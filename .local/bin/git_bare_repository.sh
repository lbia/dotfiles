#!/bin/sh

# first clone this repository normally in order to have scripts
# then run this script which will clone again this repository but bare

# set dotfiles folder name
folder="$HOME"/.dotfiles

# clone repository
git clone --bare https://github.com/Cubik22/dotfiles.git "$folder"

# create temporary alias
config () {
   /usr/bin/git --git-dir="$folder"/ --work-tree="$HOME" "$@"
}

# remove files if present
rm -f "${HOME}"/.bash_profile
rm -f "${HOME}"/.bashrc
rm -f "${HOME}"/.inputrc

# checkout and copy files in the appropiate places
config checkout

# set to not show untracked files
config config status.showUntrackedFiles no

# source bash profile and bashrc
source "$HOME"/.bash_profile
source "$HOME"/.bashrc

# add runtime dir
mkdir "${HOME}"/.local/runtime
chmod 700 "${HOME}"/.local/runtime

# import gpg key
gpg2 --search-keys $email

# trust key
echo "-------------------- type 'trust', '5', 'y', 'primary', 'save' --------------------"
gpg2 --edit-key $email

cargo install rbw

# already set in config folder
#rbw config set email "lorenzo.bianco22@protonmail.com"

rbw unlock

# set to track upstram
config push --set-upstream origin main

# set git to remeber credentials (danger but with github token you can give small permission)
#git config --global credential.helper store

# change root PS1
doas cat << EOF >> /root/.bashrc
PS1="\[\e[1;31m\]\w\[\e[m\] \[\e[1;31m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
#PS1="\[\e[1;31m\][\u@\h \W]\$\[\e[m\] "
EOF

# symlink nvim config to root
doas mkdir -p "/root/.config/nvim"
doas ln -s "$HOME"/.config/nvim/init.vim /root/.config/nvim/init.vim
