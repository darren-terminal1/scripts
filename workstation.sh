!/bin/bash

# Ensure repositories are up to date and updates are installed
# Add nordvpn, chrome and virtualbox repositories and remove firefox prior to apt update
sudo wget https://repo.nordvpn.com/gpg/nordvpn_public.asc -O - | sudo apt-key add -
sudo wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -

sudo sh -c 'echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" >> /etc/apt/sources.list.d/nordvpn.list'
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
sudo sh -c 'echo "deb [arch=amd64] https://download.virtualbox.org/virtualbox/debian bionic contrib" >> /etc/apt/sources.list.d/virtualbox.list'
sudo add-apt-repository ppa:agornostal/ulauncher -y

sudo apt update
sudo apt remove -y firefox
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt upgrade -y

# Copy scripts and files to home drive
cd ~/
mkdir ~/Downloads
sudo mkdir /scripts
cp /media/${USER}/UTILS/* ~/Downloads
sudo cp /media/${USER}/UTILS/scripts/* /scripts
sudo cp /media/${USER}/UTILS/Home/* ~/Pictures
sudo cp ~/Downloads/motd-thinkcentre /etc/motd
sudo gpasswd --add ${USER} dialout
sudo chown -R ${USER} *

# Install core applications
# COMMON:
sudo apt install -y neofetch zsh git cdrecord figlet unrar zip unzip p7zip-full p7zip-rar rar bzip2 wget samba apt-show-versions openssh-server regionset apt-transport-https nordvpn curl htop

# WORKSTATION:
# Libraries
sudo apt install -y libapt-pkg-perl libavahi-compat-libdnssd1 libqt5core5a libqt5gui5 libqt5network5 libqt5widgets5 libavahi-compat-libdnssd1 libjpeg62 beignet-opencl-icd libopenal1 libopenal-data libopenal-dev python3-launchpadli
# Applications
sudo apt install -y gufw openjdk-11-jdk flatpak gnome-software-plugin-flatpak setserial gtkterm google-chrome-stable chrome-gnome-shell virtualbox virtualbox-ext-pack virtualbox-guest-additions-iso python3-venv python3-pip steam-installer
# Extras
sudo apt install -y ubuntu-restricted-extras ulauncher gnome-shell-extensions gnome-shell-extension-caffeine gnome-shell-extension-show-ip gnome-shell-extension-weather gnome-software-plugin-flatpak ccextractor
# Flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Enable and configure the firewall
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow samba
sudo ufw allow from any to any port 1194 proto udp
sudo ufw reload

# Install synergy
cd ~/Downloads
sudo dpkg -i synergy.deb

# Install generic applications via Flathub
flatpak install -y flathub io.atom.Atom
flatpak install -y flathub com.slack.Slack
flatpak install -y flathub com.makemkv.MakeMKV
flatpak install -y flathub org.freedesktop.Platform.ffmpeg

# Install development applications via Flathub
flatpak install -y flathub com.jetbrains.PyCharm-Community
flatpak install -y flathub com.jetbrains.DataGrip
flatpak install -y flathub com.getpostman.Postman

# Install applications via snap that are not availabile on Flathub
snap install 1password-linux
snap install indicator-sensors
snap install ubuntu-release-info
snap install bashtop

# Connect bashtop to services
sudo snap connect bashtop:mount-observe
sudo snap connect bashtop:network-control
sudo snap connect bashtop:hardware-observe
sudo snap connect bashtop:system-observe
sudo snap connect bashtop:process-control

# Cleanup the system a bit before finishing
sudo apt autoremove -y
sudo apt autoclean -y

# Install ZSH and configure as default shell
sudo chsh -s /bin/zsh darren
sudo chsh -s /bin/zsh root

# Install Oh-My-Zsh
cd ~/Downloads
sudo sh -c "$(wget -O- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
