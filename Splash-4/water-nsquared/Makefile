# RISC-V 交叉编译配置
RISCV_PREFIX ?= riscv64-linux-gnu-
CC := $(RISCV_PREFIX)gcc
CFLAGS := -O2 -pthread -D_XOPEN_SOURCE=500 -D_POSIX_C_SOURCE=200112 -std=c11 -g -fno-strict-aliasing -static
LDFLAGS := -lm -static

# 添加 RISC-V 特定的编译选项
CFLAGS += -march=rv64gc -mabi=lp64d

# 检查 RISC-V 工具链是否可用
check_riscv:
	@if ! command -v $(RISCV_PREFIX)gcc > /dev/null; then \
		echo "错误：RISC-V 工具链未找到。请安装："; \
		echo "sudo apt install gcc-riscv64-linux-gnu"; \
		exit 1; \
	fi
	@echo "✓ RISC-V 工具链检查通过"

# 默认目标：先检查工具链，再编译
all: check_riscv
	$(MAKE) $(TARGET)

# 清理目标
clean:
	rm -rf *.c *.h *.o $(TARGET)*

# 显示编译信息
info:
	@echo "编译器: $(CC)"
	@echo "编译选项: $(CFLAGS)"
	@echo "链接选项: $(LDFLAGS)"
	@echo "目标文件: $(TARGET)"

TARGET = WATER-NSQUARED
OBJS = bndry.o cnstnt.o cshift.o initia.o interf.o intraf.o kineti.o mdmain.o poteng.o predcor.o syscons.o water.o

include ../../Makefile.config

# 覆盖 Makefile.config 中的编译器设置
CC := $(RISCV_PREFIX)gcc
CFLAGS := -O2 -pthread -D_XOPEN_SOURCE=500 -D_POSIX_C_SOURCE=200112 -std=c11 -g -fno-strict-aliasing -static -march=rv64gc -mabi=lp64d
LDFLAGS := -lm -static

bndry.o: bndry.c.in split.h mdvar.h parameters.h mddata.h global.h
cnstnt.o: cnstnt.c.in water.h wwpot.h cnst.h frcnst.h fileio.h parameters.h global.h
cshift.o: cshift.c.in water.h global.h
initia.o: initia.c.in split.h mdvar.h water.h cnst.h fileio.h parameters.h mddata.h global.h
interf.o: interf.c.in mdvar.h water.h wwpot.h cnst.h global.h split.h parameters.h mddata.h
intraf.o: intraf.c.in frcnst.h mdvar.h water.h wwpot.h parameters.h mddata.h global.h split.h
kineti.o: kineti.c.in global.h split.h mdvar.h parameters.h mddata.h
mdmain.o: mdmain.c.in  parameters.h mdvar.h water.h wwpot.h cnst.h mddata.h fileio.h frcnst.h randno.h global.h split.h
poteng.o: poteng.c.in global.h split.h mdvar.h frcnst.h water.h wwpot.h parameters.h mddata.h
predcor.o: predcor.c.in split.h mdvar.h parameters.h mddata.h global.h
syscons.o: syscons.c.in parameters.h mdvar.h water.h wwpot.h cnst.h mddata.h global.h
water.o: water.c.in parameters.h mdvar.h water.h wwpot.h cnst.h mddata.h fileio.h frcnst.h randno.h global.h split.h
