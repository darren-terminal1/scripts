#!/bin/bash

# Ensure repositories are up to date and updates are installed
# Add nordvpn and chrome repositories and remove firefox prior to apt update
sudo wget https://repo.nordvpn.com/gpg/nordvpn_public.asc -O - | sudo apt-key add -
sudo wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" >> /etc/apt/sources.list.d/nordvpn.list'
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo apt remove -y firefox
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

# WORKSTATION:
sudo apt install -y gufw terminator libapt-pkg-perl libavahi-compat-libdnssd1 libqt5core5a libqt5gui5 libqt5network5 libqt5widgets5 libavahi-compat-libdnssd1 ubuntu-restricted-extras openjdk-11-jdk flatpak gnome-software-plugin-flatpak setserial gtkterm libjpeg62 nuitka python-pip libqt4-opengl beignet google-chrome-stable chrome-gnome-shell

sudo cp ~/Downloads/motd-thinkcentre /etc/motd

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enable and configure the firewall
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow samba
sudo ufw reload

# Install synergy
cd ~/Downloads
sudo dpkg -i synergy.deb

flatpak install -y flathub io.atom.Atom
flatpak install -y flathub com.slack.Slack
flatpak install -y flathub com.jetbrains.PyCharm-Community
flatpak install -y flathub com.makemkv.MakeMKV
flatpak install -y flathub com.dropbox.Client

sudo snap install ffmpeg
sudo snap install github-desktop --beta --classic

# Cleanup the system a bit before finishing
sudo apt autoremove -y
sudo apt autoclean -y

# Install ZSH and configure as default shell
sudo chsh -s /bin/zsh darren
sudo chsh -s /bin/zsh root

# Install Oh-My-Zsh
cd ~/Downloads
sudo sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
