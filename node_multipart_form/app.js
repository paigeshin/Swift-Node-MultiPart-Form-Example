const path = require('path');
const express = require('express');
const bodyParser = require('body-parser');
const multer = require('multer');

const app = express();

//MARK Disk Storage
const fileStorage = multer.diskStorage({
	destination: (req, file, cb) => {
		cb(null, 'images'); //pointing images folder
	},
	filename: (req, file, cb) => {
		cb(null, new Date().toISOString() + '-' + file.originalname);
	}
});

//MARK: File Filter
const fileFilter = (req, file, cb) => {
	//WARNING, note that if you want to check mimetype, you should type `mimetype` instead of `mimeType`. I spent 2 hours figuring it out.
	if (file.mimetype === 'image/png' || file.mimetype === 'image/jpg' || file.mimetype === 'image/jpeg') {
		cb(null, true); //file upload success
	} else {
		cb(null, false); //file upload fail
	}
};

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(
	multer({ storage: fileStorage, fileFilter: fileFilter }).single('image') //field 이름이 image
);

app.use('/images', express.static(path.join(__dirname, 'images')));

app.use((req, res, next) => {
	res.setHeader('Access-Control-Allow-Origin', '*');
	res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE');
	res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization, form-data, multipart/form-data');
	next();
});

app.post('/file', (req, res, next) => {
	console.log('/file router is called!');
	console.log(`req.file: ${req.file}`);
	console.log('req.body.hello', req.body.hello);

	if (!req.file) {
		const error = new Error('No image provided');
		error.statusCode = 422;
		throw error;
	}

	const imageUrl = req.file.path;
	res.json({ message: 'Image sent successfully', url: imageUrl });
});

app.get('/', (req, res, next) => {
	res.send('Hello World');
});

app.use((error, req, res, next) => {
	const status = error.statuscode || 500;
	const message = error.message;
	const data = error.data;
	console.log(message);
	console.log(data);
	res.status(status).json({ message: message, data: data });
});

app.listen(5454);
