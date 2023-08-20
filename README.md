# Arch-installer
My personal script to install Arch

# Instructions

1. Download archlinux-2023.08.01-x86_64.iso or a newer version
2. Burn it to a CD/DVD or create a USB bootable device with it
3. Boot your computer with that image
4. Download from this repo start_install.sh and make it executable
5. Run start_install.sh

# ATTENTION!!

This script has been tested on computers having either an AMD or an Intel CPU

This script does not create partitions. You need to have already a partition
with enough space. That partition will be formatted with btrfs filesystem.

The choice of apps and packages is _my_ choice. You can change and adjust as needed.

I consciously decided not to encrypt root fileystem.
For network, it is configured via DHCP (and only with IP4 connectivity)

It is mandatory to have a fat / fat32 partition for grub.
In case of dual boot systems (windows / linux) I normally place grub in the EFI partition

The script works also under QEMU (or proxmox).

I decided not to make checks on input. So, if you answer a question with a silly answer,
or if you don't provide a needed value, the script may fail.

# IMPORTANT (and to do)

Your PC must be booted in UEFI mode, otherwise this script won't work.
Here a quick way to determine if your PC is in UEFI boot mode:
https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface
or, more quickly, check if the directory /sys/firmware/efi/ exists.
In future I might add a check at beginning of start_install.sh

This script is a hack! Check it carefully before running on your PC.
I am not responsible for any data loss. Run at your own risk!

# Final notes

Do whatever you want with this script. If you improve it, please let me know!
