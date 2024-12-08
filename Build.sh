#!/bin/bash

# Ensure the script is run from the correct directory
if [ ! -f "Makefile" ]; then
  echo "Makefile not found! Please ensure this script is run from the correct directory."
  exit 1
fi

# Update package list and install necessary dependencies
echo "Updating and installing dependencies..."
pkg update && pkg upgrade -y
pkg install -y openssl libcrypt cmake make g++ git

# Run the 'make' process
echo "Building the miner..."
make clean
make

# Check if the build succeeded
if [ -f "./miner" ]; then
  echo "Build successful! The miner is ready."
else
  echo "Build failed!"
  exit 1
fi

# Install the miner to Termux (optional)
echo "Installing miner..."
make install

echo "Setup complete!"
