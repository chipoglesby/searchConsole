FROM gcr.io/xxxx/rbaseplus:latest

# Copy the search Console Repo into Docker
copy searchConsole /searchConsole

ENTRYPOINT ["tail", "-f", "/dev/null"]