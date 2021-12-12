#!/bin/bash
#@author	Sebastian Insausti <sinsausti.uy@gmail.com>
#@since		2021-12-11

SERVER="XXXX"

DIR=/source/dir
DIRSUB="py docs"
TRG=/target/dir
#DRY="--dry-run"
DRY=""

function doSync {
	DIRSYNC="$DIR"/"$1"
	echo
	echo "Sync $DIRSYNC"
	echo
	echo /usr/bin/rsync -av $SERVER:$DIRSYNC $TRG --exclude '*.pyc' --delete --stats $DRY
	/usr/bin/rsync -av $SERVER:$DIRSYNC $trg --exclude '*.pyc' --delete --stats $DRY
}

### MAIN ###
for i in $DIRSUB; do
	doSync $i
done
