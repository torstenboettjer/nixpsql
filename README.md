# PostgreSQL Module for NixOS

This module sets up a PostgreSQL service, creates a database, a schema and defines the users for the database. It leverages the existing  services.postgresql module built into NixOS to automate the deployment of a custom database server via the `configuration.nix` file. The custom attribute set becomes part of the NixOS module system and is used to configure the database:

```nix
imports = [
  ./path/to/module
];

services.psql-server = {
  enable = true;
  port = 5444; # This will set the port to 5444
  initialScript = ./my-schema.sql;
  initialUsersFile = ./my-users.json; # Path to the JSON file
};
```
