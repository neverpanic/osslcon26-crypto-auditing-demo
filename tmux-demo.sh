#!/usr/bin/env bash

unset TMUX
tmux new-session -d -s crau-demo
tmux rename-window -t =crau-demo:0 run
tmux split-pane -v -t =crau-demo:=run -l 2 -b
tmux send-keys -t =crau-demo:=run.0 'sudo crypto-auditing/target/release/crau-agent --library openssl/libcrypto.so.4 --library openssl/libssl.so.4 --log-file /tmp/audit.cborseq'
#tmux send-keys -t =crau-demo:=run.1 'LD_LIBRARY_PATH=openssl openssl/apps/openssl s_client -connect google.com:443 -CApath /etc/pki/tls/certs </dev/null'
tmux send-keys -t =crau-demo:=run.1 'podman run --rm -v "$(readlink -f openssl):/work:z" registry.fedoraproject.org/fedora:44 env LD_LIBRARY_PATH=/work /work/apps/openssl s_client -connect google.com:443 -CApath /etc/pki/tls/certs </dev/null'

tmux new-window -t =crau-demo -n analyze
tmux send-keys -t =crau-demo:=analyze 'crypto-auditing/target/release/crau-query --log-file /tmp/audit.cborseq | jq -C | less -R'

tmux select-window -t =crau-demo:=run
tmux select-pane -t =crau-demo:=run.0
tmux attach -t =crau-demo
