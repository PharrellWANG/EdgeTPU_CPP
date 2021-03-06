add_definitions(-DUSE_EDGETPU)

if(${ARCH_TYPE} STREQUAL armv7)
	message("[BUILD edgetpu] armv7")
	target_link_libraries(${ProjectName} ${CMAKE_CURRENT_LIST_DIR}/../edgetpu/libedgetpu/direct/armv7a/libedgetpu.so.1.0)
	file(COPY ${CMAKE_CURRENT_LIST_DIR}/../edgetpu/libedgetpu/direct/armv7a/libedgetpu.so.1.0 DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
elseif(${ARCH_TYPE} STREQUAL aarch64)
	message("[BUILD edgetpu] aarch64")
	target_link_libraries(${ProjectName} ${CMAKE_CURRENT_LIST_DIR}/../edgetpu/libedgetpu/direct/aarch64/libedgetpu.so.1.0)
	file(COPY ${CMAKE_CURRENT_LIST_DIR}/../edgetpu/libedgetpu/direct/aarch64/libedgetpu.so.1.0 DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
else()
	if(WIN32)
		message("[BUILD edgetpu] windows (x64)")
		target_link_libraries(${ProjectName} ${CMAKE_CURRENT_LIST_DIR}/../edgetpu/libedgetpu/direct/x64_windows/edgetpu.dll.if.lib)
		file(COPY ${CMAKE_CURRENT_LIST_DIR}/../edgetpu/libedgetpu/direct/x64_windows/edgetpu.dll DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
	else()
		message("[BUILD edgetpu] linux (x64)")
		target_link_libraries(${ProjectName} ${CMAKE_CURRENT_LIST_DIR}/../edgetpu/libedgetpu/direct/k8/libedgetpu.so.1.0)
		file(COPY ${CMAKE_CURRENT_LIST_DIR}/../edgetpu/libedgetpu/direct/k8/libedgetpu.so.1.0 DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
	endif()
endif()


target_include_directories(${ProjectName} PUBLIC ${CMAKE_CURRENT_LIST_DIR}/../edgetpu)
target_include_directories(${ProjectName} PUBLIC ${CMAKE_CURRENT_LIST_DIR}/../edgetpu/libedgetpu)
