Used as an alternative to https://github.com/runtime-env/import-meta-env

Just a simple shell script implementation that should do the same thing with less parameters

### Example

This will create a .env file from your .env.example.

.env.example

```
BE_URL=""
APP_NAME="Scrumdiddlyumptious"
```

`ENV_SRC=env.example ENV_TGT=.env ./transform-bundle-env.sh injectExample`

-> .env

```
BE_URL="REPLACE_BE_URL"
APP_NAME="REPLACE_APP_NAME"
```

Now you can run your build (vite build, tsx, etc...) and containerize it

In prod, you can run:

`BUNDLE_DIR=build ENV_SRC=env.example ./transform-bundle-env.sh injectBundle`

Finally, you ran serve your bundle via `node /build/index-abc.js` through expressjs or host it some other way

### Environment Variables

ENV_SRC is your environment source of truth for what's going to be replaced in the bundle. It can be an env.example or any file in env format

ENV_TGT is your environment variable target. If you're using .env, it'll just be .env. Sometimes .env.production or similar is used

BUNDLE_DIR is the directory where your bundled is stored. This assumes you have a single js file in this directory. Currently does not support multiple bundle files but it would simply be another loop in the script that sed runs through.

### Usage requirements

Linux, Bash, sed

### Options

injecteExample - this takes a source of truth .env.example file and generates a .env file based on the keys in .env.example. The values for each key will be prefixed by "REPLACE\_". These prefixed values will be used by `injectBundle` to search the bundle for those values and replace them

injectBundle - replaces the example environment variables in your bundle with the true environment variables.
