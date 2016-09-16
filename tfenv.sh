#!/usr/bin/env bash

if [ ! -d .tfenv ]
then
	echo "This is your first time running tfenv.sh. Creating .tfenv directory, switch file, and back up directory."
	echo "After that is complete you will need to update .tfenv/switch to list all of the environments you want to"
	echo "manage in this instance. If you have existing tfstate or tfvars files you will need to rename them "
	echo "appropriately so that they reflect the environment they are tied to. i.e.:"
	echo "  $ mv terraform.tfstate terraform.production.tfstate"
	echo "  $ mv terraform.tfvars terraform.production.tfvars"
	echo ""
	mkdir -p ./.tfenv/backups
	touch ./.tfenv/switch
else

	if [ -s ./.tfenv/switch ]
	then
		echo "Switching environments"
		CURRENT_ENVS=`cat ./.tfenv/switch`
		DEFAULT_ENVS=`echo "$CURRENT_ENVS" | cut -d " " -f 1`
		CURRENT_ENV=`grep ".*[CURRENT]" ./.tfenv/switch | cut -d " " -f 1`
		echo ""
		echo "$CURRENT_ENVS"
		echo ""
		echo "Environment to switch to: "
		read e
		echo "Setting state and variable files to use $e configurations: "
		echo "terraform.${e}.tfstate"
		echo "terraform.${e}.tfvars"
		D=`date +%s`
		if [ -f "terraform.${CURRENT_ENV}.tfstate" ]
		then
			cp terraform.${CURRENT_ENV}.tfstate ./.tfenv/backups/terraform.${CURRENT_ENV}.tfstate.${D}
		fi
		cp terraform.${CURRENT_ENV}.tfvars ./.tfenv/backups/terraform.${CURRENT_ENV}.tfvars.${D}
		if [ -f "terraform.tfstate" ]
		then
			cat terraform.tfstate > terraform.${CURRENT_ENV}.tfstate
		fi
		cat terraform.tfvars > terraform.${CURRENT_ENV}.tfvars
		if [[ ! -f "terraform.${e}.tfstate" && ! -f "terraform.${e}.tfvars" ]]
		then
			# Empty vars, remove state
			echo "It appears you have added a new configuration. Creating a blank tfvars file (the state file will create when you use terraform)."
			touch terraform.${e}.tfvars
			touch terraform.tfvars
			echo "" > terraform.tfvars
			rm terraform.tfstate
		else
			if [ -f "terraform.${e}.tfstate" ]
			then
				cat terraform.${e}.tfstate > terraform.tfstate
			fi
			cat terraform.${e}.tfvars > terraform.tfvars
		fi

		O=`echo "$DEFAULT_ENVS" | sed -e 's/^'"$e"'$/'"$e"' [CURRENT]/g'`
		echo "$O" > ./.tfenv/switch
	
		echo "Complete"
		exit 0
	else
		echo ".tfenv/switch is either empty or missing. Create it with one environment per line."
		exit -1
	fi
fi
