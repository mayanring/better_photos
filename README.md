Better Photos
=============

### Or: Parks and Recommendations

## Setup

### Prediction.io

Hopefully you have this setup properly and have trained data. I have no idea what I'm doing here. You need to have a query engine running.

### Postgres

You'll need to install Postgres. We currently don't use it, but Rails needs a default database, so that was it. You can get Postgres [here](//postgresapp.com). After downloading, drag that to your Applications and then start it up. Make sure to open the documentation and follow the instructions for command line tools.

### Rails

Run `bundle install`.
Run `bundle exec rake db:create`.

By default, the app will expect your query engine to run on port 8000. If you want to override, specify an `ENV['PIO_ENGINE_URL']` somewhere in your config.

Setup your consumer key and secrets (you'll have to make an app on 500px - see "applications" section under "settings" - or find someone with credentials). Stick this stuff in `config/secrets.yml` as `consumer_key` and `consumer_secret`

Start Rails:

`rails s`

Point your browser at `localhost:3000`. Boom.

