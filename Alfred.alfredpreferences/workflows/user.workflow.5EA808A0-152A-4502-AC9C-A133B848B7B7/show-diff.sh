#!/usr/bin/env zsh
sublcli="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" # using full path makes this work even if `subl` hasn't been added to PATH

hash=$(echo "$*" | cut -d";" -f1)
FULL_PATH=$(echo "$*" | cut -d";" -f2)
FILE="$(basename "$FULL_PATH")"
EXT="${FILE##*.}"
OLD="/tmp/$hash.$EXT"

diff --unified --ignore-all-space "$OLD" "$FULL_PATH" | tail -n+3 > "/tmp/$hash.diff"

"$sublcli" "/tmp/$hash.diff"
