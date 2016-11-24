#!/bin/bash -x

MASTER_NODE=$1
# Fallback for the $CHAINNAME variable
if [ -z "$CHAINNAME" ]; then
    CHAINNAME='VagrantChain'
fi

# Fallback for the $NETWORK_PORT variable
if [ -z "$NETWORK_PORT" ]; then
    NETWORK_PORT=7447
fi

# Fallback for the $RPC_PORT variable
if [ -z "$RPC_PORT" ]; then
    RPC_PORT=8000
fi

# Fallback for the $RPC_USER variable
if [ -z "$RPC_USER" ]; then
    RPC_USER="multichainrpc"
fi

# Fallback for the $RPC_PASSWORD variable
if [ -z "$RPC_PASSWORD" ]; then
    RPC_PASSWORD="this-is-insecure-change-it"
fi

# Fallback for the $RPC_ALLOW_IP variable
if [ -z "$RPC_ALLOW_IP" ]; then
    RPC_ALLOW_IP="0.0.0.0/0.0.0.0"
fi



echo "Sleep for 30 seconds so the master node has initialised"
sleep 10

echo "Start the chain"
multichaind -daemon -txindex -shrinkdebugfilesize $CHAINNAME@$MASTER_NODE:$NETWORK_PORT 

echo "Sleep for 30 seconds so the slave node has initialised"
sleep 30

echo "Setup /home/vagrant/.multichain/$CHAINNAME/multichain.conf"
echo "rpcport=$RPC_PORT" >> /home/vagrant/.multichain/$CHAINNAME/multichain.conf

echo "Setup /home/vagrant/explorer.conf"
cat << EOF > /home/vagrant/explorer.conf
port 2750
host 0.0.0.0
datadir += [{
        "dirname": "~/.multichain/$CHAINNAME",
        "loader": "default",
        "chain": "MultiChain $CHAINNAME",
        "policy": "MultiChain"
        }]
dbtype = sqlite3
connect-args = vagrantchain.explorer.sqlite
EOF

echo "Run the explorer on explorer node"
#python -m Mce.abe --config /home/vagrant/explorer.conf --commit-bytes 100000 --no-serve
#python -m Mce.abe --config /home/vagrant/explorer.conf

