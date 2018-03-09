#!/bin/sh

HOST=$1

if [ -n "$(grep $HOST /etc/hosts)" ]
then
    echo "Removing $HOST from your /etc/hosts";
    sudo sed -i".bak" "/$HOST/d" /etc/hosts
else
    echo "$HOST was not found in your /etc/hosts";
fi
