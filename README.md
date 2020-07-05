CWA Data Downloader
===================

A downloader of the current *diagnosis keys* and *configuration parameters* (e.g. weights for risk calculation) of the [German *Corona Warn App* (CWA)](https://github.com/corona-warn-app).
The data is downloaded directly from the Content Delivery Network (CDN), which is periodically queried by the official mobile app as well.

**Please use this (or any other) downloader moderately in order not to negatively affect the CWA service!**

## Dependencies
```
bash curl unzip protobuf
```
Optional (for a local webserver):
```
python screen
```

## Usage
```sh
./download-cwa-data.sh
```
This will do the following:

* Download all available diagnosis keys to ``download/<current-date>/diagnosis-keys/``
* Download latest config parameters to ``download/<current-date>/app-config/``
* Convert the config parameters into human-readable form ``download/<current-date>/app-config/app-config.txt``
* Provide the *latest* parameters as an HTML snippet in ``summary/summary.htm``

### Example
An example for downloaded config parameters is privided in [``example/app-config.txt``](example/app-config.txt).

## Add a cronjob
To perform an automatic download 4 times a day, run the following command once:
```sh
./add-cronjob.sh
```
Don't forget to start the cron service on your system, e.g. ``systemctl start cronie``.

## Webserver
A simple webserver is included to provide a convenient access to the *most recent* config parameters.
To start the server, run the following command:
```sh
screen ./http-server.py
```
To stop the server, re-attach to the *screen session*, e.g. ``screen -r`` and press CTRL+C.

Access the summary by the following address: http://localhost:31501

## Disclaimer
**Please use these scripts with caution**, especially because these scripts perform write access on your hard disk. The authors of this package are not responsible for any claims or damages arising out of the use of this package.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## License
Apache 2.0


