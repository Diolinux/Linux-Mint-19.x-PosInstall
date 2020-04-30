#!/usr/bin/env bash
# ----------------------------- VARIÁVEIS ----------------------------- #
TEMP_PROGRAMS_DIRECTORY="$HOME/temp_programs"

URL_DEB_FILES=(
  https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
  https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  https://dl.strem.io/linux/v4.4.106/stremio_4.4.106-1_amd64.deb
  http://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/9505/wps-office_11.1.0.9505.XA_amd64.deb
)

PPA_ADDRESSES=(
  ppa:gezakovacs/ppa
  ppa:graphics-drivers/ppa
  ppa:kdenlive/kdenlive-stable
  ppa:peek-developers/stable
)

PROGRAMS_VIA_APT=(
  apt-transport-https
  brave-browser
  build-essential
  docker
  ffmpeg
  flameshot
  git
  insomnia
  kdenlive
  kolourpaint
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
  meld
  peek
  unetbootin
  virtualbox
  wine
)

PROGRAMS_VIA_SNAP=(
  code --classic
  intellij-idea-community --classic
  skype --classic
  spotify
  postman
  photogimp
  vlc
)
# ---------------------------------------------------------------------- #

# ----------------------------- REQUISITOS ----------------------------- #
echo "==== Removendo travas eventuais do apt ===="
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/cache/apt/archives/lock

echo "==== Adicionando/Confirmando arquitetura de 32 bits ====" 
sudo dpkg --add-architecture i386

echo "==== Atualizando o repositório ===="
sudo apt update -y

echo "==== Adicionando repositórios PPA ===="
for ppa_address in ${PPA_ADDRESSES[@]}; do
    sudo add-apt-repository "$ppa_address" -y
done

echo "==== Configura o repositório .deb ===="
echo "deb https://dl.bintray.com/getinsomnia/Insomnia /" | sudo tee -a /etc/apt/sources.list.d/insomnia.list
wget --quiet -O - https://insomnia.rest/keys/debian-public.key.asc | sudo apt-key add -

echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
wget --quiet -O - https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

# ---------------------------------------------------------------------- #

# ----------------------------- EXECUÇÃO ----------------------------- #
echo "==== Atualizando o APT depois da adição de novos repositórios ===="
sudo apt update -y

echo "==== Download de programas .deb ===="
mkdir "$TEMP_PROGRAMS_DIRECTORY"
for url in ${URL_DEB_FILES[@]}; do
    wget -c "$url" -P "$TEMP_PROGRAMS_DIRECTORY"
done

echo "==== Instalando pacotes .deb baixados ===="
sudo dpkg -i $TEMP_PROGRAMS_DIRECTORY/*.deb

echo "==== Instalando programas no APT ===="
for apt_program in ${PROGRAMS_VIA_APT[@]}; do
  if ! dpkg -l | grep -q $apt_program; then # Só instala se já não estiver instalado
    sudo apt install "$apt_program" -y
  else
    echo "[INSTALADO] - $apt_program"
  fi
done

echo "==== Configura docker && docker-compose ===="
sudo groupadd docker
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo wget -c "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -P /usr/local/bin/
sudo mv /usr/local/bin/docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "==== Instalando pacotes Snap ===="
for snap_program in ${PROGRAMS_VIA_SNAP[@]}; do
    sudo snap install "$snap_program"
done
# ---------------------------------------------------------------------- #

# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
echo "==== Finalização, atualização e limpeza ===="
sudo apt update && sudo apt dist-upgrade -y
sudo apt autoclean
sudo apt autoremove -y
rm -rf $TEMP_PROGRAMS_DIRECTORY
# ---------------------------------------------------------------------- #

# Fim do Script #
echo "==== BIRL! PRONTO PRA DERRUBAR AS ÁRVORES DO IBIRAPUERA. ===="
