
package require spi

proc conversion {canal R1 R2} {
          set spi [spi #auto /dev/spidev0.0]
 
          $spi read_mode 0
          $spi write_mode 0
          $spi write_bits_word 8
          $spi read_bits_word 8
          $spi write_maxspeed 500000
          $spi read_maxspeed 500000
 
          # commande binaire pour le convertisseur: bit de start, bit "Single Ended", canal 0
          set adcCommand [expr 0b11000000 + $canal * 0x08]
 
          # Conversion texte -> binaire 
          set transmitString [binary format c $adcCommand] 
 
          # Ajout de 3 caractères 0 (pour envoyer 4 en tout), réception de 4 caractères
          set receiveString [$spi transfer "$transmitString\x00\x00\x00" 50]
 
          # affichage de la réception en binaire
          binary scan $receiveString B* affBin
 
          # Conversion binaire vers entier
          binary scan $receiveString I convert
 
          # extraction de la valeur 
          set receivedValue [expr ($convert & 0b00000001111111111110000000000000) / 0x2000] 
 
          $spi delete
 
          set voltage [expr $receivedValue * (3.3/4096) * ($R1 + $R2)/$R2]
          return [string range $voltage 0 3]
 }

set alim1 [conversion 2 10 1.5]
set cor  0
set alim [expr ($alim1 + $cor)]
set alim [format %.1f $alim]

puts "Tension Alim: $alim V"


