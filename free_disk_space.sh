#!/usr/bin/env bash
echo "=============================================================================="
echo "Freeing up disk space on CI system for Docker Build"
echo "=============================================================================="

df -h
echo "Removing large packages..."

# Remove large development/SDK packages (GHC, Dotnet, LLVM, PHP)
sudo apt-get remove -y '^ghc-8.*'
sudo apt-get remove -y '^dotnet-.*'
sudo apt-get remove -y '^llvm-.*'
sudo apt-get remove -y 'php.*'

# Remove large SDKs and Browsers, including monodoc-http before mono-devel
sudo apt-get remove -y azure-cli google-cloud-sdk hhvm google-chrome-stable firefox monodoc-http powershell mono-devel

sudo apt-get autoremove -y
sudo apt-get clean
df -h

echo "Removing large directories (e.g., /usr/share/dotnet/)..."
# deleting approx 15GB
rm -rf /usr/share/dotnet/
df -h
echo "=============================================================================="
