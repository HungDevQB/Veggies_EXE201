# --- Build stage ---
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# copy csproj trước để cache restore
COPY *.sln ./
COPY Veggies_EXE201/*.csproj Veggies_EXE201/
RUN dotnet restore

# copy toàn bộ source
COPY . .
WORKDIR /src/Veggies_EXE201
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

# --- Run stage ---
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 8080

# Dòng này rất quan trọng khi deploy cloud
ENV ASPNETCORE_URLS=http://+:8080

# Tùy chọn: nếu có appsettings.Production.json
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "Veggies_EXE201.dll"]