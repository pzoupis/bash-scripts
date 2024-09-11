#!/bin/bash

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
for entry in ${arr[@]};
{
    [[ $(ip a) =~ $entry ]] && echo $entry is active
}

# Display available connections for the user to choose
PS3='Select vpn connection: '
options=${arr[*]}
select opt in "${arr[@]}"; do
    wg-quick up ${opt}
    break
done
