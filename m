Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4034C624DA
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 18:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AC846B0095; Thu,  3 Sep 2026 14:59:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684116B0096; Thu,  3 Sep 2026 14:59:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575F16B0098; Thu,  3 Sep 2026 14:59:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F3B6D6B0095
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:59:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 511BA16045F
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:59:06 +0000 (UTC)
X-FDA: 85173363492.27.82F76A4
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013031.outbound.protection.outlook.com [40.93.196.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E93E40005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 18:59:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GWBTIasa;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788461943;
	b=MtkaxjB58Qx2y7g51U9Nl1nGTCRwHvweDPvNYY/DVxHVrMIT3V4Wf318DgsvNbKpMOg7rd
	0vCg50gR/rONEEYXej3+7C4gKgoAZraTUfr/sKVOTupYGcTCpQuGV+UnKPSvbcGRSRW54b
	crlZ4J+SmYhY896XqGpf2caHXZ0dXGM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=GWBTIasa;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.31 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788461943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OwB+StsVA56q/xQXaukefH5Wkuw2Uoey+rPxBPRlRnM=;
	b=iIqinlOlJi//EXjH72wEilW9RR5GRx2gIkZMBZyZgdLOGkEkPoGpWPA5Itg4ltgRZF5cLV
	IJBSfLdl2do2qrS2doB+a8pgRzmAuCwUIshGZ2m0U+wAku3JTTQwrhYmASLWPCUc3+Clxf
	pyq5/8+Yb/quVmzEV18Mr2jM3YoBtns=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h5jUselzdvl1xU0xArW567ByCLjErTo3cu7CH/2kD6dgjKfQhAnyXD1vOo2tYryB4wTz7L38kFqiXcpPqI6Ja+AoZCW0rs6uRSTTVd+KvwxxJxomAnQjRagp2gCze4JKcL10RSBPR3BbuY1X3fuZ5xQxllIN2jVIwlkpMUaoZTObav0PYRMZXdlJ/FIeWtD6XSoS9H1qIpmNpQBnOeA9Ryfnq/O0rzeorbH7Fqk44MDCni1fqQmskkxvp9TH5iQNaoI8gEqq9AuZx/mVUobTP1rrKbAGYHhuKToQL7DttA+NcJjcBDWKRXYNzIGV5FMwAI4XyR4E1+QxVILH1ZCQuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OwB+StsVA56q/xQXaukefH5Wkuw2Uoey+rPxBPRlRnM=;
 b=ZzU4dSID4Kvj3rk2sp/J7d9kg9nW9qgjPzuPwodPsvNYHfNjZ9NUNOAqbsZnNg1K1UK8myDYE/AwpiSQYWCdJHZ/6hXa18A+CSxV+akPP0D44+1zmQAuaBdA6R+xVEOOSaUiWgoQnHnov8blG6/dsyBU6PRlKuUMjNhYkKrN0zfgYueGhKEqvUH5qQutvPXxev6az3Z6TQmUb4/GsXN4mnLkQW5MbSvsZpbuqaVG+eFvE4V+KBpae+atQlpWqSNbvwQtNT4JYJh8gP/ji9ziwCvHSlUe3bQ3WXbQOlqBcHjcXAhlgWG6w5Szf9jNj242FsFoBSM4dCilFXaI7ogH3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OwB+StsVA56q/xQXaukefH5Wkuw2Uoey+rPxBPRlRnM=;
 b=GWBTIasakYl5WxmTIn1OSUxJIZzkutkW0nSgbf+2KzMZXUh0INPE7fdVXdoIwMtnW0qUQGgtqx0dCclhSvKpsMHP/niqz8bslK0sreBeIw23fX4B8f1UlfRrKqXCJqLF4tcdpZd5wfQXGt3Ak69/+uqx87mVjJ4bwzTOeg43r8yxTbRX6CNb5+x9v72pIL1xgcjrlsGE82n3+0nQdfXBHSQzwMtvKXTsJy5fBsj9mPC3I0XZ+6lfIrnr4pv4JTDxpk+6KnbwzPUdQxUcipMbWC/kWqyclXf1NsL51xjGXAcEvmCZsxZxkdaNqJrVUaj1ku4bRFvJd1bbleNuk/bwPg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS2PR12MB9590.namprd12.prod.outlook.com (2603:10b6:8:279::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 18:58:57 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 18:58:57 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 03 Sep 2026 14:58:54 -0400
Message-Id: <DL5WUE8JD6MH.3W984LEQQMFV@nvidia.com>
Cc: "Nimrod Oren" <noren@nvidia.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Hugh Dickins" <hughd@google.com>, "Nirmoy
 Das" <nirmoyd@nvidia.com>, "Dragos Tatulea" <dtatulea@nvidia.com>,
 <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
To: "Johannes Weiner" <hannes@cmpxchg.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
X-Mailer: aerc 0.22.0
References: <20260901190123.3511535-1-noren@nvidia.com>
 <20260901204449.GK3004@cmpxchg.org>
 <C8541A2F-D6A9-41B0-A3FE-52339A6601F0@nvidia.com>
 <20260901220917.GM3004@cmpxchg.org>
 <69C018F5-A1C8-47AD-9567-3497AA6808EC@nvidia.com>
 <20260902160417.GN3004@cmpxchg.org>
In-Reply-To: <20260902160417.GN3004@cmpxchg.org>
X-ClientProxiedBy: YQBPR0101CA0168.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS2PR12MB9590:EE_
X-MS-Office365-Filtering-Correlation-Id: ee89eb72-6b81-4af0-8a5b-08df09ed67c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|3023799007|10067099003|11063799006|5023799004|56012099006|6133799003|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	E8sjyZIX7glDi3zHBkqWLi1tynsppwXYBUROuaTl+s7hLSKh1vUj7ZDiXhOfcTe9g2uPAKcOqFWTsUWl8Fly/xRANI4ZD3gZx2dDoH4lyUUccdJdaDgakav2DTp0KBING43GrD6gtv/fP8K5GqRtvIoPJYHPfYoM1lyi/NwPiFbQdPYjpUDtV1bt/oV3aUIv2uXYdCBd27o5uykli5eEZ5pJm31Ga9JaAVSMKAaPV27018xdUPOPpHAF2gqBVnuCt2rbysOyTNJV6DTKCaJxQZ3BxaY8TPVEq5a16S9Q02fm1aykpUJSuJqjJ2uZMuIUDfNZSrPLtUMlED1DLbcETa+tsodExP1BV9Ap2zqoi/ulRH4gR2icXsW2KVmre6+22Tge9EqiQ1JjUrX1OCWW+UcdplmXDgWNKytTBXsSt+2fOAY48ci80p3ooBvU7uujxrZJSEBYS1b8aAGD5Uo5T9guXE6W3FjEK9Bn62/tFAXrUlFXNsixYFUhHo1ssPTi/iWhpY9qHzYajDl06SiX0EbML9eCStNP91JBL/r6oOyxcXLiISpW22z/PCN5kRfdaHXWv5RrMvhAcO86TwPUnNfC72FAnUTuvtSFNqeY3aNHHoq3xSV2Ryhg79WMf5YTLb+MatFquZnR4pjj6kQnljmFAuUhNVybcw4zrxjnpAM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(3023799007)(10067099003)(11063799006)(5023799004)(56012099006)(6133799003)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MXA2ckNkSVlMRkhabGdiRGNqa0RrSkQxd0xHQlNZYmRaL2tEQ0pmd3YvL1Bh?=
 =?utf-8?B?bEw0OWxBNUwxcGFKd3I5Tk5uVzJqQVROWFBJOUFPY081eDkxUjA4N3pFeUN1?=
 =?utf-8?B?dEZzaFo2WGxzbG1CUXJPNG9ON0UwMGZZQkVYcExwTVpZZTVuQnFxSGdVTVpW?=
 =?utf-8?B?enZES1IzaUFRN2o1bVZuNUR2SHI5WDdUZGwvSGhJck1OUGJZNEZMS2ZtV0Jk?=
 =?utf-8?B?MjQrRmpoUVQvNWU4S2s0b0tSSjFNM3NDaUhWenl6RUVxK01Hd3RjTGVWNk1a?=
 =?utf-8?B?cngvbitMbnd5NnV0WFBydSt3dWhaLzJjVGpxdTJ5T0V2RGFXSFpYb0lTMHZ4?=
 =?utf-8?B?QVdYdUtCTlFxT1NYdmZ3cm5OZVNrSEYxM2xGVUgzeTg5UzVWZXVhZnMrWkNB?=
 =?utf-8?B?U00wemNZeVhqNEpGQnlEQU1Ra3JrQ3JxMDVYaUNMVkE0dWpMaml5SCtoVjFv?=
 =?utf-8?B?bk1paUNyWDZ0Nm9TUXRtYVlTaXZzUGNBalhKak5ieW1iZGpFL1gwSUlYbGN5?=
 =?utf-8?B?Sm1yRm1XNHhqeGtlUTF3YlN1QWpqa1NCczhrRDk5M0lYU1dhQlEzMzIxbDVj?=
 =?utf-8?B?TzFna1g5N3pnMkZPb1RHSnBHVXg4czFDUG1zclBZVm5lZHowSk9QUmo0Q3o5?=
 =?utf-8?B?MWIyVlAzWWN5K2dVdFJwdXNCQ0c2anVkNHdVMytGQ285ZzdzZVpjL2xEeitk?=
 =?utf-8?B?eDlOWVVLeTRGU21Wd2UyNnVETUkyUjljOGV5NmU5VGhUZDZndFo2Z0w2RXov?=
 =?utf-8?B?RHUxT05Yd0h3QjJLUDZlalVqWWwzTFg2MXVscUxRU2hBYkFVYjcydFVlekVR?=
 =?utf-8?B?Y21jd25QVHp4bGczekxqRTQxZURzMElFSFVPcjV3SWMzTUV0cUY3YUYxM1pC?=
 =?utf-8?B?bUdFaXNKa2VJcEpham0vc2YwZmc0TUhmQUthRy9VR3lEUUNDSXNwM1JNK3l2?=
 =?utf-8?B?QS9kbW9DYndQRWZRZ3RvRUlLSzlSQnlkRlNWSFNJdWFoemRlUXFPMGl4VmM0?=
 =?utf-8?B?dC9vZks1QVRvQTlxZjB1NnZjdEE5NFpWeUZMMW5qTmxtTVdWdGN3QVMyZmNN?=
 =?utf-8?B?L1ZGd3FyU3N2NG1jN0cvY040dkkxL1hNcTlsa2RVWk1YSjJFNWliaTdOdFd1?=
 =?utf-8?B?RXNoM0gwbUZIWHNSd3ZCZ2hrWkdhbElXWmZtTHUzem1ZOTBJZDljY2gveXVN?=
 =?utf-8?B?WFl6MkRib1k5bWhLYUVRaWZtbzV5T0pFaDh5RHVmSXpuRG5qWWFaSUJCQXlr?=
 =?utf-8?B?T1gvRkFMOVphbERMNEZORkRXV0cremEvTTJTSnNxWVIwOTB1b0JZK3dUdGMz?=
 =?utf-8?B?UE5yWW5IMUJFZGFPMHU2K0crTTdZV0ZiT3hYd2o5em5Ud3RFWUErM0VUWURH?=
 =?utf-8?B?N2E3MHF6czJvUVNRMUpWMy94cC9LNDByTk50RlhHRlVLNU1pRnJmRjZSdmZJ?=
 =?utf-8?B?cm5JbG9tNGd1Sk4veXZSQlFSc0N3OUx5SCtheUZ4bkNuSE91RlpoaUNDM0kx?=
 =?utf-8?B?SEJVVVV2UDNDd0hLbG9wNnp0RWs2QXA3Yzl6SkM2bHRSb1NOeFRYTitEb25u?=
 =?utf-8?B?YTgzRHhFQjVBZVdZaGFFNVFEOWtCZDJkclp5dTd5T3A4MmJ6Sll4WE9xUUxt?=
 =?utf-8?B?ZEdTMEJUWGVTdzRBK2N0eStHRjlWUjhqUEJPVjJSejE4L05qeDhyZlU4SUFI?=
 =?utf-8?B?cnFaQnhocnJQVlV2SnNlRDdaNkw2UFJ5QXJ6YlYxMlhGWTA5SVF6clBqTXFu?=
 =?utf-8?B?cVYrTWVZaktqR0FtMFg1NGdxMmpTMFdNek9ZVWxEMFBwZjI1c3cwZ3ZVQjhq?=
 =?utf-8?B?OERSUkQ5dmFhdUcwYU1SZEp2ejhzRU9aSmppQjhtWlRMcEpFeFVSSWNtTXJW?=
 =?utf-8?B?OWxUbUV2aFViV2dsTXNEZ1h0OU9UK3ZzWVhBR2FNWjQ5QjlOdk95aTNzejRY?=
 =?utf-8?B?blZtR1B5STVzNEVHQ3ZlUDV3THBwMDIyb2dneXpmWGtMM2ZKSy9nVXVqVzFT?=
 =?utf-8?B?WGdRNkZ0MXVjTlp3Tm5SUmYrbjE2Q21KSmlEQVg3ZURhSW5Gc0s5UndVY3Zj?=
 =?utf-8?B?OVRrd2dWMi9wU2M2SWlSRnBVR3dtRnhyMFBLYmJ5L2czRStkbldlWXFkN3Yr?=
 =?utf-8?B?RWtJSGJvZzV4YmFaTG82OVZacElEcllxUDVMTFdpbWpVcEdYQ05NMGpvcFJa?=
 =?utf-8?B?KzJYZnVueGpMdjRXZmlnQjFwTW5wYllaWDhXSDRDT1ZXODlDOUJlYTRjckUy?=
 =?utf-8?B?VkpETzBnSmJ3c2lxeW9uUWxCNG1JanYrUUxORnpYQTFVWlFWMGZ0TFJscUxO?=
 =?utf-8?Q?Rmy/97Xafkm9LRnwG7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee89eb72-6b81-4af0-8a5b-08df09ed67c4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 18:58:56.4579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KiM8qCxQvnyBILzws7vaZ8yFYw+gG3zSKaciQZp0Ytlfe+KyBS9SlJlSn41C/NkK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9590
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6E93E40005
X-Stat-Signature: 7wi81d9a8hy3q5jw97zruxepw5w4cdeu
X-Rspam-User: 
X-HE-Tag: 1788461943-805320
X-HE-Meta: U2FsdGVkX18rj8M1sGjcTjpGXDykZFJCEBXcLKkOlePf4jZEu54+vjtaiM1tJdTLw5Ne7eFqaA3keTxhG1ZsgAqJXRIb2HnSAzZDtJlo4b70H2S2fVqFmKnoLqn/0o0fkj0uzjrMKjf+Z/o61uPB7Mr+WPLCWe7kpgDKKe5L63Jpyll0KfFOvrYFk3luGCCRkQXC6QFjZpibbumFNJrEc2yjLikc+IDz6txLsLf9LyrOildzH6wcr3a+bmVRu89E4iCsPqPl7TKZVyAjbcJyzUhZtC7G3OgTlG6+lW+W74JCGC9tGVkQ9LDIpKnUgLlyO7jKiUG1QdqnlPSzwHzHys2cYBx/1wz15Iy+uwVVIqjxsbbs35ApvcWW8dRHCrqqWhH2JsWq/vwqqoR0VAuDq/tD91q4UDyTfGf7mBWr/Vo92UHy0A2Q2m1cGjX1EqbsU6E6Fn7kpgqPJst6Gj0Sx1VV97moNWZY07Xs96YHeeuMlyIBMyapIy0Dqpa3Pu6xRXj9BnPlLtsnupFpAsbxhNcRM1WfBLoiafChu9sV/H3hgGeW4sq1Cp8bcU4m3xgHP3pIvj+3Ha3/L2I83d/m86YubgNjUWKrFF2bTVmuiAO1XTCJHe3fAK5rv6/zkD7YhK/l5r3J0e5LxwsA0KkauLWL58ANyXk/QU7DK6zeBAbWSYM6w56gC6aR6qeUWvmLVQKtoz4aWJqiV23shhrSyGgzmfdjUEWo20DgvAuHOIEDka7IPR8bvfT2VaC2Wv+gf9UMjqxBuZmI46+cUx+sLasyRQ2yiB4Nl5AJySGbVRPAHvmgGOB9QAEwY7RdsuzUFcaFuqXNGw7/4RqA1cdBgKNWL4hoJ07HTigLiptJvljkf7CnJUE0vuYO+fiZqX+pPZalERKaHo5AVljdE7y1AmpXpm5lyA+sy+R+AYToqSO8fK1iB7Cd9DTZBrfIHzojAS4CIG7rz8NDT88yC96
 R2Pb5lob
 54KZ+4eIVE9Njeaxnrzh9iel9fuaFy4QqDdAxn/Qz1nX5FWDrALTcg+7LhcibGk2iDCy+pfdLpuM3YNaNl3vM/2hBeLo9REA4njaB6sM/lhRytZ7cDJ7jxAdC67rSD2kiHpXFUh2tAC3aa8SuGVSbt6C9VmF3BvueRXt6wpBmr68gKFras2kAB0AT1jURmoiVcy3X0zQiuaDtoD5rTfkpqzjjhd6XcifyV2rwLHUVW2yPtNXAe0NfQ2f0TPVqBCRwg4CbYROWpOBl368A2Qzy+fiE4NQ8sXu4Egmk0HWv794lsxdYIrBMDQV1ne3Q3CPLZ7tRMblLyctEMA6Ov6svAYe7CN7k4J4KkMqBaIoLip2FB4qogsX3yRy6KXZ/oSDp4xqdN3yRFVyvHd8Ud2dutnmGbsK7/ug4xvRZHFJnD7PGtNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> If you look at try_to_claim_block(), you need half of a block to be
> free or compatible with the requested migratetype in order to convert
> it. When memory is full, LRU pages are scattered all over, and
> compaction is not involved (order-0), this gets more difficult the
> bigger the block is. You can get into a situation where LRU reclaim
> will not clear sufficient room for conversion in any given pageblock
> anymore and you're stuck with the type distribution. A large share of
> buddy requests then go permanently through the slower fallback path.

I think we are digressing from the min_free_kbytes discussion, but it is
good to understand the limitations of our compaction and reclaim. Nimrod
is going to run some workloads to show us how his patch affect 4KB/2MB
THP systems. Based on the min_free_kbytes calculation, this patch has no
effect (on 4KB base page system) for a single node system with 272GB memory
and a two-node system with 484GB memory. So smaller machines would see
the impact of this patch. For example, a 16GB single node machine will
have 16MB min_free_kbytes instead of 66MB.

>
> Usama knows more about this, but we have seen this on GB300 hosts, and
> have JUST started to deploy kernels with smaller pageblocks (2M).
>
>> Basically it indicates at some point kernel allocates a lot of
>> unmovable pages that use many 512MB pageblocks and the life time of
>> these unmovable pages are so diverse, leading to all these
>> pageblocks remain unmovable and free pages spread across all these
>> pageblocks. I thought bigger pageblocks can keep unmovable pages
>> constrained within fewer pageblocks, leaving more contiguous free
>> memory.
>
> The idea is that the pageblock maintains contiguity for the largest
> size you routinely expect to allocate.
>
> The page allocator is very passive right now, and it doesn't work
> super reliably. But even in the current regime, smaller blocks have a
> better chance of containment.
>
> For example, when the ever-growing page cache runs out of movable
> block space, it spills into unmovable free space. When the next
> unmovable request finds no space, it runs LRU reclaim - which is more
> likely to free space in one of the many movable blocks. And so the
> next block is poisoned. Smaller blocks have a better chance of filling
> up natively, means less pressure to spill into incompatible ones.
>
> And the higher min_free_kbytes, the more likely there are still native
> options when the zones are down to the watermarks. E.g. better odds
> there is still unmovable free space, you just need to reclaim some
> movable/reclaimable space elsewhere to satisfy the watermarks.
>
> I've been working on making this more robust with the huge page
> allocator / defrag_mode stuff: instead of falling back and poisoning a
> block, invoke reclaim/compaction to produce a neutral block that can
> be converted entirely.
>
> It's the same idea as the higher min_free_kbytes and watermark
> boosting, but it is more targeted at the end result: readily available
> space in compatible or convertible blocks.
>
> But with that active regime, oversized pageblocks are even
> worse. You'd pay ongoing compaction work to produce a level of
> contiguity that you don't actually need.

OK, digress to the compaction and reclaim discussion. Isn't this 512MB
pageblock size issue also telling us 1GB THP allocation will not work at
all? It is a proxy of 1GB super-pageblock.

I need to spend some time on it to understand all the heuristics and see
if anything can be improved.

A quick chat with Claude results in some items for me to explore:

1. reduce pageblock conversion threshold from half of the pageblock.
That can reduce the number of slowpath entries.

2. make reclaim pageblock aware, so when an order-0 unmovable page
allocation incurs a reclaim, the reclaim will try to get free movable
pages from an unmovable pageblock first.

3. in addition to produce a neutral block, compaction/reclaim need to
repair unmovable blocks by getting rid of movable pages. Proactive
compaction should do that too.

>
>> > Seems to me the excessive min_free_kbytes is just a symptom of a
>> > deeper problem.
>>=20
>> Yes, our anti-fragmentation mechanism does not work as we expected,
>> so that we need an excessive min_free_kbytes to get khugepaged working.
>> I wonder why reclaim cannot get the extra free memory instead of
>> reserving it via min_free_kbytes. Maybe we need a watermark boost
>> when some consecutive THP allocations are seen to achieve similar
>> effect of boosting min_free_kbytes?
>
> I'm just wondering what the easiest way forward is to fix the ARM 64k
> page problem.
>
> Yes, optimally, reclaim would work to satisfy compaction space by
> itself. We've seen it fail at that before, though.
>
> How critical set_recommended_min_free_kbytes() is today is a question
> that neither of us has a clear answer to. It's from 2011 and a lot has
> changed. However, knowing Andrea, I'm willing to bet he added this
> based on seeing a need in testing data. And I would actually expect it
> to work better now with proactive compaction, since that has a better
> chance of turning low-order chunks of that volume into pageblocks that
> can be converted instead of needing a poisoning steal.
>
> It's a change of long-standing behavior for everybody. It has a
> regression risk and requires careful evaluation and testing.

Not for 4KB systems with large memory, since khugepaged's
min_free_kbytes is capped at 66MB for one-node, 88MB for two-node, and
44MB + N*22MB for N-node. For a GB300 host you mentioned above, it has
494GB memory and with pageblock size set to 2MB, it should be a nop,
right?

>
> Meanwhile, adjusting the pageblock size on 64k page arm configs has a
> much smaller blast radius, appears to be the right move ANYWAY given
> what pageblocks are for, and makes the min_free_kbytes a non-issue.


--=20
Best Regards,
Yan, Zi


