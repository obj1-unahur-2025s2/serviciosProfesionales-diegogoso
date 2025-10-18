/*Etapa 1 - profesionales y empresas

De cada **profesional** se debe poder obtener:
- en qué _universidad_ estudiaron, esto se debe asignar para cada profesional.
- sus _honorarios por hora_ de trabajo, cómo se determina depende del tipo de profesional.
- en qué _provincias_ puede trabajar, cómo se determina depende del tipo de profesional.

De cada **universidad** nos va a interesar: en qué provincia está, y qué honorarios por
 hora de trabajo recomienda para los profesionales.

Deben contemplarse distintos tipos de profesionales, de acuerdo a lo que se indica a continuación.
- **Profesionales vinculados a una universidad**:  
  pueden trabajar solamente en la provincia donde está la universidad, los honorarios son los que
   recomienda la universidad.
- **Profesionales asociados del Litoral**:
  pueden trabajar en Entre Ríos, Santa Fe y Corrientes, cobran 3000 pesos por hora de trabajo.
- **Profesionales libres**:
  se indica para cada uno en qué provincias pueden trabajar y los honorarios por hora, además de
   la universidad.
  
  
Cada **empresa de servicios** contrata a varios profesionales. Para cada una se indica un honorario
 de referencia.

A partir de este modelo, tiene que poder obtenerse para una empresa:
- cuántos (un número) de sus profesionales contratados estudió en una determinada universidad.
- el conjunto formado por sus _profesionales caros_.   
  O sea, aquellos cuyo honorario es mayor al honorario de referencia de la empresa.
- el conjunto de las _universidades formadoras_, o sea, las universidades donde estudiaron sus
 profesionales contratados, sin repetidos.
- el profesional _más barato_ (o sea, que sus honorarios son los más bajos).
- si _es de gente acotada_ (o sea, ningún profesional está habilitado para más de tres provincias,
 o lo que es equivalente, todos trabajan en a lo sumo tres provincias).


### Comentario que puede ayudar para la resolución  
Cada universidad debe acordarse provincia y honorarios recomendados, se le setean y listo.  
Por otro lado, _está mal_ que los profesionales vinculados se acuerden de qué provincias tienen 
habilitadas y cuáles son sus honorarios; le tienen que pedir estos datos a la Universidad.
  
De paso: **OJO** que la Universidad está en _una_ provincia, pero el profesional tiene que devolver
 una _colección_ de provincias. Un profesional vinculado devolverá una colección con un solo elemento.
Tenemos estas universidades:
- de San Martín: está en la provincia de Buenos Aires, los honorarios recomendados son de 3500 pesos.
- de Rosario: está en la provincia de Santa Fe, los honorarios recomendados son de 2800 pesos.
- de Corrientes: está en la provincia de Corrientes, los honorarios recomendados son de 4200 pesos.
- de Hurlingham: está en la provincia de Buenos Aires, los honorarios recomendados son de 8800 pesos.

y estos profesionales
- Juana, vinculada, estudió en la Univ. de Rosario.
- Melina, asociada el Litoral, estudió en la Univ. de Corrientes.
- Rocío, libre, estudió en la Univ. de Hurlingham, honorarios 5000 pesos, puede trabajar
 en Santa Fe, Córdoba y Buenos Aires.
- Luciana, libre, estudió en la Univ. de Rosario, honorarios 3200 pesos, puede trabajar
 en Santa Fe y Entre Ríos.*/
import provincias.*

class Universidad{
  var totalRecaudado = 0
  const provincia 
  const honorariosRecomendados
  method provincias() = provincia
  method honorarios() = honorariosRecomendados 
  method recibirDonacion(unMonto){
     totalRecaudado = totalRecaudado + unMonto
  }
}

class EmpresaServicios {
  const profesionalesContratados = #{}
  const clientes = #{}
  const honorarioReferencia
  var trabajosRealizados = 0 
  
  method contratarProfesional(unProfesional) = profesionalesContratados.add(unProfesional)
  method despedirProfesional(unProfesional) = profesionalesContratados.remove(unProfesional)
  method profesionalesDeUniversidad(unaUniversidad) = profesionalesContratados.filter({p => p.universidad() == unaUniversidad}).size()
  method profesionalesCaros() = profesionalesContratados.filter({p => p.honorarios() > honorarioReferencia})
  method universidadesFormadoras() = profesionalesContratados.map({p => p.universidad()}).asSet()
  method profesionalMasBarato() = profesionalesContratados.min({p => p.honorarios()})
  method esDeGenteAcotada() = profesionalesContratados.count({p => p.provincias().size() <= 3}) < 4

  method puedeSatisfacerA(unSolicitante) {
    return profesionalesContratados.any({p => unSolicitante.puedeSerAtendidoPor(p)})
  }

  method darServicio(unSolicitante) {
    const profesionalesQuePuedenSatisfacer = profesionalesContratados.filter({
      p => unSolicitante.puedeSerAtendidoPor(p)
    }) 

    const profesionalCualquiera = profesionalesQuePuedenSatisfacer.anyOne()

    if(self.puedeSatisfacerA(unSolicitante)) {
      profesionalCualquiera.cobrarImporte(profesionalCualquiera.honorarios())
      clientes.add(unSolicitante)
      trabajosRealizados += 1
    }
  }

  method cantidadDeClientes() = clientes.size()

  method tieneACliente(unCliente) {
    return clientes.contains(unCliente)
  }

  method esPocoAtractivo(unProfesional) =
  unProfesional.provincias().all({provincia =>
    profesionalesContratados.any({otro =>
      otro != unProfesional &&
      otro.provincias().contains(provincia) &&
      otro.honorarios() < unProfesional.honorarios()
    })
  })

  method trabajosRealizados() = trabajosRealizados

  method clientes() = clientes
}

class ProfesionalVinculado{
  const universidad 
  method provincias() = #{universidad.provincias()}
  method honorarios() = universidad.honorarios()
  method universidad() = universidad
  method cobrarImporte(unimporte){
        universidad.recibirDonacion(unimporte *0.5)
        
  }
}
class ProfesionalAsociadoLitoral{
  const honorarios = 3000
  const universidad 
  const provincias = #{santaFe, corrientes, entreRios} 
  method provincias() = provincias
  method honorarios() = honorarios
  method universidad() = universidad
  method cobrarImporte(unimporte){
    asociacionDeProfesionales.recibirDonacion(unimporte)
    
  }
}
class ProfesionalesLibres{
  var totalRecaudado = 0
  const universidad 
  const honorarios 
  const provincias = #{}
  
  method provincias() = provincias
  method honorarios() = honorarios
  method universidad() = universidad
  method agregarProvincia(unaProvincia) = provincias.add(unaProvincia)
  method cobrarImporte(unimporte){ 
    totalRecaudado = totalRecaudado + unimporte
  }
  method pasarDineroA(unProfecionalLibre, unMonto){
    totalRecaudado = totalRecaudado - unMonto
    unProfecionalLibre.cobrarImporte(unMonto)
  }
  method totalRecaudado() = totalRecaudado
}
object asociacionDeProfesionales{
  var totalRecaudado = 0
  method recibirDonacion(unMonto){
    totalRecaudado = totalRecaudado + unMonto
  } 
  method totalRecaudado()= totalRecaudado

  
}