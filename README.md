# Noctalia Victus Control

`victus-control` plugin for Noctalia Shell. Currently works on Niri, not tested on Hyprland.

---

## REQUIREMENTS

### Hardware
* **Supported Models:** Refer to the https://github.com/TUXOV/hp-wmi-fan-and-backlight-control
* **Firmware:** Secure Boot should be disabled to allow for custom kernel module interactions if required.

### Software
* **Backend:** This plugin uses `victus-control` you need to install it in order to use this plugin.
* * **victus-control:** https://github.com/TUXOV/hp-wmi-fan-and-backlight-control
* **Kernel:** Linux Kernel 6.1.x or newer (CachyOS highly recommended for optimized `hp-wmi` support).
* **Drivers:** The `hp-wmi` kernel module must be loaded.
---

## INSTALLATION

I'll try to add the plugin into Noctalia's browser for now you can install it via source.
