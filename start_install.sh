echo "This script installs Arch on your computer."
read -n1 -r -p "enter any key when ready, or press ^C to abort" key
clear
read -r -p "Enter the keyboard layout (e.g. de-latin1): " key_layout
loadkeys $key_layout

read -r -p "Enter the timezone (e.g. Europe/Berlin): " timezone
timedatectl set-timezone $timezone

read -r -p "Enter the hostname (e.g. mypc): " hname
read -r -p "Enter the fully qualified hostname (e.g. mypc.local): " fqhname
read -r -p "Enter the password for the root user (e.g. toor): " rootpw
read -r -p "Enter the userid (e.g. user): " uid
read -r -p "Enter the user full name: " ufullname
read -r -p "Enter the password for the userid (e.g. secret): " upw

read -r -p "Enter the country close to you (e.g. Germany): " mirrorlist
clear
echo "Here are the current partitions on your disk(s):"
echo " "
fdisk -l
echo " "
echo " "
echo "I am finding the best mirrors for obtaining Arch. Please be patient."
reflector --country $mirrorlist --age 6 --download-timeout 3 --sort rate --save /etc/pacman.d/mirrorlist 2>/dev/null

echo "*********************************** WARNING: ***********************************"
echo " This script will ask for an existing partition that will be formatted with the"
echo " btrfs file system. If you are not ready, abort this script right now!"
echo " Moreover, it requires an UEFI-capable system (this PC needs to be booted in"
echo " UEFI mode prior running this script). Finally, we need an existing FAT / FAT32"
echo " partition to store the grub bootloader and UEFI data."
echo " "
echo " IF YOU ARE NOT READY, ABORT THE SCRIPT NOW. THIS IS YOUR ONLY WARNING!!!!"
echo " IF YOU ARE NOT READY, ABORT THE SCRIPT NOW. THIS IS YOUR ONLY WARNING!!!!"
echo " IF YOU ARE NOT READY, ABORT THE SCRIPT NOW. THIS IS YOUR ONLY WARNING!!!!"
echo " IF YOU ARE NOT READY, ABORT THE SCRIPT NOW. THIS IS YOUR ONLY WARNING!!!!"
echo " "
read -r -p "Enter the partition for the btrfs filesystem (e.g. sda5 or nvme0n1p5): " root_filesystem
read -r -p "Enter the partition for the grub bootloader (e.g. sda1 or nvme0n1p1): " boot_filesystem

mkfs.btrfs -f /dev/$root_filesystem
mount /dev/$root_filesystem /mnt
cd /mnt
btrfs subvolume create @
btrfs subvolume create @home
btrfs subvolume create @.snapshots
btrfs subvolume create @var_log
btrfs subvolume create @var_cache_pacman_pkg
btrfs subvolume create @var_lib_libvirt_images
cd
umount /mnt
mount -o noatime,ssd,space_cache=v2,compress=zstd,discard=async,subvol=@ /dev/$root_filesystem /mnt
mkdir /mnt/{home,.snapshots}
mkdir -p /mnt/var/{log,lib/libvirt/images,cache/pacman/pkg}
mount -o noatime,ssd,space_cache=v2,compress=zstd,discard=async,subvol=@home /dev/$root_filesystem /mnt/home
mount -o noatime,ssd,space_cache=v2,compress=zstd,discard=async,subvol=@.snapshots /dev/$root_filesystem /mnt/.snapshots
mount -o noatime,ssd,space_cache=v2,compress=zstd,discard=async,subvol=@var_log /dev/$root_filesystem /mnt/var/log
mount -o noatime,ssd,space_cache=v2,discard=async,subvol=@var_lib_libvirt_images /dev/$root_filesystem /mnt/var/lib/libvirt/images
mount -o noatime,ssd,space_cache=v2,compress=zstd,discard=async,subvol=@var_cache_pacman_pkg /dev/$root_filesystem /mnt/var/cache/pacman/pkg
mkdir -p /mnt/boot/efi
mount /dev/$boot_filesystem /mnt/boot/efi
mkdir /mnt/windows
mount /dev/nvme0n1p3 /mnt/windows
pacman -Sy
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 10/' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i '/Color/a ILoveCandy' /etc/pacman.conf
echo "" >> /etc/pacman.conf
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
echo "" >> /etc/pacman.conf
echo "[community]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

# determine CPU architecture
CPU=$(grep -E 'GenuineIntel|AuthenticAMD' /proc/cpuinfo | uniq | cut -d" " -f2 | grep "AuthenticAMD" && echo "amd-ucode" || echo "intel-ucode")
cpupkg=$(echo $CPU|cut -d" " -f2)
echo "I detected the CPU and I will install this package" $cpupkg

pacstrap -K /mnt base linux linux-firmware btrfs-progs vim $cpupkg
genfstab -U /mnt >> /mnt/etc/fstab
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist
cp /etc/pacman.conf /mnt/etc/pacman.conf

pacman --noconfirm -Sy wget unzip
wget https://github.com/r10513/Arch-installer/archive/refs/heads/main.zip
unzip -qq main.zip
mv Arch-installer-main/base_system.sh /mnt
mv Arch-installer-main/kde_install.sh /mnt
rm main.zip
rm -R Arch-installer-main

# adjusting next script...

sed -i "s|timezone=CET|timezone=$timezone|" /mnt/base_system.sh
sed -i "s/hname=localhost/hname=$hname/" /mnt/base_system.sh
sed -i "s/fqhname=localhost.localdomain/fqhname=$fqhname/" /mnt/base_system.sh
sed -i "s/rootpw=root/rootpw=$rootpw/" /mnt/base_system.sh
sed -i "s/uid=user/uid=$uid/" /mnt/base_system.sh
sed -i "s/ufullname=\"Ben Utzer\"/ufullname=\"$ufullname\"/" /mnt/base_system.sh
sed -i "s/upw=password/upw=$upw/" /mnt/base_system.sh

chmod a+x /mnt/base_system.sh
chmod a+x /mnt/kde_install.sh
echo " "
echo " To continue to the next install stage, enter /base_system.sh "
arch-chroot /mnt
