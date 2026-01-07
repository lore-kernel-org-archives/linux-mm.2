Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 830A7CF6BE2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 03:32:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E93606B0088; Tue,  6 Jan 2026 22:32:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E510A6B0092; Tue,  6 Jan 2026 22:32:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53666B0095; Tue,  6 Jan 2026 22:32:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1F1B6B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 22:32:20 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B8298F4C8
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:32:20 +0000 (UTC)
X-FDA: 84303744840.02.21A90E2
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011071.outbound.protection.outlook.com [40.93.194.71])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6D58BC0003
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:32:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ha+YJfpn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767756737; a=rsa-sha256;
	cv=pass;
	b=6nDLaJ7M1jiNiGFeLfcdxxMsaHukUaSu9Ka80BvSn3hqKvRb3ESWoQXsqLBQ85p9vYg/Tc
	aC9H5Hl8nZqTfiixtlaHDgzC/emIiKL2dt0r83M/FeqdzM4Ls7SGVJLlAi1a6IcaqWjsby
	TTXW8LZA226VxLg/mbpVU4FJHl/dk2w=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ha+YJfpn;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767756737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MvXuHE7IHN77l1khasfj7gbfCLQuzo8+aEeOmzecMUg=;
	b=u3k457wALXM2DIuCwX829pRPYX8lbbiREdm63nWlLvg8PLzdi9P4X65OyYg+bDR2GF5dzB
	A65fQjaab56I0fvK4EoO9QDtGou67A/laSiaAXw4SCaEx8WmPO1eF1BWxWpnAIMNpSUQ6E
	k7uy4DyL7MxJ9DkkYGWXKo+FN0qpXfg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dmZPHv2yvst+bpHsnnJbCY8Rg6JaQUmi2RIKDz+UhddvyfzkODRotPBqjM1yCIY++n8ky38+REWTy4MmPLckWDYTYcyjrIXWp9dWN7RIXZTFCnI9LIuQKkAa6GUg/mEZ5DNydUjXBssMOhcKdzPrYdJQZesPvx9FysyNMK1gJHVGlkOIAvCjeb7g6a1OYWedmcfMGmcH2cwmZ/fXcqpymfQKIzMMgGYBxg7iujQP5yFUFTZPN8B6JYZCSWPedutxS3JG1eJxT4y4HWsoVVBHymW8MYykiIxWsqBi2QiuuZSdAChx6gX+afjcgWYBUh8wAvBYouHL6prOA18Tw428EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MvXuHE7IHN77l1khasfj7gbfCLQuzo8+aEeOmzecMUg=;
 b=IJ7GVWqEPKTz98WAoMCzouV/cRKIVvRdSdO1jWRgl5+IIQBRIC91JNZOcJUki4y3Ah3kRdJA8shhMLuQKL5yXlj824s8w4spa5pNhtnAiHFIHgYoa68FA3qYgcE6FcNZM2ALIgndbPmBG6doxCyVB9LI1aLnApW0YgC2tPrudcVeu9szi22kSW/7MCK4jFmWqqz29mZY/rFZNjubVj/9BgeV9qxDx7jfaqSVJljH9GyINLyk4JTirRyBhTv5+vxPwLFPASsMtZ54WEwmAHCmWmaXRQw+GYSeusxwekUauDWCBC68lQHI1gUBj7btPlSx7DbeyDd4pXe4UvOF/N9wyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MvXuHE7IHN77l1khasfj7gbfCLQuzo8+aEeOmzecMUg=;
 b=ha+YJfpnI7HCFeqaIxViY2ncRtmigNAfAL7JbiDjLJ/cb8LbA8lpmhVSxYtn+nOX8aUs3LXe7yDrWv3gDSGsl/yaBiny+xh73vUhEzJWiVzDGrxtMQkVK7G1ZbBviebOen64qvjfQeaqKQc3mb2gI9gfmVH6eZYyQTrwJ9UDQJE94mEuOW20GpWyqrFMTXq8xd84f/9RopUQFwuPLfKS1f3tHS11BNeznDUPbQSYMJ2GeBsj7uzPxqxw/HOLt3sRNDnha9sqEdfjEuGFthuGMs1f1KNQ+4+uEqvIqnrKm08stkMVRui3c4ATSf4A4EiEQ6RjOAS6PiHfJ74veKNInA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB7665.namprd12.prod.outlook.com (2603:10b6:610:14a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 03:32:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 03:32:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v1 1/2] mm/page_alloc: Optimize free_contig_range()
Date: Tue, 06 Jan 2026 22:32:04 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <700A6B2B-9DD1-4F8D-8A38-17FC8BA2F779@nvidia.com>
In-Reply-To: <280a3945-ff1e-48a5-a51b-6bb479d23819@arm.com>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
 <20260105161741.3952456-2-ryan.roberts@arm.com>
 <A10AC2A5-416C-4820-AF9B-D3B6946E3346@nvidia.com>
 <280a3945-ff1e-48a5-a51b-6bb479d23819@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0P220CA0013.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::20) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB7665:EE_
X-MS-Office365-Filtering-Correlation-Id: a3750145-3194-4413-c938-08de4d9d589f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UjNjWmdxblNWQ1F6a0p6YWVmNXJFVnV6MmVRTGcxWFFlME1nWS9ybzMrVUFZ?=
 =?utf-8?B?cnFpbGpmRU1CRWpZb1RMVGNMemdnZ1cxRVMwdDdDaHBxVlhSTVlwVit3SEtM?=
 =?utf-8?B?UFFJR0owMjhRNms4dXNwYnVOOERLWTd1QXZmMlhmdnpZcmhXM2wrM0R2dDdN?=
 =?utf-8?B?M1dvSlVxMzFDVmVMU2E2MklqTi9sbDhxV0IrK2MzRHp3UTZEVmxaa1BPSGRM?=
 =?utf-8?B?K1g4L1FXUGdpeXJzUDdXeEpPcFA0UnFRQk1LbzV0cVVVUmZPNUlMcG9BanB6?=
 =?utf-8?B?bWQwbXlLbnM1M041S1VSZU1zUEhYZ3hlUm1hUFdMOXpkTkZJYnhFSmdmR1Qx?=
 =?utf-8?B?RWJsTjduM3ZBNVlnZzVLRGtuUlVaQkE0R3FKakp4QmNJemdTQlVNZkkwS1Zz?=
 =?utf-8?B?UTZvbFRIUGovaGIwWjRCYnhPV3kza2E2Y0NQcTNKTytMUXdvYTRUSHErYmZh?=
 =?utf-8?B?MXVDSjJsY2UweGZuaUk3eUtZbWtKS3dwamorTmRCUmFPeDlBd2I3K0QyNGg5?=
 =?utf-8?B?QzlVd0VmNGhRODhBT05hYnN2dXlHRnpkUWdoRXkzYUR1ckgxOGVWU0p6VHNk?=
 =?utf-8?B?MzFrRXh2ODdmak4rVzRXanBrNDBQYzBPWmNaL3JtMVZUeUkvY3ZvMnNUSlF0?=
 =?utf-8?B?OWJzckVDOUgxRFpMQUdGMUhlSGxoTExHU1U4bUdiQ3NJaWxSSkdicStzQ3M3?=
 =?utf-8?B?OTFoU2I2K1lic3hhUmdBZ3FZMTNPVlM0Q0crdVJXek15K0xiN21mVVduYmw1?=
 =?utf-8?B?RTlPbjJ2RHc4dzlqYms2L1cxaitJQThGUC9peVFRS0UvU3FtbThEaFJHK2Qv?=
 =?utf-8?B?NEI2a0tTblI3S1NNOFdYUWZSREJrRGtKZ1pQbU8wc0tkdVZCYXQvTTZNdWZ5?=
 =?utf-8?B?MEVXdStxMnRNbmVNU1N5dmJKTTdSaWNhQVZXQ0Nic3lQMXJhRTFkNWhKYmU5?=
 =?utf-8?B?dk10THZqZ0dLYjZVTmpFZEtIVkljNzZldXJVc1R6UGRtaUl0NzZEOHVncW03?=
 =?utf-8?B?THFXdzUyb1ZqakRod1RwZktRbEc0cnV2TFFpUXBhTWVQcFk3bVJGaGMxd1VO?=
 =?utf-8?B?NWxGM21SNTJ4SnpNTEpmZ0F1SWZwMDNNV2NuTXpTSWJuNGVoVUxKdW85eDJO?=
 =?utf-8?B?b0IxLy9jN0Jub1NhME9sYlZrZjFrSXplS2lrZFBidXdKaGZlUnhLWWZpWERO?=
 =?utf-8?B?enM1TkFWTGIyQ0pMSUx5MXV0eUg0a25KQmJRQnpOaE9FY2Yzb3BLRXkwaGFF?=
 =?utf-8?B?aDcrcVUrS2Vkbmp5NUNaUnVUSnNEQWYrc3JoZDBrR1kwOU03RWIvNTl4M3Uy?=
 =?utf-8?B?R1pjNzdRTXpJSjRIcDJDVHNMdjZmcldzZ0FQdFVnWTg0RjJ3UHJaQ280ai9k?=
 =?utf-8?B?QzVKYVdjNFNiZUM0aVphVkhsM0FKZ1ZxemEyMUkxMUdRZURRdWFTbDZmU2Fw?=
 =?utf-8?B?YUFRNXJMRHFGOUt6eVFBMzhLUU5wRHBLZEVVYjlsY2E3OGV0eDhjc1ZaTU5B?=
 =?utf-8?B?ejFOcGIwNHZxbWlVNUIvM0ZoWUozc2tiTWpiaEZ5T1h5OTV4Sk1tYlZzdGR1?=
 =?utf-8?B?bzRseU1LUXdOTkNzc1RSaTFxS09tOWhNSDJ5UFVmckNMWDFoMlF6ZjIzMm5n?=
 =?utf-8?B?Z3NBTzZFZ2tBQXpwWEptVkZNQWdmMGFPV1laMTg3UkhVNFRGdy9ldTEzaEsw?=
 =?utf-8?B?cnMrVVdLMHdPYmwydlpoYlVZd0EwM29hc3hRUmpNK2VKSnRqaXdaY3lRYXBo?=
 =?utf-8?B?am1kUCtCVFNjWldUVitHc1lXQVErdVZYbEwyZWgzSnE5WEZuQWIyRlpSc3p3?=
 =?utf-8?B?b203MHhRZE5lWWk1UDZDTjRpK2JwQStOUmZuKzR5cGZBMWorZDFZTC9zSS83?=
 =?utf-8?B?cHc5bEo3bElBNzdSQmxuR3lMRDlxYzJMZ3RWbzB6Mmhzc3YydzVQNE13NHly?=
 =?utf-8?Q?Nj58yudEdfUlJAjRRG4BHOLmRTrgyUc7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0RJaEVveHB4QkorWWppYk02cWFYODVzOXE1UGl2MkVhTHNiOUNsZlZqK1Ry?=
 =?utf-8?B?dXB2SG44SnlCeVQ1MDI1aVkxRkMxQXZnSVkrMGtwU252UnRTdmZCWTMvQkI3?=
 =?utf-8?B?WHlFdlBwMDBsM2NSbFpvczJtcm9MT0FKTVZwQ1BsQUNkZzhqOUpwSUtsLzFh?=
 =?utf-8?B?NHFxaWV4MGljT3NTNTIza2FPNys3OWtHVDh5TFIrMmszY1ROZnN1VEFqZk10?=
 =?utf-8?B?ODVieXJWVDdWVUJIUGRWMlJwWGNYSmhJL3R0UFZVVFRGdzhqWVNqQ2ZsTGFU?=
 =?utf-8?B?NFcwNXV5Q0RBeWNsNTlBV0Nqa0cxcm5yM3k5cVFud0V0czVyOGRvSnUzckha?=
 =?utf-8?B?VUw2dktZZ21xc21ibXZZOW5JR3A5dFdTVDlLbXpWbENPSDV0d05ZYWgvZjc4?=
 =?utf-8?B?T21uRjNzZU1OZ00zK0c5R093UE5NbmRlMEN0MCtlMldrUlNuVkdSeGIxaGFD?=
 =?utf-8?B?b1lIWkF2QjFvc1pqYzR6djFWQjVXa1dGZS9QdFJ4K3NRVXpxVXFuMFVsdjcx?=
 =?utf-8?B?TmZJSXdGRGpkbi92OTFIUThPOGpWZ3VsRXdrdzFZQnJRVHlPYkZlK3dEQXdp?=
 =?utf-8?B?SzFkd1REZVhHYnNNVnZaVlR3cDh4MUFuZTFQSjZkUzQrenNjUTdXT3lVUHA4?=
 =?utf-8?B?OGVIeEpYalFqblNtaDc4SFZ5ZUZrbGQrWmlIeHB4WG5pcWpsZW9UVldyNWFH?=
 =?utf-8?B?bndzYStJcFpPZnJsOEVFcCtEQkJERklsbGM2SXY1MUV1QnhjbDFTT2hCN0ds?=
 =?utf-8?B?cyswTzhTSEhRS1lycllnd25BTFE2VEhQb1c1SzFocmkySXFjS2V6WG1PV0FU?=
 =?utf-8?B?aDBpNStHS2YxcjNlTk5FTEdYa0lhbmRFaFUxeHpMRVRGUVVJdlE2cFhGMmh6?=
 =?utf-8?B?djNaNlpHcGk3V0xucVFROWZnK3VxbmJoM2dySlhydk4wSUJUZU80bUp0OFJG?=
 =?utf-8?B?VkxReFdoOWdneXhmZWVQbnE4UHJZMldPUklqT3NJSzA3elhpellkNi9FUjVS?=
 =?utf-8?B?TEk2OVJLZiticXU2SWVSZXluWUFVdFdScVo1VnVMSkUzSkc0Y3V3MzN3OTJi?=
 =?utf-8?B?Z0lkSXV4UHM3TWlRajBmNEZna1ZXMHR6QlZIczZsamlEVy9XL2JqTzRpVGxa?=
 =?utf-8?B?R0xmMUpxc08rNVNPdGtzZmJuSDltby9NL0ZCa3FYS2Z2VFNSMkhhN292OHJO?=
 =?utf-8?B?RXVubjRHbW11RkhoYjR6bEM0Z3R4bi95c2x6czNPdW5zdEgyZ2ZQTENodDdq?=
 =?utf-8?B?aVhNVkZuTEhpZmc2TXRMaTdCZGlmQ0NlejE5Y1Bta0lmZCtNWHJKNFgrRWMz?=
 =?utf-8?B?ckZWLzhmcFV6ZjF3eG03eTU5N01JWUVrYzhSakxVL0l4S0l1bjBmVE54VC9Z?=
 =?utf-8?B?MXQxQ3FZNGo5a0c5N3g1TUlxTmVINDMxUGtrM0lDL010VTlKYWc4WXdGS0lQ?=
 =?utf-8?B?Z1ozaVl1OHNiZEtwZUtvbUE4Q1dpT3lTWGhqVjk5bmhTNWx6V2NydGp0Y240?=
 =?utf-8?B?VldQU3JManBVTlJmYUtWdWpwcjhHbHp5V2Z3RzhXdytJYSsyMVJvZEgydFh4?=
 =?utf-8?B?eXFIbU42bDF4V1N1LzEzWFlvaFhlRGdxbXBFMXpuUEtESU5BYnVaZUMyZ25t?=
 =?utf-8?B?TnlHOUgzVi9jZ1pVSzRCSzc5WGVhckFmT0w4MXJvdm5BSHVybHhaWTFsSzRY?=
 =?utf-8?B?WHRBclUvVFdla0ZYVEdpZjZLbkN3SlBnUW1KNjBzZFBNaWNrSnBTV0JrL2Fo?=
 =?utf-8?B?ZmRiR3JGZDlBaWE4NCtjd3Zza1FTSFdaR0hhMHpzOTdmUnkxNDNMWHpBcXhU?=
 =?utf-8?B?cTl3alF1UU1iY1QzL2E1Tm1VeGZFNUtEK0Fyc2VPcnU4L0RyQlhDLzRCMy8w?=
 =?utf-8?B?VXFhL29NZHdDR1JnN085MlRKWlRHclBuR0lqWFIwQVhUSEUxaVIrTXNGaGZa?=
 =?utf-8?B?Q1hJZU5NVU5vWDUrc2hmTmhEckpCRVN4Y3kza3ZOd244NCtjaEQ2ejAyQXdK?=
 =?utf-8?B?QUpCM2N0YnN6TjdJSHNPc01YcEJUY204ZTFOZmNPUlQyajZQT05tbjZzWDZ6?=
 =?utf-8?B?YWRPTnNBUzkyZzdqQ2ZtdHlOdmlsc0o0MmttQ3VWRVlrNGphUzByTFdzTG9w?=
 =?utf-8?B?cURnN2l0VzhyNSt0UTJwdXNpMzNYYzFQcm0vTlZiZHJUQUZqVGF5VnJtNnda?=
 =?utf-8?B?QXM4RkE4N3dscEhMRXNpVDFFOHZkdE9PSXgvSEZCYUZzbkdCZ3hzVFYwc3pi?=
 =?utf-8?B?UU9XcDcwQTVIaDJSend1bE5mcXYzSUJPVVNVTXZYaUw2TldiRXZjanJCUWY1?=
 =?utf-8?Q?rtt8iPVHQG1eq16cVg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3750145-3194-4413-c938-08de4d9d589f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 03:32:12.7705
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z/yC8z+/wd18huQFLCD4X9ieWjcH+S6fZWvTUcutBSIjtWAYjEng70otoFz2XnWX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7665
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6D58BC0003
X-Stat-Signature: 4afpd4amg6rqhhkft39oc9nb1dg1bhzm
X-Rspam-User: 
X-HE-Tag: 1767756737-177507
X-HE-Meta: U2FsdGVkX1+pVAInSLtJ94hGz6imqta5oMFqmrJwuaQvFNfIyRBvjFVUusGh+Z01ubdXKFkfYRiNjoKASZHrMCOIppleKbPdaOuBSms6MyEWifI1hgtwb8GeSVnb7nGToxyCVCuq6rVf9UoTiilH1hVjYJMxLmyDOWGXt1r8w7Db/WossEAxvpIm56P47wVpqQHpYywdeVrG+WYEHiuG5x+pktZj4/oCQcU3QFPeA3xd7leeZcR+4wdF7xPz1gsgjAKAbKJErgHaOXGC0mAWa76WBSV9nokLceih+9P2NcEqorEcH3qyw/fenT8zsvrf8gbdJHR8cg5haPueo+zAljH/LSNCM/EnWF3e0Dny8N506jy6Ld7GRoymxnyYgs5sOgzvwsK1m+Rf23CH6dzDSCTPuEE7kh2YdCwiE5K5ab4cRzJtKkP10baQzOf4NbFDyrsbgtezyGwyAvyqwiIRgDr5bTo3LkALLMn/FG1I2NeZh/TWoaulm4kgNVGoc0u0B9u1E6b3qWTQZmDsegPhnDzKQMn/V/WycsggO5WkmlnpO4LFHh14PAjhGEMS5htxUdcEsKuIw+esceEICVOIePTuFR7ZDpcfhMUeIFvBQAh0FViG7I/mVRMcNH7tGbTnjAEVWXTatUsL/5RKUxdgah8h1h2SZOOgEnnwuHsltMPQKTLCO9YSUuhqHwKcPUw494VL2i3VWTB0c+B+18oJDCOy/gBZJXkPj68AT3oTs+9zejVOiZLPZI3UqkHeEn399j5rl+ZVHHM8/qGwN+BzK8sVND0okn+VJFp+OYCrjE/0403sJv72eGX0TxjsfvKOeP1Ux70h45AnWurNxTfICl6ag7vqewNz95YSDc894TBRkmoaMn0lsQzwh3IYIO0/gJL2uTwOdqRyL/Xy7fqaPusV6khQno9cAzCObOdXqCpMLaWw2QT4/KKx+oEC2hA/VebA6dCDMn0CcMbEa0d
 W52uVw/+
 PWeSQCU+bzLm4NZLCxIxg0pXaVwzxNLAfcEYIVpOMMT9EgmDJzrzbA4GYgxdzCLZUGUsyfXFrfatkrT2TBj7UH1V1UDYlZZnUazNdx1YI8X8I5zClueyupBfVUqqcj78ZMhFh8zs3peIfbnJOqsE9Jx8fiuqQ6NllEBkCABppSaa5qyzC818t7bwf3Cs7kMQLAFe80NSp71V0P0+NWPVePex1yd6kBb7Uqp1didGlKO182HT2wHY5fEeGRiXNqTrHrcVvD1E9s4VvD54dFhp4uNHIFSELaka8v0gFLoIZqDVl0fgEczze1T5VcCJN/JgLVL4Wz4h2pF/UShOkHXTpzhEi03k81oO5CQTdBjJSc7eSdOzrlj3CsvhmDR4Fh1YHXTdnWUuTLzlCpW6qsofoUutF8cXCk2HuihPYpR1vU4OaYRZRDigkNRDleDepJYr0mlqz+kVeysPsyBSBR8JOJdP6KYSTJBKInm4iKeizTiVsGg3qv3KOHJKmp4tAXslAraFT7sf6cmm8T8luIluVuj9YXbe6y5+Ys6roOdx/XmCgt90=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Jan 2026, at 12:31, Ryan Roberts wrote:

> On 05/01/2026 17:15, Zi Yan wrote:
>> On 5 Jan 2026, at 11:17, Ryan Roberts wrote:
>>
>>> Decompose the range of order-0 pages to be freed into the set of larges=
t
>>> possible power-of-2 size and aligned chunks and free them to the pcp or
>>> buddy. This improves on the previous approach which freed each order-0
>>> page individually in a loop. Testing shows performance to be improved b=
y
>>> more than 10x in some cases.
>>>
>>> Since each page is order-0, we must decrement each page's reference
>>> count individually and only consider the page for freeing as part of a
>>> high order chunk if the reference count goes to zero. Additionally
>>> free_pages_prepare() must be called for each individual order-0 page
>>> too, so that the struct page state and global accounting state can be
>>> appropriately managed. But once this is done, the resulting high order
>>> chunks can be freed as a unit to the pcp or buddy.
>>>
>>> This significiantly speeds up the free operation but also has the side
>>> benefit that high order blocks are added to the pcp instead of each pag=
e
>>> ending up on the pcp order-0 list; memory remains more readily availabl=
e
>>> in high orders.
>>>
>>> vmalloc will shortly become a user of this new optimized
>>> free_contig_range() since it agressively allocates high order
>>> non-compound pages, but then calls split_page() to end up with
>>> contiguous order-0 pages. These can now be freed much more efficiently.
>>>
>>> The execution time of the following function was measured in a VM on an
>>> Apple M2 system:
>>>
>>> static int page_alloc_high_ordr_test(void)
>>> {
>>> 	unsigned int order =3D HPAGE_PMD_ORDER;
>>> 	struct page *page;
>>> 	int i;
>>>
>>> 	for (i =3D 0; i < 100000; i++) {
>>> 		page =3D alloc_pages(GFP_KERNEL, order);
>>> 		if (!page)
>>> 			return -1;
>>> 		split_page(page, order);
>>> 		free_contig_range(page_to_pfn(page), 1UL << order);
>>> 	}
>>>
>>> 	return 0;
>>> }
>>>
>>> Execution time before: 1684366 usec
>>> Execution time after:   136216 usec
>>>
>>> Perf trace before:
>>>
>>>     60.93%     0.00%  kthreadd     [kernel.kallsyms]      [k] ret_from_=
fork
>>>             |
>>>             ---ret_from_fork
>>>                kthread
>>>                0xffffbba283e63980
>>>                |
>>>                |--60.01%--0xffffbba283e636dc
>>>                |          |
>>>                |          |--58.57%--free_contig_range
>>>                |          |          |
>>>                |          |          |--57.19%--___free_pages
>>>                |          |          |          |
>>>                |          |          |          |--46.65%--__free_froze=
n_pages
>>>                |          |          |          |          |
>>>                |          |          |          |          |--28.08%--f=
ree_pcppages_bulk
>>>                |          |          |          |          |
>>>                |          |          |          |           --12.05%--f=
ree_frozen_page_commit.constprop.0
>>>                |          |          |          |
>>>                |          |          |          |--5.10%--__get_pfnbloc=
k_flags_mask.isra.0
>>>                |          |          |          |
>>>                |          |          |          |--1.13%--_raw_spin_unl=
ock
>>>                |          |          |          |
>>>                |          |          |          |--0.78%--free_frozen_p=
age_commit.constprop.0
>>>                |          |          |          |
>>>                |          |          |           --0.75%--_raw_spin_try=
lock
>>>                |          |          |
>>>                |          |           --0.95%--__free_frozen_pages
>>>                |          |
>>>                |           --1.44%--___free_pages
>>>                |
>>>                 --0.78%--0xffffbba283e636c0
>>>                           split_page
>>>
>>> Perf trace after:
>>>
>>>     10.62%     0.00%  kthreadd     [kernel.kallsyms]  [k] ret_from_fork
>>>             |
>>>             ---ret_from_fork
>>>                kthread
>>>                0xffffbbd55ef74980
>>>                |
>>>                |--8.74%--0xffffbbd55ef746dc
>>>                |          free_contig_range
>>>                |          |
>>>                |           --8.72%--__free_contig_range
>>>                |
>>>                 --1.56%--0xffffbbd55ef746c0
>>>                           |
>>>                            --1.54%--split_page
>>>
>>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>>> ---
>>>  include/linux/gfp.h |   1 +
>>>  mm/page_alloc.c     | 116 +++++++++++++++++++++++++++++++++++++++-----
>>>  2 files changed, 106 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
>>> index b155929af5b1..3ed0bef34d0c 100644
>>> --- a/include/linux/gfp.h
>>> +++ b/include/linux/gfp.h
>>> @@ -439,6 +439,7 @@ extern struct page *alloc_contig_pages_noprof(unsig=
ned long nr_pages, gfp_t gfp_
>>>  #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_nopro=
f(__VA_ARGS__))
>>>
>>>  #endif
>>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_=
pages);
>>>  void free_contig_range(unsigned long pfn, unsigned long nr_pages);
>>>
>>>  #ifdef CONFIG_CONTIG_ALLOC
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index a045d728ae0f..1015c8edf8a4 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -91,6 +91,9 @@ typedef int __bitwise fpi_t;
>>>  /* Free the page without taking locks. Rely on trylock only. */
>>>  #define FPI_TRYLOCK		((__force fpi_t)BIT(2))
>>>
>>> +/* free_pages_prepare() has already been called for page(s) being free=
d. */
>>> +#define FPI_PREPARED		((__force fpi_t)BIT(3))
>>> +
>>>  /* prevent >1 _updater_ of zone percpu pageset ->high and ->batch fiel=
ds */
>>>  static DEFINE_MUTEX(pcp_batch_high_lock);
>>>  #define MIN_PERCPU_PAGELIST_HIGH_FRACTION (8)
>>> @@ -1582,8 +1585,12 @@ static void __free_pages_ok(struct page *page, u=
nsigned int order,
>>>  	unsigned long pfn =3D page_to_pfn(page);
>>>  	struct zone *zone =3D page_zone(page);
>>>
>>> -	if (free_pages_prepare(page, order))
>>> -		free_one_page(zone, page, pfn, order, fpi_flags);
>>> +	if (!(fpi_flags & FPI_PREPARED)) {
>>> +		if (!free_pages_prepare(page, order))
>>> +			return;
>>> +	}
>>> +
>>> +	free_one_page(zone, page, pfn, order, fpi_flags);
>>>  }
>>>
>>>  void __meminit __free_pages_core(struct page *page, unsigned int order=
,
>>> @@ -2943,8 +2950,10 @@ static void __free_frozen_pages(struct page *pag=
e, unsigned int order,
>>>  		return;
>>>  	}
>>>
>>> -	if (!free_pages_prepare(page, order))
>>> -		return;
>>> +	if (!(fpi_flags & FPI_PREPARED)) {
>>> +		if (!free_pages_prepare(page, order))
>>> +			return;
>>> +	}
>>>
>>>  	/*
>>>  	 * We only track unmovable, reclaimable and movable on pcp lists.
>>> @@ -7250,9 +7259,99 @@ struct page *alloc_contig_pages_noprof(unsigned =
long nr_pages, gfp_t gfp_mask,
>>>  }
>>>  #endif /* CONFIG_CONTIG_ALLOC */
>>>
>>> +static void free_prepared_contig_range(struct page *page,
>>> +				       unsigned long nr_pages)
>>> +{
>>> +	while (nr_pages) {
>>> +		unsigned int fit_order, align_order, order;
>>> +		unsigned long pfn;
>>> +
>>> +		/*
>>> +		 * Find the largest aligned power-of-2 number of pages that
>>> +		 * starts at the current page, does not exceed nr_pages and is
>>> +		 * less than or equal to pageblock_order.
>>> +		 */
>>> +		pfn =3D page_to_pfn(page);
>>> +		fit_order =3D ilog2(nr_pages);
>>> +		align_order =3D pfn ? __ffs(pfn) : fit_order;
>>> +		order =3D min3(fit_order, align_order, pageblock_order);
>>> +
>>> +		/*
>>> +		 * Free the chunk as a single block. Our caller has already
>>> +		 * called free_pages_prepare() for each order-0 page.
>>> +		 */
>>> +		__free_frozen_pages(page, order, FPI_PREPARED);
>>> +
>>> +		page +=3D 1UL << order;
>>> +		nr_pages -=3D 1UL << order;
>>> +	}
>>> +}
>>> +
>>> +/**
>>> + * __free_contig_range - Free contiguous range of order-0 pages.
>>> + * @pfn: Page frame number of the first page in the range.
>>> + * @nr_pages: Number of pages to free.
>>> + *
>>> + * For each order-0 struct page in the physically contiguous range, pu=
t a
>>> + * reference. Free any page who's reference count falls to zero. The
>>> + * implementation is functionally equivalent to, but significantly fas=
ter than
>>> + * calling __free_page() for each struct page in a loop.
>>> + *
>>> + * Memory allocated with alloc_pages(order>=3D1) then subsequently spl=
it to
>>> + * order-0 with split_page() is an example of appropriate contiguous p=
ages that
>>> + * can be freed with this API.
>>> + *
>>> + * Returns the number of pages which were not freed, because their ref=
erence
>>> + * count did not fall to zero.
>>> + *
>>> + * Context: May be called in interrupt context or while holding a norm=
al
>>> + * spinlock, but not in NMI context or while holding a raw spinlock.
>>> + */
>>> +unsigned long __free_contig_range(unsigned long pfn, unsigned long nr_=
pages)
>>> +{
>>> +	struct page *page =3D pfn_to_page(pfn);
>>> +	unsigned long not_freed =3D 0;
>>> +	struct page *start =3D NULL;
>>> +	unsigned long i;
>>> +	bool can_free;
>>> +
>>> +	/*
>>> +	 * Chunk the range into contiguous runs of pages for which the refcou=
nt
>>> +	 * went to zero and for which free_pages_prepare() succeeded. If
>>> +	 * free_pages_prepare() fails we consider the page to have been freed
>>> +	 * deliberately leak it.
>>> +	 *
>>> +	 * Code assumes contiguous PFNs have contiguous struct pages, but not
>>> +	 * vice versa.
>>> +	 */
>>> +	for (i =3D 0; i < nr_pages; i++, page++) {
>>> +		VM_BUG_ON_PAGE(PageHead(page), page);
>>> +		VM_BUG_ON_PAGE(PageTail(page), page);
>>> +
>>> +		can_free =3D put_page_testzero(page);
>>> +		if (!can_free)
>>> +			not_freed++;
>>> +		else if (!free_pages_prepare(page, 0))
>>> +			can_free =3D false;
>>
>> I understand you use free_pages_prepare() here to catch early failures.
>> I wonder if we could let __free_frozen_pages() handle the failure of
>> non-compound >0 order pages instead of a new FPI flag.
>
> I'm not sure I follow. You would still need to provide a flag to
> __free_frozen_pages() to tell it "this is a set of order-0 pages". Otherw=
ise it
> will treat it as a non-compound high order page, which would be wrong;
> free_pages_prepare() would only be called for the head page (with the ord=
er
> passed in) and that won't do the right thing.
>
> I guess you could pass the flag all the way to free_pages_prepare() then =
it
> could be modified to do the right thing for contiguous order-0 pages; tha=
t would
> probably ultimately be more efficient then calling free_pages_prepare() f=
or
> every order-0 page. Is that what you are suggesting?

Yes. I mistakenly mixed up non-compound high order page and a set of order-=
0
pages. There is alloc_pages_bulk() to get a list of order-0 pages, but
free_pages_bulk() does not exist. Maybe that is what we need here?
Using __free_frozen_pages() for a set of order-0 pages looks like a
shoehorning. I admit that adding free_pages_bulk() with maximal code
reuse and a good interface will take some effort, so it probably is a long
term goal. free_pages_bulk() is also slightly different from what you
want to do, since, if it uses same interface as alloc_pages_bulk(),
it will need to accept a page array instead of page + order.

I am not suggesting you should do this, but just think out loud.

>
>>
>> Looking at free_pages_prepare(), three cases would cause failures:
>> 1. PageHWPoison(page): the code excludes >0 order pages, so it needs
>>    to be fixed. BTW, Jiaqi Yan has a series trying to tackle it[1].
>>
>> 2. uncleared PageNetpp(page): probably need to check every individual
>>    page of this >0 order page and call bad_page() for any violator.
>>
>> 3. bad free page: probably need to do it for individual page as well.
>
> It's not just handling the failures, it's accounting; e.g.
> __memcg_kmem_uncharge_page().

Got it. Another idea comes to mind.

Is it doable to
1) use put_page_testzero() to bring all pages=E2=80=99 refs to 0,
2) unsplit/merge these contiguous order-0 pages back to non-compound
   high order pages,
3) free unsplit/merged pages with __free_frozen_pages()?

Since your example is 1) allocate a non compound high order page,
2) split_page(). The above approach is doing the reverse steps.
Does your example represent the actual use cases?


Best Regards,
Yan, Zi

