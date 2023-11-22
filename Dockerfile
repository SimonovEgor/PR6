#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["PR6-Docker/PR6-Docker.csproj", "PR6-Docker/"]
RUN dotnet restore "PR6-Docker/PR6-Docker.csproj"
COPY . .
WORKDIR "/src/PR6-Docker"
RUN dotnet build "PR6-Docker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PR6-Docker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PR6-Docker.dll"]