#!/usr/bin/env bash

# ENV
# PRIVATE_KEY="~/.ssh/id_ed25519"
# REPO_DIR="/home/tzwm/syncthing/obsidian_data/"
# LOGFIRE_DIR="/home/tzwm/logs/cron_auto_commit_obsidian.log"

eval "$(ssh-agent -s)"
ssh-add $PRIVATE_KEY

cd $REPO_DIR

DATETIME=`date -Iminutes`
echo $DATETIME

git add --all . >> $LOGFIRE_DIR
git commit -m "Auto commit at $DATETIME" --quiet --no-verify >> $LOGFIRE_DIR
git push origin master >> $LOGFIRE_DIR
