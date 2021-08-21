import 'package:cake_wallet/entities/crypto_currency.dart';
import 'package:cake_wallet/entities/wallet_type.dart';

CryptoCurrency currencyForWalletType(WalletType type) {
  switch (type) {
    case WalletType.bitcoin:
      return CryptoCurrency.btc;
    case WalletType.monero:
      return CryptoCurrency.xhv;
    case WalletType.litecoin:
      return CryptoCurrency.ltc;
    default:
      return null;
  }
}
