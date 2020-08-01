
2fa is a two-factor authentication agent.

> 2fa is based on Russ Cox's [2fa](https://github.com/rsc/2fa) library, written in [go](https://golang.org/). I thought it would be a good exercise re-writing it in [Ruby](https://www.ruby-lang.org/en/).

Usage:

```console
2fa -add name
2fa -list
2fa name
```

`2fa -add name` adds a new key to the 2fa keychain with the given name. It prints a prompt to standard output and reads a two-factor key from standard input.

The new key generates a time-based (TOTP) authentication codes made up of 6-digit.

`2fa -list` lists the names of all the keys in the keychain.

`2fa name` prints a two-factor authentication code from the key with the given name. If `-clip` is specified, 2fa also copies the code to the system clipboard.

The keychain is stored encrypted in the text file `$PWD/.2fa`.

# Example

During Twitter 2FA setup, at the "scan the following QR code with your camera" step, click the "Can’t scan QR code?" link. A new window is shown with a code - *a bold string of letters and digits*.

Add it to 2fa under the name twitter, typing the secret at the prompt:

```console
$ 2fa -add twitter
2fa key for twitter: KERZ 2YRQ INYK 7GH4
$
```
Then whenever Twitter prompts for a 2FA code, run 2fa to obtain one:

```console
$ 2fa twitter
268346
$
```

Or to type less:

```console
$ 2fa
268346	twitter
$
```