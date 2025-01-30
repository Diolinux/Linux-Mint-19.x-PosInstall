#!/usr/bin/env bash


########################## SCRIPT CONFIGURAÇÃO DEBIAN 12 #############################
# 									                                    
# debian_posinstall_diolinux.sh -            			            
#									                                                            	
# Data Criação: 30/11/2024      		
#									                                    
# Descrição: instalar os programas e softwares necessários para meu uso no Debian 12                	                              
#	                                                                										                                    #
# Exemplo de uso: sudo chmod +x debian_posinstall_diolinux.sh	&& sudo ./debian_posinstall_diolinux.sh         		
#							                                    
######################################################################################

clear

# -------------------------------------------------------------------------------------------------

# Verificar se os programas estão instalados:

which dpkg     1> /dev/null || exit 1
which apt      1> /dev/null || exit 2
which apt-key  1> /dev/null || exit 3

# -------------------------------------------------------------------------------------------------



# ----------------------------- VARIÁVEIS ----------------------------- #

GPG_PHP="https://packages.sury.org/php/apt.gpg"
GPG_DOCKER="https://download.docker.com/linux/debian/gpg"

PROGRAMAS_PARA_INSTALAR=(
  apt-transport-https
  aptitude
  build-essential
  ca-certificates
  fish
  gnupg2
  git
  htop
  iproute2
  iptables
  iptables-persistent
  lsof
  lsb-release
  neofetch
  net-tools
  nginx
  nmap
  ncdu
  openssh-server
  p7zip
  p7zip-full
  python3
  python3-pip
  rar
  rsync
  strace
  sysstat
  tar
  traceroute
  tree
  unzip
  vim
  wget
  zip
)

PHP_INSTALAR=(
  php8.3 
  php8.3-curl 
  php8.3-gd 
  php8.3-intl 
  php8.3-mbstring 
  php8.3-mysqli
  php8.3-pdo
  php8.3-zip
  php8.3-xml
  php8.3-dom
  php8.3-bcmath 
  php8.3-xdebug
  php8.3-opcache
)

DOCKER_INSTALAR=(
  docker-ce 
  docker-ce-cli 
  containerd.io 
  docker-buildx-plugin 
  docker-compose-plugin
)

# ----------------------------- REQUISITOS ----------------------------- #

## Removendo travas eventuais do apt ##
rm /var/lib/dpkg/lock-frontend
rm /var/cache/apt/archives/lock

## Adicionando/Confirmando arquitetura de 32 bits ##
dpkg --add-architecture i386

## Atualizando o repositório ##
apt update -y

## Instalando o curl ##
apt install curl -y

# ----------------------------- EXECUÇÃO ----------------------------- #

## Atualizando o repositório depois da adição de novos repositórios ##
apt update -y

# Instalar programas no apt
for nome_do_programa in ${PROGRAMAS_PARA_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

# ---------------------------------------------------------------------- #

## Adicionando repositório para o PHP, Docker e DDEV##
# -------PHP-------
echo -e "\033[01;32mPHP\033[0m"
wget -O /etc/apt/trusted.gpg.d/php.gpg "$GPG_PHP"
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
# -------/PHP------

# -------Docker----
echo -e "\033[01;32mDocker\033[0m"
install -m 0755 -d /etc/apt/keyrings
curl -fsSL "$GPG_DOCKER" -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
# -------Docker----

# ---------------------------------------------------------------------- #

## Atualizando o repositório depois da adição de novos repositórios ##
echo -e "\033[01;32mRunning apt update after additions\033[0m"
apt update -y

# ---------------------------------------------------------------------- #

# Instalando Docker
for nome_do_programa in ${DOCKER_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

# Instalando PHP
for nome_do_programa in ${PHP_INSTALAR[@]}; do
  if ! dpkg -l | grep -q $nome_do_programa; then # Só instala se já não estiver instalado
    apt install "$nome_do_programa" -y
  else
    echo "[INSTALADO] - $nome_do_programa"
  fi
done

# Instalando o composer
echo -e "\033[01;32mCOMPOSER\033[0m"
cd ~
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer


# ----------------------------- PÓS-INSTALAÇÃO ----------------------------- #
## Finalização, atualização e limpeza##
apt update && apt dist-upgrade -y
apt autoclean
apt autoremove -y
# -------------------------------------------------------------------------- #

# Configurando o shell com o fish
chsh -s /usr/bin/fish $USER
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf update
omf install ays
omf reload