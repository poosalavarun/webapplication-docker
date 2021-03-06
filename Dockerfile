FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ["WebApplication-docker/WebApplication-docker.csproj", "WebApplication-docker/"]
RUN dotnet restore "WebApplication-docker/WebApplication-docker.csproj"
COPY . .
WORKDIR "/src/WebApplication-docker"
RUN dotnet build "WebApplication-docker.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WebApplication-docker.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "WebApplication-docker.dll"]