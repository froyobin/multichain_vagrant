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
echo "Setup /home/vagrant/.multichain/multichain.conf"
mkdir -p /home/vagrant/.multichain/
cat << EOF > /home/vagrant/.multichain/multichain.conf
rpcuser=$RPC_USER
rpcpassword=$RPC_PASSWORD
rpcallowip=$RPC_ALLOW_IP
rpcport=$RPC_PORT
EOF

echo "Start the chain"
multichaind -txindex  -shrinkdebugfilesize $CHAINNAME@$MASTER_NODE:$NETWORK_PORT -daemon

