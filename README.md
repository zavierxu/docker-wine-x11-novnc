# Run A windows application with docker
Using the docker image to run windows application like smartget on my Synology Nas(DS 916+)
## Install Image
   `docker pull zavierxu/docker-wine-x11-novnc`
## Usage
### Run image as Server
   * Run
     ```bash
     docker run -p 8080:8080 -p 8081:22 zavierxu/docker-wine-x11-novnc
     ```
   * Run with Simplified Chinese Support
     ```bash
     docker run -p 8080:8080 -p 8081:22  -e LANG=zh_CN.UTF-8 -e LC_ALL=zh_CN.UTF-8 zavierxu/docker-wine-x11-novnc
     ```
   * Adanvace Run
     ```bash
     docker run \
     -v $HOME/Downloads:/home/xclient/.wine/drive_c/Downloads \
     -v $HOME/WinApp:/home/xclient/.wine/drive_c/WinApp \
     -p 8080:8080 \
     -p 8081:22 \
     zavierxu/docker-wine-x11-novnc
     ```

This follows these docker conventions:

*  `-v $HOME/WinApp:/home/xclient/.wine/drive_c/WinAp` shared volume (folder) for your Window's programs data.
*  `-v $HOME/Downloads:/home/xclient/.wine/drive_c/Downloads` shared volume (folder) for your Window's Download Folder.
*  `-p 8080:8080` port that you will be connecting to.(8080 has been hard code in the dockerfile, You can use port fowarding to other port like
	```bash
    -p 8083:8080
    ```
*  `-p 8081:22` SSH

### Client

* Using SSH
	```bash
	ssh -x xclient@hostname -p 8081
	```
    Defalutl password is 123456
* Using noVNC
	visit `http://hostname:8080` by the browse you like

### Thanks to
	Thanks to sykuang.
	This project is forked from https://github.com/sykuang/docker-wine-x11-novnc
