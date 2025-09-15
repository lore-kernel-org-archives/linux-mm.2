Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E9C9CAC599
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95D218E0015; Mon, 15 Sep 2025 06:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90CDE8E0001; Mon, 15 Sep 2025 06:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7871F8E0015; Mon, 15 Sep 2025 06:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5FF4B8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:46:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 09B76C05C9
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:46:33 +0000 (UTC)
X-FDA: 83891155866.28.CE136DD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6D4414000D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:46:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EZBOE7Xx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AvAqSoVR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5Jp0k6ofzas6U01ifb917wRAjmyMiEHdWfflyqznYM=;
	b=7cSFf1FKkyea98LrbR7g4/NbMkybz1NLrprjaaaTgC+FJdOyGQSqb1kmujyKVwN5lurDq/
	lJ3pwaLbUBzp7l7lIYYGuxKOF1sv4XlOOLcaghqSGee9XJL8daXrfDvjixCkR00K+wt8HG
	l6ykfiURIiCYxhvPsEkEm4UySQjwMHc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757933189; a=rsa-sha256;
	cv=pass;
	b=MbQm4257f8EpJqZedqCZCq/Op3Cs/LFuoK/fFPZGU803IeHM8YPV3uAp8etpzVrJ+ZuW9r
	nrP17HB+P0bg11+GWveO0oGhySSaGhGBvBobsbUNBxr+Z9uK6g8d2iKmy/Fzp4p6OesqwU
	JQkcFHoBvuqSsgsxoeNS//B3SplW8Qs=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EZBOE7Xx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=AvAqSoVR;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6fpH0023188;
	Mon, 15 Sep 2025 10:46:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=X5Jp0k6ofzas6U01if
	b917wRAjmyMiEHdWfflyqznYM=; b=EZBOE7Xxcs+y25lTY5yQZCNxvLMigMXDSt
	aOZOfYMC1ZmMIRCe8sUzmgQoPJRL0rnTHRT8kkbWRtLe2aBI0w00GP9mEurqa+zZ
	rT2gy6TNXdUdxqm/5Z2TXKV4akIGM5ZAiyh1r8wLgFMCChpXV/bbaniyGUrmtjLP
	0XOeMp587qfyloj0o1yR73J57LJQbjfbQE+ElJLlAv24UlZRdAybKTi+V+/XPIhu
	9kqkQaU5d5iYuXZzmD/kzsFWli1Cwpo4n4gSBHBJpLGRFFNEluEL9bGm+0UQUkYJ
	5qKNn9KztcONst6gy/AyEacmpn0SEWWCmPoccrSvpKiZQQl3FSKA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49507w22vf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:46:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FA0XNH015181;
	Mon, 15 Sep 2025 10:46:06 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012045.outbound.protection.outlook.com [40.107.209.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2h4arv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:46:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sahcM8PH0ygtCypSsIK0gfbL1Xv+4fZnOq4bAERE+PNvXty9jwwrbIyJpbbsJZqfgXzr7kRAu7+Xu1yMU08I/ewaAuEjhK/tdVlWlz+c9Hmuwr0H7ZknPp8Hc14CgZtgf0n27smD0qxinNxFC41u5iJjLz9bHtot4TmLVgxIas9tDgr2WeMUCXYMzF7WtuA+12M4EcAYN8i5ModaUFTmx4DoM44zSGWBWzGimULqstjK9GOCkCveBUr7XUD8fNeqXnjOc8H5P4ru9f4WPg4vkrq/cq07X5Kj9cfiS5Ocrn8XcpNbybUdrCTtj3Ve1ymzIw/jERFrkA5CvOZCaxb+pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X5Jp0k6ofzas6U01ifb917wRAjmyMiEHdWfflyqznYM=;
 b=dOW4XY170PuSD8NKRDfaqIYoXptNebmJaEOMuiYPkBWcLihZjbj04gGzFeND+rMa70atBF1CVqE8M94xYmVlOK61Z4Mpcat3F0WKxwbQIXOYg50A/SKNybiN2gIeEZ9zV1nEbVzlV5AOSpLZ4r8s0y8GfcqCtXZ9c/GEo3ALiA+59n4Aez70W8iJZUrgxjyvFWVl86a8NnvAPzWaT/2T6CX+8PUZlSAyfrjiidGv4cU8IJQhHu7fILdRiGr7QLDMWFKYNItU13xyomjgSEyy8d1TU+WYl9pU3ZUc9yFAwQon+vSi1BcKm/8fR7rdV9a1WMVgQyaDcPHlPIAkYiJBVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X5Jp0k6ofzas6U01ifb917wRAjmyMiEHdWfflyqznYM=;
 b=AvAqSoVRqgfPNkIAoabGrCY/TUv9flTRijXGOws1kZI2t7DLoBSgsQiHE1kCX9X0xeC4k9RkMQl5WPaHpK7en9RmwCiwZQ5m6aCz98bgbWT0YPzCeVPLLwzgsw3I89JDbRv53mSuulrVEF/C4OYL784FA+WN8un4gtys9rfPKdg=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPFF257CDCED.namprd10.prod.outlook.com (2603:10b6:f:fc00::d58) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 10:46:02 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:46:02 +0000
Date: Mon, 15 Sep 2025 11:46:00 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, Nico Pache <npache@redhat.com>,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org,
        dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org,
        jglisse@google.com, surenb@google.com, zokeefe@google.com,
        hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
        rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
        lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
        jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
Message-ID: <db2f6a72-747e-4fae-ada9-b717ed033f13@lucifer.local>
References: <rapl4xr55zv2nq3jh5ulk4wvfyxa2kmbnnb4uram6q43y4cbwn@dv5m52ocyqne>
 <80c50bf4-27b1-483c-9977-2519369c2630@redhat.com>
 <7ri4u7uxsv6elyohqiq2w5oxv4yhk2tyniwglfxtiueiyofb3n@l4exlmlf5ty4>
 <59641180-a0d9-400c-aaeb-0c9e93954bf5@redhat.com>
 <c5bcecb8-13e7-4db5-849e-2120c69b2af5@lucifer.local>
 <ed784d6c-6c2a-4e0b-ad2f-e953bf310ce8@redhat.com>
 <dcfc7e27-d3c8-4fd0-8b7b-ce8f5051d597@lucifer.local>
 <78d75263-e0ab-4dcd-ae97-5c5c9bb10193@redhat.com>
 <85aa2020-5b5e-4bfc-aade-581d20aeff87@lucifer.local>
 <f1d36416-bb96-4ed1-bf0a-5e1445fbbdd6@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1d36416-bb96-4ed1-bf0a-5e1445fbbdd6@redhat.com>
X-ClientProxiedBy: LO4P123CA0228.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPFF257CDCED:EE_
X-MS-Office365-Filtering-Correlation-Id: 819d9eb2-d966-4171-8b32-08ddf44510a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/9yHTehtHTv2wu0tAnkgTqkDP8fvuuUguZXNpFzprBQsGG//HfRcCIaTPDfd?=
 =?us-ascii?Q?5/v3WD/FRhAsj20K6v3p2fOZbfIWQKtAuuXFwt+c7YbFrGU5TYyftGC1sC3P?=
 =?us-ascii?Q?u3APtkqnoLH1nZtesJuvbFalCS+TTVFJQ2lPQUVIdx9LtlhXaGv7uRvgYR0Y?=
 =?us-ascii?Q?rGjHfthdH3S7ga3rVd7OR/KA4c+XWZUmvEzeLEhcFxHmlRPaHa80vQBwTZEC?=
 =?us-ascii?Q?VgA97fCel8iec3QOkywObDOFX4YVkcOqoyKEy4FmI+cyjf7L9q5tbGMBnINz?=
 =?us-ascii?Q?6Js7V8TH+cu9PCfUdpiMIkgBiVhsYY6icRQjhTRSytB6iGAsV+eSRIQ4gPM2?=
 =?us-ascii?Q?tm6xBhX48gLDcOqUfyS4r5a/G9FEpdAz1cB9/cyFdShI+v9ePKz6+bCxQqKH?=
 =?us-ascii?Q?b5DEV9Doz1ImCvoKXnJ83vLE3mqXSh98NSMyuJt8H7Knq+D/uyHZRheAlCWp?=
 =?us-ascii?Q?TvNXCT982H5nZbwQITSzYQo22WXkACHJhF58XTVs4OS5aU0JRvUHyASZuFxa?=
 =?us-ascii?Q?yi+XKxeIzcoAxXbFK6L3AwRUvWihXoRUCfGzC3cVSqokr62tY9hSzLJTJfC8?=
 =?us-ascii?Q?7supG5SutXyjNSojiX231DRo1oMVqV0suhdQAxUWPFUD2AbHScva+iBGR6ka?=
 =?us-ascii?Q?pSZufLTPh9kqvVxMVcIxdD4xOTNT9yzEQfiwS46YBRQftcy5oUrO105N82E4?=
 =?us-ascii?Q?djHg2zO+l81hTzxNdOwPkMCvLlZ925E28D+TzZjLB7SRP9jCDlvxfwW+A2LW?=
 =?us-ascii?Q?OqXCvR66aVoWbR/IvB+jTjUcIULidexFF+KdAL64cw/wi+TTvVEwxT1lcvp3?=
 =?us-ascii?Q?bE3bJ5KMha5fEYAAaNRhMkz1UIIfTKjWGMag4x8RtLoT4KPN6uwxHiaAXzdc?=
 =?us-ascii?Q?DepA95E8pF3G6quGp/LQyxAtPS232MJ5t4MV96/mXrpOU9kKaHJ8WXXFHpOM?=
 =?us-ascii?Q?3QzMQsaTh/QpPz8I394BmRz9hhl7uP/EuSKIQksncoOCChoj0YicqqPV7qmr?=
 =?us-ascii?Q?QJ7wtZPiAbWteYfgdRAM4FOl+UlouUXNvMif4VlDx8TPJQNziuZtTTnfWVaB?=
 =?us-ascii?Q?7ZmLp5I7qajP2U5WBaKcOR3ThyaAK3TYyTKhmBtlXmYcAsB/0e5NuOetZMQq?=
 =?us-ascii?Q?H4VGjisFz8csqKI7+rFmIF+3aEwJf4sZUnSdJeheUynR01c8Z5Ixp2SVehvE?=
 =?us-ascii?Q?arBR1QnJluuW/BsrnCNI135nyzhDnfE98EPRlP06HEsAmazZgsqZrCAQzUG/?=
 =?us-ascii?Q?VITTApa/eOJx83LoFg091JIUwidk0F4mx969HdEYU3qzki+WfAo1YJX3ry2E?=
 =?us-ascii?Q?q5xfywfjPeFA0mQAKL0FzgMiJyuk8vbsrH+dNX92xErfQ4H1x1TBJyQqP3Pf?=
 =?us-ascii?Q?yixkVE/42mRkLJvJTxSjg9Jojtd5obbn0l25KEj4llikj3jHGt2U1mZcn9+Q?=
 =?us-ascii?Q?hYzLABpXsgg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QrSml7yoK5ZzlbPN3bMa6Ci6XwjUU0N1JDozEp0InmqYWR5VQox8nhhpaVCy?=
 =?us-ascii?Q?ADktXgWJ70gQUP9S3w/5x/b5q48okg7n2CNmSCGZH0oBCuh7ndvI4j0nWXM6?=
 =?us-ascii?Q?UQvkGwYVbDckq54DYRextRVq7kXBzSPQl5EGx3QzY9H6bsfP3aLLllY1+JQj?=
 =?us-ascii?Q?BKNllvrVpsXQQs5JQVihONboDrSajKyhrZVOYH2X5YzI9kmM0bQCXKD0U6GN?=
 =?us-ascii?Q?KEZh3x918t3JvBdJhtugUgxmLorTmEHYAXeQBTZRN3BNUewxn3bV2/TDEfjL?=
 =?us-ascii?Q?MRaBOG13Gz89M6A3n6/1YPwOPNX+Dh4fWfiHAXVubMVP2j8VykGXpw/MLIQb?=
 =?us-ascii?Q?IYEypiQp0l+Dt9yCMg7pU3VNyaXYGrdYCTSUcs3RTzPbrJAp4mzINWXKBh0t?=
 =?us-ascii?Q?lOOxSp+S3z6kNghI8km3HRxxxUEZWWanTkWZ0wJV2rhgVvBqHBPs69ebuzWR?=
 =?us-ascii?Q?nugvhyI2xqEFXRie6vbluhB36gA7KAuBLrQG3/GK4J9HYfwWLgj4L99g7KvX?=
 =?us-ascii?Q?xwGpwkeijgEw/qqavnPAOfvlb7vlK0epXpuhxVUJPOA+WmfUZi1kXdv2oi6Q?=
 =?us-ascii?Q?lTy2z16p51YmXS2LwY3Mcr9qPnvXC5X1ql+DIv/jacKNlLz/+X9TKSep8kGo?=
 =?us-ascii?Q?g6U9N0I1Azk8WMRXws3clgFVsJVhRldmLXRyCZ4ZUAG/CxosKlHiSOjnBtpz?=
 =?us-ascii?Q?IgGOWFmN5Ncc/BxCrUbHVrG5l+OkRkR/JX5lG87gAcLTWgkYtgxrTmHmApXa?=
 =?us-ascii?Q?pj1X2BZwo7pRQ2rw8TmYQHrUvcYMOYlmU9JedcatCDzbSu3GAuUg/3DOx79M?=
 =?us-ascii?Q?ywaRtBgwxblKvIWM3O2iuXNkijWOt9M8Ypg2VICCvQ8gaD1G2rxbyckkelym?=
 =?us-ascii?Q?qlPS9OtrDzYbac8XZg+raCGSK8EKDYJvO1sx9m3Mn8FhXkr4yVCFS3xf0Se6?=
 =?us-ascii?Q?CH+1r6fBxQzfN3K1L6ZCIF14Vw8oE5PfAEup/73jBaVRc4/vhNTzZv4FHzzE?=
 =?us-ascii?Q?Zqx7+UgyjHOHsVHyYRNYyf4lps5SDCmJaY9luXfYsj3izou6qCsyoOTQpxtZ?=
 =?us-ascii?Q?fmrTKRpnE/5qI5+0b+vDSvympAsdxWzrmbWMKM12btgZdFWcU/sDFcG/5B50?=
 =?us-ascii?Q?ezZdpgwozZA2R6HZFuNxjeZEkOnwT0zyUTvA6x+80yIdA4mf+T7oho8xLT9d?=
 =?us-ascii?Q?gX7DAs7Jq9zxmQMECpaPJ+hXPUQdz6egqSyV79/oDXf8AWtBb/xZ/wsNam7+?=
 =?us-ascii?Q?ejhvP9hHUkE4reg12ZaehzOfizNSg6wST0UZSFtvT1KYVio4x/bZ8vom+Vuy?=
 =?us-ascii?Q?W7nl7ejfg2Aw0QiWW5EO773I5BHbwWQaz0KK+M8FyiYdLArBR9EnWgvL7bBO?=
 =?us-ascii?Q?3cvv82A8Lk9rkv6y4IkHFi9E3GHDHJ9RvA+aNgQHfwblil0Bt/mnhkH84iJJ?=
 =?us-ascii?Q?2kOaTLb6Q3i0dP4BrD6OfIihLvqsWTfr4/+5ynebqDoJkFZr4tHtggjuxsMt?=
 =?us-ascii?Q?Y6Yq1CwYiSZz6ouBfPXkxQEWtBeX8y79G7m0uC64/4gzawq55pj0wvtlMIEu?=
 =?us-ascii?Q?nKFKI2n5De18ye8psjlgeSZKUsrRx/3Hyochh78Y3DxecNKTyE7DYPxQqzlE?=
 =?us-ascii?Q?zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tFvVvUtI1Dy9kLtAecsg7vHxDZ1EFGhZfdH3v8Sw4Kzo7Bf906c3wkfs1vuE5YBPMyzCiy8pKI4vIUxgDwWFok0AE2Rnn8P3KyoV9SWwFoCzyHkbwqEhGTw4E1V6jWxav6QwjcoYJo4KRDTqZPJB9yP/q8TSGjf2lHeJtY8t6HAdcEbjhEBEXG1gbSctl34Vkqf/0ivxPs2ZN5SUH8IC2ez9RYdKi9mTJI5sNrr29Jmwty45SQxshhtMkiAkz/iydxN4IER0vNGgWNnAVr4GaF0tB4fmPZ1Og35tYzd+a3U8Gd6k2XigCF81bDJOw36DXCRqcqv2NcAqZIkSO1/Yj6V28u1PssBu9g5+cNAb5X8EpF2EUXfIuUlU8HJ0o1EZ6i2/dIEEgIXPg+QPz6g31obKSNo5TBYLaNBEOC4u7n4XpuefN0Es8jkxoO17Pj0+DYX1C06pd+aDGPENpqYnduLzkUPc9uMZQ8GmOaYcEvjqPcMYnEO2Ap+klRfgIVYTTIYaIBQ+lnbPrKHgCLa9wMJ6y9P4QuWDSWm1QENTDt4ADS6qPGWABVbkh7uz/muljD6qPDrYq1jn80uOU2i6U/jNHRSnnljBPm6SLQzyzF0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 819d9eb2-d966-4171-8b32-08ddf44510a3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:46:02.6225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GR/EXz2RecXbL+dCsBnCFpnD8skX7m93dRzZ5wDUDmbVJ21E8XQYqVGsXn+WKbNrqBqpOBIzfIp4RUMaBm4VF4M4ia2pNh7xvD16msQxvzc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFF257CDCED
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=918 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150101
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyNSBTYWx0ZWRfX8PRE2azlXh5y
 r8x/FCSzfilKdWje+D/w6D72bacMBO5bvk1gwtc2Q+sY2eCnkCRJ0QBb3ckFSgY98gk0W+GEdrg
 j0waYEqKJkJqPDuWGa6b9DLZLB+PdpFvpqfeUpBZYyNQTDkybzfCxiKQMuisgccYQTjfUoaKuyp
 g8nnmM7S+Ei1ghCmuW2duKNbpuhAW6bukBjIUjeflOVGDVHWWAI4PBsndLQ1B1CO8gGvo2yBXdD
 8B+xjeLJMEdkz7k/KgeoJTWBhB5Y318wsz2GljU8w4qRqYnzRvF5BuAafxj+OUNMj0knjMPgFJ4
 Z8p4RGo/p2rKcBEtw/osgFVV4pYLKrzvEJAtSmc032Kitq4tjYk1Bpn2lkVxTODsMY2a8pnUOLs
 L5442G3q5zHmL5ug/x4mFKR4KLZXfw==
X-Proofpoint-ORIG-GUID: -A08sls9L1FmGQpxLXBJ30R4PXDk3raO
X-Authority-Analysis: v=2.4 cv=RtPFLDmK c=1 sm=1 tr=0 ts=68c7ee6f b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=7T58b0iBWaX178fjz7sA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Proofpoint-GUID: -A08sls9L1FmGQpxLXBJ30R4PXDk3raO
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D4414000D
X-Stat-Signature: s5mnnyjperbsam7pwnj5rxycq6acr4ux
X-Rspam-User: 
X-HE-Tag: 1757933189-860690
X-HE-Meta: U2FsdGVkX1+qysP+sNIv6mljbIsnTD8nnhdfwB3/F1AiNUSubogvd++C3KbjN1idTabQwoyOaETMuVCReuiPFT+G6FDIKyLTLFjEe8g+6E9IhIUBNPhW0+j5gxJgZ4R272YB5sdsRx4EKgk8UI78nVmpBc2xVnr44dIPehXgJ9vrUPdAdGteDbV5e43Rmzv/+fpHTHpMCl93h/ylazd5KWRDTAYwtmGRMy9a7nGpeeWDbIEmwEQyzur4vvoF8A3DlsKh91j0sRQuDC/rjOPbw+SHf12FksbHi2Sgqr+QgdbkKoINTvYOiDCW2wpP1x0s/1cZ9jFXDCzYS8yKeydZBbj69IVUkjiDeaO/ecg2j2FScwYMvRIbo12QKu0GOee3mraGvyY4u/76k8XdyySR4jFB11fnFP6xxoHGsaQWoYhIkN1qjsNbHHbYoiSgEk2jWNF3teLQKHHFH1/xheAHhgan7U195QlfYqRAfROi6qAaliEArJoOdJEaiyc6MQbLbYwlPQVo9udtadW5nyOKd40qxtmvjq16LKXJxzGdCKIANbU6DsJ2sRUtE7lqu5A461tRVq+ww0agdaFJHmUI80A3XQ4eN8rC51lFNQtlHKiHCE+xUH7K3cmSCDAEYozFf3bgM6tZYHFCy484nHMZhqWBlByj4d8z1CeQlJXBYJQetERdSp+qiIcjiumJQ821xl2fFySrV7F6evY1WD8Yz/ccsv5geea2XhGI9cgQkTE7IDG2iLzAx0i4TTwCm2YgHA2tnK/RghOQa1a/O2sY9zlVshRqROeQOVrVvTjW7mdO6OWr/l7IAZsaxkwQicEX0FRKmRrxNrdWJssv+kBehS5BBdx0vEPAsdJT3F6gFNTHaVM70CouFikll/92ZV0XzKJnWghtPNggs+9Mr8vy/SA0d24WK38equXf7TStHJFKsG6OA6hH2XzqJRiRzywndxF8ufMh5zCAdhbGdDb
 dKfoZk6U
 4oM8Lgy8Azx3I+OK43Tt/tMLlOwpcyMiHgInyoic9Twsx8lcuP/fe1ZG3cuFu55/JGzkEF5nXdLubT+SWj4rDlAmvVGxpcSqTnTiHW2JmG4P9Cxc7aWTuQyYDeit4aN5J4VA66n3U+Khg7+em8/cBmnVosUhEB1fLnwDMqss149tKZMr1s+gMK1PtGJcCoSkIxSPI20zQsFfbYJ9ehDxW6qONNgLsS9qR4HIC/4DIt0ny0o6iE5PmnccHLU2VjCM5mAPbMkEZyUf0fhPqCYFLTcYZr/AqdlR4pcEymxXjFd5QEOf2QcdiHZkQ6nQ2ZxMSGYOySfWvCFkrEwbNv1CnX6+BrrnOczToD8+YQgd0mDCmPBs4CLbIG6oNpBkJ35SiPw0/J66W8zVlbr9lXCKSMq542syWOE4xKBXg/ORNjY6nlC55IJ+Qy7Ow7vfvSPeyFTU9d/UJnUaYJcY19DZdS8ifDXpCl5zRng8g//MFW+G2YheWYgDawBuy91HvvOKWt0MjJYz6xXnViUoBxjiilnIKvhlyARsmpmggAKyfN4HeHPoVVsjmLV8alNaghxzFOiUndGaUcM3adg9repnJmimSJMDZs6Vj18iNRXnUJEpwklz0drjM54qUo9TtUVPYafhz3Mh5EYS8cPRqPZvXbutiFC/UcMIQf9LCMopH1fupa/IBc/FGTNxWqCdEnfzQf99M5ts9UmEQAinQWZcmhEr85sIoqGRvdgtvmJNFTNnj4K5lKl6LULhbF74CjmVkH87rr8hOpDsxetE5GNxFGNwbFLjFetuwDpeh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 12:37:28PM +0200, David Hildenbrand wrote:
> On 15.09.25 12:32, Lorenzo Stoakes wrote:
> > On Mon, Sep 15, 2025 at 12:25:54PM +0200, David Hildenbrand wrote:
> > > > >
> > > > > I would just say "The kernel might decide to use a more conservative approach
> > > > > when collapsing smaller THPs" etc.
> > > > >
> > > > >
> > > > > Thoughts?
> > > >
> > > > Well I've sort of reviewed oppositely there :) well at least that it needs to be
> > > > a hell of a lot clearer (I find that comment really compressed and I just don't
> > > > really understand it).
> > >
> > > Right. I think these are just details we should hide from the user. And in
> > > particular, not over-document it so we can more easily change semantics
> > > later.
> >
> > And when we change semantics we can't change comments?
> >
> > I mean maybe we're talking across purposes here, I'm talking about code
> > comments, not the documentation.
> >
> > I agree the documentation should not mention any of this.
>
> Yes, I was talking about patch #15 ("It's just when it comes to documenting
> all that stuff in patch #15").
>
> Comments we can adjust as we please of course :)

Yeah, ok this was just a misunderstanding then! :) We are in agreement.

>
> --
> Cheers
>
> David / dhildenb
>

Cheers, Lorenzo

