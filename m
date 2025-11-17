Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B93CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 15:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F368E001C; Mon, 17 Nov 2025 10:56:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6670A8E0002; Mon, 17 Nov 2025 10:56:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57CD88E001C; Mon, 17 Nov 2025 10:56:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 435858E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:56:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D52541401D0
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:56:50 +0000 (UTC)
X-FDA: 84120552180.23.10DDFB1
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011022.outbound.protection.outlook.com [40.107.208.22])
	by imf29.hostedemail.com (Postfix) with ESMTP id EA8E8120011
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 15:56:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dgwCjjkp;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763395008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5GKkEAa1Qrg4wkXafbEnXzzL3HWJmUBbHuZyPtEgOo=;
	b=KfI4p46kNl5IhkJGif5cKW8GsuYrDR5KFZVUEMwSnDsXU7Fy9LO95nAWxRycbkqiR8+EU7
	QsE75aRfpfSbYzJH5/7jtICUbtIUvqP6K5N7dmxyeNFz0aYADSr1vfl4ajrbTn8eSRHRaM
	A090MHUc5ZUDOR16Riqt50KRjY5fTqc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763395008; a=rsa-sha256;
	cv=pass;
	b=ORmp1BPwoPXY6ZC19nJGtbSciKGA25uEMNcbsQOaeITb95LXTKq/Zi9qilNc9Jun+SUzhv
	rhhxLtnfxk9pAyilu3GOyZ4tSfJwO+q4GMAZ7qDG/nDGrLTlRKee6YSzxrDsQdEeZ+b9Lf
	8WO24AD7nJgQGcc0Y//Oxr25cp7xmQI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dgwCjjkp;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hrgyhzJMDyXT0aZ1WfIPAkoGV1/e3vKUCoo7mpk71JTIuYAvKo6NmrhnTKxDEnHvdJ9nddXtxLZepsXW5iScO6dr2JFye5U+ElUHpHu5MR/owE1m8tzMRhJ1XvgJ1afZG94X/qo8B19olpb2kbC3v1uLqRx6WgghAecWH3FbhhB+A7epjX+W9A/l+Cwp57cdazsdy8+ZXnL5nvM3rDf8zX/RKlby7cZZk0gyM50blUF2/0GspixKd7XWNIbgZnHp+2T1w09uBwoRNy0RILroMhPmNVtsElTKeTgvTIaaZoZ9a9GHMOjBN5VN1M21VoBHSmKHBGSTCyUjyJds/3kSww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b5GKkEAa1Qrg4wkXafbEnXzzL3HWJmUBbHuZyPtEgOo=;
 b=qU+kyg17m1bpou6ou3/Qog96En3NdGeFHePcdPyFU/ySj37XDKn9RAoAKjQsS2rPLI7N6qzmMCWN/Gcv9HACynvsohe4ZXbIQuLwBXF2hZOB2uvJHje8ST0XcZt3tZr8h+vyj6K7TWDaYS7vujH6oas1a3dTBh8Gy+CkXeR/zwflz7wmWrrXPf2LecPQ3ptfowWpuWt8fgPzNG0RX8/3X0+3xPOVTfTUMPm9lJ6Bo2res475//20qqIqf/P+20Sbe2ytpkOU/iyr97DYrI9Tk7lxf4C0WAv0OqEtmeuHDqJSjmMTCxBECYZjCCEryAodCrEYXiM6CSStx3wvaH7AhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b5GKkEAa1Qrg4wkXafbEnXzzL3HWJmUBbHuZyPtEgOo=;
 b=dgwCjjkp4WyEhJMfFtK4jZDsmASrWCYpRPW9ahX7BuIAE8lKgNF9VxjCsst2TY4AAMtZLX5NpgPiCfRyXVHNu48NkbWEYsqNG9US27B5CQ5z62ASeawqyAMF3R2My2DXscgoQIyE1CnxG3L3hDdiOli8Hb4vaJ+02WTtmM9Yliidlv1M3kkTI9tcXxiTLB846vOj5yRwUgNGv5VlthaefEgG89XmSQ+xrTln3yT276ktMux2zEBHjseCnLXlKycTXLRelGHzVarT2QhRBU4GlucHaPnsHlvv/ZRYyRoM/RQm4uQ8r8kfF7b1WQN83KahTJ3kBVSNDttZOMgTklDomA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7727.namprd12.prod.outlook.com (2603:10b6:8:135::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.20; Mon, 17 Nov 2025 15:56:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 15:56:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
Subject: Re: [Patch v3 2/2] mm/huge_memory: merge uniform_split_supported()
 and non_uniform_split_supported()
Date: Mon, 17 Nov 2025 10:56:39 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <337CD281-F5B3-47FE-82C3-ECB236450F60@nvidia.com>
In-Reply-To: <20251117012239.lqm33uu4vl4y5zqc@master>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-3-richard.weiyang@gmail.com>
 <20251117012239.lqm33uu4vl4y5zqc@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0147.namprd03.prod.outlook.com
 (2603:10b6:408:fe::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 87cafa27-96c8-436a-5f4e-08de25f1e67c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?95+qKKE6EsqfJUm2DnZ91gmq+fGMOkrOcF07ajtwyMbA3TXTko+jTg6Vmh8x?=
 =?us-ascii?Q?ADLx9BVz8y3ROjXStmrTd7CdtsGMbk3e0LwzjBotZfds9wEb+QSiiXWPPbCr?=
 =?us-ascii?Q?ukLwXXuHw6u6Bj5E6hb53QerU6oCWa7Rmfmzcvyo6FaAUIbvvbJu+qaa6EuS?=
 =?us-ascii?Q?Ro01FQ8XVhWBy5DdqlMFfJiBsfQSLrNhD4ZsNPrxBOKefYWqBZwnZOgFKxni?=
 =?us-ascii?Q?h9YHKRJbNFHWDs3V7XITgyUfiaYZ8qAG8Nq6zCqoXzabjCikiTCZ1Jt3aQHo?=
 =?us-ascii?Q?1IlAAFrmiz9FpU6J+8x6S+GkSbYm3YYQzJweDIwTh2dAmcfnU1Rv/wSs0mMm?=
 =?us-ascii?Q?4ReJaWDRsyObCclrqvwH4VmbeN06VX6B9/uaUKwe7neLY2uIExoFXZELmYd4?=
 =?us-ascii?Q?ds1doLIsRS/8JRpeWn3J2UxPS4Ml1Spr3cDOVdY1gKLHgSKDe3QO/4+KoYy+?=
 =?us-ascii?Q?GOzLkM3jspbDIrq8pmkspq6eilapRi9EmTrhvpDJ32lo5T0E4UoaYkSJ0Rf5?=
 =?us-ascii?Q?666Ab9zGHvttnaKtns+k/znN1XfJA8r6KPQ9GMqoJFip/5eG8XZTPEL47G3b?=
 =?us-ascii?Q?L8KT39NwE3B2hf8UxNfL5NtBMuTD0uQGp6hBnoNKic26gqv7inHZv3GkKcWw?=
 =?us-ascii?Q?TSCvFSb4gxasqwGuR5oKJKKH02oUEWVoYMrYb7QpVUFff5DC2ib533sCgK5f?=
 =?us-ascii?Q?lKSqchb/PmlYuOpO4cOq4gcgNTehgQ5jKOsUSVCVh949qC+3aJxzQ6PId3hZ?=
 =?us-ascii?Q?58PRxGepLdzCplDAbJhBtnCE9xnnfG/LaYZak17M+92VO+PhyAwxSeUvOpJX?=
 =?us-ascii?Q?7JU5rXPjL+vcMT7WEpo5C7YDepNlypefTUfNSGIquH/m/HHqfwHeYZm0JLJF?=
 =?us-ascii?Q?f6xcASVECNWoNCvG/8aqiMY6VEtRpsitsvMs0hTTgwuhNIG0y073tTZ3UFXL?=
 =?us-ascii?Q?hBk63MLb82qAwkoCYtXaN0qkUvtKP4dfwfKZzv626Kv36Z2l9t+2/lhzJ7wd?=
 =?us-ascii?Q?ZBok8QHiQCclLxUiilknGgp/JgNsMjX458Rrw6BplaphbU94+L2wl4nbCucQ?=
 =?us-ascii?Q?1Bo4JoO/veOLlniAZCO7eKzq6uFVRsngt920HFX8+rAL5KRb2ubWigOWUozT?=
 =?us-ascii?Q?BZ6JIsRmNz6c6erlBE5UkoPJdOEUcxX+OfXMwvZHH3pJ4bMxB/3ZnU9yIOjM?=
 =?us-ascii?Q?o8h/WxQNP9ka8mqYD9sX5VQxjhIEZDkuPpnP/hd1hVHltkTCnRzlDfBRoLGx?=
 =?us-ascii?Q?2D4GGGiLpbNaEB1DlPYcV/URYHkaSr6s3YCdICZWkKJKPiddTlDwqvtS9UvA?=
 =?us-ascii?Q?hug1xH3YWzIVmifQNq9bvrGD3hMcKQSlQaMacc6op9L0a4hk9yfK17Wu0juy?=
 =?us-ascii?Q?z0VnNb44l5YhaUnx4ft2HaAmSLIK/ms8FDZcXJQz8/qfFAAJLvd0QIG0srmO?=
 =?us-ascii?Q?mkV9TE57iSs+wDghE5l4g2HSVFWkmmrr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hUZowDFsov7MbLoeHFwXB3k7y3xsaXix8naocLqeyggFCFvymhSJbluKx5VP?=
 =?us-ascii?Q?cgf7zLEtuEkBIhXMJXoAAEqUA+kxyWa0YEDTWA89hs0mq0SWT7ElL5LP2vxz?=
 =?us-ascii?Q?w/5HNQvu5B4JXxcptQy4gSCwOjP3kRfw7EL1Gns33i2XZqJT+wiYJqf29hZe?=
 =?us-ascii?Q?VTvBilmRwN1IyonOsg8FBLL1lYAomIc2O3CdcFoozLCDynzHBgDnKwc5YbdI?=
 =?us-ascii?Q?n91Ci/HMD+YSnGyUmeVA9Ri8CIpuHJBGX2JtD1nbx5IqacCwT2yTIApfpgVm?=
 =?us-ascii?Q?4x2hMeJSTXweAsEICxwPRJvfEKXs9PdWSuFeSnqvKpklJYLssvMAYTvEsj0O?=
 =?us-ascii?Q?kMpYoJb34t6Em1CrzKJipaVcyg7lC/q3ANTL3Ae1U3jB3TKHcnGob8e9VobI?=
 =?us-ascii?Q?eop6+mbss/Wi483nAeWxagfRsrGC/oHIHwi8hlCXyfbvkNzHGfw/XVBCorlS?=
 =?us-ascii?Q?2VsGMh/CELe+G90ezTBI52wrxcbvoMs/XpG5++dFdJ8gFrVu8SRf3EeAPQ/Y?=
 =?us-ascii?Q?T9PSD4LegVOF8a8jsRpPlqzuom5Z8gwHCdcIvb2/plLFUYOc2rTzDkMnQhUs?=
 =?us-ascii?Q?5TFdCR5urUwV3OcH1UTV4ihCWXAViinL5EsLledCTDEd75qaxqfyjuN6Vzt9?=
 =?us-ascii?Q?Wb6EX6JXXwI7S3Lvnvob3haOOPugLBBaWrINPKRphRC73zNtWi/1Rha8yyQG?=
 =?us-ascii?Q?DMTFSPF9F+y3TjEnyOtNRlgzhvHoVe0A3L9gvlYpaPL2nFlND8/JF15HR2Lj?=
 =?us-ascii?Q?Dgsio/7sNfXySSIAhO8G2IQSKV/dotI+fe/vsJAnYkeaNU/PnFwjVK5VyLNZ?=
 =?us-ascii?Q?JqUYAtgfhcruLvJLoQyfqXuSWhp56EbGcdvIRBz4Tt6Yolt73l6KuuDkypPS?=
 =?us-ascii?Q?bl09rYb1WQhGFHsnFycHR+J+Ay5Xvnu6KS6wXmq9pUfUDX5eRz7j2+mo2ITu?=
 =?us-ascii?Q?1otvc6Z693EDkaG5WF+PiY4w6ly5ruDUucczFJ73aXaWaSTAaf26hAciL63s?=
 =?us-ascii?Q?Zhcowkp3lm44FL0Y7NUIWn1frsTjVE4ya0PeyXJQpzvhiB7/gUseHZd7cIfc?=
 =?us-ascii?Q?Gy9vzUELXk5FinUHuJ2l1Ji+pU52nvDJwWdg6fylChErNfYeBPG2v7dQa+h5?=
 =?us-ascii?Q?U3HoreXJCmnBubpp2coQh2f7UY8t5EgRyiO1pMUxbMpKJCJDaqd0gW5ou8vd?=
 =?us-ascii?Q?LNozR7N20PC4e/iNxQ55oZP/BETQT4rnG+T5G/cVAtxiB/Ojhzs6wKPCtT8h?=
 =?us-ascii?Q?t84Z77B3+9jrj6XkFTd4UdMaPGSiKdm6nO/xx3ZIbDfJBPFHHCN/Mw+++mz4?=
 =?us-ascii?Q?GwS1woGK9Y1qzDj3SF6gURQnMVb17DT/25qU0pHU1kyjpKjGxb+YdQaB/w8f?=
 =?us-ascii?Q?PFHIM7SpSgzQVyXLAQx8s0C+BlhCCsMdEqAfxLgIa17YHZYab0IXkWXXt6Hd?=
 =?us-ascii?Q?kMcHMEE4hVwIJDLmnGRkKcmEKpAYUR3zEJqzihF8jVRmyS/mkG6wWhMqBUye?=
 =?us-ascii?Q?INO6ZrSxepCQVM4v8YC+lWjxseCyS3lkm5jWHMpTgSfOptDeiu8bXSt/9NkJ?=
 =?us-ascii?Q?1F3rsKNhESYPgZDx1uKtpJCc88cReG1bijcJLshU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87cafa27-96c8-436a-5f4e-08de25f1e67c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 15:56:41.9506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ljsyYCtqHmXEi2sH8HQetarhEsnF038RLg59MLgUSRSXoY5x/ZUX0O5F1KDDzBaL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7727
X-Stat-Signature: ibrj4fnagcjpb1sw83z8rztemk5qm6x5
X-Rspam-User: 
X-Rspamd-Queue-Id: EA8E8120011
X-Rspamd-Server: rspam01
X-HE-Tag: 1763395007-216632
X-HE-Meta: U2FsdGVkX1/zOKYstp2MWUyf0UpePXhLZInvoilj6J/x5fENCBBiDXGm64NxELv9O8S7qz3ED843v6bMp4fMdYntTMNPwInodKklf6gNnTpuCTfzYJxDWbXvY1qdv/KIuX/uSMN5jrQzmB9HAIIDgD3L3HzaxgQKb8Q6gwyyR7ID4l/zRZosA+TPvPBHEi+ZwKZdGwO4W0+diu165Qq/X4d0Z+lZ99yUyHqll9ErOZta0lB8LZgFDN9B12QqP4XyL521GLOcZYje+752tFVhBdCQxwIrXQ6OyN9gHrN0AtHE39/qkcJeDw8IkihnrOdZ4rAfG/E5Bn23pwUM5sOxnRE7Ngcf6Ur+KuTIr747hyHQVg71XuRKBnWqMHdQds8yrkgE+6NhWXyIwu78t8ELx5GI95EhA29Lb4Kl7gPhey9iFoG16s8rcN69wBczHaziHaeDWlL9oTJar0us8Be0lM8JllY8QVzyr+/Fvv6CwMe6nqcvb1WcFS4F0eo0jurmVBnh0QfvlVwsGeyxXaiO8CzG9QlAf9VF5M8kBdYIUi8eUQys26LEtYT7+wnDu+6nvo/NBwD+vwKE4Ks2BmKEup9KuprL70BH9Qg14Y7FS8WV39z20Q/ZqjCyJUcrHFdwhXGSZpekfZ56wn9JFe+JO9s5k2wbfgrEh0lyKNYtEDL+mgwA822v24QqCTgOKKKUlt/yfScHRRDGoYogA9/OFW9BsHyy5NinR7DiPlgzdBYQBKSjktpdQf+fzmoi2C/dQn3Rb3OA1maaqqkk06u2ahgro3Ua9PXLZwW07e/O6DTtOuHrkh8uAfVbeh5oZSjNlf62L4pT3paz1/qORx5dfrIsXD81tpUh3a1O3PHDZRLDSGV+efICnxkTiRbFWq3dtWdlMNlKutmukgN+53luECK0rrTrGb+WOmhGWqHQKBeyj04iNjpYsa3OA95Wcys6dWACKNtrjl6w1OTwPVV
 LysE4BxJ
 f/uOHx8D5gNGFSQ1hmcU7UFfFKST/wbAHldidn59Mea9SdXIbGqCG5JJrArQYW4m7ngomvvWINwDKzsXuDGUz/LjGm7bjyP7VcG0z/uQmj8pwuX7ia2YDn7kMuh6GHdOw+29/H2bLbQjE/+85bje/ZnaHwWdqQrtrRyV/f83bhd6NOZ0AmQGo7VILeSQtfXM5nZyey2MOuYtBXytCO+R8iRV7GDDxCo3qyDETQdw9ziJ1nuhir3ABdUYsOlNUNZRP7uzHWlDvG3sCLM5slYlaKU7vuhsNFyDOQETMHFD8enzDdhzfxFWVZB94N63h6XOadeufYzlm8tyL2Uzpc0oocHK8f9NsVm9oCwEwVV+bx1itJ4wy1/X9ooHdqTFO0uUtKsBHUZqgAwpeSXY8Phl/I5rB4tRRjyyHPDP0Y9Cc1ZCoy7XjF0ZV9mU5urzwpZGLvmkQMQConglB/p03lDiClmE/+daglRq+aGomc01RBGqYKONbpNUW2/i5lbZhnhiLSoQzvFnudKuhzPdTMl2pt8C+5ptgFOFPt10eUe5ICr0py88=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Nov 2025, at 20:22, Wei Yang wrote:

> On Thu, Nov 06, 2025 at 03:41:55AM +0000, Wei Yang wrote:
>> The functions uniform_split_supported() and
>> non_uniform_split_supported() share significantly similar logic.
>>
>> The only functional difference is that uniform_split_supported()
>> includes an additional check on the requested @new_order.
>>
>> The reason for this check comes from the following two aspects:
>>
>>  * some file system or swap cache just supports order-0 folio
>>  * the behavioral difference between uniform/non-uniform split
>>
>> The behavioral difference between uniform split and non-uniform:
>>
>>  * uniform split splits folio directly to @new_order
>>  * non-uniform split creates after-split folios with orders from
>>    folio_order(folio) - 1 to new_order.
>>
>> This means for non-uniform split or !new_order split we should check t=
he
>> file system and swap cache respectively.
>>
>> This commit unifies the logic and merge the two functions into a singl=
e
>> combined helper, removing redundant code and simplifying the split
>> support checking mechanism.
>>
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>
> [...]
>> -/* See comments in non_uniform_split_supported() */
>> -bool uniform_split_supported(struct folio *folio, unsigned int new_or=
der,
>> -		bool warns)
>> -{
>> -	if (folio_test_anon(folio)) {
>> -		VM_WARN_ONCE(warns && new_order =3D=3D 1,
>> -				"Cannot split to order-1 folio");
>> -		if (new_order =3D=3D 1)
>> -			return false;
>> -	} else  if (new_order) {
>> +	} else if (split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) {
>> 		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> 		    !mapping_large_folio_support(folio->mapping)) {
>
> After re-scan the code, I found we may have a NULL pointer dereference =
here.
>
> We bail out if folio->mapping =3D=3D NULL in __folio_split(), which mea=
ns it is
> possible to be NULL. But we access mapping->flags here.
>
> Looks there is no bug report yet, so I am not sure it worth a separate =
fix to
> original code.

Probably because the race is small, but a fix is still needed.
Likely commit 6a50c9b512f7 ("mm: huge_memory: fix misused
mapping_large_folio_support() for anon folios") introduced it, but please=

double check.

>
>> +			/*
>> +			 * We can always split a folio down to a single page
>> +			 * (new_order =3D=3D 0) uniformly.
>> +			 *
>> +			 * For any other scenario
>> +			 *   a) uniform split targeting a large folio
>> +			 *      (new_order > 0)
>> +			 *   b) any non-uniform split
>> +			 * we must confirm that the file system supports large
>> +			 * folios.
>> +			 *
>> +			 * Note that we might still have THPs in such
>> +			 * mappings, which is created from khugepaged when
>> +			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
>> +			 * case, the mapping does not actually support large
>> +			 * folios properly.
>> +			 */
>> 			VM_WARN_ONCE(warns,
>> 				"Cannot split file folio to non-0 order");
>> 			return false;
>> 		}
>> 	}
>>
>> -	if (new_order && folio_test_swapcache(folio)) {
>> +	/*
>> +	 * swapcache folio could only be split to order 0
>> +	 *
>> +	 * non-uniform split creates after-split folios with orders from
>> +	 * folio_order(folio) - 1 to new_order, making it not suitable for a=
ny
>> +	 * swapcache folio split. Only uniform split to order-0 can be used
>> +	 * here.
>> +	 */
>> +	if ((split_type =3D=3D SPLIT_TYPE_NON_UNIFORM || new_order) && folio=
_test_swapcache(folio)) {
>> 		VM_WARN_ONCE(warns,
>> 			"Cannot split swapcache folio to non-0 order");
>> 		return false;
>> @@ -3794,11 +3787,7 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
>> 	if (new_order >=3D old_order)
>> 		return -EINVAL;
>>
>> -	if (split_type =3D=3D SPLIT_TYPE_UNIFORM && !uniform_split_supported=
(folio, new_order, true))
>> -		return -EINVAL;
>> -
>> -	if (split_type =3D=3D SPLIT_TYPE_NON_UNIFORM &&
>> -	    !non_uniform_split_supported(folio, new_order, true))
>> +	if (!folio_split_supported(folio, new_order, split_type, /* warn =3D=
 */ true))
>> 		return -EINVAL;
>>
>> 	is_hzp =3D is_huge_zero_folio(folio);
>> -- =

>> 2.34.1
>
> -- =

> Wei Yang
> Help you, Help me


Best Regards,
Yan, Zi

