set -euo pipefail
APP="$HOME/Library/Application Support/Splash-M1"
BASE_VER="1.7.1-m1"   # or whatever your original folder name in $APP is
NEW_VER="1.7.2-m1"

# Clone the existing directory structure (keeps the bundled python/ runtime)
rm -rf "$APP/$NEW_VER"
cp -R "$APP/$BASE_VER/" "$APP/$NEW_VER"

# Copy the newly compiled engine binary and Metal libraries into engine/
cp ./build/splash ./build/splash.metallib ./build/host-step.metallib "$APP/$NEW_VER/engine/"

# Sync updated source folders used by launcher.py (install/, server/)
cp -R ./install ./server "$APP/$NEW_VER/"

# Remove stale Python bytecode caches so updated .py files are always loaded
find "$APP/$NEW_VER" \( -name "__pycache__" -o -name "*.pyc" -o -name "*.pyo" \) -exec rm -rf {} +

# Update release.json to 1.7.2-m1
cat > "$APP/$NEW_VER/release.json" <<'EOF'
{
  "version": "1.7.2-m1"
}
EOF

# Point `current` to 1.7.2-m1
ln -sfn "$NEW_VER" "$APP/current"
