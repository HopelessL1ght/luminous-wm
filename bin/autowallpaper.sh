#!/bin/bash

# --- Configuration ---
WALLPAPER_DIR="$HOME/Pictures/wallpapers"
INTERVAL_SECONDS=300 # Wait time between switches (e.g., 300 seconds = 5 minutes)

# Pywal/Rofi/Wofi Paths
ROFI_THEME="$HOME/.config/rofi/colors.rasi"
WOFI_CONFIG="$HOME/.config/wofi/style.css" # Set this to your Wofi config file
WAYBAR_CONFIG="$HOME/.config/waybar/style.css" # NEW: Set this to your Waybar config file
WAL_COLORS="$HOME/.cache/wal/colors.sh"
WAL_SEQUENCES="$HOME/.cache/wal/sequences" 

# --- PID Tracking ---
OLD_PID="" # PID of the currently running swaybg process

# --- Function to update Rofi/Wofi/Terminal colors ---
update_themes() {
    if [[ -f "$WAL_COLORS" ]]; then
        # Load pywal colors into shell variables
        source "$WAL_COLORS"
        echo "Pywal colors loaded."
        
        # --- 1. Update Rofi theme file ---
        cat > "$ROFI_THEME" << EOF
* {
    bg-col:         ${background};
    bg-col-light:   ${color7};
    border-col:     ${color0};
    selected-col:   ${color2};
    blue:           ${color4};
    fg-col:         ${foreground};
    fg-col2:        ${color4};
    grey:           ${color7};
    width:          600;
    font:           "Consolas Italic 16"; /* Set to italic Consolas */
}
EOF
        echo "Rofi theme updated."


        # --- 2. Update Wofi theme file (MAPPING TO PYWAL COLORS) ---
        cat > "$WOFI_CONFIG" << EOF
* {
  font-family: Consolas;
  font-style: italic; /* Set to italic */
  background: transparent;
  color: ${foreground}; 
}

#window {
  color: ${foreground}; 
  border-color: ${color0}; /* Mapped to Rofi border-col */
  border-style: solid;
  border-width: 1px;

  /*Linear gradient background instead of standard background, because it makes cleaner border-radius cuts, issa bug :p*/
  background-image: linear-gradient(to bottom, ${background} 100%); 
  border-radius: 10px;
}
#scroll {
  border-top-style: solid;
  border-width: 1px;
  border-color: ${color0}; /* Mapped to Rofi border-col */
}
#inner-box {
  padding-top: 12px;
}
#entry {
  border-style: none;
  border-color: ${color0}; /* Mapped to Rofi border-col */
  color: ${foreground}; 
  padding: 6px;
  margin-bottom: 8px;
  margin-left: 12px;
  margin-right: 12;

  border-radius: 12px;
}

#entry:selected {
  background: ${background}; 
  color: ${foreground}; 
  font-weight: bold;
  outline: none;
}

#input {
  background-color: ${background}; 
  color: ${foreground}; 
  border-color: ${color0}; /* Mapped to Rofi border-col */

  border-style: none;
  border-bottom-style: solid;
  border-width: 1px;

  font-style: italic; /* Set to italic */

  border-radius: 8;
  border-bottom-left-radius: 0px;
  border-bottom-right-radius: 0px;

  padding: 12px;
  margin: 8px;
}
#input:focus {
  background: ${background}; 
  background-color: ${background}; 
  border-color: ${color4}; /* Set to accent color */
  font-style: italic;
}

#img {
  padding: 4px;
  margin-right: 6px;
}
EOF
        echo "Wofi theme updated with Pywal colors and italic font."
        
        # --- 3. Update Waybar style file (NEW: MAPPING TO PYWAL COLORS) ---
        cat > "$WAYBAR_CONFIG" << EOF
* {
  font-family: Consolas;
  border-radius: 30;
  font-size: 16px;
  font-style: italic; /* Set to italic */
  padding: 2px;
  background: transparent;
}

window#waybar {
  background-color: transparent;
  border-radius: 30px;
  padding: 20px;
  border-style: none;
}


#custom-nemo,
#custom-powermenu,
#cpu,
#memory,
#tags button,
#battery,
#network,
#clock,
#custom-applauncher,
#tray,
#workspaces,
#pulseaudio {
  background-color: ${background}; /* #1a1a25 */
  margin: 4px;
  margin-right: 2px;
  padding: 2px 8px;
  border-radius: 30px;
  color: ${foreground}; /* #cccccf */

  border-style: none;
  transition-duration: 120ms;
}

#pulseaudio:hover {
  background-color: ${color7}; /* #1a1a25 -> Mapped to light background for hover effect */
  transition-duration: 100ms;
  all: initial;
  font-weight: bold;
  min-width: 0;
  color: ${foreground}; /* #cccccf */
  margin-right: 0.2cm;
  margin-left: 0.2cm;
}

#cpu{
  background-color: ${background}; /* #1a1a25 */
  color: ${foreground}; /* #cccccf */
  margin: 4px;
  margin-right: 0.2cm;
  margin-left: 0.2cm;
  padding: 2px 8px;
  border-radius: 30px;
}

#cpu:hover{
  background-color: ${color7}; /* #1a1a25 -> Mapped to light background for hover effect */
  transition-duration: 100ms;
  all: initial;
  font-weight: bold;
  min-width: 0;
  color: ${foreground}; /* #cccccf */
  margin-right: 0.2cm;
  margin-left: 0.2cm;
}

#cpu.state-10 {
  color: ${color2}; /* #a3be8c -> Green */
}

#cpu.state-50 {
  color: ${color3}; /* #ebcb8b -> Yellow */
}

#cpu.state-90 {
  color: ${color1}; /* #bf616a -> Red */
}



#memory {
  background-color: ${background}; /* #1a1a25 */
  color: ${foreground}; /* #cccccf */
  margin: 4px;
  margin-right: 0.2cm;
  margin-left: 0.2cm;
  padding: 2px 8px;
  border-radius: 30px;
}

#memory:hover{
  background-color: ${color7}; /* #1a1a25 -> Mapped to light background for hover effect */
  transition-duration: 100ms;
  all: initial;
  font-weight: bold;
  min-width: 0;
  color: ${foreground}; /* #cccccf */
  margin-right: 0.2cm;
  margin-left: 0.2cm;
 
}

#network {
  background-color: ${background}; /* #1a1a25 */
  color: ${foreground}; /* #cccccf */
  margin: 4px;
  margin-right: 0.2cm;
  margin-left: 0.2cm;
  padding: 2px 8px;
  border-radius: 30px;
}

#network:hover{
  background-color: ${color7}; /* #1a1a25 -> Mapped to light background for hover effect */
  transition-duration: 100ms;
  all: initial;
  font-weight: bold;
  min-width: 0;
  color: ${foreground}; /* #cccccf */
  margin-right: 0.2cm;
  margin-left: 0.2cm;

}

#clock {
  background-color: ${background}; /* #1a1a25 */
  margin-right: 0.2cm;
  margin-left: 0.2cm;
}

#clock:hover{
  background-color: ${color7}; /* #1a1a25 -> Mapped to light background for hover effect */
  transition-duration: 100ms;
  all: initial;
  font-weight: bold;
  min-width: 0;
  color: ${foreground}; /* #cccccf */
  margin-right: 0.2cm;
  margin-left: 0.2cm;
}

#tags button {
  background-color: ${background}; /* #1a1a25 */
  color: ${foreground}; /* #cccccf */
  padding: 2px 2px;
  margin-right: 6px;
  
}

#tags button.occupied {
  background-color: ${background}; /* #1a1a25 */
  color: ${color4}; /* #837E8B -> Accent color */
  
}

#tags button.focused {
  background-color: ${background}; /* #1a1a25 */
  color: ${color4}; /* #837E8B -> Accent color */
}

#tags button.urgent {
  background-color: ${background}; /* #1a1a25 */
  color: ${color1}; /* #E49186 -> Red/Urgent color */
}



#custom-applauncher {
  font-weight: bold;
  padding: 2px 8px;
  background-color: ${background}; /* #1a1a25 */
  margin-right: 6px;
  transition-duration: 120ms;
}
#custom-applauncher:hover {
  background-image: linear-gradient(to bottom, ${color5} 100%); /* #75778B -> Mapped to a strong accent color */
  color: ${foreground}; /* #cccccf */
  transition-duration: 120ms;
}

#custom-powermenu {
  font-weight: bold;
  padding: 2px 2px;
  background-color: ${background}; /* #1a1a25 */
  margin-right: 6px;
  transition-duration: 120ms;
}
#custom-powermenu:hover {
  background-image: linear-gradient(to bottom, ${color5} 100%); /* #75778B -> Mapped to a strong accent color */
  color: ${foreground}; /* #cccccf */
  transition-duration: 120ms;
}

#tray menu {
  background-color: ${background}; /* #1a1a25 */
  color: ${foreground}; /* #cccccf */
  margin: 4px;
  margin-right: 2px;
  padding: 2px 8px;
  border-radius: 30px;
}

#tray menu:hover {
  background-color: ${color7}; /* #1a1a25 -> Mapped to light background for hover effect */
  transition-duration: 100ms;
  all: initial;
  font-weight: bold;
  min-width: 0;
  color: ${background}; /* Inverted color */
  margin-right: 0.2cm;
  margin-left: 0.2cm;
}


#custom-nemo {
  font-weight: bold;
  padding: 2px 8px;
  background-color: ${background}; /* #1a1a25 */
  margin-right: 6px;
  transition-duration: 120ms;
}
#custom-nemo:hover {
  background-image: linear-gradient(to bottom, ${color5} 100%); /* #75778B -> Mapped to a strong accent color */
  color: ${foreground}; /* #cccccf */
  transition-duration: 120ms;
}

#tray menu menuitem {
  background-color: ${background}; /* #1a1a25 */
  font-weight: bold;
  font-size: 16;
  margin: 5px;
  color: ${foreground}; /* #cccccf */
  border-radius: 30px;
  border-style: solid;
  border-color: ${color0}; /* #0A0A0D -> Mapped to border color */
}


#workspaces button {
  padding: 10px 10px;
  transition-duration: 100ms;
  all: initial;
  min-width: 0;
  font-weight: bold;
  color: ${foreground}; /* #cccccf */
  margin-right: 1px;
  margin-left: 1px;
}

#workspaces button:hover {
  transition-duration: 120ms;
  color: ${color7}; /* #8B8A8D -> Mapped to light gray for hover */
}
#workspaces button.focused {
  color: ${color4}; /* #7D8094 -> Mapped to accent color */
  font-weight: bold;
}
#workspaces button.active {
  color: ${foreground}; /* #cccccf */
  font-weight: bold;
}
#workspaces button.urgent {
  color: ${color8}; /* #595866 -> Mapped to dark gray */
}

#battery {
  background-color: ${color7}; /* #6E6D71 -> Mapped to light gray */
  color: ${color8}; /* #595866 -> Mapped to dark gray */
}
#battery.warning,
#battery.critical,
#battery.urgent {
  color: ${color8}; /* #595866 -> Mapped to dark gray */
  background-color: ${color1}; /* #595866 -> Mapped to Red/Urgent color */
}

EOF
        echo "Waybar theme updated with Pywal colors and italic font."

        # --- 4. Apply terminal colors to current session ---
        if [[ -f "$WAL_SEQUENCES" ]]; then
            cat "$WAL_SEQUENCES"
            echo "Terminal colors applied."
        fi
        
        # --- 5. Reload Waybar using SIGUSR2 ---
        pkill -SIGUSR2 waybar
        echo "Sent SIGUSR2 to Waybar to reload styles."
    fi
}

# Function to handle the actual wallpaper setting and theme updating
set_next_wallpaper() {
    # 1. Select the NEXT random wallpaper image
    local IMG_TO_USE=$(find "$WALLPAPER_DIR" -type f -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" | shuf -n1)
    
    # 2. Start the new swaybg process
    swaybg -i "$IMG_TO_USE" -m fill &
    local NEXT_PID=$!
    echo "Starting new wallpaper: $IMG_TO_USE (PID: $NEXT_PID)"

    # 3. Run pywal for the new image (The -t flag prevents it from changing terminal colors prematurely)
    wal -i "$IMG_TO_USE" -t
    sleep 0.5 # Wait briefly for pywal to finish generating files

    # 4. Update Rofi/Wofi/Terminal themes
    update_themes

    # 5. Kill the OLD swaybg process
    if [[ -n "$OLD_PID" ]]; then
        # Wait briefly for the new one to fully draw before killing the old
        sleep 0.5 
        kill "$OLD_PID" 2>/dev/null
        echo "Killed old process $OLD_PID"
    fi
    
    # 6. Update the PID tracker for the next cycle
    OLD_PID=$NEXT_PID
}

# --- Main Logic ---

# Set the initial wallpaper and themes
set_next_wallpaper

# --- Main Loop ---
while true; do
    echo "Waiting for $INTERVAL_SECONDS seconds..."
    # Wait for the fixed interval
    sleep $INTERVAL_SECONDS
    
    # Set the next wallpaper after the wait
    set_next_wallpaper
done