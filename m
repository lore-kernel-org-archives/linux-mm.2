Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1DFEF01833
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DEBA6B008C; Fri,  6 Mar 2026 07:18:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172786B0092; Fri,  6 Mar 2026 07:18:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A7F6B0093; Fri,  6 Mar 2026 07:18:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E768E6B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:18:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B69B8BF52
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:18:50 +0000 (UTC)
X-FDA: 84515542020.21.5C1A579
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011033.outbound.protection.outlook.com [52.101.62.33])
	by imf13.hostedemail.com (Postfix) with ESMTP id BD7F020013
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:18:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BEZuAnUl;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772799527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rwi8VytNS93RLd6Prnn/LfZi3Ng19zgC3vDkkTIZ07s=;
	b=rYarmYrqehfV2+cmtFR0yrkT7+4gavHSUgn7dxEhU+qwZwBMzVjjhejAa5cuoH97MFZkPF
	OPviz0GIUqgFaam7VCxKdzJb1utPH8IIJNbpqewuorc+Kj4N4z9XOuB+XWAJj5govliZ7M
	QjgFrELvPHjRhKBiGm+3/+Ia0x8aDlU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772799527; a=rsa-sha256;
	cv=pass;
	b=HIgzfh+ax8YnLUxeeO3qxHTKkTiC09W7wI8fZ7ufJ7qTrF8V89l3rvHKb7JSjWahhCaPzU
	FeR5NHDmOd+M0/tCoOc2NyCmrsvb9xdXXOJcuShp0M5p7EEQq1ifrULyhLzJistCZ07xNV
	rpPzUs0Sl+vydMAhESRB5HMLP222Qug=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BEZuAnUl;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.33 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHFWAWH4K2SafNgF2atsezWbPAsEMlmpmuby33bR1XLAsB4A/ubf8SUzVE8tUBV+5a5cSzmwFne/aGuqx6aojogDOY9e1tLiFuV1Vs7rakrvtS1zWexI3kpzndBoKWWe1/POIeKgVJhqSBhDANESNZn18Gc93OIVyXty0DPpJWnYxw3yfWbFd919eaSIpqW+z8BuO/9mX1XOh1hu3U74RINv8WbDSna1xPuZp3YLWJ9IeiZb517fy/7hpNTUYSSqsHGPjJ4UrrPpVWpayQobWRMRc4hCsY8pFJ261AG7olg3LKr9vmsUzeOUE3hcUanw/6+aisLjVSrzlxpysmgwJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rwi8VytNS93RLd6Prnn/LfZi3Ng19zgC3vDkkTIZ07s=;
 b=s3z2PqQvDPu1bVvBZK4HTbJcwZkeAayk1mhgI40x1OzhZXX3EuhAMJJWscoIYzHs6MTPkNCVaYocN2EmPhMs63FJDfGWexbWA0b0CMmiBMwjHF55JXEPMbqjsTUkkjEQ3wRJ40CQFs0b8IqkdXklQSZZ/OA9Msfwa63dbW93NmF+Dh0k0nYqqvZDolLonTyt6PcSjjKaC8YDwCnskFRHtl8tLUcBt+itV+2IMujOXJfh3j1GKbskcm9hcn3cSIjDbjhagkfbXrEqzY77LrGWJ1i+cZ1xZ4yaigGZ9pQYbV1gecyo1/v384drm4TJ9HUDtGruzAC2d/dCdP5G39pqbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rwi8VytNS93RLd6Prnn/LfZi3Ng19zgC3vDkkTIZ07s=;
 b=BEZuAnUls8KGl+U7/I8VpnqtPtbCq0xMguv2oUbNYBVdArWh+5GmM+LBwAbrAgecOCPkX6DGKjXy4FzNLReOjMkjAHD5x210duAB2j3A4wwMIOa5k+43bubXCqxccWjBmOIjsfcmKwldIoGfT7bcHxya9evFejDyUdfl4uZ0pOYWDoyNQ59SwksX64ovFO+za2lwxkHtsle0zTK8NbbOqYcuFX1njkLQWLi6y65BsbxpzO1hKsriyvjGDUVBEY72yCaqIPpce31XfV9Jvzvj5MBuEPbyTRDfTrJScWdtTfuAqAVSTCfSN5+oaJII+Pc4dwsOgQ77mVeCIVWlOcgzRg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB6897.namprd12.prod.outlook.com (2603:10b6:303:20a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.23; Fri, 6 Mar
 2026 12:18:42 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.022; Fri, 6 Mar 2026
 12:18:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 david@kernel.org, linux-mm@kvack.org, mpenttil@redhat.com,
 balbirs@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 hannes@cmpxchg.org, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH] mm/migrate_device: document folio_get requirement before
 frozen PMD split
Date: Fri, 06 Mar 2026 07:18:35 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <2B0B2D37-5F49-4476-AEA6-C980E10A1B2A@nvidia.com>
In-Reply-To: <20260306104409.3915811-1-usama.arif@linux.dev>
References: <20260306104409.3915811-1-usama.arif@linux.dev>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0339.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB6897:EE_
X-MS-Office365-Filtering-Correlation-Id: 613fa046-415b-4753-f50d-08de7b7a817d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	cqQIBU0HpI+VY9QDXr85+t2x+JuQbeafh73DPEzD6QkgTCK8CEhXVCFuZ2Xsvr5+8gDFh8Rp7S9Hz2X7koc0xEJnXXkrteiarwumC/LK/jDPuffMRRYQibIfXOIvzvPs+c0wi8dFSTLpgZw+YI8ddoQzpvccIAYTRzRmS6fDl2DEzIpJRksJ3DWb8/1BaoKdXYu1yylfqPwpaDK4ISlGAn282fGK09u64y4f6MvRzTLD7umGTTui1hc2eelEebouz/4UHpyqdaKyGgzJLN2gc2o3TQix6pH63D7DIWA9dhMOCSHy9zGYgCc+wyVIVI0/2sd8LDuGrZEyqQUovcgLseWfQOnv9sa2BvOJPW6cmQF6VqPFpFV91+a5/H9cZRr2GRQw408Bc7pabLo3EP98WH9cucGLkcSe7ef3PnHfHt4JioMqZ6NBgrNzQPPPDX2Q7CbDbB9pap8BdWBpdhROGRxVe9wjaooShXMGiruo9UQojq0jrCQGv0x3l6uS07uXBwe1/u2dPKZrhtrHmllaIkFY0z2oRvm0o5yvUldMh1YAn7DpBFGvFl6tdPvor6pHipl2S/UqIKPQaDX8jx/Jt6Uv8V52qmHXDolEmIDLS+FrObuZVHHkZcLEYv75DaVSdxxY9sBem5UklmjtquR6prHou2gHjciByW6NPHezDAy4CLshmJoMD3A+pUeB7WF9s+DlAcFqY6gqf0xi+LxQcjV+2Owtcs04alLH10F7qZw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vrBPA7Iuk4S8bM3EXF3bdibBYGQPJxnCqvJS+SB/Vd84rkWvQFPOSz7stQOx?=
 =?us-ascii?Q?74Eqt52tEY9BWTUUj13+1G/DoDascS4NjozZoukdG9c92cEW+168TWyhPZef?=
 =?us-ascii?Q?AmMCQuB+vgDg5SKkm6bW9aKy0jQruYR/EreLk028B/DBGcOhweMcUh4asFP7?=
 =?us-ascii?Q?weAWYJQFvjLY1WabqzMMYk3IGtiJn6MtFFnOcf8AMbOTR1TJPD3DEV+Y14lL?=
 =?us-ascii?Q?PRDGJHQ4ZYgHUcjjDzdzzaRWu0f6Z0T6b8Bsux2FTvRaZTow5JOrlr+NpfxF?=
 =?us-ascii?Q?DK6oODUJ1aKgERvH5yJDWjQSlB6AtPqvAIp+lgQ1mIB+/ObrTvvO4fAkeLbv?=
 =?us-ascii?Q?irdM/+EhpjYxaPyophtSgVr5DgHI/IQkbm5IBihUayVTwjVj36DpYBysdXuq?=
 =?us-ascii?Q?5FnAMLuca+/3n9o8PCtUxeQXPF2KEQxAgiSEylFwUdGLZVO9Tqqk4vF0oeLI?=
 =?us-ascii?Q?gFGKsSnHr2VEIeyQRw2T0qtoKVoM6aBWnHDrRIfymjFzBteGtKQBAhp8JhLJ?=
 =?us-ascii?Q?4XtIDN1qowKvXDWu6QiVPeZwrHfH12H7RAdtjnF5hwVTGP279Q2Sjap3Zuw+?=
 =?us-ascii?Q?yIqyAHdVbziz/ZKbtfYit198JgqZ38X8mNkne7uXhwrs5kBc4FNBd9pnjpui?=
 =?us-ascii?Q?ZOno+ux0hHNHOHnbdKLc4vNr1/LBAJQC7dqPG7DL2c15Ge0dYLBs/58e/lTb?=
 =?us-ascii?Q?S6qaP7gDm4Z0UIIKYCX2j3rXD4zrny0RYARvpq+6gqMUTBKcEsjRuXM97OlP?=
 =?us-ascii?Q?Gum6LPGuuc/DOPfgvch7Utsru7O4hJ6YcCjqXm9cLa3wUK4D4lrAc7pUGnBe?=
 =?us-ascii?Q?78ASZyDFKPWcBfoFfDseAxvPHy5n9k2kSej04efUaxkdUR9kCptrfe32Hl2e?=
 =?us-ascii?Q?7jP506Yx0+KkWIG0SUtcquEqRp9r9Uk4yksgCc881R4u0KiXarZh/XucmZMj?=
 =?us-ascii?Q?61flHK504sNr0OUbAeffp1kGAMadEKLoy2ZtEUMbAyN8/myEyVaOSB9k+S3r?=
 =?us-ascii?Q?XNIfJsX+oJIPRd9ymcW0c/UvgtxpuHUy1z05YGB0TwG0CrJXqPBI+ZItW3Jl?=
 =?us-ascii?Q?Rn7kpJ+RTDZeNNPrLQ3tNHGhyRnfVLfmVU3FCHUY3BO+tAS4OAW6ieN1emZ8?=
 =?us-ascii?Q?E8lY8LhqeVvBnTfvcw3uPbxLpAJbokMdh83z8/P15y/U9z1D0V08FTO9Ev7T?=
 =?us-ascii?Q?NvF+ui+2BR5/IxPYaj4vtvofyVqkId5c3UnnZwBRvhNQ+UipguFljEeZ5as5?=
 =?us-ascii?Q?SLTmIi52vIbCuv/yLyjbMvPkCPZ1p3y/e6BZX8y8a+miSbaWXNxOhhHe2vnv?=
 =?us-ascii?Q?lOW922ym/a0Hyoy4PknZ7otJkasj9NeRx/7wGui1xw75UqZJjyM+1fuWgwcQ?=
 =?us-ascii?Q?C0b21HP/KMGqW0u62pYDkdVNknhnr70h/tfT6+MIgRYrYdRmLDCK1cx7WH3c?=
 =?us-ascii?Q?pb68wgjKshEAh1to/7pOLXc7XGVEyr21vCd1hi17HoF4FhgVpYbtYjeKS8EK?=
 =?us-ascii?Q?Eh2Yu1oe0/w0Ls9PoS+Qgv2A96gceiZ9PdDZe/vFeT84F7pA1ULBc6S81HJY?=
 =?us-ascii?Q?jj8UWT0eWtUpu996l+an7E1cCx0ByrAuZ9RJRHtLwXL+lDItzy7SJr+vpyVN?=
 =?us-ascii?Q?gcZQVAD/wyzJIR+zwwJrKbKAxnhk/KdPyx+ccgb7/3+/vSeB4osrpC9wmP8K?=
 =?us-ascii?Q?tO6bofJrOVC0JM3eKqgy/E2x3V1Xem7amBzrRacpR494ufnC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 613fa046-415b-4753-f50d-08de7b7a817d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2026 12:18:42.4128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcGFq8V8Jev/23sfiyWyghmnHEmDt1HvVkm6wXff04CMqedTMII25YwSrJga42p3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6897
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD7F020013
X-Stat-Signature: pg6q58aj8fgzucjy3j6abikk7nryyobt
X-Rspam-User: 
X-HE-Tag: 1772799527-450673
X-HE-Meta: U2FsdGVkX19tvnweTI4Ur6rn6Lr1lMO6I/MPneF7J9jgcNtxMVRKqXBhdJ7K8DIvy3I+r8F/+c25D6HLZnKsKEARZtN6AH+dBzMnXCp6ej7VuUFFrmUHlnPwb9LA//2VptsOY/iqq/B7/fw2BCa8b/+hZRPRd2io7itJxw/zLmAhZHH5M5OXlK2YC1g2g0rmmdZZgR9fymG2kQAuhqe6VffojkKcCUje9l7hx2zOJOQwr13J0LfefvcNNgYc2DJaAaV+2L4nInYLZl5ghKt37oVDl1kLfEzklaR9KvVFGS35OBNGzFzZz87vdYf4woZdBDbeA2e4Ve+JuFCBPzLA+GYNyDrHYZLTsUgsFSpafvnkz5S7oKmqkaoXvL3VL4oGSIK+Jbig0h+jJ7FAbTsqm59drmFITgO4qQX5BdcyTD3xoBf8USqEgsPhsDfLhHfjE5w349IApXubrNRQXo3Im3CVYMQoCOfDaUdMpeKO1gza5+0IsQ+fy93raHTCPLnwhAGtQhClftEmKItHQkaKH6w7IV/ElJ1KzZxUf8b8zguaOnXA4SwZZ5QPm63xGEDN1XEt1Gc2tXorZISrPt4K7pmg/V21laXnTiYqph5Neq3JB+vpv7trG2c49qoHPJprPe//a+/SqFO1vmI7NUrzd6F4T+YlOtXvc7wi9OZQQKG1o20OcqKGm1FSzmWGa7GR2Zu01s3a9Ze1DIo+M0sUiT9FjKyX2BelcZ56pB+kgg6JuRZylMAkEHm3Um9r9HlsLtqkPiDvFybHfxWDqDCKPK/e7rpd0csNcAUX5/iV0AdUKqjA70Y8QBJ5JltOblmYhC8KGHcKXlsNeKZRiTGaOPuoprsVb9dItKWMlG5Ug5UYXQeIMmXvO+VwazSV/h4Zkx6JJvoVQc08CiEe1u6w6im4vYjfCdnWIrp9M7bf6dvULU611yoZq3zxUKjMvAwHSzHpzcisQcOzKrvartZ
 4L8mgOqo
 Q6/JB12spHbwqK511CuJDYtzQxo277IQzI1XErkh40Oq0eb1ULvZLXIZjBoR/SUffPYbNru1F+gGzNvDcBmldA7LE0hVbSzJwvwTG20WY5mJEznbBKt34dH/f+lP9icPvLk0CFBlFbWHQIYdYUtXtJ7BFa0RZTUMlqcegNkIgXwO3lluuHvEAujP6D47fOkiCW+FVCXDZkP47MSsMzb8mq334Ac1dRzOsJGe5SPGjvuNTjdWF2sL6NLqEZz7tiAj/Y0VVeT5eYUZOyg+YUPgOwgKsFWKo8SRSoHnTn4KBizx5g0T1E2761OBp8bOn6iorFjUA/EvgnrB7YOHaJwgTU88bjL9k7BA3XNscYeG/OtwZOSDWC2r5SzPH5IRbECDTXI06HeIdcJbpDbnv23OY7bv8gbPeGQrEW3T4QSVRqhHJw4GLtoLurL2CymkYIuABNUUTfLPosvGt6Ienjv9E+6rJiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Mar 2026, at 5:44, Usama Arif wrote:

> split_huge_pmd_address() with freeze=true splits a PMD migration entry
> into PTE migration entries, consuming one folio reference in the
> process.  The folio_get() before it provides this reference.
>
> Add a comment explaining this relationship and a VM_WARN_ON_ONCE to
> catch an unexpected refcount != 1 entry state.
>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate_device.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
Thanks for fixing the logic in my suggestion,

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

