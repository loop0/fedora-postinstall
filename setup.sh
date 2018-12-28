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

# Install Microsoft keys
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc

# Install extra repos, update and install needed packages
pushd /etc/yum.repos.d
sudo wget https://raw.githubusercontent.com/loop0/fedora-postinstall/master/google-chrome.repo
sudo wget https://raw.githubusercontent.com/loop0/fedora-postinstall/master/vscode.repo
popd

sudo dnf -y update
sudo dnf -y install dnf-plugins-core

# Add docker-ce repository
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
# TODO: Remove it after docker starts supporting Fedora 29 as stable
sudo dnf config-manager --set-enabled docker-ce-test

sudo dnf -y install google-chrome \
					gitg \
					python2-virtualenv \
					python3-virtualenv \
					golang \
					docker-ce \
					code

# Setup docker
sudo systemctl enable docker
sudo groupadd docker && sudo gpasswd -a ${USER} docker && sudo systemctl restart docker
sudo mv /var/lib/docker /home/docker
sudo ln -s /home/docker /var/lib/docker
sudo systemctl start docker
