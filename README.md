# Ansible Seed Template Repo

## Roles

https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html#using-roles-at-the-play-level

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
