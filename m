Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66CE7C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56F566B009B; Mon, 31 Aug 2026 10:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 547A16B009D; Mon, 31 Aug 2026 10:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 436C26B009E; Mon, 31 Aug 2026 10:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4E96B009B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:50:26 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10885A23A7
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:50:25 +0000 (UTC)
X-FDA: 85161850410.29.046CEF9
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013058.outbound.protection.outlook.com [40.107.201.58])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4874020006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:50:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="j/UJrN8d";
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788187822;
	b=IBm5XSunFgI0aayVDVmbrC9jfuGudePDUXMqN2Kz4SgK51QIhlEYgEZx2Pe1q2i1m4dtXV
	xmmsnwJA2zHxPGEzhc9MG0D+nN1sI52FxzDCL33Lwdku8R1icobH2DrRWFdzfqr/uPuuYu
	utPjDn4fw+X8DYWw77UB2J7eGrgk+10=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="j/UJrN8d";
	spf=pass (imf31.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788187822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8akAQvzs0zix3Dopedb3K8qPBC2Ec5NjtaXfg4uaig=;
	b=4lX4z1FwTG+AMen61XczKdcgPM2j7R68gPsuEPRpEe6qMErW0OA+0DTP+DjdQPesVK6pSJ
	/bug0QXBQLsjRENwZTKVVmnc/48+EIuOITBwEQfPxdBlKPEYVxIGWF8SedHLuVAa0hWBe6
	OAVp/dtuRhXCb/qmMlucm/re/LtsCkc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AOPe8XA5TRLn9No74HnJuv3SPJt7wMHOq5iCD88qf7rtuHz59sHRCwGjGQkAr7ov3rcncXsvT3/OKJyntgAgurhP6Ma2BAIYfrXUDbRA+iBR7yxYIMl7Q1FE8gA7zRfrpIhmyHjHpihCnL8hbB5rZO/mJ49MOhGAdLYubbC8KItNqNOjhtlp59oBK1zqCjEu+JXaG/mRgLzqVl+vTrH3e0l0c063XX5qvYvAkJlrfCwcOYWUJabtvJd/vm6WfJUeiPuJ0UN3Ts1KqdrKGinBKh48GJZhGpg7whN7Xo40+Smody5KIvGoxQ3DiSwPBkLEDVOZIbEKpGhm577cJ5LC1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y8akAQvzs0zix3Dopedb3K8qPBC2Ec5NjtaXfg4uaig=;
 b=xp3HbpTnbRamtaH1leoJRqK46thlyV3v6iRUSdydSkgtfx7RAExA6UXf7K5Bc0Huo4wcCOEJGmj9GJFi7a2m6jJ5LckTMo18GknDBLRVAaS0YjtHFKzu09+LfSoQiZwrpr8+q97fHJkOcnPalT26OvFSeGK44h2X6vUvdLilw9tWjb3zinPjA81v7rjsf6lPte3c9ON991pnHNb+d+zlu59lTO1BUuRFYExGufQxHJN7Lx5npThXECB1NgGxjfhrzAuI7lsbElMlCFcapGY7wOSGjwrpGseFPdigHgadIIrd4p9XynbbbzX8d3hukB15oJA3uT7r4ybG5NNUv0d1LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y8akAQvzs0zix3Dopedb3K8qPBC2Ec5NjtaXfg4uaig=;
 b=j/UJrN8dUH7bvy5MpiRkpNFlh83GI71d6rOIyYJYLvxd2GvyfmhHtGTefdaQCOXsIH/P5+O7QOfXloFaRyT4CjwE+MxAM1fwfBi7m58ZEYueYR0ESFFRES4Hc/XbzQDCcreO3EwvAZfzL4UwNi/mZJlnNcijeW34Yb7YCzXYiS+MVTwsLFe9bNCdhVhqaI5LM3LHXk9Osgco2EoXIDFKtheGJeJ4xonOppFbePMyFlAgbx6s1m7aHs8lT50gLF/TnZfcW2fL4BzPAuppic5jvQMI/7/Gif0HQVHP3POIUt/zQNdkmEJG0zY+K4X1aJaSoQDU8D7pF5hSen8RUeVdcQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS2PR12MB9637.namprd12.prod.outlook.com (2603:10b6:8:27b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 14:50:15 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 14:50:15 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 31 Aug 2026 10:50:12 -0400
Message-Id: <DL37OCFFKFCH.2VWZ3CMY3EFG7@nvidia.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-arm-kernel@lists.infradead.org>
To: "Tal Zussman" <tz2294@columbia.edu>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Kairui Song"
 <kasong@tencent.com>, "Kemeng Shi" <shikemeng@huaweicloud.com>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "David
 Hildenbrand" <david@kernel.org>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>,
 "Nico Pache" <nico.pache@linux.dev>, "Ryan Roberts" <ryan.roberts@arm.com>,
 "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Rik van Riel" <riel@surriel.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Harry Yoo" <harry@kernel.org>, "Jann Horn"
 <jannh@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Yosry Ahmed"
 <yosry@kernel.org>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH 2/8] mm/huge_memory: use folio_swap_entry() when
 splitting a swapcache folio
X-Mailer: aerc 0.22.0
References: <20260830-folio_swap_entry-v1-0-7786b52acbc8@columbia.edu>
 <20260830-folio_swap_entry-v1-2-7786b52acbc8@columbia.edu>
In-Reply-To: <20260830-folio_swap_entry-v1-2-7786b52acbc8@columbia.edu>
X-ClientProxiedBy: YQBPR0101CA0258.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:68::35) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS2PR12MB9637:EE_
X-MS-Office365-Filtering-Correlation-Id: ed904f6f-207f-4718-4a01-08df076f2aa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|56012099006|11063799006|4143699003|10067099003|921020|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	3TEW82jb6JknhoRk/jCJB1u4o3XTO5hImIevrqv1ew6QZvStdAtGjPkq2YWrfVMLHFzKCrUqKU0HZOWI7D2WAjANuGg32YYsp2eJepGeD5/v1Z2zlrorwuh22OYS2p49q0M5ilVK2Fddq5DzPqOWSRyUHLJVopxXgrgSDNZPW0cDTKY/+Li0q5k+wTtjHUPsru+O05TBqX153uSorIvPacxf3Y65k5j/sjbBTZ1mNQfB/4ha34tU76ItRB1W+Z7hckiPnFPelu3xnvCWMuGlkQfUVzNV2HQZf8+Y3avTLDUrtEwag/IcyYLo34DpRwmShC+ZK+3UONfnzpooF7FatG41N0sUymfsCUBOuzmbU3RCHJyFiVsCsxfVke9/95E3ucCKZD2JnBWIdfPxX5zxnCuNdYTSjvEBrEfVw6KYrSdU9StqSOjv0hrF9WXKQeNnqUALpvAUlY4yk/RULmc+iSAE0ogJZEGqCa50hStRPi5bBM/7/vj7q6cdx2GHpk95Iwah4Q6zFzhx+T33uGByQ2rOlCnJXIgLe8PuyCVI1xv1/ZSf3vhpPtnRFmqS3auIER6LpcosS8g5dXNhcJqaZO8EYCw5f5oZIMuTgkTV4gvDsF05q0MCCEp24mY2XTkUnNiAX55wlCMcQcvVqcMeMF8Xt6aWt0jAtdbHXfVXKSNGy+gQMPkfnA3wnnd+ckWG8jxmrlX4FuSmZ3OmhxsTzg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(56012099006)(11063799006)(4143699003)(10067099003)(921020)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?elZnU2tVaW5NZ2lWNCtENWVpWDJXYTFNM05BK1lsNFBmcDhmOExQeVNuc3Bh?=
 =?utf-8?B?am0xY2cvdWNGaWVmdmpxVGFqek5mNEdGbFUyZGJZZGxGUFVlZmsxUXcyZWdJ?=
 =?utf-8?B?emY5WEpUVWJ4VmNQNEtlVFFPRHlZWWJ5WTJvZVp3VUJzSHZsYzJ1RjVUMTdP?=
 =?utf-8?B?akhTUGdZN1M3TW1JMUFZanZKWlg1R2N4QndwQkxLUkt1OHp2YUp3OTJCZXR3?=
 =?utf-8?B?NzMxUDJqSE16K3pjRVJkTlZocTE1MklEb2xEM0dlNWVBcHMrcjVMMkpveEh2?=
 =?utf-8?B?T3RqZmdnb0NxdGlCTlVjNTU0aVVPZDgvT1BkbWQ4MWw3OXpiUXJUZ3NjeFZR?=
 =?utf-8?B?WDVCOXFDQmpQNmtWL2ZQODJnY005cHViQWhTWGN2SlZuMlR0V0tON3hib2k3?=
 =?utf-8?B?WlJWejYwcDhrNWNwVmRYcG9nWmtleEJWdE9HN1lwOEpISTRweEpKOElVb3Jz?=
 =?utf-8?B?MWdvSXRadGZoUGx4VjNlY2FqWUxTZEV5ZmdQZUlZM3lTZ3paUmZhcEQ1T05o?=
 =?utf-8?B?YlVrenBXa0JmMFRzOUpPUERGeEZvT2tDQzBQZ3BPMzAxblRiUTVhUVhpWmQ1?=
 =?utf-8?B?S0s2TVlCTWdzMDhCc0RDVzBERjZwNHUyMzc5cXJ5NUgyVFFCLzVZT1YzRDFw?=
 =?utf-8?B?RUQxZGRzdTRFM2tteStjL0swOGEwaVlONDhoWXZrSDR4TGorTmdObjlkNTNL?=
 =?utf-8?B?OWswU2VqNWREZ2ZlN3VCSEhtdWRXZEJCSjdiTG5XVE9lYm53eGdNMTkySlNm?=
 =?utf-8?B?VGtOUGw5SWx3djQ0cC80d3hlaDNnMXFDcTQ0UVEyK0pkeHVBVW04ci9lWU1u?=
 =?utf-8?B?VHdKSXhoenREOUZzSjZpTVQ2T25yRCtMSHhodDRLQVIyd21QakdJZ1hXODB0?=
 =?utf-8?B?a2pNeldna1B2OVU4NDB2eFlPeHRzeTUreWpQa3dVMmQxdGQvSjBTOWpEVTZp?=
 =?utf-8?B?d3NUb3RYeE8xK1RyZlFWaWt6ekN6S3VNTWtwQzh3OFJPeUxJekpPb2JDOTcv?=
 =?utf-8?B?bDlyRnBCZzl5Nm1uK1BwZlQ3ZDRTNVBFRW93dGV0NW5MZURRSlN6Y0MxUXB0?=
 =?utf-8?B?YmpBK2xhVXNRSFNCWWlhTmd4TlRnZStHN29pUmcxWkxHclBXM1p1blhiNHB3?=
 =?utf-8?B?MGhmb0tGZzJlNkwrMHc3ZWtna1R1U3dGWm5Db3NLZ0dCclNwc2tZeWR5Nzl4?=
 =?utf-8?B?eVQ4M3dZK3lNRys4REhob2M1YVpMZ09pejAwclk5VmF2cHJkUTA5QjM4T0NI?=
 =?utf-8?B?N2MxQ0pPTnJiSHFkbDRlZGpUT1NXaElFMTNNUE1jaW9DSzBQYytUZ2gyNGxv?=
 =?utf-8?B?c3FSZFA4QmtpaEU0VlBIZGZQdUN0cm5yQ1lRbURwZVFVOHowY3Q1eGJ2eEVV?=
 =?utf-8?B?WDU3RmErUFVDOHBNdkJ4SkVoYWFnMldNQkJvZ2RJREdjNnl0ZXdESm5YUldk?=
 =?utf-8?B?cDVEMEppbXVDbnVqSCtMWWwrdkd2ZmhCakVWYWEveFc2aG5SakVuODdHOFlX?=
 =?utf-8?B?dnZ5MklMamVpb3dzZGhpZHY2b2M4eDhOMmhsSHhjZHNqSGJ1VXNnUU9waEF1?=
 =?utf-8?B?WTRtNVhXNEI1UTEzaVUwTEp0NHFGdU45cTlRNFc1b282OGxsaU1YS1JMTFhy?=
 =?utf-8?B?RUV4cjZ2bHFzVzJUZWFyUklrZEFDRWdXcGptS0tJblZPdEd3SkFIaDJsbDVM?=
 =?utf-8?B?MHdsZ1VKak81NnJkNTU5T2FIa3E2NGx1UU9Qdys3UFpzV2dPaVVJYVhQUjJ4?=
 =?utf-8?B?aTBERGx4NkZoa2h5TWlZaVVQZk1WcUttUzVRcTFVY3h6aVdPTHY2dGtnRTJ3?=
 =?utf-8?B?WUcwTlZ0RmZiWTZPV2diYzlQSkpvU1pna01zWVRrMStFWEJUR216QUtYV0ha?=
 =?utf-8?B?L3VLa24xa3pSb2o4bE5LKy9PVG5YelVHeStqT3RzWFhrSkIvNTJpMTY3bEJm?=
 =?utf-8?B?UHZDaVlqRWR6bmRtV3psZndqeDZDWHBHdnNndTg1NXozZ1phdmNzWjA2UkQ4?=
 =?utf-8?B?d2tQYm00R2paMkM4N1VRUlRUR0J6WDFCZEthSE9yRlFmYU0wUnJQT0FYOU8w?=
 =?utf-8?B?bHNQdUFOaUN2eDRxOUE4QXhsbFJsZnQwWFVNcTdkZk9uVDl6UFZpNi9Xbi83?=
 =?utf-8?B?dk02dExzWlJTNnJxVWVoMlVodmhkdlY2YXY4SzlkbEZwNFg0eVZFTlBuMFZK?=
 =?utf-8?B?R3ZzOUdlQUtjUmsxUjBtaEFNWlNHanVnMjRRTHNPV1NwZnh4NUlWN1RURm9D?=
 =?utf-8?B?cWVlUHhDSzRHRlhOVXc5VmQ5d2RyaEtNRkVIRTIyVzdMT2NUblFnYzBRWkJq?=
 =?utf-8?Q?yweXjbZqoDj7vZnKEg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed904f6f-207f-4718-4a01-08df076f2aa4
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 14:50:15.0122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ruIs+qOu/cJHGWWz+orX2ja+rY/w9MVZw7fAkilM/cu0qqRqVTKw0V363q6sklRf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS2PR12MB9637
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4874020006
X-Stat-Signature: 8mbjsdwxw1std7gx65qy3b9mtonozjz9
X-HE-Tag: 1788187822-91384
X-HE-Meta: U2FsdGVkX1/PDn+TKRh1dlvPzDRTQe095atapKt6Oh9g4vXcLa7cWpufFk8lifYW3qKl6czw0LjKqe9QauTxFaJ58wJs+sz4Ofl787QmYwYNo/nLm5/XUvkUvw3EpjnMwYswMFHwMueZG073gA39ln2+6j/m6jwl7uLbRan//6VsIfW8fPyeOvugm6jJJXSbLrVSlSq4it0X8KvqpUsIPQnMQdvJ7pEEGjKusWHxghFvL9v7YQ1t+JUrPDz1cIV2ClCzuiE7nSi4AkW+eP2xWviavzMCwBlxrZOhRywZCjL09QMwG7smKTNOaY+aExntFSMo0TCI/Cnp9HZfH7CSg3RvI/tnjDTewaGxmam58GieCB4zh8f+5b5lDxx/+Me+E7QL6OPbf0edfAyTL5faH6xIbZ/U83p7zK4+0uhs2jMuiW6CZ595gjsp5aVEjVyvbYNMc9XaQkN2mi5IUAU+8pSwR16ChJqvSZlbsUErQFxv08U6RNT/K4mq2poyTAslOvq/86idgsK3DPF0eudYu9rDI0Ees5zjPVocenGWqIkHh0VOHZ83PLdcepnnfjoYUYkB3GUgwsFsXnhl+/YokYti8Nd2ldwzI03SE/bA1bYX2oBebyj30WufEEzY59987oYs4hWSAjktJx2eKoGFEDICSgtiscD5TSWxC8e99Gx4MWrkCPu00wwlX90drEaZgQ1OHnus3zvIQOGjtS92czEm7I38gobapdN3XBy4RDbBSoWPCdf/PITtguSCeaUHp2/6kalsNE/encbfz5du4rL1u+JEDxxxWHB0TpUsxBzdBwCL8vHM3N+af++BxnmjgM8XA+ziqMa70XpFvNnmsC3g8GO6fGtUrq7JhTQZB4vsrB5sl2xWRB9FOsRkN7cL8jk3kPt7yz+Z0XXrO97l5r+spblze0SL0sbhhDApVL0QzbWdoNF0ZaS3nfZsbL1p9Y7TqXEySZrt9obj98A
 KKgyqYyd
 Hrh0r5xhZZkypi+XXIvTfdsSgAFok1oZ5x+iw32z1YFtH8I8zpzLuJK4CpxYwTxoVnGij3kabwyTGi78NJklr6WqjWyayPg30wAAUNaOFf5QWFjQWzKmr2reC3xzuGNOwL4O/HCvi7ZqZMM+1yOTsnt1mVMzw4c4IkwuMKGn/8PDn3/TthPOnjmXL43tLCO9JN5ajAOc205/Fpsjf0xuUtNExXAL4vQOt7vaIEdeNvgL2/airQTqopzdxnlJhl1mM1wDYA52BE2NYo0FeBDUlYpNZEEIZrVs3IQVRPkweIcRmni5uD0QaKskkMfWgtznK/urwv0KGfxGu9E0fz0iqciiIX9BdPXsGh07cmqJxnMlRyBX3lyJJm7b9GHmbmMdPjha/j0s/9hNLwV26aMVYFJiDMjMDClCwWRrMJxqcKaKrFXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun Aug 30, 2026 at 6:32 AM EDT, Tal Zussman wrote:
> __split_folio_to_order() open-codes the swap entry computation for the
> split-out folios. Use folio_swap_entry() instead.
>
> No functional change.
>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 54494c3fa983..03287f995d92 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3760,7 +3760,7 @@ static void __split_folio_to_order(struct folio *fo=
lio, int old_order,
>  		VM_WARN_ON_ONCE_PAGE(new_folio->private, new_head);
> =20
>  		if (folio_test_swapcache(folio))
> -			new_folio->swap.val =3D folio->swap.val + i;
> +			new_folio->swap =3D folio_swap_entry(folio, i);

folio_swap_entry() checks folio_nr_pages(folio) internally.
folio->_nr_pages is in first tail page of folio. If new_order is 0, it
is basically checking memcg_data in the first new_folio. And after first
iteration, folio->_nr_page will be clobbered. Without
NR_PAGES_IN_LARGE_FOLIO, folio_nr_pages() is derived from folio_order(),
which is in folio->_flags_1. It can have the same issue.

Please keep it open coded. You can add a comment like "during split,
not all folio fields are avaialbe, open code the swap calculation".

> =20
>  		/* Page flags must be visible before we make the page non-compound. */
>  		smp_wmb();

--=20
Best Regards,
Yan, Zi


