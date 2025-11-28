Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A06CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF196B0029; Fri, 28 Nov 2025 02:50:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7436B002B; Fri, 28 Nov 2025 02:50:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7E8F6B002C; Fri, 28 Nov 2025 02:50:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C255B6B0029
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:50:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5425F131839
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:50:03 +0000 (UTC)
X-FDA: 84159242286.02.7BAA164
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id DA0131A000C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:49:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b0IOOmZy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dQNmxY4A;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764316200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4KbvX03YB0pgVMWKgYTw/PoJPeONQDFqn4IwRVce/A=;
	b=vgpyI8VHsNuhw/8bmEvOO9jo9VhRW5EQItzJULZzq+qbxDyzPIbI6E1n0A3RWlU5gGxj3L
	s4Q8nNEO7fAvqCM8EMpOMsFtHqAyfl8UCKzWt8OuvVitb0yoKdXe60rWtVhoihhW95QT+X
	cFrv6nW19caPhbT2VrkGG7Jg77NFPNY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=b0IOOmZy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dQNmxY4A;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764316200; a=rsa-sha256;
	cv=pass;
	b=JqrgaKVaV26bv/Trf1yhtka5pL/kYLOhAj5fUlv4XEWonxVU5c7t90KAlkzGtOkiNVAaCj
	+Yn1tQu3grrHUwQUAOM7P/MSxd94B9RM1mEb9PJRE6CtCUMQ7m17SvhZHhPNWlQy8+xpZW
	aDymLpzpzV0eiiohSVWJ5JN4DAIGUwU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AS0J1UH771327;
	Fri, 28 Nov 2025 07:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=u4KbvX03YB0pgVMWKg
	YTw/PoJPeONQDFqn4IwRVce/A=; b=b0IOOmZy7QFnr2N6YDifYd2/ZM4zGxS3Uq
	RyVRjIAB0UuUXiV9NkYymWA4/1/K8EhCXDm1rB00aeHtophqGKxHo1ZyDfHLfZpf
	ks7HwM2S3YJjyGo1dOEedLQ3zKWCXtC96akadLoMhLI5uE6Vz7/C3QFvsW6oV5l9
	PlY8oBtkbZ65C8awCqC3MD/GZFGVq9RIx+xwka8Hao8Qyram1GycrJU/QTRUpn+u
	q84cNiuEItvcDWbUbDYc5Voj1w5IPN/+jYSXmG/xeoH/pvmG5eaD2YLDgl/dpVVz
	KYXayLJyu94FwwHp7DNRHknIyUxYZ76iLjhMoNbRXvKiMMXLbQsA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4apma9sajg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 07:49:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AS6SJe1022275;
	Fri, 28 Nov 2025 07:49:50 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011052.outbound.protection.outlook.com [40.93.194.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mgrvxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 28 Nov 2025 07:49:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QspEPZpxdEOaDkZhTRNwMZB0gYOyhxpT803PbbZ0A8+etxE7Fn0VtjzdRYo2MH7IzV0GGIFdJkt/PeJjbwfeHD/GM06mq24De4NSJh8hfDnFjOdeErajW6XWDyYPkrewbRDu4JPeLtaM1mjJ6FoWVRuFdl6RzSaynCl3M3PZ+Y9IsVDwhBOOd7uaW/CWwYGNTm3nnb7G5eW1UqrNuBP85F2W6SxShPx0/L0okquf04QbxAU1/lewG8NfQ+2k2jLc5XSMTEc6tIGvl13ebKw46AePmArRpMGRzSyk4t9H70GMNbBGGW0Ojsrvf7cHKx1NKors2WfNuFddOrxUSbU/1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4KbvX03YB0pgVMWKgYTw/PoJPeONQDFqn4IwRVce/A=;
 b=TERfOcvMet4/QPf8tYJtGutwdY6B9+q0LQ1Ml9CC9UJtwPzym65rRYOewb+mZyD9xKKiykCfOZXSC4BUZHHrS5A3OAP3+Y19F4Ge/G9fpWLhxhtZCB3/1dMRu8L6SsEZDp+OLLI5tfuh2kpnCDhrT0FveJ+wP4z+uqqp/rJpi41ynBhYoONUXwPl5aK49zEICd15DW1/cnZhD34cBAqpKho9wESx83kEbYh6aY3KhJi7J57JmkBpEH3gqZzvkWcqAAi/RcaRF75BIQcIv4u8L2/jnNtfewpkuZWla1FzaBecE6Oqm7FlLsrAZp8W4vyxtTixA5yEylRrB1X3CUN76w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4KbvX03YB0pgVMWKgYTw/PoJPeONQDFqn4IwRVce/A=;
 b=dQNmxY4ALto6bhTvTM6aOok+6NLRxpy7shbSfkf+FebX6r71XoUh5jGJh+wLEARnee3R6slgA12Rk/ey1+R2RD4vWmdvpe52yNGnnw/qrFo/Oim4RAvGGcFx4sgks/IuiOIk2d4PB8KpKxPmIOV9Ew7RAZc7VySJVBdaGmNGBIY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4707.namprd10.prod.outlook.com (2603:10b6:303:92::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Fri, 28 Nov
 2025 07:49:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.012; Fri, 28 Nov 2025
 07:49:47 +0000
Date: Fri, 28 Nov 2025 07:49:42 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, david@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
        mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
        ziy@nvidia.com, Liam.Howlett@oracle.com, rppt@kernel.org,
        axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
        Hongru Zhang <zhanghongru@xiaomi.com>
Subject: Re: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator
 and optimize pagetypeinfo access
Message-ID: <f3dc34f1-0579-412e-89a6-20e36ec67a7f@lucifer.local>
References: <cover.1764297987.git.zhanghongru@xiaomi.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1764297987.git.zhanghongru@xiaomi.com>
X-ClientProxiedBy: LO4P265CA0308.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4707:EE_
X-MS-Office365-Filtering-Correlation-Id: 315eff1b-387d-4733-4eec-08de2e52b3da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DEtH1I5P6ZNYMPLjo8/Ur+9rXe0YTU19KhaASGdVFqc8EO3ah5mZjVOD0M5r?=
 =?us-ascii?Q?9283n+E4MKYHPpcc1ARKUyn8p3sLTQBY4DUbj8Kcx3GuJAkzSw0VQU2nY76w?=
 =?us-ascii?Q?6NVQInrmjT6uTCuoeuFb3fkHLTLM54ExAFbmDFj4+ihyP7hkEcGGaisCLiu/?=
 =?us-ascii?Q?VvNHMn9luiK0z5SIO65cSHGyI2ZNOLfLzsDxWbllZ4y6OoOBZOl398iEbvL0?=
 =?us-ascii?Q?q70sBbTqE0CIhqk0x070fVlklApQl++/qA83Tw6pzR4wKhMNTEQsGztQGY8l?=
 =?us-ascii?Q?B8n2+pVsrKugs3xCLBAZ/rrSYcv8V2YSR6iPh3wShhYmsXEd68jQ2x3RouT8?=
 =?us-ascii?Q?eOCxQyU6AMh2452GKLeR1LtEjJJysl43W0346gYK0ZIwlB6Q6d5p4/XSjTBb?=
 =?us-ascii?Q?i9JUHMmEJXYUGkVQ1pJS2kAtQMchuI0cdwqlRv2sGgOyOO9bVlHJVoiHdjg2?=
 =?us-ascii?Q?M978Y6YgDnYO6YGfqqINiT5RyhBalxMhwZ8vEVdjQY9GbwflEbScjzNwFENI?=
 =?us-ascii?Q?IXvvLRjC9Ee92bi8sC1aaUbfGdUKQ2/QaqUb78Q0Ya1z785HtaKFjNtHJd45?=
 =?us-ascii?Q?O1X7fcBzmDH0zx4Gc5wYpQEFksnbWvghq8vDVnUKV/Sk2kDV0+RDE7sGnFZJ?=
 =?us-ascii?Q?29E2/hD+Mdz+35/jtzHenw1GgCL/EZ+sJV2fT9ieJ+6vBDoIm/SVVtkD/jaL?=
 =?us-ascii?Q?o9HRsXjd6eeOZti/yXDHQ12zoappqhisoXvP+op1JXtJ26Ken37vKFRybn2t?=
 =?us-ascii?Q?wwv9He3zrd4IFV4eekTq/qnK7F53H6YY7pXjnsQ1PngrfYJ7z2a228mCAbQq?=
 =?us-ascii?Q?9hYJbb0hOSLz9+N0xtiL9ZhlycyIvKM+A1Iv9CVKQ2ncvQMTEu64/wPuuGUt?=
 =?us-ascii?Q?+Qet8uXYKXdFpTytz/Qn+I/I4cMkL45rWAduidZ1zWG4ZxCulNtb5BjKPPlg?=
 =?us-ascii?Q?SNq/WSuEXSsa+835+At5k1Y8/B1YYsLUovA4m7v4Cw5+Hvz3lTDFitCdPAlY?=
 =?us-ascii?Q?RChccgKBqlHd5jx1XqzEmmLtOYmDk4vwdItjHHI/gVaHFqgCzg4cOc278y6U?=
 =?us-ascii?Q?Z4iv4H2xwrkU25SjnLTIXnZUSJfZEzUcbJHaHpx6t5yFJ38VMDM9CIG1jz4V?=
 =?us-ascii?Q?yPGf/DKsQOAlYVQVAVZdx3JYUoTNDE+R74iCgnF9lnsttzJLUSwmvtQOsnFf?=
 =?us-ascii?Q?TYolLtGcqVBRnWZgV6+NRqpl0ijqzd220d8PjsuyI+/rHa9MAtwHH0mkKiIK?=
 =?us-ascii?Q?7HXUloM1tiX6yckefEk8Xsv7ZqzqW1ItW+cOwtpApIfofzfREk6TapxA2WW7?=
 =?us-ascii?Q?iF8KEVtPo0biWL1Pz38ZANuFV1B5yI8Q7sjs+NOwpeSVuhELVKxMFjJu9s4v?=
 =?us-ascii?Q?YJSE3hIxIhUcalLUn01tzQIkvmaye4Qn9wDv/QZJvpNC24AQPLSx+m+HTHkS?=
 =?us-ascii?Q?vu9KGn64TfVRV/29xOOHg+kdHBR4yn1T?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UHCQpQ7qzMlQXLb9eOlCy0WYib2R5fGJ+mDCm5fCYLrKyT1/fDru3p5bQFFU?=
 =?us-ascii?Q?IsfeO2lV2ejQ3mZLOXza/qSFvT/eWwQMgyiDuSQ1OVkSrcoosCFCZW9AdoE8?=
 =?us-ascii?Q?WmEYhctyXMw+llgWM42RwAJ0lxLbmfitara6KGW3QfN8kWBWXTeHZTpOk2pI?=
 =?us-ascii?Q?j0bDyrJsuNMI0U+spaT9Dap4yeSrZvU9ApP5u+XxwsX0/biL4dwC3f9VWUJF?=
 =?us-ascii?Q?Djas964bEQqRpYe9rTWdfJDtVC5oY3yvK1Cn9jgoPeQCoGQSz9L9iFcAdZp/?=
 =?us-ascii?Q?ZGAPGrcXXcs+SiNplyxqGaqlXbbkMQeDushDWICALpHCcvxkpcjKDh6kAf3f?=
 =?us-ascii?Q?sH1UJO8v0IyT+Xsg1ksqncvzOFDJpHvDF0ofgL42h2eD9YRRgngzEgft3aTd?=
 =?us-ascii?Q?y5eHwZ6tldrET/0WpRRIqsBCE/TdvIWPVW+R+FqrjVqI6yIBmUcwbOlYxroN?=
 =?us-ascii?Q?/6yd3g+U5ib+mnVmKl5xQZnQ5Hrkk/u1mDndU5/HAgLsib9YZ57wR8u+9tPi?=
 =?us-ascii?Q?khH1qKnhv2pPE3aoMUPDKDTQ+SKarsutJxLBpBOEHTEm05UnqPrJn+bn1z7C?=
 =?us-ascii?Q?jYAlDbzPo1amJj5IlBBoioaMpiH2fGii0BD+XhFyzMieSbCxO/OexbluEs5T?=
 =?us-ascii?Q?PozBfeGPuGwbc+izaV4Q6m/WN/f4jLu0836oKdEUwaKOKGhWlBjPzlc03dgV?=
 =?us-ascii?Q?k5WlxOwnsdXJteT4xGPsVejlCwCY/cGEXkKKdHV0XbsN3C34oo/2Qfm+9Pjx?=
 =?us-ascii?Q?csf2h0Jh/eBfBEO/wpvd6+pA79EqrBI6WYhmmlq7KAd1uK71WI9fzD+sIVmO?=
 =?us-ascii?Q?BnNmLTIZmjAVvVJZnry8igQ+ZpzZRmbCFJUzxlCYa38gLbl7LbD/WSCpKr6o?=
 =?us-ascii?Q?foFG3Yfd7I8CsunoPNJbV6jaKkpijD7qEjOfQ1q2MJQqcVymU6zxm3uKtMkd?=
 =?us-ascii?Q?JaAzLATEvReePeK8XAE4HQ9TReTRSjYdBAujtxAgeOqEcBRLV6CQHQpRGAuv?=
 =?us-ascii?Q?M5a3qtGha/ZzhLMULD/oR9NWbv/UmIUCj/4hTD1hGlewGcRI1YoQnjIkQ1Yp?=
 =?us-ascii?Q?NL3L38nZKzcmkG/3sxOTVaFTpwteV4b+RfslsRZ+gZizFuJG+NUEcnskpYcc?=
 =?us-ascii?Q?a8P/ucdr4wHHlRgUotY8ypsYjQJMAfzKni9ST0DU4u8cEAO6ovbimdalX3+K?=
 =?us-ascii?Q?gvrw/0nPxbtGVVlKo8wtLpgCyFUX97hTQ/3QqzDf4gu2t1vDC3Wq2WHrcEOP?=
 =?us-ascii?Q?wFYbScEUyyCdgWOb3XpRo+pZpSPyznNBPvKndnyjFGOf1zhMiWhilb4P0t3D?=
 =?us-ascii?Q?Ov87Cf8glpltmtSof3WXnqFQQsjWMFVUn+lb0WolIoriAvWs/8oZCEFGDbA/?=
 =?us-ascii?Q?Tkr080TNuohMFAJbOKtYpoCjcwiYJ4itUl8iObLC8CF6yx6Xq7uRksOsdHCO?=
 =?us-ascii?Q?1JZmy60yrYTeltj6LT/Q9TiWD4Bl4zvHZkYKltpnoXO4ScdBUa5UKV5fTJV1?=
 =?us-ascii?Q?3ermQD51ucs5GMDaFRmauSxKq9fEmjbzy+xQbGYapkSaLC5lkIPx/65Xlfc/?=
 =?us-ascii?Q?6WX6uAYicwLmLu+ep6ZC/RVi5+Ce4t0oyFhPX+RfGZe0aVo30TI/vmwG6Vh9?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PUcJBq2ElKpPPduPQx1arJf/Nl1VFiuuH+SBec5CZZOoEjvQnBrEJMi3UjtF0P2BuxY63O/36DG2ubs7NbhEx/KsXkmU55tKJDQMAt/R2ohHlCFCpEomKA+qwRWQJS8HG0/642hazL5EI7uIjvv/t/55XheMJW3bWNq+ExEkuoGHb7zWa4IyV0DMMMDYzjrE/8wAigLnqpbTES+QiTxcaz3ieK+YroemrIw2o9wkL5IhU3fukEG+pLNedRAqjyG2h5H0v3mbHVxO9M5bC1NizxIsaj7JcA8KYezqwEkvPP5Xd9dtcT98EmA74RLuCSIGcHDytsuKxByINytIX8qWOe4T5I0380uibjX46GNGtA3YXNw5G4eKCVa+2G9FL6jQ2/GGlL4RK4wxd8V+mQFd9nMx4h55ZYpi75YxPMjG+Ita8iAiVGOatj6RWRcsZmk55Swu1a5PVTIC5iTcgr5bio1NCl40yXZAdy5/I7+HQ2MLSnMB9Tsg2c8HpHBjxOlsjTGZK3xo/a1lAte4mMmnTBMgZzGCaNCDSvURhhRVdZihGPvPqYYiTPCsrugKVlZGbuJ0gSsuj/FpfhSQKmF+CIZLrpA8kR0WZRVtA+gI8tU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 315eff1b-387d-4733-4eec-08de2e52b3da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2025 07:49:47.4496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VVRrHyfc4fjk51Ozaxw4GlbWD/mkdQRVdqJRItkOo+gI0QyLupc5pvp71r/zqblw5xLka6T+evIgd7vUnKOnVaKFuqI7Aoix6gP2BUd6Y8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=958
 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511280056
X-Proofpoint-GUID: OUfB7YrVDwYE81ubxdi--xNBeb4XFqJN
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI4MDA1NSBTYWx0ZWRfXwTOf+ZR9YPIu
 YuoVvoJYx1Ll/Ki1TXOO5JPpc9W/ZWdz8j2/0GB4I18JhCBUiWD3zDLNgO8PLO3exjMEY2KB9xO
 hGi2WgAX7XO2+4ut1oOp6WKZ88/+4CghghIC0LvGDpoPROk1RIurRd9CEAmKJOL0T5anMmruw62
 7AhpRw3fVwAFwkzuaqEIHJcV1zNC2yhR/8B7VgY5vtF/R8SmmmbmtO+V9vR0qe7bFCEFmLHlG7Z
 Rg+AHjgMsDj74a21Yw0q6cxjnTQL3KrylapFnb3zWMDd0fxUp5ijrlWLCgPcYl2re2xV0P6s1EU
 jNqn4uV6Q+ZBXnplU3WyMkrlKrKYfDbzbemXRgK37WRzQSGKGOC71AezAzcmgpRTt3tdwGIsV+X
 EJZ0UPeenuFb8EwQ9p3f/7dLHeGWDGD/UXRNZ0ROH+I13qZQ1RI=
X-Proofpoint-ORIG-GUID: OUfB7YrVDwYE81ubxdi--xNBeb4XFqJN
X-Authority-Analysis: v=2.4 cv=Sr+dKfO0 c=1 sm=1 tr=0 ts=6929541f b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1EepDEyiKQ-SOnm7R-UA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12098
X-Rspam-User: 
X-Rspamd-Queue-Id: DA0131A000C
X-Rspamd-Server: rspam11
X-Stat-Signature: g86kpawb3rncwtot1m4jc9dt9usg5cfs
X-HE-Tag: 1764316199-953816
X-HE-Meta: U2FsdGVkX19lN3Cn43nShs7StEGaEzC+yz9sDYENDWceWCQnceyVo0qajs8ub85euCz7aOjXmWQQ4Lr3f3ZNaskrCCIPDxYtOwz+iI9L8uJevWt9jcC+CfVUQJ/7exalTrhMcJ4i74MyVjo+1VbVvcxXZKByDHy/oH3H1F475Y5EMabmpidEscOHhFVgsqZFt6GDy4foqrGiaAaO9xf/G0PAWl71sV/6GszrIdcQo5dXcJKyfLzeUWkFYyjP0CP75y+Iyu3uR6NIp3xRYZINRAGz3NPz/K3Fn8Xd15noIKLiNSQ1TOTPbBv8oqzgq8kGrQ7hsk6R+mdJALCRA0n0lKMDR7ut8gWF4QpmkfEfztwdDALrOibiina0jOC4pLfTf9YWvbtY8EyK65urqNLjdHscny+J0UXhcfVsBgBw+Q+5w2GRfq217Hg1zlG1vXhURebwBSt5iEYkmM4tFdjNBRYHKqFoIYBUFcrreXVKNN6STRQs7OMW8WvfU2uwY/4F5AtzrSn8DXEtpa3b5Snu3ptaYNA5OPrBeOUQC1rX8l2DcJnpzBMMJBq6bBUTmva30R2wJBTECzw8WsGFXPJy1S0NozKHq5mKI5k9hgAmmW3n/qf92KFc8txwL///Jt5ZGaXQTn3L1P40icLUM/NUOY+hRRLFN5vftR8DlDemt5mhImr3BqqUYdsyQNXe28qIm6ysHJ0Yj1wA0vynxlJyEQHMY2eymtp79v3k3/PvGO8vLS27H6WXAmlY5eckaKXf+Xn/6A31TP6VnA+bvyeSCaL8/IPDXJ5E74IvLJSWyQU7NTAjjWA9NLxnrbR2403kaK0CN8QXSokcI1p/qgHccple7CMjZyAUMYHNOBYIT8hVhtoeOc4kRB5yz3hBRodPEWD0sqkoIRlaWqwuBbwN44eNFsxcTFzMap4G1Oc90NT+sIZDiGQBgQye71UjP9QQAuKJ7uUypfEsAS6Hnfv
 2jEXWnAj
 6CscQTSzMrF1284jOaJbQA9P3xU8oMwMf6JIdeFOcuiWkgsx5XFp9kfpnDZHsEUIitpgxJfxmQcqfYGLFdXZA1DoGFProrUBvvKIdIH7+S7HJhiZII91I3zm+tBu2sOsn3lYqRRTwiWp1ZplZswcboDYdDvm+E/iJ+KbddTWi4It9JcWuHEysbLMBtEpdSolzwjttRx8WxKxnfQCpvcRhadwMP9NOjVjr5oQYOY8zcCTLFxl0K8t677S7a5N1PS6gMJA6LrVUyi/k5pKvNIlEDFULb7WeRpUXWo13muw3ABDjNrCGyVPpGz6XbukGWjdSxXhzztOINdD4zbVy+dyyldRgerARBd+x8erdZkLg4y9Jazy7SVZjumxJZEdlnmJxZyBvmKPPZEBIILwg1ogsC1ERn11D0B/zS3FVEmUKvAOtOmid75tfkw9EBAMEPrW4SfJKyJ+sZpdEgHs0CDJSCCFigkuo84tqYgzfd2dPXpt8SfjtAqPh7F89ef8VEibtr0zcTaiLNGLxiweXOLPIfTTchLhFxMYPPl5+j32/i64h8k8bvp3Hg5CLN7StHuE3VCzdyJAAFKus1xKmjlkk6uS9NA2q3cFNF7djEqFW285gR9v2r6ir7qR2Jg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just a general plea :) could we please try not to send larger series like
this so late.

We're at the last day before the merge window, this is better sent during
6.19-rc1 or if now as an RFC.

Thanks, Lorenzo


On Fri, Nov 28, 2025 at 11:10:11AM +0800, Hongru Zhang wrote:
> On mobile devices, some user-space memory management components check
> memory pressure and fragmentation status periodically or via PSI, and
> take actions such as killing processes or performing memory compaction
> based on this information.
>
> Under high load scenarios, reading /proc/pagetypeinfo causes memory
> management components or memory allocation/free paths to be blocked
> for extended periods waiting for the zone lock, leading to the following
> issues:
> 1. Long interrupt-disabled spinlocks - occasionally exceeding 10ms on Qcom
>    8750 platforms, reducing system real-time performance
> 2. Memory management components being blocked for extended periods,
>    preventing rapid acquisition of memory fragmentation information for
>    critical memory management decisions and actions
> 3. Increased latency in memory allocation and free paths due to prolonged
>    zone lock contention
>
> Changes:
> 1. Add per-migratetype counts to the buddy allocator to track free page
>    block counts for each migratetype and order
> 2. Optimize /proc/pagetypeinfo access by utilizing these per-migratetype
>    counts instead of iterating through free lists under zone lock
>
> Performance testing shows following improvements:
> 1. /proc/pagetypeinfo access latency reduced
>
>     +-----------------------+----------+------------+
>     |                       | no-patch | with-patch |
>     +-----------------------+----------+------------+
>     |    Just after boot    | 700.9 us |  268.6 us  |
>     +-----------------------+----------+------------+
>     | After building kernel |  28.7 ms |  269.8 us  |
>     +-----------------------+----------+------------+
>
> 2. When /proc/pagetypeinfo is accessed concurrently, memory allocation and
>    free performance degradation is reduced compared to the previous
>    implementation
>
> Test setup:
> - Using config-pagealloc-micro
> - Monitor set to proc-pagetypeinfo, update frequency set to 10ms
> - PAGEALLOC_ORDER_MIN=4, PAGEALLOC_ORDER_MAX=4
>
> Without patch test results:
>                                          vanilla                vanilla
>                                        no-monitor               monitor
> Min       alloc-odr4-1        8539.00 (   0.00%)     8762.00 (  -2.61%)
> Min       alloc-odr4-2        6501.00 (   0.00%)     6683.00 (  -2.80%)
> Min       alloc-odr4-4        5537.00 (   0.00%)     5873.00 (  -6.07%)
> Min       alloc-odr4-8        5030.00 (   0.00%)     5361.00 (  -6.58%)
> Min       alloc-odr4-16       4782.00 (   0.00%)     5162.00 (  -7.95%)
> Min       alloc-odr4-32       5838.00 (   0.00%)     6499.00 ( -11.32%)
> Min       alloc-odr4-64       6565.00 (   0.00%)     7413.00 ( -12.92%)
> Min       alloc-odr4-128      6896.00 (   0.00%)     7898.00 ( -14.53%)
> Min       alloc-odr4-256      7303.00 (   0.00%)     8163.00 ( -11.78%)
> Min       alloc-odr4-512     10179.00 (   0.00%)    11985.00 ( -17.74%)
> Min       alloc-odr4-1024    11000.00 (   0.00%)    12165.00 ( -10.59%)
> Min       free-odr4-1          820.00 (   0.00%)     1230.00 ( -50.00%)
> Min       free-odr4-2          511.00 (   0.00%)      952.00 ( -86.30%)
> Min       free-odr4-4          347.00 (   0.00%)      434.00 ( -25.07%)
> Min       free-odr4-8          286.00 (   0.00%)      399.00 ( -39.51%)
> Min       free-odr4-16         250.00 (   0.00%)      405.00 ( -62.00%)
> Min       free-odr4-32         294.00 (   0.00%)      405.00 ( -37.76%)
> Min       free-odr4-64         333.00 (   0.00%)      363.00 (  -9.01%)
> Min       free-odr4-128        340.00 (   0.00%)      412.00 ( -21.18%)
> Min       free-odr4-256        339.00 (   0.00%)      329.00 (   2.95%)
> Min       free-odr4-512        361.00 (   0.00%)      409.00 ( -13.30%)
> Min       free-odr4-1024       300.00 (   0.00%)      361.00 ( -20.33%)
> Stddev    alloc-odr4-1           7.29 (   0.00%)       90.78 (-1146.00%)
> Stddev    alloc-odr4-2           3.87 (   0.00%)       51.30 (-1225.75%)
> Stddev    alloc-odr4-4           3.20 (   0.00%)       50.90 (-1491.24%)
> Stddev    alloc-odr4-8           4.67 (   0.00%)       52.23 (-1019.35%)
> Stddev    alloc-odr4-16          5.72 (   0.00%)       27.53 (-381.04%)
> Stddev    alloc-odr4-32          6.25 (   0.00%)      641.23 (-10154.46%)
> Stddev    alloc-odr4-64          2.06 (   0.00%)      386.99 (-18714.22%)
> Stddev    alloc-odr4-128        14.36 (   0.00%)       52.39 (-264.77%)
> Stddev    alloc-odr4-256        32.42 (   0.00%)      326.19 (-906.05%)
> Stddev    alloc-odr4-512        65.58 (   0.00%)      184.49 (-181.31%)
> Stddev    alloc-odr4-1024        8.88 (   0.00%)      153.01 (-1622.67%)
> Stddev    free-odr4-1            2.29 (   0.00%)      152.27 (-6549.85%)
> Stddev    free-odr4-2           10.99 (   0.00%)       73.10 (-564.89%)
> Stddev    free-odr4-4            1.99 (   0.00%)       28.40 (-1324.45%)
> Stddev    free-odr4-8            2.51 (   0.00%)       52.93 (-2007.64%)
> Stddev    free-odr4-16           2.85 (   0.00%)       26.04 (-814.88%)
> Stddev    free-odr4-32           4.04 (   0.00%)       27.05 (-569.79%)
> Stddev    free-odr4-64           2.10 (   0.00%)       48.07 (-2185.66%)
> Stddev    free-odr4-128          2.63 (   0.00%)       26.23 (-897.86%)
> Stddev    free-odr4-256          6.29 (   0.00%)       37.04 (-488.71%)
> Stddev    free-odr4-512          2.56 (   0.00%)       10.65 (-315.28%)
> Stddev    free-odr4-1024         0.95 (   0.00%)        6.46 (-582.22%)
> Max       alloc-odr4-1        8564.00 (   0.00%)     9099.00 (  -6.25%)
> Max       alloc-odr4-2        6511.00 (   0.00%)     6844.00 (  -5.11%)
> Max       alloc-odr4-4        5549.00 (   0.00%)     6038.00 (  -8.81%)
> Max       alloc-odr4-8        5045.00 (   0.00%)     5551.00 ( -10.03%)
> Max       alloc-odr4-16       4800.00 (   0.00%)     5257.00 (  -9.52%)
> Max       alloc-odr4-32       5861.00 (   0.00%)     8115.00 ( -38.46%)
> Max       alloc-odr4-64       6571.00 (   0.00%)     8292.00 ( -26.19%)
> Max       alloc-odr4-128      6930.00 (   0.00%)     8081.00 ( -16.61%)
> Max       alloc-odr4-256      7372.00 (   0.00%)     9150.00 ( -24.12%)
> Max       alloc-odr4-512     10333.00 (   0.00%)    12636.00 ( -22.29%)
> Max       alloc-odr4-1024    11035.00 (   0.00%)    12590.00 ( -14.09%)
> Max       free-odr4-1          828.00 (   0.00%)     1724.00 (-108.21%)
> Max       free-odr4-2          543.00 (   0.00%)     1192.00 (-119.52%)
> Max       free-odr4-4          354.00 (   0.00%)      519.00 ( -46.61%)
> Max       free-odr4-8          293.00 (   0.00%)      617.00 (-110.58%)
> Max       free-odr4-16         260.00 (   0.00%)      483.00 ( -85.77%)
> Max       free-odr4-32         308.00 (   0.00%)      488.00 ( -58.44%)
> Max       free-odr4-64         341.00 (   0.00%)      505.00 ( -48.09%)
> Max       free-odr4-128        346.00 (   0.00%)      497.00 ( -43.64%)
> Max       free-odr4-256        353.00 (   0.00%)      463.00 ( -31.16%)
> Max       free-odr4-512        367.00 (   0.00%)      442.00 ( -20.44%)
> Max       free-odr4-1024       303.00 (   0.00%)      381.00 ( -25.74%)
>
> With patch test results:
>                                          patched                patched
>                                       no-monitor                monitor
> Min       alloc-odr4-1        8488.00 (   0.00%)     8514.00 (  -0.31%)
> Min       alloc-odr4-2        6551.00 (   0.00%)     6527.00 (   0.37%)
> Min       alloc-odr4-4        5536.00 (   0.00%)     5591.00 (  -0.99%)
> Min       alloc-odr4-8        5008.00 (   0.00%)     5098.00 (  -1.80%)
> Min       alloc-odr4-16       4760.00 (   0.00%)     4857.00 (  -2.04%)
> Min       alloc-odr4-32       5827.00 (   0.00%)     5919.00 (  -1.58%)
> Min       alloc-odr4-64       6561.00 (   0.00%)     6680.00 (  -1.81%)
> Min       alloc-odr4-128      6898.00 (   0.00%)     7014.00 (  -1.68%)
> Min       alloc-odr4-256      7311.00 (   0.00%)     7464.00 (  -2.09%)
> Min       alloc-odr4-512     10181.00 (   0.00%)    10286.00 (  -1.03%)
> Min       alloc-odr4-1024    11205.00 (   0.00%)    11725.00 (  -4.64%)
> Min       free-odr4-1          789.00 (   0.00%)      867.00 (  -9.89%)
> Min       free-odr4-2          490.00 (   0.00%)      526.00 (  -7.35%)
> Min       free-odr4-4          350.00 (   0.00%)      360.00 (  -2.86%)
> Min       free-odr4-8          272.00 (   0.00%)      287.00 (  -5.51%)
> Min       free-odr4-16         247.00 (   0.00%)      254.00 (  -2.83%)
> Min       free-odr4-32         298.00 (   0.00%)      304.00 (  -2.01%)
> Min       free-odr4-64         334.00 (   0.00%)      325.00 (   2.69%)
> Min       free-odr4-128        334.00 (   0.00%)      329.00 (   1.50%)
> Min       free-odr4-256        336.00 (   0.00%)      336.00 (   0.00%)
> Min       free-odr4-512        360.00 (   0.00%)      342.00 (   5.00%)
> Min       free-odr4-1024       327.00 (   0.00%)      355.00 (  -8.56%)
> Stddev    alloc-odr4-1           5.19 (   0.00%)       45.38 (-775.09%)
> Stddev    alloc-odr4-2           6.99 (   0.00%)       37.63 (-437.98%)
> Stddev    alloc-odr4-4           3.91 (   0.00%)       17.85 (-356.28%)
> Stddev    alloc-odr4-8           5.15 (   0.00%)        9.34 ( -81.47%)
> Stddev    alloc-odr4-16          3.83 (   0.00%)        5.34 ( -39.34%)
> Stddev    alloc-odr4-32          1.96 (   0.00%)       10.28 (-425.09%)
> Stddev    alloc-odr4-64          1.32 (   0.00%)      333.30 (-25141.39%)
> Stddev    alloc-odr4-128         2.06 (   0.00%)        7.37 (-258.28%)
> Stddev    alloc-odr4-256        15.56 (   0.00%)      113.48 (-629.25%)
> Stddev    alloc-odr4-512        61.25 (   0.00%)      165.09 (-169.53%)
> Stddev    alloc-odr4-1024       18.89 (   0.00%)        2.93 (  84.51%)
> Stddev    free-odr4-1            4.45 (   0.00%)       40.12 (-800.98%)
> Stddev    free-odr4-2            1.50 (   0.00%)       29.30 (-1850.31%)
> Stddev    free-odr4-4            1.27 (   0.00%)       19.49 (-1439.40%)
> Stddev    free-odr4-8            0.97 (   0.00%)        8.93 (-823.07%)
> Stddev    free-odr4-16           8.38 (   0.00%)        4.51 (  46.21%)
> Stddev    free-odr4-32           3.18 (   0.00%)        6.59 (-107.42%)
> Stddev    free-odr4-64           2.40 (   0.00%)        3.09 ( -28.50%)
> Stddev    free-odr4-128          1.55 (   0.00%)        2.53 ( -62.92%)
> Stddev    free-odr4-256          0.41 (   0.00%)        2.80 (-585.57%)
> Stddev    free-odr4-512          1.60 (   0.00%)        4.84 (-202.08%)
> Stddev    free-odr4-1024         0.66 (   0.00%)        1.19 ( -80.68%)
> Max       alloc-odr4-1        8505.00 (   0.00%)     8676.00 (  -2.01%)
> Max       alloc-odr4-2        6572.00 (   0.00%)     6651.00 (  -1.20%)
> Max       alloc-odr4-4        5552.00 (   0.00%)     5646.00 (  -1.69%)
> Max       alloc-odr4-8        5024.00 (   0.00%)     5131.00 (  -2.13%)
> Max       alloc-odr4-16       4774.00 (   0.00%)     4875.00 (  -2.12%)
> Max       alloc-odr4-32       5834.00 (   0.00%)     5950.00 (  -1.99%)
> Max       alloc-odr4-64       6565.00 (   0.00%)     7434.00 ( -13.24%)
> Max       alloc-odr4-128      6907.00 (   0.00%)     7034.00 (  -1.84%)
> Max       alloc-odr4-256      7347.00 (   0.00%)     7843.00 (  -6.75%)
> Max       alloc-odr4-512     10315.00 (   0.00%)    10866.00 (  -5.34%)
> Max       alloc-odr4-1024    11278.00 (   0.00%)    11733.00 (  -4.03%)
> Max       free-odr4-1          803.00 (   0.00%)     1009.00 ( -25.65%)
> Max       free-odr4-2          495.00 (   0.00%)      607.00 ( -22.63%)
> Max       free-odr4-4          354.00 (   0.00%)      417.00 ( -17.80%)
> Max       free-odr4-8          275.00 (   0.00%)      313.00 ( -13.82%)
> Max       free-odr4-16         273.00 (   0.00%)      272.00 (   0.37%)
> Max       free-odr4-32         309.00 (   0.00%)      324.00 (  -4.85%)
> Max       free-odr4-64         340.00 (   0.00%)      335.00 (   1.47%)
> Max       free-odr4-128        340.00 (   0.00%)      338.00 (   0.59%)
> Max       free-odr4-256        338.00 (   0.00%)      346.00 (  -2.37%)
> Max       free-odr4-512        364.00 (   0.00%)      359.00 (   1.37%)
> Max       free-odr4-1024       329.00 (   0.00%)      359.00 (  -9.12%)
>
> The main overhead is a slight increase in latency on the memory allocation
> and free paths due to additional per-migratetype counting, with
> theoretically minimal impact on overall performance.
>
> This patch series is based on v6.18-rc7
>
> Hongru Zhang (3):
>   mm/page_alloc: add per-migratetype counts to buddy allocator
>   mm/vmstat: get fragmentation statistics from per-migragetype count
>   mm: optimize free_area_empty() check using per-migratetype counts
>
>  include/linux/mmzone.h |  1 +
>  mm/internal.h          |  2 +-
>  mm/mm_init.c           |  1 +
>  mm/page_alloc.c        |  9 ++++++++-
>  mm/vmstat.c            | 30 +++++++-----------------------
>  5 files changed, 18 insertions(+), 25 deletions(-)
>
> --
> 2.43.0
>

