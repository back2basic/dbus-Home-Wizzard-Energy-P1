# dbus-HomeWizard-energy-p1
This project is not affiliated with HomeWizard or Victron.

Integrate HomeWizard Energy P1 meter into [Victron Energies Venus OS](https://github.com/victronenergy/venus)
forked from https://github.com/back2basic/dbus-Home-Wizzard-Energy-P1 who forked from https://github.com/fabian-lauer/dbus-shelly-3em-smartmeter

## Purpose
With the scripts in this repo it should be easy possible to install, uninstall, restart a service that connects the HomeWizard P1 to the VenusOS and GX devices from Victron.
Idea is pasend on @RalfZim project linked below.

I cleaned it up a bit and added mDNS auto discovery



## Inspiration
This project is my first on GitHub and with the Victron Venus OS, so I took some ideas and approaches from the following projects - many thanks for sharing the knowledge:
- https://github.com/RalfZim/venus.dbus-fronius-smartmeter
- https://github.com/victronenergy/dbus-smappee
- https://github.com/Louisvdw/dbus-serialbattery
- https://community.victronenergy.com/idea/114716/power-meter-lib-for-modbus-rtu-based-meters-from-a.html - [Old Thread](https://community.victronenergy.com/questions/85564/eastron-sdm630-modbus-energy-meter-community-editi.html)
- https://github.com/fabian-lauer/dbus-shelly-3em-smartmeter

## How it works
### My setup
- HomeWizard Energy P1 with latest firmware
  - 1 or 3-Phase installation (normal for Netherlands)
  - Connected to Wifi network "A"
  - IP 192.168.2.13/24
- Victron Energy Cerbo GX with Venus OS - Firmware v3.11
  - No other devices from Victron connected (still waiting for shipment of Multiplus-2)
  - Connected to Wifi network "A"
  - IP 192.168.2.20/24

### Details / Process
As mentioned above the script is inspired by @RalfZim fronius smartmeter implementation.
So what is the script doing:
- Running as a service
- connecting to DBus of the Venus OS `com.victronenergy.grid.http_40` or `com.victronenergy.pvinverter.http_40`
- After successful DBus connection HomeWizard P1 is accessed via REST-API - simply the /status is called and a JSON is returned with all details
  A sample JSON file from HomeWizard Energy P1 can be found [here](docs/homewizard-energy-p1.json)
- Serial is taken from the response as device serial
- Paths are added to the DBus with default value 0 - including some settings like name, etc
- After that a "loop" is started which pulls HomeWizard P1 data every 500ms from the REST-API and updates the values in the DBus

Thats it 😄

### Pictures
![Tile Overview](img/VenusOs_Overview.png)
![Remote Console - Overview](img/VenusOs_DeviceList.png)
![SmartMeter - Values](img/VenusOs_P1.png)
![SmartMeter - Device Details](img/VenusOs_Service.png)




## Install & Configuration
### Get the code
Just grap a copy of the main branche and copy them to `/data/dbus-HomeWizard-Energy-P1`.
After that call the install.sh script.

The following script should do everything for you: (ssh as root onto your GX device: https://www.victronenergy.com/live/ccgx:root_access#enable_sshd_and_log_in )
```
wget https://github.com/JensTimmerman/dbus-HomeWizard-Energy-P1/archive/refs/heads/main.zip
unzip main.zip "dbus-HomeWizard-Energy-P1-main/*" -d /data
mv /data/dbus-HomeWizard-Energy-P1-main /data/dbus-HomeWizard-Energy-P1
chmod a+x /data/dbus-HomeWizard-Energy-P1/install.sh
/data/dbus-HomeWizard-Energy-P1/install.sh
rm main.zip
```
⚠️ Check configuration after that - because service is already installed an running and with wrong connection data (host, username, pwd) you will spam the log-file

### Change config.ini
Within the project there is a file `/data/dbus-HomeWizard-Energy-P1/config.ini` - just change the values - most important is the host, username and password in section "ONPREMISE". More details below:

| Section  | Config vlaue | Explanation |
| ------------- | ------------- | ------------- |
| DEFAULT  | AccessType | Fixed value 'OnPremise' |
| DEFAULT  | SignOfLifeLog  | Time in minutes how often a status is added to the log-file `current.log` with log-level INFO |
| DEFAULT  | CustomName  | Name of your device - usefull if you want to run multiple versions of the script |
| DEFAULT  | DeviceInstance  | DeviceInstanceNumber e.g. 40 |
| DEFAULT  | Role | Fixed value:  'GRID' |
| DEFAULT  | Position | Fixed value: 0 = AC|
| DEFAULT  | LogLevel  | Define the level of logging - lookup: https://docs.python.org/3/library/logging.html#levels |
| DEFAULT  | Phases  | 1 for 1 phase system / 3 for 3 phase system |
| ONPREMISE  | Host | IP or hostname of on-premise HomeWizard P1 web-interface, leave on 'autodiscover' for mDNS discovery |
<!-- | ONPREMISE  | Username | Username for htaccess login - leave blank if no username/password required |
| ONPREMISE  | Password | Password for htaccess login - leave blank if no username/password required |
| ONPREMISE  | L1Position | Which input on the HomeWizard P1 in 3-phase grid is supplying a single Multi | -->


<!-- ### Remapping L1
In a 3-phase grid with a single Multi, Venus OS expects L1 to be supplying the only Multi. This is not always the case. If for example your Multi is supplied by L3 your GX device will show AC Loads as consuming from both L1 and L3. Setting `L1Position` to the appropriate HomeWizard P1 input allows for remapping the phases and showing correct data on the GX device.
-->

## Used documentation
- https://github.com/victronenergy/venus/wiki/dbus#grid   DBus paths for Victron namespace GRID
- https://github.com/victronenergy/venus/wiki/dbus#pv-inverters   DBus paths for Victron namespace PVINVERTER
- https://github.com/victronenergy/venus/wiki/dbus-api   DBus API from Victron
- https://www.victronenergy.com/live/ccgx:root_access   How to get root access on GX device/Venus OS

## Discussions on the web
This module/repository has been posted on the following threads:
- https://community.victronenergy.com/questions/238117/home-wizzard-energy-p1-meter-in-venusos.html
