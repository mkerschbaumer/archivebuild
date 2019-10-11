#!/usr/bin/env bash

# Use .tar.gz files as default
if [ -z "$ARCHIVEBUILD_FILE_FORMAT" ]; then
    ARCHIVEBUILD_FILE_FORMAT="tar.gz"
fi

# Prefix to use for archive files (e.g. when a course requires the group
# number and the surename to be part of the archive file name).
if [ -z "$ARCHIVEBUILD_PREFIX" ]; then
    # Group number used as default
    ARCHIVEBUILD_PREFIX="2-"
fi

# Directory, where the archive files should be placed.
if [ -z "$ARCHIVEBUILD_ARCHIVE_DIR" ]; then
    ARCHIVEBUILD_ARCHIVE_DIR=archives
fi

# File containing wildcards describing, which files should be included in the
# archive to build.
if [ -z "$ARCHIVEBUILD_WILDCARD_FILE" ]; then
    ARCHIVEBUILD_WILDCARD_FILE="$(dirname $0)/default_wildcards.txt"
fi

# Directory, where subfolders should be used for achive creation (folder name
# is part of archive name).
if [ -z "$ARCHIVEBUILD_ROOT_DIR" ]; then
    ARCHIVEBUILD_ROOT_DIR="."
fi

# Allow printing of variables to use (for diagnostic purposes).
if [ -n "$ARCHIVEBUILD_DEBUG" ]; then
    echo "File format to use for archives: '$ARCHIVEBUILD_FILE_FORMAT'"
    echo "Archive prefix: '$ARCHIVEBUILD_PREFIX'"
    echo "Directory for archives to create: '$ARCHIVEBUILD_ARCHIVE_DIR'"
    echo "Root directory: '$ARCHIVEBUILD_ROOT_DIR'"
    echo "Used archive file: '$ARCHIVEBUILD_WILDCARD_FILE'"
fi

# Return a list of files, which should be used for archive creation. The file
# path is relative to the current directory.
function get_relevant_files() {
    SUFFIX="$1"
    if [ -z "$SUFFIX" ]; then
        echo "No suffix specified!"
        exit 1
    fi

    find . -type f -name "$SUFFIX" | \
        sed "s/^\.\///"
}
