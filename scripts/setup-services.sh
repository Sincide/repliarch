#!/bin/bash

# Service Setup Script
# Configures systemd user services for Hyprland environment

set -euo pipefail

print_info() {
    echo "[INFO] $1"
}

print_success() {
    echo "[SUCCESS] $1"
}

print_error() {
    echo "[ERROR] $1"
}

# Enable PipeWire audio services
setup_audio() {
    print_info "Setting up audio services..."
    
    # Enable and start PipeWire services
    systemctl --user enable pipewire.service
    systemctl --user enable pipewire-pulse.service
    systemctl --user enable wireplumber.service
    
    # Start services if not running
    systemctl --user start pipewire.service || true
    systemctl --user start pipewire-pulse.service || true
    systemctl --user start wireplumber.service || true
    
    print_success "Audio services configured"
}

# Setup environment variables
setup_environment() {
    print_info "Setting up environment variables..."
    
    # Create environment file for systemd user session
    mkdir -p "$HOME/.config/environment.d"
    
    cat > "$HOME/.config/environment.d/hyprland.conf" << 'EOF'
# Hyprland Environment Variables
XDG_CURRENT_DESKTOP=Hyprland
XDG_SESSION_TYPE=wayland
XDG_SESSION_DESKTOP=Hyprland
XCURSOR_SIZE=24
QT_QPA_PLATFORM=wayland
QT_QPA_PLATFORMTHEME=qt6ct
MOZ_ENABLE_WAYLAND=1
ELECTRON_ENABLE_WAYLAND=1
EOF
    
    print_success "Environment variables configured"
}

# Setup XDG portals
setup_portals() {
    print_info "Setting up XDG desktop portals..."
    
    # Create xdg-desktop-portal configuration
    mkdir -p "$HOME/.config/xdg-desktop-portal"
    
    cat > "$HOME/.config/xdg-desktop-portal/portals.conf" << 'EOF'
[preferred]
default=hyprland;gtk
org.freedesktop.impl.portal.Screenshot=hyprland
org.freedesktop.impl.portal.ScreenCast=hyprland
org.freedesktop.impl.portal.FileChooser=gtk
EOF
    
    # Enable xdg-desktop-portal service
    systemctl --user enable xdg-desktop-portal.service
    systemctl --user enable xdg-desktop-portal-hyprland.service
    
    print_success "XDG portals configured"
}

# Setup Mako notification service
setup_notifications() {
    print_info "Setting up notification service..."
    
    # Create mako systemd service
    mkdir -p "$HOME/.config/systemd/user"
    
    cat > "$HOME/.config/systemd/user/mako.service" << 'EOF'
[Unit]
Description=Mako notification daemon
PartOf=graphical-session.target

[Service]
Type=dbus
BusName=org.freedesktop.Notifications
ExecStart=/usr/bin/mako
Restart=on-failure

[Install]
WantedBy=graphical-session.target
EOF
    
    systemctl --user daemon-reload
    systemctl --user enable mako.service
    
    print_success "Notification service configured"
}

# Setup polkit agent
setup_polkit() {
    print_info "Setting up polkit authentication agent..."
    
    cat > "$HOME/.config/systemd/user/polkit-kde-agent.service" << 'EOF'
[Unit]
Description=KDE Polkit Authentication Agent
PartOf=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/lib/polkit-kde-authentication-agent-1
Restart=on-failure
RestartSec=1
TimeoutStopSec=10

[Install]
WantedBy=graphical-session.target
EOF
    
    systemctl --user daemon-reload
    systemctl --user enable polkit-kde-agent.service
    
    print_success "Polkit agent configured"
}

# Main function
main() {
    print_info "Starting service setup..."
    
    setup_audio
    setup_environment
    setup_portals
    setup_notifications
    setup_polkit
    
    print_success "All services configured successfully"
    print_info "Services will start automatically on next login"
}

main "$@"