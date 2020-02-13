#!/bin/bash

# Ensure repositories are up to date and updates are installed
# Add repositories for nordvpn, postgresql and webmin prior to apt update
cd ~/Downloads
sudo wget https://repo.nordvpn.com/gpg/nordvpn_public.asc -O - | sudo apt-key add -
sudo sh -c 'echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" >> /etc/apt/sources.list.d/nordvpn.list'

wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" | sudo tee /etc/apt/sources.list.d/postgresql.list'

sudo wget http://www.webmin.com/jcameron-key.asc
sudo apt-key add jcameron-key.asc
sudo sh -c "echo 'deb http://download.webmin.com/download/repository sarge contrib' >> /etc/apt/sources.list.d/webmin.list"

sudo apt update
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt upgrade -y

# Copy scripts and files to home drive
mkdir ~/Downloads
sudo mkdir /scripts
cp /media/darren/UTILS/* ~/Downloads
sudo cp /media/darren/UTILS/scripts/* /scripts
sudo gpasswd --add ${USER} dialout

# Install core applications
# COMMON:
sudo apt install -y neofetch zsh git cdrecord figlet unrar zip unzip p7zip-full p7zip-rar rar bzip2 wget samba apt-show-versions openssh-server regionset apt-transport-https nordvpn

# SERVER:
sudo apt install -y apache2 certbot mon smartmontools libapt-pkg-perl libio-pty-perl python3-certbot-apache ntpdate sntp cups libauthen-libwrap-perl libdbd-pg-perl libdbi-perl

sudo cp ~/Downloads/motd-media1 /etc/motd

# Enable and configure the firewall
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 10000/tcp
sudo ufw allow 10000/udp
sudo ufw allow 24800/tcp
sudo ufw allow 24800/udp
sudo ufw allow 5432/tcp
sudo ufw allow 5432/udp
sudo ufw allow ssh
sudo ufw allow samba
sudo ufw allow from any to any port 1194 proto udp
sudo ufw reload

# Configure apache2
sudo sh -c "echo 'ServerName media1' >> /etc/apache2/apache2.conf"
sudo apache2ctl configtest
sudo systemctl restart apache2
sudo ufw allow in "Apache Full"

# Install & configure Postgresql
sudo apt update
sudo apt install -y postgresql-12

# Edit two configuration files
sudo nano /etc/postgresql/12/main/pg_hba.conf
sudo nano /etc/postgresql/12/main/postgresql.conf

# Install bacula
sudo apt install -y bacula

# Install webmin
sudo apt install -y webmin

# Configure webmin
sudo cp ~/Downloads/media1.conf /etc/apache2/sites-available/media1.conf
sudo sh -c "echo 'refers=media1' >> /etc/webmin/config"
sudo nano /etc/webmin/miniserv.conf
sudo systemctl restart webmin
sudo a2enmod proxy_http
sudo a2ensite media1
sudo systemctl restart apache2
sudo certbot --apache --email darren.williams1973@icloud.com -d media1.cable.virginmedia.net --agree-tos --redirect --noninteractive

# Cleanup the system a bit before finishing
sudo apt autoremove -y
sudo apt autoclean -y

# Install ZSH and configure as default shell
sudo chsh -s /bin/zsh darren
sudo chsh -s /bin/zsh root

# Install Oh-My-Zsh
cd ~/Downloads
sudo sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
