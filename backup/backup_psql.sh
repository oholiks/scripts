#!/bin/bash
# will backup all databases and keep a set number of versions

BACKUP_USER="postgres"
BACKUPLOCATION="/var/lib/pgsql/backups"
HOSTNAME="localhost"
LOGFILE="${BACKUPLOCATION}/pgsqlbackup.log"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
# Days to keep
DTK="7"

DATABASES="select datname from pg_database where not datistemplate and datallowconn order by datname;"


if [ $(id -un) != ${BACKUP_USER} ]; then
    echo "Script must run as $BACKUP_USER"
    exit 1
fi

if ! [ -d "${BACKUPLOCATION}" ]; then
    mkdir -p ${BACKUPLOCATION} 2> /dev/null 1>&2
    if ! [ "$?" = "0" ]; then
        echo "failed to create ${BACKUPLOCATION}"
        exit 1
    fi
fi

if ! [ -w "${BACKUPLOCATION}" ]; then
    echo "${BACKUPLOCATION} not writeable to user ${USER}"
    exit 1
fi

for DATABASE in $(psql -At -c "${DATABASES}"); do
    STATUS=""
    STARTTIME="$(date +%s)"
    if ! pg_dump -Fp "${DATABASE}" | gzip > ${BACKUPLOCATION}/${DATABASE}.sql.gz.in_progress; then
        STATUS="FAILED"
    else
        mv ${BACKUPLOCATION}/${DATABASE}.sql.gz.in_progress ${BACKUPLOCATION}/${DATABASE}-${TIMESTAMP}.sql.gz
        STATUS="OK"
    fi
    ENDTIME="$(date +%s)"
    echo "${TIMESTAMP}: ${DATABASE} ${STATUS} elapsed $((${ENDTIME}-${STARTTIME})) seconds" >> ${LOGFILE}
done

find ${BACKUPLOCATION} -maxdepth 1 -name '*.sql.gz'  -daystart -mtime +${DTK} -exec rm -f {} \+
