provider "docker" {}

resource "docker_image" "sonarr" {
  name = "linuxserver/sonarr"
}
resource "docker_image" "radarr" {
  name = "linuxserver/radarr"
}

resource "docker_network" "wp" {
  name = "wp_network"
}

resource "docker_volume" "sonarr_config" {
  name = "sonarr_config"
}
resource "docker_volume" "sonarr_tv" {
  name = "sonarr_tv"
}
resource "docker_volume" "sonarr_downloads" {
  name = "sonarr_downloads"
}
resource "docker_volume" "radarr_config" {
    name = "radarr_config"
}
resource "docker_volume" "radarr_movies" {
    name = "radarr_movies"
}
resource "docker_volume" "radarr_downloads" {
    name = "radarr_download"
}

resource "docker_container" "sonarr" {
  name    = "sonarr"
  image   = docker_image.sonarr.latest
  restart = "always"
  volumes {
    volume_name    = docker_volume.sonarr_config.name
    container_path = "/config"
    read_only      = false
  }
  volumes {
    volume_name    = docker_volume.sonarr_tv.name
    container_path = "/tv"
    read_only      = false
  }
  volumes {
    volume_name    = docker_volume.sonarr_downloads.name
    container_path = "/downloads"
    read_only      = false
  }
  ports {
    internal = "8989"
    external = "8989"
  }
    env = [
    "TZ=Europe/Minsk"
  ]
  networks_advanced {
    name = docker_network.wp.name
  }
}

resource "docker_container" "radarr" {
  name    = "radarr"
  image   = docker_image.radarr.latest
  restart = "always"
  volumes {
    volume_name    = docker_volume.radarr_config.name
    container_path = "/config"
    read_only      = false
  }
  volumes {
    volume_name    = docker_volume.radarr_movies.name
    container_path = "/movies"
    read_only      = false
  }
  volumes {
    volume_name    = docker_volume.radarr_downloads.name
    container_path = "/downloads"
    read_only      = false
  }
  ports {
    internal = "7878"
    external = "7878"
  }
  env = [
    "TZ=Europe/Minsk"
  ]
  networks_advanced {
    name = docker_network.wp.name
  }
}
