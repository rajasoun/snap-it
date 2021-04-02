#!/usr/bin/env bash

set -eo pipefail
IFS=$'\n\t'
export REGISTRY_HOST_URL=docker.io

if [ ! -d "bash-it" ]; then
    git clone https://github.com/rajasoun/bash-it
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=bash-it/scripts/load.bash

source "$SCRIPT_DIR/bash-it/scripts/load.bash"


# shellcheck source=bash-it/scripts/docker.bash
source "$SCRIPT_DIR/assist/docker.bash"
