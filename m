Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A61CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 17:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEAD26B0088; Tue,  2 Jun 2026 13:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA17B6B008A; Tue,  2 Jun 2026 13:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A8F6B008C; Tue,  2 Jun 2026 13:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB0D86B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:46:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52AACC3192
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:46:25 +0000 (UTC)
X-FDA: 84835701930.27.082034B
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013050.outbound.protection.outlook.com [40.107.201.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 86172A001B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:46:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lOiFT4Iq;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780422382;
	b=lQYBjQzPOvVYSU8UcyJs3S1r3lOprFQdOZt0PF1TLebTR3Evpp18Z29g+mCHzjKCNe+ti5
	Q25KhD1MtCBlnbWL3fziBS7cn7nAJ5k9Mv6sW+1rIkLIWVBnqoQ56BYMkCVE9eNHa3Q33b
	xc7vrq8gYYDqgQkodNurvJuoZzTmtcM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lOiFT4Iq;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780422382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESlPa9Ug0A6mTG8AVoUqSglzO81tywO0nYb5bjQSE4w=;
	b=4UfCWBHSZ6iocwlkJjGfByZO6bm8Rfa1iLgQT0d0MBUWRUq+jtho5aHlX1GhCLrRTeWmG6
	RPO3L8cfrYse0GxWc5YIU4gv8UZ3EOTV2yaZamum1pzVaCyjrt37l3hqe0fyg0P0ostpdz
	EbgYppwSgzfCj5AOOzw8H8oTF6x5WCk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O03p0nJ2LMY231U7XFkXI3cgsViGCbzfInLMAnbHn6Tr21PqnJ+pq7ECGAdUCWFlHHn+75PwRzh0kYykRNO8ucYjthtR9mDdeCq0uPoU3KSyrehcjWvaqKSPd2Y5wrRqOPayVQgLQmGx7MWjGSpjojAZyKtz8Bjq1yOCafFxgdYan/KuliBDCar0rsZHFniBCArH5LHC50a09lUFVvr4CDQekY91kJQVJKWNPjuVjj6VEfyPmYe7xbHPHjeZfEvmlCPBine8rNeJ0NUaYoE/9Ps/LvAY+hA8Z0/FQINr/tp2ENrEkzG5ROyjaBohKANr04VTZ8NpD/lsJclfGplZTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ESlPa9Ug0A6mTG8AVoUqSglzO81tywO0nYb5bjQSE4w=;
 b=DecM30I9T3v2E5moGWCpA53c6HbcMkoL96UtV9gI8oOJzVcFsY5/dFJXD3g4RGAjRqufA2iZnfLJSbwzBLvy/ssgv/OjJ8c+6o4P2wuLiiPKS84tvS9KK3HPa85jJzb//aAVu2l1jFyj/hfYvmVSMZUjDdvrB/z2elqOSltDv98dVwzhagvA82rvCh/o4G/87jEpHSuwASx5PYKa7xYrTmMP8+gswyVh0cuC9EaS7TK9USyr0BF1YpK2JXPAxxKLOQAeFy1bRO/criyTgOfh33SfxlOEZI1Rq4JZYkSxJtNoyY/tSzZjJ9bfWZ+fHOacF1H477ZZlpjMp+Gby3CRYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ESlPa9Ug0A6mTG8AVoUqSglzO81tywO0nYb5bjQSE4w=;
 b=lOiFT4Iqwm6X3xfYa5S5vq8GWHNVKxDszayd3+DKmzif83DMc7tsiqY7Hty6+pOIQJL/iZ/Vpxkhb/cAHGh86ty6EEsgSzdR+O6k5cMUBY+3VrprQHDYRzy0qr7ffuSC86+Eq+BvfEhUKXLYNsWp8tc8jQP4u2enXxSHwAWu2au1/u90EevjTP1RJOWw4FERql+KBQd2jAtxIijmDybameIiFpXPLzp3V8mS9qPsP2nji3cRic+nlWdvOPo+U8ummECFoLeqLZ6rv0uX3015KmCS0j29VT7hAVfmep7AJhdWA9VAWe6kLEoocCCS7RqIWDObE61KewSEcG+549VIAQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB6440.namprd12.prod.outlook.com (2603:10b6:8:c8::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.92.7; Tue, 2 Jun 2026 17:46:10 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0071.014; Tue, 2 Jun 2026
 17:46:09 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Liu Shixin <liushixin2@huawei.com>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v2] mm: page_isolation: avoid unsafe folio reads while
 scanning compound pages
Date: Tue, 02 Jun 2026 13:46:06 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <07E96104-E481-43E4-9ECC-5247A6CF4EE2@nvidia.com>
In-Reply-To: <20260602101147.2892436f68fd383723c39855@linux-foundation.org>
References: <20260602130755.38794-1-kaitao.cheng@linux.dev>
 <34F0943E-4ACD-4655-B9B8-41F658FCDB7E@nvidia.com>
 <20260602101147.2892436f68fd383723c39855@linux-foundation.org>
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB6440:EE_
X-MS-Office365-Filtering-Correlation-Id: 563b1ec4-83eb-4888-28f9-08dec0ced4b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|18002099003|11063799006|56012099006|4143699003;
X-Microsoft-Antispam-Message-Info:
	9mHeqzrewPZURknD0z6DiEIQ5ZY4o/DwnkaCZhxFPy/SkVfROFiLR+8fVBUyfhOM2ubTwKyR9PwTYBQ96v4KteSkdE4USVlKv0sDp02EX/tdrc06Y+9R+lLGdf7/QzZ5LgY9FQ4z/Pf5kpoxCuZwdIYyEa1douVQlQ78m/6Dsk9eEo2jfUKwSCKguu2P8F4H0uL0Q0UqlKWBWogHI1b0dZrETVO8UN7NB1LEunCDTZP480NilEFw4WeO4HGuf6olG+V3aZY3g/MoRRmT5I6dgzateJGBY3a/LHPtUerd0ZuTRhirdpsO0lhuPvjwh9PKFLYtyasDLpL4A1NeIos+hXhHuPLmTEulAQVaggSKdtgdxGvVO9lAG9NsI9w5RbfCyzdkEoH7Bnlg4K7vABRe9TPWvwrfJGZsVeJJsP880UDRIe9YIL2OEyT4s517s5uybA75OQTrZDUgvPKiMccC/gOkZ3PBIDcR3xs91q9xWgleral8ZNQVY5hxeuPTrUjoNV5WP2EfOWSYXKRs7YijqfQE5y2NGTp/oXiME4T48jusFAiP1DdVXNQBm3u1BIKCqyJIRwEOnT7KOTG184rcC5RWSKUgzHA5A7BhimLpxiDC3LDoSu0dmJ87GLQiw7HNL8QSbRZWgUql4ldNVHq/nCUW4DWIlVgicCVC+I1Gvk8JSVk/h4/va8FpDnBcyNMV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bKYV1/hTNjisSa+K7YxrZYSYe3BRt8T4hri74hTbgraJnf1SFzDwUhBvyRtU?=
 =?us-ascii?Q?/mBWmKkayF4J4bPNmuNa+MN8nk/XpG/oFhjPOy3HM/GiPTeeEYdLbFt9tmc2?=
 =?us-ascii?Q?o5z7k+9CSrezJHpjXVQAPLCtrXVY6HjAJZOB6RL9uQYygSHt/wIVGhS9NLey?=
 =?us-ascii?Q?gUxu1cpkN2THHrdU12BS+xclF/AGITgO0R4K89Ax65J+JGI80VFFYeXRbk/G?=
 =?us-ascii?Q?kCC9b6FZu/QUJ9xFrMb73LOHMID9lp6MXVSwTW6+h2HuTWR4RHYlILtzzwFQ?=
 =?us-ascii?Q?64mQMqbxEjYkDDUtcmoLqe740KUXc2D4/IvBYrNvDH1tshYiR4To5sH5tsOm?=
 =?us-ascii?Q?xnldSpH9qCxYyN3xyYbx6NjlZYct/E4ygdgzyA1hRSB00LXw/pyqq/oq9rGp?=
 =?us-ascii?Q?DviUmypDdkLtOHqGPVjrMp7qoDUtklf4BMi6lh7MeBUOnYvcorjsm8m2HJrQ?=
 =?us-ascii?Q?TngZggJa4AKq/Cw8a5HTsfSHxxkBdepx+R0zQ0miEeahTIpqzqSp9mdo3062?=
 =?us-ascii?Q?AamACxGV00yDZSPoZbxFs+j9dXcYhPIRM24i8k2cgwFGH2d5h55VuyXxny3D?=
 =?us-ascii?Q?oTt9EgxaDI1jiMYMFTItGHLbGp+s10F3dTcYpZoHLkNA5mcqNBXSljCe9oNw?=
 =?us-ascii?Q?nAwTWmRo0Nhobntb7HfkG9R20zoDcnODaIG7nQJD/LHui8LYxD/jE1E/y7Wk?=
 =?us-ascii?Q?XFsrLFzrfPIej65FRSrjFELXCEjRehu3ornvla51+p//QXiBNBBuP3dngwN+?=
 =?us-ascii?Q?6Q4ccp1bvv5RgcpFGDWhkwuQD9LefgO3ixlUO0biWFdnkSSy1vdMNO42B0wY?=
 =?us-ascii?Q?70gvHXvYRYnPqhBfn4c4ySZRRj/8Kdgy2/15h3DSCIeZd89pD9vmsMqZHwUF?=
 =?us-ascii?Q?xYWPn2c2qR9q1p0yAZO6R+Pt+u+7Rhsde0AVV0Jb3PrwqTcrSFdx1qKam060?=
 =?us-ascii?Q?IvTC21As5PnPerYVAuJSHU/q+91EmIXe9ct1R6Yrg015/1xdb9m5F8wR65RN?=
 =?us-ascii?Q?D3qP1MXu1s80Q/wGaI3+SdZNn6HhgmCpKn1zSrSSsEKizxD3VS7vNCaH+zHh?=
 =?us-ascii?Q?Cm4oVn/G3iLOOcXy7mmtMbJwSFurz47hDROtdOdwDqNBoMuMhALeQ238MUnB?=
 =?us-ascii?Q?XibJWPZEKGG4BRnaeZGS43RNGbD4JYHbWm5HOLS5YW4bOPP/4yg3y51w+74p?=
 =?us-ascii?Q?mHL/vREg40TOkBdxoBYSvg4n+gpep6WIalYxSKUxYkGwhQin3T60l/6GisrP?=
 =?us-ascii?Q?qDQSuwQv0xI5I4MGkf9fcwxj6qYfIw5RJNibZN9JUrj0wyKeM7B1hlDGP06d?=
 =?us-ascii?Q?4rYEDB1grbCnHAYQLlEO5Npl0YGtnGytwYTu1EQxvXM5Zjpd7fv15IXPbvJ0?=
 =?us-ascii?Q?5CcEGEPGVcpXCpxExIzpvMdNNEx4JX1WmFwmFTJkJnQMMm6nUk81GhF5vTPS?=
 =?us-ascii?Q?ZcF6lINL1e3F/3RtGcXdqqkyXs1ATxKiJB3tniriFXMCrUpGqnLtfc3eMTpg?=
 =?us-ascii?Q?Li//qmiMm6101lsa9Ony0PInYZAJ/zArutuaa54gzxHGQltpV2zWTZXHFxRv?=
 =?us-ascii?Q?pFlJ5MGk6dl/qkZUqmIPdS/AJN5yHDVmhe3Mq0kc3jxTT2V9YtH3USGLnypO?=
 =?us-ascii?Q?Tlt8DiqWAAFqtE0Xe2N0GAXDnhlTFs03061gzlEe+ucg3sDjTxGPoJRQT5CL?=
 =?us-ascii?Q?pVXqoUYNc5wmVc4NEBzLvz0B+pYlF+3BX5xaTqok7DRUhXdk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 563b1ec4-83eb-4888-28f9-08dec0ced4b7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2026 17:46:09.9206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: loptiCmDbQgb0Xjh5RKQ8rRTAsxzAIeFxSZWyzOWsZZfz7IQ0zA9yYHO6BuQWrll
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6440
X-Rspamd-Queue-Id: 86172A001B
X-Stat-Signature: ebbbu6xjofcf6djp59hgccxeyx4o6fzh
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780422382-480318
X-HE-Meta: U2FsdGVkX196+o/bWAXI9DVDX3ZsEqlGTpvIXi2ZrlJ4RjZAOE/LOC1QK+tJ4Jmpq4xjMBBUlJFchFr8wvVPD14htpZXwbWUt3x0Lg4co10seWvhdVTb6cYHQ5jG2N5HCngOB1AXmnJ6P6V2kabtFaOWCp/cbBQ57izXaRoEKQ4IBvZ8yivX0XVmH8JbaAdMuUsybF1MeIYPsZTHlnM+/DtlekIj0yxER22ERzZVK41IP74kZWPtGF4zrdFQPeM2Z3h/PIBOhA3Bvumqul3fDJh9OPgTLhOlih4pg56sZPiM+gbmpnVmpTozRtfn6V5B7eNaWHaJhOOlv0zST6KM+wGGtnwjKcqEfizRdaAi00TRrSGi/PXSu2oidqt1tEt7CYwXDAcsOG4GF1UuvY2ghyhb5dD55FFPHGnwAO6kced1R75p6vUAzRSt+5I6otQRft+KbAfraQKXRgzkI50NhvgqikcHe697j/N8vdsG8bNHOuc1B+JKbAm0QjYVeOaZXEMo7eUmxc7UBXYj6FYqU1Yvwl5a+mgIACRpqyf3g1EzTuulEok3/s4ptcW2UTBzwtoL01w2TIgs0KkP0hP6b9gjzAnsXmmKrueGvH70qCk4+Za3g2xwmwZGcoweKC2aSJn5Fii9x4G5dijdFk6K/C203kXoBXzTeQPNOucS3GeLwQzu/B4sA2fDsIsw2BrVIu6gAJgxktaEuzFelRNvq0TYVfAYd+bhW3ru//x/4cKO3k8W8gj9JRRyQZpSG5kKbGsHqu2sF+0lgZA6FoGqu/2qKP2DT/5uOsR9+mcDHMTq2Vu/mm0RckbFyJMLV8ynaJt93PtGHLxx1msKbDQvwPvtjTBFXpJaM00nJgZGSDy6Ay9wXV47M6HhOKE0EoBJGcC2/dafEbGfHLF8qlO+ppKMY2b3wc1zl5oMuWzsEulQZMyY5AC+8A05c16BCx+ufbMxbA2fNfCB1WiiGoz
 ibI6bzyM
 D65BszfNkeRVPYKN2f5K3/xafth+KT2G45EXVys77qrC2GiJhdVOT8ln8eckyRPdNyb1pFnon2SPyMudFoHKt8BQ5lW+IUXDN3BcAy2zdiEutq2D76xdGWW7/V8YZY7jbO84Wo7+a1ZdwY3Bi9kcHigww8gmLBidlx2WC8TUJToIDNmyZjIIXnD9irLzSftCMQ52ZvUCRgh8DoxZD8HVlHUKxdGRiccyzt/ebQtbTTCgV0Yb0rvbAxcgvZcIut32oNGJgLJhiI5rcabimAj8WwtstoUbj5WsZtiMfq8mjhUHONf1UOYa7JmJ8cBZznGQ/2Q8saTJ/3S3YefSiMru9bTESGFPanD4L/rv7XgmHTT0dgEicWkHz0Kw1LJYNcYXofc42aTZmPTJpTXfVSQX2/YOCzBS7SK1XbX4OhCesqTFrMRiZt/nKj0ihK0QfKZ8F7CCw+t/RSiTjBisEYAPCgo5B4CAPLIqzfIkKrtNpZl1l2fr9X9JFL89jDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Jun 2026, at 13:11, Andrew Morton wrote:

> On Tue, 02 Jun 2026 11:02:41 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>>> -		*step = folio_nr_pages(folio) - folio_page_idx(folio, page);
>>> +		nr_pages = 1UL << order;
>>> +		pfn = page_to_pfn(page);
>>> +		*step = (pfn | (nr_pages - 1)) + 1 - pfn;
>>>  		return false;
>>>  	}
>>
>> LGTM. Thanks.
>>
>> Just a comment, order can be dropped and use
>> nr_pages = compound_nr(&folio->page) instead:
>> 1. order > MAX_FOLIO_ORDER -> nr_pages > MAX_FOLIO_NR_PAGES
>> 2. PAGE_SIZE << order -> PAGE_SIZE * nr_pages.
>> But it is not worth a new version.
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>
> Thanks, I queued this.
>
> What are we to make of Sashiko's question?
> https://sashiko.dev/#/patchset/20260602130755.38794-1-kaitao.cheng@linux.dev

Sashiko asked if compound_order() returns bogus order and the code
can skip checking unmovable pages and return false negative (the
range has unmovable pages but returning false), leading to offline
in-use memory.

Answer is no. 1. order > MAX_FOLIO_ORDER restricts the number of
skipped pages; 2. the actual users of page_is_unmovable(), alloc_contig_range()
or hot offline, will perform page migration and unmovable pages
will fail the migration and prevent these users from doing
anything.

Best Regards,
Yan, Zi

