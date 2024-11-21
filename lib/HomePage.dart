import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookListPage extends StatefulWidget {
  BookListPage({super.key});

  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  List<Map<String, dynamic>> books = [];

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    final response = await Supabase.instance.client.from('books').select();
    setState(() {
      books = List<Map<String, dynamic>>.from(response);
    });
  }

  Future<void> insertBook(String title, String author, String decription) async {
  try {
    final response = await Supabase.instance.client.from('books').insert([
      {
        'title': title,
        'author': author,
        'decription': decription,
      }
    ]);

    if (response.error == null) {
      // Data berhasil dimasukkan, reload daftar buku
      fetchBooks();
    } else {
      // Menangani error jika terjadi
      print('Error inserting book: ${response.error?.message}');
    }
  } catch (e) {
    print('Error inserting book: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
            // Open the drawer when menu icon is pressed
            Scaffold.of(context).openDrawer();
          },
            icon: Icon(Icons.menu, color: Colors.white,),
            tooltip: 'Drawer Buku',
          ),
        title: Text('Daftar Buku', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
        actions: [
          IconButton(
            onPressed: fetchBooks,
            icon: Icon(Icons.refresh, color: Colors.white,),
            tooltip: 'Refresh Daftar Buku',
          ),
          IconButton(
            onPressed: () {
              // Open the insert book form
              showDialog(
                context: context,
                builder: (context) => InsertBookDialog(onSubmit: insertBook),
              );
            },
            icon: Icon(Icons.add, size: 28, color: Colors.white,),
            tooltip: 'Tambah Buku',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink[100],
              ),
              child: Text(
                'Perpustakaan Milenial',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Daftar Buku'),
              onTap: () {
                // Navigasi ke halaman daftar buku
                Navigator.pop(context); // Menutup drawer
                // Tidak perlu navigasi karena kita sudah ada di halaman ini
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Pengaturan'),
              onTap: () {
                // Aksi pengaturan
                Navigator.pop(context); // Menutup drawer
                // Anda bisa menambahkan halaman pengaturan di sini
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Keluar'),
              onTap: () {
                // Aksi keluar (misalnya log out)
                Navigator.pop(context); // Menutup drawer
                // Menambahkan aksi keluar, seperti log out
              },
            ),
          ],
        ),
      ),
      body: books.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      book['title'] ?? 'No Title',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4),
                        Text(
                          book['author'] ?? 'No Author',
                          style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.black54),
                        ),
                        SizedBox(height: 4),
                        Text(
                          book['decription'] ??
                              'No Description available.',
                          style: TextStyle(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              color: Colors.black45),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Wrap(
                      spacing: 12, // space between icons
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            // Handle edit action
                            Navigator.pop(context);
                          },
                          tooltip: 'Edit Buku',
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Handle delete action
                            Navigator.pop(context);
                          },
                          tooltip: 'Hapus Buku',
                        ),
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}

// Dialog for adding a new book
class InsertBookDialog extends StatefulWidget {
  final Function(String, String, String) onSubmit;

  InsertBookDialog({required this.onSubmit});

  @override
  _InsertBookDialogState createState() => _InsertBookDialogState();
}

class _InsertBookDialogState extends State<InsertBookDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _decriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Tambah Buku Baru'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Judul Buku'),
          ),
          TextField(
            controller: _authorController,
            decoration: InputDecoration(labelText: 'Pengarang'),
          ),
          TextField(
            controller: _decriptionController,
            decoration: InputDecoration(labelText: 'Deskripsi Buku'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            final title = _titleController.text;
            final author = _authorController.text;
            final decription = _decriptionController.text;

            if (title.isNotEmpty && author.isNotEmpty && decription.isNotEmpty) {
              widget.onSubmit(title, author, decription);
              Navigator.pop(context);
            } else {
              // Show error if fields are empty
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Harap isi semua field!')),
              );
            }
          },
          child: Text('Simpan'),
        ),
      ],
    );
  }
}