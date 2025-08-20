#!/bin/bash

# Global parameters
USER=""

# Styling variables
GREEN=`tput bold && tput setaf 2`
RED=`tput bold && tput setaf 1`
BLUE=`tput bold && tput setaf 4`
RESET=`tput sgr0`

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
function check_os()
{
    if ! [ -f "/etc/debian_version" ]; then
        error " OS is not Debian, this script will probably not work!"
        echo " Continue anyway? [y/n]:"
        read -r continue

        if [ "${continue,,}" == "n" || "${continue,,}" == "no"]; then
            exit
        elif [ "${continue,,}" == "y" || "${continue,,}" == "yes"]; then
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
        error " [ERR] Please run this script as root."
        exit
    else
        success " [SUC] Logged in as root."
        info " [INF] Starting hyperdrive."
        return
    fi
}

# Process functions
function startup()
{
    # Banner
    info " ~ HYPERDRIVE ~"

    check_os

    echo " What function do you want to run?"
    info " [ 1 ] Install tools"
    info " [ 2 ] Modify Debian"
    info " [ 3 ] Info"
    info " [ 0 ] Exit"
    echo ""
    echo -n " > "
    read -r choice

    if ["${choice}" == "1"]; then
        installer
    elif ["${choice}" == "2"]; then
        customiser
    elif ["${choice}" == "3"]; then
        info_provider
    elif ["${choice}" == "0"]; then
        exit
    else
        startup
    fi

    return
}

function installer()
{
    check_root

    # -- General --
    info " [INF] Updating repositories..."
    sudo apt update
}

function customiser()
{
    echo " this does nothing yet..."
    startup
}

function info_provider()
{
    echo " this does nothing yet..."
    startup
}

clear
startup
exit