#!/bin/bash

# s3cmd sync docs/rekion/ s3://rekion/iiif/ --exclude '.DS_Store' && s3cmd setacl s3://rekion/iiif/ --acl-public --recursive

# ログファイルのパス
LOGFILE="sync_output.log"

# s3cmd sync コマンドの実行とログの保存
s3cmd sync docs/rekion/ s3://rekion/iiif/ --exclude '.DS_Store' > $LOGFILE

grep "upload:" $LOGFILE | awk -F"'" '{print $4}' | while read dst
do
    s3cmd setacl "${dst}" --acl-public
done

# ログファイルの削除
rm $LOGFILE

