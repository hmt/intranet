require 'sinatra'
require 'mailgun-ruby'
require 'envyable'
# env.yml mit den unten verwendeten ENV anleg
Envyable.load("#{File.dirname(__FILE__)}/config/env.yml")

helpers do
  def repost(adresse)
    mg_client = Mailgun::Client.new(ENV['MG_API_KEY'])
    message_params =  {
      from: ENV['MG_SENDER'],
      to:  adresse,
      subject: 'Zugangsdaten zum Intranet',
      text:    "Jemand hat die Zugangsdaten zum Intranet für diese Adresse angefordert.\n\nBenutzername und Passwort:\n#{ENV['MG_USER']}\n#{ENV['MG_PASSWORD']}\n\nEinen schönen Tag noch und bis zum nächsten Mal."
    }
    result = mg_client.send_message(ENV['MG_DOMAIN'], message_params).to_h!
    puts "Nachricht an #{adresse} verschickt"
  end
end

get '/' do
  <<-eos
    <html>
      <head>
          <meta charset="utf-8">
          <title>Zugangsdaten vergessen</title>
          <style media="screen" type="text/css">
            *, *:before, *:after {
              -moz-box-sizing: border-box;
              -webkit-box-sizing: border-box;
              box-sizing: border-box;
            }
            form {
              max-width: 400px;
              margin: 10px auto;
              padding: 10px 20px;
              background: #f4f7f8;
              border-radius: 8px;
            }
            h1 {
              margin: 0 0 30px 0;
              text-align: center;
            }
            input[type="email"],
            textarea,
            select {
              background: rgba(255,255,255,0.1);
              border: none;
              font-style: normal;
              font-size: 16px;
              height: auto;
              margin: 0;
              outline: 0;
              padding: 15px;
              width: 100%;
              background-color: #e8eeef;
              color: #000000;
              box-shadow: 0 1px 0 rgba(0,0,0,0.03) inset;
              margin-bottom: 30px;
            }
            button {
              padding: 19px 39px 18px 39px;
              color: #FFF;
              background-color: #4bc970;
              font-size: 18px;
              text-align: center;
              font-style: normal;
              border-radius: 5px;
              width: 100%;
              border: 1px solid #3ac162;
              border-width: 1px 1px 3px;
              box-shadow: 0 -1px 0 rgba(255,255,255,0.1) inset;
              margin-bottom: 10px;
            }
            fieldset {
              margin-bottom: 30px;
              border: none;
            }
            label {
              display: block;
              margin-bottom: 8px;
            }
          </style>
        </head>
        <body>
          <form action="/repost" method="post">
            <h1>Zugangsdaten zum Intranet vergessen?</h1>
            <fieldset>
              <label for="mail">Bitte Dienstadresse angeben</label>
              <input type="email" id="mail" name="email" placeholder="Vorname.Name@fvbschulen.de">
            </fieldset>
            <button type="submit">Zugangsdaten zuschicken</button>
          </form>
        </body>
    </html>
  eos
end

post "/repost" do
  adresse = params["email"]
  domain = adresse.scan(/(?<=@)([^\s]+)(?=\s|$)/).join
  if ENV['MG_ZUL_DOMAIN']== domain
    repost(adresse)
    puts "Nachricht an #{adresse} verschickt"
    <<-eos
      <html>
        <head>
          <meta charset="utf-8">
          <title>Zugangsdaten verschickt</title>
          <style type="text/css">h1 {margin: 30px 30px 30px 30px; text-align: center;}</style>
        </head>
        <body><h1>Zugangsdaten verschickt, bis zum nächsten Mal.</h1></body>
      </html>
    eos
  else
    puts "Fehler: #{adresse} unzulässig"
    <<-eos
      <html>
        <head>
          <meta charset="utf-8">
          <title>Fehler!</title>
          <style type="text/css">h1 {margin: 30px 30px 30px 30px; text-align: center;}</style>
        </head>
        <body><h1>Nur Dienstadressen sind zulässig.</h1></body>
      </html>
    eos
  end
end

