#!/bin/bash

### DCA WEEKLY SCRIPT ###
# This scripts is to know when was the best day for buying a crypto token/currency last week (starting on Sunday). #
# It is useful to follow a weekly DCA strategy. #
# A token is required as parameter. E.g.
# $./dca-weekly.sh BTC
# Add a cron job in this way:
# 0 2 * * * /root/dca-script/dca-weekly.sh BTC
# This will run the script once a day at 2:00 AM.
# Also, you can configure a Telegram bot to receive the notifications.
#
#@author	Sebastian Insausti <sinsausti.uy@gmail.com>
#@since		2021-12-11

#Token required
if [ $# -eq 0 ]
        then
        echo "Error: You must specify a token."
        exit 1
fi

#Telegram Bot
CHAT_ID=XXXX
BOT_TOKEN=XXXX

#Variables
TOKEN=$1
LOG=/root/dca-script/$TOKEN-dca.log
LOG_OLD=/root/dca-script/$TOKEN-dca.log1
FILE=/root/dca-script/$TOKEN-price.txt
FILE_OLD=/root/dca-script/$TOKEN-price.txt1
PRICE=`/bin/curl -s https://api.coinbase.com/v2/prices/$TOKEN-USD/spot?currency=USD | /bin/python3 -c "import sys, json; print(json.load(sys.stdin)['data'])" |awk '{ print $6 }' |cut -c2- |cut -d '.' -f 1`
DAY=`date +%A`

#Starting the job
#Logging
echo "RUNNING $TOKEN DCA SCRIPT" > $LOG
echo "Starting at: `date`" >> $LOG
echo "$DAY - $PRICE" >> $LOG
echo "Finishing at: `date`" >> $LOG
echo "" >> $LOG

#Writing the file
echo "$DAY - $PRICE" >> $FILE

#Checking the current day
if [ $DAY == "Saturday" ]
	then
	LOWEST=$(grep -o '[0-9]*' $FILE | sort -n | head -1)
	WINNER=`grep $LOWEST $FILE`
	echo "The best day for buying $TOKEN this week was on: $WINNER" >> $FILE
	/bin/curl -s --data "text=`cat $FILE`" --data "chat_id=$CHAT_ID" 'https://api.telegram.org/bot'$BOT_TOKEN'/sendMessage' > /dev/null
	mv -f $FILE $FILE_OLD
	mv -f $LOG $LOG_OLD
	echo "$TOKEN DCA SCRIPT" >> $FILE
fi
#Done
