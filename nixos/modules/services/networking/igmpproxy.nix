# Module for the IGMP Proxy Daemon

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.igmpproxy;

  confFile = pkgs.writeText "igmpproxy.conf" cfg.config;

in

{

  ###### interface

  options = {

    services.igmpproxy.enable = mkOption {
      default = false;
      description =
        ''
          Whether to enable the <command>igmpproxy</command>,
          which is a simple dynamic Multicast Routing Daemon
          using only IGMP signalling. It's intended for simple
          forwarding of Multicast traffic between networks.
        '';
    };

    services.igmpproxy.config = mkOption {
      example = builtins.readFile "${pkgs.igmpproxy}/etc/igmpproxy.conf";
      description =
        ''
          The contents of the igmpproxy configuration file.
        '';
    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.igmpproxy =
      { description = "Simple multicast router that only uses the IGMP protocol";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" ];
        serviceConfig =
          { Type = simple;
            ExecStart = "@${pkgs.igmpproxy}/bin/igmpproxy igmpproxy ${confFile}";
            Restart = "on-abort";
          };
      };
  };

}
