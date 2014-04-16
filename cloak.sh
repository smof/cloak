#!/bin/bash
#Simon Moffatt April 2014 - basic file encryption suite using OpenSSL

#dependencies
#check that jq util is present
OPENSSL_LOC="$(which openssl)"
if [ "$JQ_LOC" = "" ]; then
   	echo "OpenSSL not found! Please install before running ./cloak.sh "
   	exit
fi


#main menu interface #################################################################################################################################################################################
function menu() { 
	
	clear
	echo "Cloak v0.1 - file encryption and signing wrapper utility"
	echo "----------------------------------------------------------------------------------"
	echo ""
	echo "1: Encrypt file using public key"	
	echo "2: Decrypt file using private key"
	echo "3: Sign file with private key"
	echo "4: Verify and recover file"
	echo ""
	echo "X: Exit"
	echo "----------------------------------------------------------------------------------"
	echo "Select an option:"
	read option

	case $option in

		1)
			encrypt
			;;
			
			
		2)
			decrypt
			;;
			
		3)
			sign
			;;
			
		4)
			verify_recover
			;;

		[x] | [X])
				clear	
				echo "Byeeeeeeeeeeeeeeeeeee :)"
				echo ""			
				exit
				;;
	
		#[c] | [C])

		#	config
			#;;

		*)

			menu
			;;
	esac

}
#main menu interface #################################################################################################################################################################################

function split_file() {
	
			clear
			echo "The following files exist in this directory:"
			echo ""
			ls
			echo ""
			echo "Enter the name of the file to split:"
			read file_to_split
			echo ""
			echo "Enter the size of split files in MB:"
			read split_size
			echo ""
			split  
			echo ""
			echo "Recovered file saved to $file_to_verify.recovered"
			echo ""
			read -p "Press [Enter] to return to menu"
			menu
			
}


function verify_recover() {
	
			clear
			echo "The following files exist in this directory:"
			echo ""
			ls
			echo ""
			echo "Enter the name of the file to verify & recover after signing (or full path to a file in a different directory):"
			read file_to_verify
			echo ""
			echo "The following key files exist in your .ssh directory:"
			echo ""
			ls ~/.ssh/
			echo ""
			echo "Enter the name of the key file to verify the file with:"
			read verifying_key_file
			echo ""
			#verifyrecover using openssl
			openssl pkeyutl -verifyrecover -in $file_to_verify -inkey ~/.ssh/$verifying_key_file > $file_to_verify.recovered 
			echo ""
			echo "Recovered file saved to $file_to_verify.recovered"
			echo ""
			read -p "Press [Enter] to return to menu"
			menu
	
}


function sign() {
		
			clear
			echo "The following files exist in this directory:"
			echo ""
			ls
			echo ""
			echo "Enter the name of the file to sign (or full path to a file in a different directory):"
			read file_to_sign
			echo ""
			echo "The following key files exist in your .ssh directory:"
			echo ""
			ls ~/.ssh/
			echo ""
			echo "Enter the name of the key file to sign the file with:"
			read signing_key_file
			echo ""
			#sign using openssl
			openssl pkeyutl -sign -in access -inkey ~/.ssh/$signing_key_file -out access.signed
			echo ""
			echo "Signed file saved to $file_to_sign.signed"
			echo ""
			read -p "Press [Enter] to return to menu"
			menu

}

function decrypt() {
	
			
			clear
			echo "The following files exist in this directory:"
			echo ""
			ls
			echo ""
			echo "Enter the name of the file to decrypt (or full path to a file in a different directory):"
			read file_to_decrypt
			echo ""
			echo "The following key files exist in your .ssh directory:"
			echo ""
			ls ~/.ssh/
			echo ""
			echo "Enter the name of the key file to decrypt the file with:"
			read decryption_key_file
			#decrypt using openssl
			openssl pkeyutl -decrypt -in $file_to_decrypt -out $file_to_decrypt.decrypted -inkey ~/.ssh/$decryption_key_file
			echo ""
			echo "Decrypted file saved to $file_to_decrypt.decrypted"
			echo ""
			read -p "Press [Enter] to return to menu"
			menu
				
}

function encrypt() {
	
			
			clear
			echo "The following files exist in this directory:"
			echo ""
			ls
			echo ""
			echo "Enter the name of the file to encrypt (or full path to a file in a different directory):"
			read file_to_encrypt
			echo ""
			echo "The following key files exist in your .ssh directory:"
			echo ""
			ls ~/.ssh/
			echo ""
			echo "Enter the name of the key file to encrypt data with:"
			read encryption_key_file
			echo ""
			#encrypt using openssl
			openssl pkeyutl -encrypt -pubin -in $file_to_encrypt -out $file_to_encrypt.encrypted -inkey ~/.ssh/$encryption_key_file
			echo ""
			echo "Encrypted file saved to $file_to_encrypt.encrypted"
			echo ""
			read -p "Press [Enter] to return to menu"
			menu
			
}

#initiate menu
menu
