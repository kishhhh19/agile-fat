git checkout -b bad-release
git add Dockerfile
git commit -m "Introduce intentionally broken app version"
git push origin bad-release
