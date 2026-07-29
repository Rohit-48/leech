{
  description = "leech - realtime DNS process monitor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        # Construct a complete Rust toolchain including standard library sources
        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" "clippy" "rustfmt" ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          # Tools that run at build/compilation time
          nativeBuildInputs = with pkgs; [
            rustToolchain
            pkg-config
            clang
          ];

          # Libraries your project links against at runtime
          buildInputs = with pkgs; [
            libpcap
          ];

          # Extra CLI tools for workflow
          packages = with pkgs; [
            git
            just
            bacon
            cargo-watch
            tcpdump
            wireshark
            dnsutils
          ];

          # Environment variables automatically passed to your shell and IDE
          shellHook = ''
            # Force Clang to find system headers (required for bindgen / pcap crates)
            export LIBCLANG_PATH="${pkgs.llvmPackages.libclang.lib}/lib"

            # Expose standard library source directly for RustRover / LSPs
            export RUST_SRC_PATH="${rustToolchain}/lib/rustlib/src/rust/library"

            # Symlink toolchain for IDEs requiring a single static path
            mkdir -p .nix-deps
            ln -sfn ${rustToolchain} .nix-deps/rust-toolchain

            echo "leech dev shell active. Rust toolchain linked at ./.nix-deps/rust-toolchain"
          '';
        };
      });
}