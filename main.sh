#!/bin/bash

# Check user

user=$(whoami)

if [[ $user == "root" ]]; then
    exit
fi

# Location

dir=$(pwd)
cd ~

# Network Variables

interface=$(ip -br a | grep UP | sed "s/  */ /g" | head -1 | cut -d " " -f 1)
network_ip=$(ip -br a | grep UP | sed "s/  */ /g" | head -1 | cut -d " " -f 3 | cut -d "/" -f 1)
network_mask=$(ip -br a | grep UP | sed "s/  */ /g" | head -1 | cut -d " " -f 3 | cut -d "/" -f 2)

# Other Variables

# Create System Users

sudo useradd -m system
sudo useradd -m user
sudo useradd -m guest

# Create System Groups

sudo groupadd system_admins
sudo groupadd system_users
sudo groupadd system_guests

# Assign Users

sudo usermod -aG system_admins system
sudo usermod -aG wheel system
sudo usermod -aG system_users user
sudo usermod -aG system_guests guest

# Install basic packages

sudo pacman -Syu
sudo pacman -S libxcb xcb-util xcb-util-wm xcb-util-keysyms gdm xorg xorg-xinit polybar gnome-terminal rofi feh tmux brave open-vm-tools net-tools base-devel --noconfirm

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

# Install packages from yay

yay -Y --gendb
yay -Syu
yay -Syu --devel
yay -S snapd
yay -S bitwarden

# Enable Services

sudo systemctl enable snapd && sudo systemctl start snapd
sudo systemctl enable gdm
sudo systemctl enable vmtoolsd.service
sudo ln -s /var/lib/snapd/snap /snap

# Install Snaps

sudo snap install --classic code
sudo ln -s /snap/bin/code /bin/code
sudo snap install discord
