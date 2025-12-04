#!/bin/bash

# Directory containing your images
IMAGE_DIR="$HOME/Pictures/backgrounds/favs_bg_pack"  # Set this to your folder with images

# Time interval between background changes (in seconds)
INTERVAL=300  # 300 seconds = 5 minutes

# Infinite loop to keep cycling through the images
while true; do
    # Loop through each image file in the directory
    for img in "$IMAGE_DIR"/*; do
        # Check if the file is an actual image (optional)
        if file "$img" | grep -qE 'image|bitmap'; then
            # Use pywal to set the background based on the current image
            wal -i "$img"
            echo "Set background to $img"
	    update_rofi_theme.sh
	    sleep 1
            # Wait for the specified interval before moving to the next image
            sleep $INTERVAL
        fi
    done
done
