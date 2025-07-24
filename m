Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB48C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCC578E0069; Thu, 24 Jul 2025 05:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7DBC8E0051; Thu, 24 Jul 2025 05:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1DB98E0069; Thu, 24 Jul 2025 05:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DFF68E0051
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:29:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63A7F1A02F1
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:29:45 +0000 (UTC)
X-FDA: 83698635930.12.36E75C6
Received: from OS8PR02CU002.outbound.protection.outlook.com (mail-japanwestazon11012028.outbound.protection.outlook.com [40.107.75.28])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2AAE214000A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:29:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=efa1GnwA;
	spf=pass (imf26.hostedemail.com: domain of link@vivo.com designates 40.107.75.28 as permitted sender) smtp.mailfrom=link@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753349382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rbECc+BPpmfhRBiZiHcaZ0Wv/yapvE4MC3RqzKFGeXU=;
	b=0TCUfuPdzwl7UahnKJrGwjCrEf1sbXfX965wxFcm4QeFqzuJozPETy0Jvq8m5srYVEw8V+
	nRZrIS5hnz8EfPUFi6OVvbDjGXZaqUzjjd3SYQjY5k+IhsqDJuQqlcr8Jv8rBtqQC0axNf
	N2RVBc0WeH3PWDwrm/ACTajqb3vamBU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b=efa1GnwA;
	spf=pass (imf26.hostedemail.com: domain of link@vivo.com designates 40.107.75.28 as permitted sender) smtp.mailfrom=link@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753349382; a=rsa-sha256;
	cv=pass;
	b=YzCxpg36dosAfS08ILq0110a9uQoB08n74O2QJh/SEo2csghsKx61DsKCauo80F+tfKFRn
	2D90xId6xV4ccJNlcoxhAIcLoRAwmY6027uO5TJ45aJH+D6gDdVl0cS6bKIcx2kwsDp5kO
	hjqMSG75q6h2774Gm9ibto7UchN9aJs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=on3hleJJB6rjQv9X6NnYcw374MCgOIEEDBXSzbdTKbZH8T47xqt6/+wwMmhfCzOcGIMWQD/ui+NWySH7vGdaLUVIhfE4k40hDNGnrkLkPwB69GxddsRl/4XkoogdsLKPqg6DGv/nQhENWzzTxowZV11B1eBSISJP44P3GaR3eIdog06msIa1aXXrkQW1FDV3k9I1XABuxIfOY+N7at6Sb5HwmCERYmVBy1wX1lqITKlnqRd83vSI1jYWG0O7e1M8ExY6cluIDN55zmDCy6JDFjzVD+wcUMD78DHPBRlqOGK5tWWRP5wCY5ytTlwpVEsIK+tzstB7CbopuTwZqp/s1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rbECc+BPpmfhRBiZiHcaZ0Wv/yapvE4MC3RqzKFGeXU=;
 b=Wi4KAwYd2zbQc8zu3pOQdfy73MtVN5WSwK/O/meVt5bc4suR5W5FMnpaYdMdWNor2HuNS4Xw6V6bAoD4yCrjT4EKZIuNu4cH6fyzdDFwqja2wOzgElS8TmSaR/goSvHeTa+PABsqfw9eU5TwiDFKhnyCphjZ9EuzZsJwUY05HJcx8Tgy++4s/AIOC/zPp7Ei3sG9Ssj4UX4t6xJpyOMDslNMRjnb6UTk3dhwp6ZETi8xX64YFiny//HEu+ZgG6NdWwcO9NlZTQZ7pmgHCFpy2O1b851NlU/LbdvmE/lSrxfIRdruzKNi5CU/VtgP4zdeNYH3sTQuwqtlc0YENouV8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rbECc+BPpmfhRBiZiHcaZ0Wv/yapvE4MC3RqzKFGeXU=;
 b=efa1GnwAfY9twbrk/UnCI1iqCyUw5i/oEsqtJpMYWi3QSGawJFcUpfZ8gzJxzx3Xt7n9cFPhyd8n4ko3SUw6tvdMqLVxt7lKm1Z4OnjVRB62WBdVL6AyDnx6ISjnRqlheRxakVFcLBRZ6Hs1fhBono6oEXMW5hk++7jIB9ALOMvoDzrBCuw8Bmvt6C1sIzhM1iBOlTfCuWTvMsJvETcMVRWJhfIBXKI1HB+fT1Bl7kZV3Qk+u8W1YRghjn1HLmZYabJmRIcBsdjpOd3Fu9zH3+VtCGZaFEqQ2ly3weV5JQdIb/AD3wnu2DYBmmZq8fB4OFrSK7nwNacThWtOcLKh5Q==
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com (2603:1096:301:f8::10)
 by TYSPR06MB6675.apcprd06.prod.outlook.com (2603:1096:400:478::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Thu, 24 Jul
 2025 09:29:37 +0000
Received: from PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f]) by PUZPR06MB5676.apcprd06.prod.outlook.com
 ([fe80::a00b:f422:ac44:636f%4]) with mapi id 15.20.8943.029; Thu, 24 Jul 2025
 09:29:36 +0000
Message-ID: <40cb7d64-0b90-4561-8e10-06a808a2766a@vivo.com>
Date: Thu, 24 Jul 2025 17:29:30 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Rik van Riel <riel@surriel.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Christian Brauner <brauner@kernel.org>, Usama Arif <usamaarif642@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250724084441.380404-1-link@vivo.com>
 <764c48ad-8869-4f69-898e-0a1c58684f7d@lucifer.local>
From: Huan Yang <link@vivo.com>
In-Reply-To: <764c48ad-8869-4f69-898e-0a1c58684f7d@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:196::10) To PUZPR06MB5676.apcprd06.prod.outlook.com
 (2603:1096:301:f8::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PUZPR06MB5676:EE_|TYSPR06MB6675:EE_
X-MS-Office365-Filtering-Correlation-Id: 98216632-556c-4166-8ee8-08ddca949b57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|7416014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VzNhTjJKaFBWYzBjYUdPejRrWTB5bzl0QXhHeE41TmR4aGxhSWxvMlR5L2Rv?=
 =?utf-8?B?Q3VXMEZwTXBWVnFBYk9qWE82dkRPcVJzQWVKVkd6SElTVW5wVU1UOWVQRkds?=
 =?utf-8?B?Q3BRaTQ2cFNhL2h4MFZ4alBRTjNZYWdBQ3haUGladGN6dEF4YmFBbzVoTjBY?=
 =?utf-8?B?VU9SVXhDVDJuTERSakZ1RDNwRUlzUVNNR2hQalp0LytUSHZqWW8yZWozNEZq?=
 =?utf-8?B?ZDlydkJCSVRvTmZUTXVJZ3QxVnJmQk9ZMVh5eFhOT1RuUE9SOFB2aXVaZ3o1?=
 =?utf-8?B?dWlKWjJRblNKTFc3UkRKenZsaGFNK0JNdUFna2VUcUxtT2JMbmhtTU5tRVNM?=
 =?utf-8?B?SWVEbXRZTWRNNEhmLzI1QXFNM3VHZld4TnNaOE9YTHdTSkN0NWlCbVdERXBR?=
 =?utf-8?B?TndMUzV6QkNab1dXb01qZmJneXJMcy9wRjBPbEJ4b3ZLL1hzQTRsaVhWbEV0?=
 =?utf-8?B?YzhkRkZFbm1IZUpENkdaSkFiczVPdlpVMjFWcFBvRE1SQnB4akthOUYxOXpr?=
 =?utf-8?B?QjAzWWtJZDRIcm9tY3NoSmtQbUhpNXoxMkRQWUFiNzYrWFFNMS9pSjR4OUtl?=
 =?utf-8?B?WEIvMVZmb2VxM242d2tyZmNYVG5zQVRNSTBWY09BeUpNNDluZkkxK3dNZ29r?=
 =?utf-8?B?UitZRERjVVZhYm1PMGVMckVIdlNlT2lvOUhLcDNCWFdxSm5JOStCQlVFVXM1?=
 =?utf-8?B?OEdhajVPUWtrZkhGcU93Mjh3Um5aTDNQV0V2cXp2bDIrcFVMUDJsSTlNejhP?=
 =?utf-8?B?bUVKbWU5NlRRRkhQeHgyanhSRThMT1docjZDYnNiclhsOU5Mc0Y2RE45UnBV?=
 =?utf-8?B?MXhDaTJza2tCT2twcWsxSDVaOUlkb01VRG5ydFpOUTNObVVoMkpPekpBZEhU?=
 =?utf-8?B?RGtVSi85Yi8vSEhldWZubisvc2g2c3RUWVkrUlFWVnJ5UHR2eTJFTyt0SUpq?=
 =?utf-8?B?QmJJOVVyS25BeVVJZndzclZyYWJxM2QybVpqcmVMY0JGWFM5UDhaWkxTM0VC?=
 =?utf-8?B?cng4YWJYVEkwUWJ5SUJDNzJhZExFRVNyY1hCRUo2U2VPcXk3S3VqQUd1Mlhi?=
 =?utf-8?B?VnJHaDJkVlN1MndEd3VGMG9PbzNydXo3bkk3OVVUcUZITEZQbEk3elliUzMx?=
 =?utf-8?B?Tzh5K1A0cmQzbEtnVUZLaW1mT0xSQ3hhQUwvTTh0NHlBTGluZzJBS0JKajM1?=
 =?utf-8?B?eHFGYUNUUnNhMXFET0xSeVcxNUpMRytBdENDb0pOK25HZFpROTFaaU0vWElI?=
 =?utf-8?B?VEhSaGpIWVRyQnZ3T2RQSnJMM0NOdkNiRkFjS0NVOE81bGRZNGw2ZWR2QUdZ?=
 =?utf-8?B?QWFiRjh6bXoyNEpycVFGQnM1QTgwN1BJVERoMzVvVEJKUXJOOUttQks2cXpZ?=
 =?utf-8?B?am0rVnZIYkt6UVJLcmY5d2pRZDUraHZYeDRVV2ZrSWxoL2NXYmRYR0RMT2R2?=
 =?utf-8?B?N2hWTkIwM2psSGtwLzJuUW9UOEVINnZCZzNJQzJocHEvLzdERWkzNDV1TFRD?=
 =?utf-8?B?dzhJVHV1N29KTmIyQlZ4QUxXREJjRXdOWGlQTmlrTmhlWFVEdk83ZHRZS0ZX?=
 =?utf-8?B?a1ZZYjZqK0V2TzBCWldJVWJqM2VJUGRYNkJlem5lR2FGdXFPdGEvRGNMdmlQ?=
 =?utf-8?B?akZaT1hrSHFpdUFZeWZwQTRCRWpXbDhUYXk3TysxZkR2Uk1vR3EwRzFlN09L?=
 =?utf-8?B?cnJtcHplQ2ZCR1dCVzlDWlgyMEhMT0N2MElXUFUrMjN5eit0OFVUbXJ5UXNX?=
 =?utf-8?B?T3pQQllaTXFZcWJ6cU9ocmdmWmIzMlF1QTRoNWROOGIzUG9VNTdielkyWVZr?=
 =?utf-8?B?VVlKbHNHcHdTSHZ3TWVsWVFadmpSSjk0c2NjV1JwYW5Kako0d0VQNHh4Yk85?=
 =?utf-8?B?ejhUTnFBc3VJSm81dm5vUVZpWjdESERMTVliTGtGQzlCTEVCcTFRWlpzYlJ5?=
 =?utf-8?B?U25TaDkyMVV5aWJpQk9LcFJNWVZ5WTB5eTRubVJ0bzY4aGRCVHBhaUIwazkr?=
 =?utf-8?Q?fAq7jxhJslxEWBoHHRLeOZdl128Mdw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR06MB5676.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(7416014)(366016)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dVRIRUlMdHBSUzhjUFRtOTNkc3BFTHlaUTk5dmhrNDluaGFlSFAyWGxuYjBL?=
 =?utf-8?B?TGRScjJ5dXcyYVc5YTk0QVRyRFFsOTJ1aTRacUN6MmQ5N0I2SXluQk5lLzlj?=
 =?utf-8?B?RkNBbnRHb2k3TE0rSC83K2pOR3dxMGlxTG5ZemtPYnVCNXFja2U5NDhkakVN?=
 =?utf-8?B?dzZ5UXAvejkwTVVTWG1kdjhsR2xiZythSzNuNHIzZGkvMzRMcUw1MlRQSTV5?=
 =?utf-8?B?YnB0ZnF5TmN3bWJvNWxQMEhRMTJKUzZsNGlPRk0ycGxMSVFXQndiTUFRVHpL?=
 =?utf-8?B?UkpEUW5UYW16OWViTVJGTkRwZTlGdkpoOWtDMVdDYjBLMDNIWWVjZWlCSzMy?=
 =?utf-8?B?djBheGtWZmg4UWc0UHA4MjRjRDBsU2p5dHdsdkZ3N3duY3R4UnVXNVVrRFpu?=
 =?utf-8?B?akVyNXNuQ29hUkhZTXNjZmpmWUllRmp6NktZdG40Umc5dDJlQ0M1d0ZiTnNa?=
 =?utf-8?B?MlpSenpPNkhFRHZORkUvZnNzQ3AwWDFHUGgxYXFicWJvNm9JMG1Jb2VjSDNT?=
 =?utf-8?B?bjhkYkRZM29aWkxUUEpQc0lBNlJpZnlzc1JQbHBINFNJbmcySWZ0eXlxazNu?=
 =?utf-8?B?cGhSR0tVdHlLZmFOV21RaVRBWHNYT3hlT01idU44MVNOcjdSaFY3QWl1ZlFE?=
 =?utf-8?B?elR2emJ0ZkxKbW83anZXVXNqSUdVMkx0WUp6c1BnUWorU05QaXQyMFp4Y3RZ?=
 =?utf-8?B?TVVnSFF4ZkcrSGpWZFR2ZitOd0NNRGhTbTFuSWZkZHFWRTRCaDZVd0xvd0lM?=
 =?utf-8?B?VW1nWjRBNmV6bzN0QXFlazlKK0svZENZYWRWc2RvanorL09iZkpSSlV6cDhy?=
 =?utf-8?B?dW5qYmV3OVUxekI3ODBObXludHcwTkRQVnFzOUZDOGdCMXI0Y1lXK21EMGdI?=
 =?utf-8?B?Nlh0RUNFaVcwQ1A0aWlzSDJ1Mlh6bnZrTThwL214TTEzZUVZMi9WOGZLWEEr?=
 =?utf-8?B?TkZ6WHRqOWNac1A3S0U1dmJjWVE4MmZXcUlKVmRNMTVVbHlPc3hVOW1ra0lI?=
 =?utf-8?B?NWpYNEN0TExkbDZVbFFuZWhYUUI2U3RWaTJTTzNnNUV5QjFqbWM4V0FVOFZV?=
 =?utf-8?B?amdDTC9kdThxRy9WK3BvTmJDQTcwb05jaDhPMCtud3BhdzNxWm0rTFRMUk1l?=
 =?utf-8?B?cEkrT2V2MFlwYUhxQlJsRzV6ZUFHaENRb241L0lXQ0RObGdqdnhFdFhqanFh?=
 =?utf-8?B?VmFnb2pBUzdTU2JZWVBjQXZRb3N2SjVkOHJlM2UvRnlYN1B1RmEyNG9BMnVY?=
 =?utf-8?B?NWZqOXN5aXBCS3ptNjQ2REFHb3pjMldmdjBmRUhqUC9lVU1DcytKVkZZNzdi?=
 =?utf-8?B?QnNZcXJ0YjJNWkNiZlU5TXJwNlVCUWs5ckVPYmJuNjNNZWpndXhyckZBalVT?=
 =?utf-8?B?MUM2RTh1SHVGenZidEVSSjQ3dGhCa2xFaGorZW12UXdhT0JDNTg0eEs1MEpk?=
 =?utf-8?B?UzBtb25KaHRySnZ1Q2tzdjZEcUU1TlQ3NUVTOThzcElMT3hydjlXTVgvMzNC?=
 =?utf-8?B?cGw5S2ZXVXdmT0Y5MWdwMXFEWXE0NmJ6UEFZOUN1ZkUxMmxDeEZDcEthTnJs?=
 =?utf-8?B?aGc4L0Y2d1E2UGkvREZFTzFKTkIyaDFMdjNjZnUwaGd4a3JUaWZCTEFEWTEz?=
 =?utf-8?B?bWx4VXo1UWNkU0FnME44c1NLSFJhNklOckpCL2RzQytjb29TWG16TEV2eEVr?=
 =?utf-8?B?dWtHT0l1Z1RuQkY5eEdvQzBCVHQ0aXplUXBsbERUVVZEeFNOQnJsUllhdDBC?=
 =?utf-8?B?MWZ3OGdUbnFjZEV3Rk1uZCszbzFQNjZCZlRuRElZZ3NOc21XWmtHVXYza2lE?=
 =?utf-8?B?VHlaSEZUeE1RbkpScWo2T09qQjVITlVPV2c3MnRoUWs5Z3JOcE5oQytRR1Vr?=
 =?utf-8?B?OWtYeGppdG4zWXFzUlNPYnB3QXZLYXN0RmZ6QzdhZGs2TzM4Z0lTZmdPZDd3?=
 =?utf-8?B?NndsanNVT3BCQ3g4d2ZQR2dNTEgrMkI4TlFjeTFSTzM4aGJaSlpVSlRNUXpq?=
 =?utf-8?B?WkNLLzdDdFRMMWFQdkFzY3c4VjJzdkpVNmxlcFBHVnJuc2tuQitRSGE0U1JY?=
 =?utf-8?B?MHlqMFJQZmVYS3I4dWROcHhkTENNWDZyYlcyTytkSWdsUVdkWFo5V2lxQ2ZD?=
 =?utf-8?Q?24Q/8j/56eZx0TRY+todNHh8u?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98216632-556c-4166-8ee8-08ddca949b57
X-MS-Exchange-CrossTenant-AuthSource: PUZPR06MB5676.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 09:29:36.8448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4BjIMyeaVKxcZ+Sh2i0jVN4NwI+rgQ5hINpeu/S/+tnwSxYhBvgJjKjjCD51/XnCKDir8DlQkEGLAcIUS800qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYSPR06MB6675
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AAE214000A
X-Rspamd-Server: rspam06
X-Stat-Signature: hx4yk4q83nknat6zkcwizo898yxgskq8
X-HE-Tag: 1753349381-797087
X-HE-Meta: U2FsdGVkX196wF7CXGJbQpZZAPduXPQsGYeMsJ+tRFsgkAHoRvOeYjyEQzMrZbBWEfJl+1VwS1zm9sgTZiAGZo+zawjqFu1rM+BiiryEFfx6tqvR3Vfk75wxehr7T8cvb+yhXZk6m3vFmog6URdh4AsoyQbc/Nj4BVOlXtEkb5HZUbwkx1A4mTCNYYGJGM3QtY0hQskGczlm+ottV2vRjX/5Elfd46VUwMuYRUfhMYmJkcI1rxnSd+ohDzyEYduub7u0LW3PgvV19/LYDQNtBPktCfALelrd5IfRLBFvFzaTaVt4BXj3xcbEXGCyr1ZfYhYj+Re9ODWLQ+qy+NUbrCrTNaNlvqo0h1yot8UULLd6qeKUCCuPOZyki8rIip8HUDs+NV3L/u5RsP7H9SndABagsRKshc+RX47lQ6JzbIKl4z5tYqQgLTiPn/hwSbhydXKorI2D3IGbzUtIks4Q5RPEUsrUYTQRfFnnF6yVAg/dgWLRi0XEMrrJIE9cskFQ2Xsbo5bPsCMDE+36IjAVeTk4OK8lDEeDagLhaIO5Wl5ho1PYRsCwgbMd9oFextBtvpNJnmV28M3aV1rMzz0CbVH4l0tOp6oduod2lrkAWV63jMQLBUfXKz5KIR/vE81IGYwqnXWarSjScoqOB+Vfh/UFeR8DE6pcB9LLe8S8RQfPsJngUQbZ3/tonc8XwwM01tYiaBFLouE6cWKhrWx6fyTWoSoEhuSY5pRzdnVETWT/KbdkoqkSGp44g3fGemm6TXAIEX4uQ58bnPnB8uYyoAmCJwKurKak1OOmeZy0gS+VG19VygRPr1bVclL15lRWEdn0Q7+hViw3SdAh9EhrNkJnNxnDCmEM3KBpvCOEVa3MUtzva89xjMh9IPlhLU/nysRYQnQjbAhxXmTRZm4VLCp/LWFbFCkDO8655o39i7+flNzOJuX0j8oCWkZLtZZRkpsKCI9TLRpPZR9rlYE
 JcZQB2vC
 SjYlNYwnK1po5fIRpTudk+hq7z3lTVFdMppPDQF1INv5qj32FEaxUAzohYcq1ZeuTewgx1Y2uIOWF9nONHv3YaadfCKVqvumHyyO8jp0RcCqj1e76hmOVVkOmUf+eIWRqgBY0kUzZwhPzJqxFWrB7M6kNVf4AXRpnZBEeiP9nS83mdrcynGDMW/MzVluOAE7I765m+qlvdqfvYyAZyzs4g5lLZAxNRooCRAWilrYNm+q1Yvmdb+qu2cn8AayZ6Vpkr3Qu9t8qcdlsME6d3MhS+E78d9DPU0H4Az/yXoX8oB+XBYrogpFnxCtBV2eJSGI1Fl/h/NFydLem44bZFWLP7FCGiIbB3GuRVczFTo905ZsQY1KTHNGkHb+hrgNdv86dLcaHGfwPNifsXXqyZJSh5zfKN2R5xlB0XP3AA6GnhsCFXLYsQbI0iKtxpGwzwUxJWHvP5OMORN10ett/efpqJo0/3glCgmqE7Dr7L4beccTQAENAajUJsnu0xJFsB7UTA0ZXjiJvT+yLuaqDXJMyXV5YUr2oTL7ROFIDfcKVjepHYPK+mNwO2fRJOhudycLXQU/ygdg3EkYX1xuL0dYbBRX64pm4uDgUNy9d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/7/24 17:15, Lorenzo Stoakes 写道:
> NAK. This series is completely un-upstreamable in any form.
>
> David has responded to you already, but to underline.
>
> The lesson here is that you really ought to discuss things with people in
> the subsystem you are changing in advance of spending a lot of time doing
> work like this which you intend to upstream.

Yes, this is a very useful lesson.:)

In the future, when I have ideas in this area, I will bring them up for 
discussion first, especially when

they involve folios or pages.

>
> On Thu, Jul 24, 2025 at 04:44:28PM +0800, Huan Yang wrote:
>> Summary
>> ==
>> This patchset reuses page_type to store migrate entry count during the
>> period from migrate entry setup to removal, enabling accelerated VMA
>> traversal when removing migrate entries, following a similar principle to
>> early termination when folio is unmapped in try_to_migrate.
>>
>> In my self-constructed test scenario, the migration time can be reduced
>> from over 150+ms to around 30+ms, achieving nearly a 70% performance
>> improvement. Additionally, the flame graph shows that the proportion of
>> remove_migration_ptes can be reduced from 80%+ to 60%+.
> This sounds completely contrived. I don't even know if you have a use case
> here.

The test case I provided does have an amplified effect, but the 
optimization it demonstrates is real. It's just that when scaled up to 
the system level, the effect becomes difficult to observe.

>
>> Notice: migrate entry specifically refers to migrate PTE entry, as large
>> folio are not supported page type and 0 mapcount reuse.
>>
>> Principle
>> ==
>> When a page removes all PTEs in try_to_migrate and sets up a migrate PTE
>> entry, we can determine whether the traversal of remaining VMAs can be
>> terminated early by checking if mapcount is zero. This optimization
>> helps improve performance during migration.
>>
>> However, when removing migrate PTE entries and setting up PTEs for the
>> destination folio in remove_migration_ptes, there is no such information
>> available to assist in deciding whether the traversal of remaining VMAs
>> can be ended early. Therefore, it is necessary to traversal all VMAs
>> associated with this folio.
>>
>> In reality, when a folio is fully unmapped and before all migrate PTE
>> entries are removed, the mapcount will always be zero. Since page_type
>> and mapcount share a union, and referring to folio_mapcount, we can
>> reuse page_type to record the number of migrate PTE entries of the
>> current folio in the system as long as it's not a large folio. This
>> reuse does not affect calls to folio_mapcount, which will always return
>> zero.
> OK so - if you ever find yourself thinking this way, please stop. We are in
> the midst of fundamentally changing how folios and pages work.
>
> There is absolutely ZERO room for reusing arbitrary fields in this way. Any
> series that attempts to do this will be rejected.
>
> Again, I must say - if you had raised this ahead of time we could have
> saved you some effort.
>
>> Therefore, we can set the folio's page_type to PGTY_mgt_entry when
>> try_to_migrate completes, the folio is already unmapped, and it's not a
>> large folio. The remaining 24 bits can then be used to record the number
>> of migrate PTE entries generated by try_to_migrate.
> I mean there's so much wrong here. The future is large folios. Making some
> fundamental change that relies on not-large folio is a mistake. 24
> bits... I mean no.
Thanks, I understand it.
>
>> Then, in remove_migration_ptes, when the nr_mgt_entry count drops to
>> zero, we can terminate the VMA traversal early.
>>
>> It's important to note that we need to initialize the folio's page_type
>> to PGTY_mgt_entry and set the migrate entry count only while holding the
>> rmap walk lock.This is because during the lock period, we can prevent
>> new VMA fork (which would increase migrate entries) and VMA unmap
>> (which would decrease migrate entries).
> No, no no. NO.
>
> You are not introducing new locking complexity for this.
>
> I could go on, but there's no point.
>
> This series is not upstreamable, NAK.
>

