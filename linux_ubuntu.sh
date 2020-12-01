#!/usr/bin/env bash
# ----------------------------- VARIABLES ----------------------------- #
TEMP_PROGRAMS_DIRECTORY="$HOME/temp_programs" # temporary folder to save .deb files
UBUNTU_VERSION=$(lsb_release -c | grep -oE "[^:]*$") # get version codename: focal, eoan...

# .deb list
URL_DEB_FILES=(
  https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  https://dl.strem.io/linux/v4.4.106/stremio_4.4.106-1_amd64.deb
  http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/9505/wps-office_11.1.0.9505.XA_amd64.deb
)

# ppa list
PPA_ADDRESSES=(
  ppa:graphics-drivers/ppa
  ppa:kdenlive/kdenlive-stable
  ppa:peek-developers/stable
  ppa:fossfreedom/indicator-sysmonitor
)

# apt list
PROGRAMS_VIA_APT=(
  apt-transport-https
  build-essential
  ca-certificates
  ca-certificates-java
  ffmpeg
  ffmpegthumbnailer
  fonts-liberation 
  java-common
  nodejs 
  nodejs-doc 
  openjdk-8-jre-headless 
  phantomjs 
  python3-pyxattr
  rtmpdump 
  qml-module-qt-labs-platform
  qml-module-qtgraphicaleffects 
  qml-module-qtquick-controls 
  qml-module-qtquick-dialogs
  qml-module-qtquick-layouts 
  qml-module-qtquick-privatewidgets 
  qml-module-qtquick-window2 
  qml-module-qtquick2
  qml-module-qtwebchannel 
  qml-module-qtwebengine 
  libasound2-plugins:i386
  libdbus-1-3:i386
  libfreetype6:i386
  libgnutls30:i386
  libgpg-error0:i386
  libldap-2.4-2:i386
  libsdl2-2.0-0:i386
  libsqlite3-0:i386
  libvulkan1
  libvulkan1:i386
  libxml2:i386
  libavdevice57 
  libc-ares2 
  libdc1394-22
  libevent-2.1-6 
  libminizip1 
  libmpv1 
  libopenal-data 
  libopenal1 
  libqt5positioning5 
  libqt5printsupport5
  libqt5qml5 
  libqt5quick5 
  libqt5sensors5 
  libqt5webchannel5 
  libqt5webengine-data 
  libqt5webengine5
  libqt5webenginecore5 
  libqt5webkit5 
  libre2-4 
  libsdl2-2.0-0 
  libsndio6.1 
  libuchardet0 
  libuv1 
  libva-wayland2
  gparted
  gnome-tweak-tool
  openvpn
  network-manager-openvpn
  network-manager-openvpn-gnome
  meld
  peek
  brave-browser
  virtualbox
  wine
  flameshot
  git
  gnupg-agent
  indicator-sysmonitor
  kolourpaint
  kdenlive
  youtube-dl
  mpv
  docker-ce 
  docker-ce-cli 
  containerd.io
)

# snap list
PROGRAMS_VIA_SNAP=(
  "code --classic"
  "insomnia"
  "intellij-idea-community --classic"
  "skype --classic"
  "spotify"
  "postman"
  "photogimp"
  "telegram-desktop"
  "vlc"
)
# ---------------------------------------------------------------------- #

# ----------------------------- PRE INSTALL STEP ----------------------------- #
echo "==== Removendo travas eventuais do apt ===="
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

echo "==== Adicionando/Confirmando arquitetura de 32 bits ====" 
sudo dpkg --add-architecture i386

echo "==== Atualizando o repositório ===="
sudo apt update -y

echo "==== Adicionando repositórios PPA ===="
sudo apt install software-properties-common -y
for ppa_address in ${PPA_ADDRESSES[@]}; do
    sudo add-apt-repository "$ppa_address" -y
done

echo "==== Configura repositório brave-browser ===="
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
wget --quiet -O - https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

echo "==== Configura repositório docker e docker-compose ===="
sudo apt-get remove docker docker-engine docker.io containerd runc -y
echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $UBUNTU_VERSION stable" | sudo tee /etc/apt/sources.list.d/docker-release.list
wget --quiet -O - https://download.docker.com/linux/ubuntu/gpg | sudo apt-key --keyring /etc/apt/trusted.gpg.d/docker-release.gpg add -
sudo wget -c "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -P /usr/local/bin/
sudo mv /usr/local/bin/docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# ------------------------------------------------------------------------ #

# ----------------------------- INSTALL STEP ----------------------------- #
echo "==== Atualizando o APT depois da adição de novos repositórios ===="
sudo apt update -y

echo "==== Instalando programas no APT ===="
for apt_program in ${PROGRAMS_VIA_APT[@]}; do
  echo "[INSTALANDO VIA APT] - $apt_program"
  sudo apt install "$apt_program" -y
done

echo "==== Download de programas .deb ===="
mkdir "$TEMP_PROGRAMS_DIRECTORY"
for url in ${URL_DEB_FILES[@]}; do
  wget -c "$url" -P "$TEMP_PROGRAMS_DIRECTORY"
done

echo "==== Instalando pacotes .deb baixados ===="
sudo dpkg -i $TEMP_PROGRAMS_DIRECTORY/*.deb
sudo apt --fix-broken install -y
# caso haja erro na primeira vez por conta de pacotes dependentes, ele roda novamente o comando
sudo dpkg -i $TEMP_PROGRAMS_DIRECTORY/*.deb

echo "==== Instalando pacotes Snap ===="
sudo apt install snapd -y
for snap_program in "${PROGRAMS_VIA_SNAP[@]}"; do
  echo "[INSTALANDO VIA SNAP] - $snap_program"
  sudo snap install $snap_program
done

echo "==== Configura docker para funcionar sem sudo ===="
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker

echo "==== Criando atalho para um arquivo em branco ===="
mkdir $HOME/Templates
touch $HOME/Templates/"blank file"
# ---------------------------------------------------------------------- #

# ----------------------------- CLEANING ------------------------------- #
echo "==== Finalização, atualização e limpeza ===="
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean
sudo apt autoremove -y
sudo rm -rf $TEMP_PROGRAMS_DIRECTORY
# ---------------------------------------------------------------------- #

# ----------------------------- FINISH --------------------------------- #
echo "==== PARA O DOCKER FUNCIONAR SEM O SUDO BASTA REINICIAR ===="
echo "==== BIRL! PRONTO PRA DERRUBAR AS ÁRVORES DO IBIRAPUERA. ===="

read -p "REINICIAR AGORA? [s/n]: " opcao
if [ "$opcao" == "s" ] || [ "$opcao" == "S" ]; then
  sudo reboot
fi

exit 0