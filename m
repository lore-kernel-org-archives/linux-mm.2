Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37EE7C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED958E0006; Fri,  8 Aug 2025 10:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5108E0001; Fri,  8 Aug 2025 10:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C4D8E0006; Fri,  8 Aug 2025 10:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7A4B8E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:46:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5544658625
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:46:29 +0000 (UTC)
X-FDA: 83753866098.01.6AAB967
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id ED48540013
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:46:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XuFknpES;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LcxQlkgk;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754664386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qu+M5KRPPtzdMJF//tAdHvkKC6YaE7z1ATl6HXsrIYw=;
	b=D9FKp8FTvKuZJ2hpD+aQsMPVdOx8jUKFOhS+8TXjt0Jt0DEtmZYWRE7AgT56qQT8212Z0x
	+2kMxsZ+Z+oha24dzZbnKbbCLbyg+ISmQVJDvRsm3TBgFYaV4WCTQiw36yIWH7zeOrVvIK
	NGoFzk+eQyiB06Nlzwlf2i6+4xDqzgk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754664386; a=rsa-sha256;
	cv=pass;
	b=jETb62PsC3j+yMwJQzghTRGDXzQ8PST7LpiS8wp4QzZEQbB33CPymMsgLwzJ96sCYAtv/2
	eji8Ztu/S5tZvvlQa9reQdtXmkO4izi8vjdbiaTVkhepBxIKurmDEwBksTCsjf6+0k8AJn
	SSiWuy3TfF3uTa2QCmlTRLu+LinOO0Q=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XuFknpES;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LcxQlkgk;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 578DNPpJ028675;
	Fri, 8 Aug 2025 14:46:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Qu+M5KRPPtzdMJF//t
	AdHvkKC6YaE7z1ATl6HXsrIYw=; b=XuFknpES77lAY4iADDw3649UFlEYUJwVto
	1GKfpWMFfL7NfwaoDv1PbVyDSl9c7rkqlfprw3PEhKcx/ipCr9nAIBI4r2hgtPWf
	FbnJhJB+9161Fyk9BxbFCBu5WPBUcE95wqlFQ+GqQ9uc/D4+zNvgY2Kyp5XZN/mN
	OiAPX+28gDKrYe8gYSqO3NfLDvQ4WDHMa55wixZZSbitQYS/3472tzBfOX6iwax4
	czuOFfVq3zaBM2+yUlD3xkxNtLPGPb6dEK6yFgqIJD9QfQw4Ksb9QnXISHU2QAed
	78hiQG29R6+4nDSrgTUUve2FE3olpfFIDiePuQZ0NUsu20wjm4kg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvd6hjr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:46:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 578EYu41010024;
	Fri, 8 Aug 2025 14:46:20 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwpu0yy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Aug 2025 14:46:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nLMeN/YkPm108D9m8Jw0ih1q1pVMLM1RcSJGI5eqAbRcdb7LNFEbUYU9PRzOSst54CN6yeF9k53qask1ddsM8z9XaCUzpG7yyll10BYh7UmZx9o3P4EwUZ7axni1GX/kGy2aHkEuQ8OEXk8L4tWQaY5mHY29CV+bz/h29msoFSvPintPpraEB0YTz5nmup5kJlVz67F1fcFvZ2tu0GhBVtczda8KpbIXD8xrhDWl3ya6gMB4YJdQXUSiXW7v2dWdllrGfs5VD6IsO9iyGSmj2dACDkMcfE8WX2YJi2kR5C8VsFm8g1AWJtMxzwx76D1wmk9RXQOfeW5ZptWGMbyipA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qu+M5KRPPtzdMJF//tAdHvkKC6YaE7z1ATl6HXsrIYw=;
 b=USrmWp2cSOICpcEYOZPR7Dy86MTf9O4gH8SNb6U7YSxNz+H/IENDTMMrEIiUsuti+0be3ZmGJtNAXlCYXxXsOYWXKDjfSLUpEOvq+uXVz1qwxwXSmhSAxph8gjQ4H1yyD6tClr8H6N2Q22Ax1VEiwramN3hHiMjHj4UNs4uvyP1+SGHAYY8YKD9Z38H/46fHzCOHG1UFVr9EZgEHkryOvjzDRJNQo5YSsp9VULznoDe8NmZNbBGWrYQqtB2Yy9fO2ytFZigbuOgml1trEAYHUpZ/PZqpajoNYSNoswVLmRmsYnBWvrFGObZnKXQAqdeYpD4cRO2MrFm3pe/SaStQXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu+M5KRPPtzdMJF//tAdHvkKC6YaE7z1ATl6HXsrIYw=;
 b=LcxQlkgkLpvsTTLxZPVuN4f28Zik4XW2F/IsO8FAW7TvEAl9i7bdxqTjTb82EjJYBqDRZp9+n1Fnj2EoUhCCMqDDoTPe3uDciyHjaoCj5orWfsAynHYRvWSqD2Y58pPbWg243ffF2+LrH5G1F/NHiAs0gOB/ArvPia4EEfx7Fxw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4714.namprd10.prod.outlook.com (2603:10b6:806:111::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Fri, 8 Aug
 2025 14:46:16 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Fri, 8 Aug 2025
 14:46:15 +0000
Date: Fri, 8 Aug 2025 15:46:13 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        David Hildenbrand <david@redhat.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.17 2/3] mm/mremap: catch invalid multi VMA moves earlier
Message-ID: <c938f48b-d1c3-4c5e-b68c-7788075a2485@lucifer.local>
References: <cover.1754218667.git.lorenzo.stoakes@oracle.com>
 <2b5aad5681573be85b5b8fac61399af6fb6b68b6.1754218667.git.lorenzo.stoakes@oracle.com>
 <571c0a24-6bdf-47cd-b336-efff34f48010@suse.cz>
 <52bd8c18-9299-4a91-aec7-670038d90f62@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52bd8c18-9299-4a91-aec7-670038d90f62@lucifer.local>
X-ClientProxiedBy: MM0P280CA0067.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::34) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4714:EE_
X-MS-Office365-Filtering-Correlation-Id: 68f0ee76-9007-4729-3b5a-08ddd68a53da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IYzZy1u4SajbTYbSGPES+SK9ZU3nTyQKUgnrvKcZRhgFpom0Ko1145NCOrJV?=
 =?us-ascii?Q?ICP0hwPupRnEyPlg3DIkbHtfmIt+E3EyrFcKkOsZjK3yFMVfJY3a5zEul8Cg?=
 =?us-ascii?Q?HBxGIndkh4Auctn/Gal3TqTnS43fu//YqFGqbqtIJPEMSuLi7mWlOZnwNxzG?=
 =?us-ascii?Q?hDdRQ8kUDholQZasKbTrCO3cv/tzoxVEM9xVMB0/V26OE6y/A1uLU6wLgP3X?=
 =?us-ascii?Q?zbZbWLTdPtZEqNupf1llLa3+v+1RXIIg/f88VE6b8Wd9QQ1pYEifHhfbDFmr?=
 =?us-ascii?Q?pMaNB5m9dG3QlVfop/mlGdpiuCip4TRu5CBwimSLZ8i2+l9/xVMdKqQQNK36?=
 =?us-ascii?Q?Jv5dmtvtFgyFdXl3HbruS1qSBySlk1yz3pKD2B98mXf3P6z9dJ0uULJ2DAMF?=
 =?us-ascii?Q?qwE71gW6XuqBLvRxsGAqLMuyo2bdimmnoMWFwRzegjWpxbtQWvpcfqiDSeqf?=
 =?us-ascii?Q?iJoe9FTRP8r+xldpRtROhMumhecuJbPbU9TJnrex0OWVdg4oX572DgXOAUIQ?=
 =?us-ascii?Q?SL9x98YQGpTKj/BKxbYYVO9Em3ZbXXcmCqfLRozGGsNoxQLPNhtsCBCDL6A9?=
 =?us-ascii?Q?hRxOBEJSaTLrlcTErXK9YpEtd45ljQCeW67F35qm3DnIlsWdVj/t7eDgqQCC?=
 =?us-ascii?Q?lWGNmrAFZR6Mcri3vbfD4tdXGV9pLr11mr8Pbs8Fjo1J897oae0mU9ITzghV?=
 =?us-ascii?Q?TAy/rxONid7LSCr882DDlzgr/reCb2epBsnVmGRUwb95vwY0zACwWlCxgjUE?=
 =?us-ascii?Q?lwzLI4NDKZpUtCv56A6tvR8IA1idNcj+v0dbXY2EEEra1nxBHz/eyNm2zBlh?=
 =?us-ascii?Q?I+Xa5X3pHh3BA5tQh5bNw1YrxkVQVl/niBRIgPBtOBDR3qe2JSsBMQHFO760?=
 =?us-ascii?Q?jgWE4KOR7qHVCBiPNAbJZartZE66lDDumUxgMobI9+IEcG9nhcHlbzvTGbQo?=
 =?us-ascii?Q?cj8fxptBOd101hCNJVO83q8ght2P/PG09b7E/LHjxZMlb/1fAtsY6/cXWFex?=
 =?us-ascii?Q?jgO40jeoOC2ccnofPvxR/arfUlpIVVM/QwPuCz27LzB+tVfz9ArthgEQAlsq?=
 =?us-ascii?Q?tVpwHpdP3QMfdCIAb+1hHsKp5byu+jBFL0wdFaIE6fmFYZyUn6Lr7Ed1YFqS?=
 =?us-ascii?Q?ET54eycJPwSyIr3dGJvGPCpCSzATGHz0l2Su8UVSy1hJnLxywWKBM7j6/pE6?=
 =?us-ascii?Q?75lZgny8tQd6z1uYXh3j/7v+55HLd89kQAvkcgAPOjE2J4RN7yFzIdGpcf+W?=
 =?us-ascii?Q?h4D3UXau5Ffmv6HM2XLcVA2GojiTOKVnDacU6wJEvW7keVK3VU/AslmVX3gv?=
 =?us-ascii?Q?DNxyArqxEGzRKMuv5jCxaMQjOjIr2afe6TOpmyBnZ5gqjphlmnjdOrPiQGmY?=
 =?us-ascii?Q?GCSXrPcmASFc+DGo0ssxctVeJFctxBMus1zM3YmgPvX0yTEBVESOO3vdjx0T?=
 =?us-ascii?Q?QDQJ3K4KGpA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yMVAsU5tJ/tBCwAe4H56zld/Z31HS4EMK7e+nxSjBeJcl3UcgwoJfhV+I68Z?=
 =?us-ascii?Q?6Bf1T/6h/n0Zf1jOw3tXYWcRsfYOeQ4YLcGhAN3ZK6khqpvzgeS7Uxs64VMU?=
 =?us-ascii?Q?b1YooiWtnOA7KOVVJmE9R0nMcw1TawyUpSUDvUdxOqiUjYOXesz5tNmwzb+p?=
 =?us-ascii?Q?ZicsvO5QQI+sYfD1bSNcFLKvpJQ9RYr+PTr3MWj06UHpyoYtlLnbsu3Ih3KF?=
 =?us-ascii?Q?AV72vpcfbiq8z9wS2ZlWCl5DX/pjKS3Vzn1GHSbBH1pFigZb68laihoZqSLI?=
 =?us-ascii?Q?aPnpgwf1s1AwBys97QNhPmKBYJqH3xwfchVR2z9Luh6BYkyc3oqZCJAQG8pq?=
 =?us-ascii?Q?Z9kXnl79EzS+REDVLWa+CXkZzqGOrtZ+QFbaE/VPOKQd5BXGfB9qzDgCh7WL?=
 =?us-ascii?Q?ntU6tSFhkUZ3QFVaOOxXxkleFQPz5djqxrQSZhC/QvwRApVm7q917J1H7yDG?=
 =?us-ascii?Q?uaCPLhkEkoC+u7s9bM+ZqqbLUZhNvu91vSeq2EqJUY+wB/vkznxU+l6Tcs8r?=
 =?us-ascii?Q?cDrx3Qxz6+MnJ9mi6To9Xntb4GWW5ERzflPsvdRg+HlGuOckHBv64V3znDn8?=
 =?us-ascii?Q?4xhc67tRhQUaqHBGHLJ529z3OdKPOjGZD0LNFDskJH4sLUo38rgsox6VJYOv?=
 =?us-ascii?Q?cP+WjCquadHZIkyYwxaFvCVOk80be19/HhQmu++7ZI4emxz/1cmV9RkhqwfJ?=
 =?us-ascii?Q?zc8apxIGbWCWVHMcHP0XXZWUKzpGdvHzqKr+VTZvUQ7dIsAJ1QuHeli13Exg?=
 =?us-ascii?Q?fK40DBSvrAzuZOuYLXIOApyGNzPHttmbcpFMpSqN7ok0tRsnG07bQU/adFGU?=
 =?us-ascii?Q?FWTRaDUK8C3CAQr53lszfXGRtKlPIOMnitFE//gFGMBR8jTTKkjh4jPMurqE?=
 =?us-ascii?Q?5dv6R1pr0XSS/GGorPjYA5of0LFRfnadEKUKZ1z+UTfugU4wYlojfGS1S3bf?=
 =?us-ascii?Q?D7LyDmy92JAArD4zu4gpEDz7iCzhMENZVWvgpIF15j5e2fNjyIr16zp3Ra4e?=
 =?us-ascii?Q?O2VFosSaLrRgTaZT63FvOZU7u5SFfIYmfdYXkjfy2XM7BbEKeLkHAdDVyjs7?=
 =?us-ascii?Q?L7CYrr2rr4NFBZhH6NmxyuHFSgoYF+K5j8mpwp89rXpFn/lr99zgsYZg7ibt?=
 =?us-ascii?Q?VFyZks1RpEnT33yYdcLUF4NwHSVn6IKsK4GrVG2pkCOSJZJmqgrsChhgkGdr?=
 =?us-ascii?Q?bvG6Nm7Vst2iCMpLldyHiqhY8K0mrZ1WpRm0Am+foUEIyvgxV65oDiMzcfm/?=
 =?us-ascii?Q?DOEArgzrs/gU9wJte8ry6J2NW5P/S2TANShByU5tB7DM70S7vydoWF9LOFtq?=
 =?us-ascii?Q?u65cM8hrZU2s2l3/VuVnCNVp2pWuAlUTeMSfyeauW6uya5WXVK37lMrqpph4?=
 =?us-ascii?Q?PrrcCNMFsKSYWqshrRxafm/2ZF6BMm+iwzY4CHppJORtgZIdQsd+otB7iK9k?=
 =?us-ascii?Q?/8IW1MSg1qrnZ/0s7F38DmQUqwOZU0QWOAv+EmpzkH3yuIkpFIgI8G9mSl3u?=
 =?us-ascii?Q?qoDAmjM/7rKcc+ZnE3oPLONG6MQ+wgqz/VXPsjhakNva3uh2OasRausA4DZf?=
 =?us-ascii?Q?1rxh/AXc8+VJJPLLjmsq2Lk22dsGcjzjuWzF0z1YiHgRgWeo5E/cbY/aOZ5F?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1m+Fdkf2501779Xw/SYBy5aYKljlXPhN2lgVH1YCkg5/j9ICeLbemeCbwYO0INZJkvDDw2UMq2j6x9W4m0ITAAU9WORbfR5d372V2fC62hh4Gj7BhbTxgCVtFGxXs3EAcV1di+c4YMjz3lRdEpC3nF8ae9aqL/KOcbU6CkPj3IJVkWufhtDjGhdhn2ELSAJDZU2NV8zwBop6lQ5wvoftNd2Hp0nZAmX+eWlITS6bw2PSjiRWNBVrAaktzRp3naFoexkHVL5ERdrFyzX3r64m160Bclb0qpsYA50fFXfyfojReOHdGRdxSlj9uKBJxMIeVjGKWq9jZOvJuKj6Ym6p12hR/IrSfyLog/VWrySp8fGw6oS/vhH1TzzGQoBhRk8p/Go2VLYPHfa4vd0mZR0MYDw2ozU7mRLyz+zTqOTwaijzZu8wg2htroB0BMJt/yrVScQk7OwjQsy/wL7rTL491ZwH13hYP9KG2yZ3zQkJ368raGxak4D/mbo+l4NYOheoHWbX0uhBZO13I6f5PLthEtsi4BH+c+mCgs4kXz9M5JHW/MsaYt9glPTVNuavc+m2bQ4okET6MOYeNrsZr39dVDHphDnrAPLSGcvXvIinelE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68f0ee76-9007-4729-3b5a-08ddd68a53da
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2025 14:46:15.9149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2UGsI99e7J7TDIWVZ6fevgGASTk1ezVSo0ZV28laR2bJi7lSK+Ddq0gH1cJRJFSZYhfL6BydkuoNoYOBJgVl89mGxcMokGZ4ej/UWgg/ue4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4714
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508080119
X-Authority-Analysis: v=2.4 cv=fYaty1QF c=1 sm=1 tr=0 ts=68960dbd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=6JWAElMpae5xf6a-faYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: ZT0PMU8105EFxESWWjUIyLV3u1IRoFeD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA4MDEyMCBTYWx0ZWRfX4/3irGhT3MxH
 ySCnoyk2i+fqMZSdnO1qWVtRFx2ZWmw2ObYsJnButgaOZKga+rO24DszaRmARNc/kiumIQylDag
 Ys7VMs78VBfb4MzKXnwnq8snWkfOUDz9fyviTr6R5NOaK1wXn4BKuQvVSZ7HhY988AI1rCU3lOD
 xCwIY9eNP8W73n39P35vnAcpMsiZiDEub6mNB+IkGmGmqWD/JrpyBerHDxgiLCIcCdA7al7vtZk
 2ydGFgGg5pX72+ToxIyEZjHGBieWT58SPhTYev1mowtp0CKqeWxcvBoVVdhuk/EX/Ca6C9IfTqr
 vqqHcRBFPgYDMTYl2jfxZoW2qNzQ6qKNHwxmUeTnXGD2//q1oHw7s2wbulpKkGGgkaF2COj0oiV
 BlJLdKVA84KYZtGC0hVRCOgBQH0rQ3+w55t5yhN/izUGy0gK2e18pEoHoBN5i1qQDSYpAdix
X-Proofpoint-GUID: ZT0PMU8105EFxESWWjUIyLV3u1IRoFeD
X-Rspamd-Queue-Id: ED48540013
X-Stat-Signature: 8a3codqp55dojadfxjm6g8uud6c7sng6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754664385-149180
X-HE-Meta: U2FsdGVkX19/L6YFSUO3MgP+QwTAdEcuQo4iZYm0pRXeidnqJJBBTJZ/5wXnzWRFLQ3ihmwgw2hCqTtiEl3F4tAYcFhcd87d1iNg8XVkj5CfdWBnHgA58i1RcwdUl3TOWKIvmUQTEo5eetAq8dbykDCikQ/GwOkbmgvXUUozrTqZDyf+UUMGm0raDD/pZs4mitUpGkAU8XMlTpgk1BBicl97xIx4wcdLS2lXvWLAsz7AX0dextJJ2qVAlOlZI0g4/YOZMSBMzuWPfPubIVdWUQjng4ph4AZL4dkFQ9prKWMVNuNwfsn/Zb4Zb6oy2oVxDB0HZpQQpykF/t7kzIC9vLLxXmZampVKvHkDJ9VDaXffgDg5Kq/a61BveeGJPkVtRb3D6rsQ3lR8pTWGLoewNk69Yw2OKMnMH2k7r/xBBBvouWxNjBS6vNSRCKXJm4o+uljhkJuaUGaZUBq57LOF3c9cDrGxC73iUWQgKVrONQrnveIUrFiIRLlQ4S2bbBfqJAforAFxkaGXyi5P2thVkim63UcJJG3gL2gkKW3q17s3mzchrikuVvCK5PKlTRyDwzhFDK4wD9kCd3CsOwS4fahsTy4t42PrL19VPO0Xk49QdTF0C6MQIyj1aBOf/zzSe0tqCyfwxnsrucp21dG094V2IgxzgxsEaJUjSBY2sEYiu7fPTD13AJUfu3iU5mEgf9Lp2PcyOD6nXqcHdBaproMOYtx8z12ZXg/s/fLhvQisId/WDpf9G44vqay8vwXJZnlDbEk2sWJBjIy0F3kDIDP4wOuEHIiU2F+BrENS8jSnw6s/ez59LSlXZfmeRlhbXFb8eiK2jg0UUmKOY2qYqYe0NW33UdBD0I7Gt0i4Gsq95S25NDjXRs/QaKoJQHGk9+F8fCmFgE4M/C+2Ka+4yBLzbDHtO7YeM5g6tBQLB9+QwsiuLzwu42L1UH+y+PNMNdH8gASpzPgFTaL0dcj
 WLw8sTqS
 HcKNE7lzblBYkoTRRFIPokrO2uf9v14hiDRCpakjJSjLHMt8re3e7CZ2VYcdlFb6IPE6P8+E4YZWorcJQODxpnJwW/3WzaWJ2M8ZcEoheMjV6puoYr3gZGync2g2wzFzmZFc2Gy65jLIMPkFDmvQ34PR57PJ/nzHyAL6wXG0COq3XtRlXBOEjrfrCAJPKdjjh5NFN7WF+qYqJbrn3GwPe2aQBAWoSaKwzi1Q21FodvCFAiQv7zMh4YcjOG+7JQrrVjoMFiPs6Ls4JZYwrPguCA+mcyNrqwdKBeJMH3WWlmfUS4Ob+8REMcbfwuaKRK5A6CE0XqXBF6ixSLuLkPkAyuPzuUPJJSNAIcG1dUMjmVOYZ38IXZ9P2j6hGNrul6TwYCJfkjE/XVWY8PlpfOc1c605DufrrtF4i4b9CGrgxLIbzw3xLwZLFClnUVfJegVyeeQwCiaXUIXLu4gXZI/6Q1vFjylcwt/QG2a6eeyH0psjGG7jnk3s5edjErmAgBhXNsxoQ4UjhXsENzV5Z6OMfwy24dqd2m65Q2uEHC6jgC0+9WAe6Isp1X85DJ9aFe7db5L8PEHAoeA4vsDSm4xWsi0/iSScj1Fu7s39ByXAUxNE22ueJAa6J+lahaevBGDxuM3e4T6rwOy13l4X27i6C4E1pTwT8LuQsy1gEDB9GK64JzhlpspjvT1GivDcaFcFxoQksj2ttmyVuvL21oVFCcPWJPYqf8O99VBGt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 03:34:13PM +0100, Lorenzo Stoakes wrote:
> On Fri, Aug 08, 2025 at 04:19:09PM +0200, Vlastimil Babka wrote:
> > On 8/3/25 13:11, Lorenzo Stoakes wrote:
> [snip]
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >  mm/mremap.c | 20 ++++++++++++--------
> > >  1 file changed, 12 insertions(+), 8 deletions(-)
> [snip]
> > > @@ -1863,9 +1861,14 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
> > >  		vrm->new_addr = target_addr + offset;
> > >  		vrm->old_len = vrm->new_len = len;
> > >
> > > -		allowed = vma_multi_allowed(vma);
> > > -		if (seen_vma && !allowed)
> > > -			return -EFAULT;
> > > +		if (!vma_multi_allowed(vma)) {
> > > +			/* This is not the first VMA, abort immediately. */
> > > +			if (seen_vma)
> > > +				return -EFAULT;
> > > +			/* This is the first, but there are more, abort. */
> > > +			if (vma->vm_end < end)
> > > +				return -EFAULT;
> >
> > Hm there can just also be a gap, and we permit gaps at the end (unlike at
> > the start), right?
>
> I don't think we should allow a single VMA with gap, it's actually more
> correct to maintain existing behavour in this case.
>
> > So we might be denying a multi vma mremap for !vma_multi_allowed()
> > reasons even if it's a single vma and a gap.
>
> This is therfore a useful exercise in preventing us from permitting this
> case I think.
>
> >
> > AFAICS this is not regressing the behavior prior to d23cb648e365
> > ("mm/mremap: permit mremap() move of multiple VMAs") as such mremap() would
> > be denied anyway by the "/* We can't remap across vm area boundaries */"
> > check in check_prep_vma().
>
> Yup.
>
> And this code is _only_ called for MREMAP_FIXED. So nothing else is impacted.
>
> >
> > So the question is just if we want this odd corner case to behave like this,
> > and if yes then be more explicit about it perhaps.
>
> We definitely do IMO. There's no reason to change this behaviour.
>
> The end gap thing in multi was more a product of 'why not permit it' but
> now is more a case of 'it means we don't have to go check or fail
> partially'.
>
> So I think this is fine.
>
> >
> > > +		}
> > >
> > >  		res_vma = check_prep_vma(vrm);
> > >  		if (!res_vma)
> > > @@ -1874,7 +1877,8 @@ static unsigned long remap_move(struct vma_remap_struct *vrm)
> > >  			return res_vma;
> > >
> > >  		if (!seen_vma) {
> > > -			VM_WARN_ON_ONCE(allowed && res_vma != new_addr);
> > > +			VM_WARN_ON_ONCE(vma_multi_allowed(vma) &&
> > > +					res_vma != new_addr);
> > >  			res = res_vma;
> > >  		}
> > >
> >
>
> I can update the commit msg accordingly...

I have asked Andrew to update with a clear explanation of this (see [0]), and
made clear why I feel it's consistent for us to disallow this behaviour for
non-eligible VMAs while permitting it for eligible ones.

It means we can simply say 'for eligible pure moves, you may specify gaps
between or after VMAs spanning 1 or more VMAs'.

Cheers, Lorenzo

[0]: https://lore.kernel.org/linux-mm/df80b788-0546-4b78-a2fa-64d26e5a35b8@lucifer.local/

