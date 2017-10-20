# Usage

`docker run -e BUCKET= -e MYSQL_ROOT_PWD= -e PREFIX= -e MAX_BACKUPS= -e DES_DIR= --link db:mysql -v /key:/app zenyai/docker-mysqlbackup-gcloud`

Use `docker exec <container> /backup.sh` to take an immediate backup.

Backup every 2 am

References
 - https://github.com/nickbreen/docker-mysql-backup-cron
 - https://github.com/ecwillis/mysqlbackup-gcloud