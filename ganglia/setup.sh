#!/bin/bash

/root/spark-openstack/copy-dir /etc/ganglia/

# Start gmond everywhere
/etc/init.d/gmond restart

for node in $SLAVES $OTHER_MASTERS; do
  ssh -t $SSH_OPTS root@$node "/etc/init.d/gmond restart"
done

# gmeta needs rrds to be owned by ganglia (in CentOs 6.4)
chown -R ganglia /var/lib/ganglia/rrds
# cluster-wide aggregates only show up with this. TODO: Fix this cleanly ?
ln -s /usr/share/ganglia/conf/default.json /var/lib/ganglia/conf/

/etc/init.d/gmetad restart

# Start http server to serve ganglia
/etc/init.d/httpd restart
