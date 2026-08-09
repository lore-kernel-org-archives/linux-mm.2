Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C3D8C5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 02:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9AC76B00F8; Sat,  8 Aug 2026 22:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BD26B00F9; Sat,  8 Aug 2026 22:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14266B00FA; Sat,  8 Aug 2026 22:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E91A6B00F8
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 22:35:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C16081A049A
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:35:45 +0000 (UTC)
X-FDA: 85080165450.20.22F7B27
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012028.outbound.protection.outlook.com [40.107.209.28])
	by imf18.hostedemail.com (Postfix) with ESMTP id E65681C0002
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:35:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=juv8+Usb;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786242943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xku3wnnDPeryho4gUSoAG4TClA2WqK2Aj9RKimQEt9g=;
	b=4CyDgdog9kNnvLnqOgmb73QRii6GbPXXreuEGdy+k5s7QD0UKJTKKJ+WWdRZDya+VOxuNf
	5I+ipJ+JP/EE1pGmqgziYoO0NRSU3QWURqD8BG1u107JukK7AgCCWhyP7b7x9qvqxTIV7N
	R4zBONuFn9g/cMdZo+3oGqZBvdfuG3k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786242943;
	b=HDjayDVAzotlKTYMTXIb0dRRUQGgKqE11rjA6IE4MXjHuR7jMB8FMVjVqR9hzZHMYxLcB0
	EahNV+Ap8GqJRY+Vvvc6OJdv3m3RPBRuPS5bhFZqNjAlrRZVfOKWfP68u6K1NFMkzmEs0i
	GX8EnxVPKIT++vl7zVF0YDF7oSNwYmQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=juv8+Usb;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.28 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ez4H/6zA7dUVX5K7NezTLiD3YCOVVlrg0UZEaH4upRrQNpAx9Gv0pMaZRgiF3GPbYB6tFKWLBeXpIdlJkIWasvsjgQE6jPY2fE+/1l24YqUQQouYszvAiDmMnlX7m1h8brLdFPTSNQXhDNGl5FSgVKxFbfgcuIY/k/jSZOjNOM3IoaNVpOXsIEJV/4IvlDDG8S2BCjwwVL+20VcCBkjocyULhKUd+4zsVZRenL4hCEIlAbopJ/+OlRZbEPClmla0QfDrKwMjbR6JiykiC1yQ2ATMMpA1uxyVWDBToiT4zbbDDZVo/3kRfxPxBwe7A5rz1T6zBZkI65ubmLVQoK9wJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xku3wnnDPeryho4gUSoAG4TClA2WqK2Aj9RKimQEt9g=;
 b=Sg+X0r6ncjqVmscg8D3hzTl+5HKXAaiPm1VguFcG0vDzpuKPVj77W+DaTJxf8UQl32+TH+jkeU1enK6UGT8KD483Avdnyh5s8DLRHj/GTMOLMoc4B2i230e0UUY9aIvEUp+wDyLgBzjrW1EnQGEk41TmQRgVdgJAp+Tv3c3S91ZgAvphjg7Rlm0XaPamWLaGYj2VhLTGHt97srlMdMK7ph1VhKkgnuY+6UTo1cp1/cJ5TdogzHC2B7xeHW8cCT24oTe/5CxkIdMRIS1hs+RcYf9xwTCU1ti5GkuHWkfuROHrtsFTu+9lLcOEk3+h4A1EhgpG56WyweBK18eK1phtLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xku3wnnDPeryho4gUSoAG4TClA2WqK2Aj9RKimQEt9g=;
 b=juv8+UsbwkPFPfzcdo1s6Ca3RsLHEo6yv8miuJNIAtKFi27fpmCbvCI7hVIvRKzda/DV1ZyTWQ+0mtj1CPvsSTBJ3IV60QtBedkeOh2S3gPTPlKXeR/9uWPdhWDBIazoCvecLVUzRFyTtTIeYzxlS/0jyA/utkE7NPR0gqs5dSsciZFd4X+lBpyn7DTY5jE1SA96/HuPqpl6txUWF/iL8dkJdIHtR6PFw7M2peTibfC1SbHCDJxplNQbsMRuhSnwPJrXXRNSh3SXUUkIV3iwGmmFkbjQD3g30+BJRNYaM+IwKDebKL0sswVi2umVcYoDjWGEOedcXeItDyCbbZhVvA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA5PPFB2BF91BC0.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8de) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Sun, 9 Aug
 2026 02:35:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.024; Sun, 9 Aug 2026
 02:35:38 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sat, 08 Aug 2026 22:35:37 -0400
Message-Id: <DKK29WZF14ZU.2RUEE7789XAEH@nvidia.com>
Subject: Re: [PATCH RFC 10/13] mm/huge_memory: allow splitting mappingless
 swap cache folios
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
X-Mailer: aerc 0.21.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-10-689939a7ccc3@tencent.com>
In-Reply-To: <20260808-swap-thp-cleanup-v1-10-689939a7ccc3@tencent.com>
X-ClientProxiedBy: MN0PR02CA0001.namprd02.prod.outlook.com
 (2603:10b6:208:530::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA5PPFB2BF91BC0:EE_
X-MS-Office365-Filtering-Correlation-Id: 439dc591-84c0-46e8-2369-08def5bee5ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|6133799003|10067099003|4143699003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	5DTEnrcrR42kIF7Tm2hMC1EwfFU0uXTbezQlxh8whPF4B1F61GbTJP9FmlHFHRRa8oOxIwEDj7IwUHCTPHF6EAP74zviKgdfWcHPnjopx//3ubf0gvZ51j67LVVDWdU41s8KgfzLHHyuy9wAr8BOd+9muES9JKC7IOb1AtOMi3ep3u4O2xhGvUH9C20X0vh4tzIQLe8Xe/CRLrWKuyzl+5NWzIr050XO6EqF/h12byHNqNbXUKsZbi+ZMXM0i8OEoZXlBuyC+5+qEoPrlMK0KvcVneXvhZMjV/1QKbBLtykuGFrn5lpsDHxf9RuOjXWPFKdOicBI8Nle5ny4TO7sA1aT6e/1McXCbizFxhCfvryriPK6aGpxIQue4erp48ry4BjMykN87aaewqYCbKlIfS1XZsvxmW1GEYYWLEJUDf9D1/ndvffZRu9g3h8mcTE8xLnUk946AeQVxZ2fvKJIJQfGilmmCScJWUN/6fwqN0dcW3eQA11kDh1+N8cJlm39a0d3ary5g2g4y2+8VMdoQXKYG43m0NNSqhggrz/rSNJY39P3gKGLqXHKgtPZ1X2T7irp+j208VtYi4018ITrzono14iiOt/1TynjrzhVYrcXqlGTvG+YV9E+Nf/ZVDEA9c3xE4tc/IDuPwjR/I55plT6eGeIfLRX3jjAjjEHZ00=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(6133799003)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Y3g0K0YvTCsyYTdJcXM1a2sxU0VxaUNSMDBkd013dWk0elhVaUJ5dXd4ZmJq?=
 =?utf-8?B?NmJnRzZyNmp5d08yRUlaV0UwSTVLMjJkVGdhcVg1cHhIM2Fzc1lmNHgrUmM2?=
 =?utf-8?B?cE5JcVYyUmMvbnByVkxmY2tiSzltYU1BWXVXdzltWElVMVMyWURsUFZRSDlr?=
 =?utf-8?B?MmVwazNrWndwUWNHSG5wZHNsRlJkS05nekNqV1RRWDNuMmpUdmM2eHFaYUdT?=
 =?utf-8?B?M2Rsdi95VnR0REdlQ1V1MHU3bUxzcm9sN25BaWtrWi9kQ1MrWC91NVRuWlE2?=
 =?utf-8?B?SlJlK3EzSVdIVFpobU9Jam5aTnVWdUI5bUlaeUNTTGt0dENGVmR2M1NyRXFV?=
 =?utf-8?B?MmZVemVvbFRTbm9RbitKQkJ5Z2xSSEJmVllTemZMYW50OW1zYUZRVmtUMDI2?=
 =?utf-8?B?S0V6UXZLYlRrNWtuZ28wYkVVa2RSMHdBZXlreDVoRmV2QVc0Q0VlbEczb0p6?=
 =?utf-8?B?ZXRnWU5rM1UzeWdHUU9PS0pvL1M0VDQ4RmE1Q09ZVUVmMmNuRzlaU3FSVFpo?=
 =?utf-8?B?dkVHdy9Qa2JJMys1VDMzTFdHQzhVMG9IdVg0VmZZeWFhSXpqSzFtYUIyYmp2?=
 =?utf-8?B?UDVDZHhSZGlaSnZQdHU1Zjl5TnJ0ODVjdy90ZDMwKzg1L1Y1b21LdlBtdFV6?=
 =?utf-8?B?dVh3SDlUZUYxdFU5Ni94Y1Q0TmowUVlrUGtraG53N3BSMlZGT2I0SzRVUUtI?=
 =?utf-8?B?a1NtbTNOTExJYWROMDFtTmxVcXVIOWF1TlNVZVR2TFNyUlp0S0tpdTNpb2t4?=
 =?utf-8?B?a1M2aGx0WmpQWlpyc0pBdmZRMHhzSHp6K2lBUTd0RTRRa3NCVXNIQlhwb1p5?=
 =?utf-8?B?TS9XeGw3QjBVNjNOaXQyaEk1LzVYcEdqMmZIUUl2TDBsN0RkRDI0WURWOHlW?=
 =?utf-8?B?TEl0ZWV6RkxYMG1KREhURnZNWHQzM2FUU21DQTNwTWttMFNIWTd0ODNXbVMr?=
 =?utf-8?B?WFAxeUc2L3Uva3dqZEJzelFlSHEyWC8wQkVVR0RQczNkeHhHSHpwdE9VWXZ3?=
 =?utf-8?B?UmJMLzMzdXlNK2tEZVNZWU9HMXh4Q3h3M0dKblZoeDk5SHp4eFBRc09FR1lC?=
 =?utf-8?B?SWZoMjBOeVdqSzI5V2NhQkRCcTRJNVpoOU5Qc2JTY3J6OXdiQWhvem9za3Z5?=
 =?utf-8?B?NFN5WU9VZys5aHFxU2VhSmFBS2pVMlJoR1lBdVQyTkRrcGUwVWJOVnpHNld0?=
 =?utf-8?B?Um1DdFptU3JRdUp5UVY5b0NybVBZK2tZOC9lbDNnbGlvSU9ZNzlXcGdONWhh?=
 =?utf-8?B?aWVkRHdnRVNkZ2hDWEFoS0hqMCtLK0RwUGZhaEhKeGZlS0RwNFNvNWUxY3Vs?=
 =?utf-8?B?SXRuNlp4UlQ4cnhibnNhTWNsbDFxUi9OS1NZamZrcS9ZQUtqS3BzTWNiYlh3?=
 =?utf-8?B?VUFYUUtmN1dleFpVYkdycTV5dU8vM0Z1ZWdCNHd0VG9tSzA0NGs1Y3FidEhl?=
 =?utf-8?B?UFQ3NUZKZ0pFbjNuUHJVK2hDZWhCZmdGQ2YxYlN4RTB2ckhmVVVJKzgrU0I4?=
 =?utf-8?B?VmZIL1RtSFVILzhvdnYwcUtSdkdOTmYvd2RjNGtnRHppWENXWVlGTW50QTcw?=
 =?utf-8?B?dEpOQmZnZkJqcEE2VXR4OUZyTmphMURFNDFzeUt4MXRmUU9pU0FQMGw5blEz?=
 =?utf-8?B?N0xoWkdDWGNTRFhWYkRYNFFWTnc1MVZ0YzZhWSt0TWFZWVpxdkNrYTMrMUM2?=
 =?utf-8?B?T2pOT1NtQ3JBK056OUt2Zzd2ZzhEeERFYzAvQTl3NlhNdE1PMnIzNmllWEIx?=
 =?utf-8?B?QndqbGQ2Q0NySVJXVFVhRDBEN21DanYyelB5Z2hTUEVYalJycmhRMEtzKzM3?=
 =?utf-8?B?emxCb0dqeWVUTEJPR2g1Y3NJNm5qaC94bTdKV2JxdURiTzFaTFpGRTFqemhB?=
 =?utf-8?B?M2ZQT1NPdTJ4Z1RGSzErREl0RDVoOVc4UTdLTzNzcGU2RWtrRkN3cDc5YXZ0?=
 =?utf-8?B?ck82RkNsVDRuNk5pWkVzRGJ6Szl5c2NuMklzenpjZXVselMwR2w4UDdPbmJT?=
 =?utf-8?B?NktCWFo2ZFJSWndPUisrL3NwNVhTb2p1Wkx2alZ6d0ZETkdHb3J5Wm1FcWpl?=
 =?utf-8?B?YUVXWm9KYkdpdDRKdExRV3krNXNLeW1rUGk2cjU4VU43Z1g3a3hQTlgxZktY?=
 =?utf-8?B?cW1LTnFvS283d0FLUjc0bUJSaURrN1BxN1dkWWYvenNFWkNmdFN2WEJoNEhk?=
 =?utf-8?B?SGMvdFBXS1V0TGVrNVZmWExrZy9BREV5VnY2czB4T1ExTXNvbFFGVWhZb3Bv?=
 =?utf-8?B?WXdMQjZLVjVxVnNZYnlTSWZ4OW83dFRGSWZmM1VoWVZPUFRzNVB1RUYvQ3dl?=
 =?utf-8?Q?pHGzcMdTpzkeNMzqY7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439dc591-84c0-46e8-2369-08def5bee5ce
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2026 02:35:38.2155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CNuxGdS/iXqiZBSq0ikg1rN8cg1f7cyHz6ycvfOUkELejqBwmI3MixUkbDIATVZa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFB2BF91BC0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E65681C0002
X-Stat-Signature: p1a5pt89ha1pjc9en9t5c4qsunuydmue
X-Rspam-User: 
X-HE-Tag: 1786242942-740587
X-HE-Meta: U2FsdGVkX19E5zZTMzSOt56oSR1m6z1Pz1Itru75BjiwcQd5nvM19Et8shAs176kmKZZ7BvevmTAZT8XEkobK14KKPKbQuqHpTBEzkYz4pOmkMer9TRveiywdFoJdZYCkG6aQ3XTozV4aczNP9HZSPkGOYB97BYUpbOpVKSXQAdFKp5Zh34NezucoVFRapkGlvQB4sLyYlPXXou64yG0T2tjaXBAP6LD3aebiMwxUh2yJmzjLZqHYXl4WRU7e6ROSndPQMPYLVySWU7q3h0Vu1If5mNNQiVa9ue61QJgTAg1u6Vx23vAAos5udibn5ivxZx9ECN+meYuKtrglxrUjHWjB9ajd72cfgac7Pl8U6NPNHz9gdc/RssbV74qNKIL/LxnqXBpNOOLA2oI4FaMZDRcC6fFe8cKftJbzF6ymLeXlV24PT8Fs/Tj3mrjo9SZk41XE7peGe6jDKScj2iWEYh0wyA8mNf6+rOVxVhFsJIpuim7PgtqZE8PdosHaNOAvOU8UxSmUNjHxaRCve+XzsJ6H42slLpApoiU8Y+MMCGVg8ekm2RXsx5Iwjx2ZAH3NiEdqN1GCB0PxYOq2vlnDoeFLCmA8wZc93mV/MJt4tO13vfn1JAfgwWjqEyzyeD/aqjKE292TXdnigAVQ32uSEM7U+o2wo5wZWum8dBPoxRS4ChTlZJV9J91oec2T2Lzgs3D9YCuy+XkiavSWLiEDBDW0DcUFdR2La7OdxkrPJ4x3mgJjzlqH7E/VJRaK+cv0LoG//gtlPDOOk138WGZrB8xHEJXLpWxKNPwmW/eyIBGBVAy84lgckGJaeVfhIeIF9E1ANHFteXs+fvwIF9tx2Mu2+kBT+2SkgU9985jZb8+mO08jxN4AJwFAaB6QsegYpx5O+dJkGgxIFcCxGD8+8fko9EC/u4/RbXsXpeG8mWxgDE2+hahSa9yieuzyA1NDgf+bfwt0aNu9EOwYl4
 NfedotqE
 wg3OJBTFM40mPlny6DOA7S7nWDM5eDuM7fiBzVC6VF0nkKLM2/yHGCixAiU7P40L3WJnhPh7ncTB4qEbAOBwGAg7LYtt7CThJ4x+913kP1I3tkNCH25L9cav0VSGBGvagR2E6/XjZxMcc4koVXhm1ArT3a8wulVx5zeOqJ0hNQAu7rSN+ECB9Z9YCrqLn3LNtEXnWnHaAaV7LAsQovMG4YPoOqxZAFbtoexn5kz0JiSQK1dSer1BryHrB2f2pjaMcivERVf9b8bHXFZ5raSYaThOGq2/ishmBRu5lVekRyy6FKLYqwG1UDrj95/CtKaBZ///8KhM1SezZVromoWlEeB5Y+tgyzlhLfRA79ALr/M+9dNbymRtCvllUtVsyR352hZbOg5rkLPAo11k/MmCT3eqx225rM5dpfrY5CZQpx+FCKmDxnvmvJrpjU5N6x+ltGdJ8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
>
> Lift the restriction that kept swap cache folios without a mapping
> from being split.  All the underlying infrastructure is sound against
> that with a few more tweaks, no reason to block it anymore.
>
> Also rename the split helper, which now handles mappingless swap
> cache folios that are yet to be anon, or may actually belong to
> shmem.  In either case there is not much difference in how they would
> be split.
>
> A non-anon swap cache folio that still has a mapping (e.g. a shmem
> swap cache folio) remains rejected up front: it would need both its
> page cache and swap cache entries updated on split, which the split
> helpers do not do, and there would be little benefit in doing so.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/huge_memory.c | 40 +++++++++++++++++++++++-----------------
>  1 file changed, 23 insertions(+), 17 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ab2bb29748d3..b80d0db63225 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3881,12 +3881,10 @@ int folio_check_splittable(struct folio *folio, u=
nsigned int new_order,
>  	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>  	/*
>  	 * Folios that just got truncated cannot get split. Signal to the
> -	 * caller that there was a race.
> -	 *
> -	 * TODO: this will also currently refuse folios without a mapping in th=
e
> -	 * swapcache (shmem or to-be-anon folios).
> +	 * caller that there was a race. A mappingless swap cache folio
> +	 * has no page cache entries to update, so it is fine to split.
>  	 */
> -	if (!folio->mapping && !is_anon)
> +	if (!folio->mapping && !is_swapcache)
>  		return -EBUSY;
> =20
>  	/* order-1 is not supported for anonymous THP. */
> @@ -3931,11 +3929,12 @@ static unsigned int folio_cache_ref_count(const s=
truct folio *folio)
>  	return folio_nr_pages(folio);
>  }
> =20
> -static int __folio_freeze_split_unmap_anon(struct folio *folio, unsigned=
 int new_order,
> -					   struct page *split_at, bool do_lru, bool unmap,
> -					   struct list_head *list, enum split_type split_type)
> +static int __folio_freeze_split_unmap(struct folio *folio, unsigned int =
new_order,
> +				      struct page *split_at, bool do_lru, bool anon_unmap,
> +				      struct list_head *list, enum split_type split_type)

I have not figured out a good name for it, but it definitely needs a
function kdoc to explain what it does, since it is no longer a simple
anon only function. It is better to add the documentation for this one
and file one when they are introduced and modify anon one's comment
here.



--=20
Best Regards,
Yan, Zi


