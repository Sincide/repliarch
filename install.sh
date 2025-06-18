#!/bin/bash

# Arch Linux Post-Installation Script for Hyprland Desktop Environment
# Author: Auto-generated installation script
# Date: June 18, 2025
# Description: Automated setup for beautiful Hyprland environment with Waybar, Fish shell, and dynamic theming

set -euo pipefail

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/tmp/hyprland-install.log"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"
DOTFILES_DIR="$HOME/.dotfiles"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" | tee -a "$LOG_FILE"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

print_header() {
    echo -e "${PURPLE}$1${NC}"
    echo "$(printf '=%.0s' {1..60})"
}

# Progress indicator
show_progress() {
    local current=$1
    local total=$2
    local desc=$3
    local percentage=$((current * 100 / total))
    local bar_length=50
    local filled_length=$((percentage * bar_length / 100))
    
    printf "\r${CYAN}Progress: ["
    printf "%*s" $filled_length | tr ' ' '='
    printf "%*s" $((bar_length - filled_length)) | tr ' ' '-'
    printf "] %d%% - %s${NC}" $percentage "$desc"
    
    if [ $current -eq $total ]; then
        echo
    fi
}

# Error handling
handle_error() {
    local exit_code=$?
    local line_number=$1
    print_error "An error occurred on line $line_number. Exit code: $exit_code"
    print_error "Check the log file: $LOG_FILE"
    print_error "To restore backup: cp -r $BACKUP_DIR/* ~/.config/"
    exit $exit_code
}

trap 'handle_error $LINENO' ERR

# Check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_error "This script should not be run as root!"
        exit 1
    fi
}

# Check system requirements
check_requirements() {
    print_info "Checking system requirements..."
    
    # Check if Arch Linux
    if ! grep -q "Arch Linux" /etc/os-release 2>/dev/null; then
        print_error "This script is designed for Arch Linux only!"
        exit 1
    fi
    
    # Check internet connection
    if ! ping -c 1 google.com &> /dev/null; then
        print_error "No internet connection detected!"
        exit 1
    fi
    
    # Check if pacman is available
    if ! command -v pacman &> /dev/null; then
        print_error "Pacman package manager not found!"
        exit 1
    fi
    
    print_success "System requirements check passed"
}

# Create backup of existing configurations
create_backup() {
    print_info "Creating backup of existing configurations..."
    
    mkdir -p "$BACKUP_DIR"
    
    local config_dirs=(".config/hypr" ".config/waybar" ".config/fish" ".config/matugen")
    
    for dir in "${config_dirs[@]}"; do
        if [ -d "$HOME/$dir" ]; then
            cp -r "$HOME/$dir" "$BACKUP_DIR/" 2>/dev/null || true
            print_info "Backed up $dir"
        fi
    done
    
    print_success "Backup created at: $BACKUP_DIR"
}

# Update system
update_system() {
    print_info "Updating system packages..."
    sudo pacman -Syu --noconfirm
    print_success "System updated successfully"
}

# Install AUR helper (yay)
install_aur_helper() {
    if ! command -v yay &> /dev/null; then
        print_info "Installing yay AUR helper..."
        
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd "$SCRIPT_DIR"
        
        print_success "yay AUR helper installed"
    else
        print_info "yay AUR helper already installed"
    fi
}

# Install Hyprland and dependencies
install_hyprland() {
    print_info "Installing Hyprland and dependencies..."
    
    local packages=(
        "hyprland"
        "hyprpaper"
        "hypridle"
        "hyprlock"
        "hyprpicker"
        "xdg-desktop-portal-hyprland"
        "xdg-desktop-portal-gtk"
        "polkit-kde-agent"
        "qt5-wayland"
        "qt6-wayland"
        "wl-clipboard"
        "cliphist"
        "grim"
        "slurp"
        "swappy"
        "mako"
        "wofi"
        "thunar"
        "thunar-volman"
        "gvfs"
        "pavucontrol"
        "brightnessctl"
        "playerctl"
        "network-manager-applet"
        "kitty"
        "noto-fonts"
        "noto-fonts-emoji"
        "ttf-jetbrains-mono-nerd"
        "wireplumber"
        "pipewire"
        "pipewire-pulse"
        "pipewire-alsa"
        "wlogout"
    )
    
    for i in "${!packages[@]}"; do
        show_progress $((i + 1)) ${#packages[@]} "Installing ${packages[i]}"
        sudo pacman -S --needed --noconfirm "${packages[i]}" >> "$LOG_FILE" 2>&1
    done
    
    print_success "Hyprland and dependencies installed"
}

# Install Waybar
install_waybar() {
    print_info "Installing Waybar..."
    sudo pacman -S --needed --noconfirm waybar
    print_success "Waybar installed"
}

# Install Fish shell
install_fish() {
    print_info "Installing Fish shell..."
    sudo pacman -S --needed --noconfirm fish
    
    # Install Fisher plugin manager
    if ! fish -c "functions -q fisher" 2>/dev/null; then
        print_info "Installing Fisher plugin manager..."
        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    fi
    
    # Set Fish as default shell
    if [[ "$SHELL" != *"fish"* ]]; then
        print_info "Setting Fish as default shell..."
        chsh -s /usr/bin/fish
        print_warning "You may need to log out and back in for the shell change to take effect"
    fi
    
    print_success "Fish shell installed and configured"
}

# Install Matugen for dynamic theming
install_matugen() {
    print_info "Installing Matugen for dynamic theming..."
    
    # Install dependencies first
    sudo pacman -S --needed --noconfirm rust cargo
    
    # Install matugen from AUR
    if ! command -v matugen &> /dev/null; then
        yay -S --needed --noconfirm matugen-bin
        print_success "Matugen installed from AUR"
    else
        print_info "Matugen already installed"
    fi
    
    # Create matugen directories
    mkdir -p "$HOME/.config/matugen/templates"
    mkdir -p "$HOME/.config/matugen/backups"
    mkdir -p "$HOME/.local/share/matugen"
    
    print_success "Matugen and directories configured"
}

# Install additional utilities
install_utilities() {
    print_info "Installing additional utilities..."
    
    local utilities=(
        "fastfetch"
        "btop"
        "eza"
        "bat"
        "fd"
        "ripgrep"
        "fzf"
        "starship"
        "zoxide"
        "git"
        "curl"
        "wget"
        "unzip"
        "tree"
    )
    
    for i in "${!utilities[@]}"; do
        show_progress $((i + 1)) ${#utilities[@]} "Installing ${utilities[i]}"
        sudo pacman -S --needed --noconfirm "${utilities[i]}" >> "$LOG_FILE" 2>&1 || yay -S --needed --noconfirm "${utilities[i]}" >> "$LOG_FILE" 2>&1
    done
    
    print_success "Additional utilities installed"
}

# Deploy configurations
deploy_configurations() {
    print_info "Deploying configuration files..."
    
    # Create necessary directories
    mkdir -p "$HOME/.config/hypr"
    mkdir -p "$HOME/.config/waybar/scripts"
    mkdir -p "$HOME/.config/fish/functions"
    mkdir -p "$HOME/.config/matugen/templates"
    mkdir -p "$HOME/.config/mako"
    mkdir -p "$HOME/.config/wofi"
    mkdir -p "$HOME/.config/kitty"
    mkdir -p "$HOME/Pictures/Wallpapers"
    mkdir -p "$HOME/Pictures/Screenshots"
    
    # Copy configuration files
    cp -r "$SCRIPT_DIR/configs/hypr/"* "$HOME/.config/hypr/"
    cp -r "$SCRIPT_DIR/configs/waybar/"* "$HOME/.config/waybar/"
    cp -r "$SCRIPT_DIR/configs/fish/"* "$HOME/.config/fish/"
    cp -r "$SCRIPT_DIR/configs/matugen/"* "$HOME/.config/matugen/"
    cp -r "$SCRIPT_DIR/configs/mako/"* "$HOME/.config/mako/"
    cp -r "$SCRIPT_DIR/configs/wofi/"* "$HOME/.config/wofi/"
    cp -r "$SCRIPT_DIR/configs/kitty/"* "$HOME/.config/kitty/"
    cp "$SCRIPT_DIR/themes/default-wallpaper.svg" "$HOME/Pictures/Wallpapers/"
    
    # Make scripts executable
    chmod +x "$SCRIPT_DIR/scripts/"*.sh
    chmod +x "$HOME/.config/waybar/scripts/"*.py
    
    # Set proper permissions for configuration files
    chmod 644 "$HOME/.config/hypr/"*.conf
    chmod 644 "$HOME/.config/waybar/"*.jsonc
    chmod 644 "$HOME/.config/waybar/"*.css
    chmod 644 "$HOME/.config/fish/"*.fish
    chmod 644 "$HOME/.config/mako/"*
    chmod 644 "$HOME/.config/wofi/"*
    chmod 644 "$HOME/.config/kitty/"*.conf
    
    print_success "Configuration files deployed"
}

# Setup services
setup_services() {
    print_info "Setting up system services..."
    "$SCRIPT_DIR/scripts/setup-services.sh"
    print_success "System services configured"
}

# Setup dotfiles symlinks
setup_dotfiles() {
    print_info "Setting up dotfiles symlinks..."
    
    # Create dotfiles directory
    if [ ! -d "$DOTFILES_DIR" ]; then
        mkdir -p "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"
        git init
        
        # Create basic gitignore
        cat > .gitignore << 'EOF'
# Ignore sensitive files
*.log
*.tmp
*~
.DS_Store
EOF
        
        git add .gitignore
        git commit -m "Initial commit: Add gitignore"
    fi
    
    # Run symlink manager
    "$SCRIPT_DIR/scripts/symlink-manager.sh" setup
    
    print_success "Dotfiles symlinks configured"
}

# Apply initial theme
apply_theme() {
    print_info "Applying initial theme..."
    "$SCRIPT_DIR/scripts/theme-manager.sh" apply-default
    print_success "Initial theme applied"
}

# Verify installation
verify_installation() {
    print_info "Verifying installation..."
    
    local checks=0
    local total_checks=6
    
    # Check Hyprland
    if command -v Hyprland &> /dev/null; then
        print_success "✓ Hyprland installed"
        ((checks++))
    else
        print_error "✗ Hyprland not found"
    fi
    
    # Check Waybar
    if command -v waybar &> /dev/null; then
        print_success "✓ Waybar installed"
        ((checks++))
    else
        print_error "✗ Waybar not found"
    fi
    
    # Check Fish
    if command -v fish &> /dev/null; then
        print_success "✓ Fish shell installed"
        ((checks++))
    else
        print_error "✗ Fish shell not found"
    fi
    
    # Check Matugen
    if command -v matugen &> /dev/null; then
        print_success "✓ Matugen installed"
        ((checks++))
    else
        print_error "✗ Matugen not found"
    fi
    
    # Check configuration files
    if [ -f "$HOME/.config/hypr/hyprland.conf" ]; then
        print_success "✓ Hyprland configuration deployed"
        ((checks++))
    else
        print_error "✗ Hyprland configuration missing"
    fi
    
    # Check Waybar configurations
    if [ -f "$HOME/.config/waybar/config-primary.jsonc" ] && [ -f "$HOME/.config/waybar/config-secondary.jsonc" ]; then
        print_success "✓ Waybar configurations deployed"
        ((checks++))
    else
        print_error "✗ Waybar configurations missing"
    fi
    
    print_info "Verification complete: $checks/$total_checks checks passed"
    
    if [ $checks -eq $total_checks ]; then
        return 0
    else
        return 1
    fi
}

# Main installation function
main() {
    print_header "Arch Linux Hyprland Setup Script"
    print_info "Starting installation process..."
    print_info "Log file: $LOG_FILE"
    
    # Pre-installation checks
    check_root
    check_requirements
    
    # Create backup
    create_backup
    
    # Installation steps
    local steps=(
        "update_system"
        "install_aur_helper"
        "install_hyprland"
        "install_waybar"
        "install_fish"
        "install_matugen"
        "install_utilities"
        "deploy_configurations"
        "setup_services"
        "setup_dotfiles"
        "apply_theme"
    )
    
    for i in "${!steps[@]}"; do
        show_progress $((i + 1)) ${#steps[@]} "Executing ${steps[i]}"
        ${steps[i]}
    done
    
    # Verification
    if verify_installation; then
        print_header "Installation Completed Successfully!"
        print_success "Hyprland desktop environment has been set up"
        print_info "Backup location: $BACKUP_DIR"
        print_info "Log file: $LOG_FILE"
        print_info ""
        print_info "Next steps:"
        print_info "1. Log out of your current session"
        print_info "2. Select 'Hyprland' from your display manager"
        print_info "3. Log in to experience your new desktop environment"
        print_info ""
        print_info "Key bindings:"
        print_info "- Super + Enter: Terminal"
        print_info "- Super + Q: Close window"
        print_info "- Super + D: Application launcher"
        print_info "- Super + Shift + S: Screenshot"
        print_info ""
        print_info "To customize themes: $SCRIPT_DIR/scripts/theme-manager.sh"
        print_info "To manage dotfiles: $SCRIPT_DIR/scripts/symlink-manager.sh"
    else
        print_error "Installation completed with errors"
        print_error "Check the log file for details: $LOG_FILE"
        exit 1
    fi
}

# Handle command line arguments
case "${1:-}" in
    --backup-only)
        create_backup
        ;;
    --verify)
        verify_installation
        ;;
    --help|-h)
        echo "Usage: $0 [options]"
        echo "Options:"
        echo "  --backup-only    Create backup only"
        echo "  --verify         Verify installation"
        echo "  --help, -h       Show this help message"
        ;;
    *)
        main
        ;;
esac
