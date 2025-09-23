Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FE49CAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 20:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742158E0008; Tue, 23 Sep 2025 16:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1E08E0001; Tue, 23 Sep 2025 16:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56B308E0008; Tue, 23 Sep 2025 16:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1038E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 16:27:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC03A1DFABD
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 20:27:22 +0000 (UTC)
X-FDA: 83921649924.29.9E1A9CA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 370091A000C
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 20:27:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Z4rjjRgy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JIg6Mqaj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758659239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OvczqdQaRQNRIdX5SXOImtBYoFEA7ASvBXeESGjCVP0=;
	b=ccEkqwOObDI6ldO791/V4PIWVFk2HdNmQ5st/gQAqwkHiUG0HcrxEwE28/Vb1PGNy4rwzi
	bjQUN8e6dC6fyGD7aP8ovgtR5OYqWuKJnL36m8DmrrAquE9P/Kg/vKMblHG+JDLzUOK510
	2v0Msy0mc9Jpv8zNHxFEXirQJdNTjtM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758659239; a=rsa-sha256;
	cv=pass;
	b=eP3AFyLGZ5G/+oBrf7FkWWUdyyfRzP4Q5Xi1yO9VjCNv8SKoxRrwOZkZuXP32phoJPOGZy
	dMj+Od8D8RPumdSJClsi7FhmsWNdBfq9rJi0EsTwZ5rAYijs0nEWMg/wNvli2w38pWn26X
	++hw1D4oorVQAmjxH4rz2MQl7kDGPc8=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Z4rjjRgy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=JIg6Mqaj;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58NJtl9i013023;
	Tue, 23 Sep 2025 20:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=OvczqdQaRQNRIdX5SX
	OImtBYoFEA7ASvBXeESGjCVP0=; b=Z4rjjRgyWlK4kqlUaeufR6Gc2mzDAlCW/B
	q0ogkA9xyB6/+m+7hImuIYXEijcSgItATV3VEhtYIL7UjNVc5gJMmkaDxCZPJ00c
	fVSG+BUuF9EWh2IuDWhIKYZo9Ceo4fu5GegAzkxOtR1hbyp4/P0kWw+MHHCxqhlf
	vkWv25IHrmnOALZtRJ7sr4yJOYN+5uLqFeb6vk4JF53v66iDpdJxAU7UnN6Jh25q
	Tbo6Jh/ini8lQ4lBXG7eRQIN3AHWAO3iIoym0+/mDa/MsO9FIkcEn6G0NxhfDSMo
	7jMS2MuGaXK/2Wg4IIwF7AMo5CQp0HSP/yP+RRke7W7Wbi6IxyRg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499k6awfta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 20:26:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58NJYBgY014210;
	Tue, 23 Sep 2025 20:26:49 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011017.outbound.protection.outlook.com [40.107.208.17])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jq8rg1f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Sep 2025 20:26:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pN+oNwz6WAyZ5KTr+hLR5o8AXQlEgX9yHO5w8/iAimUvS+XO1lf6+HXwAQKfSIlR+oRz3ImuXnI5/O/2rI24oAu5fORgfz5X7bP5IyX8/cgwMOQtMTr+S30VcirEWftUOJDp/LiF8iayAboCwVbtXqZgdg+r5CGLTYUZHomzBf9TG9D2LFcd9i7o5ImZ3GdBQQlSbbue+tfyCL7czt4rTzUAoRFh+qvwov8Ex+iqSZJXb/0TLf8keVpY4jMgvNPw7EpNpUren0qKfAeBMhesUaXSfgTZVQ1cjA4MoPBVX4ohDcqtksd2UYodNOLGbXINYnHojQdKPskQKQoS/0IimA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OvczqdQaRQNRIdX5SXOImtBYoFEA7ASvBXeESGjCVP0=;
 b=qWdHSg3k6D6Od8V3yckdovq9U9kijymRuKzU6XteszrETimVA34o+ZJAbgYRvtM/uyMbvRUvrUcqW2Uddd3e3fVqHBG+mb2BVq9qaWyMhlzBSBqBtTnKg3h1E2Qtoc4RnHiuXe8/TdOzVbZboMVmOuG3LXvqlj/dfbtFiO39xORM/LUzIyd13PqALISzuCOm0sgSaXWrb95rveZG4O3akT4ew0H014pZa2Z+wXJMuo5KFb7HNc4Wj0o0WxryhqNR45K1XgPgQlLFMCUDL4TLMKaXlo+VkhT4hrIKEYFoouqSYTskgcHIQ1wHRf5iU6LZH3xxpe+gOzwGDYq/LwU0nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OvczqdQaRQNRIdX5SXOImtBYoFEA7ASvBXeESGjCVP0=;
 b=JIg6MqajFdo1fWntQ9uvA8i7Y3BKif2DgOffAIgqfVbIgeN8adq2L4xHbfCXiCBraS2cvDVzO1QEpoQRkQB3akwaHG21q1phwOroAtmzEAirlVpuh1zcPDghAkudBpUXc20CzBaZwbFeEJorSnsLoyEHFdz3WSgUbbpOXGxsrgc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS0PR10MB6054.namprd10.prod.outlook.com (2603:10b6:8:cd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9; Tue, 23 Sep 2025 20:26:46 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9137.017; Tue, 23 Sep 2025
 20:26:46 +0000
References: <20250917152418.4077386-1-ankur.a.arora@oracle.com>
 <20250917152418.4077386-11-ankur.a.arora@oracle.com>
 <5ec85b0b-9848-4cee-98f4-37953d504773@redhat.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, acme@kernel.org, namhyung@kernel.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: Re: [PATCH v7 10/16] mm: define clear_pages(), clear_user_pages()
In-reply-to: <5ec85b0b-9848-4cee-98f4-37953d504773@redhat.com>
Date: Tue, 23 Sep 2025 13:26:44 -0700
Message-ID: <87y0q4ewzf.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::14) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS0PR10MB6054:EE_
X-MS-Office365-Filtering-Correlation-Id: 90e1f390-05d2-475f-6b1b-08ddfadf845f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?COGZizPX7Wmg2uUsUAR32j5kH4tBnumjaLolsaUAJe6P3H9HtUJ1VoVCeDNi?=
 =?us-ascii?Q?pwNAF1SxAWxJbCL7NiAMFoosUY8wzHmC5EvC6jhBw3UhTGWM4Scct45eRLPt?=
 =?us-ascii?Q?q7GAgrDBzb7Nw16AlpNdFhYiDuLmATpujMIQ4EJjlMGcMHoxtXNoUjMEtnKl?=
 =?us-ascii?Q?8/5Oozwh4/w13ijrdkpxfPDycMtApn0ZVV+5fV0bc46+tUmVztfOP3EtyK7y?=
 =?us-ascii?Q?XOsWgqwtGpcKAjgmhCISNh+LSkE4DfvysNVSKzCGZBUnpjFUS56+jR9t1fz+?=
 =?us-ascii?Q?KyaQun74JCnND9HAib+AodqPhIrexty4SXEVe3LhXjZ189iNPV4v/FZCUUr3?=
 =?us-ascii?Q?ESVjMxCcfYxpJeGwNxDW5YEEgM7uOXImF+ZjGr3srZhleTg68QNZBeX/s23Q?=
 =?us-ascii?Q?vaBegsoioVe6gvUOtAIjEE9rNpuGFAq7trMMrdKo5Iw0RwnL7UmCNGI8HYs9?=
 =?us-ascii?Q?KIJ6lOuFPCEgahje69VC8KtfJs8TItCEmWImvFYR2iIUnyxDA2oGyX+JFU64?=
 =?us-ascii?Q?0vXpUSEcRp+d3p+SlMPAAhJ27e2mWooNBiYM/KDkSe+PARVbyJl43Vl5TXvP?=
 =?us-ascii?Q?1g8Tkigi5q0Jtey56w0Hieks9pE+bwbJ7yC/lczghGYUhIWpm4BqrWkyuFJv?=
 =?us-ascii?Q?WvPWcIba6UvktBbMwK6DlaWa4XwnEjRRaWsMAk+fmX2HMYv0fAUAD1q9G+a5?=
 =?us-ascii?Q?fqxm999yU63YZ3DBQNusJCa5aTcBRE57R/DwDIGHWRB0Or3VRvd1Zxhb+u+O?=
 =?us-ascii?Q?MWxh7qcVFKqKSaKBt52t22dWjw7K2KqGtjVFhQfg0e/nvX2kAL4b8bpoJGeO?=
 =?us-ascii?Q?nad9EdH7R7mNEEN6/CzkjrTLJMRYXmmoVcxSB3CGVDkIJEhBY7At6u9Zj696?=
 =?us-ascii?Q?DXA+0djsF4NgBMNhe7TcDgWkX+rN4nUzv4LHdHZ5M92pNhOIIAetNrtKJo0+?=
 =?us-ascii?Q?/3xcjEv0cSrt8OR6h5CduI8iseJtA7LY/TLV+BMgKtnv8WCjDt+FvHQWHuNX?=
 =?us-ascii?Q?m8mYR5bbkeNHIuWRPgEeFFrMD6Abz4Gl6hl+keANK6VeHIEQVa91UVHllTh0?=
 =?us-ascii?Q?dLliIvyo7PM57N+9Pc2FwuTxzwoSRfGoGYn2C02FgU3Znd/w92Wfde/Ic0iY?=
 =?us-ascii?Q?hkfRtM0R/aqndBynBeyhEwTgtZB6xvdL8extyFAscaDniLUjTdXJ2rSShDJI?=
 =?us-ascii?Q?vhVh0zT2aLF3Nq88h0YGuHOVvYjYDgrEjZXRNvJAvr3wFZteCQzpjqYzVVHU?=
 =?us-ascii?Q?1IioxT3uHmPS1v7lmFMNg1+FWJF++DCqocH3pnrXwsP9hGGVAN8zRdTrEPYQ?=
 =?us-ascii?Q?rLj4f14DpHTjHSTJZEbmM6QlRdpz5Zqvj1pwWs5AEOiloG1t6pWmeRAoKPKm?=
 =?us-ascii?Q?IhGg2cbzAK2hFvWcuX+ZFx9QLA5V+hHcPeWTyOnnTUmAYN2HYT7Cp7QXHtW3?=
 =?us-ascii?Q?VgvU48JBt/0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fTBhrNeT6qUZhLGQ4Sq030xVazV3nZ6LH3RJlXXIWctZB6NkHRO0JhFP5LCA?=
 =?us-ascii?Q?lmYX1J9ROkGDMr+xIH5KQ+kj5KThjdXO1+bxyJma0tpUofKGKtNImKggmP1M?=
 =?us-ascii?Q?youK5Vfwfh6wY1JWnmhC75Ge2e8zDKU55TtasaoGHm1DWMJtPwv+0uHeNZp2?=
 =?us-ascii?Q?6DD4AmxvK5wvJW0AL6TCymRYuCemisobp4UqiQUh9vV0JUYVd0EwMqUtKRgU?=
 =?us-ascii?Q?nasCwz7pA4ARKZHk5+zJ3qgpp1tTGCGc9GtNfjvnf7tW6Fg0nIQuiw1Bnr8W?=
 =?us-ascii?Q?yHlTLxZjDSGeK6UZvMXgq4izbLEYiEBdh/aLUZbvKCs3qEmKmoxTyJ7nvQIU?=
 =?us-ascii?Q?XgpmaSASwMs8Ic3bfsLa4GEwgA5Fu8/HPJBnFxi5Yb7MNlOGL/JrzOrMga8y?=
 =?us-ascii?Q?bOjv04yP7tM/GFfdgqvPk3n/jCk2vcZYY5qfYTpCn3oNYtJ3RhF2a9ENj0x4?=
 =?us-ascii?Q?oxYQMmBa7Wgq6TdWkUI1Wkv1mknYFb7wXkiJfhNx6NzbGqz/6bKv1eHjkZ/p?=
 =?us-ascii?Q?J2A3cBbE0irBWdoiXepTFxoCR6tjk372q94Jtw6AOGManERUOsbLi/bob1Or?=
 =?us-ascii?Q?OXLyGjCauIcno0mG0yT7nQgxfSFClYqns9lPXBylx4pCFro54W79O+pAmKjR?=
 =?us-ascii?Q?KGL2yNpNdw60u8y3v/Aw7xqDhSJjykeYVxtdipROx+AHfwK0z+Bh4ALipgW5?=
 =?us-ascii?Q?0zecBsG9zo+q1xvGouyz1/ZxcrWF0koDqd7m9ncVG5BdNT1jQUsnXy2rCKpk?=
 =?us-ascii?Q?KF6BGqb4PuR5sLrebiBn1uc10UixZBk9PKU3K85zJqpY72btbQZr4NDL+872?=
 =?us-ascii?Q?18XOO/PdpCb0AUQTt1hZeltMPTgIkyVq1Jm1BjHP/pCVXSGhR8NZGfIf+hGG?=
 =?us-ascii?Q?GtMQal+Lv46R6xvwxRHX+AK4wB0TpL/w2OEx8jAVA20edzuDNsAwx8UnyDDa?=
 =?us-ascii?Q?HZpu3v5sdb0eLyTl2ir19FJ2nuJ28iNHd+EGSMUVDFxRQdu+GD2B2ohH6TSD?=
 =?us-ascii?Q?CaFpOwnlQFGHijVnWVjZtTVCEEMez0SHHqKQV5Y2rQQLj0s2twLLW3kd4Nm9?=
 =?us-ascii?Q?CYNka/vLD8+Nef58e3bgrLgpLMknHNZDVbAB98Ky0QdETyrhYiJdjCEq3Xqr?=
 =?us-ascii?Q?XzW7Tp/aUy5/VrQP3azWrK7oe8S2kuxYfwzk86sRvpMkAj7kCyMFjnuwwf1L?=
 =?us-ascii?Q?GSyPg/nAVVOb+RgAbEty5caVuRQ2v5bfbvkXtwv68jVQy1arWgmbtV27q0ZZ?=
 =?us-ascii?Q?iA9Y36fbEP6qCCK8OeYxGG0hs1Ll60HL59TO7ohYuFq1ttIJJAQ39rQR4bu4?=
 =?us-ascii?Q?YiR9yeMjCnStfKwbuLhcgQCvCprFb4nGkZQBaGRzFtUgEvF8Wa/MKHxdcHou?=
 =?us-ascii?Q?1lpZMdyRqawIlPLL9ldTaQA1uMsZH4xV54UASkSLuQi2Ag9ysYYoe+DhvRx/?=
 =?us-ascii?Q?42Q8gWyWN0Me4lNeEr0EEHwIaU+x7Wlgo/MnNJVqXi/7rPN75KrMx21ougUG?=
 =?us-ascii?Q?QtTG4+2qCCuB5j6J/wIVFjxDJHJaIPqfm1uZEiCAQB9bf1kgDs1kWUNWfteg?=
 =?us-ascii?Q?NJryz/FYhcWhtSv37h8xLUIVRWm+pvhQmDpjJ3mhHm/pQGPcdSsjeZBHPhfk?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e0ghIjTy/3xp3b0qByvoA+7sRgr2g73DGDvo5tzND33N3cL+caO04YxDYBHvLlN4ZAtHsj8DOT5DTF7EyR3EzCBmL5YNGZnBqWIzXS33QbtOrRs3kqysNtJYH/GQuQej/sU7NYiNiG45aKM0veMqTIqzc+3UALkHeiHaXu6So7SN0A6IsaX0aEzL9GHyVfqlj8RnKD1oiP8FPu5mEPvdzSiFi4CRj0BOHpSqzsQFzrIMjFHf/vEvnHLNaWhX25cU9kZp6L+J+d1PaOXbOkHNbYIXTRaQQHgwIKv8XI/pQxXxVrSPMkBYKOUF5ZRaSUIQ/pctoGr+dcJG8iFlkFNAmwsFJsJnJatt282AY12LyhXkj1N3YM8MdFWSd/piR041gc8NghCN0ht4qAI7gdpVs2xgxl9Q9FaNP0p79oI1aNav37LEoFzOdyMlxOpzPQPQ6RMo64V0rsPWYPxwJjTvtjvEa/H6AHmI9NmfehLP1ywoXx7Z4LX/XwsJAqhWGYmO/n6ZM7HtblrivUh9pco/PLgyMv4nNUXDABNYHJ1NKMjGbI8Li7YmxtP8PXeWDbcdE8/FM2cm9EsFm2JDb06Qy+eVGURlK6pbDW1ZQv3I5CA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90e1f390-05d2-475f-6b1b-08ddfadf845f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 20:26:46.4222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obSbsBgrTMopYCAdW2L3KXNqcsqB5+l9LL6ft6jh8ELFTgoNHTG3f34bf7FH+jf8I4ntwCRsDQl77BQGBlADPC2GKBtfqXkfda1kYdzRtRU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6054
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-23_05,2025-09-22_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509230185
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNyBTYWx0ZWRfX4DyH7RYv8uYp
 pwCIYkAqnEzUngTwCWObpNE9ZN9ZpUlEzWbSQeNUv/XdsnoDMI/hsboJDDIdsesbpNxGzUqKsKo
 tMZta+lvIkTmag0gWHLpLXBUMRZiC1fuhG0iGD4UjXaORwnO0yMmkOpj3y+5F7q5fhIRJa/M4yF
 SG94QGcQflR4Fx1S5AzemV95Od/0pN5/DQqmvmeKoTZgA0iUaAcn6RGDWYYkhA+j7ufr4GKytnV
 qDTQQnpLW/OxLoVNrsgKTVk3iMB8k1WpKACafpfMygmPHUp6fjpDSRdj817xz9WxJNunHsuN496
 XDmnsi2K46+eyIdX1SUX/qSqaOkrqQtB65nWkUKwr2tE2XnNA+uEVxF41UAT8E2csI69JcjCQHi
 Tm+HkNO2jLNPkfN/vHA2ZU7I4tj0mQ==
X-Proofpoint-GUID: IsfI-_eIO9U5nVo1XNetcDwmLV863fYb
X-Authority-Analysis: v=2.4 cv=E47Npbdl c=1 sm=1 tr=0 ts=68d3028b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8
 a=yPCof4ZbAAAA:8 a=GnxG2MVDPjwrmWg7Ru4A:9 cc=ntf awl=host:12085
X-Proofpoint-ORIG-GUID: IsfI-_eIO9U5nVo1XNetcDwmLV863fYb
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 370091A000C
X-Stat-Signature: mtcdk4ou6b66ubq5ci394zn3u938dq87
X-Rspam-User: 
X-HE-Tag: 1758659239-458779
X-HE-Meta: U2FsdGVkX1/fmSk4aasFRT4ftLVWbo6rD3nLegL2JCjC46EXyTlI1o7wRoN7aonnmHA01K6xuU39OyCbp6U/DXtdelNal981OPkrsRC7v4YKbjyXDZ9rn1q5iR+45QDeXtK1w2ZUhfrm86tbcEnoO465VcNfbNX+5NOD6QD2HOlthdF3i/ZbEmBBabaVKV43rYTRhTlmjzZnk7lURz6I4EWOs11FrHAAiZTz7r51SCKHDmSLpMsc5ioWRltbhfPhgjlLMmG0JvFS+1rapfMFgTupfluNqaujigK6VFHi8nxvXb3+9+poGKmwMu8STmgIPcybM6Grp4FSxJr6hwqyqfI1pcUg/Mv4s2LcEbZQpDc+ZigXRaJA/EB5Fv4EDK+OwZ9BabsVggBaUMnO9lsybNBgyMd54w9pjFk21tK024sz/WMQ75yGUKwxVmCelX80VaWckKHmGAIVLMzEfe9uO6TXxZPf8aVQoSFZneZ1xqjiI8s4s2mFrz5jlkwygLfTtOl18Wjej9I1DtiobyxD9FEehLkt1qvsjEXROclQCzTY52AGcXUSPThtNYKcOaM9jQD7prtW0OvexJ6bBSVa/cdaHOOgREqhUTPKs/cdSsIBmC+Bjgf8T+Bn+Bs2GQv4AC4excsuDoy3jVQeJfKQDLBt9q1iKUgCBzyCAzsGF0JiD3KFA5qvq9tf50nGl3E+0Tb7BhB30bIFU56XQxKioLWxBIeVr7usR7J6N55yPjYqMCcjt9Z1SYF/TuA1eFc2Gm0URRL79ASIx8ZPe81jzyA6viMEp6OD6f+cgmJH+G3UVhwzBN1YLqtyUUk0wwX72t4sGj0icbcf8MMnTceotktXexFAF9ELLwlqKxobpLY7AC90gkN0d7nApHvNYX2dwx4i/9vyJgo3B/SIokPQGe8O9v+q0RhN/GthFgwpG7q/1dc19fpBl7T7ARHBVpjIgVaT2OcRyyumW2s5FNk
 vwKsrCPP
 ouvdh3jwlZGf2AffRuN+98UT6fNXtRyZReC+19HsjcWvOmnPeaweUvFHUp+s5fIpfvhocOZ+rXRbZtYhCVydfTrKe49IuZHfHWLpjkhD+4ZLo8gig3J3K8LqEkJYshtE9QBp+B6YfEE+cCjrtCGCgZ7VEUlwrJBqmllDZBLWTpYZ6h/3KEjFtG6WrnlWUMBpyT3iMB4BW7I4SIShJ/ZMKdhXUTm0bSYscNOGl9EOpKsPe7wRMl+2gffkMZnVmuLRxiLbdRKTM87BU/AosboQMo9o02qFNIJg7TMjZuV6wimbOC0mWqfewKka4/3qLtvCewOFvU55S7Mm7cTfTzKJFjSvHIUGy19WHMxWXbPzPFFFyMi/nPIgdPA2hTWQG3iYnJ7l1BOBsBVz6D8lig6NMjoze33DaLdMxdR+gL27anAp2TlaaZ0tEperCg1iSQgSn/w+z9vHZWmRdTjdEyaTj/wjixmy2FVoqPiQOcgzwdFsKpDqLgAOgVppCJZ6r04dJCL3/OEBNh0v+UALxdlVuS3DkvJEv00o8iSya/AaTCT0OJFS+wuZFgAf/eqF9WG85T4QYYLoKS1rTM6RS5aIIRc/96I355zRwuzr4Hm2kiR2sB8t8igl4+II5Am7K0XfJykB7U+rVwTbD7wN7nxVZG3n3uVmgZYdMOKYyS2elomq/SjUiQ+prKNBakLjp5MDYO56gci6YccPWW4gnC3LnQjMb9G7QFor/tCbT7WssUro/e/Ol4jaUyaEzNt0QhJJGraDTTW+90vXB25HR8uPrrScfwZ+lcSQfTSa65y4x4xdJb1GwYk9gvmCSXdbkNsNMfnNdDLSu+2kRbZyUWm/6l9MSKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand <david@redhat.com> writes:

> On 17.09.25 17:24, Ankur Arora wrote:
>> Define fallback versions of clear_pages(), clear_user_pages().
>> In absence of architectural primitives, we just clear pages
>> sequentially.
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>   include/linux/mm.h | 38 ++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 38 insertions(+)
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 1ae97a0b8ec7..0cde9b01da5e 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3768,6 +3768,44 @@ static inline void clear_page_guard(struct zone *zone, struct page *page,
>>   				unsigned int order) {}
>>   #endif	/* CONFIG_DEBUG_PAGEALLOC */
>>   +#ifndef clear_pages
>> +/**
>> + * clear_pages() - clear a page range using a kernel virtual address.
>
> I'd just call this "clear a page range for kernel-internal use"
>
>> + * @addr: start address
>> + * @npages: number of pages
>> + *
>> + * Assumes that (@addr, +@npages) references a kernel region.
>
> And say here simply that "Use clear_user_pages() instead for clearing a page
> range to be mapped to user space".

So, comments that actually speak to the use instead of technically
correct but unhelpful generalities :). Thanks, good lesson.

>> + * Does absolutely no exception handling.
>> + */
>> +static inline void clear_pages(void *addr, unsigned int npages)
>> +{
>> +	do {
>> +		clear_page(addr);
>> +		addr += PAGE_SIZE;
>> +	} while (--npages);
>> +}
>> +#endif
>> +
>> +#ifndef clear_user_pages
>> +/**
>> + * clear_user_pages() - clear a page range mapped by the user.
>
> I'd call this then "clear a page range to be mapped to user space"
>
> Because it's usually called before we actually map it and it will properly flush
> the dcache if required.

Makes sense.

>> + * @addr: kernel mapped address
>
> "start address"
>
>> + * @vaddr: user mapped address
>
> "start address of the user mapping" ?
>
>> + * @pg: start page
>
> Please just call it "page". I know, clear_user_page() has this weird page vs. pg
> thingy, but let's do it better here.
>
>> + * @npages: number of pages
>> + *
>> + * Assumes that the region (@addr, +@npages) has been validated
>> + * already so this does no exception handling.
>> + */
>> +#define clear_user_pages(addr, vaddr, pg, npages)	\
>> +do {							\
>> +	clear_user_page(addr, vaddr, pg);		\
>> +	addr += PAGE_SIZE;				\
>> +	vaddr += PAGE_SIZE;				\
>> +	pg++;						\
>> +} while (--npages)
>> +#endif
>
> Should indent with one tab.

Will do. Also acking to the ones above.

> Any reason this is not a static inline function?

Alas yes. Most architecture code defines clear_user_page() as a macro
where, if they need a to flush the dcache or otherwise do something
special, they need access to some external primitive. And this primitive
which might not be visible in contexts that we include this header.

For instance this one on sparc:
  https://lore.kernel.org/lkml/202509030338.DlQJTxIk-lkp@intel.com/

Defining as a macro to get around that. But maybe there's a better
way?

--
ankur

