#!/bin/sh

#  N90_InternalUI_Restore.sh
#  
#
#  Created by Tyler on 11/8/24.
#  

# Get the macOS version and store it in a variable

# Variables
macos_version=$(sw_vers -productVersion)
#python_attempt_dir="/usr/bin/python"
#python_attempt_dir_2="/usr/bin/python3"

python_download_link="https://www.python.org/ftp/python/2.7.18/python-2.7.18-macosx10.9.pkg"

remove_script() {
    echo "Removing script..."
    rm -rf $0
}

# Text markdown types
if [[ -t 1 ]]
then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi
tty_mkbold() { tty_escape "1;$1"; }
tty_underline="$(tty_escape "4;39")"
tty_blue="$(tty_mkbold 34)"
tty_red="$(tty_mkbold 31)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

echo "Starting N90 restore..."
cd ~
printf "The following files will be downloaded: \n\n ${tty_bold}InternalUI (iOS) 7.0.4 11BB54a${tty_reset} \n\n ${tty_bold}ParrotGeek1/Pluvia${tty_reset}"
read -p "Are you sure you want to continue? (y/n): " choice
case "$choice" in
    y|Y )
        echo "Beginning installation..."
        ;;
    n|N )
        echo "Cancelling..."
        exit 0
        ;;
    * )
        echo "Failed to read input. Not a valid option."
        exit 1
        ;;
esac

if [ "$macos_version" = 10.15 ]; then
    echo "Will use python at /usr/bin/python."
else
    echo "Downloading python from https://python.org..."
    curl -L -o python_2_7_18.pkg ${python_download_link}
    sudo installer -pkg ./python_2_7_18.pkg -target /Volumes/Macintosh\ HD
    sleep 0.5
    rm -rf ./python_2_7_18.pkg
fi
    

mkdir "Internal"
cd ~/Internal

echo "Downloading Pluvia"
git clone https://github.com/parrotgeek1/Pluvia
cd Pluvia

chmod +x ./restore.sh

# USED BEFORE PLUVIA RUNS!!!
ecid=`ioreg -l -w0 | grep "USB Serial Number" | grep -m 1 "iBoot-574.4" | sed 's/^.*ECID://' | sed 's/ .*//'`
if [ "x$ecid" = x ]; then
    echo "Failed to connect to iPhone: iPhone must be connected to work."
    exit 1
else
    ./restore.sh ../iOS\ 7.0.4\ 11BB54a.ipsw
fi
