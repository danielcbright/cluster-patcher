# on all
curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash

hab pkg install -z "" -u https://bldr.habitat.sh -c stable <ORIGIN>/cluster-patcher

# on bastions
hab sup run --permanent-peer --listen-ctl=0.0.0.0:9632 --strategy rolling&

# on the rest
hab sup run --peer redis-1 --peer redis-2 --peer redis-3 --listen-ctl=0.0.0.0:9632 --strategy rolling&

# on all
hab svc load --strategy at-once -u https://bldr.habitat.sh --channel stable <ORIGIN>/cluster-patcher; journalctl -fu hab-sup

# permanent-peers
[Unit]
Description=Habitat Supervisor

[Service]
Environment=HAB_BLDR_URL=https://bldr.habitat.sh
Environment=HAB_AUTH_TOKEN=<AUTH_TOKEN>
ExecStartPre=/bin/bash -c /bin/systemctl
ExecStart=/bin/hab sup run --permanent-peer --peer ring-bastion-1 --peer ring-bastion-2 --peer ring-bastion-3 --peer redis-1 --peer redis-2 --peer redis-3 --peer redis-4 --peer redis-5 --peer redis-6 --listen-ctl=0.0.0.0:9632 --strategy rolling

[Install]
WantedBy=default.target

# normal-peers
[Unit]
Description=Habitat Supervisor

[Service]
Environment=HAB_BLDR_URL=https://bldr.habitat.sh
Environment=HAB_AUTH_TOKEN=<AUTH_TOKEN>
ExecStartPre=/bin/bash -c /bin/systemctl
ExecStart=/bin/hab sup run --peer ring-bastion-1 --peer ring-bastion-2 --peer ring-bastion-3 --peer redis-1 --peer redis-2 --peer redis-3 --peer redis-4 --peer redis-5 --peer redis-6 --listen-ctl=0.0.0.0:9632 --strategy rolling

[Install]
WantedBy=default.target
