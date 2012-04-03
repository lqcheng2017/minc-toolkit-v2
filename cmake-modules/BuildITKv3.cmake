macro(build_itkv3 install_prefix)
#      ${LOCAL_CMAKE_BUILD_OPTIONS}
  if(CMAKE_EXTRA_GENERATOR)
    set(CMAKE_GEN "${CMAKE_EXTRA_GENERATOR} - ${CMAKE_GENERATOR}")
  else()
    set(CMAKE_GEN "${CMAKE_GENERATOR}")
  endif()
  
  set(CMAKE_OSX_EXTERNAL_PROJECT_ARGS)
  if(APPLE)
    list(APPEND CMAKE_OSX_EXTERNAL_PROJECT_ARGS
      -DCMAKE_OSX_ARCHITECTURES=${CMAKE_OSX_ARCHITECTURES}
      -DCMAKE_OSX_SYSROOT=${CMAKE_OSX_SYSROOT}
      -DCMAKE_OSX_DEPLOYMENT_TARGET=${CMAKE_OSX_DEPLOYMENT_TARGET})
  endif()

  ExternalProject_Add(ITKv3
    URL "http://downloads.sourceforge.net/project/itk/itk/3.20/InsightToolkit-3.20.1.tar.gz"
    URL_MD5 "90342ffa78bd88ae48b3f62866fbf050"
    UPDATE_COMMAND ""
    SOURCE_DIR ITKv3
    BINARY_DIR ITKv3-build
    CMAKE_GENERATOR ${CMAKE_GEN}
    CMAKE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DBUILD_SHARED_LIBS:BOOL=${MT_BUILD_SHARED_LIBS}
        -DCMAKE_INSTALL_PREFIX:PATH=${install_prefix}
        -DCMAKE_CXX_COMPILER:FILEPATH=${CMAKE_CXX_COMPILER}
        -DCMAKE_CXX_FLAGS:STRING=${DCMAKE_CXX_FLAGS}
        -DCMAKE_C_COMPILER:FILEPATH=${CMAKE_C_COMPILER}
        -DCMAKE_C_FLAGS:STRING=${DCMAKE_C_FLAGS}
        ${CMAKE_OSX_EXTERNAL_PROJECT_ARGS}
        -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
        -DBUILD_EXAMPLES:BOOL=OFF
        -DBUILD_TESTING:BOOL=OFF
        -DITK_USE_REVIEW:BOOL=ON
        -DITK_USE_REVIEW_STATISTICS:BOOL=ON
        -DITK_USE_OPTIMIZED_REGISTRATION_METHODS:BOOL=ON
        #-DITK_USE_PORTABLE_ROUND:BOOL=ON # Unused
        -DITK_USE_CENTERED_PIXEL_COORDINATES_CONSISTENTLY:BOOL=ON
        -DITK_USE_TRANSFORM_IO_FACTORIES:BOOL=ON
        -DITK_LEGACY_REMOVE:BOOL=ON
        -DKWSYS_USE_MD5:BOOL=ON # Required by SlicerExecutionModel
    INSTALL_COMMAND make install DESTDIR=${CMAKE_CURRENT_BINARY_DIR}/external
    INSTALL_DIR ${CMAKE_CURRENT_BINARY_DIR}/external/${install_prefix}
  )
  #FORCE_BUILD_CHECK(ITKv3)
  SET(ITK_DIR ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build)
  SET(ITK_USE_FILE  ${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/UseITK.cmake)
  SET(ITK_FOUND ON)
  
  SET(ITK_INCLUDE_DIRS "${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Algorithms;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/BasicFilters;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Common;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Numerics;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/IO;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Numerics/FEM;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Numerics/NeuralNetworks;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/SpatialObject;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/MetaIO;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/NrrdIO;${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/NrrdIO;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/DICOMParser;${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/DICOMParser;${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/expat;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/expat;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/nifti/niftilib;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/nifti/znzlib;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/itkExtHdrs;${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/vxl/v3p/netlib;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/vxl/vcl;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/vxl/core;${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/vxl/v3p/netlib;${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/vxl/vcl;${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/vxl/core;${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/Utilities/gdcm;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Utilities/gdcm/src;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Review;${CMAKE_CURRENT_BINARY_DIR}/ITKv3/Code/Review/Statistics")

# The ITK library directories.
  SET(ITK_LIBRARY_DIRS "${CMAKE_CURRENT_BINARY_DIR}/ITKv3-build/bin")

  SET(ITK_LIBRARIES ITKAlgorithms ITKStatistics ITKFEM ITKQuadEdgeMesh)

endmacro(build_itkv3)
