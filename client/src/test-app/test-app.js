import {html, PolymerElement} from '@polymer/polymer/polymer-element.js';

/**
 * @customElement
 * @polymer
 */
class TestApp extends PolymerElement {
  static get template() {
    return html`
      <style>
        :host {
          display: block;
        }
      </style>
      <h2>Hello [[prop1]]!</h2>
    `;
  }
  static get properties() {
    return {
      prop1: {
        type: String,
        value: 'test-app'
      }
    };
  }

  ready() {
	  let echo = new WebSocket("ws://adebray.ovh:8080")
	  echo.addEventListener('open', () => echo.send("echo"))
	  echo.addEventListener('message', e => console.log(e))
  }
}

window.customElements.define('test-app', TestApp);
