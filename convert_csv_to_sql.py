import csv
import sys

def convert_csv_to_sql(csv_file, sql_file):
    with open(csv_file, mode='r') as infile, open(sql_file, mode='w') as outfile:
        reader = csv.DictReader(infile)
        outfile.write("INSERT INTO author (lname, fname, email) VALUES\n")
        first = True
        for row in reader:
            if not first:
                outfile.write(",\n")
            first = False
            outfile.write(f"('{row['lname']}', '{row['fname']}', '{row['email']}')")
        outfile.write(";\n")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 convert_csv_to_sql.py <input_csv_file> <output_sql_file>")
        sys.exit(1)
    convert_csv_to_sql(sys.argv[1], sys.argv[2])
