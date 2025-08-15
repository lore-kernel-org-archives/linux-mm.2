Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CA1CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA20D90024C; Fri, 15 Aug 2025 11:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D532890024B; Fri, 15 Aug 2025 11:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF38D90024C; Fri, 15 Aug 2025 11:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A9ADA90024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:02:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CED41601AB
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:02:20 +0000 (UTC)
X-FDA: 83779307640.16.EC68EAC
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id AA7EF40002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:02:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nDiAEau6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AWyFekd0;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755270136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jFuFgNsrKnuygoz9r7ZggyKIDo2MODxEAZ/t++kWVAA=;
	b=paVbDuBWrR3sMvEaiLLwqgEdONl1KeqT6UhfKS+yGv/agqV7Ri6prEua68LIrptzYEJJqL
	Bd7T1XpyI1mbS8xyVBCYzu7p3twuUBTUlWmU228vfaDXCAzIQRzozheM4f2Nq3K+z5xG1G
	qb0LPUxXsPG8Ycf371rRBeVmcDAxsJs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nDiAEau6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AWyFekd0;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755270136; a=rsa-sha256;
	cv=pass;
	b=X8gn4OXOPAHrTt1Q2ivhc3WbXg9f75rH8SKQRHOX1X2O8eMYC84n5h2oIeHMDRDOL2birK
	LBZaHyJkcddzAksjZ/MbMAHzj3oMqFRSiztrPGjm05sVKzni91q5aY7pSU9FCnUZqCOwSD
	QWp295OcUzEUzyHkNYB/2Dgf8ZqNxes=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57FDN5hY009226;
	Fri, 15 Aug 2025 15:01:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jFuFgNsrKnuygoz9r7
	ZggyKIDo2MODxEAZ/t++kWVAA=; b=nDiAEau6SEAgC9nIq+Z5Lc7/zxjSeuahSA
	YIYcrxPOl1rVO8mVIVUcm+bFWXNp2pUX4eUEmjIrnaL0hrzOQHS1cfTMRoZnavd2
	3P8ixY6V5/+bXL8FmKifudAjf+NDmlMs0mb67sUnvk2UVsvGsYNM/LxNEpIw3hFD
	dzsV6cadx10tnl0cNUY3esUl/nFe+eHHxEzKh5weXVypyenkfb7a7DsPwzOuR0+b
	g/7MV3pg3V1jg5ZS5BpcbmqHyArNx14Zj2/iO0gHlYMFQmgmFHH+w6JFzcNka0E6
	fsbf7hR9fJP82pAX/Hm8N2xCktoyrGfiHEm4jeYUT9AowHFtmylA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcfc86t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 15:01:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57FDDpIA006333;
	Fri, 15 Aug 2025 15:01:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2068.outbound.protection.outlook.com [40.107.243.68])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdw955-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 15:01:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uOA7g80YOVfq1gaU97eXI+WgcWlsvcZrS3E0EpcyW1AcaXzmy99XhPVAyD3YYvi7FGzZrlWKfebXBBEQqVi7jlp631nJHoSUQdTn+X6U9s3xhD+N47repSfYfHkw9Fv3zpHBRmxvyS4mt3f4ooRMgjw3YixUyvq7Kc4DNPV1xSSov6/RkTJnBW934hEjhHOW5Bqmg9MDcEW74mKTpDMRnIqGYz5YbclbfXaC0uSO/Hj7/uG2SJqYjyy4juddAee3XdOUbwzsWdkwALsnu98ekGSWFfeJQgia1OXO4QICObwg66MeIvUOHk/buofGygxP/vxTpleY7K13IJaNN37g8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jFuFgNsrKnuygoz9r7ZggyKIDo2MODxEAZ/t++kWVAA=;
 b=zEfCzdv43LiBeEnBef1BqUjHsLmXY/Fkertbi+ItGtupE4zhEOTQC1OIOemy/X4NmtR2NXmfH0PuF28TW40hb+SFehBApDy9DRlwakxvH9Zx3/KmB/V3mMhR+K0ecHAwjzRMrFiKtg8csdAoWZfYMCkNT+RshlwaJIIwnNxVYSnoSByJPrBbI9Er2GEojfh6erv3VQrzEc5wbR59ZxlKf/q0W0xD96XXLmeQ9sE//UGhxxnicZvQB8xA2Rp2pEIl7PYs2g55JeHrmOFyS99ssfDIZnm0rTtFaI/YX1ENohjq0Yy4L2GIZdi/TZ/cDvTnF8/pvalTaHypSq8C5f05EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jFuFgNsrKnuygoz9r7ZggyKIDo2MODxEAZ/t++kWVAA=;
 b=AWyFekd0Wa7Y8zVhONcGvB9CHM5GRVJJCjua3A1ufjmChMDMOEhqnH5OEVLfHF7H0vsog/VkFEW0tTQsSVNMIQFNqdb4PFbvvCL5x5+bKTWpIhE9VWof2zgOFOK7RDzrNRGfMPQe4HXK1bvMnEssK7/QeiEHwAg52ljg3sb3KKc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7480.namprd10.prod.outlook.com (2603:10b6:8:165::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Fri, 15 Aug
 2025 15:01:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 15:01:49 +0000
Date: Fri, 15 Aug 2025 16:01:45 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: zhongjinji@honor.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
        rientjes@google.com, shakeel.butt@linux.dev, npache@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        peterz@infradead.org, dvhart@infradead.org, dave@stgolabs.net,
        andrealmeid@igalia.com, liam.howlett@oracle.com, liulu.liu@honor.com,
        feng.han@honor.com
Subject: Re: [PATCH v4 3/3] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite orders
Message-ID: <5df54577-4494-461a-b195-a8d23539c9f6@lucifer.local>
References: <20250814135555.17493-1-zhongjinji@honor.com>
 <20250814135555.17493-4-zhongjinji@honor.com>
 <8e20a389-9733-4882-85a0-b244046b8b51@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e20a389-9733-4882-85a0-b244046b8b51@lucifer.local>
X-ClientProxiedBy: MM0P280CA0081.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7480:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cb1eac5-5584-42ee-8ff7-08dddc0ca94d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NiUtRaJHbfyViwn7LINzSJx+d4hip1CARu5VCvwKEqBG9s33EylLOWIDqgko?=
 =?us-ascii?Q?Z+ygL4nB9lgRXegIUuZbvL/E8gXsrpZtf0Dr/wXJnThFC4JpJ2MdeIvh7w++?=
 =?us-ascii?Q?ThURbQBWm4LpOQck+aaRWbWU8lbpeu5PxWiC6QoptzMJYcyfLfJupAakU0z7?=
 =?us-ascii?Q?BURWURzdcnmxydkEpIQxU6fMdt5X70DkuhApVCOlLKUgsufVpQnb4pU8xZlG?=
 =?us-ascii?Q?6tq8EEtYP3eQA0XNLIug2ZuPGQmep2+MAU22lgHAhl4/EMIUN7OkkndksTS1?=
 =?us-ascii?Q?FFVpM4hlIxtun7UKNoKjywF4ykO4mBK+P5MY/kAxO43ncJUQ8Nhv8Y6SWkBX?=
 =?us-ascii?Q?NbzPeBD98n1b3c+Q/vOHxN2N6eRe/lonrZWmMD1jEIfSRn0/n4TxEV8yU5+2?=
 =?us-ascii?Q?SSCm8eph8erum5EqdBbwSzppItYENgXEaJkZvnw5HbMxrR3c1crpq7g2ZQIQ?=
 =?us-ascii?Q?pBGu1BZjTGUVnkEh5By+ZGVXBooUn3aHPPm7C1spKcVTfvwsieCmJBqEo+Wz?=
 =?us-ascii?Q?FAS2FvGV5+wKLUC5aNW52xy8e8hoCVH2zmDasTfUIk9J9uEfCtkmO5VkxF2r?=
 =?us-ascii?Q?/crcH4nSX5lHGrL4CwX+9TVjJTiwTLV1ekLQFzntp3N6V0xjliiNaUF4Ryg8?=
 =?us-ascii?Q?cZGDahe6bhmgwc1279rL+QfBpvr/8VCf8rDqLLKj1dC3KZ8ZPeKrElTsfENb?=
 =?us-ascii?Q?lDAk6pl9aziK9Z7LgccBYohezNHCMJ/1tiZ2KTNAyJVJeqbMY8CWdLtQaZMP?=
 =?us-ascii?Q?NMOQiZnvSUKIT4UQgtjM5R7Tl955QAOI5eyDjgwlZ1Cj51Vf976O2MinxFar?=
 =?us-ascii?Q?LtTo+hhg0ZmglshVnSe1a3Afxmidmpp+gHyRcaETHA5TgqFWGk89++w99Ju0?=
 =?us-ascii?Q?o/pvOkTNqielxZ2/7mGlPGQVDP4iNAjhPTISpKeb8tl6ZuEB8B5yv6Q+2pJZ?=
 =?us-ascii?Q?3LOooFrI/eG8c4BD3CUSXhBOx1KAAQoWIjM5N1j7a/9YFTpksqgyP6k5LAb2?=
 =?us-ascii?Q?JF4mk701BrokgfBsTKRAwWR4GkXjzEB03YI2hXrs3usUwkxHeKjQ+sSRHR04?=
 =?us-ascii?Q?zpr7Xe8TVuzPSJDwoPCXimep5Kbew+9TLwgfLF9CJ05RlU2wAUL4HKBIMMQs?=
 =?us-ascii?Q?QEjQPGJXOI5JyJZ3MEcrIwJJ3u3oHzR2AKS+LVVTIlaSspWGT8N/o1cxWRW3?=
 =?us-ascii?Q?p50YqLGCu0zNNhTnmMzhGT/x1ZmZFjXgihqEakbCfhaKKXlFExRxJtGSaur7?=
 =?us-ascii?Q?W9j6EebMlPBgo9SQywEUlLc849jQC4q15VGzQY0dK3b4OGvAsBSeIKJ9ubRf?=
 =?us-ascii?Q?/R788lvWNEnyS92i7JcvInDqUCO41oCCc1eOjtOcEfwvAKY6pzHQSpsAqzQa?=
 =?us-ascii?Q?QW7yr62PDHUi9DUDr0IKf/p49uQQwOKuFvjkGtCoS0k1e7dlI7dBUYE+ECwY?=
 =?us-ascii?Q?KSsBlyEj8wM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uu8tMtee/97FZFi6ielDEYEz7vs23qvox3Bqppk9DoKfL5tJE58CB4mgI8n5?=
 =?us-ascii?Q?YU28jjrOxqpMSPf9M5f0X++WSHh5fpIndyHfKB+ieNV6yq1i5ndY51Z9BUI4?=
 =?us-ascii?Q?onas83BotXWOeY97qkFZ0qee1KQR8WEUX+TUeEsf9ZRvbRh9T9RgdPAkPOij?=
 =?us-ascii?Q?iilUsBJOZda256nwLhfDkp1haqai8sbYpMxyuqqm03HcZ4+xgg3NPRRxYOe9?=
 =?us-ascii?Q?OCB897fxOAsaec4ePMIJYQqu+BKIKtZtMYwiQGB6njfEg3D+bV0T3nLsWWFS?=
 =?us-ascii?Q?XtHIbI0iyz2t6llNeBqhXiffNCD0tj6vw0qQdDfLRgEHTJEM2dte62UVF7l3?=
 =?us-ascii?Q?OEG3ty6/sxnB4yCs7Y1bbLtMkK2S5uWos2a9UYf0r1Rf193ON0CXzYff4+3X?=
 =?us-ascii?Q?tyrKymO2ImVdeJDW63OrgOPZPGSHbdtF26+xBUiHNxF8pm2P7E4xd/ouizYf?=
 =?us-ascii?Q?7n/EvNuZ3OUdS3n0HoNiiMXhvpUjlAIlxQ/l3fnAyFH1O8hmeo0E4Hn0krlD?=
 =?us-ascii?Q?zpDvfxIOfDJWrUG3HkMIwRDD2Gj+U2NsIPI5m7vbwuRG5KnrWQWz6rX5Yr1P?=
 =?us-ascii?Q?/nAZsgf03aGVJdG6AhAyy1FIF6UytmPjlTFD+5LA/P+nF19enjCvXFf+8FHf?=
 =?us-ascii?Q?s7HPXwM9rAqcUsL9A2RvzJartmBWpaUiPIwLQvyRZ5Sc+QKY5O411ePihOVM?=
 =?us-ascii?Q?MGiJDdBOoAwcnEngHSV0vIquaMNAIOJZqsxSvYE7kAw264QiliSz5iHWCtPY?=
 =?us-ascii?Q?OsrJ1Grp4DLfEOrDkK2fOvJPCMrBZCzZgNk4Va27nld97iWHi5ulrZ5MW/99?=
 =?us-ascii?Q?7pQ+yf20lBmeM1olZp2tLPOigy9wlAVYwDI+r0kVLdHbZ28d2UjNZU3ZbvOR?=
 =?us-ascii?Q?MciK94569zQVLuaHnLYRlMg2phjakKLixQid9b/OMh+Iw+MUNGJKT4bBL846?=
 =?us-ascii?Q?W3FciAqb0CYqJSYCuLHNntWMaJhf4ybEKSS8Ng9Ik1cWUa8QaPa1fxvv+3hK?=
 =?us-ascii?Q?tLZjhEplqXKDxV+5BmN8k6/TqNnt2pfgwYeGU2CVbtSIriEkzfZaOtHq6nGZ?=
 =?us-ascii?Q?byltou1uR9CJ55i8sUJ7g1XJjopKufTI2TPgKTmbTuyyTLgjHNk+JcUTcgh/?=
 =?us-ascii?Q?EcV++i4UdJRPB/z9Nw9H55R6Dxbdmp5FQ7+LghV81WhWx89w8K10e4Wggdpq?=
 =?us-ascii?Q?LcSJc7k7oY+qAp+Do+ymEnGvOKl7sxjz6YJ/uhBlsFHNCAfBxXXB8Qx9h6kQ?=
 =?us-ascii?Q?rczLlQh71a2wywODIPm8Shb3QW0RS78V3PUfNuY/n0oj6A7faSAdiOhhz6vP?=
 =?us-ascii?Q?xrJg5VCgVQRYictHmz2eMviBdTuDWNttHso8jgkk6dr66KaIlo++7U2DbfrQ?=
 =?us-ascii?Q?HC2dM84QeKmUUNEKT3346qObldZRyczF1wOhV+6LSdY7TbCPZaqecAdYcB8/?=
 =?us-ascii?Q?fX5+RggJGeqgozBQWaPKFXR4mOltXgXJqVYa+IIG6XoW3GR4mGTkpW+kPevN?=
 =?us-ascii?Q?Vdd+I4pUryfD5u6cgckbo7+tOOyewsnENv75ggoyM33WIrgtAke4nFCjhOil?=
 =?us-ascii?Q?sfDD4svLIUYuOLZCZ6S22SXmpnregrjauPWRNU7eSaXhphKCfJ6ZY9h7CCY5?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7xpadilIHiIRrFj2eq+FqL2j32czTSlR79o12GabXpcFPv0Il2M7xzNsDbRbgxfWvPyAmkdsu1vusEww7DN+gqeQKoD7i+cJJWp0VXZpql6NPkM8oVnn/03nQZGwyhXHZF+QLkuslv9pY4bV3VfxocifsmLHKYuc/RXP0a+rUYn5aAUFzdz9e9e3Lp1ydTti3QKl6f93R+XjZA9GFuEuzQnZERbqeA8j7oVwuCOq80a97QFxUmafqhgEqTP3ARFUxCdVW88EkuxDulXYfHD1U88KVxX+DX2KDUmNCDsEtafPpRRMLNDWJ77tUkwQ6YlqZdwk5OAk5hbUXlB2cD4GUxgfNGG+5ItCgGKj/zunTydCcgNSZouoW+An4UrmVsNH9V7BxYCqoWO/IBQIszjEnEJR4rzxmwptsi4XT0opmHpz1lE9A9iLLmS6dcz+Oe3q+hOqZfW2N9M5LY7ScNL5Iy7MuSALUzYzdeQL9yioSJe9YRqRZVqFMKSaI5Tm1K17gKE5dGjDnmSgp58snZIPaMpghp7hyC5r7W7SyEPXgVJBrt1pdI8lgC7xOgZsHO7eqmaUMIVXxoi3aBQJ+ha5MAP19OGfHMHRtcJwYbYGdAw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb1eac5-5584-42ee-8ff7-08dddc0ca94d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 15:01:49.5456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vMO99Pitm/o3nGmywU/ZmJNWjWEyr4rEkea/i04Wi3iCOM0GwsQcgvBthnaAHnZCa3eIQIUiEbl34J7EYvzIdKodUxhGysR4awUojQK1kfw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7480
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150123
X-Proofpoint-GUID: iwUBJsVrNXWZkpN9f0IkDkweLgOHxGkf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDEyNCBTYWx0ZWRfX7ktkXntxsF2c
 RR1J6PYlf3C60SoBGDi8Ut1LD1Rr66/sRGweSL96xcpnKPZc62pQhYyPx0XJKN4Phh6Xx6BGYvx
 Allb/ee9O8spXKZCQ7OTgZ9pSAkYxeXKXeLAguOS1bAs3PKzin4UVjK0LlXXTV7Df/xbRybLVHx
 bKad246qHumSv00AX26XuD7B8yB8bIclSCBqsSu7rPaO5M2N9yRNZPkPsfuNhuKCFhvXIGsvhSZ
 HPhRDq0u2QfFIbajhI36BX7RAdVuxyVGxwF5xe/wJWDUaYteD5z9gzJwr/UU7ciGqCW0oaASGpP
 Iw+i2yhG5iwJFXIwPdy+IhET3VLhBrJyJmv/dYFFSjEB4XNYWOX0EUsB2s43KhHB16dRTiIyQzc
 aXhZOpiZ4UKjtynLJzQbaebmDsltKAfeRNcnsmI3hhHQ8xsVikz2cOCp4EQgPRUdhc3zGy8K
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=689f4be2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=CvlTB2HrAAAA:8 a=bRh9hFN43DYlccTXN30A:9
 a=CjuIK1q_8ugA:10 a=67QrwF-mucXG56UA-v15:22 cc=ntf awl=host:13600
X-Proofpoint-ORIG-GUID: iwUBJsVrNXWZkpN9f0IkDkweLgOHxGkf
X-Rspamd-Queue-Id: AA7EF40002
X-Rspam-User: 
X-Stat-Signature: mi13pegfh5xryr3pn9bddzremmgzx1w7
X-Rspamd-Server: rspam09
X-HE-Tag: 1755270136-957311
X-HE-Meta: U2FsdGVkX1/8aSAJ3ZXfT6cE4j6wTshvhn+VEHJzNmFx71+tMH6J4thY2tHULn/ec7Fho6CK9wKJM5RmYGr9oLnXLkciSpj4nV2QwNxBh58CT1vvGn7x7jP/AMWSRnOHcEnLzWs43PRdcijwDrHdWKNhlvS+6vUW7zQ9blCH8FtdbKyc3Cz8wKtId6m7Z2DCI+Ok2D+g6n1N6Kne9WT2oAtsO5+HmCLYQTofG7vGhZgac0l4lk3BvzS7JOx2saL2oYMISP4+wltZMr/cWkTCnKs7pLsij3I/DG3O3QUVhTVX38absaLLdFnMXgo/13EdN5KFcCqumQm5/DPIG93zWG7ex8OdvshksTJSEEGOQ1ZaQ5rfusUwEFixD8b2cSVqbUopR5iAkf6gSHKhbyjg9402g2pYKgSG0yvuSYOHxCjJjrfijV91op2A3Ovj0iQ1unM+x9sxyIaHXAh9qmv0PerpxA1vlrTBnkaeAHIMZu7TKfMbcO57J1UlO2gauAi3A/djXN+em7x/9BkTq0hf2Og4WY5dz5XIWP6MNqgDTxwp9ukdfnrIKxP/hp+toH9CkIxTzEg3Wo/t1IhwO8a+hhvv9xAkwPaUvBIDdGZGmhXKk3QylTCglzqLtBS/JKXM387wNdpNmbhOD3TSXM3eUTpkQzJIk768EFNByCW1+ZMdhodPBSqTMtMzcp/ID/4n0HCwq8pxw5+TdGPNx1SefKskKi5rVFlQJd3oITHL78N0rawHXy09H96LXT7XhAC6oK4mlfZA46tFDvfUVcfaZopJg5GBJGEJiaEY2CQgPlQh41FEGygsm0CZ10mwAXvhJ3XclaQ7D2tgLrU/Behy7Z5jXH2gBI9/Yysxxi/Eon8lv/JU/QVz5sCYahfxRGN7xDIPde2Ke+QSywbDIe+5R1ZAEqjROt+jpRE2NWV1jHym154iK0oQpAI1DDbDpDvWmqRGXZwJ1uLR27lfN6G
 zoLKY0hR
 nvdthyI1hppaaA93FFzuLEmmgYCQUDZFvmVxjEg3i1M49xwXbcRuxBk6AUM2jJaY+hQFdkTsPCbtejrePLWYm0MebgFbCc2BGMqm+wXazOY3FI6Mr68zdbXuLtxUAduYwKpjmXI5mcYfm5Pbaj7EsnnL2lTPcUOSOCDa6KtCQCFNW0GrPIeWfb0DomgeWXeIr0SK7nMmSnRNGW8oOjBB73oHRA2nfVWJalTbqmLli+XHoUdhzSML3tOtqGMCgNm31aaogVorQcfvUkiPjOF+4J+lpFLGI6EXroXsCMuaK5XUlNbItSvJcYDAVahbFHjA2sOyvmXAvIti6azFunKwvwDdUFTGdYfKU7At0BiNKQz+gNRidcn0eWq42u5dWcLM8kw1w2TLtNzd0AHmzjw9q9T0r7+pY+dQMkEBa1YS/6q7iSHrVOXCe3ZPXlUoBrX1euFVgYJnXy8Tsr3VRM09NImRRIgYVZSnPW2EiBAcHidOwq0TO+8OkJnTWWFHudHrDPs8v4OEaJ+SgJjE/86e9yqc0rs8BJ6h3QsB1Ru+ez9ToEzuObYlMKF1jDGgBhHevlxAQW+wsArdVqb/p0PZxyQnyMWd1ITuUdZPI5E+UKEFoDWJBCFXFpoWPfCuEZSKdld/7ozZhkb19Om0v9myztqNo8FUBU0VdNU338N3dD59TcSoMtp3pR57qEiKRg6/xWu/iMgYk+m6d3RuAD3PC95cIllAqarYaaTcWcMgGlJcmRGzbrGfHmHdvw/srN4hGPp/HuDx77QWxx6kCx8BVjPkrvO3vQR+jI3jgeyOwYS8AC1texUL/YWL0CkDIzJRoMAmwF55rsKi1YMxwqMGxsJqIgiFQDLCATcJI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 03:29:24PM +0100, Lorenzo Stoakes wrote:
> On Thu, Aug 14, 2025 at 09:55:55PM +0800, zhongjinji@honor.com wrote:
> > From: zhongjinji <zhongjinji@honor.com>
> >
> > When a process is OOM killed, if the OOM reaper and the thread running
> > exit_mmap() execute at the same time, both will traverse the vma's maple
> > tree along the same path. They may easily unmap the same vma, causing them
> > to compete for the pte spinlock. This increases unnecessary load, causing
> > the execution time of the OOM reaper and the thread running exit_mmap() to
> > increase.
>
> You're not giving any numbers, and this seems pretty niche, you really
> exiting that many processes with the reaper running at the exact same time
> that this is an issue? Waiting on a spinlock also?
>
> This commit message is very unconvincing.
>
> >
> > When a process exits, exit_mmap() traverses the vma's maple tree from low to high
> > address. To reduce the chance of unmapping the same vma simultaneously,
> > the OOM reaper should traverse vma's tree from high to low address. This reduces
> > lock contention when unmapping the same vma.
>
> Are they going to run through and do their work in exactly the same time,
> or might one 'run past' the other and you still have an issue?
>
> Seems very vague and timing dependent and again, not convincing.
>
> >
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > ---
> >  include/linux/mm.h | 3 +++
> >  mm/oom_kill.c      | 9 +++++++--
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 0c44bb8ce544..b665ea3c30eb 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -923,6 +923,9 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
> >  #define for_each_vma_range(__vmi, __vma, __end)				\
> >  	while (((__vma) = vma_find(&(__vmi), (__end))) != NULL)
> >
> > +#define for_each_vma_reverse(__vmi, __vma)					\
> > +	while (((__vma) = vma_prev(&(__vmi))) != NULL)
>
> Please don't casually add an undocumented public VMA iterator hidden in a
> patch doing something else :)
>
> Won't this skip the first VMA? Not sure this is really worth having as a
> general thing anyway, it's not many people who want to do this in reverse.
>
> > +
> >  #ifdef CONFIG_SHMEM
> >  /*
> >   * The vma_is_shmem is not inline because it is used only by slow
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 7ae4001e47c1..602d6836098a 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -517,7 +517,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
> >  {
> >  	struct vm_area_struct *vma;
> >  	bool ret = true;
> > -	VMA_ITERATOR(vmi, mm, 0);
> > +	VMA_ITERATOR(vmi, mm, ULONG_MAX);
> >
> >  	/*
> >  	 * Tell all users of get_user/copy_from_user etc... that the content
> > @@ -527,7 +527,12 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
> >  	 */
> >  	set_bit(MMF_UNSTABLE, &mm->flags);
> >
> > -	for_each_vma(vmi, vma) {
> > +	/*
> > +	 * When two tasks unmap the same vma at the same time, they may contend for the
> > +	 * pte spinlock. To avoid traversing the same vma as exit_mmap unmap, traverse
> > +	 * the vma maple tree in reverse order.
> > +	 */
>
> Except you won't necessarily avoid anything, as if one walker is faster
> than the other they'll run ahead, plus of course they'll have a cross-over
> where they share the same PTE anyway.

OK I guess what is happening here is very likely one task will be faster the
other slower, but like a slow train ahead of a fast one on a single line, if it
happens to get the lock first it'll hold up the first one overa nd over again if
the same PTEs are traversed.

Still, again this is super timing dependent it still feels like the wrong
solution and something of a hack and it really needs to be backed/explained more
thorougly.

The remaining comments still apply.

>
> I feel like maybe you've got a fairly specific situation that indicates an
> issue elsewhere and you're maybe solving the wrong problem here?
>
> > +	for_each_vma_reverse(vmi, vma) {
> >  		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
> >  			continue;
> >
> > --
> > 2.17.1
> >
> >

