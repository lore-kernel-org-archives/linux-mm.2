Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2834EDEBFD
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 01:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080BE6B0005; Tue,  3 Mar 2026 20:55:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02E386B0088; Tue,  3 Mar 2026 20:55:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27C36B008A; Tue,  3 Mar 2026 20:55:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE8216B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:55:36 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 781BD1C3DA
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:55:36 +0000 (UTC)
X-FDA: 84506713872.17.F742225
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0C68118000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 01:55:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LcdXwvmr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L4YOrxzx;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772589333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHpJEeRknOxeiZQtzkPTHjy9A9y5+EoPUBrPVLnITLo=;
	b=1TUdDGBCTpAqxYztZaKcVOgggPO1xGXyjSYcGPos8poV3Fs2Ay5WT/tiVYBM1MQ0pvYeVH
	Cq8KqrzZX+K5qxAJmIbxzgvMtQ2091Z0rqsrKdVfHxWsY50TynjsAj3NOKliWHu3OAIj2M
	ny2I9HbXD2JPHKxh53Of5JwdgFr8uTI=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LcdXwvmr;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L4YOrxzx;
	spf=pass (imf16.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772589333; a=rsa-sha256;
	cv=pass;
	b=3Iil9QTPBXjWps+fN+3L7Zc26FkEITTO1YBVZshjpC8KLV8Ro1lkt3/cQ1zv0sc1rJgxps
	hGX0uD2WRSxHiRhyh5wZWo1kEoXrSjLPx7NSTb7KOOI6pti52NsK0sJs3054wrha1J9nQJ
	bqMLpMGKeLqnfuOucyeOgELN9XO4flQ=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6241roTL1275775;
	Wed, 4 Mar 2026 01:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=uHpJEeRknOxeiZQtzk
	PTHjy9A9y5+EoPUBrPVLnITLo=; b=LcdXwvmrFICqomvlPkibCrmALOoB0fOyk1
	vulysegGhtx5LjJiqJFUQS6Lr3bnJDCohBeHE2p7y730U5vebbzxdnnDYme5Gsin
	Dz0zDw5a8KxYx73s8eLyFczmIp++WGXUqeaV4wygzFca+2rI7+68SFWazzJX51DA
	DMvOh3WJxz0zr1JZrWTnhWUDMRR70zomeYPV8d+oZj6pAlmdj6ljRCRw2ri1e+uw
	1KE83qpOtXE8o4+v3Sef9zusC/+dzdxCv3r4D2ULYwE90eNU+iPsAHKQvxiTMcp1
	9btYYDXbW9pbqnjL/YsfIa8mp9WgyURluOIrgdJwhy6xfKCuss/w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cpbfk800w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 01:55:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 623NJEHW023063;
	Wed, 4 Mar 2026 01:55:24 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013052.outbound.protection.outlook.com [40.93.196.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptfdu9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Mar 2026 01:55:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aS+Cp0PkmSKVpwe7V3fMwX9PtDBUMtw6/IF2Fgi1eNfV370lTI1qjIwpO0N00JQJicVaomqTGCa/ARa1y+RTL77HdYpfKGFR+UN2G/mHBDNZ8CswhUpXy87JtaEnFgGa+EMicHulLQdXy0fAtXI5yPmFPG5SWQwc/M6/7W36V0TeeuW/JUVGktHPezW6QcE7utx2/4cG8XCrCpV7RdMcDKHACCNf6aHUcAM8VeSIqC8Q8i/5Nkq4aqemXu1jnAu6QV5VsDdQTQvSkcu2PM79f9yrUkGuAb/pqSG3krVroLuY9fwnrGp5563kBRkrJ9Hm1CDtM8dBqmtyDrB785QB3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uHpJEeRknOxeiZQtzkPTHjy9A9y5+EoPUBrPVLnITLo=;
 b=bhjhQ9rQkbZb25bV1d69Zcl7qA9HPhiyNHdrJHEZhRf9K9LIhwiPkGtMnPN0n6CYLAE1/QY8TuOTpZ0nyKjtgmstpE0S5L9c0eyDPtQnUcrlUQmm4FGl1LtoRixrkaHCEaP4yz2C6ZDjMDo/dfGKXhVmd69gdXq4Vy+PutfKDvYvTAiLIEKSaevhKVm6HFqS23nnR9rZBwfV8u28g4lOECGniCGlHEttSMiYuDP4Ih7nAiRRH3TA49wNYE+ya5Q8LBLNG01vJenqsS33Wyj1d7yotq2NcYUSQkC9g+Ff6eXuJviWqKhVQECpE4fajGFUXuZi+9zEjZuK25MJBoPZ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uHpJEeRknOxeiZQtzkPTHjy9A9y5+EoPUBrPVLnITLo=;
 b=L4YOrxzx8XDlJDU1p6lBsWo8Qrvb6ayI04i/Yeq6jvXIx+qakqc1WH8QQyjogss/59Uq0lyipoLOrXRpGLr1Ts0dSaNe6vJgJLWkqkIlPMvcFgJVyKuDd5Ledr7iJcHWRKelkKCsPDFKZP7a1ql65PXWrYHeTgyl7zUoPLJ2py8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MW4PR10MB6583.namprd10.prod.outlook.com (2603:10b6:303:228::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Wed, 4 Mar
 2026 01:55:16 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 01:55:15 +0000
Date: Wed, 4 Mar 2026 10:55:07 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: Update stale comment for sheaf_capacity.
Message-ID: <aaeQ-7iMf7yhv4j9@hyeyoo>
References: <20260228201510.973702-1-kuniyu@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228201510.973702-1-kuniyu@google.com>
X-ClientProxiedBy: SL2P216CA0135.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MW4PR10MB6583:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c4859ef-7fd8-4ba5-7f1c-08de79911460
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	AEyQt6Ju1kjwMjmUYlhux5PmdGNHWJ/PM6gYhrsIlYU7QY0IvMnhXYBWGSZ5hzr7+8IPGRlrYztVsiN/oY+lpftLMeGnXI8X4nJHfVA+jH2MM9WgPix0tHHP7iqxKim4HyUMHT4NDyt3mAE1j5pEPqzDvdawXynOMb5+SLjXVxli2PLinMstyDsyTmcGf7xih59NJ8Y6kN53TAryN9oxZ/lPPQXHunmduaDKoG8j0MNTva905lxxzqbOvgwCJdpGeR7uifiCm1rXFB0cvnNn9K4MhRHjukn2NuD0Hu9oQtcluWWTPK7iX4JNEEQL/0BpA1wFNqk9ggVm1UyL4eKFDDqEIqqlXn427b4tau9QVNKfcEU5NRVgrxgUZYK2SNIwsM2s0Z+AIqtTGAlEWOtc3o+hJpQIRggN7z/0BnjJRps0PnhK5VigD0g3nycA6uD7Pxw0M6n92OiJkBznuzhqsHMrP+7endc4pyPcwfldbp2PwdAwoPzaE2ounFbCiSR09ydezwkDenQYPNhwGqvTA21fR3wapWgG5OEpyxdY67GUxNPyZH81NeU7Q5YSEyDmGQ5PHqRwhNnVfs9qZejXh7vy5JiIMJHYphslf/y4w6ATGL/Og2KN0xsXkx6iN4dzf1o6MjNMJHKVH8HY1NrvQ1D863FSfukWgye0LW1x8IqWAhSIzS+CjqL0xEXh1waE1CX6BQkzUT+MaN2exK/i+oLcKzTKItjQHCzegwaejwU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N+0VEGOaGEeeTcGHBB7ghNIC8X6Hjs/WS747WWZst0hUtVkLIOWehuBZbBs0?=
 =?us-ascii?Q?Yz8ejF3w8oLa/B4NAlVDvgFf3HzbbydvQ9gK6W7w5njP4qeXQmHiA3SwbRFR?=
 =?us-ascii?Q?fNPzxzniAbB5HXdo9eC5cd8/CJEYrj+phoNrCY7bqgHpX5IELhSfXi+ngidX?=
 =?us-ascii?Q?Kmf4gB90ex+6vinyt6yhlf714ni2qaCMh8//LLZOdZzxIuRvp8iLVdoC204r?=
 =?us-ascii?Q?7keF2sAcbIq0EfVMD5DA3R3ELJHmLmEaI9AHJt8wmtpRPjfD68puhtXit6re?=
 =?us-ascii?Q?yGV+LwOBNevrqo3OnmN4WDMWRH964exdgdyNT/Nrqsie++PsFTPQIlPYM25n?=
 =?us-ascii?Q?2XdU72vdAX03Bj6yaXQfxpbXZBBaDAzFw8BR4+pq92aXu+8/jPJvlB8YuY2y?=
 =?us-ascii?Q?mvAiRNF9DK6v4ZgyIiItqCEIyCzPZXXCmhBo2aCIZmoXZGJGOndxh3pzfp1L?=
 =?us-ascii?Q?bBqxu0c2T2jTsV9yU1dE1aVabLM7xTNKz8FhzBVNfhIzm3OlTJMr2H1kBxtc?=
 =?us-ascii?Q?Gk0rGqYTLGCHDWe21QYYkwoLMHoQts33ZgK0X+ysCPfOt45I+KsL7+TQMJBT?=
 =?us-ascii?Q?JeztZXu/hknIAsk9QraQdd93591hFQZp4KxLvBJcppmix6/t5+fD0MEI3UH1?=
 =?us-ascii?Q?IUzxqcRnw/gD6a6vxp9De76MXdizXA+YxwSTrO5Jsy6cuQF5LpCHaZZT1JHb?=
 =?us-ascii?Q?PEKuqdglC1doU+6IkoxWMFyc3DJ1CtWHCgJLH/EbgieUoTEXSebv/SYNO4U0?=
 =?us-ascii?Q?upbFHN0mAQOqHY3BXQnAwm7Eti2nSzing4hxwfwVaveamV0FIYaJg0NSu7rj?=
 =?us-ascii?Q?pscdH905bM0bOVLBeQzUEMoVUPEaD08eneoZrqkmVL8VCqdNtpHDSLtIjeu5?=
 =?us-ascii?Q?eAqrSiYv9wh2Sp1rkoD0XdN+TaL+o1ynfUg+KnyrGGEi87ktjt/7NKBgxvYK?=
 =?us-ascii?Q?eqgrQkHfeOj0A14HAWCUL8EFR/e0QV8qt8GnCVqdOVmabu+8a3jG0nMzDlFA?=
 =?us-ascii?Q?hVt2Cl3YaYmw+kNra4MQyyNuE4FClo15A+hoRQ1dsW36+hZ4G2DAXBXWZ2PG?=
 =?us-ascii?Q?l90/7RM94P5xpjuXERGoM2Cw4UFcCPqSjnacTu/esRzNu46m3TZLj/dhUlnY?=
 =?us-ascii?Q?HIYbocv5GqW9Mdtb8FMFJoiXw+eyWG7xdsXHtJOU/w40dfEYsyUxspSvPdTd?=
 =?us-ascii?Q?Yqc8TS3zipGgrGETM8AWHssD74wDDSkxevSYhDjl8hnLehEcxqsvC6QcTgd4?=
 =?us-ascii?Q?Q7JI/C5OGXkHGpmhOJQFhlnzLwg+a/DbzedLHN0ZTVpDgy/qtON29ws8ZKTK?=
 =?us-ascii?Q?mT2zEvJoqTfwHZECqPsgE02PEiiNhT93OzusAfXM31mfT6jOKQXL9RtokC6F?=
 =?us-ascii?Q?0bmrHg0eibUM/+iVFoYw3vJAym5Ud0+p7ATQGZ69zcyycKsLL7ewN7wzuhcq?=
 =?us-ascii?Q?HEJ/41CSikrBsiOpsekJJS2p+n88jnVXlf5aZdMshaly7085NJybTxNPX/7e?=
 =?us-ascii?Q?sffWOI8dprKYD0oKy6qsN+ZZGQJ4J89pIMnzCz0JHliRf8sfJt8x9NjD+Y7l?=
 =?us-ascii?Q?P4C44i1zgbkcIbdIFOA7/5wPoMQC/Zf70PesUR+nB8kdmQTUsVQPcXy39P5F?=
 =?us-ascii?Q?dMAOYITQ7NIn5hX1sy7kkER1JZVv8nhflsNd8bTLYZtAszqdZdscwQ+wolBu?=
 =?us-ascii?Q?OkqZPDO7CttYDUkbAhBOwkOvEEQ33raX6/MnWYPvZPddeBe5X1imNd0pXvlL?=
 =?us-ascii?Q?DRQqZ3gcqA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	K8Dr2HDaWAcIuXXw63e1HlebveCY+88Q5vSuwOkWT9J8At37+Jgl++iZ5srOrw/yeMFP+jI0X+82e/GwaeTICxyGWcm7RWdx88G1ESYOMBYGAJ5Lkx5Lc/d3RrXwAiJ5cmOFqHqeSXaIJ1ImVVplqdkEe3BuNA6yiJ8quwbknOHKkw6+Dg0EyaCmfIp6Fx7Ccq2fdHwlJAH6bKC0UXP79gjLVbgtUxcTzbWK7BhGk+vPJ1G54g7CV/S/ErKLGJHVvqaCRsNdpUA22XeDvIRM9QI0uXTb4vD0sweYHyrYHszhrFzJmQYxiLV1ga7gb6Sq8z0l7xzh6P2mTrbdkcM8oNASsaW221/sju8Z9gD0Ys4/YiduyS/FwcZIvhZbCgDgCktT22JmzhTa4+rAggAi9MFJ+WxC9pR5h2l/ynrYly74iaT35NxBbED/5y3MvgOKl3MaFcvJOHm0iOD5BsrTNdvFi0q6436W0l7wREpUvWmcr8aZH81lGaQNvwwXgi+igWnxwjXN7IySsCBJLfrxOmzFQ5Pf2qI29lR9Y+Livsck2xc3hd6Ah0iD4zuoGX8DwC4ZNqftAnbfwD7y1ecdTai1Spb1sPjtCr2+YxW+Anw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c4859ef-7fd8-4ba5-7f1c-08de79911460
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2026 01:55:15.4122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Iey/cR1nlVOGM16mn4/DMwbmYHckGC7Pid6QgzlC+lCQubWZST5lXvel8+c6NhB09EHynV8+i1P4tsxknvW6XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6583
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-04_01,2026-03-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603040014
X-Proofpoint-GUID: POf7qIv-bUk63hshRScTvUjId33QbOnu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA0MDAxNCBTYWx0ZWRfXy2meVEZRuV0i
 4qw/c2BM862hinjpOFO5Ws5KkBPP53+vYgJZUE+a1wIo1c4gA2t8d5QA98lw5vMXPZsEVl5WQcf
 FSk3ON7Ga0388BMgNe7kWprfBNaI0KlJagRmcEZxkUQ0f3bRcrwNytNVLEKaTSRsLevHMVUvDbe
 v/J7JHX+ULFBjqlgJdoCjOZUROvcoqCnC/Vm/kSgxtfhJ3Djja4uC6IaSdPrdydZrx9/yiWgwO+
 2jwR0CwHJs1PO+eK4B4XZNX+tZI38ivCur+PBChiWPEbPbyqj44y6DrtRE+FAskki9nrOvFDDcz
 tr/QK8WZD1afCIs62lRZ+Qg6KCk2OU5zLVoyLsRqaSpZRCiUEGTw8HdE+ychF28RhsGrq9xoTxU
 lu5KXJolxp2moX0BwjZqDNZzYAOA216ZEJ+9s3OAQPXnLxL203FgKlKHbU+cyj5EcwgahB+4QFP
 AIpx//pigttZfgbJBePwIlUKxnlwmjjyXcgqf9gs=
X-Proofpoint-ORIG-GUID: POf7qIv-bUk63hshRScTvUjId33QbOnu
X-Authority-Analysis: v=2.4 cv=UKDQ3Sfy c=1 sm=1 tr=0 ts=69a7910d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=1XWaLZrsAAAA:8
 a=yPCof4ZbAAAA:8 a=JVKC3EeB6v7BgArEv2UA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12267
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C68118000D
X-Rspamd-Server: rspam08
X-Stat-Signature: xhtta6kuznpxtukq7ppcuucxs4wz1e4j
X-HE-Tag: 1772589332-67165
X-HE-Meta: U2FsdGVkX1/30vf7P+ZbhNCte84dAWcCgrrdo7RpHnx131uplB6l51/s4i3+Lnph+4sR3JavtGBx3oJx4Vf+xpHWiMJWyvrZKxtyymqQGhfUFMV6rS3HVBEPJrC0ClWrbNxNg5fDKFjsBVjm5Amt5LpSdWVI5aWfBuc0YBK7RzedX+VZ0JYgQq7A3QWtEZ+sbzaH20ZIN4sO2UYwKodyj/+HqvTtGgvpfmnH28q/t+7FGMrG3+LnhNimGNaFlmAcBSYwbrQXMH7sZtRd71WvcxQCQIMPH4syjdAtq7sOp0k0yZs5QFTi665s29NBLX7u9yBFubDECjhyTA7UHUGF/IGWgiHUgb59B5cFwSbsH5KIUHVM2bmVn4hqb7/+5zLOlJ24TVvK6P4heBfw7z5VXL/e52RI2TTZBBJ429tj4rEN1J9kmbMclmOMMFpSRvG+xYL9cRxb/l7e3ifguJTAtIjKnO6ze4ZMaSjX617AkumugbWt+49Nbyd3YZ+yajXZUeKMap1J3LJdKuoU5PJIjUM33gcBv2P06tazUwfzj+dfN88ruFXyCK2eR4OSzqVPBB2y/wzag56b/Hw3aAKS71BCiTmlv7RZDiZK7BrfSy0baMhYWLp1pr1SZsD4Nt+hdr9+1d9x7uWDvPXM20cKKkBR5DKbmODhbJaO9g2pwd/OvPmV9fbiFOdkKHw7hmkxYmbR65F0A9Z8PWUrTzH09vR/iolqSOdgVUa62Fp2QapDgznhmPYWj1NO42lhbtNMIogwBiXvuhQENCWh9XyWGiWLTLd5YnfQ3mlWbMAcDAePIfvpcJxan1Tv4o2EpRftDPC6boQQBbBseY9A5UgR6zf8Ra6JSFk+uWCsMCzlh3PnvxHszagqWJqmKVgLQ9KVudIRyUkLUwzXodggF8aJ0IcgQRDAVWuzdNn4T05jT9UibnurxPl4VYSQmOg+m9QFfDTpuQvQy2RFjxnWwNQ
 oQQN94a+
 JNHVLzk5XMBT5XKOWyv2WnFhMnIfDKNUTGuqC3S/90tjfsx9Ef7DXFRTSGBgTQO6SYT8mV5KnDxKIs4iYwlvYl8nstlX9kCuEPifqLzB9NuhtKM9xW5VB9hiG3H/LeF1aAhWqPLM1oxM/B3Xlw5LnYaTzI6aaf2zZXFOM7Aia1efIyft/T6v4JfqECXpKqF+kWk31C820kk+aklWrrEhO9UgGT8exTuIriQv8pSOuWzx8ijz4Iyp6QlRkV8vlJw7B6+oFOZQxigQHfd6KUVmwx2J/ux3hfW0vtY4NZmShxWM6yvvBb3dt5Xbj6ouym7ezWrR/+p+2PNb0t/J7skmy0eYI+vnzt7nSeqeeOnh0Lczgjm+A5D17tZ2aTXNbBEf5Y+eAW62z4/31dKJs8iIct2KMZ/bv22BZ/acT1afVqmkqmgywbQDXACFy/+HpMCJGmdzHvG8qimQ3ZbpXje6wEQbNsw+f1+LoCKiystdfYZOXtNDvYQ/mR7JcYALFd97SHYfYwDde2wdCNVbHh/6g5BULtNpk2JxNqWKcpC2h8Tsxl34SYMhhDIzj35/fIJevPF/jyvJNZdDFF2eGA1BPn9D+UGElgskvIGnFM2jPH0QL3DX3uiBm0Xx6i3YroIGn15qZMqlzdAj6aGH2y3koydQ2B2JnIt8aA1T06xlKYMuaY4JFWH4IotB6SzLaJuXz+EhXlljJ/MD/zHc6JTYdEd85iXAuH9u39XXPAHA5LNbE+h0SH+2Y7na4xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 28, 2026 at 08:15:07PM +0000, Kuniyuki Iwashima wrote:
> The comment for sheaf_capacity says it does not enforce NUMA
> placement, but it's not true since commit 4ec1a08d2031 ("slab:
> allow NUMA restricted allocations to use percpu sheaves").
> 
> Let's update the comment.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> ---

Acked-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

>  include/linux/slab.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 15a60b501b95..7477109eb315 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -359,9 +359,8 @@ struct kmem_cache_args {
>  	 * may replace it with an empty sheaf, unless it's over capacity. In
>  	 * that case a sheaf is bulk freed to slab pages.
>  	 *
> -	 * The sheaves do not enforce NUMA placement of objects, so allocations
> -	 * via kmem_cache_alloc_node() with a node specified other than
> -	 * NUMA_NO_NODE will bypass them.
> +	 * The sheaves try to enforce NUMA placement of objects, but the
> +	 * allocation may fall back to the normal operation.
>  	 *
>  	 * Bulk allocation and free operations also try to use the cpu sheaves
>  	 * and barn, but fallback to using slab pages directly.
> -- 
> 2.53.0.473.g4a7958ca14-goog

