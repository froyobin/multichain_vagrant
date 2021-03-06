#!/bin/sh

# Script Arguments:
# $1 - MTU
# $2 - allinone IP address
# $3 - allinone short name
# $4 - compute1 IP address
# $5 - compute1 short name
# $6 - compute2 IP address
# $7 - compute2 short name
MTU=$1
ALLINONE_IP=$2
ALLINONE_NAME=$3
COMPUTE1_IP=$4
COMPUTE1_NAME=$5
COMPUTE2_IP=$6
COMPUTE2_NAME=$7

BASE_PACKAGES="git bridge-utils ebtables python-pip python-dev build-essential ntp openvswitch-switch jq vlan"
DEBIAN_FRONTEND=noninteractive sudo apt-get -qqy update
DEBIAN_FRONTEND=noninteractive sudo apt-get install -qqy $BASE_PACKAGES
echo export LC_ALL=en_US.UTF-8 >> ~/.bash_profile
echo export LANG=en_US.UTF-8 >> ~/.bash_profile
echo source ~/.bashrc >> ~/.bash_profile

# FIXME(mestery): Remove once Vagrant boxes allow apt-get to work again
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get install -y git
sudo apt-get install -y curl
# Enable history and command line editing
cat << DEVSTACKEOF >> .bashrc

# Enable history and command line editing
set -o vi
VISUAL=vim
DEVSTACKEOF

# Add vim plug-ins to make Python development easier

#cat << DEVSTACKEOF > .vimrc
#set tabstop=8
#set expandtab
#set shiftwidth=4
#set softtabstop=4
#set textwidth=79
#syntax on
#filetype on
#filetype plugin indent on
#set autoindent
#set nu
#set ruler
#execute pathogen#infect()
#autocmd FileType python set omnifunc=pythoncomplete#Complete
#let g:syntastic_auto_loc_list=1
#let g:syntastic_python_checkers=['flake8']
#let g:syntastic_quiet_messages = {"regex": "D10*"}
#DEVSTACKEOF
#
#mkdir -p ~/.vim/autoload ~/.vim/bundle
#curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
#sudo pip install flake8
#git clone https://github.com/scrooloose/syntastic.git .vim/bundle/syntastic
#git clone https://github.com/tmhedberg/SimpylFold .vim/bundle/SimpylFold
#git clone https://github.com/Raimondi/delimitMate .vim/bundle/delimitMate
#
# Prepare for devstack


# If available, use repositories on host to facilitate testing local changes.
# Vagrant requires that shared folders exist on the host, so additionally
# check for the ".git" directory in case the parent exists but lacks
# repository contents.


# We need swap space to do any sort of scale testing with the Vagrant config.
# Without this, we quickly run out of RAM and the kernel starts whacking things.
#sudo rm -f /swapfile1
#sudo dd if=/dev/zero of=/swapfile1 bs=1024 count=8388608
#sudo chown root:root /swapfile1
#sudo chmod 0600 /swapfile1
#sudo mkswap /swapfile1
#sudo swapon /swapfile1
URL=http://www.multichain.com/download/multichain-1.0-alpha-25.tar.gz
DEST=/tmp/
curl  -s /tmp/multichain.tar.gz $URL > $DEST/multinode.tar.gz
tar xvzf $DEST/multinode.tar.gz -C /tmp --strip-components 1
sudo mv /tmp/multichaind /tmp/multichain-cli /tmp/multichain-util /usr/local/bin/
