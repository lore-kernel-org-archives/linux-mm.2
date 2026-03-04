Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36F08EFCE47
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 21:48:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785D36B0005; Wed,  4 Mar 2026 16:48:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739566B0088; Wed,  4 Mar 2026 16:48:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 607D06B0089; Wed,  4 Mar 2026 16:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 502856B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:48:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17665C1D27
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:48:30 +0000 (UTC)
X-FDA: 84509719980.22.8786835
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013042.outbound.protection.outlook.com [40.107.201.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3C7BC10000B
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 21:48:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BXZvckoN;
	spf=pass (imf14.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.201.42 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772660907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDbJlm6EhKYDOCGAtkUjyJEnxN+v33J8RVoAnke9c0M=;
	b=3tNP7skn+VL/R8vjJP/xGpJza7Ei2W+cTK07uL7twnJCc28rRHbGra8ybpSJ+YrGcJHN0S
	dEO1knR0NbWldHfEvrJ7Hl4VWbej7mJFzbAV9wQZnjPD8b3gQkHy72ADpBsafhWj7m43bs
	45CLc8fAdDEFK2coXF32I8F5V0TbmLU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772660907; a=rsa-sha256;
	cv=pass;
	b=zZoqdVTnpa5MzN8R6Wll1PVpxtzx14u4MikZrqtcaAOnryoOD7hLmXgm+7DiFGNXS6nXxR
	GY7cMb5yKTNr87mGX/b0Qi2EWDJmha7hN3tEMc8cWd+vbdlwfzjX+ZgNuEoi80/PTn02DB
	6IFKS+/RtLGvFBrbMCf4UWk6PXtFQZc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BXZvckoN;
	spf=pass (imf14.hostedemail.com: domain of balbirs@nvidia.com designates 40.107.201.42 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DwEVhNoDv7ukDsuUK+e+DyFpjI/eP75OfZkuX/SllmDaBfuPw9x9eokwXwCLgqlaFafjzV45TfYtlh/lRgRSuUru1e+K77x429JrxX65JLRgx5Pt9SeUKJfh3uEJCFoaKcmoAJpvBRizywmkHMmPIWeGmw/q2hd9hpaPA7qdx+RsJIcNVwbx0djSiNbQ/6yBqG/whmLja0Qo31nJiJoc1XlS3jRqaGmMNfwZIND5POYDtUbtSkSwEAAmcrH5IeGtxDG8X2yrptnzLnFUN8hYBdEQD4SapejbODVQ0DfJzNmH/QqNR3VgA3HYNQzIB2FMg9LJdjIp4ujXZu0FHibL7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDbJlm6EhKYDOCGAtkUjyJEnxN+v33J8RVoAnke9c0M=;
 b=vdaRMBQtSzm4LCCZnS0iiQt86fQ7zrCwoabcTR0JMQkrv+jV8UmeYvcVq52Pdp7ZCEa9kdBKolv+ckr9Eg20h8pQiAfAxRd9DOI1LWakqqjB7W0yMOjSggOGxF/dkd7vkw4cAqdhYXHv32mlu9eQcoiWhcfCN6VwmaR+z1+/h6uKbxoNd2OjyTiO43XYzlGjUD0Rlijo63Iw15OGJLlTEE5Ni3SuMIqdfP/7+dqwIsE/ThFDs+mjFJR9MeCf0HBQG7iJX/OkHMuebKI+I9UapEDhrVR+F9xs23UhJu4FOeH0Q+DsygKntOOTTGLhLi3/3/R5clgyOQV33sDayxRDiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDbJlm6EhKYDOCGAtkUjyJEnxN+v33J8RVoAnke9c0M=;
 b=BXZvckoNVHaFM+8RzkpOW6TjetoJHlQTVfvPDicQ+aOQKjNHmyeZu/O/tAl9pf8/Cc1iGc5BidfhytGP8sRdDSPn0V3ZAouxJwEd4KuBgxr4AMiPisQfFVpvV1ecMewkcxTyzmODLZCKXGE6hoLsh2Cy1sGZZkpGzCUBRvezhlBcB2b6/sWanlh+F1hAaIkW4U9rFUWYlZN7li2/lHRMGHHa/yfgxelC40CLAy6diOYkHonUIkKv8yqphKFE69u+74ZCD4lp74p/NP5OdAqC+apnL7ePVAjT2skGrURWykloCDBXajnimiP+8Okh9Uq9KFotQfQYqxJ4qKoT+YdMOg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SN7PR12MB7856.namprd12.prod.outlook.com (2603:10b6:806:340::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 21:48:17 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9654.022; Wed, 4 Mar 2026
 21:48:17 +0000
Message-ID: <fbae2102-3e62-4df6-96bd-e8600ef2f497@nvidia.com>
Date: Thu, 5 Mar 2026 08:48:09 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on
 folio_split_unmapped failure
To: Zi Yan <ziy@nvidia.com>, Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 david@kernel.org, linux-mm@kvack.org, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, hannes@cmpxchg.org, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, riel@surriel.com, shakeel.butt@linux.dev,
 kas@kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 Usama Arif <usama.arif@linux.dev>
References: <20260304120132.3973445-1-usamaarif642@gmail.com>
 <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <E4B81DFE-5D45-40F2-9C90-EF386D89B06F@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0021.namprd08.prod.outlook.com
 (2603:10b6:a03:100::34) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SN7PR12MB7856:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c546a3-8d28-40b3-59ad-08de7a37beb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	Gbn6hw+oLSIdVQqFwHAe9ur6tuIZpXF06MSo7N2RwwN1O1nNYnZA6TcIj34BvI8sJOgQIpe28u+f6SPg56sNsXZLumQX6QlYwawFjy0z7Q3PCGYa7RgK5hStgMfGwxpNjo84siR1GXhmr58LGN7UUzSUT2FdPnAODqjA0a/auMTSCiejscaPU07F888F1c7uUOedAgz33oJBAn8onaTOoAC4tPgRstYFRZrKSfDv6hotMR7XWFX4NcaBLBwsa2HHdChVHZlEk5bSeOUkCYKht71bTAiWNA9CvFj11LsRCp3fd2YLutMvj/Dw44hjDjfVvfuY2MmMmFuOkZz1v6+Bd+0BKggDtKUuhR9v1r5i6yYZZzbDBz1BpunbYgRMu4nIEspASpOTG1EPbE+r6LL7OmB96niXvGXT6ySK5ycbPX4GjeCTr/frAiL4v6thcgzQh7Q9wnKKqf6UpROBvL6TfB/7FG35loLxnIHHPjNu9GgSUlQUE4ih06zvUopt8gDBshPMd3AHti7fG8/QyKlTPa7Rr5A93t6+du2tdw1VOdXXtB6O+2wzz/cl8yVN16E+qXgo45CsUoAHKm0IdNG8FGRT8iwXK9T18jQdEkUsdOX5C2SYwIs9qETKA+44eoSiPnadrm7RXbGx18qktC0WlfrAYKhpP45sVOcvN07lyZYNMgIYP0diaSjVvamGFuauIkvwynvZfn40IKs0jkRpSWUzC2xsYGI/R7b6ZW3IJpc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WVVsSER0MlIxaWdobjlJNnhqeVBwRFdVVk1YeUwrUUhSWEd4SWNoOWpGZzcz?=
 =?utf-8?B?dWV3ZWF1dkN3M2phVCtISzJkTVlvSW5LL2pBcUVVUmN6Z3FEV2E4SFovRE1x?=
 =?utf-8?B?dUdBcTNuZkNQT1FXS1drOUNFOG1DTERRd1ZYQjZXa0taYjNuRmtzNk9ldTZs?=
 =?utf-8?B?QU1YMFVUMUpWa0ZCV0FicklPR1VSQ2RTNDg2U3RhK1FIUWIwcjJjZ3h1SmFP?=
 =?utf-8?B?TFhTZnh3bUVIQU43QW0wYS9HY2s1RFIzSDBwSllYNUgvMU5MOTM3Q201VlBp?=
 =?utf-8?B?V3p5U0JoUXNtUlJsRGxYU2puR2lEL0pwN3VjeE5GdHlDdDFhcVBqWUw0TWdw?=
 =?utf-8?B?bFE5Sk91VWZZOUo0aFhxM1BZMmQxa3J2OGdKU2YxSGRjbHhqa2NOVWJ0UlVv?=
 =?utf-8?B?NG5sRHhsMUpVSUR0K2VuYlhLYnl6QlFOUWEyM0hqQ1A2VWswMUZJQXU1dzRq?=
 =?utf-8?B?ZEQ0QmM2cTRvbmRRQ2FJdG5udFlpRkFmbjNXUENEQTFQRDNMREd4a1Q0N0hT?=
 =?utf-8?B?UlE3cW5HWEpNaTQ5T1Q0SjVQeHBKcEk0c2xRaWNNTUNvMjNxeDVveDh4cE5C?=
 =?utf-8?B?NzFYMzIxQ2Fhdk5DV0xzb1NIZERNWXlCQXRQcnFQRlhxV081Y01KMlJPN2Jw?=
 =?utf-8?B?ekRPSFBWTk0rQVhLMWg2WG9xNmhwcHZkNlV1KzRSWnEvY3E5UllyQ0dlalVO?=
 =?utf-8?B?RGRJeFFGcXo4bEd3ZjJ2TmNOOEF0SzNMVkM2Y2pHQlZWcjRkU1d0U0dYN3kv?=
 =?utf-8?B?N3pJZTBaT0toTHBhbk1pa3dzNUVvMzQ3YUlkQzFYYkFVcStoaHAwZzZYWndP?=
 =?utf-8?B?VXBNWFhLdDdBM2FMSFpCM0JmdU5ZNGtBUXUrTFU2MEpoR1VrcXFydzlKMmxB?=
 =?utf-8?B?V0l4WEZKVVBCdU14Zmc5UmM5VGlLdWJTellTbDBkN2xZNm1vRExSeXVZYmQr?=
 =?utf-8?B?WXBaS0t6bDhKdTFqa3JFZ1JlWHBDaSszOXdWLy9iYTg1SHU1YXpnNUp3d1Jn?=
 =?utf-8?B?dkJEeE9YRkxuZ2llb1d1WnVNcmx3dHVFSHRiMktKMkltQXhBMERLSEROZlhU?=
 =?utf-8?B?NkExUnpHTkpDUXNzKzEzcUR1bkZKM1lVTGNtWFFhY0ZJVWpqQU5XWmxVYXFI?=
 =?utf-8?B?Wlg3aXROYXdDdkRyVlIwL2tyRjlvSmpZOFpBNUVSaVNpOTBKYjFiQmx5ZVBP?=
 =?utf-8?B?QVJtYkVoRXV1aFllc1lvZ1lOVHIwNWFnMHJDM29KZUxQYTVGcnVveHFnWEh5?=
 =?utf-8?B?QTZwekJxMmFuUWxIa1l0Rm9UNDE1Q0t0QnpEREpzWnJreExvbTVaRVFaTkxB?=
 =?utf-8?B?Uk5tU3FyS2FCb1N2dFVtQVJGaTkyRVlRQSsza0FTSkNNejE1OVROWTZQUHhx?=
 =?utf-8?B?YkQxanVSZVc4VTM1VDVhZmR2aUNVcFdSbU0yQWN1UWRNL01iT0xTc3hDYjhK?=
 =?utf-8?B?SjIvSUhVK3Q5c2xMalhlL05pOEFnWWwzVURtTnVNNFFidDRzbjhvVko4WStr?=
 =?utf-8?B?NTVtSXRaTXgvendEZHFTWUFNRi9ycnhPRXdETEhRREJ4Yld3VCtpajZYY1I3?=
 =?utf-8?B?eWZmV2JRQlF6US8yODdqMTQvOUt4Q1J2NVBlYUhwbnFRR1J3L3lZUEZTSVdY?=
 =?utf-8?B?blFObFhlY0FRbjRiSE1IdzZlckp4enJKQkdmMkltVmNVaGZTVWZOM0xYRkg1?=
 =?utf-8?B?M2owRnhnb3o3YlJ0WHhQL1VUNzlKT1daUDFVWi9MUGxhS1dNZDJiRGZ3ZlRB?=
 =?utf-8?B?RGkvQm50UjMyOVozOUIxSFMrY3dYWGNRVEJWYjVueFdFd2NjbjNGYzJkYXJY?=
 =?utf-8?B?SEU0VWlQVDQyeDZHYUt2N0U5dW1qU2t1cmx2UG8zRmhwcjlvTC9LVDl6RHdm?=
 =?utf-8?B?U2N2dnpQanNFdlE5TG5QTXd2MFJMcGkreUhwc0drMFE0N0VjRU5zUkZNZU0w?=
 =?utf-8?B?eGhOS2NzNHRPVkxwY2NDdmJRS0ovK2tiZjE1RXVyR2ZrS3lGbmV5Y2F6d3FP?=
 =?utf-8?B?TFlmNVViUGxjcTQ3N1pFVFJzOGUvdlZVMDc5eVE2ZlZRSk9GNUlVVUNnUStk?=
 =?utf-8?B?MEkrTUlHYTA4NWpOdXJOTXZCcEhQMkN5d0kvd1ZhWitpNlpTaEFuVVQ1eldZ?=
 =?utf-8?B?MDlTOWdJdEFBS3VjamhScFhaSHVndENMbHpQQkZFSG9oODRLVkhLNFZrN1hm?=
 =?utf-8?B?eHpDTGNWTHZnY2trcXEwREFuOHhhY3BXTXgrY3FMVmVlNkorck9jcTBtNmlQ?=
 =?utf-8?B?ZW56WjM0RG1UVkN1OElsMFJLbmhUekovNGtpZmxPdTRxLzdqOGZ6cDVOc253?=
 =?utf-8?B?dzkvWGM2ZEROakVyM3ZDTVlCc2hoUjRKTDhJdmtnSTIrb2kzNGN4Zz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c546a3-8d28-40b3-59ad-08de7a37beb4
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 21:48:17.5761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m7IwcnXcwLKqWEQ76dnw69Rt4y9PggBYn73YopDiWOTQZS78w3s2fISjqv5y9V/0cSI/AGWoP+gMKvRNFy3cVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7856
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C7BC10000B
X-Stat-Signature: ou7rwtzxkpyeit53yfqcctnsqmisag8x
X-HE-Tag: 1772660907-864637
X-HE-Meta: U2FsdGVkX1/YkVJsIRnCl77uUIji9qJERwZMw6gjgFnkHvWIey3fEMT8qQLgdPNLnuotBcAU6VxVOqpPzSkp2i83e1sXXXxXd1HpER6cr9GiZP/hA6h8o1vN9WO6BtK1Td9wwoDYbb/WFst66+B9b2m6kbq7kJPE15Ez8PqYm36vY9WWK+PHiip1YfndbVZCRySrJ2leP7nMe7ok2tQmCTW3R1BxHv3hvfi8NAr1fHl2xAmqx4IQSm1pgln3YHyE2nQj3Rs1b4lfqvKZVCFeanUoUMj7H6FAPl99026w6U7Muu3thp5L70XyYMQN1lk/Ke4rIzSYCb/uq3bD5gUtlUdPu1irpBBBZ9oqt7fLFo4vAMTDiV/W/ulioZPkDAOQ+EpDiwMTP1aHpvInsmBeFqGTgFdGZPAEB3NBuQNWqY5fKJOfoPfHcqYcvMiX9OQOSuKjk+pfPqEE7EWOhuu03iYzAtG6l+zeCUcnKV1jxRQnR1+szOrBIClSAML+JpinzJya3HIAXF7GS0QLYqrsQMBGf/1VrBbQjrmBG1owdY5xUQRW/6O2wrJvaLY8eqAO2KM5sa28xPyYshIt9rrbibGaPhrSF2Gfol0jU2C4twJ0l2OXRkVGfFYSz6Kok/+y6LHuBJxRxbQHDltDsCpyZGb9RB1kxudXvOga+AXuBUgVqkfaEcLbIjdInYh71SRFPdVn36pqj1XTWyaE8Y4AWTfjYP2otdw8Z7ecpwkWD/vIkbPLYO/ORyNGagVwvDXMAHWt/1TlpMVsm+8u6tZHJ58hdZ+Frq1tMLf0wskq87BHAVJFIfGfXVZoGMUJq7zWfk4mgZyJlNLQCUYZpNE5JFPjQpVFNJyqXK2icnOkvCR2xGqHiC4zqaJciuPZCkGgZvcuLXnHIlwotYtE8EZ0OKPGRsiVcKInHNkMMqE3z78gN1F11L6hpddetekM3KNZtjoWi2UBfDqZAqccPWi
 QADlNh68
 QAuxZd1FzT0GzVgmTVkAWH66P9n5qORfaBUfFTTszI997CB7D+ZHQXikRvl5tDtMl/+xHvfcq5OfnNYU/jV8KUR0HlvpZxQF/fdvdbLN5LSmQAMhgWrBrHkR8lwx6KLtY5m6nv1Z8T+eSa89k/9AsyxQLdl8yJCfV1BX2m90W0RH1hoVVo07PXEYS5NSnX8n65dgAkfaBlwPOrT5zBeHpX7jskY5uH3Gm46j/17xEJ6SOnT7Sl2kpchb3IiIZ+8pko9lp/yVH8mP3wUH+7PWsnG+pVGdhOaq/QmCxcOHNlCgYVF0E1UadsykJMypRy9930If0S7S9Oevxl4CRQ5XV6nPZH58tJz2bwXDkwKlhwRSeDZhXFbsBlz4iXW5y2VlTVnLh3v9MJ3i8u62bTFhKbXnEbhN3Jjg6XibYYcr1I+k7dSDTSUyaryK6DtRIjhagrFrxJ4kIcEeZAthPCITuiB1Tntivt6PpvvCj24yjY7hb0gR5OSL+/jJO0GjsHXMfZ0Eh6kbxEgKfJYKOEOG++WUZS73nMlI+KBfGi2NMVtXBzFwNPelT6Va3b1KsPPdJxx4OEcZm8vLzce79SaEjov5EK/uC+fBDsqGs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 02:17, Zi Yan wrote:
> On 4 Mar 2026, at 7:01, Usama Arif wrote:
> 
>> From: Usama Arif <usama.arif@linux.dev>
>>
>> migrate_vma_split_unmapped_folio() takes an extra reference via
>> folio_get() before calling folio_split_unmapped().  On success, the
>> split consumes this reference: __folio_freeze_and_split_unmapped()
>> expects the +1 in its folio_ref_freeze() check, and distributes it
>> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
>> are later balanced by folio_put() calls in __migrate_device_finalize().
>>
>> If folio_split_unmapped() fails (e.g., unexpected pinning returns
>> -EAGAIN), the function returns without calling folio_put().  The extra
>> reference is never released.
>>
>> Add the missing folio_put() on the error path.
>>
>> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
>> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
>> Reported-by: Nico Pache <npache@redhat.com>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  mm/migrate_device.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
>> index 0a8b31939640f..351ecd9065d13 100644
>> --- a/mm/migrate_device.c
>> +++ b/mm/migrate_device.c
>> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>>  	folio_get(folio);
>>  	split_huge_pmd_address(migrate->vma, addr, true);
>>  	ret = folio_split_unmapped(folio, 0);
>> -	if (ret)
>> +	if (ret) {
>> +		folio_put(folio);
>>  		return ret;
>> +	}
>>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
>>  	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>>  	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
>> -- 
>> 2.47.3
> 
> Add Balbir, who wrote the code, to comment on this.
> 

Thanks Zi!

Just wondering if there is a reproducer for the issue and how the fix was tested?
I expect migrate_vma_finalize() to be called for folios, even when split failed and
drop the lock.

Balbir

