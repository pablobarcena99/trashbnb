import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  updateNavbar() {
    if (window.scrollY >= window.innerHeight) {
      this.element.classList.add("navbar-lewagon-transparent")
    } else {
      this.element.classList.remove("navbar-lewagon-transparent")
    }
  };
}
