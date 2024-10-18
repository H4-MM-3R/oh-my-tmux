#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux source "$CURRENT_DIR/scripts/tmux.conf"
tmux source "$CURRENT_DIR/scripts/statusline.conf"
