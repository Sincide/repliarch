# Hyprland Setup Installation Guide

## Prerequisites

- Fresh Arch Linux installation with internet connection
- User account with sudo privileges
- Basic packages installed: `base-devel git`

## Installation Steps

### 1. System Preparation

```bash
# Update system
sudo pacman -Syu

# Install required base packages
sudo pacman -S --needed base-devel git wget curl
```

### 2. Clone and Run Installation Script

```bash
# Clone repository
git clone https://github.com/your-repo/arch-hyprland-setup.git
cd arch-hyprland-setup

# Make executable and run
chmod +x install.sh
./install.sh
```

### 3. Post-Installation

After installation completes:

1. **Reboot the system**
2. **Login from TTY** (Ctrl+Alt+F2)
3. **Start Hyprland**: `Hyprland`

## Key Bindings

| Shortcut | Action |
|----------|--------|
| `Super + Return` | Open terminal |
| `Super + D` | Application launcher |
| `Super + Q` | Close window |
| `Super + M` | Exit Hyprland |
| `Super + V` | Toggle floating |
| `Super + F` | Toggle fullscreen |
| `Super + 1-9` | Switch workspace |
| `Super + Shift + 1-9` | Move window to workspace |

## Configuration Files

All configurations are located in `~/.config/`:

- `hypr/hyprland.conf` - Main Hyprland configuration
- `waybar/config-primary.jsonc` - Top bar configuration
- `waybar/config-secondary.jsonc` - Bottom bar configuration
- `waybar/style.css` - Waybar styling
- `fish/config.fish` - Fish shell configuration
- `kitty/kitty.conf` - Terminal configuration
- `mako/config` - Notification configuration

## Troubleshooting

### Hyprland won't start
- Ensure you're on TTY (not in display manager)
- Check GPU drivers are installed
- Verify Wayland support: `echo $XDG_SESSION_TYPE`

### Audio issues
- Start pipewire services: `systemctl --user enable --now pipewire pipewire-pulse wireplumber`
- Check audio devices: `wpctl status`

### Waybar not showing
- Verify fonts installed: `fc-list | grep -i jetbrains`
- Check waybar logs: `journalctl --user -u waybar -f`

## Theme Customization

Generate new themes from wallpapers:

```bash
# Generate theme from wallpaper
matugen image /path/to/wallpaper.jpg

# Reload Hyprland to apply
hyprctl reload
```

## Package List

### Core Hyprland
- hyprland
- hyprpaper
- hypridle
- hyprlock
- hyprpicker
- wlogout

### System Integration
- xdg-desktop-portal-hyprland
- xdg-desktop-portal-gtk
- polkit-kde-agent
- pipewire
- pipewire-pulse
- wireplumber

### Applications
- waybar
- kitty
- fish
- mako
- wofi
- thunar
- pavucontrol

### Utilities
- grim
- slurp
- swappy
- wl-clipboard
- cliphist
- brightnessctl
- playerctl
- network-manager-applet

### Fonts
- ttf-jetbrains-mono-nerd
- noto-fonts
- noto-fonts-emoji