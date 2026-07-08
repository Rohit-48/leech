# leech — Milestone 1

Raw packet capture. Proves you can see UDP/53 traffic. No parsing yet — that's Milestone 2.

## Run it

```bash
nix develop        # drops you into the dev shell with libpcap + rust
cargo build
```

Capturing raw packets needs elevated perms. Two options:

**Option A — just use sudo (fastest for testing):**
```bash
sudo ./target/debug/leech
```

**Option B — set capabilities on the binary (no sudo needed after this):**
```bash
sudo setcap cap_net_raw,cap_net_admin=eip ./target/debug/leech
./target/debug/leech
```

## What "done" looks like for M1

- Program lists your network devices
- Picks the default one (or you hardcode one if `Device::lookup()` grabs the wrong interface — check the printed list)
- Opens a capture filtered to `udp port 53`
- Prints a line every time a DNS packet crosses the wire, with timestamp + byte length

Open a browser tab or `curl` something in another terminal while this runs — you should see packets flowing. If nothing prints, check:
1. Right interface? (wifi vs ethernet vs loopback — DNS from your own machine usually isn't loopback, it's your actual NIC)
2. Permissions actually applied?
3. Firewall/VPN swallowing traffic before it hits the interface?

Next up: Milestone 2 — parse these packets into actual domain names instead of just byte counts.
