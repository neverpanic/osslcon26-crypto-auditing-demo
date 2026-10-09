#!/usr/bin/env bash

unset TMUX

NONE="\[\033[0m\]"    # unsets color to term's fg color
G="\[\033[0;32m\]"    # green
EMG="\[\033[1;32m\]"
NEWPS1="${G}\u${NONE}@${EMG}\h${NONE} \\$ "

tmpdir=$(mktemp -d)
trap "rm -rf '$tmpdir'" EXIT

sed "/^shopt -s/ aunset PROMPT_COMMAND\nPS1='$(echo "${NEWPS1:q}" | sed 's/\\/\\\\/g')'" ~/.bashrc >"$tmpdir/.bashrc"

tmux new-session -d -s crau-demo bash --rcfile "$tmpdir/.bashrc"
tmux rename-window -t =crau-demo:0 run
tmux split-pane -v -t =crau-demo:=run -l 30% -b bash --rcfile "$tmpdir/.bashrc"
tmux send-keys -t =crau-demo:=run.0 'sudo crypto-auditing/target/release/crau-agent --library openssl/libcrypto.so.4 --library openssl/libssl.so.4 --log-file /tmp/audit.cborseq'

# Bare metal test with OpenSSL s_client
#tmux send-keys -t =crau-demo:=run.1 'LD_LIBRARY_PATH=openssl openssl/apps/openssl s_client -connect google.com:443 -CApath /etc/pki/tls/certs </dev/null'

# Works in containers, too!
tmux send-keys -t =crau-demo:=run.1 'podman run --rm -v "$(readlink -f openssl):/work:z" registry.fedoraproject.org/fedora:44 env LD_LIBRARY_PATH=/work /work/apps/openssl s_client -connect google.com:443 -CApath /etc/pki/tls/certs </dev/null'

# Creates multiple handshake events, possibly due to happy eyeballs? Let's keep it simple.
#tmux send-keys -t =crau-demo:=run.1 'podman run --rm -v "$(readlink -f openssl):/work:z" registry.fedoraproject.org/fedora:45 env LD_LIBRARY_PATH=/work curl --capath /etc/pki/tls/certs https://www.google.com -I'

tmux new-window -t =crau-demo -n analyze bash --rcfile "$tmpdir/.bashrc"
tmux send-keys -t =crau-demo:=analyze 'crypto-auditing/target/release/crau-query --log-file /tmp/audit.cborseq | jq -C | less -R'

tmux select-window -t =crau-demo:=run
tmux select-pane -t =crau-demo:=run.0
tmux send-keys -t =crau-demo:=run.0 C-L
tmux send-keys -t =crau-demo:=run.1 C-L
tmux attach -t =crau-demo
