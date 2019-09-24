# workstation-cm

> [WARNING] Please read carefully this note before using this project. It contains important facts.

Content

1. What is **workstation-cm**, and when to use it ?
2. What should you know before using **workstation-cm** ?
3. How to use **workstation-cm** ?
4. Known issues
5. Miscellanous

## 1. What is **workstation-cm**, and when to use it ?
**workstation-cm** is a Packer script that create an automated workstation based on Ubuntu taylored to my needs.

### What's new in v0.8.0

* fixed #28 : Preinstall GnuPG2
* fixed #31 : Gedit as git editor does not support the '--wait' with '--standalone' anymore

### What's new in v0.7.0

* upgraded to ubuntu 18.04.3
* fixed #30 : The atom ppa from webupd8team seems discontinued

### What's new in v0.6.0

* upgraded to ubuntu 18.04.2
* fixed : force non interactive mode for apt-get calls
* upgrade Eclipse to 2019-06
* #26 : Pre-install Atom-IDE packages for Javascript support
* #27 : Atom - do not install js-hyperclick


### What's new in v0.5.0

* #21 : preinstall gnome tweaks
* #22 : Eclipse desktop descriptor
* #23 : Preinstall backup script
* #24 : Download bash_aliases instead of inline generation
* #25 : Change eclipse version and replace checkstyle plugin

### What's new in v0.4.0

* #12 : preinstall some packages for Atom
* #11 : preinstall Eclipse Photon (4.8) with plugins
* #16 : fix keyboard layout to french (tentative fix)
* #20 : use VirtualBox 5.2 to generate the box
* based on Ubuntu 18.04.1

### What's new in v0.3.0

* #8 : git prompt
* #9 : git default configuration
* #10 : use vagrant-cloud post-processors (upload the box automatically to vagrant cloud)
* #13 : maven
* #15 : FIX hostname in /etc/hosts
* #14 : FIX install nvm in /etc/skel for new user being able to use it at all.

### What's new in v0.2.0

* #1 : Atom text editor.
* #3 : French language pack and locale.
* #4 : Default `.bash_aliases`.
* #6 : nvm.
* #7 : docker-ce and docker-compose.

### What's new in v0.1.0

Working script on my computer, will need tuning to work on another computer.

* build-essential
* wget
* curl
* git
* openjdk-8-jdk

### Licence
 **workstation-cm** is public domain as it gathers some public knowledge.

 **workstation-cm** is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


## 2. What should you know before using **workstation-cm** ?

**workstation-cm** relies HashiCorp Packer to generate the box.

https://www.packer.io/

**workstation-cm** generate a Vagrant box that will run on VirtualBox 5.1.

https://www.virtualbox.org/

**workstation-cm** is based on the project `box-ubuntu-budgie-18-x64` by Martin Andersson.

https://github.com/martinanderssondotcom/box-ubuntu-budgie-18-x64

> Do not use **workstation-cm** if this project is not suitable for your project

## 3. How to use **workstation-cm** ?

### Vagrant

Use the base box `sporniket/workstation-cm`.

### From source

_You MUST install Packer 1.2 and VirtualBox 5.1_

To get the latest available code, one must clone the git repository, build and install to the maven local repository.

	git clone https://github.com/sporniket/workstation-cm.git
	cd workstation-cm
	packer build template.json

  > Note : I had to define the `VAGRANT_CLOUD_TOKEN` environment variable.

  > Note : I had use the following command : `PACKER_KEY_INTERVAL=300ms TMPDIR=/var/tmp packer build -force template.json`

## 4. Known issues

See the [project issues](https://github.com/sporniket/workstation-cm/issues) page.

The boot command sequence is timed after my setup : a Linux on SSD. Thus the timing are quite shorts. In the future, I plan to make these timing configurable to get a taylored script.

## 5. Miscellanous

### Report issues

Use the [project issues](https://github.com/sporniket/workstation-cm/issues) page.
