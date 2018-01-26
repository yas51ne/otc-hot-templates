# otc-hot-templates

This template help to create an example of kubernetes glusterfs and mongodb infrastructure in the T-Systems Cloud 'OTC'.

## Getting Started

These instructions will get you a copy of the otc-hot project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

You need to be root on your local machine:

```
home]$ sudo -i
```

### Cloning

A step by step series of commands to get a development env running.

Download the project from the GitHb:

```
root]# git clone https://github.com/yas51ne/otc-hot-templates.git --branch ASgroups
```

Update the environment variables OS_USERNAME and OS_PASSWORD in the file otcrcscoped with your OTC username and password:

```
root]# cd otc-hot-templates
otc-hot-templates]# vi otcrcscoped
```

## Deploying

```
otc-hot-templates]# openstack stack create -t main_template.yaml -e environement.yaml cws-production
```

### Cheking

```
otc-hot-templates]# openstack stack show cws-production
otc-hot-templates]# openstack stack resource list cws-production
otc-hot-templates]# openstack stack event list cws-production
```

## Outputs

```
otc-hot-templates]# openstack stack output show --all cws-production
```

## Authors

* **Yassine MAACHI** - *Initial work* - [CWS-HOT](https://github.com/yas51ne/otc-hot-templates)
