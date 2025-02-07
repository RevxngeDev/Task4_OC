#!/bin/bash

# Configuración
MAX_HISTORY=10
history=()
guessed=()
step=1
hits=0
misses=0

# Función para imprimir el historial
print_history() {
    echo -n "Numbers: "
    for ((i = 0; i < ${#history[@]}; i++)); do
        if [[ ${guessed[$i]} -eq 1 ]]; then
            echo -ne "\033[0;32m${history[$i]}\033[0m " # Verde para acertados
        else
            echo -ne "\033[0;31m${history[$i]}\033[0m " # Rojo para fallados
        fi
    done
    echo
}

# Bucle principal
while true; do
    # Generar un número aleatorio entre 0 y 9
    random_number=$((RANDOM % 10))

    # Actualizar el historial
    if [[ ${#history[@]} -lt $MAX_HISTORY ]]; then
        history+=($random_number)
        guessed+=(0)
    else
        history=("${history[@]:1}" $random_number)
        guessed=("${guessed[@]:1}" 0)
    fi

    # Mostrar el paso actual
    echo "Step: $step"

    # Solicitar entrada del usuario
    read -p "Please enter a number from 0 to 9 (q - quit): " input

    # Salir si el usuario ingresa 'q'
    if [[ "$input" == "q" ]]; then
        echo "Goodbye!"
        break
    fi

    # Validar la entrada del usuario
    if ! [[ "$input" =~ ^[0-9]$ ]]; then
        echo "Input error!"
        continue
    fi

    # Comparar la entrada del usuario con el número aleatorio
    if [[ $input -eq $random_number ]]; then
        echo "Hit! My number: $random_number"
        hits=$((hits + 1))
        guessed[-1]=1 # Marcar como acertado
    else
        echo "Miss! My number: $random_number"
        misses=$((misses + 1))
    fi

    # Calcular porcentajes de aciertos y fallos
    total=$((hits + misses))
    hit_percentage=$((hits * 100 / total))
    miss_percentage=$((misses * 100 / total))

    # Mostrar estadísticas
    echo "Hit: ${hit_percentage}% Miss: ${miss_percentage}%"

    # Mostrar el historial
    print_history

    # Incrementar el paso
    step=$((step + 1))
done
