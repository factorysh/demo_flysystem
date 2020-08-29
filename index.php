<?php
require __DIR__ . '/vendor/autoload.php';

use Aws\S3\S3Client;
use League\Flysystem\AwsS3v3\AwsS3Adapter;
use League\Flysystem\Filesystem;

// https://docs.min.io/docs/how-to-use-aws-sdk-for-php-with-minio-server.html
$s3Cfg = [
    'credentials' => [
        'key'    => $_SERVER['ACCESS_KEY'],
        'secret' => $_SERVER['SECRET_KEY'],
    ],
    'region' => $_SERVER['REGION'],
    'version' => 'latest',
];
if($_SERVER['S3_ENDPOINT']) {
    $s3Cfg['endpoint'] = $_SERVER['S3_ENDPOINT'];
    $s3Cfg['use_path_style_endpoint'] = true;
}
$client = new S3Client($s3Cfg);

$adapter = new AwsS3Adapter($client, $_SERVER['BUCKET'], 'upload');

$filesystem = new Filesystem($adapter);
