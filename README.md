# arm-dotnet-repro

Correct behavior on x64:

`docker build -t ex-repro:x64-1 --target x64 .; docker run --rm -it ex-repro:x64-1;`

---

Incorrect behavior on arm64 (this freezes my powershell on windows with qemu):

`docker build -t ex-repro:arm64-1 --target arm64 .; docker run --rm -it ex-repro:arm64-1;`

---

Correct behavior with entrypoint script workaround on arm64:

`docker build -t ex-repro:arm64-entrypoint-1 --target arm64-entrypoint .; docker run --rm -it ex-repro:arm64-entrypoint-1;`

---

Good but not ideal behavior with Unhandled exception event workaround on arm64:

`docker build -t ex-repro:arm64-global-ex --target arm64-global-ex .; docker run --rm -it ex-repro:arm64-global-ex;`
