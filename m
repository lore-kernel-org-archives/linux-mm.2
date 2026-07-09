Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C41D2C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 01:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1471B6B0093; Wed,  8 Jul 2026 21:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11FC56B0095; Wed,  8 Jul 2026 21:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02346B0096; Wed,  8 Jul 2026 21:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8B996B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 21:52:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E0528D445
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 01:52:43 +0000 (UTC)
X-FDA: 84967564206.19.196C959
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011054.outbound.protection.outlook.com [40.107.208.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id D788340007;
	Thu,  9 Jul 2026 01:52:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g1wNoIWT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783561960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgmsIUewvtgaZUDi1JMSdecE8z2jvCAGnPZP1YDwjOg=;
	b=iGugAocd2+RGEH+SHoISVwKO1KuFf2xOJJuXfTqNIWHhWCCxsMlbUOXx96rqVnvRVJCFTA
	+gsCyFfPg/uNWRt/wktB8lGcsc62VYhIYx7PkbrIGkT5hzGqJXq4zIWfEPTF6rCWu0Z2rB
	fLlT9vniAOXN/AmfURBY/f7rGJP8dcM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=g1wNoIWT;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783561960;
	b=yEG9xe7Re5L8joKrBkZlvCO2CcRpEm8M3gc4E5Q0XGVuR1+543gfJ8t6bwCMpmgE9dUdOW
	C9eLxqA3kc5x13Yg0ByF3RxtwOZDq0E72TCwC3tNq2kz62tfyv+dJFF3Tm1sYesV+0OjyK
	0cA7RFGFIy0qxrSkfFFJ7cT6ElvwZTY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cjp8xPN3RUM5OddQSmxigJbi+D9CHmDgyVuA6D5RiiyGfSw/+x0Edd5zsYREEB8jTwNClG4TMOFxdQkfssfaENZIDPOsstqQTsORb4jr/HAXH/H9F3tfRR2fUKsdI45VNGFSIYyhUEV/XwHEDaRDLBjd24U8KB9vaPFU0VMP8ImgM6Bi8tlaXJM0+cILzXUpGKeu4eiD/lmsEFunmkHLmOpaHhfprjFp5xgumUf+vi7rdAgxKiA4dMtyvnPFQwQg7CtSVZvbUmLYruJWRBTXZKwn5rXQO3yludzWmBBPZHVgwWnKdIc+wARLvkdbBGbqQY1mQa0+nshUc+Q3vFl92g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dgmsIUewvtgaZUDi1JMSdecE8z2jvCAGnPZP1YDwjOg=;
 b=EXjke7CUW/5f2iy9OKEz+jRG+TSwpfDGSg6WGGUk9Vv3AIBSt+R1rJ491htqPK22SCzoELEZtKwtScCFKbv6vZRo3e46NKL55QbyDm5h0b4rWYwEZLDvCNNrEUiJF/f3fJoMInWjUHAUWU8Z//NjBp5XKDUDcmlKR9FPrDSRW2RRdcid5IFcwH3iQSYiMlOMvHsWldJmTLcbONJ+8xFYEU52rraucOZAZruZZ5ZTUur0e7jWJGCRYBcjMP+uZyQyVnBnPhHNYQZLVgdH5eE8UUkgNlXUgt/SpoZK8317cPBoE8MyvFg+yT/aXufoxROR1782IGKLwoqABs4UvBCfzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgmsIUewvtgaZUDi1JMSdecE8z2jvCAGnPZP1YDwjOg=;
 b=g1wNoIWT2Fpn5YCBEHNCOakYn0IcDIJHExfw+BmzBQJigcrZQXeAzqb7fDSGvMaDdWEoapL46X/4OhaQhWRnOb/6FfcUE2/g+4ZkscFOIthx8bK9cdQSIrVVjGZaBpqOVzUANNhlhjfVu/elvjbhuENXQqdDW1pxQqCSGQgPjbSly/6cvI1vVQnHPgfCZMFhPdhUoyFaou53L/7VxqTbp1cnKuAG1EOuVGXnrbWXRJQferiE9ugGyGEQsQQzSLGjQieCUJrLcID+jjAxeRlysUA6fRFjSksQX05F4E+FJ+naWd5CiFLSQWyiaMCgWF050xtGj3uDYVFOrvyZAH8zmg==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 DM6PR12MB4154.namprd12.prod.outlook.com (2603:10b6:5:21d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.15; Thu, 9 Jul 2026 01:52:25 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0181.009; Thu, 9 Jul 2026
 01:52:24 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 08 Jul 2026 21:52:19 -0400
Message-Id: <DJTNXVOWGWJ4.3MDNLPMY0Y3RF@nvidia.com>
Subject: Re: [PATCH 10/13] mm/vma: convert miscellaneous uses of VMA flags
 in core mm
Cc: <akpm@linux-foundation.org>, <tsbogend@alpha.franken.de>,
 <maddy@linux.ibm.com>, <mpe@ellerman.id.au>,
 <maarten.lankhorst@linux.intel.com>, <mripard@kernel.org>,
 <tzimmermann@suse.de>, <airlied@gmail.com>, <simona@ffwll.ch>,
 <l.stach@pengutronix.de>, <inki.dae@samsung.com>, <sw0312.kim@samsung.com>,
 <kyungmin.park@samsung.com>, <krzk@kernel.org>, <peter.griffin@linaro.org>,
 <jani.nikula@linux.intel.com>, <joonas.lahtinen@linux.intel.com>,
 <rodrigo.vivi@intel.com>, <tursulin@ursulin.net>,
 <robin.clark@oss.qualcomm.com>, <lumag@kernel.org>, <lyude@redhat.com>,
 <dakr@kernel.org>, <tomi.valkeinen@ideasonboard.com>, <hjc@rock-chips.com>,
 <heiko@sntech.de>, <andy.yan@rock-chips.com>, <thierry.reding@kernel.org>,
 <mperttunen@nvidia.com>, <jonathanh@nvidia.com>, <kraxel@redhat.com>,
 <dmitry.osipenko@collabora.com>, <zack.rusin@broadcom.com>,
 <matthew.brost@intel.com>, <thomas.hellstrom@linux.intel.com>,
 <oleksandr_andrushchenko@epam.com>, <deller@gmx.de>, <bcrl@kvack.org>,
 <viro@zeniv.linux.org.uk>, <brauner@kernel.org>, <muchun.song@linux.dev>,
 <osalvador@suse.de>, <david@kernel.org>, <baolin.wang@linux.alibaba.com>,
 <liam@infradead.org>, <npache@redhat.com>, <ryan.roberts@arm.com>,
 <dev.jain@arm.com>, <baohua@kernel.org>, <hughd@google.com>,
 <vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
 <mhocko@suse.com>, <jannh@google.com>, <pfalcato@suse.de>,
 <kees@kernel.org>, <perex@perex.cz>, <tiwai@suse.com>,
 <linux-mips@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linuxppc-dev@lists.ozlabs.org>, <dri-devel@lists.freedesktop.org>,
 <etnaviv@lists.freedesktop.org>, <linux-arm-kernel@lists.infradead.org>,
 <linux-samsung-soc@vger.kernel.org>, <intel-gfx@lists.freedesktop.org>,
 <linux-arm-msm@vger.kernel.org>, <freedreno@lists.freedesktop.org>,
 <nouveau@lists.freedesktop.org>, <linux-rockchip@lists.infradead.org>,
 <linux-tegra@vger.kernel.org>, <virtualization@lists.linux.dev>,
 <intel-xe@lists.freedesktop.org>, <xen-devel@lists.xenproject.org>,
 <linux-fbdev@vger.kernel.org>, <linux-aio@kvack.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <linux-sound@vger.kernel.org>
To: "Lorenzo Stoakes" <ljs@kernel.org>, "Lance Yang" <lance.yang@linux.dev>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <1e7d834c887b6a65627d730addcff13d458c6268.1782760670.git.ljs@kernel.org> <20260702131233.59026-1-lance.yang@linux.dev> <akaGxiTaJreEQn8T@lucifer>
In-Reply-To: <akaGxiTaJreEQn8T@lucifer>
X-ClientProxiedBy: YQZPR01CA0041.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::13) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|DM6PR12MB4154:EE_
X-MS-Office365-Filtering-Correlation-Id: bacc7942-656d-4181-e20f-08dedd5cb91a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	Yd28dTy/xN9ySMyhg2uIQeY4gQAgrUnJObMIVS22bJ5VRzmoeTnNAj3462cN98HdiG2seYtR7K5OFXMblYfILyPUu/uCu/Rz7HRmbjk9gtGiEnH5qLj4BjMy4LshOkUGUl61yUNpm1dEB/vj9L35x+JcFqqOS01ylTSeSKtR9hcQHUciu3LED5xX8q7gGNbPCoVYQ1iSmJ8Vxn5xJknM6/iZWiVa+4m0F3PivDqGaU6996tnxowWFJIEAU7FdI7QqWNSIPu6de93Ych0CU6wtWi7ewgtxYm0StXUbcIA772VPhrPyXntIIn/CVND2yXt1dqOwQMGoh9Ey3mVFAEEk/S9+bqVcAYkeU4Y4LdYplZqQVDWwL7wh7NrKr6irfH0NOAVXZEqngQ34zv9OBUq5i+xRWaZVPKmWzFtc9AUZ/uE/KNVv0rL/u9rEPCf8r2viLdLX5XNG7Yd42dPn0h29jLtXpbJTeIO8FizYjpgteCBdo6h/ztWPT8koa43b3xU1TS1GUS9DdjBsXvjnkZqUmm1nIwv+Pp3vwWRZkFs3x19WsnrLwsi2bjmBVQ3pqMDnPDl36l40CU01hRUo0UkwUhuDjhh4hY1BHpF1RRR25+J0ov3CWhYB7WugenvDcU1SRxPz+rlFkz8auNamE3mow==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THNNeExvMFhubllkUE9NcTIya3haaHpIRDVleXp2c0FTMVprU3psTzAzWmFk?=
 =?utf-8?B?WnlzQWFEVFNGT09sUFBlMGViVGZZbWxHdlQvT0xYTnI1c2dHMzd0QVY2T1Nw?=
 =?utf-8?B?Ylhudms2YWhVN0lpZ3JNc2dLWnNyWUFqb0F6TnkvWGlubENMRk1oRGVzeisw?=
 =?utf-8?B?MnZBMnBkRWVIaExuUHJLR1Q1OG03STQ2eG9GbVN0SW1RallPa05hK283a0Ir?=
 =?utf-8?B?MlpoaytmZGpYWmRhTkpKb1UrQ1E4TGk2OUVuNkNmSGx4Q2FjMmdtUUZsQi8z?=
 =?utf-8?B?b0hjMTFndmN1bWUyVGo2eGs5TVFzeTV5YnhEZGVLQk91Y1VUM2h5YTVwRjdX?=
 =?utf-8?B?WGJkYlVwbjdLaTZJSjVEZm9VWXpYY1cvOXFOK2pDZGlOZitXOVlXK241RkJt?=
 =?utf-8?B?UEhsY2lCYzIrQXIyUTVMZDFBc0l5S1dOOEdYeDRWYzV4WnRCR2xFWXJlaEdM?=
 =?utf-8?B?UlFpTGpsTnR3SUpRb1pyVnI5U2s2QkthSDI2RW9uZzAvN3MyMk5BWWR1RzBh?=
 =?utf-8?B?VWQ3R3YzTVV4NDI0UVlNZzVwS1NjTVJ6dGtybW11OGlWTW5WcVY5ZlBNSjhz?=
 =?utf-8?B?RTA5U05kdHlTQjFMVEpqRENBS1Fmc0lQS1BROGI4MUFBNUZpYTBmVzdkMU9S?=
 =?utf-8?B?VStLaVpycVJPbGxxRE45dFNKNHgzRU1hZG1Ud0FLTlZYUDJLcFZDMWlKc0Zp?=
 =?utf-8?B?eVZhOG85MDQvM1B6YUIxR0pTZStVZmFOWm91cDZuNGRsMlI2cUxzTjVOajJj?=
 =?utf-8?B?WEYvQ2NZUy9PU29zWjQ4MUMyMlNGblZjUFZXTnhPN2dpMjM3WUMxVXowb3VJ?=
 =?utf-8?B?M1B1MVpBZmxoSWVKY3JFeEFETG83ZW1yaTRQZVdPR3h4VTBPUm5tOXA2RGVi?=
 =?utf-8?B?QThXZmZuK3l3NXpCL3dLeGs1a1Q5YnR4QnRETXltRVNCOG44QVdJOFEyb24z?=
 =?utf-8?B?OGNXYnUvYWVMWGtvcVRHa29CVDMrWlhLYm91a281M3JWZURvT3pjQkpmWGUw?=
 =?utf-8?B?ei9ENHd2dDEwQUNabWNxTlVNa0xoaWdTU1AxV2FuL3hsaHdrL21RZTZXU09l?=
 =?utf-8?B?MHYwbnl0b0Iyd1BibG0xMm4zVXdjdVRDOG15NmppMzY3bVpSbWYwa1lRWDhs?=
 =?utf-8?B?V1J6UGdQMi9yNlZxaXBnOG1iVS8xTGVSc3JnRExxc1krLzBPUGg0cm1PbmR5?=
 =?utf-8?B?S3hBSUI5TzBXOTVveU5UaDd5Q3Ard1R4SEt3UkkySG83NmxveEF1eTJ5Nkda?=
 =?utf-8?B?Y2RBekRnZ0JNMXR2aU1SK2ZOVUE5RFJPWDUxSHFNTUZhTjBHT2dFR3lyZTNi?=
 =?utf-8?B?S0NPNE9FNk1IRWJWQWNrL1ZlZXllTGplazdRTjhZMHdRL3JpSXpYZDRhRks0?=
 =?utf-8?B?OGk4MUt3OFhHQklSSlJuWmM0bDRRc0dEMEZ2enIvYUZXOEJMUlNyZjF6aTFi?=
 =?utf-8?B?NlJUZ29oaUJ1a21wZVBVbXNhM0ZabUxCRm1xVnNXT1dnWXM0NnVBbk1qaVpN?=
 =?utf-8?B?bXFTZUQwNFhFWG9naUx2T2dyVWc1bXdVYVFsQzcvN1N4bXlBeWErR0Ryb2Yx?=
 =?utf-8?B?bmVMV1hHa0d3L3Jja3lRZ1lyamtlVjNOc3d6YjdDMEI1aFNwNm9UYkM5TWcz?=
 =?utf-8?B?SnllbEdSbGF1ZDB5Uyswb09Zd25JT1lZT3hwcXczZmdxbXQzUUpNL3N5aUNF?=
 =?utf-8?B?SzI4Nmk1eGRxS2dPbVNNeW5rMWhrMWh2VWhkTEJmYUVUcDlkQ3Y4UkxwOWdo?=
 =?utf-8?B?UjZoeHhLVGVDc0ZxTk12VWdCNUhWVjJGeE9JdUVyeFlsVTI5TGViSE5MSjlZ?=
 =?utf-8?B?b29jRVhwSkxKOW9SeFFJVlllRFFDbEZZQ1FyZ1NXUElEWURPS3l3djRPMGNF?=
 =?utf-8?B?THVXRUhRemx0aTlSRjhKZUJ0czF2QXRpRVpvY1RGcTBFdWlsdjMxYThiNmdS?=
 =?utf-8?B?QTV4KzJ3dkM2bmIrTXJnSEw5UE93bTFTSnNydStoRGkvMHNoQm04ekVGMFo3?=
 =?utf-8?B?ejlxemd0Slg2OFhuVnc2YTk3R0FYK25BWGphTzdPOVpFOTluaVpYTS9ZZmJW?=
 =?utf-8?B?VytmcDVkamJGMXg0cXBOckZoMzM1SFhxSk0xWWVHMzJWR21obkhtTXdjL0VF?=
 =?utf-8?B?eWMvZUNzTTRkNWo3NjVBbmxLRjc1anhPeERYUUQ4eDZTcFdac2dWTzUrVHZ1?=
 =?utf-8?B?djFxZmFVZTZMR0VTbll2eHdvRjJ2blo2K3BOeW1UVWxrb0lHbEZwMEFZUW9p?=
 =?utf-8?B?NU8yQlBJMndyZWp0bUU2dVhSVWFEMHVMSEl3VDZuVkp1blgxTXppOVAzbWxV?=
 =?utf-8?Q?QcZDKeihkt77hc+27P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bacc7942-656d-4181-e20f-08dedd5cb91a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 01:52:24.7416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d6w7qvqU9Xvfq3rnPOcHPBkvnO4m2Fn3xJjwiOL8S5RfEjHG8pIPBVGzUoy7hQIy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4154
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D788340007
X-Stat-Signature: fpiadnq5fht5uizcxay6bi9rx8aa5arb
X-HE-Tag: 1783561959-126962
X-HE-Meta: U2FsdGVkX18Cy6Eu69P1b6J+ElNs8A2sATM9AOkxyARnl9QVI8uzsmzIUYNN7jkwxGt9K2LMM4adESQBHyWkKybX0ZjWNMFyXJjsh++tOWUp9YmWDnFL87Rd+Ywuj2VmB6Qf/I2ulXcssghc6cB0K/nsaMuPd4jaR6JjMYWvKXQcDNd2SKfjz6kFhRAYGiPoQZJ4AYS6zsQ/blraj+JK0FTsJRohzUECt3E8esjvsvf9dZBhjcRFYPV5nI6YNYqkCVI0obT3xB6qelP2oT6itRNl9ZEcQHQOCIQ+047Wqub3FURULm9PFa0SgcNRLC+OsMarDyeEzUUMEveTuKpYS2aUFFqzQYbnJyS8/xOWiUzzpBxxbHbODUZEYNTpVwJuko+hBWs/UCHg/VfDKlOqKDt9xfewtI6gc4DB9u4dLzu+pz7Ue506Vb77m4+52yOpZA4530QIK1TwKce11lVuF4f1skLaAeLI/Iy69nRlbPOsBeMNfc83V5CK2dneXuRoDKqvRKxWGG2o4QC9wDIQfAiStc5JFtcpWAt0+G3CJU3akyaXvEykM6Pdh1RRy54k9ZU3wbYwW+gspV58vCjuU/ltkg7aY0mGO642h2b8ize7MtwsGpkWETnJm0oqwK7O3vh23SXKWF6xPQI1x9rVdF+cHlcSR7lwZdCAFQky4CB9H+Yh0PYZ4pk1A0CO4OxwgSoz2JQeERytoi+TFJNbcHknZEQxafzeO41VnW+u1tT28kuLy/TofAYEDZLwVE5dIu2Cp1fjJIU6kMiAgx/f3i9dwM05lJqz8/dqBK2JAgjIJKCSGn+gMC3OPrN8Sk+NLvm5NvHJF4D4bqqlgaB540yO4pMgCb3Vqw0sHoeTGQl3uTnswLMQjjzH0qpjeiMSBxy6+URN41JVL1Vaz344OoeoPfIA/DUxgiTkVkuLReyM/903EborMDpHRxZYSo8jbZzQJfrGzSB+c6D5Tak
 +XchForP
 kW2ejMLa7yqwLQ+ctmGV9YNd8lJHTluJF1yG53rapvgQT0bUoKZxVAsJMxCmB4aMGhe7aPpohHJJiUiZ1acPOYmZXsyjgBnKgL4hgWi2d3wVo5l0XJB9QtCpQviYxgIq3hrFjkPUlWrrmLD20GeDxABixQOxnFBveXfArPLu/+3FmvMjAtTFqmnZaXpY4EVIaZILyNURoHrog0v7yUAOk2C7SzBjrgj2xuOGXxG23IWkgeLyL1oyDKpa5cdqBh8xc2JzLPl5x4waQrns51vsD9HBN1tcI1zOclME5uOkT9bjUWWZ7IlylXd2Z8cYJhoXT1qZrF2YhXaD3NKrk6vsUoYfxvQt9VaLb+7ErZyEwzR03TvSdIMlMDvvOQIeimXUJHjJh/O2YURJWWcUYQMy6g1sVxSk2zkERcl8H7JBXgnjzn4Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jul 2, 2026 at 11:46 AM EDT, Lorenzo Stoakes wrote:
> On Thu, Jul 02, 2026 at 09:12:33PM +0800, Lance Yang wrote:
>>
>> On Mon, Jun 29, 2026 at 08:25:33PM +0100, Lorenzo Stoakes wrote:
>> >Update various uses of legacy flags in vma.c and mmap.c to the new
>> >vma_flags_t type, updating comments alongside them to be consistent.
>> >
>> >Also update __install_special_mapping() to rearrange things slightly to
>> >accommodate the changes.
>> >
>> >Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>> >---
>> [...]
>> >diff --git a/mm/vma.c b/mm/vma.c
>> >index b81c05e67a61..ab2ef0f04420 100644
>> >--- a/mm/vma.c
>> >+++ b/mm/vma.c
>> >@@ -3417,23 +3417,27 @@ struct vm_area_struct *__install_special_mappin=
g(
>> > 	vm_flags_t vm_flags, void *priv,
>> > 	const struct vm_operations_struct *ops)
>> > {
>> >-	int ret;
>> >+	vma_flags_t vma_flags =3D legacy_to_vma_flags(vm_flags);
>> > 	struct vm_area_struct *vma;
>> >+	int ret;
>> >
>> > 	vma =3D vm_area_alloc(mm);
>> >-	if (unlikely(vma =3D=3D NULL))
>> >+	if (unlikely(!vma))
>> > 		return ERR_PTR(-ENOMEM);
>> >
>> >-	vma_set_range(vma, addr, addr + len, 0);
>> >-	vm_flags |=3D vma_flags_to_legacy(mm->def_vma_flags) | VM_DONTEXPAND;
>> >+	vma_flags_set_mask(&vma_flags, mm->def_vma_flags);
>> >+	vma_flags_set(&vma_flags, VMA_DONTEXPAND_BIT);
>> > 	if (pgtable_supports_soft_dirty())
>> >-		vm_flags |=3D VM_SOFTDIRTY;
>> >-	vm_flags_init(vma, vm_flags & ~VM_LOCKED_MASK);
>> >+		vma_flags_set(&vma_flags, VMA_SOFTDIRTY_BIT);
>> >+	vma_flags_clear_mask(&vma_flags, VMA_LOCKED_MASK);
>> >+	vma->flags =3D vma_flags;
>>
>> Maybe worth a vma_flags_init() helper here to mirror vm_flags_init()?
>> With this open-coded, we lose the soft-dirty WARN_ON_ONCE sanity check.
>>
>> Might be nicer to keep that check in one place ;)
>
> I really hate all the VMA flag accessors, they conflate things horribly -=
 we
> should be explicitly taking VMA write locks when we need to (and often ki=
llable
> ones actually) not assuming that a VMA flags accessor does (they should a=
t most
> assert).
>
> This case is even more terribly egregious - you are setting flags at an
> arbitrary time, why are we asserting something about softdirty?
>
> You may update them as part of initialisation, maybe not. It's far from a
> guarantee and feels like a lazy place to put it.
>
> BUT obviously it's an oversight not to open code that here, so I'll updat=
e the
> patch to do that!

What do you want to open code here? softdirty WARN_ON_ONCE()?

vma_flags gets VMA_SOFTDIRTY_BIT just above vma->flags, why do we need a
check after that?

BTW, if you think the check is needed, patch 9 will need to be updated,
since the same pattern appears in create_init_stack_vma().

>
> I want VMA flags to be a clean stateless thing, other than the flags
> themselves. Implicit, unrelated, asserts or lock acquisitions in general =
should
> be done separately IMO.
>

Anyway,

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


