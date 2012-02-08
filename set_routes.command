#!/bin/sh

# mac os x script to add routes depeding on your source network
# replace network addresses with your own

SUDO_ASKPASS="/Applications/Utilities/Keychain\ Access.app/Contents/MacOS/Keychain\ Access"

get_addr() {
	ifconfig | awk '/inet 172.12/{print $2}'
}

		ADDRESS=$(get_addr)
		# networks where these routes are needed, else skip
                ALLOWED_NETS=( 1 3 5 )
                declare -a SUBNET
                NET=( ${ADDRESS//./ } )
				# create third octect variable
				SUBNET=${NET[2]}
#				echo ${SUBNET}
                for s in ${ALLOWED_NETS[*]}; do
#				echo $s
                        if [ ${s} == "${SUBNET}" ]; then
								sudo route -n add -net 192.168.0.0/24 172.12.${SUBNET}.254 >> /tmp/subnet.tmp
                        fi
                done


