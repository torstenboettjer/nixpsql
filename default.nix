{ config, lib, pkgs, ... }:

let
  # The configuration for the module is available under config.services.rescile-standards
  cfg = config.services.rescile-standards;

  # Conditionally load and parse a JSON file containing the user if the option is set.
  usersFromJSON = lib.mkIf cfg.initialUsersFile (
    let
      # Read the JSON file and parse it.
      users = builtins.fromJSON (builtins.readFile cfg.initialUsersFile);
    in
    # Map the list of user names from the JSON file to the format
    # required by the NixOS postgresql module.
    map (name: { inherit name; ensureCreate = true; }) users
  );

in
{
  # Define the options for the module. This makes the options configurable from configuration.nix.
  options.services.rescile-standards = {
    enable = lib.mkEnableOption "rescile-standards";

    # Define the port option with a default value that can be overridden.
    port = lib.mkOption {
      type = lib.types.int;
      default = 5432;
      description = "The port for the PostgreSQL server to listen on.";
    };

    # Specify the PostgreSQL package
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.postgresql;
      description = "The PostgreSQL package to use.";
    };

    # Define an option for an initial SQL script to load.
    initialScript = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to an initial SQL script to be executed on first database creation.";
    };

    # Define an option to load users from a JSON file.
    initialUsersFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a JSON file containing a list of user names to be created.";
    };
  };

  # Use the custom options to configure the built-in NixOS modules with lib.mkIf ensuring this configuration is only applied when the module is enabled.
  config = lib.mkIf cfg.enable {
    # Enable the built-in PostgreSQL service.
    services.postgresql = {
      enable = true;
      package = cfg.package;
      port = cfg.port;

      # Create the database with the name "standard".
      databases = [
        {
          name = "standard";
          owner = "postgres";
          ensureCreate = true;
        }
      ];

      # Use the initial script from our custom option, if it exists.
      initialScript = cfg.initialScript;

      # Use the list of users generated from the JSON file, if the option is set.
      users = usersFromJSON;
    };
  };
}
