#!/usr/bin/env bash

###########################################################
# Initial config script for the writerdeckOS v2.0         #
# Assumes fresh install of Debian 12.12.0 "Bookworm"      #
# Run from the user created during installation.          #
###########################################################

###########################################################
# Table of Contents of this Build Script                  #
#                                                         #
# Variables - Establish script variables                  #
# Greetings - Say hello to user                           #
# Dependencies - Escalate to root & install dependencies  #
# Word Perfect - Install Word Perfect for *nix            #
# Tmux - Configure Tmux. Note: Edit to change title bar   #
# Startup - Have device boot directly into word processor #
# Editor - Set the EDITOR environmental variable          #
# Autologin - Enable Autologin on device                  #
# Hostname - Update device hostname                       #
# Default Folders - Set default folders for users         #
# Automount - Configure USB to automount in terminal      #
# GRUB Boot - Tweak GRUB boot                             #
# wdmenu - Place wdmenu script into the PATH              #
# Bash Message - Change message above "dev" mode          #
# Reboot                                                  #
#                                                         #
###########################################################

# Variables - Uncomment for the word processor you want the system to boot directly into.
# Only one choice allowed. Please comment out any other selection.

# WORDP=/usr/bin/tilde	# Tilde Word Processor
WORDP=/usr/bin/wordgrinder # WordGrinder Word Processor (Default)
# WORDP=/usr/bin/wp	# Word Perfect Word Processor
# WORDP=/usr/bin/joe	# Joe Text Editor
# WORDP=/usr/bin/emacs	# Emacs Text Editor
# WORDP=/usr/bin/vi	# VI Text Editor
# WORDP=/usr/bin/vim	# VIM Text Editor
# WORDP=/usr/bin/nano	# Nano Text Editor
# WORDP=/usr/bin/micro	# Micro Text Editor
# WORDP=/usr/bin/custom	# Change out "custom" for a text editor or program of your choice that you've installed
# WORDP=/full/path/app	# Change out full path if you've installed an editor or program outside of /usr/bin/

# Greetings
echo
echo "Welcome to the writerdeckOS v2.0 build script! Let's turn this device into a Writer Deck!"
echo

# Dependencies - Escalate to root, install dependencies
echo "Please enter the password for 'root' that you created during the installation of the base OS:"

su -m -c 'echo; echo "Adding dependencies and installing base applications."; echo; \
	apt update; \
	while read APP; do apt install -y $APP; done < dependencies.list; \

# Add user to sudoers group and disable need for password \
	echo; \
	echo "Adding user to sudoers and removing requirement for password input:"; \
	echo "$USER ALL = NOPASSWD : ALL" | EDITOR="tee -a" /usr/sbin/visudo;'

# Word Perfect - Install Tavis Ormandy's port of Word Perfect for Unix from binary
# Optional. Uncomment for installation. Commenting because this is installing from binary and may change.
# Because this is installing from binary, verify then update the binaryURL variable below.

binaryURL='https://github.com/taviso/wpunix/releases/download/v0.13/wordperfect8_i386.deb'
wget -O /tmp/wpunixinstall.deb $binaryURL
sudo dpkg --add-architecture i386
sudo apt install -y /tmp/wpunixinstall.deb
rm /tmp/wpunixinstall.deb

# Tmux - Set Tmux to run at startup and configure tmux
# Tmux is used to create the title line at the top of the screen and includes things like battery charge amount, etc.

sudo touch /etc/tmux.conf

echo "# Set tmux status bar on top" | sudo tee -a /etc/tmux.conf
echo "set -g status-position top" | sudo tee -a /etc/tmux.conf
echo "" | sudo tee -a /etc/tmux.conf
echo "# Clear out default status bar" | sudo tee -a /etc/tmux.conf
echo "set -g status-left ''" | sudo tee -a /etc/tmux.conf
echo "set -g status-right ''" | sudo tee -a /etc/tmux.conf
echo "set -g window-status-current-format ''" | sudo tee -a /etc/tmux.conf
echo "set -g window-status-format ''" | sudo tee -a /etc/tmux.conf
echo "" | sudo tee -a /etc/tmux.conf
echo "# Set out max char length" | sudo tee -a /etc/tmux.conf
echo "set -g status-left-length 100" | sudo tee -a /etc/tmux.conf
echo "set -g status-right-length 100" | sudo tee -a /etc/tmux.conf
echo "" | sudo tee -a /etc/tmux.conf
echo "# Set background and foreground colors" | sudo tee -a /etc/tmux.conf
echo "set -g status-bg black" | sudo tee -a /etc/tmux.conf
echo "set -g status-fg white" | sudo tee -a /etc/tmux.conf
echo "" | sudo tee -a /etc/tmux.conf
echo "# Set status" | sudo tee -a /etc/tmux.conf
echo "set -g status-left 'writerdeckOS v2.0'" | sudo tee -a /etc/tmux.conf
echo "set -g status-right \"Battery: #(acpi | cut -d ':' -f 2 | cut -d ' ' -f 3)\"" | sudo tee -a /etc/tmux.conf

echo '' | sudo tee -a /etc/bash.bashrc
echo '# Call Tmux to load at startup.' | sudo tee -a /etc/bash.bashrc
echo 'if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then' | sudo tee -a /etc/bash.bashrc
echo '  tmux attach-session -t default || tmux new-session -s default' | sudo tee -a /etc/bash.bashrc
echo 'fi' | sudo tee -a /etc/bash.bashrc

# Startup - Set designated word processor to run at startup. (You can change this by altering the WORDP variable at the beginning of this script.)
sudo touch /usr/bin/texteditor.conf
echo -e "$WORDP" | sudo tee /usr/bin/texteditor.conf
sudo chmod +x /usr/bin/texteditor.conf

echo "" | sudo tee -a /etc/profile
echo "# Boot directly into Word Processor by calling /usr/bin/texteditor.conf" | sudo tee -a /etc/profile 
echo "# To change to a different word processor or text editor, edit the entry with the full path in /usr/bin/texteditor.conf" | sudo tee -a /etc/profile
echo "/usr/bin/texteditor.conf" | sudo tee -a /etc/profile

# Editor - Set the environmental variable EDITOR to match the default word processor. Used for tuifi program.
echo '' | sudo tee -a /etc/profile
echo '# Set environmental variable EDITOR to match the default word processor. Used for tuifi program.' | sudo tee -a /etc/profile
echo 'export EDITOR=$(cat /usr/bin/texteditor.conf)' | sudo tee -a /etc/profile

# Autologin - Enable Autologin
sudo sed -i '39s,.*,ExecStart=-/sbin/agetty --noissue --autologin author %I $TERM,' /lib/systemd/system/getty@.service

# Hostname - Update hostname
echo "writerdeckOS" | sudo tee /etc/hostname
sudo sed -i '1 a 127.0.1.1\twriterdeckOS' /etc/hosts

# Default Folders - Set Default Folders for users
sudo mkdir /etc/skel/Documents
if [ ! -d /home/$USER/Documents ]; then mkdir /home/$USER/Documents; fi

# Automount - Enable USB Automount and Create Symlink in Home Folder
echo '' | sudo tee -a /etc/profile
echo '# Enable USB Automount and Create Symlink in Home Folder' | sudo tee -a /etc/profile
echo '/usr/bin/udiskie -N -F --no-notify-command >/dev/null 2>&1 &' | sudo tee -a /etc/profile
echo 'if [ ! -L /home/$USER/USBs ]; then ln -s /media/$USER/ /home/$USER/USBs; fi' | sudo tee -a /etc/profile
# Check to see if folder is permissioned to user, if need be add a chown here

# GRUB Config Tweaks
# Remove grub splashscreen to speed up boot time
sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
sudo update-grub

# Place the wdmenu script into the path
sudo cp wdmenu.sh /usr/bin/wdmenu
sudo chmod +xr /usr/bin/wdmenu

# Check how laptop works with shutting lid.
# Turn off suspend/shutdown when lid is closed if need be

# Bash Message - Change Bash Message
echo '' | sudo tee -a /etc/profile
echo '# Bash Message' | sudo tee -a /etc/profile
echo "echo '                                                       '" | sudo tee -a /etc/profile
echo "echo '           _   _             _         _   _____ _____ '" | sudo tee -a /etc/profile
echo "echo ' _ _ _ ___|_|_| |_ ___ ___ _| |___ ___| |_|     |   __|'" | sudo tee -a /etc/profile
echo "echo '| | | |  _| |_   _| -_|  _| . | -_|  _|  /|  |  |__   |'" | sudo tee -a /etc/profile
echo "echo '|_____|_| |_| |_| |___|_| |___|___|___|_-\|_____|_____|'" | sudo tee -a /etc/profile
echo "echo '                                                       '" | sudo tee -a /etc/profile
echo 'echo "Welcome to writerdeckOS dev mode."' | sudo tee -a /etc/profile
echo 'echo "Below is a standard Bash CLI. You can run Bash commands."' | sudo tee -a /etc/profile
echo 'echo ""' | sudo tee -a /etc/profile
echo 'echo "You can also run the writerdeckOS menu to change the default word processor and access the internet or wifi."' | sudo tee -a /etc/profile
echo 'echo "Run: wdmenu - to access the writerdeckOS menu."' | sudo tee -a /etc/profile
echo 'echo ""' | sudo tee -a /etc/profile

# Prompt to reboot system, then reboot
clear
read -e -p "Installation complete. Reboot? [Y/N]: " CHOICE
[[ "$CHOICE" == [Yy]* ]] && sudo reboot || echo "Please reboot when ready."






































