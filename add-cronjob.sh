#!/bin/bash

CURRENT_DIR=`pwd`
DOWNLOADER_FILENAME="download-cwa-data.sh"

(crontab -l && echo "0 */6 * * * cd $CURRENT_DIR && ./$DOWNLOADER_FILENAME") | crontab -

# * * * * * "command to be executed"
# - - - - -
# | | | | |
# | | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
# | | | ------- Month (1 - 12)
# | | --------- Day of month (1 - 31)
# | ----------- Hour (0 - 23)
# ------------- Minute (0 - 59)

# edit crontab interactively:
# crontab -e
