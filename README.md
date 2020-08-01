
2fa is a two-factor authentication agent.

> 2fa is based on Russ Cox's [2fa](https://github.com/rsc/2fa) library, written in [go](https://golang.org/). I thought re-writing it in [Ruby](https://www.ruby-lang.org/en/) would be a good exercise.

Usage:

```bash
2fa --name [NAME]
2fa [NAME]
2fa --list
```

`2fa --name [NAME]` adds a new key to the 2fa keychain with the given name. It prints a prompt to standard output and reads a two-factor key from standard input.

The new key generates a time-based (TOTP) authentication codes made up of 6-digit.

`2fa --list` lists the names of all the keys in the keychain.

`2fa [NAME]` prints a two-factor authentication code from the key with the given name.

The keychain is stored encrypted in the text file `$PWD/.2fa`.

# Example

During Twitter 2FA setup, at the "scan the following QR code with your camera" step, click the "Can’t scan QR code?" link. A new window is shown with a code - *a bold string of letters and digits*.

Add it to 2fa under the name twitter, typing the secret at the prompt:

```bash
$ 2fa --name twitter
2fa key for twitter: KERZ 2YRQ INYK 7GH4
$
```
Then whenever Twitter prompts for a 2FA code, run 2fa to obtain one:

```bash
$ 2fa twitter
268346
$
```

Or list the names of all keys:

```bash
$ 2fa --list
twitter
$
```
