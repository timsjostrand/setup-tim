#!/bin/bash -e
#
# Sets up Ubuntu just the way Tim likes it.
#
# Override options by setting them in the environment, like so:
# GIT_USER=apples GIT_EMAIL=spam ./setup-tim.sh
#
# Author: Tim Sjöstrand <tim.sjostrand@gmail.com>

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

do_install_packages() {
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

do_update_git_config() {
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

do_update_vim_config() {
	echo

	if [ -f "${VIM_RC}" ]
	then
		echo "> Updating ${VIM_RC}"
	else
		echo "> Creating ${VIM_RC}"
		touch "${VIM_RC}"
	fi

	# Try to avoid overriding existing settings
	for line in "${VIM_SETTINGS[@]}"
	do
		if [ ! -z "$(echo "${line}" | grep 'set ')" ]
		then
			if [ -z "$(grep "${line}" "${VIM_RC}")" ]
			then
				echo "${line}" >> "${VIM_RC}"
			else
				echo "  Skipping \"${line}\", already present"
			fi
		else
			keyword=$(echo "${line}" | cut -d' ' -f1)

			if [ -z "$(sed -n "s/^${keyword} \(.*\)$/\1/p" "${VIM_RC}")" ]
			then
				echo "${line}" >> "${VIM_RC}"
			else
				echo "  Skipping \"${keyword}\", already present"
			fi
		fi
	done
}

do_clean_up() {
	echo
	echo "> Cleaning up"

	rm apt.log
}

if [ "$(whoami)" != "root" ]
then
	echo "WARN: You probably want to be root"
fi

do_update_groups
do_install_packages
do_update_git_config
do_update_vim_config
do_clean_up

echo
echo "> Done!"
