#!/bin/sh

echo "########################################################################################################"
echo "#                                                             __                                       #"
echo "#                    ______ __  __  __  _____          ___   / /_____  _____                           #"
echo "#                   / ____// / / / / / / ___/   ____  / __\`\/ __/ __ \/ ___/                           #"
echo "#                  / /___ / /_/ /_/ / (__  )   /___/ / /_/ / /_/ /_/ (__  )                            #"
echo "#                  \____/ \___/\___/ /____/          \__,_/\__/\____/____/                             #"
echo "#                                                                                                      #"
echo "#------------------------------------------------------------------------------------------------------#"
echo "#           For any additional informations, feel free to contact yassine.maachi@atos.net              #"
echo "########################################################################################################"

#installing/updating otc-tools and OpenstackClient in case of it's not installed/updated
sudo yum install -y otc-tools 
sudo yum  install -y  python-openstackclient

##############################################
# must create your ssh keypair in the OTC    #
# Console first and provide the name of      #
# your key to the variable KEY_NAME in       #
# the "Generic nodes configuration" section  #
##############################################

#########################################vars###########################################################
#Connection informations Cleanning
unset OS_USERNAME
unset OS_USER_DOMAIN_NAME
unset OS_ DOMAIN_NAME
unset OS_PASSWORD
unset OS_INTERFACE
unset OS_TENANT_NAME
unset OS_PROJECT_NAME
unset OS_AUTH_URL
unset NOVA_ENDPOINT_TYPE
unset OS_ENDPOINT_TYPE
unset CINDER_ENDPOINT_TYPE
unset OS_VOLUME_API_VERSION
unset OS_IDENTITY_API_VERSION
unset OS_IMAGE_API_VERSION

#Personal connection informations
export OS_USERNAME="******** OTC-EU-DE-00000000001000022981"
export OS_USER_DOMAIN_NAME=OTC-EU-DE-00000000001000022981
export OS_ DOMAIN_NAME=OTC-EU-DE-00000000001000022981
export OS_PASSWORD=********
# Only change these for a different region
export OS_INTERFACE=public
export OS_TENANT_NAME=eu-de
export OS_PROJECT_NAME=eu-de
export OS_AUTH_URL=https://iam.eu-de.otc.t-systems.com:443/v3
# No changes needed beyond this point
export NOVA_ENDPOINT_TYPE=publicURL
export OS_ENDPOINT_TYPE=publicURL
export CINDER_ENDPOINT_TYPE=publicURL
export OS_VOLUME_API_VERSION=2
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2


#Network and subnet configuration
export VPC_NAME=cws-network
export VPC_CIDR=172.16.0.0/16
export SUBNET_NAME=cws-subnet
export SUBNET_CIDR=172.16.1.0/24
export SUBNET_GW=172.16.1.1
export PRIMARY_DNS=100.125.4.25
export SECONDARY_DNS=8.8.8.8
export AZ=eu-de-02
export REBOND_IP=172.16.1.11
export INTERNET=0.0.0.0/0

#DNS configuration
export DNS_DOMAINE_NAME=cws.sparkindata.

#Security groups configuration
export SECGRP_NAME=cws-secgroup
export SECGRP_PORT1=22
export SECGRP_PORT2=80
export SECGRP_PORT3=443

#Kubernetes common Masters configuration
export MASTER_FLAVOR=normal3
export MASTER_DISK_SIZE=50
export MASTER_DISK_TYPE=SSD
export MASTER_TAGS=type=master-k8s
export MASTER_COUNT=1

#Kubernetes #1 Master configuration
export MASTER001_NAME=k8s-master-001
export MASTER001_IP=172.16.1.11
export MASTER001_EIP=false

#Kubernetes #2 Master configuration
export MASTER002_NAME=k8s-master-002
export MASTER002_IP=172.16.1.12
export MASTER002_EIP=false

#Kubernetes #3 Masters configuration
export MASTER003_NAME=k8s-master-003
export MASTER003_IP=172.16.1.13
export MASTER003_EIP=false

#Kubernetes common Slaves configuration
export SLAVE_FLAVOR=normal3
export SLAVE_DISK_SIZE=50
export SLAVE_DISK_TYPE=SSD
export SLAVE_TAGS=type=slave-k8s
export SLAVE_COUNT=1

#Kubernetes #1 Slave configuration
export SLAVE001_NAME=k8s-slave-001
export SLAVE001_IP=172.16.1.21
export SLAVE001_EIP=false

#Kubernetes #2 Slave configuration
export SLAVE002_NAME=k8s-slave-002
export SLAVE002_IP=172.16.1.22
export SLAVE002_EIP=false

#Kubernetes #3 Slave configuration
export SLAVE003_NAME=k8s-slave-003
export SLAVE003_IP=172.16.1.23
export SLAVE003_EIP=false

#MongoDB common nodes configuration
export MONGO_FLAVOR=computev1-2
export MONGO_DISK_SIZE=50
export MONGO_DISK_TYPE=SSD
export MONGO_TAGS=type=mongodb
export MONGO_COUNT=1

#MongoDB #1 node configuration
export MONGO001_NAME=mongodb-001
export MONGO001_IP=172.16.1.31
export MONGO001_EIP=false

#MongoDB #2 node configuration
export MONGO002_NAME=mongodb-002
export MONGO002_IP=172.16.1.32
export MONGO002_EIP=false

#MongoDB #3 node configuration
export MONGO003_NAME=mongodb-003
export MONGO003_IP=172.16.1.33
export MONGO003_EIP=false

#Glusterfs common nodes configuration
export GLUSTER_FLAVOR=computev1-2
export GLUSTER_DISK_SIZE=50
export GLUSTER_DISK_TYPE=SSD
export GLUSTER_TAGS=type=glusterfs
export GLUSTER_COUNT=1

#Glusterfs #1 node configuration
export GLUSTER001_NAME=glusterfs-001
export GLUSTER001_IP=172.16.1.41
export GLUSTER001_EIP=false

#Glusterfs #2 node configuration
export GLUSTER002_NAME=glusterfs-002
export GLUSTER002_IP=172.16.1.42
export GLUSTER002_EIP=false

#Generic nodes configuration
export IMAGE_NAME=Standard_CentOS_7.3_latest
export ADMIN_PASS=e54@Cw5!
export KEY_NAME=KeyPair-test-YM
########################################################################################################

#VPC Creation
otc vpc create --vpc-name $VPC_NAME --cidr $VPC_CIDR
otc vpc enable-snat $VPC_NAME

#Subnet Creation
otc subnet create --subnet-name $SUBNET_NAME --cidr $SUBNET_CIDR --gateway-ip $SUBNET_GW --primary-dns $PRIMARY_DNS --secondary-dns $SECONDARY_DNS --availability-zone $AZ --vpc-name $VPC_NAME

#Security group and rules creation
otc security-group create -g $SECGRP_NAME --vpc-name $VPC_NAME
openstack security group rule create --proto tcp --src-ip $INTERNET --dst-port $SECGRP_PORT1 $SECGRP_NAME
openstack security group rule create --proto tcp --src-ip $INTERNET --dst-port $SECGRP_PORT2 $SECGRP_NAME
openstack security group rule create --proto tcp --src-ip $INTERNET --dst-port $SECGRP_PORT3 $SECGRP_NAME

#DNS Domain creation
otc domain create --vpc-name $VPC_NAME $DNS_DOMAINE_NAME internal-domain private

#Kubernetes Master 1 creation
otc ecs create \
--instance-name $MASTER001_NAME \
--fixed-ip $MASTER001_IP \
--public $MASTER001_EIP \
--instance-type $MASTER_FLAVOR \
--disksize $MASTER_DISK_SIZE \
--disktype $MASTER_DISK_TYPE \
--tags $MASTER_TAGS \
--count $MASTER_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 

#Kubernetes Master 2 creation
otc ecs create \
--instance-name $MASTER002_NAME \
--fixed-ip $MASTER002_IP \
--public $MASTER002_EIP \
--instance-type $MASTER_FLAVOR \
--disksize $MASTER_DISK_SIZE \
--disktype $MASTER_DISK_TYPE \
--tags $MASTER_TAGS \
--count $MASTER_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 

#Kubernetes Master 3 creation
otc ecs create \
--instance-name $MASTER003_NAME \
--fixed-ip $MASTER003_IP \
--public $MASTER003_EIP \
--instance-type $MASTER_FLAVOR \
--disksize $MASTER_DISK_SIZE \
--disktype $MASTER_DISK_TYPE \
--tags $MASTER_TAGS \
--count $MASTER_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 

#Kubernetes Slave 1 creation
otc ecs create \
--instance-name $SLAVE001_NAME \
--fixed-ip $SLAVE001_IP \
--public $SLAVE001_EIP \
--instance-type $SLAVE_FLAVOR \
--disksize $SLAVE_DISK_SIZE \
--disktype $SLAVE_DISK_TYPE \
--tags $SLAVE_TAGS \
--count $SLAVE_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 

#Kubernetes Slave 2 creation
otc ecs create \
--instance-name $SLAVE002_NAME \
--fixed-ip $SLAVE002_IP \
--public $SLAVE002_EIP \
--instance-type $SLAVE_FLAVOR \
--disksize $SLAVE_DISK_SIZE \
--disktype $SLAVE_DISK_TYPE \
--tags $SLAVE_TAGS \
--count $SLAVE_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 

#Kubernetes Slave 3 creation
otc ecs create \
--instance-name $SLAVE003_NAME \
--fixed-ip $SLAVE003_IP \
--public $SLAVE003_EIP \
--instance-type $SLAVE_FLAVOR \
--disksize $SLAVE_DISK_SIZE \
--disktype $SLAVE_DISK_TYPE \
--tags $SLAVE_TAGS \
--count $SLAVE_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 

#MongoDB 1 creation
otc ecs create \
--instance-name $MONGO001_NAME \
--fixed-ip $MONGO001_IP \
--public $MONGO001_EIP \
--instance-type $MONGO_FLAVOR \
--disksize $MONGO_DISK_SIZE \
--disktype $MONGO_DISK_TYPE \
--tags $MONGO_TAGS \
--count $MONGO_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 

#MongoDB 2 creation
otc ecs create \
--instance-name $MONGO002_NAME \
--fixed-ip $MONGO002_IP \
--public $MONGO002_EIP \
--instance-type $MONGO_FLAVOR \
--disksize $MONGO_DISK_SIZE \
--disktype $MONGO_DISK_TYPE \
--tags $MONGO_TAGS \
--count $MONGO_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 

#MongoDB 3 creation
otc ecs create \
--instance-name $MONGO003_NAME \
--fixed-ip $MONGO003_IP \
--public $MONGO003_EIP \
--instance-type $MONGO_FLAVOR \
--disksize $MONGO_DISK_SIZE \
--disktype $MONGO_DISK_TYPE \
--tags $MONGO_TAGS \
--count $MONGO_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 

#GlusterFS 1 creation
otc ecs create \
--instance-name $GLUSTER001_NAME \
--fixed-ip $GLUSTER001_IP \
--public $GLUSTER001_EIP \
--instance-type $GLUSTER_FLAVOR \
--disksize $GLUSTER_DISK_SIZE \
--disktype $GLUSTER_DISK_TYPE \
--tags $GLUSTER_TAGS \
--count $GLUSTER_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 

#GlusterFS 2 creation
otc ecs create \
--instance-name $GLUSTER002_NAME \
--fixed-ip $GLUSTER002_IP \
--public $GLUSTER002_EIP \
--instance-type $GLUSTER_FLAVOR \
--disksize $GLUSTER_DISK_SIZE \
--disktype $GLUSTER_DISK_TYPE \
--tags $GLUSTER_TAGS \
--count $GLUSTER_COUNT \
--image-name $IMAGE_NAME \
--subnet-name $SUBNET_NAME \
--vpc-name $VPC_NAME \
--security-group-name $SECGRP_NAME \
--admin-pass $ADMIN_PASS \
--key-name $KEY_NAME 


#Adding records to the domain 
#############################################kubernetes-masters###############################################
otc domain addrecord $DNS_DOMAINE_NAME $MASTER001_NAME.$DNS_DOMAINE_NAME A 300 $MASTER001_IP kubernetes-master
otc domain addrecord $DNS_DOMAINE_NAME $MASTER002_NAME.$DNS_DOMAINE_NAME A 300 $MASTER002_IP kubernetes-master
otc domain addrecord $DNS_DOMAINE_NAME $MASTER003_NAME.$DNS_DOMAINE_NAME A 300 $MASTER003_IP kubernetes-master
##############################################kubernetes-slaves###############################################
otc domain addrecord $DNS_DOMAINE_NAME $SLAVE001_NAME.$DNS_DOMAINE_NAME A 300 $SLAVE001_IP kubernetes-slave
otc domain addrecord $DNS_DOMAINE_NAME $SLAVE002_NAME.$DNS_DOMAINE_NAME A 300 $SLAVE002_IP kubernetes-slave
otc domain addrecord $DNS_DOMAINE_NAME $SLAVE003_NAME.$DNS_DOMAINE_NAME A 300 $SLAVE003_IP kubernetes-slave
####################################################mongodb###################################################
otc domain addrecord $DNS_DOMAINE_NAME $MONGO001_NAME.$DNS_DOMAINE_NAME A 300 $MONGO001_IP mongodb
otc domain addrecord $DNS_DOMAINE_NAME $MONGO002_NAME.$DNS_DOMAINE_NAME A 300 $MONGO002_IP mongodb
otc domain addrecord $DNS_DOMAINE_NAME $MONGO003_NAME.$DNS_DOMAINE_NAME A 300 $MONGO003_IP mongodb
###################################################glusterfs##################################################
otc domain addrecord $DNS_DOMAINE_NAME $GLUSTER001_NAME.$DNS_DOMAINE_NAME A 300 $GLUSTER001_IP glusterfs
otc domain addrecord $DNS_DOMAINE_NAME $GLUSTER002_NAME.$DNS_DOMAINE_NAME A 300 $GLUSTER002_IP glusterfs

#Default route Creation
otc vpc addroute $VPC_NAME $INTERNET $REBOND_IP
