Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A8ECD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 16:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A126B0088; Fri,  5 Jun 2026 12:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA316B0092; Fri,  5 Jun 2026 12:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8E86B009E; Fri,  5 Jun 2026 12:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2DD6B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:20:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0D3E8C6BA
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:20:52 +0000 (UTC)
X-FDA: 84846372744.04.8C11D18
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012008.outbound.protection.outlook.com [40.107.209.8])
	by imf18.hostedemail.com (Postfix) with ESMTP id BDC921C0013
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 16:20:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O3Wrg7Ob;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780676449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1a1qxpB1IoQi8pQD+6oWQb1iy1Y6bEAp37OumbiNWI=;
	b=yITXrTSroUsUVXDxN9nTS35tDESz7D1lPFGvLQ/PGi5LPQ7StF0uUyxveozWX8oPP4hIQG
	E88+dHYi/Tr1VmMASWS9Mrnh+ua52JI3lBN93U/o4oZtn1gP1nM40ypvNEayWBXSW6Rp8G
	HrXzNNaRWu6BsrVFOHGpqYs3vEv/kf8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780676449;
	b=Mj/6YVFO+KDGWO/lukIOhA7zKkdd+ID/dV7xM5cXqCjiDcoFslU3jYye07fOpOaMrEpEUp
	UsPrXPu6uR0Kf44U5UnQr0rcAtE5rgUox4grbBvN4qwWLWsc/JDT7Mg39MQUU9fQpiF8RC
	lBpIcQR0kPWTbUhD29W4kt46zyClWv0=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O3Wrg7Ob;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vCZt32nLF+bi8C9mCJc/0fjjo5n4SRIlayjpg33Tx872mb7vIem9rGODSlQ8VF2eEZqct9+3YxqcHjFmZOUKvgSQo6lYNkHeX0U77uyPdYvy1Gddk6yY1HDWHBVqc5zC9H+yeF6nHNOExC/jKnXNLBK5SBGoaJERIOVI4OlplR5npGdoM5ZYVghJyT/PpKKBgSQ980sJfGav4jVD13zvBo0I2sYMDDvvW8khESOBFEP+gI/yInncLj4lZAUoJLsq+XHo01IsJldtUA1Bt+RowBHuYCLS6m56bpCrnPjoIMcj/B1FjQ7FjlmXd7hs/zEouNq4bUparNAWBPa8thJBiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1a1qxpB1IoQi8pQD+6oWQb1iy1Y6bEAp37OumbiNWI=;
 b=tT4+g+seP+5NWhX56TULPBQCbykwcJTp5Uhp/ub9GtWlErElPIKVCQUCB2y1p/qyWQCM4p9ih/1IJS4bn+LFF+h/g9WaeYX/CG3sB+weoENQ7c7Hzv2ZNIViQiXA+3dBvITuyjyngUeNHNPEYeFWz+JZgcMWgALhCo1NBkA7V0PDwfnWhM5j7mYQp0v/qFcCWQvHxiWt9VZ1oARNXfZSG/Go2yw/50WGmapFfZspdy2A5Qsy8piahorTx5AmYOj81NFskSzN7iQkkNSO07cX0KE4QbblRojjQpJfasBvoJCqQgXaJp3f+DZXd6jaW+xg3eTbSt9EfpN4OHyLTqQHkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1a1qxpB1IoQi8pQD+6oWQb1iy1Y6bEAp37OumbiNWI=;
 b=O3Wrg7ObjdVAWdsK6S+nMQOu44IQ1BLUPQffoxJB9Xy8RYGx033X7QDe8TTh0llZN0gi4caPeYyir4BJxwUkCBxDc/SeY6sgrZeeyEeZffipIOWAX6bNOA/Mk+yrJNQzyM1FdY9CGsLIMuozQ1anrrQicM+1cGqSbm4KpNOvGyZf3aVeZDJgDY/qiRwSEAJ3H13qFG3QQ3dzEOrMAkvpIxeoYOek6AFnRBTP2Z1Vt1Qm1fe//fCPh/Nk0IjTQzvg9xGgcJP5VP86yK/yuEwbttpnqcO/8MsCEdGpfUIpIhGKy2E97n0WQgVXxBdK/lhaSp8PwSeUg5+3Jeaar4CBwA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA0PPFDDA81179A.namprd12.prod.outlook.com (2603:10b6:20f:fc04::be9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Fri, 5 Jun 2026
 16:20:40 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.007; Fri, 5 Jun 2026
 16:20:40 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 John Hubbard <jhubbard@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Peter Xu <peterx@redhat.com>, Mike Rapoport <rppt@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
 Sourab Gupta <sougupta@nvidia.com>
Subject: Re: [PATCH] mm/gup: fix GUP-fast fallback for NULL-mapping order-0
 folios
Date: Fri, 05 Jun 2026 12:20:37 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <7A8AEDE1-C28F-4490-8A2E-72E4E8D0E78F@nvidia.com>
In-Reply-To: <5aae8c80-e886-47b1-a1e1-4e91771f3492@kernel.org>
References: <20260409014647.397515-1-jhubbard@nvidia.com>
 <4d6c1af0-dee5-4f1b-b74c-2ebc23de7baf@kernel.org>
 <08afbec2-bbe7-4e8a-8d99-8a5eaecaeee7@nvidia.com>
 <aiJbJVbD4W-y1XDg@nvdebian.thelocal>
 <5aae8c80-e886-47b1-a1e1-4e91771f3492@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: IA4P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA0PPFDDA81179A:EE_
X-MS-Office365-Filtering-Correlation-Id: 07c20f7e-a1e8-45cc-b22f-08dec31e6277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	SWwl8yk/DwjZdCljl1BNSNSK3QX/dARjqXoLL8jpTf/CpSw3mgq4ALS43+3YPBXEqALeg7jCkj5McvzS0bOHJoQdk62TPtG/J4mv4Tef/4YfhVy6xIQ/rYsCluLw8eGWrpr2TzoZ7wouTTtSbPXHr9xouHImgq+de/kpTsFymwpY5o3Sj5QZSeFDv6tu62BTYjwus/bkoqPuYyF0jGRwOsxwCi4uZp2bU3NI0NTM/weKCO+hMLKJtLRFEwxvFqHpDbq4AlK/EikrVfb7N9lJp95yON69s6cArH0M+J+36XKd2c4IKlXBgk9CxFEN7xTwQ0npCKDg0jEpVu27pNleQLEuQdt3p1jodT3ZfKyEIz0oeLnZk8nO8duUVApnr7yU2BUsyGalYLfiHN2yZ3zOZWnrz0/paRWeHg3cDvRuGCMhuPr7DgMufFrYm7jzDnjZcwUI6UpLnHPpuI82Z66M3rQ7+Q1TiVt1MDOzZ+AgVDDayR+mThrTzV1jl+UVWa05Kpkt4JZ/ctmYdzzdtOd58XrnP1wUmmvGoO1e5D44dplsjVDP4272D1x+3bv69CIfesbtPUtgEDMwdJHhl48/nFmJXLDpFqmCoWyQw/DZraslXsIxcV579d1V4x6xI69AVRX1d326C5yY82+7jOpe4lZmAD8lRC/AAPc8LbUfY96JEnuVevAIn3N5gykRSJEw
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NpB/eDPRyd+EiuSe6KSGzQQglgG2y3vosQNPP7D9flxY4Uf9QPePwobljk0O?=
 =?us-ascii?Q?xou9hJ8onxzKEiyFqNdKZjf9wnk1Y/ll4yNIjiM/rMZl1WQV1V9qgNcyvb31?=
 =?us-ascii?Q?pfVDALJWvbXBdjXWHVa6MJHq74i0ILn7kPxnO4e+l9UdISQ7aWCYMsvM9oaq?=
 =?us-ascii?Q?ZYB4ZkmUWY29gR9BOkxPIHnRKOt3Hqey2IaLwkQtOLE8oTZg4Wza7h9hL7pH?=
 =?us-ascii?Q?PjkByr0Cjq8lJU0vPI61X5LrXAmuy8pLKbemMdyrpwv+anQB9YVYypEcMC45?=
 =?us-ascii?Q?EteejK/q5t/0JsBWIu7iV5yaYEJw6g77zbn+zJRLiekgWvcuiXmVFtOs2yiz?=
 =?us-ascii?Q?GfdIn86FVOOiZZABV4bJkFZvpXEerlDngRqs7c9m8kNll2QF3rbftq++61K1?=
 =?us-ascii?Q?wJUPKh34HnD4BwhtEfGX8R3FF8luA5uTXBb5yQB3f/gDZG5eg5GjvjuMa3rH?=
 =?us-ascii?Q?uyiDguCwcf4IEk6jx9HUWc4/5lzTOWW2UAUUm0rkTcLLlnsHzW6soKVB21ao?=
 =?us-ascii?Q?zXOU9ETky/Gkpuph23LuvOt4lKM/fo2NsGMKTUsk+E61j9qNWczi/gohlpLF?=
 =?us-ascii?Q?Ks/RYw5xHjDOcvxocUZ6Bj/ozSMYEMo0sBN8ESFrje0O8/Xwuyf3Jg3Ihm5w?=
 =?us-ascii?Q?hkSzgCM1wgShIXpwHIN3yP/Fib4wSsppkjF4ZH+5Gm7hqHq2XG/rCL+AtaBk?=
 =?us-ascii?Q?rGZ/xsI4HwUTdL2MfBnViTW7F7VAHo8e2AFFsC5UbiH/pCB7WZC9l0KjPq6n?=
 =?us-ascii?Q?BGg2S12Qwt4xM0prlBKoV84bqP+3RpUUAR0yi6q2mDBwhDiN6Zx2x9lYrZir?=
 =?us-ascii?Q?QEKDmwXBR7PEXYqDIHl65THSGryNyPUYGnxN29g21IBCBoX+ButYS8SdKxuA?=
 =?us-ascii?Q?0nIyzKUkXpxQu7AjYpaNgoZLiSdJ43nCQjTtLFIzMhYO1E7gEjr+pY54okJT?=
 =?us-ascii?Q?AVDMfdmfFHWd7D6eGoIFRTd408qG4VA9Kun/hA/44ufbcj5+i1JCOiK16Rtb?=
 =?us-ascii?Q?EMFlicYCKgo/fer0cyNCPpZrdWE8ft3HqPZszlfoPe0mrr8HfyvPuxDlkaTL?=
 =?us-ascii?Q?croa83LaP3RpRcWS+eR1strT2UWDUtHZukG68N69P7r4Am+KX9JEktVr3yyd?=
 =?us-ascii?Q?VxbMSQKgGKx52BbJdgktS+bMfZaG4bOX6uvwLvHrxffbQcaiYdnro3byMKWM?=
 =?us-ascii?Q?/ePm0ahLXppLLKkXMl6xqnoVo0oZXgepIhuSF/SaukoUAQGbosH5Y9k0vyZT?=
 =?us-ascii?Q?Qa327M4RdrQkVXEc0BwtNa+4dWIgEWLWteJpqZEro9k3oUgR7w0vNjX4tc2E?=
 =?us-ascii?Q?vYxUmGvDG6U+PBByl4E7jq7VB962BnUhUd/3LDXynZhMMERK4GHRInmNcPsR?=
 =?us-ascii?Q?BQFhvuI66lcwE7C64SKuItk+6mZayKXeJBtWB7pqGQhau0f/lKawdPIi+Be8?=
 =?us-ascii?Q?Af4cbyk6GfsKB/sP0BBNZhth5s5Gs8WyN8TFa1e4+3EfTkolYLdeeQdj8Wcs?=
 =?us-ascii?Q?/rYjz2Go3fdd14QFsFNzpwoMn8J9r3WzqtgKZvIt4hnkBT+Ci/H9JpwnJHEv?=
 =?us-ascii?Q?9SLjYxzVGi5WEFQVea6MEKs+KYeBL48wmizN2HwP55xM3hdAv5rimvUpYtm+?=
 =?us-ascii?Q?nYTBGbpwR4xQkYbh0BHHvpgZ2zHRlZTBjEIvugy5TT+8R3McVX3X4C80YFvC?=
 =?us-ascii?Q?ShKCjjSFAwnVIpva0nTB9fSfwkoonsy+aNpPG2FPM2wZQuSq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c20f7e-a1e8-45cc-b22f-08dec31e6277
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2026 16:20:40.3091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lnwlwnp9kZg2drBZEYviG0E4KjY5hEnJB9CERRRaDEo0sk2AuvdMczStppSkwqpr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPFDDA81179A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BDC921C0013
X-Stat-Signature: ch5fj8ug1fab78obpqg5jehn3uhz3q9h
X-HE-Tag: 1780676449-645940
X-HE-Meta: U2FsdGVkX1+Bik6b8hlFpqdZBZgFRdWvnkvIZCy2THdOuxx+EUwxoCaICwcQ8wq7c8uoeU1KXMd8hRKPESOnw/ySxliLS6/YjC2CK/ihpUhEpSALv/I/z/Wat+Lqroxzt83PRGF2t1UQjRBOt5/siY5YGNHU6XLITTbsghwLYOXIId0TqsielQvBh160iITZvGYTlA7oo1fguQ3bV3lpcKTtFvRbLV1b0SniOIs7T63B6xbUDAKpzAeUECiLu48YyON/tqcnu/QETcHYjiA2hKS8LEcurBj+op6k7e+n07W+usCn0u4jMcwY/YWOAEPmQYm1+3aEwxbN15sMQclidVry9AcgBKLnfBot+j/L4p/SWRM0cCCqQXNZVFqc2hM9g4VeevHBwXpDuGDkWpTV2mVnMYXVGln2aCmrZFsEadWBOqTwJXxrm+jDYJzR1A25u5sImF3iFTzD0gwGzLQ2flpcVHBi4P4L7SRHn86oGlGZq/4KYWC80HVLScsdJ4aJrnKAB2ormp0KUvbJOV/3y347hga9AY+nCbvhVHSBCpCqchpNK7YVzSudU8Fb2u7Sfb0VVrUyvX5bFpPAf3kMLhO3Rwku1YdeeYVCmhu18B1/EqnrC3//RMjEYLq0wHVP80z6F7pFa0tbDVvePlPjjiZaWMuFgDY9ODxNCNJU1Cpyi3R5kDBc/UqnEPKutvCfP3Y61l9OyWlOdInMa4xPJczChaKYIqCndHPqNidn7K3GYEM9zHN5j7AhDzw6JBRkHTLu99DVM6UdDge3HWGQ/yheYOtyK2A3BGma4FZBBP0eOtE+yPexYxp/T0zwa2B4EIums9INKZO9VuCO3wYi7dXWgfP8cD5Nmm/3wMukeItaAJrQXfkN5tYT4aucs1oc35tCD559LYlGcyUOidaSmAN/G5CBjWeSAdzomuV1LvO44cSyTQKUULcMG6TBTgE+oEDmg8SvCFrHirdh4NT
 fhgabVuY
 xXPLqfmqN0CpWdvQ8uBcCOmNMqQpFojW0myfkA8ThYwiarVo9W1oXBqvSsRtYbqsOZeIg+iXqB9WkX0hP1tHEaNgNUGGg5Fq5HdjJGjsHxHcAzxYB8GPLNYQLiOX8ZthiePkNnm1Tp0DXzWrriCYN2SOhUSASJNWE45eahr39O9vyFgkXzJVjmxKTYyKv+M4AQ4zqB2KUKZkqcM23hJIwjL/+v0AWVYggKiEovVL3sQkp3W/3zV/pFgQhJ59dXqasHnxkTTMYw9/GRVkQJRnwJD4vy6Ih9k/ST6vYVFMgsTX0gbBAK4aF9wKCxmC/58x2PX2QWzg1O7e8HLG7lQ4uuRw9MZ7XkDplSge1CdFb2coId/+Eto+Iwc9fEssh3tvpWKUU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5 Jun 2026, at 5:22, David Hildenbrand (Arm) wrote:

> On 6/5/26 07:17, Alistair Popple wrote:
>> On 2026-05-15 at 10:09 +1000, Balbir Singh <balbirs@nvidia.com> wrote...
>>> On 4/9/26 17:52, David Hildenbrand (Arm) wrote:
>>>>
>>>> Hm, what if secretmem folio just got truncated? I hate to rely on some
>>>> handling in the caller to detect truncation differently during GUP-fast,
>>>> but this function returning "true".
>>>>
>>>
>>> Can secretmem folios be truncated? I assume you are referring to
>>> ftruncate(), I am looking at the setattr implementation of secretmem
>>> and it does not seem like it can be truncated.
>>>
>>>> Zi is working on a way to distinguish folios from non-folio things: that
>>>> we can identify whatever was added through vm_insert_page().
>>>>
>>>> Because that's really the key problem here: vm_insert_page() pages are
>>>> not actually folios, they just look like a folio today, but looking at
>>>> fields like ->mapping does not make any sense.
>>>>
>>>
>>> I still think this is a short term fix worth having until we get
>>> Zi's fixes
>>
>> Agreed - this clearly results in a performance regression and we have customers
>> reporting it as such. I think Zi might be out of the office atm but when I last
>> spoke to him he agreed this fix should go in for now and his approach will come
>> later.
>
> He should be back now. But yeah, let's get this fix in.

Right, I will work on my solution soon. Meanwhile, this change
is simpler and can be easily back ported.

BTW, should it be back ported to older kernels?

Best Regards,
Yan, Zi

