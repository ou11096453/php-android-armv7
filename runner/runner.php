<?php
if ($argc < 4) { fwrite(STDERR, "Usage: php runner.php <script> <method> <json>\n"); exit(1); }
$params = json_decode($argv[3], true) ?: []; $_GET = array_merge($_GET, $params); ob_start(); $loaded = require $argv[1]; $output = ob_get_clean();
$result = is_callable($loaded) ? $loaded($params) : (function_exists($argv[2]) ? $argv[2]($params) : $output);
if (is_array($result) || is_object($result)) echo json_encode($result, JSON_UNESCAPED_UNICODE); elseif ($result !== null) echo $result;
