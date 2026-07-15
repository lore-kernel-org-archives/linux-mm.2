Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B5EDC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 01:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372166B0098; Tue, 14 Jul 2026 21:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3220A6B0099; Tue, 14 Jul 2026 21:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED4F6B009B; Tue, 14 Jul 2026 21:19:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D494C6B0098
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 21:19:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 503A712057B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:19:52 +0000 (UTC)
X-FDA: 84989254224.13.76925DC
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010020.outbound.protection.outlook.com [52.101.61.20])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8ED8840002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 01:19:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=msOHyUWQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784078389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7kv0C9arQX3Xqpz/8MXasR/eKOw414MGN/BpW70eMo=;
	b=y0E8myE8mfEDKMQNnfpBG03OLbwQOLHg4bb8feEXMEjZIuQjzuYvXhXiNfgNJwRxIXOkbz
	Sw2FE7tI78j2t5C5DZw640CjvjJ6zQ0YTaIzDTAzI7LuXwbA3YZAqKH3PhTW3eTSP+69uY
	Av3NbuyjmMgcm25WbMb4GhlWUJYO5Hc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=msOHyUWQ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784078389;
	b=hZFYiWnK0kuLMicijDMA9Q3dzfhEqMQpexfWxLdw4kuDdrfMszcPu/ZOKHE2YEKb/u/jmq
	/K+XZAU2etXIxSf0BC5sLniuCCIuyWGC+y/+25XC6+iyfRtsWu/BUzb6hEIwUI/RcN2Cy9
	z9JUV/7kj7epABwJzinz4qGerSUwdBQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Je/hKNHTBpLHnsOx6S+oJV8lQvHOLLwwc2N4WUFfIJIbHwIdm/3bVfH9PndAqxhqpu3rDMzgIxh8lsyNbLfmu1jxavLTaTk7LFW0B5qGQ08DUk+PUgJJN/C9aCQcTisFSqGOQvW9BAsVnlUVd8kiJX3AZfhzEIfHE2Pf70U0Gy3EVLGI4hJKKyPsjpz2oIlQzIam1I8LPU//f1oIg76pmy9Zfh//GlarD0ZGVjGiKNOSzmZ3tevAWBU6GnMIJ0Ysn1SX4TPbKH0BZZwp+L6Cfby4ZmQnBpaImG31do/TCP2hmkX34TpDW3KlBmrzhLUc8epS3+RJnjEd0JMB1jRQAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z7kv0C9arQX3Xqpz/8MXasR/eKOw414MGN/BpW70eMo=;
 b=Zwz8MambdEZmvgUaT20Lhw7jpk6xK7wBcrFwTVvwB3YlpZqLJB1gfFW6Htgf9ZmTElo7sDgYrV4B6ayMsJPY8WQ7SbuHHmt8oVUsWygaDGqw9N3IXmzqZq10NX5947cx58p73l2j2MwPnL8270yvqM1fTKGFRQwcXmo2Ug5dTMm4ADfodld0Kn1+31e3Vemh56KPj8zWgq4PESgIFtm8m/sJ6FZk1bkQE7Pq9sMvTTjtX+pmK+kvQJs427Jp3g0u1FEfffxAV0zjUDtPt9NnpfI2QjgpWxCfmjUVT7EO1a3nPGYjNSw9w61YCiVYzxuVmrBQyCtOC6mU80vYlIImhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z7kv0C9arQX3Xqpz/8MXasR/eKOw414MGN/BpW70eMo=;
 b=msOHyUWQqUyj4oYy8XuWXSPW4+MGdxaFKNJBEak53pXylmiMM2v8bBB0aQq5e5iEe66WU86kfmx8VzDpeuz3H+jm3fWhOlsDScZpFDvvXXMHmoGXAfXvPCvuiwYqENljUZKDJG40kTPhtkubpjUQU3nHCPhqyNM/JF1kRx+7fRXOyd8J75FE0skuJZOMi94upnKvZlpyWAtyb2NL25W4hujW00z9vyuTj8DHROwPWfZslGf5Q6qhWtTck77MiCFCCxX+S1oxPysKP3RqsscgS9vwokv68XUDu3AHcdhO6v0rK7z5o8rnNIMnm4Ng8Uxy8n+iQauBzYgm95oYFI6/ug==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by BN7PPF5D27497F1.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.23; Wed, 15 Jul
 2026 01:19:46 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0223.008; Wed, 15 Jul 2026
 01:19:46 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 14 Jul 2026 21:19:45 -0400
Message-Id: <DJYR07PU34ZE.SHSPHMKZRBBZ@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 4/4] mm/page_alloc: remove a VM_BUG_ON()
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <cgroups@vger.kernel.org>
To: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Waiman Long" <longman@redhat.com>, "Ridong
 Chen" <ridong.chen@linux.dev>, "Tejun Heo" <tj@kernel.org>,
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
X-Mailer: aerc 0.21.0
References: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
 <20260714-spin-trylock-followup-v2-4-3c20ed032b14@google.com>
In-Reply-To: <20260714-spin-trylock-followup-v2-4-3c20ed032b14@google.com>
X-ClientProxiedBy: BLAPR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:208:329::18) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|BN7PPF5D27497F1:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a6c049d-a8dc-42a4-be82-08dee20f285a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|56012099006|11063799006|4143699003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	PS3RIIF0n8YrPVJFi1vbUZS2xAuoJsaFqTocTKdERiHWwHO6tl8Djd5a+H49+t+b6RXHySR+C0tbhplc9ini74LSSTHYpQJqPIe1Y6v0+sr8T32sLzSiInJOR8FLu8lK5MZoftVpEoLDTbwWuGI0jva22Qr/6YQlvgwe2f9/9NLWqmZvPcWwd+qY60qooqfzjz4Q4KGKqqzb4boTtHBqTjNTkJvBQ1SAdSXarhJgH4Fb4PivTnEQmOp/4pqEV/d9ActssIye/ylM9Bzr9i3YwpWIMS4JYlF7quOd2oaRfCkvT0XUkQWo7nSU8qXOE7/X+J5rzQFYk00pTjXfYs0/l8saLywY6rnoH0tgPINy/Ljr6jgswzYS7KrdiNJI9cAvCuFFkt3XR9uBrZt0tj1Wz8pMqPoELtMqXFtuAvibx6LR7sKxzdkXgVhlnO+vkZ819Fyx1QtNty66LkpBGCWAaQWt/d1SyzeymOjnDyBmEklMgeCbkaIBJYseOrNYUd4kZAzfRSwW+Zorb6+c8thUgwvx5wCWmRyols+aDyar35I8z+8QfEAM8sD0DOg6no1sN1AjpvP64O+FyBip06tvmwTeaNXQw2YCf356aI1fA4eOT/dSe60bbuPQjGAjCtxerDJte+fHSE23v4lyK4opCB99kcaVSI+Oe0ZDdpgT59J9SH+bQfrXELeZ7MJYbg9lK/ktomaRm6wB7PvqQhTfWQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEhZU2c3TWliTTNKVTFZNzNuemp0VzRkS0NjMkZJZ21QNkF3U2hPbmpmM1JW?=
 =?utf-8?B?ZzZzUURmZXpBdmtrRTJrVzZOeVdscUFsaEoxOUhHQWVhYlFLMnBRb004Ymgv?=
 =?utf-8?B?OFdOTTNlZTZaV0szYktxRllwbStGcWdMWUE3R0RjUWxwYTFBdHZqNjRlekpW?=
 =?utf-8?B?YVZkTjRBTjZXRTF4dUpGOVh2N1VodnFqeFYyNHE1c3dEVTRRY3lSTkVaWkNG?=
 =?utf-8?B?YnduazZzT1NPNHAwUnhSYXJwSDB6WWRrRTMvcXVCNjl2NVNVNXZUZVQ3VSt4?=
 =?utf-8?B?MHVSYzRjd24yRy9aS0FEeVFYMDh2SHlxWDFUV3ZEcllWZEUrZE4rNmtpaU5E?=
 =?utf-8?B?dU14Q0dXbG5id3VNb3dNRWlxNHFUTGhSRkhkd2l3NTl5OG9LVkovejlDa1FU?=
 =?utf-8?B?YS9wcG1uMTQwVTI3U1VMaU5DaSszVE5pUmM1Rk5SWTBjeDlHWk8vdVJNOXpL?=
 =?utf-8?B?c2VUOWRheTR2TnptWDJITE0rcDRHbkpEZkVBdW9RWlhpaHB2NDNPMWMxMUZj?=
 =?utf-8?B?RlFkVTk4WXlrbUFSV0poRjFFS2k1SjRNUUtOUzltSGd2MTRTRUFLbk1ydC9T?=
 =?utf-8?B?aGNZQzVmeTdtZXhCVDlxU1JaVDhWU2xXRGhTYW03aC9GQ3VDT1I1TjR3KzI4?=
 =?utf-8?B?bHRjdHh3c2NBTGQ1YVNsTC9NT3V3aDRkUDNkZzdOZWRMTGkvUmNaeGM4REFC?=
 =?utf-8?B?UW9leVlwY0xnVXYrQktVZXM1VDFqdGxBblZlM2J5MHdoL0xjMDA3OC9MYW54?=
 =?utf-8?B?em1KbWdHb1ZMYmcyRUJzRUcvVFpOYTJaU1JmYUg2L1NWU1NyVk1OL0VObGJ0?=
 =?utf-8?B?NDJyeUFwOGU5cmVUWGFCMFNSREpEN3Y5eG1OU2NWVkxQKzhHelFicG9CY1Fa?=
 =?utf-8?B?MTVFN3Mvc0NsRHpTcjFOV0gxc0xjc0luNG0zN2Q5UkZKQlVBUlZlYlJ3SE1P?=
 =?utf-8?B?aUp0UEdEL0ZRSUdYWDRyWCtnUzVFenUxSGdjL1R2RVErYmFpSTlHcTBRNnF5?=
 =?utf-8?B?dHhsR3B2cE1rRjNPRC8xenIyN0FnU29aYkZzMlJkUkhLY3VwbTVrMGFiOXFR?=
 =?utf-8?B?VDFzbkh1anpWbk9LaWFEQ2oxb2NJZC9oOUNHZVlnSTBFQmtvenJuWWpPcGpY?=
 =?utf-8?B?SXZtU2FBcUk5YXVRb1g4TDFXUkNpMG9Ca25ycXBoRHl3RWtoeUp0UFVNNzZ1?=
 =?utf-8?B?NVFzL0xoalliVVVhYk9FZXZjSnFGYjMraFZDbVdCdXRjZjBjMGRHaVZ1K3Fz?=
 =?utf-8?B?WmxpSFpUb0krdzlPb3ZHSHU1ekJ6N2xmR3hFM0xScStTK2d0clVyazRjLzFy?=
 =?utf-8?B?U2s1b0RLZ0pNT2dXRjc2VGZaN3VQeEdQM20vTStyUS96blpXMHhDRU5CNGZ1?=
 =?utf-8?B?bnRKREFLazMreVJGeE83TWZqUFBSU2UzanBqcm9FM1BPcjFZT0p2Y1pneVBT?=
 =?utf-8?B?Ymc1bHZJQ2J4bU1BQjZpWXMzN2ZZaXVuMExDUFRXQkZPbEVnYWw2YlRmcFFS?=
 =?utf-8?B?dlIrL3Nydk5lOG1PZGYyWVRQOWZ2Z1lab3lyVENRbHFaaktCekI4bGFGOHdq?=
 =?utf-8?B?TkYxM2huZ1MwbFR2SC9HbkR5WmJtME9qUmNiSFlYaGh1ejJNUWhFbzVNYmZD?=
 =?utf-8?B?M1AzSU42N2dGYnQwanQ3Qjh6U2FPc0hiMDNnZUtsbnBLNUxzQmhvWnZuV2JZ?=
 =?utf-8?B?RW0wUnN6RFlPZ0Y3bkl4eDZONk5lUnh6L21lYmNDSndGNzZDemZmcjN4OHEw?=
 =?utf-8?B?RXQ0Vjc3RHVTSmtyK3FvNisrS2h2Vm9NN05ucXBOcXRiOGxCcEJWajEvbStF?=
 =?utf-8?B?QUpiNnExYWRjMFVaQXdjT2ZyaEhtLzNaWUIya0QxZml6K3hSTW9hU1h5RTkv?=
 =?utf-8?B?RGVUbnpMNkZNTW9xeVpSRHJ6N2V1OFZkYWtVOTBaMlZkbkJzME5zeW1Nb1hZ?=
 =?utf-8?B?SStEYXdFbk1NVU5scGVXY01RMjNtRzBEY2ZJVmI0U0xTV3ZSTCtYN2FibENp?=
 =?utf-8?B?SWI1alMyWU5pWXd6VUY1RWdzak01b1N6K2h6NTZJajNkdGpybHcyWUdWQmhY?=
 =?utf-8?B?OHlQdktEM3dBMy9uekd5Q1Jnbkl2ZENKd0Z2blNaTzFqL1I3STRGbFZ6R2Z4?=
 =?utf-8?B?cVRobGFnclQrclYyZG9XNFVqMHFXUS9YZ3BIZW1pOHMyUWszU25XRk5VaVVV?=
 =?utf-8?B?eDRKNzFzQ2xIUUEzVTVxdWoydFNhbkR0VWtqUE0xY1JDTVhqUHF1NEJocWdn?=
 =?utf-8?B?UVhhN0ZZYUZseVNLY05xMlFnVlo1clFqYW5URTB4SjZjUWJXcEVOQjJGazhI?=
 =?utf-8?Q?diHHfQAS5OiStxP3HG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6c049d-a8dc-42a4-be82-08dee20f285a
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2026 01:19:46.4454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IfJB9P+WpAITUgbm33wT/6OiOKTFBIgbPkZHTodWc07otopnRJ2tulm/NkZwtV9A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF5D27497F1
X-Rspamd-Queue-Id: 8ED8840002
X-Stat-Signature: 8g39fyqge4icdjix3pozb5heq9upjuch
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784078389-99460
X-HE-Meta: U2FsdGVkX18MEHS4kWdGBLfnQA0g2+3aF6WDY03ghLmenuL0tcC0kSgmgFXO1BqeFvL1II1+KLqlk80D6J5BHuHiy8cDeDemC53ErMblSgJRxU19idX0HYLNGs3y2k/wrUm6Z4mdQPr52+EaCk5YDG7yUPUdVUxpeAa3M7PGZqG0awXYKh52gZpP7TJn2K7SR78Aa1D0Km7/a4wjm2hBzjivoJBEKuSEn3Ut5c9u7MKV3MNh72V3phZPlNb2xzd3L5U5eirkimYJJ/JkBUe+meSVZLzUaOjKCftwzjJ8EXfCn1R3yLdtlg1l581Wwf8zAuZ8LdJYj/TjpZYJ4Dz4SzPisu5x2wVKc5DDckGCami2y1B1x7EPdfNt3ic2rpr3EMGMit2uqkem3XzixK1UvaVMOwpo+O4xTBQmScyU54Ucc0gcxpaSYRhzZuyDrvDmPsW0K4c1ax1T6fcuJSYt4kSFWibm/Wuo4VzKNelzPTNFj9aNeSrEq/eaq8TxS747BrBA2pWEG66dnMnq/+0EitAD3Xnf2mofWCpockbVl0N/iConwXzhQLwzU6rXjyZ1+qhh5IcCwJyj+s5kB5ARREU7sC36UbeDrvI8vuxfkNiTSiOSHWw68wry8tzhSh5+vPwTWTfN5wqYzrOWxe8Tg6virpujALPxsjKimAP1MU2wt/tUPeL3vSfRw/+4AeWWhy0gjX7Vjq01qGEYHZECbgKXENM/rU1nHSBMpoVUkjGn74yNWhBKsu1TliPFEdZ5Kxn+JrBdwufbDjNRpL1ZJLYopoa030GGy7EHwvZF5wdrK4gKxQY+PJt9JHWBRogo4cQrK3GXVtTSvi0KUMIN4iq0VF3832Sulpz0tWoTZ1CSh6kETT+GfEHnbgaKEBZITIndAk10KlO5d2U3EKUnvLTkYTy4NNCdAjf/hGzLqtGkjxAreKxndPxYDFSZRztyNJlDMYglkqlmNcc/H63
 1rS9VUWb
 P5is9kBQmfxL0dh6W+ysrWvyGho2keZYLz0oQWJMSAeP6LEP3/IfXvs3698VnBHlsLdLaibZneTdeU2zkh61N4sUuF0ROxBFyKsfItQtcGmjQduCU87wZincviBM9KNbbIW47n80AkfAYE7q1nntVj4y+HDLNKwq7LNFPCePy5rTIDMF05E7o7CB6Lb1Vt+ZybxQ1isrGvDUFK3NdpEygxT/nxcG8NXkogIQT54AcfIVP/Xc9e/N41ifMjIKH+npviyma+0+UfmIBJBRCNc5wWAef7U/EAeoAAWdtDilmwaHMdvmgpBlJKR3SNgIwWvIyRkm1InY6fjQzUqvgOQfVAwSP9xb0MJDa1KDKYm30t1IQ5whhJkUWOuP9tTFL8JEXb96Tgxgegcq/JItGLc39orodF4XDBewPU33fhLs5WVyWIxu/PSW6v1t7+2rMPhD9al4JTCdn5Lvinu/9wQVnG8rOCkuObchBFXddbnHPdM9fLog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Jul 14, 2026 at 5:32 AM EDT, Brendan Jackman wrote:
> VM_BUG_ON() is out of favour and on the way to removal, since I recently
> touched this code I am removing this invocation. If this precondition is
> violated, the system will soon crash anyway.
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Link: https://lore.kernel.org/all/7F866265-3F2E-4765-B9D4-9AB898A9C4AC@nv=
idia.com/
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 1 -
>  1 file changed, 1 deletion(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>



--=20
Best Regards,
Yan, Zi


