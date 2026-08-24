Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E894FC5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA556B008C; Mon, 24 Aug 2026 13:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BAA6B0096; Mon, 24 Aug 2026 13:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52BC6B0099; Mon, 24 Aug 2026 13:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 909F06B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:38:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 250601401D5
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:38:19 +0000 (UTC)
X-FDA: 85136871918.05.A010C21
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012022.outbound.protection.outlook.com [52.101.53.22])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4E5F5C0008
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:38:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nqJLptia;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of dtatulea@nvidia.com designates 52.101.53.22 as permitted sender) smtp.mailfrom=dtatulea@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787593096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hm3h8e+sMh+d/mdJtHeW5XUau1BL5R/3hDeAxrWkbdw=;
	b=8plvHnXY70JoLX2QM4lBD4+bBHjwADPGWBPcIJJSehD+jN0Xz2MG/xzbALo0R3mzCwkczK
	9x+JF1AJKBHqG6rU5BVLM+n/VblKleLN9ZcqjHNleDP8aI/E6Xq0t34uoGaLvK5e4qHVPQ
	Yt876LAoj6AWZl+nwYlBK6CHZyMdrdg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nqJLptia;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of dtatulea@nvidia.com designates 52.101.53.22 as permitted sender) smtp.mailfrom=dtatulea@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787593096;
	b=VlHZ0S02+wOUF7lf9PFt8oy+r4l7mYtASdiLuEE1QsQSR8ZXw+sMhZB8qU2iI0upqyVtnp
	qf+lOm0q615dquH7XK5DahH/OFBQrT7zkPTaxcN22mWV9eEO5ujUwUfUuzxhvbF5H8tL6Z
	rHxeH7GqWzL+EfvYsc32bDvBLDpYhJU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Jhze1EDMWaOkzRnmdorug4obgWyjW3NwhNyW/qSL/806hMvF4XwRzhW3C47KRCX/3lFmVctNo9Le/20iohGW81v5e7+D9t44X/ctjk/VphKpdEFflwBAIgyQob5s09NgbIIULVYhOaCdSAve4hqzmaHDLIOJsNyP66zRWxh7w3vPtvREKjk2wo9VpLTE4MgKoIdyWY6+gwx/kdHMhwEnC8h6r8iwyUG4tUPe5ZAQjXe2Q6qQ2/ZpS1f7aurR6fw3VOSGsWz5XiVlS3ENwRyxNSSwbkiEQ19FHD/QJncLYoeG7wYF2NCLN8pcMcwOHahda1aJdK42/t4X/9NW8hIJYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hm3h8e+sMh+d/mdJtHeW5XUau1BL5R/3hDeAxrWkbdw=;
 b=SfCTihQJ82uCpg9plc9LRdy0Yxdh1XsoW3JiSx+0ieV2KxL/ct+hRjF9axzPLdL44yMItWNxIuoeXedgbM+JG446uJ79GFXW0iRNhewJTS77OVu8DfayCqIM+J7uYb097Ry84i5JC9xUxicBpKr58u7Tqvzkjw7e+nI9HjwlDCk8fdQ9l6LzIqqnUW/WzSbQAWe3yhYN3/HYuJfhx+7cRjTTo6ltVhOCjMf+jNYolqhwfQhr8kw1+1j4gAg8quWw2HnuFeGZJIKw94ICDowas8jD8QhMKFK9lwfaRABvizVVsMh1geu687NvVJCXYY8eHfNInAhln6N57/yAYqmv+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hm3h8e+sMh+d/mdJtHeW5XUau1BL5R/3hDeAxrWkbdw=;
 b=nqJLptiaYj7W7mMAg13+HndIzTn//6xtY4uJiCwZk5hs1iuAokvvUhCQYN2gyzYh+mGs+8B9AAIigHE3+kyEdi8vn7W8GMVMbmV7cS+iAihLLDsI9F/XDCRtyAz4p84Ouw1CK9SXee5JQX0mvuNln+nRz8Jbok/nlKuvT/7kiZL/dQNkjVeQNAm3bQFcokfP5V2yCu0McgojLln/3UCA1xgycVD7XT3xKKMk8CIEy4weXM+YQRS/7fCJMUdbfVX2fODjBgS5nisdu1AnuOSrsuwL+ek+x5gauAcDVKkn3mlt/NBpTZ/UfwC5YUmDE4srBznx8ZirtZ+ujcMzH9cPiQ==
Received: from CH3PR12MB8728.namprd12.prod.outlook.com (2603:10b6:610:171::12)
 by SN7PR12MB8820.namprd12.prod.outlook.com (2603:10b6:806:341::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.12; Mon, 24 Aug
 2026 17:38:11 +0000
Received: from CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7]) by CH3PR12MB8728.namprd12.prod.outlook.com
 ([fe80::2641:1046:bdf3:93d7%6]) with mapi id 15.21.0339.012; Mon, 24 Aug 2026
 17:38:11 +0000
Message-ID: <472d9fe1-0044-4e47-af5f-cb03618d77b0@nvidia.com>
Date: Mon, 24 Aug 2026 19:38:05 +0200
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v2 2/5] swiotlb/mm: Implement SWIOTLB nocopy page
 allocator
To: Luigi Rizzo <lrizzo@google.com>, Robin Murphy <robin.murphy@arm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
 Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima
 <kuniyu@google.com>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, netdev@vger.kernel.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260615234220.3946885-1-lrizzo@google.com>
 <20260824152932.1583506-1-lrizzo@google.com>
 <20260824152932.1583506-3-lrizzo@google.com>
 <a826c7cb-5e77-4c21-a649-d40a9f0ef564@arm.com>
 <CAMOZA0JstwiwoWFuFjpoC1W12ir2b=SrWPO9i9tto1rOksKGgQ@mail.gmail.com>
Content-Language: en-US
From: Dragos Tatulea <dtatulea@nvidia.com>
In-Reply-To: <CAMOZA0JstwiwoWFuFjpoC1W12ir2b=SrWPO9i9tto1rOksKGgQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0204.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ad::13) To CH3PR12MB8728.namprd12.prod.outlook.com
 (2603:10b6:610:171::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8728:EE_|SN7PR12MB8820:EE_
X-MS-Office365-Filtering-Correlation-Id: 959c2f8f-e659-4e41-15d5-08df020677e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|4143699003|10067099003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	cshxjT6SKBA5VDevf7UY09Eg8mBJfiegjEmH4LD3yEvX9LSRcUVhGm+WA/vZtZNRG0a/6544DpySqlb/AeboEX1li9HcdZUdSXGyyze9xBjuF655YH62slrsg02zAFHptFMtZG+7TQap/7ekw4k1okYXgw5kXbcUqnFCJrdx4RBboKXbgk1CSRjxHwBeFmgFmZBBIGTK5V3vhcUEPlCFHiD/HVii/6JpQK/ow9sb61xgMR2IoZnBzA76YzHcrzczHQ6ZlwxEYtvuJdaq1j4vt4r3n3DAJqZKe/E5v5/clcUnhZ7dJDnewNPa6kkM514GfDafIbh/u4ZwDx4oDq34qAXSKz9s0DgcTzGFF35pyCorjoh6AXMdIXX9HN1zjnZDp2fvKvAhHrNrw96IInXSfCIVwcoWc7vDNNsp5jEL7ZVRd/lEIwliVoKBcfsoIVZcY11pvnuFA81W+taQ7j8smWWlCi1zvvLgg2F0NnlZiTBa7RwRbEOwBsOCx7Wg+GmoAR8VJP01/ULcwwdklRCuvEcV5fsJaKGlxaBvaNCKlbDSFz5oNseuMWBE2Jr2Xyq12DQ1XJ3ayJ6w3Er5Az73d1SiOB2bsInTJWgxWIy8w1OJvuFz12J6FQiTHD3ehK1QJfcykIDSa1gsRO0Usq1sTb5GnKIq5GDK+g7tVY529lc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8728.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(4143699003)(10067099003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTd2b3FMdlVWS2tZMzlXTXJnczhueVNkem5Xa0hiMUpiTHNsb3h1U240THBZ?=
 =?utf-8?B?WXNLYnJMUGx5Zm80N2FiVlJ1SWwrZDBYNEtBbXJZeHJUYmJoV2J5Y1hVUXE5?=
 =?utf-8?B?cG1ML1Q1QUc1NXhBclFFaFBJN3B2N3BpRFBYV2ZmU0hRWloxTUVVa0FtWUla?=
 =?utf-8?B?SXFmcVI5YS9ubjhUMDNRdmFHSHJuZGhmd2EyTDRZWTBYanBtN1VSdTdyMk5I?=
 =?utf-8?B?ZWY4RVVwUFZscUZCQUxObVFCMmtnNkQ5NEVRZEpIWUlPK3J3ZVpic0RVSEJS?=
 =?utf-8?B?THNpQ0R6T1ZNTWZjdkFQZER1MmMvdkZqZUJNRXZveFRoQ3o5Y3pXY0ZJMG1D?=
 =?utf-8?B?VFl4TlFlR2tRZ3VRVElpbFJ3RGppMXYrakRZQmFuS011S2J6UU1QdXZoek9r?=
 =?utf-8?B?azlEakRvUVZyUWtNdUFLMXU5YjJETDFZbVFRajdyTHQ0dWd1VFk0MGNtdXpy?=
 =?utf-8?B?NUhrL2pST0VXZzNXaWRLRjlRQkhTTVlHWWw0T2V4Z3ltQm9TRWRvRlF6YUVB?=
 =?utf-8?B?bGMyMXZhS0NUMXVBTFFlTmFLU1V2Q0tUcDV4T1gvMncwRWw1WThwdW1jYlZE?=
 =?utf-8?B?a3dtR09tbHRCUGdjbHVKRWFjT0JEYUlYUVhzc2swdjdtMVhFdDBsWml4VFo1?=
 =?utf-8?B?cmhDdnpIRnRKK0hhbXZTRmxEcHFzb2tkSUVSUklpeVljWThvY0RVQkxmemZK?=
 =?utf-8?B?aTg0ZVE2ckVjeFA3bzQ1bFQzK3BBNlBNajZyaVhNYU9rYXNkZ2RyZ0c5ck9N?=
 =?utf-8?B?cG1TNXdyU3JBQ0ZwVXdyb2Q0UGNaMkZ0aFJVMHBybk9pMU1yYmZnd3lEeUZ2?=
 =?utf-8?B?MkFPa1lJaXN6WE0vUzVCNDA4SU9EY0FUSHVZem9laTU2ejF4aGFtUy80MHdP?=
 =?utf-8?B?K3kxem5MV0NvRzlUMWRjbHBXQUs0N1ZEQWpPNVl1Y1ozRkZDNVlOSkJYNjBY?=
 =?utf-8?B?Z2YzL3R0NFhxQVgxeGJQYmdFUUMxNzcvR3pnRnY1MStrMnM0SWx4OWJPVUhm?=
 =?utf-8?B?RDhMSjZDaXA4eTVjQmxjMEFKdEgrZDZRZzFheC9tUUNSdjU0UUxCaC9jNE9k?=
 =?utf-8?B?U0R5VE82WGJVeGVQc1VLSWdrcldRb3ppSk8rTHhzdjkrc0xxRG9pRW1udXhV?=
 =?utf-8?B?NDZoVTlzRGR3VVV1SlFsYjdnZjJEVjc1dkdVUDhBbForNWhCdEJvdFUrZ3Ru?=
 =?utf-8?B?SU8rRmUzRE1hdU1GYzJJV1ZLaGFNdndibDUwN0kxSEFNRXpadVR4eXpEVEV3?=
 =?utf-8?B?cFNLYVNSN1M0RjMwam9BdlRXaXpMMVBDQnZQNWo5Zk80M1RYZlRQZGhKYThi?=
 =?utf-8?B?RUczbjlnM3RMczFjUjFTM2gvS2NycWVJd2owUzAzWVdWMkxxV3BRV2llSzBx?=
 =?utf-8?B?eVdreExLazk5MUJ2cWdPdXRucG5uK0tEaE04V1ZmK1Q3b2ZxTWVVd3RJREtT?=
 =?utf-8?B?Rm1VUzBzcFFDK0xoZk9Ta0NGVjhjeTV5aXFsRWZFbk1HMzVkdDdPOVZ4eVFU?=
 =?utf-8?B?SnZQazU0NEZxOTNVem1IQVBhc1NvNnhyVm44eWdyTHFUZm95U205UWp0RERt?=
 =?utf-8?B?blJCNEtJUVFLdHZxcUR0bE9JcHJUVFgvdUxwamtLbmNZbDlrS3RuUDBlMXJT?=
 =?utf-8?B?aUEzNmQ2U3hVZGV4MzgyeWxJWmZCVEdnQkgzWEk0SFgwQlIzdUhpWXplTkEx?=
 =?utf-8?B?WS9vRklwdVpza25uWHp2Y2p5NDZFWlQvV1p1eHBpQVc3bVlORVZnYjl6K28v?=
 =?utf-8?B?YXlKUU1nNjlpb1hQRWljcE5JNXZ3RW1IUzVlaXhnb0JjeXhVbkMrMDBHV2xn?=
 =?utf-8?B?TkJtRkJFc2JIRGtacUE2Wko0Tk5Bc3pYRUdxUHYwT2VLZnlxL3JUZ0FxbW5R?=
 =?utf-8?B?RWJQSC9RdEpXYjg3QTByeXBuTGtuYkpJSDlVRzRjQzUwZGY5TG5lTEVrb3d0?=
 =?utf-8?B?QXJxMEdUZnltMmFqWEhERC9PWnl0WnI1eU9nc3RJUU9oMFN4V3BaOUxOYlBU?=
 =?utf-8?B?dmVnMStzTUVCZ2x4akZkdytFaXRkYlVWWm9RWndFMU5peXNFTmtHd3c0TmI2?=
 =?utf-8?B?SStsZ1ZNWXM5TWJNMksrV2hlWWlpRkp4b0RMalh1aVpURW1FeWdmR1pXS1ky?=
 =?utf-8?B?cUNzWnVGcDdoZzJIRlI1SG91dVNmV2NRY0hKRjZsMlhpSHQvaWdTNnVhN3FM?=
 =?utf-8?B?MzhCdXBsUktTYis0ejU1TXhKcmxQZENtbmdNRi9tMzY1dTR6UjN4UkxqbHlm?=
 =?utf-8?B?c2tMLzd1SkdRNjdCOVhtZ3l5RjIxaGdXelpIOXBkR29aVHVYWUt3RzFuekpI?=
 =?utf-8?B?S2s2bHRSOS9RS1FBSXF1bE1relk3VmVtS3BIQnd2TlFuNEV5WjlkZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 959c2f8f-e659-4e41-15d5-08df020677e3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8728.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2026 17:38:11.6550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: md0Zn1yei7aJBqgTuVk+9LNllLK+xUdiBfjIaeVNvunz33vlXGdezRCnrdVRqXb+nx/iwaN3YX9cgmfwDwLh5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8820
X-Rspam-User: 
X-Stat-Signature: s8ybd7emd5gg6rqb738ppk55sknf4enf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E5F5C0008
X-HE-Tag: 1787593096-632918
X-HE-Meta: U2FsdGVkX18M/9JPgBGOO8H0v1+jf9gE5NEKJQbGWiBGVH0MYTtupGoG3aihcn7Q/MN72VLO6Zo8o1RVj8qvS0Rv6YGlU/xQvZEf56yURykZrdhQsl8xndLbjd90PFtrCtO1P3GkBBTplfAodE3a1+6kmtFAJ+VB+rKbZkCVNNHE886cFZPnua+m8ncONvmO0FzxHr76aH2os1owkb1AHh3o5i/CYM8en5yXlmlQngoLsIVvAhJU2H66mDoBxCZBSBMN2BcfDveeKQY1zyodNnhhKXpTk1vzZkq820n579/A0qNZrTnhnHpYOshhfeDhWKO3g2pzA1pwrT3TdRG7mYjacYzemnjByxl4/5HdMEKJsv3UtEC7Oeqcj07k2/SsIt2YrOEvvhEtOsHqvprhuP+e+4zMNUkJdWwLigEE2+3wv62MIlj8MZGZA9wzrwyspBvHBlawBmfdhZWRQSu1x6qcX2YcBCLwiaieg1B67y/bRn393vrQDj14nr1RvWtAd10lbwrOlQOPxsNSRIsUbuRYuWR7O3cBosL1SNQfyOnHnz3znm+Pfmu8QEAPRdEfi7929X01037K1QRj+84coOct5h7hfbLHxFIB8XVl1PLqH40AR/w7aRoK4Bq4LXAVugzXyBzPCpKCEGEmgC0FhyWMA3filWwsZ1kZIUDl5b1q+dt2V0O422krE2tRfgecg1guBl1kURKYZCDRAg3pevNNBfGx1Sa2yLJLjIUj6xEtdmk16uJLY0RQO+VDY6SQmZtqhSpWj0ZNGZ0E7pc2BKc70zk0sUiyCM7VKYbhVDPOaOE+naE3YZqI4ND76mqX07RsBcx2jqGdZz3znjQdZU7ioFDmzkylMbR3OGAKhrnCl9InX8v+t9f0wDGS5CdtLd9bdHckK3dNlUvPnZxsPFD/1BApRrkyCfmbq+NEhF2ejtpmRkcep0/lJCcst+1fW7wXhjW+ZG9JVnZOitE
 B6zT5gdd
 Ye5Pv90Zz7a8w5CVuCl9o3qoDcACeyLKdR3/rUyOaMsX6QgdG4oir2EL0X+EWOaYG9M+GMOJ/yoLAEKZbraCWUYG/ILN1bWKLnhA3rNTPTC9invXHWjTJcoBtJ0184mPYMO2n4QnUn64ewxhBvbxSmB5XLLRJp1ok/bG+FvPCj1mV/ZBvT5ZK6Zx7Pps92LK99/nRTRDPYX59mMqm3khQ+2eEwGmLG0S5++PTme+ZB2sjasARCd59scPYsfce4QVU0mE5pPu7AsZXpKtbbY7xTKSQzynYVufdvEs5vEDb3n4vR5r794rdzTX2cq9rZJpa7UkNfl4qsDS90pwW15PG49ZHB6eqYzIJtQGvJ4TJESjBUVcStHE/p6ZhsMPD0M/xALt6QsI6cMsVWGYT+ipyL+S2ufZIUVxjKTHoDjSkX42Vsz/nhxET24H8CTR3W/MSjuZkgU4mhAsXDykae7W+WTPF7amoLUnL5EWZgCSDNBOlVLvqg2QLJPI5P3UcHZOeI3zI9HtY0CrMO93dyQz81t4x46SpxKuBFIsdWNqjkaI8s6fDTFr6dwbuFw8tS4/Ex20Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24.08.26 18:30, Luigi Rizzo wrote:
> On Mon, Aug 24, 2026 at 6:06 PM Robin Murphy <robin.murphy@arm.com> wrote:
>>
>> On 2026-08-24 4:29 pm, Luigi Rizzo wrote:
>>> Introduce swiotlb_alloc_pages() and swiotlb_free_pages() to allocate
>>> and release compound pages directly from the default SWIOTLB pool.
>>
>> Huh? The sole intended purpose of SWIOTLB is for bounce-buffering data
>> which already exists in some other memory that is unsuitable for DMA for
>> whatever reason. If you want to allocate directly from some kind of
>> pre-shared DMA page pool to avoid bounce-buffering, set up some kind of
>> pre-shared DMA page pool and allocate from that in a manner which can
>> avoid bouncing entirely (see DMA_ATTR_CC_SHARED). The idea of getting as
>> far as calling swiotlb_bounce() to then have a special case saying "haha
>> not really" seems entirely absurd. Don't hack stuff into the SWIOTLB
>> code which has no business being there.
> 
> Ah I see DMA_ATTR_CC_SHARED did not exist when I implemented the
> swiotlb allocator. Cool, one less piece, it should be possible to replace
> this chunk witth the DMA_ATTR_CC_SHARED.
> 
I agree with Robin's point (if I understood it correctly):
Why should it at all pass through the SWIOTLB? Why can't it be a standalone
DMA pool?

> The other pieces are still relevant though ?
> 
> - use these dma-able pages for page pool allocations (small)
> - [PATCH v2 3/5] net/swiotlb: Track bounce device per socket
>   or one would have to unconditionally allocate from that pool,
>   even for e.g. local sockets
> - divert socket allocations for eligible sockets to a DMA-able pool
> 

Thanks,
Dragos

