// See https://aka.ms/new-console-template for more information
if (!string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("USE_GLOBAL_EX")))
{
    AppDomain.CurrentDomain.UnhandledException += (sender, eventArgs) =>
    {
        Environment.Exit(1);
    };
}

Console.WriteLine("Hello, World!");

Console.WriteLine("Sleeping");
await Task.Delay(TimeSpan.FromSeconds(5));
Console.WriteLine("Done Sleeping");

throw new Exception("Unhandled exception");
