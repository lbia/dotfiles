#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias sudo="doas"
alias ls='ls --color=auto --group-directories-first --format=horizontal --human-readable'
alias lsa='ls --color=auto --group-directories-first --format=horizontal --human-readable -a'
alias lsl='ls --color=auto --group-directories-first --format=horizontal --human-readable -l'
alias lsal='ls --color=auto --group-directories-first --format=horizontal --human-readable -a -l'
alias lsla='ls --color=auto --group-directories-first --format=horizontal --human-readable -l -a'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias mkdir='mkdir -pv'
alias space="du -sh"
alias n3="nnn"
alias ..='cd ..'
alias cd..='cd ..'
alias trexa="exa --long --header --modified --git --tree --color --icons --all --group-directories-first"
alias nv='nvim'
alias gpg='gpg2'
alias iwdscan='iwctl station wlan0 scan'
#alias chromium="ungoogled_chromium.sh"

# root privileges
# so the root can link and use this bashrc
if [ "$LOGNAME" = "root" ] || [ "$(id -u)" -eq 0 ]; then
	PS1="\[\e[1;31m\]\w\[\e[m\] \[\e[1;31m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
	#PS1='\[\e[1;31m\][\u@\h \W]\$\[\e[m\] '
	
else
	PS1="\[\e[1;32m\]\w\[\e[m\] \[\e[1;31m\]>\[\e[m\]\[\e[1;33m\]>\[\e[m\]\[\e[1;36m\]>\[\e[m\] "
	#PS1='\[\e[1;32m\][\u@\h \W]\$\[\e[m\] '

	alias sn3="doas nnn"
	alias snv='doas nvim'
fi

#alias config='/usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME"'

# git bare repository dotfiles
function config {
	# when adding echo to remember to pull before commit
	if [ $1 = "add" ]; then
		echo "remember to pull before commit"
	fi
	/usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" "$@"
	# when pulling remove README from HOME and set git to not track in locale
	if [ $1 = "pull" ]; then
		rm -f "$HOME"/README.md
		/usr/bin/git --git-dir="$HOME"/.dotfiles/ --work-tree="$HOME" update-index --assume-unchanged "$HOME"/README.md
	fi
}

# move to directory without using cd
# has to be sourced in bash_completion.sh
#shopt -s autocd

# autocomplete doas as sudo
# has to be sourced in bash_completion.sh
_completion_loader doas
complete -F _sudo doas

# autocomplete config as git
# has to be sourced in bash_completion.sh
_completion_loader __git_wrap__git_main
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main config

# autocomplete alias config (git bare repository)
# remember to sometimes check https://github.com/cykerway/complete-alias
#complete -F _complete_alias config

# void mirrors in order to quickly change when one si slow (R flag)
mirror1="https://alpha.de.repo.voidlinux.org/current/musl"
mirror2="https://mirrors.servercentral.com/voidlinux/current/musl"
mirror3="https://alpha.us.repo.voidlinux.org/current/musl"

HISTSIZE=
HISTFILESIZE=

HISTCONTROL=ignoredups

# PATHS
