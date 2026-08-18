#!/bin/bash

set -e

script_dir="$(dirname "$(readlink -f "$0")")"
docker build -t esp-idf-builder -f "$script_dir/Dockerfile" "$script_dir"
