#!/bin/bash


ALL_DEVICES_INIT=" Number of Initialized Devices"
SOME_DEVICES_NOT_INIT=" Initialization of Devices Failed"

function Color_Print {
	##	This function print data to stdout
	##
	##											Options: YES
	##	Local var: response, error_message		Return object: CodeError -1
	##				count, amount_init

	response="$1"
	if [[ "$response" != "" ]]; then
		printf "[ \e[32mOK\e[0m ] " && echo "$1" "$2" "$3"
		return
	fi

	error_message="$2" ; count="$3" ; amount_init="$4" ;
	printf "[ \e[31mNO\e[0m ] " && echo "$error_message" "$count" "$amount_init"
	return 1
}


function Check_Equality_Numbers {
	##	This function compares two numbers
	##
	##	Global var: ALL_DEVICES_INIT, SOME_DEVICES_NOT_INIT					Options: Yes
	##	Local var: count_initialized_devices, sum_initialized_devices		Return object: No

	count_initialized_devices=$1
	sum_initialized_devices=$2

	if ((count_initialized_devices = sum_initialized_devices)); then
		Color_Print "$ALL_DEVICES_INIT" "$count_initialized_devices" "of $sum_initialized_devices"
	else
		Color_Print "" "$SOME_DEVICES_NOT_INIT" "$count_initialized_devices" "of $sum_initialized_devices"
	fi
}


function Fmt_UsbDevices {
	##	This function display the number of USB devices			Options: No
	##
	##
	##	Local var: num_init_usb_devices, amount_usb_devices		Return object: No

	while read -r ; do
		Color_Print "$REPLY"
		sleep 0.3
		((num_init_usb_devices+=1))
	done < <(lsusb | grep -iE "bus [0-9]{3} device")

	amount_usb_devices=$(lsusb | wc -l)
	Check_Equality_Numbers "$num_init_usb_devices" "$amount_usb_devices"

	sleep 1
	lsusb -tv

	unset -v "num_init_usb_devices" "amount_usb_devices"
}

Fmt_UsbDevices
