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

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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
export HISTIGNORE='&:cd:cd :cd -:cd ~:cd ..:cd..:..:clear:exit:l:lr:lh:l@:gl:h:h *'
export HISTTIMEFORMAT="$(printf '\033[2;37;40m')%m/%d %H:%M:%S$(printf '\033[m')  "

export LC_CTYPE=${LANG:-en_US.UTF-8}
export LESS='-R -M -w -x4 -~ -z-4 --prompt=M ?f"%f" ?m[%i/%m]. | .?lbLine %lb?L of %L..?PB (%PB\%).?e (END). '
# export LSCOLORS=exfxcxdxbxegedabagacad
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:';

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
path_prepend "$SCRIPT_DIR/$_PROFILE_HOST" "$SCRIPT_DIR/$_PROFILE_OS" "$SCRIPT_DIR" "$HOME/bin" "$HOME/.local/bin"

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

#case "$_PROFILE_HOST" in
#
#	HOST_A)
#		path_append \
#			"$HOME/SOME_PATH"
#		;;
#
#esac

# Look for additional bash.d/ folders and include their contents
source_dir "$HOME"/{etc,bin}/bash.d
source_dir {"$SCRIPT_DIR","$SCRIPT_DIR/$_PROFILE_OS","$SCRIPT_DIR/$_PROFILE_HOST"}/bash.d

unset _PROFILE_HOST _PROFILE_OS
