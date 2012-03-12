h2. Welcome

This is a simple service for routing update events from an app to connected
web clients using Server Sent Events that are read from a named redis pub/sub
queue.

h2. Requirements

 Redis
 Ruby >= 1.9.2

h2. Installation

  gem install updatebroker

Note, do NOT add this to your Gemfile (for Rails 3.1 anyways).  It brings in
asynch-rack which seems to conflict.

h2. Usage

  updatebroker --help

h2. Adding support for your web app.

  See ./example/* [TBD]

h2. Gotchas

  TBD

h2. License

  MIT




