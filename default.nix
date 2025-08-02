{ config, lib, pkgs, ... }:

{
  # Enable the PostgreSQL service and configure it.
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql; # Use the default PostgreSQL package.

    # This is a list of databases to create on the first run.
    # We'll create a database named 'standard'.
    databases = [
      {
        name = "standard";
        owner = "postgres"; # The default owner is the 'postgres' user
        ensureCreate = true;
      }
    ];

    # You can also use an initial script to set up a database schema.
    # This script would be run once when the database is created for the first time.
    # initialScript = pkgs.writeText "init-standard-db.sql" ''
    #   -- The SQL script to initialize the 'standard' database.
    #   CREATE TABLE mytable (
    #     id SERIAL PRIMARY KEY,
    #     name VARCHAR(255)
    #   );
    # '';

    # Set up a dedicated user for the database (optional but recommended)
    # users = [
    #   {
    #     name = "standard_user";
    #     ensureCreate = true;
    #   }
    # ];
  };

  # This is how the module system implicitly defines the systemd service.
  # The 'services.postgresql.enable' option automatically creates and manages this service.
  # You don't need to write this part yourself, but it's good to know what's happening
  # behind the scenes.
  systemd.services.postgresql = {
    description = "PostgreSQL Database Server";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.postgresql}/bin/pg_ctl -D /var/lib/postgresql -l /var/log/postgresql/server.log start";
      Restart = "always";
      Type = "forking";
      User = "postgres";
    };
  };
}
