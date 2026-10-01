Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D1C9CA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D41746B0088; Thu,  1 Oct 2026 07:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19276B008A; Thu,  1 Oct 2026 07:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E4E6B008C; Thu,  1 Oct 2026 07:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99C466B0088
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:18:22 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 269441203C8
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:18:22 +0000 (UTC)
X-FDA: 85273808844.13.2172E50
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012013.outbound.protection.outlook.com [40.93.195.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3C558120005
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:18:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XQRscA+o;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790853499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLexoLRVfDQa+64aoDbaSAoPyQyGTI/u9Y7kIeL2owk=;
	b=gb/VmOcHK6EiKCR1IKtvnxaejlD573l0XBBMO25LVw7fOxH5nl3IAFywVIqomp3NUv7iMK
	QrJEZwWpNMVz4wxswr4NppbYeyc+A0CKgRul278zrWFLdvwVZhL9QvTt8G8AX8wEZOIcs4
	2SZ+05rhFYusYpRxiwJd3YH0qeEbw60=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XQRscA+o;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790853499;
	b=te9T1Shm2EItKb3v2zoNzToQTHVzWNLAHoFRNEjYfQrMF0sv2vbinjP5qTl1ZbqsVPsnQD
	Up8Mze+5HksxZ36GA/y5BUz1T+FJVQWKS4+F7uSTtzRWv9A+mrAJEP4NxOKKctza2vEBD5
	g+mlABR/KM/rN33IUoRVZiVYElxWlH0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tt/7KttJcmXrb1CYiG725dhJ1i4ZWGUvGDe2HBVexmcSZUHDOSn2EIcMCm17gOZL+qN4Fcxb0+uorVfB9udq4DS4NhLLxmY//BR9SQ5hn0X0/qGM9eDFfwb/uSc+z0ImCqT4yY1pEr/sJzMKXbwzNl2Onmr2ksRYsErJ4uaztScJddHruGHMZJOhYvL+zogVdqiYIS9UowGI7n6sHnEvrRXrIGGOngx/udPGo2pvq32LVRz6LsVSsU6mWYWYFzlb1r8KdT45ucdl1FZdQNcRaiUZWdNeJqj+3siCLYqT0jOJfL6LbCo5zI/NLhLqoxxy4E9dnuIxn7MtbGEovqOFQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OLexoLRVfDQa+64aoDbaSAoPyQyGTI/u9Y7kIeL2owk=;
 b=PkGf9seseu9k53SE+Po52+zDA4HzNjuUfR8mF+ljSG3EJdaF6mJTzTr1NjlFmBNdhomifgDDzSixDQvidL19jZmS2INLiTd+9Yw8f22IX9DtqwyCpTJkXjvKDMbYXw3St+ZcE100HuBwfg9NiVCgtjiMM+SZbkeIIw0sb3aKUWkvGioQztw9bY5mF76wcbUTyLHTxpdzI/8GZgUz1GrEbHQOWdEDP3iSq5IRt4KLsEdS/K23p2/xAWLn4/qnkLxIzm8VuGtQqJNM2UHOZqe6gMIMhlGGarPy+pnryKfef9kiI0kKGUb62e8v5a+HR31j7/gXkM0Rcp2/fNnH6I+kCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OLexoLRVfDQa+64aoDbaSAoPyQyGTI/u9Y7kIeL2owk=;
 b=XQRscA+oQo+okrILTcLCYg0PvvjJab4AKW9+VxpJUOnkn+s5fwpPGwM4fQ1Uu3MMiX6IZ4bkhdhnXyZ3tpsDZpD4Fd3+zGMVSkGWVS+W4H/EDhcgGZLEmrGF2vr5a9EA08Vg2Uk7hbvYsc8b73cig23AzTnAC2j26wYtxl0PPXYBtdlRjE6KnaN2dTTm5I6auS67H5GqBNmaVx+a3fxqdEmoqPWkrRN/ppdSDJpAi044QhaQ2CDOFaCzuThGYpi2Y3xk/QzJADa3sX86tlF8d2S8lcq/WLn/3niPOVLOOgfm2r+8PLsfvlLtXaSa8ngvl2aCP6LEQU1cDhVqXZyX0g==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MN0PR12MB5811.namprd12.prod.outlook.com (2603:10b6:208:377::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.15; Thu, 1 Oct
 2026 11:18:13 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 1 Oct 2026
 11:18:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>, Li Zhe <lizhe.67@bytedance.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, mhocko@suse.com,
 corbet@lwn.net, skhan@linuxfoundation.org, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/numa_balancing: allow migrate on protnone reference
 with MPOL_WEIGHTED_INTERLEAVE policy
Date: Thu, 01 Oct 2026 07:18:11 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <4CDEE1DB-1847-42EB-9801-6B3968590C33@nvidia.com>
In-Reply-To: <280965b2-c6eb-4f01-a0ac-c4fb7e518f97@kernel.org>
References: <20260930121154.687586-1-joshua.hahnjy@gmail.com>
 <2e3f12b7-0dac-428c-b70b-07e1f63de028@bytedance.com>
 <ar0fURbLDPrphYMY@gourry-fedora-PF4VCD3F>
 <A005B05D-A85C-4153-A65D-0BDF9D8500DF@nvidia.com>
 <280965b2-c6eb-4f01-a0ac-c4fb7e518f97@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-MS-Reactions: disallow
X-ClientProxiedBy: MN2PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:208:234::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MN0PR12MB5811:EE_
X-MS-Office365-Filtering-Correlation-Id: 43c8a7f9-689c-40b5-68bd-08df1fadae75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|10067099003|56012099006|4143699003|3023799007|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	vUARe23zlZxkKWgIrh7d8cr5ce/eEHj1hm2i2KVD1wkZcdodSaqkBbaiDlk1I0Gmev5YmBXLZ/gyrs0JSn2aAFbQfwHVJijUYCelII3nk3SZ6rtH0qWhRb01/yYV73IeTydTq4+GP5hGjePN2pfWv70oSQ+n+0QNcvPSS/NIKrDMobK/uHEflAGOqM+SiYfqMujlmlT2P7UFYLKbTw7aIrgUaZmz80NDusDV/RLCKNbickjPQdjXAIi7I0TAHENRdZKIefHJ46Sgp2uvlD15mi/POrdK1c3igGVZ6g82dnftuVg1OziSIfuodFWJ6VbG5BBEVgcu4QlNXo1FbZYM63IBclCnF6L8rgW5zfYBU3ZiKSEN5iFUW2pz2Scavzbqw4br4BgKKQnczmiBe8ewtopIzrN9rTcUr7jIYw31jaoWxNJ0SAqxnb6cYogmYyJLcz0+oHlRdaynXHNEh0lpddZKSUw+L6GhspZ1Td3SlWf+cSckkqJqhMwmsBVKwf7M7GPxBMiQaYtiroOfyKP2oA98IzZbtuBYyOGThpvF2zeEQUniyb7BNVnjWVtvWjlN3F97uUa7+eFADg79T7RHByMPyu75zwn8bPtv30LX9Pc1BhuLXFf2Oin+s+0AaO1AdZ0T975xZYpl+eXZBzjUVN8iEan5JlVsd8TnjNV9Jls=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(10067099003)(56012099006)(4143699003)(3023799007)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enN1TFBsS1N5SHpyc1gwbzhmT1Ywb2xIRjhSVVcwcFM0a1RqYURaWEJmemNm?=
 =?utf-8?B?cExsU0hxbXIxTXBhckFUNzloWjBrbjBscjA4YTEybytVU1VSOXUxSG82aEhT?=
 =?utf-8?B?bU1QNDNoN0o4S0c4VUZ0OEQvbDdOUmx0OWNBZFBaNDZNYndJOUhnTG13M1ov?=
 =?utf-8?B?NGxUM3oyUjFkMmpkWit1T2wxTWJXa3FuT0VuMmFMNWdjSHR5TDZHWmpDcEtj?=
 =?utf-8?B?ZnVLYmVQMm10NjlISFIvbzduTHFNUGZjRkRIaVYvMFU3Z2VFdElMazBIb3Ez?=
 =?utf-8?B?ZmJMeXpnSWI5bWI2U2pWQWQ2N2lYc201ZEVKaTVTVG44eWk2eHhzK0R2emcz?=
 =?utf-8?B?S0JpaEtOMjZ5aXlrYmZDMHlpbmQ4Zm45Uk0wa1VZMXZNdnE2SE0xRmNxZXNq?=
 =?utf-8?B?NThKLzVSNnJ2UjVHQjlqbDF5OVNkc1BHaWZvZG9VejhwQkh0dFRmQ1QxbXVz?=
 =?utf-8?B?YWJENC9tellsd1RBclBBOXB5SGhtY0lZd1BKSE1oNG9wMGJFWnZtMkFId3pl?=
 =?utf-8?B?NHpySUNKUEpBZFFuR3R2azEzUEEwMm5PMCtlbkt6ZU1sUXEyRDNvSEdpdzIz?=
 =?utf-8?B?d05hOGc4Yng1M2xWR0gzM0ZTWGI4dVJ5Rm9qeVRDam9FTjMzTy9GOUJPVlVB?=
 =?utf-8?B?TmhYTjlicitDR0NnR1lEUUIzd0tnY1lpK3RDWFB3R1kwd3k3NzVnTEIyN3dn?=
 =?utf-8?B?cWRqSldNOEVDaUxkVVpKSDlCK1N6OERBcDhVazdFNlJCRkRIRTBHVXcwWHBZ?=
 =?utf-8?B?K3Z1UXlKcDQ0NTUzQ0g2L2J1aDQ4UEdXMmxXRkdLamRTUnQydG5DN0JadUVC?=
 =?utf-8?B?TkJud2FpRm5nNHVYMDJDZllsK0IweG9zSndQY0RCUnlrR01FcVpJdWw0Y2dE?=
 =?utf-8?B?cmRpbHRMbE5RYlA2OXp4MmZ3RnFwNDBWUHJmdENCRVh2aXBvRGxjcm5jZnov?=
 =?utf-8?B?ZTkzV0VUT0pkdW8yRWs2ZjBzTzlOWUwzNHFOSlVuMWNTaUI1MTFrWkE1d25j?=
 =?utf-8?B?Y0cvTFFnMGpxNUpMc3VJV1owb0xrZlF6aVFFSXhtN2hhZGgzMnN3akhPNnpW?=
 =?utf-8?B?azJJa3pQVGJOVHpVQlNyNHd3RzhOQXR1YWNBSFJzYk52VDc2KzVIdFdBWkJS?=
 =?utf-8?B?OWtCSHZ5L1NlaHJnbVFxZmUzRGJ2aTZvRkdnRnRyR0pXTHZybWtVTlVRL0ZL?=
 =?utf-8?B?R2JHbkRsNmQ3TUZKb3hvRVFSZzhUaXZoZFBJUFBNWmZWUGNKeUw3bExhOWh6?=
 =?utf-8?B?bEJDbHk3SjRvMldRZUVLVVBuNUgwWnpDbDRKWi9GZDYyZ2R3Yk04S0RMWDVQ?=
 =?utf-8?B?VHVKS1lpNkhIZDRFekdjcFgyaUlCUkVkR1lqcmtMMnpWUmlHU0hmaUZiSGxD?=
 =?utf-8?B?RW1XNGRHOVAyR3hyU3JkNHlrakdtUERmbE44bENQTUhNdGhyUjFyVDFyT0kx?=
 =?utf-8?B?RXFlSWZwdDVRQ3lBSjVyZGljck1QdE9raFIrUXN3UkVrUWx1dWJTNzg5SHZp?=
 =?utf-8?B?QVZoTmM2M01BYTlqcnlIMWwyc2tnRTBPYjZJRjZ4RVZHZFlDcXZkLzJpN2xG?=
 =?utf-8?B?SlgrSitGUk9BQXhWbnV5RnhSam01dit6M1hJUDJHYU9PNjdxTzFlaUlGUlBx?=
 =?utf-8?B?YmZURWhGMjVCUGMyZWRzcVJKTHpja2NxQ2YrOG8xc2Z5VGM2TlhQc29YS1lY?=
 =?utf-8?B?cWJrRGhCOWhjbGc0Q081b1BjcFVkQWhmenhvbE1QYk5jaUxtWDI1YWdvcis1?=
 =?utf-8?B?NmdDak9wMzlVc21hL0ZuY0c3NVFmZmdwbnJ6R1prSDVUVjFyZ1JOekJBc2ND?=
 =?utf-8?B?cSsxL2lJQmlGZVlGekxBcTVCbUUrYkluL000YVlYNTV6SnNwZlV0NytVeGVa?=
 =?utf-8?B?UHNDajlEUVBEKzNieUZicThRcFI3QnFCd2psWGdxWkRCNnpqeENCU3VqTGsx?=
 =?utf-8?B?dHpZNm9HMlhpMlRtUGRtS1drWnROZjg2WksvclczTkhvN1p0Q1htWkk3cktz?=
 =?utf-8?B?anJKL3FHUThUODlMUW5WZDBEUXpYVU0vSGo4QldDU08vSXFMeVNBYzJLT3dk?=
 =?utf-8?B?Tk03dmpBdWJxNmlmeWUycGFzaFNEZXo4c2tHMzA1U2ZpT2Fsb1E3UEFJZEhs?=
 =?utf-8?B?ZjhFVW9Qd2J6U2hrVFk0Sjk4a201eEw4QkN5NUtZYVNWMWlBMDB6Ry82emV3?=
 =?utf-8?B?Vk90NzRjTjRKNHArWitwWmpxcjhjQ2NpNVg5U0dob2t1VTZJMjZJODVhdGVZ?=
 =?utf-8?B?bHlEZ3dtK3l3dDU5TEFya2lWazN5VEl0SkRmZTV2VkQvek5nWnNZd2pwQjNN?=
 =?utf-8?Q?1C4oqmiuLw3IAZxOMy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43c8a7f9-689c-40b5-68bd-08df1fadae75
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 11:18:12.9767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nD5YnVJi4a8orRs7Bduy5lNr6RNCfULi5L7KLlGTLGHNj980gAu0HIehAyNZ8Da5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5811
X-Rspam-User: 
X-Stat-Signature: x89mgmcmirapjkeyrbd4zwy788pn7t6k
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C558120005
X-HE-Tag: 1790853499-152161
X-HE-Meta: U2FsdGVkX1/n+thDpMRGRFEa0nPefWgLounSf4XpNk43ahlM4ic6ItwEddxFhHjRMj6XeASV6hrni0Mkqa+TT5Fg+5j2deVD9gT12AsPjBjxNGcHalkYdU8b1WJvZyli1dxIySQeRjMoznvrmBl5adI0uuYnpkkr0Q/HuQOIWc5wU2iMyXwoJdTgjENxnf8E7c0jkqX4CP6M1Ov0L79UIOknuS71qBgLOrdQBgsVYaetObFUG5LqKWXVmKfCLBJ40kTK9h4EoKFYzE02GDeIdVb16uvgCSNpzxRDKLhZVsux6ek4s8LfYl3R0C6tHuK6J77d8Su7vOcq//IxdhnFTxG0J2ZkSBtJoaxptvOj55tC8clti9BRBQgzDuK63S1t+WtO2+v1ORY6widcwekcTYETC+zyCSLobkRxNm5Pk6kiiTax+ap+E3ASVNZg7VC4r+8Um0TPmo0cLKoJ7l2THR+fusWbM6W54aBgbW+yx4bA4zeS2R0YNYyrojHUoT7JfXQt0X3/d5WNqGnCwJ2s3L/XWEIRX1bP5o+qhNZywMLJaHfsHap4+b2nPCNSltbNgugQeb9MWgWLDDafqtfs2uHDfVTtick0h30vFdqecqzuMmD1RN/t5kkZfCl7LR7ecLhU2VZfJY+VJSTKgElHGsTIT0fnzlJxCPCF2ZM7u44yDIDdlAiKJSd8WkTOydCs1CjINAdXnF8SSNeRaXdgPmTrm4t8rubjHNbo9ald5UwdQK5KyG3XZbS35SlUCDApFdRIhc7x8lxtUE7BJegLApNcm7ANjhEeNWTu1dWzpcCEZJYdjgfqGqdxCmPTRHZiXCVsb4JycyRD3Y0ytlvgJ+albM332a5c8NF2IaAPWuPvQuXv406mbjZttCSmDe0squChR7twdKsDzmbVIK9e4VR+8Z/LfJZl0WdDmFFH8KFRAvUd5Voy75rfhpKeUbULF2tZitxESRvUyT3ROHF
 zbF6SzNw
 MgdKJugRRfiY/x6EyWqGKuC/qOggamnhaxq0zJXQNoSBeCmm1GR3uxk4aiE+7um2oh0GY/YWI+TCqxQW09F03JBxtsxMmiZXmGLDipNJUOfolm2Nwy1NYiXP1c6eO3/FZmj22Qep0pdtwP/9b/sLjTMyU5/rbyblGzX9xtzvx70Ah1MTrF+ZiTaaohNPKrijaX9OwkqzGDdnMEYz87tQ+RaayZXCrIl0AR0y1GraDC2zJdo4TNteagl5au7kAopjrZRhy4GXCiTYUaZEbrDgGN1EjYMOmyD7qmVAOyg/nBykkPywNvjk7tBeEpazLzdf764ierpwOw4nISOOJsfUFj0/iCdpgHluABBDriOKqFk6y/g1UGvqdsVlTqqpZnzVsYnyre94w71p6Wmw+bmYD1+xaIEBR2r2Hx05YZqQ1nxceX64fg+fhYkun7t8WMRk3S8OruMoqaG8lFWxD+ueo1g9d7BVJrEACKfVI1bepgTaYvwfs+6hfCM/KUFNKhWJMrVVmEbxAmL3+RkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Oct 2026, at 6:54, David Hildenbrand (Arm) wrote:

> On 9/30/26 17:10, Zi Yan wrote:
>> On 30 Sep 2026, at 10:50, Gregory Price wrote:
>>
>>> On Wed, Sep 30, 2026 at 10:02:23PM +0800, Li Zhe wrote:
>>>> The use case is closer to the second one, but the main motivation is not
>>>> only startup-time performance.  The more important point is that each
>>>> workload has its own DDR/CXL budget assigned by the workload manager.
>>>>
>>>
>>> mempolicy is the wrong interface to do budget policy, you'd be better
>>> off looking at Joshua's memcg tiered node solutions for that.
>>>
>>>> MPOL_WEIGHTED_INTERLEAVE is useful because it lets new allocations
>>>> follow that per-workload budget from the beginning, instead of placing
>>>> everything on one tier first and correcting the placement later. This is
>>>> important for workload orchestration because the workload starts from a
>>>> placement close to its assigned DDR/CXL ratio.
>>>>
>>>
>>> This however is reasonable to me - you'd prefer to spread out the cost
>>> of initial faulting placement explicitly, rather than simply take
>>> fallbacks when the top-tier budget becomes pressured.
>>>
>>> i.e. w/o interleave:
>>>
>>> [node 0       ]
>>> ^^^^^^^^^^^^^^ alloc until full
>>>                 vvvvvvvvv fallback
>>>                 [node 1          ]
>>>
>>> in this scenario you end up with considerable hot memory
>>> on the remote node consolidated in time-space (everything
>>> allocated after node0 becomes full skews heavily toward
>>> node1)
>>>
>>> Tiering then likely takes many faults to rebalance after
>>> you've already reached node0 limits.
>>>
>>> w/ interleave
>>>
>>> [node 0                                      ]
>>>  ^^^vv^^^vv^^^vv^^^vv^^^vv^^^vv....
>>> [node 1                                      ]
>>>
>>> In this scenario you do an initial fill distributed by weight
>>> and then let tiering figure it out without consolidating all
>>> of the pressure to the point where node0 has no space left.
>>>
>>> That said - this seems like mostly an initial-fill problem, after
>>> you initially fill your memory, a new allocation largely implies
>>> the memory is hot - and you probably prefer that to be local.
>>
>> If this is a initial-fill problem, can userspace set weighted interleave
>> initially? The program or harness can observe memory usage of the program
>> or related NUMA nodes and switch the policy to numa balancing via
>> set_mempolicy() or mbind() without MPOL_MF_MOVE after certain threshold
>> is met?
>
> You mean: use the weighted policy initially and then switch to a NUMA-balancing
> one which doesn't involve the weights anymore?
>
> That makes more sense to me. Although I struggle to see why an effectively
> "let's put random memory on slow and others at hot" is a good starting point to
> later let if be fixed up by actual balancing/tiering.

Statistically speaking, unless the hot/cold page distribution follows a power-law
distribution, random placement usually provides an average placement result.
So it is not a bad start point.

>
> It all sounds a bit hackish. :)


Best Regards,
Yan, Zi

