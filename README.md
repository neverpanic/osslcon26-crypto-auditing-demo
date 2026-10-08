# Crypto-Auditing with OpenSSL

This is a demonstration that shows tracing of the OpenSSL `libcrypto` and
`libssl` libraries with eBPF probes by [latchset/crypto-auditing][crypto-auditing].

The demo compiles the crypto-auditing user space tooling and an instrumented
copy of OpenSSL, then starts the tracing and runs `openssl s_client` to show
the events for a handshake.

[crypto-auditing]: https://github.com/latchset/crypto-auditing/
