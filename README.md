# tfenv
A really dumb way of managing your terraform environments.

### Usage
Copy the shell script to your terraform directory (the same directory that holds your tfstate and tfvars files). If you have existing tfstate and tfvars files you will need to copy them to your preferred environment name:
```
$ mv terraform.tfstate terraform.production.tfstate
$ mv terraform.tfvars terraform.production.tfvars
```
Then run the script 
```
$ ./tfenv.sh
```
This will create the .tfenv directory and switch file. Open this file and add a line for the environment you currently have, and ones you plan on creating
```
production
qa
development
```

Run ./tfenv.sh one more time and select the environment you wish to work in:
```
Switching environments

prod
qa
development

Environment to switch to: 
prod
Setting state and variable files to use prod configurations: 
terraform.production.tfstate
terraform.production.tfvars
Complete
```

Basically this script copies terraform.$ENVIRONMENT.{tfstate,tfvars} to terraform.{tfstate,tfvars} and back and forth as necessary.
