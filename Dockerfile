# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# Copy solution and project files first (for layer caching)
COPY src/MyProject.slnx ./
COPY src/MyProject/MyProject.csproj MyProject/
COPY src/MyProject.Tests/MyProject.Tests.csproj MyProject.Tests/

RUN dotnet restore MyProject.slnx

# Copy source
COPY src/MyProject/ MyProject/

# Build & publish
RUN dotnet publish MyProject/MyProject.csproj \
    --configuration Release \
    --no-restore \
    --output /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# Create non-root user
RUN addgroup --system --gid 1001 appgroup \
    && adduser --system --uid 1001 --ingroup appgroup appuser

COPY --from=build /app/publish .

USER appuser

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "MyProject.dll"]
