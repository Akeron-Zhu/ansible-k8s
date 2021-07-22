#/bin/bash

echo $1
IP=$1
USER=$2
if [ ! -n "$IP" ]; then
	IP=192.168.1.1
fi

if [ ! -n "$USER" ]; then
    USER=root
fi

echo $IP $USER

TOKEN=$(ssh $USER@$IP "kubeadm token list |tail -n 1|cut -d ' ' -f 1")
SHA=$(ssh $USER@$IP "openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'")

echo $TOKEN $SHA

kubeadm join $IP:6443 --token $TOKEN --discovery-token-ca-cert-hash sha256:$SHA -v=5
