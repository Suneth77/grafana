#!/bin/bash
#Making a file system of new ebs drive
sudo mkfs -t ext4 /dev/sdb

#Installing dependencies
sudo yum install python-pip  python-jinja2 python-paramiko PyYAML git jq -y
sudo pip install --upgrade --force-reinstall ansible boto3 botocore
sudo echo 'export PATH=$PATH:/usr/local/bin' >> /root/.bash_profile
sudo mkdir -p /etc/ansible
cd /etc/ansible

git clone https://github.com/Suneth77/grafana.git
ANSIBLE_CONFIG=/etc/ansible/grafana/grafana_ansible/ansible.cfg sudo /usr/local/bin/ansible-playbook /etc/ansible/grafana/grafana_ansible/grafana.yaml -v -i /etc/ansible/grafana/grafana_ansible/inventory