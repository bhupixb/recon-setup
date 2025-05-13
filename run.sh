#!/usr/bin/env bash

set -e
dir="/Users/bhupendrayadav/Developer/bhupendray/github/recon-setup"
# 1. Check if podman is running
if ! podman info >/dev/null 2>&1; then
  echo "🚫 Podman is not running or not reachable. Please start Podman and try again."
  exit 1
fi

# 2. Check if container 'devshell' exists
if podman container exists devshell; then
  # Check if it's running
  if podman ps --format '{{.Names}}' | grep -q '^devshell$'; then
    echo "🔗 Attaching to running devshell container..."
  else
    echo "▶️  Starting existing devshell container..."
    podman start devshell
  fi
else
  echo "🚀 Creating and starting devshell container..."
  podman run -d --name devshell \
    -v "$dir/data/zsh_history:/root/.zsh_history" \
    -v "$dir/data:/root/data" \
    -it devshell:1.0.0
fi

# 3. Exec into the container
podman exec -it devshell zsh