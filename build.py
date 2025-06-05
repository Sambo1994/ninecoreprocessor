import siliconcompiler

def main():
    chip = siliconcompiler.Chip('ninecoreprocessor')

    # Add all source files here
    chip.input([
        'src/top.sv',
        'src/core0.sv',
        'src/core1.sv',
        'src/predictor.sv'
    ])

    chip.set('design', 'top')  # Your top-level module name
    chip.set('clock', 'clk', '12ns')  # Adjust clock as needed
    chip.set('option', 'frontend', 'sv')  # Force SystemVerilog parsing
    chip.load_target('skywater130')  # ASIC flow with open PDK

    chip.run()

    print("✅ GDS Output Path:")
    print(chip.find_result('gds', step='export', index='0'))

if __name__ == '__main__':
    main()
