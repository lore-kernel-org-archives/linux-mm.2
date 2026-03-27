Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F1110F2848
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 15:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDB196B0099; Fri, 27 Mar 2026 11:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B8F6B009B; Fri, 27 Mar 2026 11:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53636B009D; Fri, 27 Mar 2026 11:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE0056B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 11:49:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C8805873D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:49:21 +0000 (UTC)
X-FDA: 84592277322.20.63FF7EB
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013027.outbound.protection.outlook.com [40.93.201.27])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8624B12000D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 15:49:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WV31kkBO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774626558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uBtWh8WKLdfKi6qPuc2FrfBIHXaukUGz3vF+fvqFrw=;
	b=SZKG1fxcXjyDlMjQT4x7oCgabeaBFtzy54rv/Apk6/z4r0qrqM8DUvVKj9tzO6I0wxZiha
	wLq1eJ1tjxhQ+OH2Tto7EWmA2ihyTUcNQPjHIpkeXwDDy1gAsiNTaDJJ4nsPnDV3NzJdpk
	MZyCTsojc/WKDZM88p0wiMTguvDLwKU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774626558; a=rsa-sha256;
	cv=pass;
	b=FMzYIXGFqVlngvBGcQYoYn+gxYbNg7z/B6bYQAOV1R2XNEyYn06HI4S5CURzWs8/r4hBvB
	Bv9z6S+3u4b0z+fAJ6JMgasIXBdEcsfCr25bjjpQomsA/rz5Rr/Z7efkoQF6uYdckrD5nx
	L9RI7rpWX2vo13k8ZAfjhcG0+hbrmmE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=WV31kkBO;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g9PKr+El17wPgPBUzGQVeBidJQILY31edyjBlo0Gv4RBJPk7FXTcvVavE67Y8udI8mNL70Py9Es7iFezCunEsokYOx6XRNPKCG78plERxLPaTPO4xIGaQBVwDYJ9PM2Wj/S3eDEe8C6ZcUg3h3J9rjsgvJOoNL3VypZu8KR1USZPI1eCGm4jR1v80cWxP3uNBKIu4DhvKDtey6Ui69FKAzqGcbwujOAOsJ9VxmxTWPC1k0nOS25tdpLt+4Fj8XzTRtyHj75LhWrFJXvMMej9pcaOrYw72jNJ4/cAVnV9v5e4pIPWvS3HYgI3hzg/q2jpMYoqTRfUmP7siO06qjIo3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7uBtWh8WKLdfKi6qPuc2FrfBIHXaukUGz3vF+fvqFrw=;
 b=aD6hkNiXI4oJBr20473Qf5ZkhGGJj7HFxtR95NbMdgKpYLxf08sTb/7tyjOPzeP+YCIeNEaEoPsPoqQf883sGRO6xZR6bh1xMK1yN9LbJUXsrSO5GOXmXgLAZLv66nMDEEn4KTUROjEaiGRPgMRwgKsg850aQQyKXmAUCF2r2eCZJVTNQyvvMgofxbLoYTEClP6IeyN6t1x/+9u8Seezkyl4kxMrhe+QONbqErkDNZu/6CuIQcdHS/SQeUtiFx9jkx+EST9KdZc/HdnuCYCYI7Uk/o/EhfQIVEuSZp4Dc8H0g9KMRSu22NcBnk6a5O9PPnF2ZWM95Dqyp1Xwa/l1Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7uBtWh8WKLdfKi6qPuc2FrfBIHXaukUGz3vF+fvqFrw=;
 b=WV31kkBONM7ZVJBJuSZSfCdkpT+UA2cxwdygklOa+RmLCxWpk/ax5YCHnKgBlzWnBFd7Xoh4CVB0zixwKr6fiAqbC183sCJCAwFgbAuJd4J8qwbaXioz7Wi/mkIdxhz7ppUnCZGqFcIfpfo62x2CxmdoTp96ymp3XNargErknJMv35N7hnjq2V/XXP3RPTHW4JH/JqBHq5HcsEVGFgZSd3LK2l2OWLfzhK1jDhbIk4VV9vdDt/KeSOLhouOK9Avn0nGc0cQ0AICd+WtDt7IqxTGBuvMoOksUwoNMxi2RI8IDUBDoC/+O1THiw8A4ot+YHhsdGpb4WcQwj2O+D69u5g==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH0PR12MB8774.namprd12.prod.outlook.com (2603:10b6:510:28e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.10; Fri, 27 Mar
 2026 15:49:14 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Fri, 27 Mar 2026
 15:49:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ljs@kernel.org, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 3/3] mm: memcontrol: correct the nr_pages parameter
 type of mem_cgroup_update_lru_size()
Date: Fri, 27 Mar 2026 11:49:10 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <2EA22095-8C43-4BD6-AF4E-80AE125F478E@nvidia.com>
In-Reply-To: <fd4140de44fa0a3978e4e2426731187fe8625f0b.1774604356.git.zhengqi.arch@bytedance.com>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
 <fd4140de44fa0a3978e4e2426731187fe8625f0b.1774604356.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:32b::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH0PR12MB8774:EE_
X-MS-Office365-Filtering-Correlation-Id: 9bb5ca5d-fb55-4472-e488-08de8c186560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	G4hoHbWV1VPQuVxarb2gUwA+16/MfHMmc/wr4RWHqksYv72bLpOSmWXMVCTeShGlVEWs8pLb5MPzndqcS5eE4NkfNFt1bZYn20+aGtRHLho97DJHR0x9y3HWSfvVcbzv7VmD17BjJKOdm3LGWOmca6ZW/WcW36YZzqIwF2RjlaNN1a3EUkmw8pIl3R4xTXYyOkId6N5PzPEM02x7/vOpAdSGDrzoyUNF+hNqHUj92mH4Qezm5MyINQ8Gyhs+VybeZVpvcEG9+CJbIAwnx1lqiYwp4Mcgr9z9NSSRYZk2LKCgCt7KoBqNZ386VCY3D3d0T1+MrVTFVIG8YVd3GoR7motNrkiu9TYxDSY8G2uBdTe4H/MGTgIRtNYz4f5V5YPcoX9j69edjS4LhzOM1N6ZQ69OF9mbTq1W69mhTLQT/uX5d93h2aZC03G5/qbQ4E1yrsN5ES5t1aIdrzkMHFDCUh7MyoXVz6xWUbFPJHZ+NMZmX2pY8nXMCE1tsfGD2cItByNrk+SckzxmTWztd54CYwJRaRgC4cwWsVYKl+EuziiAtviCwh8M/4JsGk9gCb4DYAyxpxrH2pATKJNjCZk1XSehDymJGzRG7oYYtRR1GL6A3qWMOkMzB1YXVpgG4l9asyvSoHAswcySjpTu1Kgma7qPI6V89H1BhMoIFej56JhV7Pv8DmW2swc+Add+zU9foT8X6EkSRWNXg2aCrfuusUH8tvPKbYI9c1zqFfaZq54=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Jr1ZQnQ35+azt1LC4gucOamGODGtvpvwWlNUOnwFIkWi1WtZu+VFf27i90YX?=
 =?us-ascii?Q?TQ0HPf9986FRF4ijviu+5N237XiMtCtm71s4pHRL4BGbyK+GNSTcQ9nQ9VvF?=
 =?us-ascii?Q?5s5RVwErjNQNLVpGsXjBuCWtmY7Y5fPM+dl3U6kYYUJ2OogdF740HNmPjZTu?=
 =?us-ascii?Q?7xTw5Rp/pA3oyYezfC5OdP/4qcFn4Bnr3XrHIaZBwkxvtbJxmuxg9Bxp4R/Y?=
 =?us-ascii?Q?HcxACppribIRGLSeOQBPU2Q7AKf5PXKUOjdp+7Nmrtf+w+O3KqUU5LQ9khQK?=
 =?us-ascii?Q?pyGQ077nUkJBuW21rnPiX9vcZkG9iY3cVezWayaYIA+ffNblbGn4cwcFl1Zq?=
 =?us-ascii?Q?8kuptChc/BA1vJw2ViCCYzhqlkheCGwegjfAQrLplx3uD5pRfpCdBTYhFI9D?=
 =?us-ascii?Q?5/Kjk3Ivlesc/NFczn1tAiwNZSwc6LjKU6skl8B1IiOZa/uk2F4NR8MWPhLJ?=
 =?us-ascii?Q?XpR9kj0nRRbOyqZ+Ygp6pwcFZ9IZaW1xBAuVTAPEBZJlnMa80hDdqE6IUiqM?=
 =?us-ascii?Q?DoIwvjGyDasJtA4fjShLuRTDzlI8TkFijozcRz0zqdFUwDfJk2PZxIUwrxv8?=
 =?us-ascii?Q?bEDWeHyqvGsxF/doUgHGOqPquXjb6JzXrUYnVa7Yl7VPp0VltQzEDK9kKpu6?=
 =?us-ascii?Q?x4GyuaMQlVuIQmkVUbYR3x1IAr7CnanVoKI4LHbYLto+8FvnzqmDEcTl9oui?=
 =?us-ascii?Q?FjBOWKQv9Eq3/nbUu/QECuyt9s8QeZjx1/61eFMtHShu7M0hcsZJv1brCeiW?=
 =?us-ascii?Q?kxpASG0VbXd79llepmIWLNQ6fhfexbFRC1F5LuOg46mthYANS60psgxNfC+D?=
 =?us-ascii?Q?ZmvxEcgtu5Uhop3W4+mLml1Gjw2TfisupFECEduuOESmJriTJo/V52RMJ7YV?=
 =?us-ascii?Q?ZILYcGVCqjcxGp9ba4zomTjySCe4ukpcFlAYwR1Z7GaX9BqYeG5YZKEKElkG?=
 =?us-ascii?Q?Eg3HMoPn1MUL+hc6yXlC03qbDN9AYUs3lcOyHzf6gmoLZiMNACApiXfIHiuc?=
 =?us-ascii?Q?9EKi4sqXdMaAx2ojBIBFpwnoxjSzKLeuaP8tOBnn/hNWAP8TPbP41aGQroqU?=
 =?us-ascii?Q?79SotOiio2hOzI+E7EzMHlsZfLs7WByhkso+q/Buzi2ktRfH7lcW3/p9EqSQ?=
 =?us-ascii?Q?UOSVg2tGSOPnL2GSbrYiVJJCjdadNrSZDl2odQPjNsqeTK4O372WWvB94ebQ?=
 =?us-ascii?Q?0pgAnkw2FqLVqdEAJkJlLJDNkNjb+Tr3fyrL25ogM88rauaUmGdLp5pSTVTf?=
 =?us-ascii?Q?HhEY5VI9gyQV1hNponXfR92nbxVlg0nxIITVs5kPVKFT+nFYHrF19fONyUO2?=
 =?us-ascii?Q?1U5k0lWVlCayR5Q+nPg1wDtTDhOs9TUBcDtDTyRQtKfi0MTeNtqnnFqR045p?=
 =?us-ascii?Q?YWa69mXsY0kcZaaGWgPC98JM/cUkmkl/TxOrOCNfyLrf3/GukpGoWLUlOVR6?=
 =?us-ascii?Q?aztKwypiyPJcm7BQcnZnJe68sxquTHFgATXxwescRpWjUVkGPar1Q3o+tfZc?=
 =?us-ascii?Q?eDQF6RjLCyxSEMDr+mxOmT0XgRbhq1Jwn65H24PUaRQxKE+eV9ZaWFtZdZjD?=
 =?us-ascii?Q?U1A9I1BvHAXpenDg8V9fLH4RNH/hAmuJoJqnTB08yVhDEwCqJ9E0FkgNFTgD?=
 =?us-ascii?Q?vsBP4Hv6GocQ2xULgpG5Lgc+V8LTvd1LGD+swYqdkkZIHeGaICGZSu8KMZEa?=
 =?us-ascii?Q?vyqzV9vKk1doM9JRuoPHr7yoV+/RaB0Jq1g8qSR6Qk4hG5mJ61byweO9ybcs?=
 =?us-ascii?Q?EflRe5i80g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb5ca5d-fb55-4472-e488-08de8c186560
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:49:14.2341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2h0zznGirUxJiUhwCHvxEREfz1WEPgzIQAEgZdL+oqOfdi1Kyq03gT3Grf/eb9R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8774
X-Rspamd-Server: rspam12
X-Stat-Signature: imn9uhn9pkxo5y9r99t6xfeihgcw9tmm
X-Rspamd-Queue-Id: 8624B12000D
X-Rspam-User: 
X-HE-Tag: 1774626558-481244
X-HE-Meta: U2FsdGVkX1/9/DwALjwYd1qSOJsSQ2SLCOdWhIPCCK77AsBlE4NHEo6/1NioAOWX0hcbq1pWaHM6N6WVateELQANNiQRcZs8dg6s9cpjenqbR5YpzNAim0LTVgZUrhpKZDeqsLooYMBTEr6Cgk07gE+sZ4wpoAT2iuTAFW5NG96zC8WNl8z/6DIaEqzAt0wgpQs4sY5RSd6hqDbN/X2rI4uCx7V9jEs30X8yAtx0NvdZvIw1jefdME4/4KHVIb3sb23H4Ga+QZR2N6FXNJFriPiAsHtL+17T4/R2OheK3OUl7oDn3IeZ8IucSVG9iWs6mJUZRF1bS2bxO0YM3dxfby8RmYrDWVXpi/A/XmlsQdJHQXlRtr/CpgCr67l8xwCAdamdvixJiPfBAnTO1kNb+EnzlysaFX8WUefZn/PCxmOLXW13bOMAd6T57CBATX4pXiqdBH2/VuANN7LRJPbdbxv1yocOF1IuODi+WyePLw5uXeCBrwgktA5ap9NOXG8408NdmP4uK/L3JGvH0OaxaQP+mZ0NjudgRZ28CWPi0XVc6C0DkEbA7k1YuT7m7apPyCwust3V3I4uYzcBkSbVVTWZD0rPM4sN51qFp9h7pXN2cX/tmO6pXkmiEb08ilHr97XAnSyWljSqdGCuETRC38AIfVqOcARLQkWCdjGtbdvrvIs/PDITnloOIS/L5c1IM3ElTYsoZ5AnGpfn8i6cXOxOfhqHfrK/B3iks6WsMgTTlRYZth7FPNr3pIBdHwgeebpIblTyyRRDJP55xe/dPXEqNvCPzDAhj0i/5g/nXGCRnWclx/8TegQBv6rgWn8yH+3StT1MzbwwlpceJEV/7ZAby3iDLIf9ZoKbwMFBrXzXp7H1g/ZqB68ukAdvgmOwbeeKPFRU3YvTTkxOpnkCsqsroZhd1LBYsU+z/eHanQ0YHa4+TM7nE/c02q8o0Vj1PgLn3Q/HOtmtj12+Vj4
 LR06BVQ6
 VrIQ+UWo/YxKlYCwlmCM4Ol7pjASWCLV/IgENh30R4cdj4mVydP2k5NKUXLakBnFp/3IaDOz97PIjwjgZK+3FHPtb2ckIfgj/cG1f+6EmKiBxF41XPnYbx2F70EoraCSHL11b5L3XJ6g8WaSL1B2mck2Ys5efI+vI7YXnNk6S9la2nHhoA06FnMio+CB8k/KXaW/suThKmH7+0lLrF59PTa5eIVsWXvfL0xluobEYwrq67kjPBsTSnPVVTON1Kq1qBZOxh+8nEEgXiotNi1FO7DsukCO8a0vJ+bPl9Qtv/sYqC1Egb8C8bBXp7JeSjLIkOUzB7mRxm2UiWCHi1Zac/EqSXJlBo+j2reGHpzbNHLu1GxSt355KLCUTLEnwkGYVjfnJc8wWceiWeOF7SHD9KXtCk7KMbYVHV2h5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27 Mar 2026, at 6:16, Qi Zheng wrote:

> From: Qi Zheng <zhengqi.arch@bytedance.com>
>
> The nr_pages parameter of mem_cgroup_update_lru_size() represents a page
> count. During the reparenting of LRU folios, the value passed to it can
> potentially exceed the maximum value of a 32-bit integer. It should be
> declared as long instead of int to match the types used in lruvec size
> accounting and to prevent possible overflow.
>
> Update the parameter type to long to ensure correctness.
>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  include/linux/memcontrol.h | 2 +-
>  mm/memcontrol.c            | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

