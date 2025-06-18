# Arch Linux Hyprland Setup Script

An automated post-installation script for Arch Linux that sets up a beautiful Hyprland desktop environment with dual Waybar installations, Fish shell with custom prompt, dynamic theming using Matugen, and symlinked dotfiles for version control.

## Features

### 🎨 Desktop Environment
- **Hyprland**: Modern Wayland compositor with beautiful animations and effects
- **Dual Waybar Setup**: Primary top bar and secondary bottom bar with different widget configurations
- **Dynamic Theming**: Matugen integration for automatic color scheme generation from wallpapers
- **Modern Wallpapers**: Animated SVG-based default wallpaper with Material You design
- **Complete Audio**: PipeWire with WirePlumber for modern audio management

### 🐚 Shell Experience
- **Fish Shell**: User-friendly shell with advanced syntax highlighting and completions
- **Custom Prompt**: Multi-line prompt with git integration, system info, and battery status
- **Modern CLI Tools**: eza, bat, fd, ripgrep, fzf, starship, zoxide and more
- **Intelligent Aliases**: Convenient shortcuts for system management and development

### 🖥️ Applications & Tools
- **Terminal**: Kitty with Catppuccin theme and proper Wayland support
- **File Manager**: Thunar with volume management and GVFS support
- **Launcher**: Wofi with beautiful styling and fuzzy search
- **Notifications**: Mako with urgency-based styling and app-specific themes
- **Screenshots**: Grim + Slurp + Swappy for advanced screenshot workflow
- **Lock Screen**: Hyprlock with blur effects and custom styling

### 🔧 Configuration Management
- **Dotfiles Integration**: Automatic symlink management for version control with Git
- **Backup System**: Comprehensive backup of existing configurations before installation
- **Theme Management**: Advanced theme switching and wallpaper management scripts
- **Service Integration**: Proper systemd user services and environment setup

### 🔒 Security & System
- **Polkit Integration**: KDE polkit agent for secure privilege escalation
- **Portal Support**: XDG desktop portals for proper Wayland app integration
- **Network Management**: NetworkManager with nm-applet for easy network configuration
- **Power Management**: Hypridle for screen timeout and system suspend

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/hyprland-setup.git
   cd hyprland-setup
   ```

2. **Make the script executable:**
   ```bash
   chmod +x install.sh
   ```

3. **Run the installation:**
   ```bash
   ./install.sh
   ```

4. **Optional commands:**
   ```bash
   # Create backup only
   ./install.sh --backup-only
   
   # Verify installation
   ./install.sh --verify
   
   # Show help
   ./install.sh --help
   ```

## What Gets Installed

### Core Packages
- Hyprland compositor and related tools (hyprpaper, hypridle, hyprlock)
- Waybar status bar
- Fish shell with custom configuration
- Kitty terminal emulator
- Wofi application launcher
- Mako notification daemon
- Audio system (PipeWire, WirePlumber)

### Utilities & Tools
- Screenshot tools (grim, slurp, swappy)
- Clipboard manager (cliphist)
- File manager (Thunar with plugins)
- Modern CLI tools (eza, bat, fd, ripgrep, fzf, starship, zoxide)
- Development tools (git, curl, wget)
- System utilities (fastfetch, btop, brightnessctl, playerctl)

### Fonts
- JetBrains Mono Nerd Font
- Noto Fonts with emoji support

## Configuration Structure

```
~/.config/
├── hypr/                    # Hyprland configuration
│   ├── hyprland.conf       # Main configuration
│   ├── hyprpaper.conf      # Wallpaper configuration
│   ├── hypridle.conf       # Idle management
│   ├── hyprlock.conf       # Lock screen
│   └── colors.conf         # Dynamic colors (managed by Matugen)
├── waybar/                  # Status bar configuration
│   ├── config-primary.jsonc    # Top bar configuration
│   ├── config-secondary.jsonc  # Bottom bar configuration
│   ├── style.css              # Static styling
│   └── scripts/               # Custom scripts
├── fish/                    # Fish shell configuration
│   ├── config.fish         # Main configuration
│   └── functions/          # Custom functions and prompts
├── matugen/                # Dynamic theming
│   ├── config.toml         # Matugen configuration
│   └── templates/          # Theme templates
├── kitty/                  # Terminal configuration
├── mako/                   # Notification configuration
└── wofi/                   # Application launcher
```

## Key Bindings

### Window Management
- `Super + Enter` - Open terminal
- `Super + Q` - Close window
- `Super + V` - Toggle floating
- `Super + F` - Toggle fullscreen
- `Super + P` - Pseudo-tile (dwindle)
- `Super + J` - Toggle split (dwindle)

### Navigation
- `Super + h/j/k/l` - Move focus (vim-style)
- `Super + 1-9` - Switch to workspace
- `Super + Shift + 1-9` - Move window to workspace
- `Super + mouse_down/up` - Scroll through workspaces

### Applications
- `Super + D` - Application launcher (wofi)
- `Super + E` - File manager (thunar)
- `Super + L` - Lock screen
- `Super + Shift + S` - Screenshot area
- `Super + C` - Clipboard history

### System
- `Super + Shift + E` - Power menu
- `Super + M` - Exit Hyprland

## Theme Management

### Apply New Theme from Wallpaper
```bash
./scripts/theme-manager.sh apply ~/Pictures/new-wallpaper.jpg
```

### List Available Wallpapers
```bash
./scripts/theme-manager.sh list-wallpapers
```

### Install Wallpaper from URL
```bash
./scripts/theme-manager.sh install-wallpaper https://example.com/wallpaper.jpg
```

### Backup Current Theme
```bash
./scripts/theme-manager.sh backup
```

## Dotfiles Management

### Initialize Dotfiles Repository
```bash
./scripts/symlink-manager.sh setup
```

### Add Configuration to Dotfiles
```bash
./scripts/symlink-manager.sh add ~/.config/hypr
```

### Create Symlinks
```bash
./scripts/symlink-manager.sh link
```

## Backup Management

### Create Manual Backup
```bash
./scripts/backup.sh create pre-update-backup
```

### List Available Backups
```bash
./scripts/backup.sh list
```

### Restore from Backup
```bash
./scripts/backup.sh restore ~/.config-backups/backup-20250618-140530
```

## Troubleshooting

### Audio Issues
If audio is not working:
```bash
# Restart PipeWire services
systemctl --user restart pipewire pipewire-pulse wireplumber
```

### Display Issues
If displays are not configured correctly:
```bash
# Edit monitor configuration in Hyprland config
nano ~/.config/hypr/hyprland.conf
# Look for monitor= lines and adjust as needed
```

### Theme Not Applying
If themes are not applying correctly:
```bash
# Reload theme services
./scripts/theme-manager.sh reload
```

## Post-Installation

After installation:
1. Log out of your current session
2. Select "Hyprland" from your display manager
3. Log in to experience your new desktop environment

## Customization

### Wallpapers
Place wallpapers in `~/Pictures/Wallpapers/` and use the theme manager to apply them.

### Custom Keybindings
Edit `~/.config/hypr/hyprland.conf` to add or modify keybindings.

### Waybar Modules
Modify `~/.config/waybar/config-primary.jsonc` or `config-secondary.jsonc` to customize widgets.

## Requirements

- Arch Linux (base installation)
- Internet connection
- User with sudo privileges
- At least 2GB free disk space

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## Support

If you encounter issues:
1. Check the troubleshooting section
2. Review logs in `/tmp/hyprland-install.log`
3. Open an issue on GitHub with detailed information

## Acknowledgments

- [Hyprland](https://hyprland.org/) - Amazing Wayland compositor
- [Waybar](https://github.com/Alexays/Waybar) - Highly customizable status bar
- [Catppuccin](https://catppuccin.com/) - Soothing pastel theme
- [Matugen](https://github.com/InioX/matugen) - Material You color generation
- [Fish Shell](https://fishshell.com/) - User-friendly command line shell
   