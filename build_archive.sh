#!/usr/bin/env bash

# Ensure needed variables are present and set defaults accordingly.
. "$(dirname $0)/globals.sh"

RELEVANT_FILES=""
SUFFIX_LIST=$(cat "$ARCHIVEBUILD_WILDCARD_FILE")
for suffix in $SUFFIX_LIST; do
    MATCHING=$(get_relevant_files "$suffix")
    if [ -n "$MATCHING" ]; then
        # Ensure proper spacing between entries
        RELEVANT_FILES+=" $MATCHING"
    fi
done

# Don't continue execution if no archives can be created.
if [ -z "$RELEVANT_FILES" ]; then
    echo "No relevant files found => no archives to be created"
    exit 0
fi

# Folders, for which archives should be created. Only the top-level directory is used
# (as archive name).
FOLDER_CANDIDATES=$(
    echo "$RELEVANT_FILES" | \
    xargs -n 1 dirname | \
    sed "s/^\.\///" | \
    sed -rn "s/([^\/]+).*/\1/p" | \
    uniq \
)

if [ -n "$ARCHIVEBUILD_DEBUG" ]; then
    echo
    echo "Creating archives for folders $FOLDER_CANDIDATES"
fi

# Rely on global variables ARCHIVE_NAME and RELEVANT_FILES
function create_archive() {
    local TMPFILE=tmp
    echo "Creating archive '$ARCHIVE_NAME'"

    case "$ARCHIVEBUILD_FILE_FORMAT" in
    "tar.gz")
        cd $folder && \
            tar -cvf "$TMPFILE" -- $RELEVANT_FILES && \
            gzip "$TMPFILE" && \
            mv "$TMPFILE.gz" "../$ARCHIVE_NAME" && \
            rm -f "$TMPFILE" && \
            cd - >/dev/null
        ;;
    esac
}

# Ensure archive directory is present
if [ ! -d "$ARCHIVEBUILD_ARCHIVE_DIR" ]; then
    mkdir "$ARCHIVEBUILD_ARCHIVE_DIR"
fi

for folder in $FOLDER_CANDIDATES; do
    ARCHIVE_NAME="$ARCHIVEBUILD_ARCHIVE_DIR/$ARCHIVEBUILD_PREFIX$folder\
.$ARCHIVEBUILD_FILE_FORMAT"
    RELEVANT_FILES=""
    for suffix in $SUFFIX_LIST; do
        MATCHING=$(cd $folder && get_relevant_files "$suffix")
        RELEVANT_FILES+=" $MATCHING"
    done

    create_archive
done

