# Install repositories
git clone https://github.com/sifive/hifive-premier-p550-tools/
git clone https://github.com/sifive/meta-sifive
git clone https://github.com/eswincomputing/Esbd-77serial-nsign

# Checkout to the correct branches
cd meta-sifive; git checkout rel/meta-sifive/hifive-premier-p550

# Go back to parent folder
cd ..

# U-boot
git clone https://github.com/eswincomputing/u-boot
cd u-boot; git checkout u-boot-2024.01-EIC7X

# Apply patches
git apply ../meta-sifive/recipes-bsp/u-boot/files/riscv64/0001-board-sifive-spl-Initialized-the-PWM-setting-in-the-.patch
git apply ../meta-sifive/recipes-bsp/u-boot/files/riscv64/0002-board-sifive-Set-LED-s-color-to-purple-in-the-U-boot.patch
git apply ../meta-sifive/recipes-bsp/u-boot/files/riscv64/0003-board-sifive-Set-LED-s-color-to-blue-before-jumping-.patch
git apply ../meta-sifive/recipes-bsp/u-boot/files/riscv64/0004-board-sifive-spl-Set-remote-thermal-of-TMP451-to-85-.patch
git apply ../meta-sifive/recipes-bsp/u-boot/files/riscv64/0005-riscv-dts-Add-few-PMU-events.patch
git apply ../meta-sifive/recipes-bsp/u-boot/files/riscv64/0006-riscv-sifive-fu740-reduce-DDR-speed-from-1866MT-s-to.patch

# Build
make CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv hifive_premier_p550_defconfig
make CROSS_COMPILE=riscv64-linux-gnu- RCH=riscv -j$(nproc)

# Go back to root folder
cd ..

# OpenSBI
git clone https://github.com/riscv-software-src/opensbi

# Go to version 1.4
cd opensbi; git checkout a2b255b88918715173942f2c5e1f97ac9e90c877

# Apply patches
git apply ../meta-sifive/recipes-bsp/opensbi/opensbi-sifive-hf-prem/0001-platform-Add-ESWIN-EIC770x-platform.patch
git apply ../meta-sifive/recipes-bsp/opensbi/opensbi-sifive-hf-prem/0002-EIC770X-Added-changes-to-write-Fractional-register.patch
git apply ../meta-sifive/recipes-bsp/opensbi/opensbi-sifive-hf-prem/0003-platform-eswin-Add-eic770X-UART-driver.patch
git apply ../meta-sifive/recipes-bsp/opensbi/opensbi-sifive-hf-prem/0004-platform-eswin-Add-shutdown-and-reset-function.patch
git apply ../meta-sifive/recipes-bsp/opensbi/opensbi-sifive-hf-prem/0005-lib-sbi-Configure-CSR-registers.patch # This
git apply ../meta-sifive/recipes-bsp/opensbi/opensbi-sifive-hf-prem/0006-lib-sbi-eic770x-Add-PMP-for-TOR-region.patch # This
git apply ../meta-sifive/recipes-bsp/opensbi/opensbi-sifive-hf-prem/0007-sbi-init-Modify-CSR-values.patch # This
git apply ../meta-sifive/recipes-bsp/opensbi/opensbi-sifive-hf-prem/0008-lib-sbi-Add-new-PMP-region.patch

# Compile opensbi
PLATFORM=eswin/eic770x FW_PAYLOAD_PATH=../u-boot/u-boot.bin FW_FDT_PATH=../u-boot/u-boot.dtb make CROSS_COMPILE=riscv64-unknown-linux-gnu- ARCH=riscv PLATFORM_RISCV_ISA=rv64imafdc_zicsr_zifencei

# Go to parent folder
cd ..

# Build nsign tool
cd Esbd-77serial-nsign; ./build.sh

# Go back to root folder
cd ..

# Now copy the files
cp Esbd-77serial-nsign/nsign .
cp meta-sifive/recipes-bsp/bootchain/files/nsign.cfg .
cp hifive-premier-p550-tools/ddr-fw/ddr_fw.bin .
cp hifive-premier-p550-tools/second_boot_fw/second_boot_fw.bin .
cp opensbi/build/platform/eswin/eic770x/firmware/fw_payload.bin .

# We can build the image now
./nsign nsign.cfg