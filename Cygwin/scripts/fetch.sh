#!/usr/bin/env bash
# vim:fdm=marker
# Fetch info about your system
# https://github.com/dylanaraps/fetch
#
# Required Dependencies:
#   Bash 4.0+
#   Text formatting, dynamic image size and padding: tput
#   [Linux / BSD / Windows] Uptime detection: procps or procps-ng
#
# Optional Dependencies: (You'll lose these features without them)
#   Displaying Images: w3m + w3m-img
#   Image Cropping: ImageMagick
#   More accurate window manager detection: wmctrl
#   [ Linux / BSD ] Wallpaper Display: feh, nitrogen or gsettings
#   [ Linux / BSD ] Current Song: mpc or cmus
#   [ Linux / BSD ] Resolution detection: xorg-xdpyinfo
#
# Created by Dylan Araps
# https://github.com/dylanaraps/

# Speed up script by not using unicode
export LC_ALL=C
export LANG=c
export LANGUAGE=C


# Config Options {{{


# Info Options {{{


# Info
# What to display and in what order.
# You can use ANY bash syntax in the function below!
# For example you could use if statments to only print info
# when a condition is true!
#
# The script comes with two helper functions:
# info:
#       info "subtitle" funcname
# prin:
#       prin "Custom message to print"
#       prin "Subtitle: Custom message to print"
#       prin "Subtitle: $(date)"
#
# You can also just use printf / echo to add lines but you'll
# need to prefix your msg with "${padding}", for example:
# echo -e "${padding} My custom message here"
#
# Info functions enabled by default are:
# "title" "distro" "kernel" "uptime" "packages"
# "shell" "resolution" "windowmanager" "gtktheme"
# "gtkicons" "cpu" "gpu" "memory" "cols"
#
# Info functions that are disabled by default are:
# "resolution" "song" "visualstyle" "font" "disk"
#
# See this wiki page for more info:
# https://github.com/dylanaraps/fetch/wiki/Customizing-Info
printinfo () {

	info linebreak
    info title
	info underline
    prin "OS: Windows 7 Ultimate 64-bit"
    info "Uptime" uptime
    prin "Shell: Blackbox Zero 1.18"
    prin "WM: bbLean, Explorer"
    prin "Visual Style: Shiro Transparent"
    prin "Fonts: Inconsolata, Open Sans"
    prin "IRC Client: Hexchat"
    prin "Music Player: Foobar2000"
    prin "Icons: Numix by neiio"
    info "CPU" cpu
    prin "GPU: AMD Radeon R9 200 Series"
    info "Memory" memory
    prin "$(printf "\e[0;31m"▄▄▄"\e[0;33m"▄▄▄"\e[0;32m"▄▄▄"\e[0;36m"▄▄▄"\e[0;34m"▄▄▄"\e[0;35m"▄▄▄"\e[0;37m"▄▄▄"\e[0;30m"▄▄▄)"
    prin "$(printf "\e[1;31m"▀▀▀"\e[1;33m"▀▀▀"\e[1;32m"▀▀▀"\e[1;36m"▀▀▀"\e[1;34m"▀▀▀"\e[1;35m"▀▀▀"\e[1;37m"▀▀▀"\e[1;30m"▀▀▀)"
}


# Kernel

# Show more kernel info
# --kernel_shorthand on/off
kernel_shorthand="on"


# Distro

# Mac OS X hide/show build version
# --osx_buildversion on/off
osx_buildversion="on"


# Uptime

# Shorten the output of the uptime function
# --uptime_shorthand tiny, on, off
uptime_shorthand="on"


# Shell

# Show the path to $SHELL
# --shell_path on/off
shell_path="on"

# Show $SHELL's version
# --shell_version on/off
shell_version="off"


# CPU

# CPU speed type
# Only works on Linux with cpufreq.
# --speed_type current, min, max, bios,
# scaling_current, scaling_min, scaling_max
speed_type="max"


# GPU

# Shorten output of the getgpu funcion
# --gpu_shorthand on/off
gpu_shorthand="off"


# Gtk Theme / Icons

# Shorten output (Hide [GTK2] etc)
# --gtk_shorthand on/off
gtk_shorthand="off"


# Enable/Disable gtk2 theme/icons output
# --gtk2 on/off
gtk2="on"

# Enable/Disable gtk3 theme/icons output
# --gtk3 on/off
gtk3="on"


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

# Color of "@" symbol in title
# --at_color num
at_color=6

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
bold="off"

# Toggle title underline
# --underline on/off
underline="on"

# Underline character
# --underline_char char
underline_char="-"

# Prompt height
# You should only have to change this if your
# prompt is greater than 2 lines high.
# --prompt_height num
prompt_height=2


# }}}

# Image Options {{{


# Image Source
# --image wall, shuffle, ascii, /path/to/img, off
image="wall"

# Thumbnail directory
imgtempdir="$HOME/.fetchimages"

# Image Backend
# Which program to draw images with
# --image_backend w3m, iterm2
image_backend="w3m"

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
# Only works with the w3m backend
# --image_position left/right
image_position="left"

# Shuffle dir
shuffledir="$HOME/Pictures"

# Crop mode
# --crop_mode normal/fit/fill
crop_mode="normal"

# Crop offset
# Only affects normal mode.
# --crop_offset northwest/north/northeast/west/center
#               east/southwest/south/southeast
crop_offset="west"

# Font width
# Used when calculating dynamic image size
font_width=7

# Right gap between image and text
# --gap num
gap=2

# Image offsets
# --xoffset px
# --yoffset px
yoffset=25
xoffset=19

# }}}

# Ascii Options {{{


# Default ascii image to use
# When this is set to distro it will use your
# distro's logo as the ascii.
# --ascii 'distro', path/to/ascii
ascii="distro"

# Ascii color
# When this is set to distro it will use your
# ditro's colors to color the ascii.
# --ascii_color distro, number
ascii_color="distro"


# }}}

# Other Options {{{


# Whether or not to always take a screenshot
# You can manually take a screenshot with "--scrot" or "-s"
scrot="off"

# Screenshot program to launch
# --scrot_cmd
scrot_cmd="scrot -c -d 3"

# Scrot dir
# Where to save the screenshots
# --scrot_dir /path/to/screenshot/folder
scrot_dir="$HOME/Pictures"

# Scrot filename
# What to name the screenshots
# --scrot_name str
scrot_name="fetch-%Y-%m-%d-%H:%M.png"


# }}}


# }}}


# Gather Info {{{


# Operating System {{{

case "$(uname)" in
    "Linux")
        os="Linux"
    ;;

    "Darwin")
        os="Mac OS X"
    ;;

    "OpenBSD")
        os="OpenBSD"
    ;;

    *"BSD")
        os="BSD"
    ;;

    "CYGWIN"*)
        os="Windows"
    ;;

    *)
        printf "%s\n" "Couldn't detect OS, exiting"
        exit
    ;;
esac

# }}}

# Distro {{{

case "$os" in
    "Linux" )
        if type -p lsb_release >/dev/null 2>&1; then
            distro="$(lsb_release -a 2>/dev/null | awk -F':' '/Description/ {printf $2}')"
            distro=${distro/[[:space:]]}
        elif type -p crux >/dev/null 2>&1; then
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

        [ "$osx_buildversion" == "on" ] && \
            distro+=" $(sw_vers -buildVersion)"
    ;;

    "OpenBSD")
        distro="OpenBSD"
    ;;

    "BSD")
        distro="$(uname -v)"
        distro=${distro%% *}
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
ascii_distro="$distro"

# }}}

# Title {{{

gettitle () {
    title="${USER}@$(hostname)"
}

# }}}

# Kernel {{{

getkernel() {
    case "$kernel_shorthand" in
        "on")  kernel="$(uname -r)" ;;
        "off") kernel="$(uname -srm)" ;;
    esac
}

# }}}

# Uptime {{{

getuptime () {
    case "$os" in
        "Linux")
            uptime="$(uptime -p)"
        ;;

        "Mac OS X" | *"BSD")
            # Get boot time in seconds
            boot="$(sysctl -n kern.boottime)"
            boot="${boot/{ sec = }"
            boot=${boot/,*}

            # Get current date in seconds
            now=$(date +%s)
            uptime=$((now - boot))

            # Convert uptime to days/hours/mins
            mins=$((uptime / 60%60))
            hours=$((uptime / 3600%24))
            days=$((uptime / 86400))

            # Format the output like Linux's "uptime -p" cmd.
            case "$mins" in
                0) ;;
                1) uptime="up $mins minute" ;;
                *) uptime="up $mins minutes" ;;
            esac

            case "$hours" in
                0) ;;
                1) uptime="up $hours hour, ${uptime/up }" ;;
                *) uptime="up $hours hours, ${uptime/up }" ;;
            esac

            case "$days" in
                0) ;;
                1) uptime="up $days day, ${uptime/up }" ;;
                *) uptime="up $days days, ${uptime/up }" ;;
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

    # Make the output of uptime smaller.
    case "$uptime_shorthand" in
        "on")
            uptime=${uptime/up}
            uptime=${uptime/minutes/mins}
            uptime=${uptime/minute/min}
            uptime=${uptime# }
        ;;

        "tiny")
            uptime=${uptime/up}
            uptime=${uptime/ days/d}
            uptime=${uptime/ day/d}
            uptime=${uptime/ hours/h}
            uptime=${uptime/ hour/h}
            uptime=${uptime/ minutes/m}
            uptime=${uptime/ minute/m}
            uptime=${uptime/,}
            uptime=${uptime# }
        ;;
    esac
}

# }}}

# Package Count {{{

getpackages () {
    case "$distro" in
        "Arch Linux"* | "Parabola"* | "Manjaro"* | "Antergos"*)
            packages="$(pacman -Qq --color never | wc -l)"
        ;;

        "void"*)
            packages="$(xbps-query -l | wc -l)"
        ;;

        "Ubuntu"* | "Mint"* | "Debian"* | "Kali Linux"* | "Deepin Linux"* | "elementary"*)
            packages="$(dpkg --get-selections | grep -cv deinstall$)"
        ;;

        "Slackware"*)
            packages="$(ls -1 /var/log/packages | wc -l)"
        ;;

        "Gentoo"* | "Funtoo"*)
            packages="$(ls -d /var/db/pkg/*/* | wc -l)"
        ;;

        "Fedora"* | "openSUSE"* | "Red Hat Enterprise Linux"* | "CentOS"*)
            packages="$(rpm -qa | wc -l)"
        ;;

        "CRUX")
            packages="$(pkginfo -i | wc -l)"
        ;;

        "Mac OS X"*)
            if [ -d "/usr/local/bin" ]; then
                local_packages=$(ls -l /usr/local/bin/ | grep -v "\(../Cellar/\|brew\)" | wc -l)
                packages=$((local_packages - 1))
            fi

            if type -p port >/dev/null 2>&1; then
                port_packages=$(port installed 2>/dev/null | wc -l)
                packages=$((packages + $((port_packages - 1))))
            fi

            if type -p brew >/dev/null 2>&1; then
                brew_packages=$(brew list -1 2>/dev/null | wc -l)
                packages=$((packages + brew_packages))
            fi

            if type -p pkgin >/dev/null 2>&1; then
                pkgsrc_packages=$(pkgin list 2>/dev/null | wc -l)
                packages=$((packages + pkgsrc_packages))
            fi
        ;;

        "OpenBSD" | "NetBSD")
            packages=$(pkg_info | wc -l)
        ;;

        "FreeBSD")
            packages=$(pkg info | wc -l)
        ;;

        "Windows"*)
            packages=$(cygcheck -cd | wc -l)

            # Count chocolatey packages
            if [ -d "/cygdrive/c/ProgramData/chocolatey/lib" ]; then
                choco_packages=$(ls -1 /cygdrive/c/ProgramData/chocolatey/lib | wc -l)
                packages=$((packages + choco_packages))
            fi
        ;;

        *)
            packages="Unknown"
        ;;
    esac

    packages=${packages// }
}

# }}}

# Shell {{{

getshell () {
    case "$shell_path" in
        "on")  shell="$SHELL " ;;
        "off") shell="${SHELL##*/} " ;;
    esac

    if [ "$shell_version" == "on" ]; then
        case "$shell" in
            *"bash"*)
                shell+="$(bash --version | head -n 1)"
                shell=${shell/ *, version}
            ;;

            *"zsh"*)
                shell+="$(zsh --version)"
                shell=${shell/ zsh}
            ;;

            *"mksh"* | *"ksh")
                shell+="$("$SHELL" -c 'printf "%s" "$KSH_VERSION"')"
                shell=${shell/ * KSH}
            ;;

            *"tcsh"* | *"csh"*)
                shell+="$("$SHELL" --version)"
                shell=${shell/tcsh}
                shell=${shell/\(*}
            ;;
        esac

        shell="${shell/\(*\)}"
    fi
}

# }}}

# Window Manager {{{

getwindowmanager () {
    if type -p wmctrl >/dev/null 2>&1; then
        windowmanager="$(wmctrl -m | head -n1)"
        windowmanager=${windowmanager/Name: }

    elif [ "$XDG_CURRENT_DESKTOP" ]; then
        windowmanager="$XDG_CURRENT_DESKTOP"

    elif [ "$XINITRC" ]; then
        windowmanager=$(grep "^[^#]*exec" "$XINITRC")

    elif [ -e "$HOME/.xinitrc" ]; then
        windowmanager=$(grep "^[^#]*exec" "${HOME}/.xinitrc")

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

    windowmanager="${windowmanager/exec }"
    windowmanager="${windowmanager/-session}"
    windowmanager="${windowmanager^}"
}

# }}}

# CPU {{{

getcpu () {
    case "$os" in
        "Linux")
            # Get cpu name
            cpu="$(grep -F 'model name' /proc/cpuinfo)"
            cpu=${cpu/model name*: }
            cpu=${cpu%%  *}
            cpu=${cpu/@*}

            # Get cpu speed
            if [ -d "/sys/devices/system/cpu/cpu0/cpufreq" ]; then
                case "$speed_type" in
                    current) speed_type="scaling_cur_freq" ;;
                    min) speed_type="scaling_min_freq" ;;
                    max) speed_type="scaling_max_freq" ;;
                    bios) speed_type="bios_limit" ;;
                    scaling_current) speed_type="scaling_cur_freq" ;;
                    scaling_min) speed_type="scaling_min_freq" ;;
                    scaling_max) speed_type="scaling_max_freq" ;;
                esac

                read -r speed < \
                    /sys/devices/system/cpu/cpu0/cpufreq/${speed_type}

            else
                speed=$(awk -F ': ' '/cpu MHz/ {printf $2; exit}' /proc/cpuinfo)
                speed=${speed/\.}
            fi

            # Convert mhz to ghz without bc
            speed=$((speed / 100000))
            speed=${speed:0:1}.${speed:1}

            cpu="$cpu @ ${speed}GHz"
        ;;

        "Mac OS X")
            cpu="$(sysctl -n machdep.cpu.brand_string)"
        ;;

        *"BSD")
            case "$distro" in
                "OpenBSD")
                    # Get cpu name
                    cpu="$(sysctl -n hw.model)"
                    cpu=${cpu/ @*}
                    cpu=${cpu//  }
                    cpu=${cpu% }

                    # Get cpu speed
                    speed=$(sysctl -n hw.cpuspeed)
                    speed=$((speed / 100))
                ;;

                "FreeBSD")
                    # Get cpu name
                    cpu="$(sysctl -n hw.model)"
                    cpu=${cpu/ @*}
                    cpu=${cpu//  }
                    cpu=${cpu% }

                    # Get cpu speed
                    speed="$(sysctl -n hw.clockrate)"
                    speed=$((speed / 100))
                ;;

                "NetBSD")
                    # Get cpu name
                    cpu="$(grep -F 'model name' /proc/cpuinfo)"
                    cpu=${cpu/model name*: }
                    cpu=${cpu/ @*}
                    cpu=${cpu//  }
                    cpu=${cpu% }

                    # Get cpu speed
                    speed="$(grep -F 'cpu MHz' /proc/cpuinfo)"
                    speed=${speed/cpu MHz*: }
                    speed=${speed/\.}
                    speed=$((speed / 10000))
                ;;
            esac

            speed=${speed:0:1}.${speed:1}
            cpu="$cpu @ ${speed}GHz"
        ;;

        "Windows")
            # Get cpu name
            cpu="$(grep -F 'model name' /proc/cpuinfo)"
            cpu=${cpu/model name*: }
            cpu=${cpu/ @*}
            cpu=${cpu//  }
            cpu=${cpu% }

            # Get cpu speed
            speed=$(grep -F 'cpu MHz' /proc/cpuinfo)
            speed=${speed/cpu MHz*: }
            speed=${speed/\.}

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
    cpu=${cpu//(tm)}
    cpu=${cpu//(TM)}
    cpu=${cpu//(r)}
    cpu=${cpu//(R)}
    cpu=${cpu// CPU}
    cpu=${cpu// Processor}
    cpu=${cpu// Six-Core}
    cpu=${cpu// with Radeon HD Graphics}
}

# }}}

# GPU {{{

getgpu () {
   case "$os" in
       "Linux")
            gpu="$(lspci | grep -F "VGA")"
            gpu=${gpu/* VGA compatible controller: }
            gpu=${gpu/(rev*)}

            shopt -s nocasematch
            case "$gpu" in
                intel*)
                    gpu=${gpu/Intel Corporation }
                    gpu=${gpu/Haswell-??? }

                    brand="Intel "
                ;;

                advanced*)
                    gpu=${gpu/Advanced Micro Devices, Inc\. }
                    gpu=${gpu/'[AMD/ATI]' }
                    gpu=${gpu/Tahiti PRO}
                    gpu=${gpu/Seymour}
                    gpu=${gpu/ OEM}
                    gpu=${gpu/ \[}
                    gpu=${gpu/\]}

                    brand="AMD "
                ;;

                nvidia*)
                    gpu=${gpu/NVIDIA Corporation }
                    gpu=${gpu/nVidia Corporation }
                    gpu=${gpu/G????M }
                    gpu=${gpu/G???? }
                    gpu=${gpu/\[}
                    gpu=${gpu/\]}

                    brand="Nvidia "
                ;;

                *virtualbox*)
                    gpu="VirtualBox Graphics Adapter"
                ;;
            esac

            gpu="${brand}${gpu}"
        ;;

        "Mac OS X")
            gpu=$( \
                system_profiler SPDisplaysDataType | \
                awk -F': ' '/^\ *Chipset Model:/ {printf $2}' | \
                awk '{ printf "%s / ", $0 }'
            )
            gpu=${gpu//'/ $'}
        ;;

        *"BSD")
            case "$distro" in
                "FreeBSD")
                    gpu=$(pciconf -lv 2>/dev/null | grep -B 4 "VGA" | grep "device")
                    gpu=${gpu/device*= }
                    gpu=${gpu//\'}
                    gpu=${gpu//[[:space:]]/ }
                    gpu=${gpu//  }
                ;;

                *)
                    gpu="Unknown"
                ;;
            esac
        ;;


        "Windows")
            gpu=$(wmic path Win32_VideoController get caption)
            gpu=${gpu/Caption }
            gpu=${gpu//[[:space:]]/ }
            gpu=${gpu//  }
        ;;
    esac

    if [ "$gpu_shorthand" == "on" ]; then
        gpu=${gpu// Rev\. ?}
        gpu=${gpu//AMD\/ATI/AMD}
        gpu=${gpu// Tahiti}
        gpu=${gpu// PRO}
        gpu=${gpu// OEM}
        gpu=${gpu// Mars}
        gpu=${gpu// Series}
        gpu=${gpu/\/*}
    fi
}

# }}}

# Memory {{{

getmemory () {
    case "$os" in
        "Linux")
            # Read first 3 lines
            exec 6< /proc/meminfo
            read -r memtotal <&6
            read -r memfree <&6 # We don't actually use this var
            read -r memavail <&6
            exec 6<&-

            # Do some substitution on each line
            memtotal=${memtotal/MemTotal:}
            memtotal=${memtotal/kB*}
            memavail=${memavail/MemAvailable:}
            memavail=${memavail/kB*}

            memused=$((memtotal - memavail))
            memory="$((memused / 1024))MB / $((memtotal / 1024))MB"
        ;;

        "Mac OS X")
            memtotal=$(printf "%s\n" "$(sysctl -n hw.memsize)"/1024^2 | bc)
            memwired=$(vm_stat | awk '/wired/ { print $4 }')
            memactive=$(vm_stat | awk '/active / { printf $3 }')
            memcompressed=$(vm_stat | awk '/occupied/ { printf $5 }')
            memused=$(((${wiredmem//.} + ${memactive//.} + ${memcompressed//.}) * 4 / 1024))
            memory="${memused}MB / ${memtotal}MB"
        ;;

        "OpenBSD" | "BSD")
            case "$distro" in
                "OpenBSD")
                    memtotal=$(dmesg | awk '/real mem/ {printf $5}')
                    memtotal=${memtotal/\(}
                    memtotal=${memtotal/MB\)}

                    memfree=$(top -d 1 | awk '/Real:/ {printf $6}')
                    memfree=${memfree/M}

                    memused=$((memtotal - memfree))
                    memory="${memused}MB / ${memtotal}MB"
                ;;

                "FreeBSD")
                    memtotal=$(dmesg | awk '/real mem/ {printf $5}')
                    memtotal=${memtotal/\(}
                    memtotal=${memtotal/MB\)}

                    memfree=$(top -d 1 | awk '/Mem:/ {printf $10}')
                    memfree=${memfree/M}

                    memused=$((memtotal - memfree))
                    memory="${memused}MB / ${memtotal}MB"
                ;;

                "NetBSD")
                    memfree=$(($(vmstat | awk 'END{printf $4}') / 1000))
                    memused=$(($(vmstat | awk 'END{printf $3}') / 1000))
                    memtotal=$((memused + memfree))

                    memused=$((memtotal - memfree))
                    memory="${memused}MB / ${memtotal}MB"
                ;;
            esac

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

# }}}

# Song {{{

getsong () {
    if type -p mpc >/dev/null 2>&1; then
        song="$(mpc current)"

    elif type -p cmus >/dev/null 2>&1; then
        song="$(cmus-remote -Q | grep "tag artist\|title")"
        song=${song/tag artist }
        song=${song/tag title/-}
        song=${song//[[:space:]]/ }

    else
        song="Unknown"
    fi
}

# }}}

# Resolution {{{

getresolution () {
    case "$os" in
        "Linux" | *"BSD")
            resolution=$(xdpyinfo 2>/dev/null | awk '/dimensions:/ {printf $2}')
        ;;

        "Mac OS X")
            resolution=$(system_profiler SPDisplaysDataType |\
                        awk '/Resolution:/ {printf $2"x"$4" "}')
        ;;
    esac

    [ -z "$resolution" ] && resolution="Unknown"
}

# }}}

# GTK Theme/Icons/Font {{{

getgtk () {
    case "$1" in
        theme)
            name="gtk-theme-name"
            gsettings="gtk-theme"
        ;;

        icons)
            name="gtk-icon-theme-name"
            gsettings="icon-theme"
        ;;

        font)
            name="gtk-font-name"
            gsettings="font-name"
        ;;
    esac

    # Check for gtk2 theme
    if [ "$gtk2" == "on" ]; then
        if [ -f "$HOME/.gtkrc-2.0" ]; then
            gtk2theme=$(grep "^[^#]*$name" "$HOME/.gtkrc-2.0")

        elif [ -f "/etc/gtk-2.0/gtkrc" ]; then
            gtk2theme=$(grep "^[^#]*$name" /etc/gtk-2.0/gtkrc)
        fi

        gtk2theme=${gtk2theme/${name}*=}
        gtk2theme=${gtk2theme//\"}
    fi

    # Check for gtk3 theme
    if [ "$gtk3" == "on" ]; then
        if [ -f "$HOME/.config/gtk-3.0/settings.ini" ]; then
            gtk3theme=$(grep "^[^#]*$name" "$HOME/.config/gtk-3.0/settings.ini")

        elif type -p gsettings >/dev/null 2>&1; then
            gtk3theme="$(gsettings get org.gnome.desktop.interface $gsettings)"
            gtk3theme=${gtk3theme//\'}

        else
            gtk3theme=$(grep "^[^#]*$name" /etc/gtk-3.0/settings.ini)
        fi

        gtk3theme=${gtk3theme/${name}*=}
        gtk3theme=${gtk3theme//\"}
        gtk3theme=${gtk3theme/[[:space:]]/ }
    fi

    # Format the string based on which themes exist
    if  [ "$gtk2theme" ] && [ "$gtk2theme" == "$gtk3theme" ]; then
        gtk3theme+=" [GTK2/3]"
        unset gtk2theme

    elif [ "$gtk2theme" ] && [ "$gtk3theme" ]; then
        gtk2theme+=" [GTK2], "
        gtk3theme+=" [GTK3] "
    else
        [ "$gtk2theme" ] && gtk2theme+=" [GTK2] "
        [ "$gtk3theme" ] && gtk3theme+=" [GTK3] "
    fi

    # Final string
    gtktheme="${gtk2theme}${gtk3theme}"

    # If the final string is empty print "None"
    [ -z "$gtktheme" ] && gtktheme="None"

    # Make the output shorter by removing "[GTKX]" from the string
    if [ "$gtk_shorthand" == "on" ]; then
        gtktheme=${gtktheme/ '[GTK2]'}
        gtktheme=${gtktheme/ '[GTK3]'}
        gtktheme=${gtktheme/ '[GTK2/3]'}
    fi
}

getgtktheme () {
    getgtk theme
}

getgtkicons () {
    getgtk icons
    gtkicons="$gtktheme"
}

getgtkfont () {
    getgtk font
    gtkfont="$gtktheme"
}

# }}}

# Disk Usage {{{

getdisk () {
    # df flags
    case "$os" in
        "Linux" | "Windows") df_flags="-h --total" ;;
        "Mac OS X") df_flags="-H /" ;;

        *"BSD")
            case "$os" in
                "FreeBSD") df_flags="-h -c" ;;
                *) disk="Unknown"; return ;;
            esac
        ;;
    esac

    # Get the disk info
    disk=$(df $df_flags 2>/dev/null | awk 'END{print $2 ":" $3 ":" $5}')

    # Format the output
    disk_used=${disk#*:}
    disk_used=${disk_used%%:*}
    disk_total=${disk%%:*}
    disk_total_per=${disk#*:*:}

    # Put it all together
    disk="${disk_used} / ${disk_total} (${disk_total_per})"
}

# }}}

# Terminal colors {{{

getcols () {
    if [ "$color_blocks" == "on" ]; then
        printf "${padding}%s"
        while [ $start -le $end ]; do
            printf "\033[48;5;${start}m%${block_width}s"
            start=$((start + 1))

            # Split the blocks at 8 colors
            [ $end -ge 9 ] && [ $start -eq 8 ] && \
                printf "\n%s${clear}${padding}"
        done

        # Clear formatting
        printf "%b%s" "$clear"
    fi
}

# }}}

# Windows Specific Functions {{{

getvisualstyle () {
    case "$os" in
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


# }}}


# Images {{{


# Wallpaper {{{

getwallpaper () {
    case "$os" in
        "Linux" | *"BSD")
            if type -p feh >/dev/null 2>&1 && [ -f "$HOME/.fehbg" ]; then
                img="$(awk -F\' '/feh/ {printf $2}' "$HOME/.fehbg")"

            elif type -p nitrogen >/dev/null 2>&1; then
                img="$(awk -F'=' '/file/ {printf $2}' "$HOME/.config/nitrogen/bg-saved.cfg")"

            elif type -p gsettings >/dev/null 2>&1; then
                img="$(gsettings get org.gnome.desktop.background picture-uri 2>/dev/null)"
                img=${img/'file://'}
                img=${img//\'}
            fi
        ;;

        "Mac OS X")
            img="$(osascript -e 'tell app "finder" to get posix path of (get desktop picture as text)')"
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
                    img+="/suwako_wall.png"
                ;;
            esac
        ;;
    esac
}

# }}}

# Shuffle {{{

getshuffle () {
    img=$(find "$shuffle_dir" -type f \( -name '*.jpg' -o -name '*.png' \) -print0 |
    shuf -n1 -z)
}

# }}}

# Ascii {{{

getascii () {
    # Change color of logo based on distro
    shopt -s nocasematch
    case "$ascii_distro" in
        "Arch Linux"* | "Antergos"*)
            c1=$(color 6)
            c2=$(color 4)
        ;;

        "CentOS"*)
            c1=$(color 3)
            c2=$(color 2)
            c3=$(color 4)
            c4=$(color 5)
            c5=$(color 7)
        ;;

        "CRUX")
            c1=$(color 4)
            c2=$(color 5)
            c3=$(color 7)
        ;;

        "Debian"* | "FreeBSD"*)
            c1=$(color 7)
            c2=$(color 1)
        ;;

        "elementary"*)
            c1=$(color 7)
        ;;

        "Fedora"*)
            c1=$(color 7)
            c2=$(color 4)
        ;;

        "Gentoo"* | "Funtoo"*)
            c1=$(color 7)
            c2=$(color 5)
        ;;

        "Kali"*)
            c1=$(color 4)
            c2=$(color 8)
        ;;

        "Manjaro"* | "Deepin"*)
            c1=$(color 2)
        ;;

        "Mac OS X"*)
            c1=$(color 2)
            c2=$(color 3)
            c3=$(color 1)
            c4=$(color 1)
            c5=$(color 5)
            c6=$(color 4)
        ;;

        "Mint"*)
            c1=$(color 7)
            c2=$(color 2)
        ;;

        "NetBSD"*)
            c1=$(color 5)
            c2=$(color 7)
        ;;

        "OpenBSD"*)
            c1=$(color 3)
            c2=$(color 3)
            c3=$(color 6)
            c4=$(color 1)
            c5=$(color 8)
        ;;

        "OpenSuse"*)
            c1=$(color 2)
            c2=$(color 7)
        ;;

        "Parabola"*)
            c1=$(color 5)
            c2=$(color 7)
        ;;

        "Red Hat"*)
            c1=$(color 7)
            c2=$(color 1)
        ;;

        "Slackware"*)
            c1=$(color 4)
            c2=$(color 7)
        ;;

        "Ubuntu"*)
            c1=$(color 7)
            c2=$(color 1)
            c3=$(color 3)
        ;;

        "void"*)
            c1=$(color 2)
            c2=$(color 2)
            c3=$(color 8)
        ;;

        "Windows"*)
            c1=$(color 1)
            c2=$(color 2)
            c3=$(color 4)
            c4=$(color 3)
        ;;
    esac

    if [ "$ascii" == "distro" ]; then
        # Lowercase the distro name
        ascii=${ascii_distro,,}

        # Check /usr/share/fetch for ascii before
        # looking in the script's directory.
        if [ -f "/usr/share/fetch/ascii/distro/${ascii/ *}" ]; then
            ascii="/usr/share/fetch/ascii/distro/${ascii/ *}"
        else
            # Use $0 to get the script's physical path.
            cd "${0%/*}"
            ascii_dir=${0##*/}

            # Iterate down a (possible) chain of symlinks.
            while [ -L "$ascii_dir" ]; do
                ascii_dir="$(readlink $ascii_dir)"
                cd "${ascii_dir%/*}"
                ascii_dir="${ascii_dir##*/}"
            done

            # Final directory
            ascii_dir="$(pwd -P)"

            if [ -f "$ascii_dir/ascii/distro/${ascii/ *}" ]; then
                ascii="$ascii_dir/ascii/distro/${ascii/ *}"
            else
                padding="\033[0C"
                image="off"
                return
            fi
        fi

        # Overwrite distro colors if '$ascii_color` doesn't
        # equal 'distro'.
        if [ "$ascii_color" != "distro" ]; then
            c1=$(color $ascii_color)
            c2=$(color $ascii_color)
            c3=$(color $ascii_color)
            c4=$(color $ascii_color)
            c5=$(color $ascii_color)
            c6=$(color $ascii_color)
        fi

        # We only use eval in the distro ascii files.
        print="$(eval printf "$(<"$ascii")")"
    else
        case "$ascii_color" in
            "distro") ascii_color="$c1" ;;
            *) ascii_color="$(color $ascii_color)" ;;
        esac

        print="${ascii_color}$(<"$ascii")"
    fi

    # Turn the file into a variable.
    ascii_strip=$(<$ascii)

    # Strip escape codes backslashes from contents of
    ascii_strip=${ascii_strip//\$\{??\}}
    ascii_strip=${ascii_strip//\\}

    # Get length of longest line
    length="$(LC_ALL="en_US.UTF8" wc -L 2>/dev/null <<< "$ascii_strip")"

    # Get the height in lines
    lines="$(($(LC_ALL="en_US.UTF8" wc -l 2>/dev/null <<< "$ascii_strip") + 1))"

    # Fallback to using awk on systems without 'wc -L'
    [ -z "$length" ] && \
        length="$(LC_ALL="en_US.UTF8" awk 'length>max{max=length}END{print max}' <<< "$ascii_strip")"

    # Set the text padding
    padding="\033[$((length + gap))C"

    # Print the ascii
    printf "%b%s" "$print"
}


# }}}

# Image {{{

getimage () {
    # Fallback to ascii mode if imagemagick isn't installed.
    if ! type -p convert >/dev/null 2>&1; then
        image="ascii"
    fi

    # Fallback to ascii mode if image mode is 'w3m' and 'w3m' isn't installed.
    if [ "$image_backend" == "w3m" ] && ! type -p $w3m_img_path >/dev/null 2>&1; then
        image="ascii"
    fi

    # Make the directory if it doesn't exist
    mkdir -p "$imgtempdir"

    # Image size is half of the terminal
    imgsize=$((columns * font_width / split_size))

    # Where to draw the image
    case "$image_position" in
        "left")
            # Padding is half the terminal width + gap
            padding="\033[$((columns / split_size + gap))C"
        ;;

        "right")
            padding="\033[0C"
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

        "ascii")
            getascii
            return
        ;;

        *)
            img="$image"
        ;;
    esac

    # If $img is empty, reset padding to 0 and exit the function
    if [ -z "$img" ]; then
        padding="\033[0C"
        return
    fi

    # Check to see if the image has a file extension
    case "${img##*/}" in
        *"."*)
            # Get name of image and prefix it with it's crop mode and offset
            imgname="$crop_mode-$crop_offset-$imgsize-${img##*/}"
        ;;

        *)
            # Add a file extension if the image doesn't have one. This
            # fixes w3m not being able to display them.
            imgname="$crop_mode-$crop_offset-$imgsize-${img##*/}.jpg"
        ;;
    esac

    # Check to see if the thumbnail exists before we do any cropping.
    if [ ! -f "$imgtempdir/$imgname" ]; then
        # Get image size so that we can do a better crop
        size=$(identify -format "%w %h" "$img")
        width=${size%% *}
        height=${size##* }

        # This checks to see if height is geater than width
        # so we can do a better crop of portrait images.
        if [ "$height" -gt "$width" ]; then
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

    # Lines equals terminal height
    lines=$(tput lines)

    # The final image
    img="$imgtempdir/$imgname"
}

scrot_path="$scrot_dir/$scrot_name"
takescrot () {
    $scrot_cmd "$scrot_path"
}

# }}}


# }}}


# Text Formatting {{{


# Info {{{

info () {
    # Call the function and update variable
    if [ -z "$2" ]; then
        "get$1" 2>/dev/null
        eval output="\$${1}"
    else
        "get$2" 2>/dev/null
        eval output="\$${2}"
    fi

    case "$1" in
        title)
            string="${bold}${title_color}${output}"
            string="${string/@/${at_color}@${title_color}}"
            length=${#output}
        ;;

        underline)
            string="${underline_color}${output}"
        ;;

        linebreak | cols)
            string=""
        ;;

        *)
            string="${bold}${subtitle_color}${1}${clear}"
            string+="${colon_color}: ${info_color}${output}"
            length=$((${#subtitle} +  ${#output} + 2))
        ;;
    esac

    printf "%b%s\n" "${padding}${string}${clear}"
}

# }}}

# Prin {{{

prin () {
    case "$1" in
        *:*)
            subtitle=${1%%:*}
            output=${1#*: }

            string="${bold}${subtitle_color}${subtitle}${clear}"
            string+="${colon_color}: ${info_color}${output}"
            length=$((${#subtitle} +  ${#output} + 1))
        ;;

        *)
            string="${info_color}${1}"
            length=${#1}
        ;;
    esac

    printf "%b%s\n" "${padding}${string}${clear}"
}

# }}}

# Underline {{{

getunderline () {
    underline=$(printf %"$length"s)
    underline=${underline// /$underline_char}
}

# }}}

# Colors {{{

colors () {
    title_color="\033[38;5;${title_color}m"
    at_color="\033[38;5;${at_color}m"
    subtitle_color="\033[38;5;${subtitle_color}m"
    colon_color="\033[38;5;${colon_color}m"
    underline_color="\033[38;5;${underline_color}m"
    info_color="\033[38;5;${info_color}m"
}

color () {
   printf "%b%s" "\033[38;5;${1}m"
}

# }}}

# Bold {{{

bold () {
    if [ "$bold" == "on" ]; then
        bold="\033[1m"
    else
        bold=""
    fi
}

# }}}


clear="\033[0m"


# }}}


# Usage {{{


usage () { cat << EOF

    usage: ${0##*/} --option "value"

    Info:
    --osx_buildversion     Hide/Show Mac OS X build version.
    --speed_type           Change the type of cpu speed to display.
                           Possible values: current, min, max, bios,
                           scaling_current, scaling_min, scaling_max
                           NOTE: This only support Linux with cpufreq.
    --kernel_shorthand     Shorten the output of kernel
    --uptime_shorthand     Shorten the output of uptime (tiny, on, off)
    --gpu_shorthand on/off Shorten the output of GPU
    --gtk_shorthand on/off Shorten output of gtk theme/icons
    --gtk2 on/off          Enable/Disable gtk2 theme/icons output
    --gtk3 on/off          Enable/Disable gtk3 theme/icons output
    --shell_path on/off    Enable/Disable showing \$SHELL path
    --shell_version on/off Enable/Disable showing \$SHELL version

    Text Colors:
    --colors 1 2 3 4 5 6   Change the color of text
                           (title, @, subtitle, colon, underline, info)
    --title_color num      Change the color of the title
    --at_color num         Change the color of "@" in title
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
                           Possible values: wall, shuffle, ascii,
                           /path/to/img, off
    --image_backend        Which program to use to draw images.
    --shuffle_dir           Which directory to shuffle for an image.
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
                           NOTE: This only works with w3m
    --yoffset px           How close the image will be
                           to the top edge of the window
                           NOTE: This only works with w3m
    --gap num              Gap between image and text right side
                           to the top edge of the window
                           NOTE: --gap can take a negative value which will
                           move the text closer to the left side.
    --clean                Remove all cropped images


    Ascii:
    --ascii                Where to get the ascii from, Possible values:
                           distro, /path/to/ascii
    --ascii_color          Color to print the ascii art
    --ascii_distro distro  Which Distro\'s ascii art to print


    Screenshot:
    --scrot /path/to/img   Take a screenshot, if path is left empty
                           the screenshot function will use
                           \$scrot_dir and \$scrot_name.
    --scrot_cmd            Screenshot program to launch

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
        --osx_buildversion) osx_buildversion="$2" ;;
        --speed_type) speed_type="$2" ;;
        --kernel_shorthand) kernel_shorthand="$2" ;;
        --uptime_shorthand) uptime_shorthand="$2" ;;
        --gpu_shorthand) gpu_shorthand="$2" ;;
        --gtk_shorthand) gtk_shorthand="$2" ;;
        --gtk2) gtk2="$2" ;;
        --gtk3) gtk3="$2" ;;
        --shell_path) shell_path="$2" ;;
        --shell_version) shell_version="$2" ;;

        # Text Colors
        --colors) title_color=$2
            [ "$3" ] && subtitle_color=$3
            [ "$4" ] && at_color=$4
            [ "$5" ] && colon_color=$5
            [ "$6" ] && underline_color=$6
            [ "$7" ] && info_color=$7 ;;
        --title_color) title_color=$2 ;;
        --at_color) at_color=$2 ;;
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
        --image) image="$2"
            [ -z "$2" ] && image="ascii" ;;
        --image_backend) image_backend="$2" ;;
        --shuffle_dir) shuffle_dir="$2" ;;
        --font_width) font_width="$2" ;;
        --image_position) image_position="$2" ;;
        --split_size) split_size="$2" ;;
        --crop_mode) crop_mode="$2" ;;
        --crop_offset) crop_offset="$2" ;;
        --xoffset) xoffset="$2" ;;
        --yoffset) yoffset="$2" ;;
        --gap) gap="$2" ;;
        --clean) rm -rf "$imgtempdir" || exit ;;

        # Ascii
        --ascii) image="ascii"; ascii="$2"
            [ -z "$2" ] && ascii="distro" ;;
        --ascii_color) ascii_color="$2" ;;
        --ascii_distro) ascii_distro="$2" ;;

        # Screenshot
        --scrot | -s) scrot="on"; \
            [ "$2" ] && scrot_path="$2" ;;
        --scrot_cmd) scrot_cmd="$2" ;;

        # Other
        --help) usage ;;
    esac

    shift
done


# }}}


# Call Functions and Finish Up {{{


# Restore cursor and clear screen on ctrl+c
trap 'printf "\033[?25h"; clear; exit' 2

# Get columns
columns=$(tput cols)

# Clear the terminal and hide the cursor
[ "$image" != "off" ] && clear
printf "\033[?25l"

# Get the image
[ "$image" != "off" ] && getimage

# Disable line wrap
[ "$line_wrap" == "off" ] && printf "\033[?7l"

# Display the image if enabled
if [ "$image" != "off" ] && [ "$image" != "ascii" ]; then
    case "$image_backend" in
        "w3m")
            printf "%b%s\n" "0;1;$xoffset;$yoffset;$imgsize;$imgsize;;;;;$img\n4;\n3;" |\
            $w3m_img_path 2>/dev/null || padding="\033[0C"
        ;;

        "iterm2")
            printf "%b%s\a\n" "\033]1337;File=width=${imgsize}px;height=${imgsize}px;inline=1:$(base64 < "$img")"
        ;;
    esac
fi

# Get colors / bold
colors
bold

# Move the cursor to the top and display the info
[ "$image" != "off" ] && printf "\033[0H"
printinfo

# Move the cursor to the bottom and Show the cursor
if [ "$image" != "off" ]; then
    # Set cursor position dynamically based on height of ascii/text.
    info_height="$(IFS=';' read -sdR -p $'\E[6n' ROW COL; printf "%s" "${ROW#*[}")"
    [ "$lines" -lt "$info_height" ] && lines="$info_height"

    printf "%b%s" "\033[${lines}H\033[${prompt_height}A"
fi

# Enable line wrap again
[ "$line_wrap" == "off" ] && printf "\033[?7h"

# Show the cursor
printf "%b%s" "\033[?25h"

# If enabled take a screenshot
[ "$scrot" == "on" ] && takescrot


# }}}


