#!/usr/bin/env bash

# Initial config script for the writerdeckOS v1.0
# Assumes fresh install of Debian 12.10.0 "Bookworm"

# Enable password bypass
# Note: For security purposes, this machine should not be (and is not intended to be) connected to the network.
# If connected to the network, please change the default password using the 'passwd' command.
echo "password" | sudo -S echo hello
echo 'author ALL = NOPASSWD : ALL' | sudo EDITOR='tee -a' visudo

# Enable Autologin
sudo sed -i '39s,.*,ExecStart=-/sbin/agetty --noissue --autologin author %I $TERM,' /lib/systemd/system/getty@.service

# Update hostname
echo "writerdeck" | sudo tee /etc/hostname
sudo sed -i '1 a 127.0.1.1\twriterdeck' /etc/hosts

# Set tmux to run at startup and configure tmux
touch /home/author/.tmux.conf

echo "# Set tmux status bar on top" >> /home/author/.tmux.conf
echo "set -g status-position top" >> /home/author/.tmux.conf
echo "" >> /home/author/.tmux.conf
echo "# Clear out default status bar" >> /home/author/.tmux.conf
echo "set -g status-left ''" >> /home/author/.tmux.conf
echo "set -g status-right ''" >> /home/author/.tmux.conf
echo "set -g window-status-current-format ''" >> /home/author/.tmux.conf
echo "set -g window-status-format ''" >> /home/author/.tmux.conf
echo "" >> /home/author/.tmux.conf
echo "# Set out max char length" >> /home/author/.tmux.conf
echo "set -g status-left-length 100" >> /home/author/.tmux.conf
echo "set -g status-right-length 100" >> /home/author/.tmux.conf
echo "" >> /home/author/.tmux.conf
echo "# Set background and foreground colors" >> /home/author/.tmux.conf
echo "set -g status-bg black" >> /home/author/.tmux.conf
echo "set -g status-fg white" >> /home/author/.tmux.conf
echo "" >> /home/author/.tmux.conf
echo "# Set status" >> /home/author/.tmux.conf
echo "set -g status-left 'Tinker WriterDeck v1.0'" >> /home/author/.tmux.conf
echo 'set -g status-right "Battery: #(cat /sys/class/power_supply/BAT0/capacity)\%"' >> /home/author/.tmux.conf

echo 'if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then' >> /home/author/.bashrc
echo '  tmux attach-session -t default || tmux new-session -s default' >> /home/author/.bashrc
echo 'fi' >> /home/author/.bashrc

# Enable Automount and Create Symlink to Home Folder
echo '' >> /home/author/.profile
echo '# Enable Automount and Create Symlink to Home Folder' >> /home/author/.profile
echo '/usr/bin/udiskie -N -F --no-notify-command >/dev/null 2>&1 &' >> /home/author/.profile

ln -s /media/author /home/author/USBs
mkdir /home/author/Documents
sudo chown author:author /home/author/Documents

# Remove grub splashscreen to speed up boot time
sudo sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub
sudo update-grub

# Turn off suspend/shutdown when lid is closed and add shutdown alias
sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
sudo systemctl restart systemd-logind.service

alias shutdown='sudo shutdown -h now'
echo "alias shutdown='sudo shutdown -h now'" >> /home/author/.bashrc

# Set text editor to run at startup
echo "" >> /home/author/.profile
echo "# Boot directly into Text Editor of your choice" >> /home/author/.profile
echo "# To change text editor, comment out the text editors you dont want using a pound sign or hashtag" >> /home/author/.profile
echo "# Add line for the text editor you do want to use. See examples below:" >> /home/author/.profile
echo "# /usr/bin/joe" >> /home/author/.profile
echo "/usr/bin/tilde" >> /home/author/.profile
echo "# /usr/bin/nano" >> /home/author/.profile

