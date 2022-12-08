/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{html,elm,js}',
    "./node_modules/flowbite/**/*.js"
  ],
  theme: {
    fontFamily: {
      optima: ['Optima'],
      pxgrotesk: ['Px Grotesk'],
      pxgrotesklight: ['PxGrotesk-Light'],
    },
    extend: {
      colors: {
        'alto-border': '#d7d2d1',
        'alto-bg': '#f7f3ef',
        'alto-gray-1': '#777777',
        'alto-gray-2': '#dddad6',
        'alto-white': '#ffffff',
        'alto-black': '#000000',
        'alto-brown-1': '#3f3825',
        'alto-gray-3': '#f7f3ef',
        'alto-gray-transparent': '#9d9d9d00',
        'alto-brown-2': '#1e1d1e',
        'alto-brown-3': '#eae6db',
        'alto-brown-4': '#6c685b',
        'alto-brown-5': '#ac826d',
        'alto-gray-3': '#d9d8cb',

        'alto-line': '#EAE6DB',
        'alto-primary': '#3F3825',
        'alto-dark': '#AC826D',
      },
      fontSize: {
        'alto-base': '0.875rem',
				'alto-title': '0.75rem',
				'alto-subtitle': '0.5rem',
      }
    },
  },
  plugins: [
    require('flowbite/plugin')
  ],
  darkMode: 'media'
}
