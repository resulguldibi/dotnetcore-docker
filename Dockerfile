FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
#COPY *.sln .
COPY dotnetcore-api/*.csproj ./dotnetcore-api/
WORKDIR /app/dotnetcore-api
RUN dotnet restore

# copy everything else and build app
COPY dotnetcore-api/. ./dotnetcore-api/
WORKDIR /app/dotnetcore-api
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:2.2 AS runtime
WORKDIR /app
COPY --from=build /app/dotnetcore-api/out ./
ENTRYPOINT ["dotnet", "dotnetcore-api.dll"]
