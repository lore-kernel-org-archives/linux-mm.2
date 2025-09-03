Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCF7CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:30:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A658C8E0011; Wed,  3 Sep 2025 12:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A169A8E0001; Wed,  3 Sep 2025 12:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DDA38E0011; Wed,  3 Sep 2025 12:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79FE18E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:30:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2798F1607D0
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:30:23 +0000 (UTC)
X-FDA: 83848476726.26.BF9A448
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
	by imf22.hostedemail.com (Postfix) with ESMTP id 31B06C000A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:30:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a0yAlfhm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756917019; a=rsa-sha256;
	cv=pass;
	b=DHlohCGpyukIs5JN1z80Eh3Tb8LsfeWDt9mDfS9B/dICIe+SP5hgvoG73vFDj2hjQBQRjQ
	R7jw54L8T7reV9F2PP6urn5ij3zum+ixzVr1WqXaSAkLsoXnc5eg0UQf9YA6MiugXisZs7
	jniFEWu5rE6Pwfwq1tV2IxosG5BWfyk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=a0yAlfhm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.107.220.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756917019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ikd4Ck5K9rBEjcpNcMFAassNR2Z7UbD11SsNKNHLkNE=;
	b=N5HkO9O8RsW8L2/oF3ZxkdICTMO0q8xsCEyGhziwbgY6RznsKGfYTeJgphYCRmilHeJJSP
	KtqpkhbqljK00GbfDREOOBf2llIr6w//nsaU3PKOtVVU3tQ+kjS7HAW7xcluLtdGi9vYfj
	DifuSeVg1IZgJgeMVcuDUmL6e8s1SE4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fTvpy9Ci38F4AH7HNUsNAby9qGgUPub3+IUR1NryOii0QxZ2rCX5IMk976OQ7fxPKySjXNxOedkAHyUdNHow6mdsQZZiS9uWH17HyE/weStUibZygX6/QsnrinScQV6fxvToFM8QPxP8mHhL3q8v60C5tGVi6GMgQPIhApZR+J9RId9PAaDnlbf8iQN1MQyBKb/vwriFP9uNB+Y6QkDRhu7hyYYm/1iGIw5f96vzoIcyR9PgBynJuBT5iQ1jvx44QSy1GVnRP5jIyHEEtaiBYQI0BN5knSPBMdQXP9OclFNz3ysh4J65p9aDzXt2+sH0vg2LqbdmWWv4XP+b23tnPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ikd4Ck5K9rBEjcpNcMFAassNR2Z7UbD11SsNKNHLkNE=;
 b=JaFU7wDqp+FHklzQafHlsGT1qlOIvsIBb43Uu5APqYmXNd84c6IPtCzIlTgiGoxvAZOdken/SJsQDv8/b/OWYsH3Yfr5hh1WHhBILa9trNFcc4rdYrkwVpqe80JdEp3e/lF1T5NZRLNn3y8kEhtg/TUxuv5W+Ila+qEC3hMvNMuh4OEsj9OFG+vhmGddNG+lTg60F+tv2QxxRQEmTnadhAerpU4EF6uuijsoNalbg7zjw8RWGxAHvznxutSg3OrEukXI+a+uX5lwWvf2a2ynnoV8IVJFIbe5FE6hmNUJSdCcksEnFOB8t9SnIriWQqmVM14xQIi10X6EJ5tR3zd53w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ikd4Ck5K9rBEjcpNcMFAassNR2Z7UbD11SsNKNHLkNE=;
 b=a0yAlfhmSpxatn2iIgzBnQMnYC/vv0hgGXMPTnPMX9TT/gpCWhi2dxqTBje0gnVvsmjATKv2as4h1h57JPGX0QMBTnGf3wuZBPrB1kFEqn1qGJBHUSMgX2f1lUxo6JTCVWLO+qbZNjr2e/HVhEvYnIhfhUuzj166Vb1UsIpfVnGaa6bYvawBliECvcRytye7Pb0IGsFF9oY9FhHU/SiuGDNKK1z8jZlRMRDe0LG/CNisYOyWv6IQPrEqaVXI0V0Pn/guus0VJGXF4cEcGkaZlZQ60NutuXhCS0SN2Do8MkZ0hRS3kFw4kejMXhq9dFfxga25yKiBO+FJIPgag6xvLw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB8850.namprd12.prod.outlook.com (2603:10b6:610:167::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Wed, 3 Sep
 2025 16:30:12 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9094.016; Wed, 3 Sep 2025
 16:30:12 +0000
From: Zi Yan <ziy@nvidia.com>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Vishal Moola <vishal.moola@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>,
 linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/show_mem: Add trylock while printing alloc info
Date: Wed, 03 Sep 2025 12:30:10 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <087C9FD8-BEDD-4CF8-82DB-E3B909FEE321@nvidia.com>
In-Reply-To: <4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com>
References: <cover.1756897825.git.pyyjason@gmail.com>
 <4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0567.namprd03.prod.outlook.com
 (2603:10b6:408:138::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB8850:EE_
X-MS-Office365-Filtering-Correlation-Id: 41eb13e4-346d-44fd-e8ac-08ddeb072815
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vhDPPkL/HYV65FEtikGC8/5wl9D7uJ9M5kcsL0vVYMRdTSTM/jKvUAFVz2xR?=
 =?us-ascii?Q?pgvQ5mc3U+VDrZMefKRSBq6oM1tCstPok+e0zfJF9OD9VbY9fUQVQzFSM9vV?=
 =?us-ascii?Q?9GoGAEQPbdEEZBRi2Cb3v9blqMf3BZJkR5uUZ+amX50t9/Vh4SDofRmGNuGv?=
 =?us-ascii?Q?/yxqSuOEWheIR6AgIm4TkN6HcEvWyk988BrZlle6RpBAc5PQqW58ZepqbLmb?=
 =?us-ascii?Q?je/ow62w6fx+jRCpayS8WBHSHxwNGsvU4WQqjeYADFWNf83CNOcFkQog5eOs?=
 =?us-ascii?Q?hJTNxBLPdIvfdjINmBukEZqMbrspTR+49tN+VwVD38vUOTYmCUDpUdBwUK/t?=
 =?us-ascii?Q?EbXvAEBMuX6++Kms0HGTA45h0V8D3hCVmC3mzjuWsOe3f+Lor5MoV9XU4B4L?=
 =?us-ascii?Q?CvhG80/G0k3g87q6wRH7QolOhUvXIaMoUi6ATyVTV7xIGvWxUzcQQI399pKn?=
 =?us-ascii?Q?W5WX0Xhl4W8Mcd+IBrw5bGKRvHZph2WDz0QIequuDGLtKIgeY8OBtxTGGzH8?=
 =?us-ascii?Q?2WSSFt1GuO6uZD8Cejfabr2CkgmUdY4IXqiXzq3T8yD14WOvGzlHyeRB5Zvl?=
 =?us-ascii?Q?jZTWtZMiVfUHsliSKzXjiO3cgQhBMBVOXf8SEt9NGmUq0SXeUfayWVu3BIH3?=
 =?us-ascii?Q?qa6cZcm3KCv9G6pIMiU1zIJINAgNCODQgARqTGZezKGiydlOuaiOuwZFsRVc?=
 =?us-ascii?Q?Zov0sZCwq3XwBJSrMrZQtLMgOr+78Olb7tIdMDlgnpqgCGGZhFdSHVg3QKrc?=
 =?us-ascii?Q?SRacvEh6IWYj4eUrdK8nXT5NgQl8UOI64Vxao+V8akCYk0bsDjtFKbuEv0FI?=
 =?us-ascii?Q?/3dmAXOfZtoKoMGoDm3ZPUOK23nKnt/u9dOcnuNvnTlm01JebMOcxARtC1rW?=
 =?us-ascii?Q?vf791XqZd7HGbYnSOclY8TF80u+jBOyTwglG2asLUZ7c54xJHtXexL6wirob?=
 =?us-ascii?Q?BNV1ES5ZTMKBZh1SaCAnT3aGZgfogn1d5VHqBTSZ9F9TpYH+oMIAFY57fH47?=
 =?us-ascii?Q?Yf9yOkSELWgzg2pLJ0Y37E/yCHUjZmsCpteykuuu7cGVm6K7G0c+ouQwuKdQ?=
 =?us-ascii?Q?ickvplckfeuLiNLiJ21ekHAwAK65c9JJlAUe8oqiHgFS5XPl5mu/RaPs8DvA?=
 =?us-ascii?Q?hYM7I2QfaktSUFM9tcH3Yl2AzKKgpCp0HrerwPI3DX9VRK1AbOMUaC6I/MPO?=
 =?us-ascii?Q?q7mTRTCu+xHmtIrYptxpyAqyB/NdsDUN+IsCN19Xokd46ExvaUdSkwbO4nJu?=
 =?us-ascii?Q?d4ETULxcK0iWC0+mUbWiXZWYIxYnwIjR24syug/77dKJLUWJHW1pOad2cfp8?=
 =?us-ascii?Q?w5UooEBugMcSbBHQIX6eG++fbzvCcrUoSs3I1STIUHaz3u2lpq0T4r9GHQVR?=
 =?us-ascii?Q?6Vrrqumd5RI549kxc5O2eNhjbHCbYgdJLhHNZQ/5XGEZCdqgprIvane2mlSj?=
 =?us-ascii?Q?w//q+3y55w0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nQBrmnWuKz92x3IyNGgLn81rpn2u8nHjyWtV5GoQGjR8wuJgaMNsuj5cNCU5?=
 =?us-ascii?Q?yAMb4cLMvHg0xQEUyTWxdUd9r4hPUcu+qFpPwHb77ifx/vS+oRCB+GdJXqkj?=
 =?us-ascii?Q?iR5ElFRfYUh3vx6Ojmm26k+Zj1RLY3NpdbIgtzpXYcGbusDI+wuuVPkYyV4c?=
 =?us-ascii?Q?eS+0ydbFzRSUfLjxVOQ0Sq290H2p2Qh0kwl/9e8sB2g5yL/AeuZL6WxY6+8e?=
 =?us-ascii?Q?qSV7xPIF9iNyL/2vdHrgJ6wHqn5yYlcsmVIMi38+/Br9bRSXTUKccJ5izw/7?=
 =?us-ascii?Q?8hyvjHR9E5DcciB4xJ1U3JVs5wWbrd9Q+69tSxPafBYi9v31K6DCsyoT9Pdz?=
 =?us-ascii?Q?2BK3Yfi5Lin3IuFL/Zj89LzRidT1xpGayMcmmsAwC2zATF60CJcj1O4Cj1K/?=
 =?us-ascii?Q?QCOqnUBAf4lxH7Fx9St6iBHVHtso9E3uNQu4anuAT40OR8CkARPFGxmucrkW?=
 =?us-ascii?Q?yCZXAxrxSz/LIDEfLyNl/a9DFUVhN7MuOmjYmz2nH0KUlHt1dwnvvxCjHsWw?=
 =?us-ascii?Q?cPGlcS03gb8XXVA+7pM/LHzhO9XSpfks05erNEkyWyZR1+0G+ZTFmzZILiST?=
 =?us-ascii?Q?IA8xGPPdYxJ7w5yM04xUihMaJ8BL2a8TErb9NofvWM+rPRGHSZq3QC3iDOSP?=
 =?us-ascii?Q?9CV12uOWYsApIJMO4gskcrqr7PCZy2ns/+hgMxrbqlZ6cHfBtf8as4CL6evX?=
 =?us-ascii?Q?9QUHX9ZVmyZd9ZxFBNbCF2PN/3RRapiLEEzr7GbsSVycDqTk3W33fvSstQ5j?=
 =?us-ascii?Q?hmDkvK1u5brKEJV97JsxwJkNEBy1p7f8LRfxkXqr3/2b6O3nxIKNZH+TVxuy?=
 =?us-ascii?Q?AvSSuNhlW92Cc3LXXA6NiI8F/LmiWVykIa60vBWQtqgI3+TbxsnhISZ0APWN?=
 =?us-ascii?Q?zIB0tSmwC+5s6ciY/S8p6q5tymjfdsXA1o3axE6kKncHod1ghq5hTfpHSYL9?=
 =?us-ascii?Q?y+SiXpzVQaz9VA3AhRRi/KAKwacHoO8/QPV/w49lObtRTMingsnp1UyGqBtO?=
 =?us-ascii?Q?czEJkXXrgzZG6ox6PXakDxmyTtR7msh6I7jwUGclEgJtatmNunmA+nd392a5?=
 =?us-ascii?Q?3ATaHv1Nb50B4OTfmTdIJgkrqeLZHhxV9FSfyCy0b+W1CI4F7RLy47AdmhUt?=
 =?us-ascii?Q?W13OevsNC3UIfWkx1r/ihTqjy0Q7iIVoUxs+d6qyX3xeuG6XgKGS0LdWHvwn?=
 =?us-ascii?Q?GRviI7pxamJxtS7Io/orvSKy4s/m4qQ3pMFgNgTRSE7heTzj5jVFIeqng+88?=
 =?us-ascii?Q?gTFxh4w40NgnIWRne5Da8R3EKdusJII8RvXzJQ7ZvtUiouQ1mR7w+crBhQD5?=
 =?us-ascii?Q?4o/bd2KgZexL7nGwCtyq9FxaBrkq2iNCxg/jFttBkDVv+aKcXitLF2ti7Mwu?=
 =?us-ascii?Q?aI458vA2YTfR3GGcyYBiLfNpHaj52DKhx9QjhHi2k55JDCQnAHo5AEfQcxKw?=
 =?us-ascii?Q?IF6BOypJAQtqir0yf5E8moL2d2BnMC2xSLYVfKkwT6FU+irPEZ7zYN75Z/sW?=
 =?us-ascii?Q?B0uJX2sBd6rGxT9rUYbYESTUySoAfWgjIRmSsZNDiN8+V+YzwUm/GSc9MOmM?=
 =?us-ascii?Q?iBd30+6GIqH3nFGUZWtrmjNNIp1V3l4BshqlD6jb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41eb13e4-346d-44fd-e8ac-08ddeb072815
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 16:30:12.7434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gF519BJ583SSZWL2s04ButGgHZ+eOCCU/Wt8qR6/wXO3tokX3ptXW7Mum74Ge24V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8850
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 31B06C000A
X-Stat-Signature: rztc4gy54o716ggfcfoncimnnycmmaty
X-HE-Tag: 1756917018-592257
X-HE-Meta: U2FsdGVkX1/VcEKJ6CiHNnXg7GZXNTzwVAhJaDHEOTgl/Ix82ick1w2PZMw/icu7DGuy2faLYJRt/WYXG60ZlCMeg3PFvB6ksNCI5c9kgXMAFm8Y8z6edk0NnMQqpKvxyliIjgRxN7Y+Zi7qWo48qepJUeywEU27kvIR6I5uos4sRx2Xy3f+3hy9gw4k9tIBvBmyr5cB1mB/vsEQzs2ou5qL4eQNzpLUIcK9f2cV3swha9XizPMRPAY1LqLBySMmBfAFe+vojDGdm1MLLPEir0RaOHFasI/gI/yN0djnsmluysqUEGXNV6Se1rKoGcvZ7a8cdvVV1EV7Az+kAJOos59FZ198Vhu5SFF9JyFPAIxKh9TCBzpya4RGANk1R/3mAFsNaNuWWLs+pL5bh8YCcwCnwav8VEZvXzLK8rzDx2GILFjdzY+j6r1sJtdi/ZmO0qnBuJSToqzlsrSc+nqlZSt6SJZg9/WjfElykQgWq89ryujXfg64lfXaMsiDzP/t7hUaglcnJgD7ovWJNfyS4j6bLye222Lu2BZJfvtUTBGV1vvWaKRhkE/vzWzdKWPqggu7M1ZcBu2cffBAIuZ+B4aMvzcUHwW8QeXv+4bEqsq/sGGgYChPdPqS5S9Er8p7/uAs6457998nuvwbauw3DpH3tv9gmVb5a4a7K57McxofkDggrx4O/27uargKeeSsmZce09WCicFi0r/DQEUIjCOOtMh+6Zn/UUfAQDEw4Pyz2HpUpBWXSRc/8ozhzZ+p9A8OF/6aRlg6ZBfgjJcIMSimRviRbZ+9PI/tNRgg4FLWdWXAfXbvWesJZODXgjVnoQup+JeVlXBqw8UaZUzWvLZoYUZbUw481aBoixDLRWBFypM0SeQ5v2cgeh8bNo6E8Deu/Q1F9WLYT8x8QR2r8ZyzlCaookrILfgKFkeNH4HmDvItqiHTPeDmRr2h1EmjW3OuV1EocoPxDjPZUaS
 2HCuVjuj
 wWk0VRoSv8JYM1YQU7+L662Rk/7rith1Y/+/Pf0OwpwF6ZNMTimQmMv4nZTz349FWslXFU7fXiFkS97MKGuGFKXadgigmlbl+X7GgJhNBSTXsS/U1Kdn8813GVebURbwQySfhJPe3mCbycnSsAsNYQOLM/B6r9LNfSQn9xBiGijwa4eZl6k7t1dJHvpRMa5z9gEqecO7VsSQNsVkiSX9mbICgFgvAGrTOAEshqnlvLleOxitda2gB9gC4DZB278Ls/Op+gsXzsk3pL6wQvVyOjKfB66B9uGLCmArC9+FudvLZqLpE24L/oCk89LqrPcZ5GRrDQqZS9UBoS/gv4s0q6D4W/tpKfRWr7ThyeZyPl8UxKr5eG6l9WA7ljt1gEN4v8Br9pscDVK4nRXZz5HHXVjSPn186tbfKhPmfUlmumXXtWPVUWmBnrxZfathAcir+FydbacB6aKA0+9DUlpbdjDZ29ZX3YCSa0PZ3pGCU1OvxmDve86mDA+Xyz6CGRlZ11/e4eEEli1mWAjYhfGwSpVUF93PD9U6MWJWZLP9j2UceOj9YOFLLs2gQoTSVWASdHOHeXlhzWYNwoPg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3 Sep 2025, at 7:16, Yueyang Pan wrote:

> In production, show_mem() can be called concurrently from two
> different entities, for example one from oom_kill_process()
> another from __alloc_pages_slowpath from another kthread. This
> patch adds a spinlock and invokes trylock before printing out the
> kernel alloc info in show_mem(). This way two alloc info won't
> interleave with each other, which then makes parsing easier.
>
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> ---
>  mm/show_mem.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

