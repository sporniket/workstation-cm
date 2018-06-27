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
# Network toolset
apt-get install -y wget curl
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# VCS toolset
apt-get install -y git
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Java development toolset
apt-get install -y openjdk-8-jdk
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Atom text editor
add-apt-repository ppa:webupd8team/atom
apt-get update
apt-get install -y atom

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
