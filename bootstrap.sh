#!/usr/bin/env bash

set -eu -o pipefail

mkdir -p ./environments/{dev,qa,prod}/group_vars

for environment in {dev,qa,prod}; do
  cat <<EOF > "./environments/${environment}/kafka_hosts"
[kafka]
kafka001 kafka_broker_id=1
kafka002 kafka_broker_id=2
kafka003 kafka_broker_id=3

[kafka:vars]
ansible_user=changeme
kafka_zookeeper_connect=zk001:2181,zk002:2181,zk003:2181
EOF

  cat <<EOF > "./environments/${environment}/zookeeper_hosts"
[zookeeper]
zk001
zk002
zk003

[zookeeper:vars]
ansible_user=changeme
zookeeper_foo=bar
EOF

cat <<EOF > "./environments/${environment}/senseless_nginx_hosts"
[senseless_nginx]
senseless-nginx001
senseless-nginx002 nginx_config_foo=foobar
senseless-nginx003

[senseless_nginx:vars]
ansible_user=changeme
nginx_config_foo=baz
EOF

  [[ ! -f "./environments/${environment}/group_vars/kafka.yml" ]] && echo "---" > "./environments/${environment}/group_vars/kafka.yml"
  [[ ! -f "./environments/${environment}/group_vars/zookeeper.yml" ]] && echo "---" > "./environments/${environment}/group_vars/zookeeper.yml"
  [[ ! -f "./environments/${environment}/group_vars/senseless_nginx.yml" ]] && echo "---" > "./environments/${environment}/group_vars/senseless_nginx.yml"
done

mkdir -p playbooks
[[ ! -f playbooks/kafka.yml ]] && echo "---" > playbooks/kafka.yml
[[ ! -f playbooks/zookeeper.yml ]] && echo "---" > playbooks/zookeeper.yml
[[ ! -f playbooks/senseless-nginx.yml ]] && echo "---" > playbooks/senseless-nginx.yml

# https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-multiple-roles-from-a-file
[[ ! -f requirements.yml ]] && echo "---" > requirements.yml

# install roles defined at requirements
# ansible-galaxy install -r requirements.yml

cat <<EOF > ansible.cfg
[defaults]
roles_path = external_roles:roles
inventory = inventory/empty
forks = 20
timeout = 60
ansible_keep_remote_files = True
retry_files_enabled = False

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o PreferredAuthentications=publickey -o ConnectTimeout=10
pipelining = True
EOF

mkdir -p roles

# create role skeletons
(
  cd roles

  [[ ! -d "kafka" ]] && ansible-galaxy role init kafka
  [[ ! -d "zookeeper" ]] && ansible-galaxy role init zookeeper
)
