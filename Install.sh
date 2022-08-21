#!/bin/bash

RED="\e[31m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

error_ins=1
error_conf=1

echo Updating...
apt-get update -y 1>/dev/null 2>> /root/error.log

echo Upgrading...
apt-get upgrade -y 1>/dev/null 2>> /root/error.log


echo Installing HTOP...
apt-get install htop -y 1>/dev/null 2>> /root/error.log

echo Installing NET-TOOLS...
apt-get install net-tools -y 1>/dev/null 2>> /root/error.log

echo Installing OpenSSH-Server...
echo

apt-get install openssh-server -y 1>/dev/null 2>> /root/error.log

if [[ $? = 0 ]]
then
        echo ______________________
        echo -e "${GREEN}Instalation completed${ENDCOLOR}"
        echo ______________________
        echo
        error_inst=0
else
        echo ______________________
        echo -e "${RED}Instalation error${ENDCOLOR}"
        echo ______________________
        echo
        error_inst=1
fi

if [[ $error_inst = 0 ]]
then
        echo Configuring Root access...
        echo
        echo PermitRootLogin yes >> /etc/ssh/sshd_config 2>> /root/error.log
        if [[ $? = 0 ]]
        then
                echo ______________________
                echo -e "${GREEN}Configuration completed${ENDCOLOR}"
                echo ______________________
                echo
                error_conf=0
        else
                echo ______________________
                echo -e "${RED}Configuration error${ENDCOLOR}"
                echo ______________________
                echo
                error_conf=1
        fi
fi

if [[ $error_conf = 0 ]]
then
        echo Restarting ssh...
        echo
        /etc/init.d/ssh restart

        if [[ $? = 0 ]]
        then
                echo ______________________
                echo -e "${GREEN}Completed${ENDCOLOR}"
                echo ______________________
                echo
                ip a
        else
                echo ______________________
                echo -e "${RED}Error${ENDCOLOR}"
                echo ______________________
                echo
        fi

fi
