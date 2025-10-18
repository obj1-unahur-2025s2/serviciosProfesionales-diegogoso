class Persona {
    const provincia

    method provincia() = provincia

    method puedeSerAtendidoPor(unProfesional) {
        return unProfesional.provincias().contains(provincia)
    }
}

class Institucion {
    const universidadesReconocidas = #{}

    method universidadesReconocidas() = universidadesReconocidas

    method puedeSerAtendidoPor(unProfesional) {
        return universidadesReconocidas.contains(unProfesional.universidad())
    }
} 

class Club {
    const provincias = #{}

    method provincias() = provincias

    method puedeSerAtendidoPor(unProfesional) {
        return provincias.any({p => unProfesional.provincias().contains(p)})
    }
}