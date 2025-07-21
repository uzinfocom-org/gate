module.exports = {
  root: true,
  rules: {
    "react/display-name": 0,
    "react-hooks/exhaustive-deps": 0,
    "@typescript-eslint/no-unused-vars": 0,
  },
  // This tells ESLint to load the config from the package `eslint-config-custom`
  extends: ["custom"],
};
