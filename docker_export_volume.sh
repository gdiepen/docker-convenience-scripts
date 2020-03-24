#!/usr/bin/env bash

# Author: Alexey Ukhov <alex@ukhov.ru>

SCRIPTSRC=`readlink -f "$0" || echo "$0"`
SCRIPT_PATH=`dirname "$SCRIPTSRC" || echo .`

#First check if the user provided all needed arguments
if [ "$1" = "" ]
then
        echo "Please provide a source volume name"
        exit
fi

#Check if the source volume name does exist
docker volume inspect $1 > /dev/null 2>&1
if [ "$?" != "0" ]
then
        echo "The source volume \"$1\" does not exist"
        exit
fi

BACKUP_FOLDER=${2:-backup}
if [ ! -d "${BACKUP_FOLDER}" ]
then
        echo "Create backup folder '${BACKUP_FOLDER}'"
        mkdir -p ${BACKUP_FOLDER}
fi

NOW=$(date +"%Y-%m-%d-%H-%M-%S")
BACKUP_FILE=${BACKUP_FOLDER}/$1_${NOW}.tar.gz

echo "Export volume '$1' into file '${BACKUP_FILE}'"
docker run --rm -v $1:/from alpine ash -c 'cd /from && tar -cOzf - .' > ${BACKUP_FILE}