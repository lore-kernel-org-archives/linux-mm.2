Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D8BCF8549
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 07:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB876B0005; Thu, 20 Nov 2025 02:08:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC34F6B0006; Thu, 20 Nov 2025 02:08:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98AD06B0008; Thu, 20 Nov 2025 02:08:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87B746B0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:08:44 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1D4A13BA76
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:08:41 +0000 (UTC)
X-FDA: 84130107642.26.E0806BF
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011047.outbound.protection.outlook.com [52.101.52.47])
	by imf23.hostedemail.com (Postfix) with ESMTP id 456F0140004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:08:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=f1btIFPV;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf23.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.52.47 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763622519; a=rsa-sha256;
	cv=pass;
	b=qej+kjXt4XS5c2L6v+It0wVq0PCGVSZak1CugiWchgdqg4C6W4nBvMQxl3yY1+OS/vSpQp
	T6UpePEEmVwZmSx6X+ko8yLfDn94QehFzWX8bKECrBEW0zbcdE0R0Ib/ceDnK80Es3i+vp
	ZX4cf6WkQ9sKT5eKSFUUpx/zkOFIhzI=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=f1btIFPV;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf23.hostedemail.com: domain of Christian.Koenig@amd.com designates 52.101.52.47 as permitted sender) smtp.mailfrom=Christian.Koenig@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763622519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0BqwNh0CMDN4tREUEZSXBR4jlSvz2FIn8iZxWVxqI0g=;
	b=6OUGewtjyoQaVdg6v88g5DaquMzveBcD7OUHOrgBvaEzyRSkAJmnQo//hRxxcCoIbJjW+1
	ZlLNlGLbJa5zIBpz/j6u1oN+zk5GIfbsjn7wxfEzAN7vvBxKFlXbb0zbaVhgB1Rk1SMGA0
	4ovv9WYRYdYNgN5WDNrRIGEE0KAMlKM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mja4SxtEqX8XhF9gnj0pedobt/9sX0qzYMVgFKlyRWDhZKDV1ylwXezS6gasbyTcBGLCtURRq0wqeFT/N8OAbIofRQwnCMdNBtq4QjYXyE5QzwX7EVdwji9DAWH9QW9J4IQ/VDlSwf8TZouA6ZPZfZey1nyzbbFVX7tVJGWOjir5pCUiGhsQn1mJegnu+b0KiKKjkXKsyp8wrjYmGfCilakMQKSxQF24lFJ2MA7TvxLzMTDAXN74w4Ac/07K9y4KfhBNMQ17q2FhEwx8O1CXmpKznRDH81dM1AW0rdiiGpQCZBX+xfSB2+y7JLFo8aXcsqqgbWjllxse6nhXcxmUgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0BqwNh0CMDN4tREUEZSXBR4jlSvz2FIn8iZxWVxqI0g=;
 b=f4GvykrX9LMftlNxpfA9LiPFu1oSPDNdKfwOYW62AfQGlN8DCWWdhn3sMBwC1jtA22WGNK53+TL/607Ov0OKqNyebrwguu3YN/ZlZVgRh3P83QdfSPaAlWEA4/Ph30EcgY7HiDDaEBRWRKni+1Uhmht+HVWjp9gTWvdcTsNkwtzMe1KAw8QP9zsGypu4w1o2x4R5YQgLjK1dqe31qXFtocaW0s01l4wh+neDSGVj0mOw93ZHOh3M1wlf5tKedQ0LKcUJn04+1EwwdZg+SMzUWNxSzJdm5QrtkRYrvzi7UnpLXrNuyC3iWBPQXmcNQB+PeofAtYlHHsK5M/rg5kfHow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BqwNh0CMDN4tREUEZSXBR4jlSvz2FIn8iZxWVxqI0g=;
 b=f1btIFPVyxehKaZYtXYE+WaEt+JmwXfXrgE7VJTQ6TPuQ+9ng9Wl/Mv/v+P2Twk7XZTtnXtb1YMu5FhXDA5C8ToOohHgjD9WFpwxzPLLqGxJttDuYGMDqlWhMblPfewLW56bTb2tENnxi3Xl7yajiRjMQPiAuUYI6qS9Lmm/ekg=
Received: from PH7PR12MB5685.namprd12.prod.outlook.com (2603:10b6:510:13c::22)
 by CH3PR12MB8850.namprd12.prod.outlook.com (2603:10b6:610:167::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Thu, 20 Nov
 2025 07:08:37 +0000
Received: from PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5]) by PH7PR12MB5685.namprd12.prod.outlook.com
 ([fe80::46fb:96f2:7667:7ca5%4]) with mapi id 15.20.9320.021; Thu, 20 Nov 2025
 07:08:36 +0000
Message-ID: <c115432c-b63d-4b99-be18-0bf96398e153@amd.com>
Date: Thu, 20 Nov 2025 08:08:27 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [Linaro-mm-sig] [PATCH v8 06/11] dma-buf: provide phys_vec to
 scatter-gather mapping routine
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
 Logan Gunthorpe <logang@deltatee.com>, Jens Axboe <axboe@kernel.dk>,
 Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>,
 Will Deacon <will@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Sumit Semwal <sumit.semwal@linaro.org>, Kees Cook <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
 Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian
 <kevin.tian@intel.com>, Alex Williamson <alex@shazbot.org>,
 Krishnakant Jaju <kjaju@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org,
 Alex Mastro <amastro@fb.com>, Nicolin Chen <nicolinc@nvidia.com>
References: <20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.com>
 <20251111-dmabuf-vfio-v8-6-fd9aa5df478f@nvidia.com>
 <8a11b605-6ac7-48ac-8f27-22df7072e4ad@amd.com>
 <20251119132511.GK17968@ziepe.ca>
 <69436b2a-108d-4a5a-8025-c94348b74db6@amd.com>
 <20251119193114.GP17968@ziepe.ca>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
In-Reply-To: <20251119193114.GP17968@ziepe.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR4P281CA0178.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b7::6) To PH7PR12MB5685.namprd12.prod.outlook.com
 (2603:10b6:510:13c::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5685:EE_|CH3PR12MB8850:EE_
X-MS-Office365-Filtering-Correlation-Id: 65b461c9-e10f-4c57-ddb4-08de28039fd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SWYyMnpFL2c0aVRnL2Yxdmp4TFpWa0dMYzBtUmFKb0Q1TWNtQ1BFSGFQWm5w?=
 =?utf-8?B?MGNoajBUS0pPdnJMTDZjcVlvVTc3dXpWS0pMbnk2S3NNMlp0TjhXU0ZYK0Rs?=
 =?utf-8?B?NHE2NkZBK0pvOHlNZHh0eWY5a3d5dk0wdlpWTkxwdDFoTDUxckNBcjdMQVl6?=
 =?utf-8?B?MFI1VlVBL2xFRXY5d2dVUW1EdjFBQW01anBmM0FDUWRQbUFMKzl2Vis0R2VN?=
 =?utf-8?B?RjFjcTVSTEsxSWtiTi9lZjdub3YydkhWQ25OSCtadVBIYUExdEFKSjhuNVpp?=
 =?utf-8?B?RTVKdGs1a3hvOEF6N3FHOG12QlpvWDY3MGs3c1Z2dnNTUjBOU3lHTFVEVkRr?=
 =?utf-8?B?enFZa3N5WklNUmlkL1JmemtOV0VkdUFPRmQrbUI5Ym1TQ2hzclFCOXc1cGt2?=
 =?utf-8?B?eHlPS0FWWGhsbUowaEZLRkJkK3k3MHNtZ0JwZXNpZFJ6cGhPVjZrNEdrY3lU?=
 =?utf-8?B?bStlRllqVWJFbDhhSkw5bUVkUVN1cm5zeFdPNDlCU0s5QkpnZkNVTXpuTlNt?=
 =?utf-8?B?RWsydUVaR3Q2Z2d0VVdvUGFwWUYrT1FSY09hOU0xVHNTOUtDUUh3Z3U1R1p0?=
 =?utf-8?B?SURXV0x3VzhWTWVqTllEbFBWQ1o5NU1oczR1SEVUQkJSeXlZWFVpeGJjVHhV?=
 =?utf-8?B?U2MzU001NE56OHlxaWRucUYvWUxpNGVUWm84cDJVS1hwWmcwSzFNRmpNVTVz?=
 =?utf-8?B?U3ZTY3J3MkpXWkdnb0ZMdDA1SndHMCtseU5JY3QrcUtnOURGSGRFK1ltWWRn?=
 =?utf-8?B?VUM5QUxucStMVWpZelNDdXB3WHR6U2RSWlN3dWswNFl4L0g5ZXR5UFQwWjAv?=
 =?utf-8?B?MjNSSEttRWlUWUpKRmdoa1hBNy80ZHZmK3hpaVIxU1ZxTFJqU01qblpqbDVS?=
 =?utf-8?B?dTRXYXA3d2g3Vk5xRC9BYjlnaDd2eGRDSmNZWWE5QU5MTHo4M1VqcU5GbzBs?=
 =?utf-8?B?KzgzMnJTQ1ljVDZweXp1ckloYk0yL3JOT01vLzM5NkpVMTEvcHQyclo5VDdS?=
 =?utf-8?B?VHE4TFJoVnhVdEZ1RWE2aVZTcVpuVEJmd005SXNBNERzaEU0dHJDb0kxSWZ0?=
 =?utf-8?B?L2RIU3pvMFJGbUR3NGt6bi9vZElweTA4b0lZaGtrWkM3LzRva3NiaGRoOG00?=
 =?utf-8?B?bElvOUN2SVJKNmJTR1FrcURjTGR0VXBkTU9SQzkxbnlMbVpnQXdONDMrbmd4?=
 =?utf-8?B?d1lZcWhkampnelpkMVF2K3NjU3ovRFF6R09tSWY1MGV0dE4zQTFOeDZ5WWFQ?=
 =?utf-8?B?UU8yaUtXK0llZ01ncXlpQjk3VnYzVVpPa3hxRm9sNGxKTVEyRm9YYVVaeWN1?=
 =?utf-8?B?U3Boem9IUkFXVVdyeHRNVkh6ZmNIU1I2SFpVSUg4Y1VHaWtMYkJOOWh0aGtl?=
 =?utf-8?B?aTVnZ1ArVlF2M1VleVRCWnA5alpQMmpYMnRtRDMyM3BYYmNzU0JpUmJBZGlF?=
 =?utf-8?B?bW93a2ZVUEpuU3F5dlIrci9SRU8zN1NFRURyaDg3ZFJ0dTVkNlI4MGw1c1U3?=
 =?utf-8?B?LzN4LzkydWZXRVJRd3Z3RWhoY1FDc2tsa0RadjIvcW4rQ2s0VjFHN0Y4MHc0?=
 =?utf-8?B?RzRGMDhTQUttV1d4OHF3RnB5bUZ0KzVLalVLNG5qeUN5QTBNd05LU3FRei9r?=
 =?utf-8?B?NFB5SXBWZFErSkdkVlNsbnF2VERjTVV6ZVYvbHpDalRvOHp0cUx2SWpGM3RK?=
 =?utf-8?B?R3BTTVZQTC8yOEJlN05Mc0xnVEwyOE1lamNoalI5bUFpN3k0b3o1ekw0UExm?=
 =?utf-8?B?TThFc2V6NGxOOVp0SjFwY1l6Vjk1VUk3ZDhMRkFKRytzUEpSS2F6eDEyeW5q?=
 =?utf-8?B?ZTRKVnJXcXRFY2g4MmFwKzRoaXlXRWNJYkswTkd3aERVanFqTVFpRmQ5RHM0?=
 =?utf-8?B?NHZGbE5sQ21Wc0pjU0ZEUkwvc1cxTGF0N2RjRGFSZ3U0VEtaZFowa3BJZG9F?=
 =?utf-8?Q?mVZksCQ2XDqonEV1wvkJaXdVZot5RvHh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5685.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1FXQzBqdmc5ZGZXc3ZIVDErR2JqUTRmdmJVUnlENjhLMVJ5Qkl6MW1seDZU?=
 =?utf-8?B?RG52bTNXdDNCUGZuYStwaUQyeWhEczZMdThBdWRWRSttdnhTNXM1d0xHaFI2?=
 =?utf-8?B?YS8wR2k0eHRadnFrWkcyTEFDM045NjYvVlJNR0dlaENDenRpRHpwankrVXhT?=
 =?utf-8?B?cEpLUE00TXhnSUpnVHV4bHhsRlBObmFLQ0ZRb295TkNJa0VzRmRTRzZRQUZl?=
 =?utf-8?B?RDhLRWxUbldnckM4UjZWTjVHZG44cjBzN3k4RlJBdzFSVVp4b1ZDeWs3T0NX?=
 =?utf-8?B?c2lrMWpyN1grRE04YTNTVXVGK0Z6NFlRdUQ2c2FnUzg1Vi9tV3VMVVo4NU4v?=
 =?utf-8?B?a1VXODNvcWVCSnJSaHFmcG1TRG9XWnFNb3RSN2VBT0FPSHNVRUFXeEVKaWJy?=
 =?utf-8?B?VktDdFFtQTY3SXl2MnJZcnlxZ0xQbitQTEhDSVdsMktrUy9IajB5OHhrdVA5?=
 =?utf-8?B?ZDNQK29GSmIxQmQyWjhER0k1K1RSdWdiNjdLNkE1S00yMFZSWE5rbVprL1Qy?=
 =?utf-8?B?bGI3VGhjUUxsSXRTRmdadmxIUU1tc1VJZnlmSjYzVEFUbkFIZTVTTDNTdHM5?=
 =?utf-8?B?NVI1NEJsaWcyMyt2K2o4NVJpTlFtWU52UVUwbndNVnVidVR2RDhQeFkzMjdN?=
 =?utf-8?B?bmNYQXd5UG94aFE2dnpaM1V1SUtsR2VibFpmWWx2WVlQRTFMZEVLVzVBd2xY?=
 =?utf-8?B?U2w2eEtCVFgyRTRIYXRzZGhUY1RjeTBIZDhlU2xKRzhxbU94YnhDSGY0MWt2?=
 =?utf-8?B?OVpHb0tMVmtOeTVKcytqZjJZRkpXQkcrSisyV2F6c1dUL0NYaVRCcmNTeGFF?=
 =?utf-8?B?VCtwc3ZZRUVLcVlKYWdLY0dOamdhZEFlNnBRNmdMOS8zcnNYMHIrRHlaMVI1?=
 =?utf-8?B?NzRmWFp5aWRyQzlzaVJOWXBzNDlFRWFaQkl4NE13cjNTWVIrd3dINTVVc0Jo?=
 =?utf-8?B?am5qWHc0cEkxWnZQakZxNFl3SkgvcHJkQmhEYUZoWnBhcHlVVkJucXpqUldP?=
 =?utf-8?B?QUovS3pEb3V1VmpFbHcvSkR3OE90cGFqdVZFaEdQandWa3NTS0VFb3pGM1Nw?=
 =?utf-8?B?cGVIQTRUak1WQXNBcVU3QWtCTWx2bzRQUnRyL21EcjlvYnFIU1A2OWFobUND?=
 =?utf-8?B?RENSRWRkMnpsaDdaV0hqdHYvRGlNVzZhaHJocERtdU5TUVRZa0N2WFVqZjhK?=
 =?utf-8?B?Nnl5eVd4Wm5OSWN0aEQ3cnpnbzVxQW84MXNXWm5Xa01USFpHRFV6N2RPaWFn?=
 =?utf-8?B?Qm0zdUs3MUJTSXI4NUd6anNjbGtMNjdTTU9QbHczdWhkaG1mODFteWl4QTAy?=
 =?utf-8?B?VElJZk05Z3NPWEZPL2Y5czBObVR6a2pHK3lRNkk4OHhMMEtxT0RuaFYvZWdz?=
 =?utf-8?B?aytWQVAvZHF1K3luUkhwOWp1bldKSGk5ZEdsVklDdjBHaE1nREZsb3BEMWFJ?=
 =?utf-8?B?Y2d1QlQ5QkNRSElUOFpyKy9mU2FueEw3YlZmVjRlMDRJSFMrT2lTK0tpQU5R?=
 =?utf-8?B?YjFZM2tMZmtHQkc5eUx1MnNIRzNyVTVpTnU3TDdiQ2NlcVZQWHpEa1JaRVFB?=
 =?utf-8?B?R0pjME1HMmFDeVB4ZGhGN0tzUE5KTzc4SDhkUFdpRzNLVjN4a0k3Qi9wT01X?=
 =?utf-8?B?UUxJMkFSdDhjRzUzb0lCQnFaaDhwTFp2aXF2a3NuTjIzL0RrV09ydDl2YkhC?=
 =?utf-8?B?T0lvQStVbmNmYzBiVWFSdGpjZnNiZytWVDYxZmJ2clFuYTA4d3pKejZMY1NG?=
 =?utf-8?B?N0VqWVlkaWRmVEYxdmJ0MlArMXpxTTJnZlBkbmhrR2lDNU45WnRCZkF0Yjh5?=
 =?utf-8?B?NHdqWkJLMkEwd3lNMk51M3pPaDM3d3F1OUY1bXhSZ1hCdVlHeTAydW5SV3JY?=
 =?utf-8?B?WkJ2VW9NRkUyUTNGK1dCOEw5cm56YnhJbjRhT05mSm50WjUvc1BkdFBZbVA4?=
 =?utf-8?B?cTJWNkduN3lkWE52Y1dkMWNSWDBRbjhsQWt4RHlHWmJRZ1pTcWQyTC9HU016?=
 =?utf-8?B?K1cwdW45UUJyREYwNDFiVlBIek9NNUhqOW5XVHQ3UDFBRXdWSHhIRzdLYTdN?=
 =?utf-8?B?VXdqaDNNN3RIaUFzMitKYXc4N3VBaERCSFdyQ2pQR29kWEFSSEhLU08xbm5r?=
 =?utf-8?Q?VEjcGMmJFesxxmX26bIYFI/9W?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65b461c9-e10f-4c57-ddb4-08de28039fd7
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5685.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 07:08:36.7427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nPLTc9lfo7pkt18Hd09ayYMLoygIREgU/2354NRtNPs4Jmxaj/r4/gbluVYsfTJK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8850
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 456F0140004
X-Stat-Signature: jp1jn37kb31mnobsxkro8nzcqff5iy4q
X-Rspam-User: 
X-HE-Tag: 1763622519-739680
X-HE-Meta: U2FsdGVkX18SutPuOPwwMXvhVsbdgVhOlDZ8baJ/zwylheya1r3PQ8WjXetSFvumsb0XqSE8kHe4gvrmaOLgGlzX2B/JP7XR4zDtob7wGRdbgMZ5+jRoU7CDqwzG0UloEa0N3lWIFUFN2Y9OZbseDW+y4JSb6h9t92SKrB0xm/TZEKaOspE8t8DsgeZOmw5MFABifdAEgW4P32L5cfk0Pf4Th4wrcHRzT6SV/FohmtkR2tJmUbF5EnIzlD442swGZdwUoBpPgfu8cUBDZ0h0JfR9wDQo4BuET9f9BR///lmtcg5ibyb12xWVbYN6QKc9By1DECrw9mLX80JoMjqRg6lBbouTuCNYUEbT4i8lhDEO6L1SHYjdhf3sWxB56ilVc6sVpcTHAtWppbXrrFGfkS8BA+kRlIK/M0Mw0HxRLV7BjyBnNdY1m7dJ9Jvn+qr5u5Em0FIuU0xtrjZERG93d1KpAe+p+b44H+9ddIgNFNUkVJhF7hVPgmtj4VQXOnzg6aiT4oWNq+yWc/H0yc1hhMmg+kKBqkd776t+st7w00KvkV7VRiZ0zbZfwU/LKl9ALCVeNTg7johb7pc6jxqxbx77eFf1rz7Xs0AzE0dpVl/XOX/jGqyvl/gEbNdcJr00V6AnqlS0d7KWIHAFW/f/U9+BqHa81Qws+jOgDjYxQumOMjBKb7t4lNxLjtxPy9Q/Y+NhZ5c+EETEOwbUL/uGoKxkKWvAnvhHxVwBp0FINvMcYdOPgACS0ZF/Fvm3OCFwPp28TL47zyyPAdVTJ7NDJF7ZfqF8EpovZCasVPvQ6P8be+9W/aqK34HDWAAvusqFX8DMbBboOB3P8fCBAFxCotUeiFhWNfxqg1H621bYanln9aXpwMuPxlm2CPjka3Rx/9nHudUcVz/+9j7MM5w79RQDjsXgbal+yXo6hERadj+arzmSG4LrYx71h/CCIfGed2XF5A0hCG8ex3yi8lu
 fPH/MYod
 rkIzFyg2xX4gFJDE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/19/25 20:31, Jason Gunthorpe wrote:
> On Wed, Nov 19, 2025 at 02:42:18PM +0100, Christian König wrote:
> 
>>>>> +	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
>>>>> +		dma->state = kzalloc(sizeof(*dma->state), GFP_KERNEL);
>>>>> +		if (!dma->state) {
>>>>> +			ret = -ENOMEM;
>>>>> +			goto err_free_dma;
>>>>> +		}
>>>>> +
>>>>> +		dma_iova_try_alloc(attach->dev, dma->state, 0, size);
>>>>
>>>> Oh, that is a clear no-go for the core DMA-buf code.
>>>>
>>>> It's intentionally up to the exporter how to create the DMA
>>>> addresses the importer can work with.
>>>
>>> I can't fully understand this remark?
>>
>> The exporter should be able to decide if it actually wants to use
>> P2P when the transfer has to go through the host bridge (e.g. when
>> IOMMU/bridge routing bits are enabled).
> 
> Sure, but this is a simplified helper for exporters that don't have
> choices where the memory comes from.

That is extremely questionable as justification to put that in common DMA-buf code.

> I fully expet to see changes to this to support more use cases,
> including the one above. We should do those changes along with users
> making use of them so we can evaluate what works best.

Yeah, exactly that's my concern.

>> But only take that as Acked-by, I would need at least a day (or
>> week) of free time to wrap my head around all the technical details
>> again. And that is something I won't have before January or even
>> later.
> 
> Sure, it is alot, and I think DRM community in general should come up
> to speed on the new DMA API and how we are pushing to see P2P work
> within Linux.
> 
> So thanks, we can take the Acked-by and progress here. Interested
> parties can pick it up from this point when time allows.

Wait a second. After sleeping a night over it I think my initial take that we really should not put that into common DMA-buf code seems to hold true.

This is the use case for VFIO, but I absolutely want to avoid other drivers from re-using this code until be have more experience with that.

So to move forward I now strongly think we should keep that in VFIO until somebody else comes along and needs that helper.

Regards,
Christian.

> 
> We can also have a mini-community call to give a summary/etc on these
> topics.
> 
> Thanks,
> Jason


