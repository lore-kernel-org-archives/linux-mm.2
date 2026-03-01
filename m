Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EF50C624C8
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 23:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B0D6B0088; Sun,  1 Mar 2026 18:38:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FCBA6B0089; Sun,  1 Mar 2026 18:38:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D0B36B008A; Sun,  1 Mar 2026 18:38:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4336B0088
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 18:38:46 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E45A116088B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 23:38:45 +0000 (UTC)
X-FDA: 84499111410.08.F9C4C16
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010034.outbound.protection.outlook.com [52.101.56.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0FAED20004
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 23:38:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="VO4xK/F+";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.56.34 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772408322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXGU8D2g6poycTThIVXAeaBENw9W4dcUWvij/5gETeU=;
	b=UYnT+22GEG+QouXVzoG69um0tmirnuvk2Fi3MJA2GkRB60ek5n8FVlokY4aGuUf2Ume+XP
	HiOFrbPZ1qwrR/ZsNZrSEFBlLq7dbU1LhlMlKAoMKasFnPD158e01qPKfv20bc5tOhqoKd
	7r1wWwE7JaTt93AAIiYpGD9XRZCylUc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772408322; a=rsa-sha256;
	cv=pass;
	b=Y8/HbCP8IoFzaONx9bRHWmh5yt680PaDvsniUSP+Ml0a4cjue+OP8DhayQDC1SIGNgZRYT
	+B9Qa2OLqth8eeNcvgXK7NpgXhJa6clmr0CmGQVFjFr/DDnn6fbwBdAc2VFwf968qimHRr
	SnpLvE1PmXGsnO+ypoPLqy0NOijLQ4A=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="VO4xK/F+";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of jniethe@nvidia.com designates 52.101.56.34 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+10p451V7jDpXvxoCPQCDDfNnhVHsBH+kG0QCR80sGgpS8JF1gqPPSW3R7TvVEifYzS9WjbrCIpKwKnEQQ8a0kmv4VsdX97kBbHSlxFWn25JtBGlSJzNG0riyVw+u89sDzLWnGgiVdl4IEU02TKXceXJCLA+xv7pbTJT84UDEGWWleXT8ER1mhfdnQs20bUlnj7Nxi1U+JVcOMeHVEa5jbO372zV3YJVBX3uG+pkm12X+iDvxOo0khlfNRTjq2HSeEfIrcjcOjNRbu+HcdmIESRjDAg6R3F6RT/X1kOnhpZq1pFoC2t2di403835y3T54QivSdBkUeIB4dzxDR6ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xXGU8D2g6poycTThIVXAeaBENw9W4dcUWvij/5gETeU=;
 b=wchDaJSWsWutb60PKxkxBsKHoXDQE/6F8+Amr2LAFb72jZZBbRLT3uw2vY/tcqaB5QjOIEUfG/9LlGzDpXKbU/3VO2Bt6AEk6B9VPec/1/5yQHMrG2hMHWBTkG3oHRw5MZvkQ/kztEOYLQZIWvPHIb6h4B1wBHBnB2WxCD8n7Ugf3IZwEzHT/b2oByyk2VfKtP7vUndYGAibD0SUWde11uUXAsmo0dtJ+9Ks5mkWyx9ohFIAu1R32hDHPMcFMgB3cSh0mCSIeVfxyLTv3+livjUN3GySPrHKRD2iCp6JRvdqv1YbTBtkb7+usmCwMX11rpkgSG0xuO9mFKqJWzuvSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXGU8D2g6poycTThIVXAeaBENw9W4dcUWvij/5gETeU=;
 b=VO4xK/F+6VkSTamKBR7Xnx4PTjOiv1ZrqYj5NPWgoJl5Lozf5eeTfH0UQSPLhUSgME4X/76f2sC0YeN+oFSqDXYfaNKGsvWvmXm8A6YRcLAbNHpAoirZOK0jAMZekdwsRoBri0dMXbiBjav8rTbbPNyEh8wksyncZOHhm4Fhc7ZXkZFC+a5uE09UuD41bzfEDaETPD2wIZBo0Oq0F60a1F5bStfv433ZWmaZnrn1gkNLz7bn4UVusE9n9hyWZMRExJyd2BCY9UQFN9NsumSrf9pyD32d6mtk9bZpl30TgQUoYJwENqkg/fRZiJZ7zWsLOhV7l+hwrv5Yjs/QO7vCUA==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 IA0PR12MB7555.namprd12.prod.outlook.com (2603:10b6:208:43d::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9654.20; Sun, 1 Mar 2026 23:38:39 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::32dc:be07:3859:b4e3]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::32dc:be07:3859:b4e3%4]) with mapi id 15.20.9654.015; Sun, 1 Mar 2026
 23:38:38 +0000
Message-ID: <cf547dbb-af45-49d0-87a0-5267dedf0470@nvidia.com>
Date: Mon, 2 Mar 2026 10:38:24 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/13] mm/migrate_device: Introduce
 migrate_pfn_from_page() helper
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Cc: balbirs@nvidia.com, matthew.brost@intel.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 ziy@nvidia.com, apopple@nvidia.com, lorenzo.stoakes@oracle.com,
 lyude@redhat.com, dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
 rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com,
 willy@infradead.org, linuxppc-dev@lists.ozlabs.org,
 intel-xe@lists.freedesktop.org, jgg@ziepe.ca, Felix.Kuehling@amd.com,
 jhubbard@nvidia.com, maddy@linux.ibm.com, mpe@ellerman.id.au,
 ying.huang@linux.alibaba.com
References: <20260202113642.59295-1-jniethe@nvidia.com>
 <20260202113642.59295-2-jniethe@nvidia.com>
 <9ee22635-a219-47bb-a397-bc4e141b408d@kernel.org>
Content-Language: en-US
From: Jordan Niethe <jniethe@nvidia.com>
In-Reply-To: <9ee22635-a219-47bb-a397-bc4e141b408d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0233.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::28) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|IA0PR12MB7555:EE_
X-MS-Office365-Filtering-Correlation-Id: fc19446b-688d-4ae4-de5d-08de77eba9f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	JeJfczj4WhKKXskzqi5TiMQMXWRSA2aXSy5FGEQcVVEppqxBRUqrcm/CvnYLo+7usvON7V+5bOeQBxVOSapbxZJ++e7ryr6AkhuSmDTZqwxwlpDzY2Tyy7q7L3uOcFDJgiCXQjBITOLafNKvbUTE1/vxySo5tqeCeU4ua9bA7BNbTIJ+YSCCbQ+AfOcLwAOTWaYJASh6zK1/gIXFWjeaA9GnkYixU/41lQ/15kTyiInMxV1Q3nZ0aRD/E4Bz+dwxW00K4D0AdgSIuiO0x4mY5cbG0CjM5aEf2/DKV3P3ijJEHG/wD1QTLJpifPVcnkmVccG8moWjsGxAcdfDOLIAgvQVI2ktxVLTz3ZRshpx53/WZhlRZyw2Lcp1kYzx2yolodWmNz+9OEEGzvynbeqNsY8EwDw+8KOXEDZMNFpEn6AwesfezYPwGP1wJGINNjIIKNQkk+GkDSa2I9GBIFyUqq8fsN5Vbo2fRj2463024RnAvq8OWlrOmyuN6C8jzLi0hNAj/JdBLRCjR1Nf4dHEAdVTpF1jkj+xU+Z8KS5DmXtUZVrqhAQC3EWwdoQtJuZ3uD8asoh1vUSufWigqHgWO+NhhCmC28erwIiYgMWqnauLWk6mlK9kmOJIAwB07nK7Iyo7XgMEzixZXV9y9/a2/81zyOe3A6yrZIs+71ZldZdhjti0u/J9pPhUC0Q/YI9zhFvwVj6nejr4QyZueqLEZjbw149YOfvvpPKnWBVKjGw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MklhK0xDTjJGMFplcVpPazJtMmhyNnArRGc5ZTdjRU1BUWpDa0lMKzNkK3Rp?=
 =?utf-8?B?RWViTzdnYXdxOXJCS01sekkzMlYyazZDckM2SVdjcUJ2M1pKNVUvMFdJV3lo?=
 =?utf-8?B?VU4xdm03bHFGMTNmVlBlS2JsWmtGNzZpazBDVVEvVlR1ZUhtRWs4WmUrR3kw?=
 =?utf-8?B?K2g5N2pZdWhqK0hhMDdKRENkWEFnb1RNTngwL3pnc1FHUXVCVlJqdldidllS?=
 =?utf-8?B?dnJuYkMzd0xlTk1Gcno4TmV4UkVoNW9IbG5RdkJObzU0L1RxTllabk96VFR5?=
 =?utf-8?B?UXRFODhSUnFkdkZZTm1EbmJYTFNJK2lJblRpci9NYnNXeVJ6V1BkdDQ4dEZw?=
 =?utf-8?B?bXRSZWRiZGg1QW5hcC9LMWYrWUphb05kQk1aN2JzdFRZZ2wzVXNDV0l1UTA4?=
 =?utf-8?B?MUYxY1hFbFZQYzVhTGl1bk9XNUxFQUxNNllidzZQTjRZTGMwU2hqUWdLSjFN?=
 =?utf-8?B?bm5xUjNFMDQ5VWRJWjZDU3JoR3g2L3Axa3dEZXBJY3B4Q3kza3dNUVk1eTBx?=
 =?utf-8?B?cUJDNWc5dUttRVdmOU1mUkpyVHNQZ1MrNm9PS00yVGpySXNEaUY5b2gycEFJ?=
 =?utf-8?B?Q1MxUlBPS0k3ZitWdDYxVjJpK1crNUx2M0xJZ1RnL0VSTFNYV2NNd1FDNHpV?=
 =?utf-8?B?SFk0TTBTY2VFY2ZmY3p2ZVZHMXJUMk8vMFhJOTRsWjdyMk5xdUM1c011SktJ?=
 =?utf-8?B?YVl0Y3c0V0JHZ2ZKODMzVVdkRVRhVlUvU2Y4Z3hqQ0t0UnlHb3piaUM5Rk5i?=
 =?utf-8?B?ODRBR1JFc3FqY3pRdHcvR1BTVUVaSW0wNUZOdXgzK1BLazJ5YVRWWS9JS2ox?=
 =?utf-8?B?bFdURUhPQnFuOTMxT1hwYTE1R1E5cXc2ZmwvYzAzcWJvdk10OXlsWU0rak9q?=
 =?utf-8?B?TWtIUW0xNitUYjlqTksvOGFrY2pWbEtZd1c2RjN3TjNGSkFoZmh5eGcyOGQx?=
 =?utf-8?B?RzZLUHQ2VzhQSW4yKzhFOFlXUEF0Zk01TFczaHpuK0svaVlDVGlMT2Rlb2RB?=
 =?utf-8?B?NFlhVzhUMjEwUHRmNDNJL2cxdnlRYnJ5T0hDTmt0YS9kRnRpeHMxdVRTdTB1?=
 =?utf-8?B?RU1oUktOUzIzU29kcDJZa2dvelk0NGtKNXBuVkxBeVBpVjVTV3NPNnRYUzh2?=
 =?utf-8?B?NWZBRlV1L1V2RnFJa00zcUpjZXRZTE9EeEg0SEl3K3l4QVFnMXNkd1Axb1lR?=
 =?utf-8?B?LytQOFpKSzVtQ0lFY0tRU2xmR3pReFByMVZiVmxSSUg3YmhhR1k0WXg0UThh?=
 =?utf-8?B?aTZFQUNOS3ZkS2JRNkU5L09xNU4vRUllcXZiN3BhVUpNVGV3VkhaZThaVXF1?=
 =?utf-8?B?bDR1SlRybWRhb1dTazZzNy9NbHNPcFhvajJNdlUxblNZTmdhd3QzcDltUit2?=
 =?utf-8?B?S2xwMzN2K0NJR1VYYTVFN1Zia0JNNmJTN2hRc3ZUR2d1QmdJYU9tUFI0NUNa?=
 =?utf-8?B?MUd6Q0sva0hIWXV6RlhpUS9SMjJsZ0pFeHIySm41VmdQK0l6ejBKS0xGcFlB?=
 =?utf-8?B?Vnh6WnBrNXhNWDJDbVZjaVdFMGUxbjNXMWRxK3Ivc0RjR0NWVmZHbTVFeGkr?=
 =?utf-8?B?MkRoK2JMdC9xbml4aEZubTZkbDN5Z0MxR1NyNFdFTXJKNG43eisyZWRhV1dj?=
 =?utf-8?B?VVBRVkpXMWFhdHQ0Vnh2UC9YdnhJbVlHVUI4WkFxL2RoNmNla29hamFxR0di?=
 =?utf-8?B?UjArMmxhM1ludTY5MkxWbm5HSUZ2TDJCbWNmTklXVlovUnVELzdBbTBJQ011?=
 =?utf-8?B?TEtjQ000MHJtL1hFQitCN2o4NHVaVG5RWXgxYnlqcWRxYlhCQ1BOeXZxSDEz?=
 =?utf-8?B?c2xPYkRCT2FDNVpqQXRYV0VIdnNIVmM1QXdUUVJZcUhzQThTYmxlNTllaEpE?=
 =?utf-8?B?ZjNSRnpLZ0Z4aG84RnU5RzF4N0NWR0dDV3NNOGZzQ0IyRm1wcDFPVVI4MXVw?=
 =?utf-8?B?VjlDbklUMDF5c09wREZHMXNFV0RTeTdDZkFFSnVnaEFrajQ4UlRrM25WUmNw?=
 =?utf-8?B?Z0J6LzdUQ2pXczE0ME4vaVFpWERoYW4rWEduOU9HYXNEcFRnVm40b2dFRThN?=
 =?utf-8?B?NUdCRUV1anRUZDFtdmJwR2xCTGh3K25TSnN3OTE4NmMzM1hhdzlCdGNiZDFI?=
 =?utf-8?B?U0dudE1ldmpQaEFyelRuYkNPSlJDWmM2ak1zL3prbjNoK1F2QnNXN0srcEJG?=
 =?utf-8?B?MlVjU0VkeEhPVzRRRGZyT0wrWnNRTWV0NFliMFVNTE4zVVowZlMyOFROV3pY?=
 =?utf-8?B?Wmp2QWhBSEczYVlTY2JYOVM0VXRlb2tTejVsUDBvZ3ZhL0FZV0F0MHVrVEpM?=
 =?utf-8?B?cklQZElhTGJ0cmNLRW41eCtkNzAzMTdqY1pNSWpCSXE3YWRxaW5ZUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc19446b-688d-4ae4-de5d-08de77eba9f1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2026 23:38:38.7077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uNvETC7qel3nJblcuiBqvNAFKzUOkYGp1uquV2vEvQuIVIpDxpbTplR9fwFyuNRKH5z9HJIo13Ci7j9DdX/L/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7555
X-Rspam-User: 
X-Stat-Signature: 65dqp7d67ytpicufehgot8zkbqfpobjf
X-Rspamd-Queue-Id: 0FAED20004
X-Rspamd-Server: rspam03
X-HE-Tag: 1772408321-249778
X-HE-Meta: U2FsdGVkX1851hBRxcTB3qsMo8i/6Y1E0U53mTrKEnLlb2m+SFr1FRyB/PrzUU4pFt5/Krx+ze4ysAq1en4yeSlfJNv6Eni9/3h4j2XkmvGtdPfrrybrwRcYX1KqGoZLT8BqEjwL7lSa6XA8lgVMBGUp9kwpMsMOGzgmDJv9WEf+dNHZxpnPY5v8MSz7TihPI327MH2NiqE84FvLFkhpeDqh+RIPfkj3wPFIKwIJWlxdyaXwfM6fwtPUJcGuZZQAx9w629uj4eRqTVj0kpFr21Y9/FVMqa9z4cwgmq5C6yqNLyV0XNhBNcwJhOuTs8AFSG9OHSUR5S6loGWPhbGryCknmLza0jdYGeNHFR7maT2QxYDqCbm8CIxCkD7DeOHNxUSLzaToAefB9bF4w8WyPIMxNTtq4P6U2PhRUd034aVJVZFakBOnmc7LYFEMjSCIdPandEMv7oyNMElRrPaPN/3Bshppp0v9itpFc5QIqEYh70HCgBnjXWBig7bOWovIalgmFz5fIdo8Qm+NkkIUUABmq5dPWFdhCk2a+B50uRF/RQaft1EpA/mp2diDEY4fFjKyP/WMjN2r8ixkXdtcWPQ0m/yxSBSt6n8fp7+K1/O0E+kR7Twrrc678mqIjqEFvJhlx0109Appmm32VYiAux11BzgM29O4T5fUBALOJ3Ud0rgnD9h2Yz1hD3/GKdpZvXhN15vdNhXoc13tJLxRJMz5qDbsPxaRkxtIprVrEgxgMB8tCZjylZ6vaxrPNyejmzaj3T6LG3SWrHM6C8vEyBAnTr+yXmQUdmUAGnDRVxYDKx8t1s83xNTqs/ct6c7/kgVwtE0hG/gOli5Z8jGpWgHy9IiE5inK2btLx+BPX5FyIMZi+hdIOCx3vKTi6qlCacrxytbCfqi3zYb+EFFcEz6akO2rV9PZu/5L8yugclZPG4DjU3nmJjm5jYB7MIjhs142dPVO0QrZsQvJ1Mr
 BDBtgnZP
 6dAAZLvMEbcLHMozxohi+IJlEZ5zVrjfdd3Ww9O6TTINUmm2t3CkP3S8y8eDCCxFTg7x2wsE7ltZMnZQ/weiX8BixYWnLykrtdY0zl4yfdllEOBYfPlBvfxSEOV06uYhqq930H0TdboeSIRNLbukVIFJtkP60smMfudPj4RgvJF67R/IDfzfSb5EjQzSDSDMqgc9BRjaNnVzMHN8WLqH7WS+Gy7LMRd5NfTBrXsdEYqsgK42QmAs6IIO58upUu55tfGcSlfEFx0w92gYSZ67ypC+veGDGQ8xIlxto3d6mGrG/H2KNobvzyB6v1p0rLLf3hVmD5T4Hs8IuSWx9HXhXF1VZws1Brue/3gBYEqHqDhn7o9YwaUdNH8Jt6pdGljDUElrbtFEdQGjicjnFtk3dH2ffNNG9hpJG7IrWPiuT/3nmyFc8cGWlaIEaBd7GCm0aMiWKVzse6kblZEPix5bCb5QcPrj8YigGCPseLAar8FtqXRE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 28/2/26 08:11, David Hildenbrand (Arm) wrote:
> On 2/2/26 12:36, Jordan Niethe wrote:
>> To create a migrate entry from a given struct page, that page is first
>> converted to its pfn, before passing the pfn to migrate_pfn().
>>
>> A future change will remove device private pages from the physical
>> address space. This will mean that device private pages no longer have a
>> pfn and must be handled separately.
>>
>> Prepare for this with a new helper:
>>
>>      - migrate_pfn_from_page()
>>
>> This helper takes a struct page as parameter instead of a pfn. This will
>> allow more flexibility for handling the mpfn differently for device
>> private pages.
>>
>> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
>> Acked-by: Felix Kuehling <felix.kuehling@amd.com>
>> Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
>> ---
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks David,
Jordan.

> 


