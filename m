Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CB95CCD184
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 00:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B6298E0103; Tue, 14 Oct 2025 20:45:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58DB68E0005; Tue, 14 Oct 2025 20:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47CEF8E0103; Tue, 14 Oct 2025 20:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 379718E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:45:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1B1C4795F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:45:53 +0000 (UTC)
X-FDA: 83998506186.06.B554CA8
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012014.outbound.protection.outlook.com [52.101.53.14])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3523B140005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:45:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fgKfmeCM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760489151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b2nQkVJb89TMq4vJ2n+E8qkLPR9kUKTttW8GFe5qZEQ=;
	b=rKwDDvQ9sjCZlIfNN3laN5loADkM8gfdPJ8v2FGYYiItdRJcykJQxXX+LeUBlybx2l22sT
	n+oMiWGNBPbcH5s99tK2lQ5TKt9lcqXXgsFnJcsPpwh0NmjsW+xPDt9HlXsJLeXJpwc59r
	cS4IjQA7unYYoe0gKazBYxA1seznJl0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760489151; a=rsa-sha256;
	cv=pass;
	b=yBGg2hUraezCsWrvcs2/lX+/qDpI+csXP1VjrEqFiYY9RW4O/koiQm6qChRwgnmGHOnRDe
	RWc1Pja+1yTvIV2cDhOOa4KIBuJyrErnti6ztTZr6bNMcMEhW6KIGDw+B1yLXV3BZhFsI+
	R3vWXq40XTFniqoaSwKpU6/4KPscIR8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fgKfmeCM;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g6NykgKLChv5QLCTbHPgSNT/YUMCL1ibXFx6vK3G+qyWu1vSfLR6liEPjDM5ayhKmujylbLybquBvcBqzVevNRYmtfhLRSm26V38ijS/0sNXEpBibb2NiAjuRLA2Ws5yN2g72eBlntFR0MtWZJ7HCQLsbuWJjH2Fj1Vo7Zmy7Qj8YFSxlp0jGi+oTTmnsJJyqznRnOzbkCemnktgddOcagTTttCHQ71NmGUByim5E11Wc9MKNv3NnpPqWdJdgB7N7y3YkHveWXami+VALx5kKpEamlUU6AqyaPTfh/mpCFh3qrmqLeHUV6ccuakaXRmw6qJnvS7Fwhc8FSvoMQne5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2nQkVJb89TMq4vJ2n+E8qkLPR9kUKTttW8GFe5qZEQ=;
 b=rg2AkETkiKwwZ3bwHpsMFMvBfMyTVjT1t8HhgrEwEbV3WdZAd82TzPKq/9GXZeXLGHFF7TK2GOYlNc1GiuyBTiGRlK1ADXFmIo8X5aUwm0Nys8SzF8l98lBgfbPPo2df2a6JGIWu5z796nGQlPUt4Ufl0meMd/2sOaO60Ifso2xT8VMe5d7zld3MkYxF5+XAdWxsyUhp2vzBN3raJRn1aCZffMMOUSDKySxrHMTLdgCcbOcqfZXikbhwg+yOg6DNOcwPQW+JNF8wnlpuPelMQOzj3YEWgFABZByuknmTPUIqa5/82GH9oBDMr04S0f2wItBZ9/cES4kcBGeMKyBrng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2nQkVJb89TMq4vJ2n+E8qkLPR9kUKTttW8GFe5qZEQ=;
 b=fgKfmeCMC8djUf8dPckv34xUAT2N5Z3qJ09+H8MiRKf0C++RUNiE/+8ilMu2KIMfH4UzlcvFSd6eBMWacrnbm52sOqJ+gc1gZyi5aTNtTvpeHhe1DUrWF3+3ft1avA/yeJCSGmvCPWeN30oM1Ja7zriHMXr6o8LCypkXdebHJgyesx1zegYKQi5xO0GtaEzWQAobwsz1KHETLBXgzAnKBQ0OoZR5tFnbNCf/Grdxv8Por1CdwzpwWRfAGXDzJz2ifhiEO5Wf8tks3bi6Ta2fPgQERCMkHAEyZelWc11aR06yDZ+Qe3ybyvN9o0DhAoHYJj6X4vpX4oL6zHG75R3iZg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9203.13; Wed, 15 Oct 2025 00:45:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9203.009; Wed, 15 Oct 2025
 00:45:46 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH 0/5] mm/huge_memory: cleanup __split_unmapped_folio()
Date: Tue, 14 Oct 2025 20:45:43 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <B19F20C2-7B99-40AD-BC1F-944FF92ADECA@nvidia.com>
In-Reply-To: <20251014134606.22543-1-richard.weiyang@gmail.com>
References: <20251014134606.22543-1-richard.weiyang@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0371.namprd03.prod.outlook.com
 (2603:10b6:408:f7::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: b74cf5bc-d82a-4ce8-4faf-08de0b842d6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f6K6wp0PgA2ElgBwtbPFtovqaHzuTkBStnSbnI4MVo3OdQovgL0F3kxX31QL?=
 =?us-ascii?Q?p1kygWpL3na6sjFtbl+nNML6AtdciGMwVSADkvMKv5djKkib4ecq+6W/z0vp?=
 =?us-ascii?Q?tLN3Vnx782sKJdXxQ4aGcqF2GtZP4ZJoTVRgNwrqm8V09XzOiAxE9hFc4LGx?=
 =?us-ascii?Q?q2Ezrhlf9Taf9HkU5MaXIu6vudvtvKjrq2fOnWR/3clx6628cCH+bZwQqCgY?=
 =?us-ascii?Q?ClxxabuHS/b3F9M2FdCz/GsUW9MxDqckKpcdE4yDtTy2DJCdmmKPrEX5R02V?=
 =?us-ascii?Q?wbYwHLKmLDTPe4afpW4iGxtHKbp3tkxwmMI0UNZpUAGUklEUMcmOl699wyd0?=
 =?us-ascii?Q?URVYEn6oiMf2Vo1mtnqE+yZZX3JsN+iuegLSpKNHqSwSyPh0lQiUXeSGws0T?=
 =?us-ascii?Q?I6ssu1fLIXCD9zZY/TDl1r1KDN8xU6nghsKZ0OZfMUNNUYYNQXlNrmGA9Qa8?=
 =?us-ascii?Q?5aCztc9VTPBh/sx1uTcDBbqsmYV8IHw4LVldYXJVbNs/fEYtVHMeFFCugpWH?=
 =?us-ascii?Q?wPHJUb239b9TNTSSZrb26eA7qH8ljQRplpUM0BCnrjAqDd+yoEXXhOqT5X5Q?=
 =?us-ascii?Q?6EdAGQGrDgKo7VYuAkSPE46DnusyEaP7KCSTHLjUSr5/bRcBcslNQLDGar4T?=
 =?us-ascii?Q?WBrBw6t9gdZINN1jag/V2QRtngJ7nKutXz3mAKfmBGPXDkYxb9fj80FP6tiw?=
 =?us-ascii?Q?us89KU3MvZkpsW7QlEU7Ee0Upp4pT2LHFtI5VXarFS+K7+lLEogK0Tg5OEkU?=
 =?us-ascii?Q?5cW8YqlgEpaNu4GcCLRSQW5ny4em5IklQ2Pzx9nGpNHzIuUgJzjnWU92aahr?=
 =?us-ascii?Q?KRmoPCFUB8gXv4S/IQaFMURr47963Y1Kd4yGp790pvO4Uar2Fn08nfYqCMRd?=
 =?us-ascii?Q?HJo0qLKan6UZyZ7TnVeMK/inlCiT+vRLJNHoXuKeD8caOKwY39AIMJo/qij7?=
 =?us-ascii?Q?jAGFFd/VbXDVPhSOjhwplHxOz++43+c+kIa3JmbmJVM/xdAidV6n8OBCsqQ0?=
 =?us-ascii?Q?BNxBoytQvW2W9MmQdzwXNXqRUHU34sYRaN+A56mEwntNX9FxAWDTk/A+8q+p?=
 =?us-ascii?Q?dTv05w+9FE6la4LdYu2KyvSEmE9U7McqVGe1Pz9qi19DMEeewofrKrc2qMgd?=
 =?us-ascii?Q?pTJdrtIH5YP8p9FMoEXcdBgw8n0ShJQJ3E8+IjIAXC4yViks95/J3Pis8/3+?=
 =?us-ascii?Q?q1fYeueNuuYt11sroiFlY8tzwJLTNHCHZJkbnV1AamYmqrGkz4by1lsy+eer?=
 =?us-ascii?Q?jsfn1tcqTJYDN8JeN9k4YurGSh+11d1EEYXoJA2kKi03BjVzQKW10TpDFhMS?=
 =?us-ascii?Q?1VBvK/f5/2JcDSQa1aynMBRVYOuKpPHpkGBrA/1V2S7PQtYtse8bWBxAWnnk?=
 =?us-ascii?Q?Tp4tZltoba1oohwE1i6X/OmxtLYI22TSCFFgKQy9TvqVEUps6biG/x1w4fWB?=
 =?us-ascii?Q?k/wxR0yL50UuKRNMaA86uSAhtCix9OaG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2A+dJcCzGUkwpACovLPQGsuRy8ueBuhb75GlJCM4bpSu8e+fDCITsOjvzvtV?=
 =?us-ascii?Q?HcUmvc97GYPr0ACXgijM0eSZ3/3/KAG6KMheVI4KZhJDwoSQwHTo9zXSJ4cC?=
 =?us-ascii?Q?zJUa2rCjU9LikUYSs2tOd7emgQcmjhwAVKHhCiC39GoV1y34d5pHwTcfXUmt?=
 =?us-ascii?Q?U2up3kuJQUp8R84MSMceKhZiMsVKL3V6Vjb/mTo9zh5e2gegCnf/8TQ5h7fo?=
 =?us-ascii?Q?xLLQxp21pKnvzyxk3iGIeo1ih0WNtA8/pyd939a62u9h4LGcPr+c5zErBNZE?=
 =?us-ascii?Q?hvqFkNua1zXIsixvV1OC89SBrcu8w9d5uSvnJBlKkrdMdtsO1WwRp/IuKNAS?=
 =?us-ascii?Q?vbOJhYa66p78gAwHJ9yLB3tVWr0Q6ZLglsoQLq5kW0RQlj2dJPYZy+ykdDY9?=
 =?us-ascii?Q?1i4QZlRZYUX4ImqeSMtCa4V3J3bfyWoczyMljujssD6atmoj9dySjlgv+8s+?=
 =?us-ascii?Q?LEFBp63RBDPkz7XtiZhl9acJ1dgXMZjA6Gg3IGYsSM6aKiQAYCwNJgD0TDWu?=
 =?us-ascii?Q?ywhRiqddvk7hOBr0Xqdr59S5uAoJhR/bBVMPS/HgksPEl8PY2xsp4Vp/7hpE?=
 =?us-ascii?Q?Nu/7nQc+MKTYt0/3LHQIDaeTVUfQleJhf0JJOSlR+Iu579NWUTFs3k1UNFgN?=
 =?us-ascii?Q?e5KCApgMKMKnZLmYsKo/Kjxf0OqxpFieu4eX7bxmXvAr8Thw5KY/77WKqpo1?=
 =?us-ascii?Q?ZFeZfOooPCTT028FGs1EcII4Rvfb/A8eQWwMlvnfPts4k9iA3d89mYcPkQf0?=
 =?us-ascii?Q?pmtU4Z690L/eIbL3jXCldRAeCawyG2Nf+vSeIlUfyZrvn1ZkGvUpp/gC5ca2?=
 =?us-ascii?Q?dK9dVYy+T0Isz+PevCxv3bSK4t6a1Exmop7qQMqgVoD6V0MPG8uiNdVq62vM?=
 =?us-ascii?Q?eAr9qhJbvsk4I68i8YQ+R7ZgjFlsKpiFzAx0LRie88pQgUlDUnmcIWwntFsz?=
 =?us-ascii?Q?136k9qEJWsfxXnJmHzRe9brD8I/W3qjfVQkGOCHd3d2goRKLHEw7hoHhSm7K?=
 =?us-ascii?Q?4vI6fLm2seYi0LF0ocM9BnyhW8WvcCDyB+o6ysxbq26r+v5ndiu+WBtpdWIJ?=
 =?us-ascii?Q?okd6itY10zZBHfdXTW1AGnFg9BsSAQA9Sl/ADVZd/XmIH5gZTjEWDhYQE0Uj?=
 =?us-ascii?Q?OpOCpRDZvz8pkSeVQvJXu/c/ZALN0Wxzfi34rt8ua6EWvRIORoY6U+eaiyCz?=
 =?us-ascii?Q?qqPOlAPiaNk1EowlJQI567AM25OBpgk/No6Q0bdeOOlmhVWZ6MpvCZnJM1gM?=
 =?us-ascii?Q?dsMxHqbkySfGG1BZ0Acrd8ldGGm4scNJEAP7YlcT+1TTXeUafQUKNPzsCXXR?=
 =?us-ascii?Q?k3hvc96FLTiFtZAtHRwS2ZK25ofnhcqyxgDoXX2ouP21+Kg6/sjB+019Ofhz?=
 =?us-ascii?Q?2vdq9zBDtI6Yye9OKkHDlgVwavBsMZziTLxxQIz1Xcr1HTi8ktl5P9quDYTH?=
 =?us-ascii?Q?5i5MASAaxNKFmyXUbqDvAi0HEL60vpVDGcitG/ru8RuU6X8WrhvHAoEf7m7e?=
 =?us-ascii?Q?UXgZL5zYYr/0hg149MbI+ldiqKwJeUrNfE1c6/hZLPJNjRKxwf1ryRcEjjKV?=
 =?us-ascii?Q?orQlaglFW3T0QIiS2Ejlinc3zu4jGqnM6Ih7SPrS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74cf5bc-d82a-4ce8-4faf-08de0b842d6b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2025 00:45:46.0323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qsmhpgJUpHVl7z5S0/wKG7aQzOGXfDtZRRtumkyvUbh6vnBhOZYzb0nblbJI+Lxr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspamd-Server: rspam01
X-Stat-Signature: 3mrb97smbnbi8mg1f45oyxpsuhmnibyn
X-Rspam-User: 
X-Rspamd-Queue-Id: 3523B140005
X-HE-Tag: 1760489151-215194
X-HE-Meta: U2FsdGVkX19iCUlUt+YC8MvHWQi5GsEitEZW12LLrsiXywS5/aMQx6ehmk+AA11bkhQf1M+9fAJm/K4l0s0aEXq5Dgkzrk20hx9UoLC7p6EUGso2qNASGwA7vesueguLB5E9/j/YLAHyPoM1nmaMvA7g5NczsdFsuvk+zK8AUzHdGd9RtsaFS9rKCcYArTnFbomFPYgRvjDylJywC5sAE4/F1Mjpvdie4QYyUOfXY375MJ8Wn/ygpHysGAkT8mBgxzfoVSlP5hcHPkgyGFLWGgHTRzcNsLNdskpVeMV816GZ/DvukxjLM0+DmqUvy6UyzMSDae/5EtcjcEDN3pMFVmB7u8FNWPDrkaGE8Uo5SmbBfPCsrwApClCJkIMTmQdKEYAMVXKP5/jXdOjbzTgiuv3CZ1xyXsx9FrKfgChHiad+X6PzLFikrEvfjuI9S7/XioOqhX7vSsHU3E3HBjfXarHB4BycxNlnhDReQWEaZjPUr1SxLkjXxAjIDdVx1WKsSucxBNOBuLB5n7mM1JKpiXPwLTL4OF3HbmQI5TsXKpLZdjcLU/czniBbV/yVeiGYY1SmHqYrUkgyR9KZV9EbhGLIpcBNkZkSv0hrUhrRWMTxFCA8FIJcA1vq7nD0zpGYbZtX8Tyb2d9eFOLQDNXyViQTBTkHbnRKYWLfCPtJ9a8Imy34FbZ1WN9TBg8Viyf2GyPtsae+oY/8/kvjaYDO80hqGPtx/8aMxok3Lpa/Dw5P+8G8yXhOb0YJuVAdPRYrPHUwCPy5dkOg0NI4nrX09cqiV/GtCpYGe6UGi6pHHUTJL2t1puyX0oHDFFXtOpM1dqZKP+cr8zsvqEYW1h2cANvaUC7H+IbO+Ug9A3nuv+Et3iey/D6XCeS35YoT2RIMA9E44Hp6xfLi03aQV5kDqjZONCiNEJYaf4ZYvaJHuaARlhl/yKwzYzEFP9oXr86whs50kz0lliSIUW4PlkU
 1YAzcHKD
 ZEunARx7L0xaxO4ZDPp3ozuLxKV78IjRuXae5L6eljRhJ6hVYSd9ZbbfBmq8798Ue1MeMvgq2aF/b+Ez5DwtBm9Rab9WZTDw9QDuDYSFVJ/EFToInR5qxDiJsEwZ72mVjbnoDUcnT2zvqKnioNeONE/dZCx8gnV2qw/7/EIb5d0+qgm2B3qaZUhuXRxBq5i3dEbfyP7rOYvd+BD3Iy9kl+61hH4mjgAqC4SDlzVdLi6neNi0QDW1w1Jp8tr1vmIvIFSVFbkjC/NiNT/XTk+CtGfAtBxgmAwekB0BF/sU/dWo2ONY+0V8zhp8a7PdR60BceJ/iyu2Y5mKdxGHOySjfCWm+UMtyuXUImci/E+Q+hcClMycpPk8mtNO/gBA+TU0Pe3Of4JlwX1KO2+nNyeO/KADKrqjldUWGQpWrb6Yde+UaRLnGMknnG1tmzvmv2i5reyoT6nqSK/lav3Oh1YQpNL7Bhcy+gkQaXZqyidxQjbO4Eqg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14 Oct 2025, at 9:46, Wei Yang wrote:

> This short patch series cleans up and optimizes the internal logic of f=
olio
> splitting, particularly focusing on the __split_unmapped_folio() functi=
on.
>
> The goal is to improve clarity and efficiency by eliminating redundant
> checks, caching stable attribute values, and simplifying the iteration
> logic used for updating folio statistics.
>
> These changes make the code easier to follow and maintain.
>
> Wei Yang (5):
>   mm/huge_memory: cache folio attribute in __split_unmapped_folio()
>   mm/huge_memory: update folio stat after successful split
>   mm/huge_memory: Optimize and simplify folio stat update after split
>   mm/huge_memory: Optimize old_order derivation during folio splitting
>   mm/huge_memory: Remove redundant split_order !=3D new_order check in
>     uniform_split
>
>  mm/huge_memory.c | 70 +++++++++++++-----------------------------------=

>  1 file changed, 18 insertions(+), 52 deletions(-)
>
The final code looks good to me, but patch 2-5 could be merged into one.
The diff below is the patch 2-5 and is not that big. My comments are
added below inline:



> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b2a48e8e4e08..46ed647f85c1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3528,9 +3528,7 @@ static int __split_unmapped_folio(struct folio *f=
olio, int new_order,
>  		struct address_space *mapping, bool uniform_split)
>  {
>  	bool is_anon =3D folio_test_anon(folio);
> -	int order =3D folio_order(folio);
> -	int start_order =3D uniform_split ? new_order : order - 1;

I would like to retain this, no need to inflate the initialization part
of for loop.

> -	struct folio *next;
> +	int old_order =3D folio_order(folio);
>  	int split_order;
>  	folio_clear_has_hwpoisoned(folio);
> @@ -3539,18 +3537,14 @@ static int __split_unmapped_folio(struct folio =
*folio, int new_order,
>  	 * split to new_order one order at a time. For uniform split,
>  	 * folio is split to new_order directly.
>  	 */
> -	for (split_order =3D start_order;
> +	for (split_order =3D uniform_split ? new_order : old_order - 1;
>  	     split_order >=3D new_order;
>  	     split_order--) {
> -		struct folio *end_folio =3D folio_next(folio);
> -		int old_order =3D folio_order(folio);
> -		struct folio *new_folio;
> +		int new_folios =3D 1UL << (old_order - split_order);

nr_new_folios is better.

>  		/* order-1 anonymous folio is not supported */
>  		if (is_anon && split_order =3D=3D 1)
>  			continue;
> -		if (uniform_split && split_order !=3D new_order)
> -			continue;

This is probably dead code in my initial implementation.
>  		if (mapping) {
>  			/*
> @@ -3573,19 +3567,12 @@ static int __split_unmapped_folio(struct folio =
*folio, int new_order,
>  		pgalloc_tag_split(folio, old_order, split_order);
>  		__split_folio_to_order(folio, old_order, split_order);
> -		if (is_anon)
> +		if (is_anon) {
>  			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
> -		/*
> -		 * Iterate through after-split folios and update folio stats.
> -		 */
> -		for (new_folio =3D folio; new_folio !=3D end_folio; new_folio =3D ne=
xt) {
> -			next =3D folio_next(new_folio);
> -			if (new_folio =3D=3D page_folio(split_at))
> -				folio =3D new_folio;
> -			if (is_anon)
> -				mod_mthp_stat(folio_order(new_folio),
> -					      MTHP_STAT_NR_ANON, 1);
> +			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, new_folios);
>  		}
> +		folio =3D page_folio(split_at);

This is where non-uniform split moves to next to-be-split folio.
For uniform split, the for loop only iterates once, so this one
and the one below do not affect anything.

A comment above this assignment would help reader understand the differen=
ce
between uniform split and non-uniform split.

> +		old_order =3D split_order;
>  	}
>  	return 0;
>

Otherwise, looks good to me. Thanks for the cleanup.

--
Best Regards,
Yan, Zi

