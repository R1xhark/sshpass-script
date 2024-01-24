#!/bin/bash

echo "SSH pass script"

# Function to check if a unit is up
is_unit_up() {
    ping -c 1 "$1" &> /dev/null
    return $?
}

# Function to handle remote commands
handle_remote_command() {
    local ip="$1"
    local pass="$2"

    while true; do
        if is_unit_up "$ip"; then
            read -p "Input: >> " command

            # Check for exit command
            if [[ "${command,,}" == 'k' ]]; then
                echo "Exiting command input mode."
                break
            fi

            # Execute the command
            if [ -z "$pass" ]; then
                pass="password" # Default password
            fi
            output=$(sshpass -p "$pass" ssh "$ip" "$command" 2>&1)
            echo "Command output: $output"
        else
            echo "Invalid IP or unit is not reachable."
            break
        fi
    done
}

# Main loop
while true; do
    read -p "Enter unit IP: " ip
    read -p "Enter password (leave empty for default): " pass

    # Check for exit command
    if [[ "${pass,,}" == "k" || "${ip,,}" == "k" ]]; then
        echo "Exiting"
        break
    fi

    handle_remote_command "$ip" "$pass"
done
