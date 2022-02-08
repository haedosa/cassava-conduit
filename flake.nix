{
  description = "cassava-conduit";

  inputs = {

    haedosa.url = "github:haedosa/flakes";
    nixpkgs.follows = "haedosa/nixpkgs";
    flake-utils.follows = "haedosa/flake-utils";

  };

  outputs =
    inputs@{ self, nixpkgs, flake-utils, ... }:
    {
      overlay = nixpkgs.lib.composeManyExtensions (
                  with inputs;
                  [
                    (import ./overlay.nix)
                  ]);

    } // flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = import nixpkgs {
          inherit system;
          config = {};
          overlays = [ self.overlay ];
        };
      in rec {

        devShell = import ./develop.nix { inherit pkgs; };

        defaultPackage = pkgs.haskellPackages.cassava-conduit;

      }
    );

}
