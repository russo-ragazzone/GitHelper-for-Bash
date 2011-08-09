#!/bin/bash

help_script="~/.git-tools/git-helper.sh"

# if directory doesn't exist:
if [ ! -d ~/.git-tools ]; then 
    mkdir ~/.git-tools
fi

# Copy helper.sh script to this directory:
if [ ! -f $help_script ]; then
    install -m 755 git-helper.sh ~/.git-tools/
fi

# Check for .bashrc:
if [ ! -f ~/.bashrc ]; then 
    touch ~/.bashrc
fi

# Add to bashrc our script:
helper=`cat ~/.bashrc | grep git-helper-mark`
if [ "$helper" = "" ]; then 
    PS1='${debian_chroot:+($debian_chroot)}\[\e[1;31m\][\T] \[\e[0;36m\]\u\[\e[0m\]@\[\e[1;32m\]\h\[\e[0m\]:\w\`~/.git-tools/git-helper.sh\`\$ '
    echo "PS1=\"$PS1\" # git-helper-mark ! Do not remove it!" >> ~/.bashrc
#    echo -e "PS1=\"\$PS1\`$help_script\`>\"" >> ~/.bashrc;
    echo "Installed successfully."
else 
    echo "Plugin is already installed!"
fi

