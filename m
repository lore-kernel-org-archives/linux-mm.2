Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A91C8FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223796B009B; Tue, 28 Apr 2026 09:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADA86B009D; Tue, 28 Apr 2026 09:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0754B6B009E; Tue, 28 Apr 2026 09:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E818F6B009B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:20:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C7D3401AE
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:20:51 +0000 (UTC)
X-FDA: 84708024702.16.240B60C
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011025.outbound.protection.outlook.com [40.107.208.25])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3838C18000B
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:20:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sDU45+TG;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777382448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULf2aEphtP5aFcRQzptiCETlcFZuidIZumQZqdD/3MM=;
	b=XrOpZCRqWTHiNhGL05kv32kY9oOIIRymxn0gM8bTjfouilNxiJGYgO42qXWcyhYhDmtzci
	zNO5+ySfOQGk27ACflq38GpnItAHeAGHMG75rrupWzVbDtk2oPyx5USwllBTNeGTf+5Ba4
	x6WQ3O7PkstxcbNkq2hTKzkZQLwiiC8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=sDU45+TG;
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777382448; a=rsa-sha256;
	cv=pass;
	b=6D02e9+CjATjAk6xVMw+g6vVhtydvil3L0o5n7HReH/nGy1S7xr22SPx+Pj/PtBJgyACr6
	KL2r1V/pYvh1IG6ZeartIJWFGiSNLaxi8KTeCbFMa6p9LYANQaKZc+KRoV8+km8fIxKy7W
	W2P4p25DRGJkUUEzzakI0lSFxpOC0Jc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kApnbB7YH8gyT/I59OdSKQ6Y03gvsWWIW6O1YKF5ArDojIvuaTYn8advm/LIdr3eTFuZAv8rsroNKPxR12TTXcOvDp1PG8ffgd1pUOQ3bfaaCACL5AmhFeQVk7i5OzgHyzVyx5vu7+j4EogtxQzp7j9A+C61bKfP3MCrBGudfQeyKF0NxTL2OX55c5of2P6YG/3HUBULl8WUx1PcWqyhQSCF/yf4m8Kwz2Cb6D0BOVwQ3gOxYWXpVZs5xSP0kfqgJ/OsVSBS242DSN1HXYUuHas5SlWKhCQ9UAFSCoyyjjgiUkf57576GqnvFEOYOBnwwpjzAyoYa5j246htwpqmjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ULf2aEphtP5aFcRQzptiCETlcFZuidIZumQZqdD/3MM=;
 b=RTGusWJfgrVutA4XjH3JKZm1foNF4bYQIbimyDhGHFxmY/WqFpOdw1x9Zi5sSQh8c4a9aFt+7oNhm27INZigSWZW55lkKdk6WXI5Lfrs+jYQc+Xf82nRJ7Q9rA9inobhu1MUjYbE3gPcdl7qSCCqiB4GY67jZknZvUZA+oBl3PIY/23nQ+qsprk1JL57vHDR9RALyDhb0T//rdDyr+DVV0weFHHLl9GFhYvrDQUAzHT0H5EPc5/ur9SS5EML1HezFm842aw/ybDEGwSlp3uqtDO+UzMMBDj8pUyjrfilRYMMnoVGCKkEF57D3OUHoaOEkGtc6pHksUp0ATVJt+wI1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ULf2aEphtP5aFcRQzptiCETlcFZuidIZumQZqdD/3MM=;
 b=sDU45+TGMaI8CdoQEda5pAFMUYFzYpdkNUKmEciOJX2x5eUVm4yNzdcTlCMcdCoBOfdbmRv8RITSfLqvMMcB9tw/6SkfAGifT+vBFDJPtLm/6aBgfY6BgjZr9GxKt1qtK/gVVSMAGpWHNgVqtntAGDZktUrrm8vdNuZr+BQky2IXuEgbWtaTM/fCWLQd7fITE1r0MWIJdRvaq5Ulz4de4tQkqrdet6t2ickfeeI+LbqjaBoU+qy/eNnF3P4iYcSpRGtJQJlMxxnRbqItEfhjLZDEVI7rvz9yHAWM26juWKv/XKy2FAoKMMAWxVI2hqhhAB0MpThPMAmboneUb/pEiQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB5925.namprd12.prod.outlook.com (2603:10b6:510:1d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.18; Tue, 28 Apr
 2026 13:20:41 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9870.013; Tue, 28 Apr 2026
 13:20:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: "zhen.ni" <zhen.ni@easystack.cn>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mm/page_owner: add print_mode filter
Date: Tue, 28 Apr 2026 09:20:38 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <CBB2A60B-7491-4D93-89B8-941832DD0478@nvidia.com>
In-Reply-To: <0f9e11c8-743e-45be-8fbc-ea81d7592ae3@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
 <20260419155540.376847-3-zhen.ni@easystack.cn>
 <41EDDEC1-9BAB-447D-AAB0-B8B22289F19C@nvidia.com>
 <0f9e11c8-743e-45be-8fbc-ea81d7592ae3@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN1PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:408:e0::12) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB5925:EE_
X-MS-Office365-Filtering-Correlation-Id: bd7d3629-900a-4fc0-3627-08dea528f1cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|18096099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	6nh5UcVB5HyLljIdC/ZUdkRZIf+a8YkAVCU13Hhhdhr+1t3nwxfpH5kYv+7qrck7ZLwK0oq6mLV2zkHUFD6x7e31l5SDKga4YxgdAD6Ywno3WbdOb4mL8sKzqLYM54LYXa6mAeSFmVGDvdb4BZCefHO9ETA/mtKldjH9ke6nMRrokE5G9b3qD3r3e2yTr1Val/82e8eM+Rg1gy9Dosu8knBSXR0bMC9loBh1BVdRszqssV2JDc2BA90T/w+SHpD+cHblLIv2iCRxOOPkYVU6ghEnwNwBd3wMvGR5YkSurF8lF35kKAEQIow1nf3hnQGj+bq7+OVK+xJ7EvGtZxUVWqHOOFwlqYGiwIC18q9Y4EfuQL20acrIYdBmiyk+/ECp0gYDdA+mWVA9FbbyiNXm87eCX9hpyjBPDYXTOhhy1IL+pU044INEH71ja9mN1NWbjzl2CpbPlthwaIv2Y4/BkTSD7rzitWSjfuE1yodKfpl4jHLeP3046NQiTwdHeifRtXA17lyi9O0zaN42nZdMpeHoKsujLlbbTIsI3zVpSAum+vAZe2tEe3hWl5EFcms8CP2SlP0Am3ptxLeBfRQjpjiRcuSO+OJ7TjOnCNzrO8GOfDOiq/lZNx9n08FrtQi8GswFrmjffKdbkDmEitf/u310oPJk/CdE1yQg3N0CRfW7dekPTOTBxw+a/hzlwQKKNm18XofKaGjXidPGYDP8EzU+9bmULahyhbM9rcBZCIwgW/PuLatzitAJ5aXl9LoL
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(18096099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eFhqbkpHd05iNmFXOVZKVW5xOVdRRFZVUWg3TlZ2VmpWQyt4bGJBL3NpekQx?=
 =?utf-8?B?azhwOU5DZ092Y0tzVzRGZ3lSVi83a2JTYWlmdk15UTh4QW5BUHVnUVRoU2pu?=
 =?utf-8?B?VHJSb1N0S2EwQnRjeEp4bjI3SFlxNlpyQnpzS2RKZ3krUC9DYjVKRmU2VExP?=
 =?utf-8?B?S3VZcU5CQkZNb0xSUlVOcThuUHVKQlBCTCtnamhnOUgzb3dvS09YakxVZ0NY?=
 =?utf-8?B?SmJUN1k5akdCZjYzdFJZZTBpWTA1UUhwUHgxS1F0OUxHRHZpak5CR0lrKzFh?=
 =?utf-8?B?R1czZ3dhb0lLT0V5dDZ5Y3E3eWNEc1lmNnBnc1l6MFM2Ymx4Ui9hcStHalBK?=
 =?utf-8?B?NDBuTzh3em82aklSeEdLRFF3R0tGS1lUK3h5YVNxakY4UDN3bjZqVDJMelFo?=
 =?utf-8?B?QkdqVnIrRVJxR0g0NERWWUdDeGp0NTRkQjBCQ2YvWlllNktMSnF1SWdYbitJ?=
 =?utf-8?B?WUFwZWtiSVBURklyeU83Ujc4V1QyeU9yR1g5RlNIN2l2ZldQdlQzaGlLSlc5?=
 =?utf-8?B?bkNzckdqb0t0MVNHcEZ3RjYyVDAwUi9VTFRTZUZrN3BPeTZiU3VQdFF5ajE4?=
 =?utf-8?B?THN2V24xcVpJdjRpNllZQUE2VGFoNHBFZjgrdHlyRkp5S2FqUFl0MG10Ynli?=
 =?utf-8?B?WlNqQmgyUllFV29mekFsS2Q4Y0Fkak15ZnN5a0NYWTNLMmErVnpwODdST1h1?=
 =?utf-8?B?WSs2Uis2ZkpkZXFqY01DakZOSjJLN0ZSRldnOURwbXV3dU1Yc0VURWRrMFp5?=
 =?utf-8?B?c2tRaFQvQUx5dStDcGVuZ1h5OFZ4Q2o2cmttT3pscC9INkw1aHJQYXNyUVJP?=
 =?utf-8?B?cHYwbHRmSXAyM0xvOXZQaTgxRnkxK1QxOUtKYTM5Z2E4ekZTTWllaTdZSm9v?=
 =?utf-8?B?VCtCa0llQVBGS1VnVDJYSlNsb2RBWDEwMkZNQzJrbFZpZTNnVmZoUEx2UHNv?=
 =?utf-8?B?d0ZlYlJkU3ZYeGZzaitMTnZoYXl0Wm5KcnVWdHdVNGVmM2hEa0JkWVRRcGRZ?=
 =?utf-8?B?TjRUbENjWjBITHp3ZkxBYjV4N2lCZ0hTM1hhUEhsVEhDb2N6VEJCcy9FbzlC?=
 =?utf-8?B?YUdPeEg3UXQ5OVFVd0FwRU9BUWp4SnJJRUlUenUvVFduSlYvdTRTMUNYSjhJ?=
 =?utf-8?B?NUxkL1QxYzlSTzJsMnUvaG0vMGZhQzM3UDNyZDZKT1QrckRHSFZXb25LVTdK?=
 =?utf-8?B?MENLT3JnZVBubUhmdU4vNzh3YldkTVROa2x3WjVNV0Rza0dvUmZRTmd0clRH?=
 =?utf-8?B?aWl5b1pYek5zdzZIbFJXVHpacjNUUGJlVUlXTTVPYzFLTXYwSHk0UTVoTkZQ?=
 =?utf-8?B?NVlVeG93azFjL0dsU2hFakNHRXNGNGxaNVYxSks2cytOMmZ5aE91R0xXZ0xi?=
 =?utf-8?B?WGVWUTZ4QjIwVUdGeTFxVVhCWXgzVENTcGJwZDdTMCtLYkREY21hV1Fsc2M2?=
 =?utf-8?B?UDl2NjQzWU93bEZUd0tmbnU1N2N2YUx6aVZFTUYwVk1tWkdLWkppMUFpZGNT?=
 =?utf-8?B?bjBpbTdFSmQ3Z2NJUUtUd2ZoanBsS2hqMHJiR2x4Mm5lTytuQUMwd2RGMUhT?=
 =?utf-8?B?d090MUdmOU95NTl1SlZ1cXdzNzl0a1pmbHdHYm44YjJvd2dpcFFwM0pIME5T?=
 =?utf-8?B?UU1hVUd0bDhSQmcrdXhwZzhlbGF2S1FEdHFrdHlmUmliWVVaQVZvV3lkenVz?=
 =?utf-8?B?bkUxYmY0Nm1SeHB0MFV5TkZNZ0JiNVFZNjZCOS9NOEN5cFo3NEJrL2FKcWNX?=
 =?utf-8?B?SnZhWHJDN3B6U3VkTnZ6ajljZDFRTkNVcVYvOEx6RUZ2WGp0MS9aUlhCc2Y2?=
 =?utf-8?B?bTVCelJjaW42ZzFaR1hZSTVUWWM5SExXaFhBaGVNMHFoZWRQQUZYNytjTGw2?=
 =?utf-8?B?STZyYTRBYmNGRWlCT2JsVlBSdmZyMjZyRVp4TGhTWlROU0VycG84TXpNUWJY?=
 =?utf-8?B?UFl3dXNEd2pzSzVjNmFTRDA1cUIrczdJdnF6VTF5YlZJYnY0OFNPWDU5T1dY?=
 =?utf-8?B?UGxkYnJUZXpuYWgyYW0vU1hYVmFLNHFpcmFWY25ISU1jNFFkTVdmbXpaNERs?=
 =?utf-8?B?YmZSR1ZKN1c1WjhEejJ5WWpsMDJhRHN4T0kyNHdlQVozbXREeHBCMGRzZ1FS?=
 =?utf-8?B?NzhWNkFQVWdGMzBRTnNYR2xaVU9VczNIdG1HRVpsUkkramlrQzdhVWNNOGla?=
 =?utf-8?B?QWlIWTJlZG9RS0JkWDhrM1J0Vm1MSVV1U0daNWcwQm1BTEtkTVV3M0lBZXdo?=
 =?utf-8?B?bDkzTlBsb0dXeVQvTkFlN3h3WVA3TTV3dlJsQUtoZFl5ZW1XZUdVdjJkRDhk?=
 =?utf-8?Q?oFih6DWPhPQ2q+W4Z5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7d3629-900a-4fc0-3627-08dea528f1cd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2026 13:20:40.8485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xg2TwPLdg7AaGPOgyBHiwtpWeOUaje2VBKA1v1w1MHloJpfW+mWyQAE0wWr29um9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5925
X-Stat-Signature: aj9g6cqmb348rzhm3cy8m9ih5r6ce3qk
X-Rspamd-Queue-Id: 3838C18000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777382447-841012
X-HE-Meta: U2FsdGVkX1+K6cEZAzrXNOsaa77/82CtMZ0jgcDTD726Kx6otQLjIEoy36kasQCAojpEY1gab1puymPlILNYMhAYSHpY0ZXZBsZQMgbsCbxiUVoqF/PN0fuxFUO7qW/wmQopjmyxsRYqAKtOOC0xpww5ZxJFswiD7huxd/+5t0FVZdUsT7qJJ0FiClR6u3n/RvuEqE7/QrbhVUmHEM5L+JrGGyf3apHBhi4RvkLHsW277esCy3O93rKMLvCMKqu7ca9jMgpK+4/UhYMBde8m5VWa2yOGqgmFfOZnx6DXyCGGuT7fvRyQ5nQsXqifaZyJ9aVPiiZg2lXBB3eC7xtTAP6Br5fl13zGA3d5NHH0Xz7kwzjjdzarE3xxhvRisU4zFUKysFEkPT/ctGr83wku1Pl8NDQGupbcilvHma/KJ5OSLRgVkivvJXaM8lb/V/JfkWAxGox9+XXI7nk12vQsuz3T4uPcRTf50ytf/9DiusocyuUt0W4LNUh5YOEHhfY64HkMSUmfeAXaoHGFd+u/4oGwGg+vJ01iuQYTCenEt99Pkt6u10QhRV5EXEd/BYPuEop9LLwlCCTUXU9TsF7xwN+o3KPb+VgMCk6sLD6hS4+dSajb9qiOk7oxJ4jgatttAEgVLMGPgqswoNiC+p8BLo5S9tb0MOJjHIvE77QFS+szbKqcKFbISTfdFZkgI9oJBT20lagiNdzLjoJNAAYw5Lb2qDZRgBN74NQYOaLQHIzEUiLZVJsSQp0ZG/dsZLr1YyyLzNBmFdLVIqGPlV01hNJ8O06IfoJKOEioiBSVgF1eCikB/aW2sbzFEdkkye/NX9zxfuA4daFMbXTLOLOYfXsJ3i/nTR53/rZprQziPKmv763U3yMzNBwmmc8uRS9T0hWdz1A4Uegu39e1nXBtgaldmXjSKgzHG4y7tSTBRe+jJNDchwo0PUN29TfUCNTLCUOawCkXqfuzrzMolnK
 20pgXFiO
 c8SjEcanQaTH/JJ2JGOp2r42u3RL5MBdnEnoweoLkTfTZFGagpi3tnRTSAviFqrJ2MtAfqoFrRJcZz1URoy1Xb6tOAtUXr9jLy9JMZrWlpCLHZHcYyvWMUIkqtDH287Cm66DHhhyC/+jEZUkuxbQqWwMra0lrca7H5ZPklUQhH50jLXc/lXZbUVvuA1xAY9ynOUQXbWDSD/0So6DyueHccI8hoXU+TubmbZ4BJwoRqvRjSdFL+zzoBPRqNpU2h/C50ST8SoqEfjkBk7Hvm7vAnsNVO8dhq2xycdv2rjiJiWUPz7aWQG0yben/ck3QHb7S2UwuYafulBMrkiaA2vKF/sbePRYHZYmuQBO5qWekitI41VO98+Hh3syiQd1Kjn4XqZwnzByYCoHNiB+rI2rff4NKa9Mbg0V0aGCTN8yd4F6pxjejXeLTWBL/JRd5f/y18GHfk7oyB6hW+Iy59nq6LHRfNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Apr 2026, at 23:36, zhen.ni wrote:

> =E5=9C=A8 2026/4/27 23:43, Zi Yan =E5=86=99=E9=81=93:
>> On 19 Apr 2026, at 11:55, Zhen Ni wrote:
>>
>>> Add print_mode functionality to reduce page_owner output size by
>>> printing only the stack handle instead of the full stack trace.
>>>
>>> Example output with print_mode enabled:
>>>    Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
>>>    pid 1, tgid 1 (systemd), ts 349667370 ns
>>>    PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
>>>    Flags 0x33fffe0000004124(referenced|lru|active|private|node=3D3|zone=
=3D0|
>>> lastcpupid=3D0x1ffff)
>>>    handle: 17432583
>>>    Charged to memcg /
>>>
>>> Print mode significantly reduces output size while preserving all
>>> other page allocation information. The correspondence between handles
>>> and stack traces can be obtained through the show_stacks_handles interf=
ace.
>>>
>>> Link: https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@e=
asystack.cn/
>>> Suggested-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
>>> ---
>>>
>>> Changes in v2:
>>> - Renamed from 'compact mode' to 'print_mode' for better clarity
>>> - Use enum values (0=3Dfull_stack, 1=3Dstack_handle) instead of boolean
>>> - Update debugfs filename from 'compact' to 'print_mode'
>>> ---
>>>   mm/page_owner.c | 28 +++++++++++++++++++++++++++-
>>>   1 file changed, 27 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>>> index 5884d883837e..6d87b6948cfa 100644
>>> --- a/mm/page_owner.c
>>> +++ b/mm/page_owner.c
>>> @@ -590,7 +590,13 @@ print_page_owner(char __user *buf, size_t count, u=
nsigned long pfn,
>>>   			migratetype_names[pageblock_mt],
>>>   			&page->flags);
>>>
>>> -	ret +=3D stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>>> +	/* Print mode: full stack or stack handle */
>>> +	if (READ_ONCE(owner_filter.print_mode) =3D=3D PAGE_OWNER_PRINT_STACK_=
HANDLE) {
>>> +		ret +=3D scnprintf(kbuf + ret, count - ret,
>>> +				"handle: %d\n", handle);
>>> +	} else {
>>> +		ret +=3D stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
>>> +	}
>>>   	if (ret >=3D count)
>>>   		goto err;
>>>
>>> @@ -985,6 +991,24 @@ static int page_owner_threshold_set(void *data, u6=
4 val)
>>>   DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_thresh=
old_get,
>>>   			&page_owner_threshold_set, "%llu");
>>>
>>> +static int page_owner_print_mode_get(void *data, u64 *val)
>>> +{
>>> +	*val =3D READ_ONCE(owner_filter.print_mode);
>>> +	return 0;
>>> +}
>>> +
>>> +static int page_owner_print_mode_set(void *data, u64 val)
>>> +{
>>> +	if (val > PAGE_OWNER_PRINT_STACK_HANDLE)
>>> +		return -EINVAL;
>>> +	WRITE_ONCE(owner_filter.print_mode, val);
>>> +	return 0;
>>> +}
>>> +
>>> +DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
>>> +			&page_owner_print_mode_get,
>>> +			&page_owner_print_mode_set, "%lld");
>>> +
>>>
>>>   static int __init pageowner_init(void)
>>>   {
>>> @@ -998,6 +1022,8 @@ static int __init pageowner_init(void)
>>>   	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops=
);
>>>
>>>   	filter_dir =3D debugfs_create_dir("page_owner_filter", NULL);
>>> +	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
>>> +			    &page_owner_print_mode_fops);
>>>
>>>   	dir =3D debugfs_create_dir("page_owner_stacks", NULL);
>>>   	debugfs_create_file("show_stacks", 0400, dir,
>>> --=20
>>> 2.20.1
>>
>> I think it is more user-friendly to use =E2=80=9Cfull_stack=E2=80=9D and=
 =E2=80=9Cstack_handle=E2=80=9D
>> instead of 0 and 1. You can refer to [1] to sysfs_match_string() to
>> do that. I was testing the interface, but needed to look at your code
>> to know which print_mode I am using. ;)
>>
>>
>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/mm/=
huge_memory.c?h=3Dmm-everything#n380
>>
>>
>
> Thanks for the suggestion!
>
> I considered using "full_stack" and "stack_handle" strings, but
> I think the numeric values (0/1) are more concise and easier to type
> for users.

I disagree. It is hard for user to know what the current print mode
is and what available modes are. 0 or 1 is usually for boolean input.

Something like:
[full_stack] stack_handle
full_stack [stack_handle]

is much easier for user to read and use.

>
> The v3 documentation will clarify the meaning:
> - 0 (default): Print full stack traces
> - 1: Print only stack handles
>
> Do you think this is sufficient, or would you still prefer using
> string values instead?
>
>
>> Best Regards,
>> Yan, Zi
>>
>>
> Best regards,
> Zhen


Best Regards,
Yan, Zi

