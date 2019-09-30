#!/bin/bash

## Removendo travas eventuais do apt ##

sudo rm /var/lib/dpkg/lock-frontend; sudo rm /var/cache/apt/archives/lock ;

## Adicionando/Confirmando arquitetura de 32 bits ##

sudo dpkg --add-architecture i386 

## Atualizando o repositório ##

sudo apt update

## Adicionando repositórios de terceiros e suporte a Snap (Driver Logitech, Lutris e Drivers Nvidia)##

sudo apt-add-repository ppa:libratbag-piper/piper-libratbag-git -y

sudo add-apt-repository ppa:lutris-team/lutris -y

sudo apt-add-repository ppa:graphics-drivers/ppa -y

sudo apt install snapd -y

wget -nc https://dl.winehq.org/wine-builds/winehq.key 

sudo apt-key add winehq.key -y

sudo apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'

## Atualizando o repositório depois da adição de novos repositórios ##

sudo apt update

## Download e instalaçao de programas externos ##

mkdir /home/$USER/Downloads/programas

cd /home/$USER/Downloads/programas

wget -c https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

wget -c https://github.com/Automattic/simplenote-electron/releases/download/v1.8.0/Simplenote-linux-1.8.0-amd64.deb

wget -c https://dl.4kdownload.com/app/4kvideodownloader_4.9.2-1_amd64.deb

wget -c https://d2t3ff60b2tol4.cloudfront.net/builds/insync_3.0.20.40428-bionic_amd64.deb

## Instalando pacotes .deb baixados na sessão anterior ##

sudo dpkg -i *.deb

## Programas do repositório APT##

sudo apt install mint-meta-codecs -y

sudo apt install winff -y

sudo apt install guvcview -y

sudo apt install virtualbox -y

sudo apt install flameshot -y

sudo apt install nemo-dropbox -y

sudo apt install steam-installer steam-devices steam:i386 -y

sudo apt install ratbagd -y

sudo apt install piper -y

sudo apt install lutris libvulkan1 libvulkan1:i386 -y

sudo apt-get install --install-recommends winehq-stable wine-stable wine-stable-i386 wine-stable-amd64 -y

sudo apt-get install libgnutls30:i386 libldap-2.4-2:i386 libgpg-error0:i386 libxml2:i386 libasound2-plugins:i386 libsdl2-2.0-0:i386 libfreetype6:i386 libdbus-1-3:i386 libsqlite3-0:i386 -y

##Instalando pacotes Flatpak ##

flatpak install flathub com.obsproject.Studio -y

## Instalando pacotes Snap ##

sudo snap install spotify

sudo snap install slack --classic

sudo snap install skype --classic

sudo snap install photogimp

## Finalização, atualização e limpeza##


sudo apt update && sudo apt dist-upgrade -y

flatpak update

sudo apt autoclean 

sudo apt autoremove -y

echo "Chegamos ao final"









