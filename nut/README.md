# System Requirements



- Proxmox 7 pve
- UPS / SAI -  SPS 700/500 Salicru

## Change
- Install packages nut-server nut-client pgwen
- Create user for admin and hamon
- automatic add service to startup ( systemctl )

## Install:

```bash
bash -c "$(wget -qLO - https://raw.githubusercontent.com/patriciocl/proxmoxha/main/nut/install.sh)"
```

