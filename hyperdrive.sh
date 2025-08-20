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

function CHECK_OS()
{
    if ! [ -f "/etc/debian_version" ]; then
        ERROR "OS is not Debian, this script will probably not work!"
    fi
}

function STARTUP()
{
    # Banner
    INFO "||| HYPERDRIVE STARTED |||"

    CHECK_OS

    echo "What function do you want to run?"
    INFO "[ 1 ] Install tools"
    INFO "[ 2 ] Modify Debian"
    INFO "[ 3 ] Info"
}

function UPDATER()
{
    # Test for root
    if [ $UID -ne 0 ]
    then
        ERROR "[ERR] Please run this script as root."
        exit
    else
        SUCCESS "[SUC] Logged in as root."
        INFO "[INF] Starting ignition."
    fi
    # -- General --
    INFO "[INF] Updating repositories..."
    sudo apt update
}

clear
STARTUP