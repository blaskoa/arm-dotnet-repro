// See https://aka.ms/new-console-template for more information


if (!string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("USE_GLOBAL_EX")))
{
    AppDomain.CurrentDomain.UnhandledException += (sender, eventArgs) =>
    {
        Environment.Exit(1);
    };
}

Console.WriteLine("Hello, World!");
throw new Exception("Unhandled exception");
