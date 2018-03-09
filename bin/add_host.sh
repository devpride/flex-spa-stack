#!/bin/sh

IP=$1
HOST=$2

if [ -n "$(grep $HOST /etc/hosts)" ]
    then
        echo "$HOST already exists."
    else
        echo "Adding $HOST to your /etc/hosts";
        sudo -- sh -c -e "echo '$IP\t$HOST' >> /etc/hosts";

        if [ -n "$(grep $HOST /etc/hosts)" ]
            then
                echo "$HOST has been added succesfully\n";
            else
                echo "Failed to add $HOST.";
        fi
fi
