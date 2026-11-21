# S13 Training Camps

A self-contained student training website that runs as one Docker container.

## Single-container architecture

The `app` container provides everything:

- Responsive HTML, CSS, and JavaScript website
- Course catalog API
- Student registration and login API
- Enrollment API
- File-based demo persistence through the `app-data` Docker volume

The application uses only the Node.js standard library and has no package dependencies. CI publishes Docker Hub images tagged with the full Git commit SHA and `latest` for pushes to `develop`.

## Tools used

- HTML5, CSS3, and vanilla JavaScript
- Node.js 22
- Docker and Docker Compose
- Forgejo Actions
- Git and curl

## Run

```bash
docker build -t s13-training-camps:latest .
docker volume create s13-training-camps-data
docker run -d --name s13-training-camps --restart unless-stopped -p 8080:8080 -v s13-training-camps-data:/data s13-training-camps:latest
```

Open <http://localhost:8080>.

## Verify

```bash
docker ps --filter name=s13-training-camps
curl http://localhost:8080/health
curl http://localhost:8080/api/courses
```

## Stop

```bash
docker rm -f s13-training-camps
```

Use `docker volume rm s13-training-camps-data` only when you intentionally want to delete saved demo users and enrollments.

## CI/CD

`.github/workflows/check-dockerfile.yml` runs on every push and pull request. The `Dockerfile and image build` check fails if the root `Dockerfile` is missing or the Docker image cannot be built. It uses a self-hosted runner with the labels `linux`, `ubuntu`, `docker`, `shell`, and `backend`, and requires access to Docker.

Pushes to `develop` also publish `empire20/s13-training-camps:latest` and a tag containing the full commit SHA. Other branches and pull requests build without publishing. Add a repository Actions secret named `DOCKERHUB_TOKEN` containing a Docker Hub access token for `empire20` with write access to this repository. The token is used only for publishing and is not stored in the source code.

After a successful publish, download the new image with `docker pull empire20/s13-training-camps:latest`. Running containers keep their current image until recreated.

To enforce this before merging, configure branch protection on the default branch to require pull requests and the `Dockerfile and image build` status check. Disable direct pushes and bypasses for the developers covered by the rule. The workflow must run once before the check may appear in the branch protection settings.
