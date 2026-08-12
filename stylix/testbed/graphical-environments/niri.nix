{
  config,
  lib,
  pkgs,
  ...
}:
{
  config =
    lib.mkIf (config.stylix.testbed.ui.graphicalEnvironment or null == "niri")
      {
        programs.niri.enable = true;

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${config.programs.niri.package}/bin/niri-session";
              user = "guest";
            };
          };
        };
        environment.systemPackages = [
          # dex looks for `x-terminal-emulator` when running a terminal program
          (pkgs.writeShellScriptBin "x-terminal-emulator" ''exec ${lib.getExe pkgs.kitty} "$@"'')
        ];

        home-manager.sharedModules = lib.singleton {
          programs.kitty.enable = true;

          wayland.windowManager.niri = {
            enable = true;
            settings = {
              _children = [
                {
                  spawn-at-startup._args = [
                    "${pkgs.bash}/bin/bash"
                    "-c"
                    "find /run/current-system/sw/etc/xdg/autostart/ -type f -or -type l | xargs -P0 -L1 ${lib.getExe pkgs.dex}"
                  ];
                }
              ];
            };
          };
        };
      };
}
