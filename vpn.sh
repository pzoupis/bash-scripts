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

# Display available connections for the user to choose
PS3='Select vpn connection: '
options=${arr[*]}
select opt in "${arr[@]}"; do
    wg-quick up ${opt}
    break
done
