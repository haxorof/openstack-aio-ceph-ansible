# openstack-aio-ceph-ansible

Install and configure OpenStack (Pike) AIO to use Ceph and work on an Intel NUC (NUC7i7BNH) 32GB RAM with a single 500GB M.2 SSD disk

Before this playbook is executed:

- Install Ubuntu 16.04 LTS
- Create user: ansible
- Manually create OS LVM partition see below (90GB).
  - swap => 5GB
  - /boot => 500MB
  - / => The rest
- Only select tasks: System Utilities and OpenSSH Server
- IP: 192.168.1.200

What do you get after this playbook has been executed?

- Ceph configued with BlueStore
- OpenStack release Pike (All-In-One)
- OpenStack HEAT and Swift services are excluded
- Ceph used by all OpenStack services
- Network 'public' setup for floating IPs
- Test project create with test user (password: test)

Example output of lsblk after execution of this playbook:

```console
NAME          MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0           7:0    0    16G  0 loop /var/lib/machines
nvme0n1       259:0    0 465.8G  0 disk
├─nvme0n1p1   259:1    0  83.9G  0 part
│ ├─os-root   252:0    0  78.8G  0 lvm  /
│ ├─os-swap   252:1    0   4.7G  0 lvm  [SWAP]
│ └─os-boot   252:3    0   476M  0 lvm  /boot
└─nvme0n1p2   259:2    0 381.9G  0 part
  └─ceph-data 252:2    0 381.9G  0 lvm
```

To access OpenStack Instances from Windows 10 it might in some cases not work out-of-the-box

- Allow inbound/outbound access in firewall for subnet range 172.29.248.0/22 or 172.29.249.110 - 172.29.249.200 (floating IPs)
- Allow inbound ICMPv4 from within LAN
- Allow inbound Multicast DNS traffic on port 5353

**IMPORTANT!** Do not forget to setup static route in your router or on the host machine from where you want to access the instances you create in OpenStack.

| Network/Host IP | Netmask       | Gateway       |
| --------------- | ------------- | ------------- |
| 172.29.248.0    | 255.255.252.0 | 192.168.1.200 |
