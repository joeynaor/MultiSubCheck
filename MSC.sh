#!/bin/bash
clear
echo -e "
\e[96m __  __       _ _   _  _____       _      _____ _               _\e[0m
\e[95m|  \/  |     | | | (_)/ ____|     | |    / ____| |             | |v0.1\e[0m
\e[94m| \  / |_   _| | |_ _| (___  _   _| |__ | |    | |__   ___  ___| | __\e[0m
\e[94m| |\/| | | | | | __| |\___ \| | | | '_ \| |    | '_ \ / _ \/ __| |/ /\e[0m
\e[95m| |  | | |_| | | |_| |____) | |_| | |_) | |____| | | |  __/ (__|   <\e[0m
\e[96m|_|  |_|\__,_|_|\__|_|_____/ \__,_|_.__/ \_____|_| |_|\___|\___|_|\_\\ \e[0m
  \e[96mby\e[0m \e[95mn0khodsia\e[0m              \e[96mhttps://github.com/\e[0m\e[95mn0khodsia/MultiSubCheck\e[0m
     \e[96mgithub.com/\e[0m\e[95mn0khodsia\e[0m


"
# Exit if no argument was added OR the formant is not domain.com
if [ -z $1 ] || ! [[ $1 =~ [.] ]] || [[ $1 =~ [/] ]]; then
  echo -e "Usage: ./MSC.sh domain.com"
  exit 1
fi

# Main menu
echo -e "Domain to scan: \e[42m$1\e[0m"
echo -e "Choose Action:"
echo -e "	1) Subdomain scan"
echo -e "	2) CNAME scan"
echo -e "	3) Subdomain takeover check"
echo -e "	4) HTTP Method check"

# Subdomain scan function (1)
function one {
  # If scan file exists, exit
	input="scans/$1"
	if [ -d "$input" ]; then
    echo -e "\e[91m$1 Was already scanned. Delete the directory to scan again.\e[0m"
    exit 1
	fi

	input="scans"
	if [ ! -d "$input" ]; then
    echo -e "\e[92m[+]\e[0m Creating scans directory"
    mkdir scans
	fi

  echo -e "\e[92m[+]\e[0m Creating scans/$1 directory ..."
	mkdir scans/$1
	echo -e "Sanning subdomains on $1..."
	python sublist3r.py -d $1 -o scans/$1/subdomains.list || { echo "Could not launch sublist3r. Please follow the installation process on github."; exit 1 }
	echo -e "\e[92m[+]\e[0m Scan done. list saved to scans/$1/subdomains.list"
}

function two {
  input="scans/$1/subdomains.list"

  if [ ! -f "$input" ]; then
  	echo -e "\e[91m$input does not exist. Run Sub scan first.\e[0m"
  	exit 1
  fi

  while IFS= read -r line
  do
          echo -e "Checking CNAME record on $line ..."
          dig A $line @8.8.8.8 | grep CNAME >> scans/$1/CNAME.scan
  done < "$input"
  echo -e "\e[92m[+]\e[0m Scan Done. log saved to scans/$1/CNAME.scan"
}

function three {
  input="scans/$1/CNAME.scan"
  if [ ! -f "$input" ]; then
          echo -e "\e[91m$input does not exist. Run CNAME check first.\e[0m"
          exit 1
  fi

  echo -e "############### Checking Known CNAME on $1 subdomains"
  echo -e "############### Checking for AWS ... "
  while IFS= read -r line
  do
  	if [[ $line =~ "s3" ]]
  	then
  	echo -e "$line"
  	fi
  done < "$input"

  echo -e "############## Checking for Github ... "
  input="scans/$1/CNAME.scan"
  while IFS= read -r line
  do
          if [[ $line =~ "github" ]]
          then
          echo -e "$line"
          fi
  done < "$input"

  echo -e "############## Checking for Heroku ... "
  input="scans/$1/CNAME.scan"
  while IFS= read -r line
  do
          if [[ $line =~ "herokudns" ]]
          then
          echo -e "$line"
          fi
  done < "$input"

  echo -e "############## Checking for Readme.io ... "
  input="scans/$1/CNAME.scan"
  while IFS= read -r line
  do
          if [[ $line =~ "readme" ]]
          then
          echo -e "$line"
          fi
  done < "$input"

  echo -e "############## Checking for Ghost ... "
  input="scans/$1/CNAME.scan"
  while IFS= read -r line
  do
          if [[ $line =~ "ghost" ]]
          then
          echo -e "$line"
          fi
  done < "$input"

  echo -e "############## Checking for Bitbucket ... "
  input="scans/$1/CNAME.scan"
  while IFS= read -r line
  do
          if [[ $line =~ "bitbucket" ]]
          then
          echo -e "$line"
          fi
  done < "$input"

  echo -e "########################## DONE #############################"
  echo -e "#############################################################"
  echo -e "### TAKEOVER INFO: https://0xpatrik.com/takeover-proofs/ ####"
  echo -e "#############################################################"
}

function four {
  input="scans/$1/subdomains.list"
  if [ ! -f "$input" ]; then
          echo -e "$input does not exist. Run Sub scan first"
          exit 1
  fi

  while IFS= read -r line
  do
  	echo -e "Checking HTTP methods on port 80 for $line ..."
  	nmap -p 80 --script http-methods $line  >> scans/$1/methods.scan
  	echo -e "Checking HTTP methods on port 443 for $line ..."
  	nmap -p 443 --script http-methods $line  >> scans/$1/methods.scan
  done < "$input"
  echo -e "\e[92m[+]\e[0m Scan Done. Scan saved to scans/$1/methods.scan"
  echo -e "\e[92m[+]\e[0m Grepping risky methods from entire scan:"
  cat scans/$1/methods.scan | grep risky
}

read choise

if [ "$choise" == "1" ]; then
  one $1
fi

if [ "$choise" == "2" ]; then
  two $1
fi

if [ "$choise" == "3" ]; then
  three $1
fi

if [ "$choise" == "4" ]; then
  four $1
fi
