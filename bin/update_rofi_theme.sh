#!/usr/bin/env bash

# Paths
ROFI_THEME="$HOME/.config/rofi/colors.rasi"
WAL_COLORS="$HOME/.cache/wal/colors.sh"

# Ensure pywal has been run
if [[ ! -f "$WAL_COLORS" ]]; then
  echo "No pywal colors found. Run 'wal -i <image>' first."
  exit 1
fi

# Load pywal colors
source "$WAL_COLORS"

# Generate Rofi theme in desired format
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

echo "Rofi theme saved to $ROFI_THEME"

