#!/bin/bash

# Wallpaper Setup Script
# Downloads and configures default wallpapers for the Hyprland setup

set -euo pipefail

WALLPAPER_DIR="$HOME/.config/wallpapers"
CONFIG_DIR="$HOME/.config"

# Create wallpaper directory
mkdir -p "$WALLPAPER_DIR"

# Download default wallpaper (using curl which is more commonly available)
if command -v curl &> /dev/null; then
    echo "Downloading default wallpaper..."
    curl -L -o "$WALLPAPER_DIR/default.jpg" \
        "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&q=80" \
        || echo "Failed to download wallpaper, using fallback"
elif command -v wget &> /dev/null; then
    echo "Downloading default wallpaper..."
    wget -O "$WALLPAPER_DIR/default.jpg" \
        "https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=2560&q=80" \
        || echo "Failed to download wallpaper, using fallback"
else
    echo "Creating placeholder wallpaper..."
    # Create a simple solid color image using ImageMagick if available
    if command -v convert &> /dev/null; then
        convert -size 1920x1080 xc:"#1e1e2e" "$WALLPAPER_DIR/default.jpg"
    else
        echo "No download tool available, skipping wallpaper setup"
        exit 1
    fi
fi

# Set up hyprpaper configuration
cat > "$CONFIG_DIR/hyprpaper/hyprpaper.conf" << EOF
preload = $WALLPAPER_DIR/default.jpg
wallpaper = ,$WALLPAPER_DIR/default.jpg

splash = false
ipc = on
EOF

echo "Wallpaper setup completed"