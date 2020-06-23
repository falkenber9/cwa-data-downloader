CWA Downloader
==============

A downloader for the Corona Warn App configuration and diagnosis keys.

# Usage
```sh
./download-cronfig.sh
```
This will do the following:

* Download latest parameters to ``download/<date>/``
* Convert the Message into human-readable form ``download/<date>/app-config/app-config.txt``
* Provide the *latest* parameters as an HTML snippet in ``summary/summary.htm``

# Add a cronjob
To perform the download 3 times a day, run the following command once:
```sh
./add-cronjob.sh
```
Don't forget to start the cron service on your system, e.g. ``systemctl start cronie``.

# License
Apache 2.0


