# searchConsole
Query the Google Webmaster Tools API via Python or R

This repo provides two ways to pull data from Google Webmaster Tools Search Console.
You use either [`python`](/python) or [`R` using `searchConsoleR`](/r).

The [`Dockerfile`](Dockerfile) will help you build a docker image to run these scripts automatically in a container.

The [`cloudbuild.yaml`](cloudbuild.yaml) provides the steps for building the docker image to run on Google Compute Engine.
