#!/bin/bash

# Setup script for multiple GitHub Actions runners on AWS Lightsail
# This script sets up 3 runners with unique names on a single instance

set -e

# Configuration
RUNNER_COUNT=3
GITHUB_OWNER=$(echo $GITHUB_REPOSITORY | cut -d'/' -f1)
GITHUB_REPO=$(echo $GITHUB_REPOSITORY | cut -d'/' -f2)
RUNNER_BASE_DIR="/home/ubuntu/actions-runners"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}Setting up $RUNNER_COUNT GitHub Actions runners...${NC}"

# Check if running as ubuntu user
if [ "$USER" != "ubuntu" ]; then
    echo -e "${RED}This script should be run as the ubuntu user${NC}"
    exit 1
fi

# Create base directory
mkdir -p "$RUNNER_BASE_DIR"
cd "$RUNNER_BASE_DIR"

# Get runner token (you'll need to provide this)
if [ -z "$RUNNER_TOKEN" ]; then
    echo -e "${YELLOW}Please set the RUNNER_TOKEN environment variable${NC}"
    echo "You can get it from: https://github.com/$GITHUB_OWNER/$GITHUB_REPO/settings/actions/runners/new"
    echo "Example: export RUNNER_TOKEN='your_token_here'"
    exit 1
fi

# Download runner package (only need to do this once)
if [ ! -f "actions-runner-linux-x64-2.317.0.tar.gz" ]; then
    echo -e "${GREEN}Downloading GitHub Actions runner...${NC}"
    curl -o actions-runner-linux-x64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-linux-x64-2.317.0.tar.gz
fi

# Setup each runner
for i in $(seq 1 $RUNNER_COUNT); do
    RUNNER_NAME="lightsail-runner-$i"
    RUNNER_DIR="$RUNNER_BASE_DIR/runner-$i"
    
    echo -e "${GREEN}Setting up runner $i: $RUNNER_NAME${NC}"
    
    # Create runner directory
    mkdir -p "$RUNNER_DIR"
    cd "$RUNNER_DIR"
    
    # Extract runner
    tar xzf ../actions-runner-linux-x64-2.317.0.tar.gz
    
    # Configure runner
    ./config.sh --url "https://github.com/$GITHUB_OWNER/$GITHUB_REPO" \
                --token "$RUNNER_TOKEN" \
                --name "$RUNNER_NAME" \
                --labels "self-hosted,Linux,X64,lightsail" \
                --work "_work" \
                --unattended \
                --replace
    
    # Install as service
    sudo ./svc.sh install "runner-$i"
    
    # Start the service
    sudo ./svc.sh start "runner-$i"
    
    echo -e "${GREEN}Runner $i started successfully${NC}"
    echo ""
done

echo -e "${GREEN}All $RUNNER_COUNT runners have been set up!${NC}"
echo ""
echo "Runner status:"
for i in $(seq 1 $RUNNER_COUNT); do
    echo -n "Runner $i: "
    sudo ./runner-$i/svc.sh status "runner-$i"
done

echo ""
echo -e "${YELLOW}To manage runners:${NC}"
echo "Start runner: sudo $RUNNER_BASE_DIR/runner-N/svc.sh start runner-N"
echo "Stop runner: sudo $RUNNER_BASE_DIR/runner-N/svc.sh stop runner-N"
echo "Check status: sudo $RUNNER_BASE_DIR/runner-N/svc.sh status runner-N"