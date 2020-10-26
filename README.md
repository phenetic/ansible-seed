# Ansible Seed Template Repo

## [Roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#using-roles-at-the-play-level)

The role `senseless-nginx` contains a minimal role bootstrapped manually.
`kafka` and `zookeeper` had been created using `ansible-galaxy role init <role-name>` which creates a lot boilerplate to clean up before commmit. 

You can pass other keywords to the roles option:

```yamlex
---
- hosts: webservers
  roles:
    - common
    - role: foo_app_instance
      vars:
        dir: '/opt/a'
        app_port: 5000
      tags: typeA
    - role: foo_app_instance
      vars:
        dir: '/opt/b'
        app_port: 5001
      tags: typeB
```

## execute playbook
```bash
ansible-playbook -i environments/dev playbooks/senseless-nginx.yml
```
