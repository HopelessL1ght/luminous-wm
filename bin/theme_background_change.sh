#!/bin/bash

# Directory containing your images
IMAGE_DIR="$HOME/Pictures/basic_bg_pack"  # Set this to your folder with images

# Time interval between background changes (in seconds)
INTERVAL=300  # 300 seconds = 5 minutes

# Rofi theme path
ROFI_THEME="$HOME/.config/rofi/colors.rasi"
WAL_COLORS="$HOME/.cache/wal/colors.sh"

# Infinite loop to keep cycling through the images
while true; do
    for img in "$IMAGE_DIR"/*; do
        if file "$img" | grep -qE 'image|bitmap'; then
            # Set wallpaper and generate pywal colors
            wal -i "$img"
            echo "Set background to $img"

            # Wait briefly to ensure wal generates files
            sleep 1

            # Update Rofi theme if wal colors exist
            if [[ -f "$WAL_COLORS" ]]; then
                source "$WAL_COLORS"

                cat > "$ROFI_THEME" << EOF
* {
    bg-col:        ${background};
    bg-col-light:  ${color7};
    border-col:    ${color0};
    selected-col:  ${color2};
    blue:          ${color4};
    fg-col:        ${foreground};
    fg-col2:       ${color4};
    grey:          ${color7};
    width:         600;
}
EOF

                echo "Updated Rofi theme at $ROFI_THEME"
            else
                echo "No pywal colors found. Skipping Rofi theme update."
            fi

            # Wait before next image
            sleep $INTERVAL
        fi
    done
done

