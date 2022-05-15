echo "deb http://deb.librewolf.net focal main" >>  /etc/apt/sources.list.d/librewolf.list
wget https://deb.librewolf.net/keyring.gpg -O /etc/apt/trusted.gpg.d/librewolf.gpg
apt update
apt install librewolf -y