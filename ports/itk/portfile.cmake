include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO InsightSoftwareConsortium/ITK
    REF d92873e33e8a54e933e445b92151191f02feab42
    SHA512 0e3ebd27571543e1c497377dd9576a9bb0711129be12131109fe9b3c8413655ad14ce4d9ac6e281bac83c57e6032b614bc9ff53ed357d831544ca52f41513b62
    HEAD_REF master
)

# remove old source dir so RENAME doesn't fail
file(REMOVE_RECURSE ${CURRENT_BUILDTREES_DIR}/ITK)
# directory path length needs to be shorter than 50 characters
file(RENAME ${SOURCE_PATH} ${CURRENT_BUILDTREES_DIR}/ITK)
set(SOURCE_PATH "${CURRENT_BUILDTREES_DIR}/ITK")

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_TESTING=OFF
        -DBUILD_EXAMPLES=OFF
        -DDO_NOT_INSTALL_ITK_TEST_DRIVER=ON
        -DITK_INSTALL_DATA_DIR=share/itk/data
        -DITK_INSTALL_DOC_DIR=share/itk/doc
        -DITK_INSTALL_PACKAGE_DIR=share/itk
        -DBUILD_SHARED_LIBS=ON
        -DITKV3_COMPATIBILITY=ON
        -DITK_BUILD_DEFAULT_MODULES=ON
        -DCMAKE_POSITION_INDEPENDENT_CODE=ON
        -DCMAKE_DEBUG_POSTFIX:string=d
        ${ADDITIONAL_OPTIONS}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

vcpkg_fixup_cmake_targets() # combines release and debug build configurations

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/itk)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/itk/LICENSE ${CURRENT_PACKAGES_DIR}/share/itk/copyright)
