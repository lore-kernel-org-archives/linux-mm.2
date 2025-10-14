Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D82CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 10:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2720C8E00DF; Tue, 14 Oct 2025 06:28:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 249368E000D; Tue, 14 Oct 2025 06:28:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 110DB8E00DF; Tue, 14 Oct 2025 06:28:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEE598E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:28:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A336A140844
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:28:07 +0000 (UTC)
X-FDA: 83996344614.30.C038646
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4855A20008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:28:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gm2MK2Ku;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NyNUnnBw;
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760437684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJuxUrbSRMEd/75rSMe8okGCTGEcTrPAcDa+KlRUI80=;
	b=bxwL3n+G3Se/80BX6tinm9rK6YtJkK4zfuA5bHQUIJNRdoXLHZJy7+VNSNVfHNXvQfMlEe
	OYzO1/1MdsVHWNY51//MFI2vqNoVvNGb7QJ7Ta18+BIkUvXS5FxHKcs7TFknfqDTyCrZdk
	5NWE/IzgFIo0sPyZ/jL05PAyMlVCFsw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=gm2MK2Ku;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=NyNUnnBw;
	spf=pass (imf03.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760437684; a=rsa-sha256;
	cv=pass;
	b=rwyxCa9swXJIjGIJiJWCFA5HDRjcrCOtUTju0U1z0ZzOr1fhe4l5NASqIVQk2dPCRWB/wp
	nLrwwgnDq37AW4sw+yMdHuea8xYqyUgO9m2S/5D9JqSUXOjOzIH10XqnzzVI1mAwJMsqDO
	2NEKr8Ta4HgiEBDqjQnqv2ogV+wr+Fg=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59E9uusq011567;
	Tue, 14 Oct 2025 10:27:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XJuxUrbSRMEd/75rSM
	e8okGCTGEcTrPAcDa+KlRUI80=; b=gm2MK2KuguK2Zud1So0edgwjN82z2jtP9W
	eYGG+Uyoo6CAXa1Wa1gwGEhnkmrI5xDZ1Z+HT0RcguSwOo2DtQolLxNXexR7fSb/
	KjM04JjCSJWq4UHN91x+BTjarv2p/1FvETgUwiSXf7eOZoLLWz0x9REVBkYe8P2R
	UmLIfJFFveHEBc8pe7AJOKILs4xVyt7/esP+HGHC75Fs1aJgV7FmwvILX+lKlYzn
	avUqe1Qml3nVepJPDVOMBPej8vTc6fMTVDQa5eBDcTvrdDjLM0FmY5ufpCTurcWT
	zaVvGsssFgvg9bzNsD/4cK2AqczP/+jDczCnZsDvTTg6gi+ABifw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qdnc41fn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 10:27:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EACldL009793;
	Tue, 14 Oct 2025 10:27:58 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011062.outbound.protection.outlook.com [40.93.194.62])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdperj0s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 10:27:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q78yfvhJccQxYPNlcSNybaDQBk9JqCaPUaQ9mC0VaRY6Y736Irk+sLXRIJ94EOr540+leakDidpoZwYZXM6aGytDNAwJr53mNuNCAUWvvPmg0IFZIkgjfoErXEU6PN7tn9r7uNpv/or5EoHhmrIDDYKmHTlqWwMkJ8+bEr9FUz4udoSI5V4e4rXX5Z3MEgBavLy5ouIBcJnR22j/c9nNXpBTbuOLPd8+Ba7j3AmQQkuDMvcIdFJcD9RoQ5opgURbc++lQFgxXY9AaM8MLdPn3AcA18A0GKIav+21HzH8ECrsyqg/MszKtVn+LwkSd9ZI8gRShuM7+cfA30fs3aWWeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJuxUrbSRMEd/75rSMe8okGCTGEcTrPAcDa+KlRUI80=;
 b=uGv+ZC+rRyajV9b1osER0aKZeLZ8N1rHqDWszIZ8rg24fp5gMBW8xhCjTsVUPtmfswYZFYGA/1IbUpGbx58YRo8uFjJya0cVvuzWVerAogWfZN+WEihKKnqQCAvbt3yYUzRESFY6jsRWiv9NJFp94NXu40oiYsUEj8rDt6/yauYjzZFyMwXhnWeEMo0U8X+7ccKq/aCGFZB9iFrdgSw5E1rbuUOGfjLVlT6F94OqUzB66DDml4BJAqoO7y2a8b+1PvsVdxZX5ZsSGcI5MI0dqWzldVQpT/yeRG2Cdk8Isf8XHtBKAUkhFTNtdJXFjyBdE2yfFg5Fq9DcIgZUh2h31A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJuxUrbSRMEd/75rSMe8okGCTGEcTrPAcDa+KlRUI80=;
 b=NyNUnnBwA1DoLHEHyWI0B1P5tOT8Ktyxo0MXjONz+wRTVZpowlJpIUfgKo0LFf2sHfLXaRRJdQ3cEtcIUsg3WO1K/AknUADa7Dqf69bXqaDfQwbesU8ULMm/Fw3aVNji3SJPTvhQzUnofo0Qgibfdmwhe/E7qwXKyCycHpBuTNA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB4927.namprd10.prod.outlook.com (2603:10b6:5:3a2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Tue, 14 Oct
 2025 10:27:55 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%4]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 10:27:55 +0000
Date: Tue, 14 Oct 2025 19:27:46 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hao Ge <gehao@kylinos.cn>
Subject: Re: [PATCH] slab: Introduce __SECOND_OBJEXT_FLAG for objext_flags
Message-ID: <aO4loolcE5u2gSM0@hyeyoo>
References: <20251014093124.300012-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014093124.300012-1-hao.ge@linux.dev>
X-ClientProxiedBy: SL2P216CA0196.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:19::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB4927:EE_
X-MS-Office365-Filtering-Correlation-Id: be154e45-86e5-4d19-a564-08de0b0c566b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z0+nYi4X/yi5dBEJtGDC7JRlT1oxqWOsKZMTtxouvBCo/oaZ9cVBOU06JRKz?=
 =?us-ascii?Q?yEMRKkFB/DkNUqU7OlcgUzcVZ4g8PT5wDqy7VRfYFSRtaN5sb2b5rXImiP2/?=
 =?us-ascii?Q?5vDkKlo633hNllW3mfVhvTytILXGi6Tp4dyvpEhSyLiZmKzoJT/aOfWrIzTZ?=
 =?us-ascii?Q?kt1pH5Hliec8WM/Gi+Q0/H7sBSdJ/vNBrm0haz45FJGzijhsk/evipNLuZNt?=
 =?us-ascii?Q?4NA+/jK0HLwOiQvSXHk2S13nDRF4tjLK4pkBTVdlVVPtorBP0JmQRNgPrFR+?=
 =?us-ascii?Q?u6vSYViqZUDEsHx8YyUvADbm5kip5gD0dGM+WXClzUmf/gPeSpwbFkyK47xJ?=
 =?us-ascii?Q?VSguy8srw3n3OO72oE5igVy0q9vlcKI8LIH0/lPc6G/Fmw6/YhkuuHyr1qNZ?=
 =?us-ascii?Q?vJo4oFDVk+FVEHzYGGWigbCSeH+G0NTEKojANSyXYB/g7bqDT7GD+UXNAdHM?=
 =?us-ascii?Q?aJn8h0GA0VhzyXM+R8o4R+04noEV4s5hVexbDujw+LiGQnrY6Vgq+tizBW/q?=
 =?us-ascii?Q?Mx2HRv9ExWI4dAADXxVjb0I0Tw38LuCzDuGTVuB8jbvIqOfifQpSyOAZwCfL?=
 =?us-ascii?Q?aGpK8/hVHWK6MwUJqwwuAzpccKmZ97csedyxzURUjVev7uYNENwJv/QStoCE?=
 =?us-ascii?Q?j6UNiXulwJRES3+5O5c0wVa9/LhmunfYBZ4LyWC6/C/HxrhcdcLRSi/UtTPO?=
 =?us-ascii?Q?CF372JACMiGl8VWqn0k7ZuyCISOE1ytk6jCUT+y2QNyYICKbRHEhBtNeGCHj?=
 =?us-ascii?Q?q+JoOEywR9fPECmPhXcblZx00bmaH5SbjkRhwQJZSmEWC4rdlPUZWvC4IuSD?=
 =?us-ascii?Q?lkDlMDO1ZkNivUP1DSZbU/PIQ1drYVnzj22DW597FxEYyUAS5iSBRycqdqeC?=
 =?us-ascii?Q?MW6RrWuUMOrhiCMw0jt3bRncPFKrS9ZTJKeFzYRRSj+jEY9TbowWsXOFnRu6?=
 =?us-ascii?Q?wbM8NCy10gfSo6KgYMI8Cp573FNhFbztIVvad9De6CAd42mh32507aGLS+rm?=
 =?us-ascii?Q?BWErE2Ve9f1LATO+DscYxrvjW+235/o9bwBCnsgvF00jGlhOqfKsw6MV4kk9?=
 =?us-ascii?Q?uo/Mk/2WlYkX9jivAcSxiGN1pR9QCLFzYvPOM6lp7TrQlky4xNhIjWVfI6PK?=
 =?us-ascii?Q?nem8Zdtwwn2bP+IEJzgiY9OcoLmm4NIsNkASCPQmDo4GiZj8goD2OlBDh/m7?=
 =?us-ascii?Q?AI1rbvGuJfkXZdBUChTtrEm2aTsP7ex+2DOV0HnEIZvKHTLmGRj0U+Hhnkgg?=
 =?us-ascii?Q?w8EHIg7wUX15howd9B61SgY2p3wYE0/GijtIAEVvlH7c5CQJeS6mdsb9Vyxt?=
 =?us-ascii?Q?hQicvHckkliO6KuMV+E9kkZoiXDjUe+f+J2cnojDuFB6ZuybbH6OjKS0NBV8?=
 =?us-ascii?Q?FphIv6qQSzIxiz18ZGVrhexLm0cOfQcutwXs/bvZzBR1h4KNOEmY13XNj9lS?=
 =?us-ascii?Q?0R1T1bojPC+i1wCMeMgkL9yyyKa2CD1V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NDJVqDbGdGKsJJIU6QeNe0Zomfct9VNdLjJiLvPD/4ujClXX4kZSLXzB9eGz?=
 =?us-ascii?Q?0WvF6Z3X5thGUEk+E+pKutZYvR6bSTTPbFL+SIEYbkWe+EINLY2DldL6BuXr?=
 =?us-ascii?Q?xYNfT3iVP2r66fZM41IowCtZzfcQpANBc2pzFzGQWorUS5MlNd5X3M0luBf8?=
 =?us-ascii?Q?XgPUttaJn0M2OLMsL18xev23yVUQDyUWHl7aTqxCEhfaX7Yh0113ARUTc3H+?=
 =?us-ascii?Q?bA/lXlT63Zun2eX/LbBRun70T/EFT2u741hpjJRzA6hGcapplii+85xMnljE?=
 =?us-ascii?Q?f+5zsFSbFORikfKQIhv1JoFXMW/V/HAwoyMUbmy+01Nla+rnY8ywqVmB9Psl?=
 =?us-ascii?Q?kXxiZ+yA9kMOf9jasP9CtcLbzk/us+fYYoaPiEA+IAP35SypFXIQVJ8eJycU?=
 =?us-ascii?Q?sKJ18s4TV4AzOo1oSwvkKfc6vvXFunU7dAZrCOroILRgpoibwv89Y7IMxmKI?=
 =?us-ascii?Q?xXad6HolPMX3y+gO6yssmNm1XC4xvu9BMz+5PdnoSGEaHjQGf+8qOPBQzTY1?=
 =?us-ascii?Q?cuTz/hZhiEi4YZxW+YxbWO/DmrHmQc7tsPWSlO9NcmSUfQJpl3gFENcfu/B4?=
 =?us-ascii?Q?3wNVh1utAPd56vg0T0/5R+W8ULhW+2ZAC0qDf2wpTJ47K9foKgNXlujAoiBb?=
 =?us-ascii?Q?C9unzQdnG0mYdJwZuUq0a/M16TvAOgXYtGTfNjyxl2+t/GbB8PA5+z6np7GI?=
 =?us-ascii?Q?NT5KcefB3O7QUSMtw/FSUKDMGnZkYcqoub3EQlyjxHRJoOxjTSu4EidJ3eGc?=
 =?us-ascii?Q?FoT7MKqIXi/X0i6bjgVl2r/Rn/i/HYmFfaiTKTQywK6YAv8FpkgwWlL2TY+f?=
 =?us-ascii?Q?LvPrH4CvJuwsPqePfq6HedJkPCzTAs3O23zosCTxZvwbIEGIpHktxQBcRuLM?=
 =?us-ascii?Q?0YG1N5X3enx26rqOic6ceDTIRA6GYQ+qKbRpTPlRG0pemTEhQsHpzb/nwiAQ?=
 =?us-ascii?Q?OlGCephIxLxLeaK6CrP1taETC4G37mC5tgcfzhdZhWshCR+N5rmUNHBxtzUI?=
 =?us-ascii?Q?wPuz0G/FuUIf70/R2p+G2U9LYnc4lXVCLT9Xa2G+XGLgx6pQdbTfJixL9LOm?=
 =?us-ascii?Q?1WxGmQn4hgmfVdNKd295Uwph7ZMGpCZaaygf7zZpO3m+GO04pMCKMAWhwD+o?=
 =?us-ascii?Q?B6f184rEGCivl+lAtpo/xuCK1jxcSoMcAjTzhbqX/5sBOrqNdhobnqYSI1K4?=
 =?us-ascii?Q?9lKNrj3OYRi6DpGhiMem7JE0KBlQwsdpdW0Y/gRZIVD3C1SnXkOhiwp5cBLy?=
 =?us-ascii?Q?G12S714KHKM/e/bbj1WJunelMB71BntjyDW21zyMETZkhQMfllGv9lxliO/A?=
 =?us-ascii?Q?KBmi8WHp5Gmo43eQWcbS4VmamQLte0HXpG95ss0S8UF0Tz/pazj9Ba+aB5Vr?=
 =?us-ascii?Q?35hFUgAfxBKJ7iucq13AhwGpWrfBrWtzODFR/UWS8XRvU3I/4QAM4bKgZyx3?=
 =?us-ascii?Q?xqGDA+7cHJ7k9HZqS1C7zboPa77BdE4mhHX5QpMohQeeT+62BLsez/hQQhuO?=
 =?us-ascii?Q?ZVfRtKSBk+BjaDNGVkGjOpXm6f8FEdRcgPz6d3YUpbV4r8VF52isLfW4a/xG?=
 =?us-ascii?Q?KBPl7b0AnuzV+Irfzynv20FCk/WdY7AZjpwp2NKb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WHHPjWhtXQFTfgZBIS4CkS2BVlK5TJOCfn4qSTGVuCm4qV29nUOv/34jZ0kkpAiMUGqmIvjm2w+CfaXv2Dvzzbcgdsjk3Au10sMEvIre/rbpqL6ztBbBWHCu/cgS8kOw+Jtuq41z5J44N9RpKWyFVKOtQZtYrc+7KQ2YpV6xYXZpN+hPqvkk1zYetvnX9PKQg54yUDzbTWTpS/FTXUTPe/Wt0Na4J6KuoeWNTdrr/VjBRkBTtTYXJx23WhhadeXNzTP164IpE1a6DoYdq1esMKEkjrE0aYZh+ncHDFwJQZXbIsktCVaJqHDjHKAz0Jw+qa9PybDZeIN+BGW1xsNwtc6iBkbJB6GPIlFyb9l6uKVXqPruIgfDz7o6H6zWNHeClTZ7UMEVYAfrBLGGo9+RXdv/KkWoLU3j/MvtZ3o4L+LNmrgLOrnZUMBC9wrQsL9xjU0nZXInJHRSo3t/Zsc7to3lF6YqQWaK5KUXNs5zNMWwRGRWZco3IWZCb4AWpbl6x3GYgshB5huDDhupHcH16xJ7L2uDg5NnxULaZYli0om9ntcxTnB7zo8x5zR4ZgVQM604j+psVh/ET+q7BMOinbNmENVgjDYput/LZEgQwX0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be154e45-86e5-4d19-a564-08de0b0c566b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 10:27:55.2922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RtJk6WjEzgAnqbn9eNt9Q31oAj/21VdndzBcsBx6a07RVYJD0E0zEuQ6NxJfqyGWgq9hXihUZxWjJAmOJxh3QA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4927
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510140082
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAwNiBTYWx0ZWRfX3Z8wrEdbnfX/
 YUNIM2mxZSq3NCOm+aSXyswUVqAv09ZGFjnAAT1OtAQW+e3c/PUNygiOOjEw+0FCSUB+rur4ZZJ
 YBJaTSYWzjjHPBD1aKRdRyFUV2DKkrji+INcDaSZg816MYRIcmUKpDNYorZYGT+PJDiGiM9J158
 +hqW9Vw2+WoOuDVvebfDUGXo4ge7ENNrZG4dmIAWcQlI6sl4uAHRxLFRalLtAVpMYK8Rq0ji1PX
 JfRqMgRa+ak24KEoWDCUyWSd6c01SPBwEb4JgYZfgO0wi3D08YCz9eQM3ORDHxN0QVtFcB0dsOb
 G5BSl5C2MespvXu7o/xKxiUy/2HknM0/Uh7O2dGIzzLP2wDyJNO+MaX9TuyHk1r2WR2DaHubC0q
 QB0Zfi42I3bbeatcfuGGFso/oJNSsBfVvD5CRG5OBF1ak8X/A8A=
X-Proofpoint-GUID: v7NeCkp9BdVCkAXLfR2A1qL-bn4Rlkvc
X-Authority-Analysis: v=2.4 cv=ReCdyltv c=1 sm=1 tr=0 ts=68ee25af b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=txUcLFOied1NsZmgZ5cA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12092
X-Proofpoint-ORIG-GUID: v7NeCkp9BdVCkAXLfR2A1qL-bn4Rlkvc
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4855A20008
X-Stat-Signature: s6syyrmb6sj6epozqa99y5wbtqudsmtq
X-Rspam-User: 
X-HE-Tag: 1760437684-605129
X-HE-Meta: U2FsdGVkX19HBNNtntxW9k21ABvJIbTFeVgZsTh4xIMQN1H+GRgkLAna4VnehaPqLOExt5H0OYP9lSwWrIPugv0+Pe06QUvMqO+vUINZmg96+8VMbj/ofZxG9vobuIOsDGe13Vw9LcFvB83002e8G+Qr5CBtKIfzfehYiEIDoe59CIB2xWUO0CgwQp9AYNV+SonNbp/dJX7gIHjDLarJvMAswBVdKGXVNrY7kfkUmEY6JglUSG3kT0GhmMtc2hf7GKAKS4MpTys752SUkyHT+9Wy5GRxPTRRdc8ORKxaFpFtZrOAtNs1K1N15Eranb8u+EIb+QPtEywnDg11nrWcN0hGBWp+MnF1lG6oMEk1yIxl45UP6sG+9aQlxeS5WY6rq92klB+VT0UHbWZV1jWaZUr2q9NYNBYP5yVrbxOhO9ISyknzyoiws1nobcNqzsBFUX8co554sVeKSpnQbPDlzRym4m6jCRUtet/hn6lKZ66FdPa39g3Cadi/IfriSx4l1UIpwQCvezvpmZ0RgfSqNsfEkOBtrETB8+0uEowOuEWjgKr9RI1HLPzXMFjs4y1Sdr8mIyMbYclV/eICyUss9NsVCfP5s4Erm30XopBu5V7XTDWz9YVXrtH28qCchxJHmO96HAY6CxaUzFHCDg7W++A3NLJlwEHhqqv+JY9vDrWgHXTn3UtITSYSzT16clYbcSbjucufnNhV5HUv9Twi02lbePLH8VITfVXzKWhghvWqLVI8EWmKdMXdCKIBauEfoc6hDH+EBnGB9bx707hV6fIBvY7yl8lxn/Iqh45JQklg/R9JBMs+wSoGe6QEuSh5rgnTVNEuzOzSTDooE65dsd7R+TEtysXnhjZiMgLN3V4iRZnwwM6svvhlYzKJIp4l4jIBEovg0C6cXcJMbU3e6dFEiyZZhHPB9RVO+pxihpaySkvjV3C4Wo6zn0HEXRZCY5htz9Zn5OkmH6zYJUv
 NTnCgIC3
 o18GAGoQb8fjr6qZRJE/EJtt4VS4hC2X8r62BUP/ChqqhiUwZ2YQE2j+0otnhtfWwSPXXPaCzPTHkfzyZKFWwr37Bki1jGgwHFh9Lqmy2/4sf5BfVFBEhQwWkLhJOpmtPqIhZiZE1FVr69pR5Axyc8DfXCTropYJyiO7YYUg1gWE3U1p59jM/o6CmUci377Cxo75RhW7Pv8Xv8i1i8y1sWMOmK069N/BqfoefTWr97aApgsJ3JySbTEqsT5FJo00SiefOqg/5JAe6lRvRHeI6uxzCSrZRMDJRFdLNx2zTr0eyKc5g70l1Wd0mhLh40fYzHtylu4jXyihWtr3OIryGDsS4au7Vt2pt1atdSwbf17zrNle7iFx5bBo/Z9tkgpgwSSpKfFb1Ta8c3OqWvjuZ+rzy+esdvIqVKvgvIO/7HZNU5aMvOkgY0sFpfVfESjuAT+W4TDktnPzZBwhMNcb9nN8ALHWuUHXHgsCgf/FKDIz+r7udn65hzE5LZROKeaLb8Ng5HfEziBPcfM6ceFAm6RLOtAX7vyecHdiEofFsG0hL0OJAmuoDiek898hu16ztSXBJRWa1Qu4C0TaD0K+hwWj12BWRhd3XoOYBpqy1K5C3xqNR7r30FBVGeN8/Lg9DUokk5znIjTu2+mpJvpt5biZ9H1Ue0GwjlBxMnxG6FaCuq14Wco/Iobs4GgcT1MyNUKRpIqjy9CSC9K4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 05:31:24PM +0800, Hao Ge wrote:
> From: Hao Ge <gehao@kylinos.cn>
> 
> We should not reuse the first bit for OBJEXTS_ALLOC_FAIL.
> This is because the following scenarios may be encountered:
> 
> Under heavy system load, certain sequences of events can trigger the

Hi Hao, thanks for catching it!

It's late at night and my brain is tired so I may be missing something,
but let me leave comment anyway...

> VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio) check:

Should we check (folio->memcg_data != OBJEXTS_ALLOC_FAIL) &&
(folio->memcg_data & MEMCG_DATA_OBJEXTS) instead then?

Not clearing a valid folio->memcg_data is considered an error, but freeing a
folio that is marked OBJEXTS_ALLOC_FAIL isn't.

> 1. High system pressure may cause objext allocation failure for a slab.
> 2. When objext allocation fails, slab->obj_exts is set to
>    OBJEXTS_ALLOC_FAIL (value 1).
> 3. Later, this slab may enter the release process.
> 4. During release of the associated folio, the existing
>    VM_BUG_ON_FOLIO check validates folio->memcg_data.
>    If the MEMCG_DATA_OBJEXTS bit is unexpectedly
>    set here, the bug check gets triggered.
>
> We have obtained the following logs:
> [ 7108.343437] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff0002deb97600 pfn:0x31eb96
> [ 7108.343482] head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> [ 7108.343500] memcg:1
> [ 7108.343507] flags: 0x17ffff800000040(head|node=0|zone=2|lastcpupid=0xfffff)
> [ 7108.343523] raw: 017ffff800000040 ffff0000c000cac0 dead000000000100 0000000000000000
> [ 7108.343528] raw: ffff0002deb97600 0000000000240000 00000000ffffffff 0000000000000001
> [ 7108.343534] head: 017ffff800000040 ffff0000c000cac0 dead000000000100 0000000000000000
> [ 7108.343539] head: ffff0002deb97600 0000000000240000 00000000ffffffff 0000000000000001
> [ 7108.343562] head: 017ffff800000001 fffffdffcb7ae581 00000000ffffffff 00000000ffffffff
> [ 7108.343569] head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
> [ 7108.343574] page dumped because: VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS)
> [ 7108.343601] ------------[ cut here ]------------
> [ 7108.343607] kernel BUG at ./include/linux/memcontrol.h:537!
> [ 7108.343617] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [ 7108.345751] Modules linked in: squashfs isofs vhost_vsock vhost_net vmw_vsock_virtio_transport_common vfio_iommu_type1 vhost vfio vsock vhost_iotlb iommufd tap binfmt_misc nfsv3 nfs_acl nfs lockd grace netfs tls rds dns_resolver tun brd overlay ntfs3 exfat btrfs blake2b_generic xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_tunnel nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables rfkill ip_set sunrpc vfat fat joydev sg sch_fq_codel nfnetlink virtio_gpu drm_client_lib virtio_dma_buf drm_shmem_helper sr_mod drm_kms_helper cdrom drm ghash_ce virtio_net virtio_scsi backlight virtio_console virtio_blk net_failover failover virtio_mmio dm_mirror dm_region_hash dm_log dm_multipath dm_mod fuse i2c_dev virtio_pci virtio_pci_legacy_dev virtio_pci_modern_dev virtio virtio_ring autofs4 aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
> [ 7108.355662] CPU: 7 UID: 0 PID: 4470 Comm: kylin-process-m Kdump: loaded Not tainted 6.18.0-rc1-dirty #54 PREEMPT(voluntary)
> [ 7108.356864] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
> [ 7108.357621] pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [ 7108.358981] pc : __free_frozen_pages+0xf18/0x18e8
> [ 7108.359834] lr : __free_frozen_pages+0xf18/0x18e8
> [ 7108.360379] sp : ffff8000a2bb7580
> [ 7108.360786] x29: ffff8000a2bb7580 x28: fffffdffcb7ae580 x27: fffffdffcb7ae580
> [ 7108.362013] x26: fffffdffcb7ae588 x25: 1fffffbff96f5cb1 x24: 1fffffbff96f5cb0
> [ 7108.362804] x23: ffff8000839d6ba0 x22: ffff8000839d6000 x21: 0000000000000000
> [ 7108.363596] x20: 0000000000000000 x19: 0000000000000001 x18: 0000000000000000
> [ 7108.364393] x17: 445f47434d454d20 x16: 2620617461645f67 x15: 636d656d3e2d6f69
> [ 7108.365498] x14: 6c6f66284f494c4f x13: 0000000000000001 x12: ffff600063fece93
> [ 7108.366317] x11: 1fffe00063fece92 x10: ffff600063fece92 x9 : dfff800000000000
> [ 7108.367610] x8 : 00009fff9c01316e x7 : ffff00031ff67493 x6 : 0000000000000001
> [ 7108.368455] x5 : ffff00031ff67490 x4 : ffff600063fece93 x3 : 0000000000000000
> [ 7108.369276] x2 : 0000000000000000 x1 : ffff000103fe5d40 x0 : 000000000000004c
> [ 7108.370140] Call trace:
> [ 7108.370463]  __free_frozen_pages+0xf18/0x18e8 (P)
> [ 7108.371011]  free_frozen_pages+0x1c/0x30
> [ 7108.372040]  __free_slab+0xd0/0x250
> [ 7108.372471]  free_slab+0x38/0x118
> [ 7108.372882]  free_to_partial_list+0x1d4/0x340
> [ 7108.373813]  __slab_free+0x24c/0x348
> [ 7108.374253]  ___cache_free+0xf0/0x110
> [ 7108.374699]  qlist_free_all+0x78/0x130
> [ 7108.375156]  kasan_quarantine_reduce+0x114/0x148
> [ 7108.375695]  __kasan_slab_alloc+0x7c/0xb0
> [ 7108.376668]  kmem_cache_alloc_noprof+0x164/0x5c8
> [ 7108.377206]  __alloc_object+0x44/0x1f8
> [ 7108.377659]  __create_object+0x34/0xc8
> [ 7108.378196]  kmemleak_alloc+0xb8/0xd8
> [ 7108.378644]  kmem_cache_alloc_noprof+0x368/0x5c8
> [ 7108.379224]  getname_flags.part.0+0xa4/0x610
> [ 7108.379733]  getname_flags+0x80/0xd8
> [ 7108.380169]  do_sys_openat2+0xb4/0x178
> [ 7108.380921]  __arm64_sys_openat+0x134/0x1d0
> [ 7108.381952]  invoke_syscall+0xd4/0x258
> [ 7108.382408]  el0_svc_common.constprop.0+0xb4/0x240
> [ 7108.382965]  do_el0_svc+0x48/0x68
> [ 7108.383375]  el0_svc+0x40/0xe0
> [ 7108.383757]  el0t_64_sync_handler+0xa0/0xe8
> [ 7108.384465]  el0t_64_sync+0x1ac/0x1b0
> [ 7108.385284] Code: 91398021 aa1b03e0 91138021 97fd35e3 (d4210000)
> [ 7108.386553] SMP: stopping secondary CPUs
> [ 7108.389714] Starting crashdump kernel...
> [ 7108.390190] Bye!
> 
> So, introduce __SECOND_OBJEXT_FLAG for objext_flags, adjust
> the corresponding order accordingly, and ensure that OBJEXTS_ALLOC_FAIL
> is no longer reused.
>
> Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")

Hmm using a new bit was suggested at that time, but that would
require bumping up the alignment when allocating slabobj_ext array?
(see alloc_slab_obj_exts())

And we can still distinguish two cases where

1) MEMCG_DATA_OBJEXTS is set, but upper bits are not set,
   so it should mean obj_exts allocation failed (OBJEXTS_ALLOC_FAIL),
   thus do not report error, or

2) MEMCG_DATA_OBJEXTS is set, and upper bits are also set, so someone
   did not clear a valid folio->memcg_data before freeing the folio
   (report error).

without introducing a new bit, right?

> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> ---
>  include/linux/memcontrol.h | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 873e510d6f8d..8ea023944fac 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -341,27 +341,23 @@ enum page_memcg_data_flags {
>  	__NR_MEMCG_DATA_FLAGS  = (1UL << 2),
>  };
>  
> -#define __OBJEXTS_ALLOC_FAIL	MEMCG_DATA_OBJEXTS
>  #define __FIRST_OBJEXT_FLAG	__NR_MEMCG_DATA_FLAGS
> +#define __SECOND_OBJEXT_FLAG    (__FIRST_OBJEXT_FLAG << 1)
>  
>  #else /* CONFIG_MEMCG */
>  
> -#define __OBJEXTS_ALLOC_FAIL	(1UL << 0)
>  #define __FIRST_OBJEXT_FLAG	(1UL << 0)
> +#define __SECOND_OBJEXT_FLAG	(1UL << 0)
>  
>  #endif /* CONFIG_MEMCG */
>  
>  enum objext_flags {
> -	/*
> -	 * Use bit 0 with zero other bits to signal that slabobj_ext vector
> -	 * failed to allocate. The same bit 0 with valid upper bits means
> -	 * MEMCG_DATA_OBJEXTS.
> -	 */
> -	OBJEXTS_ALLOC_FAIL = __OBJEXTS_ALLOC_FAIL,
> +	/* slabobj_ext vector failed to allocate */
> +	OBJEXTS_ALLOC_FAIL = __FIRST_OBJEXT_FLAG,
>  	/* slabobj_ext vector allocated with kmalloc_nolock() */
> -	OBJEXTS_NOSPIN_ALLOC = __FIRST_OBJEXT_FLAG,
> +	OBJEXTS_NOSPIN_ALLOC = __SECOND_OBJEXT_FLAG,
>  	/* the next bit after the last actual flag */
> -	__NR_OBJEXTS_FLAGS  = (__FIRST_OBJEXT_FLAG << 1),
> +	__NR_OBJEXTS_FLAGS  = (__SECOND_OBJEXT_FLAG << 1),
>  };
>  
>  #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
> -- 
> 2.25.1
> 

-- 
Cheers,
Harry / Hyeonggon

