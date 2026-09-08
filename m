Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17E6BC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A49496B00A3; Mon,  7 Sep 2026 22:56:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3116B00A4; Mon,  7 Sep 2026 22:56:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874896B00A5; Mon,  7 Sep 2026 22:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9D1F6B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:56:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51CF980341
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:56 +0000 (UTC)
X-FDA: 85189082832.29.EB5BC99
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7AF851C0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ILAcdjd7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uQNatyVZsCkHUcZa/m9V4rw8GUXb5HTkV57Z5KyBqGM=;
	b=dPVIULJBiYQ/6IivVApqfCN9pqSOrj1d6RIrePqriOwVH/A5kgq0hFv6Fhws0PSt21ovWo
	UDHxSYnbpbK9ntC6ffHeZUK7IQ+mOsXEDcUrb7AMXNw4gCWeG33Q+bspUGJ+SkrFs29iu5
	hOFJ9WGZoQIYzr0oH8/Eq9U1AThcRNo=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ILAcdjd7;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788836213;
	b=5PZSdaFS4mPWcccAQ4BJvb1lM7ExOpSqvTsI3w7E5Y8su7E08qgS+vqpJ9tmvO4nZouynI
	8netwMIMDTpQPi9ExiNNNr+73Jnh8rYXBxyOsTuasayB/1xyWZBs5ouf3KtpQdyqlGBiiR
	NQyLtjpwRu40USE5WnmlCmoMBUDuSeY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LEPx4eMPjwyd3Xm7upj72cOYVrTkOJZGnn52KynADOz4nl2yTW/IpCwiiaOWxV67SjtGXna4nVf2CfF3RLyPxvLQ4PBZFBCgTd1Pf5dpV/neoHwtGKyXkbYHZctsjZmI9y7SIaIah4T4nniYJm1QIMpNLpqBNMC+zAj2X73M29Y9snLq2aA4aESvOPqtGtbaJMZXpTFdrYPYSX7Sg8sWYKxrizqqzXum4T9GXaEMI2vAoWVP7w85ABWE9Vi1fQ4WywJFBAxEqflUjY0iUvo49SZev/cbiULOyhpsUJpRc/MBFIl3v9NNuYls/vVXz2Cy0awsyZEO9TrtN0z5rhepNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQNatyVZsCkHUcZa/m9V4rw8GUXb5HTkV57Z5KyBqGM=;
 b=Y0dz5gxjZAloD6qPIUMXbHRGD4E5Hil60gI7Hh6ZQif+9KftQa//QzKv9UdtJAapktYYxMWf61BEByQmh9oFl9U+cTdauPD21PHHzfTlEgyV0Y7Z79M+9Q/1e7WkRbVKgw7wPDLKMGDuRfOku6kvqeTwLLJRfXeBqH5Et1zWA1oUbRiVRKXuYIpjocIvUlVrJ04kZ+8hVjP28EOK04iI4vSXOh1QZZ5/gYa3kn5f9wMByWOhyOqO5WvlqGMt2pB/8kveqxjLBUzWHBlaQPf5ncFdUd4dcvvC/Mkt8uZnMIwISrI/303f0KUBA/jQj8IWNRX3WcTEME3raZ1TOb/vwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQNatyVZsCkHUcZa/m9V4rw8GUXb5HTkV57Z5KyBqGM=;
 b=ILAcdjd7aE9WoqXX069oLMUD7pFXefnqEC6SL3VXtZ7OIL7ZEb73LdmE0X4fZCIUSmvu2vply79MZbrk/9vaPViNzdOWx8ixPFxAebdDo2kHY3HdlEKd6L9AkMVdZ3AELEDb/UATp48XBirLPL7DWup2MwspZK74bgKnwqioHPKguAa21A5r8647PpR7bczZ5iqVKFcvqnn5PbgGRv44bgrymvw18wCVfwZtEmvUm6ZudtEJnPkwfTE0eKB/BZWu8XR/InwBfD1dOL4TnxDqzTVHKDVu2yfp7t4wkVvUiR0/ApD1yRA4BevTi6GA5OkCVserLhQKk5mc7WX8zv//Zw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:41 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:41 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 07 Sep 2026 22:56:17 -0400
Subject: [PATCH v3 10/14] mm/page-flags: introduce folio_test_fs_private()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-remove-pg_private-v3-10-6ae22f9d9272@nvidia.com>
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
In-Reply-To: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, linux-fsdevel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: DS1PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:8:44f::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: a26b3b2a-3cec-4082-f8f5-08df0d54cee2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	vRtGOHf5ClSxJNsSpG+CgbAZr3WoVqk/IPAhZ0Ev3vFc+1hWR4A2ZDQd4C8UU0+iJqoUXQZEi9/nKP5yy2MqcXnR7TxvOeKLjQCG3tmtiPOAR1tZdsAOqvYQOo+OU5RpMnOzzoGwGj9o3P2q/TqJNExowcupVoAMjbkJ0ac1IDzvIsUobzCCUx5rmrcz/wIi77d8/LXytVVZHI+DrXxNEAQDDWAKHRlYLE9yyOPlhG94fApf6WSAzk8HsxyslOwkSHhmr5wDKqioLC3TWg1c+2WMYtd2iBFWb0md5tz0HDQwhVodOWU16DWHki4hfjRe28knKijOmhJkdN+nq/yiQEjkhoMqNd/2pBiQfsFRSWdtg1j4aeUub3nQBZ9agTxcnLfZG5I5uLCIVptmh5JAgCh4B0eVN/ysLay8ypoTvLdPTfC4beLZ1XB9/PcJ0ax0/2fVLydERe9RB1hQpCfruX5iAxaE5FDhrsCD0YAuVuUYpKJ3xN7O5CFYchxnAkBatvFrIwyyyOUSd/W5aMA2z6H4b5nnzhuupgoEFLihaalwGQfIVyAa/2+wAH8Zsul/8Nm7GzaWIzRr7/7kmkAxu0gQmz49H2Tiv3EVvjSxGFh7/iuEcCl9+e6VaUUVFeyLxYQw+b1EW6folCehRhSUhXOUF/G6xnI8h34tpaENNn1S2qtyiXzgE9jjor+Kjb+6iBCzhJOfCcdi21u0sOjVFg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bEN5TEZHQVBEZiszdE92dWtCN2JQaTF5TEV2WlNJK01wNDNBd0lZbGttVndy?=
 =?utf-8?B?QVgyMzlLQ3E1L0pPeENicFVKSjU2bXhBbE1tR3ovQzQ5Z1k0SzZwMXpYclNG?=
 =?utf-8?B?bkdJenhrMEcyNllTcjJFQUswc0ZFM2luMVJGNUozRERGRjF1OGM1WE1LbUlQ?=
 =?utf-8?B?QjRLTUpoQVpUczl6by9HZGJENTVTUEk1QzExYVd2dWNuUVFIQUlXRUlyZC8r?=
 =?utf-8?B?YzJuN2x2K3c5Rlhic1dUQjQvWWkxZXNFcmpiM1ZNSS8wL0pKV3kvWStSdTRJ?=
 =?utf-8?B?UG1sYSs3OWVxdkhMS3JUTkFMSTZLU010d21LS1l6SEZvWTkvanVSMDN4aTV6?=
 =?utf-8?B?cXJzNTRScjg1RkJaRG8vQ3ZuVjBNUFk5YWswNzh2cXQ1S3ZSeGZJY1E2K0py?=
 =?utf-8?B?S2VlOHFKTEtwekxaZ1VzbEdRLy82TFVkMWtJRWVYK01yZCtiQWFML28vZUov?=
 =?utf-8?B?VURrY1NMeG9BUFVtaEFwQzVET0RGYlBNS2NSRDUyMWxtcnlQWk9OdUZ3dk5z?=
 =?utf-8?B?MS9QY0s1dC8yN25VYjFtdTFiVkFZemE1RFVnN09VeGM4dzNRSU16QkFCQ0g1?=
 =?utf-8?B?TE9SdXd4RUhLZXlaM2JQbUpmVWlQSFFkbEh1WHlXcGFNenUyc3BUSWhTV0Za?=
 =?utf-8?B?YS9DYnpNamM1cmljQ2g4alRkRjFYZ245M0tWTS81V0hIQktWQUFwTWNXQ1pl?=
 =?utf-8?B?ZG9DWk5yTC9YOS8vZWRFUXVWSERXdldBRkl0K1BjeEJyRjZyV3hXaUlIcFhT?=
 =?utf-8?B?ZVdxcUxDMDA4OHVxamtsR3BFU1h0NzFoMVgvQUdFK3BoYWR3cEtJZTM5ZWhB?=
 =?utf-8?B?RjdKRlFOY1h3d0Z3WVROTzlGK3pMUGVsWXhXV3QrNGxwMlJFSHQ5b1JjZ0Yv?=
 =?utf-8?B?cTJDZWxRMlFKTWUrMm5tMjY3UHNrdWZlbzBGRGRQaEh1dG05Y2N5Z2VzK2Fi?=
 =?utf-8?B?WlZzb0FwQ2dOcTlScVNuam42ZU92aDFrUnhMUGV0bmFYaE9CaGFrUERkZ01v?=
 =?utf-8?B?L1JZOEk3Sld4NklmeW5GaExMcGVibWRwN2sxNFRZUEtOVGgrMEZIclY2bjgx?=
 =?utf-8?B?cGwvb3ZXamROQmlyY2t3ZE1rVC9MVVZ1YkdPT3V3UThkRjloRHROa0llSDQ2?=
 =?utf-8?B?cHlneGFRU0xWeTNZUytOa0VxMXROdFBXekRzV2dFZzRUbml5eTBWL1kyWlNk?=
 =?utf-8?B?YWRIOWFkK3Q2c0pvc0hCUVZ2ZHdGN3hscE9iNjd3aWNHdjJhczlXYThUdW1k?=
 =?utf-8?B?SVduNWNReHFsaFdDaWpxTkpsV29keXVCUE1MZmNzdCtING1zbFh2S1J1Z090?=
 =?utf-8?B?NE81ZmFGdjVGZjFWVnNtaVBrTEFZWnFqME5aQkRkZHFXNXdBeWNGOUVzYkt2?=
 =?utf-8?B?TW1YKyt1M1Bad21qVVhTK2s4MTNQc29XSmZYcFRpSzVkK3FJVTAzbTlRWm0r?=
 =?utf-8?B?dEZST1hqSHBMeklmdUhOSnk5Y05xUkx6YU4yY3hmR3hiZktxSWlxZ2NPa3hP?=
 =?utf-8?B?Q0Q2K3pXeDJ0d3RRMzB3bjdtTEpOa0M1VXpCWEdSUWZhTG9ZdGN3Y2k1dFlv?=
 =?utf-8?B?R0ZUNWhJc0phSmxZdjVwdzZxRGlEYnhVZWFDSU9IWnFlWnRBRmxLZTZLdkhQ?=
 =?utf-8?B?WUFtYmZlMnlsRXdkOEFxdS9aZU1zbjNNdkdvQzVKNEdBMmxyYm96anFIWXRL?=
 =?utf-8?B?QVJ6ZkNpenlGTy9zb2pyQ0E3bkFBYndRdi9JQ2wvajUxMkxnV2xxdStyZlRY?=
 =?utf-8?B?aUhQVDZ4UmQxTlJRTVRGRUk0Q1NSbWhMaVBOZzMxOHEvWFFxZzNJNFllazhw?=
 =?utf-8?B?Z1BJYjlNZXZpZk1aUU51ZDZmdWs5aU9WeElDN05zMHZJcXZBdXMzeGJOMHRO?=
 =?utf-8?B?VWZ3WDNwOS9reTZhaUhUelYra1pEdjBHMFFyRHNpOXdiQkFnQnNBZEZWTkNR?=
 =?utf-8?B?TFZNbnozRFdmbkRWcUhPSUFTOHNzYlpQdnhaZmxOQkJUaWNrVGNhU0FzVVFj?=
 =?utf-8?B?WVhobHhXeDdLcU16aE5vcGdxODEzOEdsL3hhV0FoTWJLK24yYzBjMllpQW4w?=
 =?utf-8?B?Z1A3aTdvc0Q4QTJXT3haY2dYbldIVWZpakFqR2h1NlJJdFdLaGo1ZHZydDFm?=
 =?utf-8?B?MHZya1RSeGVZYVNONFA0ejFiUTRrMjgzREZxYWFXN01teDVwUDhPY2NkZGJr?=
 =?utf-8?B?Z2pKeDl2b2RwZFl0ejlvSUhPcVMzL2FjWkFYWHZmZEJ1cllYK0hIQXBsUjI5?=
 =?utf-8?B?ZFExWXlrejRLbEYxTTVkVHlHN3ZWb3p3NjZ4WVFXWXNwSzZHMm9rOGZ5OVB5?=
 =?utf-8?Q?707/ZWhEjkcnkxbSZn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a26b3b2a-3cec-4082-f8f5-08df0d54cee2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:41.0450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dkh2oTEHwEYCz80hM/ixDR3ztBinEHHlW8Bhn8RJAVp1zvzH/n1WGhj5JhF6Xd2l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
X-Stat-Signature: fs5m8hhdbnrkj5b6mq5wrd45r7fy8cos
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7AF851C0006
X-Rspam-User: 
X-HE-Tag: 1788836213-811727
X-HE-Meta: U2FsdGVkX1+u6M7yNHMiZ12RIsRA3nVamT12VscLxzI24tbW8hgIS1o0FD+kmUZF3aQDTkTqmQbGlhVuXzz9yDVNvUC8lgEMThqiVCGXn9mubySjyA7px3V5cJHfq/TdnCbuTRBwdXc7VJ99ET6EDk25YcATQXuNYYkdGHgxqXSjWgs9XJU5rpm3nhecky31pqd8h+GrSFRMxHmZpHpElXjQCh6X20BJs5bb1R6U9xLCvImkyvr1/Lo0kqzNOFKtA0XLkwtWB/xCjzKcjjFlnF1VM5nUsLtX2bbysIIi6NooBpFB0HGJn7qB/OTmM2fFF97AvGIBIR5SlEJT0Ztlel2bMBUf3NDTqLwKnVbq2hBxCLrxlqk3HyPnaKlbjisnK+fBOLatX+/wwDwDcJ/1V9gKlYMQ0p882+HCkwUHjkaaS27zsmHFFCrJ2jepK9/wYzNOVyAD2T9ottuMgCNNHJVdXklRB+Y3+d3whlQ/7+RI01YfKd79TC+Soe5BPPm8g47aPronaxBJE19dRfF87fcxKri63BCLc9lCqx54kTA51Xvdsx6S3djEkJi859RlYhReO308jf4zpSz97AAP0KWeQ2ftSII+IUyp3mclhxWMLF8mLIKHVdlCAbKrsekgIUOZ5CD+y6kTzUFpfhdaEE57RinyPtD/Qh29riRbXZev6gCjvzdr/Oew6mYGwfbAIH+eYaR6yQlRKgoAoFrVKwYA90tCfy6dnInCWVI3v/9GgzdTOVb8e62FY8q0XZMGpo4uhtkUwcp56pDHbfxsMW4EXt/H1hQBfTOFfYBxUk15d3BL82U8luOYLBekwLz7H92JWe1deNdCofHllQd/JlABBufI3LLoE5JyF1TfvsIinbIZ89PvO+DprElyCQ9rNxBBiwtfAkFEDhv4LYlu+HZwVV6N5YQGWMDrVkU9pNo/6YHcpPJtb1e6wyDG/fAFKyGeBczkaxZYcSrmJYn
 oZ/xDydu
 OjyspKT8rOBXemTOHjOLCNXe1I+AzTAaohDOfujEPmOVraB3bW02NyiBNihAViWgDUnzbVVKOyEFqOTvopzTNsZSCk9Mw0Nt44jKWxWC9HAqR3mXtUYf6uJBjgIJlTQhDDyUgjI4RWMMg9nlaGBtI62AT7aF92As9fa/0p2pOuaXgY23G3v+/m8h7DR33RwZ9+G4KiXl0hpZ1x23eJqQOxcegLgDZVsh3KiOrxs87ZJ9wiVZhUbQBnbgEO74btqav1RjyRwF6ygHrs1WzLwGBRRJojvycEnJH1eeWMXCMquiFg+PIqAkfmj6l3IrtnBJHZxuubg1Zf4Pg405KaXoPfKYNXcY6vXjtRzjacFMEG7xzECSITDmItdFjUXEb/FoLT3nzZlUyEGj64IHC8NKcwki2MbyqZY/HscNohQZ9hcT0pqf4z0416VzfgTwePexTnKUxobMNcwEQxG1SFo5gbElN3nMpxAZubhbi4lzrJhGpqpy+M7dbTMXib4+omm5jsgt1NseYUml9Liwsd0m2o+bcSTxU1U25T01xjj7hANPJ0Q+DHhJIfns73xgES4nL63XKZms8GrjGMMjIQVWbwrsTJto10MmxLRdiFhjy/CpVxM8aXSW9T9bWw33ANcRF9cpCk6C6aH2GSJn8QJ9nBYxdihTxSmsyPmu6CZMtBCwT7C1oBuydXz1fqxASlz93uWKP3I59wbtJujKdymtZaNecuALKAyPhWFgiZtIL3t1gZDsQsUNKoA8W+MSh2bXxbNO0qhAK4wLs0SH3WRWy1RfXY5CRvFYNpaYYSpRSx7Zv3SSePKEh7o+lSdu5FnzmufLOk9jE2XmEZfhE/ABM2y5TXn//YL/kxeJ8R4q9q8RqQDmDr9VtQi1yGIoXU/Mt5JdpyCdK9kGYf3zPie6AWciSxKJjk1o/9CZyfQ7b92p0Mqrua/Yp5J4yiSO+ucIw64yYgXdPD/bPjFcrQ0o/TA68k1Iv
 p4jN0jtj
 /b5/t4Ox7Rz9Xlx5mzG9x4+UNr1iTV2GPrVF85Hi9luAgFOT/QuPnT59AAEyqkawwb6aWVLXw2sotE8lOR9ThkSl5REjmCO/Q2po3g/9xnxZ0B9wbd0MF8KU6sWvcGMD56n4NCQMGuP1/4ucIv9t/yxrvnTOF1m45U5Rk3wNmwRpjdOUot3kfBDkY48Ww0Zz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_test_fs_private() wraps folio->private != NULL check and excludes
swapcache and hugetlb folios, since swapcache uses swp_entry_t overlapping
with folio->private and hugetlb sets its own flags in folio->private.
Replace open code with the helper, since core MM does this check
frequently.

No functional change intended.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: David Hildenbrand <david@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <mhiramat@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: Ying Huang <ying.huang@linux.alibaba.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
---
 include/linux/mm.h             |  4 +---
 include/linux/page-flags.h     | 26 +++++++++++++++++++++++---
 include/trace/events/pagemap.h |  4 +---
 mm/huge_memory.c               |  4 +---
 mm/migrate.c                   |  3 +--
 mm/page-writeback.c            |  5 +----
 mm/vmscan.c                    |  3 +--
 7 files changed, 29 insertions(+), 20 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5eb8a62fafb56..c861525cda83f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3053,9 +3053,7 @@ static inline int folio_expected_ref_count(const struct folio *folio)
 		 * One reference from filesystem private data.
 		 * Use data_race() since folio might not be locked.
 		 */
-		ref_count += data_race(folio_test_private(folio)) &&
-			     !folio_test_hugetlb(folio) &&
-			     !folio_test_swapbacked(folio);
+		ref_count += data_race(folio_test_fs_private(folio));
 	}
 
 	/* One reference per page table mapping. */
diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 9cb4d64739798..ce7fccd90367b 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1210,6 +1210,28 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
 	(0xffUL /* order */		| 1UL << PG_has_hwpoisoned |	\
 	 1UL << PG_large_rmappable	| 1UL << PG_partially_mapped)
 
+/**
+ * folio_test_fs_private - check if the folio has filesystem private data
+ * @folio: The folio to check.
+ *
+ * Use this in code that may encounter swapcache or hugetlb folios but only
+ * wants to detect filesystem private data. Swapcache stores swp_entry_t in
+ * folio->swap, a union with folio->private, and hugetlb stores its own flags
+ * in folio->private; both are excluded.
+ *
+ * NOTE: For swapcache, folio->swap.val PG_swapcache are not set as a whole,
+ * so folio_test_swapcache() is not reliable to exclude swapcache.
+ * Use folio_test_swapbacked() instead, since it remains set when a folio is
+ * added to/removed from swapcache.
+ *
+ * Return: true if folio->private is set and the folio is neither swapcache
+ * nor hugetlb.
+ */
+static inline bool folio_test_fs_private(const struct folio *folio)
+{
+	return folio_test_private(folio) && !folio_test_swapbacked(folio) &&
+	       !folio_test_hugetlb(folio);
+}
 /**
  * folio_has_private - Determine if folio has private stuff
  * @folio: The folio to be checked
@@ -1219,9 +1241,7 @@ static __always_inline void __ClearPageAnonExclusive(struct page *page)
  */
 static inline int folio_has_private(const struct folio *folio)
 {
-	return (!!folio->private && !folio_test_swapbacked(folio) &&
-		!folio_test_hugetlb(folio)) ||
-		folio_test_private_2(folio);
+	return folio_test_fs_private(folio) || folio_test_private_2(folio);
 }
 
 #undef PF_ANY
diff --git a/include/trace/events/pagemap.h b/include/trace/events/pagemap.h
index 8193f91216822..547a550b81ee1 100644
--- a/include/trace/events/pagemap.h
+++ b/include/trace/events/pagemap.h
@@ -23,9 +23,7 @@
 	(folio_test_swapbacked(folio)	? PAGEMAP_SWAPBACKED : 0) | \
 	(folio_test_mappedtodisk(folio)	? PAGEMAP_MAPPEDDISK : 0) | \
 	/* data_race() is used to read folio->private locklessly */ \
-	(data_race(folio_test_private(folio)) && \
-	 !folio_test_swapbacked(folio) && \
-	 !folio_test_hugetlb(folio)	? PAGEMAP_BUFFERS    : 0) \
+	(data_race(folio_test_fs_private(folio))	? PAGEMAP_BUFFERS    : 0) \
 	)
 
 TRACE_EVENT(mm_lru_insertion,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9b2a9d0794a61..4cb7d9bc47544 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4833,9 +4833,7 @@ static int split_huge_pages_pid(int pid, unsigned long vaddr_start,
 		 * can be split or not. So skip the check here.
 		 * data_race() is used to read folio->private locklessly.
 		 */
-		if (!(data_race(folio_test_private(folio)) &&
-		      !folio_test_swapbacked(folio) &&
-		      !folio_test_hugetlb(folio)) &&
+		if (!data_race(folio_test_fs_private(folio)) &&
 		    folio_expected_ref_count(folio) != folio_ref_count(folio))
 			goto next;
 
diff --git a/mm/migrate.c b/mm/migrate.c
index f6befd3ff1c46..2e133d533c8da 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1327,8 +1327,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	 * free the metadata, so the page can be freed.
 	 */
 	if (!src->mapping) {
-		if (folio_test_private(src) && !folio_test_swapbacked(src) &&
-		    !folio_test_hugetlb(src)) {
+		if (folio_test_fs_private(src)) {
 			try_to_free_buffers(src);
 			goto out;
 		}
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 02ad49b10be07..e7389020d2a56 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2706,10 +2706,7 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 		return false;
 
 	/* data_race() is used to read folio->private locklessly */
-	__folio_mark_dirty(folio, mapping,
-			   !(data_race(folio_test_private(folio)) &&
-			     !folio_test_swapbacked(folio) &&
-			     !folio_test_hugetlb(folio)));
+	__folio_mark_dirty(folio, mapping, !data_race(folio_test_fs_private(folio)));
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9348ebf9de882..47352bafc5b6f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -978,8 +978,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
 	*writeback = folio_test_writeback(folio);
 
 	/* Verify dirty/writeback state if the filesystem supports it */
-	if (!(folio_test_private(folio) && !folio_test_swapbacked(folio) &&
-	      !folio_test_hugetlb(folio)))
+	if (!folio_test_fs_private(folio))
 		return;
 
 	mapping = folio_mapping(folio);

-- 
2.53.0


