# Codaxia Agent Team — Landing

Page de vente statique pour la commercialisation de **Codaxia Agent Team** en accès anticipé.

## Structure

- `index.html` — page de vente principale (FR-CA)
- `success.html` — page de confirmation post-paiement (`noindex`)
- `privacy.html` — politique de confidentialité
- `terms.html` — conditions de l'accès anticipé
- `styles.css` — design system + responsive
- `robots.txt` — instructions crawlers
- `sitemap.xml` — sitemap
- `assets/favicon.svg` — icône (3 barres style kanban)
- `assets/og-codaxia-agent-team.svg` — image de partage social (Open Graph)

## Placeholders à remplacer avant publication

| Placeholder | Où | Quoi mettre |
|---|---|---|
| `REPLACE_WITH_PAYMENT_LINK` | `index.html` (4 occurrences) | Lien Stripe Payment Link |
| `REPLACE_WITH_YOUTUBE_VIDEO_ID` | `index.html` (section #demo) | ID YouTube de la démo (ex. `dQw4w9WgXcQ`) |
| `agents.codaxia.com` | `index.html`, `robots.txt`, `sitemap.xml` | Domaine final si différent |
| `8 / 25 places` | `index.html` (section pricing) | Compteur manuel d'accès anticipé |
| `XL` (avatar) | `index.html` (section founder) | Initiales ou remplacer par `<img>` avec photo |

## Image Open Graph

L'image OG est en SVG. **Avant la mise en ligne**, la convertir en PNG `1200×630` (les principales plateformes — LinkedIn, Twitter, Slack — n'affichent pas les SVG en preview social).

Conversion possible avec ImageMagick :

```bash
magick -density 300 assets/og-codaxia-agent-team.svg -resize 1200x630 assets/og-codaxia-agent-team.png
```

Puis mettre à jour le `og:image` dans `index.html` pour pointer vers le `.png`.

## Analytics

Pas d'analytics intégrée. Recommandation : **Cloudflare Web Analytics** (gratuit, sans cookie, sans bandeau de consentement requis). Ajouter le snippet juste avant `</body>` dans toutes les pages.

## Capture courriel

Le formulaire `#book` utilise actuellement `mailto:`. Pour automatiser, brancher un service comme :

- Buttondown
- ConvertKit
- Mailchimp
- ou un Cloudflare Worker simple qui pousse vers ClickUp / Notion

## Déploiement

Site 100 % statique, aucun build. Compatible avec :

- **Cloudflare Pages** (recommandé — CDN + SSL + analytics gratuits)
- Netlify
- Vercel
- GitHub Pages
- NGINX statique

Configuration Cloudflare Pages :

- **Framework preset** : None
- **Build command** : (vide)
- **Build output directory** : `/`

## Conformité avant publication

- [ ] Remplacer tous les `REPLACE_WITH_*`
- [ ] Convertir `og-codaxia-agent-team.svg` → `.png`
- [ ] Brancher Stripe Payment Link
- [ ] Ajouter ID YouTube
- [ ] Confirmer le domaine final
- [ ] Tester PageSpeed mobile + desktop
- [ ] Tester preview Open Graph (LinkedIn, Twitter, Slack)
- [ ] Tester `success.html`, refund flow, capture courriel
- [ ] Brancher analytics (Cloudflare Web Analytics)
- [ ] Supprimer l'ancien `assets/og-dashboard-agents.svg` (orphelin)
