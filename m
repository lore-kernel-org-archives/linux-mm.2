Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21468CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 15:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776968E0019; Fri, 10 Oct 2025 11:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E338E0003; Fri, 10 Oct 2025 11:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 615C88E0019; Fri, 10 Oct 2025 11:02:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1C08E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 11:02:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00DA886E95
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:02:23 +0000 (UTC)
X-FDA: 83982520608.29.C56275C
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6454A80033
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 15:02:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SR7BTQBi;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.193.56 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760108541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7BUempDXgvU/KC/HX66DemGIPH4a3QdLgmZG49vAmHk=;
	b=h3Oc3uORNyq9CaIl8rlx/f5LgmtszwmN1nDnwVOcfcy3GohPrOF+M0/2yDEnHojpOaaGd7
	+yMfmiPITWFA4UwVnKK/yTW21MAo2wHjlNjG3VpE7UcNIVSN7hhB0a1xN1brqge7FzDSEf
	+ect2y7HL3278zWBGIv6E7G+wfMhCXY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=SR7BTQBi;
	spf=pass (imf02.hostedemail.com: domain of jgg@nvidia.com designates 52.101.193.56 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760108541; a=rsa-sha256;
	cv=pass;
	b=MPturhs6q/7Q4l4lznsvOIdxXceOlKu8lZ0bbuJVUld6slIfxdaj4EixSXHsdUj6uN+LTA
	zlvQiO7ZZSKNE5Md8CwXWKp2XnVWiXwL7RCmxQ87np2uyTQseCf4tZkAisAloa1t778Jwk
	UQjIdscDvu6XGRbGogVmQcD93QOLQ28=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HsOcPkR5zapx98fpCtQjsFPnypT/FTtR3E5m56ufSd9G/F3uPU2QTmPm3/2zrbnv88y9ydIHqe5zUNOMe2expyOndyzT3nJB5E6tE0qK718tufN+66UKLbR8TnKNq3t6WexRJmkABEuaqGSmpZeIprvlkBc+N+ZO+EGamJPCL7+MehUXK4cedXFgvt1dC9qtqM4LElSqgzXGPMjw8d2g6UQ9lSZu1pgPhWCW5Is/pi6CmvZ1chduQckE3K+JX1RaRFn4DQ3hcTiIfdCAH+CojS39zCBkqf3nKPKrxkLoWqDZb4OzjyAaP91mkjG/Zjhw0QBd6RFaxI57QvAAMAe+sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7BUempDXgvU/KC/HX66DemGIPH4a3QdLgmZG49vAmHk=;
 b=DmtR+N7/Ubpt2fF83dQXhYzAXHaUeMuhX6GY+2RCNbKrcZCqhuWBuvhwmlJh55V7AczP80Td7o/QUCWozgZ//NMODBEBROqkxsZTdscK2UUuajahUwYCmCKfCkROxR6eNzTrPKj0HZqzfKyAyDwGdVmkz33oWIwP7DpZAgzPB9QcmsVfTGVBUIWWvZZhS00g/RItG+tDs5Kvbf6t7Ue/zThsUGdXcN8iAl6nNWOIt/ZAftYMy+tSITXUU4AK3INlzq03UYQvEbqTg0r02+KH5Ph7MGD3vPqg8Pla5xtoSKP85RwfByWHCOSL6MFM69/z2MW90cX/J8agyAj5Cw4kCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7BUempDXgvU/KC/HX66DemGIPH4a3QdLgmZG49vAmHk=;
 b=SR7BTQBiVW3sBB+9o7y5fGhGMC1bks+I7PXE9wdM3e0ozPsmREauoMS38UPqOlKcvOyXbj3r7omkan2CbonS5WhFdUPBr25SF3JJHMf5MAVEEyPSm7DgumkmYjIunztLQ5Py1qmktK3JEDH6+P6czvwXPgcFhqaNK+3l3xS1yxcp4ViwStjEx9l6eaMloTq2Ox9PN43XOHFzfsDCjecR6XMmi/CPbjGYWHtgx842tT+S/zMa/44nAabTg8h+al04fZ3njqMYOOPUtoVEM9UvwJy8x5Ja7auFR4hRTeOrFDnD9DU/tdQ0Fspe1euHbWyVHLHiUxGpDvBh85ff/2Dsrg==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by MW4PR12MB7015.namprd12.prod.outlook.com (2603:10b6:303:218::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Fri, 10 Oct
 2025 15:02:14 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9203.009; Fri, 10 Oct 2025
 15:02:14 +0000
Date: Fri, 10 Oct 2025 12:02:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, pratyush@kernel.org,
	jasonmiu@google.com, graf@amazon.com, changyuanl@google.com,
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, parav@nvidia.com, leonro@nvidia.com,
	witu@nvidia.com, hughd@google.com, chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: Re: [PATCH v4 00/30] Live Update Orchestrator
Message-ID: <20251010150212.GD3901471@nvidia.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <CA+CK2bB+RdapsozPHe84MP4NVSPLo6vje5hji5MKSg8L6ViAbw@mail.gmail.com>
 <CAAywjhT_9vV-V+BBs1_=QqhCGQqHo89qWy7r5zW1ej51yHPGJA@mail.gmail.com>
 <CA+CK2bAe3yk4NocURmihcuTNPUcb2-K0JCaQQ5GJ4B58YLEwEw@mail.gmail.com>
 <20251010144248.GB3901471@nvidia.com>
 <CA+CK2bBxMpb=jXy3-i19PdBHqxLoLrMMg1sOnditOYwNe1Fr+w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bBxMpb=jXy3-i19PdBHqxLoLrMMg1sOnditOYwNe1Fr+w@mail.gmail.com>
X-ClientProxiedBy: BN9PR03CA0912.namprd03.prod.outlook.com
 (2603:10b6:408:107::17) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|MW4PR12MB7015:EE_
X-MS-Office365-Filtering-Correlation-Id: fda06e23-49b1-44c4-af79-08de080dff13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2rq8S5iJSC6qggla+nl2VNqFbrWrPDLJxVW9AzHkP7UvhG4YgdnsuqYCMxtL?=
 =?us-ascii?Q?mRW51HWXLKk6ZCRZGDy2nymZygxx7d1EjumpEJMI7cbfivPCa/9HZvqT0cvX?=
 =?us-ascii?Q?lXmpuLJH5zfQh9sWzKozSZ7dgij75PxYx94rWGPw85Hge5tpvj0+D3zp/ND3?=
 =?us-ascii?Q?xV08m0SRTiPsvp314BR2YcfSke4jNtTE2IlEHe2nvzneg/EFVVCqMmjo1Bg8?=
 =?us-ascii?Q?47nac6COUogJ9c6KtnkYGboBkjE5ElW7KSd9dZHpQC76hH0+1sIvjEhc+CMj?=
 =?us-ascii?Q?npmx38HfOqQAz0xeFkkmS8c2kv2tV57R58ZmraBqoxe+h06amNQg3AadzQNK?=
 =?us-ascii?Q?gVL2VDIB33+MRUQoIC0CQ4baMEYPtDm/er4GlE8G6ycjmrvN5xlhR+zh01me?=
 =?us-ascii?Q?xUdjIKZrvUHLOoC74R02iq3SvO/tr4cfCKJH5I9j/AxGUYjQLz9gUKQ6KJzI?=
 =?us-ascii?Q?doP3mtQ6wH+UucHoZ4FGqmIa3fanwC+vxsqQMUXi+WUsZgTUa8JOZyIWZjCl?=
 =?us-ascii?Q?xz7Gjh1Q1L6xmy1TM4bUhU4zajrAVJtdYIEbBzz3IaSfsIq5/WVIIQnZUgc4?=
 =?us-ascii?Q?mLR15JMN2ud4RRVjCqxIXLRveCs5eOjFbdthmdCiHQqYTStEILT9ZFJB0ogh?=
 =?us-ascii?Q?W/AZP7VkTSQkvWqccVPCbEaRPM0btvtmJmg/p4xiv3J+2BZg4sBQpJu55DBT?=
 =?us-ascii?Q?O56BHfZmwd4NPOZMLjXtVVsSVLoEHNhwDC0uY9PVayHe1R2Itb0+KxvZ0NrL?=
 =?us-ascii?Q?Nd5qRmPxxd6Vk4yJHZhdSrHtJC6fXd6n/F1fu+cjoGtRKm/BQaPClGo50HVk?=
 =?us-ascii?Q?wkM8m2uCgMJyF/HDquYB45zleqY4DDoG5fhDZrkbZ6OJqvVygwVLoXZT1uu0?=
 =?us-ascii?Q?BqvNej24h7Bx9eCVb7PkPV48I0V9dlv5yHwxDGF5R29W8t/bwZYBT2l6mZZo?=
 =?us-ascii?Q?ul5G6phNXnwLTRVr9LyOpsd8Ng71IHAUENyGkSmZifLL+pDVcDyfeFGgl1Q2?=
 =?us-ascii?Q?GmzQRFNX0NgLCQ+ZpN35zwB4TGMS6qlzX3OQfoxDG9qEEoD16AGb31USNOZN?=
 =?us-ascii?Q?6O3rkecuH/hmbya1yeDXQM3C4wxmU0ZdzdZJsCOrnMB7AEqIUrhUw4iUZEQv?=
 =?us-ascii?Q?GVA3xKbsTXClRP035Ahj//ZUpYSfvrjsu6e9GglBaWlmnEz3IfqapvseUlX4?=
 =?us-ascii?Q?zWWAcnt+udYUORhUBnhtK6knJI549u+SruO7ao+ujJCtLMGUuGm38WObPsHo?=
 =?us-ascii?Q?4krxW1nVjnr1XZoKpyKK/QYKnTR+Pi95H7dSiVdBDlh7PABRuKdee+BGz4iS?=
 =?us-ascii?Q?EniPcPPzo2ysIe0GtWZMYbtKQUFpvdMZVvWcyeX6fk/Q4jCU1Zbxv3WNRU1V?=
 =?us-ascii?Q?MshzbdhmYeP5rlPcVjxBExDYQxF+T4RUxy8+z8CDJwurCNhBhewmx7+UyKeC?=
 =?us-ascii?Q?Dkz9QpTZIOpee06lPIUjgIwG47G5z/Hk?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BcZv3hE+4bqapUeZqRjBm4WXpnomU9dzSPbRWzFM+I4IUz5JMRolBhJVef0u?=
 =?us-ascii?Q?AUEaWaxc1VYHk7a1OriGwSGq9vMQrk1jFkYMOWCqz+qEUFlxgvZafbtK6/nG?=
 =?us-ascii?Q?m6sk/2feCCYEJu27BgnR60wuKAxONy56kBH+6dlCmr9J5G98glh1SNipIdIC?=
 =?us-ascii?Q?dsmmf4eL1T2g9RTNHRqJ/QFbiZySS63qzlHQJzlzFx4+4WaHKJoAC3iKXOT1?=
 =?us-ascii?Q?SVd+WBVzuAkxi/wIrx0Is93+8SWf7NXuAk+3u9gB5YcQH7t6XMc/vxcRxl2/?=
 =?us-ascii?Q?frsMavyzud8PJG3vvBO+i1R6DJQiZ0k+WRzGFxXBYm7pTjaULyG3J16rlLgJ?=
 =?us-ascii?Q?MwCozLog8ytWFBsp1GCn0Eb5ZiTO/KbNLQA2Cs0OLYaSWKjkqkpTc4t2aCoj?=
 =?us-ascii?Q?wqxmU8V+FCkFSO+teAQOJ8RnJohCbuRxEp/+p8RdwEo6i6P/tUz8TU7MoUIa?=
 =?us-ascii?Q?okyRiEXeY4Q6fnxxVERNJKPhw087h6gQuEVvs7I6sTS4eDA2E8uUeEgnbGhf?=
 =?us-ascii?Q?HM9hZQU66OOVp9acbFoFhX5ifBnSGUCtR1aBRgUwLKbQls2YKYVRUydGIGSt?=
 =?us-ascii?Q?PcsfqVViQUSA2kJJm/A0zCkJeh4bxNxryh6iUHmwmwZnch31KoDBhDxZvp7e?=
 =?us-ascii?Q?we5AqpW1NeAEUIStD1JRgArVUM0FR37qsjR+pcA+mjMCFH0E14XTB/OFAx6J?=
 =?us-ascii?Q?e3LOTQ9noaEcvkqudgrS3keaPEpdqygEyjOsePJQEXI9nBOGcXoILjYY9d/c?=
 =?us-ascii?Q?ZzBC9JZgeDfEIo9V74r7yfLOcskLSkw1Wt+ylaN2VyricbOMRwSg5hT/EVdT?=
 =?us-ascii?Q?oX/Hc7up79UUj+w7CvQ6jHX3rc02Jk0ipoZ/7h18G1BmeDYc7gAhEXK4RLDm?=
 =?us-ascii?Q?thYQgSv6ZVOFt6wwYofBh08HgGhEvz/O7DToOO83uDPPYtrgx1Bi4HbXAbYs?=
 =?us-ascii?Q?cm+uOlualSJjItcYrD6KAcGOMFazAcVfbRt16kUhMg4GMULbCDNP2r9BM687?=
 =?us-ascii?Q?PZ0TM6RiwK2EOTy2z+st8vpN6C+hx9VrUrfIyZVhSadroBBlfwQSZ7fU3DSf?=
 =?us-ascii?Q?G5dhWfqFEXc4H2LS466jHFQJIe9lWgnawG0slxVGCmMVl9CACfVAdnCM0DBh?=
 =?us-ascii?Q?vNKTz7HOZ7qY02r78gnevW02oa6swospq1UInhoGpsaXtmHGuIH98eJxE77E?=
 =?us-ascii?Q?QY85RkldadYWSz5PMyRcHlMTOS3MnX8VOS5sLVpTOUikPBGHEx+saa1N1qyG?=
 =?us-ascii?Q?k89djNa/GCbh89ZsRyJZP8qbc+sHRiOUOO61tGknofM+CvRWb48k50V7lqVP?=
 =?us-ascii?Q?sAc0jf7fZ3YpvnTtGLbLDLaKAFB6QE/nGhabh6cRTtiYn0XJj90OP0eVFQog?=
 =?us-ascii?Q?wJxHBlLx5Et703cVu4b4NGMYbVO6xBrPAOcAtv1f7cKiGZR6hhDbDDcuQQBT?=
 =?us-ascii?Q?HBKXd3K1kIkXiYgUwjmkt64ZPNUVmKzbCd8L7HZLe/x7wH5YXvt1ckqlbjM2?=
 =?us-ascii?Q?pq0Nicr63U99uX3YysOPQr5/yGFoqk+O3uA4/FLHbKrtu53VPeFd3px3+521?=
 =?us-ascii?Q?1K8I1NMLdQT9o2Y68sg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fda06e23-49b1-44c4-af79-08de080dff13
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2025 15:02:14.1856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kosf61oSxG2D+yFgkqCNcO+V13BLN/M3mNP/kYXHIElS2lQ30vvdstnTVZP8ZmRd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7015
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6454A80033
X-Stat-Signature: eacz9q791edqqzoutsxwfzduyz61ef8q
X-Rspam-User: 
X-HE-Tag: 1760108541-618636
X-HE-Meta: U2FsdGVkX19KvnahvdVLIkQnYF3FNHeK8S95wi7WO5QRcX6VexvwWf/GiO/WphxjXGsE1vRDBzukwuiQQWXDSmJVpwwYxcXDW8iFZrAK9SkmMfHUnKwTo+07FIo+rqGK8IJCn7NuRlvbQoALHTkGOyNU0x9lwWOvvceZmznmU52D9zqCbzIPNC7/qsB4FP7LEc92TaHRusa9iLw+gQKXXoMkGuA1GUFERHWoArkb5jae1sKjE4cP/wmYVJrcjgXZOYZHXTgHOVYm96NpazHXcyMQ4MGsAu/hKSg9pE6UGvAUe5xPIjkKPIjk12PeXFg+bdd0mppDcm5OicK/f+zHIEZan6W9C0xfbxqmuwTQe3+mX7zf388QuqcwNzUa8G9uIDrVCwfq1whWfz1l3H2VIv08LP5TmblNlpQq5MCLsaWFbrrB8gpLOAfQYapEO1nNLjRBnjyhVSjI8YlXSG88CXced+Kpy/4VtwR/YKKwvZPDfxe+mr1X8rrri59yQQ6rdvyYAfUncYO73HICYe4fVcei0q8r+fSfbtBhJN5oZesyrM7KqMCQaqcbEAi6Agpwiwqb9xwoNg4nlxmDCbAF9IcX9nZGaAQVr/CgtSVguhp0VFNrMop/GtLIjIHLIgqEoQIJ6Qzfq1kXG79LI82h0JCuSeeqmbTgRZbio8Zt18hOL2H1G8J8fI2t9xSbVKHqxIE94FhjT5K92KrOzmUH0fLrse9E319/Wtn+rcw4lNqWH7nvOZTI5VfHaZO/jeJ983xQHIKkdtStUUsjK+GCI82Mc6jGdhn67OxNfOdrpPbn96ZHZ2iLijNi4xaKBTza1VMeXE2/hVnwCRrfSPCvPQgKpqnIM1f/sM6jZxINhNF76+vu0AWVYQZNUnmf55fLrC3HQ0nUaqj5ZKeUeRyo6PWgGzHEn275Hsc+0EdQkiD8RUGwWsr1D+cBMCuHnwUmij37lMri16x9vQKQkX4
 DN9vOBif
 /+pPDj4cx30UoDY0LEpEqaCsyv43kTAH8PzF7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 10, 2025 at 10:58:00AM -0400, Pasha Tatashin wrote:

> With that, I would assume KVM itself would drive the live update and
> would make LUO calls to preserve the resources in an orderly fashion
> and then restore them in the same order during boot.

I don't think so, it should always be sequenced by userspace, and KVM
is not the thing linked to VFIO or IOMMUFD, that's backwards.

Jason

