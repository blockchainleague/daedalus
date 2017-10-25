// @flow
import BigNumber from 'bignumber.js';
import { request } from './lib/request';
import { ETC_API_HOST, ETC_API_PORT } from './index';

export type SendEtcTransactionParams = [
  { from: string, to: string, value: BigNumber }, // transaction details
  string // password
];

export type SendEtcTransactionResponse = string; // tx address

export const sendEtcTransaction = (
  params: SendEtcTransactionParams
): Promise<SendEtcTransactionResponse> => (
  request({
    hostname: ETC_API_HOST,
    method: 'POST',
    path: '/',
    port: ETC_API_PORT,
  }, {
    jsonrpc: '2.0',
    method: 'personal_sendTransaction',
    params: [{ ...params[0], value: params[0].value.toString(16) }, params[1]]
  })
);
