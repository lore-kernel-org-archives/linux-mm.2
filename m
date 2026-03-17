Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A6EFB5E90
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 00:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376ED6B03C5; Mon, 16 Mar 2026 20:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34EA36B03C6; Mon, 16 Mar 2026 20:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216D46B03C7; Mon, 16 Mar 2026 20:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0DC66B03C5
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 20:21:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5DC278A67D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:15:12 +0000 (UTC)
X-FDA: 84553635264.13.9B0FC6E
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11020106.outbound.protection.outlook.com [52.101.56.106])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5AD8C18000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:15:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ZYfECa6p;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.56.106 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773706509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTsJrooZAGG/3jW7/PFsKrYVAG5E8SRmkAReZoeiefs=;
	b=LS+mdQCFT9SurpYGuoIp/W5azEeLTjERxnatYKN0rt+ZZT51+wP34TcsHwKy4eRopk0/1E
	Bf9INwKbEXRaXc3yi0aEOq6RKtoPaf4gba+woLFYy4o6JUvogGHE4BKhcBjsX9etFvuSpc
	nOwdTvFvH5ZHBrFpmWVjifx4qkIj+XU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=ZYfECa6p;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	spf=pass (imf16.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.56.106 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773706509; a=rsa-sha256;
	cv=pass;
	b=C6+QRAXWl5UKHfD7If60yYgIF3l3jQsFHF4kIfdERoxaCZ2Ldisw3tTzMSm4EZicRdcq72
	copu2xMl1DkNFzDtpMRbNlYdLuHPcyzeqTBXUmDSVHK4C/amedAZlLf+GOfls3EKOkDdux
	H3qxWEz1vb907T6RW0a037zsAO8OE+Q=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kmeNoy7nDYBj4JhpE2+LRkWIdrABsil4PDdVMSxlTdNFY3Fb1NbXoz/FrN3LHdKtcOSzegHvRcf56FeapQ1R3ZxcBfNXwbosL4VJSJfE0HAiFiy5Com7/TmAKtzWHoWet3oQWxA2IeZCd2tRNMtqtE/xJpNF9UtOjWdPu1Q/i3PICYlIYOezVJDfBydmoFeO4R4ZNo3Wzd0xAu9QtVSUjmXNTr2xgCn3+W9m5a3zSxiQTTZw+snWaSjM1bVaQOXM43cSECc+TM/XHoWYXfpwr4Ha8dWoryscz4ngcOsdU2xtBwdpZSmzIL20S+8NhQ2ciUOgNnfXN4drtfvX/H90jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tTsJrooZAGG/3jW7/PFsKrYVAG5E8SRmkAReZoeiefs=;
 b=dhJ4lllVWiSIeAHXIZzoPg3D5Xjaqh7eANj+/HK26uAR/ysAtVm5N1MA4lyJxo9tCt4lN9kYeqNQw8lpQxKK2nlQ+5msWHggQYtSc7pslNq60zWwBSkykiRMy29zJtcXde8hnUXZlzm9MKdXMJ3H+rGC+49wNZkPk2NpenR2/na+8HGebm0oqg8kcNrMpaO/jOBQRwZpxvp4frGu2FRbQZi0ckZweD8ZJfwnlB9SGrXUPRNKl8VAXQCsHttLbAXtrDj3lYK2QVefRJGoDwE5OwZAmcU3tPnEoYKllSMJjgAkNDQGPjUB1loQHFC2NZ1jk5ZhyGTWea8dbMJUZkaHVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tTsJrooZAGG/3jW7/PFsKrYVAG5E8SRmkAReZoeiefs=;
 b=ZYfECa6pJUrGkZh4+k+Cork41tFIB6Iw+K17d+FmDYds0paP1eW67Hu1bG4T8euuFlH8rNLebGWz4nOoTtrPiDs8jzfHrKSdar7A6Jv32MsOB2dGh2e6gpMntjk627OXv9UjbJxBiS7BCnkXsdUSmCgtDLl+btkikr4z9K2/uwI=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 SA1PR01MB994067.prod.exchangelabs.com (2603:10b6:806:4a7::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.22; Tue, 17 Mar 2026 00:14:47 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::46eb:64a3:667c:c1a0%4]) with mapi id 15.20.9700.021; Tue, 17 Mar 2026
 00:14:56 +0000
Message-ID: <0a740020-4780-4156-a9c5-f8b4ada9c8c0@os.amperecomputing.com>
Date: Mon, 16 Mar 2026 17:15:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>, Jinjiang Tu <tujinjiang@huawei.com>,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org,
 Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <0b2a4ae5-fc51-4d77-b177-b2e9db74f11d@huawei.com>
 <de0b06cf-15a5-4109-b339-75c10d9b8a18@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <de0b06cf-15a5-4109-b339-75c10d9b8a18@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0114.namprd03.prod.outlook.com
 (2603:10b6:a03:333::29) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|SA1PR01MB994067:EE_
X-MS-Office365-Filtering-Correlation-Id: c6dd19ae-59f9-4aa8-ad6d-08de83ba3864
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020|18002099003|56012099003|22082099003|55112099003;
X-Microsoft-Antispam-Message-Info:
	La1m9VqcDjBWJjwS8/t8dEW5tRZ/TICTLqbJ+WP9mWKR3WYhZbJ8F3c+p/cscd9yu/EN6OUP4jEUC7w0DP67rPQQnSW9XP427YDPqCEOb+jn6hXiW1hE5C5Xy9qSVItJesYRzi0mu7FBhQfLitrOf5dshXs8iywPt+LXCiaL2HPTVjhSQd0R+sL1+RSRAbKCvm+sU98QygLr8lNHIB2as/C16VtecIHctDI+uvAvefiKybE8A/K2a99PHW/kwgFTwjZwW/X/HkvxJAOH9VGU1wTFdrDmkfUCYiDhoMMn/iPoyhDlwmWyBEqz53RICV4m1augC4fymZllumyDKaIzWxYZwjYW/AD83ueGpRvH0HWBhQF6Wfcw+2Qav5AUYxqTSaNYrg7bZ6ppsDSB641Fg8HHvBb5AUhXYDy/JZ7fOe/OGwRSOmGpd6rN6/tipomLJPaPSoCiIQdduM8ASU7toSpQytVEcjL09M5PzaZCcLeb9KglyOS9vtUfN/La0yV5REPC0v8Wt5sUz3MpttF+XmAil4EMvxzr/IvMy8LJHnGeOe7ccAxxkn0pgzC3+2QF+I7Y2r2sWavl2dZTlQtfk7C3jRV6PTKqIPlIO0kb1qUEXbrfWe1LkHM3N+utX+V0NpUpu5tMpPl0peXxGkqBkjQYiCcUBM89Ou74hPn2CebgmZKckKDRukvgV/+9msL0ORslIpT0sIotX8tnDYYMDEdf8UfgM8Mw60GIty7qtpxC0IaV0YfUSqhGgeP05pg9z4LqIe3fM+ggHygKpU3w9DxFtufv67Im0bJiTZ5VAYY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020)(18002099003)(56012099003)(22082099003)(55112099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?a1o3QVZuSlpnYTVuZldYZVN1dHplbDVrN2JxdEZnbDg2M3FCbUdyNXppWlhB?=
 =?utf-8?B?eVduRHVZdnJPVm0xZDJqZTNDYUNGR1JiUlRLcUZsYzN1aW1KajdiSGtLb3R1?=
 =?utf-8?B?NTduZWx4WUZMNXpRRXNMTS9ZNnl4MjZYbDByblRORDR6ejJwSXJ6ajR5bG0v?=
 =?utf-8?B?SElPQmdYZUxBeXh6Ny9PK05CTUJxeXRIQ1pNRGJaWEJCckljS2JkNzFYbk9R?=
 =?utf-8?B?ZGFWcjIxN2thNFRmNk5ybTJUcEtLejRMR3d0bFBoSmRMMUtHNEljc24xM0JN?=
 =?utf-8?B?enh4SDlEZ0M5M09FREIzWFl4TFJ2cEQ5SzlXNTB0SzZYMDAwd012Z3k3TDc2?=
 =?utf-8?B?aFhtWGdNV3JhUFhxL1pmUmVjVFhnMVBFMnphaSsrY3lPdDZlU2svZ1kwZ3VM?=
 =?utf-8?B?WEdPNlgyZjh3T0xHdnorTHJKUmdBdWNLdzAwUkJxYndmU1FVbCt5ZGFwanRw?=
 =?utf-8?B?RTd4VTlOUjhyVlNYK2JKMkJXcEhTNGIybmlia2VpNUliOTJvRVRaZFFUUmxy?=
 =?utf-8?B?eEYwSUF5eGJkSmI0ZUdpQTdTNmRaYjErbklBUUd5ams4cllhbXd5TFVrckZD?=
 =?utf-8?B?S2g5eXlVZjVYcVhZZXVMUHFlc0x5RHRCUGhYanZuSzE4bUJFakt2cE80ZjRN?=
 =?utf-8?B?bC9YTlJNTU8zZXNZTk50R1BhUmpHR0NOYW9ab0NYVUZHVFU1L29wZEUvMUg3?=
 =?utf-8?B?bWhZMVZIRnlvbGF0ZGxtVDRpZXRmaUJocTZoY2lFU2lJTU1HMEpxRFMvOGp4?=
 =?utf-8?B?THZoKy9maWRrZVJlZ0JvQmVydkFGTWQ5dDNQR0hLNURzM2xZV3dtSlZOVFdL?=
 =?utf-8?B?QWtETk8vU05aSERFditaSFowOUdiZExnL1FpejdJeldOUzl5c0tUQUpSUVJL?=
 =?utf-8?B?UTB1QTFiTkpZVDRZazdocGhsTmJuT0N5Q1lmSVlvbWU2RHpFQmdsYUxYSjdo?=
 =?utf-8?B?NHl0TVNPcFlSOHNoZ2tUQlc0ZDQyanNYcm5hNnU4RlZ2ZkIxbUxybDRQdHlI?=
 =?utf-8?B?MlI5U0hmYlNBTktTWHErYkMzc0lKWEJ5eE9EVGFyeTBwYkRLMGhONDFDT3BX?=
 =?utf-8?B?Z1dXRit5Q0N5ZTIwTU1WUHdKNEFYVDZSOGlaRjUydFAzV0p4TmRDUWtlenRo?=
 =?utf-8?B?T01NME1VdFZudE0xK210QWtPVXRWRjlRZ2UzdFJYWTJCbTNUNFA1ZzlxS3pq?=
 =?utf-8?B?SXdNUENiNEJCWXVoeTlsM2ZYNk91MURINENpd3ZwV1o2SkhPbVhQaWFad3VQ?=
 =?utf-8?B?RUxGUUVNN1BJWkc2aHJxTGFqd25mZU16bUVzL1doVHFHT2dYVS9WTHc4MlEz?=
 =?utf-8?B?MWNqVkc2Y1R4ZjhPWUV1T0tZbVhpc0Y1Q0JYcVJFTTg1VFlGVGdsMVdjdVFT?=
 =?utf-8?B?Y1J0a0lTbXhzY2lJN2R0TmhrYldhbk45TE8vMWVSZmNsZnFwb3BWQVdQam5x?=
 =?utf-8?B?bXJ0bC9wTzFxS3JoWG8wYnRhNldxczVrMjAyWE5IVWF5Z0xJTWs3YkMrcFhU?=
 =?utf-8?B?YnowWXd5L2k5dmhxQk1BeG1Dd0JjRU1zS0ZMam15MmtWNjYwam9JYkMvalpz?=
 =?utf-8?B?SnMvbVdORXkrMTJ3aEdVZi9ZZGFKdHJ5WFdVeWprTnB5L09iTUNwSU8xWkRT?=
 =?utf-8?B?SW5nNHpsNG11c1d4MWxqcEt1NDJ6bG1NOW5QOW95UXRlN2s5TUpQTFQ4c1gv?=
 =?utf-8?B?SzM4ZVBuV1hGRTNaakt4V0FQVWRqa1h0ZktuSzROcVlGeTFFNDVtMGZWcnI3?=
 =?utf-8?B?TmhGSlRFd2xvdFN4RVlOWDNPWXUzR0pyU3ljRmxnNHdyUGxZY2M1Yi9zMnQ3?=
 =?utf-8?B?L0JTdVFaTy9ldStsLzVWTzkwOTgvVXQwTm9FUGtuclR5M2twWGhpWXQzMW41?=
 =?utf-8?B?WDZjSGYzUnBleFpkZmhHaHVIK3RxZmQydmxpSk5uanJRTFVDQlZReFRuRXdx?=
 =?utf-8?B?QmtPVklBYUJ1VTJ2S2Z5WGtEenZuZEhGYzFtQ0VxOUNPb2JPQ1ZDZW9BV01J?=
 =?utf-8?B?TkZLUEYvN2E5eW9wZ2VYaTliZWlyOFNjK1BDZkZ4OVJ5T3VmY3hObjYvRmk2?=
 =?utf-8?B?SjBYY0VJRHlZV2tNbHROb0tSQ2I4V2ZMSDB4bk83Nys1Ylo4RDZwY2RCaWtM?=
 =?utf-8?B?VTFIVGxOWDdnZG0zZWtRNE9ua3ZNd3d1d1BRL0FYSGhUWFkzWk5qdjh6RlJs?=
 =?utf-8?B?alprV3MwR2MzeDQwbkh2SitScTF6Z1JscTZKOHM0aHlvSnpIczdnRHdIaHNr?=
 =?utf-8?B?SEZ0RFU1VjdhWGxIM09xRGhkbGp0UEJheWdOaFRDNnZTam92UXVqWWpiQ1Zz?=
 =?utf-8?B?YVU1eS9UZnpvV3R5bTZpN3JsM1MzWEwyUldIbUVCeDJHR0E4YVgxWXB1czBU?=
 =?utf-8?Q?nOZKPXYcPxYYeehQ=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6dd19ae-59f9-4aa8-ad6d-08de83ba3864
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 00:14:56.8583
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3GU4KbfHEI9FaCNRgdeD44HE9avyLlRbslQ7ErDOJA0j04q4/0kitCOVwDhe97gdscKOD+5Ii/dLyqyhfAmvhQ2PoezLbi+Ejk5UJytLWI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR01MB994067
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5AD8C18000D
X-Stat-Signature: 77j5erhz5wo5otw4cr81dqgu39t4g4qc
X-Rspam-User: 
X-HE-Tag: 1773706509-689196
X-HE-Meta: U2FsdGVkX19E9HqmNYqnWmShQIkYwu/mEJYABiRrHMoXbXoKsTDxrKwj9LWcaBWFQJJQagvF9vxWnhMgCB7GqFZihyhGUeLM/jZkHWpteZO2fCuH26TBG4EteQu9+EN76jJ+8U3D2ZG4qMqHk0fGG9dpIFvrX17Rnpg/8GClr6M9jYaouRkw345y+npwnThzkfPuViFrnj1lTbGdCfGZRjdLrnEzwhTNL2nJ8iYA3PxgqIXkI91dy9oSS8c3GZRe0OMkebhKunWl9dQaDKXrQAArJGF6eK4iKK/qVR1NldLc0XkcdN9lQ5W7I6vAFnBoXfYn1maQw40D0j3VaAqULRrbGV4rfGqBZ5wbgAquV8xIINl7bcG7zGvN4y55NBqEl3xXOYHeBhR72PFlxUWHCiguf5+HFlEpTi/HUWl0IjqNGKH0uUpiI5Uizqy2QhoRmKixRfQ7yIoiiTzFNSB41P/dHHbVaCiNdCPOfVYLke0ptcY8E/IMT9A2Ihkfy+/O3C2FisOf46TtNjrxokcS0J2EKD8I/4ZRt1Z1+rSuNQPL6HpjdYB4jhfPwKAmhUU/rYF0gg8sKYOnAhRRAZskiq8rEDEco3J325WtXIcZigwv1DxnsPLXhlQqt/OPB7Ir6fMdGlHHWO4gmRhGyLr2h9pUREUubjCxGZvcWMp0odz2wR4LYLHBJ/Gbonycf9QExH6ToxEJ30aPvOoMW57gGk7lwGRXy1ftVNWv59VuqEHyhib0N1E5WNZXUNKq13W+kH4G8EOYu/HBA6o3LRS+Y1+hBP0u1TgwlebhEJurE8a8mkDFnmCm/A1zi1ZSH3zBAoB2xgTaoczA7JV8yYyh9TzZbtMUDdMmfqBx7fEiKQn0RcrSuUZelFh3AXf+D6cO87GeG669ttdaY4Ufgf/LCJTv8bf2Gn7DxYFf3eO39kuPWyqmTUV5JYFrWu+Wbv1iIg61YPhl97ZSxYYAUwN
 hSSDfSu/
 VTdL9srdYgY5xeXeAxxq8PNpPhixqlPlVjpbfE1e67c6AzVSDtP0ec3B27K8U68IVBdOwYeSwH+0NY/ElV53VYtkUEk0AIj3AupFc4r2oCkLi5gaCTbzL4wXJgEyFiAt3xeZKJ7L+bFJo+hjaajBgOkuC12GKYIGWVOJcax4uM/kRXkeLZkwaW6iTIYO6Xe25YI2QtPQuHakUYUHF6xRg7+eeD+dFr7hghVq/zYze2f7RJ294PzJIMHmTE4Y6/tRsowhCSpeiHmDALUF67Dse+2vs6kwUqucHmJXGweQVoWn9+1HNKWx4m7k0X4mluxwareyfchKt6ug0dNa9/2F/+dx64CtaqtjztMEy46XQSrv8D4nAcWqMqW6qtPhVQM2uzzaLV39W6uFAzDgokPeTdCozfxSDSIaYSOaRcy8oxRbobm6TqSaerNJjAr4hWtTdn4CttbmR5hJYT+a6RLXs5V1EVVHmm7503BVP16dCQn+eQiesgr87ebfsUi3o5xSZAR/ABhaBrgplaZDuOPt23GAo1kcrC5uNgxvDTMqFqsfCW4nxh19BvSjXt/mnKdi0FB6wb7sPdweMOGKVTlVuOQTV8316LUSLCVU7J+7cjAKibhFrWlgVNk7uehCya4pXih+Aj+hKuNc8aEzlFYh0zOBdww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/16/26 8:47 AM, Ryan Roberts wrote:
> Thanks for the report!
>
> + Kevin, who was looking at some adjacent issues and may have some ideas for how
> to fix.
>
>
> On 16/03/2026 07:35, Jinjiang Tu wrote:
>> 在 2025/9/18 3:02, Yang Shi 写道:
>>> On systems with BBML2_NOABORT support, it causes the linear map to be mapped
>>> with large blocks, even when rodata=full, and leads to some nice performance
>>> improvements.
>> Hi,

Hi Jinjiang,

Thanks for reporting the problem.

>>
>> I find this feature is incompatible with realm. The calltrace is as follows:
>>
>> [    0.000000][    T0] ------------[ cut here ]------------
>> [    0.000000][    T0] WARNING: CPU: 0 PID: 0 at arch/arm64/mm/pageattr.c:56
>> pageattr_pmd_entry+0x60/0x78
>> [    0.000000][    T0] Modules linked in:
>> [    0.000000][    T0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.6.0 #16
>> [    0.000000][    T0] Hardware name: linux,dummy-virt (DT)
>> [    0.000000][    T0] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS
>> BTYPE=--)
>> [    0.000000][    T0] pc : pageattr_pmd_entry+0x60/0x78
>> [    0.000000][    T0] lr : walk_pmd_range.isra.0+0x170/0x1f0
>> [    0.000000][    T0] sp : ffffcb90a0f337d0
>> [    0.000000][    T0] x29: ffffcb90a0f337d0 x28: 0000000000000000 x27:
>> ffff0000035e0000
>> [    0.000000][    T0] x26: ffffcb90a0f338f8 x25: ffff00001fff60d0 x24:
>> ffff0000035d0000
>> [    0.000000][    T0] x23: 0400000000000001 x22: 0c00000000000001 x21:
>> ffff0000035dffff
>> [    0.000000][    T0] x20: ffffcb909fe3b7f0 x19: ffff0000035e0000 x18:
>> ffffffffffffffff
>> [    0.000000][    T0] x17: 7220303030303178 x16: 307e303030306435 x15:
>> ffffcb90a0f334c8
>> [    0.000000][    T0] x14: 0000000000000000 x13: 205d305420202020 x12:
>> 5b5d303030303030
>> [    0.000000][    T0] x11: 00000000ffff7fff x10: 00000000ffff7fff x9 :
>> ffffcb909f1e27d8
>> [    0.000000][    T0] x8 : 00000000000bffe8 x7 : c0000000ffff7fff x6 :
>> 0000000000000001
>> [    0.000000][    T0] x5 : 0000000000000001 x4 : 0078000083400705 x3 :
>> ffffcb90a0f338f8
>> [    0.000000][    T0] x2 : 0000000000010000 x1 : ffff0000035d0000 x0 :
>> ffff00001fff60d0
>> [    0.000000][    T0] Call trace:
>> [    0.000000][    T0]  pageattr_pmd_entry+0x60/0x78
>> [    0.000000][    T0]  walk_pud_range+0x124/0x190
>> [    0.000000][    T0]  walk_pgd_range+0x158/0x1b0
>> [    0.000000][    T0]  walk_kernel_page_table_range_lockless+0x58/0x98
>> [    0.000000][    T0]  update_range_prot+0xb8/0x108
>> [    0.000000][    T0]  __change_memory_common+0x30/0x1a8
>> [    0.000000][    T0]  __set_memory_enc_dec.part.0+0x170/0x260
>> [    0.000000][    T0]  realm_set_memory_decrypted+0x6c/0xb0
>> [    0.000000][    T0]  set_memory_decrypted+0x38/0x58
>> [    0.000000][    T0]  its_alloc_pages_node+0xc4/0x140
>> [    0.000000][    T0]  its_probe_one+0xbc/0x3c0
>> [    0.000000][    T0]  its_of_probe.isra.0+0x130/0x220
>> [    0.000000][    T0]  its_init+0x160/0x2f8
>> [    0.000000][    T0]  gic_init_bases+0x1fc/0x318
>> [    0.000000][    T0]  gic_of_init+0x2a0/0x300
>> [    0.000000][    T0]  of_irq_init+0x238/0x4b8
>> [    0.000000][    T0]  irqchip_init+0x20/0x50
>> [    0.000000][    T0]  init_IRQ+0x1c/0x100
>> [    0.000000][    T0]  start_kernel+0x1ec/0x4f0
>> [    0.000000][    T0]  __primary_switched+0xbc/0xd0
>> [    0.000000][    T0] ---[ end trace 0000000000000000 ]---
>> [    0.000000][    T0] ------------[ cut here ]------------
>> [    0.000000][    T0] Failed to decrypt memory, 16 pages will be leaked
>>
>> realm feature relies on rodata=full to dynamically update kernel page table prot.
>>
>> In init_IRQ(), realm_set_memory_decrypted() is called to update kernel page
>> table prot.
>> At this time, secondary cpus aren't booted, BBML2 noabort feature isn't
>> initializated,
>> and system_supports_bbml2_noabort() still returns false. As a result,
>> split_kernel_leaf_mapping() is skipped, leading to WARN_ON_ONCE((next - addr) !=
>> PMD_SIZE)
>> in pageattr_pmd_entry().
> If no secondary cpus are yet running, then it is technically safe to split
> because we know all online cpus (i.e. just the boot cpu) supports BBML2_NOABORT.
> So we could explicitly only disallow splitting during the window between booting
> secondary cpus and finalizing the system caps. Feels a bit hacky though...

I think we can check whether system feature has been finalized or not. 
If it has not been finalized yet, we just need to check whether the 
current cpu (should be just boot cpu) supports BBML2_NOABORT or not. It 
sounds ok to me.

>
>> Before setup_system_features(), we don't know if all cpus support BBML2 noabort,
>> and we
>> couldn't split kernel page table, in case another cpu that doesn't support BBML2
>> noabort
>> is running.
>>
>> How could we fix this issue?
>>
>> 1. force pte mapping if realm feature is enabled? Although force_pte_mapping()
>> return true if is_realm_world() return true, arm64_rsi_init() is called after
>> map_mem(). So is_realm_world() still return false during map_mem(). Thus
>> realm feature relies on rodata=full. If we fix by this solution, we need
>> to add a new cmdline to force pte mapping.

I don't quite get why is_realm_world() relies on rodata=full. I 
understand realm needs PTE mapping if BBML2_NOABORT is not supported. 
But it doesn't mean real relies on rodata=full.

> I think we just need to make is_realm_world() work earlier in boot? I think this
> has been a known issue for a while. Not sure if there is any plan to fix it
> though.
>
>> 2. If we could try to split kernel page table before setup_system_features()?
> Another option would be to initially map by pte then collapse to block mappings
> once we have determined that all cpus support BBML2_NOABORT. We originally opted
> not to do that because it's a tax on symetric systems. But we could throw in the
> towel if it's the least bad solution we can come up with for solving this. I
> think it might help some of Kevin's use cases too?

May be an option too. When we discussed this there was no usecase for 
direct mapping collapse. But if we can have multiple usecases, it may be 
worth it. AFAICT, the ROX execmem cache may need this, which Will or 
someone else from Google is going to work on.

Checking current cpu BBML2_NOABORT capability before system feature is 
finalized seems like a fast way to stop bleeding IMHO before we find 
more elegant long-term solution.

Thanks,
Yang

>
> Thanks,
> Ryan
>
>
>> Thanks.
>>
>>> Ryan tested v7 on an AmpereOne system (a VM with 12G RAM) in all 3 possible
>>> modes by hacking the BBML2 feature detection code:
>>>
>>>     - mode 1: All CPUs support BBML2 so the linear map uses large mappings
>>>     - mode 2: Boot CPU does not support BBML2 so linear map uses pte mappings
>>>     - mode 3: Boot CPU supports BBML2 but secondaries do not so linear map
>>>       initially uses large mappings but is then repainted to use pte mappings
>>>
>>> In all cases, mm selftests run and no regressions are observed. In all cases,
>>> ptdump of linear map is as expected. Because there are just some cleanups
>>> between v7 and v8, so I kept using Ryan's test result:
>>>
>>> Mode 1:
>>> =======
>>> ---[ Linear Mapping start ]---
>>> 0xffff000000000000-0xffff000000200000           2M PMD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000000200000-0xffff000000210000          64K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000000210000-0xffff000000400000        1984K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL
>>> 0xffff000000400000-0xffff000002400000          32M PMD       ro NX SHD
>>> AF        BLK UXN    MEM/NORMAL
>>> 0xffff000002400000-0xffff000002550000        1344K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL
>>> 0xffff000002550000-0xffff000002600000         704K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000002600000-0xffff000004000000          26M PMD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000004000000-0xffff000040000000         960M PMD       RW NX SHD AF
>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000040000000-0xffff000140000000           4G PUD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000140000000-0xffff000142000000          32M PMD       RW NX SHD AF
>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142000000-0xffff000142120000        1152K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142120000-0xffff000142128000          32K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142128000-0xffff000142159000         196K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142159000-0xffff000142160000          28K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142160000-0xffff000142240000         896K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142240000-0xffff00014224e000          56K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff00014224e000-0xffff000142250000           8K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142250000-0xffff000142260000          64K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142260000-0xffff000142280000         128K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142280000-0xffff000142288000          32K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142288000-0xffff000142290000          32K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142290000-0xffff0001422a0000          64K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff0001422a0000-0xffff000142465000        1812K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142465000-0xffff000142470000          44K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142470000-0xffff000142600000        1600K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000142600000-0xffff000144000000          26M PMD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000144000000-0xffff000180000000         960M PMD       RW NX SHD AF
>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000180000000-0xffff000181a00000          26M PMD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181a00000-0xffff000181b90000        1600K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181b90000-0xffff000181b9d000          52K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181b9d000-0xffff000181c80000         908K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181c80000-0xffff000181c90000          64K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181c90000-0xffff000181ca0000          64K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181ca0000-0xffff000181dbd000        1140K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181dbd000-0xffff000181dc0000          12K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181dc0000-0xffff000181e00000         256K PTE       RW NX SHD AF
>>> CON     UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181e00000-0xffff000182000000           2M PMD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000182000000-0xffff0001c0000000         992M PMD       RW NX SHD AF
>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff0001c0000000-0xffff000300000000           5G PUD       RW NX SHD
>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>> 0xffff000300000000-0xffff008000000000         500G PUD
>>> 0xffff008000000000-0xffff800000000000      130560G PGD
>>> ---[ Linear Mapping end ]---
>>>
>>> Mode 3:
>>> =======
>>> ---[ Linear Mapping start ]---
>>> 0xffff000000000000-0xffff000000210000        2112K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000000210000-0xffff000000400000        1984K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL
>>> 0xffff000000400000-0xffff000002400000          32M PMD       ro NX SHD
>>> AF        BLK UXN    MEM/NORMAL
>>> 0xffff000002400000-0xffff000002550000        1344K PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL
>>> 0xffff000002550000-0xffff000143a61000     5264452K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000143a61000-0xffff000143c61000           2M PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000143c61000-0xffff000181b9a000     1015012K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181b9a000-0xffff000181d9a000           2M PTE       ro NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000181d9a000-0xffff000300000000     6261144K PTE       RW NX SHD
>>> AF            UXN    MEM/NORMAL-TAGGED
>>> 0xffff000300000000-0xffff008000000000         500G PUD
>>> 0xffff008000000000-0xffff800000000000      130560G PGD
>>> ---[ Linear Mapping end ]---
>>>
>>>
>>> Performance Testing
>>> ===================
>>> * Memory use after boot
>>> Before:
>>> MemTotal:       258988984 kB
>>> MemFree:        254821700 kB
>>>
>>> After:
>>> MemTotal:       259505132 kB
>>> MemFree:        255410264 kB
>>>
>>> Around 500MB more memory are free to use.  The larger the machine, the
>>> more memory saved.
>>>
>>> * Memcached
>>> We saw performance degradation when running Memcached benchmark with
>>> rodata=full vs rodata=on.  Our profiling pointed to kernel TLB pressure.
>>> With this patchset we saw ops/sec is increased by around 3.5%, P99
>>> latency is reduced by around 9.6%.
>>> The gain mainly came from reduced kernel TLB misses.  The kernel TLB
>>> MPKI is reduced by 28.5%.
>>>
>>> The benchmark data is now on par with rodata=on too.
>>>
>>> * Disk encryption (dm-crypt) benchmark
>>> Ran fio benchmark with the below command on a 128G ramdisk (ext4) with
>>> disk encryption (by dm-crypt).
>>> fio --directory=/data --random_generator=lfsr --norandommap            \
>>>       --randrepeat 1 --status-interval=999 --rw=write --bs=4k --loops=1  \
>>>       --ioengine=sync --iodepth=1 --numjobs=1 --fsync_on_close=1         \
>>>       --group_reporting --thread --name=iops-test-job --eta-newline=1    \
>>>       --size 100G
>>>
>>> The IOPS is increased by 90% - 150% (the variance is high, but the worst
>>> number of good case is around 90% more than the best number of bad
>>> case). The bandwidth is increased and the avg clat is reduced
>>> proportionally.
>>>
>>> * Sequential file read
>>> Read 100G file sequentially on XFS (xfs_io read with page cache
>>> populated). The bandwidth is increased by 150%.
>>>
>>> Additionally Ryan also ran this through a random selection of benchmarks on
>>> AmpereOne. None show any regressions, and various benchmarks show statistically
>>> significant improvement. I'm just showing those improvements here:
>>>
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | Benchmark            | Result
>>> Class                                             | Improvement vs 6.17-rc1 |
>>> +======================+==========================================================+=========================+
>>> | micromm/vmalloc      | full_fit_alloc_test: p:1, h:0, l:500000
>>> (usec)           |              (I) -9.00% |
>>> |                      | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000
>>> (usec) |              (I) -6.93% |
>>> |                      | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000
>>> (usec) |              (I) -6.77% |
>>> |                      | pcpu_alloc_test: p:1, h:0, l:500000
>>> (usec)               |              (I) -4.63% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | mmtests/hackbench    | process-sockets-30
>>> (seconds)                             |              (I) -2.96% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | mmtests/kernbench    | syst-192
>>> (seconds)                                       |             (I) -12.77% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | pts/perl-benchmark   | Test: Interpreter
>>> (Seconds)                              |              (I) -4.86% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | pts/pgbench          | Scale: 1 Clients: 1 Read Write
>>> (TPS)                     |               (I) 5.07% |
>>> |                      | Scale: 1 Clients: 1 Read Write - Latency
>>> (ms)            |              (I) -4.72% |
>>> |                      | Scale: 100 Clients: 1000 Read Write
>>> (TPS)                |               (I) 2.58% |
>>> |                      | Scale: 100 Clients: 1000 Read Write - Latency
>>> (ms)       |              (I) -2.52% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>> | pts/sqlite-speedtest | Timed Time - Size 1,000
>>> (Seconds)                        |              (I) -2.68% |
>>> +----------------------
>>> +----------------------------------------------------------
>>> +-------------------------+
>>>
>>> Changes since v7 [1]
>>> ====================
>>> - Rebased on v6.17-rc6 and Shijie's rodata series (https://git.kernel.org/pub/
>>> scm/linux/kernel/git/arm64/linux.git/commit/?id=bfbbb0d3215f)
>>>     which has been picked up by Will.
>>> - Patch 1: Fixed pmd_leaf/pud_leaf issue since the code may need to change
>>>     permission for invalid entries per Jinjiang Tu.
>>> - Patch 1: Removed pageattr_pgd_entry and pageattr_p4d_entry per Ryan.
>>> - Used (-1ULL) instead of -1 per Catalin.
>>> - Added comment about arm64 lazy mmu allow sleeping per Ryan.
>>> - Squashed patch #4 in v7 into patch #3.
>>> - Squashed patch #6 in v7 into patch #4.
>>> - Added patch #5 to fix a arm64 kprobes bug. It guarantees set_memory_rox()
>>>     is called before vfree(). It can go into separately or with this series
>>>     together.
>>> - Collected all the R-bs and A-bs.
>>>
>>> Changes since v6 [2]
>>> ====================
>>> - Patch 1: Minor refactor to implement walk_kernel_page_table_range() in terms
>>>     of walk_kernel_page_table_range_lockless(). Also lead to adding *pmd argument
>>>     to the lockless variant for consistency (per Catalin).
>>> - Misc function/variable renames to improve clarity and consistency.
>>> - Share same syncrhonization flag between idmap_kpti_install_ng_mappings and
>>>     wait_linear_map_split_to_ptes, which allows removal of bbml2_ptes[] to save
>>>     ~20K from kernel image.
>>> - Only take pgtable_split_lock and enter lazy mmu mode once for both splits.
>>> - Only walk the pgtable once for the common "split single page" case.
>>> - Bypass split to contpmd and contpte when spllitting linear map to ptes.
>>>
>>> [1] https://lore.kernel.org/linux-arm-kernel/20250829115250.2395585-1-
>>> ryan.roberts@arm.com/
>>> [2] https://lore.kernel.org/linux-arm-kernel/20250805081350.3854670-1-
>>> ryan.roberts@arm.com/
>>>
>>>
>>> Dev Jain (1):
>>>         arm64: Enable permission change on arm64 kernel block mappings
>>>
>>> Ryan Roberts (1):
>>>         arm64: mm: split linear mapping if BBML2 unsupported on secondary CPUs
>>>
>>> Yang Shi (3):
>>>         arm64: cpufeature: add AmpereOne to BBML2 allow list
>>>         arm64: mm: support large block mapping when rodata=full
>>>         arm64: kprobes: call set_memory_rox() for kprobe page
>>>
>>>    arch/arm64/include/asm/cpufeature.h |   2 +
>>>    arch/arm64/include/asm/mmu.h        |   3 +
>>>    arch/arm64/include/asm/pgtable.h    |   5 ++
>>>    arch/arm64/kernel/cpufeature.c      |  12 +++-
>>>    arch/arm64/kernel/probes/kprobes.c  |  12 ++++
>>>    arch/arm64/mm/mmu.c                 | 422 ++++++++++++++++++++++++++++++++++
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>>>    arch/arm64/mm/pageattr.c            | 123 ++++++++++++++++++++++++---------
>>>    arch/arm64/mm/proc.S                |  27 ++++++--
>>>    include/linux/pagewalk.h            |   3 +
>>>    mm/pagewalk.c                       |  36 ++++++----
>>>    10 files changed, 581 insertions(+), 64 deletions(-)
>>>
>>>


