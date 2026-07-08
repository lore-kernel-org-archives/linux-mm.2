Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 227F8C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 15:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2A536B0005; Wed,  8 Jul 2026 11:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB3FB6B0088; Wed,  8 Jul 2026 11:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54736B0092; Wed,  8 Jul 2026 11:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6ECA6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:25:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C55C1A01C9
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:25:30 +0000 (UTC)
X-FDA: 84965983620.22.1E6048E
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011018.outbound.protection.outlook.com [52.101.57.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5BC5F160003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:25:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Emgwp8+H;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783524327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7n+m9L+nVuVwf/REsqo5poFit2H7FtnYO0z4THdy+2M=;
	b=vpHk2Kz8pX0smnwPabfYe3/BaKiXt4HN+35KansyVVqId8sZqrkmbRRBib0DHoAFSSmwy8
	npVKG38Zbd+MQPR5dRn/tz9u3zNgmc1hfOTNC8wvzfGV1QYCW2dp7RKtXU/KHH4uUD3Kr2
	Qr7PSH0nCuzZ+BrGYqR0FJG1z9hO1Pg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783524327;
	b=CoH9lzDLMliLGidyHtgQMOZdMzArkn5l9tEBmkJoiU0yAeWoKW+1DcOUmQOblCAWcvmI3G
	Iwn0VmG5RWht438MLcOPNn3GnvI+b8Rn0cNc2XNTKQJMm0B9E4jUEyM3F5YiNIDH+UNE9U
	/b/YYlZcVqHSNllLejeJzuGmLH0A9PM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Emgwp8+H;
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.18 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KL796/8wC13gBD9GGQA2bqc39xZy3zpWzNvuoVT2b/gqS7bto6uCVRCQojvk0Sq8jtMXjZTKhHzzXcwJ1VxWGp2lpFdQb0vY5gS80/gsSZ+kPcH4qG+y7dkEk/AxzOFVnMPwDMUFCnrYK+xmiYbVeNDYIbRRolibl6TFYjScclB40clOPLry+eAHEbnTXMy7gzJDaLOdI7do62RLdp8xk523r93R91WZeAqXwSAyudFX0a6EvcW2C+sdYYHP4uSXBGTq7iENglTxG6QHL1xv3nh8kTpuGJpxXl09t5Swa15fL4xMOmjxjYeViv1XLGbC7eDO9XLDNKNaNZu6ei2a2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7n+m9L+nVuVwf/REsqo5poFit2H7FtnYO0z4THdy+2M=;
 b=Ke/Twupu3++rCzkKMO2WIsn25lRTpDejvt7L9wxhmYu8bUnXgy0be2bVUbuVs25a4bmfcFX1JUkE1BdTJ2MV2YzQzuvt931IVloS6M5/JcNg/UZX18Nt0SFXvfg8GlA1GfHvMn+AHtR22Qg9XkDlcBAnFIyuD/cx22Lc5v5M3SsQE89lophkMoWp8WxNQvaZ9/gAEmQamj6lMuzY0bdEfdTejaA2uMJiU/MXNsnggx0e2CzBIhWnufVFM7edPU5JO80+fRtZWG00MU7ZX5Rk/TL/VzIPHR9qSydek2o8kiXs+cbqm1G4AY95Bbh/4A5EcMCdJS6TO6Eo5A8XxkW9ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7n+m9L+nVuVwf/REsqo5poFit2H7FtnYO0z4THdy+2M=;
 b=Emgwp8+Hw1sSd+VGQVplXpqpVqlSYwywtKOhIMpwB/9ef5K1gqewvfBFMInnXIJCr6lIDDDK5O9Jq0ib+w3p3r8MlAlZFpqyd+UVIgOHVGF4aFQB5QbRBYIZmMZLBagQN3bFD+sjajtahZBw6AuVdbkbaskU1CtA9MIuXrkTkVhKMJSz10D2CT7rKRwNVPNzmrqWTSwzX+pwdyF6WeNzFoYW24YFZlbaGC1k55xhPcWE+IGMd7bucG9zjLZau26rIdtWi1Ra02SwbkhWsqspRTLHipJAuZ2frBKHw9cFfo4aPpRs9ElrYnrq2nULwXlc9ReEucplVI+MJbMSPU+ucw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by IA1PR12MB7543.namprd12.prod.outlook.com (2603:10b6:208:42d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 15:25:21 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.009; Wed, 8 Jul 2026
 15:25:19 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 david@kernel.org, dev.jain@arm.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com,
 ryan.roberts@arm.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 shakeel.butt@linux.dev, hannes@cmpxchg.org,
 sashiko-bot <sashiko-bot@kernel.org>
Subject: Re: [PATCH 1/3] mm/mempolicy: skip device-private PMDs when queueing
 folios
Date: Wed, 08 Jul 2026 11:25:17 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D609FFC0-FE64-462E-A8F1-31E9A60B4726@nvidia.com>
In-Reply-To: <ca93162e-346a-4847-8cb3-cbc5baf03950@linux.dev>
References: <20260707135255.292870-1-usama.arif@linux.dev>
 <20260707135255.292870-2-usama.arif@linux.dev>
 <DJSMJDTLDNDJ.1KAP9PWH9H4Y3@nvidia.com>
 <ca93162e-346a-4847-8cb3-cbc5baf03950@linux.dev>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0805.namprd03.prod.outlook.com
 (2603:10b6:408:13f::30) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|IA1PR12MB7543:EE_
X-MS-Office365-Filtering-Correlation-Id: 35ace700-84dc-4ed0-bdd3-08dedd051ead
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|23010399003|366016|4143699003|22082099003|18002099003|6133799003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	BQJFR/9T2zw1hp9ZA6k+RMEQlThsO2dkV7SHnA6JemHNbWj3benNVCx+VHCs4ZmQ+6I2UN7rF53ONp5oOuqyAH4PdP8JDwimcL0zY+/o2gslwQc4T+7jc2SxOa/cFdMoYt97fTJgy3f7cwMTxTQyj5x5mraNcgcx64XdLJ3bc4j7S55k4RxcTee0VfJfWN6AkIHoASrMzABBWR5l2OKI98P86D/NTPq9GZgO7U7//0Py0p5mfmN5iTmoUj16DIIbM+XJyk57ICaVuiCQ9jXnmf89N5bB5pPzh8C7ems9Yd+sB72m/WbEuPd5Gtawud6sm4kXdyOwEG42k8Fo5r9y8nun+gn6PjH8G4LU+eVERPVm442pMpuqR7NTROhWfoAsWqBXBdAnuh0gZd+0BMGHX6Nfp8EPiGdhJvBO2BYWywoNXx6lD8QIIq6VAk4T9bbkEBowDRuWxF7u/Pgh50GpkNNXYlYKDRrfby37us3JHIB8cT1UcL+cZsD9UYvah7FHCYUNcw1w7jr2bslZmCj26exa2nlzPDQ6rlXYPrP8uHOiZPjZzGBo0xz0HprxitGreor9C4MZZyeEcL7nOWZ6zXOVA3WCHtMONmltxhgIgZj1wZb/YmshuqmajVEuS5p252uN782aAOBFUSlOR9kCRhu2mHdn/rDoejGO3CQFsbk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(23010399003)(366016)(4143699003)(22082099003)(18002099003)(6133799003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j5jRMu31er7RIWIMC/PC4bhES5eC5LJqQZe01YUdPXGj5VuXwaiWjzcvU8qH?=
 =?us-ascii?Q?0eWwhvL02bGcQueKtFDuPvpWJ4DoOGGs0zzsUJ+r6kM7ttVkg6IW2nK1mwGF?=
 =?us-ascii?Q?TU/LYc8Oo6tcpbVNlWmJ5caF5MaiUGCaOkTEhhLM1HT9K+GnMjvhD9JTWoZr?=
 =?us-ascii?Q?+nMOpSE1iUmnFluTpdOY2VHJEwjCZe+xTQkwhDoiOmMKhU1ETbplwr/z1dF7?=
 =?us-ascii?Q?yytYhjffu7aDxYgLCw3B464EqsWLGufdATcHAxU96Mc05KFil9WFkJL/6ovf?=
 =?us-ascii?Q?7RB99Q4cHWGRIJV4uZIOovPCdl/5ONSgRQqGEsg+ojcUK1UbA5zG0jgJB002?=
 =?us-ascii?Q?tQ6ZPiRTC8ZnyeTssOdu44d1XTsh8nGxl/Orz9d7Q7Ph4LJiVlNmWgTEmVaM?=
 =?us-ascii?Q?8r22E/fmMfnHrb1Yo3XOyz+usY5hj2d+NXiGBvDJcGEFRWOrf1tv2+ORI1+4?=
 =?us-ascii?Q?liD+X4el98E75YT/5gtLM+NaGIZPNlrWqwnhBa/B306Nxj2yXD7zWUmu0Pbx?=
 =?us-ascii?Q?M+Y5ob5azjuz6IGF6O+65Zs7rJZnZM0S7cY14Hnig/I7p9KNNehY0KG7ZsmS?=
 =?us-ascii?Q?AFN9nmxGmUFn+POKcnjtRDCKQ68jADSjFQJmEdmFDSShLqAzN188BSuN6gyi?=
 =?us-ascii?Q?+3pmNu7RUEh4AyN7Z9r6f4lb0Ve59/4VAz6a6kop4S6hH+vHf+yIAW68LENU?=
 =?us-ascii?Q?sUCUX+hcnco2G5bNm0/tQ6QVChvOkiNuWn7s6WbiFO4MtwUP1or4ZA0WaKCs?=
 =?us-ascii?Q?3e6ca3tra9hZofnGFHDX+nNKGgC8cGzOB4c9g5ylZb+4nEBrmj2LiDMYe20M?=
 =?us-ascii?Q?Og2K0MoTV5aFAI7KxwYGaKZzpiUS/igtj84jUSQ93nmpnE4yO1BpA/OeDqv+?=
 =?us-ascii?Q?Fo8qdhKrlJKFrxHBNIK9CoVB+MrEHQTjIYVGUES713MLSpL9t/yX1HLvXY2y?=
 =?us-ascii?Q?RKmT7y5e1iyw1ft4QF0XQ4reyL9DgITQIB2yg4hpY3yC6P96JMWUwlneeS/P?=
 =?us-ascii?Q?O1iXObjgaQX2Qx5BxM27o97c1ZjTOqGfQm9yAYoxNxRkGqjImW39bSHhapDT?=
 =?us-ascii?Q?E7uc87gC6VD6qcnPAgh+uWoMV8+LB81CVHHrGlv52zIImc9ZuNLXBzzlaaYl?=
 =?us-ascii?Q?b0ZVZrh4ZRyD976nSo9qrtyF6/UWI2U/MGczuNX49U44fDVak3dGHjBMFclk?=
 =?us-ascii?Q?gvVf5ejuLqeck4fDgTw0vNTd2lJdwOUi1/o2fQF0acudZbex4kGvYWPWXEP7?=
 =?us-ascii?Q?ErajRJt6jFDLLSA6ZPAgdMdQ6EqWpypUG9kOraRe4HaLRqu67usLU+j6Vgvk?=
 =?us-ascii?Q?XKXsN9AeQJMEr3UOGriJZs5yOEBldESHab7MOU0xD+CmhgK0b4kfzfBM31Bm?=
 =?us-ascii?Q?kc1yxR1xhrRkHjVCLFEj8dc8pwxG9ap0RwA4WEy2tYImMDl8TV3q1R5nLAyP?=
 =?us-ascii?Q?izElMscIdJEI+bi/6XO9FKEGH8thbcbgDjthrOojO60CggT5/pnR3c8kzkWJ?=
 =?us-ascii?Q?c7IfOevrM1Nzfr+ySldpDry5HrjUNmw9i7sr19Aa30NdBjD1q8M8bc1Yn+Ye?=
 =?us-ascii?Q?hDfEpYc6ZucybUN7I+xJiMwDGu5M3wRTGynJaF3OAscEjYvpiQHpqv3bmmqH?=
 =?us-ascii?Q?VtKfPiebVqtAT4LretlGHtIENFx9nkosTYQ5V2UeTdGPOOyspEQSsKWH+ZWU?=
 =?us-ascii?Q?1RlnGnzuwieaA5mWPYYwIqpSTBjT5LNh7d9Rq8daW3HzyT8++HOQbmwJQWjT?=
 =?us-ascii?Q?MsgTWyP2Rg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35ace700-84dc-4ed0-bdd3-08dedd051ead
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 15:25:19.4435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nLK1/fc2aFdhDlM+RkelQqJ7hkl/7L0nfPWGwcLKBgOMMbI8r+2D8nIkbNevwpLO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7543
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5BC5F160003
X-Stat-Signature: zcp1gwqgw39j3c3j5pwii9h8qkjmjwoa
X-HE-Tag: 1783524327-117378
X-HE-Meta: U2FsdGVkX1+vJfZzr3NvKDuuMv6g/vS5oBs+DKZXoy7MIjST2qURpeOjrcSRH86yJM+3K9RIeoBpEt8t53e8VkrZw8ntyW2OwK62g73x1/NIRQqJ1DcaAqQmKoVdwBOX1zIJNIDiuLu1mzlXPXRyIZL+fupAD4bUtU2GL+sBYTfJ+S4j8eiHJNC83EcRfYP6o/WXUTHkymY7CoqTGkwv5sb4RU0+KmXID4bAbWo+K0/2lH9//sECh+ocgPrJGfq3oq7ArxoSdBV5DYAsxEPto8KMLrpb+an5Ate/IVccpIHpShw42xxYjnEqFI493bGEqEzAxH0U+4lYNRQ4hCCCCtReWvZHQD/hzsUwPuE/mFus1We078gyexR3uCofwyyGJQ6RnLbelQ+r4NXDXoIU7V+43soZ8n8SzWfmNFk+8VWWt455rJSOT1dD8qXnnEeOZV6w5T+nF4xhCfu4M5lqDAy3XsqXdNVlRjrbAkhT0XjFS/v+WZDC0Xr9UOh0LDJxTbpr1njv9FWjQsS+NhHHlS/66rD+xcoBp/rkxX1A6yJxZOB+84tEAIbZnKvcdn8+STFwBvrUuYnFqQYAjPQcj00qcAo6SxelXtTdfJLsfHbTvkvXgm3kWOkFj4T3Z1CN58OVx4aKOw1jNt+bSTMnMDF+dJtfCTfGbI9AwOG/3PxT9IiSvtGqkbJDz3dVa4w4kgGA3eR+GEn9tsgh0WGGpB/S5lZaSZKq6fGKQGWzWEzy3XOAHMd/+2zHx/JBYgkIJJzXSp5rhB+NYC/5ErVyX2CvI/HHHmuPhwQ2DAjjWj7c5BikHmJCGRiuxXPkDyh2gXcbWfkROg7IY6sCY9Ib/jyRXW/kMLERVpuqly49vIhjy2IcQrjPXDPIaPxwq63dbfaFnz/kXQJzAp9K/8zDhhxg000XCgDMWyjlIK1YW+tzs1vlX6NKnKZbelHB41C1C+xdnJlDR0NxbESKqgy
 tWJBBbn6
 0Os6EHHY/nlO3vYxiFCEmD5KhrupUVXnwMoXmHfEDqnS+pRK9BRROkUr4o9nXJD+FVnkvvdWj+Er0d8XvTOGUbXmR/OtjaYFwv10MByA1oIm8Cg2KpoGku4NMMORr3gDDlk/Hizs0TIvzCZYZLaeiV3y6zYhzjLjiFiCHDbyfiPhI2sRwH9os/x9csgCelNOcMQjeL/PXg9wQnNr0LSfU2ZZK1dbeb4ft2QIQ9Oas3ts+gu2gDJ7raYG56YtxOqknKeUHP54cSe5uT0HUX1w9eYSjbvVDAROgDTLz03uevRIpy9E3d2AsPczihKmHMhdLMEUwrH/Rl42mCjsn4DYOaO+bPIIgbhGEhVyRayOTKja7ourdm6N6zyLDDoQk85VJMmJq2rwxbR7cGLOejQ6U0Rzx9rEuB4nAh7F3BhK5pFdYfXzVP1C2Esiu203l15CDxkrnsUGPsf1ezDWt2izmkQ8jjVLA32DLjBp0uRFImtunUR9BGX96sk9pmZKx60m8tgWyfOxDiky3C39YH0x4KEqoJoEVVE5L93jcmE2qlUeQQjk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jul 2026, at 6:54, Usama Arif wrote:

> On 07/07/2026 21:33, Zi Yan wrote:
>> On Tue Jul 7, 2026 at 9:45 AM EDT, Usama Arif wrote:
>>> queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
>>> pmd_is_huge() check returns true for any non-present, non-none huge
>>> PMD - including a device-private swap entry. Passing such a PMD to
>>> pmd_folio() extracts garbage bits as a PFN and returns a bogus folio
>>> pointer.
>>>
>>> Potential trigger: an HMM-based GPU driver migrates an anonymous THP
>>> folio to device memory via migrate_vma_pages(), leaving a device-priv=
ate
>>> PMD. Userspace then calls mbind(), migrate_pages() or
>>> set_mempolicy_home_node() on that range.
>>>
>>> Skip device-private PMDs, matching how queue_folios_pte_range() skips=

>>> device-private PTE entries by checking !pte_present().
>>>
>>> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
>>> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.a=
rif%40linux.dev?part=3D6
>>> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support =
to PMD operations")
>>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>>> ---
>>>  mm/mempolicy.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
>>> index 914f81863db5..eda817539c77 100644
>>> --- a/mm/mempolicy.c
>>> +++ b/mm/mempolicy.c
>>> @@ -659,6 +659,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct m=
m_walk *walk)
>>>  		qp->nr_failed++;
>>>  		return;
>>>  	}
>>> +	if (unlikely(pmd_is_device_private_entry(*pmd)))
>>> +		return;
>>
>> Should it also increase qp->nr_failed like pmd migration entry above?
>> It also applies to your "if (unlikely(pmd_is_swap_entry(*pmd)))" in th=
e
>> PMD-level swap patchset.
>
> The PTE path only increments nr_failed for migration entries, other non=
-present
> entries, including device-private and swap, are skipped. I kept things =
aligned
> with the PTE path.
>
>> In addition, since pmd_is_huge() returns true for all non-present
>> non-none pmds, other softleaf entries should also be excluded here? Oh=
,
>> because there is no PMD level hwpoison or pmd marker.
>>
>
> I think what Joshua recommended in [1] makes sense, I will change the P=
MD code
> to gate on !pmd_present() instead. That keeps migration entry accountin=
g, skips
> device-private now, and will also avoid calling pmd_folio() on any futu=
re non-present
> PMD softleaf such as PMD swap.
>
> [1] https://lore.kernel.org/all/20260707191917.3213033-1-joshua.hahnjy@=
gmail.com/

Makes sense. Thank you for the explanation.

Best Regards,
Yan, Zi

