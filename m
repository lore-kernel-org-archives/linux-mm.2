Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C045CD3427
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 01:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971DF6B0005; Fri,  1 May 2026 21:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949986B008A; Fri,  1 May 2026 21:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8384D6B008C; Fri,  1 May 2026 21:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72BCA6B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:03:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AE1340367
	for <linux-mm@kvack.org>; Sat,  2 May 2026 01:03:05 +0000 (UTC)
X-FDA: 84720680730.17.4DFBF5C
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013001.outbound.protection.outlook.com [40.107.201.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3DD5040012
	for <linux-mm@kvack.org>; Sat,  2 May 2026 01:03:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FC9j8Gw7;
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.201.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777683782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5CDauMZtA6brBKCvR70YbJcxEQhRsDcllVBoNbrXYbE=;
	b=FPfthfZRWtByMjxnPBJzfRyFhVRk0Fh7+gDAK3Cx92JNhx3VBrdvNGaHSZQIOyBos9hVYH
	GehWWj84YTrolD3aSFpB2Xm7F0JXbLIG0iJz6N/p/eG4R8qVcYQbWfY7AnRUVWAfcSrsfT
	6Oq0lBk81dYK+7WLCSUDvLB9K2w+BGQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FC9j8Gw7;
	spf=pass (imf17.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.201.1 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777683782; a=rsa-sha256;
	cv=pass;
	b=mQEKvXEi4cHKoolAIeBSKpLYmNt92C5MMARqf4aW6hqbYYb6ow7wovhin2DwSjooNX+1g1
	8qtlvoP18BvbTUcdj0lU13omcAVwzov8kl9GVzOCt/F4idRkfHcCzhAdgQalCaprUliZ4z
	7oyzgfR9klaNmcCedqIlGDrw5IWAYW0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K7fiKnoo/7OnI+r64CL+KxAcDo4mjpJK6bQsi5T43MqgBFcJHKHvNtv4T3oU8Bu1OIxu9K10LzPnqpX5bZM6WmBP86hqjp/aWBnA8w6ZPJD8pNJeGPSr5FRmEnwecUpzCHGu1FV2kmA1WhdXzfCFkRU0L1mzUhBGxztRr5VdoN/oQ/v+bV4Z2jEdQ0jQ3aKcrPZtXf6lypzM+3/E80LN77WNjkTw10dTJVWE8TZNLIbGgNoXvENI8xankWcuAO0c5Alwgvl13hndLElHmE8FsMZ30jYYtPG8bxI3d16UIjwYuqG8VCNkqKrdhP4CS3T0gqyqsRxQMenNg6oG+Ffw9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5CDauMZtA6brBKCvR70YbJcxEQhRsDcllVBoNbrXYbE=;
 b=mKj7Uph0uTqY8my4CZL6iZYOBUThJ/9p5TtMzUeHNlTQtny1zJnTdEiIX9yzpxXPgezo7HOWANEmKXX8WK3EQXd/dcysBSZAaja7Dea/BL90chOm3ykITqdLY1X5y/3NtudYEMPD3QYUSY5oAP9sM72AKkNyntLCTWJ6URHvphUt9u+4Fri9ZeORa2LPcDVW59bImvWfoIVBAqsyt3owDGWvW0MtAIH6sHiPnRLPnSr0rTyqfrk4LLnh9PFeXOQopeBQoILQM7oyMUlJWhnBbBDVQwkOV0+3Ok31PQaz789R2ECfupSDpsGRnQhvwAyB3LBqLMpVmME8u+G2MSi7nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CDauMZtA6brBKCvR70YbJcxEQhRsDcllVBoNbrXYbE=;
 b=FC9j8Gw70U9fYLB0MgIqDNownbl4E+sJejVK7O1WTYu+DbjDRRG67nUb8XXmnmCaqeX7r37PogI/pZ7rm3OluTO9ZxbRv4+nrXiBjwI5O468Y/8+s5dE5fsCXM2pZPTYkh7sVpVVno038BZnV1/049BgaTCzRqnU75zmxXjTnf4WA0WQwGFtjp619nf1Gp9wxMNrIVtZ2TWW13rgHbBPKGBpMyZqLETpw1eWp8EXHrvMaE/g2Hlj4HP90EC1HTZ/p1XTQ3BBmo98l897tThuiaN48x0Aq9wMBTJ3Mzk6kNNuAZg4qHaZLsCH6l8E/RVf4lNbVpYU6uWLJ6mNDydzIw==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by DS0PR12MB7851.namprd12.prod.outlook.com (2603:10b6:8:14a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Sat, 2 May
 2026 01:02:55 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9870.022; Sat, 2 May 2026
 01:02:48 +0000
Message-ID: <6f92ad63-e601-425c-a61a-5ff929cba738@nvidia.com>
Date: Sat, 2 May 2026 11:02:41 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sunny Patel <nueralspacetech@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260501115122.23288-1-nueralspacetech@gmail.com>
 <20260501054416.af0ed62d635c3eb01d425e61@linux-foundation.org>
 <24ab5ddc-11a9-40ed-90b2-1a6c68010928@kernel.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <24ab5ddc-11a9-40ed-90b2-1a6c68010928@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEAPR01CA0070.ausprd01.prod.outlook.com
 (2603:10c6:201:30::34) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|DS0PR12MB7851:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c20064c-42f1-4464-7d8b-08dea7e68726
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|10070799003|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	d2ZPFo+YimhJabKkAxHC4UOF+aRJuKVqgU7aPdggOiwVns/u6VI+9BJAwILdyNYPnqVhDQARkGkUnbFV3vPSWVr2Tj749wys0rLTCNZbeF4FaFXUCt0qnP8S21odr9+4C0RTJs8gPSIdngUgxpo+ltiQaASoIeIUR3i/QC5Gs5uhvPZxxnz8xp1XQUBTwK85Ef02SnD6V0PkZI8on6ubfLr2VekqeSIJmjuelK9sYCqizm5P/BGDNzr0sBhn7MpsqmS6KtKh1RDOHAt0ceAfLpQjyiPDLqX9KgspAorYwdWKIPsUF9pplyxeYzsAuZt8UuLbhVKoP3TfhRtQT7yvhLLuW+OIP9ajMpvPnEmxfAMcjdOQQXK9iv+35mWJa/sXCVVR+VmGtorhOLxQ9D4NaOdEduIWUQf/XpwlJQWGTIt96qeiaDXD/8/PDxd5fnXNmpm7W7IdJGeCdpfstmKfM1hzxDOAWm9dg15uqXFHzuQKAd73/D3Xj7OxRu9nvIMb+rny4MmPjx5HgOHcXDOfw7A5ETdPWT3poLIbHw9NUchn0rTN5Vl6qdOFzBuXqHeX/kdZ8X2gLw5N5SHoH4txjB7ja0KoJfN4G96AtJxH8Hv2hAweD8L1yoW6KnfiPCh+4Y5tYv5ExjZpNRuVH0J0A7cLK1XmXiQnUamRX1htIPJaoVe9IpQDaoHtHb0tQSPr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(10070799003)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UWU2NGRQZURQbEJraHVtYXBaM0J6WnpEK0lCT0dSNWduVkQ4TXdxNGVwME1w?=
 =?utf-8?B?THV0Y0hUa0oxMElyU0RUdFU0eTQwTTRsNmJDazNnQlJKTFVweUNqYUhpZDFa?=
 =?utf-8?B?Wi8xNWpQcTRHRGIxVFpVN2ltWFpqTkt3R2Jzbkxzb1Ivc1k1QmhLY3BzWndH?=
 =?utf-8?B?U0JacnQ5ZjdBeHZnWFAvS0JpaVRkZ0lncjNwb05qRHFSSTFad0UvRFBWN1ZX?=
 =?utf-8?B?czYrbjJsMExZcjZhVFdNTC9wOEZOTXg1RUxrMVRIYy9uU2hCZk15SjRMR21L?=
 =?utf-8?B?dWRKYk1odXlHLzJOVVpzNlNTZnI0Umg0dG5XaTNMM1RsMnNhcW5XakJBNDF6?=
 =?utf-8?B?Ry9vLzJWUlY2NGx2MUJwVWhxelN3TXU1eFdhVUo1T1laM3QvK25jOFRLZkdO?=
 =?utf-8?B?RnVYMnpOQ05xdzJQSE9sNFBNVzgzb2NWOU1iV1NFUjNKK01QNUFjOU44Z1Z5?=
 =?utf-8?B?aW5uQVBFQytWcjR0bjVqZjBPZjhyY1oxcFIzb3BMQzMzZi9iSEhiRHlCdmpu?=
 =?utf-8?B?aUNMMERNcFFDVmlLaGwwSWI2U3RGaFoyam5Vd2tUdWo2QkZlVEVWZ1l1YUhn?=
 =?utf-8?B?UnVWNysrY0RHeUxFcVVGZmJodHVwWksxUFNDcFkxbzhhTEE5bnNHc2l6M1ZQ?=
 =?utf-8?B?ZVFWbERQTnRnU0NRTUdQMGdYQStrMWo3ZjRPNVdiQ0MzOWw0YmxPRjlWU1VF?=
 =?utf-8?B?VmUwTHR3bzNPSkEvekx4NlNTaXZ6a1d4SXFiRDhQWVVMU2hhZjdUeTkxNW01?=
 =?utf-8?B?bzdUbDl4eWY0cmZSdkNsd3pRUE5qOGRvWFl5NHJ2ZWJFSWFqaXZnVWx1V0pw?=
 =?utf-8?B?NHV5WkpMNDhJYmNNNzVPLy9taHF5dTZRc1J4TWtEZy9mQkxuVW9YSndFTzc1?=
 =?utf-8?B?VlNNaGRVUkp1bWs4R1paTlhEVHdudDU1eXpQdTdOZVIyeUpiYllRRHlsZWpQ?=
 =?utf-8?B?YkZjanErVm8yZjVHNGJSYlhTZWFrSFJsSkdyOTNIMEM0Y0hXYVN2UnNVNTIy?=
 =?utf-8?B?ZDhvdWgyNS9RdFBOSExoLzVxQnZvRFJEa3U5WGRvQ0xWRkRoK2VwbTQyQnJI?=
 =?utf-8?B?OStwK3F4blhLbzZFdXU4NFp1aVl0ejM4SXgxQ05hNGI1QTFkUlRZUDR1ZGxB?=
 =?utf-8?B?bTd4L25hS2k0YW9TeU4vdURPUUIxblNSN3J2MGJLQUprNFNRR0RleGZybDNV?=
 =?utf-8?B?MU5aQVJXSVdxLzhCcVloUm1SM05sNjRYd05uMDFiL0dlMkErNnd6eHYxU1Nh?=
 =?utf-8?B?eFhVcWc4YzNmUDhsWDUwS1J3MzhROHh5ajlqZlRaMm5VZXZBTS9DRDErSEJm?=
 =?utf-8?B?T1hFSUVxN1N5SDd4YlEveUhVQzkzanFQVkJWeGZSWElyYXdTTXp0QUdTTnVv?=
 =?utf-8?B?c0F2YnUzelFuMHREL2VIL3lEdXpwK3M2c3hqYjRFQnhiWklPUFpWZnhiUHlv?=
 =?utf-8?B?MEY5TUxvem42ZTB3WHl1KzJ4WTVoeTdBTnVlNVhzTDdGM0dTS0xCWkRVWnVD?=
 =?utf-8?B?cnhZRzhqWXZ6bmlhU1Z5T1RHVi9DYVpnbFBOM1RJQ3JNbTJ6NUpQS05pTWhv?=
 =?utf-8?B?V3U5RW5JNW4vS2VqSkpFaE5yZmY0cWF0YjdNTzhscDJlclFrQUhoZXE3a2l3?=
 =?utf-8?B?MnRHc3pwSjAxbVhUZWlOVk5CZE5kSHFydzlqUzJQNE56dVdlSzNxeXJIcXI0?=
 =?utf-8?B?WmdUL3dEV2l0M2xIOEc5TkJCdllGazl5SkVkT1ZrRTArdUphNGhpbnJuY1Fr?=
 =?utf-8?B?Sk14dzcvdSt6RUVnblQ0QlJaV1R3bGF5SFg2ZFFoYUFvZlc5RW5SSS8xS05q?=
 =?utf-8?B?RmJZU2xQVzM5VWU2SVF0enlwWW1ROE5RaXZOSHRKMkIzU09BVVZ6NTBiRUVz?=
 =?utf-8?B?RlVDaTUxeUJvTDNTa2hSUldNazBHdnZ1Q0k1eTlTbDVoU0JucjdWTkRoaWlJ?=
 =?utf-8?B?aE4rejJxNzBJQ1RZUFl4K3NuYzZNdmVCUk5EQ05CaXJZS2M0ZisvY2VpUnNJ?=
 =?utf-8?B?UzIrWm9zeGZDcnJvTER3bHorSXdwWFk3QU1LL2lHcENMdXVCYllHZ3VGZzh0?=
 =?utf-8?B?UXdZZ1cxL3VHRTA4QnBKMVZGbk50Zk0rcm91OUx5bXZoREVUSUh6dTBneXFi?=
 =?utf-8?B?dDdUMVFjQzNzR29BNk9abGRNeEM0NXk5UmljVWxJNjl4WU9sblJabThoR1kv?=
 =?utf-8?B?WSt5MjJQYW8xYjJBamU3Njh6QWFOWitObVFPZE93NjFZU3AxNEpTVG1hTUtM?=
 =?utf-8?B?RnpaTEtsT2RBSVlrOS82ZUtzVDZ3SmNkUFRIajJmK0dzWmNBSk8yM0xtQ00r?=
 =?utf-8?B?TkJwbHFYNHRTMHpoaDl2WXN6MWo4bFVveW1Id1RPTkY3RDFGUjVHYUluYk1m?=
 =?utf-8?Q?7h7FJkMOWlEffcNRznmaCdj0rMaDX89Ym4QaJs9yt1U5t?=
X-MS-Exchange-AntiSpam-MessageData-1: 8Kdhz05UF9axeA==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c20064c-42f1-4464-7d8b-08dea7e68726
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2026 01:02:48.6244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/J7kgvs9pBqB5MivzCj5Fms6kkEe5B0wIDnihdttDdA16WjHaySQvjJ4p3d2kRSvbBCL73R/o5udO6SSPTWaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7851
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3DD5040012
X-Stat-Signature: 9qzmbquueusxqcht1q51mogcbu1byw47
X-HE-Tag: 1777683782-852367
X-HE-Meta: U2FsdGVkX1+Yy5/E29Y/DN78FOjzIQAEIOfYWe/uGPJaopdvGB6xD1vfQtm8OJXZtu/OySElqErTWC9YYoAw71Pj5nCnDO3Z7lAMSOaOatUQzkqxNsynn/yh1R7rDcAGOoJUEfNj1mII4i/fLtj78ScMVmSokxV05gnwSJWc125syUaEl5jzkHrA0vDDaOPMddt44ywq58hRqoR7Ca2UUlqcnRVqLWOkXdY7aKAN/z2dyI1Q0197SBR8ZuEKJv/7zurDwRyIaA+PgKifhTAk2zP0ch5lKBnX5syeuEJdPUYKJ6cSY2EyWioObwvb/MuppBi/44DVvMKsPaGS4XlnLOd7iqQUEJXjecN2RYSOM8cbU94ozgyCSWJTuwyCAzZgcKzcAdtccLxN9ItEn9IWUIJpDzokRV5WmZcBLECSJEzFjdhk+1gpedNRQb4m+trtAX3HY35HGt3l+/LP2pseY1vC5Ji6x6PkwPVoCS1ZiALlHBMb+BglyY4ax4jfPj9t4OX12asp+a0NAQ6W1n4zP+Dn5aNCTEKjbGWQAA6FzKcq+vFIzkbD3pG6da3BOnQPEdGNGi+WE3n8rplKQhVOdn2CZQTOrPHRymot6lCXa+dVpAiPo234F6HtXqzjt0M0oMfOOb6gcr3BbmugzOOzzn4ZAK06aytQj5W0jxRZdMTkbsFEKy8ck1bZJjID4iYbu4KpDqwJ5DW4CJ4TZZ25CzYMWZl5EJyjGiJh3GLi96zJxXdKyqqOH1mRk6qHDea6EMPzEfPD/62yqxkuJt61pmVvdVcLXQdC88wKFrXvukVGczbI0H9PBMePa+wgA2u5MuzgIi3NT5nBsVC8uAr8JqdK0l+PiwMImrSQiB8xF9pcZxTCtH9bPZ9Gq4CQkU3mSwRa2SlMNQocO4gjvEtTQ4jlQkDJyQ+PX1jDusWFkLKoxChpyFn28o16P25jsDck7VWJP3LcsaqTeC/Bsk1
 clS8lQp7
 A2XzoJwOA9KUjX5NY/MaDh3wC2Oxs8Ko1uU5a3fBo4klWmFaZQ+jWfDorevT9ddRlqEk/B9B47cY/9BRY76De4s+TTjSrlY5CCdJGO0ac4Uno8ua1YYGs/tRSHBDkSap81A2rNHZsYJPTW8ilfbeI790bx5cHozT69EE8gZUapX9Uika9xvooLFob/HL1AGxvIRaI4FyU4/JyGG9SYs4bUg6sKDxIWBE8dp50FXvmfrAIQ+cqCsesZq4ihVSDksQeRHzvWywd0/WM9GnWuHGwsVGFdNGkh2CiS9KKXeWJE+x0d1rG0t41JI9FLPk/zMZSExAAoegIwy3nghNjaHbmQvCcGjvNNarutZj5H8UBbHEswCK7eYLMN1XsUu8Z1e1WoJhcXXLi8uvqvfuSebrbPipyvr8+SgUPMEWCGH18JP4U1kZsCwi5dn7BT4Gg42ZU4kFecN88BNlnU++hLv2QrX3j922QKZd2pQ0iTN/pEGoi8T4PnAWwMPuYuVyRQQnKfHN1e24CRFJaSgXGrf9F9wCMybalP9TbNU5e7JXUGRvP2F7FEggEDhE93U78xqo0GoRMI09QSwoPdGY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/2/26 05:08, David Hildenbrand (Arm) wrote:
> On 5/1/26 14:44, Andrew Morton wrote:
>> On Fri,  1 May 2026 17:21:16 +0530 Sunny Patel <nueralspacetech@gmail.com> wrote:
>>
>>> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
>>> to a PMD check failure, the pgtable allocated earlier via
>>> pte_alloc_one() is never freed, causing a memory leak.
>>>
>>> Added free_abort label to release the pgtable in error path.
>>>
>>> ...
>>>
>>> --- a/mm/migrate_device.c
>>> +++ b/mm/migrate_device.c
>>> @@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>  	} else {
>>>  		if (folio_is_zone_device(folio) &&
>>>  		    !folio_is_device_coherent(folio)) {
>>> -			goto abort;
>>> +			goto free_abort;
>>>  		}
>>>  		entry = folio_mk_pmd(folio, vma->vm_page_prot);
>>>  		if (vma->vm_flags & VM_WRITE)
>>> @@ -893,6 +893,8 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>  
>>>  unlock_abort:
>>>  	spin_unlock(ptl);
>>> +free_abort:
>>> +	pte_free(vma->vm_mm, pgtable);
>>>  abort:
>>>  	for (i = 0; i < HPAGE_PMD_NR; i++)
>>>  		src[i] &= ~MIGRATE_PFN_MIGRATE;
>>
>> Yikes, we leak that page on several error paths.
>>
>> Thanks, I'll retain David's ack from the v2 patch.
> 
> Yes. If we want to avoid more labels, we could do something like:
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index ab49d4dcdb60..babb56c4d47f 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -795,8 +795,8 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>         struct folio *folio = page_folio(page);
>         int ret;
>         vm_fault_t csa_ret;
> -       spinlock_t *ptl;
> -       pgtable_t pgtable;
> +       spinlock_t *ptl = NULL;
> +       pgtable_t pgtable = NULL;
>         pmd_t entry;
>         bool flush = false;
>         unsigned long i;
> @@ -818,14 +818,14 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>                 count_vm_event(THP_FAULT_FALLBACK);
>                 count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
>                 ret = -ENOMEM;
> -               goto abort;
> +               goto error;
>         }
>  
>         __folio_mark_uptodate(folio);
>  
>         pgtable = pte_alloc_one(vma->vm_mm);
>         if (unlikely(!pgtable))
> -               goto abort;
> +               goto error;
>  
>         if (folio_is_device_private(folio)) {
>                 swp_entry_t swp_entry;
> @@ -840,7 +840,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>         } else {
>                 if (folio_is_zone_device(folio) &&
>                     !folio_is_device_coherent(folio)) {
> -                       goto abort;
> +                       goto error;
>                 }
>                 entry = folio_mk_pmd(folio, vma->vm_page_prot);
>                 if (vma->vm_flags & VM_WRITE)
> @@ -850,21 +850,21 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>         ptl = pmd_lock(vma->vm_mm, pmdp);
>         csa_ret = check_stable_address_space(vma->vm_mm);
>         if (csa_ret)
> -               goto unlock_abort;
> +               goto error;
>  
>         /*
>          * Check for userfaultfd but do not deliver the fault. Instead,
>          * just back off.
>          */
>         if (userfaultfd_missing(vma))
> -               goto unlock_abort;
> +               goto error;
>  
>         if (!pmd_none(*pmdp)) {
>                 if (!is_huge_zero_pmd(*pmdp))
> -                       goto unlock_abort;
> +                       goto error;
>                 flush = true;
>         } else if (!pmd_none(*pmdp))
> -               goto unlock_abort;
> +               goto error;
>  
>         add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
>         folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
> @@ -891,9 +891,11 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>  
>         return 0;
>  
> -unlock_abort:
> -       spin_unlock(ptl);
> -abort:
> +error:
> +       if (ptl)
> +               spin_unlock(ptl);
> +       if (pgtable)
> +               pte_free(vma->vm_mm, pgtable);
>         for (i = 0; i < HPAGE_PMD_NR; i++)
>                 src[i] &= ~MIGRATE_PFN_MIGRATE;
>         return 0;
> 
> 

The changes look good!

Reviewed-by: Balbir Singh <balbirs@nvidia.com>

