# Vagrant provisioning
#
# 1 -- username to create developper account (sudoer)
# 2 -- display name to create developper account (sudoer)
#
# Goal : create and setup developper account
#
# User name login will be the password, to be changed by the user manually
#

################################################################################
# Workstation system-wide customisation
#
# Gathers any customisation not tied to the user.
################################################################################

#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# Title
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
# SubTitle
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====

################################################################################
# User creation and permission settings
################################################################################

# Force all lowercase username
USER_NAME="${1,,}"
id -u ${USER_NAME} > /dev/null
if [ $? -eq 1 ]; then
	echo "Creating user ${USER_NAME}"
	adduser --gecos "${2},,," "${USER_NAME}"
	echo "${USER_NAME}:${USER_NAME}" | chpasswd

	#adding to the same groups as 'vagrant' user
	for grp in $(grep "vagrant" /etc/group | grep --only-matching "^[a-z]*");do echo "adding to group '$grp'"; usermod --append --groups $grp ${USER_NAME} ; done

	#add to the docker group
	usermod -aG docker ${USER_NAME}

	#add to the sudo group
	usermod -aG sudo ${USER_NAME}
fi
if [ $(grep "${USER_NAME}" /etc/sudoers | wc -l) -eq 0 ]; then
	echo "Adding user '${USER_NAME}' to sudoers"
	echo "${USER_NAME}  ALL=(ALL:ALL) ALL" >> /etc/sudoers
	cat /etc/sudoers
fi
#
# From now, /home/${USER_NAME} exists and is initialised
TARGET_HOME="/home/${USER_NAME}"

################################################################################
# Workstation user-wide customisation
#
# Gathers any customisation tied to the user.
################################################################################

#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====
# enable all files in ~/.bashrc.d/available
# ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
cd $TARGET_HOME/.bashrc.d/enabled
for fic in $(ls $TARGET_HOME/.bashrc.d/available); do
	echo "Enabling $fic"
	ln -s ../available/$fic $fic
done
#-====-====-====-====-====-====-====-====-====-====-====-====-====-====-====

# [TODO] to be continued...

#
# You did it, have a nice day.
#
