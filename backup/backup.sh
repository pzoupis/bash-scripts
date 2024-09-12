#!/bin/bash

# Directory of files with restic environment variables
environment_variables_directory=~/Documents/AppFiles/restic

files_array=()
backup_location_array=()

for entry in "$environment_variables_directory"/*
do
    filename_with_extension=$(basename "$entry")
    if [[ $filename_with_extension == *.env ]]; then
        filename="${filename_with_extension%.*}"
        array+=($filename_with_extension)
        backup_location_array+=($filename)
    fi
done

# Debug
# echo "${array[*]}"
# echo "${backup_location_array[*]}"

PS3='Select backup location: '
options=${backup_location_array[*]}
select opt in "${backup_location_array[@]}"; do
    set -a
    . $environment_variables_directory/$opt.env
    restic backup --files-from ~/Documents/AppFiles/restic/includes --skip-if-unchanged
    break
done