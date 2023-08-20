#### BEGIN ####

timezone=CET
hname=localhost
fqhname=localhost.localdomain
rootpw=root
uid=user
ufullname="Ben Utzer"
upw=password

ln -sf /usr/share/zoneinfo/$timezone /etc/localtime
hwclock --systohc
sed -i 's/#de_DE.UTF-8 UTF-8/de_DE.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de" > /etc/vconsole.conf
echo "XKBLAYOUT=de" >> /etc/vconsole.conf
echo "XKBMODEL=pc105" >> /etc/vconsole.conf
echo "XKBOPTIONS=terminate:ctrl_alt_bksp" >> /etc/vconsole.conf
echo $hname >> /etc/hostname

# set local host address
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $fqhname $hname" >> /etc/hosts

echo root:$rootpw | chpasswd

# install packages for booting
pacman --noconfirm --needed -S grub grub-btrfs efibootmgr

# install packages for network
pacman --noconfirm --needed -S networkmanager \
network-manager-applet wpa_supplicant

# install DOS filesystem utilities & disk tools
pacman --noconfirm --needed -S mtools dosfstools os-prober

# install shell dialog box, arch mirrorlist
pacman --noconfirm --needed -S dialog reflector

# install linux system group packages
pacman --noconfirm --needed -S base-devel linux-headers

# install user directories & command line tools
pacman --noconfirm --needed -S xdg-user-dirs xdg-utils

# install bluetooth protocol stack packages
pacman --noconfirm --needed -S bluez bluez-utils

# install sound system packages
pacman --noconfirm --needed -S alsa-utils pipewire pipewire-alsa \
pipewire-pulse pipewire-jack pavucontrol extra/pipewire-session-manager

# install SSH protocol support & sync packages
pacman --noconfirm --needed -S openssh rsync

# install support for  battery, power, and thermals
pacman --noconfirm --needed -S acpi acpi_call tlp acpid

# install support for Virtual machines & emulators
#pacman --noconfirm --needed -S virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2

# install firewall support
pacman --noconfirm --needed -S firewalld

# install other packages
pacman --noconfirm --needed -S cups bash-completion ntfs-3g mc htop core/man \
git nano wget curl lsof atop iotop unzip haveged putty gvfs

# install additional fonts
pacman --noconfirm --needed -S ttf-cormorant ttf-crimson ttf-crimson-pro \
gentium-plus-font inter-font xorg-mkfontscale ttf-ubuntu-font-family \
ttf-bitstream-vera ttf-caladea ttf-carlito ttf-cascadia-code \
ttf-croscore ttf-droid ttf-fira-code ttf-fira-mono ttf-fira-sans \
ttf-ibm-plex ttf-inconsolata ttf-opensans ttf-roboto ttf-roboto-mono \
ttf-crimson-pro-variable ttf-eurof ttf-fantasque-sans-mono \
ttf-input ttf-ionicons ttf-joypixels ttf-junicode ttf-font-awesome \
ttf-linux-libertine-g ttf-monofur ttf-monoid ttf-overpass ttf-proggy-clean \
gnu-free-fonts adobe-source-sans-fonts adobe-source-serif-fonts

grub-install --target=x86_64-efi --efi-directory=/boot/efi/ --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
sed -i 's/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub

# install cute grub theme
wget https://github.com/r10513/EndeavourOS-Blue-GRUB-Theme/archive/refs/heads/main.zip
unzip -qq main.zip -d /boot/grub/themes
mv /boot/grub/themes/EndeavourOS-Blue-GRUB-Theme-main/EndeavourOS /boot/grub/themes/EndeavourOS-Blue
rm main.zip
rm -R /boot/grub/themes/EndeavourOS-Blue-GRUB-Theme-main
echo "" >> /etc/default/grub
echo "GRUB_THEME=\"/boot/grub/themes/EndeavourOS-Blue/theme.txt\"" >> /etc/default/grub

# read -n1 -r -p "Press any key to continue..." key

grub-mkconfig -o /boot/grub/grub.cfg

# read -n1 -r -p "Press any key to continue..." key

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable acpid
systemctl enable avahi-daemon
#systemctl enable libvirtd
systemctl enable firewalld
systemctl enable haveged.service
systemctl enable gpm

# read -n1 -r -p "Press any key to continue..." key

useradd -m $uid
echo $uid:$upw | chpasswd
sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers

usermod -c "$ufullname" $uid
usermod -aG rfkill,sys,wheel $uid
#usermod -aG libvirt $uid

sed -i 's/MODULES=()/MODULES=(btrfs)/' /etc/mkinitcpio.conf
sed -i 's/BINARIES=()/BINARIES=(\/usr\/bin\/btrfs)/' /etc/mkinitcpio.conf
mkinitcpio -p linux

# set environment variables to use Wayland
echo "QT_QPA_PLATFORM=wayland" >> /etc/environment
echo "QT_QPA_PLATFORMTHEME=qt5ct" >> /etc/environment
echo "MOZ_ENABLE_WAYLAND=1" >> /etc/environment
echo "MOZ_WEBRENDER=1" >> /etc/environment
echo "XDG_SESSION_TYPE=wayland" >> /etc/environment
echo "XDG_CURRENT_DESKTOP=KDE" >> /etc/environment

mkdir -p /home/$uid/.config
chown $uid:$uid /home/$uid/.config

echo "[Formats]" > /home/$uid/.config/plasma-localerc
echo "LANG=en_US.UTF-8" >> /home/$uid/.config/plasma-localerc
echo "LC_ADDRESS=de_DE.UTF-8" >> /home/$uid/.config/plasma-localerc
echo "LC_MEASUREMENT=de_DE.UTF-8" >> /home/$uid/.config/plasma-localerc
echo "LC_MONETARY=de_DE.UTF-8" >> /home/$uid/.config/plasma-localerc
echo "LC_NAME=de_DE.UTF-8" >> /home/$uid/.config/plasma-localerc
echo "LC_NUMERIC=de_DE.UTF-8" >> /home/$uid/.config/plasma-localerc
echo "LC_PAPER=de_DE.UTF-8" >> /home/$uid/.config/plasma-localerc
echo "LC_TELEPHONE=de_DE.UTF-8" >> /home/$uid/.config/plasma-localerc
echo "LC_TIME=en_GB.UTF-8" >> /home/$uid/.config/plasma-localerc

# set up powertop service
echo "[Unit]" > /etc/systemd/system/powertop.service
echo "Description=Powertop tunings" >> /etc/systemd/system/powertop.service
echo "" >> /etc/systemd/system/powertop.service
echo "[Service]" >> /etc/systemd/system/powertop.service
echo "Type=oneshot" >> /etc/systemd/system/powertop.service
echo "RemainAfterExit=yes" >> /etc/systemd/system/powertop.service
echo "ExecStart=/usr/bin/powertop --auto-tune" >> /etc/systemd/system/powertop.service
echo "" >> /etc/systemd/system/powertop.service
echo "[Install]" >> /etc/systemd/system/powertop.service
echo "WantedBy=multi-user.target" >> /etc/systemd/system/powertop.service
#systemctl enable powertop --now

echo "========================"
echo "now type exit"
echo "then type umount -R /mnt"
echo " "
echo "finally reboot the system with reboot command"
echo " "
echo "*AFTER* the reboot you can (optionally) install a DE such as KDE. To do so, enter"
echo "/kde_system.sh"
echo " "
echo "========================"
echo " do not forget to eject (or unmount) the iso file to boot into the new installed system!"
echo "========================"

exit
