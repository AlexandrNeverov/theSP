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
# -------------------------------
echo "Step 1.5: Installing required utilities (unzip curl gnupg software-properties-common)"
if sudo apt-get install -y unzip curl gnupg software-properties-common; then
  echo "Step 1.5 - done"
else
  echo "Step 1.5 - failed"
  exit 1
fi

# -------------------------------
# STEP 2: Install unzip
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
# STEP 3: Install tree
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
# STEP 12: Generate SSH key and copy to projects folder
# -------------------------------
echo "Step 12: Generating SSH key (if not exists)"
SSH_KEY_PATH="$HOME/.ssh/zero-node-key"
SSH_KEY_COPY="$HOME/projects/.ssh_terr_0_node"
mkdir -p "$HOME/projects"
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

# Copy private key to ~/projects/.ssh_terr_0_node
cp "$SSH_KEY_PATH" "$SSH_KEY_COPY"
chmod 600 "$SSH_KEY_COPY"
echo "SSH key copied to $SSH_KEY_COPY"

# -------------------------------
# STEP 13: Save public IP to $HOME/projects/public
# -------------------------------
echo "Step 13: Saving public IP to $HOME/projects/publicip"
PUBLIC_IP=$(curl -s ifconfig.me)
PUBLIC_IP_FILE="$HOME/projects/publicip"
if echo "$PUBLIC_IP" > "$PUBLIC_IP_FILE"; then
  echo "Public IP saved to $PUBLIC_IP_FILE: $PUBLIC_IP"
  echo "Step 13 - done"
else
  echo "Step 13 - failed"
  exit 1
fi

# STEP 13: Save public IP to $HOME/projects/publicip
# -------------------------------
echo "Step 13: Saving public IP to $HOME/projects/publicip"
PUBLIC_IP=$(curl -s ifconfig.me)
PUBLIC_IP_FILE="$HOME/projects/publicip"
if echo "$PUBLIC_IP" > "$PUBLIC_IP_FILE"; then
  echo "Public IP saved to $PUBLIC_IP_FILE: $PUBLIC_IP"
  echo "Step 13 - done"
else
  echo "Step 13 - failed"
  exit 1
fi

# -------------------------------
# FINAL: Summary of installed tools and versions
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
echo "Copy to:  ${SSH_KEY_COPY}"
echo "Public IP: $(cat "$PUBLIC_IP_FILE")  (saved to $PUBLIC_IP_FILE)"
echo "==========================================="