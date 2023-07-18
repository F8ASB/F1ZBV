#!/bin/sh

echo "---------------------------"
echo "  BULLETIN D'INFORMATION "
echo "      DU RELAIS F1ZBV"
echo "---------------------------"
echo "           "

#Test si cinnexion Internet est active
echo "INTERNET:"
if : >/dev/tcp/8.8.8.8/53; then
echo 'Connexion Internet active'
else
echo '!*!  Connexion Internet inactive'
fi

echo "          "

# Lire la valeur du gpio24 si 0 présent si 1 non présent
echo "PRESENCE SECTEUR:"

value=$(cat /sys/class/gpio/gpio24/value)

# Tester la valeur et afficher le message correspondant
if [ "$value" -eq 0 ]; then
echo "230V présent"
elif [ "$value" -eq 1 ]; then
echo "!*! coupure secteur"
else
echo "Valeur invalide"
fi
echo "  "

# Lescteur des temperature sur les capteurs 1wire
# Initialiser un tableau vide pour stocker les températures
temps=()

# Parcourir les fichiers correspondant au motif
for file in /sys/bus/w1/devices/*/w1_slave; do
# Extraire la valeur de la température avec grep et cut
r=$(cat $file | grep t= | cut -f2 -d=)
# Convertir la valeur en degrés Celsius avec bc
r=$(echo "scale=1; $r / 1000.0" | bc)
# Ajouter la valeur au tableau
temps+=($r)
done

# Affecter les valeurs du tableau à des variables
temp1=${temps[0]}
temp2=${temps[1]}
temp3=${temps[2]}

echo "LES TEMPERATURES:"
echo "T° TX: "$temp1"°C"
echo "T° Logique: "$temp2"°C"
# echo "T° l: "$temp3
echo "    "
# lecture de la tension d'alimentation convertisseur MCP3204
# Lancement du script TCL dedié

echo "TENSION ALIMENTATION:"
result=$(tclsh tension.tcl)
echo $result
echo " "
echo "-o-o-o-o-o-o-o-o-o-o-o-o-"
exit 0
