#!/usr/bin/env bash

# source this script

CONFIG_BASE_URL_GITHUB="https://raw.githubusercontent.com/tzwm/public_config/main"
CONFIG_BASE_URL_CODING="https://tzwm01.coding.net/p/public_config/d/public_config/git/raw/main"

# bascily setup
echo "==== 0. basicly setup ===="
function switch_download_mirror() {
  echo -n "free? [y/n]: "
  read ans
  if [[ "$ans" == "y" ]]; then
    CONFIG_BASE_URL="$CONFIG_BASE_URL_GITHUB"
  else
    CONFIG_BASE_URL="$CONFIG_BASE_URL_CODING"
  fi
}

function install_basic_packages() {
  apt-get update
  apt-get install tmux \
    vim \
    htop \
    tree \
    wget \
    git \
    sudo \
    zsh \
    man
}

function create_directories() {
  mkdir /data
}

switch_download_mirror
install_basic_packages
create_directories

echo "==== 0. done ===="

# add user
echo "==== 1. add user ===="
function add_user() {
  echo -n "input username: "
  read user
  echo -n "input password: "
  read password
  useradd -m $user -p $password -G sudo -s /bin/zsh
}

#add_user
echo "==== 1. done ===="

# security
echo "==== 2. security ===="
function add_pub_key() {
  echo -n "input public rsa key: "
  read key
  cd /home/$user/ && mkdir -p .ssh && cd .ssh && touch authorized_keys
  echo "$key" >> authorized_keys
}
function update_ssh_auth() {
  cd /etc/ssh/ && touch sshd_config
  sed -i -E 's/#?PasswordAuthentication yes/PasswordAuthentication no/' sshd_config
  sed -i -E 's/#?PermitRootLogin yes/PermitRootLogin no/' sshd_config
  service ssh restart
  #/etc/init.d/sshd restart
}

#add_pub_key
#update_ssh_auth

echo "==== 2. done ===="

# install docker and docker compose
echo "==== 3. install docker and docker compose ===="
function install_docker() {
  apt-get install \
      ca-certificates \
      curl \
      gnupg \
      lsb-release
  mkdir -p /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  apt-get update
  apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
}

#install_docker
echo "==== 3. done ===="

# install syncthing
echo "==== 4. install syncthing ===="
function install_and_run_syncthing() {
  mkdir /etc/syncthing
  cd /etc/syncthing
  wget "${CONFIG_BASE_URL}/dockerfiles/syncthing/docker-compose.yml"
  docker compose up -d
}

#install_and_run_syncthing
echo "==== 4. done ===="
