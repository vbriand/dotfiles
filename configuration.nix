# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot = {
      enable = true;
      configurationLimit = 15; # Maximum number of boot entries
    };
  };

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_cachyos; # pkgs.linuxPackages_latest;

  boot.kernelParams = [
    "amdgpu.dcdebugmask=0x10"
    # Enable overclocking https://github.com/ilya-zlobintsev/LACT/wiki/Overclocking-(AMD)
    "amdgpu.ppfeaturemask=0xffffffff"
  ];

  networking.hostName = "hogwarts"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_CTYPE = "fr_FR.UTF-8";
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MESSAGES = "en_US.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
    LC_COLLATE = "fr_FR.UTF-8";
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services = {
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };
    desktopManager.plasma6.enable = true;
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
    flatpak.enable = true;
    # silverbullet.enable = true;
    ratbagd.enable = true;
    xserver = {
      enable = true; # Enable the X11 windowing system.
      excludePackages = [ pkgs.xterm ];
    };
  };

  hardware.i2c.enable = true; # Allow changing the monitor's brightness
  hardware.xone.enable = true;

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      inputs.millennium.overlays.default
    ];
  };

  environment = {
    plasma6.excludePackages = with pkgs.kdePackages; [
      plasma-browser-integration
      kdepim-runtime
      konsole
    ];
    systemPackages =
      with pkgs;
      [
        anytype
        boilr
        caprine
        discord
        emacs-nox
        git
        hardinfo2 # System information and benchmarks for Linux systems
        heroic
        kdePackages.kcalc # Calculator
        kdePackages.kcharselect # Tool to select and copy special characters from all installed fonts
        kdePackages.sddm-kcm # Configuration module for SDDM
        kdePackages.partitionmanager # Optional Manage the disk devices, partitions and file systems on your computer
        # kdotool # Enable automatic page switching for streamcontroller
        lact # GPU metrics and overclocking
        obsidian
        piper # Mouse configuration GUI
        protonplus
        samrewritten
        snapper
        snapper-gui
        steamtinkerlaunch
        tealdeer
        teamspeak3
        wayland-utils # Wayland utilities
        wget
        wl-clipboard # Command-line copy/paste utilities for Wayland
      ]
      ++ [ inputs.ghostty.packages.${system}.default ];
    variables = {
      GTK_IM_MODULE = "cedilla";
      QT_IM_MODULE = "cedilla";
    };
  };

  systemd.services = {
    lact = {
      description = "AMDGPU Control Daemon";
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };
      enable = true;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-label/Games";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.valou = {
    initialHashedPassword = "$y$j9T$SmCjwti0cZLgFBQxOM2EZ.$uXH4qxEpI6CNluj/TSphPQWs2K6Cn7sXrcGLJK1UAi9";
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "i2c"
      "gamemode"
    ];
    #   packages = with pkgs; [
    #     tree
    #   ];
  };

  programs.firefox.enable = true;
  programs.thunderbird.enable = true;
  programs.steam = {
    enable = true;
    package = pkgs.steam-millennium;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 10;
      };
      custom = {
        start = [
          "${pkgs.ddcutil}/bin/ddcutil -d 1 setvcp 10 90"
          "${pkgs.wireplumber}/bin/wpctl set-volume 53 .65"
          "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance"
          "${pkgs.libnotify}/bin/notify-send 'GameMode started'"
        ];
        end = [
          "${pkgs.libnotify}/bin/notify-send 'GameMode ended'"
          "${pkgs.wireplumber}/bin/wpctl set-volume 53 .5"
          "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set balanced"
          "${pkgs.ddcutil}/bin/ddcutil -d 1 setvcp 10 44"
        ];
      };
    };
  };
  programs.gamescope.enable = true;
  # programs.streamcontroller.enable = true;
  programs.dconf.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep 25";
    flake = "/home/valou/.dotfiles";
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    alsa-lib
    atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libgbm
    libusb1
    libxkbcommon
    libGL
    nss
    nspr
    pango
    xorg.libxcb
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   emacs-nox # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   git
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22000 ]; # 22000 = Syncthing
  networking.firewall.allowedUDPPorts = [ 22000 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
