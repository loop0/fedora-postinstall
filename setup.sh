#!/bin/bash -x
set -e

# Enable BBR congestion control
sudo bash -c 'echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf'
sudo bash -c 'echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf'

# Disable abrt stuff
sudo systemctl stop abrt*
sudo systemctl disable abrt-ccpp.service 
sudo systemctl disable abrtd.service 
sudo systemctl disable abrt-oops.service 
sudo systemctl disable abrt-vmcore.service 
sudo systemctl disable abrt-xorg.service 

# Remove unused packages
sudo dnf -y remove firefox evolution rhythmbox

# Install extra repos, update and install needed packages
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
pushd /etc/yum.repos.d
sudo wget https://raw.githubusercontent.com/loop0/fedora-postinstall/master/google-chrome.repo
sudo wget https://raw.githubusercontent.com/loop0/fedora-postinstall/master/fedora-spotify.repo
popd

sudo dnf -y update
sudo dnf -y install google-chrome vim gitg spotify-client python2-virtualenv docker

# Setup docker
sudo systemctl enable docker
sudo groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker
newgrp docker
sudo systemctl start docker

# Install necessary udev rules for Fido U2F
pushd /etc/udev/rules.d
sudo wget https://raw.githubusercontent.com/Yubico/libu2f-host/master/70-u2f.rules
sudo udevadm control --reload-rules
sudo udevadm trigger
popd
