#!/usr/bin/env bash
# `bash_profile.sh` by Scott Buchanan https://buchanansc.com
SCRIPT_NAME="bash_profile.sh"
SCRIPT_VERSION="r1 2025-06-22"

usage() { cat <<EOF
$SCRIPT_NAME $SCRIPT_VERSION
Source from your .bash_profile to prepare your bash environment.

Usage: source ${0##*/}
EOF
}

ERROR() { [[ $1 ]] && echo "$SCRIPT_NAME: $1" 1>&2; [[ $2 > -1 ]] && exit $2; }

while (($#)); do
	case $1 in
		-h|--help) usage; exit 0 ;;
		*) break ;;
	esac
	shift
done

# path_append DIRECTORY...
# Append DIRECTORY to `$PATH` (if it exists, and isn't in $PATH already).
path_append() { while (($#)); do [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"; shift; done; export PATH; }

# path_prepend DIRECTORY...
# Prepend DIRECTORY to `$PATH` (if it exists, and isn't in $PATH already)
path_prepend() { while (($#)); do [[ -d "$1" && ":$PATH:" != *":$1:"* ]] && PATH="$1:$PATH"; shift; done; export PATH; }

# source_dir DIRECTORY...
# Source the files in a directory.
source_dir() { local f; while (($#)); do [[ -d "$1" ]] && for f in "$1"/*; do [[ -f "$f" ]] && . "$f"; done; shift; done; }

export CLICOLOR=1
#export GREP_OPTIONS='--ignore-case --color=auto'

# bash history options
export HISTCONTROL=erasedups:ignorespace:ignoredups
export HISTFILESIZE=2000
export HISTSIZE=1000
export HISTIGNORE='&:cd:cd :cd -:cd ~:cd ..:cd..:..:clear:exit:l:lr:lh:l@:gl:fresh:freshe:h:h *'
export HISTTIMEFORMAT="$(printf '\033[2;37;40m')%m/%d %H:%M:%S$(printf '\033[m')  "

export LC_CTYPE=${LANG:-en_US.UTF-8}
export LESS='-R -M -w -x4 -~ -z-4 --prompt=M ?f"%f" ?m[%i/%m]. | .?lbLine %lb?L of %L..?PB (%PB\%).?e (END). '
# export LSCOLORS=exfxcxdxbxegedabagacad
# export LS_COLORS='rs=0:di=00;34:ln=00;35:mh=00:pi=40;33:so=00;32:do=01;35:bd=40;33;01:cd=40;33;01:or=41;30;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=30;43:st=37;44:ex=31:';

[ -e "$HOME/.inputrc" ] && export INPUTRC="$HOME/.inputrc"
[ -e "$HOME/.htmltidy" ] && export HTML_TIDY="$HOME/.htmltidy"

# Shell is interactive
if [ -n "$PS1" ]; then
	shopt -s cdspell histappend histreedit histverify

	# Prompt
	[[ ! $TERM =~ ^xterm-.*color$ ]] &&
		export PS1='\h:\W \$ ' ||
		export PS1='\[\e[m\]\[\e]0;\h:\W\007\]\[\e[0;0;32m\]\h\[\e[37m\]:\[\e[33m\]\W \[\e[0;$([[ $? > 0 ]] && echo "31" || echo "32")m\]\$\[\e[m\] '
fi

_PROFILE_OS="$(uname)"
_PROFILE_HOST="$(hostname -s)"

# User executables
path_prepend "$HOME/bin/$_PROFILE_HOST" "$HOME/bin/$_PROFILE_OS" "$HOME/bin" "$HOME/.local/bin"

# Rubygem executables
which ruby gem &>/dev/null && path_prepend "$(ruby -rubygems -e 'puts Gem.user_dir' 2>/dev/null)/bin"

#
# OS specific settings
#

case "$_PROFILE_OS" in

	CYGWIN*)
		path_append "/cygdrive/c/Program Files/nodejs"
		;;

	Darwin)
		# Macports
		path_prepend /opt/local/{bin,sbin}

		# XCode Developer tools
		type "xcode-select" &>/dev/null && path_append "$("xcode-select" -print-path 2>/dev/null)/usr/bin"
		;;

esac

#
# Host specific settings
#

case "$_PROFILE_HOST" in

	lilpete)
		path_append \
			"$HOME/.pear/bin" \
			"$HOME/Library/Python/2.7/bin" \
			"$HOME/lib" \
			"$HOME/lib/AdobeAIRSDK-latest/bin" \
			"$HOME/lib/phantomjs-latest/bin" \
			"$HOME/lib/cocoaDialog.app/Contents/MacOS"
		;;

	box)
		path_append /usr/{sbin,local/{sbin,lib}} /sbin
		
		# Change color of hostname in prompt (if it has one)
		[ -n "$PS1" ] && export PS1=$(echo "$PS1" | sed -E 's/(\\e\[)[0-9]{2}(m\\\]\\h)/\194\2/g' 2>/dev/null)
		;;

esac

# Look for additional bash.d/ folders and include their contents
source_dir "$HOME"/{etc,bin,bin/"$_PROFILE_OS",bin/"$_PROFILE_HOST"}/bash.d

unset _PROFILE_HOST _PROFILE_OS
