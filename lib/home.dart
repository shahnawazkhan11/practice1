import 'package:flutter/material.dart';
import 'data.dart';
import 'auth.dart';
import 'login.dart';

class HomesScreen extends StatefulWidget {
  const HomesScreen({super.key});

  @override
  _HomesScreenState createState() => _HomesScreenState();
}

class _HomesScreenState extends State<HomesScreen> {
  List<Plant> _allPlants = [];
  List<Plant> _filteredPlants = [];
  String _selectedCat = "ALL";
  final TextEditingController _searchController = TextEditingController(); 

  @override

  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_onSearchChnaged);
    
  }
  void  _loadData() async
  {
    var plants = await loadPlants();
    setState(() {
      _allPlants = plants;
      _filteredPlants = plants;
    });

  }
  void _onSearchChnaged()
  {
    _applyFilters();
  }

  void _onCategorySelect(String category)
  {
    setState(() {
      _selectedCat = category;
    });
    _applyFilters();

  }
  void _applyFilters()
  {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredPlants = _allPlants.where((plant)
      {
        bool matchesCategory = _selectedCat == 'ALL'
        || plant.category.toUpperCase() == _selectedCat ;
        bool matchesSearch = plant.name.toLowerCase().contains(query);
        return matchesCategory && matchesSearch ;

      }).toList();
    });
  }

  Widget _buildCard(Plant plant) {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 150.0,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    plant.image,
                    fit :BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) 
                    {
                      return const Icon(Icons.local_florist,size: 150 ,color: Colors.grey);


                    }
                  ),
                ),
               
         
              ),
              const SizedBox(height: 04),
              // Text("hello" , style: TextStyle(fontSize: 24),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      plant.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                  alignment: Alignment.centerLeft,

                    child: Text(
                      plant.category,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body :SafeArea
      (child: Column( 
        children: [
        // top header
        Padding(padding: const EdgeInsets.all(10.0),
        child :Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.account_circle_sharp , size: 30.0, color: Colors.grey,),
            IconButton(
              icon: Icon(Icons.logout, size: 30.0, color: Colors.grey),
              onPressed: () async {
                await Auth.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Login()),
                );
              },
            ),

          ],

        )
        ),
        
        Padding(padding: const EdgeInsets.all(10.0),
        child : Text("Let's find your plants!" , style: TextStyle(fontSize: 35 ,fontWeight: FontWeight.bold))
        ),
        
      SearchBar(
        controller: _searchController,
        leading: const Icon(Icons.search),
        hintText: 'Search plants...',
        trailing: [
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () {
              // Add voice search functionality here
            },
          ),
        ],
        padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 16.0)),
      ),

  Padding(
  padding: const EdgeInsets.all(10.0),
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      
      children: [
        
        ElevatedButton(
          onPressed: () => _onCategorySelect('ALL'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedCat == 'ALL' ? Colors.green : Colors.grey[300],
            foregroundColor: _selectedCat == 'ALL' ? Colors.white : Colors.black,
          ),
          child: Text("ALL"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _onCategorySelect('INDOOR'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedCat == 'INDOOR' ? Colors.green : Colors.grey[300],
            foregroundColor: _selectedCat == 'INDOOR' ? Colors.white : Colors.black,
          ),
          child: Text("INDOOR"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _onCategorySelect('OUTDOOR'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedCat == 'OUTDOOR' ? Colors.green : Colors.grey[300],
            foregroundColor: _selectedCat == 'OUTDOOR' ? Colors.white : Colors.black,
          ),
          child: Text("OUTDOOR"),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => _onCategorySelect('BATHROOM'),
          style: ElevatedButton.styleFrom(
            backgroundColor: _selectedCat == 'BATHROOM' ? Colors.green : Colors.grey[300],
            foregroundColor: _selectedCat == 'BATHROOM' ? Colors.white : Colors.black,
          ),
          child: Text("BATHROOM"),
        ),
        SizedBox(width: 10),
      ],
    ),
  ),
),

   

      // )
      SizedBox(
        height: 300,
        child: _filteredPlants.isEmpty 
            ? Center(child: Text("No plants found"))
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: _filteredPlants.length,
                itemBuilder: (context, index) {
                  final plant = _filteredPlants[index];
                  return _buildCard(plant);
                },
              ),
      ),

Padding(padding: const EdgeInsets.all(10),
child: Align(
  alignment: Alignment.centerLeft,
  child:  Text("Recently Viewed" , style: TextStyle(fontSize: 28 , fontWeight: FontWeight.bold),
  ),
),),
Padding(
  padding: const EdgeInsets.all(10),
  child: SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        Container(
          width: 250,
          margin: const EdgeInsets.only(right: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cactus",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Leaves do the talking",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/plant1.jpeg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.local_florist, size: 40, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: 250,
          margin: const EdgeInsets.only(right: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Baboon",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Foliage become home",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/plant2.jpeg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.local_florist, size: 40, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: 250,
          margin: const EdgeInsets.only(right: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Aloe Vera",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Healing plant",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/plant3.jpeg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.local_florist, size: 40, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),
        ]
      ),
      
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: "Notes"),
        ],
        currentIndex: 0, 
        selectedItemColor: Colors.black,
        onTap: (i) {
          if (i != 0) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Placeholder Screen")));
        },
      ),
    );
  }
}
