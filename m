Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31287C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:55:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA29E6B0005; Wed,  8 Jul 2026 13:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E535F6B0092; Wed,  8 Jul 2026 13:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BB66B0093; Wed,  8 Jul 2026 13:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABA2D6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:55:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3117314021C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:55:18 +0000 (UTC)
X-FDA: 84966361116.30.150D2D1
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azolkn19012045.outbound.protection.outlook.com [52.103.23.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 744A1140007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:55:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=ifk+2IIe;
	spf=pass (imf26.hostedemail.com: domain of jiahuitry@outlook.com designates 52.103.23.45 as permitted sender) smtp.mailfrom=jiahuitry@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783533315;
	b=0ZG9n0/eeTeTLZDAg88pDfEdps12fC9PPW0LvYxHM+rilBqGJN8QI/5fNKBIa8bcO7aQP/
	RiHQNjrJjbZubUWSC1KE3EQZB788+XvJrMwueXFVX4PsmbmT6Ov3P1F8hlkOIxUUUohkCC
	olrFTUYiSXtHlIB4UILvUcsoHLbMTQw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=ifk+2IIe;
	spf=pass (imf26.hostedemail.com: domain of jiahuitry@outlook.com designates 52.103.23.45 as permitted sender) smtp.mailfrom=jiahuitry@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783533315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tK308Hbv3khHV6wKnOB8APnVoMEGdx6YTUnp3NLXTdE=;
	b=P4FINHQP7pxQ1CUiY1K3uq6s45JgSHDuPovpdsT/X2L4zwbOmVPWbze9lNaxlA6/P6dCI6
	G6So+xcMY4bw9MTTywFDisuMgxZV7ZIdz+Yv62gClQabNQNKd80rE/08yj6mwmmupndjGh
	X4JV7E4U6quCMLzCZqYAR5EPOZEfsmM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WVUeAgdQCa9svwMFIiQh2Dn72p/mN4m7RGZhEV+C1eUCjzxt5Fr7LZdAfR+C4vjml+iYeLkmlFAgTbJbc7a6gGjbgjWHR1OoTsPcNjBOJkmQaw6vog++dzwTBpAqQ3IqHSrJrcSnOV4/xqAz/GxxcIPczwd9GyKS3mwJvf8KRqCfG9lLaGVrk2gwXbDNc6O6QW8U3RPWpPRFXRiCRtx6QlXQQTUvKIRIOx5U9nwmPmk0yW7KR5Ap+q86Joojs8HqwU/qFsJXhK3Tigu+xLjji7cwhecF5rt4bjGmcGivB5ccKtTfsSgJuOkAnsth/2DJieZWbvKBVsBOFMuqVSKYfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tK308Hbv3khHV6wKnOB8APnVoMEGdx6YTUnp3NLXTdE=;
 b=S16d/0VJUA9QgP/wfuf8PMDJvKir9XnHbsoCyTPg9yf/uGW6sBAsYcQDoR66dsmGMcCDYH34wdLNXUxKFUzI4Pp5QmHaa22s4FGX5vpQPr8SzuzR49YNjGZJ8d3stS8xLspehIbvx4FE/0/3qYiafrghVDPBAl0wwfbuQKc/cgKiKjxaGprbACbgeCt11dpPr8maUEIgEoKJ1xoeyHymLcXLA1/Aa+rhiedBZ2dz7yi6hIqu1S7l6Kt+t9kDq5wlA1CtjGr58qZtJM5Y6u7oHDiKNW9j8oGr+uvFBUNcxbQJu6zWjK8NIzSOFzp845N+SsLBwi0An5JM0+NLmpDazA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tK308Hbv3khHV6wKnOB8APnVoMEGdx6YTUnp3NLXTdE=;
 b=ifk+2IIesy4ApVp0buFR4qeEDXxYZIF61C+BPWaSkfBn8h0LoSvMhVCpoIBHWAE1XaqT6rzG8CMFHzaDcvFK3yc0TuBWKVSLZNtdmvMfZjIgpG1RlHKxP48r1pF3I7cvu7UicBoUU8jhh20Y84NqrzqwN2WDXqdex0d/cP4uR22VGuTq8sG/TO+G+jrS0ciCsUSSBhhG7xisTNpht/bLpyomcaoYV2QUHB6QNvMsT/uDw4cLRcz6tiafj3a/oumQ29dsxsQ5FlI5c85TlqxlDnCBLWJ7/+012uqCL9NOc1Y71BxjQn3/0x1DmRdq/Gq1q6W1gjb54EoXWI6INZ67AA==
Received: from BY5PR02MB6642.namprd02.prod.outlook.com (2603:10b6:a03:20c::23)
 by LV1PR02MB11998.namprd02.prod.outlook.com (2603:10b6:408:3f8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 17:55:11 +0000
Received: from BY5PR02MB6642.namprd02.prod.outlook.com
 ([fe80::97a8:6e72:40bb:875d]) by BY5PR02MB6642.namprd02.prod.outlook.com
 ([fe80::97a8:6e72:40bb:875d%5]) with mapi id 15.21.0181.012; Wed, 8 Jul 2026
 17:55:11 +0000
Date: Wed, 8 Jul 2026 10:55:05 -0700
From: Jiahui Zhang <jiahuitry@outlook.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: prevent migration fallback to non-target nodes
Message-ID:
 <BY5PR02MB6642569E180FF82F147E7880B5FF2@BY5PR02MB6642.namprd02.prod.outlook.com>
References: <BY5PR02MB6642F4D1A8BA92BFF3A034B4B5FF2@BY5PR02MB6642.namprd02.prod.outlook.com>
 <20260708141134.123360-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260708141134.123360-1-sj@kernel.org>
X-ClientProxiedBy: JH0PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:990:56::19) To BY5PR02MB6642.namprd02.prod.outlook.com
 (2603:10b6:a03:20c::23)
X-Microsoft-Original-Message-ID: <ak6LqsGOBhbtmvTU@s222>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR02MB6642:EE_|LV1PR02MB11998:EE_
X-MS-Office365-Filtering-Correlation-Id: 9067b631-5e49-4661-8c9a-08dedd1a0e5a
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|24021099003|23021999003|8060799015|19110799012|6090799003|5072599009|15080799012|51005399006|5040399003|40105399003|3430499035|18061999006|440099028|3412199025;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lGujeJ5XBsAs6q1G9Gwkx2YmUVpf2HJvI6hsyqx85shybSde0iVTOmX7NlZV?=
 =?us-ascii?Q?ewoNYreF+lnqfcAwE27INhiEoTyT68RrJgauW77LbtXAUyeC53WkJ9UWqLLW?=
 =?us-ascii?Q?fouEG/NQdEzPZzvy3n1WFmnr2AjemkBBA0+L/HwaTy/xjbIBuE9fUgKSu5zs?=
 =?us-ascii?Q?2Ss6Ze/F/evsku8xrvJgOdFxF4lvZWOJYySlKbWL/01TQ5ODND0Jpaoqgoti?=
 =?us-ascii?Q?/bi0uEGWPGZoLQVYIpxC7ZbIWenS0ESVUsyLpv98hoBftO8V4Oirbgdf8C4+?=
 =?us-ascii?Q?aBJr4LljAJkGSBycCf/DLurxEcchztf25rCb6ZP31u44bXoIUKsg9s4E1L0L?=
 =?us-ascii?Q?rDP9t0Elk723eB+TeL+cr7ptcqQjSGnRAJCvebSVkyFlHVu8H5hHT4k3lO1X?=
 =?us-ascii?Q?lg4gB/miW3mlZNylfkrDbzULciT32wIx0ZMGjUSrjsr55o440UOa49VOoONM?=
 =?us-ascii?Q?/TCVjfKaNvDG/QJBLKoHNxXnjQU3mRoGPz1gBW3BgR6/+doP0GbkiAgGwJPm?=
 =?us-ascii?Q?nxMGjGLnHNAiZIn+oC31F3Db5G4lMqznxiW501CsCflxjttfoS0jeevcvznQ?=
 =?us-ascii?Q?l0Vm1GK4nzva1os8fMD1qEBH4wy6KjP0xn/wgA1R5SUA8+9Fz7HBn8tjOqXC?=
 =?us-ascii?Q?7+X1PvwMQqm70l688rMZcxRq+nJsBXAocOsmVRDdktDeRljc9wWnpRVAv9S9?=
 =?us-ascii?Q?qGw4lmCqKin6dPeTafqp9csToiCDw1oNiZyqTYKazdR5lD4GNW6eHHSxSUTn?=
 =?us-ascii?Q?oqGnOHb1ysf0+0zwBT/oXsr00TZIj224izztJEiYswErgHeM1wnNU8rbmX+O?=
 =?us-ascii?Q?QWbttCmsfvGABkCauvuaobypVDYu434U3AR8lGgHTBd2ZgNpP3J7hTonIfZK?=
 =?us-ascii?Q?A5kTELNrCmHIaXx5pzcinbq9A/UDXbLWQgk+StCbc9rm78DlOeGUl6aSMUjq?=
 =?us-ascii?Q?UwMJ+7nXaL/e36Vp/o0hXRrEVx2SKkccN26RiIdVCSd1m5UZOLZXrTSl4hTl?=
 =?us-ascii?Q?fsHm?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3Q2L62MeNjb2OxtPjC0Wa4gkjJTbcVouVnloAjRElE50D+WBtnwC1RyqSpkM?=
 =?us-ascii?Q?uWiKaoJaabZkSC+8tEdvdQOb7QS5l5fgHtWR6tsYwRChu2hzac6kaRMVPIpH?=
 =?us-ascii?Q?NQD7RRH9eTNEIua/8FAAxrGruPTLVaTnnkubO+ytGLodO9URmDQ6+380GdFq?=
 =?us-ascii?Q?9BgNS99r3CqPNQGO7ZtcU0OT6mlii4VJcsLFTjfDG/QRrkP1GOYFXb7H+jYj?=
 =?us-ascii?Q?RVMulwuz7SBmuKwsWiGKTEGU64sRFPqRtYzPGTKpe3/9Acx1LpmZ3hevVr7i?=
 =?us-ascii?Q?+1lFpNzLfC70nXsLOC74h8WV0F3vCDWD343HJdTj5cvPssMxZrpq5kSF+8LO?=
 =?us-ascii?Q?9F1U+foeEU0f4FFRorADen9Dgq3INyrmbwlCW5S0RaoPq/n+owFoKWotuvdY?=
 =?us-ascii?Q?IctnQI9ii9Gi64v08evHg5bGgbW2VHpaVkRT2PrAxawc8woSQ9WWG7EQ83Pn?=
 =?us-ascii?Q?P/2IPZdEX8pg9MbQNcMj3J0A32DzPkO8Py4U/NYCSu/KKxuzpn3dvRbSzKb8?=
 =?us-ascii?Q?p3Z6ze9dkUW52x8u+CM2cYaEuRLmkgNlHlIGdeDSxsthvOkVkwf4hPcN4Xzc?=
 =?us-ascii?Q?GMiMzOJdMV9+DnzgjFtiyC/GlVEBDZl4PxgmVK+jfAYkM6kN84Ggft1n08JN?=
 =?us-ascii?Q?VVGBBgPF16dWP8ZT3gYjKgTp8JgkDGmsqZCchNKq42xbC6HsJWl2iKZ6t2xj?=
 =?us-ascii?Q?S7qfi8bN2DzkL1EtIdG5J3JAFh+/8a+2PkASShPqgUbLHODgBHO09Y93qsvo?=
 =?us-ascii?Q?IOixMMXCLqDW6Bk2uI24DP6hAoxtcUZC4lDU/oh5NZ+JYYQWAn/wc+obf/bv?=
 =?us-ascii?Q?dCzAQ/ptrE/xMhEkEqBlf64bbwB7W9+8v//cWguv5uNEXYa5GYAq8T3Q6smk?=
 =?us-ascii?Q?EBL4kRgALy2yGAG+D6oTkDrTeJslX3gBnZL4b6IVstQSSBiIDoO1pPV/JEY6?=
 =?us-ascii?Q?rXoXbi9JlOySh+xRWRhkWp498VobgNL2WVcwyLtJqLX67DWM44YDWpVjOElH?=
 =?us-ascii?Q?UdvvcbWXLfrC40MT3FfFg7umu2F8bu5QFUlyLGO/7jFaG0Yp37ThE6NYcoCz?=
 =?us-ascii?Q?dt/KVaOSWfI05ykSHQw3Ny2RjRrIh9Ok4MlcskKglTx8Q9qWGfra8jFIWxsQ?=
 =?us-ascii?Q?K0VO/Xq7t4gKZvmXxgtZWnFDyC47SzkJncKjOypNtKZujcMqGmMo9Pf6Pb/6?=
 =?us-ascii?Q?Wlfirt84mS5TIsiZHqKBYMk0JAf4zFTJPqBitXUm4Uzj/ib4oxKo/QADlYri?=
 =?us-ascii?Q?p05xCTrA+o9cQm/t+tPJX+/Nf0UeeNFu4TAIoQyhpHi7uBFqXOmVEX9wmCfE?=
 =?us-ascii?Q?poRtaVQVRUYdLUDt9rt2bUytDz5brw+kTwucU0UbUqT0YGZiAxvuvV9fqjuz?=
 =?us-ascii?Q?ZQdMiVtYfxvXE1AZSoEVc41SOGGk?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9067b631-5e49-4661-8c9a-08dedd1a0e5a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR02MB6642.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 17:55:11.7128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR02MB11998
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 744A1140007
X-Stat-Signature: x116ppkcpo5r36fh48q84eixei4uwb5y
X-HE-Tag: 1783533315-434177
X-HE-Meta: U2FsdGVkX18q0Qz8cH50Yrl833JHqJgaecTtoMHOLxgQ+w4jzC6hr/LmPfamKVhp3L4SjM1HuR84w4T5yG4WXUBWssfiD+eF2xq9G7Ap9osKexf/UInYYSN27hQudr3czlwrM6oyFTAsdlhZhNZ94WtqYLuxRTrb4RsFB0W8x3PQNHECnx3HomBJZIlwU09m2+KjKxJLl1OdWhe2UsGs+5nB1zXbU6YcNv3xztPX0Ttz1+yBPfFmz5kLDuTHUU9qJIYbpzg3Qh+MOBiod/InFjOPCJbEK3W1oKOBv3IpY1XWnXcBKl7ySdOyMM2Ub0MnXsKFv5e8CO4ljagXmLBDmddO4oJz4/fYBFtpEHTneRcI4S38IFLfaSGlK3QdXXD1IfsCQHXjjEAOSPAwEvXA2aifJvJNzCQF1E+R4fo1YrEFOvpt82MRAmUJ3BC5y7gHvA4SpwI/V5H2mVkEG/La1+qpJlLBO84DYUysamWKCD+EdlJomHOmARzitYU6sVzm4FvzhXXDaFVBNqgCxfrjj69EmHOnKu6JygGScCyfC5Gubr1Fr09OERZKhC+X//4yaDFP7DjY4LbZTTCIcN31r38c0yCHEDmm/PKH3ROKWVGHArYpt9QfYKxj6gfryBUp/4ND3Wq7o2+GDIVN+9jzx6mEFdU2FoMfEXFj09HCkGoPUw5QItPQhEVklAtpKujZ00Sh2zRYf02gue0yIfZ8AYDbAvKyTJLp5W+ZnY+5bnVnMBqap3J4xphIRLLkU9BH6eh0b2P4/2DmT70PSs+Kdi8svcM4qzq4inZ5DlbKMpWQNYRYiJ0lb/XJi9I5gf+zD1RwD+TkUj3HpiAabxw6aSv1kA6bXeG57e6UY1ioUcsTMyGM/scI1Sa+udICDnP/trw33ADQUGBr7Pj3yXPYLHSc3rSWJZA50sVJ6NHR+qD/HG6IRLnY4Q84UB4r08RhaoBeQKrie/QqCXSlMnh
 VKtd7yuH
 JTprDRjQ0ngc4GiUhKjXv56NjCqZh2xvvLEWsHUG5UCaItK4fnGqVUys2iyy/aYRs1H6rkLkM2TX8r2ayF575UDkKAuKGCQuaLUPxLM870HA7d6IKPpcXs+HocrAshofrlAHk1erDjd05sSsWgDK+7t9cDA3bntlClIv8g+heoEJ8YmAQHfBptULS1q27JKWZKtEPY1bxkAN4Cgf/R13Yz7sZL9Jgx9/SIXwuKQuWcjDkqAZkiVxOguwcjjeISFWrr2Q3blPeh67iRAZkISftTiOWTaGihYJzMyKv0yuo5w4+TzDOGUIq0/0KcmlmKbHbN4L2lFKdspSyaLiL8bYxSJf6NLLnDs+dbRJj1Am2X06nfW5ZD4yP/XY8mw8KhXcSiDC1D5M97IbCKKpzsX3EFTWp3uaa6D7BrHq9cjn0Y/R/BjsKnV+cnAdarCLZCEaY1Z+DkLwxW3N4jPFjGJdsAFiiCDHHM1ZQIIVjsmqG3vc1UnLgPzYaLKXVAj20fdUmsMZepLMIJ9NKb9Fcf0mvn8zQIUjsa3/KEorMwD4vovlD3afVGFajUm61L/N3ZnLq3t6TB9779m9cHIk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thank you for the review.

On Wed, Jul 08, 2026 at 07:11:33AM -0700, SJ Park wrote:
> So this patch is introducing a small behavioral change.  May I ask
> why you think the new behavior is better?  Have you find some 
> negative user impacts from the current behavior?

Consider a two-node tiered system, where node 0 is the fast tier and 
node 1 is a CPU-less slow tier, such as CXL memory.  Suppose node 0 
is nearly full and the user wants to promote hot regions (which reside
on node 1) to node 0 with a command like:

  sudo damo start --ops vaddr --target_pid ${workload_pid} \
      --damos_action migrate_hot 0 \
      --damos_access_rate 70% max

Without the __GFP_THISNODE flag, when the memory allocator finds that
node 0 is nearly full, it can fall back to node 1 without waking up 
kswapd. Then the pages allocated for migrate_pages() are still on node 1, 
and the regions that are expected to be promoted to node 0 are only moved
 to different physical pages on node 1.

As a result, the NUMA node placement does not change, but the following
command still observes successful migrations:

  sudo bpftrace -e '
  tracepoint:migrate:mm_migrate_pages /args->reason == 9/
  {
      @succeeded_pages = sum(args->succeeded);
  }
  interval:s:1
  {
      time("%H:%M:%S ");
      print(@succeeded_pages);
      clear(@succeeded_pages);
  }'

I've also checked other page migration paths, such as alloc_demote_folio(),
 alloc_misplaced_dst_folio() and do_move_pages_to_node(), all of which set
the __GFP_THISNODE flag.

I am not sure whether the original design intended to provide only
best-effort semantics, but I found this behavior very confusing in my
experiment.

> We as the kernel community disallow [1] anonymous patch submissions.  Is zjh
> your preferred identity?  Also, it is not a strict rule, but we as the mm
> community prefer using a formal name if that's ok.

Sorry I did not notice this.  If you think the GFP flag should be added, I will
send a v2 of the patch and correct the Signed-off-by issue.

Thanks,
Jiahui Zhang



