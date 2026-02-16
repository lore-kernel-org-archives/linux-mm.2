Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2434EE83837
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 21:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2C26B0089; Mon, 16 Feb 2026 16:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76C826B008A; Mon, 16 Feb 2026 16:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6508E6B008C; Mon, 16 Feb 2026 16:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 490B96B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:08:08 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1277D1B5545
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:08:08 +0000 (UTC)
X-FDA: 84451557456.10.9C84CF8
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011047.outbound.protection.outlook.com [40.93.194.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 12960140008
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:08:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V7quBsbM;
	spf=pass (imf09.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.93.194.47 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771276085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAlk7YR/CdgEcTVttOQFASqEqxAGoGpkc6ASbqA9GH8=;
	b=gmyw7zxRg2876fbXbW+NTToG7sGJmldTpSZhpWr7uYwcw3Iq6k9TIJNlspkiVyJNKm2uSl
	PISshz0GIaKUvz2VX/cOGvvszBCq0XaOYEB2MblUz7L4WREfmirLQkFui4kTwKMkee4x6v
	+fKGPhlfh0ztsRmP4CHuUDQy4d9tgC8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V7quBsbM;
	spf=pass (imf09.hostedemail.com: domain of joelagnelf@nvidia.com designates 40.93.194.47 as permitted sender) smtp.mailfrom=joelagnelf@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771276085; a=rsa-sha256;
	cv=pass;
	b=7Jj0eyIATgSHrToirCD59v8YudtRkXgsR/uFGQDgkdB5TapjjBBPjqSZiInZl4KRT4SJB7
	mHuB/lA5W0vBXjG4UQEucu5zftjjgoVrJn54S460+3Jk0w5j8ZAR/29OUG1Pl93PbqyWji
	1hAI0DO7R1Ryf5PsAGvGraj4OekRZjE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=p2s+wIOnSehc4drpcSeQS3jVD8g28uh4x1Bw42E3CZ5cU1CYYnlLGh0Oj3SKlmfSMfcGgLu1YERjta5bRqvg8BpdUCww6Mgk0YsWC/TfYhE4NmQBkq28Tp46A1cmxyb5pm8uOoNcBQKZqXp3W+VF8S5x+WG4QrUl8h7e4NWPnIes4ma8S9KI5G5LGbkO6VvVt3zrz9hehA+alGtljD4rSGxqy4OEaPGIKmh26IIqhHjYGB1ioQn8DhYQ+GVrPTP4WVf6/ENcgYWk7JPXfeWIXeYsjXi01J8mcwl9+7FMKxRgZKN8Ixm2r0JWP9oW0dbic/9isqHLEFgGmMwjV4vo/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAlk7YR/CdgEcTVttOQFASqEqxAGoGpkc6ASbqA9GH8=;
 b=wKbvRWjoCLA3gyQ08kZPra1Joau/FA168LBd9ZBYWh63Z5eUN6CDoKhFLTs0Z2GS3qVOuoNTbY/jiAlR8qfi6gSEDGtPvAoT8WMU8RScE31DwZ/ZlfnyLdhtdoY4bJ/NM5Zzcfp/u6y37lDs4UYcQL0JxKTL0/gtYPsn6zbVSGIfgvU8voQ//oU6QwlKlxv2DEy1N2PiEli5Ymm61bVHALZrcC1s6ukJKCceKi3u86fcvoL6ZFIkJOAKQHZ4SbWoe6mcMF74RTkmAMPmiEKHGdbgiWQf4dE17QNYOsepWXzR6/sRZxpe4KH4xhocVwak/Ap0V195+WHamtqXCkkLvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAlk7YR/CdgEcTVttOQFASqEqxAGoGpkc6ASbqA9GH8=;
 b=V7quBsbMsgb5WaMhFBQFTs1ZYfCLrnX3eDGtJQJkl1sJ2x3uRDjST1Tpg3Y6ZdY/60tRcicKEhPDgJghvl/jp0gNIcci+pG8Z3Mhlhomd+QrDKaePCyXvDP6m1/4XlKpZaXaSpDRRYmvLlNqnRCVHEOBLZlNHhsS9MotJxzQQzlo3RC1qdbOi+LkooeQQs2inO78uXxN8lYNFxA1ZPflzExMNGQ9mt3c7WVyIjmvZUHWL1iOsV2MUIWskvrUY1lNEMNQ3QYZHXWWyqpAdLm7qeZKIxs7fXnip+PAea+Cy3UWiB54b9zMyhIYEQLzYYtJoQTuVFWsFHFkdTNW1BvAcw==
Received: from DS0PR12MB6486.namprd12.prod.outlook.com (2603:10b6:8:c5::21) by
 MN0PR12MB6125.namprd12.prod.outlook.com (2603:10b6:208:3c7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 21:07:57 +0000
Received: from DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33]) by DS0PR12MB6486.namprd12.prod.outlook.com
 ([fe80::88a9:f314:c95f:8b33%4]) with mapi id 15.20.9611.013; Mon, 16 Feb 2026
 21:07:56 +0000
Date: Mon, 16 Feb 2026 16:07:55 -0500
From: Joel Fernandes <joelagnelf@nvidia.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Puranjay Mohan <puranjay@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Amery Hung <ameryhung@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Dave Chinner <david@fromorbit.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
	linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 6/7] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <20260216210755.GA1320175@joelbox2>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-7-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260206093410.160622-7-harry.yoo@oracle.com>
X-ClientProxiedBy: IA4P221CA0007.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::17) To DS0PR12MB6486.namprd12.prod.outlook.com
 (2603:10b6:8:c5::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6486:EE_|MN0PR12MB6125:EE_
X-MS-Office365-Filtering-Correlation-Id: ba66620b-374b-4bfa-4152-08de6d9f74f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?264HE+9dpLRMxJnEaznOZoPImPNJJDNabL0XbB+ZR10Gae2LClCYP5OG75hs?=
 =?us-ascii?Q?oNkCWGTXcv755AMYssBY5kyFNu3C/tKbCNnoWwLaOv8hCpdVkxrys3FUIqck?=
 =?us-ascii?Q?840s84aZs7W+aF7GeIWX0VzLjStlKmj1mJdBo4JMR8BengSGM0bT/bt80kpQ?=
 =?us-ascii?Q?9ytizKS1458Vsk0AA8U8Uoxyb2IUli2k47+A2TnMCwePOrARYeEjAq1EZZrB?=
 =?us-ascii?Q?dm7YU765sIOnT1v8CS7YLissRSAOSUFdqityGgB+O6Wq2QccirsGaUEiBoRl?=
 =?us-ascii?Q?7FzcSJ+9/xCgvwbwwjS5ZTUcKxr0F0R9NYOuHGMiXqvb3h4K1UYUgBsMU19s?=
 =?us-ascii?Q?yAzofbB2CLMwNvX2og44fgBeAISBj3l4iaoJGA41bBG6r+rQWpbDvE2H9ugn?=
 =?us-ascii?Q?f5AIfLJtD4e9xCRkrVSCX7P1OGBMKWFlsbmIHBgRkPkDrE36UWTRLqBLGrRC?=
 =?us-ascii?Q?RCIS8lfi4KMtzaapO8rBjelvZJCeF4PIiPszKUW/f/Kye8ngCSheGiqK/Asj?=
 =?us-ascii?Q?Anvr7OgusrmV7HIaJClVDz6dJUFZaMk+guydHxxMV+57Jh5Uns/lCBUgBXHi?=
 =?us-ascii?Q?o2cjDfa+6l3ogMK2rsk/znIFMux9Fo6oYQTazhYShi+yFsDk/aMQ1Vln6Qcn?=
 =?us-ascii?Q?Atw2Mw/F8aW4Hecathpdz9KDlD5zI69p6gXg5D+BTh5LfphkhYvk07PYHqem?=
 =?us-ascii?Q?mUm83G/bRasaFY3NQkW8Fa/V3/hdShhOc35qYrbjzmweUmvRE0MEwWdrafrG?=
 =?us-ascii?Q?oLHVKVlyKhHwSkYjBRJVQq6facsvjkuPhXIY835HiK4XlLWkVULsb03pqoip?=
 =?us-ascii?Q?Ehg2zJMKdw02sZ/7C69Z5f/BXaxLBnoYx5CWUyTEhvkEdz236qZNj7QJ58nK?=
 =?us-ascii?Q?f8yjYU3brYUbWZNet5wv8IMhW/8CuLwiYirU6WfdIzERWZeb8uOmmQbIP9AI?=
 =?us-ascii?Q?DN1pF37ZcyZQO1amUNH74PIR1T72H6fE974kEksWWgmX+sqiA1mbko5221Zv?=
 =?us-ascii?Q?1XCxiQEqY64HUzdDRI+lX/Ur8i+Yxy1Zfvz11ogsOYv6H3qp8oGfxs4C2t5q?=
 =?us-ascii?Q?DtBWZUeyxrAUFcTtD4PrTK8mFsDuOr89NuoQ3iB0b295VFcuiFERh1wtIczH?=
 =?us-ascii?Q?Q9JnfZspmaMNXeqyJAOlU7ihJqAWwIOWyDoGTSh25I49VobYsqBauTZXcCjP?=
 =?us-ascii?Q?Y0TwYGgzKJCaSoT1ivNkCGN3/UixMGzd+SBB7vSQnAJRU550522wcqpG8FEW?=
 =?us-ascii?Q?xyYbz9Wk+CeNmTaVeu/TUxGXcBCAdD+xzGswASmi+5mH928PBHEXzarapxZw?=
 =?us-ascii?Q?T3TuVAUM3iOmbKmzoXRkP0HwmgGH0jjc8aFs0JpfWCryeEGmDQ9vpOpAVLPK?=
 =?us-ascii?Q?sxtd6iWzSq+32uT3+E2VCOYzKz0Hx6YPpKcyrl3bFi4RNr90YkxWCcop0YMB?=
 =?us-ascii?Q?qdsFP5xtD36XF1Z8gYFp4kOZmEjolgPmvjM/4/vC/Ey2sr6OwpbKJU5ULwfI?=
 =?us-ascii?Q?iCRfcEdaYTIp2a5zFMey1AClAI9zYdmzg+Q5+YWd2wXURtIKGAk4faaMLYoo?=
 =?us-ascii?Q?tIkXwGEktEqjYZlqvc4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6486.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kNeJLqry5LpwdxejtgDAHAV3SHSUizt0xxBjhglxqRwyJxkzqiMTw5Emkdxl?=
 =?us-ascii?Q?dqfF6Fg0hb08qoCAPFKSc/1xtTGo7CWvLFrHA/kxPFK9x1KLgGx3JmwTzPKC?=
 =?us-ascii?Q?yRm7F+jMcvO0ENHii641i95OtDxWumT3RXy0598NI1LXEYM4JMFyYpwUtLzJ?=
 =?us-ascii?Q?b+l8JABvIQJvYyJuNOxjp5rJAUGMX0V424b9eyUgheyyz+T6IZHu1YkFPNqp?=
 =?us-ascii?Q?mMXpN251Rjzow7WmDzuyNYzhJA3+MDqlUmCb5RB7CWu/JcDX1wLUOHt+mXmC?=
 =?us-ascii?Q?I1jGHtgBTk85mutYog1wrRmkyfFWKf+2nXUchaBd7uzmllLjTUZxcfRaQcyp?=
 =?us-ascii?Q?NWLHGS9gyZcaMDDsotl/K5+orvNqNqnzxcM9nj2yxFCWWjGxGnnMC9sVSLXP?=
 =?us-ascii?Q?/3ImydvNnu7X4uujmPCUvXu55/7/ISO7mftQux0AvJSQnXe51YhJ7hDtIQu/?=
 =?us-ascii?Q?8PdWP0dIqyVoMk91tSVQh/YCxdTUFC9yDjuy0NNT9So4sGmdgSXr0N0p+BiC?=
 =?us-ascii?Q?gc9rlkSPCKL341T390vFyoyRhzHlO8sJwoqd7s4udqGSckoK/8Y2Bm5x8GGq?=
 =?us-ascii?Q?1NsiU9mZcx8mRUS8qnliS91MYIZwUJs/7S/XlOSEZBNtzQtrKCnG3S8jf/dE?=
 =?us-ascii?Q?H6sDl8FFsDiImiyqgj44jLOSp4wLTPkJHKCRdhIm8DANhNIPlPikUotP+iE/?=
 =?us-ascii?Q?a8kdLEJWUSqQYWhbu2fy8hFfzkutzBTlnYF2GqBxtefu7SIlNXlmn8CfNc1j?=
 =?us-ascii?Q?6P7Mr0r7BKV+JX3qeiw6/iVpvaDXdTcSqSmg5Z4KjRrYdoxplU4XBnxeIHUh?=
 =?us-ascii?Q?o6BMTgvazLaM2DNRcPncYctg4l4aCxcHK/6o97xm4hUbkAI9PIMcqnTC/YXS?=
 =?us-ascii?Q?/NbqO35GEil0C7DpegoHo6LiMc4YUfc8oZt+5bTh+A9VYaYw5eweX1p4qCVS?=
 =?us-ascii?Q?zXbLcwzhOrf0wk4xOqNYn8VkeXGGooRR7LBDEheXskqdDAiXZvH33NY+jNX5?=
 =?us-ascii?Q?q+T18PBPLOjLw/ay8PMe8tBrL9K1LxdXd6tvb5NQqhrXhRV40yVoT6Uz7NWg?=
 =?us-ascii?Q?KLIEn5fhbm/ZcmJe69M7ERNtfLfKjBm8/5Hc5B8tGiLfXjt3NA+QMbCIMrBg?=
 =?us-ascii?Q?sUIkf0HsMoKgYoq5FE8exLd1jQD2qk0fS5YvywGmZEaUAl87BItduibNMl+J?=
 =?us-ascii?Q?Y+O5cwPkmw8BwB7Gv9hwmUmtHyoTBE9tmf1buSd+7uUUuliQMJiDoYFQdNSl?=
 =?us-ascii?Q?ToBqksMzFuCWkU59q/57V/U13MPug03z728stvV5z+SANYzC6706itO+x9Fe?=
 =?us-ascii?Q?Bv6LlcXcYEtYIASn1mWKRvzbOAtfPTYttLMNj7cCfaGOCuBa4iIn2sktCiq8?=
 =?us-ascii?Q?O6+IejiQ2IZrk3OPHN1vNA8lxpg1+IqKHnytygtK+8KtH8IMZmuV++Sf5uJb?=
 =?us-ascii?Q?rtd/pOO0JhEU/5woXAQRff0GZlMepFVANUfUeZzXUPrsAYkrq1GXJa07Vezo?=
 =?us-ascii?Q?KvWpmuamClyr386wGhlkaBL/A/hT1WjrbewT7LgJGPenlJCO7wbFer5sOmcg?=
 =?us-ascii?Q?iEMBe+q4I2U6Rto9aTNa10HnrB10FizTlaXnzsbxYUjW2rIW4E9L7fp+evmQ?=
 =?us-ascii?Q?pvBKEu9kmF+ISNZhfiZpXUjoefAyeXtP7fP3KrSESEyA2Z30D2N54pRWKPag?=
 =?us-ascii?Q?TRb9cp7/dbS0f8dHMDhEVAA24xbiiuoBASaGAmrS+RL7JwdHdbOxf6it7hW1?=
 =?us-ascii?Q?5QY+S7lTdA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba66620b-374b-4bfa-4152-08de6d9f74f7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6486.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 21:07:56.4844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gCwQHnl3pBsWlEL/Y6KYJMoKqz6Ck91ZBkJGve3M1RS7asy2lP+qZoKO1di++M4UeriQKGrPrmLadSD3gXhnzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6125
X-Rspamd-Server: rspam11
X-Stat-Signature: h7u5hiw7f9fztx7tioxahksuc68sza88
X-Rspam-User: 
X-Rspamd-Queue-Id: 12960140008
X-HE-Tag: 1771276084-273883
X-HE-Meta: U2FsdGVkX19RsbAjuiUD3Br81xR7ClAbYXo1JdrXgoCDOzWr5nEyISYMHbCDZbe6UIfLaQ8ZzGH5zggeD7bXQKv+NcsGjaEeWdxGadBm8exYDu9sZJ8XFGq2xOwtigQHLxJ2e43/bfkZoAzUonzpgx3t/w1y+wMa/s3xJK4ua9fa8oPsRJRhIBmhqRbEKWYglxxEoBEdRdvIKpSBEVVpQXlSYqv3nYz4L0/yZpFNue/gQgMhNyFkoMf6QLNfBbQSOajIFzCNr0hsyNlqN+6e1l0TPAtKQAt01bI/Uju+KiPpmfP7QKQ85zT1BgJBrPLCYg0KuxtmMoM7cSdnmvqU6UiuFMnsXkdAekJogZaFOkAbFAjKdWWOiPZypcYYb5NvnH2snsTlaT4dC58DdsMmd9jmO96UXz/JsFWeoJN4h8UoY/2QEWqU2HvYmd1I7Y7r5qMijNhmkF4ZZi4k7xeMxAeB/OH7ZXjL7YYHsfAbJmgb96b6uuo/RXHTbzM4/gftqclVGnKdHa60gUHW4Bw0TyH9flZCkSsIp6J6H9MfsbC9QZW6QO/rDb2tZf/JkUitcmE/NFeBqNos1y1cwepo3U3faRwWv/qflvZitV4rWIlf+zF2A9R0bUPrCVq/OgaUzbhYx0Co8MxpuCxIf07qmTB59yrhJC6sCw5p5EW0uBnMSU8pU/2ozonBE51tWTCjIMZTfxqGHxBuBkymWRHz2P3orjAD0jlT9EtdY8l8pQVEpNDEq7Dm1HmK1lrE/ZRIl5lXRUGKFzVQkDwbZxeCDEf5hw8OTcZLnanYX9PnM9M7E49dnVnFqGZHB+4fCqhSvtCn2ePl4lMI7DC4i0B4E32ySl/6uxXIEQUqt/u2XLqtFaESQTHLqQ3waZ2WkzXKBB2lNXAHvsZJfn27yl8wKKW6aaZjpP78rWqWhvdzTkSlSAAvhdLqQth5RE1F2DLCayCTdN5uJVDrfDfrGNf
 4uxWSUeI
 Avd7xloxfa2XjNvfbZIw13Vilzh0dU5evfMKsCvEh/NZT4wNo/qhRL3yWj0lRMEkf3KsS/LYiVKeRDQtaeOfDxZnjXDDU0ryIUVYrsIECekC0YP294Bwzat6s0nBD64oyP5M7Yk4VrUvZ7bzxdQzPo7aiz9LyNYyZ+SmXiwCeOMqxDU/1OJM2T2y1PawmbZPdBBnz1FpvqsuzK2Sa0HsEW3GDKKBu7cbVAPfmCHz2BmIIS+esp/BxDE2Y6K642qVeR2yNaefNQEgtcsLAhY0vUWGTEWzHdxcFIjYCBYngsuBmVPozcbtzmVUx0bsTq/ph4ng++vSGnDDjmi8B8TX1w/BujlMWphZS97+LJCxz1BnwTK2CZ5tOhcveAiRjkQ/8OJ54tSx56ebGGzgjd4YOHNBJ6e6s7Qa17n5zM4fpW+WUSUUeh+DLDW7w1snPfgKBN4I4ifZpwCig7DXvrqbZQ2vbE7KZ43SiieHvDvKo4iesdWa0DeiYBYzOxuYmOrxKQy5AmccznHpK7dljsVa48VEliMwP7xBHEggnx0VEgv1HyEl/sJT7vwmTHXsq6p0TaDV2OJaXQy4qHlZnonek4U9I7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry,

On Fri, Feb 06, 2026 at 06:34:09PM +0900, Harry Yoo wrote:
> Currently, kfree_rcu() cannot be called in an NMI context.
> In such a context, even calling call_rcu() is not legal,
> forcing users to implement deferred freeing.
> 
> Make users' lives easier by introducing kfree_rcu_nolock() variant.
> Unlike kfree_rcu(), kfree_rcu_nolock() only supports a 2-argument
> variant, because, in the worst case where memory allocation fails,
> the caller cannot synchronously wait for the grace period to finish.
> 
> Similar to kfree_nolock() implementation, try to acquire kfree_rcu_cpu
> spinlock, and if that fails, insert the object to per-cpu lockless list
> and delay freeing using irq_work that calls kvfree_call_rcu() later.
> In case kmemleak or debugobjects is enabled, always defer freeing as
> those debug features don't support NMI contexts.
> 
> When trylock succeeds, avoid consuming bnode and run_page_cache_worker()
> altogether. Instead, insert objects into struct kfree_rcu_cpu.head
> without consuming additional memory.
> 
> For now, the sheaves layer is bypassed if spinning is not allowed.
> 
> Scheduling delayed monitor work in an NMI context is tricky; use
> irq_work to schedule, but use lazy irq_work to avoid raising self-IPIs.
> That means scheduling delayed monitor work can be delayed up to the
> length of a time slice.
> 
> Without CONFIG_KVFREE_RCU_BATCHED, all frees in the !allow_spin case are
> delayed using irq_work.
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  include/linux/rcupdate.h |  23 ++++---
>  mm/slab_common.c         | 140 +++++++++++++++++++++++++++++++++------
>  2 files changed, 133 insertions(+), 30 deletions(-)
> 
> diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
> index db5053a7b0cb..18bb7378b23d 100644
> --- a/include/linux/rcupdate.h
> +++ b/include/linux/rcupdate.h
> @@ -1092,8 +1092,9 @@ static inline void rcu_read_unlock_migrate(void)
>   * The BUILD_BUG_ON check must not involve any function calls, hence the
>   * checks are done in macros here.
>   */
> -#define kfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
> -#define kvfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf)
> +#define kfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf, true)
> +#define kfree_rcu_nolock(ptr, rf) kvfree_rcu_arg_2(ptr, rf, false)
> +#define kvfree_rcu(ptr, rf) kvfree_rcu_arg_2(ptr, rf, true)
>  
>  /**
>   * kfree_rcu_mightsleep() - kfree an object after a grace period.
> @@ -1117,35 +1118,35 @@ static inline void rcu_read_unlock_migrate(void)
>  
>  
>  #ifdef CONFIG_KVFREE_RCU_BATCHED
> -void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr);
> -#define kvfree_call_rcu(head, ptr) \
> +void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr, bool allow_spin);
> +#define kvfree_call_rcu(head, ptr, spin) \
>  	_Generic((head), \
>  		struct rcu_head *: kvfree_call_rcu_ptr,		\
>  		struct rcu_ptr *: kvfree_call_rcu_ptr,		\
>  		void *: kvfree_call_rcu_ptr			\
> -	)((struct rcu_ptr *)(head), (ptr))
> +	)((struct rcu_ptr *)(head), (ptr), spin)
>  #else
> -void kvfree_call_rcu_head(struct rcu_head *head, void *ptr);
> +void kvfree_call_rcu_head(struct rcu_head *head, void *ptr, bool allow_spin);
>  static_assert(sizeof(struct rcu_head) == sizeof(struct rcu_ptr));
> -#define kvfree_call_rcu(head, ptr) \
> +#define kvfree_call_rcu(head, ptr, spin) \
>  	_Generic((head), \
>  		struct rcu_head *: kvfree_call_rcu_head,	\
>  		struct rcu_ptr *: kvfree_call_rcu_head,		\
>  		void *: kvfree_call_rcu_head			\
> -	)((struct rcu_head *)(head), (ptr))
> +	)((struct rcu_head *)(head), (ptr), spin)
>  #endif
>  
>  /*
>   * The BUILD_BUG_ON() makes sure the rcu_head offset can be handled. See the
>   * comment of kfree_rcu() for details.
>   */
> -#define kvfree_rcu_arg_2(ptr, rf)					\
> +#define kvfree_rcu_arg_2(ptr, rf, spin)					\
>  do {									\
>  	typeof (ptr) ___p = (ptr);					\
>  									\
>  	if (___p) {							\
>  		BUILD_BUG_ON(offsetof(typeof(*(ptr)), rf) >= 4096);	\
> -		kvfree_call_rcu(&((___p)->rf), (void *) (___p));	\
> +		kvfree_call_rcu(&((___p)->rf), (void *) (___p), spin);	\
>  	}								\
>  } while (0)
>  
> @@ -1154,7 +1155,7 @@ do {								\
>  	typeof(ptr) ___p = (ptr);				\
>  								\
>  	if (___p)						\
> -		kvfree_call_rcu(NULL, (void *) (___p));		\
> +		kvfree_call_rcu(NULL, (void *) (___p), true);	\
>  } while (0)
>  
>  /*
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index d232b99a4b52..9d7801e5cb73 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1311,6 +1311,12 @@ struct kfree_rcu_cpu_work {
>   * the interactions with the slab allocators.
>   */
>  struct kfree_rcu_cpu {
> +	// Objects queued on a lockless linked list, not protected by the lock.
> +	// This allows freeing objects in NMI context, where trylock may fail.
> +	struct llist_head llist_head;
> +	struct irq_work irq_work;
> +	struct irq_work sched_monitor_irq_work;

It would be great if irq_work_queue() could support a lazy flag, or a new
irq_work_queue_lazy() which then just skips the irq_work_raise() for the lazy
case. Then we don't need multiple struct irq_work doing the same thing. +PeterZ

[...]
> @@ -1979,9 +2059,15 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
>  	}
>  
>  	kasan_record_aux_stack(ptr);
> -	success = add_ptr_to_bulk_krc_lock(&krcp, &flags, ptr, !head);
> +
> +	krcp = krc_this_cpu_lock(&flags, allow_spin);
> +	if (!krcp)
> +		goto defer_free;
> +
> +	success = add_ptr_to_bulk_krc_lock(krcp, &flags, ptr, !head, allow_spin);
>  	if (!success) {
> -		run_page_cache_worker(krcp);
> +		if (allow_spin)
> +			run_page_cache_worker(krcp);
>  
>  		if (head == NULL)
>  			// Inline if kvfree_rcu(one_arg) call.
> @@ -2005,8 +2091,12 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
>  	kmemleak_ignore(ptr);
>  
>  	// Set timer to drain after KFREE_DRAIN_JIFFIES.
> -	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING)
> -		__schedule_delayed_monitor_work(krcp);
> +	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING) {
> +		if (allow_spin)
> +			__schedule_delayed_monitor_work(krcp);
> +		else
> +			irq_work_queue(&krcp->sched_monitor_irq_work);

Here this irq_work will be queued even if delayed_work_pending? That might be
additional irq_work overhead (which was not needed) when the delayed monitor
was already queued?

If delayed_work_pending() is safe to call from NMI, you could also call
that to avoid unnecessary irq_work queueing. But do double check if it is.

Also per [1], I gather allow_spin does not always imply NMI. If that is true,
is better to call in_nmi() instead of relying on allow_spin?

[1] https://lore.kernel.org/all/CAADnVQKk_Bgi0bc-td_3pVpHYXR3CpC3R8rg-NHwdLEDiQSeNg@mail.gmail.com/

Thanks,

--
Joel Fernandes



> +	}
>  
>  unlock_return:
>  	krc_this_cpu_unlock(krcp, flags);
> @@ -2017,10 +2107,22 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
>  	 * CPU can pass the QS state.
>  	 */
>  	if (!success) {
> +		VM_WARN_ON_ONCE(!allow_spin);
>  		debug_rcu_head_unqueue((struct rcu_head *) ptr);
>  		synchronize_rcu();
>  		kvfree(ptr);
>  	}
> +	return;
> +
> +defer_free:
> +	VM_WARN_ON_ONCE(allow_spin);
> +	guard(preempt)();
> +
> +	krcp = this_cpu_ptr(&krc);
> +	if (llist_add((struct llist_node *)head, &krcp->llist_head))
> +		irq_work_queue(&krcp->irq_work);
> +	return;
> +
>  }
>  EXPORT_SYMBOL_GPL(kvfree_call_rcu_ptr);
>  
> -- 
> 2.43.0
> 

