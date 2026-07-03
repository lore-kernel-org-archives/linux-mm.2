Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DF18C44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0FAD6B00CB; Fri,  3 Jul 2026 09:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBFF66B00DF; Fri,  3 Jul 2026 09:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D885D6B00E0; Fri,  3 Jul 2026 09:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0BD56B00CB
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:47:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1510040140
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:47:59 +0000 (UTC)
X-FDA: 84947593878.06.3C56CF5
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by imf05.hostedemail.com (Postfix) with ESMTP id 01C9410000D
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:47:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HT5wzZ79;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783086476;
	b=yZH3x1ZYW+dGSSsSXxwyyQZ2RNNfSKCDUFWl1pDGBQJKiszOz8y03pTJMGR3nqpSipR73Y
	9b28XSE+LLurkDpXqUNN8RvrneGbXDj208iP9TR0Oo+FKSllXCGkU+GJOnv3MRjSfKIB5x
	Krq7zYVOTFTSQn3URVhAPovODmtBuns=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783086476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QX6Ucrr/REz5Purc4nmnDk96neqPcHkJ3Pa6g+ekjo0=;
	b=JWhkuv5aulveuH64ylqL3aC3fBpgJfD4P27Gg3VzluL/dRVRWraEcCNFZY6ACOHi5QjSTA
	lhra5TefHdA4sD1dCGtYU4pb307UGyhGGNUcnnVATG0LRBp5DPW2L18k2/KJBiEQ7LfSlV
	B9I6vq4NzWYa3bNN8bBsAQUyVb3NiPo=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HT5wzZ79;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mpzl7jsym18CUCEGpN202/c2UffIm0gvun3eMW2RMf8ZomlhTpeveMj9ZnY4TBvqmSr1+Cv3Ka/ZZyyhG1yyPG+mCcftdKYaNhq+j23RujqfEjK+V88zxZfg33cGHz200Bi1B3c7LU9JqlKqDcgY/vvFhLiTq91PuiQOPkLlu3jUAES2nZnu/9VjKSr01mFcs5lc3dWL8Vi16Mf45dPXc8lynBFt48CP0+CrDgQtoa6yyCJKmPCNshkpjgpVaW0txEIlOlbMM7BgMB0wUttGYnFxXrfjq2gfKUSVyrfgobq9XsF8BCSwS8Vp4wFpvXQSbflmtWrQJ7DIa+bI5rUjbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QX6Ucrr/REz5Purc4nmnDk96neqPcHkJ3Pa6g+ekjo0=;
 b=ivO7LYyMjkWCb/se5d7iA2xxZ4VlDxc8w83SAA8j/NZCx+FraRHkk7MCQ3l0MnCf2kyjjvADmFsKS41/iMTy1e4i1nxtnkD0sSsGUOad8lFRMzovrLyAjhMUiwfvP2fcIHBoWWQJpO7t63ymnPdRGJSNE4N31rYfBFj9EYVwsktWrioqqKyxX0fW6OLwoz1BpDynPA0XW4tf0r1DApKzDTKmI8vg1o7cCQOOkHqy2nDNIgGGGehwcr7a0ebpctsR9CbQh1+ckzctBYLHOP9a0ghdGo59QpE4LkwjVOantJCWYAWTSHwBa+zh0enQETbjAZWHRkjhio/YjEDC1jG7Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QX6Ucrr/REz5Purc4nmnDk96neqPcHkJ3Pa6g+ekjo0=;
 b=HT5wzZ792eQdz+ItsKN5As3pW4PIAj4bskfK2r6JdGMpyaBKYIh+HgqNk/k4d6S0ZhZYur+DCUlhJ2tU/d4je5FMYSJn6rYn332ey61Txe1eSAYGoRDga2ubF/fxkvhyG3s7rFp0Yrk+RTFVxpzbzplfPJkdLxIq6UF4CVHEk+vNT7Vliay5FFZF73mb/3VKgLXLRLePJaPuwJB2D4CU9zvClICtp1la5ae44rNoQDH8zD4wIxAWDRviBX6vgH0XMcYeiTRUHhuDvB5EFzjzMPJy1OunzNlkSfVyThX0CsWBTkaO0nE41uLgGCdQAqGP024/lGTwtcMqNokkKK3YMw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN2PR12MB4111.namprd12.prod.outlook.com (2603:10b6:208:1de::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Fri, 3 Jul
 2026 13:47:49 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 13:47:49 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 03 Jul 2026 09:47:46 -0400
Subject: [PATCH v2 1/5] mm/percpu-km: clear page->private before free them
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260703-keep-subpage-private-zero-at-free-v2-1-2970fe777dd6@nvidia.com>
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.14.3
X-ClientProxiedBy: DM6PR08CA0037.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::11) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN2PR12MB4111:EE_
X-MS-Office365-Filtering-Correlation-Id: 8be2fcfa-9c9a-4e78-72dd-08ded909ab97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|921020|18002099003|22082099003|56012099006|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info:
	0XI4zR5w4uWrO9qqC1MzjqFLKOzYXT2uSs1FigQYPovznu6LTSKqb6bLVQONs467odR5KRKig0HGL5xHmBG9t8FQHGV5Xb9AEgQWwL6F54LxSFZ9Ww9cepTmjYBv6Rblkt+RO5wfoO+wR9obLHojXb+npy+/TA9sXJ7iley5MNyas+JINsn1ehw4Vl7XiOUqwNwVThjBy1V7rY6TbZiGEy2ohp3cTFo8HMKLiKVDoiawARMmLowH6UOVptZBgozbLGfRYjeL2cGCl4Aa7wd3x6kYh4zGpCRII49iuH07A5ozcEEU8SV85NmbYS3b9U2Qe2TSdFpIRSzoJd5TmCDAHhyeJBMu9pVAIQGVT6tpl5exNvtzZ5vh5jHY7ZsWmjMO7Kt+x98PEh2sRN+HMktEH/+wrpKJFQxDQNJIudWiWhHkropKe+0mVjDTiHgL8+X0MvjZKkvyIqnnZRYfKw90bCs0Er9EXp0UOmkqvjxn2zlhfR+4aouE28+lNJf3dvOB1fl2NpkmBr3kM2DM6r7Bg4imeIK6jhUNEeoko4a6RAkdLJTpZbuMy7il7sOrKiw2QdKnq3UFif+kvftCplkVAAQJcRJ6dOSvZ2Ej8aNlx+SAc5kQDRKDR5+C9W3X55hUXGOLBzupnYNllEl2pmpsLRYAUTZMG+/Ezygfxiw/KNegf9ovwd87w08bsc+hBIR9O7d5O5pgAVXoA31qp+9/Bw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(921020)(18002099003)(22082099003)(56012099006)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aWU2Rm96Skk4TmplNU1LNkxsSmRNSU9pL0JBTkNvejNhSEQwMDBBNWFkUUJr?=
 =?utf-8?B?MjFVNUc1S0c1eTN2WE4rckJtOTlYLzM2czk1ajJGeHFmZU84d2NnVUJHQzNo?=
 =?utf-8?B?bjUvbGgwdlJic29qUS9aQmJ3NE1GUjFvdllnaWt4bWM1b1pFL3ZEZ2lOZjla?=
 =?utf-8?B?YXl5ZUtPNXZ3VGtBR29QN295YVF0YVBwM1UvSXNvQnhEcG1jaENyMUY1OXhv?=
 =?utf-8?B?ZmVGVXJuRjBaa2JOV3B1cys0MndObVJTeCtKNW13RzhGYUVIRE5sY2M2UWs4?=
 =?utf-8?B?Q244Z0grRnZ0Yk1EK3htNlhLY0ZTbXFvZzVrdlluTnF3OHA3SWlXbERDR21W?=
 =?utf-8?B?ZmJ1UTVaMGZCL01FOXVrcXJKOWZEbWpSYXVLQ09qMGc2SUQ5WFZWTWoxbVF5?=
 =?utf-8?B?c0hmclNmZis2VzhJTW56QlY2dlpZNUkrRHJpNHBvZFp3RUNvZ09UT1ZRZ3BJ?=
 =?utf-8?B?V1FjMmlSbnhoNHZ4UW1sYUMxWkRHTmt0UkU2M0o0NzE3a0hRR3BQeWl5cGRP?=
 =?utf-8?B?NmVWZEhxR2lzTW9RUm9leTdzeFIzUGJ1L1VTeklLbkRuY2JhT1RhcjY0ZkxY?=
 =?utf-8?B?b1pGaVJvYkhabmgvMnk1SkNhTFhCUUhpVS8zUi9uWUY1WnMweFh1OVRlbzV1?=
 =?utf-8?B?YWZQMUhyWnlldUtZbWJMT3FOVnJvOVM3RHcycGNtcGc5blc1dEdqekt2Qi9x?=
 =?utf-8?B?dURWTkhJNWFlOTQ3TFljZXNQdVRNT1htakZ2S3I4eHkzcFZESXJ6V0xOYk9J?=
 =?utf-8?B?MVgvM1ZMczBGYnZNSUFuMUVTK2kxVnJNWU5BYnFBRTluck8wbk1tNVJMbmt6?=
 =?utf-8?B?Z1VvQUoxY3FkU1hVS1prOW50QWh1cnFZbEZPdmJ2NFQyc1ZWWXE0UlFhRUJC?=
 =?utf-8?B?MzY4RTQ2ZDMzd0R6ak12SFo4VUR5UmE4ZlpqWEszdU95Q3BGWUtabjR0NjlK?=
 =?utf-8?B?cDMyRzFuNEIrTXc0WHFIRTlmcjR2QS9NOTVDRVNjNW1EaEFCWDY1V0dXc1dk?=
 =?utf-8?B?TlJYVVJMU2JXWTJvT3hxVnR2VklJTlU2VHJQUy9ud1VxWjJYQVhZVE5obVpS?=
 =?utf-8?B?bGFtZTRHMXhBOUVycUlqMXVTTU1pY2tLR0hZbnczUEhBa3pEbUZ5TVhiQU85?=
 =?utf-8?B?bjdpa3RIT1lid29USThzSnF0RWtFVW01cFhKUVZHM21aZ0RkUFNEQ2p0RU52?=
 =?utf-8?B?KzZ5YVNFNStJeFBBeThFUzV6NUo4UjlhN0pVeWU2NGdqQ1FjUTkvOFRCUmp0?=
 =?utf-8?B?SUFrS0xINk5UbXZWSzBocVVFQy9DeG02bW1iOWJYeDFqTy9tU2pXVGJLcUxQ?=
 =?utf-8?B?VW1hbFF4NkhXMDZLbnVpQnRRMERJREQ5RlNTenkrWDQ4dkc0QU5RVDNSWXNL?=
 =?utf-8?B?VjhURUJBTVA2ellCRStXdzRBbHAyYXlVQnowVFpaaUdHWlI0Ylg5ckcyYmd0?=
 =?utf-8?B?Vmdua2hSQ1pKOFFmaW5DQ2EyTHNxbVUvWWkxRkpiNHlyYzdJdlVJd3J5UkR5?=
 =?utf-8?B?RHp3aStOdVRvMnd5SHl2a2pEaC9WcStDT2ltR2IxbFVVVjN0Q3B5Ungra290?=
 =?utf-8?B?bSszQ2E5ZFptd0tpdFRXOTdCQ1JTVTEyY0ZCOEJ2TXk1emowT1RkdzB0MWpG?=
 =?utf-8?B?TlFQM3QyVVBGSU9IcnVXQ09HMW85b1dINjNTVEdsV0hhb0gzb1JSNkNOT1dV?=
 =?utf-8?B?cFFUWnBKanQ3NWNST2xqVFYxUkltVHpOeHRodWxWZmJrQjkxWlQ0TVAraVBO?=
 =?utf-8?B?V3FOZzhRYXFTc1YrRWRGeVpvOXgycUNMTWNxVWRhekZEUHdLNllQSUN1T1gr?=
 =?utf-8?B?a0diL1N2V3BtaklCVVB3SEJ1UU5ZRU1LZDNRZEhTRHpsaWJIeXVhNDBpdGlX?=
 =?utf-8?B?MjVjcmlYS3hUSmEwek1ONkx2RFRFWWZGQ3FFeXB0M2docWM0K0xoWXB2Vnd4?=
 =?utf-8?B?cjBLQmFpOVh2dEU4eFlGQ1hsMjZ4QjltcWxGNUthd2t5c3JxWExRT1hWZE51?=
 =?utf-8?B?MkZ0TlgvZDBtRFBiNDVNYU44SHUxTFJBbW5YRGJibTBZR3ZHc0xENVNZY2Nv?=
 =?utf-8?B?d1MrNksxcVNleEJheWNzUzJRMmZRWU5sNTVHbitmMmJkaTFmcmdzZnZNRDJ0?=
 =?utf-8?B?eUdLV0NhREc0cE5xd0R3MjZ4V0Q5alZXTlpKOE8rbWFQbDdxdE04ZHpGYWNl?=
 =?utf-8?B?enhaYitJWXlha1Q2MXNsLzJTdzBOazBzT2VJMkhiajRTeE1LZ3ZxZVpseXp3?=
 =?utf-8?B?RUkyNVVOQXRrTE9JcFRxR3RPc0lJd1grZVdud2RNdEpQZTFTRFY1ZEJlQi9z?=
 =?utf-8?Q?vBS7Ents//8bQRYNnS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8be2fcfa-9c9a-4e78-72dd-08ded909ab97
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 13:47:49.1272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGHMJfG5NxKwkByxL4jUyLJz/s8feKbP9sLTy69BKXo/9n1a9F6dlxcoQVfG6xUf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4111
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: nq9dnmqrnnmfr4xzwn7u36q6ikwjriog
X-Rspamd-Queue-Id: 01C9410000D
X-HE-Tag: 1783086475-479395
X-HE-Meta: U2FsdGVkX19NGTCEo2t2d6r8HijIKLohWUjLkaFg7ZE3ndEBPDuqqdm2GkuYFtqOm6QpwFljGybpenjgQhuQVCpk0xWlQrzoMxK/eFgsSUMguhrInwS+5Aq+cFdD3hLx1sjIRpMnMxTbmIzVQgg33I1LLolrLClIlNHRfxqeQrIXlonQrcaNvhTdmy8a+SJEYRH7URtt5cSzcZGJa4mCTHBmiBjo/kg/G0CBQ8Pt2p89TbPn/xBpsKeEH5yzS9jTMVHNuU5z9VLVC015K02sAfqmV/SR6eR9L3a1Y847oISHCpAMGdbayhZtlgpPTdqe/fPYjSi20iSYE17mPyvwWJqK2p2xyJdKMLz/7Snym/XBoiCQ0LX4NQciXu8deEtM4RdMS2b5AzGB7q3DmyTJW8DTgbJIwggd6H8/UVfPDHvW47S5QnXQnNLG7oSjM6/MRE+LH4TZILEJ54bbaFG3j8U1r1PjZ/U+e61t5bIFbR0akSkhIRkPo77qju4vSIBFejRnr3rrWjGUHCfnaWscqTRM9G73cVOIYi6iH3+MJqBlp0tcqfUMstbzXFasvAr8X/p0aT14Fhk/lSOZaBGHbQnT6BxA/d7cyBsh406ZOglgDWCHnVQLrh+e2iysUDl+nqXS1H11j5D7nIUHqK9jIBsnnbPMPlKggKS15PFBY7yZ47rE35weyNXAzLTjqeSkVHDdzdzKnnAk4p1urKNoD/9BEWApZnsoeEGDKkn6eiXltdvyEZJCEehbukpDuVZbciizHEYMx9tu8xcBnsp0ZziVgvIkD/vPCDcN3j3K/qjrINwkN9Lmo0qUgP/S1B7NvS//4JRxCQByLKXGMQ5wJm5iTM2NYh2r/t19jA/y/he3Q6noEYo8trr9ig9xbceMXNRLKfLEfzQBYsNlrnksQjepoEDWAN+Ym5EjrY8W2leWJySNHqMpnuv8WYt1PMmLoOx8YXtuvRdgX8oXRt6
 ca2bMgl0
 uAaNugU2cz/PlMymcKKZI9KqurRQITXJ7KNTcP4boYlpzKkPlXWjtVHjwntFFqUfFO+kBfc8HA8MleWqss08Vkq3pS39fOP7BE7zK85S6o6ulrEqcQhkbQUSdPE9r0nCZ94ICNTQOJ2burheS0OFpY8wv1dkba/1lfPbe/ToBgTBIsesgErurENgFY8L1zqwHBt+HJbK9iScaOAWSntE9oHrtlRpOHmO9+yfga0oxRurfLu9LLVJJhfL7kZHkMFJ79q1ZaICPrTzMIwUqsWlyVbcqQQ5kc0ZC4lMbGCWwE/jOWShVZsCU8vUurZiwYpvqbedgCdocns32wapT8JhrjDlj1HNAXwd1D/9IQy4gqqwxcK7ja9LEYLoenNmigrBUoCyWp7/Lv9Ac4JSiCyf4R4SSYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page->private is cleared in free page path. In a subsequent commit,
tail_page->private will be checked and ensured to be zero. Clearing
percpu-km allocated pages' ->private to prevent triggering warnings later.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/percpu-km.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index 4efa74a495cb6..7ffe84adadb9d 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -94,8 +94,15 @@ static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
 	pcpu_stats_chunk_dealloc();
 	trace_percpu_destroy_chunk(chunk->base_addr);
 
-	if (chunk->data)
+	if (chunk->data) {
+		struct page *pages = (struct page *)chunk->data;
+		int i;
+
+		/* clear chunk info from each page before free them */
+		for (i = 0; i < nr_pages; i++)
+			pcpu_set_page_chunk(pages + i, NULL);
 		__free_pages(chunk->data, order_base_2(nr_pages));
+	}
 	pcpu_free_chunk(chunk);
 }
 

-- 
2.53.0


