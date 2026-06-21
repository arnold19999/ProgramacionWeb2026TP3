const publications = [
  {
    id: 1,
    title: "Fotografía para eventos",
    type: "servicio",
    featured: true,
    location: "Villarrica, Guairá",
    description: "Cobertura profesional para celebraciones, retratos y contenido comercial.",
    price: "Desde G. 450.000",
    rating: "4.9",
    image: "assets/img/fotografia.jpg"
  },
  {
    id: 2,
    title: "Jabones artesanales",
    type: "producto",
    featured: true,
    location: "Coronel Oviedo, Caaguazú",
    description: "Productos elaborados de forma artesanal, ideales para regalos y cuidado personal.",
    price: "Desde G. 25.000",
    rating: "4.8",
    image: "assets/img/artesania.jpg"
  },
  {
    id: 3,
    title: "Cría y producción avícola",
    type: "servicio",
    featured: false,
    location: "Caazapá, Caazapá",
    description: "Asesoramiento local para producción, cuidado y manejo responsable de aves.",
    price: "Consultar",
    rating: "4.7",
    image: "assets/img/avicultura.jpg"
  },
  {
    id: 4,
    title: "Diseño y desarrollo web",
    type: "servicio",
    featured: true,
    location: "Asunción, Capital",
    description: "Sitios rápidos, adaptables y pensados para potenciar negocios paraguayos.",
    price: "Desde G. 900.000",
    rating: "5.0",
    image: "assets/img/tecnologia.svg"
  },
  {
    id: 5,
    title: "Identidad visual para emprendedores",
    type: "servicio",
    featured: false,
    location: "Luque, Central",
    description: "Logo, paleta y piezas digitales para dar una imagen coherente a tu marca.",
    price: "Desde G. 350.000",
    rating: "4.9",
    image: "assets/img/diseno.svg"
  },
  {
    id: 6,
    title: "Kit de regalo artesanal",
    type: "producto",
    featured: false,
    location: "Encarnación, Itapúa",
    description: "Selección de productos locales preparada para obsequios y fechas especiales.",
    price: "G. 85.000",
    rating: "4.6",
    image: "assets/img/regalo.svg"
  }
];

const galleryGrid = document.querySelector("#galleryGrid");
const emptyMessage = document.querySelector("#emptyMessage");
const filterButtons = [...document.querySelectorAll(".filter-btn")];
let activeFilter = "todos";
let searchTerm = "";

function normalize(value) {
  return value.toLowerCase().normalize("NFD").replace(/[\u0300-\u036f]/g, "");
}

function filteredPublications() {
  return publications.filter((item) => {
    const matchesFilter =
      activeFilter === "todos" ||
      item.type === activeFilter ||
      (activeFilter === "destacado" && item.featured);
    const haystack = normalize(`${item.title} ${item.description} ${item.location} ${item.type}`);
    return matchesFilter && haystack.includes(normalize(searchTerm));
  });
}

function renderGallery() {
  const results = filteredPublications();
  galleryGrid.innerHTML = results.map((item) => `
    <article class="gallery-card reveal visible">
      <div class="gallery-image-wrap">
        <img src="${item.image}" alt="${item.title}" loading="lazy">
        <span class="gallery-badge">${item.featured ? "Destacado · " : ""}${item.type}</span>
        <button class="favorite-btn" type="button" data-favorite="${item.id}" aria-label="Guardar ${item.title}" title="Guardar en favoritos">♡</button>
      </div>
      <div class="gallery-body">
        <span class="gallery-location">⌖ ${item.location}</span>
        <h3>${item.title}</h3>
        <p>${item.description}</p>
        <div class="gallery-footer">
          <strong>${item.price}</strong>
          <span>★ ${item.rating}</span>
        </div>
      </div>
    </article>
  `).join("");
  emptyMessage.hidden = results.length > 0;
}

filterButtons.forEach((button) => {
  button.addEventListener("click", () => {
    activeFilter = button.dataset.filter;
    filterButtons.forEach((item) => item.classList.toggle("active", item === button));
    renderGallery();
  });
});

galleryGrid.addEventListener("click", (event) => {
  const button = event.target.closest("[data-favorite]");
  if (!button) return;
  button.classList.toggle("active");
  button.textContent = button.classList.contains("active") ? "♥" : "♡";
  button.setAttribute("aria-pressed", String(button.classList.contains("active")));
});

const heroSearch = document.querySelector("#heroSearch");
const searchInput = document.querySelector("#searchInput");

heroSearch.addEventListener("submit", (event) => {
  event.preventDefault();
  searchTerm = searchInput.value.trim();
  document.querySelector("#explorar").scrollIntoView({ behavior: "smooth" });
  renderGallery();
});

document.querySelectorAll("[data-quick]").forEach((button) => {
  button.addEventListener("click", () => {
    searchInput.value = button.dataset.quick;
    searchTerm = button.dataset.quick;
    renderGallery();
    document.querySelector("#explorar").scrollIntoView({ behavior: "smooth" });
  });
});

const menuToggle = document.querySelector("#menuToggle");
const navLinks = document.querySelector("#navLinks");
menuToggle.addEventListener("click", () => {
  const isOpen = navLinks.classList.toggle("open");
  menuToggle.classList.toggle("active", isOpen);
  menuToggle.setAttribute("aria-expanded", String(isOpen));
  document.body.classList.toggle("menu-open", isOpen);
});
navLinks.addEventListener("click", (event) => {
  if (!event.target.closest("a")) return;
  navLinks.classList.remove("open");
  menuToggle.classList.remove("active");
  menuToggle.setAttribute("aria-expanded", "false");
  document.body.classList.remove("menu-open");
});

const siteHeader = document.querySelector(".site-header");
window.addEventListener("scroll", () => siteHeader.classList.toggle("scrolled", window.scrollY > 25), { passive: true });

const revealObserver = new IntersectionObserver((entries) => {
  entries.forEach((entry) => {
    if (entry.isIntersecting) {
      entry.target.classList.add("visible");
      revealObserver.unobserve(entry.target);
    }
  });
}, { threshold: 0.12 });
document.querySelectorAll(".reveal").forEach((element) => revealObserver.observe(element));

const statsSection = document.querySelector(".stats-strip");
const counterObserver = new IntersectionObserver(([entry]) => {
  if (!entry.isIntersecting) return;
  document.querySelectorAll("[data-counter]").forEach((counter) => {
    const target = Number(counter.dataset.counter);
    const duration = 1000;
    const start = performance.now();
    const animate = (now) => {
      const progress = Math.min((now - start) / duration, 1);
      counter.textContent = `${Math.floor(target * progress)}${target >= 24 ? "+" : ""}`;
      if (progress < 1) requestAnimationFrame(animate);
    };
    requestAnimationFrame(animate);
  });
  counterObserver.disconnect();
}, { threshold: .4 });
counterObserver.observe(statsSection);

const contactForm = document.querySelector("#contactForm");
const message = document.querySelector("#message");
const characterCount = document.querySelector("#characterCount");
message.addEventListener("input", () => {
  if (message.value.length > 300) message.value = message.value.slice(0, 300);
  characterCount.textContent = message.value.length;
});

function setError(field, messageText) {
  const input = document.querySelector(`#${field}`);
  const error = document.querySelector(`#${field}Error`);
  if (input) input.classList.toggle("invalid", Boolean(messageText));
  error.textContent = messageText;
}

contactForm.addEventListener("submit", (event) => {
  event.preventDefault();
  const values = Object.fromEntries(new FormData(contactForm));
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  setError("name", values.name?.trim().length >= 3 ? "" : "Ingresá tu nombre completo.");
  setError("email", emailPattern.test(values.email || "") ? "" : "Ingresá un correo electrónico válido.");
  setError("interest", values.interest ? "" : "Seleccioná una opción.");
  setError("message", values.message?.trim().length >= 15 ? "" : "Escribí un mensaje de al menos 15 caracteres.");
  setError("privacy", values.privacy ? "" : "Debés aceptar el uso de datos para continuar.");

  const hasErrors = contactForm.querySelectorAll(".field-error:not(:empty)").length > 0;
  const success = document.querySelector("#formSuccess");
  success.hidden = hasErrors;
  if (!hasErrors) {
    contactForm.reset();
    characterCount.textContent = "0";
    success.scrollIntoView({ behavior: "smooth", block: "nearest" });
  }
});

renderGallery();
