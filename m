Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A1F0C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:38:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ECED6B018F; Tue, 18 Aug 2026 14:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5296B0190; Tue, 18 Aug 2026 14:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA036B0191; Tue, 18 Aug 2026 14:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3951F6B018F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:38:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CACF216024B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:38:34 +0000 (UTC)
X-FDA: 85115250948.12.76B0B73
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011051.outbound.protection.outlook.com [40.107.208.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id DCE68120003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:38:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b1x9AxR+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787078312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FTga8UMIRYJaHKYIPluZ7TwRZPofOSvhphcB0sSwboI=;
	b=6CjSJRJ7FsLVVZCaVDUnJFHcvR4myQtA5dBoPQWP3O1S2mzW5aAcVSqDpLscSroICDa3jL
	S4rWddNzIto7oveOY1W9T0yojZsPs/CYjAJEe61WAE7XJhp1ZucQoMpDwCDwJ1W0obFZHn
	4vdGLDEb6lmAA4o3wDspsQk5kvDAFPw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=b1x9AxR+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.51 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787078312;
	b=x49lxdF32EKKOXido7GJave8vw+AHxO9wnnstk9/txGR1hXXQr+TWsI3iUJpdzrLw0xdBJ
	+fBMQKGndzD7eHO6tSkBk98VLMskyDL+azGwq14Lrh8nMxmNzXdMz+Avc5/R2WdhEb5g//
	Ocv8dM+ZDX73PxOhhHIVDcNWvT9GGsA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TttcWVM7usaTPEl1m+GFhqtAjJNL1hm/Le37UWzkppdwOCYhYH0Y6qEJZUhK6lMQeNxugJb3JFQokLHvzN8DhTQ+/TJ1B4FUXYPNdT1L9CCE68gE5eUk7NCFux8kKLv4WQ1PG2swpw/FIfotsXsmPtqTg4I1H2YxUFZR+L3MN80NxWiz7RKHk9cUXxNSORjtcMNIxCWuX6FXjOvqvM9lI5/j/5/pit1C1NX1wKv4ZbnD+GxENHBfsNwBGRcLQk6oaVauPUyVOy+Noq9V4khnPWhSB9gWpXj0b/3DLUuwtKXacIIV017Bp4uCaBJHBS/t/2js29NRkpkP/HPy7XdPBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTga8UMIRYJaHKYIPluZ7TwRZPofOSvhphcB0sSwboI=;
 b=PYJOOOwCx3nvrDeCV8h4in9Tgo8berX1JbNbZs0NpU08ejd5Ya+1OQRzzRI+Qc4Eu8EvaCElsEEm9bNPWiypbVT8qjAo+PRx2ZCQTpkOEHcz1IOGq/j8bWKX/G5pr1/E6Mokh+X7TSilp3WxAG9szs/au3oaihRRUm/i18zFr0kV9zWZl+szCAt7t1Mdi9nooPbOF3qDwreef6CYC43FDcrQVq/mTOEDogx7XhPN631mVB1MjMPyyn3CvToyawRptwN1JtIgf7KLhpPVnA4D5LG65fTxvoQp/U8goW/+RFQvIEScSRoOj3eU7fZdDiUK27PYLWjw/UZxmBa5WH3m9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FTga8UMIRYJaHKYIPluZ7TwRZPofOSvhphcB0sSwboI=;
 b=b1x9AxR+rapG6MtozIRerKikO8v8AJOpQqpcKS/eDrZk1fJF6wGigLNeleW6GwJC8gmevBtITGFMMgMPPIhLEa9XVH61pgabB0WQW9MSwxc51s7FIyAIX6eoYzs+7/xRF0TqdJwxEzjVA3dm7VjFCVm+dup4qg2Oogh3yTttq6G+vrst+wnnPgczn2IamJhlTOhtybvxDMHGEv0l5rZ+C3l4zF7bubkVHu4yHr/5MnwJvy16h4O5CiR3q5+DSLgXFlrASigLArqh6TQR3Ef9rDspC8MZlxeJTyMqcXqLWYZuyfv4DXjJ+9d6YCXOYle+BL1tDwTB+H0aV7bTisSDmw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SJ2PR12MB7846.namprd12.prod.outlook.com (2603:10b6:a03:4c9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 18 Aug
 2026 18:38:26 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0339.007; Tue, 18 Aug 2026
 18:38:26 +0000
From: Zi Yan <ziy@nvidia.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, linux-mm@kvack.org,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R.Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 01/12] mm: rename pmd_to_softleaf_folio() to
 pmd_softleaf_to_folio()
Date: Tue, 18 Aug 2026 14:38:25 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <E737BD86-BF4B-436F-89A8-4E2FA4EBCA5E@nvidia.com>
In-Reply-To: <20260818131202.494754-2-usama.arif@linux.dev>
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-2-usama.arif@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BL1PR13CA0421.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SJ2PR12MB7846:EE_
X-MS-Office365-Filtering-Correlation-Id: 6def086c-6305-4df1-6fb7-08defd57e435
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|7416014|376014|56012099006|10067099003|3023799007|18002099003|22082099003|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info:
	+1QansHrYAhOD65MkslSsrXLCtk51zDqHDptO3dAl8UM/BGHbbRQvcqBvG5iCyu/EzwlsZD4768YRJYHk24qgkGC/yJoLYgTuHrqdEWjemLwLo2wLdZmZkGhZVtQYTYVn42VaFCpYFXY5tB5TEFF8Aht/3KWExcc84s5tpVlYPraONz3ae7zgJVFQ+laNhG2oYRoRUzOy/3qdlHMy5bY40+fTfrpn1jwSEyrvizrSri/i/pJDyCKFc9aAmXqY5wI4XPJNuZPxt4qdh19syZkkkdo4sypesOvtvf8PuW/kJijbKpVbrBMcUmtDXNS/HnCgqxx7YvRv2kypdw+Qvjp5PF82YUeuYqhL99Q+kZJiPtRfU7HJELf6BxFXwBQPAxvWzVY0ht4OnNUQ2053wcM87oYQ7qpPtOeB5YKcswYTzYt6kRNYTizTDru8b6UtJAutMujIP/aIpRowwFaypxne1ckT68OW+tbH2LxHVxx31RPkFIOd6IvsXwLMvVo/FI/zI7NBXCTO+4PzGUYVKj7XPhUlv0CBFQcUl62QxyWpl2a60DsF03HSQa0idZJP7tp7/x+iyJ+AWsVIyFp63fFo+EIfWqoB8jQyO/EDT8W7c1EJ9OASq0DcXredY4aqpsMF53osYxrnHHfWE24kZfntw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(7416014)(376014)(56012099006)(10067099003)(3023799007)(18002099003)(22082099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j9rKNQJ1B+NCc38k9tEI8SGMHTMB431v4HwqncPLWaKhnydgXLmUjMWL826B?=
 =?us-ascii?Q?aeRZ3ZXh2kx1DCGZV1jD1AzY+8QtcJCd5lWEeYvatBQgJnJnJDNRjiwtpaiE?=
 =?us-ascii?Q?tqcHMSy5PMaqoMUbm9kMKMKGQ28YKpdOGsykBEJl5Ixgq671qBqblq9aQotc?=
 =?us-ascii?Q?rANFsK5QXzuXWDzkWD5KffZ1Q0lG6YIXqxOa1bBaxxh96MsvdesufSrcqvJM?=
 =?us-ascii?Q?t3Q9uaBvh0y3vA8afZ1I999MgCpo5QBHtTgmKfEVUyc87FD4SnzRL/9E0v6P?=
 =?us-ascii?Q?FXgELaGiWdHg7+oCicWgMXbcP/Gho3c7RtsnT1hALcXoqOtSJmEByhYm6mKF?=
 =?us-ascii?Q?lL3Me6Z1jBk4p5Xfkg97BHlFFraMSC/k/08Tycbu9tC3kjyG5bN3FAsJDgIk?=
 =?us-ascii?Q?KVp0GPNWcRQnEAy35zf+EcLLMH9zcurM/qaHaBpwRjdmDhT+VMBdPtBWANnm?=
 =?us-ascii?Q?LABX2NpXcms+1CdGotrEdIba8SB6ycFQcdPRjCAMFBLdgBrsyLjJbxLSkvax?=
 =?us-ascii?Q?8nZAfy0JtQT9ICP5ZEAhdBAs2AaYiCcNl6q1hBqsltI34seR9yU4XVqnyBoW?=
 =?us-ascii?Q?jbNrLcnv45C7sni640xc4PzC9QQFCpV6isdSWlF8DWbeOODnmtFR0xVtfu/O?=
 =?us-ascii?Q?o1Ow/x3b16um/uhvN8vBEj7YoDLRKhnKLhdHQ1GTdmPb7IpGhhdHGWcAO8sb?=
 =?us-ascii?Q?IBiXWQDc3GQLzgOcQ0PWum6Q3/uyJZdsHlBoEmaZv4Oph509IGzHxOFkxuKj?=
 =?us-ascii?Q?gEZUaiAjQaalVjVHlL+jAKDfv4LH8yyylPjvNUdn3ZnDp67qC8rkn9mP+EQC?=
 =?us-ascii?Q?qxZKQtPM/q6hGo4YNADtm5+Mc5odUVFW2iuwV2Lr2fH+eTWfjrdtR917VYfo?=
 =?us-ascii?Q?PG5fgjNBz7oo7O2g+iMxjVB2rCSUJ21UDjFBnnO6sPDZkFsflmtxqBo0Go8B?=
 =?us-ascii?Q?/apUszP+5lVLSMkg+a0iIS9EO3fSt25AL3cnEW0laAd/EijupR88AHnfF84b?=
 =?us-ascii?Q?lWZJRt4Rk3VAX7b71h4X/1Voi1ONgC5wuFXmQ/NGiLPj/2RMJtwniBMej1qL?=
 =?us-ascii?Q?ZcoUtv0gV5Gj7/9oJhqiWY6HEK5ZVB4i3+RA52ncFvxCHaI2+xx7SSpgBqGb?=
 =?us-ascii?Q?02YS5pdmCQFNujw056GaGr999eb9YFWqN8zbl9FajZymW9eXA3t+u0kzpsMX?=
 =?us-ascii?Q?BZHwlvIZaGWuqMiKfWnloKxM+w6kn1DMIk68KXvxjHyWL5VHrLlcRd0yM/du?=
 =?us-ascii?Q?prUVwr4pEyyeajpoIJnAcmJfVUz3ovIWs/XmPGwR9FftWTjhvq2hOFrxy/+e?=
 =?us-ascii?Q?OtK5DsoGTRpuK4hS9gySoVDqa/bB7Wwxx0ArOdRdD1x+BVtg5Nfg46PNyrwy?=
 =?us-ascii?Q?nGLf95piOGYcKrsELstacmAbYd2N28y9JgVJg7qxHcZuy0l8pw8R5JG/UtN4?=
 =?us-ascii?Q?2oH8hMZnTpa3LLalr5/tCupG93fmr1WgvJYVjRTXMXeD7A6UA+DVJO7iB3Pl?=
 =?us-ascii?Q?yL4UAyXH0HVcD8iHdKNxe/WstdHnlJYukScJAYAGSwzoVgyMu85uDZK+yxSe?=
 =?us-ascii?Q?3PVj+LppOfOQj59ymzn6JzJ2MEj4/bBJNGHg7+TDsz/ff+VUniMm74A+HMLx?=
 =?us-ascii?Q?X5X/pscG0fXvp7rJXzHRleCBd2yDWwRL4hND8mXr11J34kzUrQokh8wmYi+U?=
 =?us-ascii?Q?jMBT7vhnW5LZ6stYCAQ04g6Lgbk8unHGn2xcRtnQFEqReAxZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6def086c-6305-4df1-6fb7-08defd57e435
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 18:38:26.7078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwj4DuUm9hwCmbYm5eryQ+wNt76Nz4qq96FTGu2gIITc8hNAl/BgaVYx+Hd2YMZR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7846
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DCE68120003
X-Stat-Signature: s4gkg9o4u139rb5hgfc9wypg3pumtpz3
X-Rspam-User: 
X-HE-Tag: 1787078311-532805
X-HE-Meta: U2FsdGVkX1938uOWnUUphUrKV66xVSujBcUBft/sXiF+CZVdu4367vtvpneUtsdfXEGAVSYMMaKY6oNbfKlhhQ1rQzRPwBu3k4q0a+JzqI/kI2aWnmxXVrxDgq/0MEw1CSJ8ZSU2gjg2e0P7k4QyY1//yFqqEjVvssqHV+9B422PmZIwfXCzJD2aLKl+myWl58nUh22ljOCeU85j+gjR+vZ+68UEycNtrY84k5ZKEi2gBk/f5nUvirMQRdFWCX2cZI1q+W25SvHKkrObSQJ2mOstFVnjv0cWMGkb/X0LfhNoVFUfAtZ9CQVc37+iwM7Flbi6GQv6MSg76ysQAes2gYaDpY9WTgHMAhxqbgH/FGgpEemx/wv+ZFMr2Mm3zZx600wJAPdOCVNm4e0cGaRfcWYpxyOYpETCtnBPKOpVQqMoOcGPNkFxPL1ueV2vHcnHlozBeWK5VQhfnB4/JlAPM/E5/G6m1i53iHx51IgEMjpelk3oXgdKjS+Xjb7TiGyQpUzQi46ySaEcMAnEEFF01i16q9F/ULHQMtBXJeGq0R/ACOu8bO1T9jLg81546oSNNECpz8Qj7nCu6KxaPnzT4a/dlaz8vj062tuv12Xy+jJetlNXRKdCPZPyQaG80qK/u7ZxpOuGHDu9Nd43Fl8vGS3Pb6gdqFpeVuibAme6gpRjC+YWeEb9c2MhgOuJx0hh7F12UhvqsOgQHu/2ZCgrK7KsY8z+4iwXwJ5zmehG3D41F+ax+VO5VxOpzNFYqWxiMHtAXpynPg8ybDuu7xXzyH8gQaOZPTLP1yH5+Aohk8sVfrr2/68zPDGduVe/VbVjYeqaQGCfV8izktUIg6Tt1ruwzikeZUMfYGSO8PR4vHg+FxCRZHPBos2v9kgwGhOKMR2WQLiM2025rsf7LZlJJe6W0uga5kB0Y4NbTnvZz8buimZG6JJjk+QqU4OAXvI8rc79fpei97IY9UV1Vhl
 TQKCNXWF
 DgX8LLwzd4n/KfDTsoR0sBir0B2sy7peT9UNInjTZVAb/RTjEWA30FMEhos/uN3tf3tgE6WEnhPs3VmVxGYUtFKxKLsr6GJi0wYs4PAsWaYGvbx7ygXg3RTVZzDSVG4u87ut/bhPQJsR/fjKWj5V4a830epGM3GUlHu5MtpGs+36tkYuHJZmq7+/+bMq04REirGCyhYkyuDEU/8QmhesGa19D+8gz7b/WNhFSwR0lovfinDsCcgiCaNPQo2ynw7MRiCPEnx/gyQ+nVE3k0QwF7ZTrfFjHsFGjQBZNvY3dNp346k1yckD21oTPpLvdiw9ovrf+EJmhgBfG7eINTDPpBR5nZ5C6heLzU94ZZNdmEaCjQABEgY6JgYZlPmWESf7QYb/GJ6mdkhygghXrssxA/ikEzgTepqy7wFbklY0aDcw8iYK5QIGU4j+qumYnAofE/SCaFqTORbe7mpte829HZtnhuTkoOQ9wIrEKu+9OLXUWh8dy35L+/m5LBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Aug 2026, at 9:09, Usama Arif wrote:

> pmd_to_softleaf_folio() converts the softleaf entry encoded by a PMD
> to a folio. Rename it to pmd_softleaf_to_folio() to make the conversion
> direction explicit and align it with softleaf_to_folio().
>
> No functional change.
>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  include/linux/leafops.h | 4 ++--
>  mm/huge_memory.c        | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

