{ config, lib, pkgs, ... }:

{
  # Enable the PostgreSQL service.
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql; # Use the default PostgreSQL package.

    # This is a list of databases to create on the first run.
    databases = [
      {
        name = "standard";
        owner = "postgres";
        ensureCreate = true;
      }
    ];

    # Create an initial database schema. This script runs once when the database is created for the first time.
    initialScript = pkgs.writeText "init-standard-db.sql" ''
      -- The SQL script to initialize the 'standard' database.
      CREATE TABLE mytable (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255)
      );
    '';

    # Set up a dedicated user for the database (optional but recommended)
    # users = [
    #   {
    #     name = "standard_user";
    #     ensureCreate = true;
    #   }
    # ];
  };

  # This module system implicitly defines the systemd service.
  systemd.services.postgresql = {
    description = "PostgreSQL Database Server for the Rescile standard database.";
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
