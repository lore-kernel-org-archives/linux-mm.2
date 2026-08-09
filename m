Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D260EC5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 02:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF41C6B00F6; Sat,  8 Aug 2026 22:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5FA6B00F7; Sat,  8 Aug 2026 22:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944A86B00F8; Sat,  8 Aug 2026 22:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 506406B00F6
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 22:29:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B468C14047C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:29:32 +0000 (UTC)
X-FDA: 85080149784.28.8A1130E
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013058.outbound.protection.outlook.com [40.93.196.58])
	by imf22.hostedemail.com (Postfix) with ESMTP id DB76DC0002
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:29:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CRFc9BEJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786242570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sR9yxfq7XRK8KcxWfBXcyrld5iExm0me+zbLnLAwF14=;
	b=CDP+nWQhLLLPFWOeksP7ZMIcbW+lx6wiAuX0WqWFpKzZc73/XyfMI/IXL9NdRle6K/NSqv
	gMFeYc6VKmQQtFv3c9T/kF+cfLa6RBISlamGqEW1nQa8BrgpnpcDSYPXU/0ZCTJLhmWYtu
	wioNtuuxw5sXn+/S8W3NrEO2wf9Yn3U=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=CRFc9BEJ;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786242570;
	b=ECr4x/1+9t2V1seo0tlDMhhLjLsK/Zf7t6G55IHwP3VzRWI3bdq68Q6pH+naj9eT2tyOJw
	jiG/Y65TYNVPtqvi38yLNcRGHC5prRbXJH+SkPA3jcyEtg/AsX9u+SU9jJOW16hQ9dLNDh
	dhhGlPwyh8j6LCM8QYCU6js3dALlic4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NTDaRGVXqci3j6bOHqbIHJc4tkIKBnOfCXdhbV3nsujvu8luzbFTnYC/H5O10cNK/+YzwzML//yrSaWMZ2O9SGy615a6WhdYRNB3A/Qpbad7EPG/sBMaaE3/RBqQelp7tqDjjSn5ayyOp25FQQKiprK7XA+a+mZtYeGnCUG7FLeSwUBU1BjpJir5BkwXwtyw8Pi0V1+hKUleaIkiTLdK3n2uuyngJTDVcEUwvrVZU5XCoAdOZ6c54XS7HIy6DZ2PttPbKzfwYJSFWTaWEk673DALfnWhdZBy9tU0no4hXx1MUM1q5JGIIA5xkaHbYN+ftkwqhk2ZDMViv3DB8+5yRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sR9yxfq7XRK8KcxWfBXcyrld5iExm0me+zbLnLAwF14=;
 b=Ro6J0iAhiaV67zZO5y/XNmi8NXkQoOE7yX+/vshmuRD731yc/2+9osDpT8AjfQoEHh4jba+5hfUXv0xsYva/ck0IPJnyPK0+SIDqZnhmE7xk3u6ax25aruc1ryKyu6NbhCONabbOTvkUk8Cy8hy7wemD479FZY0zh5D1mXaftc+ZHUfN9U8QsLCs38MVurew9lpYH+z2GreMy2SLikPXwfszHoKvh89FPDl2m06cgdHhBEn59SeJmpvJWrB4E4IbRxz4b2SXLkjo3QBdY0xFdVkihjYhOcDKvOb8uGm1McwNMgaQWsvoalasC+X7TF5gsJ9BPBeigsx1RpvYZ80ZHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sR9yxfq7XRK8KcxWfBXcyrld5iExm0me+zbLnLAwF14=;
 b=CRFc9BEJ3hzs3cS1+aahdPFG96LHU1qI4V5YtXcRq1oeBgQg/A8RkHMaF4nGpi64HuTdbtNvmXJ98Q2ktwIT2AxEbMcVZi5+hlftgdr1yrXzZCtr0Hlts8qdL73grorGdNZYP0Ja58AgmDGgk0utpPnp0/bfo8hvl3BslRia246qWGmg26VPhrJc3y3qhNY2TdGP1uORm9XiKXJyAYGs3z+ht5uMaxfZZf6cKcwWo4pfIM1XVxhgpv7LX15uDAhu5roqL/uFVs7rrzhc/I0LsxS5aOVjLv+pOmbMiOGDJs+uBOIsVcp6ZbVvxV2+GWzD9k820/dQKY0Xoy37/BsizQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA5PPFB2BF91BC0.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8de) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Sun, 9 Aug
 2026 02:29:23 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sun, 9 Aug 2026
 02:29:22 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 22:29:21 -0400
Message-Id: <DKK254J26GL7.TD1NRM9G0D7M@nvidia.com>
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
Subject: Re: [PATCH RFC 09/13] mm/huge_memory: move memcg switch into the
 file split helper
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-9-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-9-689939a7ccc3@tencent.com>
X-ClientProxiedBy: BL1PR13CA0205.namprd13.prod.outlook.com
 (2603:10b6:208:2be::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA5PPFB2BF91BC0:EE_
X-MS-Office365-Filtering-Correlation-Id: 3997b116-db9f-42e8-0ad8-08def5be060f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|6133799003|10067099003|4143699003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	AXl+MCRYejF1oTw/3R2tM8uT4sib6tGo208I+dkm9XXiFnFBSnYdZlCrt00cV/EMny31g2WrlOIeqBv6mahzdMs9888Axj3PsRK3kn5hwLDLnGIhKRPTHat4NWF7x+dxlBEqLJD/DWR58zm+1fujs7xpto7KYynRurbXMBLxtRUTeibVGcsNXQ0bBfnzHVyQV6wLpA84+6YKZGrMfbtriPHy6lmO+PLnzsrQXFePzo4Y+v/bYBZzzZq+QbQMOgQ+oahMskka+XJyMZA2faOTcPMx0sLFEUTAycGWtPdjQo7WAs8jekJQwknC3HitsRJCbGmaGu3vHbFfSGGh71TNAPtVAc30Gu8Aj2a9S7ZPw9MI3cZ/s33tbd/BS9myuM8NzrO4DWu3OZ7s89MAdg68RpECT0YEeT5LYqlCZD032E46OLRsdG8ReorNCG6wMahzx73/kdwku1LrW78MLQWKuTpcj3hOx6T+ytiQ/yC69NzGScBwcnov2ld9MAZG8H8UVZFrZz8+O2PE/pU+7XUJXJ4m7rfBgL7CF78oCCNzc0e+wmSuxOrxP3LB8qz1Dzn5U62dpiY6y9MXd7gKnlkUEB3MPiaQakBa6kM6TQoq2GBpdLl7igyLLflm/0aidrPmaEG/tkFi4kM6BQ98rSOuby+KzKFHv+K3tFqKNkuoTL4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(6133799003)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UVFYMHhkZTBkSEJ3dGZwVW5qTm5TZzZBQytVcEw2WVJTNFIveFBUNUxCd2oy?=
 =?utf-8?B?VUU3ZUF2MjFVWUJzajlGekpscHYyY1k4TkkxdS9nWHo4QVo4NjRVbnNPUlQw?=
 =?utf-8?B?YThKTjhBaEw1WFZrektrN1U0MGV2T01IOThpSkg1KzN6SnMzWm9jKy8veTA2?=
 =?utf-8?B?VE1aMWp6d1VYVTZGQnVhdXFqNXZHZ1JmSyswcmRNbFNjMytiQmVYTXpkSEJQ?=
 =?utf-8?B?ZU5ya1dLTGVqV0NSNk9WZFUwVlRSQ2lLVW4rNFArdm05TkxCc2traTkvallF?=
 =?utf-8?B?LzVoK1RMTFJ6WDZuYkkrdHJ1cFVVL09uTStBSTRpQ2JZSnRnZGRDeXdSOUk0?=
 =?utf-8?B?ZVRWMEpLcEorcjdTTnB2enA3VDNYYUVoUVpwb1RBbmlFeE56Nk9uQU0wSTRt?=
 =?utf-8?B?azJITm1UVTZDME9QWlUxOUg4QzVtRmgrOEdsQjdoOUhIQUQvRElaeVdXbllx?=
 =?utf-8?B?aVI3RUl3elhpb1NJSFFlUU9nZ2t2bzlEaXZoQU9GYmpJTmE2Q1dGeHlpU1lr?=
 =?utf-8?B?MTAzSlBNSDQ3eHNWd1R3bHlLajFJS245Ukp4YXllbDM4ZmtYVjY5REVITFFI?=
 =?utf-8?B?MmZSVjdlVUl1QnRCTWFiT3I4eUdFeE81Mk03ZHFiSDdETy9mN2tKRllFK2x6?=
 =?utf-8?B?Sm1wcFBQVmRIUVVqb2o4eWtIMHhlU0RCQlVKbVpNK25WSDJYd05WaCtvenB3?=
 =?utf-8?B?eEhDajY4aGVKaCt5VmpYa3hOTVR1U3M3Y3RqUjhVSzhBcU52cFlpL2NsVGxO?=
 =?utf-8?B?dXZYQWJaZ2JUOGN6NzV4NjRBQzQxb0dWbkk3L0kxZVJsQkJWNDVGVWdvdms4?=
 =?utf-8?B?WkVudHRKT0d5cFdtTUIrTVVTbjA5RkYvZ013SGRlVVZkbGNWd0RQTHpmeWc2?=
 =?utf-8?B?QXBPdVFITGpQdjZ4VG03QTFrcmc5MjBkM2NocG9Mdm5TUUlRL2VybGNGQ1BB?=
 =?utf-8?B?V1BWU2NrdDY5YUVsQ0tPZ3oyRVRxZmJqMGZSSGkyNC8vNnUwSUUraDYwT29L?=
 =?utf-8?B?QW1CMjVoMS84ZEVWQ250R1lFUUVBSll4ZlNMQUZHamxHOWlwMkkxNTM5RXRh?=
 =?utf-8?B?d0RDdGRlRlN6RG1yZE9rbXEyU0N0ckJKeXhLWnJDN1VsckZ4VzJDcGdYdnNv?=
 =?utf-8?B?QlpsSzJYUzZmdGRyWks4cHNoTWJmTmlYbk9qdUhJZnpWSFVYSTRYTWU1ZlBO?=
 =?utf-8?B?ZktTbjZLN2JneUgwc1ljcVJDdE4ybDhrcVlEa0xtUWNsVDlmb1E0U2FnSFBE?=
 =?utf-8?B?cUN1bmgzUkJ0Q0JjNGlsZUYwS2JOTmY4d2x2dnVsTDNkZmpQVlpLSHkrYi8v?=
 =?utf-8?B?d09sTkd3YkFSQXhDUmE2K2w0dTRlcU9CZXV5cFU2dC8vTUR6MEcxanFxaUFi?=
 =?utf-8?B?cTdCVlBRMTk2U2ZuUVB4QzJXcVBGelNvRHRNZUFCMjlwV2tSQW9WMmNYUURx?=
 =?utf-8?B?NldsSnEzUEp6cm1XLzVEbjhGR3MyelVXTnM0cXJScVVoSkJjWHkrZkllMzNC?=
 =?utf-8?B?TkxPZlVMR3N3RXEyTmg5bHFDL2RDd0NNTjEvOHFKcStyTkUyZW5PdTRlT0xy?=
 =?utf-8?B?TzlTam1qbXdsVkhsMDFEL0Z1eU1TL2ZjL0JnbC92YnR3ZmJKZXZOajVrc1F5?=
 =?utf-8?B?dnV4NXUrbEV3RnhGMDlwdU1KRzVocUJSWGFoN3VLckR3N3VsTHFKcnhka08v?=
 =?utf-8?B?R2ZkZFlNRWFGN0JFb2lWMmNoYk1KbmxoM1p6Q2NiaVh4ZlQ4NjJvc1hUU3dE?=
 =?utf-8?B?N1FCZTZWSCtNaVJEOVFCTDZHOGtkSGNhTm9rNk5kTm15bis5UEs0T2RQL3Mr?=
 =?utf-8?B?WGpZc3BLSFM4OWhWdytsVU1SN0ZkSGFJTWpkeFQ5ZWxxcDRMaXdzZ0xyUHBm?=
 =?utf-8?B?b1hoWTlKbWlZNHZ0UVlGUXlnRVFQQmxpeHJOeFp3bUJZdnREVG1CL1RNUWsv?=
 =?utf-8?B?VVRkRHFYaW12VC81KzNDa3Rtd01uT1loWVkySEZwQzkxd2JDUDIwZUNpKzQ4?=
 =?utf-8?B?Rkt5dDI2YTRwUnl5QnpvazdOa2tyMlVyenJMTU5hcG5CbkZmaUxIS3ZtQkdo?=
 =?utf-8?B?OHU1M25zWGE1VEtzamNxNHY1dG5NUE9UUmdEa2dRcWhxV2k1b0xzK2QrNktJ?=
 =?utf-8?B?d2R2NjFKNXhpcXlTbXNqUEYwd2ErV2pRWjQ3c1k0OUwwQlptUGVqcmhmSTBB?=
 =?utf-8?B?STVvZUJJMTdoZnh2MWl6TGlGWkN6SXc1aERhczkxcjVJWFZvRENYZWN0emdn?=
 =?utf-8?B?cTFEbittMEJ4SytIZFI1QTFVSDJZRlBGdnJOOUFISUQxZjBIMTZXMnJUOXRY?=
 =?utf-8?Q?EGpnemzSM2OOs8FQ6X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3997b116-db9f-42e8-0ad8-08def5be060f
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2026 02:29:22.8717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3yRr84Gd6Cm5XcTm00WpATG6XjEEQ1wOlO0EEeOShiV7uY/F11XTk9J2MPenk9RO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFB2BF91BC0
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DB76DC0002
X-Stat-Signature: artdzfoyhmmr1bx739m8igrwr9zja8mb
X-Rspam-User: 
X-HE-Tag: 1786242569-818058
X-HE-Meta: U2FsdGVkX18n32OmszT87Gdf4TeCuW/drBXKe/tq8D8qE49seFyYx47FVSQAhTzRxS9IVKBitoF+MxPgwxYsjAefXVr+R5hhFbhhZXFtggmYb+UPS6tB4SrXngdzgIhW3i/IHHohZkTGUOZ6emhmUHfFjhSY6oxtIu+ecSJ478LUumd4s1ZT/udMsSm8Tt9fUwqv3p3XCwFGaPbPnwZbm5Ph1w0frxa1sjUptwQMRmMihc+DF2e7s7ftxYc+ntoRB9k2d7lmwMhEYDaq6xySjWElpZIQ8N4VoOqkp+fHtdnrkTIwxBPHfMfkC4b7Z4NjSr8jEwRlIH6SMriFFOCNUKHl8t0TDVnqIiguBqKtLavKPsGm9gdn30ZYI/Ee5Ykz2Umv+hYoSY/oKtwV7nXwPZmAhQbY1YA8LwDvQvpSeNJNtq2Z2h9QRLaE7Z54xHY8OUureKPeYIzgevD9FYEX9n1YUbt5exsHh74o39w36sczULDqsd3Vc8TinM8AUGT2kRi9vpvmMvjLTgaOE4WKjQcWoA0zWgkLVfoAZkhjVq0Dkd9nMqs0oR+9mZFFyFeX629VXWdobZqAvi+DMkcsvhNxN7VeqZJeTTDeePpiJ7OSo7SwG5INq1czU6pDZc4oJXgM+ZJFwo4GPV726uofDdUKKiEGuY6P2/Bz14qKw8H8LxS1pQWACeN7J0II/UoBqJSl2RC1FbPWpnSvoZl+tTftZtgJpu4S7bBq4ITslFMIngBEj5zhOM03yKJ8fPjGwr/xq0Ic2sdQumhch4RTwDMDLBHVda9qB+xepieGdRvSQjLCkuJYQWkap2yCwMSMwHCv8jEtFf2rLXD1SjcIpeQlP/f9P9mf9yL14YKy+3SqUD7mKv/XoDByVBQYM6/7J9Z8QteAs1tfd11PAFwUbPSG3Ifhoj1c6l0iFWlfkibLpJ5O47/XIa35YbTLJRUF28WQ7nYXD8um0OXDL6G
 AXLox4Qy
 NBzjfZOt0cmzCgS14PtBqDNl56ug3UmgGccvgIapvkcf6BpcCpuWGL0V1OhLaUJY7wBQGOPHEvo8Vi6XNaIheTCSZbztanZKQoh4g0MMJnITn1dCk0VWGImfidUyJmzNU7KQL97ZD+8w/bio8ubktAHbKgFQfgfgfGNulOVcklKLeNeckKc8eS5vKWweLBMAqLIiHM3kTVju+EncE0e5eWw1GhkUUY7/VG0J9R3jVxFocuoSOkzlq9vPhRjvD/xiVdOWH2Uk6PCJGP+vBRsA78KFL2RHUeM8uCKUX79d0k0FguG0B4po8t7Te8VtSkXixpVh/iyYIDM6wGxvGvFRjAdMmdNyk5RBjmyM6Gm3nBITD679VxwHAUEioiKuibA110JLZVHGfh7If8wYKjxR8I0TIhlgZvVy7Z4wG/dQzA3/uxpqWsTY74/ZmY5CdM6Y0kNYsuEZZSedBf6bqEd+lKxi+Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> The xarray node allocations in __folio_freeze_split_unmap_file() need
> to be charged to the folio's memcg, so move the memcg switch from
> __folio_split() into the helper.
>
> The anon split helper and the after-split folio freeing perform no
> chargeable allocations, so no memcg handling is left in __folio_split().
> Rename its out_no_memcg label to out.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 36 +++++++++++++++++++-----------------
>  1 file changed, 19 insertions(+), 17 deletions(-)
>

Yeah, it should not change anon accounting.

Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


