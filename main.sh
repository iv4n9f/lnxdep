#!/bin/bash

# Location

dir=$(pwd)
cd ~

# Network Variables

interface=$(ip -br a | grep UP | sed "s/  */ /g" | head -1 | cut -d " " -f 1)
network_ip=$(ip -br a | grep UP | sed "s/  */ /g" | head -1 | cut -d " " -f 3 | cut -d "/" -f 1)
network_mask=$(ip -br a | grep UP | sed "s/  */ /g" | head -1 | cut -d " " -f 3 | cut -d "/" -f 2)

# Other Variables

packages="libxcb xcb-util xcb-util-wm xcb-util-keysyms gdm xorg xorg-xinit polybar gnome-terminal rofi feh tmux brave open-vm-tools net-tools base-devel"

# Create System Users

useradd -m system
useradd -m user
useradd -m guest

# Create System Groups

groupadd administration
groupadd users
groupadd guests

# Assign Users

usermod -aG administration system
usermod -aG wheel system
usermod -aG users user
usermod -aG guests guest

# Install basic packages

sudo pacman -Syu
sudo pacman -S $packages --noconfirm

# Install Yay

git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si

#Install bspwm

git clone https://github.com/baskerville/bspwm.git
git clone https://github.com/baskerville/sxhkd.git
cd bspwm && make && sudo make install
cd ../sxhkd && make && sudo make install
mkdir -p ~/.config/{bspwm,sxhkd,polybar}
mkdir ~/.config/bspwm/scripts
mkdir ~/pic 
cp $dir/bspwmrc ~/.config/bspwm/
cp $dir/bspwmrc_resize ~/.config/bspwm/scripts
cp $dir/sxhkdrc ~/.config/sxhkd/
cp $dir/launch.sh ~/.config/polybar/
cp $dir/config.ini ~/.config/polybar/
cp $dir/wallpaper.jpg ~/pic/wallpaper.jpg
cp $dir/wallpaper.jpg
cp /etc/X11/xinit/xinitrc ~/.xinitrc
echo "exec bspwm" >> ~/.xinitrc
chmod u+x ~/.config/bspwm/bspwmrc
chmod +x ~/.config/polybar/launch.sh
cd ~
git clone https://github.com/lr-tech/rofi-themes-collection.git
cd rofi-themes-collection
mkdir -p ~/.local/share/rofi/themes/
cp themes/rounded-common.rasi ~/.local/share/rofi/themes/
cp themes/rounded-blue-dark.rasi ~/.local/share/rofi/themes/
cd ~
mkdir fonts
cd fonts
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Hack.tar.xz
tar -xvf Hack.tar.xz
mkdir -p ~/.local/share/fonts
cp *.ttf ~/.local/share/fonts/.
cp -r $dir/scripts ~/.config/polybar/
chmod u+x ~/.config/polybar/scripts/*
cd ~
sudo rm -r bspwm fonts rofi-themes-collection sxhkd lnxdep yay

# Deploy main directory

mkdir -p {doc,psw,tmp,dwn,log,msc,sft,rep}

# Install Snapd

yay -Y --gendb
yay -Syu
yay -Syu --devel
yay -S snapd

# Enable Services

sudo systemctl enable snapd && sudo systemctl start snapd
sudo systemctl enable gdm
sudo systemctl enable vmtoolsd.service
sudo ln -s /var/lib/snapd/snap /snap

# Install Snaps

sudo snap install --classic code
sudo ln -s /snap/bin/code /bin/code
sudo snap install bitwarden
sudo snap install discord
