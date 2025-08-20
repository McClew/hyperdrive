#!/bin/bash

# Global parameters
USER=""

# Styling variables
GREEN=`tput bold && tput setaf 2`
RED=`tput bold && tput setaf 1`
BLUE=`tput bold && tput setaf 4`
RESET=`tput sgr0`

# Styling functions
function SUCCESS()
{
	echo -e "\n${GREEN}${1}${RESET}"
}

function ERROR()
{
	echo -e "\n${RED}${1}${RESET}"
}

function INFO()
{
	echo -e "\n${BLUE}${1}${RESET}"
}

# Utility functions
function CHECK_OS()
{
    if ! [ -f "/etc/debian_version" ]; then
        ERROR " OS is not Debian, this script will probably not work!"
    fi

    echo " Continue anyway? [y/n]:"
    read -r continue

    if [ "${continue,,}" == "n" || "${continue,,}" == "no"]; then
        exit
    elif [ "${continue,,}" == "y" || "${continue,,}" == "yes"]; then
        return
    else
        exit
    fi
}

function CHECK_ROOT()
{
    # Test for root
    if [ $UID -ne 0 ]; then
        ERROR " [ERR] Please run this script as root."
        exit
    else
        SUCCESS " [SUC] Logged in as root."
        INFO " [INF] Starting hyperdrive."
        return
    fi
}

# Process functions
function STARTUP()
{
    # Banner
    INFO " ~ HYPERDRIVE ~"

    CHECK_OS

    echo " What function do you want to run?"
    INFO " [ 1 ] Install tools"
    INFO " [ 2 ] Modify Debian"
    INFO " [ 3 ] Info"

    read -r function_choice

    if [function_choice == 1]; then
        INSTALLER
    elif [function_choice == 2]; then
        CUSTOMISER
    elif [function_choice == 3]; then
        INFO_PROVIDER
    else
        STARTUP
    fi
}

function INSTALLER()
{
    CHECK_ROOT

    # -- General --
    INFO " [INF] Updating repositories..."
    sudo apt update
}

function CUSTOMISER()
{
    echo "this does nothing yet..."
    STARTUP
}

function INFO_PROVIDER()
{
    echo "this does nothing yet..."
    STARTUP
}

clear
STARTUP