#!/bin/bash

# Generate a (gzipped) dumpfile for each database specified in ${DBS}.
# Upload to gCloud

PREFIX=${PREFIX:-backup}

. /etc/container_environment.sh


# Bailout if any command fails
set -e

# Create a temporary directory to hold the backup files.
DIR=$(mktemp -d)

# Generate a timestamp to name the backup files with.
TS=$(date +%s)

# Backup all databases, unless a list of databases has been specified
if [ -z "$DBS" ]
then
	# Backup all DB's in bulk
	mysqldump -uroot -p$MYSQL_ROOT_PWD -hmysql --all-databases | gzip > $DIR/$PREFIX-all-databases-$TS.sql.gz
else
	# Backup each DB separately
	for DB in $DBS
	do
		mysqldump -uroot -p$MYSQL_ROOT_PWD -hmysql -B $DB | gzip > $DIR/$PREFIX-$DB-$TS.sql.gz
	done
fi

# Upload the backups to gcloud
gcloud auth activate-service-account --key-file /app/key.json

gsutil mv $DIR/* gs://$BUCKET

# Clean up
rm -rf $DIR
