#!/usr/bin/env python3

"""
Media Player Script for Waybar
Auto-generated by Arch Linux Hyprland Setup Script
"""

import json
import subprocess
import sys
import os
import signal
import time
from typing import Dict, Any, Optional

class MediaPlayer:
    def __init__(self):
        self.player_cmd = "playerctl"
        self.max_length = 40
        self.update_interval = 1
        
    def get_player_status(self) -> Dict[str, Any]:
        """Get current player status and metadata"""
        try:
            # Get list of active players
            players_output = subprocess.run(
                [self.player_cmd, "-l"], 
                capture_output=True, 
                text=True, 
                timeout=2
            )
            
            if players_output.returncode != 0 or not players_output.stdout.strip():
                return self._empty_status()
                
            players = players_output.stdout.strip().split('\n')
            
            # Try each player until we find one that's playing
            for player in players:
                try:
                    status = self._get_player_info(player)
                    if status and status.get('status') in ['Playing', 'Paused']:
                        return status
                except:
                    continue
                    
            # If no player is playing, get info from the first available player
            if players:
                return self._get_player_info(players[0]) or self._empty_status()
                
            return self._empty_status()
            
        except Exception as e:
            return self._empty_status()
    
    def _get_player_info(self, player: str) -> Optional[Dict[str, Any]]:
        """Get information from a specific player"""
        try:
            # Get player status
            status_result = subprocess.run(
                [self.player_cmd, "-p", player, "status"],
                capture_output=True,
                text=True,
                timeout=2
            )
            
            if status_result.returncode != 0:
                return None
                
            status = status_result.stdout.strip()
            
            # Get metadata
            metadata = {}
            metadata_fields = [
                ("title", "xesam:title"),
                ("artist", "xesam:artist"),
                ("album", "xesam:album"),
                ("length", "mpris:length")
            ]
            
            for field, mpris_field in metadata_fields:
                try:
                    result = subprocess.run(
                        [self.player_cmd, "-p", player, "metadata", mpris_field],
                        capture_output=True,
                        text=True,
                        timeout=1
                    )
                    if result.returncode == 0:
                        metadata[field] = result.stdout.strip()
                except:
                    metadata[field] = ""
            
            # Get position
            position = ""
            try:
                pos_result = subprocess.run(
                    [self.player_cmd, "-p", player, "position"],
                    capture_output=True,
                    text=True,
                    timeout=1
                )
                if pos_result.returncode == 0:
                    position = pos_result.stdout.strip()
            except:
                pass
            
            return {
                "player": player,
                "status": status,
                "title": metadata.get("title", ""),
                "artist": metadata.get("artist", ""),
                "album": metadata.get("album", ""),
                "length": metadata.get("length", ""),
                "position": position
            }
            
        except Exception:
            return None
    
    def _empty_status(self) -> Dict[str, Any]:
        """Return empty status when no media is playing"""
        return {
            "text": "",
            "tooltip": "No media playing",
            "class": "custom-media",
            "alt": "stopped"
        }
    
    def format_output(self, status: Dict[str, Any]) -> Dict[str, Any]:
        """Format player status for Waybar output"""
        if not status.get("title") and not status.get("artist"):
            return self._empty_status()
        
        # Determine player icon
        player = status.get("player", "").lower()
        if "spotify" in player:
            icon = "󰓇"
            player_class = "custom-spotify"
        elif "firefox" in player:
            icon = "󰈹"
            player_class = "custom-firefox"
        elif "chromium" in player or "chrome" in player:
            icon = ""
            player_class = "custom-chrome"
        elif "vlc" in player:
            icon = "󰕼"
            player_class = "custom-vlc"
        elif "mpv" in player:
            icon = ""
            player_class = "custom-mpv"
        else:
            icon = "🎵"
            player_class = "custom-media"
        
        # Format title and artist
        title = status.get("title", "Unknown Title")
        artist = status.get("artist", "Unknown Artist")
        
        # Create display text
        if artist and artist != "Unknown Artist":
            display_text = f"{artist} - {title}"
        else:
            display_text = title
        
        # Truncate if too long
        if len(display_text) > self.max_length:
            display_text = display_text[:self.max_length - 3] + "..."
        
        # Format tooltip
        tooltip_parts = []
        if title:
            tooltip_parts.append(f"Title: {title}")
        if artist:
            tooltip_parts.append(f"Artist: {artist}")
        if status.get("album"):
            tooltip_parts.append(f"Album: {status['album']}")
        if status.get("status"):
            tooltip_parts.append(f"Status: {status['status']}")
        
        tooltip = "\n".join(tooltip_parts) if tooltip_parts else "No media information"
        
        # Determine status class
        player_status = status.get("status", "").lower()
        if player_status == "playing":
            status_class = "playing"
        elif player_status == "paused":
            status_class = "paused"
        else:
            status_class = "stopped"
        
        return {
            "text": display_text,
            "tooltip": tooltip,
            "class": f"{player_class} {status_class}",
            "alt": status_class
        }
    
    def run_continuous(self):
        """Run in continuous mode, outputting JSON for each update"""
        def signal_handler(signum, frame):
            sys.exit(0)
            
        signal.signal(signal.SIGINT, signal_handler)
        signal.signal(signal.SIGTERM, signal_handler)
        
        while True:
            try:
                status = self.get_player_status()
                output = self.format_output(status)
                print(json.dumps(output), flush=True)
                time.sleep(self.update_interval)
            except KeyboardInterrupt:
                break
            except Exception as e:
                # On error, output empty status
                print(json.dumps(self._empty_status()), flush=True)
                time.sleep(self.update_interval)
    
    def run_once(self):
        """Run once and output current status"""
        try:
            status = self.get_player_status()
            output = self.format_output(status)
            print(json.dumps(output))
        except Exception:
            print(json.dumps(self._empty_status()))

def main():
    """Main function"""
    player = MediaPlayer()
    
    # Check if playerctl is available
    try:
        subprocess.run(
            ["playerctl", "--version"], 
            capture_output=True, 
            check=True
        )
    except (subprocess.CalledProcessError, FileNotFoundError):
        print(json.dumps({
            "text": "",
            "tooltip": "Playerctl not installed",
            "class": "custom-media error",
            "alt": "error"
        }))
        sys.exit(1)
    
    # Parse command line arguments
    if len(sys.argv) > 1:
        if sys.argv[1] == "--continuous":
            player.run_continuous()
        elif sys.argv[1] == "--once":
            player.run_once()
        elif sys.argv[1] == "--help":
            print("Media Player Script for Waybar")
            print("Usage:")
            print("  python3 mediaplayer.py [--continuous|--once|--help]")
            print("")
            print("Options:")
            print("  --continuous  Run continuously and output updates")
            print("  --once        Run once and output current status")
            print("  --help        Show this help message")
        else:
            print(f"Unknown argument: {sys.argv[1]}")
            sys.exit(1)
    else:
        # Default to once mode for Waybar compatibility
        player.run_once()

if __name__ == "__main__":
    main()
