Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D33C5AD2C
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 18:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CAE76B00CD; Sat,  8 Aug 2026 14:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C6F6B00CF; Sat,  8 Aug 2026 14:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1437B6B00D0; Sat,  8 Aug 2026 14:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE9EB6B00CD
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 14:04:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 75EF8A2453
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:04:36 +0000 (UTC)
X-FDA: 85078877352.28.4729425
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013046.outbound.protection.outlook.com [40.93.196.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id A27A9180003
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 18:04:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P8QbyX5R;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786212273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRcNipL5dTGS1bEpyfPStMrrkq7kJz5jpIZuY1IXjy8=;
	b=EzSx7VmruBuiKXNoltuOCb7OiS6OmCzxyxHHEAC1D5WFko5pfa9rrZjXmJOvYIe3WEHbmj
	S7fa4X12h3m+NQoTBFM6/dqQIXau6Ntrzsbj3RKKb4REwFSxOQYNBr0HvwDGRJexdmeUKI
	PXgp+LDSSnQajIgTj0z2+WVF7sjTzP4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786212273;
	b=AQQ/96hmIRrIT5tsgkuHf/2VHyvB3Z56A3DSwhiezJ/FPLcSi9x6gIfe97njVENHuqZEjM
	OoSrlsxewYtPSz/LskdzGWuwwOAtLjWoTGejqnRXysuPVOaPbtE2nLelCVak8CzR6ZTQsT
	LdbWPZoRLNZE3YTjf8/4POELE+LhEnY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=P8QbyX5R;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IRbKBx2JWmXgwtQx0X7sNIkZfx2MWDYbKlLvt1Ex611VAdhxY2rAgaYYL1HW7ehNE4jHx7SkTIWxWq1D1ArePyPTGlsHj7WUeWJWNpTsoG7xzg/Er0xu4xiMdkUVyI1uglndVr/c3CuFqyMhX9Ub41R1tiqWok9f/nhcoaQrhscYVKbzn6MAqdnjCnkLky9xcsUf/v/YZM+e7BnO4skkKQEViJUJcqbau+Sfh+fiqszN1gmXys6crbbt0pG6X12O8hhjwLdLedd5obPlvE3VJZ+9jv9hXIgzvLC7Bp9rtnAw39hmevuJ3chYW5PHCnKVNaTb7Q7y3rblVhSxzL3Wpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lRcNipL5dTGS1bEpyfPStMrrkq7kJz5jpIZuY1IXjy8=;
 b=JlYMweATK4FPE+ZMJlCfuj61HpdvGCRFqloSHwC6krwxCB4GU50wnePZIkmz+qPODi5qRlBwsgkAAgwNqMIWMUEFa+B7d8TW1YMLNE3JPBtg1ymrjrcpl3NvtMt5lyQ9VBLasnYeX33ueI0zwYNGbL1NAvqWoUaeAc6GxYuo1J07GFh6DB5rN07tD0A/QW/6ucqKnJUYIxg8OPA8/5KAYlxCbWuE6KOQjjSJew10s+AATh+T5vE9CPd3veQb2QHcCx7oxDRQJ+MaqXaVzQFPfyeJO3Lfa4NA3Bi1APA1TQt6+fD5cupkGmjvPqnQpFmNk71o4n9baQnl9Fnu4kH9FA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lRcNipL5dTGS1bEpyfPStMrrkq7kJz5jpIZuY1IXjy8=;
 b=P8QbyX5Rhb9GSYhixc0+LIrWydQ0pxWoEx1FzxvwgUmGROblaT67VfTp8197AtUytRK6mRladbF8TEN3x1GW24P11x+I3Fyz21Nlih9AExDPJvdGELpizmUuGEq0+YAc5XTqMOcMndwpaBMbn4ll+fgFokNZlWUBW/xvmjv2+R5sv5VVOFaiqbupn0zDXfEs6q09qV1hkGFr+92HgAH19RvWHsgfttpWXgn83qsIXN2JOptvTNNUDTbNOoQlSVtZfWOJ2ayO8bjDyhCx+vYN+sl1iZGEPjSt956aRbuXAT7aicBAor5LZjZcOj2bwi1XwlMhpprcWrl8m/9e7s0nHQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV8PR12MB9691.namprd12.prod.outlook.com (2603:10b6:408:295::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.24; Sat, 8 Aug
 2026 18:04:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sat, 8 Aug 2026
 18:04:27 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 14:04:25 -0400
Message-Id: <DKJREIP73LYJ.3TTIRZ61HM2ZG@nvidia.com>
Cc: <linux-kernel@vger.kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Barry Song" <baohua@kernel.org>, "Youngjun
 Park" <youngjun.park@lge.com>
To: <kasong@tencent.com>, <linux-mm@kvack.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH RFC 03/13] mm/huge_memory: invert folio_ref_freeze()
 check to reduce indentation
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-3-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-3-689939a7ccc3@tencent.com>
X-ClientProxiedBy: YQBPR01CA0164.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::27) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV8PR12MB9691:EE_
X-MS-Office365-Filtering-Correlation-Id: a434f85a-d5a8-4427-59d6-08def5777c9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|22082099003|18002099003|10067099003|56012099006|11063799006|4143699003|6133799003;
X-Microsoft-Antispam-Message-Info:
	CZb0+FRFArmhpqRlqY39soshkrQxtmagqpqdgx/8KIjVkISNzwOU/O7/Q8eufcVdF95Zo4I3sO3PO3ktDQnIZTtAecgsVv1a4rKJUNr/uo9suhzD4MUmquRhAf2rGd/DtlUupRg+YJ4aJMxKqkgwo0aflDT+zzQpoPHTQhTXVnfUP+EIfJWE3xDpqbvYjqY7oqRGDJCkqI0BrpJUX9sQm5UVGFCk2x3cY0hl8Y42I/t4tu5fuCizHnuUixrOmoM6YzJwoHygo70TX0Cle/f9FeT3tuaLse+UwMa7Rx/GZGa2Op2R9fi8iqDAHOST0FT6EpTu6S0omMfbNW9oiWMH5pmW5TwMduZStiZ8T6lv4c/xh9kP5SVWuMoIbFQNjzY4qaB2O9XvWcKIjR9k6LN3eUOKY49NSJMgHqkVMtApJIiqp4GcV/LO24rzgme3azh9Wjq2TwSseptQBBHYEUgWdmTAUJnpUstwpNPaGRPoAj0AOMWn74er0j7DM2h4ufwzn4zbgL3r9W0h8OpPya5T7fBfeDZ5Yjd7KGsICNNJaztZQfbWJYKZcQvVJkyL64FwuBPScKZcdtRnGIUi3kAaesMean1sC4cWQPtwjg5zNVgu/Zo/5AkAg+08AQbYqe6HLPrwpqgYbKDC+6Zz4j0n6W0/ZjUgOEk9sWyQw+zr0bk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(10067099003)(56012099006)(11063799006)(4143699003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bkNiOWJiMUhId3h5NFVyWGViaWdLZlV3YklUVS9hdzRVbzBnbEVMUDFsODUr?=
 =?utf-8?B?clJnNjhCSW9PUENPbmJiYXhoV2ltY01ERzBKdktNOUFJaVBQS1JCL2gxcGM0?=
 =?utf-8?B?NGEyMFFKVGxpVmo5eVFDNFpnODhXK25iOTZrb21oWTdRdlhGNGgzcTliSUt1?=
 =?utf-8?B?V010SHJsMEtiKzAzelU1Q0s1bGYyUW8wTFpJMkh3R0oyZm9wcUQrbmFFMmx4?=
 =?utf-8?B?RGp3NTVreFJpdmdYc3NxZGZZN1Irenh6SWFyZGUrOGxIVDBDR3AxT1R6Qjdm?=
 =?utf-8?B?bzZhdnhUaGY2dnV0cE1yUEdUM2xZV084R0Q2Ylh1dHVleHBLQ1Jab0RZU2Zu?=
 =?utf-8?B?dkRhZjVvaHFjZ295VUQvU29BdkF3S2JuUm1LcFhaTjl2ZndxNVZsUDBSNXhw?=
 =?utf-8?B?ekNNUFpSWjlualJwZ2kwRGt5S25pRGFrWU83NkI0c3dudXlSQ0RpL3JIeWhh?=
 =?utf-8?B?cjNuQ1FmN3d1ejU5dURSTlM0dGUrMStVRmRlUitnSHBnQ1J6RmFMUEJJaTIz?=
 =?utf-8?B?MHFHcXQreFZGNXVvMm1HYThVU0FhTjFKUlczR294NlM3MHVLK1NOeFZLekxk?=
 =?utf-8?B?K1czTzlkWDhEQjUrbWs2bnE1QnpTVUVUbVJoMTFyZ2k4bEQ1UlVNRWJqUHFT?=
 =?utf-8?B?cXNuUlN2TEU2dnEzbCt4VmdhcWVzWExFV0JDMVZKQ24waElwMkFnd3Z4ZUE0?=
 =?utf-8?B?UFVvYzZEdTM0cTlSUTEzTkgzMldIYWpSVzBJMnlyZlpqNzlYSzZLUmhiOUI0?=
 =?utf-8?B?VjFSNUF1SHdTK01BZzc5ZVBNTStNcFhuc0JhYS9UeVNsWVpDLzYzSk5ya09r?=
 =?utf-8?B?QlM3WVE3cE9yamE2SnBVRHlvLzNnd1BsYmdxMEtGcEZ0UTNjdmYyMmQxZ29j?=
 =?utf-8?B?R2o5THBDTm5XdkY0bklaSzZlMlRUNGpjcmZ4Zm8wdkxkVngyOHJPOGV0bXVE?=
 =?utf-8?B?THJ4WXZBSkR0bURPVDkyTFEwRVJuOUtTNzBob1liZHVnSlM2dk0zN2wvZ0VC?=
 =?utf-8?B?NWlYc0E4SExIL2huWlNVaDVBbGtqQlBuY0FpdjZmaEJvSGlTSk0xbVgzdElm?=
 =?utf-8?B?OGowQjlIL3F0b3FIVllXUUVTU3RaZTJsUXBYVzlqejQxMlNsR0FKMHRETUhK?=
 =?utf-8?B?bkIwcnJwVlRPOEJVN0dCTkgzZTI2K0I4U3RLdlJJbHVzc0VVQVlEc3FQc3cw?=
 =?utf-8?B?NVd0czVCcm9udTU5aCs1MU10VFZpQ2VnOFlrOEFERWZtOGRQT3hsU0lTSy9Y?=
 =?utf-8?B?NW55R3pwSGJHdGFRdzQ5cXdCNlJ1RTZHWit4ci9QTzBMMjVDelBib21PcFgv?=
 =?utf-8?B?Nk1LU1RMWjlsejRTZHJLRXBUVXFvRndhN3FpQm5Lc0FlMFAxOXhwcGZjTWJG?=
 =?utf-8?B?dlUya1ljVjA5cjFraWhKS1BCYVh3ai9kbWpnQ1BwQWo2K0Vyc3l4Ykhxb1Iz?=
 =?utf-8?B?VkF0YmRRRDgra1VFbU84eEZYVGl2eEh5VzNlSHA4SXpLT1MwRC9CMjc5WGxM?=
 =?utf-8?B?d0dzYWNRa3EwQ1diMi9CZ29XdWJ2OEcyQUVoUE15U09CYjdVQ0hBbXJGaUgr?=
 =?utf-8?B?Qm9ub21TVnZndnR4UkZGR1F3VTl1TjY1RnQ1MFB6Rjd2K01lYjlEcnpidkpL?=
 =?utf-8?B?MmYzUXg3cTA1UzhVYS80NUFnMkYzU1pEV3lReXBRQjRMOHluRzNrZUVUZG9a?=
 =?utf-8?B?Vm1KRGl6aWxvMTUyUk9zNzZPQU9SbWRHMHVLckxDbDN3ZUIrYkRoVy9TSDdn?=
 =?utf-8?B?YVh2OWZiRVNxVEFPNVlIdC9GR3plUEhreEl5WnhFNjJoaGV3Zkxvcnd5SjJK?=
 =?utf-8?B?VjBVUTJZTlBLQ0JWMEthQXpLUmorTE4vVVJuUElmWUlGQ0UyWmdKclgxUDZJ?=
 =?utf-8?B?VjVIdENPOW5saTF6bmhuZktOK3c4d1pDT1lLTTRoMmtESjlKT2dRbWlSc1Zj?=
 =?utf-8?B?Ui9Ib29sajlYY2MvMlhkcjFjTHhGdzV3THU1RGxiME9WVkxCazdQOWpxQ1d5?=
 =?utf-8?B?aUpHTGdCT2xzNjdXSFo5ck01RmZ2M0FUMWp0bkFpV1JscGoyczdacVRDcWdV?=
 =?utf-8?B?V1FGZ0JXUmk2NHNLUkdCenZQQjU4RTBSMFg3MzJsUXVOUlpVLytYamN5WnVr?=
 =?utf-8?B?akZxN3BSWEFmZGdXS0xiTHdYelE0OHF0Q3Q1cGFOSy9PcmJqS0tIeE9ud0s2?=
 =?utf-8?B?SXduTXZqVUJta0ZPUzhvdGg3SzhuV1BjMnNuK3JOTEkwNnk5WEt0d1ZMb1Bq?=
 =?utf-8?B?SkhGTzVjN0w3dnFRV2h6OFFaQXRWa1FPalFnRUdKOVk4V25BRElpZHFRd2xW?=
 =?utf-8?Q?ZrxhVnTr/FcIyqX8hh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a434f85a-d5a8-4427-59d6-08def5777c9d
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2026 18:04:27.4994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NuLIV+2Ftil+NAnvwyh+vjKG/TiASsYq34zVCmQxtBycR4dcS7ts9PH692NIjkTk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9691
X-Rspamd-Queue-Id: A27A9180003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 8m6z5gedxpsnkxsodp98n5tejuw3wgc1
X-HE-Tag: 1786212273-775609
X-HE-Meta: U2FsdGVkX18+n1e6IC+cKuZGHJrAsB9ysXJ6G+SR4HU/NUsF1jV7DGmbG3IOiXBWoXi/dNm9BXrcbNVcg0jiVIXDVmjqJHT9GlsttfH4WXgLrRu8hYobRRtnBTH6ij4aOJ4mQm9JCrdQwr9A1bbpVcOAka7uhwUJG/kCLqTtVrebrTOn1LV1chlkDjRH3Mh1fzzY+LgGNhM1BCUJv4gRGphc7NIRVUj6C7jwxbDapm7LOXmg9QUyVaHMws/fX6UvSA6NAiM6DEbqNFNbfG/snQYK6K23DInC7M9N4v15FydQskitiMO8u2e1QXgK08cbTZDBklKf/GMBJKiRbm1J7pHdvBkSdevSxLQSebGSKFJo2KYFAkywZEzjuFiMHZsyAKJJGvpGzXx+6sag3y7H7rNxI54xaH+jZ7aZEkgtEuLJG5BUvRuGD5FjCmMjxPO/N0rNSgEJK8Q0HpNlA25yKPLC0P2wGmEQ9MjwyWQS0HaH/jQcdsyvf5kw61lwxfqRjw6maQTqKtOq08U27s4LK8uZKjqAAJA+X7WlwsrI53UpRgvGJyd6Il4q4Q2ykELBojWSFeIy0Fkr/6p2sgd0GwhogrkUV7Rd7m0qh7ob3FIaDmg+7Mwz3GG8PspjyDh9vLsxIzD0BrRdbiDn91p9jtMPzb2qrC2ZrhGot3lKxGz0m30e6BU/MgTZl/eTIsYb5qPoaG/Q64zbWIdhQBYTVYF7uRBga4o6nxXoPsnpbtcw9RVsg666mYGLqbaxKZ47J3K+JB490ABITl2/lMt1YuM9a5OHgM+r2iX/tnM/YYMVOAS994MDHhNUA8Id8X14gUBPq8Gaz6wloJ0mXDLlYmpLjypyGrtx1TCnbM2N+tqPJ5XMyprB9BpKRoq1xVImUA9JSvs9MhMy/a5TxeWNZJYyqAiKdkr+ZWqsKzPtMhGhiJExAQsUpMN+JWudm9uQ8iiMf55QCnOvVVbCMqk
 ZQKiznaG
 iHCqWPOr1pHdHuLce1ldrDrWLY1+I6RK5ZmPRofhLmgg/irvEKv1FuPWp/fetPaEaIEtN27pStDZLp7WWrKoOXWzj8iJ4eVH5i7AgOStBtDoaTt+5C593jDZGoilCgaJ4ya8Wud79sK1MxnpKWYGCBcXVj2jDttMEHtOiqdiMadvSLLcrsINNPn7jc2SkcgJ31x6EyG8V4mR2qZQXaGffahiJhRQBN3jfxPl9uNF0KzIZsqyCMU9TRFHOewdlXwoiQ2TrtfmKmndlVvMEmzFRPqFTcnCMy+pEarWmMJORIhoxgAENOzKyHmeEw1WLRSJ0HMSc5l9cX55W8CCYZVPrTK5onseQ/2QBwRSs28UJjk5FULgMGQlPL8of/sTqp8drN3xJWkNH8GTmuuXjU+7QKz6cPH6VLVIU8Qt4DNDw7+tuc4yMkRM/nwO8iJg51OY9Pj6xY4CuNQFAvk0eOvD2wvhM/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Invert the folio_ref_freeze() success check in
> __folio_freeze_and_split_unmapped() to return early on failure, which
> removes one level of indentation from the entire success path.
>
> This is a pure refactoring with no functional change.  It prepares the
> function to be split into separate helpers for anonymous and
> file-backed folios in a later patch.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 181 +++++++++++++++++++++++++++----------------------=
------
>  1 file changed, 90 insertions(+), 91 deletions(-)
>

LGTM. Thanks for the cleanup.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


