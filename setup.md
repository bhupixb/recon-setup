Create a Dockerfile for a personal development shell. Requirements:

- Base image: `debian:bookworm`
- Must install the following CLI tools:
  - `zsh`, `curl`, `git`, `jq`, `yq`, `ripgrep`, `fd-find` (and symlink to `fd`), `dnsutils`, `netcat`, `iputils-ping`, `fzf`, `locales`, `sudo`
- Configure `zsh`:
  - Install `fzf` from GitHub with its keybindings
  - Enable persistent history with fuzzy search using `fzf` on `Ctrl+R`
  - Configure `.zshrc` to support large persistent history across sessions
- Add a non-root user `dev` with home directory `/home/dev`, default shell `/bin/zsh`, and passwordless sudo
- Set up proper `en_US.UTF-8` locale
- Place the zsh history file at `~/.zsh_history` (ensure it can be mounted externally)
- Set working directory to `/home/dev`

Extra (optional):
- Python 3 and pipx (installed in user mode)
- Go with `go install` support
- Ensure all commands are non-interactive (suppress prompts)
- Clean up `apt` caches after install

Make sure the Dockerfile is clean, organized, and uses best practices.
