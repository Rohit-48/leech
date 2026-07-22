# leech
**what is leech?** <br>
You know how your laptop is constantly "phoning home",  apps checking for updates, ads loading, some background service pinging a server you've never heard of? Right now, you have basically zero visibility into that. It's happening silently, all the time, and you'd need to be a network wizard to see it.
leech is a live dashboard, right in your terminal, that shows you exactly that, in real time.

Something like:

```
Process       Domain                  Time
firefox       google.com              12:03:41
spotify       spclient.wg.spotify.com 12:03:42
some-daemon   sketchy-tracker.io      12:03:44
```

So instead of your machine's network chatter being invisible, you get a live feed of who's talking to the internet and where.

The actual "crazy" part of the idea, most simple network tools show you traffic, but connecting it back to a specific running process is the genuinely hard, systems-level puzzle we're solving.

**Note**
Why bother building it? Real talk -- it's not solving world hunger or cancer, it's a learning project. It forces you through actual Linux networking internals, Rust systems programming, and process/socket internals.
