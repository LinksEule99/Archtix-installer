#!/bin/bash

init_system=none
mirror_country=none
timezone=none
keyboard=none
timezone=none
locale=none
kernel=none

root_menu() {
	select_menu=$(gum choose "init" "mirrors" "locals" "disk" "kernel" "hostname" "root passwd")
	case $select_menu in
	"init") init_menu ;;
	"mirrors") mirrors_menu ;;
	"locals") locals_menu ;;
	"disk") disc_menu ;;
	"kernel") kernel_menu ;;
	"hostname") hostname_menu ;;
	"root passwd") root_passwd_menu ;;
	esac
}
init_menu() {
	select_menu=$(gum choose "return" "dinit" "openrc" "s6-rc" "runit" "Systemd")
	if [[ $select_menu == return ]]; then
		root_menu
	else
		init_system=$select_menu
		root_menu
	fi
}
mirrors_menu() {
	countries=$(reflector --list-countries | sed 's/^[[:space:]]*[0-9]*[[:space:]]*//')
	select_menu=$(printf "return\n%s" "$countries" | gum choose)
	if [[ "$select_menu" == "return" ]]; then
		root_menu
	else
		mirror_country="$selcet_menu"
		root_menu
	fi
}
locals_menu() {
	keyboard_menu() {
		mapfile -t keymaps < <(find /usr/share/kbd/keymaps/ -type f -name "*.map.gz" |
			sed 's|.*/||;s|\.map\.gz$||' | sort)
		select_menu=$(printf "%s\n" "return" "${keymaps[@]}" | gum choose)
		if [ "$select_menu" != "return" ]; then
			loadkeys "$select_menu"
			keyboard="$select_menu"
		fi
		locals_menu
	}
	timezone_menu() {
		continent() {
			mapfile -t city < <(find /usr/share/zoneinfo/"$1" -type f | sed 's|/usr/share/zoneinfo/||' | sort)
			select_menu=$(printf "%s\n" "return" "${city[@]}" | gum choose)
			if [ "$selcet_menu" == "return" ]; then
				timezone_menu
			else
				timezone="$selcet_menu"
				unset -f continent
				locals_menu
			fi
		}
		mapfile -t continent < <(find /usr/share/zoneinfo/ -maxdepth 1 -type d | tail -n +2 | sed 's|.*/||')
		selcet_menu=$(printf "%s\n" "return" "${continent[@]}" | gum choose)
		if [ "$selcet_menu" == "return" ]; then
			locals_menu
		else
			continent "$selcet_menu"
		fi
	}
	language_menu() {
		mapfile -t locales < <(grep -E 'UTF-8' /etc/locale.gen | sed 's/#//; s/ UTF-8//')
		selcet_menu=$(printf "%s\n" "return" "${locales[@]}" | gum choose)
		if [ "$selcet_menu" == "return" ]; then
			locals_menu
		else
			locale="$selcet_menu"
			locals_menu
		fi
	}
	select_menu=$(gum choose "return" "keyboard" "timezone" "language")
	case $select_menu in
	"return")
		root_menu
		unset -f keyboard_menu
		unset -f timezone_menu
		unset -f language_menu
		;;
	"keyboard") keyboard_menu ;;
	"timezone") timezone_menu ;;
	"language") language_menu ;;
	esac

}
kernel_menu() {
	select_menu=$(gum choose "return" "linux" "linux-lts" "linux-hardened" "linux-zen")
	if [[ $select_menu == "return" ]]; then
		root_menu
	else
		kernel=$select_menu
		root_menu
	fi

}


root_menu
