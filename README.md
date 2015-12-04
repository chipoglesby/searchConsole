# Search Console

This script lets you query the <a href="https://developers.google.com/webmaster-tools/">Google Webmaster Tools API</a> via a Python script.

To get started, you'll need to create a new project in the Google Developer Console, enable the Google Search Console API.

Afterwards, you’ll want to edit the client_secrets.json file and insert your own client_id and client_secret.

Once that’s set up, you’ll be able to query any website that you have claimed in Webmaster Tools.

You can clone this repo to your local computer, fire up terminal and type in:
python search.py 'www.website.com' '2015-08-01' '2015-12-04'

If you want to save your results to a csv file, you can type in:
python search.py 'www.website.com' '2015-08-01' '2015-12-04' > results.csv

The date range is limited to 90 days, so you might want to consider how you store your data long-term. You could enable the Google Drive API and write the data to a <a href=“https://github.com/triketora/women-in-software-eng/blob/master/update_script.py”>Google spreadsheet.</a> You could also take it one step further and host it all on app engine.
