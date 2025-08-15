Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3A9CCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 16:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A850900258; Fri, 15 Aug 2025 12:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BF3900256; Fri, 15 Aug 2025 12:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC729900258; Fri, 15 Aug 2025 12:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C25F5900256
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:11:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27B7B1A01B8
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:11:30 +0000 (UTC)
X-FDA: 83779481940.13.F739781
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id B8C04140004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:11:26 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nzuCU+zx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=He1bheEJ;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755274286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gZ7ng1JUbawsLsOMCbuV6oBBq+WJ91TK80+go6y6ZI=;
	b=NUSPQgXFCPRg3M7QOs4lt4zgGbpa+2HXAVRhV9Q8Xrv7TtbTv0V57oBKa6NnavLJe28pDe
	FDE87+ISU+zYomgrgIH/u6xyqelRX8X+qEfV2wX/R1msP98HaZVjJIsS4fWmKK1kCDW3Az
	5zY7VRzUdImTcZ8RiAZzcacBb7aUEBw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nzuCU+zx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=He1bheEJ;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755274286; a=rsa-sha256;
	cv=pass;
	b=Lbh75o1AvYm6wMVZ9YOR7frkSSz65yd9KTs+CpkxALMN1e3hrzorhkjZjSvThqglY6EwKC
	oY6cC/uL/W9H5qaC3YNevf2X+jH2zalkcWEdElNaBT3XWaUmGZiSEwNi+FoibbLQeiC+xp
	Nn6nWcDqM85kONJ9EFyBj1zJIXk4PuA=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57FDN4Ct009183;
	Fri, 15 Aug 2025 16:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2gZ7ng1JUbawsLsOMC
	buV6oBBq+WJ91TK80+go6y6ZI=; b=nzuCU+zxAw6OgdUbW2w0pCdo9ZfeTls1AY
	Su1AyPHqWrQS2nBPHNpEY3ag9RK8ERaK2D6njkTPqIHi3c8yjRwDpcP1BTWFX7C5
	91+M2M8iZ4o6F6ClLetau4VyOFuwu3b2alhdxLbdBEUvllBY+FEozKaE01kzDRHj
	m/vqk5Z67OxQYwuriipqL7ZjJFPKBcFvbMr539STH/EkpNbAwr6ndk66HY1WCvQi
	yZZjGCkV1ZpHuIGWL7TVUJUfFu20Q4E8eHX5DdN0M8FAnqZjHGO83/Mw8PCDkef5
	pTfRhbqQYXXy2K6Q6uk4KvtWpMmjTonKyYcIAg2+a1nkjLd+Omxw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcfcc05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 16:06:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57FFXcf9017385;
	Fri, 15 Aug 2025 16:06:04 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013061.outbound.protection.outlook.com [40.107.201.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvse4hrq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 16:06:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=njnE560N+kunBGHrMGV1Hb4UIuBSDZSlXQ7hfiGvTd8E4xqJOJUXuwD1VU05uiNXUFo6Go9WcdMvsCKBu4SsGPUBhJplKi6lEJCJPDG0bg+5yrL/WCI2TbWlPbKafNTtx1UYR4gpmFC/XpjbtJn35/xREVUaxPSYIPX5KNX3HxTorjahGel/XmvcVNizF78Y7gms/K9G1rOClp/YtkO3HhUMEN3tSD4ZvBkVJ2b8XfQaVKEp8xNyQgXF0MPiV3lFzvxTuYqQcbeYaNHB9BcOKu2pviPD8OOOTCRSwKYtlXS7JJ82xikJEa2UemjMbZFQbEH5bBm3v9SGxuK1eim4kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2gZ7ng1JUbawsLsOMCbuV6oBBq+WJ91TK80+go6y6ZI=;
 b=x/Ka+Yl0oHi2DbwPguFMvvKS099jqkj0W9IBE0d562ywozchuxijJG3bUYMxj+AgFOtik6OkKGXguUMK1yhWuZDlru/TpIf5/IO8RWew04EuOFoiyGO3hlfj0I8T0rt3TDV8wd3KymjgmPFKrWXSKtdT8iP6gsgLI5b4OFhsvq+Y5JUfWiOIHIvyYuedRgswwet4b/DnhH6XIcipshEZOiOObwKA9+9M7P17Rs1u/kCWSl9oVLkhIhjeD5G7rBuxX+swgfmQmwhG7NQajQwhwhemyzsuMfe8/sEbXDhHlrr1ddITiA9Jz52VGRY9zUplWjim+U4bC0taGNR+yaUTLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2gZ7ng1JUbawsLsOMCbuV6oBBq+WJ91TK80+go6y6ZI=;
 b=He1bheEJOTMLiPA9ITVgBH2yFRDaRMCowVif7H0Gjz92fhsSjLJfu3Hkjs39auy6OnMeqhyLVX823FmStNOXLHx8ozJ741bVdtGOK6ZqUnojRZPCfMHCN3KyC6WLx4Z6K9ID3VhnOodfVCvO/SjDJyYEkKAyLqM9UjztJwtNwXw=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA1PR10MB6076.namprd10.prod.outlook.com (2603:10b6:208:3ac::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Fri, 15 Aug
 2025 16:06:00 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 16:06:00 +0000
Date: Fri, 15 Aug 2025 12:05:44 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: zhongjinji@honor.com, linux-mm@kvack.org, akpm@linux-foundation.org,
        mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev,
        npache@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, peterz@infradead.org, dvhart@infradead.org,
        dave@stgolabs.net, andrealmeid@igalia.com, liulu.liu@honor.com,
        feng.han@honor.com
Subject: Re: [PATCH v4 3/3] mm/oom_kill: Have the OOM reaper and exit_mmap()
 traverse the maple tree in opposite orders
Message-ID: <tnuqbtlwvxem6l26vhdg2dfxuefdyd5a4xth6wjyhm3ea3uwcp@kvimpn576u25>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	zhongjinji@honor.com, linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com, 
	rientjes@google.com, shakeel.butt@linux.dev, npache@redhat.com, 
	linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org, 
	dvhart@infradead.org, dave@stgolabs.net, andrealmeid@igalia.com, liulu.liu@honor.com, 
	feng.han@honor.com
References: <20250814135555.17493-1-zhongjinji@honor.com>
 <20250814135555.17493-4-zhongjinji@honor.com>
 <26larxehoe3a627s4fxsqghriwctays4opm4hhme3uk7ybjc5r@pmwh4s4yv7lm>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26larxehoe3a627s4fxsqghriwctays4opm4hhme3uk7ybjc5r@pmwh4s4yv7lm>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4P288CA0063.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::28) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA1PR10MB6076:EE_
X-MS-Office365-Filtering-Correlation-Id: 3fbaedf4-10ea-4e2e-9c68-08dddc15a095
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i+AJ7S2wzUy4NAxyiXXcgINpqWxLG2bPofBjtLXgFE74s60CQf37BG8EJuTP?=
 =?us-ascii?Q?IK9bVlF2Wpr0HH1vUf/fJF2YjxfpcOdHSlGG6LkE9wZB6ovVYZe72mUeHwzV?=
 =?us-ascii?Q?zjag3rxYImbkR9MBRLkc7SCw2KlHacKQUpctI/P5/dCl+k1oz2170Iqjb8V/?=
 =?us-ascii?Q?KXjMKHu5jFJpaPfLF9rMDcAtgC9V2tQ8Q6BUq9cK3EMROUeczAXK156+Fa1Z?=
 =?us-ascii?Q?POa15ifUWf+09BvdBOkKlPPDyUvGKAWmp/uVsy7ll7r26n+DgCb53uG9G5BK?=
 =?us-ascii?Q?7NP0hrUKwyo67XPPsbGOtN7i8qE4SztuW7fowyNY40Uk2S3E0bHyyknjYqEX?=
 =?us-ascii?Q?mkzoatls+nz6AytqMsoI73vjJdxAYHFyllJFV06nAd6pmMAcd3PhojJHVtNK?=
 =?us-ascii?Q?3qnlkHLeyq6c/oH/MZgdgVsz6+OG7GwWq1/6vO3blc+eL/cBEKiQDR+yoiQl?=
 =?us-ascii?Q?IixEvVjzhDVMXctODSQ6VfgEJFO7H1hCPLE54WATptZWsgz4btAE1H9kPJT1?=
 =?us-ascii?Q?s3EhydlhYvt5sHMYSpen+mXgLasTsK0TBiJKm59dh/jrIklz8MmRUaTym+Hs?=
 =?us-ascii?Q?biOOE7jljJIgxSM97wDfzsi3TXulSjkI2OYpl9sg9atbIL7wkRB/Y4QA0w47?=
 =?us-ascii?Q?fhTgLYvfJnFsQDPdvo8xhpl98iOdCzGahgXeaa1Dw+wGWEzSCBP79dXsluoi?=
 =?us-ascii?Q?9l98yn8hhUu9PCeSwyGAYdhP/4cw8FfSTblMz6pGQ624hO2KcHzq62DGjWeH?=
 =?us-ascii?Q?9SZBap4S2Z3FCW4Lmpt1Z29a0UP/uD1IADIqFMuYJQDCwzTTNsM9ovwkZ6kE?=
 =?us-ascii?Q?l3F7Stqy9UXA+NEdg+wK5MTzCMZpTR+ouStkXxeFBfPAR9GSelwG1pLAUq10?=
 =?us-ascii?Q?Jgw2fi4fkN2Je8o0uHPaIY3R7jXcGs+gql9zUPDUrp4lNCI6TCykurWanj34?=
 =?us-ascii?Q?w0+rJgfhHcpoFZhClL38EycDB/0veuc2JtqsgvLCfJRc4v8AZZ+ORV/sVKtI?=
 =?us-ascii?Q?7obe7ZnROwx688LtPYrrCLNzLFNUM8Wi+2Aw0223Tspok2nLSPcK+GjFi4GB?=
 =?us-ascii?Q?fkSDI6ghPgakzsHcMrJQMdVHL3OiTd4iSjCVuBuNpU2EKjofqWFx0mNFgWKj?=
 =?us-ascii?Q?AtXXfFIfSpejeG5OFqXEmICz5SQAp87QGCNmAm8fp1vnz5yqm6vyDsrqWeHS?=
 =?us-ascii?Q?yiAiu9yL/L5m6JiciI0myi/ajzJkorsv6qTl7N6qD5+AuKMZ4lU9N3jeP6NQ?=
 =?us-ascii?Q?ItUSqIVpMFbXeMap6g5qb0DxM27f3+qquXlxfFXr8N3qFMASnmm1UY+QsXW3?=
 =?us-ascii?Q?Z+HRuphRznw5Z+gwUXdfWMLsB6+cQMuzsx0xjOfZ8qAcN75Ja91Uewi2rDkY?=
 =?us-ascii?Q?7FZPpqrwprStJV02Aq4zLKhP+nyUzbXOKSg9/Xw+4O7OcfgIkzOwGl3gXklD?=
 =?us-ascii?Q?C4VXo+zhfzDATY3A4QOn/xrLueWoq0uLxYVFJ3rkj7qauV1uGamXzg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fMsdzA9rjRBBBGZl2l2aVjrMqlHQyQ3sE+MqPaLDJlsMyoGln101JwViTSgz?=
 =?us-ascii?Q?TktK5va9cAmlng0vibGUhZr718110kcPK62GVOFF+BoIsJWRkJMKztWfq0LJ?=
 =?us-ascii?Q?vxpNX/LX6VAkNvvFGOmAxSa50UHYGCqRVMWg4aPqZO8VKVnn6dfNNlCQrz8t?=
 =?us-ascii?Q?Hj1vLrRhvY5jPbzs1p7uHxHWcivfZ8MUouwtpTA14s1XtvhqUhpAKJc6iciH?=
 =?us-ascii?Q?tU33TuI5Km0Sz+dKbMZopktbsP87hy0cELrqPAfMUAH5I1RC8p8PSCVIpYvn?=
 =?us-ascii?Q?yLoYFQmbnjDna1am1NDwGCWutf98Bw6SAryRXwekEwhyv84oKQAMk/PH0K1m?=
 =?us-ascii?Q?7nrUC7pOhyfoTjgOLkKdJuZmKJEDQS+zuQAti02amjFwJ2lM5qWymug/jaTG?=
 =?us-ascii?Q?vO/+9LJQKzaegEzpHEYBidDQnK3owBSciPC7qY4t9Ar1vIGTjNUEAhH3w7ts?=
 =?us-ascii?Q?lmgPxhitd7roKare857VF509P7R4P0NFAczh6sQi9GzFFAvdgiHT3Xj9tkEv?=
 =?us-ascii?Q?k9+fvA8iwI7ebPrX4VBpcssM4CAg4VU5nJC/s7q4U9RvMfZTVLj54v4rusHY?=
 =?us-ascii?Q?KuHHd7SEVL2fa+auILFroilD8F61cPYnU/g9HyJ3TFGpQUlRNTrDaF+GP+iD?=
 =?us-ascii?Q?aOnht43muii+0cOG34ClO0YCEWE00zzqlW/QPrQeUGemykP5kO05dDDpYTJ0?=
 =?us-ascii?Q?5Ceb91ZzNHfFcfN9a0sJRd/1nBX/ejvINWy+Q82NjZ+o7dqEc+BZ9dPWAdIn?=
 =?us-ascii?Q?KJH34Ai5uD6YxE9Osb0SXihiWWCIrPzvLi0uxjBzloawPRvy0POyCgcTKKhI?=
 =?us-ascii?Q?/JCF7gFiWYpby/XPrZfwPjetrfjNEtY0rfPDnRphYl2tc2i0gSAWKFDi/Ze6?=
 =?us-ascii?Q?Bsv5svLcFwXbEcTLXTcO97bMEwamGTxT0j4QUI/7hBy0hY30Xd3gBO+15uyZ?=
 =?us-ascii?Q?lqIFcp+SKvy9YM2hfdjquqcm7PzVY8pkVW8dhDmlW2FiX2DF7YHPAMalbJ4k?=
 =?us-ascii?Q?QZ3muOBrgOd1pyhHryOcTklIEf4+drNCz3K4zXl6IT6ySOYu9l1mAozdJMK9?=
 =?us-ascii?Q?3GJU4vKB5sMeevkBXAjR3z86ooICbFn88B/8AZfmK6n51AWb3yaXnSzrb4bE?=
 =?us-ascii?Q?QJ0NE4beDd2Q7oyej85LJr/shJ00uo4g9T6qOgL9KJo+KEsaSP9ohhUP4lGs?=
 =?us-ascii?Q?A65xQ+2gK23cxWfcVLlK1o7e6j/kIKs1NRsZ9egtTmzFtPkqm2lM2MK5E046?=
 =?us-ascii?Q?5sP985l8hpFOL2y/W8vfHe4zzuTIUw5mzq+aOe+yrBJm5rlGg+WQl7UdtsS6?=
 =?us-ascii?Q?mPvlR3c/ITa1ZhmSAqjZcfWtbf10kgWRTqtsm5LXdQZ2aXikj9Tc7zhODoAG?=
 =?us-ascii?Q?kbrwpZrdK0VGJObFwgtmtbW6FabFrgQ7vWBlMXD95F1hfNIE3YPboOWw77lx?=
 =?us-ascii?Q?70TMO1yIc65F8wl8fGrNYrX5zWosVZm0jaPCLmyMnvnd5d426Y2pORWF+c28?=
 =?us-ascii?Q?72/D09t9wQYJ/IlXtTdEg0tGiwt1xWJLi3A02j0OwPFccjrZmmVCQTyzqxaT?=
 =?us-ascii?Q?oG2oHAVO+YAMFoHlkud8YKmEbgEspO/nZX3RWEp551jFXGAZhPuclkKHdHiL?=
 =?us-ascii?Q?Vg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NdssfOU798sKBnsDrggpOhJUPEWnlRpS0u13LSBYlGJGHXcWL3gpFhIlxfD7nt557BZWbMGUTDzngGhKCKKidEhPI7zjhku7mXMow3wBHomTFZAvdhrjHVxqjItbkt7I26fTpgYY9OhgXWxhzaBfT5wtET7HHW5vT9GNO8lF+IWSPcb1aeuciDsqihAPr9Azrb5l+OBHqrVq7rOYfUoAt1vNczcbGg2P8+b/CSK8p0MMW88samz49hYCB4pa1CsipIFcCEa/TGC93uc9nHXhUdEBpfFwe406Qw8uEXW6UelZVpWr7Err/TXOnpXxJNKbkfzEksbSSlUen+kgg5mzFs848aTZYukIxZ1uJMYCK9rI0Y4ZoR1JQXdtIXZbXNsm18iqzFI6wtfKRrYJrX/YvyiSrr8IBiIkhF0u2D6w6nk0exT8hq8dN+dng4dzlkSjRWQ/hJBf0mGxwXJXYoge9jsCKSbFqti1/KoJASYi5yWF9Rxcv66VqD3WRht5UCJLy6nptdR7nzZfsvksr0Lru4x8nUM9az17Rm6nI9eFMDaTqwwOXWYfc/jVnxukyfYkVDlFuRTnLZfgQzKHvcKo93eB9VM1dp4yRi5AKTSDl14=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fbaedf4-10ea-4e2e-9c68-08dddc15a095
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2025 16:06:00.6038
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KOGyvZNLNnQbAJh+9tbUBA/5SBmpEpX8x8XlOpopXsGKWQpo45clVm8QRN4NWDzlynO4mrUhbvfLh/JbZgpPRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6076
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-15_05,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150132
X-Proofpoint-GUID: w-ZFSSJLi-22qYNCG3vRhcv38SYIHO_B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDEzMyBTYWx0ZWRfX1bUvfyxlPU6U
 cok9T/uKoe/AVUXGhxNjx0zdVu0ZddwwHpujxS9Of0+HQx8osOqh/7g+HsDd6pyZ68H9Ejw+y9Z
 7LWfuFTUzb4ZywwrwZ+TXe9ASMI5tN2n5SVMucTTOYdMUVcEKhRKIpWGT+ftSYCR0Cjbc4FbKsQ
 dHilH5np/duLtvCSgQpyTprmz5C6Vxu6U1z8Zof3wtuJvSAY6StvbfTgVMv+JfmFoVa9HDigJk4
 50p+TBFSCWswU3FlzmU8+5UhaF+BsZ2FFrteYQcbwCdBBkXVLHrunnp3BGVodvAOD2iIuAAuf6b
 1ae9o48g+Nfu8GtTUqiJQEgq3638o3zcAyK1+wV3RpDvLLPzTta9T7eUxmqwlhTHQmPhIIr/+Vb
 MpxZSdNbEkMOfc2lBbQf3ORWbi2zVcsDv9G7X2eg5aZuxP+eELHOrMb9xLX61t3p6FMF8tkO
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=689f5aed b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=CvlTB2HrAAAA:8
 a=ZsEY0Lvu8KfwinP7TggA:9 a=CjuIK1q_8ugA:10 a=67QrwF-mucXG56UA-v15:22
X-Proofpoint-ORIG-GUID: w-ZFSSJLi-22qYNCG3vRhcv38SYIHO_B
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B8C04140004
X-Stat-Signature: gaukgji5gje9os5j6bhme9co731ecyzd
X-Rspam-User: 
X-HE-Tag: 1755274286-116383
X-HE-Meta: U2FsdGVkX1+CyC+WMpBJXKulncwF8ptJju0N5gDPkPipBJ9aJsu5N3x1AjyNuWagfj07kMPYfofLTCyX6uM/wdRefUu3yEJPKQiDfyckVCTwadZW6j17O/GkgsFZJHzin2jqVLxO2Q0Vy+GVc1nb/r26YyjWUgCQ+WplWasvfEgoFt6xjBYjt56FXGw6xpJ1Q8la8SB+nlyetPnTg0Hthn67fmPlJe+gxjpx2TPP7Yo3DOOHfOYZ2mcl8hMiLtyIUwUpNbavBk76ynqQl0P5Cc+sCBW0k58tdyoY1tudMhdLVfjn011ZsYfG9BEAIfv1K4VTJpIIbfasIPu4n+NF84PZq3CZjE19mzRh+lOSgC8TGnqkEVSaU0t6GQnSkORaYbqfjbfSCqFKsy7h26Ek+BIO/x2I5xTqvlibWjRlcHN+jiylHJCDlkfaETYfGhqdgV/M9Mb2jwFCE4R5cqMRAgT/Pgfoxr8eWcAh9aS6UI9D2DIZiTjk4dasmUBDhK+ik1bnJlH1EhhkUxduWgBAXvEze50KE2aKX5T+wnU8RMUrWbz6Zct8Nh4ZiOygHaOYeAfed92LFhm+xTMMQwxqWZhrEcCGg/wFuCGZGT43bzjpOPMmF7gtN5KWv6wnoN2C09+LRLsveusZ4X2DN5EzaHuXfV9jHC4AXrNSRkIGRXNzHBIcotB+QahuaDtvRRlmJnao3AxBqSprtfa0ZPwlt8tavmjGnKwTq6RTY5Q9P1m2TGzqx3zvovEvOKOwd3BCpDUvoGrgVjRErpour4awa1hL4lF80E2xz8JC9wnewlpe1BQOcsWcASg3WHe90+9tspReSC103bu7EqWAO5NoYbckTwWSywAfh/IBqTNsnPQbqI7z4+5kxh2aVakOkyOCbS+Cje2mUwnJYeWafm9N1vbKkCQ5QTtjYQko9UMzO1I35i8hVj2WpUvr4ABoDQ2hJcE9HRY30qNaxiy3vt9
 sTBEnpKr
 qoTA0QXPXguOrrhhUVAA9oKpItPURx1Rhvqidn9iiKX3Ncf8owJunRuSVgDQny8bn1IgY4NTxSnylH7ybnZFT7sz8+yjjuAvfgGX6LbroGD6EtB3s6XFATDUx93UkyvHpWw1JVgu7U5i7UUME/B84u2aPP0snSshLKA7PE+EUOPygXJRc0iZ1sRftKskjsc7Ih4J5nJNwAIha0Pny1oAXJAUTLEXZiA1v4dfrl4MD5U/GMzDBxNv0jzfMY8Vd6zv5GtDo+EHQE0gEwfUiFMtxcw2049oRzuqiYtjsnEtjlZxYu/2LccswVUOHB4Ylmqb827qu9CsuvYS7BX6q973FPcR3fBPCUsLTShBJj2iI6fn1WgY+RkLhOKQa7fPea4hOsEU5kHIEuN/4psdBEypw/9CeUcqGobjTPdS48pp9mACGLVzJn/+HVyJtUoUV0nnFTS4bprv/C/JpR4AWnIYzxSxtq7+22mLSTm02yTRD/gFggTKOiPeqcUaA2/QVU0u2UY/He5xdLIDi30HTFLE+Uf10ELir8JV/EaOHIBaJ7nHWjouTjAnbK5HqSeTZ6/DeeZ2wUacaUQH0wuK7LgeoLA8vyJ3sY0vm6s9/56RX7XKDxdSdQ9S5kCM0KQRjDd7BQtuovKC+tiqkuCxoTUd6PP5v8YqalOt5ddoAb27GcqAMH8lE1ywNcivuwdZfQLJD/jxmTekq1FI97F+N+1lNOW+kzSOSfI6mnGt+G78yxiGpwrJN7ncXT5oUj7JgQzlV6MyQE6BdD0x7qlZCoFUj44LlS1/P6XwooZVb0CquKZ5agZpoPAQt7cx0rjQ0sHJsBeKlqqbOvxwUjlgHLHl4R2wyKP2s2C8paOM9bj5s05UZ6iMqnOQPl4/hETww5L4gQk6o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Liam R. Howlett <Liam.Howlett@oracle.com> [250815 10:41]:
> * zhongjinji@honor.com <zhongjinji@honor.com> [250814 09:56]:
> > From: zhongjinji <zhongjinji@honor.com>
...

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
> > +	for_each_vma_reverse(vmi, vma) {
> 
> How is this possible?  Both need the same lock..?  What part of
> exit_mmap() will race here?

I see, exit_mmap() and the oom both use unmap_page_range() under the
mmap read lock, so they can race but since they'll contend on the pte
lock it doesn't really matter.

This is so rare, I don't think this is worth fixing.

Thanks,
Liam

