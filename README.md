# Intranet

Eine Miniapp zum verschicken vergessener Passwörter.

Läuft unter Ruby und benötigt folgendes:

* Konto bei [https://www.mailgun.com/](Mailgun)
* Server mit Ruby
* Einheitliche eMail-Domain
* Konfigurationsdatei mit folgendem Inhalt:

```bash
MG_ZUL_DOMAIN: unsere-domain.de
MG_API_KEY: key-1234567890
MG_SENDER: "Dein Admin <der.admin@unsere-domain.de>"
MG_DOMAIN: mg.email-domain.de
MG_USER: "Der_zu_verschickende_Benutzername"
MG_PASSWORD: "Das_zu_verschickende_Passwort"
```

Ob man Ruby auf dem Server hat, erfährt man mit:

`ruby -v`

Bekommt man eine Version über 2.x angezeigt, ist alle prima.

Dann entweder das Repository mit Git runterladen:

`git clone https://github.com/hmt/intranet.git`

oder als Archiv unter [https://github.com/hmt/intranet](https://github.com/hmt/intranet)

Dann mit `cd intranet` ins Verzeichnis wechseln, und die benötigten
Bibliothen installieren:

`bundle install`

Dann kann es auch schon losgehen mit dem Server:

`puma`

Die Seite ist nun über die IP des Servers erreichbar, Port sollte `9292`
sein.

`intranet` ist von hmt unter der MIT-Lizenz lizenziert.
