# Verificar que se han proporcionado los argumentos necesarios
if [ $# -ne 6 ]; then
    echo "Por favor proporciona: $0 <Nombre_VM> <Tipo_SO_Linux> <CPUs> <Memoria_GB> <VRAM_MB> <Tamaño_Disco_GB>"
    exit 1
fi

# Capturar los argumentos
nombre_vm=$1
tipo_so=$2
cpus=$3
memoria=$4
vram=$5
tamanio_disco=$6

# Crear la máquina virtual
VBoxManage createvm --name $nombre_vm --ostype $tipo_so --register

# Configurar la máquina virtual
VBoxManage modifyvm $nombre_vm --cpus $cpus --memory $((memoria*1024)) --vram $vram

# Crear el disco duro virtual
VBoxManage createmedium disk --filename "$nombre_vm.vdi" --size $((tamanio_disco*1024)) --format VDI

# Asociar el disco duro virtual a la máquina virtual
VBoxManage storagectl $nombre_vm --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach $nombre_vm --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$nombre_vm.vdi"

# Crear y configurar el controlador IDE para el CD/DVD
VBoxManage storagectl $nombre_vm --name "IDE Controller" --add ide

# Imprimir la configuración
echo "Configuración de la máquina virtual:"
VBoxManage showvminfo $nombre_vm
