{
  nixConfig.bash-prompt = "[nix-develop-hs2halo2:] ";
  description = "hs2halo2";
  inputs = {
    # Nixpkgs set to specific URL for haskellNix
    nixpkgs.url = "github:NixOS/nixpkgs/baaf9459d6105c243239289e1e82e3cdd5ac4809";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";

    #HaskellNix is implemented using a set nixpkgs.follows; allowing for flake-build
    haskellNix =
    {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:input-output-hk/haskell.nix";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils, haskellNix }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        overlays = [
          haskellNix.overlay
          (final: prev: {
            # This overlay adds our project to pkgs
            hs2halo2 =
              final.haskell-nix.project' {
                name = "hs2halo2";
                src = ./.;
                compiler-nix-name = "ghc8107";
                shell.tools = {
                  cabal = { };
                  ghcid = { };
                  hlint = { };
                  haskell-language-server = { };
                  stylish-haskell = { };
                };
                # Non-Haskell shell tools go here
                shell.buildInputs = with pkgs; [
                  nixpkgs-fmt
                ];
                shell.shellHook =
                  ''
                  manual-ci() (
                    set -e

                    ./lint.sh
                    nix-build
                  )
                  '';
              };
          })
        ];
        pkgs = import nixpkgs { inherit system overlays; inherit (haskellNix) config; };
        flake = pkgs.hs2halo2.flake { };
      in flake // {
        herculesCI.ciSystems = [ "x86_64-linux" ];
        defaultPackage = flake.packages."hs2halo2:lib:hs2halo2";
      });
}
