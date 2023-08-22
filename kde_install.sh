#!/bin/sh

if [ "$(id -u)" -eq 0 ]; then
        echo 'This script must NOT be run by root' >&2
        exit 1
fi

sudo grub-mkconfig -o /boot/grub/grub.cfg

git clone https://aur.archlinux.org/yay-bin
cd yay-bin
makepkg -si
cd
rm -Rf yay-bin

yay --needed --noconfirm -S zramd
sudo systemctl enable zramd.service
yay --needed --noconfirm -S timeshift-bin timeshift-autosnap

#sudo timeshift --list-devices
#sudo timeshift --snapshot-device /dev[....]
sudo timeshift --create --comments "First Backup" --tags D

#read -n1 -r -p "Press any key to continue..." key

sudo grub-mkconfig -o /boot/grub/grub.cfg

#read -n1 -r -p "Press any key to continue..." key

sudo pacman -S --needed --noconfirm wayland-protocols wayland-utils plasma-desktop \
plasma-firewall konsole kscreen kinfocenter dolphin plasma-wayland-protocols yt-dlp \
plasma-workspace-wallpapers plasma-wayland-session sddm sddm-kcm oxygen oxygen-sounds \
breeze-gtk breeze-icons kde-gtk-config kvantum plasma-nm layer-shell-qt firefox kfind \
discover flatpak kdesu kpipewire kwayland mpv vlc nano-syntax-highlighting solaar \
packagekit-qt5 sof-firmware plasma-pa kdenetwork-filesharing powerdevil plasma-nm \
phonon-qt5-vlc baloo colord-kde ttf-dejavu ttf-liberation terminus-font inotify-tools \
ttf-jetbrains-mono xdg-desktop-portal-kde gparted kdeplasma-addons plasma-systemmonitor \
smartmontools gimp inkscape scribus meld bleachbit gwenview okular skanlite kate kalk \
keysmith sweeper spectacle kweather elisa k3b kjournald vivaldi vivaldi-ffmpeg-codecs \
redshift plasma-disks speech-dispatcher libertinus-font kwallet-pam bluedevil bluez-qt

#read -n1 -r -p "Press any key to continue..." key

sudo sed -i 's/Current=/Current=breeze/' /usr/lib/sddm/sddm.conf.d/default.conf
systemctl enable sddm

yay --needed --noconfirm -S fastfetch-bin pamac-aur pamac-tray-icon-plasma insync \
insync-dolphin usbimager-bin powertop-auto-tune xwaylandvideobridge-bin

#read -n1 -r -p "Press any key to continue..." key

# some apps
sudo pacman -S --needed --noconfirm libreoffice-fresh libreoffice-fresh-de glances \
coin-or-mp libreoffice-fresh-it hunspell-en_gb hunspell-en_us hunspell-de keepassxc \
hunspell-it mythes-en mythes-de mythes-it nextcloud-client obs-studio fatresize

sudo pacman -S --needed --noconfirm jfsutils reiserfsprogs libdvdcss libid3tag \
unarchiver unrar vcdimager vorbis-tools xfsprogs zip libnfs pstoedit read-edid \
udftools arj cdrtools dvd+rw-tools exfat-utils f2fs-tools flite gst-plugins-ugly

#read -n1 -r -p "Press any key to continue..." key

yay --needed --noconfirm -S \
softmaker-office-2021-bin \
vscodium-bin \
primevideo \
windscribe-v2-bin \
wps-office \
wps-office-all-dicts-win-languages \
libtiff5 \
wps-office-mime \
jellyfin-media-player

# some fonts
yay -S --needed --noconfirm \
3270-fonts \
amazon-fonts \
apple-fonts \
otf-aurelis \
otf-baskervald \
otf-berenis \
otf-electrum \
otf-fanwood \
otf-gillius \
otf-ikarius \
otf-irianis \
otf-keypad \
otf-libris \
otf-mekanus \
otf-mononoki \
otf-neogothis \
otf-oldania \
otf-ornements \
otf-romande \
otf-solothurn \
otf-tribun \
otf-universalis \
otf-yrsa \
redhat-fonts \
ttf-apple-fontpack \
ttf-asap-variable \
ttf-bangers \
ttf-barlow \
ttf-bbcreith \
ttf-breeze-sans \
ttf-cheapskate \
ttf-cm-unicode \
ttf-comfortaa \
ttf-comic-neue \
ttf-comic-relief \
ttf-comic-sans \
ttf-courier-prime \
ttf-crosextra \
ttf-dejavu-sans-code \
ttf-ecofont-sans \
ttf-exo-2 \
ttf-firge \
ttf-fluentui-system-icons \
ttf-font-awesome-4 \
ttf-font-awesome-5 \
ttf-fragment-mono \
ttf-gelasio-ib \
ttf-google-sans \
ttf-google \
ttf-hellvetica \
ttf-icomoon-feather \
ttf-intel-one-mono \
ttf-juliamono \
ttf-liberation-sans-narrow \
ttf-librebarcode \
ttf-literata-opticals \
ttf-md-fonts-git \
ttf-meslo \
ttf-ms-win11-auto \
ttf-ms-win11-auto-other \
ttf-ocr-a \
ttf-oldeenglish \
ttf-orbitron \
ttf-oswald \
ttf-quintessential \
ttf-raleway \
ttf-raleway-variable \
ttf-recursive \
ttf-roboto-slab \
ttf-roboto-serif \
ttf-roboto-flex \
ttf-roboto-slab-variable \
ttf-segoe-ui-variable \
ttf-selawik \
ttf-signika \
ttf-sourcesanspro \
ttf-spectral \
ttf-symbola \
ttf-tannenberg \
ttf-technical \
ttf-twemoji \
ttf-twilio \
ttf-unifont \
ttf-weather-icons \
ttf-wps-fonts \
ttf-xo-fonts
#otf-mintspirit \
#sgi-fonts \
#ttf-iosevka \
#ttf-iosevka-aile \
#ttf-iosevka-comfy \
#ttf-iosevka-curly \
#ttf-iosevka-curly-slab \
#ttf-iosevka-etoile \
#ttf-iosevka-fixed \
#ttf-iosevka-fixed-curly \
#ttf-iosevka-fixed-curly-slab \
#ttf-iosevka-fixed-slab \
#ttf-iosevka-ibx \
#ttf-iosevka-lyte \
#ttf-iosevka-slab \
#ttf-iosevka-term \
#ttf-iosevka-term-curly \
#ttf-iosevka-term-curly-slab \
#ttf-nanum \
#wps-office-fonts \

#read -n1 -r -p "Press any key to continue..." key

echo "installing ocenaudio, instead of audacity"
wget https://www.ocenaudio.com/downloads/ocenaudio_archlinux.pkg.tar.xz
sudo pacman --noconfirm -U ocenaudio_archlinux.pkg.tar.xz
rm ocenaudio_archlinux.pkg.tar.xz

yay --needed --noconfirm -S input-remapper-git
sudo systemctl enable input-remapper --now

# power-profiles-daemon ?

sudo systemctl enable colord.service
sudo systemctl enable firewalld.service
#sudo systemctl enable ldconfig.service
#sudo systemctl enable power-profiles-daemon.service
sudo systemctl enable systemd-hostnamed.service
#sudo systemctl enable systemd-journal-catalog-update.service
#sudo systemctl enable systemd-sysusers.service
sudo systemctl enable systemd-timesyncd.service
#sudo systemctl enable systemd-update-done.service
sudo systemctl enable smartd.service

#sudo reboot
