Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E92F60865CC
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 16:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=chyLBFdB
Received: by kanga.kvack.org (Postfix)
	id 6C0226B05B3; Mon,  2 Nov 2026 11:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6976E6B05B4; Mon,  2 Nov 2026 11:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F716B05B5; Mon,  2 Nov 2026 11:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 270426B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:24:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A38E140187
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:24:31 +0000 (UTC)
X-FDA: 85390701942.01.BC2CEBB
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011042.outbound.protection.outlook.com [52.101.57.42])
	by imf17.hostedemail.com (Postfix) with ESMTP id C002040002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:24:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=chyLBFdB;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793636668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Pg+YMdkMmzgUhYUhypukPGmUtjekv375oLct35sIbZw=;
	b=q6LSJ8/VSe9opAR6orXWMFsbWLvBoW/j5skbmb+mhEBvn6t0HHB4wDsXsHHyeSFp8Jmy/1
	VJN1ro6j8LugU8IZ4XlGy8bJi/C7P6oJjSgaT7Mzqe1coYwrdm0Qz4ISJkIw6n9qwIH++W
	5R6LLFRRXNWfXWxIuU6IQS/ZkdIH0AI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=chyLBFdB;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.42 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793636668;
	b=WKBrQ6nFqTxhs/Muye9af6MBBJV5SnXDPqQenYFgbvVUYIJvBcyUvIkGzk8Kp0VxRBHPvD
	M+v1AsO9NQNGEvx2CENqLlHUeUNo9Vm2RZ0/qpo/KX1oZdU10zfDIoK550jfg5C2IVnVBo
	NuBTW+v3zCrVR17AgUaZhVuR+NuL4RQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WwEf3CZ6h8gQGyuOZzoa8GKhdocjhTtSa7ojHyevvJbocEB0v+m/oEBrXdEpzfcvmyRnqDK2dRN4MBTL5hWwvV1JpD4QcVk13RZ86epAVJ8T2Z8W7vYDHP7eFYm/00fN/brwF/JCGBXKzaHrJ61+Il6kloEXzFv8rWOVr3JlnKbxClGGcpC66HF0YuL1cg9maP0ixBNK2UrhyOwSfqIS0vwwonAtWIK5ojwJGnuRfTTwJ2sj/ye6Z05RWe0K6lGxPE2AXjwP3svk5aeR17+0OjDGFGGcgkCB7W6qqFJF3EVDyA2V9EkTQO35Hqg/UsLcar2htI+9zmK8Jcu52Y9ujQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pg+YMdkMmzgUhYUhypukPGmUtjekv375oLct35sIbZw=;
 b=uNjQjQuohOhQwyhJPIKN9A9w21Djr+3ifRfzUzQvx1UzpEBU6XOegLr6uBiwEDLnLI+HSz5HRYd2HD+cuYujTUCk/tk22nV0tE81uFfg7VChzR6TGXYGg1k7WitYKOYCLyZsXMw6DIiRoLmTLvpF+3ElgmeLYxZWM2wCOYPDAGmcLkoGhP3+XfjwZQtckce6gNOLHsnpeC17CxjEDH2bEK6Bg5qMh1rGOYDoLoxW3PVi8ndmDIVK+FExXuhEc24TecuoYfIBEqDu//PcrSTzXeal28TVUfxo+57hTBMacW7Tl4BRVV7Oi+3RN/G2rgnH3/+EV6nDPxbPVWsycv5b+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pg+YMdkMmzgUhYUhypukPGmUtjekv375oLct35sIbZw=;
 b=chyLBFdBoI/CdOJWBJVrAp8aWGmFpyQ3AAjlmk2Q9SlG0hZ9qV0NY1Tr/DYvTFv4CzlsKVxoL04IZB2HSvDXwvHohhMcl9IIfLVPcyTXSFd1gZqbh23dvJJZEh3aXr/Q9aFHYInYyk1HPThBwCbbqwqj7J8vL4ZmaLDn2iFagtuGZIQfZlDP0OtlLbPLiHQ4xKtkWWcU2Vnnei5clgpazMaM5aE1/JYfrm2AJE/twFerRkYzWwBINtSKiR8fUDQh57sGjUKJ4gwFp1uyi7XVd6TDNzCVqsWYj58Rx03tMbJl1CeVMY6Ieo+zvLXVpvVXxeA/0+jESSOCwPAQJt2Z+g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by LV8PR12MB9082.namprd12.prod.outlook.com (2603:10b6:408:180::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 16:24:25 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 16:24:24 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Mon, 02 Nov 2026 11:24:11 -0500
Subject: [PATCH v2] mm/page_alloc: more checks for
 alloc_contig_frozen_range() with __GFP_COMP
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-free-pfn-on-alloc-contig-range-error-path-v2-1-a9fe939a85c3@nvidia.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/52NQQrCMBBFr1KydiQZS7CuvId0EdNJO1CTMilBK
 b27sUdw+T6f9zaVSZiyujWbEiqcOcUKeGqUn1wcCXiorFCj1RY7CEIES4iQIrh5Th58iiuPIMe
 bRJLA4tYJnPdaG7xga6+q+hahwO+j9egrT5zXJJ8jXcxv/adSDBhoOxtC5x3i8LzHwgO7s08v1
 e/7/gWWt/GP4wAAAA==
X-Change-ID: 20260629-free-pfn-on-alloc-contig-range-error-path-acc001232468
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
 Yu Zhao <yuzhao@google.com>, Zhenghui Hao <zhenghui.hao@qq.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: MN2PR05CA0055.namprd05.prod.outlook.com
 (2603:10b6:208:236::24) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|LV8PR12MB9082:EE_
X-MS-Office365-Filtering-Correlation-Id: 6046f7c1-4f3f-4f79-3491-08df38fdc1bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|23010399003|6133799003|18002099003|56012099006|261102123227099003|10067099003|261009223027099003|921020|261022105027099003|261021123027099003|261021121427099003|261022075727099003|11063799006|261028144727099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	IWCMtoHOwtx84WULZPinQmS6EydvJ/Id83qOs4iC4ZB+HoZutp5cMp0sI7+u3T/7U4dcnppFF0U7nrG624X8N54OaNCAViDIqoBwpX7ZmPt1AUFEz15cgIzRf0ONlx8G7H6HViXKNvisjgQcuiIx3sDcKTG0tjz7JqOaJ1/YsO/WttJiqjstD7Srb6wSxFKKm8YuprX6Pe9Ou1qng/gmp2VU/kgYBFRR9XBD095zCpWIAsy6Mv/Bd446A5ZDchMeINPZlCtKccczMjfDk2Nneeh5Bn2Gr9dRN0GWYpSaayBQAdoEYOAct6x4fKKbdcciPr0v1e7029/JwYtjiJPs31z4+4FLcQm34G+RVF2FDIMMc2hLHIA+Eq8InESWEI2pKyGDLDyBrazJhLVv1kqxY4aI8etJRg8SPSDerZO+JkyReFm0zgQP6vmDrl4eL+97h36TUOGJLbAe25cIQb6zUG5Qm8cgFe9HjbuufQ20MaPILbqYue1FDkA/vnSgXKw+UMmuwdGDfAA8gpqqkZJaeWK9ctqcjHXsMLbMIsFMM6J1eK4mDd87C0qP6t49O+pMYsw1647AJQpRATx8DPaPa6UnzVw4kYpnPKcCf7FN9eGrlEvOH3CeHalgjJAT2Osp9er4/5tiV/bJoMN0AC+u/Vl126Ibvg0k4aQ1B97DxaTmhmuDdCjKzSsfwkoeFyHd6kCvCk03ngID26ORk6Xg3A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(23010399003)(6133799003)(18002099003)(56012099006)(261102123227099003)(10067099003)(261009223027099003)(921020)(261022105027099003)(261021123027099003)(261021121427099003)(261022075727099003)(11063799006)(261028144727099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T0tYeXB0Mm43T3FFY1NvaXpBVmNjQzVLdmZXMzdJWllrZjBOYmNMLzNjeDBB?=
 =?utf-8?B?cTlvTjU1NWRxR0tTb3hPcGhrWHcyNnhMOUhLa0xLMXdhSTNYWkZTN0FpUDJM?=
 =?utf-8?B?dzUwNVlJMXFOUkxoVlEyVnI3WkRqc1ZkVkFQUmFLQkpwcmpOZm1FVGkrR0Uz?=
 =?utf-8?B?RkxWaWNUZEFwVjRWWmdDbzkxV2wzNG9HZnZxMDhhUm1USzVnbU42VlZFNUt5?=
 =?utf-8?B?Qm14ZWNkNXFsbFhWS1lmNENnbzAra0w0czJLaUNvempQTkk1d1EvSHV4T1ox?=
 =?utf-8?B?RzhDZUdhM2xYUE0wRGlvSHh6VUpJdUJuQW11Ujk1VS8raCtaZlVrNjUzdFRJ?=
 =?utf-8?B?UjAzQzk0MlVRYlBxS3pOVkhpbkhDU0dSUmRLQjZiMGZjSC9QK1hHQklrMHNo?=
 =?utf-8?B?bUxJb2twMU9NTEVHQkZJTXF3c1BjZzNXN0FieE1TSVZTTXRJRjZPdmFYY3hU?=
 =?utf-8?B?QVNzTnRRSlA5bk1kOUtlT2lsaHRqOW5HLzZaQWhHOC9rVGl1Y1FHTFQzcFda?=
 =?utf-8?B?RGhkVGNaUlRCczAxOWVIUjdvUzBNVCs4Q3JneUVKT2hUbVNYSlBQL3ROQTRw?=
 =?utf-8?B?T0hFREx2VVloOWs1RnBHVSthVVp2ZkYxUXo2dlQ2V281SmVudmgvOEV6VkFR?=
 =?utf-8?B?VVQ0WDhCYjdLYUFDUjZWd1JjY2pVYzVOUFJKcmVUNWVSbkhqb0RPNmNFZ0gr?=
 =?utf-8?B?cEMyQXlwN0hYQnZ2a3VsZGtBN3BmdnZ5S20yS3JSc3YvcmdHdG5vbzE1MGNL?=
 =?utf-8?B?cUhKWllBc2JCN0FKUUJhVk8yb3JqcFpHcHhpU0FFWng4OUxQeks1dStnNWF5?=
 =?utf-8?B?b3p3c3RZdHZid3ZyUUtEUGd3eVlkWEF3K1c3dThmNU1NNkowakNKb0lKUisy?=
 =?utf-8?B?cFFScy9qUDFpWTdMZVJPclVQVkQxV1o4WGhYRklqYmliZHA3YncxL2FMblFa?=
 =?utf-8?B?azFQWUxFQStwa1M5ZEordTgvQVlpaDBGZHRKc1Y4WEZrQ2h2aE10RDdXQXNL?=
 =?utf-8?B?MkVZQjlIL3U2cy9iTVovcFJmMWdNYmhsZWJaYWlHLzI4RFNiSEZsSFlHS21Z?=
 =?utf-8?B?eDNaYWpOM1hONVRudDM4YUs5alBuOFBWOG9VYkxkL3JGbm9yZGdnYzUraE5m?=
 =?utf-8?B?amZaRU0yZlg3dzVTRUFPSHIwaGl2YkhOeCtmM3g4ZXZDT0QzOVdvMzF4bytu?=
 =?utf-8?B?cnJFVDVLeVNUcmhSZFY1K0ZSaVRCcW1HdjdRVjVOMEZGbjlRUVdaOG9XbzFi?=
 =?utf-8?B?YS9RSTdCVlNiRUZwWTBkODJLM1Z5dDJIQmUxRWtORnRQYjNTWVRkQXZ1b3p0?=
 =?utf-8?B?citsOGZvU2hDQUhpQWp0S2F4OEdCV3NKWjVRT1pIWnRCV0srSW1sN1N2RXAw?=
 =?utf-8?B?V0ZqYTlFM0ZPQUFWMlBpc29TbVN4RWJLT3k4b1dZNjB6MzNtMGNRWVRDRGlE?=
 =?utf-8?B?bGY1NXBUNTJyR3lwWVRPZXduMk1EaHp3VFI4Qk5aZ1ZaYlBGcndWenl5MUQx?=
 =?utf-8?B?aEIrMmdUeEhTK1RWbkJ5VHRISXZCR2lCOVA2bytSVUEvYUdNL083UG5oSjJB?=
 =?utf-8?B?Y25xQ3FrSHZ5S2tseG1mQmtVMzQwUzVJZStjdWhXa1grMmxqaTN0QUtKSWtJ?=
 =?utf-8?B?WFVETEZVeStxSjcwdTdFS3B0ZE80alJUbHR2VTUyb2UrQ2F3UXVqZTFvTDd1?=
 =?utf-8?B?b1hXYmVsSlY4b3VqSFJMZVQzV3NXM3lrY1hZZG42WFQvYkNOanRoTXVWdmhk?=
 =?utf-8?B?ME5pRll0RE5lTU1yRUpyS2xZVDUzYTZmOE96aHBuVGpmb2g4NjJkaGFVNE9k?=
 =?utf-8?B?Mks3ZStUN0MrRGZwM2RQY0RqbGlGRVlxcElpUjlqeXdnTVkyYUEwWVgzYTc3?=
 =?utf-8?B?aW5vNFFjWjQraEFUcGdvdldyMGxYd1JPYW1odEdwY20xbWJpYXB3aHRvZ09o?=
 =?utf-8?B?NEhXcWNud0FFMVJUNGRNdnRBNGJ4VDhZWlBQUC9OS2kvQ3Zrc1h1NzBhR0FP?=
 =?utf-8?B?ZzFHR01zVVZ5dkpZaW5TRThFSHZ3NmYwbDdPUlN5RFc1NFhRdk1UM0srbFJC?=
 =?utf-8?B?cW5kYStVNEFHcncxVHZ4SHYzQ214YXFJSkRubm1xRWlMbmtHTEhZNTJJZU9O?=
 =?utf-8?B?OE1lN1VZK28rYlBCaWVCK25GM2kyN3J2Mko2ZisvNzl6L3pYaFpJbW5oSk8x?=
 =?utf-8?B?REJqK0dRWG1wWU10SnVhQkl6OFZ1WXJiVXRZcmNyK0pXZG16dVI2Z1I3QVlH?=
 =?utf-8?B?ajU0cnpjZ1EyRXRqb0VWeG1yUmNZaWVwVVJ3Q1lXR3NsN28wVlVzajQrTXRk?=
 =?utf-8?Q?zRvZUEbfqWRWmfICDd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6046f7c1-4f3f-4f79-3491-08df38fdc1bf
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 16:24:24.3181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17amGsc56pKi1weWK7Ba7ajYwjktSRELwthq6waHM1wX1GhRDtmHBUqiWvzVJCnr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9082
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C002040002
X-Stat-Signature: 5kee94wujrh43s7wueer5p7u3qinko89
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793636668-880835
X-HE-Meta: U2FsdGVkX1+NgBP8FuW1BfIHXHrShP5AlZWCLLresfkffsq/eAtAoFxUUD+TxjOo+U6HJGASDRR7REi7baZg7Oh2FUMqGIZpNFQZbYscIz6DaAaJKyab5+fVqCn/ACxjIsxhCMD7iBBjGqgMFbfwJugCa/1oKRAHD0kt7qlr5Wn4QltPBEQTpQfa2dj1kMSs8ITeqZpyV1Rom7TszmEzDi3PiVz0uvmX+BIeJAF+LvjN3iiIU9cYRKtTs6zTXp86os+kXJrwXlBKy5onIX/bA+VW3uU1vPSNtE0ITVFiVHbRxfdPHAwGnXCNKOoDDO7+tIUWxqq6XMhwOUzfwUit2AvtqpKHFnkY2pZshChDOBcLUBSQJaezO/4Jl2ht2+eTF51oHE++PCiVD9kdlZhEEtV552whXpGCr9Jup6ZRTl+KMatikixF+iH7Ie6tyao7M6YIU6ufF7v4uK9Fj9cwLrkxnUJRBvR57L0y6LLTU7Gh1KueOITf3qQHrSsSfLbmIkykGI9ZlwrcEoxlTFx/4EZW1knAUGF9Ckp3C79EvbHgjhK5oyNuuMopBin23Ncokv0PqENnLUAB0EOg7tST7PGqDJ2iZ3y3A5WCz31mrXsxLD20WGDw9p3f/oTPLkIDJu3WRgiRsYNHnM+wWFg0SAZl2mHrrP1vUr3t1JHg84cUKX5zbfbGRgl23AmO3bbHX6T3qLfIMm9Ive2nBYPfPRdwYz+UP7+0L1zmxeauNHR7jr2kc0tCb53mj7Zfa21rWUaOfM07royoBteEk14kGzUVby9MiEUnrMhx2KQTiyL8n8QDcLsRsCq4TFG0Tpup8CEMRSdtay8mtSNbGt8IFJLx46zvDvg5uz6vOjh28UgmAHJQCbOVfz4Mt3umA1MLxBVUsKC69KtSb8rAoVi9HCBSpwXeGZRMGKupwlHZsELe3+4xNkyZPQ72C/fllJ2+KseYGGT/0SrZavcs+db
 ek0hVHzc
 cIYKKO1hqYNnCmdJ+phFk6oDAzNfiPLhGrq9FoKZhRrWJh8MUBhV4R3KaNF9Ynl61dnOQA8JESNH2IPAJMee1zFoTNqgPR8oPmmn5nlmb2JQVB//O7b2w/g9ZC2gEoOJoRlXbON43wYOZBUFd7btftsZY8rXmOG5Dj9zvxDY2CjtN7mERSEftCUEcEgGPFiBrUiYR77z7+J6Tz7HEc0hrTov6JuSI4K1V9e3PiF5WbQ4FV9mm2BGLwl26bBbRHnA1X9wIwlUeLT4eBwiBGD9r7PU/5bQgwke5nshQVeK1xNSLJ5FzN9dIxnU6AQhY2crFU99ZBVqdNGyNFK2VpndGfPOnfgDYvVU1rUL2AtmOhVFp+Uax60VEo3zUVsAvPDETxUpoWRGXDAXIuEtZj4V+iqyETgHJhsJGb5QMDb7LFyAGzFrgWvX1XfYKk0T5D4TKPoosSZhpuH+25cUHvKDPNi58RqEc3AR05ZwCcVVJUtK94zihwgelDFcXTAWHKpWir+GULq0HDB6OW9v1++Lztx5ceg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When alloc_contig_frozen_range() is called with __GFP_COMP, certain inputs
can cause a mismatch between a requested range and its allocated range,
leading to the WARN at the end of the function and page leaks. No in-tree
user passes such inputs. Add checks to prevent it:

1. the order is at least MAX_PAGE_ORDER: free pages during isolation can
   merge up to MAX_PAGE_ORDER, extending the allocated range beyond the
   requested range;
2. the number of pages in the range is a power of 2: ilog2() can round
   down, so that the compound page will not cover the requested range;
3. start and end are naturally aligned to nr_pages: a compound page must be
   naturally aligned, and the unaligned range can also lead to a mismatched
   allocated range.

Because of check 2, the same power of 2 at the end is redundant and
removed.

Add a comment on the WARN path to clarify it should not be reachable, so no
one in the future will try to fix the impossible page leak.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f%40nvidia.com?part=1
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
Sashiko reports that if alloc_contig_frozen_range() with __GFP_COMP can
allocate a free page range different from the requested range, the function
triggers a WARN and returns EINVAL without freeing the allocated PFNs and
causes free memory leaks. Add checks to prevent it.

The is_power_of_2() check and start PFN alignment check are added with the
help of LLM.
---
Changes in v2:
1. added 3 checks for __GFP_COMP to prevent the allocated range from
   mismatching the requested range, which can trigger the warning.
2. removed the redundant power of 2 check at the end of the function.
3. added a comment on the WARN path to clarify it becomes unreachable.
4. dropped Fixes tag.
- Link to v1: https://lore.kernel.org/r/20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com
---
 mm/page_alloc.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 15ff5c1feef4f..003911ef393be 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7326,12 +7326,24 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 					    PB_ISOLATE_MODE_OTHER;
 
 	/*
-	 * In contrast to the buddy, we allow for orders here that exceed
-	 * MAX_PAGE_ORDER, so we must manually make sure that we are not
-	 * exceeding the maximum folio order.
+	 * The use of __GFP_COMP has the following requirements:
+	 * 1. the order cannot exceed MAX_FOLIO_ORDER (>MAX_PAGE_ORDER is OK);
+	 * 2. the order is at least MAX_PAGE_ORDER to ensure at the end
+	 *    outer_start and outer_end match start and end respectively;
+	 * 3. the number of pages in the range is a power of 2;
+	 * 4. start and end are naturally aligned to nr_pages.
+	 *
+	 * 3 and 4 are also the requirements for __GFP_COMP pages in general.
 	 */
-	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
-		return -EINVAL;
+	if (gfp_mask & __GFP_COMP) {
+		const unsigned long nr_pages = end - start;
+
+		if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER ||
+				 order < MAX_PAGE_ORDER ||
+				 !is_power_of_2(nr_pages) ||
+				 !IS_ALIGNED(start, nr_pages)))
+			return -EINVAL;
+	}
 
 	gfp_mask = current_gfp_context(gfp_mask);
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
@@ -7428,12 +7440,13 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 			__free_contig_frozen_range(outer_start, start - outer_start);
 		if (end != outer_end)
 			__free_contig_frozen_range(end, outer_end - end);
-	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
+	} else if (start == outer_start && end == outer_end) {
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
 		prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
 	} else {
+		/* Unreachable with the __GFP_COMP checks above */
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
 		     start, end, outer_start, outer_end);

---
base-commit: afb4eea28037fa55c4560313ecbd8a1e1da8369a
change-id: 20260629-free-pfn-on-alloc-contig-range-error-path-acc001232468

Best regards,
--  
Yan, Zi


