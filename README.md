# workstation-cm

> [WARNING] Please read carefully this note before using this project. It contains important facts.

Content

1. What is **workstation-cm**, and when to use it ?
2. What should you know before using **workstation-cm** ?
3. How to use **workstation-cm** ?
4. Known issues
5. Miscellanous

##1. What is **workstation-cm**, and when to use it ?
**workstation-cm** is a Packer script that create an automated workstation based on Ubuntu taylored to my needs.

### What's new in v0.1.0

* Working script on my computer, will need tuning to work on another computer.


###Licence
 **workstation-cm** is public domain as it gathers some public knowledge.

 **workstation-cm** is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without
 even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


##2. What should you know before using **workstation-cm** ?

**workstation-cm** relies HashiCorp Packer to generate the box.

https://www.packer.io/

**workstation-cm** generate a Vagrant box that will run on VirtualBox 5.1.

https://www.virtualbox.org/

**workstation-cm** is based on the project `box-ubuntu-budgie-18-x64` by Martin Andersson.

https://github.com/martinanderssondotcom/box-ubuntu-budgie-18-x64

> Do not use **workstation-cm** if this project is not suitable for your project

##3. How to use **workstation-cm** ?

### Vagrant

Use the base box `sporniket/workstation-cm`.

### From source

_You MUST install Packer 1.2 and VirtualBox 5.1_

To get the latest available code, one must clone the git repository, build and install to the maven local repository.

	git clone https://github.com/sporniket/workstation-cm.git
	cd workstation-cm
	packer build template.json

> Note : I had use the following command : `PACKER_KEY_INTERVAL=300ms TMPDIR=/var/tmp packer build template.json`

##4. Known issues

See the [project issues](https://github.com/sporniket/workstation-cm/issues) page.

The boot command sequence is timed after my setup : a Linux on SSD. Thus the timing are quite shorts. In the future, I plan to make these timing configurable to get an taylored script.

##5. Miscellanous

### Report issues

Use the [project issues](https://github.com/sporniket/workstation-cm/issues) page.
