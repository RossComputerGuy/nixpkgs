# shellcheck shell=bash

function boltFixupPhase {
  if [ -d "$prefix/bin" ]; then
    for e in $(find "$prefix/bin" -executable -type f); do
      if $(file "$e" | cut -f2 -d ':' | grep -q ELF); then
        llvm-bolt "$e" -o $(dirname "$e")/.bolt-$(basename "$e") "${boltFlags[@]-}"
        mv $(dirname "$e")/.bolt-$(basename "$e") "$e"
      fi
    done
  fi
}

if [ -z "${dontUseBolt-}" ]; then
    appendToVar preFixupPhases boltFixupPhase
fi
