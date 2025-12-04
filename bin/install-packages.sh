#!/bin/bash

# ====================================================================
# Arch Linux Package Installation Script
#
# This script installs all necessary packages for the dwl Wayland
# environment and user applications via pacman.
# ====================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# Determine the user ID for informational output
if [ -n "$SUDO_USER" ]; then
    USER_ID="$SUDO_USER"
else
    USER_ID="$(whoami)"
fi

echo "Starting package installation for user: $USER_ID"

# --- 1. Install base-devel (Essential Build/Dev Tools) ---
echo "1/4: Installing 'base-devel' group..."
sudo pacman -S --needed --noconfirm base-devel

# --- 2. Synchronize package database (Ensures packages are found) ---
echo "2/4: Synchronizing package database..."
sudo pacman -Sy

# --- 3. Define all remaining packages (39 total) ---
CORE_PACKAGES=(
    # Development / Configuration tools
    "git"
    "pkgconf" 

    # Wayland Core Components & wlroots Dependencies
    "libinput"
    "wayland"
    "wlroots" 
    "libxkbcommon"
    "wayland-protocols"
    "libxcb"
    "xcb-util-wm"
    "xorg-xwayland"

    # Wayland Utilities
    "grim"      # Screenshot tool
    "slurp"     # Region selection tool
    "swappy"    # Screenshot editor/clipper
    "wofi"      # Wayland Application launcher
    "waybar"    # Status bar

    # System Utilities
    "pavucontrol"   # PulseAudio/PipeWire volume control GUI
    "nemo"          # File manager
    "lxappearance"  # GTK theme configuration
    "networkmanager" # Network management daemon
    "blueman"       # Bluetooth manager (GUI for bluez)
    "fastfetch"     # System information tool (Added)

    # Display Managers
    "lightdm"
    "lightdm-slick-greeter"
    
    # User Applications
    "brave-browser"     # Web Browser
    "libreoffice-fresh" # Office Suite
    "qownnotes"         # Markdown notes app
    "pinta"             # Image editor
    "audacity"          # Audio editor
    "rofi"              # X11 Application launcher (for fallback/Xorg needs)
    "firefox"           # Web Browser
    "prismlauncher" 
    "steam"
    "discord"
    "obs-studio"    # OBS
    "vlc"           # Video player
    "vim"           # Editor
    "alacritty"     # GPU-accelerated terminal emulator
)

# --- 4. Install all remaining packages ---
echo "4/4: Installing remaining packages (${#CORE_PACKAGES[@]} total)..."
sudo pacman -S --needed --noconfirm "${CORE_PACKAGES[@]}"

echo "--------------------------------------------------------"
echo "Package Installation Complete!"
echo "Next: Run ./setup_config.sh to clone the repository and configure dwl."
echo "--------------------------------------------------------"