# PostgresSQL Module for NixOS

This module sets up a custom PostgreSQL service, creating a database, a schema and defining users when the service is started. It leverages the existing  services.postgresql module built into NixOS and is imported it into the `configuration.nix` file. The services.postgresql attribute set is part of the NixOS module system and is used to configure the database. The module can be imported into configuration.nix:

```nix
imports = [
  ./path/to/your-module.nix
];

services.psql-server = {
  enable = true;
  port = 5444; # This will set the port to 5444
  initialScript = ./my-schema.sql;
  initialUsersFile = ./my-users.json; # Path to the JSON file
};
```
