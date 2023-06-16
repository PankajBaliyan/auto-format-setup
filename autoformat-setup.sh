# #!/bin/bash

# to run Script, run both 👇 command in terminal
# chmod +x autoformat-setup.sh
# ./autoformat-setup.sh

# Install dependencies
# npm init -y
npm install --save-dev eslint eslint-config-prettier eslint-plugin-prettier prettier husky lint-staged eslint-plugin-json eslint-plugin-markdown eslint-plugin-react stylelint stylelint-config-standard pretty-quick
echo "Packages installation ✅"

# Create ESLint configuration file
echo '{
  "root": true,
  "env": {
    "browser": true,
    "node": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:json/recommended",
    "prettier",
    "plugin:markdown/recommended"
  ],
  "plugins": ["markdown", "json", "prettier"],
  "parserOptions": {
    "ecmaVersion": 2021,
    "sourceType": "module",
    "ecmaFeatures": {
      "jsx": true
    }
  },
  "settings": {
    "react": {
      "version": "detect"
    }
  },
  "rules": {
    "prettier/prettier": "error"
    // Additional rules or overrides if needed
  }
}' > .eslintrc.json
echo "ESLint configuration ✅"

# Create Prettier configuration file
echo '{
  "printWidth": 80,
  "tabWidth": 2,
  "singleQuote": true,
  "trailingComma": "all"
}' > .prettierrc.json
echo "Prettier configuration ✅"

# Create .gitignore file
echo '# gitignore - data
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# production
/build

# misc
.DS_Store
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

package-lock.json

yarn-error.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*' > .gitignore
echo "gitignore added ✅"

# Create Stylelint configuration file
echo '{
  "extends": "stylelint-config-standard"
}' > .stylelintrc.json
echo "Stylelint configuration ✅"

# Configure Husky pre-commit hook
npx husky install

echo '#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npx lint-staged' > .husky/pre-commit
echo "Husky pre-commit hook configuration ✅"

# Read the existing package.json file
file="package.json"
contents=$(cat "$file")

# Define the new code to add
new_code='  "format": "prettier --write \"**/*.html\" && prettier --write \"**/*.js\" && prettier --write \"**/*.css\" && prettier --write \"**/*.jsx\" && prettier --write \"**/*.json\" && prettier --write \"**/*.md\"",
  "pre-format": "npm run format",
  "precommit": "lint-staged"'

# Find the position of the "scripts" section
scripts_start=$(echo "$contents" | grep -n '"scripts": {' | cut -d: -f1)
scripts_end=$(echo "$contents" | awk 'NR > '$scripts_start' && /^  },/ { print NR; exit }')

# Get the indentation of the "scripts" section
indentation=$(echo "$contents" | sed -n "${scripts_start}s/^\([[:space:]]*\).*/\1/p")

# Find the last line before the "scripts" section
# last_line=$(echo "$contents" | sed -n "$((scripts_start - 1))p")

# Append a comma ',' to the last line before the "scripts" section
updated_last_line=$(echo "${last_line},")

# Remove the trailing "},"
part1=$(echo "$contents" | sed -n "1,${scripts_end}p" | sed '$d')

# Split the contents into two parts
part2=$(echo "$new_code" | sed "s/^/${indentation}/")
part3=$(echo "$contents" | sed -n "$((scripts_end + 1)),\$p")

# Construct the updated contents with correct indentation
updated_contents="${part1}${updated_last_line}
${part2}
${indentation}},
${part3}"

# Overwrite the package.json file with the updated contents
echo "$updated_contents" > "$file"

echo "Code added inside "script" in package.json! ✅"

#!/bin/bash

# Read the existing package.json file
file="package.json"
contents=$(cat "$file")

# Define the new code to add
new_code='
    "husky": {
      "hooks": {
        "pre-commit": "npm run precommit"
      }
    },
    "lint-staged": {
      "*.{html,css,js,jsx,json,md}": [
        "prettier --write"
      ]
'

# Find the position of the "scripts" section
scripts_start=$(echo "$contents" | grep -n '"scripts": {' | cut -d: -f1)
scripts_end=$(echo "$contents" | awk 'NR > '$scripts_start' && /^  },/ { print NR; exit }')

# Split the contents into two parts
part1=$(echo "$contents" | head -n "$scripts_end")
part2=$(echo "$new_code" | sed 's/^  //')
part3=$(echo "$contents" | tail -n +"$scripts_end")

# Construct the updated contents with correct indentation
updated_contents="${part1}${part2}
${part3}"

# Overwrite the package.json file with the updated contents
echo "$updated_contents" > "$file"

echo "Code added after "script" to package.json! ✅"

echo "✅ AUTOSETUP COMPLETED SUCCESSFULLY! ✅"