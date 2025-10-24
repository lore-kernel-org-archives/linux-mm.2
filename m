Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A03CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 19:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A29628E00F9; Fri, 24 Oct 2025 15:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00DD8E00C9; Fri, 24 Oct 2025 15:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A1938E00F9; Fri, 24 Oct 2025 15:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 766EC8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:59:16 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF02049461
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:59:15 +0000 (UTC)
X-FDA: 84034071870.12.6CB72CC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5A9E24000E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:59:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Fy0/6fCU";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L4roEqGu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761335952; a=rsa-sha256;
	cv=pass;
	b=8I20EswbeiUFHf+G508/HYU7OnzHIWHhPNor+/R9AXpJJZvFtXKLYuWezFHXMOunxIZ1f+
	qk0doznuxmROrV99Hk5hGtHyO6TM59oFwIkXuH962tQOYVzQAQsD2Mzoptte7QcjsHJKob
	6AKnCt0jEEaz+MaKpyv60zJRUlFpYqc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Fy0/6fCU";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=L4roEqGu;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761335952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dg7kH8z5KMxdDK6Xd+N2Ma8t81z8KcViPNyQxFSZLDk=;
	b=NGVPtRVzevoZyljfSNXDbTaW022ogXVV2KaI554MY3w64NI8a2jqqp7ayEmzvwTc3IkZYt
	zQicsoMS7dd4UYXcxDj+fwRyX0w/0SPb2DBQL3ZFxO/S6V7nuzxGKFaHmD12G5t28QvKCX
	lEJBwr8GxYn65o0K0ZBqDmCbx2s1DIE=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59OINF6L020056;
	Fri, 24 Oct 2025 19:59:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Dg7kH8z5KMxdDK6Xd+
	N2Ma8t81z8KcViPNyQxFSZLDk=; b=Fy0/6fCUwuFsa3TqsL+FGY/WNGJNaMnDSP
	LLz3rPpIbQt8qfabxwvcOOn6cZzY4jW12/p0HT0mOQWLBA3lmsAD8O4N4rlZwK4/
	LRwzBhHe7VLSvmGXux2biKTRV98tI7aAPP6hjW3XK1FqXwX/0qGv0Zsb+bmfLGw7
	f2L9zBPMAvRSh6SdRJkB9z930nWAI61+iOxm63j8WVWu2oT3TvbCaexI9FAqKdB2
	LoH+Bn9GoIw/Zb3x/PI+CzsLKYrVf7sXURp+tKyZ5LwNd9pAhxZiDVZoRG9b0en/
	qcFjj/qMcWYM1fODHVTwG4db6gaJ8Su13k6JkPWlpTdaQsBGMoFw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49ykah39jf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 19:59:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OHntXc023242;
	Fri, 24 Oct 2025 19:58:58 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010069.outbound.protection.outlook.com [52.101.193.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bhd2fu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 19:58:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kdQMrd3ZXgznKl1ELNieXO1Ln4B5dek26GumVIv/em3AFw85Q28kS/tuR61vuBBJTxTj1XmzS2czS4kEIkF4D8QVSb/OXCBtzgpFQ3k7RT1ffSMEONBOPHJh5nJGsvTe9+iN/9zPxFceTD0IXeaJgaBGa6fJCAPsK+6qa1p//g38OtEryiu3w7NRGeFdQZu2of5xFMeAhqAaXslWio3htizQQd4Ym6q83pKn2jX+97WV+8hztbIjM9mnweaAVU7fwVFnmd1UfO/S0MEDX/Ge3ry3jyXxrTsC/S0SSmqosUyT+OBw7VwOSDO6PkbYHSrS2JUKCagZZ70p6Y5LiVxo2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dg7kH8z5KMxdDK6Xd+N2Ma8t81z8KcViPNyQxFSZLDk=;
 b=Vw08rZCyfs8yrAqPmplRBJTzGE8A/rKLMQriDuywXnM3167YCQ6QcLP5Y2r3AadH/3Sl8iDMM0FlyRLe1oDFaS5CbYf4gNtoqqEKHPMMlyZjVwTnjtHiCU7wDNk99Rjtta/6puSYslsoBKpc6444ncTWG6pbAP4+tvFSLemTZXLPCpQA/7c24qkmVPOb2vyrcBcEOxObY+DFExZkI3GxWQ78R53Rlf2FzFjRyb7j5AmhF5hV+b4fqnG7sGtf3aW3uXMxP+pskZP8xcHmDtN36RwzMDPuOPi24fqyUttQ2LlbmmA9eB4T7YefzGiW6iFqEgv1zXVn6rlGPFdRjCa/+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dg7kH8z5KMxdDK6Xd+N2Ma8t81z8KcViPNyQxFSZLDk=;
 b=L4roEqGueN+UveAsHt0w1CHrwAxbQNvtfiLRIzj/Gwy4EfsV/peA+8VO/jc7La6SQBgUxRrlLyjZiSmvsTPda/a2ALgyef32+ZY1iyViTx8UPjPQR1RMm5CWy0dz7aetaTaeqtfIVSf80HGQiUWMWdeG0VkF9a1iFmK0BZCKZE0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB997654.namprd10.prod.outlook.com (2603:10b6:806:4b6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 19:58:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 19:58:56 +0000
Date: Fri, 24 Oct 2025 20:58:53 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jann Horn <jannh@google.com>
Cc: David Hildenbrand <david@redhat.com>,
        "Uschakow, Stanislav" <suschako@amazon.de>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "trix@redhat.com" <trix@redhat.com>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "nathan@kernel.org" <nathan@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "muchun.song@linux.dev" <muchun.song@linux.dev>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
        "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
Message-ID: <6e939a0f-3011-4a69-a725-6fb09880a51f@lucifer.local>
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
 <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
 <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
 <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
 <a317657d-5c4a-4291-9b53-4435012bd590@lucifer.local>
 <CAG48ez0ubDysSygbKjUvjR2JU6_UmFJzzXtQfk0=zQeGMPwDEA@mail.gmail.com>
 <4ebbd082-86e3-4b86-bb01-6325f300fc9c@lucifer.local>
 <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1JEerijaUxDRad6RkVm3TLm8bSuWGxQYs+fc_rsJDpAQ@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0524.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2c5::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB997654:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f92ebd2-23ce-4158-1dc9-08de1337c3dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BmBgy6/WVx2JCbRC20gPweuQOdNfKC/8ioCKjXDXSvEeW1D1OVzL6QUaafHo?=
 =?us-ascii?Q?HtwqJCEbFP+a7dq0Jcsm9VHq1GkBXR/ULhiBRrEgJGzri6MgDT5/aEhh9/3N?=
 =?us-ascii?Q?9RthrHyJpSKJJvZwqANVt1wF+UV+/yJy6r9i90OvDvS5MVqxMYmZn7jMUrwo?=
 =?us-ascii?Q?EuqnSMxP5ZAJPeIXu6qqt30r2caATrLpwAt/G+AQjdSVV7l97gbEJP3QdfkS?=
 =?us-ascii?Q?3VmLunlYAwdD9tFL9TdDysmuuUnvqOq8dpRYQQn3xrhuIQZvT5sTC7AjzjCb?=
 =?us-ascii?Q?MwgxvmFUyxY5A/IMsIbbDa0FGqA87upEnKkmRHWLmyKiCPbVDhctnUUKbJXZ?=
 =?us-ascii?Q?2bxQScCJe3xGqtsfkq1xU3ie1f6hDGzui2juPLld2dEyyH1+bKTzIAWTzw9V?=
 =?us-ascii?Q?gKxdtPg2y4dunJVaTEH3I4vwF9jBJ9pq3m3NXaeLP/GmishK+kLrxYn4Kfng?=
 =?us-ascii?Q?pMaLPbSpdbqhRc2fKKIQzF221gY0rsSzLhEt54KHeRxtyK7YsiKOVzlG6iz2?=
 =?us-ascii?Q?ylTmOTMN9qPpxnrf9oA7qauGVjLS9DKjD/izhEaeXmpw70CYm4zvDK89cqfO?=
 =?us-ascii?Q?owEUsX3lSpZ7FsmzRdWaFsE6NSvdSqnWop+pyI3/6BckZa3V7F8LEjHacccJ?=
 =?us-ascii?Q?teH/S8ZnWtwZKTaAc6OQDfoqvsQyO2aF2CqlT9ek4b2leItaPv8pwb+/Jaip?=
 =?us-ascii?Q?QvtmSPijzntNgUU0UEAxgDCZ7lzzJONRCsMx4yy/KBfRGi+Vo6PFu2w4pATD?=
 =?us-ascii?Q?fJSmALyMrNgDl40G8nTMs+oMF/40UK9MCJfZF5/O/02/kh8McIuae7BFj2zS?=
 =?us-ascii?Q?uUln5zq0cWBiUmlfSXPkkNzQumYo50S/lKxClOBrvbYAeahXVzCHAHrPRg16?=
 =?us-ascii?Q?PZ4qrmRXbhnRJMnFlPd6M28/CeCrgbj7c2GDm6V2L4DgBzqVlKemC3RZUcjR?=
 =?us-ascii?Q?/kXZhnT6uWyqqmw/VluS01qosFeNGoD7d3cnpCRxJRfSLA2uVYiyTToIVUsQ?=
 =?us-ascii?Q?gVAjVBr6D7IqLnISu6pQEY4RVSWrqu0kCCuyBYK6RXq+t98xCQzOADbpD8rQ?=
 =?us-ascii?Q?NcQUKKEyvqseW6XQBbBjH5zfRW68Ofm7YiYsT78aFF1HEm9kO3SeKgr5jZdm?=
 =?us-ascii?Q?+4Lhp9CmM4T/mXahbfQ70zDcCfDr+ogzcUCwm7XmUmJ+fyVWQogufc6eyPGi?=
 =?us-ascii?Q?gy9j02366hBPlamVk9HOWid5fEW8bkhR9BCcKXzqZilRDz8Rdfjy/Xfpfzy5?=
 =?us-ascii?Q?3WtGaI1fvsBh5pnMdlbDGmoIQmqD/EulYEYTvkyR1tVsBzBCLVqxWM6Y5SSO?=
 =?us-ascii?Q?ux+dHyujqkBw7z0tmfxGNGLH/dCyPCRSLW812eLvp+5SsgC2rKqd2y8YHg0N?=
 =?us-ascii?Q?ZoaI94D4+X+zZOPKB0YzxeLKnlvDpRh1LeUEkTaxJyRNDOsUw3F+SlDh3Rs8?=
 =?us-ascii?Q?/UhA3IoUhIlogo2qrWsSI7Ov84d2suxA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0Asost1W7Rd3umd8OQchw9okq3M09Sz9QYaq2pqWn7J3JccB+nwEiKDJt7UE?=
 =?us-ascii?Q?vyMuuEthSNNkVfo3CZZdFZNOhtmpKWTEfKVGa6y47/a0rzNxfLCBprfTqoXV?=
 =?us-ascii?Q?wR53NFLyMfBPyTxReaF/z1pGybhlt34PGyf1L5Po/ewZOswtLwdQp0mPeoMY?=
 =?us-ascii?Q?C9un+3lxvK68q/FJTLHwIkCkq1EJwZhv+Fpsz6r0xmxAmqyexvB0M/PpXT+K?=
 =?us-ascii?Q?GiS+h6wsBSMvRFcYGqg0uewsJobtDx/yzHq1igcIXOF0RAtra2C/27ehpkgm?=
 =?us-ascii?Q?5UlF0oNA7EKJdrGWPsknIWIKsA3WJKxgg9r5Mc1Uez7/ZvY9UnFscKqpNPO8?=
 =?us-ascii?Q?hHBsPEzasTXUsBLd/JhSi5fjZkAWXj/CHT0kdn2bbgcGYH2GIJVSQID24huE?=
 =?us-ascii?Q?mNMXLJ6F0wvvOhesmTlXIO9rSKikq3uSNZ3TpGMUKmyZh7euT5rmqmtU8gcn?=
 =?us-ascii?Q?IdFDAwP/qFx9EensAd0MlbDD+EgKPs2j9heuo5bBFUqqw4Ry1adPE84Aiiq0?=
 =?us-ascii?Q?0Tihn6k0O6/iL8to4yfube3moV/PUxMvp1Gv+DrCINjUWzY7XITDVsnpqa24?=
 =?us-ascii?Q?gWjZw9pZXeq0VTZFTDzfRiKe8CGDWiOdO18/jREn4+rKA1JDKi0A7mUN1LDW?=
 =?us-ascii?Q?cVcQ4M4P0tzQRRj29Il9KXmcND32buWxU6zZ+Eech5gCVqrZyNNrpInbMeJx?=
 =?us-ascii?Q?RFdQoc38r39P3bdMlA6v5eNEGkMk+uaE7o+gk9zazBD7mk4dorz45464jQCC?=
 =?us-ascii?Q?ZDos+sxekcb4gLjXkLqMEFkGtlVHzIlsGvpTM8Wqs8JmdJSyJuXWe78Pm/Fh?=
 =?us-ascii?Q?ByiGarhiPabp8nQ/kZbE8Gb8HxOthNfql/k7d3rInti57lgDz+/3SchCf8I0?=
 =?us-ascii?Q?64GCA37LaHWL8zX81eRdECXqY4Rh9Ik26CO03geXHlW8X3eBdq3oiv3b8ZAX?=
 =?us-ascii?Q?uhTtAwXLZhjfo1EdREoveX04VnruqLrrnkhdom3nccMAfCRQlY0Rqdg5Wrue?=
 =?us-ascii?Q?RgNQDy/A+SSzcPqMBzyTwJMF5IEREMSHpN1CZgGDnVjnRSWKOy9Q/fGQhD3J?=
 =?us-ascii?Q?vl2+aHXmOd9yWxW62qb2Z0e6cDAzJdkShr9GnwAMLg61cfo9GcmGhqStQcHH?=
 =?us-ascii?Q?3C4O3Fn7kjgzw20JlPm3PoaZVJsyYH3Js9MyJnXnGTpHO0qsEE3SlAbnzMcO?=
 =?us-ascii?Q?soKOUFE5ULBYszo5/ly34ImG6z8uKGQB/pC49ubBEBGs1+MmQKxjWhVUqpen?=
 =?us-ascii?Q?PxXlqST4dtU7v9gKu4OG/fFHaaUc3SPtZoQp3VaX3AaiFjl9H8p9BnuA0Ntq?=
 =?us-ascii?Q?mMDGpQWNmXH45cIRiYV3K0CATaJGtYg2txPNpRURrFnOh43UD04SkfnApLZN?=
 =?us-ascii?Q?5Bm4qjgMHk95BQXbOgfF6f9OD31/voHzwqTlIGx1LE/mTp1jwRhgIT8gZ0Ts?=
 =?us-ascii?Q?3oJ+2uLgUGV1LkHwmiP4Sxyrg8bVYQCkMTZr1aVB9OQY5Jm8yjCbR5lCfAQu?=
 =?us-ascii?Q?pP2jtCorjbSBpJNGh7NTBI0SSWm+l9p01cm6HnnsrdXSU+H/0r6LaT7Vy6z2?=
 =?us-ascii?Q?Rg/vvIh8gLpnloLZFBlVTZQhGPq36cBxFBpzsr+ZYuvvIx+kY/1LUMuuSyuO?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BXuqea88Xl9+2VFiQrsaaHqImgv5bqxwz/FIolaQLbjhe3iSnKJBbhnn8ICTSuXzpQS4OMmwAAi/BMtt4cZiwTbw53r/Sla0ht85akLz4mnbN94V43AXGbPbdzuvEdmyCnF0zUszjwhIBc4Ja2FnzRtG9GUpwLxJSEDrkw5I2eHizFVBvdKOZFOBWlt9cebkpB43/DpVy043TR4zqdAC78mhwB2D5HJff7vuV/A6qSIjHdG4KISc+k3XTlafrWqu9tFOEvHzjOrzxuZzQVphNB0QVCpAjcXBARvmmWRLQQ1YYhAcGQyVWCeioH7q44frsFNUH9ZMh1rkmHnWZQ4lFbSORfol4Z9eLli8VcvzP9waIz+3Qoq4KkcMHyVJTyxv81BbFxQ6j+7TDq8TTwFM+O0GT9i0fsZ5ZfluV/8KicdHrOxn7ituC3ICwLq10CWxw7bfl63bNFz2uhawAW1jyWCfvIBLq1nY+I6SsffNSzJ2LguuOs8lXIGLY0EFx+ZaWZ/A5qQZY7xf5mYtSg1D82pCX3VX8fDhWt4+cLJiNZF5GqNgomdTALRx3TqGlph3cTj2mGRsQ6vVDkju7eYp8lSlyaT48kgHxJ1mjS7eaMs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f92ebd2-23ce-4158-1dc9-08de1337c3dd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 19:58:56.4074
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KG8cd79/mbkCxRb6ZV8iZnLcyrgUiyaek/9y9hPJ145uYwJXppSy+8Kbv/JLuLXfwQxoTgVRyt97Y8AECnVhZfDWqYxf/7VJ/tD9MpUCiLQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB997654
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_04,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=923 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510240181
X-Proofpoint-ORIG-GUID: j7N13NkmkUDvBP74yMhx_xxIJsu3UjU2
X-Authority-Analysis: v=2.4 cv=XJc9iAhE c=1 sm=1 tr=0 ts=68fbda88 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z3DuqeTXpcLp3XrOtOcA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIzMDEwMiBTYWx0ZWRfX6/7EEvNGuCSt
 SdJ7KnFMUcdv3k9ZfPdS8JMe22CQbRjjSowDFK0uYPEavrTJdCk/FymWNd4bFmQWifTf6r2CyjO
 wi6z5pk1+v8+EUhr9bEjMzTVteux9hu2uZojNP7PFTxpyw+ipoOqhXti97Ng9Fldgzt7iajwMdh
 wi/w8+lAdqpWo4ZXGlbulo2Wa31OVzPjzJC2iOxY8gcE5SrwdpaumjDtV3wxIQnEFm2AwhB4MvM
 efsK9tANEJBv0ZTJMHpvVyH/euHSCpxIIteaCt/9SBRjlLEaqTWRgo9S7+KT0xr0vbIDo4l7rJj
 1y7BEfqVjVXMsiRnRoTLkbcztu+h9DaYRmy4Y2bnz3m8NP0YJyHU/+xXiJ3jXtfyNuZaxdOv/LA
 R7xIvVyCS2yBseNqTj3P4HZM2ufPjTm2+CnKxuvCF1PeFjQ4XUg=
X-Proofpoint-GUID: j7N13NkmkUDvBP74yMhx_xxIJsu3UjU2
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5A9E24000E
X-Stat-Signature: is31cw9hzm1eg9w8pzjf83zopt5p431b
X-HE-Tag: 1761335952-784514
X-HE-Meta: U2FsdGVkX1/+V2Or4mWsKEqedVnmDzBWfOjDDRQkB9IbyQdQykQKd+Zit9PmCWW+eKCzT1B20aOV4DjtSLXJro249YggP0ZQn5lEMdwPZtfCzsNiTvYxd2LB9WtE732C511lu3YVKbKwPbAZtzgrN2mfVdScJZfNfygCPW4JDa/L+fwRZmUR+gl5BzHG/INMU8cMqVnpUcj5DZ23dMT/U1xeUHxG3uhKWagW2DsymQR+aDhWYwJrrL1Y4qbSMLyIIVfMPbGtzCg5NF0jBZmI17sn4NYIK/P+IVRhAkId4WPVQYnGjYo7FPbB56937uKv4YcN7y24iyTAx1PEC0Ruh1k3vOdNm60Zg1/6ubCKOfpKYVEBKnM6zE0SunCYtam3dfBhvXwhL/qktOsG39HbY/BaSmthqktpR+ehTZR9OqUeXkvxubB7WKQ+Gh/Xl4GuufybtVIzFBSD+TDmjlAxgE8niBEQJek1MkUQDe++dgw7CoWHw7wnPTD+BWsBiPyrQ4kID9NLjS6rXOwSx10gP/XOR7yexijGbRuxQeuF3itNZneAUazmRY1cY2JkZ4yCsUn6ke6qdJNgpm++W9cDqUB7/iCdutVf+FG65Om2bEWcsDAEVrBvSq1hQLKcSonqZPBUDJ/2QLwcokUiQvRnWd/j9By8wyHWtHPxvGOcOIpn8SH7rdwYi0MR9ArrsDFtgJcvKFsSvHAb/K/IcZ2eZW+m2aMH7hMonBNzqMyDcSOQ5c2h2sxclqVoAfJxGA4Xfz9d9jEWgGNMKoTTs04E7sxwq5zfrs8NcxxD6tXigTSqkiw0FxOY5mfK0WTefC7F6JZsNze6XoNScd6K3YjiFcaEwlJc4vze6BY5QxMMZOFgE+vTOgbsNXZaT4VFnem4X3zW57odU8edvIpVYL5gKa4Xl5IFWyOC7xVgp4IsDTgdpIjz5zJCXHCGFkwSGDWXzj2y2iJzxQa2RPoQxEs
 zmkhSUpo
 x+y1zye7gRMvunGaNAFTToepa+xkEHu4LvvWc7Uv9CjFljrTm7KGPLYEqyUlzt7cu5jCQ4RvMxufoBCt2qDP8K+pYgeNKnoyillj9qhxNazY0gil8cDe8PnVctDkm8XjLqXBwfe9p2Xhjtj8JQ1htUDu7qqBOr6o+h6Hu9hS6gSfHy1VLjQSuvKHGkbnrYvuuDRNLFlqel9SXmXqT3tDa9jRt1qkds7LKEd4koUWBmt35+quprSapy6j8LagrdZTjvIxewAkPz6pAmNtskMZNuh2+zr+SxcEMS7wJgyrnGgweyeia6WWW1aYr2Qgu3wEdJ3fC/6XXw2TM+cSMtI5jMmlaRqgXVEcad09KBjufdbCr0MiJ95/NIXlqzfnRuXfMaxsQl4ciRF14biLrdILJiChWEeENpdhFUMSt/v+j80jQJKaon9c5KxhmNhzaK2gUkvgoR7ukeS3n5dtdlqBWT0KCyhCQ1vEgMiqw09WW+SeCcUx2O5DtziwwFcxMoM/RDaDNxR4wRBK+lLV3Gvf9A1e2dBHeLN9DeZEf7ef11IuUbXU/xHsaMzQEMhhGj2YpglrFtcyv0rl0uontLFohw+AhV8cT2UuaVUoQIea+9zmwEYaBTQRhpLc5fXAyRzd5N6Emekh2h4PR+wbb0ii7H/U+wSYf7TMZlVhmasF07kieVNMhT5avxkmcE4H0yqX/PcytX8QyFwTAIBgf1CMoXFjKiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:43:43PM +0200, Jann Horn wrote:
> > So my question is - would it be reasonable to consider this at the very
> > least a vanishingly small, 'paranoid' fixup? I think it's telling you
> > couldn't come up with a repro, and you are usually very good at that :)
>
> I mean, how hard this is to hit probably partly depends on what
> choices hypervisors make about vCPU scheduling. And it would probably
> also be easier to hit for an attacker with CAP_PERFMON, though that's
> true of many bugs.
>
> But yeah, it's not the kind of bug I would choose to target if I
> wanted to write an exploit and had a larger selection of bugs to
> choose from.
>
> > Another question, perhaps silly one, is - what is the attack scenario here?
> > I'm not so familiar with hugetlb page table sharing, but is it in any way
> > feasible that you'd access another process's mappings? If not, the attack
> > scenario is that you end up accidentally accessing some other part of the
> > process's memory (which doesn't seem so bad right?).
>
> I think the impact would be P2 being able to read/write unrelated data
> in P1. Though with the way things are currently implemented, I think
> that requires P1 to do this weird unmap of half of a hugetlb mapping.
>
> We're also playing with fire because if P2 is walking page tables of
> P1 while P1 is concurrently freeing page tables, normal TLB flush IPIs
> issued by P1 wouldn't be sent to P2. I think that's not exploitable in
> the current implementation because CONFIG_MMU_GATHER_RCU_TABLE_FREE
> unconditionally either frees page tables through RCU or does IPI
> broadcasts sent to the whole system, but it is scary because
> sensible-looking optimizations could turn this into a user-to-kernel
> privilege escalation bug. For example, if we decided that in cases
> where we already did an IPI-based TLB flush, or in cases where we are
> single-threaded, we don't need to free page tables with Semi-RCU delay
> to synchronize against gup_fast().

Would it therefore be reasonable to say that this is more of a preventative
measure against future kernel changes (which otherwise seem reasonable)
which might lead to exploitable bugs rather than being a practiclaly
exploitable bug in itself?

