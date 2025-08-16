# 🔑 Rofi Password Manager

A simple **password manager script** built on top of [pass](https://www.passwordstore.org/), [rofi](https://github.com/davatorium/rofi), and [xclip](https://github.com/astrand/xclip).
It provides a minimal graphical menu (via rofi) to **store, generate, read, edit, and remove passwords** securely from your password store.

---

## ✨ Features

* **Generate** random secure passwords (with optional username & URL)
* **Store** existing passwords with metadata
* **Read** and copy password or username directly to clipboard
* **Edit** passwords, usernames, or URLs without opening an editor
* **Remove** entries with confirmation
* Clipboard integration with **xclip**
* Desktop notifications using `notify-send`

---

## 📦 Requirements

Make sure these dependencies are installed on your system:

* [pass](https://www.passwordstore.org/) (Password manager using GnuPG)
* [rofi](https://github.com/davatorium/rofi) (for the dmenu interface)
* [xclip](https://github.com/astrand/xclip) (for clipboard integration)
* `openssl` (for password generation)
* `notify-send` (comes with libnotify, for notifications)
* GnuPG (`gpg`) configured and working (since `pass` relies on it)

On **Debian/Ubuntu-based distros**:

```bash
sudo apt install pass rofi xclip openssl libnotify-bin gnupg
```

On **Arch Linux**:

```bash
sudo pacman -S pass rofi xclip openssl libnotify gnupg
```

---

## ⚙️ Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/mzfr/passmenu.git
   cd passmenu
   ```

2. Make the script executable:

   ```bash
   chmod +x passmenu.sh
   ```

3. (Optional) Add it to your `$PATH`:

   ```bash
   sudo ln -s "$(pwd)/passmenu.sh" /usr/local/bin/passmenu
   ```

4. Initialize your password store (if you haven’t already):

   ```bash
   pass init "Your GPG Key ID"
   ```

---

## 🚀 Usage

Run:

```bash
./passmenu.sh
```

or if symlinked:

```bash
passmenu
```

You’ll be presented with a rofi menu:

* **Generate** → Create a new random password with metadata
* **Store** → Store an existing password
* **Read** → Copy password/username to clipboard
* **Edit** → Update password/username/URL inline
* **Remove** → Delete an entry

---

## 📂 Password Format

Each entry is stored in `pass` with the following structure:

```
<password>
username: <username>
url: <url>
```

Example:

```
S3cureP@ssw0rd
username: alice
url: https://example.com
```

---

## 🖼️ Demo

👉 *(Add a screenshot or gif here later if you want!)*

---

## 🔒 Security Notes

* Clipboard contents remain available until overwritten — consider using tools like [`xclip -selection clipboard -i /dev/null`](https://linux.die.net/man/1/xclip) or clipboard managers that auto-clear sensitive data.
* Make sure your `~/.gnupg` permissions are set correctly:

  ```bash
  chmod 700 ~/.gnupg
  chmod 600 ~/.gnupg/*
  ```

---

## 📜 License

MIT License.
Feel free to modify and share.

---
