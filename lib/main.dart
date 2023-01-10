import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  await initHiveForFlutter();
  runApp(const MaterialApp(title: "GQL App", home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink("https://countries.trevorblades.com/");
    final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
      GraphQLClient(
        link: httpLink,
        cache: GraphQLCache(store: HiveStore()),
      ),
    );
    return GraphQLProvider(
      client: client,
      child: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  final String query = r"""
                    query GetContinents{
 countries{
  name,
  phone
}
}
                  """;

  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Code')),
      body: Query(
        options: QueryOptions(document: gql(query)),
        builder: (result, {fetchMore, refetch}) {
          if (result.data == null) {
            return const Text('No data found');
          }
          return ListView.builder(
            itemBuilder: ((context, index) {
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(result.data!['countries'][index]['name']),
                    Text(result.data!['countries'][index]['phone']),
                  ]);
            }),
            itemCount: result.data!['countries'].length,
          );
        },
      ),
    );
  }
}
