import json, os, subprocess

payload_file = input('What is the name of your file\n')

def payload_comsumption():
    file_name = payload_file
    try:
        with open('../payload/'f'{file_name}.tfvars.json', "r+") as file:
            load = json.load(file)
            return load
    except FileNotFoundError:
        print("File not found:", file_name)
        return False
    except json.JSONDecodeError:
        print("Invalid JSON format in file:", file_name)
        return False
    
def iam_validator(load):
    group_output = []
    for baselist in load:
        for nextlist in load[baselist]:
            data = nextlist.items()
            for key, value in data:
                if 'group_name' in key:
                    group_output.append(value)
                if 'user_group_association' in key:
                    association_output = value
            else: 
                None
    if group_output == association_output:
        return True
    else:
        return False

def tf_actuator():
    file_name = payload_file
    os.chdir('../terraform/proxmox-iam-manager')
    subprocess.Popen("terraform plan -var-file=../../payload/{}.tfvars.json -no-color > ../../payload/{}.txt".format(file_name,file_name), shell=True, stdout=subprocess.PIPE).stdout.read()
    os.chdir('../..')

if iam_validator(payload_comsumption()) == True:
    tf_actuator()
else:
    print('Checksum failed.')