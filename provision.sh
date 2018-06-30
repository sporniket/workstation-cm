# Exit immediately on failure
set -e

# Print the commands as they are executed
set -x

# Set the VM Name
echo 'workstation-cm' > /etc/hostname

# Authorize Vagrant's insecure public SSH key
mkdir /home/vagrant/.ssh/
chmod 700 /home/vagrant/.ssh/
wget https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant: /home/vagrant/.ssh/

# Set root password to "vagrant"
echo root:vagrant | chpasswd

# Passwordless sudo
echo '\nvagrant ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers



# Update/upgrade
apt-get update
apt-get full-upgrade -y

################################################################################
# Workstation Customisation
#
# This process will install any publicly available ressource needed to
# simplify the Vagrant provisionning
################################################################################

#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Bash user default
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
echo '#Grant that there is a directory at ~/.bashrc.d/enabled
if [ ! -d "~/.bashrc.d/enabled" ]; then
  mkdir -p ~/.bashrc.d/enabled
fi

#load configs from .bashrc.d
reload-bashrc () {
  for rc in $(ls ~/.bashrc.d/enabled); do source ~/.bashrc.d/enabled/$rc ; done
}

reload-bashrc'>/etc/skel/.bash_aliases
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
mkdir -p /etc/skel/.bashrc.d/enabled
mkdir -p /etc/skel/.bashrc.d/available
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# French support
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#language pack
apt-get install -y $(check-language-support -l fr)
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#keyboard
mv /etc/default/keyboard /etc/default/keyboard.orig
sed -e 's,"us","fr",' /etc/default/keyboard.orig > /etc/default/keyboard
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#locale
locale-gen fr_FR.UTF-8
update-locale LANG=fr_FR.UTF-8
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Network toolset
apt-get install -y wget curl
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Git
apt-get install -y git
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Default settings
wget -O /etc/gitconfig https://raw.githubusercontent.com/sporniket/sporniket-workstation/master/src-deb/1-second-stage/git-extras/etc/gitconfig
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Git prompt
[ ! -d /usr/share/git-extras ] && mkdir -p /usr/share/git-extras
wget -O /usr/share/git-extras/git-prompt.sh https://github.com/git/git/raw/master/contrib/completion/git-prompt.sh
wget -O /etc/skel/.bashrc.d/available/90-git-prompt https://raw.githubusercontent.com/sporniket/sporniket-workstation/master/src-deb/1-second-stage/git-extras/usr/share/git-extras/bashrc.append
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Java development toolset
apt-get install -y openjdk-8-jdk
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Atom text editor
add-apt-repository ppa:webupd8team/atom
apt-get update
apt-get install -y atom
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Preinstall packages
apm install atom-beautify
apm install editorconfig

#put in user template
cp -Rf ~/.atom /etc/skel
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# nvm
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Install
[ ! -d /etc/skel/opt ] && mkdir -p /etc/skel/opt
cd /etc/skel/opt
git clone https://github.com/creationix/nvm.git
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Add to bash sourcing
echo '#!/bin/bash

#setup nvm
export NVM_DIR="$HOME/opt/nvm"

# Loads nvm
[ -z "$(command -v nvm)" ] && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
'>/etc/skel/.bashrc.d/available/50-nvm
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Docker and docker-compose
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Docker CE
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

#To do in a next release : fail if the following sequence don't give '1' as a result.
#apt-key fingerprint 0EBFCD88 | grep "Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88" | wc -l

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get update
apt-get install -y docker-ce
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# Docker-compose
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# bash completion
curl -L https://raw.githubusercontent.com/docker/compose/1.21.2/contrib/completion/bash/docker-compose
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Title
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# SubTitle
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====

################################################################################

# Delete stuff
apt-get --purge autoremove
apt-get clean

rm -rf /var/log/*
rm -rf /home/vagrant/.cache/*
rm -rf /root/.cache/*
rm -rf /var/cache/*
rm -rf /var/tmp/*
rm -rf /tmp/*

# Clear recent bash history
cat /dev/null > /home/vagrant/.bash_history
cat /dev/null > /root/.bash_history

# Fill empty space with zeroes
# This should allow for a smaller archive of the disk
#set +e
# This is supposed to crash with an error message:
#   "dd: error writing 'zerofile': No space left on device"
#dd if=/dev/zero of=zerofile bs=1M
#set -e
#
#rm -f zerofile
sync
