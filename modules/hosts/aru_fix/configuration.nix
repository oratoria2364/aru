{self, inputs, ...}: {
  flake.nixosModules.Aru_fixConfiguration = {pkgs, ...}: let
    bizhawk = import inputs.bizhawk {
      inherit pkgs;
      system = pkgs.stdenv.hostPlatform.system;
    };
  in {
    imports = [
      self.nixosModules.Aru_fixHardware
      self.nixosModules.feature-base
      self.nixosModules.feature-vr
      inputs.roxysu.nixosModules.default
    ];

    programs.roxysu.enable = true;

    networking.hostName = "aru_fix"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable touchpad support (enabled default in most desktopManager).
    # services.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."aruf" = {
      isNormalUser = true;
      description = "aru_fix";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        kdePackages.kate
        vesktop
        vlc
        libreoffice
        opencode
        git
        protonplus
        osu-lazer-bin
        gh
        vscode-fhs
        bs-manager
        fastfetch
        archipelago
        bizhawk.emuhawk-latest-bin
        prismlauncher
        olympus
        signal-desktop
      ];
    };

    programs.steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    # BizHawk (imported from inputs.bizhawk) still depends on gtk2,
    # which is marked broken until NixOS 27.05.
    nixpkgs.config.problems.handlers."gtk+".broken = "warn";

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia.open = true;

    environment.shellAliases = {
      aru = "cd /home/aruf/code/aru/ && sudo nixos-rebuild switch --flake ./#aru_fix";
      clean = "sudo nix-collect-garbage -d && sudo nix-store --optimise";
      pc = "kate /home/aruf/code/aru/modules/hosts/aru_fix/configuration.nix";
    };

    system.stateVersion = "26.05"; # Did you read the comment?
  };
}
