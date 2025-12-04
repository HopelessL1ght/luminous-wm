powermenu.sh
//- file:rofi/powermenu.sh
#!/bin/env bash
exec update_rofi_theme.sh &

# Options for powermenu
logout="↩️ Logout"
shutdown="⏻ Shutdown"
reboot="↺ Reboot"
sleep="⏾ Sleep"
exit="💻  Back to Desktop"

# Get answer from user via rofi
selected_option=$(echo "$logout
$sleep
$reboot
$shutdown
$exit" | rofi -dmenu\
                  -i\
                  -p ""\
                  -config "~/.config/rofi/powermenu.rasi"\
                  -font "Consolas 16"\
                  -width "5"\
                  -lines 5\
                  -line-margin 3\
                  -line-padding 5\
                  -scrollbar-width "0" )


# Do something based on selected option
if [ "$selected_option" == "$logout" ]
then
    loginctl terminate-user `whoami`
elif [ "$selected_option" == "$shutdown" ]
then
    systemctl poweroff
elif [ "$selected_option" == "$reboot" ]
then
    systemctl reboot
elif [ "$selected_option" == "$sleep" ]
then
    amixer set Master mute
    systemctl suspend
elif [ "$selected_option" == "$exit" ]
then
    pkill rofi
else
    echo "No match"
fi
