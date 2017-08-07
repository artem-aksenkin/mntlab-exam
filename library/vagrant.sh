#!/usr/bin/bash

function vagrant_up
	{
		if [ $(ls $dest | grep Vagrantfile) ] || [ -f "$dest" ]  ;  then
			cd $dest ; vagrant up
			while [ $( vagrant ssh-config | $? ) ] false
			do
				sleep 1
			done
			vagrant_ssh_config
			if [ $? -eq 0 ]; then
				printf '{"failed": false, "changed": true, "ip": "%s", "port": "%s", "user": "%s", "key": "%s", "status": "%s", "os_name": "%s", "ram": "%s"}' "$ip" "$port" "$user" "$key" "$status" "$os_name" "$ram"
				exit 0
			else
				printf '{"failed": true, "changed": false, "ip": "%s", "port": "%s", "user": "%s", "key": "%s", "status": "%s", "os_name": "%s", "ram": "%s"}' "$ip" "$port" "$user" "$key" "$status" "$os_name" "$ram"
				exit 1
			fi
		else
			printf '{"failed": true, "msg": "missing vagrant file at destination"}'
			exit 1
		fi
	}

function vagrant_halt
	{
		if [ $(ls $dest| grep Vagrantfile) ] || [ -f "$dest" ]; then
			cd $dest ; vagrant halt
			if [ $? -ne 0 ]; then
				printf '{"failed": true , "changed": true , "msg": "error halting vm"}'
				exit 1
			else
				printf '{"failed": false,"changed": true, "msg": "vm halted"}'
				exit 0
			fi
		fi
	}

function vagrant_destroy
	{
		if [ $(ls $dest| grep Vagrantfile) ] || [ -f "$dest" ] ; then
			cd $dest && vagrant destroy -f
			if [ vagrant ssh-config -ne 0 ]; then
				printf '{"failed": true , "changed": true , "msg": "error destroying vm"}'
				exit 1
			else
				printf '{"failed": false,"changed": true, "msg": "vm destroyed"}'
				exit 0
			fi
		else
			printf '{"failed": true,"changed": false, "msg": "missing vagrant file at destination"}'
			exit 1
		fi
	}

function vagrant_ssh_config
	{
		ip=$(vagrant ssh-config | grep HostName | awk '{print $2}')
	    port=$(vagrant ssh-config | grep Port | awk '{print $2}')
	    user=$(vagrant ssh-config | grep -w "User" | awk '{print $2}' 2>/dev/null)
   		key=$(vagrant ssh-config | grep IdentityFile | awk '{print $2}' 2>/dev/null)
    	status=$(vagrant status | grep default | awk '{print $2}')
    	os_name=$(vagrant ssh -c "cat /etc/redhat-release" 2>/dev/null)
    	ram=$(vagrant ssh -c "cat /proc/meminfo | grep MemTotal | awk '{print \$2}'" 2>/dev/null)
    }


source $1

if [ -z "$dest" ]; then
	printf '{"failed": true, "msg": "missing required arguments: dest"\n}'
	exit 1
fi

if [ -z "$state" ]; then
	exit 1
fi


case $state in
	started)
		vagrant_up
	;;
	stopped)
		vagrant_halt
	;;
	destroyed)
		vagrant_destroy
	;;
	ssh)
		vagrant_ssh_config
	;;
	*)
		printf '{"failed": true, "msg": "invalid state selected {started | stopped | destroyed}"\n}'
		exit 1
	;;
esac

exit 0
