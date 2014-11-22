# Vagrant box for Apache Solr 4.10.2 served by Apache Tomcat 7

## description

Vagrant box for Apache Solr 4.10.2 served by Apache Tomcat 7 on Ubuntu Trusty 64 bit.

## installation

1. Make sure you have Vagrant installed.
2. Clone the repository.
3. Move into to the reopsitory directory and perform `vagrant up`
4. login to the admin to verify the installation by going to http://192.168.33.123:8080/solr/#/

## usage

After settin up the Vagrant box with the provisioning script, you can add cores like you are used to with Apache Solr.

1. add your core to /usr/share/solr or copy one of the default cores,
2. add your core the the solr.xml file in that directory
3. restart Apache Tomcat `sudo service tomcat7 restart`

You will find the loggin files in /var/logs/tomcat/ .

## FAQ

### I can not connect to my vagrant box from (Arch)linux.

You probably need to install some addiotional drivers for both Virtual box and your host system, see the [Arch linux wiki](https://wiki.archlinux.org/index.php/VirtualBox#Load_the_VirtualBox_kernel_modules) for how to set it up on Arch.
