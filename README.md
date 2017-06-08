# Usage

`docker run -e BUCKET= -e MYSQL_ROOT_PWD= -e PREFIX= --link db:mysql -v /key:/app zenyai/docker-mysqlbackup-gcloud`

Use `docker exec <container> /backup.sh` to take an immediate backup.

References
 - https://github.com/nickbreen/docker-mysql-backup-cron
 - https://github.com/ecwillis/mysqlbackup-gcloud