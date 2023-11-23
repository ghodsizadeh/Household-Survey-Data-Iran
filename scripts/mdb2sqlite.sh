#!/bin/bash
# Inspired by 
# https://www.codeenigma.com/community/blog/using-mdbtools-nix-convert-microsoft-access-mysql

# USAGE
# Rename your MDB file to migration-export.mdb 
# run ./mdb2sqlite.sh migration-export.mdb
# wait and wait a bit longer...
set -e

FileName=$1
Output=$2
echo $FileName
echo $Output

echo "mdb-schema "$FileName" sqlite > schema.sql"
mdb-schema "$FileName" sqlite > schema.sql
rm -rf sqlite
mkdir -p sqlite
mkdir -p sql
for i in $( mdb-tables "$FileName" ); do echo $i ; mdb-export -D "%Y-%m-%d %H:%M:%S" -H -I sqlite "$FileName" $i > sql/$i.sql; done

mv schema.sql sqlite
mv sql sqlite
cd sqlite

cat schema.sql | sqlite3 $Output

# for f in sql/* ; do echo $f && cat $f | sqlite3 db.sqlite3; done
for f in sql/* ; do echo $f && (echo 'BEGIN;'; cat $f; echo 'COMMIT;') | sqlite3 $Output; done


echo input: $1
echo  output: $2

