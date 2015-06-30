macro(build_hdf5 install_prefix staging_prefix  zlib_include_dir zlib_library zlib_dir)

  if(CMAKE_EXTRA_GENERATOR)
    set(CMAKE_GEN "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
  else()
    set(CMAKE_GEN "${CMAKE_GENERATOR}")
  endif()
  
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT:STRING=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET}
    )
  endif()

set_property(DIRECTORY PROPERTY EP_STEP_TARGETS configure build test)

ExternalProject_Add(HDF5
  URL "https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8.15-patch1/src/hdf5-1.8.15-patch1.tar.bz2"
  URL_MD5 "3c0d7a8c38d1abc7b40fc12c1d5f2bb8"
  SOURCE_DIR HDF5
  BINARY_DIR HDF5-build
  CMAKE_GENERATOR ${CMAKE_GEN}
  CMAKE_ARGS
      -DBUILD_TESTING:BOOL=OFF #${BUILD_TESTING}
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      -DBUILD_SHARED_LIBS:BOOL=${MT_BUILD_SHARED_LIBS}
      -DBUILD_STATIC_EXECS:BOOL=OFF
      -DCMAKE_SKIP_RPATH:BOOL=ON
      -DCMAKE_SKIP_INSTALL_RPATH:BOOL=ON
      -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
      -DHDF5_INSTALL_CMAKE_DIR:PATH=${install_prefix}
      -DHDF5_NO_PACKAGES:BOOL=ON
      -DHDF5_BUILD_CPP_LIB:BOOL=ON
      -DHDF5_BUILD_TOOLS:BOOL=ON
      -DHDF5_ENABLE_Z_LIB_SUPPORT=ON
      ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
      -DCMAKE_CXX_FLAGS:STRING=-fPIC ${CMAKE_CXX_FLAGS}
      -DCMAKE_C_FLAGS:STRING=-fPIC ${CMAKE_C_FLAGS}
      -DCMAKE_EXE_LINKER_FLAGS:STRING=${CMAKE_EXE_LINKER_FLAGS}
      -DCMAKE_MODULE_LINKER_FLAGS:STRING=${CMAKE_MODULE_LINKER_FLAGS}
      -DCMAKE_SHARED_LINKER_FLAGS:STRING=${CMAKE_SHARED_LINKER_FLAGS}
#      -DZLIB_USE_EXTERNAL:BOOL=ON
#      -DZLIB_DIR:PATH=${zlib_library_dir}
      -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
      -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
      -DZLIB_INCLUDE_DIRS:STRING=${zlib_include_dir}
      -DZLIB_LIBRARIES:STRING=${zlib_library}
      -DZLIB_INCLUDE_DIR:STRING=${zlib_include_dir}
      -DZLIB_LIBRARY:STRING=${zlib_library}
#      -DZLIB_DIR:PATH=${zlib_dir}
#      -DH5_ZLIB_HEADER="zlib.h"
  INSTALL_COMMAND $(MAKE) install DESTDIR=${staging_prefix}
  INSTALL_DIR ${staging_prefix}/${install_prefix}
#  TEST_COMMAND make test
)

SET(HDF5_LIB_SUFFIX ".a")

IF(MT_BUILD_SHARED_LIBS)
  IF(APPLE)
    IF(${CMAKE_BUILD_TYPE} STREQUAL Release)
      SET(HDF5_LIB_SUFFIX ".dylib")
    ELSE(${CMAKE_BUILD_TYPE} STREQUAL Release)
      SET(HDF5_LIB_SUFFIX "_debug.dylib")
    ENDIF(${CMAKE_BUILD_TYPE} STREQUAL Release)
  ELSE(APPLE)
    IF(${CMAKE_BUILD_TYPE} STREQUAL Release)
      SET(HDF5_LIB_SUFFIX ".so")
    ELSE(${CMAKE_BUILD_TYPE} STREQUAL Release)
      SET(HDF5_LIB_SUFFIX "_debug.so")
    ENDIF(${CMAKE_BUILD_TYPE} STREQUAL Release)
  ENDIF(APPLE)
ELSE(MT_BUILD_SHARED_LIBS)
  IF(${CMAKE_BUILD_TYPE} STREQUAL Release)
    SET(HDF5_LIB_SUFFIX ".a")
  ELSE(${CMAKE_BUILD_TYPE} STREQUAL Release)
    SET(HDF5_LIB_SUFFIX "_debug.a")
  ENDIF(${CMAKE_BUILD_TYPE} STREQUAL Release)
ENDIF(MT_BUILD_SHARED_LIBS)

SET(HDF5_BIN_DIR     ${staging_prefix}/${install_prefix}/bin )
SET(HDF5_INCLUDE_DIR ${staging_prefix}/${install_prefix}/include )
SET(HDF5_LIBRARY_DIR ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX} )
SET(HDF5_LIBRARY     ${staging_prefix}/${install_prefix}/lib${LIB_SUFFIX}/libhdf5${HDF5_LIB_SUFFIX} )

SET(HDF5_DIR         ${staging_prefix}/${install_prefix}/share/cmake/hdf5)
SET(HDF5_FOUND ON)
endmacro(build_hdf5)
