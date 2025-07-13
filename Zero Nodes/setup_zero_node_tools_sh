#!/bin/bash

# Exit immediately if any command fails
set -e

# Utility function to log status of each step
log_step() {
  STEP="$1"
  if "$2"; then
    echo "$STEP - done"
  else
    echo "$STEP - failed"
    exit 1
  fi
}

# -------------------------------
# STEP 0: Update and upgrade system packages
# Ensures the latest security patches and updates are applied
# -------------------------------
echo "Step 0: System update & upgrade"
if sudo apt-get update -y && sudo apt-get upgrade -y; then
  echo "Step 0 - done"
else
  echo "Step 0 - failed"
  exit 1
fi

# -------------------------------
# STEP 1: Set system timezone to America/New_York
# Standardizes logs and scheduling across deployments
# -------------------------------
echo "Step 1: Setting timezone to America/New_York"
if sudo timedatectl set-timezone America/New_York; then
  timedatectl
  echo "Step 1 - done"
else
  echo "Step 1 - failed"
  exit 1
fi

# -------------------------------
# STEP 1.5: Ensure essential utilities installed
# Required for further steps and Terraform setup
# -------------------------------
echo "Step 1.5: Installing required utilities (unzip curl gnupg software-properties-common)"
if sudo apt-get install -y unzip curl gnupg software-properties-common; then
  echo "Step 1.5 - done"
else
  echo "Step 1.5 - failed"
  exit 1
fi

# -------------------------------
# STEP 2: Install unzip utility
# Required for handling ZIP archives (e.g. AWS CLI install)
# -------------------------------
echo "Step 2: Installing unzip"
if sudo apt-get install -y unzip; then
  unzip -v
  echo "Step 2 - done"
else
  echo "Step 2 - failed"
  exit 1
fi

# -------------------------------
# STEP 3: Install tree utility
# Visual representation of directory structure
# -------------------------------
echo "Step 3: Installing tree"
if sudo apt-get install -y tree; then
  tree --version
  echo "Step 3 - done"
else
  echo "Step 3 - failed"
  exit 1
fi

# -------------------------------
# STEP 4: Install curl
# Essential tool for interacting with HTTP APIs
# -------------------------------
echo "Step 4: Installing curl"
if sudo apt-get install -y curl; then
  curl --version
  echo "Step 4 - done"
else
  echo "Step 4 - failed"
  exit 1
fi

# -------------------------------
# STEP 5: Install net-tools (netstat)
# Helpful for checking port bindings and network diagnostics
# -------------------------------
echo "Step 5: Installing net-tools (netstat)"
if sudo apt-get install -y net-tools; then
  netstat -V || echo "netstat ready (no version output)"
  echo "Step 5 - done"
else
  echo "Step 5 - failed"
  exit 1
fi

# -------------------------------
# STEP 6: Install Python 3 and pip
# Required for DevOps scripting, CLI tools, and automation
# -------------------------------
echo "Step 6: Installing Python 3 and pip"
if sudo apt-get install -y python3 python3-pip; then
  python3 --version
  pip3 --version
  echo "Step 6 - done"
else
  echo "Step 6 - failed"
  exit 1
fi

# -------------------------------
# STEP 7: Install AWS CLI (v2)
# Enables programmatic access to AWS services via terminal
# -------------------------------
echo "Step 7: Installing AWS CLI"
if curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip -o awscliv2.zip && sudo ./aws/install; then
  aws --version
  echo "Step 7 - done"
else
  echo "Step 7 - failed"
  exit 1
fi

# -------------------------------
# STEP 8: Install Git
# Fundamental version control tool for managing infrastructure code
# -------------------------------
echo "Step 8: Installing Git"
if sudo apt-get install -y git; then
  git --version
  echo "Step 8 - done"
else
  echo "Step 8 - failed"
  exit 1
fi

# -------------------------------
# STEP 9: Install jq
# Lightweight tool for parsing and manipulating JSON (e.g. AWS CLI output)
# -------------------------------
echo "Step 9: Installing jq"
if sudo apt-get install -y jq; then
  jq --version
  echo "Step 9 - done"
else
  echo "Step 9 - failed"
  exit 1
fi

# -------------------------------
# STEP 10: Install htop
# Advanced system monitoring tool (interactive, better than top)
# -------------------------------
echo "Step 10: Installing htop"
if sudo apt-get install -y htop; then
  htop --version
  echo "Step 10 - done"
else
  echo "Step 10 - failed"
  exit 1
fi

# -------------------------------
# STEP 11: Install tmux
# Terminal multiplexer - essential for remote DevOps session management
# -------------------------------
echo "Step 11: Installing tmux"
if sudo apt-get install -y tmux; then
  tmux -V
  echo "Step 11 - done"
else
  echo "Step 11 - failed"
  exit 1
fi

# -------------------------------
# STEP 12: Generate SSH key for secure access
# Used for connecting to EC2 and other remote services
# -------------------------------
echo "Step 12: Generating SSH key (if not exists)"
SSH_KEY_PATH="$HOME/.ssh/zero-node-key"
if [[ -f "$SSH_KEY_PATH" ]]; then
  echo "SSH key already exists at $SSH_KEY_PATH - skipping"
else
  if ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N "" -C "zero-node-key"; then
    echo "Step 12 - SSH key generated"
  else
    echo "Step 12 - failed to generate SSH key"
    exit 1
  fi
fi

# -------------------------------
# FINAL STEP: Create Terraform project directory
# Ensures default location for pulling IaC projects
# -------------------------------
echo "Final Step: Creating ~/projects/terraform directory"
if mkdir -p "$HOME/projects/terraform"; then
  echo "Directory created at $HOME/projects/terraform"
else
  echo "Failed to create directory"
  exit 1
fi

# -------------------------------
# FINAL: Summary of installed tools and versions
# Ensures auditability, transparency, and reproducibility
# -------------------------------
echo ""
echo "========= Installed Tools Summary ========="
echo "Timezone: $(timedatectl | grep 'Time zone')"
echo "Python 3: $(python3 --version 2>&1)"
echo "pip3:     $(pip3 --version 2>&1)"
echo "Git:      $(git --version 2>&1)"
echo "Curl:     $(curl --version | head -n 1)"
echo "Unzip:    $(unzip -v | head -n 1)"
echo "Tree:     $(tree --version 2>&1)"
echo "JQ:       $(jq --version 2>&1)"
echo "AWS CLI:  $(aws --version 2>&1)"
echo "htop:     $(htop --version 2>&1)"
echo "tmux:     $(tmux -V 2>&1)"
echo "SSH key:  ${SSH_KEY_PATH} / ${SSH_KEY_PATH}.pub"
echo "==========================================="