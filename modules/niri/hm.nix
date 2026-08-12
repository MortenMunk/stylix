{
  pkgs,
  config,
  lib,
  mkTarget,
  ...
}:
mkTarget {
  config =
    {
      colors,
      cursor,
      image,
      ...
    }:
    lib.mkIf config.wayland.windowManager.niri.enable {
      wayland.windowManager.niri.settings = {
        cursor = lib.mkIf (cursor.name != null) {
          xcursor-theme = cursor.name;
          xcursor-size = cursor.size;
        };

        layout = {
          border = {
            active-color = colors.withHashtag.base0D;
            inactive-color = colors.withHashtag.base03;
          };
          focus-ring.off = { };
        };

        _children = lib.mkIf (image != null) [
          {
            spawn-at-startup._args = [
              "${lib.getExe pkgs.swaybg}"
              "-i"
              "${image}"
            ];
          }
        ];
      };
    };
}
