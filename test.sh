#!/bin/bash 

root_menu() { 
	myvar=$(gum choose "init" "mirrors" "locals" "disk" "kernel" "hostname" "root passwd")
}
root_menu 
root_menu
echo $myvar
