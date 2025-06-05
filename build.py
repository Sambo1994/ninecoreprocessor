import os
import subprocess

# List of source files
verilog_sources = [
    "top.sv",
    "core0.sv",
    "core1.sv",
    "core2.sv",
    "core3.sv",
    "core4.sv",
    "core5.sv",
    "core6.sv",
    "core7.sv",
    "predictor.sv",
    "testbench.sv"  # Include your testbench file
]

# Output binary or simulation name
output_exe = "sim.out"

def compile_with_iverilog():
    print("🔧 Compiling with Icarus Verilog...")
    cmd = ["iverilog", "-g2012", "-o", output_exe] + verilog_sources
    subprocess.run(cmd, check=True)
    print("✅ Compilation finished!")

def simulate():
    print("🚀 Running simulation...")
    subprocess.run(["vvp", output_exe], check=True)
    print("📊 Simulation completed.")

def main():
    try:
        compile_with_iverilog()
        simulate()
    except subprocess.CalledProcessError as e:
        print(f"❌ Build or simulation failed: {e}")

if __name__ == "__main__":
    main()
