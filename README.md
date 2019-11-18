![Screenshot](https://i.imgur.com/yIFVpY2.png)

# MultiSubCheck
## MultiSubCheck can scan HTTP Headers & subdomain takeover vulnerabilites on all subdomains of a specified domain.

### Requirements:
- Linux (Made and tested on Kali VM)
- [Sublist3r](https://github.com/aboul3la/Sublist3r) (move executable to /usr/bin/)
- [NMAP](https://nmap.org/download.html)

### Installation:
```bash
git clone https://github.com/n0khodsia/MultiSubCheck.git
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r/
pip install -r requirements.txt
cp ../MultiSubCheck/* .
chmod +x MSC.sh
```

### Usage:
```bash
./MSC.sh domain.com
```

This tool is for educational purposes only. I am not responsible of any misuses of this tool.
