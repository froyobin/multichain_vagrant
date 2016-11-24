#!/usr/bin/env bash

# Script Arguments:
# $1 -  Interface for Vlan type networks
# $2 -  Physical network for Vlan type networks interface in allinone and compute1 "rack"
# $3 -  Physical network for Vlan type networks interface in compute2 and compute3 "rack"
# $4 -  Segmentation id to be used when creating vlan segments
# $5 -  IPv4 subnet CIDR for vlan's segment 1
# $6 -  IPv4 subnet CIDR for vlan's segment 2
# $7 -  IPv6 subnet CIDR for vlan's segment 1
# $8 -  IPv6 subnet CIDR for vlan's segment 2
#VLAN_INTERFACE=$1
#PHYSICAL_NETWORK=$2
#COMPUTES_PHYSICAL_NETWORK=$3
#SEGMENTATION_ID=$4
#SEGMENT1_IPV4_CIDR=$5
#SEGMENT2_IPV4_CIDR=$6
#SEGMENT1_IPV6_CIDR=$7
#SEGMENT2_IPV6_CIDR=$8
MASTER_ADDRESS=$1
cp /vagrant/provisioning/explorer.sh /home/vagrant/explorer.sh
cp /vagrant/provisioning/blocknotify.sh /home/vagrant/blocknotify.sh
# Get the IP address
ipaddress=$(ip -4 addr show eth1 | grep -oP "(?<=inet ).*(?=/)")

BASE_PACKAGES="sqlite3 libsqlite3-dev"
DEBIAN_FRONTEND=noninteractive sudo apt-get -qqy update
DEBIAN_FRONTEND=noninteractive sudo apt-get install -qqy $BASE_PACKAGES
sudo -H pip install --upgrade pip
sudo -H pip install pycrypto
git clone https://github.com/MultiChain/multichain-explorer.git
cd multichain-explorer; python setup.py install --user
bash /home/vagrant/explorer.sh $MASTER_ADDRESS
echo "done"
