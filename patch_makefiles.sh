#!/bin/bash

# 批量修改 Makefile 以支持 RISC-V 交叉编译

set -e

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}开始批量修改 Makefile 以支持 RISC-V 交叉编译...${NC}"

# 需要修改的程序列表
programs=(
    "Splash-4/radix"
    "Splash-4/ocean-non_contiguous_partitions"
    "Splash-4/lu-non_contiguous_blocks"
    "Splash-4/water-nsquared"
    "Splash-4/volrend-no_print_lock"
)

# 为每个程序修改 Makefile
for program_dir in "${programs[@]}"; do
    if [ -d "$program_dir" ]; then
        echo -e "${YELLOW}修改 $program_dir/Makefile...${NC}"
        
        # 备份原始 Makefile
        cp "$program_dir/Makefile" "$program_dir/Makefile.backup"
        
        # 创建新的 Makefile 内容
        cat > "$program_dir/Makefile" << 'EOF'
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

EOF
        
        # 添加程序特定的配置
        case "$program_dir" in
            "Splash-4/radix")
                echo "TARGET = RADIX" >> "$program_dir/Makefile"
                echo "OBJS = radix.o" >> "$program_dir/Makefile"
                ;;
            "Splash-4/ocean-non_contiguous_partitions")
                echo "TARGET = OCEAN-NOCONT" >> "$program_dir/Makefile"
                echo "OBJS = jacobcalc.o laplacalc.o main.o multi.o slave1.o slave2.o" >> "$program_dir/Makefile"
                echo "" >> "$program_dir/Makefile"
                echo "decs.h: decs.h.in" >> "$program_dir/Makefile"
                echo "jacobcalc.c: decs.h" >> "$program_dir/Makefile"
                echo "main.c: decs.h" >> "$program_dir/Makefile"
                echo "slave1.c: decs.h" >> "$program_dir/Makefile"
                echo "laplacalc.c: decs.h" >> "$program_dir/Makefile"
                echo "multi.c : decs.h" >> "$program_dir/Makefile"
                echo "slave2.c: decs.h" >> "$program_dir/Makefile"
                ;;
            "Splash-4/lu-non_contiguous_blocks")
                echo "TARGET = LU-NOCONT" >> "$program_dir/Makefile"
                echo "OBJS = lu.o" >> "$program_dir/Makefile"
                ;;
            "Splash-4/water-nsquared")
                echo "TARGET = WATER-NSQUARED" >> "$program_dir/Makefile"
                echo "OBJS = water-nsquared.o" >> "$program_dir/Makefile"
                ;;
            "Splash-4/volrend-no_print_lock")
                echo "TARGET = VOLREND-NPL" >> "$program_dir/Makefile"
                echo "OBJS = adaptive.o file.o main.o map.o normal.o object.o octree.o opacity.o option.o raytrace.o render.o view.o" >> "$program_dir/Makefile"
                ;;
        esac
        
        # 添加通用的编译规则
        cat >> "$program_dir/Makefile" << 'EOF'

include ../../Makefile.config

# 覆盖 Makefile.config 中的编译器设置
CC := $(RISCV_PREFIX)gcc
CFLAGS := -O2 -pthread -D_XOPEN_SOURCE=500 -D_POSIX_C_SOURCE=200112 -std=c11 -g -fno-strict-aliasing -static -march=rv64gc -mabi=lp64d
LDFLAGS := -lm -static
EOF
        
        echo -e "${GREEN}✓ $program_dir/Makefile 修改完成${NC}"
    else
        echo -e "${YELLOW}警告：目录 $program_dir 不存在${NC}"
    fi
done

echo -e "${GREEN}所有 Makefile 修改完成！${NC}"
echo -e "${YELLOW}现在可以运行 ./compile_riscv.sh 来编译所有程序${NC}" 