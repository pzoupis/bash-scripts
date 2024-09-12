backup()
{
    if [ -z "$1" ]; then
        _backup_usage
        return
    fi

    subcommand="$1"
    shift
    case "$subcommand" in
        backup)
            _backup_backup
            ;;
        snapshots)
            _backup_snapshots
            ;;
        manual)
            _backup_manual
            ;;
        help)
            _backup_usage
            ;;
    esac
    return $?
}

_backup_usage()
{
    echo "usage: backup <command>"
    echo
    echo "COMMANDS"
    echo "  backup: creates a backup"
    echo "  snapshots: prints the snapshots"
    echo "  manual: Loads environment variables for manual use of restic"
    echo "  help: prints this help"
    echo
}

_backup_backup()
{
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

    PS3='Select backup location: '
    options=${backup_location_array[*]}
    select opt in "${backup_location_array[@]}"; do
        set -a
        . $environment_variables_directory/$opt.env
        restic backup --files-from ~/Documents/AppFiles/restic/includes --exclude-file ~/Documents/AppFiles/restic/excludes --skip-if-unchanged
        break
    done
}

_backup_snapshots()
{
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

    PS3='Select backup location: '
    options=${backup_location_array[*]}
    select opt in "${backup_location_array[@]}"; do
        set -a
        . $environment_variables_directory/$opt.env
        restic snapshots
        break
    done
}

_backup_manual()
{
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

    PS3='Select backup location: '
    options=${backup_location_array[*]}
    select opt in "${backup_location_array[@]}"; do
        set -a
        . $environment_variables_directory/$opt.env
        break
    done
}