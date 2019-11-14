# openstack-aio-ceph-ansible

Install and configure OpenStack AIO to use Ceph and work on an Intel NUC (NUC7i7BNH) 32GB RAM with a single 500GB M.2 SSD disk

Before this playbook (setup-everything.yml) is executed:

- Install Ubuntu 18.04 LTS
- Create user: ansible
- Manually create OS LVM partition see below (90GB).
  - swap => 5GB
  - /boot => 500MB
  - / => The rest
- Only select tasks: System Utilities and OpenSSH Server
- IP: 192.168.1.200

What do you get after this playbook has been executed?

- Ceph configued with BlueStore
- OpenStack release (All-In-One)
- OpenStack services: Cinder, Glance, Nova, Neutron, Horizon
- Ceph used by all OpenStack services
- Network 'public' setup for floating IPs
- Test project create with test user (password: test)

Example output of lsblk after execution of this playbook:

```console
NAME          MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0           7:0    0    84G  0 loop /var/lib/machines
nvme0n1       259:0    0 465.8G  0 disk
|-nvme0n1p1   259:1    0   487M  0 part /boot
|-nvme0n1p2   259:2    0  90.6G  0 part
| |-os-root   252:0    0  85.9G  0 lvm  /
| `-os-swap   252:1    0   4.8G  0 lvm  [SWAP]
`-nvme0n1p5   259:4    0 374.7G  0 part
  `-ceph-data 252:2    0 374.7G  0 lvm
```

To access OpenStack Instances from Windows 10 it might in some cases not work out-of-the-box

- Allow inbound/outbound access in firewall for subnet range 172.29.248.0/22 or 172.29.249.110 - 172.29.249.200 (floating IPs)
- Allow inbound ICMPv4 from within LAN
- Allow inbound Multicast DNS traffic on port 5353

**IMPORTANT!** Do not forget to setup static route in your router or on the host machine from where you want to access the instances you create in OpenStack.

| Network/Host IP | Netmask       | Gateway       |
| --------------- | ------------- | ------------- |
| 172.29.248.0    | 255.255.252.0 | 192.168.1.200 |

## How to deploy OpenStack AIO

The steps below describes a way where you are only required to have Docker
on your machine to remotely deploy Ceph and OpenStack AIO on a target host.

1. Build Docker image create a kind of AIO deployment host:
    ```console
    docker build -t aio_deploy .
    ```
1. Start the AIO deployment container:
    ```console
    docker run --rm -it -v ${PWD}:/mnt/data:ro -v /path/to/your/.ssh:/tmp/.ssh:ro aio_deploy
    ```
1. Activate the Python virtual environment to gain access to Ansible and add SSH keys to SSH agent:
    ```console
    . ~/venvs/default/bin/activate
    eval `ssh-agent` && ssh-add
1. Copy SSH public key to target (If preseed has been used to setup host then password for ansible is ansible):
    ```console
    ssh-copy-id ansible@192.168.1.200
    ```
1. Now inside the container go to `/mnt/data`:
    ```console
    cd /mnt/data
    ```
1. Deploy Ceph and OpenStack AIO in one go:
    ```console
    ansible-playbook setup-everything.yml
    ```
1. Deactivate Python virtual environment and kill SSH agent:
    ```console
    deactivate
    ssh-agent -k
    ```
