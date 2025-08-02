# Standard Database

This module sets up a basic PostgreSQL service, creates a user and a database, and then executes a SQL script the first time the database is started. Itn leverages the existing and robust services.postgresql module built into NixOS and is imported it into the `configuration.nix` file. The services.postgresql attribute set is part of the NixOS module system and is used to configure the database. An initial database named "standard" is automatically created.
