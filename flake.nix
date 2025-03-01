{
  description = "Homebrew Casks, nixified";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  outputs = { self, nixpkgs }:
    let
      systems = [
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
      pkgs = forAllSystems (system: nixpkgs.legacyPackages.${system});
      legacyPackages = forAllSystems (system: import ./default.nix {
        pkgs = import nixpkgs { inherit system; };
      });
    in
    {      
      overlay = {nixcasks = legacyPackages."${system}";};
      devShells = forAllSystems (system: {
        default = pkgs."${system}".mkShell {};
      });
    };
}
