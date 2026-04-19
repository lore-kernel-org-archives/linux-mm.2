Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A297EA7197
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 17:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B866B032C; Sun, 19 Apr 2026 13:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02926B032E; Sun, 19 Apr 2026 13:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D18B66B032F; Sun, 19 Apr 2026 13:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C004A6B032C
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 13:50:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49405BAE94
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 17:50:37 +0000 (UTC)
X-FDA: 84676045314.02.9AE0A9A
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010034.outbound.protection.outlook.com [52.101.46.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 760B020009
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 17:50:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RfVlK8qF;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776621034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5OB/fZe9oCKVlRS4/aPMojvDMOpI+wRIoPjcQRb10Qc=;
	b=3USQ30b71xejGIrT5n8eTYp69cInB9hOl71T17R+KO8/tEQXe5YvnHQDvTVGhzBRxVVsuA
	ZhuC11YQqY6EBWghz95bFQF3wKGvus0QXEljJ7Cai+M5abqIdWZFULsi/C+e80KggbBUYQ
	AAWEv8ZF2PGb7NUiENzdBzBKsY8tRC4=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RfVlK8qF;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.34 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776621034; a=rsa-sha256;
	cv=pass;
	b=rP1qV09FUc6Ltk4To6FucN4KUGLrvxr1HfplzC+ittAAJRZ+Ym8wRsJUWW2xxMc8DOxjPo
	RxiFukl5tvXiBgg/oZCFqbHdIh4FOCF3w72/z3hC29ml3LMF1B8y3hDFFKVc5NrJQFIuPE
	K6saQ1AYmfevzH3O/CZZWfyplJlr1wE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c4HbYmNAmg+Ap2BYQW7kUX7ESbnvUBNgPJ8iOKi+BGJpBUc6VeqDknCcn/MnCJCYKpb88I0wXRTZxj92o0ltmbkaH3HB5Bn0UiMWE6xo39iSRHI1PdTkJaHarWG+6vzeMoBrompw0WzcOJzo1fPeY2tKXmqNwyUrc7KQK1K/sPLyzRR6NmI5MRTUVyDXekAVwuw5QnJISCQ8gqCL3DISgw7AB/LbKh+oJS969z2VO/ONRzL/JzEBsCJqufFHykeGoAPJ0wF6wbonTLoBlRHzj612p8J3DbCqLmaoHudWw3HPuSaapuw9hc+8pAUj4giOoBEL6c+sihGbhmaK1nHVhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5OB/fZe9oCKVlRS4/aPMojvDMOpI+wRIoPjcQRb10Qc=;
 b=Ojh1i5nV8TFK7CXOGiqESSpz4or54EHpoSUNL6xlGs62AXuKmzLdil35nJoDcMJUwGzqMWiitzYQs1gw3iSdOvxB4VT9UQLhkeMyd7n2kee/42/VsSIfNvqWYduaFPTWwH1Mo7WajdsZIjj6jE373GMKMGH9XhUQ3G/l8HxYykZVHqmaCKzkbOpBTtxRLiB5ZerP9x+wkJ98onx7qgZVtk9jVqrlYScFXUXZsoLqym6fdWSWjvO6HVKqJOzY++cX6FVjHCUUuCn3aF2X82no4+V3kTVnE/Iuahxh/j5mTBL7kh/9uZq41kEQfbDdI4a4xfFkaHAVzqUe2XwgQ5JTyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OB/fZe9oCKVlRS4/aPMojvDMOpI+wRIoPjcQRb10Qc=;
 b=RfVlK8qF1qRHDgJNCwT589usOKgMhYC73FXk7ipqVCad8RIOLA2u084PwhD4i1I7qg5+eQySXlGwPH4YcLbvQwsDgaRphWlXvveZN3jEfjwj+7NQ3PB/pu+Z5ub9GVLXNdsa4vdmZj3Y0mBNQsxNJce9o9xC0cAqTQFohHEYSqG3ZOS5Mc8ZyKRQnw0RRZQA82U30eOwHuLqSTZRF7XPnVoUwbX7XT85bo04xrgL8M5KCcASjTROH4fjFHxyTx1iHT3jlGUA1mCY+RM/3qQLaTkq9V+54yoGm3dXLR7AO5+LtMIWrYy78FPQmRQysXWnJxUEWfOwhMXimQnQsrtE4Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PR12MB7724.namprd12.prod.outlook.com (2603:10b6:208:430::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.12; Sun, 19 Apr
 2026 17:50:29 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.012; Sun, 19 Apr 2026
 17:50:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Sun, 19 Apr 2026 13:50:27 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <863FC1DF-BA32-4C96-B7E1-9405D1C4FEF0@nvidia.com>
In-Reply-To: <20260419174747.10701-1-nueralspacetech@gmail.com>
References: <20260419174747.10701-1-nueralspacetech@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0027.namprd18.prod.outlook.com
 (2603:10b6:208:23c::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PR12MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d1a9891-9daf-459a-1691-08de9e3c2552
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	xcNo1+hMrbgVnQnXTHRc3eaYcVvo0vP9pCL/6tWI6r4Tqywav+aZsHqvDXwXfilRDgTpZOLlH2d8NIR2JiUNeW4F2NII9IAV4PECZAiIODKVQAHcodM7D/bmsMHMHDzbHeI254/Yxo3DQjuehZGeR66j5Ug1UMtxTbHTcFJGI7QFAW0KOUm6OqLtZDx4CAYPbBGvNh4f7I10cpZM3++twhWdeCE98uPGZNn/n/fh4mHLXon/fxYQbjmJ4l06Rr0N0B1RGNmYkgyoU9Ipp4eqgMf1hOyvo1RWolfzLCh0UqqxgcruOAcSW/iDFAlAwxZINuwpzVOwaeru45DF7gEDxHWmmhwmwlLhayAGh/x15sPCTRyvR3NMuoPwLEGWSMOx6jstptkS1W6tGD/40/2n/QSQHMIFcObo3q2S/LWx5VWwEQemRZqG5UAMXKbbDrObD8Bnki9XxO1SjxBFl3uJVUTC/aMa/H3CWdUAO4I3NEaP+pD7pCDDc/nvCgEwwPnuyn1NAVzTozKX8f3riud1t/VO5Anq9B+AdXzQVb5L6ZHZIrvchoYUhLKMS5w2QhMczv/zE2xPVkhqAXLaHS91Yn+WNSpzmqG9rX+e4ojMhzZ02nD8PhYYEiD6mt3fgVw2bHeWWraMT27GmOcoF3ml+PaU/B3B3AVJlvfmPxepvcuIdYgKhzl4LE4YECGmxS8ee4JczicBLBf4vIRrv9xeX/blKTQHS6b6xt3c1py58sg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?SazDid/isRleYUOiL7IYxHxtiupdBs+rV0VI8NoPEUh9tmjEtaeh55kbr0E8?=
 =?us-ascii?Q?1EwG3Kziu0BWypoaakvZriVzAeekvaEciLvSHzXTMwvEDUN+UwhQYIe4UEUI?=
 =?us-ascii?Q?U3qhsWyG2NLPXt27GmUd7MAVjcazXUFOEVt8/NIpIgXSkXYIGRt8lgMn3U4F?=
 =?us-ascii?Q?w5+XKJ7aa3ocf4gd0qGec9RPQzQT00kwTDgtz3K+tAodNk5uO9epD6fXlTuz?=
 =?us-ascii?Q?rXKV20OHbQBIoaZeJPgvrOSL0qtw00qXLjWKThK4yBSisO8KhftDrra92+/2?=
 =?us-ascii?Q?dlX12YedsU34VwC5lDQZfrYzx+HFwr+qqGj8N9Vu6ynzeXXIDkajSXNen7FP?=
 =?us-ascii?Q?XwgpccaUO49QrPlMHSfD1u976k56wLxF9dB1jnD+8qqEgoduK1RWhhzB4ELv?=
 =?us-ascii?Q?Z8eSrMnClUhCUalueOtLELfJ3qLS/HSwFR5fMRcyoLdXDDdetF0y4i3Xl4Nk?=
 =?us-ascii?Q?FpQnH3KE9ubpWayLx/5osGrFnosImvCvjBNwUTsUAJNZ0whN/m0W8aPwG7cW?=
 =?us-ascii?Q?CVFWfUw2p1ZSVX9E77mPYbLyui+vV2aljquTStNmF6OsBrmdZynvgQ0ng42i?=
 =?us-ascii?Q?sNAW+CaF+epbbWUtgDPaWyq3p4XPmlBDcJeFGb7BioYQAFea2+AUYUbCF9Sm?=
 =?us-ascii?Q?kEv3EUK6qkra7ftcqaDeBAMXqWtK2g32Dkbb3rZunYWyqts+InnRw0aK5xln?=
 =?us-ascii?Q?dK/x6xT6a3fogE9kIaiVsk3L5MQfsg4G9JXyZnCMkt+nwq8FrItDZjj8nyEC?=
 =?us-ascii?Q?51RUzEQ8NJy+6HwP0o/JOyEvgkXby9m1poNe4xOqowGXxVy4lQUxCvZpJjx4?=
 =?us-ascii?Q?TF+F4mjM3YHEL8zmpOPcfN3c5Y9wOxD7Zug3LeWskWrOElyzdGxW/P3hMatw?=
 =?us-ascii?Q?/2QIvgQGxuwfgsE6iTcdCE8yupn7G/QNO7CprESPuIgTBRokV0fzGQFpnYPy?=
 =?us-ascii?Q?v7WP2QdoE1eSbGH4MIaK+GezqQ3m7BG9MsVA0GfkE9g4UFSBgvgb4OvkgzEt?=
 =?us-ascii?Q?s/Ijlw3lRk8LJ6/DMBVecE6665tjijW/JAU2gkpbgS8aC2ImggPyfHg75RZL?=
 =?us-ascii?Q?KL+S3MyXFBMhySCHCYGV0NvDjEeNuSTztiE/rtIdVjqs1oKSbhLd5Q8rJjwl?=
 =?us-ascii?Q?WyJPMPAJ1cRtvy96AbSp3egg17cVfaTPEL42JtBMQbtzUEfctSgFeGAf/nea?=
 =?us-ascii?Q?uc165cZaUjAuIrsUdyn7HYwOh1z5kBHerj/4YPB4lgPtL4K5Q4rrICR1GaO/?=
 =?us-ascii?Q?DM6IXSzlB+FCjK5oR2aqgNeJmzjk3wZJkyy9fvCCYoCFxRXTWpGGW8KHG28S?=
 =?us-ascii?Q?c6E75A6/OJa2z1VMUEJfiO1Q5qKMpJzY/CPKcc30MEAfLU8jM0hsgCqa+sgL?=
 =?us-ascii?Q?0RfQi4xsqeH6BWWVTM+OGPyLInMmnPc8wwbnByVEvwLhAaT3ENkKXw4Pukj4?=
 =?us-ascii?Q?uGaTnukPH862WfehTqKH1i2lgkDPtNq2xHhHVXaFQS4TM1a519rebGas7d2k?=
 =?us-ascii?Q?84g3Hrdhw13dH6FEK2b0cwyIfkw7Q35eQ0k0d1LvfZSvLXF8ijpOqN1psEVw?=
 =?us-ascii?Q?kWRkNTBLxG4PloXIXPX2rYnGLFZQ6F2aywAumoYmJouf7U2CevNzr6o698zz?=
 =?us-ascii?Q?HCAgGXwdsGj1F6KrFJ4uI9/69Zof5B0Vxg35tWqbuO0M4XMRGCTdyffTXiDY?=
 =?us-ascii?Q?K7375IAiBNGGs/FEqz9Bmz5r5nU+KUeQ8IrnSQgAZV62qcru?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1a9891-9daf-459a-1691-08de9e3c2552
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2026 17:50:29.5841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AafJ3yv2MfMoAaEGhiEsNl4TSkhUzmfLCvKg+vkPv8DfIO7T3aDf2ivUHlsf3pNW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7724
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 760B020009
X-Stat-Signature: 7kahhnir631xi1tbgx78dxqo5gejdcot
X-Rspam-User: 
X-HE-Tag: 1776621034-543234
X-HE-Meta: U2FsdGVkX1/E7ew/8z0gKggb9YgVmICX6DsYqgEY01IAXswsqvQtsWuTYHVg9XMuWXbgYjYINibfTaukV30x+5tnMRw3hWFELeLxZL7cTHC4Fm5RQb99pWw3GjbeNQrSQVpIEdbgw3DVp752ZpjwRDOptQVK26gtc7JtMJx0jgpyF7961mdRrvLaIjjzzmVTRtMRs4G2x2dzSzkFy04HvMV3FuOdSzFNbtFZhw/UQT8eVSmgWEagdyfSn1+HreN3TnJfMisNfjtNwRWS0PgSYGtjW2tDrEfaavNv0oxFYBZfcjDDypeXS4kPAzYhhWGqj/6sj39bqVdo0BBwHfndN/yfwgszhiSXYecXZruBRKHCeoGkmwfx1Q5t2l0RhsTcR2IOe/iGSnO56sRIgXCJARV9HEYpVsP55vuu7cI97ODs8q1BYZtdIchtFRThQYgEE0+wQ3p8e1M7LL1+7UP9R4T+gD6IUmg+6IawMTDAxRJHTrGClVWIH6VxMWfQZWn3ABv6fRK4AnQ0fX43/c0lOOxX3LRkQ+rjHJeFk+aNaAH93Pnga6p12WBTEdrkEyDMG7GkneB3Myku3aE+V569LaqbsZsdXFTy+zlZtqfW/dDcYtTP9mkGCdhwjOZawXIOknGa0S62vIwmJytkiBY961ucjuD0h/nOaW0BgrFLTGRKLxiIR0UuEKqdUYSYJnv25GBOCZPlxdg0RVQRGcBOWmO5x2yf2ZFMC5YFghbXo1Jg4XzYPSfxnJcW1goV+mPmaRGCHzJwcq/U8MLb+GTLSGq/gstM22EhKId06zjOYRtSfHuAfO1J4uyUtLIWG7Ob8Obsds3xwS20o8oum4RPSE2z1mTr3fWRMaW7BONGuIGdLPYYZCdc8h9Vpg93eafFDj5bPwHvh6YrjwyFLWc4kZuw2ALQVhyb8ROZWigFYeQusUWrnYofMi2M6zEKzDwA2001f2+TQ4dNIg+4D6I
 8KkzoAUC
 sAqEW0P5qxW0tRwvaRxY+Vj2jaID6UY1NYBv9xJFoBp/CmdnMHgYlTgGR7B6+XpN2zuUChh3+Mnmg920GEEWI18tU/TyIuG2+2+pzVgbFQ7k4oWm2PrQiLLUfbDngVZk3LUSmN0VzYnm8dF8+CVXhFvISK+LGgz40XznRG2z16qq4NtPY1zXUZBrGxSOa+1ExVWjT1TtMWxy7WZySWtVIe/UaDwkuVhHEw+8+5Z8J7X6LMoeHhfTEoAzkBo9m9CksotKdT0Sm6Gp65sGCUFq5U+bx/TxqI3gKUAvi2NIaYzv7VT4HwZP0oRSF6OaxrSUp2JRItbd5bk9QEKMW0RLu5C4u00iQgO49bvdYz1mRNdegBIcn8bs3geoWMdwBs7yn/6/AL0pkp1FalR78jpxVRJvhSperHwYWhq47mcX7+TmaKs/qJyrEJKVLzLz35F0wtEuYoUm2QSkl3KDJnqnhtby3OOQiA6Wdxk5sGnMlp5XUVbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Apr 2026, at 13:47, Sunny Patel wrote:

> Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
> with a simpler VM_WARN_ON_ONCE(!folio) check.
>
> Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
> !is_huge_zero_pmd(*pmdp)).
>
> Refactor the PMD checks, making the control flow
> clearer and avoiding duplicate condition checks.
>
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>
> Changes in v2:
>   - Removed additional check for pmd_present() as is_huge_zero_pmd()
>   already checks for pmd_present().
>
> Missed it in first version of this patch.
>
>  mm/migrate_device.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

