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
if ($_SERVER['S3_ENDPOINT']) {
    $s3Cfg['endpoint'] = $_SERVER['S3_ENDPOINT'];
    $s3Cfg['use_path_style_endpoint'] = true;
}
$client = new S3Client($s3Cfg);
$adapter = new AwsS3Adapter($client, $_SERVER['BUCKET'], 'upload');
$filesystem = new Filesystem($adapter);

$uploadName = "fileToUpload";

if ($_FILES[$uploadName] != null) {
    $stream = fopen($_FILES[$uploadName]['tmp_name'], 'r+');
    $up = $filesystem->writeStream(
        $_FILES[$uploadName]['name'],
        $stream
    );
    if(! $up) {
        echo "oups";
    };
    if (is_resource($stream)) {
        fclose($stream);
    }
}

?>
<!DOCTYPE html>
<html>

<head>
    <title>Demo Flysystem</title>
</head>

<body>
    <h1>Demo Flysystem</h1>

    <ul>
    <?php
        $contents = $filesystem->listContents('', false);
        foreach ($contents as $object) { ?>
            <li><a href="<?=$object['path']?>"><?=$object['basename']?></a></li>
        <?php } ?>
    </ul>

    <form action="/" method="post" enctype="multipart/form-data">
        <input type="file" name="fileToUpload" id="fileToUpload">
        <input type="submit" value="Upload Image" name="submit">
    </form>

</body>

</html>