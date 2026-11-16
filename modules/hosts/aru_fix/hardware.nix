{...}: {
  flake.nixosModules.Aru_fixHardware = {
    config,
    lib,
    modulesPath,
    ...
  }: {
    imports =
        [ (modulesPath + "/installer/scan/not-detected.nix")
        ];

    boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
        { device = "/dev/disk/by-uuid/7ae8842e-24b9-4be6-a85e-40c31eb1ef1f";
        fsType = "ext4";
        };

    fileSystems."/boot" =
        { device = "/dev/disk/by-uuid/AB49-F584";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
        };

    fileSystems."/mnt/slave" =
      { device = "/dev/disk/by-uuid/0009d784-3cda-4512-b834-985dbe7eeb8d";
        fsType = "ext4";
      };

    swapDevices = [ ];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  };
}
