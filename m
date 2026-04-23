Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF3FFAD3E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 02:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269006B0005; Wed, 22 Apr 2026 22:37:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F2C96B008A; Wed, 22 Apr 2026 22:37:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094E26B008C; Wed, 22 Apr 2026 22:37:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E927B6B0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 22:37:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D7CFC0A65
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:37:38 +0000 (UTC)
X-FDA: 84688259796.29.0CA3109
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010052.outbound.protection.outlook.com [52.101.193.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7251C0008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 02:37:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bVkRk7X9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776911855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRnWokAAT5mSrHEynnnky9zTBKdjIu3CP17dRHVdyWo=;
	b=z4AbsALRXz657C9yXUt1f6PEVuz79cMHp22tGAzRC4dOQOnpulcFU+V5q+n1fLzPpMMxFg
	2cVzaBPLqZ8GwkejuGaqh+cFoqySWzCkpVcR04hfPzZMXv8HEmQ9+ScgUuOtojDVlsiVUN
	CX1+KSWUJFslpavk8DsJpGnzvP8cThc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=bVkRk7X9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.52 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776911855; a=rsa-sha256;
	cv=pass;
	b=hRJOWSZglotbDYLTzshyD46hpbpOGfFaqingjYgDz+ZwzeqzXbaIAfu1A8nH2TQloLKmXO
	96aBfNrK6ojJS/4hTbDK3QrMxLrwqtUDzaNtmUezXdsedPfKH1McV0wwDzQQJmE83F1zsz
	NbQMG79WExYTMEkYRDAujJhqX4j6OTU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yOiH/yoU2/bI68LoCSBZKhNRI/Wwp+EowobMoJXdcDyoNx7SqQ9Fc+4GqPx6Ja0sB3jPXI6nETWjCBFBDc45Osym26+diEl3h+iTYgqJ1pD92/3A0pCOP4v81lyegFTqTJL7qS2fukFhW+lhXVQloSCCaCn2xJIijA3TjE2X44dRq1vs2F+Ssbzh7Q3tCi2Uj8aA2Tuk4dntyDI2rezD2OWiEy1eFE3QXgSF12zwdwL45wI4Ju0BbU2USIIgvjQE1iJuO6CZonj2fKoFB5MLJpWeUOUxbFsndIYpdfxgmp+qy+jiPuCOUO8ApJQQb8TVvMlSePBsAutOavpklfjtbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRnWokAAT5mSrHEynnnky9zTBKdjIu3CP17dRHVdyWo=;
 b=LwCj+MQZFuzPd9FVxq7Z2dgtLJMwl8lsXODaPoiMR1JJrs323hqaZKgJMEHtVZxv1kTR8if/hRnsWEvRQy8/Y2fMMCk6ztJQlnYAzN/SgKk/TDUEW62W+9d0Cg8TbLtqiw9SVlaWfyzUVcvqMddiqa/bMfZLREXmgSv3oyjHFGT22n4KUPSRiQmK6qbC2jin1ItHvC784TbOVRDJfpAmYMeBjoaRaALccFqD6i1rvrq6IbHHa804UrXwqMSXL6lZLJgobrvfm6DGhGFXN5U/SQiTRbKeuNd6w8TLGQBPvVZ2mCglTRwwqriJuEDAuPYYAO3r7ZBFOdx8nLkmtEWB5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRnWokAAT5mSrHEynnnky9zTBKdjIu3CP17dRHVdyWo=;
 b=bVkRk7X9yrSz/GJLhAwRbPhiMMhv1VzAo3vMjQR9zHtMbokhHf3COebZ2SnkIssNs+fhCMjmOvbf5ssY6pfVXbWt68C0nKIh1XUe0/5XyuCVzyEOonBjjNNmpmxcEkgLAHVLhb8tz8tytP/WIMFtL4lRLnqi5NuXj6lqt7Vb6cKymf/fSkG0PQknUm9Hd7JunbATttG8jgM05sGVSlz4orqsHuv78A99sjHkbvevGXrObIbQB7raKuYuf+yzoYfQpSNMRNyR5mhxaScIa/vRIqsrBCd9ssFsd2uWWROzoqM6oLTTtSsT1qgVhlXWh3WqRvzSrpNYeLxmQqXXsHl0ew==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by IA1PR12MB7494.namprd12.prod.outlook.com (2603:10b6:208:41a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.20; Thu, 23 Apr
 2026 02:37:30 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9846.019; Thu, 23 Apr 2026
 02:37:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, willy@infradead.org,
 david@kernel.org, ljs@kernel.org, lance.yang@linux.dev,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert
 "tmpfs: don't enable large folios if not supported"
Date: Wed, 22 Apr 2026 22:37:24 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <8431F3E7-43CD-4936-996C-87B989F5CCCC@nvidia.com>
In-Reply-To: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0419.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::34) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|IA1PR12MB7494:EE_
X-MS-Office365-Filtering-Correlation-Id: a7e0d8ba-7427-4846-6e02-08dea0e141e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zTo7soe6jO/GWWhLZtcA4NJoK/IN2tVld/JsXQR5fORlc61KVpoI1Y6aGfinmnsB+FycLJcNgpUBr7ca+vl0sRWWYTug5x/YFy0xebEvefLekfHMRi+UNzWGRgHYCthaUNk8tGhkmULB3dPMU4aJyDNLzY4vad2QdXSGTm/iLX3swyJRHVKsnAMYPa1JlHSqgaxyDJnBFd1AX6GEELOYiZNyOF2kCkFaoJXM+X3Cc89b0PJv3RsJ4Z2rh2gz2UyG5uR3S2/0j116Zkm1vd1eZdGj4px60et1KPgjCXWuO+QXjZk5TWm4oJ0N/Wd3L2ioIk7yZyiclvQVW5kkHAV2qLSO47x5szKL15M/8DZbOR/BQTJprPWYU06+ZQo3gtX5zR/G8RmOUpDNK6qSoQK0nrZr0CAqiBCgCMQAZUr1ExDn2uu3qz5fPEQ0IT4dgSUGUnc+QTHjIxCdf+zQ3F4qM9ie8LdHCNAVEnyCE1cDHs/ntwx7G8PHEKdQZD1aNQj/Mcg+oL4N1g5Je/AODj2PgdFc6g+F6c7wZ46RiPypvYXa5k2TV/tNbh+9DiAI7+yLpW8GUuX5CNgeU2W537iHgcWNEUjvp0B2y/20X2BGB+xGICidg/ItflrAXb2aNac6vS/ZIFf55XUITdmCYJDOX9ik+IIKQQPmsTuwnCWvfTILHCa8g7nSalJNLxFEFykwPCZIdAZZG13q7tNdhjc2pmixKSPeIEvI9Tg0C5z6K0GsBJpr/Y66tAATut/oudiC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vbLJBiYGI/M2wm4oyzPoF1TO+wOAwTBBA+NycfuQoHd3xvJA3LQ/G9OEm4fi?=
 =?us-ascii?Q?gBXs5BQm4j4LWUZ753h7w8ezk/i51QemqGbd0pXzLKFHzbswZFAs4FxRJKLm?=
 =?us-ascii?Q?sn3ARkMSevSlucomFeT/Y0WzV3u74E6PvsbLOk0D9YQpL5jxB2XOA4CoHLin?=
 =?us-ascii?Q?4/IBHiUDuyG8zzhXMdYEtHWit+rhZ6Umndy04cAjfhjapqaJ2HRCDkTNCk/n?=
 =?us-ascii?Q?gjVj4BHWLtFi/PvGZrP/mbe08kOj4xLEzzzg2UG2iXmcF7/VbyVTX7+eIatm?=
 =?us-ascii?Q?rz/iN55gb7MIVR3inmWBCuuyT5G1C/2CjCZOST27gK+U2aevLUIGW90l9oLl?=
 =?us-ascii?Q?F7Y5Y6U36wvZvr6TDS54XNCXjsGy/7c3diVi+q01Vs9b04KHHfPi3i1dkstU?=
 =?us-ascii?Q?WZcL7H78t78hykWFQDuRF0eS0yHNhAG0YBGEi3u2ykw0OpnSljbME24YRS1i?=
 =?us-ascii?Q?10Pm8ag1Oy9TAnnjcSXI8iP7eOjYOvAmdaQl+ske7sWO0GOWufdjlz92nsDl?=
 =?us-ascii?Q?ypnIGCXB2qldlwg6EvrgBemoAJCBRU3RyayFyrVOTNxjxAmdR4+9VuoFWR1/?=
 =?us-ascii?Q?kaW40DYZI5qhtkKb88HbLObqap6e1x/QMd7+ZCEhyO4c6XUKYVUtVJwk9Np9?=
 =?us-ascii?Q?eSCSdk/Nu/weKvVXk8ES6Nm1QfZFzxNMoEPabBPTq7eejuahbH5LLb4t1fwW?=
 =?us-ascii?Q?8ijELquUkoAwP+j/3mxRcJE1aSLPIIRSlCCFu7CAAmdVIlcU4/lBFTXuBlzK?=
 =?us-ascii?Q?/A09ZSgWu4ka40pFsdZNEW/E0vJlgGhlICLRKdFKXAxOWSL+jx8j9Km+JgXU?=
 =?us-ascii?Q?vT0G29pByrpTWU150qwbLXI6gXVWAPDQBbwATGzlz5HuuSa5cjJ6eIpAhUup?=
 =?us-ascii?Q?2A1tLlxiAQB5F/0hzWX1DFyy0FTGMAqBG9Yjg5vq/cKr4dmRnKmZ7l14Hknr?=
 =?us-ascii?Q?Xc6rx5yWyr2T/yUa22pVq1wRN1/sxvY8n6BZ77Pv/tATIt8tM2Z7tnqtyxJR?=
 =?us-ascii?Q?I95e7XouzZwNA8nZwnUsvMMcmf71LxD16qO4PthOG2M4KXo9cFt0mJfy1Jub?=
 =?us-ascii?Q?Y5bRe4pSnv/Pz2g9v+n83xQOmtST48L/oPx/ncv0qNIIRiM7FpvQlbXa6dbR?=
 =?us-ascii?Q?R0N9tbnRQQkUTHq9uxFUZwodbiRMWj+mYvATd1aTQg/gsUkcorVXFGGO9aRU?=
 =?us-ascii?Q?PZk7TU7LF3MmjHkQkoAcjoxpXIYg0ywwT89dB3lTaDupXs5f/sm5nDenBs9J?=
 =?us-ascii?Q?mZrRtqAEmA1hl+1eycFXUYGKmA21k8jA1r3rKZTM+kG6Gab40sOyokZKotSm?=
 =?us-ascii?Q?7VELY8dLtXL++kSDC6AalQwd7987lavvepY0TGLLPLhomXAYZOUW9OPCrnBY?=
 =?us-ascii?Q?N4X6jP7xpT94GREYNqS+hMP6ZrkXryJ8qlSM/320shFuPeZOoBY10+HeBhgE?=
 =?us-ascii?Q?Y1HaaX/5gDn6++br6ciBRPdrOu3UtY/Y94hHvzEVREm/v46UypVxDX/aPcED?=
 =?us-ascii?Q?76vi/hED79l9V9P00nWhgEzDNxp9QXYrcW8fzOcky6RBkII+K3WqGI9cbHHO?=
 =?us-ascii?Q?Oj2XakkitiDTIJz/u78fRzlFaJsz/dgB9qZog5munT4umWnUVLdays1G2I7I?=
 =?us-ascii?Q?j9XV9IKnAIQBAFpymcW7JtpYuQv956jX8MSkzBVFP1p3OMBoVJ2f7xtwwWxD?=
 =?us-ascii?Q?rYQiD26vDhWuY82mpsHWKzrOYmxYAdRdO0jGOShZPC8u2e0/T29TM2NvkhWT?=
 =?us-ascii?Q?yZEVJfmhEA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7e0d8ba-7427-4846-6e02-08dea0e141e9
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 02:37:26.7863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ycx8p+Tlq/dUp+9Ym1a03I4vSS5Fr16Vr05YgY3aYva/Ozoj6G3M9epYXhFt410J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7494
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A7251C0008
X-Stat-Signature: c8smohy4g7ejuur6w1ygd1xqzczrno67
X-HE-Tag: 1776911855-513772
X-HE-Meta: U2FsdGVkX1/4a4y8Z7JQ5XbSHWfrWnBYAB9FYqoqab+cgfkXIMsqyA6Dw5clUuZb/XLqQW+aguo9+M2dmYmpLkTFom9YsUtuGJ77pYs+ps+vmOPikJzlEixJlIQxuQfUAnAgTV2S455XoLAYQLLj4fFeBP1O3/VBSce1NWhTn9mWBEE34ZSy0wZaHY9KMZrrapEjAWk1A7927gwWo77MD75DeJDQZK9KPAeNrj7WMG8kBX5sdO5VKAM16u9RNBIKZ77++c93oWC+qiaUeLltLVF5NUBo3o+80nmQFFDnQvs/LxGMyoKQXTzINSEqo8w2XNT4qdY1XC8/G3YU/4yOWWyCuGbcVuougCf4oPZ5GX4/PE81uvHb/BnI6AWwkFc2HkB/mm3En1Iuxn7puxnKBUSXQUmpkLdAtLa6NFbDdHWnG+RUsOBu7D6duaUUVjvskYiy1N5hfvJzu8VvgT347tmcqK1vS4NqIs5MdQOxerrnPMxyGuZkrA7ykFMsIl1aenOX9atswzvnNrtoPMLKm22sQYpWYiQXZYL6rIR3hyJOzWQjotK2r1b5qZ6JmCvYYURvwkIx3dLrvQthxFm6Lf3V1G84G9tXcihcZwlIF7PGue0+LDQ0HSrFkj8628ZRzZviw38u8vcS2KvwVvJl5NMbeI3GkfyiVuplq+B4SQ8KUrRFMQFYEtcdkFjiTP97DiWSJ/OCY6NU36IM8geng+blzvwo1FTdDHGkkcmBoqCxz87sXEOWK9ILNQ8x9PMzln/JiX1ze2C2VfsQRaa1Y9ledMfmcJBSfcyS/hg/7yLosU+vibLdKqRVUtbUnzZU0KuJ7Vs+ybak/asuSAp2qxyFR/1qcY3PdsFBivaKW6/JuzK9QWxQWVk6soWIXPiDqrZQ6WjGh9swkItoCWnWYg6eUO2ERNgTdUzqYw2jKme6YkndqZiLoxPUxEpGRxZN80yUiLOwZ2W1U7zBfKM
 ZnK5wnFJ
 L8UTuPma/7aRtxy3v3uygXnkwVb0CscB6YETqtMszXXdC7IdcYQ9+G36UqClMMfh8Kt9RfOHcCqrGdvXTuQek1VFWCaggIyTYIW9q1rn4UCMMchNisRHq6zdA8uhRFcCa3Khy5qZZ0TKddLMSNUA4ICyy7qKhexDjg0VmAzepVeMa8yA54XW0oJpPxg3R/tljIdS8Zw9kJfLAFfRm62ubY6s/HnY0dgMPgHNuDhVFm81AA8QwTSOSU1hjRsrWSmIBwBoyS0wKVy9q1aj5bs0LqIov0JkwC7A2pTfa3NYfLWW7XNFzrYLJqtUc7xNUXkDkpxtBJamYBEmX6j0TReG2gva0FjluNLu572GRSY21ujBS2NjgaVxUlRG5p9bpyOrCmfHGkGCDsLaxHoCDuVr0rhScR/OSarRci1OB89WCFE0HimWZTdZES1to9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22 Apr 2026, at 21:41, Baolin Wang wrote:

> This reverts commit 5a90c155defa684f3a21f68c3f8e40c056e6114c.
>
> Currently, when shmem mounts are initialized, they only use 'sbinfo->hu=
ge' to
> determine whether the shmem mount supports large folios. However, for a=
nonymous
> shmem, whether it supports large folios can be dynamically configured v=
ia sysfs
> interfaces, so setting or not setting mapping_set_large_folios() during=
 initialization
> cannot accurately reflect whether anonymous shmem actually supports lar=
ge folios,
> which has already caused some confusion[1].
>
> Moreover, for tmpfs mounts, relying on 'sbinfo->huge' cannot keep the m=
apping_set_large_folios()
> setting consistent across all mappings in the entire tmpfs mount. In ot=
her words,
> under the same tmpfs mount, after remount, we might end up with some ma=
ppings
> supporting large folios (calling mapping_set_large_folios()) while othe=
rs don't.
>
> After some investigation, I found that the write performance regression=
 addressed
> by commit 5a90c155defa has already been fixed by the following commit 6=
65575cff098b
> ("filemap: move prefaulting out of hot write path"). See the following =
test data:
>
> Base:
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D400K count=3D10485 (3.2 GB/=
s)
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D800K count=3D5242 (3.2 GB/s=
)
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D1600K count=3D2621 (3.1 GB/=
s)
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D2200K count=3D1906 (3.0 GB/=
s )
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D3000K count=3D1398 (3.0 GB/=
s)
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D4500K count=3D932 (3.1 GB/s=
)
>
> Base + revert 5a90c155defa:
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D400K count=3D10485 (3.3 GB/=
s)
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D800K count=3D5242 (3.3 GB/s=
)
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D1600K count=3D2621 (3.2 GB/=
s)
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D2200K count=3D1906 (3.1 GB/=
s)
> dd if=3D/dev/zero of=3D/mnt/tmpfs/testbs=3D3000K count=3D1398 (3.0 GB/s=
)
> dd if=3D/dev/zero of=3D/mnt/tmpfs/test bs=3D4500K count=3D932 (3.1 GB/s=
)
>
> The data is basically consistent with minor fluctuation noise. So we ca=
n now
> safely revert commit 5a90c155defa to set mapping_set_large_folios() for=
 all
> shmem mounts unconditionally.
>
> [1] https://lore.kernel.org/all/ec927492-4577-4192-8fad-85eb1bb43121@li=
nux.alibaba.com/
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Note: for more investigation and test data, see:
> https://lore.kernel.org/all/116df9f9-4db7-40d4-a4a4-30a87c0feffa@linux.=
alibaba.com/
> Thanks Kefeng for confirming the performance issue.
> ---
>  mm/shmem.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
Thank you for the investigation and explanation.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

