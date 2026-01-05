Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C75C79F9D
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 15:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 666A96B0150; Mon,  5 Jan 2026 10:05:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E996B0151; Mon,  5 Jan 2026 10:05:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 516E36B0152; Mon,  5 Jan 2026 10:05:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8466B0150
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 10:05:44 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D4C08894FF
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:05:43 +0000 (UTC)
X-FDA: 84298234566.27.FD28ED0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32E1EA0007
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:05:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ALVtBn1X;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CZsWEwUI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767625540; a=rsa-sha256;
	cv=pass;
	b=N6Um/9XLi/5jyx7Xg2ZuQZpXmpRNF4FILR6N6aXJghfdDRNHdDGpRhqpnBLr2pt1GIunex
	hTcxIe12V84K3x6z66vL/BJ+ABsmfLrqnKzCxwXy8syGRk4NWeuQJYAlidhXroxNfpvVDj
	p0fa/bGC/3Ulc2w+YxbrxP4APDxp5SE=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ALVtBn1X;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CZsWEwUI;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767625540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=horW9AyXqtL5mnFuuBYpT/09WI8ZRvv6dNGIdM4/+Yc=;
	b=TKTXOgaGPiS+UAEJIPJIq1hnUBxbgkf+jnpjKLIUsMtW38blVp7mFSLyoVPFfy4G84cdid
	9+Q5Sl+NbvoSvXpf2EkMEkGTpj65OeSpeeJpU3D69ZyWuM9RLZ3GyhP8av91hdjc21vLJH
	iAkmhGRowwjKSv9EZ3BlmfEKdUCmJfI=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 604NtCin180217;
	Mon, 5 Jan 2026 15:05:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=horW9AyXqtL5mnFuuB
	YpT/09WI8ZRvv6dNGIdM4/+Yc=; b=ALVtBn1XPRpjuHaGjfWWy2HRza0lm13Zo/
	F8gKviZWSmpo7COYbuieJTlBnJIsoLmDWG+ZGE0IFTwkfKcgQFcc5Kg+pVS09uQe
	NIvsgGkq6zYqq9nSLpzqfja/6gDAJNPDkU1jPm25fmfyKzfBWAPV//fGlZe+RtLQ
	/f6rGj+NUDqiSM/nmnd7Vc2vRcfZwejZesa1ga2Xs96dMpqWSYoOPQLiUZKjgiDF
	wxsEdvs0j3DELOTluITAGvYxHC61G21DZWMXYX/ckWE5qFl08nEjUfbgFM3npMWy
	4aD3WOe3pOFMd7SeTsirOJElXCbdGTnU2cDHhp+S7L9feJ/athXA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev5qhumq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:05:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605EVBBH034042;
	Mon, 5 Jan 2026 15:05:34 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010042.outbound.protection.outlook.com [40.93.198.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj7fdfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 15:05:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bv3i8HFlEnGQ8cdSWdJi5zfYemntHGhgKfGTmRZwFLWL5Y98TpOKfEwAWmsNAid3spntUleeOqLu8dzvlP5ZX4Tt1r0Z2KiV6bLWCtww2OQpr5kA1dacZlOcaYYS2CW3Zths0F/4FQ/v8Se7iwlwpegwqVj0PFr5MRlN5rg/e/aGVvaL797ol4J6le+7g/tigQjrbwQstnAIshAdd2Nfifjwa07EjXf0De0IXrykQRc2+8ys6rMFdWxBIvK6OnzIAI6AHKOEDZJLKAHekyJTq5I9YzLSQxiyotrI6h6WJesGf6q4gquI6uACWIxSeJ7+qJDPHt/rzB2xR7NKe+wdcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=horW9AyXqtL5mnFuuBYpT/09WI8ZRvv6dNGIdM4/+Yc=;
 b=Ls2rR+FFfyqSOGZYTm7yY1J+PSNNYnJqz3J2+L08y0gXXXpGNXf4lVgOD9KV6Ym0//I1xI6tXZpohNXS4p7CSlIsCZXc/gQFPGzJ3eqzl2QJO1DMHvTM7tsxeYGlgSBiSSIfFrgSdiBBAFSssMg/eSnqH8GMWmhZ/WLm9zUglYWLABQU2JJLnAdCXiVrh9Lw9RY7gH5Vx3y8LokvpLBX6UdqMKREU2WspGmDfpQgD4TeLi96+T3wngPbClCUiu7FLd3pxO/DdB2O4tZcIWWNSoSQwjampZnXg6RiPzGtizYniGX8fACdfcoxF29m0HlsQdPVjxCyYrxnToQUw4nDQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=horW9AyXqtL5mnFuuBYpT/09WI8ZRvv6dNGIdM4/+Yc=;
 b=CZsWEwUINSNlhoHPllL9I2bIXycuVzme+yyfhHn3JNs11q/NLrkpXr4/6yMDUDfpakRdvQ1P7HL8uSh7QrTAdPByopda0O3hTdsV8mtcvtYg8qbRSBUxlr0k2LQ6SdzOofUZTOyCSixgV79Ey1WhL5/qD+lPje1GGa0kj88XuSk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA0PR10MB6770.namprd10.prod.outlook.com (2603:10b6:208:43d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 15:05:31 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 15:05:31 +0000
Date: Mon, 5 Jan 2026 10:05:27 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove unused function inc_node_state()
Message-ID: <52gzlbxpdt4ptkoias3ylxlxgnynna3lyi6tbstaiz5dfa2ike@vubh2z5u6fdl>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org
References: <20251225015445.16727-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251225015445.16727-1-richard.weiyang@gmail.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0407.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:108::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA0PR10MB6770:EE_
X-MS-Office365-Filtering-Correlation-Id: 54d0c746-cf09-42e6-e8bd-08de4c6bde53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7zQe6EQy78WAkv/ph8XXe26ZlioXooINJy3QCGSMVirDZViOcRvxbdMJ015Y?=
 =?us-ascii?Q?RYAmjKZ8dlTK4LwDngw1kNlVgS7Dq99Uk0nh8tyosvvRYl85xKjgUiTgzRPF?=
 =?us-ascii?Q?QMvDjQSXirNCNqwCOkocFYp/EQ2fuJ9Klm9byjuRNei9yV77ue7QlREuwHjA?=
 =?us-ascii?Q?uRqF/3XXz+yNZJNYBCkc6adYWwBRKOhGTK8Q0fG5SNfkBb4fKkWLmFNSw0lq?=
 =?us-ascii?Q?4GtNBVU90xCtPTn8+TcQj6PRN+zWhj/Ml1qQabvQ5eXDj009tkcHFHkHSmfJ?=
 =?us-ascii?Q?UfcFm+qFd3yyvfNusVGUbf6urwW2yEZiZyuRTc4NWnnadTCrbwrnR0s9rZlO?=
 =?us-ascii?Q?ebENv5xxJG7gFN8jpJebCx+2q3aEQE4V6LYGqWxWyEIf8FUfl32FfbO72vrh?=
 =?us-ascii?Q?MTX27hviQ1D9iMxWNsvY13EwfmRFAIuk5oa/oksRrHOkAomQ1PnEfXjY/IZG?=
 =?us-ascii?Q?QvM13t+2E1IwGZ3an/v+vIAx1Ax6uaoDpEUPTT6vFDFH+uFYaEUaKZkFP2Xw?=
 =?us-ascii?Q?hjjYT4PGj+GRrFzvxlDO3V6X2h1bhP9sxdE8mKBJ54TG8v2HL+ytxOppNhzB?=
 =?us-ascii?Q?gMflMO0FrgHFxuxEyLbjUyHlfHZgLhI3keanP3rmLhEaSbtTLORFC7oumRYU?=
 =?us-ascii?Q?ZdRmx/X4PNQqMIyH46OE2vbXAEEGfmfsoshqeonLFbtKt30lw2tMiA2j6z5U?=
 =?us-ascii?Q?I/Y8Vx0d2eugT8pjxeCCe8+/njgP9y0R+6yswA5GOrCWixpYWGG0i4PvU+AI?=
 =?us-ascii?Q?NbyNL8EPALO6O5eZ3GqrHVYpW8bi4vc7WDGaUmLAZO5LhYR8zuTEJUTJZtxd?=
 =?us-ascii?Q?5KunVOERIoNY3bUeZxdMT/rUcI8LSz1eReSZotXU+HmynzSL9OUez43kwpV+?=
 =?us-ascii?Q?B7MKjd4807cR0xfmV2HTTggWMycemoPge9uDZc6yr9RkFAbddyWmu340h1n7?=
 =?us-ascii?Q?yP/OHNhsbQ1l9SOrb4401odDSGNPcGQHxQA4vNyTuU4+b7VWGq6LZpR9B+aC?=
 =?us-ascii?Q?h/EcyDxI/wtzWT0LSF+cJ/5RkXUAie82tWRcJBkzY9I/WJtHReFj6vynaXo8?=
 =?us-ascii?Q?GG0pWa9vjZnugoRYceOI6xyahs6AiRVDLdc+tW3WN3sGjUzKq3W0nVCZ/bZC?=
 =?us-ascii?Q?e4Nkj4R4sA7WhNImuhEM5iw8tTWrT0hsDq0NWPlJlyU+P5yt+LDfzH3d8Zyq?=
 =?us-ascii?Q?6DqZE8blH8jRthkjrJpTMdeTdnwXdAi4hjmlx7iBSZVN9vn0OIRxLU7FNDy5?=
 =?us-ascii?Q?NhhOQo3alC2NM1PkC7cA/0pF87l02r7Mb/i81KPKbrxgB1V7XBsZoj8vhOKc?=
 =?us-ascii?Q?TKGv40wn1h4K1vvXJiQt1rhfMm7RJiLJ0a5Fl4EsBfrlCAfXNDFFVKZeyFp1?=
 =?us-ascii?Q?tmnenv0w1tHuzFPL7oYBSFT2LChBhWas33fVzkjPM49zOa35sXQzwQWMBpqJ?=
 =?us-ascii?Q?zi5IUg33Rxv/D1BKp+h+fQbflCDk/eqn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mwtvUHZNL4QkNLJVeMou+T7a74G6OgAQ5qzJkHRes2Ki/TgiFnHSGZga74MC?=
 =?us-ascii?Q?UBh29OmSJWj7jwk/P7M27xRmxzCI0fkOI5xdR5Ox8n2LRGpQb88Mxs/93BnT?=
 =?us-ascii?Q?95L4+fZekAaMfKDVWOBQEjRwMNWRIixECsDaAieaiD9fDPBJnpIoCLNN+1Nd?=
 =?us-ascii?Q?ubjpupIzk/EEL+85jmQuE8/pDyEvI7fTbCgRm6WiiWcfyqYEF7uSA7s1JKDT?=
 =?us-ascii?Q?KBUt+K+GkqneUzkvfa81Sr0xcU37CIVXUsF7MdNFjFOCmhLVKUuFbFblriST?=
 =?us-ascii?Q?HGbjYeaIsFNXEPr8gVVbgWL0xsMHFGrkK5RAYyIRnbYr3+eVwR9LOIeeQG+k?=
 =?us-ascii?Q?yNhsFl6DUrbTgHLoA6zePQW26/EIQKytP0f6Djap4iR1qZiPcjM4FbfL2B0B?=
 =?us-ascii?Q?3Co6PNt4pq1VGZY4CqSKOR+puAKEnk3Fn6rHRFdTgc27CRkaIamkDMeH5WGq?=
 =?us-ascii?Q?wZpgZo3hdGVy5jkodaXc2lW4QMR12BYQXY8c5XT6b73yrIoflWmVf73WJ8Lv?=
 =?us-ascii?Q?6PinQPWFH/zBy6SeMSiwu0Na5EHk3bv30qNB40FdE72mre1LRBkxPrJseA/D?=
 =?us-ascii?Q?0NwyEtahBe186ToBRXcP4FkI3bTTnhUaGITdBP7VAuPZeXj972irLRVqYxjQ?=
 =?us-ascii?Q?UjoScmFfJA9z/ROR5qatb2wb5YfGYaQbbps3zG3eHOHHLzoN/ju0CTWYmLwO?=
 =?us-ascii?Q?XFucIGSMq0Fo+Xbxu4SLaiaTb+WmV42IU406O4hmMFD/QyxXbGVrjxE1jDmO?=
 =?us-ascii?Q?Au40XE2I2VA4XV89wL0DzYEWiKZ0wPmmsrmhfbjbKcdQZU9+Jq/4OEip5aaA?=
 =?us-ascii?Q?sg0tIWRo2JG0gjQ7FfWXRtv7/pnTYxyKS3Bcim/ZHJjyiVSC3Vxou8qbbfXc?=
 =?us-ascii?Q?jhA3OhMRIaClujC9x4zo/QdD3ZMHLgUHfN+32/vEv07ERZxfpOaxSP1diz7J?=
 =?us-ascii?Q?igHqj8upTQvX/4hC5RW2AVY/0PR1r8LJaHyWIKbGkMVIPeWpvo2f97MnbwnR?=
 =?us-ascii?Q?+yJIDbAFn0esVFg+JIdwK5UXtwynitHYc9A7hCY2p5+CeODkoaWIPQGyfxMW?=
 =?us-ascii?Q?bZyt0ZjAmUKl99YFYogUQlNhS3cU6yis8B/GAD91FiOV7IwaJY1LmcqPjBje?=
 =?us-ascii?Q?/MdMCiAsvSJHRqtzeVybxp7ZuJDVOSiAjshoLxBERV+9U9dRmDCJGNyJ9KbR?=
 =?us-ascii?Q?ZpRAO0payx7YR98APh9Bdv53KXF7hEVWDip6bydL/9QN9P8kZtGrWvYHksy9?=
 =?us-ascii?Q?Leg9ApcVpf8SLXNoAUaa76aYBFYqx1UoTkJENldoAqjWHHi4AKKtdejPs9F+?=
 =?us-ascii?Q?/VculnhpcyETyf26r6L7Qku5kL04OK2Ufl8iNDktYnAwK6+7GNY7/a6T78iU?=
 =?us-ascii?Q?NZ5jLs2bFGrg1DsOoNlO/a4K1NLzHeFhd2GVhMmUrOJHiIPPObACiG4FMsmW?=
 =?us-ascii?Q?RPxBoQ9QSVEIMXMfEUYi3K/eRYERYDUku8NN+e3DfkwCG9clwqqUlqMXxK3z?=
 =?us-ascii?Q?gQ8EdY07xHLKOolNDtVSP95y0AlZQbhi6dyARqjm0TnoP0EawgvujLZnrpUR?=
 =?us-ascii?Q?SAQYbe16Ox8Rb5SC18fnHsoVH3EDRn+9vEpUOKhUe0acsoDEZV2+XI+evq9M?=
 =?us-ascii?Q?1qsUcdm8JPnWamneQiXX9sJ8T/xcX4xF7FZzRIXhh4/8d1GwYlUci63wCLZ3?=
 =?us-ascii?Q?MU48jAOecdelcVJwDA94+SPBWJ9KKnjENnU0vKp7fqJ0FskxHTQoork25COp?=
 =?us-ascii?Q?9paEwaDOJg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	itbFDO772witCmhYGtOmqxa73PY3QY117kw/pPX/xp872+KxlDA2Xze4sRqft2xVHl8qWNqY9F5/3NbNtZnE3cBdy0a0GG3edMANEkYEiXQbd4eXYjBo0aUh5spxuxl/CHnp32Nt38CQmURCVQzjUUYd8XdYT6zGZw4ywYMRxARDUZTqEurzcuBy5titIG8TQPUkP3JpQraheG3HmSX72KgcsIYUEJ9a+SlZjtey7wZBjPCcjFHBPYmadzrJhE7Jpq7Qaa2SILVBPTPA+1uinhoot6rmn1Ws8rtI4VnjvMuoqYVIIjgfn7qMuGaky63pZ9KjGiUvEohgMqdAkLzMDANWO3kBkI/GQSwXGL/K1wMdtqxgjX0dFDMTJVqNqcKdCoTVicvgDSTHky+NoroLD5LuLpUvy8qUJnhdRo4Fmhn6VcQtikbjxmjRRx3DoRkmWPrObizbkCpl+SEQKB0+xNQ36w5d+9mKcCiUyj1dNPVCMNp3D9hTlKRUee9ZxkNHfdV6LeIKt8vGqpi4YQ0KrXuKGlnR/OwkaKdb4oRpceYU4qoHj9hfs9ar0TTgn6AtCJX93elTmgyUSSVCNTQYJxkkqLOFyBO93CBaudO62hc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d0c746-cf09-42e6-e8bd-08de4c6bde53
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 15:05:31.3947
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q9by+h64FhCpjO/tNEeIKIVL434F8D/HT2PWEesyhvpJa49xo3JxeEQlb7Z94cOVusqJZWCvz2GnZwkgnDWrBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6770
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601050131
X-Proofpoint-GUID: 1XEH2sscnOwUEXmBb2gW0BSujMrvkuuv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEzMiBTYWx0ZWRfX/duGPbV9uk+2
 rAJahVspqVrU0EbBirhoM8Ri8xn3BgVqh5q8VkDA06K0BFJ9MtN5U7CqLjoQPW/XB4QY4qaOwNq
 LWerIFWyqDTSa8mD3VjrLRqtRwR4V8SVRDmf63nQmuKodFnMShsjCOhLGevxLiUoMBR0TjSo5F9
 GkOBru9nHDPiTNdcPXsH6WUgh/eVrFSwsihPX0RvID3AEo+NHvkKEArbe+gpQYY3JjDDjKVN23j
 SwDBCtKZh+D72geMmPg13+NGT2zDKNG3p8/D1PbWx6n8ozvsp1aozR8829bqrQmTMPVQydcSpsv
 pNdZHOd8qbXROPRW2w6JFmssgU7StNcFojhj0Asm9pMB4i4tiQzawvdBMdeL+3UgcqBGRsxPDeP
 i2NT/cbjk930LU+86vfGLi7Zt8ib8/h2tvKErwuEpnA848KKvK+E8iVePucnLj80BadM2Sjimrz
 OPVTcP8UhTx1Ax/2Pdw==
X-Proofpoint-ORIG-GUID: 1XEH2sscnOwUEXmBb2gW0BSujMrvkuuv
X-Authority-Analysis: v=2.4 cv=cePfb3DM c=1 sm=1 tr=0 ts=695bd33e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=WzSEFqyevZQOkSw6EKIA:9 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 32E1EA0007
X-Stat-Signature: zcn8sd9farjgjrn9d95i4s5yiarqhosw
X-HE-Tag: 1767625539-673243
X-HE-Meta: U2FsdGVkX1/qogQIjdF2VjMKAXLiciDlXUm7xQLxbJZX9O5SoNeCF/rj3SOhAniCgCcjaJ/oeQ1IlRdgxClq71Soqw9n0gRn39NKtOvFXDSN8RgQILVmPW0mmBojo4/IwI7iE2yvS1t9O5M8jN+SG4nOkPfjAKdRbodtHvQRDULe/m1YM920P1LW/MLWrt2uIrQJ5EXAqOsN+U56X/U1hWAqO+32XfnCE5yZQvaJxsUiipsOR4hi6gIJ6m7/MMt8uvFyuL+abq48StcDM9AKDTsFLKt3C1LFLjcoqX+hvhL+dGZQQBrsX+j48fKG6TVIcD9N5bEy2zVcEEvAQPljTsu/8KF0NBrjiQfCGYvxmTgjqeFpCvuvhGm+SqbGCIZGKd1D4IXIqXv/rif8onSj9ckuO2TazyeDJvu0/HZfadCRwlmhN6uJQuEBLYr5rw7Pad9vgJo0EPNGesncDcDg1efxMUpHMsPERhVn2q2QIS9VSO1InsRmyjrG6qy/OzTit/tqnRDSwrfRARoq60Z9DSzyyTyhRzPGkSBMLQ32xCXrffGDa7b7Jbnc9QxQ66WZjfT5WxISqrDchCuHpDdVA7GUc0L9BJWm+ig3L75wdkbHZ6GrSrVNe9szqxZ7j11Uy9w+zNmoYRfhNCxX4GsqBeo9FMThnvhu4dtoORVqEfhW6SXlFfhisbWu9vawO6FkAUTK5tatl8vCFxT3uNEOy7ZuhXkPOY4xe2FPML7Xx1RcRbgC5j7bmhyLw98sHCRXvi7wsP2jzhhHcfCOeN4aHazncch/5a08RGRKwrHjkqvRBIf0PB5zHe9yhqVuaG4GpyyjoQCsDXJKX9M8oEUwmwslfcWGyGmqR0kUKZ+26phjGfFyLw6BXuwAVh9wz+N3VKW96wcWiCHB9dGijAjQRw0KlB5OUPeMphdT4zYYXsiyGcxrOP/nx0Kq+PVo2NViv9+JsMdH2w3vvYKQbrh
 nbsAG56g
 p3HozdQ4Toe9Hv2i9AhRVwsEoUyavmSEtaxBVJ2tr82wQXunLPvKCmwTMw/sFi8EDkCY5UoZ9yBd42+iXVPnSPfuvcKCc9jI2vKFzLi0iaN06YrndKemED7x2K90cVctOTLPyC50UArumcWvBfSVMOm6hNZuRlpNMyZBpXbJMCV7+x0ssiyHC/rW/nBI8A9cEVMZnduaNsRiH0wqD6cgRgPS7XX3uFsPOO7HsYFbqDhGi4eOGXJB8yoAghG5ZEeA7KQU7aT7dNHd6vBnvejqZ+UcVeWQjVNYqU/AfHR+wH7xBfazk7PuK7UMBNQT7uj4CZ56jpyAXI87S+ZVBYA5++LoTGBPs/u+FBiu0+Hz1e8X/9XzZKbeeJ816p63TmwkIptyz9s3dUu8dIp1n0tjHuBSSLOtqSrfGonPM2I3KsePDU3ox2uZ9SPGJ8nIhAzIsGJo1rj8REsyxOgcqQTilO5YZsElIQ0rAnoPHJjB/zlWXmVnDpv2PhqTvF2RJEuCTeNj5CCwCCiVMXriXTBw6UhC/ntp5JvG/a0mhlPEmsNkNdbNdWl7FTujnmJQLbX4hGFZ6oyJKGhiE3lJa+/Diskfos6KJc2QnjOAQvDWpKSesDOtvbLYSsgvN5+s+xekKFxbsNfPnFQ40rcOjAsd1zqx1loYQ9JzhSSPnByvQon/uWviMxHt6uVF8rrt2NDUpWJ3s0XSnmVgR8Ml34z8DTv+WGl/YhNl9rWg0mN6n8BezttgEAS02mCv2zek9Oel6sqVUgzuNQc0+cESASPTDqGVgjdrUxTAXoH7tIPLivI+sZaSsfWOYn5Eq9eTpB8NmFwpT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Wei Yang <richard.weiyang@gmail.com> [251224 20:54]:
> The function inc_node_state() is no longer utilized by any part of the
> kernel.
> 
> This commit removes the dead code.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/vmstat.h |  2 --
>  mm/vmstat.c            | 15 ---------------
>  2 files changed, 17 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 3398a345bda8..864a78287371 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -286,7 +286,6 @@ void mod_node_page_state(struct pglist_data *, enum node_stat_item, long);
>  void inc_node_page_state(struct page *, enum node_stat_item);
>  void dec_node_page_state(struct page *, enum node_stat_item);
>  
> -extern void inc_node_state(struct pglist_data *, enum node_stat_item);
>  extern void __inc_zone_state(struct zone *, enum zone_stat_item);
>  extern void __inc_node_state(struct pglist_data *, enum node_stat_item);
>  extern void dec_zone_state(struct zone *, enum zone_stat_item);
> @@ -395,7 +394,6 @@ static inline void __dec_node_page_state(struct page *page,
>  #define mod_node_page_state __mod_node_page_state
>  
>  #define inc_zone_state __inc_zone_state
> -#define inc_node_state __inc_node_state
>  #define dec_zone_state __dec_zone_state
>  
>  #define set_pgdat_percpu_threshold(pgdat, callback) { }
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 090b5c5294b9..16b7cb24d411 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -671,11 +671,6 @@ void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>  }
>  EXPORT_SYMBOL(mod_node_page_state);
>  
> -void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
> -{
> -	mod_node_state(pgdat, item, 1, 1);
> -}
> -
>  void inc_node_page_state(struct page *page, enum node_stat_item item)
>  {
>  	mod_node_state(page_pgdat(page), item, 1, 1);
> @@ -724,16 +719,6 @@ void dec_zone_page_state(struct page *page, enum zone_stat_item item)
>  }
>  EXPORT_SYMBOL(dec_zone_page_state);
>  
> -void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	__inc_node_state(pgdat, item);
> -	local_irq_restore(flags);
> -}
> -EXPORT_SYMBOL(inc_node_state);
> -
>  void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>  					long delta)
>  {
> -- 
> 2.34.1
> 

