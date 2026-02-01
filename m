Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FDCE7C6FA
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 03:39:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B77BE6B0005; Sat, 31 Jan 2026 22:39:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25A26B0089; Sat, 31 Jan 2026 22:39:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD256B008A; Sat, 31 Jan 2026 22:39:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A5016B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 22:39:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B05A08C734
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 03:39:53 +0000 (UTC)
X-FDA: 84394483866.21.51A2A25
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012025.outbound.protection.outlook.com [40.107.200.25])
	by imf18.hostedemail.com (Postfix) with ESMTP id BB9C01C0009
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 03:39:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fbbS6wk7;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769917191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kALlBuIcTaA75hrPIwfgEn/gYjSO8L3kht/E+eK9s5U=;
	b=I/5UT7V6oj077Oi54K0AXDN+rg7vvzhPdpZ84wjtFMFIhNfgdz4uK5KwqAtFrRTD7ybW1t
	yV+dXiTDMwT+yWJRjrZexOx7QUA4xyRK17RAygnNYKIGdTqLduW8EZFjRZf/ay/CdqbGLH
	mY+JkkgwZQHC5KjfhbIUUbPYlVc0eq8=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=fbbS6wk7;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769917191; a=rsa-sha256;
	cv=pass;
	b=fgMQ6/D5vOFpFpx2G6vomfCvNdcWrRshfg82E4u8swqtja7UGGq65fpn+DXX59cRPB80Vs
	tPezghh1c4XsB1oCy1XvKJGQ2FS/IqjzZrR0hXKiehTOyTFl2nuziSnCk11zKmCbtZk6Iv
	m9UBjBTZVXYdK45pYpmfZzhTCXO6b3M=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zArnZCiSIg8lTqZvm1zagMlQ0qSSPzJtVHne21TH+rFkDbr/7nnWScLYe0YCja7JyDzDhODr3SItc7R0lQJsD7aIp3WrCCnsPZK8Y4O3qWKL6ACiqPkZCwBMF7DwWjbfbuUv4sRngheLptxFd2iD6PpvgVzFo1tVVXma5gGPY+ApGZV/nuZhgNOYoN2TOV7g+xyFh7vsMb9fvaWxz9WZq3+kvNlxWn4ygZd+PgFGCogiWH84Ets170blhFd/g45iTLRJdaDMJ9w5/sZ9V30++t7uBMKbw6YE3+CkS3CXbCj7O/dKuY4utGfZmira+WNJWPH9rAZROEPmtEpRrGKilw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kALlBuIcTaA75hrPIwfgEn/gYjSO8L3kht/E+eK9s5U=;
 b=BVllS+kS5mjYrMgBAN3T3kp8hs3iLD82qJFuO619qMWM7dmO1Srhj4NXCQArooE4nxVHfEb1q3EgLA2SsPu90p9mKtvrHrfd9eAD1tVtgPr3zIMuXB4y99YAmtUuDdf5DkoWAP+ZmMRRx1lLeBU7pxpN4i84t6265k1cZxFyGRZX4wLOo68kq+iJqwVyweGlM0O9jm8sDv4OqhzPrXM6e+0pxthe1UkyyCTtIoywvmOT8SqE4begwwn/525ylp1WHUnSWeRFVcE1cVINHyboieLCLOoqO6Z/tdQPFmF/VxMnvlcNoQ8RBGlY4JFpeQBL+8YWkyEJaoYZMLSzaRJBLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kALlBuIcTaA75hrPIwfgEn/gYjSO8L3kht/E+eK9s5U=;
 b=fbbS6wk7jfI6yGl7S9AeUm1HLehOHHTM2mCC4n5+BW4VDMplhrg2aqCodsfut3SiHqUFdFGDPqpXb5pOeEkyszYC3Er3HQ2AZFmytL4Ve0JVOZGp5AMdiVRH9/08Hcqf/5kq5hfegikcqLjOBTnZAIpZXs2pCw0HJod4xvpY7v5nDqeCY2Q4orombWhAOY7DCSGpQO06hhT40otPjGB8HWtH9HiPbUkO9Br89OzuKXdmuh2mvSSNukv1LYoJ5DB1H/QzbsVVvdY9auJ3JkxXKc3keiXPCBTWDamva/KQDK5omP6CzzW2y+X/+Ibeo8Hv9PdSsLQKVfPWlXWeLYJUUQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH3PR12MB9097.namprd12.prod.outlook.com (2603:10b6:610:1a6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.15; Sun, 1 Feb 2026 03:39:42 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.010; Sun, 1 Feb 2026
 03:39:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, gavinguo@igalia.com, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when
 split huge pmd for shared thp
Date: Sat, 31 Jan 2026 22:39:40 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <C620202F-685A-4B9E-B51B-078EBE5BF0C4@nvidia.com>
In-Reply-To: <20260201020950.p6aygkkiy4hxbi5r@master>
References: <20260130230058.11471-1-richard.weiyang@gmail.com>
 <178ADAB8-50AB-452F-B25F-6E145DEAA44C@nvidia.com>
 <20260201020950.p6aygkkiy4hxbi5r@master>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0076.namprd03.prod.outlook.com
 (2603:10b6:208:329::21) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH3PR12MB9097:EE_
X-MS-Office365-Filtering-Correlation-Id: f0a04882-460f-414e-b28b-08de61438938
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n1W5QtPdmHPu8s+T0dMMIcMJA0Wuhp0afDyWvheudsnv4/Dll7KIoliZsWhq?=
 =?us-ascii?Q?WtfglnSHI2bR3ftrTl1kroaCe1Q1A6M3ouXp4fZX2FIpKs+S4MaxTOCMSYDr?=
 =?us-ascii?Q?q4ktpF0IqYAv3SumGswS7oiMnLSQ7dDCWDzH5cpLKFl/WiBjx66ZIFEdDHY7?=
 =?us-ascii?Q?J8Rd9BK3fFVDpZ4g8JqjJIb5X5JtkUwoh/eJIXIcSWoO8Du/ARgkRIYFGJ4Y?=
 =?us-ascii?Q?NjGBErdQUcIsAsn9cvy5XmELWt+lXlHlRWLLqL5abhuNWDddjylSLZB5PU2U?=
 =?us-ascii?Q?s89Aogy2zwXpLHIq99s+uhDaJSIQiYNmUYJSFDrUNZ2FoQ9b/28TYU01xjuD?=
 =?us-ascii?Q?l1s0sWnscopd9C0yl6sM+n3SNjyC8suz05q1t9dy1M72rjVBZlbNcoKCq0CA?=
 =?us-ascii?Q?RURFkzef0hbr4ERivI4OVpmngfus4yXWEPD0eBlhQVREa4tTxn49asRB4ttn?=
 =?us-ascii?Q?8RTs7dEqsGPdU3Y65PmCn76JYHyTGib4BhcWdKlRej+Y6nMFLOo365wHvSOm?=
 =?us-ascii?Q?w68SnnPtww4l+JrM0nMwOAT9vpastZDU/tiWK7Auwbmn/3EIcN5ZnvyKAl9h?=
 =?us-ascii?Q?1elSOvSfpDu+1h/ZgRl5avF9xgCEBx9NX4lI10hPxcNnpBpb7CaYQgoLSJQy?=
 =?us-ascii?Q?WD2IWRpuFAnruKPrcV+PHVn+8JqFzsGbYyrbKtkcNAAY8KA8BGSHoeo0TWi9?=
 =?us-ascii?Q?DG4hCdcCwQzpEFZvAKLTQMoqMT//WduYwInNwLCIT2CHQcK1pJEqenn9LXow?=
 =?us-ascii?Q?zsi0jtEUkXwnDOSJDbFBSCCXLBj1Wsy1/is5uXvc/qrhYVcoXiney1ppc1j/?=
 =?us-ascii?Q?kW3TKCSZiamz3tNvpDxLXtDbSFNCRZ/hXcCFQdjl/ipaJ8rGxcxZzgncXdZY?=
 =?us-ascii?Q?nLxNMHqD77MVW972Xg4lj8PJAbDRZx3ZoA7LGJUJ4PvaAvsRs29P2QNkV6z0?=
 =?us-ascii?Q?4mMf5VT0GrHRk+AgEcm7KydQG3ROeDoYj1aydxDw2UDDoUIPn260zVguaRbR?=
 =?us-ascii?Q?Z/En5eUSqkhxx56aGBTHdLcvDBee/afnOiHYH9aWluJnNtugMG02Ky2EZ83q?=
 =?us-ascii?Q?QaAlAFL2A1jxtXK8ZVP/5xqYwJrIVFlZGGSl2MzLvOHfj2zFKiMkCqRHX1hP?=
 =?us-ascii?Q?sP/wakRYRiQ86iy5ywAQzMv19YakIjLrPjbT8AH8u7KBun8F4Qmf3sdKAXyd?=
 =?us-ascii?Q?O0hfa5qEWdX3LJJ6EVUQzuWfRFPEk1zsW6DdsC5co+jST1Yy0F96GzEvwaKO?=
 =?us-ascii?Q?YnP47TRw3VzxMYceoP/hM5m1Yo44vJBhch58iQliAejsEOQ0xqkcDjQha7av?=
 =?us-ascii?Q?PlaBUpKPNFJNuOEs2b6NjGk057/2cpkey0pZpIwj0NuxglJGub+eTO5YF4qG?=
 =?us-ascii?Q?lBr5ZfH60OPzn4YW0I1Fsa5++Zf6N/MMZJ0ZpeqfVIYTn0aQPruK1ZM0rVDE?=
 =?us-ascii?Q?TpE62T5YpeZWQLO8fAUmu4IjzkUY3yvF9RChk0ZKvHTeaJ0VBhWxc0NfD+iX?=
 =?us-ascii?Q?rRMusxX4ZsOfE6vCr0IKgAJVEn1YfDBK89w1b0yB7gJhFTQ4X8187mZMkkBI?=
 =?us-ascii?Q?ETqhusi0MWVcbVcRtPo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dZJgwNB01NSplWqCmsGI4aysMnIX/lRIMvP4/CqjZ5MUduhwtyBtqo3UCHve?=
 =?us-ascii?Q?7nw36pSM6AoG6/bbzimvPC+E8ASiBqGn60ocnYGCVYAXxW/nmjLQBmspZ39G?=
 =?us-ascii?Q?+Z8r9NaPSrrrIGZiHk+TXeIoRuMLSVbYO51Nd2VUaflYTKenCO1GXEs6rm8K?=
 =?us-ascii?Q?fta9MtaecGw3i50wrQH1U4ear5qiYQkaDq6uBZ9uPpTMyKOAyzB4VOf28KUf?=
 =?us-ascii?Q?RM5aAKofHwWI07r/LJ0ZJCp6xmcRfA//ov89Q90AR0j6kdD8nAbbYSjYiuZ0?=
 =?us-ascii?Q?Khlbj2vHXBdPlRiaRZNHdTuq/dCI/eUubyNvVqF+82CsiQtdOBf4/fPaIC5Z?=
 =?us-ascii?Q?Cgd8ap1wlEo3lv82ivPJME3v/NLl5tLFoTtEX72/BkomGXo29WFBdy2/exUC?=
 =?us-ascii?Q?X4FxnA2JGrp6/jw42ARwwP9+TStnAl8+qmoatQMTgavXMr9mtQrZTLDXDS4k?=
 =?us-ascii?Q?0YizLNE987pmIfNGq3SUO0bVPBo4c79EpqXntHyER17PDpX620Mt3PJXrTJX?=
 =?us-ascii?Q?YW7IHZG2n8CxqrV+PGl4bEykXqsibxspDpBckZdR8B7f8rKrm85TIxzl3T67?=
 =?us-ascii?Q?G0quXqllBsG9gwmkKwXeqIo774xDV9aEaLtjI2BW8PdnVW7n6LkqLvKsVxxQ?=
 =?us-ascii?Q?r8dCrH2nn/BeJ1qx1Krzey+xmWKPR6bc+WH5gz4OFXyKu9Ea+9AFYzjgVFiQ?=
 =?us-ascii?Q?tFiO2MEfCuwulyUsYUlxMj32BsTnNkyCNkHXSdkL89JVygyW5zRmYWv8jFIb?=
 =?us-ascii?Q?dSFGyLTYTaHdCxHznJLbw8pFWoeowSU+0R41H8I7rhtnc+3QDbDtFuK6IIwy?=
 =?us-ascii?Q?DYqm8g8ezX49pi041BDpOeQnoePNFO4r+X7eJYiabVS6q15UGtlEN/ThqwI3?=
 =?us-ascii?Q?LgDKUGoSw3JrpNFUJuBJrAG2a4PQaHBA5KlIWTVDVMjFL6LUDzarZFIgSWXF?=
 =?us-ascii?Q?glfA+WkqoEks6OcOp7dXjI2kI00D3tGmK1QtSgm7GzwlKJ3HWk4rnBX+IxIC?=
 =?us-ascii?Q?QyYLVzDtXdlqZ0f5ksLXx6/cIY90EWiipAiCLzKDiU/beBEbyD72MYSPjzCX?=
 =?us-ascii?Q?7mX1cTXo4TPI0rc961g3Kk+VK0LVILgEPwYcqwzJAq4Qd9PoEa45AJHwyFK7?=
 =?us-ascii?Q?ifQMVOvZbpv/3ssohOUDB+MCICDW7heljh+/DuThHWdu/ABMynKk/tr3U8BH?=
 =?us-ascii?Q?yJEUvRJs5YF6NE2CoAg/y3+pSjxJLU6H9v6zr0wW6riYsAr/RRzDGt/PYfZM?=
 =?us-ascii?Q?zhIsxwajwDtB3l88IX6JTgS2iOWgvjSHqvLAJDh9R3jEYR7mNWVkHcFipt3b?=
 =?us-ascii?Q?sBNE2JaIf/Fd2WR2kYbe2Has5WF/cSE1ZHS4/Lyo+9xsq3/BwKr7b41wH+D3?=
 =?us-ascii?Q?3mvHoekrDwenwkCwxWbs4D5NYXpWLYBl+inyKN/o/+sWy6r64LzlYiodbJD8?=
 =?us-ascii?Q?OPSMWVBaCoIDeqkAKYuLgBjWoHEMai9RDRVpMB9eBk4Ppk4jYZKfFg7HpHFL?=
 =?us-ascii?Q?9IOhonhHng/AesPvClwcLNpZgaBqfwcylr45sFY11aeoOWXEL6yXskvgas/6?=
 =?us-ascii?Q?16zBVL5ryIneUM9mROieIxMaobxgKxYgMzHIYy5GDVCfGynyra8HJ0/YY3xQ?=
 =?us-ascii?Q?7+4sPiRxpL7mlYswgoY4MTeIdlBGFnrsRIehExF6vP9tTqXml/wjKBTCamaV?=
 =?us-ascii?Q?3NIiXRY0CKe6W3VhTgySVHQNiQ0IhuVnB/UL7NQamfh7sH63?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0a04882-460f-414e-b28b-08de61438938
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2026 03:39:42.7224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sNmxlaftx3pECG+355O4VW5m41Y4uHZVouKmoq1At/O0IPqem1jr7bwOGcHy6gts
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9097
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BB9C01C0009
X-Stat-Signature: iokcrypg9bj3z9kyzja6eszrfedchocj
X-Rspam-User: 
X-HE-Tag: 1769917190-360544
X-HE-Meta: U2FsdGVkX1/SFg9rtBOUBPsyyqwHy31Fr2OjGr5hJzZ3dXoA51zuGyRTsICIWTxtHOlc1u0sJmKZRP8bB9ekWkMkGc2CGPTIpldQCutqmWTcdfllm/6upUyV1MgwmvnW23S1sdk0qz98ASCiAGApcEIy4ofBfPAKIOfvNgateOB2lhq/2ktYvmeNVpp+I1FICoChYP7OLDpWtwHyNjINu1N6BvjGpho/u2X1M3mn7Ih1byQftrFEBxm2Wrv3DdwfcCmsnfe8Op7MQ0waTbtNcp3CsMwoxm2ELv3Vg75L0xrWLckkV2wGHSpnh+AyDazQir2XBshmbIzymf4fnI8K1lOF/9KmzSQKmLo/6B72XxkeM9fj1NN68uuUBjbozxVE+oRN/XPJIvXdxshM34YOOeJGLttqupA/hGNqW6oHIUg1HkbHm9X/zSeMqeMsrTtPWMwgIAwHWpF3oOBIKnRDntzi40KT0Rk57FSz48i1z22CjC0YN15sGJGnE9hNIP6dRuLnqVMKF0PZRPSUVI6BUNxXAXtzDK/4jARf9zsnJkXl+uZ3TicE3ddZ2ZlJHxncJGQ1RisJDZlAb48S4OY64lOV5ZUBvICEJ0RFimwTDUoQFYdcb13EMuqYHZcuAhiii/EANX5ZxNyxuQ4sLOnRG/p781/fVIMQVnW0LXa2LCI3MPnHIHnng+uTCfsZLV4WhVfrQeKpa3lEPc8Q+aFS7gsR4Gun49LWNvg42A6aYSWOhjxzcwo13awP+PDVtI5EXhgonr3lzpdh8ZhXPI+VEvWBEqDvaWhCxczj/c0izC1gHmS06ex3lAezaAoenQbJhD2TOWLvlZ3acA1EfPDM9cNhfOaJEhBIXWRedirow314y9nq/CniUKLMcOWNAdAQuQEdUWy6/CIAEUQF1EPz7n8PIVFE2uqjmG3vED8WJXLJoqE9jNTeAHLhI1dVX/6KNwo2MW2ck40XFs1c9Ix
 8urFtB72
 4j4cv/U+cPxRxpMKpavvsjZ6YicCT9UYKy3A/TrNra3qtBLzW1+Bti/f+VrtCtcdkhz2b2tY2O/dYNRALNlMrFRY317uh/Z83MxkNTynjZyBC53LvOIcCmN9pcVFNW1BQfRmHLHQFP5RCADqsSXOzxestdAlIt1YMdjzRm1Xpx91RuyltkfyBIMh867VLcANyN0L/tg11uFI9hMkA21WpWyaBlnF2p4LOxZyGXSQFxNGtWRzGlKnBCHviP2m4/yJqf8NtIW8cd3PioRjeSoVFAEWe+0pSUgR7fCGqguwBMmbZAaWmhCPOa0QM7lVhGNG+sHqZC9d+fFuNg0nZWh6KlalicI+pDI2qs47yupEKiN8Mu99tiK2Y9x1rOHsoxbDN+0fHTZslCgnwiUu4hf3zW4YBBirFsijthpV1XLmkIb7hFQvXll5njYV47jNyKXr73idnqeIF7uzzsymMFLGZpTwFoMordGIkNDJigOBumUpTGni2sxcIYSWyv5+Robu2ZoVVX+TXNi20oTmCAZmV+rr9wG/lbGI54TXI3ciSwBpoiTPCQ9AZp4AD0wmFEs2B0Kmn7QuxjWgwLJ4OgrJKD1IdMXbfgu1J4ZZUYX5CNHcae5H/uD8/ik9FPVcj7CQKSewt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Jan 2026, at 21:09, Wei Yang wrote:

> On Fri, Jan 30, 2026 at 09:44:10PM -0500, Zi Yan wrote:
>> On 30 Jan 2026, at 18:00, Wei Yang wrote:
>>
>>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and=

>>> split_huge_pmd_locked()") return false unconditionally after
>>> split_huge_pmd_locked() which may fail early during try_to_migrate() =
for
>>> shared thp. This will lead to unexpected folio split failure.
>>>
>>> One way to reproduce:
>>>
>>>     Create an anonymous thp range and fork 512 children, so we have a=

>>>     thp shared mapped in 513 processes. Then trigger folio split with=

>>>     /sys/kernel/debug/split_huge_pages debugfs to split the thp folio=
 to
>>>     order 0.
>>>
>>> Without the above commit, we can successfully split to order 0.
>>> With the above commit, the folio is still a large folio.
>>>
>>> The reason is the above commit return false after split pmd
>>> unconditionally in the first process and break try_to_migrate().
>>
>> The reasoning looks good to me.
>>
>>>
>>> The tricky thing in above reproduce method is current debugfs interfa=
ce
>>> leverage function split_huge_pages_pid(), which will iterate the whol=
e
>>> pmd range and do folio split on each base page address. This means it=

>>> will try 512 times, and each time split one pmd from pmd mapped to pt=
e
>>> mapped thp. If there are less than 512 shared mapped process,
>>> the folio is still split successfully at last. But in real world, we
>>> usually try it for once.
>>>
>>> This patch fixes this by removing the unconditional false return afte=
r
>>> split_huge_pmd_locked(). Later, we may introduce a true fail early if=

>>> split_huge_pmd_locked() does fail.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and=
 split_huge_pmd_locked()")
>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>  mm/rmap.c | 1 -
>>>  1 file changed, 1 deletion(-)
>>>
>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>> index 618df3385c8b..eed971568d65 100644
>>> --- a/mm/rmap.c
>>> +++ b/mm/rmap.c
>>> @@ -2448,7 +2448,6 @@ static bool try_to_migrate_one(struct folio *fo=
lio, struct vm_area_struct *vma,
>>>  			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>  				split_huge_pmd_locked(vma, pvmw.address,
>>>  						      pvmw.pmd, true);
>>> -				ret =3D false;
>>>  				page_vma_mapped_walk_done(&pvmw);
>>>  				break;
>>>  			}
>>
>> How about the patch below? It matches the pattern of set_pmd_migration=
_entry() below.
>> Basically, continue if the operation is successful, break otherwise.
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 618df3385c8b..83cc9d98533e 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2448,9 +2448,7 @@ static bool try_to_migrate_one(struct folio *fol=
io, struct vm_area_struct *vma,
>> 			if (flags & TTU_SPLIT_HUGE_PMD) {
>> 				split_huge_pmd_locked(vma, pvmw.address,
>> 						      pvmw.pmd, true);
>> -				ret =3D false;
>> -				page_vma_mapped_walk_done(&pvmw);
>> -				break;
>> +				continue;
>> 			}
>
> Per my understanding if @freeze is trur, split_huge_pmd_locked() may "f=
ail" as
> the comment says:
>
> 		 * Without "freeze", we'll simply split the PMD, propagating the
> 		 * PageAnonExclusive() flag for each PTE by setting it for
> 		 * each subpage -- no need to (temporarily) clear.
> 		 *
> 		 * With "freeze" we want to replace mapped pages by
> 		 * migration entries right away. This is only possible if we
> 		 * managed to clear PageAnonExclusive() -- see
> 		 * set_pmd_migration_entry().
> 		 *
> 		 * In case we cannot clear PageAnonExclusive(), split the PMD
> 		 * only and let try_to_migrate_one() fail later.
>
> While currently we don't return the status of split_huge_pmd_locked() t=
o
> indicate whether it does replaced PMD with migration entries successful=
ly. So
> we are not sure this operation succeed.

This is the right reasoning. This means to properly handle it, split_huge=
_pmd_locked()
needs to return whether it inserts migration entries or not when freeze i=
s true.

>
> Another difference from set_pmd_migration_entry() is split_huge_pmd_loc=
ked()
> would change the page table from PMD mapped to PTE mapped.
> page_vma_mapped_walk() can handle it now for (pvmw->pmd && !pvmw->pte),=
 but I
> am not sure this is what we expected. For example, in try_to_unmap_one(=
), we
> use page_vma_mapped_walk_restart() after pmd splitted.
>
> So I prefer just remove the "ret =3D false" for a fix. Not sure this is=

> reasonable to you.
>
> I am thinking two things after this fix:
>
>   * add one similar test in selftests
>   * let split_huge_pmd_locked() return value to indicate freeze is degr=
ade to
>     !freeze, and fail early on try_to_migrate() like the thp migration =
branch
>
> Look forward your opinion on whether it worth to do it.

This is not the right fix, neither was mine above. Because before commit =
60fbb14396d5,
the code handles PAE properly. If PAE is cleared, PMD is split into PTEs =
and each
PTE becomes a migration entry, page_vma_mapped_walk(&pvmw) returns false,=

and try_to_migrate_one() returns true. If PAE is not cleared, PMD is spli=
t into PTEs
and each PTE is not a migration entry, inside while (page_vma_mapped_walk=
(&pvmw)),
PAE will be attempted to get cleared again and it will fail again, leadin=
g to
try_to_migrate_one() returns false. After commit 60fbb14396d5, no matter =
PAE is
cleared or not, try_to_migrate_one() always returns false. It causes foli=
o split
failures for shared PMD THPs.

Now with your fix (and mine above), no matter PAE is cleared or not, try_=
to_migrate_one()
always returns true. It just flips the code to a different issue. So the =
proper fix
is to let split_huge_pmd_locked() returns whether it inserts migration en=
tries or not
and do the same pattern as THP migration code path.


Hi David,

In terms of unmap_folio(), which is the only user of split_huge_pmd_locke=
d(..., freeze=3Dtrue),
there is no folio_mapped() check afterwards. That might be causing an iss=
ue,
when the folio is pinned between the refcount check and unmap_folio(), un=
map_folio()
fails, but folio split code proceeds. That means the folio is still acces=
sible
via PTEs and later remove_migration_pte() will try to remove non migratio=
n PTEs.
It needs to be fixed separately, right?


>
>> #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>> 			pmdval =3D pmdp_get(pvmw.pmd);
>>
>>
>>
>> --
>> Best Regards,
>> Yan, Zi
>
> -- =

> Wei Yang
> Help you, Help me


--
Best Regards,
Yan, Zi

