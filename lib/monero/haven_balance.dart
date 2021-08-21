import 'package:cake_wallet/monero/monero_balance.dart';
import 'package:cw_monero/balance_list.dart';
import 'package:cw_monero/structs/haven_balance_row.dart';

Map<String, MoneroBalance> getHavenBalance({int accountIndex}) {
  List<HavenBalanceRow> fullBalances =
      getHavenFullBalance(accountIndex: accountIndex);
  List<HavenBalanceRow> unlockedBalances =
      getHavenUnlockedBalance(accountIndex: accountIndex);

  final Map<String, MoneroBalance> havenBalances = new Map();

  final int balancesLength = fullBalances.length;

  for (int i = 0; i < balancesLength; i++) {
    String assetType = fullBalances[i].getAssetType();
    int fullBalance = fullBalances[i].getAmount();
    int unlockedBalance = unlockedBalances[i].getAmount();

    MoneroBalance moneroBalance = MoneroBalance(
        fullBalance: fullBalance, unlockedBalance: unlockedBalance);

    havenBalances[assetType] = moneroBalance;
  }

  return havenBalances;
}
