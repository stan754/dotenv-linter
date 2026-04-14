{
  description = "dotenv-linter";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0";

  outputs =
    { self, ... }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            inherit system;
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      packages = forEachSupportedSystem (
        { system, pkgs, ... }:
        {
          default = pkgs.rustPlatform.buildRustPackage {
            pname = "dotenv-linter";
            version = "4.0.0";

            src = ./.;

            cargoLock.lockFile = ./Cargo.lock;
          };
        }
      );
    };
}
