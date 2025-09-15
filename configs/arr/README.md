# *Arr Stack Configs

Tested on Ubuntu 22.04

## Requirements:
- Latest version of Docker with the "compose" plugin.
- Create a directory where you'd like your media to be stored.

### Created Directory Structure:
```
/media
| /tv
| /movies
| /books
/downloads
| /torrents
| | complete
| | incomplete
```
(*Example: `YOUR_DIRECTORY/downloads/complete`*)

## Instructions:
1. Change the contents of LOCAL_STORAGE in `.env.example` to where you want your downloaded media to be stored.
2. Rename `.env.example` to `.env`
3. Run `docker-compose up -d`

⚠️ **After first run you must add your VPN configuration files to the `~/.config/appdata/qbittorrentvpn/wireguard` directory!**

## Access:
- Jellyfin: `x.x.x.x:8096`
- Radarr: `x.x.x.x:7878`
- Sonarr: `x.x.x.x:8989`
- Prowlarr: `x.x.x.x:9696`
- QBitorrentVpn: `x.x.x.x:8080`

## Configuration:
### Jellyfin:
1. In the admin dashboard, add sources using the `/storage` directory. (*i.e. `/storage/movies`*)

### Radarr:
1. Add QBittorrentVPN as a Downloader source following the wizard in settings.
2. Add Prowlarr as an Indexer source in the wizard.

### Sonarr:
1. Add QBittorrentVPN as a Downloader source following the wizard in settings.
2. Add Prowlarr as an Indexer source in the wizard.

### Prowlarr:
1. Add your desired indexers. 
