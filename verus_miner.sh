#!/bin/bash
# VerusCoin Miner Script for Termux
# Author: Code Copilot
# Repository: [Your GitHub Repository URL]

# Fail script on any error
set -e

# Function to check for necessary tools
check_dependencies() {
    echo "[*] Checking for required dependencies..."
    for cmd in git curl clang make; do
        if ! command -v $cmd &>/dev/null; then
            echo "[-] $cmd is not installed. Installing..."
            pkg install -y $cmd
        else
            echo "[+] $cmd is installed."
        fi
    done
}

# Function to configure Termux storage and environment
setup_environment() {
    echo "[*] Configuring Termux environment..."
    if [ ! -d "$HOME/storage" ]; then
        echo "[+] Enabling Termux storage..."
        termux-setup-storage
        sleep 5
    fi

    echo "[+] Updating and upgrading Termux packages..."
    pkg update -y && pkg upgrade -y
}

# Function to build and install Verus miner
install_verus_miner() {
    echo "[*] Installing VerusCoin miner dependencies..."
    pkg install -y cmake

    echo "[*] Cloning VerusCoin miner repository..."
    cd $HOME
    if [ -d "verusminer" ]; then
        echo "[-] Existing miner directory found. Removing..."
        rm -rf verusminer
    fi
    git clone https://github.com/monkins1010/ccminer.git verusminer

    echo "[*] Building VerusCoin miner..."
    cd verusminer
    chmod +x build.sh
    chmod +x configure.sh
    chmod +x autogen.sh
    ./build.sh
}

# Function to run the miner
run_miner() {
    read -p "[?] Enter your mining pool address (e.g., stratum+tcp://pool.verus.io:9999): " pool_address
    read -p "[?] Enter your wallet address: " wallet_address
    read -p "[?] Enter your worker name (optional, press Enter to skip): " worker_name

    echo "[*] Starting the miner..."
    cd $HOME/verusminer
    if [ -z "$worker_name" ]; then
        ./ccminer -a verus -o "$pool_address" -u "$wallet_address" -p x
    else
        ./ccminer -a verus -o "$pool_address" -u "$wallet_address.$worker_name" -p x
    fi
}

# Main script execution
main() {
    echo "============================"
    echo "   VerusCoin Miner Script   "
    echo "============================"

    check_dependencies
    setup_environment
    install_verus_miner

    echo "[*] Verus miner setup is complete!"
    echo "[*] To start mining, ensure you have a pool and wallet ready."
    run_miner
}

main "$@"
