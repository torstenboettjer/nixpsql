# Standard Database


To use this new module and set a custom port, you would import it and override the default like this in your configuration.nix:

imports = [
  ./path/to/your-module.nix
];

```nix
services.psql-server = {
  enable = true;
  port = 5444; # This will set the port to 5444
  initialScript = ./my-schema.sql;
  initialUsersFile = ./my-users.json; # Path to the JSON file
};
```


This module sets up a basic PostgreSQL service, creates a user and a database, and then executes a SQL script the first time the database is started. Itn leverages the existing and robust services.postgresql module built into NixOS and is imported it into the `configuration.nix` file. The services.postgresql attribute set is part of the NixOS module system and is used to configure the database. An initial database named "standard" is automatically created.


Summary of Changes
New Module Definition: The module now defines its own set of options under options.services.psql-server, including an enable flag and a port option with a default value of 5432.

Configuration Logic: The config block now uses the values from our custom options (cfg.port) to configure the built-in services.postgresql module.

Simpler systemd Integration: The manual systemd.services section was removed. The services.postgresql.enable = true; line is all that is needed, as the NixOS module system automatically generates the necessary systemd service for you.
