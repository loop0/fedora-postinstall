#!/bin/bash -x
set -e

# Enable BBR congestion control
sudo bash -c 'echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf'
sudo bash -c 'echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf'

# Remove unused packages
sudo dnf -y remove evolution \
				   rhythmbox \
				   docker \
				   docker-client \
				   docker-client-latest \
				   docker-common \
				   docker-latest \
				   docker-latest-logrotate \
				   docker-logrotate \
				   docker-selinux \
				   docker-engine-selinux \
				   docker-engine


# VS Code
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf -y update
sudo dnf -y install dnf-plugins-core

# Google Chrome
sudo dnf -y install fedora-workstation-repositories
sudo dnf -y config-manager --set-enabled google-chrome

# Docker
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
# TODO: Remove it after docker starts supporting Fedora 30 as stable
sudo dnf config-manager --set-enabled docker-ce-test

sudo dnf -y install google-chrome-stable \
					gitg \
					python2-virtualenv \
					python3-virtualenv \
					golang \
					docker-ce \
					code \
					i3 \
					vim \
					feh \
					ImageMagick

# Configure docker
sudo systemctl enable docker
sudo sudo gpasswd -a ${USER} docker
sudo systemctl stop docker
sudo mv /var/lib/docker /home/docker
sudo ln -s /home/docker /var/lib/docker
sudo systemctl start docker
