FROM mcr.microsoft.com/dotnet/sdk:6.0 AS code
WORKDIR /code
COPY arm-dotnet-repro.csproj arm-dotnet-repro.csproj
COPY Program.cs Program.cs

FROM code AS publish-x64
RUN dotnet publish -o /app -c Release -r linux-x64 arm-dotnet-repro.csproj

# x64 behaves as expected
FROM mcr.microsoft.com/dotnet/runtime:6.0-focal-amd64 AS x64
WORKDIR /app
COPY --from=publish-x64 /app /app
ENTRYPOINT [ "dotnet", "arm-dotnet-repro.dll" ]

FROM code AS publish-arm64
RUN dotnet publish -o /app -c Release -r linux-arm64 arm-dotnet-repro.csproj

# arm64 hangs on unhandled expection and causes 100% utilization of 1 CPU core
FROM mcr.microsoft.com/dotnet/runtime:6.0-focal-arm64v8 AS arm64
WORKDIR /app
COPY --from=publish-arm64 /app /app
ENTRYPOINT [ "dotnet", "arm-dotnet-repro.dll" ]

# Workaround using an entrypoint script, dotnet does not respond to SIGINT
FROM arm64 AS arm64-entrypoint
COPY ./dotnet-wrap.sh ./dotnet-wrap.sh
RUN chmod +x ./dotnet-wrap.sh
ENTRYPOINT [ "./dotnet-wrap.sh", "arm-dotnet-repro.dll" ]

# Workaround using an entrypoint script, dotnet responds to SIGINT but hangs on exception
FROM arm64 AS arm64-entrypoint-exec
COPY ./dotnet-exec.sh ./dotnet-exec.sh
RUN chmod +x ./dotnet-exec.sh
ENTRYPOINT [ "./dotnet-exec.sh", "arm-dotnet-repro.dll" ]

# Workaround using global exception handler
FROM arm64 AS arm64-global-ex
ENV USE_GLOBAL_EX=1

# Workaround using an entrypoint script, seems to be working same as x64
FROM arm64 AS arm64-entrypoint-wait
COPY ./dotnet-wrap-wait.sh ./dotnet-wrap-wait.sh
RUN chmod +x ./dotnet-wrap-wait.sh
ENTRYPOINT [ "./dotnet-wrap-wait.sh", "arm-dotnet-repro.dll" ]
