# otc-hot-templates
home]$ sudo -i
root]# git clone https://github.com/yas51ne/otc-hot-templates.git --branch ASgroups
root]# cd otc-hot-templates
otc-hot-templates]# vi otcrc
otc-hot-templates]# openstack stack create -t main_template.yaml -e environement.yaml cws-production
otc-hot-templates]# openstack stack show cws-production
otc-hot-templates]# openstack stack resource list cws-production
otc-hot-templates]# openstack stack event list cws-production
otc-hot-templates]# openstack stack output show --all cws-production
