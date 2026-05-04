const express = require('express');
const app = express();

app.use(express.urlencoded({extended:false}));
app.use(express.json());

const dotenv = require('dotenv');
dotenv.config({path: './env/.env'});

app.use('/resources', express.static('public'));
app.use('/resources', express.static(__dirname + '/public'));

app.set('view engine', 'ejs');

const bcryptjs = require('bcryptjs');
const session = require('express-session');
app.use(session({
    secret: 'secret',
    resave: true,
    saveUninitialized: true
}));

// CAMBIO: Ahora importamos la FUNCIÓN de conexión
const createConnection = require('./database/db');

// Middleware para tener la conexión disponible en las rutas si hay sesión
const getConn = (req) => {
    // Si el usuario está logueado, usamos sus credenciales de MySQL guardadas en sesión
    if (req.session.loggedin) {
        return createConnection(req.session.dbUser, req.session.dbPass);
    }
    // Si no, usamos las credenciales de administrador/root por defecto
    return createConnection();
};

// --- RUTAS DE NAVEGACIÓN ---
app.get('/', (req, res) => {
    if (req.session.loggedin) {
        res.redirect('/peliculas');
    } else {
        res.render('index'); 
    }
});

// --- RUTA PARA MOSTRAR EL FORMULARIO DE EDICIÓN ---
app.get('/edit/:id', (req, res) => {
    if (!req.session.loggedin || req.session.role !== 'admin') {
        return res.redirect('/');
    }

    const id = req.params.id; // Captura el número del enlace
    const conn = getConn(req); // Ua la función que se creó

    conn.query('SELECT * FROM Pelicula WHERE id_pelicula = ?', [id], (error, results) => {
        if (error || results.length === 0) {
            conn.end();
            return res.send('Película no encontrada');
        }

        conn.query('SELECT * FROM Clasificacion', (errC, resClas) => {
            conn.query('SELECT * FROM Pais', (errP, resPais) => {
                res.render('edit', {
                    peli: results[0],
                    clasificaciones: resClas,
                    paises: resPais,
                    name: req.session.name,
                    role: req.session.role
                });
                conn.end();
            });
        });
    });
});

app.get('/delete/:id', (req, res) => {
    if (req.session.role !== 'admin') return res.send('Acceso denegado');

    const id = req.params.id;
    const conn = getConn(req);

    conn.query('DELETE FROM Pelicula WHERE id_pelicula = ?', [id], (error) => {
        conn.end();
        if (error) {
            console.log(error);
            res.send('No se pudo eliminar la película');
        } else {
            res.redirect('/peliculas');
        }
    });
});

// --- LÓGICA DE LOGIN (AUTENTICACIÓN DIRECTA EN BD) ---
app.post('/auth', async (req, res) => {
    const { user, pass } = req.body;
    
    if (user && pass) {
        const authConn = createConnection(user, pass);

        authConn.connect((error) => {
            if (error) return res.send('Usuario o contraseña incorrectos');

            req.session.loggedin = true;
            req.session.name = user;
            req.session.dbUser = user;
            req.session.dbPass = pass;
            
            // --- CORRECCIÓN AQUÍ ---
            // Definimos quiénes son administradores por su nombre de usuario en MySQL
            const admins = ['root', 'Dios', 'Fabri', 'Pablo']; 
            
            if (admins.includes(user)) {
                req.session.role = 'admin';
            } else {
                req.session.role = 'user'; // Susana entrará aquí
            }

            authConn.end();
            res.redirect('/peliculas');
        });
    }
});

// PROCESAR Actualización
app.post('/update', (req, res) => {
    // 1. Verificamos permisos de admin
    if (req.session.role !== 'admin') return res.send('Acceso denegado');

    // 2. Capturamos los datos del formulario
    const { id_pelicula, titulo, anio, duracion_minutos, sinopsis, id_clasificacion, id_pais } = req.body;

    // 3. Obtenemos la conexión dinámica del usuario actual
    const conn = getConn(req);

    const sql = 
        `UPDATE Pelicula SET titulo = ?, anio = ?, duracion_minutos = ?, sinopsis = ?, id_clasificacion = ?, id_pais = ? 
        WHERE id_pelicula = ?`;

    conn.query(sql, [titulo, anio, duracion_minutos, sinopsis, id_clasificacion, id_pais, id_pelicula], (err) => {
        // 4. Muy importante: Cerrar conexión después de la consulta
        conn.end(); 

        if (err) {
            console.error(err);
            return res.send("Error al actualizar en la base de datos");
        }
        
        // 5. Redirigimos al catálogo
        res.redirect('/peliculas');
    });
});

// --- LÓGICA DE PELÍCULAS ---
app.get('/peliculas', (req, res) => {
    if (req.session.loggedin) {
        const conn = getConn(req);
        const sql = `
            SELECT p.*, c.nombre AS clasificacion, pa.nombre AS pais 
            FROM Pelicula p
            LEFT JOIN Clasificacion c ON p.id_clasificacion = c.id_clasificacion
            LEFT JOIN Pais pa ON p.id_pais = pa.id_pais
        `;

        conn.query(sql, (error, results) => {
            conn.end(); // Siempre cerrar la conexión

            if (error) {
                console.log("Error en la consulta:", error.code);
                // Si hay error (como falta de permisos), enviamos un array vacío para que no falle el forEach
                return res.render('peliculas', {
                    login: true,
                    name: req.session.name,
                    role: req.session.role,
                    data: [] // Enviamos vacío para evitar el error de 'undefined'
                });
            }

            res.render('peliculas', {
                login: true,
                name: req.session.name,
                role: req.session.role,
                data: results
            });
        });
    } else {
        res.redirect('/');
    }
});

// --- CRUD PROTEGIDO (EJEMPLO SAVE) ---

app.post('/save', (req, res) => {
    if (req.session.role !== 'admin') return res.send('Acceso denegado');

    const { titulo, anio, duracion, sinopsis, id_clasificacion, id_pais } = req.body;
    const peliData = { titulo, anio, duracion_minutos: duracion, sinopsis, id_clasificacion, id_pais };

    const conn = getConn(req);
    conn.query('INSERT INTO Pelicula SET ?', peliData, (error) => {
        conn.end();
        if (error) {
            console.log(error);
            res.send('Error: ¿Tienes permisos de escritura en la BD?');
        } else {
            res.redirect('/peliculas');
        }
    });
});

// --- SALIDA ---
app.get('/logout', (req, res) => {
    req.session.destroy(() => {
        res.redirect('/');
    });
});

app.listen(3000, () => {
    console.log('Servidor activo en http://localhost:3000');
});