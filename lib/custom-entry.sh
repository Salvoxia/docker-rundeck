# Custom entry point for rundeck docker image

# Run pre-start hooks (if any)
HOOKS_DIR=/opt/rundeck-prestart-hooks

if ls $HOOKS_DIR/* 1> /dev/null 2>&1; then
  echo "=> Pre-start hook folder found, running hooks..."
  for script in $(ls $HOOKS_DIR | grep .sh | sort -n); do
    echo "==> Running script $script"
    eval $($HOOKS_DIR/$script)
  done
fi

# Copy custom plugins
PLUGINS_DIR=/opt/rundeck-plugins
if ls $PLUGINS_DIR/* 1> /dev/null 2>&1; then
   echo "=> Installing plugins from $PLUGINS_DIR"
   cp -Rf $PLUGINS_DIR/* /home/rundeck/libext
   chown -R rundeck:root /home/rundeck/libext
   echo "=> Custom plugins installed!"
fi

# call parent's entrypoint
echo "Launching parent image's entry"
if [[ -z $CUSTOM_RUNDECK_JVM_ARGS ]]; then
    exec docker-lib/entry.sh
else
    exec docker-lib/entry.sh $CUSTOM_RUNDECK_JVM_ARGS
fi

