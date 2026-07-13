Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D08A4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 22:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74A986B0005; Mon, 13 Jul 2026 18:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5636B0088; Mon, 13 Jul 2026 18:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575706B008A; Mon, 13 Jul 2026 18:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB086B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:24:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B181C019C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:24:23 +0000 (UTC)
X-FDA: 84985183206.08.C910466
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011030.outbound.protection.outlook.com [40.107.208.30])
	by imf01.hostedemail.com (Postfix) with ESMTP id 803AC40008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 22:24:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HKi26FMR;
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.30 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783981460;
	b=0Mkg/JXIHcq3hs+vOuFG67lRFW9jriZPRuMWQzzsRMuMDy14mYjd74sPQ2x6X7lmeZ8c0b
	L5iDcNpKSmqNy9k4i7qz2zI9b/59go/H8kvNbeFAZ+1HTe0USRFtXJnO7QRnDEH4fUIcRU
	+/7x441171YRllsUlrLNIdwSdbyVopY=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=HKi26FMR;
	spf=pass (imf01.hostedemail.com: domain of apopple@nvidia.com designates 40.107.208.30 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783981460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGq0dRQ4sQh9XSL39Fj+SimHcyvcRMCFuPX7Co1ALEI=;
	b=yG1RXhnK01HxqqNioyFBfKwBOl6cSD2qwCfCbBsidss5UmtV07PzFWoIgvJ6VMnZmkbDBa
	VUQ3KJrV9KEueogZw8Gc6j0lPc1PC2Af/lwfQsZ+2BlSIBJNMvBx5jASM9Cy2WRkXPOIid
	q8aXHF+uI9WSf8fP/CnnApm+B9ROYW8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E+MDy085JW+GUSsVTu4u16YKUa/Dmwqw2R+msyOo/H+82/beFN+w1UJ23CNjYe1QTh198F5/3RBuejKJ3EcFLqwEG2Zgcxbq2fmcUrB39tAtSNKtaCklwsuAFM3/LF6x6BOeinuWdJFrUOpIuIcpWEsYfMltKu5eyVj5cTHnB3SQAbttLIWznG4nVxKNY0R/fYcJ8mVbgxn+o9wjNOi/duDfRLKWiMEqqrdDz3qQM68r2bZegYZfx1j34Mt5N0O2kMDArX2ALVWWDVXEpHkMOQ4IXj3yffnslhXAJGJVK6D2LWK/Qyf+UBAjBzJ15L0g4f0MEk+CAlMLAE2CB5OnBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cGq0dRQ4sQh9XSL39Fj+SimHcyvcRMCFuPX7Co1ALEI=;
 b=R/NNHAd6mk7SlCN8u2G/OX7rmoaWmw+4+yAty9EuHgQSD7HJQqH3QkFkxsYitvlkJM+p0ndFKD9h/hEmIOJxwRMXemx295/LVr0EIuUkfxKb8YIASU3+ipchTgF0drUpbnpYOjvwaOzBGfRDYg42n47XJu81AoEg7wiBQPO48uew/OkDLnGIemS/TFt4ZShntAE/9dzkGa4LimAESxuA11n/bBenXpxdppiaPtezDoqWNzEeeLBpRK6Lcz6WMYzVLfsQI8fTVPwf6Ll53kyMrIWIAHYQmfPScUhsDMofWKguR1sq+oJ/GBBen5GuAH73bWhi50EJt/V+p27bPqrvYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGq0dRQ4sQh9XSL39Fj+SimHcyvcRMCFuPX7Co1ALEI=;
 b=HKi26FMRGGbrI4PIOjIOio3kOPdDrOpPRgYvJYKh0Ctt7CuqyowdgkuSqbWt3VAhr5eEwMtwjIH8FdQq4rfu06hbMQDhh/gPFFy2nl5rVWIxgXp8AqecoGd7SGQ12N9HS7K/n78096ovlJMSmHd7Pew+K1mLGjpbKRTP1QL7Dfc5i+8/ntyWc/D26LN1h7SFBs23PYmL+Hzu8kGb2r1c2URoV+bqApvwUoXVyK1aI7oNgeX1qcKAsczKfY8DGd/YvIvwrHE4p8R+woDxgN32YSIyr7Em1h+lYO6v5w+P+tIJ2V5eU9quZAn33izbMmK+T9siXyy8igGbvZ03iOeJ9w==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 DS0PR12MB6560.namprd12.prod.outlook.com (2603:10b6:8:d0::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.20; Mon, 13 Jul 2026 22:24:13 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::5807:8e24:69b0:f6c0%4]) with mapi id 15.21.0202.018; Mon, 13 Jul 2026
 22:24:13 +0000
Date: Tue, 14 Jul 2026 08:24:06 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Balbir Singh <balbirs@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] mm/migrate_device: avoid overflowing migrate_vma
 collection arrays
Message-ID: <alVjyqWiAggf1mTG@nvdebian.thelocal>
References: <b806c878-e1e6-4af9-8816-678955288d82@kernel.org>
 <DJT9JHBIGW8V.17SI5NN5GCJVQ@nvidia.com>
 <DJT9Q4WLXSUG.GHQOMM41P9PZ@nvidia.com>
 <DJUUUX0BK942.1ZP1I5GNIGEY1@nvidia.com>
 <89d20411-4915-43e8-9808-3a7fbd98d2ab@kernel.org>
 <DJV02L9N37X3.1THK8MN9Z2RUR@nvidia.com>
 <a29dae55-93de-416e-9f34-b7911a2c9fdc@kernel.org>
 <A1606A10-AB38-4101-A058-8355E5E81C47@nvidia.com>
 <57cc487b-6ec3-4ca6-8735-f37644e2b0ab@kernel.org>
 <F14401B1-7388-4C5A-A19F-E031002A76CF@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F14401B1-7388-4C5A-A19F-E031002A76CF@nvidia.com>
X-ClientProxiedBy: SY5P282CA0005.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:208::9) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|DS0PR12MB6560:EE_
X-MS-Office365-Filtering-Correlation-Id: 8efb914c-a69b-4861-3393-08dee12d776a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|23010399003|376014|4143699003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	SBRdPSDCulQSi8lb/VfBdTiZ3D5IYbxrsbGYYg8bh3W7FfbVPb4TL5GNNUyIb4E0LyJ1F5HZt4g8RP2RsQIsifWqOMWtJxzGm8HvmtPNz9jEwNrPgNd/64emsYnIm+84OSrjRBwQOD53ahxaTPn+NKBvkFFGLDfb7ZfHlnch5MjzXywe4TjUjf+mSMQ9wR8oE7TA7vzf376/Ruc1GcUzI6Msulan3jXZAyaU6BFwyyCHgM1+3VKCd1+rOuzo491WKdmB4AiaAuAsnmJIRb/zV/b3gN8SAW6FgYWZwra43BbKJunzBuMWQqKMee9CtNQzdYJsKaE71P/xB1eWXhyHPYp1viQsU1ONJNjCcEzMQTFfvg8a2No9cK2UMLHJgtboZ/ieD6k5B4Px0F5d3K56rBfVXcZZcM8wfwGlXEj98Zm6MIo2Gu808lb01nUX0BIKhmiKp0P0wXVHi4/Y5BKdNtd1ML9z88o8QeMV+qiPCkVIg9y/F4zGdplkpP/JPj7zUwaDY81TLPAJAli7nigkMFUWpV23SyMo4DPx/+yvZef8FabxKV4uBQD81c0/5cVe5P0qC1laMxflGOpyFzn8fiwXSjC4rt6Z84/GWjJqWVbr/dfCw6GVlV1xIH20DPCBUjER5wZ+bIbqUaWhpiArGHAV3z9a3lhEzzrPwcfLEdA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(23010399003)(376014)(4143699003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0o4MzArZkU5dWx2YnBwamJkVzZraHBmbXdpK2laRGZMMTgvRmcyVkNjd0E2?=
 =?utf-8?B?WFhuZU1xSENtOFppSEEvL1UzdS83cGdVamo5YS9QL3ErdjJ3Y1daSDBLREdN?=
 =?utf-8?B?bmI4U21wcDBnUCt5ZHRNMkxGeFBpVXRXZzZjNVVGUTdsV2NaTVVlT1NOaGpn?=
 =?utf-8?B?U0ZndHVnY1Vrb3FLM3pTVDlIdVlFNE1ML0NxaEJvMFM5WFRCMHBTN0RFV0ZY?=
 =?utf-8?B?NDZlOXVNOEUxNXNGK0dnYTdPQTROWVFtZ0doR3E3OU81WVc0aksrM3dGeUVG?=
 =?utf-8?B?ZDh2bFRSakc0MjRkRUYxWWpYeHlEM2dKZGtZcktTWVhmVCtWNG1ETHE1SjZC?=
 =?utf-8?B?djVFWGNRQWdhWkxKdnRsM3RPc2hnYzh3S2RYQitZZDNGNWFnaHJwTU1TZGh1?=
 =?utf-8?B?Z0FYMlJIOXNtOTVVVFpWaGszbVRReVNSVVNvbTFiSnREaG0ybGlsSXI3Qkdx?=
 =?utf-8?B?dTFRNFBZSm10bnN2d1FwUHdWVzBtREFkemt1ZzhNalNWS0dwbUZYOU5WTC9v?=
 =?utf-8?B?bUpUZlRQZGFzeWM3aUtuM3dpMDY1Y2Q0ckw1NVlUWm5mYmdNWm1Hd2Zkb051?=
 =?utf-8?B?d29LbWhYYVBjaTk5UXFmV28vb3kwUXhJbDVVSGoxNk1QUVFmZzNRK0ZYcDhU?=
 =?utf-8?B?d2YvQmNGbS8wQmorNzdSVjBOQWhPaWxPeGVnUm9DTUthVWNCd0Z1WmR2bDRI?=
 =?utf-8?B?aXE1ZWtGOVV1cXRuQ1ZDbFZwaG9QMVhRTDk3ZVVIeFlXcjU0V1NtZUlDOVAx?=
 =?utf-8?B?NXlzaXhXanFWUUdTMlJHeWN2VzZkZmEwUTR6eXlPRkxNWnZoTFh1d0xtOHJ1?=
 =?utf-8?B?UkNrRGhSaEJjWWgxQ2tpOWpHSzNmTFNwT2NvZHUzZi9YL1h2WmtTa2RadFZs?=
 =?utf-8?B?SjgxZmUzZmhWTjMrV24rNHRlcWNHaTNMcUZHZHVUZjFmZytiVm1NSUxyQlJ5?=
 =?utf-8?B?VzgzZHViTStqV2lRUW5GZFYvbGZpYUFPbmRQaDNtL2gyTUtZN2UvbTJRMnFH?=
 =?utf-8?B?Mi9mODFlRlFDdGV5aUFaZzhhWXc1b0FNbXF4bTlNTFBtTkQvcitTc2gzcXVo?=
 =?utf-8?B?RkRJY0l2RVhzamlkdDVNUGpuTGVvRWw4TlF5aGJDa1FDN1F3RmJVc29wT1ZL?=
 =?utf-8?B?YUZCZVJUUmlWWmFNOG5kWmFWOGM4ZXpQdm5ZL3Q4dUhsaUwwS2FsRWVJUklC?=
 =?utf-8?B?TFZ4RGFzU1BvcGNacmJDZXNGcVgzS3UxNVRpOU1DZ2RtSmpaQVNVbzFQV3lu?=
 =?utf-8?B?RUMwZU5LY21vcTdxcEdKdHRQTzFGOW1GZ0c1amVXWnZPNzc2R3hBUjJvQUNq?=
 =?utf-8?B?bDFlbWE5a2tST0VuVkg1b09rMEd6d3JuMlVQMG1tLzFua3pTSWRTT2YydHNu?=
 =?utf-8?B?ZzNwWE9hMi82M1F3SEttbUU4aDlvMjBLN1hhWWY3azUza1R1c2wvQXhYei9H?=
 =?utf-8?B?M040dTdXbTJja3A4MEZLaC9seWZ6V3RHSGFOV3ovTlNOdTRhZGZ1U0o5R2dH?=
 =?utf-8?B?bWlLNFhTS2R2WDdWVWwzeTVTZjNuZ3BVbGxxOVJaTkFWVmo1SlZFbWtMWTgv?=
 =?utf-8?B?MkMxdFZ2dk81RnFhNjIrZnNjTFFwdThaQ1U2QW9XRUJqV2N3dUVXVVJNRlNj?=
 =?utf-8?B?dmU5bWRDNk11cU5pMGFIMzQ2eXFvZnVVYmp2MEVJR1NTYldoZnd3L0dkeVds?=
 =?utf-8?B?ekpwMk1oV05uYVdYTFUxelFuNHVBTHM0NVdSTGJ2bGVCSnI3cUpmT1QzVVNy?=
 =?utf-8?B?UnRobDB4TW0waTloYm9QMzlJZW85K3J3aDk5RlNoTTBhOWozay9EZldUV0xj?=
 =?utf-8?B?TTAyNTJrNTZUSjJIUnF3Yi9PTkRyczYwdmFyU1ZhajcweDUvbzBkYVVtdXVD?=
 =?utf-8?B?YzAvNkxnYkFjNHZkNmhYVzB5dnR0ekdTK2V5UUYzSzhOQjBlbHc4Z3U4T2hO?=
 =?utf-8?B?MVpLL050MnZsZFYvc0ViV2UzU1Q0Smo1bTRKenQ3RE4zcEQwTDRZTmJPVUE1?=
 =?utf-8?B?QlRHczBtUUh2SXZuKzZPVDRvOEZvdVV1anNuZDQ1bWIrT2MwVEhycmVNNTl1?=
 =?utf-8?B?bWhPZTBRclNsM053c2RMVmd3K0N3OEFQVStrbnFyb09qMW5QV1NnY1FpS2lY?=
 =?utf-8?B?a25ZV2xxdG1iTks5WHNEa0RQdXdrSm8rUkMvTzliS1grbmIwbGtWNjJlc0Np?=
 =?utf-8?B?N1BKd0laRmV6SXBrRDd4YnA0OG1pSXVjMEdaQkQwZkMxME9SWXlST05YSUVu?=
 =?utf-8?B?ZEJtOVJ1OTcyTHQ1MjZVdCt1aFRqcUFCN1lYdDdBb0wxN3BQeUdpUmN6N2M5?=
 =?utf-8?B?bXRCNjhJYXBHQXdVU2kwU0NVQzl1NFhUVjhONHdJZmpaUVFSd1lsUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8efb914c-a69b-4861-3393-08dee12d776a
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2026 22:24:13.0004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WrTqodY2PeE9obUlQvKsHISQTYq8WVtokEqG4dp+9dDq19q374yF8vWkG+mNx/yZCpiucrzIa1hozyryLL152A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6560
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 803AC40008
X-Stat-Signature: py9wz765rtb4zksiti4gpbwatig8ee3n
X-HE-Tag: 1783981460-383094
X-HE-Meta: U2FsdGVkX18p6ewpvGhCpX7qTob2xzh5Dv4UEYe8TpBz/6rFOn5YWKWosA4OmR0QQjvyq0G4w9syZACPxOweA4vXF+KJfadTGDzIhvCoeOZFU8swlabHsfJSegwsBqRQrQVjLKX7cLcVPXujarr244s06z90qSgmpX/Z4VZa6zPdhqbE/78lmnJgnkGwMoMnGtxJlU5KwbIEdaobqBjvHEVASXMJTc0h8VTnhWlnn1UllxT4FdJ1QeeiW2WWWtqLeIp6iSYwzoriqLdIJE2Jm5TwjfFpHzTwp4/St2dInMlc3YwMoahRXkCpZy36HAUiYb2BOX7QWvRNzkP+qSuwJMckx3msS2pSwSi6vI33RxhT2IeU/kwN5wIWtNmjcAvYM8kxm9tL4himykRcmFMYuLWMoK5xT6YlCQolyYgZdbHWch9oNhDV1W1kS3trdFeflnEgCgP8HsWKnqVWb8Kg9ycD0WAqARBHfissXH14p2Viv01SA8xpJyWcWSP7/km+V4Mk9Z+T6KRsv41UU8Qbh2Ml5Bl38MFp1khNH3zJnhWfIs3DAMERiCiTaX9AXxLMrPQWkWLGI5Tse+yIBPq/6KVbuGGgEl3MysIOe4eAx2IqXPZZrf5ATDKi9t2V0N0p6xhnuMgj2/2Wf1we0hMy6y+08TTawsoH6KwqYYkfsjG2GubpJ4Qon7D/mokqIXNu0rM7KFqXbC+apBoso5GlAxFPJmcx/YFSt+0wHY2C6F1CoGiYX6vu9FChSISDUeJw2bHlKq9UjlXorqr16p4jiHSFDy3c4YEOvTrMloabVre0/kN/7YSMqwwg3i0kesyNtQ7pFJx5z58zWsF8KYRClUbIN2M/zDfpMw2+7CmTfliDdOyxRADaP54UBb643IIfRM+Aq5pgO/e2qAuHrHEGRtWHzRKb9CkiqizLrtF7/ltJyv5gDt+tkK0oVHQbD+SIFdmtP6uXDGfdpZ7P/J0
 pCI5edMW
 PV97LAO5wmBWlFLErFPagUQeymyBwAT67xVhWOH8S0jwXq7g4K66+jdJx0QkW7qlpjxutwpKdy6svvrWFjF4oFsed4fAM/8CQJ0JCialbfyeyZV93fBMEX10/ZE9HMbLTKDYW2wNIX4QCa/QI1IN3f2+I62Vo2O5LhJnUtXaptLquz2VwLXIA4wE+FrYrHSnB3wys0/R1NNh4KoBbJqlEVDMpwu0faP1HZ8IxXNd2/2mjCMnDkPdHp34velNIePhrDIwTQ45shP1BbD7YUfMq1obHi2XzBGUIjnnH6zYZa5+trz0U4cwU//OxNnOSS+p3SVrchoTADsI/yx0R428gtUmDMcp1W3wo+15mw8B3EFVfrp1OJce43ibmz9UanVGkDg3FiI1HwwqRFiZf3kEK2TjdHc7iqEl0GMW+EHWiAW6sgLD28zJKR2uCAjj6ZmdLi0y8ehmyRNA7OpW6G9rtfMMnZszhqlLZs2S8I+8OClml58pSHaclsWzeJEJPNvbNAKVEpuHEKk3pwrZNhzdgYKUTFPeaC/NnA58/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-14 at 01:39 +1000, Zi Yan <ziy@nvidia.com> wrote...
> On 13 Jul 2026, at 11:25, David Hildenbrand (Arm) wrote:
> 
> > On 7/13/26 17:20, Zi Yan wrote:
> >> On 13 Jul 2026, at 8:57, David Hildenbrand (Arm) wrote:
> >>
> >>> On 7/10/26 17:35, Zi Yan wrote:
> >>>>
> >>>> Not all the time. After a folio split and PTE lock is dropped, there are
> >>>> different cases:
> >>>>
> >>>> 1. no page table change, the collection grabs the PTE lock and continues;
> >>>
> >>> Yes.
> >>>
> >>>>
> >>>> 2. some PTE(s) is changed, the same as 1 and the collection continues;
> >>>
> >>> Yes.
> >>>
> >>>>
> >>>> 3. the PMD pointing to the PTE page table is changed to either a leaf
> >>>>    PMD or an invalid PMD, the collection cannot grab the PTE lock to
> >>>>    work on the remaming PTEs, since they are gone. For the collected
> >>>>    PFNs (they are mapped more than once) and folios with elevated
> >>>>    refcount (they are mapped once and unmapped here as an optimization),
> >>>>    they will be processed later in migrate_vma_unmap(). Since
> >>>>    migrate_vma_collect() is best effort, there is no need to revert and
> >>>>    try to recollect from the beginning (to get that possible large
> >>>>    folio or skip).
> >>>
> >>> Yes.
> >>>
> >>>>
> >>>> BTW, recollection will be more feasible if migrate_vma_collect() does
> >>>> not do unmap singly-mapped optimization, since in the case, no PTE is
> >>>> changed, we just need to reset migrate->->cpages and migrate->npages and
> >>>> restart from the beginning.
> >>>>
> >>>>
> >>>> Right. The PTE page table should be gone and the original PMD, pointing
> >>>> to the PTE page table, becomes a leaf PMD or an invalid PMD, since
> >>>> someone changed it when the PTE lock is dropped.
> >>>
> >>> Right, so I guess we'd have to remember how far to rollback, and rollback would
> >>> mean resetting migrate->->cpages and migrate->npages.
> >>
> >> For case 1 and 2, we do not roll back. For case 3, since the PMD is changed,
> >> we just roll back to the start address and set migrate->cpages and migrate->npages
> >> both to 0.
> >
> > Can't we walk multiple PMDs and have data already in there?
> 
> migrate_vma_collect() is the pmd_entry of struct mm_walk_ops, so it only
> walks a single PMD at a time.
> 
> >
> >>>
> >>> And for the entries we rollback, we have to decide whether to folio_put() and
> >>> whether to folio_unlock() [fault_folio != folio]. That's the confusing bit given
> >>> that the code is rather "interesting".
> >>
> >> IMHO, it might be much cleaner to remove the “unmap the mapping if the folio is
> >> only mapped once” optimization, so there is no need to roll back at all.
> >
> > I guess most folios are only mapped once. Do we have any numbers on that?
> 
> I will defer the question to Balbir, Alistair, and Matthew.

Unfortunately previous tests that I've done showed the optimisation is critical
to performance in the common case (ie. singly mapped folios).

I say unfortunately because I have similar feelings to others here about this
code :) I tested this a while ago because I was trying to clean up the collect
step by mostly removing it and replacing it with a hmm_range_fault() type thing,
but the optimisation proved too important due to unmap having to do another
rmap/page table walk.

I don't have the numbers on hand atm, but will recreate them just in case my
recollection is faulty.

 - Alistair

> BTW, for this patch, since there is no bug report on it, we would like to
> fix it properly without worrying about backport, right?
> 
> Best Regards,
> Yan, Zi

