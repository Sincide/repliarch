#!/bin/bash

# Theme Manager Script
# Handles theme generation and application using Matugen

set -euo pipefail

WALLPAPER_DIR="$HOME/.config/wallpapers"
CONFIG_DIR="$HOME/.config"
MATUGEN_DIR="$CONFIG_DIR/matugen"

print_info() {
    echo "[INFO] $1"
}

print_success() {
    echo "[SUCCESS] $1"
}

print_error() {
    echo "[ERROR] $1"
}

# Apply default theme
apply_default() {
    print_info "Applying default theme..."
    
    if [ ! -f "$WALLPAPER_DIR/default.jpg" ]; then
        print_error "Default wallpaper not found"
        return 1
    fi
    
    # Generate theme from default wallpaper
    if command -v matugen &> /dev/null; then
        matugen image "$WALLPAPER_DIR/default.jpg" --config "$MATUGEN_DIR/config.toml"
        print_success "Default theme applied"
    else
        print_error "Matugen not installed"
        return 1
    fi
}

# Generate theme from custom wallpaper
generate_theme() {
    local wallpaper_path="$1"
    
    if [ ! -f "$wallpaper_path" ]; then
        print_error "Wallpaper file not found: $wallpaper_path"
        return 1
    fi
    
    print_info "Generating theme from: $wallpaper_path"
    
    # Copy wallpaper to wallpapers directory
    cp "$wallpaper_path" "$WALLPAPER_DIR/"
    local wallpaper_name=$(basename "$wallpaper_path")
    
    # Generate theme
    matugen image "$WALLPAPER_DIR/$wallpaper_name" --config "$MATUGEN_DIR/config.toml"
    
    # Update hyprpaper config
    cat > "$CONFIG_DIR/hyprpaper/hyprpaper.conf" << EOF
preload = $WALLPAPER_DIR/$wallpaper_name
wallpaper = ,$WALLPAPER_DIR/$wallpaper_name

splash = false
ipc = on
EOF
    
    # Reload hyprpaper
    if command -v hyprctl &> /dev/null; then
        hyprctl hyprpaper unload all
        hyprctl hyprpaper preload "$WALLPAPER_DIR/$wallpaper_name"
        hyprctl hyprpaper wallpaper ",$WALLPAPER_DIR/$wallpaper_name"
    fi
    
    print_success "Theme generated and applied"
}

# List available wallpapers
list_wallpapers() {
    print_info "Available wallpapers:"
    ls -1 "$WALLPAPER_DIR"/*.{jpg,png,jpeg} 2>/dev/null || print_info "No wallpapers found"
}

# Main function
main() {
    case "${1:-help}" in
        apply-default)
            apply_default
            ;;
        generate)
            if [ -z "${2:-}" ]; then
                print_error "Usage: $0 generate <wallpaper_path>"
                exit 1
            fi
            generate_theme "$2"
            ;;
        list)
            list_wallpapers
            ;;
        help|*)
            echo "Theme Manager"
            echo "Usage: $0 [command] [options]"
            echo "Commands:"
            echo "  apply-default     Apply default theme"
            echo "  generate <path>   Generate theme from wallpaper"
            echo "  list             List available wallpapers"
            echo "  help             Show this help"
            ;;
    esac
}

main "$@"