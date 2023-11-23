import subprocess as sp
import os
import re

# find all mdb files in the current directory and subdirectories
def find_mdb_files(path= '.'):
    mdb_files = sp.check_output(['find', path, '-name', '*.mdb']).decode('utf-8').split('\n')
    return mdb_files

# run mdb2sqlite.sh and get the output
def convert_mdb_to_sqlite(mdb_file):
    # get current working directory
    cwd = os.getcwd()
    
    mdb_number = re.findall('/(\d+)/', mdb_file)[0] 
    sqlite_name = '{}.sqlite3'.format(mdb_number)
    parent_folder = os.path.dirname(mdb_file)
    file_name = os.path.basename(mdb_file)
    
    os.chdir(parent_folder)
    output = sp.check_output(['bash', cwd+'/mdb2sqlite.sh',file_name,cwd +'/sqlites/'+ sqlite_name])
    print(os.getcwd())
    os.chdir(cwd)

    return output.decode()
# 

if __name__ == '__main__':
    mdb_files = find_mdb_files()
    for mdb in mdb_files:
        if mdb:
            tmp = convert_mdb_to_sqlite(mdb)
            print(tmp)