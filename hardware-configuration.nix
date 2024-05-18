{
  boot.initrd.availableKernelModules = [ "nvme" ];
  hardware.enableRedistributableFirmware = true;
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "f2fs";
      options = [ "defaults" "lazytime" "noatime" "atgc" "gc_merge" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "defaults" "discard" ];
    };
  };
}
