#!/usr/bin/env bash

services=()                 # array to hold list of services
menu_items=()               # holds the menu items for selecting available services
dc_command=(docker-compose) # array for building the replacement docker-compose command

function init() {
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>&1 >/dev/null && pwd)" # the directory of this file
    enabled_services_dir="$script_dir/enabled_services"                        # the directory to which output files are written
    available_services_dir="$script_dir/available_services"                    # directory of the config and docker-compose files
    project_path_files_dir="$script_dir/.project_paths"                        # directory to store files containing paths to projects. This is later used to prefill the values for already added services
    mkdir -p "$available_services_dir"                                         # create the available services directory if not already present
    mkdir -p "$project_path_files_dir"                                         # create the projects path file directory
}

# gets the full path to docker-compose file of the project
function compose_file_name() {
    echo "$enabled_services_dir/$1/docker-compose.yml"
}

# populates the list of available services
function populate_services() {
    while read -r file; do
        services+=("${file##*/}")
    done < <(find "$available_services_dir" -maxdepth 1 -mindepth 1 -type d)
}

# select the services to enable
function select_services() {
    if ! selected_services=$({ whiptail --checklist --nocancel "Select services:" 15 40 8 "${menu_items[@]}" >/dev/tty; } 2>&1); then
        exit
    fi
}

function populate_menu() {
    for service in "${services[@]}"; do
        compose_file="$(compose_file_name "$service")" # the full path to docker-compose file of the project
        menu_items+=("$service" "" "$(cat "$compose_file" >/dev/null 2>&1 && echo "on" || echo "off")")
    done
}

# strip the surrounding quotes "
function strip_quotes() {
    [ "$1" == "" ] && return
    str=${1#\"}
    echo "${str%\"}"
}

# read input from user
function read_input() {
    local text
    local message=$1
    local default_value=
    [ "$2" != "" ] && default_value="$2"
    if text=$(whiptail --inputbox --nocancel "Absoulute path of $message" 10 60 "$default_value" 2>&1 >/dev/tty); then
        echo "$text"
        return
    fi
    echo "$default_value"
}

# deletes and re-creates the enabled services directory
function clean_directories() {
    rm -rf "$enabled_services_dir" && mkdir -p "$enabled_services_dir" # recreate the destination directory for cleaning old files
}

# enables a service
# copies all the files in the available services directory to enabled services for a service
# the following replacements are done for the enabled services
#   ${SERVICE_NAME}         -> The name of the service
#   ${PROJECT_DIR}          -> The path to the source code of the service
#   ${SERVICE_DIR}          -> The path to the enabled services directory of the service
function enable_service() {
    local service_name=$1
    project_path_file="$project_path_files_dir/$service_name.dir"
    current_project_directory=$(cat "$project_path_file" 2>/dev/null)
    directory=$(read_input "Absoulute path of $service_name" "$current_project_directory")
    directory=${directory%/}
    cp -r "$available_services_dir/$service_name" "$enabled_services_dir/$service_name"
    find "$enabled_services_dir/$service_name" -mindepth 1 -type f -print0 | xargs -0 \
        sed -i "s|\${SERVICE_NAME}|$service_name|g;s|\${PROJECT_DIR}|$directory|g;s|\${SERVICE_DIR}|$enabled_services_dir/$service_name|g"
    echo "$directory" >"$project_path_file" # Write the directory to directory file
}

# generates the docker-compose command to be used
# this basically generates original docker-compose command which passes all the docker-compose.yml files of the services in addition
# eg. docker-compose --file service1/docker-compose.yml --file service1/docker-compose.yml ....
function generate_compose_file() {
    cat >docker-compose <<EOF
#!/bin/bash
#shellcheck disable=SC2068
${dc_command[@]} \$@
EOF
    chmod +x docker-compose
}

# enables the selected services and builds the replacement docker-compose command
function enable_services() {
    for selected_service in $selected_services; do
        local service_name
        service_name=$(strip_quotes "$selected_service")
        enable_service "$service_name"
        dc_command+=(--file "$(compose_file_name "$service_name")") # Add the --file <filename>.yml for docker-compose command
    done
}

init                  # initialising the variables required for the script
populate_services     # populates the available services
populate_menu         # populates the menu with available services
select_services       # select the services to enable
clean_directories     # clean the existing files
enable_services       # enable the selected services
generate_compose_file # generate the replacement docker-compose command
