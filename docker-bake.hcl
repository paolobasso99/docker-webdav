group "default" {
	targets = ["latest"]
}

target "latest" {
	platforms = ["linux/amd64", "linux/arm/v7", "linux/arm64"]
	tags = [
		"paolobasso/webdav:latest"
	]
}
