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
		"return") root_menu;;
		"dinit") init_system=1;  root_menu;;
		"openrc") init_system=2;  root_menu;;
		"s6-rc") init_system=3;  root_menu;;
		"runit") init_system=4;  root_menu;;
		"Systemd") init_system=5;  root_menu;;
	esac  
} 
mirrors_menu() { 
	countries=$(reflector --list-countries | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//')
	selected_country=$(printf "return\n%s" "$countries" | gum choose)
	if [[ "$selected_country" == "return" ]]; then
        	root_menu  
		$selceted_country = none
	else 
		root_menu
   	fi
} 
locals_menu() {
	keyboard_menu() {
	      	mapfile -t keymaps < <(find /usr/share/kbd/keymaps/ -type f -name "*.map.gz" \
  | sed 's|.*/||;s|\.map\.gz$||' | sort)
		keyboard=$( printf "return\n%s" "${keymaps[@]}" | gum choose)
		if [ "$keyboard" != "return" ];then
			loadkeys "$keyboard"
		fi 
		locals_menu
	}
	timezone_menu() { 
		continent() { 	
			mapfile -t city< <(find /usr/share/zoneinfo/"$1" -type f | sed 's|/usr/share/zoneinfo/||' | sort)
			timezone=$(printf "return\n%s" "${city}" | gum choose)



		
		mapfile -t continent< <(find /usr/share/zoneinfo/ -maxdepth 1 -type d | tail -n +2 | sed 's|.*/||')
		selcet_menu=$( printf "return\n%s" "${continent[@]}" | gum choose)
		continent $selcet_menu 
		unset -f continent
		locals_menu
		}	
	}
	select_menu=$(gum choose "return" "keyboard" "timezone" "language")
	case $select_menu in 
		"return") root_menu; unset -f keyboard_menu; unset -f timezone_menu; unset -f language_menu;;
		"keyboard") keyboard_menu;;
		"timezone") timezone_menu;;
		"language") language_menu;;
	esac


}
root_menu
