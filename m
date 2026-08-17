Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36ED2C5DF74
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B154C6B0111; Mon, 17 Aug 2026 18:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F026B0114; Mon, 17 Aug 2026 18:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945146B0115; Mon, 17 Aug 2026 18:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 510E76B0111
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:06:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1EF380938
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:06:56 +0000 (UTC)
X-FDA: 85112147232.14.5B16632
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010031.outbound.protection.outlook.com [52.101.193.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CB76020003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:06:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=evqy5Ytc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.31 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787004413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02fHXAWC5HoxW6JLhxcSKXOtheSPIpYqF79y1dTepcQ=;
	b=eH13tL/L2y6+j4ixzqbZkv0IEK8ap7v+stfAi0bMSEQAcMpu5x3hfMibkcwFAQmFp7s90s
	au0XhUkLvXI1ys2bj0e9eABr+PXdSZlUQWOGI03zyvSSIt5wsTYOu/Y4QQpTq+bc9xhrI3
	65yhQqiTsGOfsG34uEWtZMML89C843k=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=evqy5Ytc;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.193.31 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787004414;
	b=ZnUFqSjzoyVU5q3rclhH4F+NyElUMGaS/CBJrScgcw2IMBoAKGRTc0LdzfjuZ/scZidQYW
	3GQy0o5rgIXi9f2MoxsEAgkGt58TIY9dWwsb0MKE+RwM8MAU78b5e+tA8aRNvX1FqbEe7U
	agpLWA9D24ofyHexn6rzn/6C73peVKA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f2lhiIa3kP5INNv/oiLYscmoLysykbDEOwn6ZMV/0ml8CRUU7o/e4WhK++qtNu6wH3wTNBQ8mp8xxofG+8n6W9GDh3efxF+y0uxopRWhW+JbRZPKycKJuPIYUyZIPcOzU8kpyrKLeK7FvBzizr+YBNHuAOHAtIIiPtVWzEtas0/VE2zFxa+NKTxSR0VbQUsnpFk8d4sUFRVEw3QeT4b7NYzl3gAIJBJ4dwMvd3o4KiaOU50pScGbWSm74P7mPMI8z945fhX7Do5WR4xQLEu9Rd0gjm1D2PoAGfMFi0gV7MpulBnUg9NrGT7l4pg/7oZqbC7lSKNtLp1UrIGy6iCFog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=02fHXAWC5HoxW6JLhxcSKXOtheSPIpYqF79y1dTepcQ=;
 b=iUpBte5ZkV9264p+TJe++3z7bnXQj4vLSjPXdM2+arkbhHRnywlJEriZh++BIOTf6edr/Dj7AWL/C3UkCa/m2UDH++IS02TsucQHI+xOww28cmx1H1I0J1GvzBXJsJRlhrSy/YZ/7U28CURgP14ILiBPINHNS8svYE7GrnFHNBew7suPw42e1ZlY3ARReNU9oT5i2eJH2oeI3ZizNXcyrramjwKQHxCU6H+fiyOPQSpHcSuKvX50hDrnO5wXx3Jvmx851y32aa1WzhHZnjOhZqbKCRa8ENwNvwDCzMWQF1MCm7t3YgueWl4F0WbXWtKBcgA4jDHQOhoBqq0Az5/Dxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=02fHXAWC5HoxW6JLhxcSKXOtheSPIpYqF79y1dTepcQ=;
 b=evqy5Ytccc6QEJOZ/owqTYz2nOQ7KrObeDp0eNXl+jbnnsqhWtxIb5oU9PNGjXhekYVEDZeAlOasS3BaQv+UrZhcbBBrt3qYDTZl8QRB/XnoC4EI18SZfjduyhOsFBdaixGAOteK0C1uSgKPfo5VWLNey0+6BXKmV4NC5oM+I5bNJPb1ir6zILCzzAdHu4e95PA/+K1qIXfKAh+1jYISY6sTexhzlKLmVeP/ZzpNQLI1b4LhZdhRQjlaRVO9Op9W153FDq/iF/QD9M4h0ftpGYnRjiJhtfoFtRgCR7V5c2mRty3VUJPXmtHNKHBjRPUJV+t9T5zTrI+6c8Z+J8FSnQ==
Received: from CH1PR12MB9670.namprd12.prod.outlook.com (2603:10b6:610:2af::6)
 by SN7PR12MB6689.namprd12.prod.outlook.com (2603:10b6:806:273::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Mon, 17 Aug
 2026 22:06:49 +0000
Received: from CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811]) by CH1PR12MB9670.namprd12.prod.outlook.com
 ([fe80::416:ea1f:d17b:2811%6]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 22:06:49 +0000
Message-ID: <0f534a0d-c523-4643-afb3-0f098ea52059@nvidia.com>
Date: Tue, 18 Aug 2026 08:06:40 +1000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix cache flush when replacing huge
 zero PMD
To: Andrew Morton <akpm@linux-foundation.org>, Hui Su <sh_def@163.com>
Cc: apopple@nvidia.com, byungchul@sk.com, david@kernel.org,
 gourry@gourry.net, joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, matthew.brost@intel.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com
References: <20260817090640.287a9a415da49e3974797aa4@linux-foundation.org>
 <20260817163646.929678-1-sh_def@163.com>
 <20260817143415.60bedb09819d13a2dc0fbe63@linux-foundation.org>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260817143415.60bedb09819d13a2dc0fbe63@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MEVPR01CA0053.ausprd01.prod.outlook.com
 (2603:10c6:220:1fd::8) To CH1PR12MB9670.namprd12.prod.outlook.com
 (2603:10b6:610:2af::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PR12MB9670:EE_|SN7PR12MB6689:EE_
X-MS-Office365-Filtering-Correlation-Id: cca3e407-880b-48c8-2175-08defcabd5a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|23010399003|56012099006|10067099003|6133799003|18002099003|4143699003|22082099003|11063799006|5023799004;
X-Microsoft-Antispam-Message-Info:
	E57fQuTANVhHPAofDmSZ47JhYOghMhhxOdo+4y/5SDcQWCoDoShmSyr+cE8QdHO7sUl09lfnjIdwvO7s9BVi11i5RXBjNmxlAlPNHWS9o5v73n5Sjk1mFr6A37CcG8/krPyIO5c/yqFGExPhRh/UtbMP7p2VA0b7GGPgfddm6jrjTswmunAW3jlr3rc91NATlWRqyveqghYMZ8wSjADVhXaMTN8fDz1vmKOw/1AVXs6/yoi1M8X/K4mbOFJtmrc8PBz4QKwJtPnS30MvVBryZfBQ1xDKxL71brlWb3eqH517Ll+8t6ewvXli1pvbrFs4TkuItO6daJhWdpPLfMwnTOYW88LHGHwfE8y7GcqCKCG33d65tDCX6O7OmGmkJtL52zjtpAZagRegHquyxM8gR6mWVANBr5vUDSUPkQBsFUHrHlOgJwI36KEcMq3wPcSQ/ob+qUbqn4NkD/S6F43SuG+9Kfx48ON3v0M1fZRUZLwbL6sLHJ2zIROhWUEudTYEAkoCCwzABZg7qD1j3i9svpo1syUhq8/vRILOyg+Vyci7p0PMLib9eAD/9Vw4vYXk27TwO4Nkw91OZVISTRi+TMqty2n3yT+bbeXm35nhdwRi75Ht+nX68RXeO4PCuRQyHGii2KykNv0BSg3NN904AwCPA+/6lwxmJbYgSlhpYgk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH1PR12MB9670.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(23010399003)(56012099006)(10067099003)(6133799003)(18002099003)(4143699003)(22082099003)(11063799006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Um5VYVhjZVJkZTJKdlMwV2JjSzVtUnpIWHVNV1JrZkdQbVVZMjY3Nm1MTWZY?=
 =?utf-8?B?TzJFNUNaa3cwRUY5TUNLYU1NczViQ1dKRXNUcHhYSW5md0lXWGVIRlF1OXp0?=
 =?utf-8?B?dk1lNDkwN2FIeHZkN0dZQTdYWE82M3M4SnVDWDg1THhPM1VhU2Vielc2ZmMv?=
 =?utf-8?B?NWFhQUgyOXBDM2FQWjl0d2pRSEZkVnhyV1RXaUZCVUwzYTN0U3dkb0tDZldo?=
 =?utf-8?B?Q0ZTYzRYMTJRT3VMRjhMYlBtZ1dXdmZuKzVVdDJ6c2FXNXlBME1zYmt5aW5l?=
 =?utf-8?B?SWw0RklMazF6WmVHZEoxMytXNmRYSjU5YTBXS3NRNlF4ODI5Y3Y5SmdsdS9y?=
 =?utf-8?B?OU1BNSthRHlUdE5YVS9DcThnRm16Yy9sTUtuMjBlVmx3UGRiNHFvOWJyaVJ4?=
 =?utf-8?B?WGdtNm95YnZta2QzTDRZQzNtMjUyYXlWZm91eEVoWHdqSk1kNTN3SlpLYVFV?=
 =?utf-8?B?YzJlQmp5c0JycTVsbVlUekp4emFZTUdmVzJWQW9lVWpuVnR1cVVOZjVET0lM?=
 =?utf-8?B?Z095TDNMaWFkZnpYK1dwOGlPTnVxek9VTkE5c3pUZlpMUytFR2hyRk9ENGpn?=
 =?utf-8?B?VUxxdG1jYm93RHBGTWhKK3dOcFZnQit4elRmZmJ6aHFKOS94TzhtaHAxMFFL?=
 =?utf-8?B?UHhnS2pyeFVDa2lpMFR3d0Zla2xFeWRrdXRYS3lITXZ6SVk4djZUOExML2J1?=
 =?utf-8?B?N1JnUTRaTWRGdFBQMUl5aUFKczlHZW5YUGcxM2RxOCtPMmg1amtoWllmTUpj?=
 =?utf-8?B?eHJ5ZENkRy80YW05SGFyZmRxanM0Y0pGcVRNZENhZ3pQVmlnOVphUHlPVTJZ?=
 =?utf-8?B?bmZVZzh3eWZPWUhuRjU4K1UxRlFGaVVEME1LN3UwaW84cWpEY0ZoRkhSb3hn?=
 =?utf-8?B?cFF3UTRMbCsyZWxObkZtbVR2VDM1YWt1SGZ3NGlQL3hJM05iVFBmTjBMdzdO?=
 =?utf-8?B?UmkyYnJzRStJaTcwY09Ebjl4T254L24zS0dxYzMwNlFCUkhPMFlKOEM2b1NT?=
 =?utf-8?B?a0t2ZGl2T2hnRnRLeHpod1RsVGlzeE1ucEo0djhOQk5zamNHRm1hZTlrekkx?=
 =?utf-8?B?anl3WW9WaXdVdkdiMlF5WWpKUGJYT3oyZTU5S041cWhhNjV1QitOeEl3M1lC?=
 =?utf-8?B?Y0h3dlR5VWhvRmhJYlN1anc5MzdIMTd4a0Jpc2E4OWZhMkJmWUNrTFUzekF6?=
 =?utf-8?B?L20vbjFxaWRCUGJZa0F5K05iRjFORHZsOUJvZzhGZFpMemRTK0ZMckUxeVdt?=
 =?utf-8?B?OGJnbDFSWkRqT1JoRHNpUGszTm9pUC9xSW1PNUZnbUUyRmlDbWZvS1cwbTIz?=
 =?utf-8?B?Z2p3WFR1UG5IKzZuOC80M1Fqa3NxN3h4N29FYm1BelR2VXExQ2VjaG5uLzFq?=
 =?utf-8?B?WnNNTks1cFVoUlFwVkhtZVFmRWE5T21LUk85WXZSUW1UMWtadHNWUlp4WHZK?=
 =?utf-8?B?dGhTUmJGVHZkVklTZVBaUHgrVkFPWXh0SEZBZEdQSFArZUtkd1MvZHZNbk4z?=
 =?utf-8?B?WG56SGtjYUp3dk11N3lqMGF6RDJaRXNTMkkrRTVZWndKdUlkQXhuN2RTSGpU?=
 =?utf-8?B?bWY1THBiY2UvZDkzS0pvdVVCam8wRWFTU204ZWZMcFpBcVY3MXR1VFg3N0JD?=
 =?utf-8?B?SzF5c05Nd1ZZdExULzZtZTlrbGQvYWhnNFFZc1NqVEpYdUsvbzdDRjdGYnhn?=
 =?utf-8?B?NFljTmhHSjMrL0o3S2RXZzg5TjBBUEIxb00rS3FxcXhNckYvbHNTbGVwVm5y?=
 =?utf-8?B?cUJiaGJtMEEvNXpiMU0yYUpWQ2NaWEtTdmpSU3NEaWNhLzVHbnJhVHlNWUpS?=
 =?utf-8?B?UUEydmFJSHVLVjE5VnJkRmJDNjRzWCsrUE5RT2FOUlNjSWJnQm5HeHFLRzFz?=
 =?utf-8?B?MkVSbzhPODBoV0ltRFRRd1h6R1lkQ1VqblROcVlTTHZxaEhFWXYyTWNoUnZH?=
 =?utf-8?B?amYySmx6c2E1a295akNMMjlYK2x5TDVCNFNBU1c3N3dYWm5yaE5ISG1oaENL?=
 =?utf-8?B?WHd5VExwV1dNU3oyMTJlRmpvSE5Md2xaU2NvQTRZZkN4UGt2QWJ4TUF6dkZM?=
 =?utf-8?B?WGdTWnl0VTRsU0tCTHoyVURLd0g5d0pxTUZLZCthaG9zNk5WK3JhcXNxejVS?=
 =?utf-8?B?MmQ3OE5yNkx3YjZpN3hkdzFpVitjWU8zeVpadTBKeldoZ3BTbklEZkp2V25i?=
 =?utf-8?B?Y0tOWks0elByYUdJd085Q1pvbmxtK3RJUTZ0SUhUWFB4V3VNMjVWdndzWis4?=
 =?utf-8?B?UUI3RzBZVFpKT2lBRllaWlJwL0d0QXduU2JNOHBOaEI5aXhmcjY0blJSUnlI?=
 =?utf-8?B?aUY3S1JaVm9iTjhtd1ZwM3RGcitKRGdZcEw2QmkrK09jdEl3VFFxQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cca3e407-880b-48c8-2175-08defcabd5a7
X-MS-Exchange-CrossTenant-AuthSource: CH1PR12MB9670.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 22:06:48.9550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9m4PipW1qsJxV0OdiLmSMLhD1u+EERfkXLuwhS3+2OtOPH+uITzNkC3+X7uu2Iq+t93n6aBp++6bj5X6Xm1pQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6689
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB76020003
X-Stat-Signature: 8g9piy3wc9e83mema8rdin6swidqpgoy
X-Rspam-User: 
X-HE-Tag: 1787004413-980891
X-HE-Meta: U2FsdGVkX18YgMWZPqlkt3QijTimwppxPfmigm6mMh0dWtgODPVmFtWRcrKzUb90YZNqTFJWCRVK1cYV9z+3WQK9FmRT5CqEcTe4ytG0eSMbvAf/+mLtwbXOGOi1/LykEm50OSWkIltNb7PlrsFQhBf+kOwb69mKZu/upks7kB9Z1YSva9o652SrjvAWZGHnXHq6EFb1k+YbEpbH9j2qKrUDiwJhAbe2/XP2obXleUbz7KDzER2efYUUMJMXk9hA10viE0dOWPRmKJwMUfM+4MAn8Wgw1ferWWNsnL3DOvuGDl2fRQizcWGB3PXt8s5ZhRYtIkRlTTypFTNGmLWvHzggPNgVrzhHNVXh0VEV/XnDDIxU3yA3iqxCoAFtaCyaM9S8jD0+kQzGLkVZWfIC8GYzjP2z+zi5FJJll+gv6QrIthbJxR+9OONs6NddDqE9mehUoz4tchsCXNikQhFszxGvPOBpe6Gtcplcp4qlKM/dQ1tvAmHiLJYCqotpKFTpK2eUW3BQvMw0VNDrovxbHoFcn7dh1fTfqDYsU4/XM8qr8EhpNp4COnQhfD0wgAIJqrNhYhT1TBPyLwA5I1M7PrTvWE7EdU3f8vxwpKPKni4ETDChfWoJHhTa7DpNwoNwBr3qI4pwTgNCvnRnWxUHYPM/bl9bZ0PFmyUWbegcr3l81BL2Ly6XgSs+4InPAs5uA2UAjGSaT2AUB+1TsQqX7rRVIk1iTg2jEG74aGR9acWwUG0ubIizOcG1OKIpxY7+tL1gYIH1tw1iOdts41Baj37TUSPuQra8tHijcRzoiIjzkcgEgvL4dKHvPsZT/HDMiNld+dZlriWZl+kQsO3WmgU4fFdKU+0ooMPryROKk+rZJwfRpyG9ku8vr7xx1WyRk4JV+lZyDUEgPu6YIt6WmGT+lkjNdt0uewLNPJU/ulj7Q2gBOX3KQ6+lV4Gcg/o+Rci828XexteYNp+BdR0
 6upw5ILt
 9FlK17iZpifMGxD3UXuAi00AAsOb8/vntWwHk0TQ1YGe/OzHwr3b6cR9gVlGMDWVwwZbKLk9la5cMrT1XLbxNP3witwF6iRJK5+0yjzvsgFD+kjRh5kPL/Bhq2oMsGplsugBcJK+q/O+Ba6MtVh3TF+KFe6jmqHGwbUCOWu/rgPZ9L75RUiHnPjSK1q7Q/543qJBA/7D+G0y0iItk5y9+xlTgcS06/9XZPrKEBcz+azUDevWkF/qMd8OGUMBjf+JK0sgqEhxjNbkgQyEhthWTjW/jmTXVGa826M/hGTWiHb649gyeL7RmJiiCSjZGIfK0YtkwU/8dw5ZXVdYercpPIw0iHFiyMgylSq9LaKjR73oRIBNxF+JXFCXt6D5+8gu6cPr8bu0jqTamQFg9xqYAXDKdQANQGyOCrLBSPxfLw3yJiDiiTMaxZMx+b3H2BTAVlMu4hyW8T2sIQ4XvsKBPopCl0GHBeOpk/EK82IPvQUsNOaKzmWcDg9zF/YnhVay4dxcAyK3Nmgjc+Bcp95qYltMJK1r1umqLRXS/OBqvFIvIma/HEIzgwl33eeDCQbGYaIiDac4IC2EmKOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/26 7:34 AM, Andrew Morton wrote:
> On Tue, 18 Aug 2026 00:36:46 +0800 Hui Su <sh_def@163.com> wrote:
> 
>>>>> --- a/mm/migrate_device.c
>>>>> +++ b/mm/migrate_device.c
>>>>> @@ -872,7 +872,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
>>>>>  
>>>>>  	if (flush) {
>>>>>  		pte_free(vma->vm_mm, pgtable);
>>>>> -		flush_cache_page(vma, addr, addr + HPAGE_PMD_SIZE);
>>>>> +		flush_cache_range(vma, addr, addr + HPAGE_PMD_SIZE);
>>>>>  		pmdp_invalidate(vma, addr, pmdp);
>>>>>  	} else {
>>>>>  		pgtable_trans_huge_deposit(vma->vm_mm, pmdp, pgtable);
>>>>
>>>> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
>>>
>>> doh.  It's a shame this actually compiled...
>>>
>>> Can we add some speculation about the userspace-visible effects of the
>>> bug?
>>>
>>> I'm assuming we should backport the fix?
>>
>> Hi,
>>
>> I took a closer look at this, there is no userspace-visible effect today.
>>
>> The architectures that currently enable ARCH_ENABLE_THP_MIGRATION use
>> no-op implementations of flush_cache_page()/flush_cache_range().
>> 32-bit ARM has non-trivial implementations, but does not enable
>> ARCH_ENABLE_THP_MIGRATION.
>>
>> So this appears to be a latent API misuse rather than a currently
>> observable bug, and I don't think a stable backport is necessary.
> 
> OK, thanks for checking.
> 
>> Should I resend a v2 clarifying the userspace-visible effect in the
>> changelog?
> 
> Yes please, after 7.3-rc1.

I have been running some tests at my end, I have some new ones, nothing
so far exposes this. Thanks for checking Hui!

Balbir

