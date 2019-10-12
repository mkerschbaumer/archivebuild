# Automate archive creation

This repo contains scripts to automate archive creation for course submissions.
A prefix can be used, if the course requires a specific archive-name format
like "<group-number>-<surename>-week<nr>.tar.gz". Currently only .tar.gz files
are supported.

Archives can be created using [Gitlab CI](https://docs.gitlab.com/ee/ci/). It
has been tested with the docker-image [bash:5](https://hub.docker.com/_/bash).

## Setup

This repo is intended to be used as a
[git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules). It can be
used as a subfolder of a parent project (e.g. course-specific repo is the parent
project).

```bash
git submodule add https://github.com/mkerschbaumer/archivebuild.git
git commit -m "Add submodule for building archives"
```

## Workflow

First, the specified root directory is scanned for files, which should be
included in the created archives. Then a list of (top level) folders is
generated, based on which archives are generated. The resulting archives only
contain files matching specific wildcards (configuration options below).

> Archive naming scheme: `<archive-prefix><folder-name><archive-file-format>`

General options can be configured by setting environment variables. The
following options are available:

+ `ARCHIVEBUILD_FILE_FORMAT`: The file format to use for the archives to
    create. Currently only ".tar.gz" is supported.
+ `ARCHIVEBUILD_PREFIX`: The prefix to use for archive-file names. If a
    specific naming scheme like "<group-number>-<surename>-week<nr>.tar.gz" is
    required, the prefix can be set to `<group-number>-<surename>-`. 
+ `ARCHIVEBUILD_ARCHIVE_DIR`: The directory, where the created archives are
    moved to (Default: "archives").
+ `ARCHIVEBUILD_ROOT_DIR`: The directory, where subfolders are used to generate
    archives (Default: ".").
+ `ARCHIVEBUILD_WILDCARD_FILE`: A file, which contains wildcards for files to
    include in archives. Each line represents a wildcard (e.g. "*.java"). By
    default, all java files get added to the archive.
+ `ARCHIVEBUILD_DEBUG`: If set to a string of nonzero length is assigned to
    this environment variable, a short summary is displayed when executing
    `build_archive.sh`. This can be useful for diagnostic purposes.

