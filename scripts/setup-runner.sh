#!/bin/bash

# Setup script for GitHub Actions self-hosted runner on AWS Lightsail

set -e

echo "=== GitHub Actions Self-Hosted Runner Setup Script ==="
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then 
   echo "Please do not run this script as root"
   exit 1
fi

# Variables
RUNNER_VERSION="2.321.0"
RUNNER_ARCH="linux-x64"
RUNNER_DIR="$HOME/actions-runner"

# Create runner directory
echo "Creating runner directory..."
mkdir -p $RUNNER_DIR
cd $RUNNER_DIR

# Download runner
echo "Downloading GitHub Actions Runner v${RUNNER_VERSION}..."
curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Extract runner
echo "Extracting runner..."
tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz
rm -f actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Make scripts executable
chmod +x config.sh
chmod +x run.sh

echo ""
echo "=== Runner downloaded and extracted successfully ==="
echo ""
echo "To configure the runner, you'll need:"
echo "1. Your repository URL (e.g., https://github.com/NJersyHiro/lightsail-runner-test)"
echo "2. A runner registration token from: Settings > Actions > Runners > New self-hosted runner"
echo ""
echo "Run the following command to configure:"
echo "cd $RUNNER_DIR && ./config.sh --url <REPO_URL> --token <TOKEN>"
echo ""
echo "After configuration, start the runner with:"
echo "./run.sh"