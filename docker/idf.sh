#!/bin/bash

rpath="$( dirname "$( readlink -f "$0" )" )"
cd $rpath

docker_extra_args=()
serial_port=""
previous_arg=""
for arg in "$@"; do
    if [[ "$previous_arg" == "-p" || "$previous_arg" == "--port" ]]; then
        serial_port="$arg"
        break
    fi
    case "$arg" in
        --port=*) serial_port="${arg#--port=}"; break ;;
    esac
    previous_arg="$arg"
done

if [[ -n "$serial_port" && -e "$serial_port" ]]; then
    docker_extra_args+=(--group-add "$(stat -c '%g' "$serial_port")")
fi

docker run --rm -it -v /dev:/dev --privileged \
    "${docker_extra_args[@]}" \
    -e BOARD="${BOARD:-NERDQAXEPLUS2}" \
    -e DISPLAY="${DISPLAY:-}" \
    -v "$rpath/..":/home/builder/project esp-idf-builder idf.py "$@"
