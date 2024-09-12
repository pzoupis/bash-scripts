#!/usr/bin/sudo bash

# Directory of wireguard .conf files
search_dir=/etc/wireguard

# Get filename of wireguard configuration files
arr=()

for entry in "$search_dir"/*
do
    filename_with_extension=$(basename "$entry")
    filename="${filename_with_extension%.*}"
    arr+=($filename)
done

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

# Display available connections for the user to choose
PS3='Select vpn connection: '
options=${arr[*]}
select opt in "${arr[@]}"; do
    wg-quick up ${opt}
    break
done
