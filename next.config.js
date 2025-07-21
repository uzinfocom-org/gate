const withBundleAnalyzer = require("@next/bundle-analyzer");

/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  reactStrictMode: false,
  swcMinify: true,
  images: {
    unoptimized: true,
    domains: ["lab.basement.studio"],
  },
  // rewrites: async () => [
  //   {
  //     source: "/:path*",
  //     destination: `/:path*`,
  //   }
  // ],
};

module.exports = (_phase, { defaultConfig: _ }) => {
  const plugins = [
    withBundleAnalyzer({ enabled: process.env.ANALYZE === "true" }),
  ];
  return plugins.reduce((acc, plugin) => plugin(acc), { ...nextConfig });
};
