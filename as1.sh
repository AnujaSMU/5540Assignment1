#!/bin/bash
#
db="$1"
user="$2"
pass="$3"
#
echo
#### INSERT HERE the command to import from authors.json into MONGO collection author
mongoimport -d "$db" -p "$pass" -u "$user" -c author --file /home/course/u00/sk_public/authors.json
echo
echo "-> Imported authors.json into Mongodb collection \"author\""
echo
#### INSERT HERE the commands to export the MONGO collection and delete it
mongoexport -d "$db" -p "$pass" -u "$user" -c author --type=csv --fields=fname,lname,email --out authors.csv
echo "db.author.drop()" | mongo "$db" -u "$user" --password="$pass"
echo
echo "-> Exported collection \"author\" into authors.csv and deleted the collection"
#
mysql -u "$user" --password="$pass" "$db" -e "source create_author_table.sql;"
echo
echo "-> Created table \"author\" in MySQL database"
#
echo
#### INSERT HERE the commands to (possibly compile and) execute your program
python3 convert_csv_to_sql.py authors.csv insert_authors.sql
#
mysql -u "$user" --password="$pass" "$db" -e "source insert_authors.sql;"
rm authors.csv
rm insert_authors.sql
echo
echo "-> Inserted from authors.csv into table \"authors\", and deleted authors.csv"
#
mysql -u "$user" --password="$pass" "$db" -e "select * from author;" > "$user".txt
echo
echo "-> Contents of table \"author\" saved in file \"$user.txt\""
mysql -u "$user" --password="$pass" "$db" -e "drop table if exists author;"
echo
echo "-> Deleted table \"author\" from MySQL database. Bye!"
echo
