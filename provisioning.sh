#!/bin/bash

#        ___           ___           ___       ___
#       /\  \         /\  \         /\__\     /\  \
#      /::\  \       /::\  \       /:/  /    /::\  \
#     /:/\ \  \     /:/\:\  \     /:/  /    /:/\:\  \
#    _\:\~\ \  \   /:/  \:\  \   /:/  /    /::\~\:\  \
#   /\ \:\ \ \__\ /:/__/ \:\__\ /:/__/    /:/\:\ \:\__\
#   \:\ \:\ \/__/ \:\  \ /:/  / \:\  \    \/_|::\/:/  /
#    \:\ \:\__\    \:\  /:/  /   \:\  \      |:|::/  /
#     \:\/:/  /     \:\/:/  /     \:\  \     |:|\/__/
#      \::/  /       \::/  /       \:\__\    |:|  |
#       \/__/         \/__/         \/__/     \|__|
#
# Assumption we are using Ubuntu precise 32 bits (12.04)
# Apache Solr 4.10.2
# Vagrant provisioning script
# Author: Patrick van Efferen

# Variables.
solr_version="4.10.2"
tomcat+version="tomcat7"
logging_location="/usr/share/solr"


# First we update apt
echo "Updating apt"

sudo apt-get update
sudo apt-get upgrade

# Install tomcat
sudo apt-get install tomcat7 tomcat7-admin -y

# Download Solr in the the directory and extract install.
if [ ! -f "/usr/share/solr/solr.war" ]; then
  cd /tmp

  # Download Solr
  wget http://archive.apache.org/dist/lucene/solr/$solr_version/$solr_version/solr-$solr_version.tgz
  tar xf solr-$solr_version.tgz
fi

# Check for solr base directory, if not create it.
if [ ! -d "/usr/share/solr" ]; then
  # Create the Solr base directory/
  sudo mv solr-$solr_version/example/multicore /usr/share/solr

  # All Solr file need to be owned by the Tomcat user.
  sudo chown -R $tomcat_version /usr/share/solr
fi

# # Install Solr if it is not yet installed.
# if [ ! -f "/usr/share/tomcat7/webapps/solr.war" ]; then
#   echo "Install Solr"
#   # Copy the Solr webapp and the example multicore configuration files:
#   sudo mkdir /usr/share/tomcat6/webapps
#   sudo cp /tmp/solr-4.3.1/dist/solr-4.3.1.war /usr/share/tomcat6/webapps/solr4.war
#   # sudo cp -R /tmp/solr-4.3.1/example/multicore/* /var/solr/

#   # Copy other solr files to solr base directory.
#   sudo cp -R /tmp/solr-4.3.1/* /usr/share/solr4/

#   # Copy Log4J libraries.
#   sudo cp /tmp/solr-4.3.1/example/lib/ext/* /usr/share/tomcat6/lib/
# fi

if [ ! -f "/usr/share/solr/solr.war"]; then
   sudo cp /tmp/solr-$solr_version/example/webapps/solr.war /usr/share/solr

  # From the Apache Solr lib, copy all the jar files to the tomcat lib.
  sudo cp -r /tmp/solr-$solr_version/example/lib/ext/* /usr/share/tomcat7/lib

  sudo cp -r /tmp/solr-$solr_version/example/resources/log4j.properties /usr/share/tomcat7/lib

  # Set the logging base direcotry to the solr direcotry. (todo change to var.)
  sudo sed -i '/solr\.log/ c\solr.log=/usr/share/solr' /user/share/tomcat7/lib/log4j.properties
fi


# Add configuration to settings file.
echo "Configuring Solr"
sudo echo "<Context docBase=\"/usr/share/solr/solr4.war\" debug=\"0\" privileged=\"true\"
         allowLinking=\"true\" crossContext=\"true\">
    <Environment name=\"solr/home\" type=\"java.lang.String\"
                 value=\"/usr/share/solr\" override=\"true\" />
</Context>" > /etc/tomcat6/Catalina/localhost/solr.xml


# Set filepermissions
echo "Set filepermissions"
# sudo chmod -R 2755 /usr/share/solr4
# sudo chmod -R 2775 /usr/share/solr4/triquanta/multicore/
# sudo chmod -R o+x /usr/share/tomcat6/lib

# # Configure log4j logging
# echo "Configure log4j loggin"
# sudo cp /usr/share/solr4/triquanta/resources/log4j.properties /usr/share/tomcat6/lib
# sudo chown tomcat6:tomcat6 /usr/share/tomcat6/lib/log4j.properties

# Setup Tomcat user.
echo "Setup Tomcat user."
sudo echo "<tomcat-users>
    <role rolename=\"manager-gui\"/>
    <user username=\"admin\" password=\"secret\" roles=\"manager-gui\"/>
</tomcat-users>" > /etc/tomcat7/tomcat-users.xml

# Restart Tomcat server
sudo service tomcat67 restart

echo "Ubuntu, $tomcat_version and solr-$solr_version have been installed."
