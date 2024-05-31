{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hardware-configuration.nix
        ({ pkgs, ... }: {

          system = {
            stateVersion = "24.05";
            switch = {
              enable = false;
              enableNg = true;
            };
          };

          nix = {
            settings.experimental-features = [ "nix-command" "flakes" ];
            optimise.automatic = true;
          };

          boot = {
            kernelPackages = pkgs.linuxPackages_latest;
            kernelParams = [ "rw" "nowatchdog" "modprobe.blacklist=sp5100_tc" ];
            initrd.systemd.enable = true;
            loader = {
              timeout = 3;
              efi.canTouchEfiVariables = true;
              systemd-boot = {
                enable = true;
                configurationLimit = 5;
                editor = false;
              };
            };
          };

          hardware.bluetooth.enable = true;
          hardware.opengl.driSupport32Bit = true;

          time.timeZone = "Asia/Yekaterinburg";

          documentation = {
            enable = false;
            doc.enable = false;
            nixos.enable = false;
            info.enable = false;
          };

          systemd.network.wait-online.enable = false;
          networking = {
            useDHCP = false;
            dhcpcd.enable = false;
            useNetworkd = true;
            nftables.enable = true;
            wireless = {
              iwd = {
                enable = true;
                settings = { General = { EnableNetworkConfiguration = true; }; };
              };
            };
          };

          security = {
            doas.enable = true;
            sudo.enable = false;
	    rtkit.enable = true;
          };

          services = {
            dbus.implementation = "broker";
            pipewire = {
              enable = true;
              pulse.enable = true;
            };
            udisks2.enable = true;
            seatd.enable = true;
            gvfs.enable = true;
          };

          users = {
            defaultUserShell = pkgs.fish;
            users.kei = {
              isNormalUser = true;
              extraGroups = [ "wheel" "video" ];
            };
          };

          environment = {
            sessionVariables.NIXOS_OZONE_WL = "1";
            systemPackages = with pkgs; [
              # main programs
              (brave.override { vulkanSupport = true; })
              telegram-desktop
              qbittorrent
              (mpv.override { scripts = [ mpvScripts.mpris ]; })
              bitwarden
              libreoffice
              hunspell
              hunspellDicts.ru-ru
              hunspellDicts.en-us
              # cli programs
              ranger
              zathura
              imv
              kitty
              mediainfo
              file
              zip
              unzip
              neofetch
              yt-dlp
              # system utils
              pavucontrol
              libnotify
              p7zip
              psmisc
              waybar
              fuzzel
              mako
              playerctl
              hyprshade
              hypridle
              hyprshot
              wl-clipboard
              jmtpfs
              xdg-utils
              # languages, programming utils
              nil
              nixpkgs-fmt
	      lua-language-server
              # games, emulators
              # wine-staging
            ];
          };

          fonts.packages = with pkgs; [
            (nerdfonts.override { fonts = [ "Hack" ]; })
            font-awesome
          ];

          programs = {
            gnupg.agent.enable = true;
            adb.enable = true;
            git.enable = true;
            light.enable = true;
            command-not-found.enable = false;
            nano.enable = false;
            fish = {
              enable = true;
              loginShellInit = "test (tty) = /dev/tty1; and exec Hyprland";
              shellAliases = {
                x = "doas";
                r = "ranger";
                p = "python";
                dl = "yt-dlp -x --audio-format mp3 -o '%(title)s.%(ext)s'";
                dla = "yt-dlp -x --add-metadata --audio-format mp3 -o '%(title)s.%(ext)s'";
                um = "udisksctl mount -b /dev/sda1";
                uu = "udisksctl unmount -b /dev/sda1";
                pm = "jmtpfs ~/media";
                pu = "fusermount -u ~/media";
              };
            };
            hyprland = {
              enable = true;
              xwayland.enable = false;
            };
            neovim = {
              enable = true;
              viAlias = true;
              defaultEditor = true;
              configure.customRC = "luafile /etc/nvim/init.lua";
            };
          };
        }
        )
      ];
    };
  };
}
