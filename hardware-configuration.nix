{
  boot.initrd.availableKernelModules = [ "nvme" ];
  hardware.enableRedistributableFirmware = true;
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "f2fs";
      options = [ "compress_algorithm=zstd:6" "compress_chksum" "atgc" "gc_merge" "lazytime" "discard"];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "defaults" "discard" ];
    };
  };
}
