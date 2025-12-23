Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C65ABE6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 02:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F4786B0088; Mon, 22 Dec 2025 21:58:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2C16B0089; Mon, 22 Dec 2025 21:58:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17B306B008A; Mon, 22 Dec 2025 21:58:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 06B3C6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:58:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A00291A049B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:58:16 +0000 (UTC)
X-FDA: 84249226992.29.033984B
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013059.outbound.protection.outlook.com [40.93.201.59])
	by imf17.hostedemail.com (Postfix) with ESMTP id F1F2D40002
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:58:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="RgB4DPv/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of apopple@nvidia.com designates 40.93.201.59 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766458694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9r7Zre2m9q0Wm2etdfqzlOZJg39bN9Fb2piHeDGmz88=;
	b=PgLWpMFRKuTRjahSIYSR6FS1mV2EtvECI0yuno/CGvHqqkm/QPi7fsXNcBCckx3Ut1Vhpa
	4rwdoIfMzgvvGThN6dRAEM0WNvhK3gxO7dPUT3AKYIkUOjQMfBvmwZQi0AvlWUKF1ejMgM
	K1jp5ZH+0z0JLOoIp6xILtCxX4KFvPM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="RgB4DPv/";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of apopple@nvidia.com designates 40.93.201.59 as permitted sender) smtp.mailfrom=apopple@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766458694; a=rsa-sha256;
	cv=pass;
	b=fn6ITuPt0HRD4lrNOOCRtkXmcnIwAD6I3ccbIVeSOtuxSNe5q+Dqb3M3VZaVQg/4IZb/fW
	oT9SZEgr55IztOJFof+99CvJsl3E7tdZdg+7QEHa/8wq7anVFGCO6kv9rKt5DLvvK94RtG
	/CACYCU2muVR98drOVhk6pHWPSvKH60=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SPvCuoFeTr7OfK8S6F/D6xcWTpKsT7US66BeEiSX9dvSnlV6sdbnMbBw+PMzCqAm0OewQWPZD9RhYr/6h/HCHsXoXKYGJGr2XnYhslPUb9QNWsODwWUjp92ubHqh7M2p8n0YX/D1DRSs7i+Mfaxi3cpPXgmNXBD4JYNfWEQMo6+PWVU87Qi4XxlcgWOPqSGWn7p5xVeq2jt4lyg7qYIFizh60AE+tB7Juz5tIfQnQNSFM29RFOjJeiRcwy/R8dfxj8yImfEtjmfCH2lgZ9jhxn6W/9iv8jIF09JtsD4L9nr9OFhbbr9PncSbk6T1qlCfrDP82vkvr7/UJnn3C5f/NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9r7Zre2m9q0Wm2etdfqzlOZJg39bN9Fb2piHeDGmz88=;
 b=yg3lU1oO8WUY/+Fd7jBhzFr6e3HhDkCu6IYs5JQFVqtXrov2jzJR0oO7KItizw64vR9Y8JqzoMLUf/fE/jhR2UtpN79H5zIOZS8lhO1ooTtQM+Q1Z4dtEYgTNpNyY4bFaz4LAv1rDvd6L2CUem3xrjPz0/76Jmn2IH2PAyV7/s/l9OFsjuE/Ka1VjVqW6kuNGH5MQPWaNnOjw9Oj7p/ZqzRJqT76lTsK6tNYC+yHivkBrexMizLujLtpJKN0yDwCPxtbqxfhc5xpBcJ5mvKIjELlmJolgT2OQ0BErfAXKp66vCEr77U1p+AU5WtOQ19xoM4eyDdCMYMn3Tup1OlTDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9r7Zre2m9q0Wm2etdfqzlOZJg39bN9Fb2piHeDGmz88=;
 b=RgB4DPv/c8nYLQJJca6+yTO4ubaehgHqi8UKTeurOqUa1MLG3+rexyg03U8U2jNuJ6O5Ngdf1rcvpD1OZBbedjD9BOQ3Mu2xyjK219tyKokZNWjjcdqqbopvHgPk26gIKJgFgnUPLU6f358uym7cfPioWeah4JtzqxGg3lZukvq3OOpIXP7WyVrXEiWxdQnGFy/kxt7ZOX2C3XoMuNS8qLFJX73nWiSI1eZqcUBrq+Wab53tb9OqYjY2UxCNyfVCvET7+38SGQkHCB0GFKWP9RdNL2Bp2vtX8a9uaeBjq49uRrxDiiCOAIcEohbw7pGu+vUV4BTl+Io0eI5N23K0mA==
Received: from DS0PR12MB7726.namprd12.prod.outlook.com (2603:10b6:8:130::6) by
 DS0PR12MB6413.namprd12.prod.outlook.com (2603:10b6:8:ce::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.11; Tue, 23 Dec 2025 02:58:11 +0000
Received: from DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe]) by DS0PR12MB7726.namprd12.prod.outlook.com
 ([fe80::953f:2f80:90c5:67fe%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 02:58:10 +0000
Date: Tue, 23 Dec 2025 13:58:05 +1100
From: Alistair Popple <apopple@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH] mm/gup: remove no longer used gup_fast_undo_dev_pagemap
Message-ID: <thcy3qdicenccps3ifzutcvocvz2jc4tpdrmztm2vmh3qy7ac3@kq7uqvxdoqkm>
References: <20251219-gup-cleanup-v1-1-348a70d9eecb@tencent.com>
 <42ef695f-030d-4e18-befd-bc774815c552@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42ef695f-030d-4e18-befd-bc774815c552@kernel.org>
X-ClientProxiedBy: SYCPR01CA0041.ausprd01.prod.outlook.com
 (2603:10c6:10:e::29) To DS0PR12MB7726.namprd12.prod.outlook.com
 (2603:10b6:8:130::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB7726:EE_|DS0PR12MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b680591-7dbd-444c-c000-08de41cf1b31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MP+acR8mr37P3PynQzdv3Eg7eeFTA0x893UuyzHoP1JLr7l2GgWtNQtJYRCl?=
 =?us-ascii?Q?ME5/nlSj5GJBcYKRqhWc5O+2MpC7grC+r/kO12Kqbsw2JIgozvJwN4qX+Io4?=
 =?us-ascii?Q?IigTPZQfWB1hkVznRQFPBj4w/TP1JFS7F9V3cIPyI7x78wBfIXrOLYJRHfCz?=
 =?us-ascii?Q?7tnZiqP9uMcY3dE23z9mrCH299ZfCqjshlXr/ZM/yoJScU8oyrs42YcMckl4?=
 =?us-ascii?Q?a3P9da3ziFRMaK282bBR9PMog2dzlnJjQZJ63iRWw245X7ehBG+L2FRFkX6H?=
 =?us-ascii?Q?L0oexIweUIKkEEnkqcxz3ic/tXwxqIPGLTQqApeHSiNqE8dS/iKEHRudbyCQ?=
 =?us-ascii?Q?Gf2mofn4/GJm+FXkGa/BeOV9FsjPOXwOubPN4J8i4hbWxVVxJRAOdL0hEMUZ?=
 =?us-ascii?Q?Wkz2H6BKJsnI1Z2UYI0URyxX/q26Zpf9JNWj0H15u4HmvrShy4ZYMwFT4/E8?=
 =?us-ascii?Q?E+YZNQcsXKcVptHWW+6RwFYJWwC0AeHjLDIj9rll36NdT3I9qSlmjI3oAtQ4?=
 =?us-ascii?Q?74GfNdlhC2VQBBZckqEoPgtRlI/zOlSH4uWW5kEiV/PYJzvzh8U08B8g6mkb?=
 =?us-ascii?Q?/UODOcCkHDZt8xHR4VIdXs3b3DBKYIfIxtwJsw60BXhKSN3iMURin/uJajU6?=
 =?us-ascii?Q?U1/i0QRhm5LM5hgVY/5cjzi8hFp2u/chhNY+5fUj1VKJxaHaL4suTPQaUKyo?=
 =?us-ascii?Q?C4Vtxjafb4RIMTUoRbAS8GNZ8jLlga3cMtTT9Qss2+ZB+2RCejkgJqmfkHJ2?=
 =?us-ascii?Q?jVYL9u6Sawy99/eEHnomWJUYF/EgtZSoIyNUYks9TncvC/OM4UgAOGLG1+4U?=
 =?us-ascii?Q?sXAFjJWBP5EkGfxSZFt0LkCk7bMeRp7Pq8R4mSCfxzZC2YWdHfQeR2cVlihA?=
 =?us-ascii?Q?LaySaqUY/JPmh11BIoTQoaBZ77hixeaBtGAzX1BBKNu2NzUtOaGwSH6rNTt5?=
 =?us-ascii?Q?qdZP4L+kZUNPwr8NssoAvs/bFQThkf4GhQ+7t0LB9mHd9/iUj4uOAIK/pSyS?=
 =?us-ascii?Q?UvJibpw3JB91108KRqXi/Gu7fl/pe4Ue4Elkg3dfzfy+Jjd7OE1wpfySxbsK?=
 =?us-ascii?Q?nerJEyvkYFGzJ7SiofuTX4nR2asFbgvqFzHcMNXB1mEiLekRNkln2Pb9Z7Xv?=
 =?us-ascii?Q?ij0WsinQvscHq05J+cJTVFV+CQqjQanfPN6o7mumr25NzE1HB2RgiOt9av67?=
 =?us-ascii?Q?x93oJkhCK5mdio3Za5AKfS+w/uMP58yMZZb8gCsu0MjiR4DAZUv0U9UGdHUY?=
 =?us-ascii?Q?6DK0T2OHNChBjkQ8td5lJ8Vfqf3KIKqhyZOdV5jiHjgxs3j/W9P1hzS0gUgr?=
 =?us-ascii?Q?m1SpdpglPy+SFgt5k4uZjzfkwZnG9o5TuBZIdR+Gd9RlFfAKSpM5Ip8sUgAd?=
 =?us-ascii?Q?D5A3lpoAi+gpCx89A5knsUJe6hcQzflvUO7y+0JuisfkAp3yEoAkfZrhl3tK?=
 =?us-ascii?Q?uTRslOOaWUxMjQWn0wmqkKDA1gCk+wTM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB7726.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ELEbqYgKSMzptcxyGg1ayR9LqDL1VeE2cSCtTbkD1l2HRkczIgd+2ru9fu38?=
 =?us-ascii?Q?z2OAajbiH3WCMCBXC59px1GFPOTkv+MxOcgzmjvYqGAb1Nx2tIny4rvKrGSF?=
 =?us-ascii?Q?FXx2wK6XQLx6Adpn8T4FNsGXaAFf4WxB2pTcVFPyHXp5VPtwPqoIzfV+z2Zn?=
 =?us-ascii?Q?KC0+ErXfYORNZzxrNJ3y1eQjewt5+w6bHeCNI0i2BdIoMOR2q4K4lEWIWAR2?=
 =?us-ascii?Q?n73/AKgOM5iwAxihqYlaROz7rNv3SYqbKBRR0p6LxRkZYhRiQLJlZUGLe+HY?=
 =?us-ascii?Q?cdp/WKJbnBDZSpC0QvaPB7nSWNnw8amI1rsEjEoE8hd7IZBuN7Eau2G020pi?=
 =?us-ascii?Q?ZXvPZ3cZOOnvFVZgXM3jwxi60UI8ThzWjR3bY1Mz2vPGPEKeSUNM8V6daMX7?=
 =?us-ascii?Q?AWgTCFn2kLBWytJA72s84citCg2VEtfZQMyD92zhzeEhVJM930woqRIqKV/c?=
 =?us-ascii?Q?k+yqJtLb4vDDT8E3dtRF2hmAesT9Prgd3kMX9dgL4d3XndAWYc71mHCfEFnZ?=
 =?us-ascii?Q?dXMFvhXkcQbUpVzrmGPPBoaYfM0suXOjg2qTkTIW2LmcGRC2Ddpho/C+Sjph?=
 =?us-ascii?Q?KGLI+K1XR0vX69h7vbgIoHxXtf4fQxyge6DMdmJ9fvUUnUkBxUbEQCgyLNWs?=
 =?us-ascii?Q?ciXAnDZ/2Ko4+yncv3EUiXQ2w3T6EmxKv7+gIU5hp/shFkfi64rjJzIURCPt?=
 =?us-ascii?Q?kviRlJKW9Pa091yKUGFrLg0gz0o3yhTVeiKIjudoFnvmjyqCjOSfxLCKX+dg?=
 =?us-ascii?Q?ZC8damDXH0PLb0gCCkLsxBkkET4Sbg7GmFimT1LrEQ244yglfWvIHpIPH6H6?=
 =?us-ascii?Q?lay4x7LoMlbHhwyhP+8MwfQQl5lHlFzXZu26UeX3zY8BlY/NmK2wegP7A/L2?=
 =?us-ascii?Q?QA6L79RKr9xVt1+ltnEVEZ7WUc8uwX+TGmAyEXV7BGkLfzu/LxOq02WaL8bP?=
 =?us-ascii?Q?JsQuM/CnU9xJgRd155i517gPuyH348+8z7meBN5s2r5NuXrIKsyg0DVEhK5E?=
 =?us-ascii?Q?7VpXR+p8WnRqHBnyhR9tV/3k1xkBj84wcQWGpYO3cgQtk0BmRvh2Y4rUKFHo?=
 =?us-ascii?Q?wRcdVB1oYZfkHpQZHZDIUfjCvuBGjPO2P6VvHN/JyTTsFCjEqKTvqVWjBFPC?=
 =?us-ascii?Q?eErZf3VdVw1xqSnc2RaGdotxSCMVsPB0hsrlmdcJGSKM62Khn1U9o79HBVqP?=
 =?us-ascii?Q?CIU9Cb2sBbEhGMdUE/6K5h8grJTgol/jOX1DIKc8OBXWgJYNRRmdfWjztV7r?=
 =?us-ascii?Q?THYf23594uzCRDV4a9736lQwpdL3/MleozBk4RvuA0eJ0650eyXNe9Q7M7rl?=
 =?us-ascii?Q?zstzHm/6oEQksqMsK2pQZYlDsN5fXHkvWbBgYvSciqfd9Rp0bh0Nd/GhLaUq?=
 =?us-ascii?Q?k+iFGiUdZ3xcJOQgJTavKtFYtlbMWwH0YoHxw0EErJQWKS9elydImw68ARkd?=
 =?us-ascii?Q?huzqoO8rN3ed7VmqrL6Gq1km4BzRJaMNNUHxgd69iI/V0cpv5FE1+hd4mTyE?=
 =?us-ascii?Q?1hIWoX35ODlC2LZG/siVwdihm4JMIkEa4UrSxzPeuuxCMpJpftp2otM/3Q/F?=
 =?us-ascii?Q?H70etAJCzEyeSN3U79yCCi/qALMEDMT8bWb8lYIvNbPM3WNflYBnop1+znvB?=
 =?us-ascii?Q?yFefcTn0sTP7NxZcY32A8EzJU6xeAJ4JxpRYxFj3OypyOdHYDW3Tvulu6my4?=
 =?us-ascii?Q?TPaqymOd3T7Wvr1Q1OwheC+oQshkEwa6h8PKd368XlLRsAf45NcaFRHp8dU0?=
 =?us-ascii?Q?r0He/VfIyQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b680591-7dbd-444c-c000-08de41cf1b31
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB7726.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 02:58:10.6151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LphfBy6C9/vzDBtWP1Xm93r1xNB0ddMReNRmtTV26nf7vjW7PJEwsY3Xn7hFzGOD64LVlZ4Mf4FK+awnO3D2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6413
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1F2D40002
X-Stat-Signature: twsqmq3tx8sspsqjwaj9muzokbecyjuc
X-Rspam-User: 
X-HE-Tag: 1766458693-893873
X-HE-Meta: U2FsdGVkX18OM2YOaAf01mVAEnB3yekl/jbtk5RG1HelS/M0o7c7Px0Lmn3R2dynZC+KxT3wYMnzJiubDFNJAN+pKX3ZZ/162Knwq0XPwdUt2odj9Vo9TyI53iLthPQTI7o93mm7Lm1/6P0+ZD/k6760kb1TeuCpwPN9TDdroEBk/fi2AFZpR1X5pOczPKPZLOxqscdBt592VcPwd2nYWTMB7HkvZuCPP0JK9x6tOgSOR0P5REVjFju3sse4vhWm0J/rJVk/5dqep26W+u7DekVLLH1mogiOtDyAR5aPtcgRSA34mJBb17lZkVhC3IYuW5ykI1rQ5uqHfodXcQGfGqb7T2UprLC7wGAJ7+qQwcGpJECRLdzk6ASdw9QkyZcAJ/skUIbGbvsdNKYs/Yek/SqmozIuOXXT9hZq1zCPVv4pN6fTnAa4dUlw8l+JooctM4NOh1rHAJRw79D9Ty3SsUO/1hvEFU/VvUTrYYbkqrwqZceeE60c+Q3bTPT9Zv4DlW87PI5nvv6RLET9PjAFItZyh3ZO/wi79fEqxIdWDREuyjNJaUnhMFCi0AmWmbFNyEL1aIV1xsc6WFjjROOWCSL874sp+WT4F+6FlFS6TA1wIKvnJvuwwSYGdqUBiWh/11hzBHm7Idj7Iekbqho7bepAZR6cO/PSdupuhedWZhejb4Jq9sehsDClX6YjhWmvlTKFQE1n6L4D1Gioyhd8/KgXqZFaj++mm0rpUTEo1QBZt79Nssd3iarqViK4q8iHliKopyIBgw5wMdVnuYYij3gVA9WMuN+2PnqU2QHYAscHAvYb41DgSGaeGV8+Q5By5r3zgXDJdyD2Pk+6GYrSHT302YqeBOASHzo3olPsv65Yq7+dTexKHUH58K2EsbSvYzS0AkOvMuoEWGQ/FGt1erWqujqCrPhb0RsdHIkqUyGqADdlF6otiIPlZZfjWzSIaaNRdjQ4NdY3nLAQ7ca
 48ZRTfOv
 oCqR4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-20 at 01:27 +1100, "David Hildenbrand (Red Hat)" <david@kernel.org> wrote...
> On 12/19/25 12:46, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > This helper is no longer used after commit fd2825b0760a ("mm/gup: remove
> > pXX_devmap usage from get_user_pages()").

Thanks for catching, we no longer have to treat the dev pagemap pages specially
so it makes sense this isn't needed.

Reviewed-by: Alistair Popple <apopple@nvidia.com>

> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   mm/gup.c | 11 -----------
> >   1 file changed, 11 deletions(-)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 95d948c8e86c..8e7dc2c6ee73 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2806,17 +2806,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
> >   	return !reject_file_backed || shmem_mapping(mapping);
> >   }
> > -static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,
> > -		unsigned int flags, struct page **pages)
> > -{
> > -	while ((*nr) - nr_start) {
> > -		struct folio *folio = page_folio(pages[--(*nr)]);
> > -
> > -		folio_clear_referenced(folio);
> > -		gup_put_folio(folio, 1, flags);
> > -	}
> > -}
> > -
> 
> Thanks!
> 
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> 
> -- 
> Cheers
> 
> David

