#!/usr/bin/sudo bash

# Directory of wireguard .conf files
search_dir=/etc/wireguard

vpn()
{
    if [ -z "$1" ]; then
        _vpn_usage
        return
    fi

    subcommand="$1"
    shift
    case "$subcommand" in
        -c|--connect)
            _vpn_connect
            ;;
        -d|--disconnect)
            _vpn_disconnect
            ;;
    esac
    return $?
}

_vpn_connect()
{
    # Get filename of wireguard configuration files
    arr=()

    for entry in "$search_dir"/*
    do
        filename_with_extension=$(basename "$entry")
        filename="${filename_with_extension%.*}"
        arr+=($filename)
    done
    
    # Display available connections for the user to choose
    PS3='Select vpn connection: '
    options=${arr[*]}
    select opt in "${arr[@]}"; do
        wg-quick up ${opt}
        break
    done
}

_vpn_disconnect()
{
    # Check for active wireguard connections
    active_connections=()
    active_connections_counter=0
    for entry in ${arr[@]};
    {
        if [[ $(ip a) =~ $entry ]]; then
            echo $entry is active
            ((active_connections_counter++))
            active_connections+=($entry)
        fi
    }

    # Ask to terminate active connections
    if [ $active_connections_counter -gt 0 ]; then
        read -p "Do you want to terminate active connections? (y/n) " response
        case $response in
            [yY] ) 
                for entry in ${active_connections[@]};
                {
                    wg-quick down $entry
                }
            ;;
            [nN] ) echo no;
            ;;
            * ) echo wrong;;
        esac
    fi
}

_vpn_usage()
{
    cat <<\USAGE
    usage: vpn [<option>]

    OPTIONS:
        -c, --connect: activate a Wireguard connection
            vpn -c|--connect <connection_name>
        -d, --disconnect: Deactivate a Wireguard connection
            vpn -d|--disonnect <connection_name>
USAGE
}