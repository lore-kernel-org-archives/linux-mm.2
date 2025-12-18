Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D47CDD6ACFF
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 19:45:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1670C6B0088; Thu, 18 Dec 2025 14:45:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1142B6B0089; Thu, 18 Dec 2025 14:45:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04496B008A; Thu, 18 Dec 2025 14:45:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCD7B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:45:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 777151402F0
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:45:46 +0000 (UTC)
X-FDA: 84233621892.30.DA631F9
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011010.outbound.protection.outlook.com [52.101.52.10])
	by imf07.hostedemail.com (Postfix) with ESMTP id C19094000F
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:45:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V5mlB2tf;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766087143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WqXVZJ8IbJ3tHhozCZZcJffBv+F+T3zLw7etjAbaDpc=;
	b=v/mQdY1TrRZkeLVgipk5WQJuMeT+izuBqwq+4rGALzGz7fFIu67DWW7VsfgfWxTjvxyk1Z
	1TZdSYpz4Befav0/SuHg7MjCxRAC09JFCjSbBI7HyxbRyVnoQgjqWLxiQkw5sPNm9mqREz
	rnPZl23DWsNd3NSnQD1u0YbHdILGOTw=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=V5mlB2tf;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.10 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766087143; a=rsa-sha256;
	cv=pass;
	b=uzqC7CSTnfxll7NBg6AzQBA+10EbWOlodrtWMgkAIUVvYaT3J6DZmJFEqB5howLvDmQGro
	xI90gxO6Sb96HOXPxICZuHU3kv+x7dm7KuHk3dtGTal45igJldzvWFDrwuzHz3E+83jnS0
	VrjzyttBI/lgNEwE7HYCeWGcivxm9UU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S/cXhh6+/qYu6cVfx3xikVz9P0AQf4Ba9Z+mc5rJ5tGoeWoT1zDMoqJAgAxZGElCYARaf77g2TBefMkC6G2UovCai4sQdZQpxHvmfjQLJzZdna8X3RxwpeMW3QGfkE6zJmG6+S7P0ui7OXFlHNX+QvnJtHT/z1rT2uWZazJzOQmkp3zcRF8TfBgkXZcX9EVUpEHj0Zq59mMX0KuTC3MZcPSmzuFeM/jd21WT5aX9uJOff0NSCWvEzVMabhNoIriXJkACL+qSUQ6U8LnOui1+bq5pLwe3qLgwtACwQXabuBGMecYFn+EQSdVq4sPF48Ggo+d5PiL0vq1l5RqR4ZhwwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WqXVZJ8IbJ3tHhozCZZcJffBv+F+T3zLw7etjAbaDpc=;
 b=fkq5gcsHqlzJes9iKskmQUx6CyLIzHevJIAs8nnbC3CStvPq+Q+pgWqBXtXbdofUHBuUI8fWMKcNlYXQ9+aRoe9wa1GQhKKvKQceVx0SqRmdmf4zF0cgfPR2n+5xcaOn1H+xQf0rDRMGFAZDCaImpgVMmjTFvGa8H9n0hyK4RInS0fsRQ2XqurFIKqjgf6i5KhjsoBKzz7zpSdHN96JvCa5ldDJSWRxyA6hNiOTOSAec5LIdivxPBYuaPWElmaEc6V1qQn68qw2HS0NsHwWJWgjF8xwqpU13k/VN+JfhHDUDuEsqJm8pz7UDwwmSpBh9HqcGlbDxZ8YcH3GaijBRYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqXVZJ8IbJ3tHhozCZZcJffBv+F+T3zLw7etjAbaDpc=;
 b=V5mlB2tfGYLKNhbDXBDRED6y5kyggLKPPjv6evoaVgRzBtIuTp3ivCpcbLYDPv1LAnEnqPrB+NTR7WiNrBwE5/+mXoI84wqm+sBLkMXsyC2MJswwOKZ0mojnIiaXEebgG5R1QJEW8MDWUjO1TgBwl7cUC09HQW42vVAIKTo6CNWSFvctHD/Q43+ZtDLcIIhQ1mZbAOHwg2Wz+oYkdsVicqVgJy+QTJGkv9PEdV6M7+L1QKovNH0gJYXEDx0opp0sWvU9Pl+QT+AuTOBdfUBFr4BFtBhy/PPvQgdb6pctMYvTUnVV5mBekD/PvdOYov4BIzQas6gu0AerdcAa1sOoUQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB7008.namprd12.prod.outlook.com (2603:10b6:a03:486::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.7; Thu, 18 Dec
 2025 19:45:39 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 19:45:39 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 richard.weiyang@gmail.com, osalvador@suse.de, rientjes@google.com,
 david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v5] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Date: Thu, 18 Dec 2025 14:45:37 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <0E77F151-99B0-4F67-814A-4D79439C9A88@nvidia.com>
In-Reply-To: <20251218190832.1319797-1-gourry@gourry.net>
References: <20251218190832.1319797-1-gourry@gourry.net>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: IA4P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:559::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: a980e702-5650-4123-04c9-08de3e6e058d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?PfQO/oWXF3gO5OKMLeaPnkyKZ+W/7wcvlhYdFTu9tRa0j8Rhc9YTa9PjwhWM?=
 =?us-ascii?Q?5Qv8nZCezfeeFJPzeiFuL4FYnaPsA05Qj1brYxnGD6pJI24NUIQuQiMog5Kq?=
 =?us-ascii?Q?5HyqXYY/g1x1mPSO7z/cD/ltK3m9PYbt5XqV2YpGDftIb33xFkL3mmQ+F6S3?=
 =?us-ascii?Q?D5Hfg/r1Vh5FUnPKT9EHSsyT7A72m0hHnTA+clxQwrQ+zy3t5T+UzsvFfrkU?=
 =?us-ascii?Q?JH+iiVHXdfmWyvVEj6IRnyMsty9cGiq2dqD3nSdv1E9MgvcbcCbXxY46axdo?=
 =?us-ascii?Q?VZ8ywavJYQ0d9ISYYkq7J/dUj4ri/2zoAe8+TSI9km3qbMrdul5OK8jXa6M8?=
 =?us-ascii?Q?V1wPTAxzYOSn0Iwvt4hBSp0yNaGWx/d8iiiNKaXpDwAeBwyYbtpodVV3L+j9?=
 =?us-ascii?Q?v+wT/THMU3X/pSdbxi4v7dEoGn1wKL/Kt2ifAXrIxIwfxT4GpCSR3hyDnG96?=
 =?us-ascii?Q?0YscOdU+bLAqfbALi4caKDnNIQw4deuNwIq4/mS2dOu/b4F/qqV2N80wdzRq?=
 =?us-ascii?Q?NApPuqxyPox9Fem0HwFGryMDVpa9eOaHuNKA8pJsclB41et6OoYPeZS3sWdC?=
 =?us-ascii?Q?9LUf2qcSMuMARGynsnIK9o04Ssur7aEdSaJj27KmS7bWmcDNfoVNXUyjNrrh?=
 =?us-ascii?Q?knNcxA6uzC4YPXBLn6qAVtGjLVaaTBClkoC17+IjnsHEGySe5yYVQH5A8eYB?=
 =?us-ascii?Q?9gv0GJj80R9fL7MISsed0cGQf5tzQhL/mzjRSF2yQzboxvNyQmSzb6abMUeU?=
 =?us-ascii?Q?VEA7Ss+M6ZbZyJFGkr4qVgN0ckY66+zeIsz68vAQkMenx9bVQ5ToSjxit1i6?=
 =?us-ascii?Q?sxtmnjl7fRi/j/9W6+RKN45SD29YBBdU5o7/cU5Ygmrfh3cNWD5k24/Zqe68?=
 =?us-ascii?Q?plph/gRv3h0LCmJ8DoMRq3XHOf6AfjUjQekQYSeYggiISYAZcTt34odEgCDj?=
 =?us-ascii?Q?htomdqM9FnlaaKACQKygSRXr60hb7pnufSx0rgcU1FdSbtTkwnSyw8wyH09p?=
 =?us-ascii?Q?D2AWl7RaivsixL81TxI6Sx/vHAvLFZnHe/EgLeheZvbJB/w1x01SsVrY2J4/?=
 =?us-ascii?Q?KnglLhkK2DP76ixXJwBDM70gf0JPtEKplrKXIi4ms73/gCxXte3Zm6PVKLjY?=
 =?us-ascii?Q?YinQ9qqtsjHWHgLJOwGMSpR7KEgswtUJ3nQGnbGGdGkh72aJlueieHhMFqIr?=
 =?us-ascii?Q?F1acLAIc9iY+hMm5U7kt/qDPnc22BdWujovdaImH9BBwhT+34OE79lzI5nYi?=
 =?us-ascii?Q?7gEkQgeQoCDXB0HtnmuvrPquGYJDyiwtQHLfmekamBTIax36zhYqyN7jKrrB?=
 =?us-ascii?Q?rFG8PJEpsgnO1LgfmwOHpmje3jkEwChp6KG3JmRZGQqd3RHpe99GeIoWcwV0?=
 =?us-ascii?Q?vRA0fNL+kN/6IHzQqMtTe7Gk9NfbjhY0SM38c61zepbcvTWVABjz+Aa9lM2G?=
 =?us-ascii?Q?ezRgELLbCBWdXSJjUIq5BuDVA02mzUYIrzsqep/M4JaGr4cRXiPmYg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C8R1bk+egZfGtlyGc3z3M8VSL7LM2uRFpxYHLHb0tbCyjRJd3xWbmvQbmXMJ?=
 =?us-ascii?Q?5ocnZVVuOZJIGFGrXQVIcDhzBbhv2fBpRbMRO5uhzERw19TeQOgzC6PKiSzy?=
 =?us-ascii?Q?ccRERZdAFQejX0Neo4aApjYgkjPYT+II7oglvXtzDqgYnsb0OnltyodEf2aW?=
 =?us-ascii?Q?9PjqbhlIq2nvThlOXifS4Wd9bxvELEnC0pnI/ICbe2h1FqTQgv+QsBV2TBlJ?=
 =?us-ascii?Q?8uw7wuIKYCrZy/zf41KZ8XPtf/ELmy+mLd1SsCLaXwe35LZnRKJz3Hs4TxKj?=
 =?us-ascii?Q?6MEU7l3N/uYKk4KK5cGFF+brWbc4CP9FoUV3XNVMQzseHyNhu//ZvJtHppS7?=
 =?us-ascii?Q?mIQhITBwKc+zP0Y3VpOv03SYBbL8BNJNkijVPD0P0Uk1sIkPTuLU1saMZRbb?=
 =?us-ascii?Q?MB94hMa37xlchRlo7nOI1OQIedYzisrzErl0DZGGF79m6zn8xAZkZkVSI2i5?=
 =?us-ascii?Q?3RXZcPSGDcVoT56j6QyfZl2KqQajKccexbyPRkhoRwk3aLJS4wQfD5TpG1wk?=
 =?us-ascii?Q?GflwrnhrrAg0WQKb8NQ/EFfbJX2XITKsq5z3KcGIJcHK3Q+eBIhMlhF+vTqG?=
 =?us-ascii?Q?vZTgxNsgytoe4sqpSIJIdWs9cYInUM770nqoTLmZpb4wYqqCu3Fy3ceGAI7k?=
 =?us-ascii?Q?4R/rDc8syMj8OoD53huHYQrlqjT11mHB60hYkFUHruO/yigGm3zVb+cUG0UX?=
 =?us-ascii?Q?sAn3j9wFjv0MZyFZZv0Oqi0A+9mzkVJ3Z/uiElXPMtz2ijBcmmm/0m/yTcQk?=
 =?us-ascii?Q?BgGhXXPnOip8cF1sfaoYxaxCxHRcj47WMR8RUm76FtX3Xw/iaq4SkTUU34+0?=
 =?us-ascii?Q?A9iJPSRicJNbA8akRMnVrBXw4/RXE0TuxqLL0mRPbo0W9cptBL8tjbjAf7km?=
 =?us-ascii?Q?VAW+MZLp8bZq6elfGLkGiS9OENqs0JeM8o5z34xjnOXjQVM5DqGLBM3+8OOq?=
 =?us-ascii?Q?lJVrxxl59PuUzNaoIdtR4hGYxtTNG7r0sDv8+UBWE0FQ+BKsoVp47t+8nmaQ?=
 =?us-ascii?Q?elxgwSqA0PnA4epOlYkf9ya04LZ6GLBeXwdar0z7fzZ5fJOt0EjigyqTtSE0?=
 =?us-ascii?Q?JGlt92PlP93c0aFZoiPhDVIrChMmdrIEKxwnmOG3RdVBBNsyY1ZJxIVIdOD8?=
 =?us-ascii?Q?HOqMm7CLtnq/pCvzAF0PF92dv04vIpRhYFz8VJJl1+BdFT3nWR40sFsyWqD8?=
 =?us-ascii?Q?dtBlmi0Tzwc0wA73yHKIXB+Mh4yzZKlKDRcilywzqDQ/076qxQU6cvmIM1bW?=
 =?us-ascii?Q?zfn73MZYIRGDI2Fm58ZzfhgX4BS6POLMe+t/jD2w1OO7I6tw7EogdaR2wyqT?=
 =?us-ascii?Q?llrq5ruuyJLdreKVH9tbYC8FNOgj8lm4oZP5E/1zelP5yRngRKlm/TCJLdFi?=
 =?us-ascii?Q?cIaIyxfD50j1cGtjDv2bkLkELcN9sbtRQDX/KeeHxdI33RgJGwwiCU6FxzVD?=
 =?us-ascii?Q?SkVsfEN0ZvdWNCVCOqen+ZQFRTJhyKmkdTscuK/Fir6L+P34d5+4v9G6GT4P?=
 =?us-ascii?Q?u1NrLpbEoQl2RpD1rcmHxKdJX5mtO6nGhR/Jdctn0p64hW41DSqw6Sv0EmvA?=
 =?us-ascii?Q?pngHjqQccVYjkKEMsZL/mHGcMBnzFOD/hm7gjBDG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a980e702-5650-4123-04c9-08de3e6e058d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 19:45:39.4947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tkkZcjtdRw3B6luaP3Y6CSfWtue6B7BFmfkq8ogcQ4ieYNfmiW+ii4tGOjXWoxxV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7008
X-Stat-Signature: fq7ns799xtonzz1drp4sspxitf3d1eeo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C19094000F
X-HE-Tag: 1766087143-807265
X-HE-Meta: U2FsdGVkX1+5Io2u1wOQLg8Lwj8tJu2GkAx+tyAytLTiH1qhkfnSK2GHEFxjQTbdg3M7PnEQyhYNcTzh90pHC3nxKJ9SMbp7T6f1cmMIycdbafVaMvG7p25kBTHAz84O68ekTGm5WiACH+lF6fhq09r7qF7x09Fu65shZg9qrv0forKRzOLzGNzIpxMMiVHWMHGHHY/mA/DNvDqqR8iCMrywHxdBKqlMM7BqH190xyY8X7h5dFXUnsdDPNOvuymduh09O5+OqPUMrwhDkpK3EsGQlS2/KaRf4OGZzmiQ/QIcNnMHqp5PX3WH5TOHd65J8kLxtSeYnrGLnvcS3U3S2mJA2oQKrvdKoWVqyg5GC2EwBiagzN2EkFIbbM/UuSdFaJS9bgnNzNiviWN6enXc85gbM8jJHOw+ahESekB+RnJiobVwquEIDzpqhV7z6iM8gwciDfj/4NjVJBkb6xfKnj932o0AA4SwtM5v3+95aVOoJa/Be5E6EdJZPLtp2MTUEF3vQUyPx8U6NEA/fFUIgYV8cNeLU8UvoeA2QAzbhjOvq2VUJWdTTpg3yq6pIo97mbJWZROx/UxTURLLDAGDicdED3O0voHcT0DSA7h9Zk7XZKc7nmJGC9S8tE/x+kbohbiVVkWPGUYdzhbqVpPNI6tJLIZXJ+1ElYKrKPrzlzH4fAWY6f38JirEc8jW48925y3vPeOoKI7dhsn4arCZeR//fczu9DeEvAbi72XA+8FbGLS623pHEwjhbhWPW6OQLZWp3HtFcqZ1Uh8/KxwpDfRGIx1PJIWMxg0T4bHGTxavdgmmTOH8tb/R2Oi5UzhFt1EPJBj4pptZzD4DDy6NqOflDG7XQwKwfPActsDbFmD6Rgn4alCNZFpnhXFrdTgQVJqR2uFjmkXEXzyby3o+ThBe0AKnAGt29LDIaHdWzq82Z8C5sTAdMhkNvv8+REJxb2L1vZ4DDN01gfMZYK+
 CrjJSOHi
 mqUCIQElSX3fYQ0ZwQ/P3hZc7ucO0QeBWMMhcSHl99yWf8if/AdE+DXnsEwU2Y3M+EDYWGAdtBmV+Fpw1fzMA6B/oDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Dec 2025, at 14:08, Gregory Price wrote:

> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  This will cause otherwise-movable
> 2MB HugeTLB pages to be considered unmovable, and will make 1GB
> hugepages allocation less reliable on systems utilizing both.
>
> Commit 4d73ba5fa710 ("mm: page_alloc: skip regions with hugetlbfs pages=

> when allocating 1G pages") skipped all HugePage containing regions
> because it can cause significant delays in 1G allocation (as HugeTLB
> migrations may fail for a number of reasons).
>
> Instead, if hugepage migration is enabled, consider regions with
> hugepages smaller than the target contiguous allocation request
> as valid targets for allocation.
>
> We optimize for the existing behavior by searching for non-hugetlb
> regions in a first pass, then retrying the search to include hugetlb
> only on failure.  This allows the existing fast-path to remain the
> default case with a slow-path fallback to increase reliability.

Why not do hugetlb search when non-hugetlb fails in pfn_range_valid_conti=
g()
and give hugetlb_search result in an input parameter? Something like

bool pfn_range_valid_contig(..., bool *hugetlb_search_result)
{
	bool no_hugetlb =3D true;

	if (hugetlb_search_result)
		*hugetlb_search_result =3D false;
	...
	if (PageHuge(page)) {
		no_hugetlb =3D false;
		...
		=

		if (hugetlb_search_result) {
			page =3D compound_head(page);
			order =3D compound_order(page);
			if ((order >=3D MAX_FOLIO_ORDER) ||
				(nr_pages <=3D (1 << order)))
				return false;
				=

		}
    /* At this point, we have not found 1GB hugetlb */
	if (hugetlb_search_result)
			*hugetlb_search_result =3D true;
	return no_hugetlb;
}

That can save another scan? And caller can pass hugetlb_search_result if
they care and check its value if pfn_range_valid_contig() returns false.



>
> isolate_migrate_pages_block() has similar hugetlb filter logic, and
> the hugetlb code does a migratable check in folio_isolate_hugetlb()
> during isolation.  The code servicing the allocation and migration
> already supports this exact use case (it's just unreachable).
>
> To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
> and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
> (Scale to your machine's memory capacity).
>
> echo 24576 > .../hugepages-2048kB/nr_hugepages
> echo 4 > .../hugepages-1048576kB/nr_hugepages
>
> Prior to this patch, the 1GB page allocation can fail if no contiguous
> 1GB pages remain.  After this patch, the kernel will try to move 2MB
> pages and successfully allocate the 1GB pages (assuming overall
> sufficient memory is available). Also tested this while a program had
> the 2MB reservations mapped, and the 1GB reservation still succeeds.
>
> folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
> other users are debug or init-time allocations and largely unaffected.
> - ppc/memtrace is a debugfs interface
> - x86/tdx memory allocation occurs once on module-init
> - kfence/core happens once on module (late) init
> - THP uses it in debug_vm_pgtable_alloc_huge_page at __init time
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535=
ad00@redhat.com/
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
> v5: add fast-path/slow-path mechanism to retain current performance
>     dropped tags as this changes the behavior of the patch
>     most of the logic otherwise remains the same.
>
>  mm/page_alloc.c | 44 ++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 40 insertions(+), 4 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a964..3ddad1fca924 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7083,7 +7083,7 @@ static int __alloc_contig_pages(unsigned long sta=
rt_pfn,
>  }
>
>  static bool pfn_range_valid_contig(struct zone *z, unsigned long start=
_pfn,
> -				   unsigned long nr_pages)
> +				   unsigned long nr_pages, bool search_hugetlb)
>  {
>  	unsigned long i, end_pfn =3D start_pfn + nr_pages;
>  	struct page *page;
> @@ -7099,8 +7099,30 @@ static bool pfn_range_valid_contig(struct zone *=
z, unsigned long start_pfn,
>  		if (PageReserved(page))
>  			return false;
>
> -		if (PageHuge(page))
> -			return false;
> +		/*
> +		 * Only consider ranges containing hugepages if those pages are
> +		 * smaller than the requested contiguous region.  e.g.:
> +		 *     Move 2MB pages to free up a 1GB range.
> +		 *     Don't move 1GB pages to free up a 2MB range.
> +		 *
> +		 * This makes contiguous allocation more reliable if multiple
> +		 * hugepage sizes are used without causing needless movement.
> +		 */
> +		if (PageHuge(page)) {
> +			unsigned int order;
> +
> +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
> +				return false;
> +
> +			if (!search_hugetlb)
> +				return false;
> +
> +			page =3D compound_head(page);
> +			order =3D compound_order(page);
> +			if ((order >=3D MAX_FOLIO_ORDER) ||
> +			    (nr_pages <=3D (1 << order)))
> +				return false;
> +		}
>  	}
>  	return true;
>  }
> @@ -7143,7 +7165,9 @@ struct page *alloc_contig_pages_noprof(unsigned l=
ong nr_pages, gfp_t gfp_mask,
>  	struct zonelist *zonelist;
>  	struct zone *zone;
>  	struct zoneref *z;
> +	bool hugetlb =3D false;
>
> +retry:
>  	zonelist =3D node_zonelist(nid, gfp_mask);
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>  					gfp_zone(gfp_mask), nodemask) {
> @@ -7151,7 +7175,8 @@ struct page *alloc_contig_pages_noprof(unsigned l=
ong nr_pages, gfp_t gfp_mask,
>
>  		pfn =3D ALIGN(zone->zone_start_pfn, nr_pages);
>  		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
> -			if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
> +			if (pfn_range_valid_contig(zone, pfn, nr_pages,
> +						   hugetlb)) {
>  				/*
>  				 * We release the zone lock here because
>  				 * alloc_contig_range() will also lock the zone
> @@ -7170,6 +7195,17 @@ struct page *alloc_contig_pages_noprof(unsigned =
long nr_pages, gfp_t gfp_mask,
>  		}
>  		spin_unlock_irqrestore(&zone->lock, flags);
>  	}
> +	/*
> +	 * If we failed, retry the search, but treat regions with HugeTLB pag=
es
> +	 * as valid targets.  This retains fast-allocations on first pass
> +	 * without trying to migrate HugeTLB pages (which may fail). On the
> +	 * second pass, we will try moving HugeTLB pages when those pages are=

> +	 * smaller than the requested contiguous region size.
> +	 */
> +	if (!hugetlb && IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION)) {
> +		hugetlb =3D true;
> +		goto retry;
> +	}
>  	return NULL;
>  }
>  #endif /* CONFIG_CONTIG_ALLOC */
> -- =

> 2.52.0


Best Regards,
Yan, Zi

