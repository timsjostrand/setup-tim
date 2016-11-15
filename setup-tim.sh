#!/bin/bash -e
#
# Sets up Ubuntu just the way Tim likes it.
#
# Override options by setting them in the environment, like so:
# GIT_USER=apples GIT_EMAIL=spam ./setup-tim.sh
#
# Run only specific tasks by specifying them as arguments, like so:
# ./setup-tim.sh git_config vim_config
#
# Author: Tim Sjöstrand <tim.sjostrand@gmail.com>.

PACKAGES=(
	"vim-nox"
	"git"
	"tig"
	"picocom"
	"nmap"
	"build-essential"
	"screen"
	"curl"
	"snmp"
	"tcpdump"
)

PACKAGES_GUI=(
	"chromium-browser"
	"flashplugin-installer"
	"vlc"
	"wireshark"
)

USER_GROUPS=(
	"dialout"	# for picocom
)

VIM_SETTINGS=(
	"set nocompatible"
	"set backspace=indent,eol,start"
	"set history=50"
	"set ruler"
	"syntax on"
	"colorscheme evening"
)

GIT_USER=${GIT_USER:-"Tim Sjöstrand"}
GIT_EMAIL=${GIT_EMAIL:-"timsjostrand@gmail.com"}

VIM_RC=${VIM_RC:-~/.vimrc}

is_gui() {
	env | sed -n "s/^DISPLAY=\(.*\)$/\1/p"
}

out_pad() {
	while read line
	do
		echo "  ${line}"
	done
}

do_packages() {
	echo
	echo "> Updating repositories..."
	apt-get update >apt.log 2>&1 || {
		tail apt.log | out_pad
		return 1
	}
	echo

	echo "> Updating current packages..."
	yes 'y' | apt-get dist-upgrade >> apt.log 2>&1 || {
		tail apt.log | out_pad
		return 1
	}
	echo

	echo "> Installing packages..."
	yes 'y' | apt-get install ${PACKAGES[@]} >> apt.log 2>&1 || {
		tail apt.log | out_pad
		return 1
	}
	echo

	if [ ! -z "$(is_gui)" ]
	then
		echo "> Installing GUI packages..."
		yes 'y' | apt-get install ${PACKAGES_GUI[@]} >> apt.log 2>&1 || {
			tail apt.log | out_pad
			return 1
		}
		echo
	fi
}

do_update_groups() {
	if [ -z "${user}" ]
	then
		user=$(env | sed -n "s/^SUDO_USER=\(.*\)$/\1/p")
	fi

	if [ -z "${user}" ]
	then
		user=$(whoami)
	fi

	echo
	echo "> Updating groups for user \"${user}\"..."

	for group in ${USER_GROUPS[@]}
	do
		echo -n "  ${group}: "
		addgroup "${user}" "${group}" 2>&1
	done
}

do_git_config() {
	echo
	echo "> Setting up git"

	echo "  User: ${GIT_USER}"
	echo "  E-mail: ${GIT_EMAIL}"

	unset ANSWER
	read -n1 -p "  Update global git config? [Yn]: " ANSWER
	echo

	if [[ "${ANSWER}" =~ [Nn] ]]
	then
		echo "  Skipped configuring git"
	else
		git config --global user.name "${GIT_USER}"
		git config --global user.email "${GIT_EMAIL}"
		git config --global color.ui "true"
		echo "  Configured git"
	fi
}

do_xterm_colors() {
	echo
	echo "> Updating TERM with 256 colors support..."
	grep 'export TERM' ~/.bashrc || echo "export TERM="xterm-256color"" >> ~/.bashrc
}

do_vim_config() {
	echo

	# Link vim config
	echo "> Installing ${VIM_RC}..."
	ln -fs "${PWD}/vimrc" "${VIM_RC}"

	# Install Vundle
	if [ ! -d "~/.vim/bundle/Vundle.vim" ]
	then
		echo "> Installing Vundle..."
		mkdir -p ~/.vim/bundle/
		git submodule update --init
		ln -fs "${PWD}/Vundle.vim" ~/.vim/bundle/Vundle.vim
#		git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/Vundle.vim
	fi

	# Install Vundle plugins
	echo "> Installing vim plugins..."
	vim +PluginInstall +qall >/dev/null 2>&1 || \
		echo "> ERROR: when installing vim plugins"
}

do_clean_up() {
	echo
	echo "> Cleaning up"

	rm apt.log 2>/dev/null || true
}

if [ "$(whoami)" != "root" ]
then
	echo "WARN: You probably want to be root"
fi

if [ "${#}" -le 0 ]
then
	do_update_groups
	do_packages
	do_git_config
	do_xterm_colors
	do_vim_config
else
	for task in ${@}
	do
		do_${task}
	done
fi

do_clean_up

echo
echo "> Done!"
