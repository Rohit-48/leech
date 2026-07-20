use pcap::{Capture, Device};

fn main() {
    // List available devices so you can see what's up if the default one is wrong
    match Device::list() {
        Ok(devices) => {
            println!("Available devices:");
            for d in &devices {
                println!("  - {} ({})", d.name, d.desc.clone().unwrap_or_default());
            }
        }
        Err(e) => {
            eprintln!("Couldn't list devices: {e}");
            eprintln!("Are you running with sudo / CAP_NET_RAW?");
            std::process::exit(1);
        }
    }

    let device = Device::lookup()
        .expect("device lookup failed")
        .expect("no default device found - specify one manually");

    println!("\nUsing device: {}\n", device.name);

    let mut cap = Capture::from_device(device)
        .expect("failed to create capture handle")
        .promisc(true)
        .snaplen(65535)
        .timeout(1000)
        .open()
        .expect("failed to open capture - do you have permission? try: sudo setcap cap_net_raw,cap_net_admin=eip ./target/debug/leech");

    // Milestone 1 scope: just prove we can see DNS packets. No parsing yet - that's M2.
    cap.filter("udp port 53", true)
        .expect("failed to apply BPF filter");

    println!("Listening for UDP/53 traffic... (Ctrl+C to stop)\n");

    loop {
        match cap.next_packet() {
            Ok(packet) => {
                println!(
                    "[{}.{:06}] captured {} bytes",
                    packet.header.ts.tv_sec,
                    packet.header.ts.tv_usec,
                    packet.header.len
                );
            }
            Err(pcap::Error::TimeoutExpired) => {
                // no packet in the last second, just keep looping
                continue;
            }
            Err(e) => {
                eprintln!("capture error: {e}");
                break;
            }
        }
    }
}
