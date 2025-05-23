using AutoMapper;
using Microsoft.EntityFrameworkCore;
using AirSense.Api;
using AirSense.Infrastructure;
using AirSense.Infrastructure.Database;
using AirSense.Api.Middlewares;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddHttpClient();
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowSpecificOrigin", policy =>
    {
        policy.WithOrigins("http://localhost:3000")  
              .AllowAnyMethod()                     
              .AllowAnyHeader()                      
              .AllowCredentials();                   
    });
});

builder.Services
    .ConfigureWebApiServices()
    .ConfigureInfrastructureServices(builder.Configuration);

builder.Services.AddDbContext<AirSenseContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));


var app = builder.Build();

app.UseCors("AllowSpecificOrigin");

app.UseMiddleware<BannedUserMiddleware>();
app.UseMiddleware<TokenValidationMiddleware>();

app.UseStaticFiles();

using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<AirSenseContext>();
    context.Database.Migrate();

}

app.UseRouting();

app.ConfigureWebApi();

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

var mapper = app.Services.GetRequiredService<IMapper>();
mapper.ConfigurationProvider.AssertConfigurationIsValid();