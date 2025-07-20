#!/bin/bash 

root_menu() { 
	select_menu=$(gum choose "init" "mirrors" "locals" "disk" "kernel" "hostname" "root passwd")
	case $select_menu in 
		"init") init_menu;;
		"mirrors") mirrors_menu;;
		"locals") locals_menu;;
		"disk") disk_menu;;
		"kernel") kernel_menu;;
		"hostname") hostname_menu;;
		"root passwd") root_passwd_menu;;
	esac
}
init_menu() { 
	select_menu=$(gum choose "return" "dinit" "openrc" "s6-rc" "runit" "Systemd")
	case $select_menu in 	
		"return <--") root_menu;;
		"dinit") init_system=1;  root_menu;;
		"openrc") init_system=2;  root_menu;;
		"s6-rc") init_system=3;  root_menu;;
		"runit") init_system=4;  root_menu;;
		"Systemd") init_system=5;  root_menu;;
	esac  
} 
mirrors_menu() { 
	selcet_menu=$(gum choose "return"   )
}      	
root_menu
