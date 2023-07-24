#!/bin/bash
set -u
set -e
set -o pipefail

function is-enabled-globally {
    if grep -xq 'set completion-ignore-case On' /etc/inputrc
    then return 0
    else return 1
    fi
}

function is-enabled-locally {
    if [[ -e ~/.inputrc && $(grep -xq 'set completion-ignore-case On' ~/.inputrc) -eq 0 ]]
    then return 0
    else return 1
    fi
}

function enable-globally {
    sudo echo -e '\nset completion-ignore-case On' >> /etc/inputrc
}

function enable-locally {
    if [ ! -e ~/.inputrc ]; then
        echo '$include /etc/inputrc' > ~/.inputrc
    fi
    echo -e '\nset completion-ignore-case On' >> ~/.inputrc
}

function enable {
    echo 'Enable "completion-ignore-case" [Globally] or [Locally]?'
    read -p '> ' inp

    case ${inp,,} in
        g|globally )
            enable-globally;;
        l|locally )
            enable-locally;;
        * ) 
            echo invalid response;
    esac
}

if is-enabled-globally
then echo '"completion-ignore-case" already enabled globally'
elif is-enabled-locally
then echo '"completion-ignore-case" already enabled locally'
else enable
fi
