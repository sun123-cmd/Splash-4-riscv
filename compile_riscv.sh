#!/bin/bash

# RISC-V 交叉编译脚本
# 用于编译 Splash-4 程序为 RISC-V 版本

# set -e  # 遇到错误时退出 - 注释掉，让脚本继续运行

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 检查 RISC-V 工具链
check_toolchain() {
    echo -e "${YELLOW}检查 RISC-V 工具链...${NC}"
    if ! command -v riscv64-linux-gnu-gcc > /dev/null; then
        echo -e "${RED}错误：RISC-V 工具链未安装${NC}"
        echo "请运行以下命令安装："
        echo "sudo apt update"
        echo "sudo apt install gcc-riscv64-linux-gnu g++-riscv64-linux-gnu"
        exit 1
    fi
    echo -e "${GREEN}✓ RISC-V 工具链检查通过${NC}"
}

# 编译单个程序
compile_program() {
    local program_dir=$1
    local program_name=$2
    
    echo -e "${YELLOW}编译 $program_name...${NC}"
    
    if [ ! -d "$program_dir" ]; then
        echo -e "${RED}错误：目录 $program_dir 不存在${NC}"
        return 1
    fi
    
    cd "$program_dir"
    
    # 清理之前的编译结果
    make clean > /dev/null 2>&1 || true
    
    # 编译
    if make all; then
        echo -e "${GREEN}✓ $program_name 编译成功${NC}"
        
        # 验证编译结果
        if [ -f "$program_name" ]; then
            echo "  文件类型: $(file $program_name)"
            echo "  文件大小: $(ls -lh $program_name | awk '{print $5}')"
        fi
    else
        echo -e "${RED}✗ $program_name 编译失败${NC}"
        return 1
    fi
    
    cd - > /dev/null
}

# 主函数
main() {
    echo "=== RISC-V Splash-4 编译脚本 ==="
    echo
    
    # 检查工具链
    check_toolchain
    echo
    
    # 定义要编译的程序
    programs=(
        "Splash-4/fft/FFT"
        "Splash-4/ocean-non_contiguous_partitions/OCEAN-NOCONT"
        "Splash-4/radix/RADIX"
        "Splash-4/lu-non_contiguous_blocks/LU-NOCONT"
        "Splash-4/water-nsquared/WATER-NSQUARED"
        "Splash-4/volrend-no_print_lock/VOLREND-NPL"
    )
    
    # 编译所有程序
    success_count=0
    total_count=${#programs[@]}
    
    for program in "${programs[@]}"; do
        program_dir=$(dirname "$program")
        program_name=$(basename "$program")
        
        if compile_program "$program_dir" "$program_name"; then
            ((success_count++))
        fi
        echo
    done
    
    # 显示编译结果
    echo "=== 编译结果 ==="
    echo -e "${GREEN}成功: $success_count/$total_count${NC}"
    
    if [ $success_count -eq $total_count ]; then
        echo -e "${GREEN}所有程序编译成功！${NC}"
    else
        echo -e "${RED}部分程序编译失败${NC}"
        exit 1
    fi
}

# 运行主函数
main "$@" 