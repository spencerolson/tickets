# Tickets

CLI for tracking tickets.

## Installation

Run `bundle install`

## Running it

Add `bin/tickets` to your PATH for convenience, and then call `tickets` anywhere. Or, run `bin/tickets`. You'll be presented with a menu that contains the options outlined in the sections below.

Alternatively, if you don't need the menu and know exactly what operation you want to perform, you can pass a flag, e.g.

```
tickets --list
```

For a list of supported flags, enter

```
tickets --help
```

or

```
tickets -h
```

## Menu Options

### Add a ticket

Provide a ticket name, and optionally a ticket description, priority, and completion status.

### Edit a ticket

Allows you to change the details for a ticket.

### Delete a ticket

Allows you to remove a ticket.

### List tickets

Prints out the tickets in order of priority.

## tickets.json

All tickets added will be saved in `tickets.json` in the root of the project.
