{
  description = "leech - realtime DNS process monitor";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {

          packages = with pkgs; [

            rustc
            cargo
            rust-analyzer

            pkg-config
            clang

            libpcap

            git

            just
            bacon
            cargo-watch

            tcpdump
            wireshark
            dnsutils
            rustfmt
            clippy

            libpcap
            pkg-config

          ];
          shellHook = ''
            export PKG_CONFIG_PATH="${pkgs.libpcap}/lib/pkgconfig:$PKG_CONFIG_PATH"
            echo "leech dev shell ready. libpcap: ${pkgs.libpcap}"
          '';

        };
      });
}
