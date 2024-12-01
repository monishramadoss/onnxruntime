
file(GLOB_RECURSE onnxruntime_providers_vk_cc_srcs CMAKE_CONFIGURE_DEPENDS "${onnxruntime_ROOT}/core/providers/vk/*.h" "${onnxruntime_ROOT}/core/providers/vk/*.cc")



if(onnxruntime_USE_MPI)
    target_link_libraries(${target} PRIVATE ${MPI_LIBRARIES} ${MPI_CXX_LINK_FLAGS})
endif()

source_group(TREE ${ONNXRUNTIME_ROOT}/core FILES ${onnxruntime_providers_vk_cc_srcs})
set(onnxruntime_providers_vk_src ${onnxruntime_providers_vk_cc_srcs} )

onnxruntime_add_shared_library_module(onnxruntime_providers_vk ${onnxruntime_providers_vk_src})

add_dependencies(${target} onnxruntime_providers_shared ${onnxruntime_EXTERNAL_DEPENDENCIES})

onnxruntime_add_include_to_target(${target} onnxruntime_common onnxruntime_framework onnx onnx_proto ${PROTOBUF_LIB} flatbuffers::flatbuffers)
if (onnxruntime_ENABLE_TRAINING_OPS)
  onnxruntime_add_include_to_target(${target} onnxruntime_training)
  if (onnxruntime_ENABLE_TRAINING)
    target_link_libraries(${target} PRIVATE onnxruntime_training)
  endif()
  if (onnxruntime_ENABLE_TRAINING_TORCH_INTEROP OR onnxruntime_ENABLE_TRITON)
    onnxruntime_add_include_to_target(${target} Python::Module)
  endif()
endif()


# Cannot use glob because the file cuda_provider_options.h should not be exposed out.
# set(ONNXRUNTIME_vk_PROVIDER_PUBLIC_HEADERS
#       "${REPO_ROOT}/include/onnxruntime/core/providers/vk/cuda_context.h"
#       "${REPO_ROOT}/include/onnxruntime/core/providers/cuda/cuda_resource.h"
#     )

if (NOT onnxruntime_BUILD_SHARED_LIB)
  install(TARGETS onnxruntime_providers
          ARCHIVE   DESTINATION ${CMAKE_INSTALL_LIBDIR}
          LIBRARY   DESTINATION ${CMAKE_INSTALL_LIBDIR}
          RUNTIME   DESTINATION ${CMAKE_INSTALL_BINDIR}
          FRAMEWORK DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
