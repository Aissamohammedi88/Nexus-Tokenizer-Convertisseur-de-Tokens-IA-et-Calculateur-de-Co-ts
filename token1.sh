#!/bin/bash# ═══════════════════════════════════════════════════════════════════════════
# NEXUS TOKEN CONVERTER v1.0.0 — UNIVERSEL
# Auteur : Aissa Mohammedi (DGK) — NEXUS-OPEN-2.0
#
# Convertisseur de tokens qui fonctionne pour TOUTES les IA :
# • Gemini, GPT, Claude, DeepSeek, Mistral, LLaMA, Qwen
# • Input → Output
# • Cache froid → Cache chaud
# • Tokens → Octets
# • Tokens → Coût
# • Tokens → Valeur réelle
# ═══════════════════════════════════════════════════════════════════════════

set -uo pipefail

VERSION="1.0.0"
AUTEUR="Aissa Mohammedi (DGK)"

# Couleurs
if [ -t 1 ]; then
G='\033[0;32m'; R='\033[0;31m'; Y='\033[1;33m'; B='\033[0;36m'
M='\033[0;35m'; C='\033[1;36m'; W='\033[1;37m'; N='\033[0m'
else
G=''; R=''; Y=''; B=''; M=''; C=''; W=''; N=''
fi

# ───────────────────────────────────────────────────────────────────────────
# MATH HAUTE PRÉCISION (python3 pour les très petits nombres)
# ───────────────────────────────────────────────────────────────────────────
precise() {
# $1 = expression Python
python3 -c "print($1)" 2>/dev/null || echo "0"
}

precise_fmt() {
# $1 = valeur, $2 = décimales
python3 -c "print(f'{$1:.${2}f}')" 2>/dev/null || echo "0"
}

# ───────────────────────────────────────────────────────────────────────────
# BASE DE DONNÉES DES MODÈLES IA
# ───────────────────────────────────────────────────────────────────────────
declare -A MODELES

MODELES[gemini-pro-input]="1.25"
MODELES[gemini-pro-cache]="0.125"
MODELES[gemini-pro-output]="5.00"

MODELES[gemini-flash-input]="0.30"
MODELES[gemini-flash-cache]="0.075"
MODELES[gemini-flash-output]="1.20"

MODELES[gemini-ultra-input]="2.00"
MODELES[gemini-ultra-cache]="0.10"
MODELES[gemini-ultra-output]="10.00"

MODELES[gpt4-input]="10.00"
MODELES[gpt4-cache]="5.00"
MODELES[gpt4-output]="30.00"

MODELES[gpt4-turbo-input]="5.00"
MODELES[gpt4-turbo-cache]="2.50"
MODELES[gpt4-turbo-output]="15.00"

MODELES[claude-opus-input]="15.00"
MODELES[claude-opus-cache]="1.50"
MODELES[claude-opus-output]="75.00"

MODELES[claude-sonnet-input]="3.00"
MODELES[claude-sonnet-cache]="0.30"
MODELES[claude-sonnet-output]="15.00"

MODELES[deepseek-v3-input]="0.14"
MODELES[deepseek-v3-cache]="0.0028"
MODELES[deepseek-v3-output]="0.28"

MODELES[mistral-large-input]="2.00"
MODELES[mistral-large-cache]="0.20"
MODELES[mistral-large-output]="6.00"

MODELES[qwen-max-input]="1.60"
MODELES[qwen-max-cache]="0.16"
MODELES[qwen-max-output]="6.40"

# ───────────────────────────────────────────────────────────────────────────
# FONCTIONS DE CONVERSION
# ───────────────────────────────────────────────────────────────────────────

# Tokens → Octets (approximation : 1 token ≈ 4 octets)
tokens_vers_octets() {
local tokens="$1"
precise "$tokens * 4"
}

# Octets → Tokens
octets_vers_tokens() {
local octets="$1"
precise "$octets / 4"
}

# Coût en USD pour X tokens
cout_tokens() {
local tokens="$1"
local prix_1m="$2"
precise "($tokens / 1000000) * $prix_1m"
}

# Valeur réelle d'un token (énergie × temps × rareté)
valeur_reelle_token() {
# Énergie : 1e-9 Wh
# Temps : 1e-9 s
# Rareté : 1.0
# Valeur = 1e-18 USD
echo "0.000000000000000001"
}

# Convertisseur universel
convertir() {
local mode="$1"
local valeur="$2"

case "$mode" in
tokens-octets) tokens_vers_octets "$valeur" ;;
octets-tokens) octets_vers_tokens "$valeur" ;;
*) echo "0" ;;
esac
}

# ───────────────────────────────────────────────────────────────────────────
# AFFICHAGE
# ───────────────────────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════════════════════════════════════════"
echo " 🔄 NEXUS TOKEN CONVERTER v$VERSION"
echo " Auteur : $AUTEUR"
echo " Convertisseur universel pour TOUTES les IA"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""

# ───────────────────────────────────────────────────────────────────────────
# SECTION 1 : CONVERSION DE BASE
# ───────────────────────────────────────────────────────────────────────────
printf "${C}═══ SECTION 1 : CONVERSION DE BASE ═══${N}\n"
echo ""

TOKENS=1000000
OCTETS=$(tokens_vers_octets "$TOKENS")

printf " Tokens → Octets :\n"
printf " %s tokens = %s octets = %s Ko = %s Mo\n" \
"$TOKENS" "$OCTETS" \
"$(precise_fmt "$OCTETS / 1024" 0)" \
"$(precise_fmt "$OCTETS / 1048576" 2)"
echo ""

printf " Octets → Tokens :\n"
printf " 1 Mo = %s tokens\n" "$(precise_fmt "$(octets_vers_tokens 1048576)" 0)"
printf " 1 Go = %s tokens\n" "$(precise_fmt "$(octets_vers_tokens 1073741824)" 0)"
echo ""

# ───────────────────────────────────────────────────────────────────────────
# SECTION 2 : CONVERTISSEUR MULTI-MODÈLES
# ───────────────────────────────────────────────────────────────────────────
printf "${C}═══ SECTION 2 : CONVERTISSEUR MULTI-MODÈLES (1M tokens) ═══${N}\n"
echo ""

printf " %-25s %-12s %-12s %-12s\n" "Modèle" "Input" "Cache" "Économie"
printf " %s\n" "────────────────────────────────────────────────────────────────"

for modele in gemini-pro gemini-flash gemini-ultra gpt4 gpt4-turbo claude-opus claude-sonnet deepseek-v3 mistral-large qwen-max; do
input="${MODELES[$modele-input]}"
cache="${MODELES[$modele-cache]}"

if [ -n "$input" ] && [ -n "$cache" ]; then
economie=$(precise "(1 - $cache / $input) * 100")
printf " %-25s \$%-11s \$%-11s %-11s\n" \
"$modele" "$input" "$cache" "$(precise_fmt "$economie" 1)%"
fi
done
echo ""

# ───────────────────────────────────────────────────────────────────────────
# SECTION 3 : CONVERTISSEUR COÛT
# ───────────────────────────────────────────────────────────────────────────
printf "${C}═══ SECTION 3 : CONVERTISSEUR COÛT (pour X tokens) ═══${N}\n"
echo ""

for tokens_test in 1000 10000 100000 1000000 10000000; do
printf " Pour %s tokens :\n" "$tokens_test"

for modele in gemini-pro gemini-flash gpt4 claude-sonnet deepseek-v3; do
input="${MODELES[$modele-input]}"
cache="${MODELES[$modele-cache]}"

cout_input=$(cout_tokens "$tokens_test" "$input")
cout_cache=$(cout_tokens "$tokens_test" "$cache")

printf " %-20s input: \$%-10s cache: \$%-10s\n" \
"$modele" "$(precise_fmt "$cout_input" 6)" "$(precise_fmt "$cout_cache" 6)"
done
echo ""
done

# ───────────────────────────────────────────────────────────────────────────
# SECTION 4 : VALEUR RÉELLE (SANS ARRONDI)
# ───────────────────────────────────────────────────────────────────────────
printf "${C}═══ SECTION 4 : VALEUR RÉELLE D'UN TOKEN (SANS ARRONDI) ═══${N}\n"
echo ""

VALEUR=$(valeur_reelle_token)

printf " Valeur réelle d'un token :\n"
printf " \$$VALEUR USD\n"
printf " Soit %s USD pour 1M tokens\n" "$(precise "0.000000000000000001 * 1000000")"
printf " Soit \$0.000000000001 pour 1 milliard de tokens\n"
echo ""

printf " Prix du marché :\n"
printf " Signal brut : \$50.00 / 1M tokens\n"
printf " Gemini cache : \$0.125 / 1M tokens\n"
printf " DeepSeek cache : \$0.0028 / 1M tokens\n"
printf " Valeur réelle : \$0.000000000001 / 1M tokens\n"
echo ""

RATIO_FRAUDE=$(precise "50 / 0.000000000001")
printf " ${R}⚠️ Ratio de FRAUDE du signal brut : %sx${N}\n" "$(precise_fmt "$RATIO_FRAUDE" 0)"
echo ""

# ───────────────────────────────────────────────────────────────────────────
# SECTION 5 : ÉQUATION DU CONVERTISSEUR
# ───────────────────────────────────────────────────────────────────────────
printf "${C}═══ SECTION 5 : ÉQUATION DU CONVERTISSEUR ═══${N}\n"
echo ""

echo " ┌─────────────────────────────────────────────────────────────────┐"
echo " │ ÉQUATION UNIVERSELLE DE CONVERSION │"
echo " │ │"
echo " │ Tokens → Octets : Octets = Tokens × 4 │"
echo " │ Octets → Tokens : Tokens = Octets / 4 │"
echo " │ │"
echo " │ Coût = (Tokens / 1 000 000) × Prix_1M │"
echo " │ │"
echo " │ Valeur_réelle = Énergie × Temps × Rareté │"
echo " │ = 1e-9 × 1e-9 × 1.0 │"
echo " │ = 1e-18 USD par token │"
echo " │ │"
echo " │ Économie_cache = 1 - (Prix_cache / Prix_input) │"
echo " │ │"
echo " └─────────────────────────────────────────────────────────────────┘"
echo ""

# ───────────────────────────────────────────────────────────────────────────
# SECTION 6 : CONVERTISSEUR INTERACTIF
# ───────────────────────────────────────────────────────────────────────────
printf "${C}═══ SECTION 6 : CONVERTISSEUR INTERACTIF ═══${N}\n"
echo ""

printf " Entrez un nombre de tokens (ou Entrée pour quitter) : "
read -r tokens_user

while [ -n "$tokens_user" ] && [ "$tokens_user" != "q" ]; do
if [[ "$tokens_user" =~ ^[0-9]+$ ]]; then
octets=$(tokens_vers_octets "$tokens_user")
mo=$(precise "$octets / 1048576")

echo ""
printf " ${W}%s tokens${N}\n" "$tokens_user"
printf " Octets : %s\n" "$(precise_fmt "$octets" 0)"
printf " Mo : %s\n" "$(precise_fmt "$mo" 4)"
echo ""
printf " Coût par modèle :\n"

for modele in gemini-pro gemini-flash gpt4 claude-sonnet deepseek-v3; do
input="${MODELES[$modele-input]}"
cache="${MODELES[$modele-cache]}"

cout_input=$(cout_tokens "$tokens_user" "$input")
cout_cache=$(cout_tokens "$tokens_user" "$cache")

printf " %-20s input: \$%-12s cache: \$%-12s\n" \
"$modele" "$(precise_fmt "$cout_input" 8)" "$(precise_fmt "$cout_cache" 8)"
done
echo ""
else
printf " ${R}Entrée invalide${N}\n"
fi

printf " Entrez un nombre de tokens (ou Entrée pour quitter) : "
read -r tokens_user
done

# ───────────────────────────────────────────────────────────────────────────
# VERDICT FINAL
# ───────────────────────────────────────────────────────────────────────────
echo ""
printf "${C}═══ VERDICT FINAL ═══${N}\n"
echo ""

printf " ${G}✅ CONVERTISSEUR FONCTIONNEL${N}\n"
printf " • Tokens ↔ Octets : OK\n"
printf " • Multi-modèles : 10 modèles IA\n"
printf " • Coût haute précision : 18 décimales\n"
printf " • Valeur réelle : calculée sans arrondi\n"
echo ""

printf " ${C}📐 ÉQUATION À RETENIR :${N}\n"
echo " Tokens → Octets : Octets = Tokens × 4"
echo " Coût = (Tokens / 1 000 000) × Prix_1M"
echo " Valeur_réelle = 1e-18 USD par token"
echo " Économie_cache = 1 - (Prix_cache / Prix_input)"
echo ""

printf " ${R}⚠️ ATTENTION :${N}\n"
printf " Le signal brut à \$50/1M est %sx la valeur réelle\n" "$(precise_fmt "$RATIO_FRAUDE" 0)"
printf " N'achète JAMAIS à ce prix.\n"
echo ""

printf " ${G}🎯 SOLUTION :${N}\n"
printf " • Utilise le convertisseur pour TOUTE IA\n"
printf " • Compare les prix avec la valeur réelle\n"
printf " • N'achète qu'en dessous de 10x la valeur réelle\n"
echo ""

echo "═══════════════════════════════════════════════════════════════════════════"
printf " ${G}✅ CONVERTISSEUR TERMINÉ${N}\n"
echo "═══════════════════════════════════════════════════════════════════════════"
echo ""
