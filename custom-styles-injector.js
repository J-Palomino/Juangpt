// JuanGPT Custom Styles Injector
// This script injects our custom CSS into the UI

document.addEventListener('DOMContentLoaded', function() {
  // Create a link element for our custom CSS
  const customStyles = document.createElement('link');
  customStyles.rel = 'stylesheet';
  customStyles.href = '/custom-styles.css';
  document.head.appendChild(customStyles);
  
  // Add JuanGPT branding element
  const brandingElement = document.createElement('div');
  brandingElement.className = 'juangpt-branding';
  brandingElement.textContent = 'Powered by JuanGPT';
  document.body.appendChild(brandingElement);
  
  console.log('JuanGPT custom styles injected!');
});
