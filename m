Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C149EC982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 23:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529EC6B0092; Mon, 21 Sep 2026 19:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC356B00A4; Mon, 21 Sep 2026 19:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C446B00A5; Mon, 21 Sep 2026 19:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F35CA6B0092
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:12:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64927A0188
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:12:35 +0000 (UTC)
X-FDA: 85239320670.09.0319671
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012058.outbound.protection.outlook.com [52.101.53.58])
	by imf04.hostedemail.com (Postfix) with ESMTP id 977B840006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 23:12:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sJxCoAXB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790032352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jua0BlwKAEkzKH4lCwOEOVuTyaRsXhSCBkaVFIbAl/w=;
	b=r5MqtJhV5LMtM8oUcpwkpvaVqPRhup3JEgxAqvuqK1c55Lp3SygqED2E/x8zGe67W0ezEy
	ATwHrqQbwTiGSgHszVc+fpN3Y75ScSjH1KsXKTH1B79Cmnwb9ADl8S0Nat9tmviVbhE62N
	1pSemb7svXZOi4tlAK8PtLOHFooVU6k=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sJxCoAXB;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790032352;
	b=SsHtJZTm8cpEIlqIx7S8gB2la5wMiQnEjHp88YzSA9TLPHWLXpdNPzd276QpBG57vXhxma
	16C+Nc3Xl9NTY4uKbJUcpi64RJnV8Ti+iyTE7ngcN9qG9Acx9B2vsZL9nqqhKtWnJGNCiD
	VB4wdvKtj/rp9sl9Rkkkm8fj8jb6ByU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s/v3FLR2F3ZTzYLNpdFVhrlH7ra9ECx8KvRakoun3+0tbt8Wn4wVbNSUEJLeI55qzem1+xAwChvLJDDCp5RS3NUadFG31UkiA4sqLibBl3uRS6GUKCv2bSR8li2ruF+qhx9VmlAEwoZOAxDmRmSeHYagH9SNcWx7hzjG70uLEx96YRYtaZJGraSYXrutzcj2eAZ9zaZvqqIVDu/YQwyqQ3vqb1GGo6JlEQEgIWGDu7O5iK5xm0F0rF6omWl30nSXrz2bppUfm+t+KNrMs4rX36YBZlq5F4bj1j1Eu61Gz4JQcVoCdrfN3hppGGPbhAioIQaJqmAzFccF+j7a4N4vLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jua0BlwKAEkzKH4lCwOEOVuTyaRsXhSCBkaVFIbAl/w=;
 b=u9AjVPKCsOZgfj/81MkTGqZOuoUfQM+SFlBgw0dEDcvrhUU9byjuNp+0KSvOswo8EVM8J7ujHehjp/f+fnIxNkqTOAi6Uawi35abwU/W9EA2+i45FfUOjAlLWyjxqZVLxgoZYDpga+VoFe9mKmFEuGh9/YFubQ8ED6m+Txhoi7AuhSdHJRAM8KxIDBnoDGai65rU7f52JHJwYNOYrdpp1C1vg5zALF69OMfWs7JUd71v55wUQc3y68tL4G/H0XturX04QSV5r4j3RswMlsQ0NcYIUlwLXbBuOhVATB6kSl/GaQBb6qo+4WaIr++FunqExIpnTbeu3P0iAco5FdbieA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jua0BlwKAEkzKH4lCwOEOVuTyaRsXhSCBkaVFIbAl/w=;
 b=sJxCoAXB8/z96Bp8VnCNB04hVM/SJ/XlR8pX3hh42g1As87EDSuYAUnaZc4lGk4zyyNwz/oN6EC2xFfs8CxhJY6fMcPdp1eZnSq3vME7zZNMlAF/gHw4KaaO1n0kRm+xQcwkxylRGFKTMIkNmKdSJEP3VRlZcZHbaQQ+VUR13SkG2yJ7zj9P7bPgQ3WUaoDUsoEOU+VaVzBsz7IotNw4fqi/dIPm0+Pd1I+DLwJTD2U2Q6oajNh+ADe3gz5D9HsecPvGm3kWKowBu18BjGdrxosAQ4Tcfpqf2C29waimlNLRv2No1ziQwLRAIC+C7fyLw3eTrxE9r1eB/Qqi4MrDCw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS7PR12MB5792.namprd12.prod.outlook.com (2603:10b6:8:77::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 23:12:19 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:12:19 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 21 Sep 2026 19:12:17 -0400
Message-Id: <DLLDI7J2Z7L3.142FJJM03D1IV@nvidia.com>
Subject: Re: [PATCH v2 01/13] mm/sparse: move mem_section init to
 sparse_extreme_init()
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-cxl@vger.kernel.org>, <driver-core@lists.linux.dev>,
 <linux-fsdevel@vger.kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Kairui Song" <kasong@tencent.com>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Barry Song" <baohua@kernel.org>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Brendan Jackman"
 <brendan.jackman@linux.dev>, "Johannes Weiner" <hannes@cmpxchg.org>, "Jan
 Kiszka" <jan.kiszka@siemens.com>, "Kieran Bingham" <kbingham@kernel.org>,
 "Oscar Salvador" <osalvador@suse.de>, "Greg Kroah-Hartman"
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "Danilo Krummrich" <dakr@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.22.0
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
 <20260921-b4-sparsemem_cleanups-v2-1-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-1-54d81d65e125@kernel.org>
X-ClientProxiedBy: BN9PR03CA0293.namprd03.prod.outlook.com
 (2603:10b6:408:f5::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS7PR12MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 612ec6fb-0758-419f-b27c-08df1835c8c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|10067099003|11063799006|56012099006|4143699003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	vYW0hAdwmmaj5achqY3kLTxcncYueQXXcjcOijyyprbAzutldnMoJbpwYZO63k3IBOEz0opdiDBoYnpOUx4hz0SzJuMv45MRxf/zpCp3y9N65a3QfhzkTvAu1mGWohPrwwmiivlKhnr2MMHeJ5xQEzVtsgHxskuS+ErsDXpN8HqDY4n6yDa9zcErl27Nk0oINBfpmwq3tLZ13pyuS95dB6euwhqpmil8OCEXK/jsJuP5h0aKTvZPRLJWVQu7vdYgOF8a/+9w7JBcrs4IWij2KdliYFO5De06Ygsg00y6H6bDYIH+jCIqIZUQfo2OPzXbyS3VJi0IvjKl1UAdUxIzmDt0+3ZafcDdc3+Lk0JzsvAJ1j9uxNTM+yIGYbuMXuWV4TBt8kqOhIrFXJRfw0DBD9+j03tCYVibALppi2XiDd71RFSf6QhZj5vUuOUw5FnOq6eV9F0g+89ucx4qSv+ntGzZLQuPj4eMUP/nsZsu80o7W9/RdfYJpW6UXlW4/TeSahOcN7doRF5pM3PpmAiBrmZx6uhW/CXkLufMK8nZG/XIDi5pfIwv/pGMHyC/5YR2zurQLiYXlIX51U4qEVrNnIdbIimOGCONA5JBa9WedHlFatkYzgYaXqrGQc4aQwLWnKerbtnG68H99WHceaaUtNEIPusn15+V5uUvpQzZc8PYT0/GrflJgVc9q3FAWug/877RVHRXNXb2H6R+lR9rag==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(10067099003)(11063799006)(56012099006)(4143699003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnE4RUI3Vm9PZ1BpUmsxNlpYZUtvSTk1RGlEd2RXMEFTbm1DRXFYT2E0L01Q?=
 =?utf-8?B?TFJhdGJncHlzSy91eFZjdEFiWlc5dStTd3o2Y014a2kya2xnTk5pK0F6UDh2?=
 =?utf-8?B?UlF6RGRaOEZTVGdSaFhqQ0IzaHdsUXcwUkFIWG1obUN2UjNDcDZXV2pzcDBa?=
 =?utf-8?B?WUFEd0NYZHJLSVdPZlVpejMvMUR5dlUxRlF5R0xscXpaUGZDVmwxKzE2VDAz?=
 =?utf-8?B?VjRvNnZBdytaVXl6aGlud09OY2pURlUyS01wLzFkM29WUGgzcnhCZzNkemR1?=
 =?utf-8?B?OHh3L0R0RkZja0pJVzk2REZObFRqT1N4bFd0OTlNZEIyYVcyeHhnaXNDZEcy?=
 =?utf-8?B?SjBIdGpmaFBLdlV5bDAxK1JaVzNibElHWFpHQjNYWXdVaEpZMytPTGRWSUxK?=
 =?utf-8?B?YVJkUlRBc0Y2YWhRZ25TdUhyS1NVYTJUMzhMaDA3d3ZIM0R4d3BGV09URGw3?=
 =?utf-8?B?N1V2anA5K1lsSnNscGtvbWxhbzYvTDRLaHZGSGNFd3VTUU54bUtXT2FrU0tB?=
 =?utf-8?B?bnNNTmduZy9RTmIzcE8vRkwzVVE2bXlIazdzNnlVZWgwSnArbWpLa3ZrN2VT?=
 =?utf-8?B?SzdPR1pGVTlmWlRZTUtBeXIvbTlMclZUV1dXWURMQVRuQWJ5UU5HTDFiNUhT?=
 =?utf-8?B?RDNjVEtEdmxaa1k5S0s4M1FJZnF0Q0x4NTJYTGFmQmpTMUJ3MUxMcE9BNFV4?=
 =?utf-8?B?MC9oUUZYUVpKSm8za3RSZjV3ZjkveFlwWC85Zmpjd3lEcTBnRTRFMk9KR2M2?=
 =?utf-8?B?UDBNeWFoUC9tbnp5bUhUU214NFk5R1RLcG1SalRLZEE4dGNDa2tZYldKYlF2?=
 =?utf-8?B?bmlFektRZzFxSDBPUGhyWW9XeUtMN3J1Qi9ZTGZ4VlZJOXJoWmJkOHNRaU11?=
 =?utf-8?B?NjhJQzYySTZoNzJ1bXRldVVlK1J2UmxyTkttSXdZUzZKeGhDTkhlV1RxZlJm?=
 =?utf-8?B?VHpaak9WM0tlUkFkOUN2NHg4STlVdmFHcjBIbDFRZ1dwMG9mZVkwVFljWEtv?=
 =?utf-8?B?ejdrdURORzZIZHJEbWNpZGdaa0Vsc1cyZk1MY2RRVDZLMXZneTA2MS8yRGts?=
 =?utf-8?B?SjJ1NVlXK0Y0ZC83Mm9QYlNvYkNKRUdHMlROKzVNdWVJSGhidEV6NmpwNDVB?=
 =?utf-8?B?dlY5VG9iSkFXanl3VExsTXh6QVpRU25hZGhzNC9KK1dHcDU0ekhNSGFRekxh?=
 =?utf-8?B?clozRHNMRWhwVDFUOFora1ZoUmFzS2FJVWNIVEx4SkN1c0dJME0wcGVpb0F4?=
 =?utf-8?B?aUovRFlvb2NOZjZod0lGYTNsS3ZHQ3BzK3JLMlIyYkJTSlNMWGFrWklYanpV?=
 =?utf-8?B?NkhhNkpGY0FIdzV2RENiVFlUYzlLU0dtL25VSmQ5cFZEUmc0NFM0YkY1K1Ix?=
 =?utf-8?B?Ym9OUkNZa2ZSWHNBK0RicXNEd3RGVkVPMWZaem9PQno3YlYxVXcxMTQreCtz?=
 =?utf-8?B?RURQVjFOV1BOZWlUcThJSnlNSytReit6bENpOUlwWmMyOEdNQWtEVWhDc3B1?=
 =?utf-8?B?c2hsdnBkNmhra2xwdW9VMUZNWDl3U1hHZzVIU0JkcjcxRlBtODJXVWtWNFg4?=
 =?utf-8?B?MW41WFFJT0llOVBNVkk3MDR1ZWNmYkdxUkZmVVcvYWhRWGZxRG9lcXdGKzc0?=
 =?utf-8?B?b2dKemhGMTdORnoxb1lXRUxSYUlRT3k4allwTEtQMTVPaFBHcndCdWR1b1JQ?=
 =?utf-8?B?cmtnWUJxVmwxR210cFhDNVRmVVlCcGpVSkZYWGlJRlVtUWpBUkpQTDF4THNp?=
 =?utf-8?B?OENMY3gxNGIva3JjK3dHNnpFdlRGTFZXdEZ3b2FuVkYzWExJMXczWHdjOXRv?=
 =?utf-8?B?Rml5Q0VMSzJhRVdldzNaV08wang4U0tzZHdOV0JUZ25Wbnhwdk5PQmNXb1Zy?=
 =?utf-8?B?aitnbkd6dS8rWnNNUTVOOGh2YVl5TEM2MmFBMWNnQmFoSzBONEE1M0lOTHhO?=
 =?utf-8?B?eElzQjJOTnptM2NmUDl6UXIwQWdsMkl2ZzJSSFN4dDJXdWdRak1xRWVnOGpE?=
 =?utf-8?B?Z2hSRWkwZ0dQU3RKQmlNTUd6a2hsVVcvY04rNVU0SlJDbEh3SGdCUEd0b00r?=
 =?utf-8?B?WEFXNS91aDdTTlBWU3UzVGtacXVyNGd4dTRtRFNSaWU0OCtmVlBrcDR2TXhH?=
 =?utf-8?B?ZlZnNlpUSWRGTjduVGh2eXdUaFpPWEJTZXhTZGVSb2ZlRVVGSmpDNWl1QlBB?=
 =?utf-8?B?NjI3b1pVcE5NL0Jzbmd3dHFxbVdnZmg3aFVhWElxT2NOaS9uOWhxcnVTQzYr?=
 =?utf-8?B?bVBqdi9oU2tTbkd2b25sMlhvM1VReWJVRjRxeUVQdS9IUkV3eGowMERYclBn?=
 =?utf-8?Q?S+2VNE7ZHjKntZxt2x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 612ec6fb-0758-419f-b27c-08df1835c8c3
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:12:19.1874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PxGSYT9+pDH6u4dnXO6lx4PjCPtvaF1WfrykK1JkF7oBwEZSwkQKS1uZhW2AI2Pu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5792
X-Rspam-User: 
X-Stat-Signature: x7h97iczgbb8nntf8t9tyhu8whahdjsp
X-Rspamd-Queue-Id: 977B840006
X-Rspamd-Server: rspam07
X-HE-Tag: 1790032352-159811
X-HE-Meta: U2FsdGVkX18YNCEUPknR4fm/Gq2SYkVkHI4sFmrbB8XBvePfSXpDf4U7bsZl3h+jvj+cC4gjdnbi/PTyBdWudxTUNIK2fKgXE5LifQfPTiIbQOxf7ScZfiXSob+GNQoL6IwLjY2SYSljBduDuGER88VQkuADCk0WyPx1b62fVQ6CUNWXHXhI4cVQKeLAADVMZMeQuohIGNZkPLAesDl2qntOLfljHtZ3Qhaqede4sCm1/aCZ869Fc8pIdQ0DFbC+qg5sj5eFnilXXA/cwUe0kEj/7IbRpeLqTFCWsiVd1pn1mmM7rrxAn6X2lp1tv/01am2b2D8J5B0oQS7/eueYwzvVN/6FM52f45xPYVwlfGqj7lj8Y+T1EecC4hnET6L7FJ11z8sa269wV2djMWZ/FttX8D0Jh37IL25uM6jfvl/rvPV9PqDcwmrw8Dqe3Rmw9xjZ+Rb/t4kMF3Tn6LNoXtCfNQYySGFi8G4wxPC/Em+bhUv+xt3nHCvhscLqQx0YrBMhOvVJu03dEkhiKMG4A69zX8iZnHZO7gg0FKGZ1E+x+ocicUYdGZ8bdiuK6jmPclaoQ8zYkG3ByHHxktb+km3hf/IQDJNUH4y5uwYZRxwCoY8mrnVJVBR1rP5X4kjiqGsfKvxSizZlM8upAFmGfafur3eyaG/B/ele+OsURh8HxEz8JU0171OZRl0rKyTAxg8lBL9IRtEf4c2P5yAR9qpZRgX95Lg+Uubhye+V/R7NoMEGtr+pB7DDImO3+NnNKMVHU/k65BJekvNBPJlYr9yy1YSoa14QFP8ubf+BQyQ2TPBEqj9GjqzrMmKsfdZV2V8fYcQOdRkzjhcC7u0nlvLwaFWFgFKtqLWDFKmRyCwon2OyZtwTKBqDbo0iv4gEoKuB9dOyr5kLjcmrEEysU2MNMBxCRKwXdf5GXtkAMk/SGee7UZaQpTZ3pujU16Ldp6jWn6h3AYgiTDoRI0d
 9ZvqMxkm
 THzpRzUQPHYytQIwFsnQBCtRAufwJS+06IyB59R5PTlPr2NDe1GXkQjLr9arZhmBGAb4I2HGOD8tH3GceRGhdm8qpGsNa05iEiE116zeSY+BPtwgS2as8eAy2yvqFfuCiuaLcr5YcPOFxnTLrVZPWDvAGPJH8HQYZ+74ARh5YJ/oUbk9cLjB+dtHQ6G+vVkvGSZjlJm3UFaW+L/1mj7fww1K6wxhjL4/gNXCEolt1VWzoJUOM5RK8Kjg5HhS380Ebbf/J0LtEvT8aZpLTHH/JO9WK0GR10qMIuDKrR2/mV45eF1VdzGvpx8EWmFvhnaCkptuEydzbMSJ+UaOPtGfd9ydA7a1O/wQg6KYCzRa+6QmGZa3jbxwgsnLKTj/itj1wrzkHlEaik6XE4oj2ZqujZ8Xl7kYDxW/tRdKFF/5AeOlaV1ozhGP5wvOmuTIo97olf4r+OYIAnDOiBG1a9Ba9zE+pbTgBiKkP/tQfTWAnjAbRPy8OCwi6WAmEwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Sep 21, 2026 at 3:58 PM EDT, David Hildenbrand (Arm) wrote:
> Let's just avoid another pair of ifdef inside a function. While at it,
> switch to INTERNODE_CACHE_BYTES by just defining a fallback in cache.h
> as well, given that the x86 variant already provides one.
>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/cache.h |  1 +
>  mm/sparse.c           | 19 ++++++++++++-------
>  2 files changed, 13 insertions(+), 7 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


