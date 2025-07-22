{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    millennium = {
      url = "git+https://github.com/SteamClientHomebrew/Millennium?ref=next";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs =
    {
      self,
      chaotic,
      disko,
      home-manager,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        hogwarts = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs system; };
          modules = [
            ./configuration.nix
            chaotic.nixosModules.default
            disko.nixosModules.disko
            {
              disko.devices = {
                disk = {
                  main = {
                    # When using disko-install, we will overwrite this value from the commandline
                    device = "/dev/disk/by-id/nvme-Samsung_SSD_990_EVO_Plus_2TB_S7U7NU0Y417341K";
                    type = "disk";
                    content = {
                      type = "gpt";
                      partitions = {
                        ESP = {
                          priority = 1;
                          size = "1G";
                          type = "EF00";
                          content = {
                            type = "filesystem";
                            format = "vfat";
                            mountpoint = "/boot";
                            mountOptions = [ "umask=0077" ];
                          };
                        };
                        root = {
                          size = "100%";
                          content = {
                            type = "btrfs";
                            extraArgs = [
                              "-f"
                              "-L"
                              "NixOS"
                            ];
                            subvolumes = {
                              "/rootfs" = {
                                mountpoint = "/";
                              };
                              "/home" = {
                                mountOptions = [ "compress=zstd" ];
                                mountpoint = "/home";
                              };
                              # "/home/valou" = { };
                              "/nix" = {
                                mountOptions = [
                                  "compress=zstd"
                                  "noatime"
                                ];
                                mountpoint = "/nix";
                              };
                              "/log" = {
                                mountOptions = [ "compress=zstd" ];
                                mountpoint = "/var/log";
                              };
                            };

                            mountpoint = "/partition-root";
                          };
                        };
                      };
                    };
                  };
                };
              };
            }
          ];
        };
      };
      homeConfigurations = {
        valou = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          extraSpecialArgs = { inherit inputs; };
          modules = [ ./home.nix ];
        };
      };
    };
}
