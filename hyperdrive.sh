#!/bin/bash

# Global parameters
PACKAGE_INSTALL_PATH="/opt"
BINARY_INSTALL_PATH="/usr/local/bin"
WORDLIST_INSTALL_PATH="/usr/share/wordlists/"

# Styling variables
GREEN=`tput bold && tput setaf 2`
RED=`tput bold && tput setaf 1`
BLUE=`tput bold && tput setaf 4`
RESET=`tput sgr0`

# Install lists
INFO_GATHERING_MANAGED=("dnsenum" "nmap" "fierce" "sublist3r")
INFO_GATHERING_PACKAGES=("git@gitlab.com:kalilinux/packages/enum4linux.git")

# Styling functions
function success()
{
	echo -e "\n${GREEN}${1}${RESET}"
}

function error()
{
	echo -e "\n${RED}${1}${RESET}"
}

function info()
{
	echo -e "\n${BLUE}${1}${RESET}"
}

# Utility functions
function banner()
{
    info "~ HYPERDRIVE ~"
}

function check_os()
{
    if ! [ -f "/etc/debian_version" ]; then
        error "OS is not Debian, this script will probably not work!"
        echo "Continue anyway? [y/n]:"
        echo -n "> "
        read -r continue

        if [ "${continue,,}" == "n" || "${continue,,}" == "no" ]; then
            exit
        elif [ "${continue,,}" == "y" || "${continue,,}" == "yes" ]; then
            return
        else
            exit
        fi
    fi

    return
}

function check_root()
{
    # Test for root
    if [ $UID -ne 0 ]; then
        error "[ERR] Please run this script as root."
        exit
    else
        success "[SUC] Logged in as root."
        info "[INF] Starting hyperdrive."
        return
    fi
}

function update_pm()
{
    info "[INF] Updating repositories..."
    sudo apt update
}

function check_git()
{
    git --version 2>&1 >/dev/null
    git_available=$?

    if [ git_available -eq 0 ]; then
        error "Git not found."
        info "Installing git"
        sudo apt install git
    fi
}

function trust_sources()
{
    ssh-keyscan github.com >> ~/.ssh/known_hosts
    ssh-keyscan gitlab.com >> ~/.ssh/known_hosts
}

# Process functions
function startup()
{
    clear
    banner
    check_os

    echo "What function do you want to run?"
    info "[ 1 ] Install tools"
    info "[ 2 ] Modify Debian"
    info "[ 3 ] Info"
    info "[ 0 ] Exit"
    echo ""
    echo -n "> "
    read -r choice

    if [ "${choice}" == "1" ]; then
        installer
    elif [ "${choice}" == "2" ]; then
        customiser
    elif [ "${choice}" == "3" ]; then
        info_provider
    elif [ "${choice}" == "0" ]; then
        exit
    else
        startup
    fi

    return
}

function installer()
{
    check_root
    update_pm

    echo "Allow unattended installs? [y/n]"
    echo -n "> "
    read -r unattended_install

    if [ "${unattended_install,,}" == "y" ] || [ "${unattended_install,,}" == "yes" ]; then
        postfix="-y"
        trust_sources
    else
        postfix=""
    fi

    for managed in "${INFO_GATHERING_MANAGED[@]}"; do
        info "Installing ${managed}..."
        sudo apt install "$managed" "$postfix"
    done

    check_git

    for packages in "${INFO_GATHERING_PACKAGES[@]}"; do
        if [[ $packages =~ /([^/]+)\.git$ ]]; then
            package_name="${BASH_REMATCH[1]}"
        fi

        info "Installing ${package_name}..."
        sudo git clone "$packages"
    done
}

function customiser()
{
    echo "this does nothing yet..."
    startup
}

function info_provider()
{
    echo "this does nothing yet..."
    startup
}

startup
exit