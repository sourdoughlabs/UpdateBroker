## Welcome

This is a simple service for routing update events from an app to connected
web clients using Server Sent Events that are read from a named redis pub/sub
queue.

## Requirements

 Redis
 Ruby >= 1.9.2

## Installation

  gem install updatebroker

Note, do NOT add this to your Gemfile (for Rails 3.1 anyways).  It brings in
asynch-rack which seems to conflict.

## Usage

  updatebroker --help

## Adding support for your web app.

  See ./example/* [TBD]

## Gotchas

  TBD

## License

  MIT




