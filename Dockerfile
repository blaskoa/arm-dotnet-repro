FROM mcr.microsoft.com/dotnet/sdk:6.0 as code
WORKDIR /code
COPY arm-dotnet-repro.csproj arm-dotnet-repro.csproj
COPY Program.cs Program.cs

FROM code as publish-x64
RUN dotnet publish -o /app -c Release -r linux-x64 arm-dotnet-repro.csproj

# x64 behaves as expected
FROM mcr.microsoft.com/dotnet/runtime:6.0-focal-amd64 as x64
WORKDIR /app
COPY --from=publish-x64 /app /app
ENTRYPOINT [ "dotnet", "arm-dotnet-repro.dll" ]

FROM code as publish-arm64
RUN dotnet publish -o /app -c Release -r linux-arm64 arm-dotnet-repro.csproj

# arm64 hangs on unhandled expection and causes 100% utilization of 1 CPU core
FROM mcr.microsoft.com/dotnet/runtime:6.0-focal-arm64v8 as arm64
WORKDIR /app
COPY --from=publish-arm64 /app /app
ENTRYPOINT [ "dotnet", "arm-dotnet-repro.dll" ]

# Workaround using an entrypoint script works properly
FROM arm64 as arm64-entrypoint
COPY ./entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh
ENTRYPOINT [ "./entrypoint.sh" ]

# Workaround using global exception handler
FROM arm64 AS arm64-global-ex
ENV USE_GLOBAL_EX=1
