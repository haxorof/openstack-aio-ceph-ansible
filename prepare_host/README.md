# Configuration required to match the preseed

If you use the `preseed.cfg` file in this directory to install Ubuntu then you need to do some minor configuration because your host partitions will look like this:

```console
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
nvme0n1     259:0    0 465.8G  0 disk
|-nvme0n1p1 259:1    0   487M  0 part /boot
|-nvme0n1p2 259:2    0  81.1G  0 part
| |-os-root 252:0    0  76.3G  0 lvm  /
| `-os-swap 252:1    0   4.8G  0 lvm  [SWAP]
|-nvme0n1p3 259:3    0     1K  0 part
`-nvme0n1p5 259:4    0 384.2G  0 part
```

To ensure that the partitioning in this play will work you need to set the following configuration in the `all.yml` file in the `group_vars` directory as a subdirectory of `openstack-aio-ceph-ansible`:

```yaml
data_partition_nr_override: 5
os_partition_index_override: 1
```

## PXE server on Windows

A free alternative if you run Windows and want to use the `preeseed.cfg` file then you can download [Serva](https://www.vercot.com/~serva/default.html) and
in this directory is a `ServaAsset.inf` which you can use.