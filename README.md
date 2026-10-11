# Nexus-Tokenizer-Convertisseur-de-Tokens-IA-et-Calculateur-de-Co-ts
DESCIPTION
<div align="center">

# Nexus Tokenizer

### Convertisseur de tokens IA et estimateur de coûts

<img src="https://readme-typing-svg.demolab.com?font=Fira+Code&size=18&pause=1000&color=36BCF7&center=true&vCenter=true&width=600&lines=Tokens+%E2%86%94+octets;Estimation+des+co%C3%BBts+IA;Mode+interactif+en+Bash" alt="Texte animé : tokens, coûts IA et mode interactif">

<br>

![Bash](https://img.shields.io/badge/Bash-4%2B-4EAA25?logo=gnubash&logoColor=white)
![Python](https://img.shields.io/badge/Python-3%2B-3776AB?logo=python&logoColor=white)
![Statut](https://img.shields.io/badge/statut-exp%C3%A9rimental-orange)

</div>

---

## Présentation

Nexus Tokenizer est un script Bash expérimental pour convertir approximativement
des tokens en octets et estimer leur coût à partir des tarifs configurés dans le script.

- Conversion approximative tokens ↔ octets
- Estimation du coût pour plusieurs modèles
- Comparaison indicative entre tarifs d’entrée et de cache
- Mode interactif pour saisir un nombre de tokens

## Démonstration

Ajoute un GIF de démonstration dans `assets/demo.gif` pour l’afficher ici :

![Démonstration de Nexus Tokenizer](assets/demo.gif)

<details>
<summary>▶️ Voir les commandes pour lancer le script</summary>

```bash
chmod +x nexus-token-converter.sh
./nexus-token-converter.sh
```

Tu peux aussi le lancer directement avec Bash :

```bash
bash nexus-token-converter.sh
```

</details>

## Prérequis

- Bash 4 ou plus récent
- Python 3

<details>
<summary>🖥️ Vérifier les prérequis</summary>

```bash
bash --version
python3 --version
```

</details>

## Mode interactif

Au lancement, saisis un nombre entier de tokens pour afficher une estimation
des octets et des coûts calculés avec les tarifs présents dans le script.

Appuie sur **Entrée** sans saisir de valeur, ou tape `q`, pour quitter.

## Personnaliser les tarifs

Les tarifs sont définis directement dans le script, dans la section consacrée
aux modèles. Modifie-les pour tes propres estimations.

La formule utilisée est :

```text
Coût estimé = (nombre de tokens / 1 000 000) × tarif par million de tokens
```

<details>
<summary>⚠️ À propos des estimations</summary>

- La règle « 1 token ≈ 4 octets » est une approximation, pas une conversion exacte.
- Les tarifs doivent être vérifiés et actualisés manuellement.
- Le coût réel peut dépendre du modèle, du type de requête et des conditions
  de facturation.
- La « valeur réelle » fixe d’un token affichée dans le script n’est pas une
  valeur monétaire universelle.

Les résultats sont indicatifs et ne représentent pas des tarifs officiels.

</details>

## Structure du projet

```text
.
├── nexus-token-converter.sh
├── README.md
└── assets/
    └── demo.gif
```

## Licence

Ajoute ici la licence de ton choix.
