#!/bin/bash
# will backup all databases and keep a set number of versions

BACKUPLOCATION="/var/backups/mysql"
LOGFILE="${BACKUPLOCATION}/mysqlbackup.log"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
# Versions to keep
VTK="3"

if ! grep password "${HOME}"/.my.cnf 2> /dev/null 1>&2; then
    echo "backup user missing password in .my.cnf"
    exit 1
fi

DATABASES=( $(mysqlshow | awk '/\| [a-z].*/{print $2}' | egrep -v 'information_schema|performance_schema') )


if ! [ -d "${BACKUPLOCATION}" ]; then
    mkdir -p "${BACKUPLOCATION}" 2> /dev/null 1>&2
    if ! [ "$?" = "0" ]; then
        echo "failed to create $BACKUPLOCATION"
        exit 1
    fi
fi

if ! [ -w "${BACKUPLOCATION}" ]; then
    echo "$BACKUPLOCATION not writeable to user ${USER}"
    exit 1
fi

for db in ${DATABASES[*]}; do
    (mysqldump $db | gzip -c > "${BACKUPLOCATION}/${db}-${TIMESTAMP}.bak.gz") 2>> $LOGFILE 1>&2
    if ! [ "$?" = "0" ]; then
        echo "db ${db} failed" >> $LOGFILE
    fi
done


while ! [ "${FILESINDIR}" = "${VTK}" ]; do
    # find oldest file in dir, remove it, find the new oldest file, until there are only VTK files left of each backup
    FILESINDIR="$(find "${BACKUPLOCATION}" -maxdepth 1 | awk -F\- '/bak.gz/{print $2"-"$3}' | sort -ru | wc -l)"
    FILESTORM="$(find "${BACKUPLOCATION}" -maxdepth 1 | awk -F\- '/bak.gz/{print $2"-"$3}' | sort -ru | tail -1)"
    find "${BACKUPLOCATION}" -name '*'"${FILESTORM}" -exec rm {} \;
    sleep 1
done

