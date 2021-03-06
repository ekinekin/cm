IF(${MPI} STREQUAL mpich2)
  SET(MPIFC mpif90)
  SET(MPICC mpicc)
ELSE(${MPI} STREQUAL mpich2)
  SET(MPIFC mpiifort)
  SET(MPICC mpiicc)
ENDIF(${MPI} STREQUAL mpich2)
SET(FC gfortran) #TODO
SET(CC gcc) #TODO
SET(AR ar)
SET(EXE_LINK ${FC})
SET(DSO_LINK ld)
SET(DBGCF_FLGS -g)
string(STRIP "${CFL_FLGS} ${CFE_FLGS} ${CF_FLGS} ${C_FLGS}" CMAKE_C_FLAGS)
string(STRIP "${CFL_FLGS} ${CFE_FLGS} ${CF_FLGS} ${F_FLGS}" CMAKE_Fortran_FLAGS)
INCLUDE_DIRECTORIES(${C_INCLUDE_DIRS})
INCLUDE_DIRECTORIES(${F_INCLUDE_DIRS})
string(STRIP "${CFL_FLGS} ${L_FLGS} ${CFE_FLGS}" ELFLAGS)
string(STRIP "${CFL_FLGS} ${L_FLGS} ${D_FLGS}" DLFLAGS)

#------------------------------------------------------------------
#---------------TODO line 181 - 223--------------------------------
#------------------------------------------------------------------

MESSAGE(STATUS "${OPERATING_SYSTEM} ${FC} ${CC} ${COMPILER}")

IF(${OPERATING_SYSTEM} STREQUAL linux)
  SET(CMAKE_Fortran_FLAGS_Release)
  SET(CMAKE_C_FLAGS_Release)
  
  SET(CMAKE_C_COMPILER gcc)
  SET(CMAKE_FORTRAN_COMPILER gfortran)
  
  IF(${COMPILER} STREQUAL intel)
    IF(COMMAND "icc -V 2>&1 | grep -i intel")
      SET(CMAKE_C_COMPILER icc)
    ENDIF(COMMAND "icc -V 2>&1 | grep -i intel")
    IF(COMMAND "ifort -V 2>&1 | grep -i intel")
      SET(CMAKE_FORTRAN_COMPILER ifort)
    ENDIF(COMMAND "ifort -V 2>&1 | grep -i intel")
  ENDIF(${COMPILER} STREQUAL intel)
  
  IF(${CC} STREQUAL gcc)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pipe -m${ABI}")
    SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fPIC")
    IF(${MACHNAME} STREQUAL x86_64)
      IF(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
        SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -march=nocona")
      ENDIF(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
    ENDIF(${MACHNAME} STREQUAL x86_64)
    SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -fbounds-check")
    SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 -funroll-all-loops")
    IF(${PROF} STREQUAL false)
      IF(${INSTRUCTION} STREQUAL i686 OR ${INSTRUCTION} STREQUAL x86_64)
        SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -momit-leaf-frame-pointer")   
      ENDIF(${INSTRUCTION} STREQUAL i686 OR ${INSTRUCTION} STREQUAL x86_64)
    ELSE(${PROF} STREQUAL false)
      SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -pg")
    ENDIF(${PROF} STREQUAL false)
  ENDIF(${CC} STREQUAL gcc)
  
  
  IF(${CC} STREQUAL icc)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -wall -m${ABI}")
    IF(${MACHNAME} STREQUAL x86_64)
      IF(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
        IF(COMMAND "grep Duo /proc/cpuinfo 2>/dev/null")
          IF(COMMAND "grep Core(TM)2 /proc/cpuinfo 2>/dev/null")
            SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -xT")
          ELSE(COMMAND "grep Core(TM)2 /proc/cpuinfo 2>/dev/null")
            SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -x0")
          ENDIF(COMMAND "grep Core(TM)2 /proc/cpuinfo 2>/dev/null")
        ELSE(COMMAND "grep Duo /proc/cpuinfo 2>/dev/null")
          SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -xP")
        ENDIF(COMMAND "grep Duo /proc/cpuinfo 2>/dev/null")
      ELSE(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
        SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -xW")
      ENDIF(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
    ENDIF(${MACHNAME} STREQUAL x86_64)
    IF(${MACHINE} MATCHES i%86)
      IF(COMMAND "grep sse2 /proc/cpuinfo 2>/dev/null")
        SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -xN")
      ENDIF(COMMAND "grep sse2 /proc/cpuinfo 2>/dev/null")
    ENDIF(${MACHINE} MATCHES i%86)
    SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")
    SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3 -ansi_alias")
    IF(not(${PROF} STREQUAL false))
      SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -pg")
      SET(ELFLAGS "ELFLAGS -pg")
    ENDIF(not (${PROF} STREQUAL false))
    IF(${MPIPROF} STREQUAL true)
      IF(${MPI} STREQUAL mpich2)
        SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wl,--export-dynamic")
        SET(CMAKE_C_FLAGS_DEBUG "CMAKE_C_FLAGS_DEBUG -Wl,--export-dynamic")
      ENDIF(${MPI} STREQUAL mpich2)
    ENDIF(${MPIPROF} STREQUAL false)
  ENDIF(${CC} STREQUAL icc)
  
  IF(${CC} MATCHES xlc%)
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -qinfo=gen:ini:por:pro:trd:tru:use") #TODO line303
    SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -q${ABI} -qarch=auto -qhalt=e")
    SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -qfullpath -C -qflttrap=inv:en -qinitauto=7F")
    SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")
    SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Dunix")
  ENDIF(${CC} MATCHES xlc%)
  
  IF(${CC} STREQUAL cc)
    SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0 -g")
    SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")
    IF(${PROF} STREQUAL true)
      SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -pg")   
    ENDIF(${PROF} STREQUAL true)
  ENDIF(${CC} STREQUAL cc)
  
  IF(${FC} STREQUAL gfortran)
    SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -pipe -m${ABI} -fno-second-underscore -Wall -x f95-cpp-input")
    SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -ffree-line-length-132")
    SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fmax-identifier-length=63")
    SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -fPIC")
    IF(${MACHNAME} STREQUAL x86_64)
      IF(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
        SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -march=nocona")
      ENDIF(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
    ENDIF(${MACHNAME} STREQUAL x86_64)
    SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -fbounds-check")
    SET(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3 -Wuninitialized -funroll-all-loops")
    IF(${PROF} STREQUAL false)
      IF((${INSTRUCTION} STREQUAL i686) OR (${INSTRUCTION} STREQUAL x86_64))
        SET(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -momit-leaf-frame-pointer")   
      ENDIF((${INSTRUCTION} STREQUAL i686) OR (${INSTRUCTION} STREQUAL x86_64))
    ELSE(${PROF} STREQUAL false)
      SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -pg")
      SET(ELFLAGS "ELFLAGS -pg")
    ENDIF(${PROF} STREQUAL false)
  ENDIF(${FC} STREQUAL gfortran)
  
  IF(${FC} STREQUAL g95)
    SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-second-underscore -Wall -m${ABI} -std=f2003")
    SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -fPIC")
    SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -fbound-check")
    SET(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3 -Wuninitialized -funroll-all-loops")
    SET(ELFLAGS "ELFLAGS -m${ABI}")
  ENDIF(${FC} STREQUAL g95)
  
  IF(${FC} STREQUAL ifort)
    SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -cpp -warn all -m${ABI}")
    IF(${MACHNAME} STREQUAL x86_64)
      IF(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
        IF(COMMAND "grep Duo /proc/cpuinfo 2>/dev/null")
          IF(COMMAND "grep Core(TM)2 /proc/cpuinfo 2>/dev/null")
            SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -xT")
          ELSE(COMMAND "grep Core(TM)2 /proc/cpuinfo 2>/dev/null")
            SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -x0")
          ENDIF(COMMAND "grep Core(TM)2 /proc/cpuinfo 2>/dev/null")
        ELSE(COMMAND "grep Duo /proc/cpuinfo 2>/dev/null")
          SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -xP")
        ENDIF(COMMAND "grep Duo /proc/cpuinfo 2>/dev/null")
      ELSE(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
        SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -xW")
      ENDIF(COMMAND "grep Intel /proc/cpuinfo 2>/dev/null")
    ENDIF(${MACHNAME} STREQUAL x86_64)
    IF(${MACHINE} MATCHES i%86)
      IF(COMMAND "grep sse2 /proc/cpuinfo 2>/dev/null")
        SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -xN")
      ENDIF(COMMAND "grep sse2 /proc/cpuinfo 2>/dev/null")
    ENDIF(${MACHINE} MATCHES i%86)  
    SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -check all -traceback -debug all")
    SET(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3")
    IF(not(${PROF} STREQUAL false))
      SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -pg")   
      SET(ELFLAGS "${ELFLAGS} -pg")
      SET(ELFLAGS "ELFLAGS -pg")
    ENDIF(not(${PROF} STREQUAL false))
    IF(${MPIPROF} STREQUAL true)
      IF(${MPI} STREQUAL mpich2)
        SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Wl,--export-dynamic")
        SET(CMAKE_Fortran_FLAGS_DEBUG "CMAKE_Fortran_FLAGS_DEBUG -Wl,--export-dynamic")
      ELSE(${MPI} STREQUAL mpich2)
        SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -tcollect")
      ENDIF(${MPI} STREQUAL mpich2)
    ENDIF(${MPIPROF} STREQUAL false)
    SET(ELFLAGS "${ELFLAGS} -nofor_main -m${ABI} -traceback")
  ENDIF(${FC} STREQUAL ifort)
  
  IF(${FC} MATCHES xlf%)
    SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qarch=auto -qhalt=e -qextname -qsuffix=cpp=f90") 
    SET(EFLAGS "${EFLAGS} -q${ABI}")
    IF(${ABI} STREQUAL 64)
      SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qwarn64")
    ENDIF(${ABI} STREQUAL 64)
    IF(${DEBUG} STREQUAL false)
      SET(MP_FLGS "-qsmp=omp")
    ELSE(${DEBUG} STREQUAL false)
      SET(MP_FLGS "-qsmp=omp:noopt")
    ENDIF(${DEBUG} STREQUAL false)
    SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -qfullpath -C -qflttrap=inv:en -qextchk -qinitauto=7FF7FFFF")
    SET(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3")
  ENDIF(${FC} MATCHES xlf%)
  
  IF(${FC} STREQUAL ftn)
    SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -O0 -g") 
    SET(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3")
    IF(${PROF} STREQUAL true)
      SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -pg")   
      SET(ELFLAGS "${ELFLAGS} -pg")
    ENDIF(${PROF} STREQUAL true)
  ENDIF(${FC} STREQUAL ftn)
   
  SET(ELFLAGS "${ELFLAGS} -static-libgcc")
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBSD_TIMERS")
ENDIF(${OPERATING_SYSTEM} STREQUAL linux)

IF(${OPERATING_SYSTEM} STREQUAL win32)
  # TODO generate visual files

ENDIF(${OPERATING_SYSTEM} STREQUAL win32)

IF(${OPERATING_SYSTEM} STREQUAL aix)
  IF(${MP} MATCHES false)
    SET(${FC} mpxlf95)
    SET(${CC} xlc)
  ELSE(${MP} MATCHES false)
    SET(${FC} mpxlf95_r)
    SET(${CC} xlc_r)
  ENDIF(${MP} MATCHES false)
  SET(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -qsuffix=cpp=f90 -qnoextname")
  SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -qinfo=gen:ini:por:pro:trd:tru:use") # TODO line 455
  SET(ELFLAGS "${ELFLAGS} -q${ABI}")
  SET(CFE_FLGS "${CFE_FLGS} -q${ABI} -qarch=auto -qhalt=e")
  SET(L_FLGS "${L_FLGS} -b${ABI}")
  SET(D_FLGS "-G -bexpall -bnoentry")
  IF(${ABI} STREQUAL 32)
    SET(ELFLAGS "${ELFLAGS} -bmaxdata:0x80000000/dsa")
  ELSE(${ABI} STREQUAL 32)
    SET(CF_FLGS "${CF_FLGS} -qwarn64")
    SET(ELFLAGS "${ELFLAGS} -bmaxdata:0x0000100000000000")
  ENDIF(${ABI} STREQUAL 32)
  IF(${DEBUG} STREQUAL false)
    SET(MP_FLGS "-qsmp=omp")
  ELSE(${DEBUG} STREQUAL false)
    SET(MP_FLGS "-qsmp=omp:noopt")
  ENDIF(${DEBUG} STREQUAL false)
  SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -qfullpath -C -qflttrap=inv:en -qextchk")
  SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -qfullpath -C -qflttrap=inv:en -qextchk")
  SET(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} -qinitauto=7FF7FFFF")
  SET(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -qinitauto=7F")
  SET(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} -O3")
  SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")
  SET(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -qnoignerrno")
  
  SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBSD_TIMERS")
  
  
ENDIF(${OPERATING_SYSTEM} STREQUAL aix)