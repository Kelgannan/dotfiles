#!/usr/bin/env bash
# Fetch info about your system
# https://github.com/dylanaraps/fetch
#
# Optional Dependencies: (You'll lose these features without them)
#   Displaying Images: w3m + w3m-img
#   Image Cropping: ImageMagick
#   Wallpaper Display: feh
#   Current Song: mpc
#   Text formatting, dynamic image size and padding: tput
#   Resolution detection: xorg-xdpyinfo
#   More accurate window manager detection: wmctrl
#
# Created by Dylan Araps
# https://github.com/dylanaraps/

# Speed up script by not using unicode
export LC_ALL=C
export LANG=C
export LANGUAGE=C


# Config Options {{{


# Info Options {{{


# Info
# What to display and in what order.
#
# Format is: "Subtitle: function name"
# Additional lines you can use include:
# "underline" "linebreak" "echo: msg here" "title: title here"
#
# You can also include your own custom lines by using:
# "echo: subtitlehere: $(custom cmd here)"
# "echo: Custom string to print"
#
# Optional info lines that are disabled by default are:
# "getresolution" "getsong"

info=(
    "gettitle"
    "underline"
    "echo: OS: Windows 7 Ultimate 64-bit"
    "Uptime: getuptime"
    "echo: Shell: Blackbox Zero 1.18"
    "echo: WM: bbLean, Explorer"
    "echo: Visual Style: Shiro Transparent"
    "echo: Font: DejaVu Sans Mono, Open Sans"
    "echo: IRC Client: Hexchat"
    "echo: Music Player: Foobar2000"
    "echo: Icons: Numix by neiio"
    "CPU: getcpu"
    "echo: GPU: AMD Radeon R9 200 Series"
    "Memory: getmemory"
    "echo: $(printf "\e[0;31m"▄▄▄"\e[0;33m"▄▄▄"\e[0;32m"▄▄▄"\e[0;36m"▄▄▄"\e[0;34m"▄▄▄"\e[0;35m"▄▄▄"\e[0;37m"▄▄▄"\e[0;30m"▄▄▄)"
    "echo: $(printf "\e[1;31m"▀▀▀"\e[1;33m"▀▀▀"\e[1;32m"▀▀▀"\e[1;36m"▀▀▀"\e[1;34m"▀▀▀"\e[1;35m"▀▀▀"\e[1;37m"▀▀▀"\e[1;30m"▀▀▀)"
)

# Window Manager

# Use wmctrl for a more accurate
# window manager reading
use_wmctrl=0


# CPU

# CPU speed type
# Only works on Linux
# --speed_type current/min/max
speed_type="max"


# Uptime

# Shorten the output of the uptime function
uptime_shorthand="off"


# Color Blocks

# Color block range
# --block_range start end
start=0
end=7

# Toggle color blocks
# --color_blocks on/off
color_blocks="on"

# Color block width
# --color_block_width num
block_width=3


# }}}


# Text Colors {{{
# --colors 1 2 3 4 5


# --title_color num
title_color=6

# --subtitle_color num
subtitle_color=4

# --colon_color num
colon_color=8

# --underline_color num
underline_color=8

# --info_color num
info_color=13

# }}}


# Text Options {{{


# Toggle line wrapping
# --line_wrap on/off
line_wrap="on"

# Toggle bold text
# --bold on/off
bold="on"

# Toggle title underline
# --underline on/off
underline="on"

# Underline character
# --underline_char char
underline_char="*"

# Prompt height
# You should only have to change this if your
# prompt is greater than 2 lines high.
# --prompt_height num
prompt_height=2


# }}}


# Image Options {{{


# Image Source
# --image wall, shuffle, /path/to/img, off
image="wall"

# Thumbnail directory
imgtempdir="$HOME/.fetchimages"

# W3m-img path
# Some systems have this in another location
w3m_img_path="/usr/lib/w3m/w3mimgdisplay"

# Split Size
# Sizing for the img and text splits
# The larger the value the less space fetch will take up.
# The default value of 2 splits the image and text at
# half terminal width each.
# A value of 3 splits them at a third width each and etc.
# --split_size num
split_size=2

# Image position
# --image_position left/right
image_position="left"

# Shuffle dir
shuffledir="D:/PICTURES/ANIME"

# Crop mode
# --crop_mode normal/fit/fill
crop_mode="normal"

# Crop offset
# Only affects normal mode.
# --crop_offset northwest/north/northeast/west/center
#               east/southwest/south/southeast
crop_offset="center"

# Font width
# Used when calculating dynamic image size
font_width=8

# Right gap between image and text
# --gap num
gap=1

# Image offsets
# --xoffset px
# --yoffset px
yoffset=12
xoffset=14


# }}}


# Other Options {{{


# Take a screenshot
# --scrot on/off
scrot="off"

# Screenshot program to launch
# --scrotcmd
scrotcmd="scrot -c -d 3"

# Scrot dir
# Where to save the screenshots
# --scrotdir /path/to/screenshot/folder
scrotdir="C:\Users\Erin\Desktop"

# Scrot filename
# What to name the screenshots
# --scrot str
scrotname="fetch-%Y-%m-%d-%H:%M.png"


# }}}


# }}}


# Gather Info {{{


# Get Operating System Type
case "$(uname)" in
    "Linux")
        os="Linux"
    ;;

    "Darwin")
        os="Mac OS X"
    ;;

    "CYGWIN"*)
        os="Windows"
    ;;
esac

# Get Distro
case "$os" in
    "Linux" )
        if type -p crux >/dev/null 2>&1; then
            distro="CRUX"
        else
            distro="$(grep -h '^NAME=' /etc/*ease)"
            distro=${distro#NAME\=*}
            distro=${distro#\"*}
            distro=${distro%*\"}
        fi
    ;;

    "Mac OS X")
        distro="Mac OS X $(sw_vers -productVersion)"
    ;;

   "Windows")
        case "$(cmd /c ver)" in
            *"XP"*)
                distro="Windows XP"
            ;;

            *"7"*)
                distro="Windows 7"
            ;;

            *"8.1"*)
                distro="Windows 8.1"
            ;;

            *"8"*)
                distro="Windows 8"
            ;;

            *"10"*)
                distro="Windows 10"
            ;;

            *)
                distro="Windows"
            ;;
        esac
    ;;

    *)
        distro="Unknown"
    ;;
esac

# Get Title
gettitle () {
    title="${USER}@$(hostname)"
}

# Get kernel version
getkernel() {
    kernel="$(uname -r)"
}

# Get uptime
getuptime () {
    case "$os" in
        "Linux")
            uptime="$(uptime -p)"
        ;;

        "Mac OS X")
            # Get boot time in seconds
            boot="$(sysctl -n kern.boottime)"
            boot=${boot/{ sec = /}
            boot=${boot/,*}

            # Get current date in seconds
            now=$(date +%s)
            uptime=$((now - boot))

            # Convert uptime to days/hours/mins
            mins=$((uptime / 60%60))
            hours=$((uptime / 3600%24))
            days=$((uptime / 86400))

            case "$mins" in
                0) ;;
                1) uptime="up ${mins} minute" ;;
                *) uptime="up ${mins} minutes" ;;
            esac

            case "$hours" in
                0) ;;
                1) uptime="up ${hours} hour, ${uptime/up /}" ;;
                *) uptime="up ${hours} hours, ${uptime/up /}" ;;
            esac

            case "$days" in
                0) ;;
                1) uptime="up ${days} day, ${uptime/up /}" ;;
                *) uptime="up ${days} days, ${uptime/up /}" ;;
            esac
        ;;

        "Windows")
            uptime=$(uptime | awk -F ':[0-9]{2}+ |(, ){1}+' '{printf $2}')
            uptime=${uptime/  / }
        ;;

        *)
            uptime="Unknown"
        ;;

    esac

    if [ "$uptime_shorthand" == "on" ]; then
        uptime=${uptime/up/}
        uptime=${uptime/minutes/mins}
        uptime=${uptime# }
    fi
}

# Get package count
getpackages () {
    case "$distro" in
        "Arch Linux" | "Parabola GNU/Linux-libre" | "Manjaro" | "Antergos")
            packages="$(pacman -Q | wc -l)"
        ;;

        "void")
            packages="$(xbps-query -l | wc -l)"
        ;;

        "Ubuntu" | "Mint" | "Debian" | "Kali Linux" | "Deepin Linux")
            packages="$(dpkg --get-selections | grep -v deinstall$ | wc -l)"
        ;;

        "Slackware")
            packages="$(ls -1 /var/log/packages | wc -l)"
        ;;

        "Gentoo" | "Funtoo")
            packages="$(ls -d /var/db/pkg/*/* | wc -l)"
        ;;

        "Fedora" | "openSUSE"|"Red Hat Enterprise Linux"|"CentOS")
            packages="$(rpm -qa | wc -l)"
        ;;

        "CRUX")
            packages="$(pkginfo -i | wc -l)"
        ;;

        "Mac OS X"*)
            packages="$(pkgutil --pkgs | wc -l)"
            packages=${packages//[[:blank:]]/}
        ;;

        "Windows"*)
            packages=$(cygcheck -cd | wc -l)
        ;;

        *)
            packages="Unknown"
        ;;
    esac
}

# Get shell
getshell () {
    shell="$SHELL"
}

# Get window manager
getwindowmanager () {
    if [ "$use_wmctrl" == "on" ]; then
        windowmanager="$(wmctrl -m | head -n1)"
        windowmanager=${windowmanager/Name: /}

    elif [ "$XDG_CURRENT_DESKTOP" ]; then
        windowmanager="$XDG_CURRENT_DESKTOP"

    elif [ -e "$HOME/.xinitrc" ]; then
        xinitrc=$(grep "^[^#]*exec" "${HOME}/.xinitrc")
        windowmanager="${xinitrc/exec /}"
        windowmanager="${windowmanager/-session/}"
        windowmanager="${windowmanager^}"

    else
        case "$os" in
            "Mac OS X")
                windowmanager="Quartz Compositor"
            ;;

            "Windows")
                windowmanager="Explorer"
            ;;

            *)
                windowmanager="Unknown"
            ;;

        esac
    fi
}

# Get cpu
getcpu () {
    case "$os" in
        "Linux")
            # Get cpu name
            cpu="$(grep -F 'model name' /proc/cpuinfo)"
            cpu=${cpu/model name*: /}
            cpu=${cpu/ @*/}

            # Get cpu speed
            speed_type=${speed_type/rent/}
            read -r speed < \
                /sys/devices/system/cpu/cpu0/cpufreq/scaling_${speed_type}_freq

            # Convert mhz to ghz without bc
            speed=$((speed / 100000))
            speed=${speed:0:1}.${speed:1}
            cpu="$cpu @ ${speed}GHz"
        ;;

        "Mac OS X")
            cpu="$(sysctl -n machdep.cpu.brand_string)"
        ;;

        "Windows")
            # Get cpu name
            cpu="$(grep -F 'model name' /proc/cpuinfo)"
            cpu=${cpu/model name*: /}
            cpu=${cpu/ @*/}
            cpu=${cpu//  /}
            cpu=${cpu% }

            # Get cpu speed
            speed=$(grep -F 'cpu MHz' /proc/cpuinfo)
            speed=${speed/cpu MHz*: /}
            speed=${speed/\./}

            # Convert mhz to ghz without bc
            speed=$((speed / 100000))
            speed=${speed:0:1}.${speed:1}
            cpu="$cpu @ ${speed}GHz"
        ;;

        *)
            cpu="Unknown"
        ;;
    esac

    # Remove uneeded patterns from cpu output
    # This is faster than sed/gsub
    cpu=${cpu//(tm)/}
    cpu=${cpu//(TM)/}
    cpu=${cpu//(r)/}
    cpu=${cpu//(R)/}
    cpu=${cpu// CPU/}
    cpu=${cpu// Processor/}
    cpu=${cpu// Six-Core/}
}

# Get memory
getmemory () {
    case "$os" in
        "Linux")
            # Read first 3 lines
            exec 6< /proc/meminfo
            read -r memtotal <&6
            read -r memfree <&6
            read -r memavail <&6
            exec 6<&-

            # Do some substitution on each line
            memtotal=${memtotal/MemTotal:/}
            memtotal=${memtotal/kB*/}
            memtotal=${memtotal// /}
            memfree=${memfree/MemFree:/}
            memfree=${memfree/kB*/}
            memfree=${memfree// /}
            memavail=${memavail/MemAvailable:/}
            memavail=${memavail/kB*/}
            memavail=${memavail// /}

            memused=$((memtotal - memavail))
            memory="$((memused / 1024))MB / $((memtotal / 1024))MB"
        ;;

        "Mac OS X")
            memtotal=$(printf "%s\n" "$(sysctl -n hw.memsize)"/1024^2 | bc)
            memwired=$(vm_stat | awk '/wired/ { print $4 }')
            memactive=$(vm_stat | awk '/active / { print $3 }')
            memcompressed=$(vm_stat | awk '/occupied/ { print $5 }')
            memused=$(((${memwired//.} + \
                        ${memactive//.} + \
                        ${memcompressed//.}) * 4 / 1024))
            memory="${memused}MB / ${memtotal}MB"
        ;;

        "Windows")
            mem="$(awk 'NR < 3 {printf $2 " "}' /proc/meminfo)"

            # Split the string above into 2 vars
            # This is faster than using an array.
            set $mem

            memtotal=$1
            memfree=$2
            memavail=$((memtotal - memfree))
            memused=$((memtotal - memavail))
            memory="$((${memused%% *} / 1024))MB / "
            memory+="$((${memtotal%% *} / 1024))MB"
        ;;

        *)
            memory="Unknown"
        ;;
    esac
}

# Get song
getsong () {
    song=$(mpc current 2>/dev/null || printf "%s" "Unknown")
}

# Get Resolution
getresolution () {
    case "$os" in
        "Linux")
            resolution=$(xdpyinfo | awk '/dimensions:/ {printf $2}')
        ;;

        "Mac OS X")
            resolution=$(system_profiler SPDisplaysDataType |\
                        awk '/Resolution:/ {print $2"x"$4" "}')
        ;;

        *)
            resolution="Unknown"
        ;;
    esac
}

getcols () {
    if [ "$color_blocks" == "on" ]; then
        printf "${padding}%s"
        while [ $start -le $end ]; do
            printf "\e[48;5;${start}m%${block_width}s"
            start=$((start + 1))

            # Split the blocks at 8 colors
            [ $end -ge 9 ] && [ $start -eq 8 ] && \
                printf "\n%s${clear}${padding}"
        done

        # Clear formatting
        printf "%b%s" "$clear"
    fi
}


# Windows Specific Functions

getvisualstyle () {
    case "$os" in
        "Windows XP")

        ;;

        "Windows"*)
            path="/proc/registry/HKEY_CURRENT_USER/Software/Microsoft"
            path+="/Windows/CurrentVersion/Themes/CurrentTheme"
            visualstyle="$(head -n1 $path)"
            visualstyle="${visualstyle##*\\}"
            visualstyle="${visualstyle%.*}"
            visualstyle="${visualstyle^}"
        ;;

        *)
            visualstyle="This feature only works on Windows"
        ;;
    esac
}


# }}}


# Images {{{


getwallpaper () {
    case "$os" in
        "Linux")
            img="$(awk -F\' '/feh/ {printf $2}' $HOME/.fehbg)"
        ;;

        "Windows")
            case "$distro" in
                "Windows XP")
                    img="/cygdrive/c/Documents and Settings/${USER}"
                    img+="/Local Settings/Application Data/Microsoft"
                    img+="/Wallpaper1.bmp"
                ;;

                "Windows"*)
                    img="D:/PICTURES/ANIME/WALLPAPERS"
                    img+="/howlsflowers1.png"
                ;;
            esac
        ;;
    esac
}

getshuffle () {
    img="$(find "$shuffledir" -type f \( -name '*.jpg' -o -name '*.png' \) -print0 |
    shuf -n1 -z)"
}

getimage () {
    # Make the directory if it doesn't exist
    mkdir -p "$imgtempdir"

    # Image size is half of the terminal
    imgsize=$((columns * font_width / split_size))

    # Where to draw the image
    case "$image_position" in
        "left")
            # Padding is half the terminal width + gap
            padding="\e[$((columns / split_size + gap))C"
        ;;

        "right")
            padding="\e[0C"
            xoffset=$((columns * font_width / split_size - gap))
        ;;
    esac

    # If wall=on, Get image to display from current wallpaper.
    case "$image" in
        "wall")
            getwallpaper
        ;;

        "shuffle")
            getshuffle
        ;;

        *)
            img="$image"
        ;;
    esac

    # Get name of image and prefix it with it's crop mode and offset
    imgname="$crop_mode-$crop_offset-$imgsize-${img##*/}"

    # Check to see if the thumbnail exists before we do any cropping.
    if [ ! -f "$imgtempdir/$imgname" ]; then
        # Get image size so that we can do a better crop
        size=$(identify -format "%w %h" "$img")
        width=${size%% *}
        height=${size##* }

        # This checks to see if height is geater than width
        # so we can do a better crop of portrait images.
        if [ $height -gt $width ]; then
            size=$width
        else
            size=$height
        fi

        case "$crop_mode" in
            fit)
                c=$(convert "$img" \
                    -colorspace srgb \
                    -format "%[pixel:p{0,0}]" info:)

                convert \
                    "$img" \
                    -trim +repage \
                    -gravity south \
                    -background "$c" \
                    -extent "$size"x"$size" \
                    -scale "$imgsize"x"$imgsize" \
                    "$imgtempdir/$imgname"
            ;;

            fill)
                convert \
                    "$img" \
                    -trim +repage \
                    -scale "$imgsize"x"$imgsize"^ \
                    -extent "$imgsize"x"$imgsize" \
                    "$imgtempdir/$imgname"
            ;;

            *)
                convert \
                    "$img" \
                    -gravity $crop_offset \
                    -crop "$size"x"$size"+0+0 \
                    -quality 95 \
                    -scale "$imgsize"x"$imgsize" \
                    "$imgtempdir/$imgname"
            ;;

        esac
    fi

    # The final image
    img="$imgtempdir/$imgname"
}

takescrot () {
    $scrotcmd "$scrotdir/$scrotname"
}


# }}}


# Text Formatting {{{


underline () {
    underline=$(printf %"$length"s)
    underline=${underline// /$underline_char}
}

colors () {
    title_color="\e[38;5;${title_color}m"
    subtitle_color="\e[38;5;${subtitle_color}m"
    colon_color="\e[38;5;${colon_color}m"
    underline_color="\e[38;5;${underline_color}m"
    info_color="\e[38;5;${info_color}m"
}

bold () {
    if [ "$bold" == "on" ]; then
        bold="\e[1m"
    else
        bold=""
    fi
}

clear="\e[0m"


# }}}


# Usage {{{


usage () { cat << EOF

 usage: ${0##*/} [--colors 1 2 3 4 5] [--kernel "\$\(uname -rs\)"]

    Info:
    --title string         Change the title at the top
    --distro string/cmd    Manually set the distro
    --kernel string/cmd    Manually set the kernel
    --uptime string/cmd    Manually set the uptime
    --uptime_shorthand on/off --v
                           Shorten the output of uptime
    --packages string/cmd  Manually set the package count
    --shell string/cmd     Manually set the shell
    --winman string/cmd    Manually set the window manager
    --use_wmctrl on/off    Use wmctrl for a more accurate reading
    --cpu string/cmd       Manually set the cpu name
    --memory string/cmd    Manually set the memory
    --speed_type           Change the type of cpu speed to get
                           Possible values: current, min, max
    --song string/cmd      Manually set the current song

    Text Colors:
    --colors 1 2 3 4 5     Change the color of text
                           (title, subtitle, colon, underline, info)
    --title_color num      Change the color of the title
    --subtitle_color num   Change the color of the subtitle
    --colon_color num      Change the color of the colons
    --underline_color num  Change the color of the underlines
    --info_color num       Change the color of the info

    Text Formatting:
    --underline on/off     Enable/Disable title underline
    --underline_char char  Character to use when underlineing title
    --line_wrap on/off     Enable/Disable line wrapping
    --bold on/off          Enable/Disable bold text
    --prompt_height num    Set this to your prompt height to fix
                           issues with the text going off screen at the top

    Color Blocks:
    --color_blocks on/off  Enable/Disable the color blocks
    --block_width num      Width of color blocks
    --block_range start end --v
                           Range of colors to print as blocks

    Image:
    --image                Image source. Where and what image we display.
                           Possible values: wall, shuffle, /path/to/img, off
    --shuffledir           Which directory to shuffle for an image.
    --font_width px        Used to automatically size the image
    --image_position       Where to display the image: (Left/Right)
    --split_size num       Width of img/text splits
                           A value of 2 makes each split half the terminal
                           width and etc
    --crop_mode            Which crop mode to use
                           Takes the values: normal, fit, fill
    --crop_offset value    Change the crop offset for normal mode.
                           Possible values: northwest, north, northeast,
                           west, center, east, southwest, south, southeast

    --xoffset px           How close the image will be
                           to the left edge of the window
    --yoffset px           How close the image will be
                           to the top edge of the window
    --gap num              Gap between image and text right side
                           to the top edge of the window
    --clean                Remove all cropped images

    Screenshot:
    --scrot                Take a screenshot
    --scrotdir             Directory to save the scrot
    --scrotfile            File name of scrot
    --scrotcmd             Screenshot program to launch

    Other:
    --help                 Print this text and exit

EOF
exit 1
}


# }}}


# Args {{{


while [ "$1" ]; do
    case $1 in
        # Info
        --title) title="$2" ;;
        --os) os="$2" ;;
        --kernel) kernel="$2" ;;
        --uptime) uptime="$2" ;;
        --uptime_shorthand) uptime_shorthand="$2" ;;
        --packages) packages="$2" ;;
        --shell) shell="$2" ;;
        --winman) windowmanager="$2" ;;
        --use_wmctrl) use_wmctrl="$2" ;;
        --cpu) cpu="$2" ;;
        --speed_type) speed_type="$2" ;;
        --memory) memory="$2" ;;
        --song) song="$2" ;;

        # Text Colors
        --colors) title_color=$2
            [ "$3" ] && subtitle_color=$3
            [ "$4" ] && colon_color=$4
            [ "$4" ] && underline_color=$5
            [ "$5" ] && info_color=$6 ;;
        --title_color) title_color=$2 ;;
        --subtitle_color) subtitle_color=$2 ;;
        --colon_color) colon_color=$2 ;;
        --underline_color) underline_color=$2 ;;
        --info_color) info_color=$2 ;;

        # Text Formatting
        --underline) underline="$2" ;;
        --underline_char) underline_char="$2" ;;
        --line_wrap) line_wrap="$2" ;;
        --bold) bold="$2" ;;
        --prompt_height) prompt_height="$2" ;;

        # Color Blocks
        --color_blocks) color_blocks="$2" ;;
        --block_range) start=$2; end=$3 ;;
        --block_width) block_width="$2" ;;

        # Image
        --image) image="$2" ;;
        --shuffledir) shuffledir="$2" ;;
        --font_width) font_width="$2" ;;
        --image_position) image_position="$2" ;;
        --split_size) split_size="$2" ;;
        --crop_mode) crop_mode="$2" ;;
        --crop_offset) crop_offset="$2" ;;
        --xoffset) xoffset="$2" ;;
        --yoffset) yoffset="$2" ;;
        --gap) gap="$2" ;;
        --clean) rm -rf "$imgtempdir" || exit ;;

        # Screenshot
        --scrot | -s) scrot="on" ;;
        --scrotdir) scrot="$2" ;;
        --scrotfile) scrot="$2" ;;
        --scrotcmd) scrot="$2" ;;

        # Other
        --help) usage ;;
    esac

    shift
done


# }}}


# Print Info {{{


printinfo () {
    for info in "${info[@]}"; do
        function=${info#*: }
        subtitle=${info%:*}

        case "$info" in
            echo:*:*)
                info=${function#*: }
                subtitle=${function/:*/}
                string="${bold}${subtitle_color}${subtitle}${clear}"
                string+="${colon_color}: ${info_color}${info}"
                length=${#function}
            ;;

            echo:*)
                string="${info_color}${function}"
                length=${#function}
            ;;

            title:*)
                string="${bold}${title_color}${function}"
                length=${#function}
            ;;

            linebreak)
                string=""
            ;;

            underline)
                if [ "$underline" == "on" ]; then
                    underline
                    string="${underline_color}${underline}"
                fi
            ;;

            *:*|*)
                # Update the var
                var=${function/get/}
                typeset -n output=$var

                # Call the function
                [ -z "$output" ] && $function
            ;;&

            gettitle)
                string="${bold}${title_color}${output}"
                length=${#output}
            ;;

            *:*)
                string="${bold}${subtitle_color}${subtitle}${clear}"
                string+="${colon_color}: ${info_color}${output}"
                length=$((${#subtitle} +  ${#output} + 2))
            ;;

            *)
                string="$output"
                length=${#output}
            ;;

        esac

        printf "%b%s\n" "${padding}${string}${clear}"
    done
}


# }}}


# Call Functions and Finish Up {{{


# Get lines and columns
termsize=$(printf "lines \n cols" | tput -S)
termsize=${termsize/$'\n'/ }
lines=${termsize% *}
columns=${termsize#* }

# Get image
[ "$image" != "off" ] && getimage

# Clear the terminal and hide the cursor
printf "\e[?25l"
clear

# Disable line wrap
[ "$line_wrap" == "off" ] && printf '\e[?7l'

# Call functions and display info
colors
bold
printinfo

# Display the image
[ "$image" != "off" ] && \
    printf "%b%s" "0;1;$xoffset;$yoffset;$imgsize;$imgsize;;;;;$img\n4;\n3;" |\
    $w3m_img_path

# Enable line wrap again
[ "$line_wrap" == "off" ] && printf '\e[?7h'

# Move cursor to bottom and redisplay it.
printf "%b%s" "\e[${lines}H\e[${prompt_height}A\e[?25h"

# If enabled take a screenshot
[ "$scrot" == "on" ] && takescrot


# }}}


