> *These are my utility scripts that I find good enough to publish. No guarantees.*

## UPM
> A simple-ish "Package manager" for apt-based systems. Designed to install packages from apt on systems where you don't have root. Requires GNU bash or compatible. Downloads packages into ~/.upm/installed.	

### Usage
> `./upm.sh <package name> [--verbose] `

### Known issues
- Adding to .bashrc does not work
- Likely to not work on some systems
- Verbose is just `set -x`

*More will be added soon*