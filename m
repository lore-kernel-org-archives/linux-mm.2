Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7D6CD043A
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 06:03:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CED26B008A; Tue,  6 Jan 2026 01:03:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17CEC6B0093; Tue,  6 Jan 2026 01:03:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034096B0095; Tue,  6 Jan 2026 01:03:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E43F16B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 01:03:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5088C1BC7
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:03:43 +0000 (UTC)
X-FDA: 84300497526.01.0951468
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6CC18180002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 06:03:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bSfkAIkB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dWvD3FL5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767679420; a=rsa-sha256;
	cv=pass;
	b=BfuWRvJdKCxnuNTZ46EQHicW9vv5MX3CvLnyvZrSYN7b3ZUe4j7geGavsaydKViBtlwmu/
	blXwVH0bak821NZJyV3Z505EhlLYX5yumcoWWnLqFvmBfIvZjE6mXBN8Wyh57IbTpY6NiG
	GCLc8O2yyNskorMzODoG4dp51H5gYKM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bSfkAIkB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dWvD3FL5;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767679420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZW85cF7Lr7QMqYgr6t2ITOPhL2otLigpSAX0WaWWMr8=;
	b=Pe8XeE7qMGAYHCbBp8UdjV+bRT1+M1Hb9AZnk1muUy8sH8UJ2uxn3X0IRF6CtO7nYTEmvZ
	+Pw3+BxLa+GYVAPuOdryksfL70Lsi2uS1UOUXKFb3XVyqjIJ7DOf8w1T9+4jPYeTHDlJdH
	+nYzN4jNdCbuWeskUz0iREqmG3kvpyY=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6063CZAu2852296;
	Tue, 6 Jan 2026 06:03:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZW85cF7Lr7QMqYgr6t
	2ITOPhL2otLigpSAX0WaWWMr8=; b=bSfkAIkB92MQ0fD58w1X56fvvoIYc28tpO
	i+2KI3VeHYDCz7PC8qVFdNybiodXIFOjNIZhD1LW4g1l12yuiFWZJCYrKqDlStin
	DqqQTpgAWoAiiGQ3cFvgS/6E4S+cRg+1weA2lfEONdQCGVyzNQDMjuZg5pCRhbmN
	DMFHqbJzFOsIOxDoi118eA28jYhYHMzi/hY5PFN7EBE17wx2wfNtKyGLYSlwFAmf
	ATacmcD5d6MhZL8rsI2vqB89emP5DzjMea1THPLOSeS1c4Rn33pZv6O8deWCrefK
	4Km/oIQiU9X5TccdsIkCmn17END39tEd4Ss2T4RU5d3SUAD8pvRg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bgt1x846p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 06:03:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6063EGrZ030658;
	Tue, 6 Jan 2026 06:03:33 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012066.outbound.protection.outlook.com [40.107.209.66])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjc7u98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 06:03:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a+rhpUJ8DR0PnYBQouQ22LHyjk9wOZyX7odkx4V4tO/CE30f3FEWs8vDix0wWJfgxik2LZ1PlVhGrUSCU7v3JyBQIubcrTYnYIQjGD+Zk1JnXOuORU0mImJkX+/bmhbq+5J+JYILfJvGpKQ07X+O3bnpSkf/BdtzJRJusdkDQ10wf5NGvY6r+4mMT/Vn2lsFEZG4JBggb8uswXMcw/Dj9AO3O84Q17BAcEWFrNOp3dz3y4ZJofWfD9TSL6uto0rCLZFZHW64/HY4Et60zudJ7cKv5JOaUYAZciF2KXfD8LKl4sBaqxM1Dden1zfuHEmys8Ey37b07eWIOZBYTrKxog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZW85cF7Lr7QMqYgr6t2ITOPhL2otLigpSAX0WaWWMr8=;
 b=CKhm7LciqU5NH8yRkKortUNx9x+OFO1PqlnLiDZr2aPP9f1WoAZ7C/0SWTbOYeOViMeCfJ3Wlg9jhiUiwj7mK1NNQLfo3N+kuon9S9bWjAFiYZ8/joq+Ph08HK9Kj6ctGJRRkQJ02AdaHO9T8n+28eYM2cIdYrRmYWEj82kpyo6ezo2a/CQ7xui7Biycwa3FfLYi+BA90TbsoD+VZ6ElRyPvly2VkGP3aQ4KrgnRrQuj/MeWxIxz7xSgSx2keATaG8kqsOJ8gncoVNjgfHhdjSWy2IbVLSpHJFPb2KHR+Og+/FWOStT2jKmFhF8YLS4cvT19TC9vIIm2CMkNR/YUcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZW85cF7Lr7QMqYgr6t2ITOPhL2otLigpSAX0WaWWMr8=;
 b=dWvD3FL5T0AkR+loqgxi3eTdE3YDl8FDqJouMzuMeoAYthzkgr0VjKA6Q44JzoKZgBfoEvas//Ze4SPrZnivSvVvNTDaPU9C+wAjd3P5U+wbrd+cUv1cKCzYlMTqW8vn6HLmh5ziHe6WyzlbXmmCcWFPhL2QxHbJyCBGFeyrNX4=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA1PR10MB7791.namprd10.prod.outlook.com (2603:10b6:806:3a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 06:03:23 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 06:03:23 +0000
Date: Tue, 6 Jan 2026 15:03:16 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@kernel.org>,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH v2 3/4] mm/vma: enforce VMA fork limit on
 unfaulted,faulted mremap merge too
Message-ID: <aVylpPc4u2ZwmK7k@hyeyoo>
References: <cover.1767638272.git.lorenzo.stoakes@oracle.com>
 <6e2b9b3024ae1220961c8b81d74296d4720eaf2b.1767638272.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e2b9b3024ae1220961c8b81d74296d4720eaf2b.1767638272.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: SL2P216CA0073.KORP216.PROD.OUTLOOK.COM (2603:1096:101:2::6)
 To CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA1PR10MB7791:EE_
X-MS-Office365-Filtering-Correlation-Id: aa561879-fa74-44b6-b2ec-08de4ce94c6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?alpysz8iYoQrWJ9u6hNVlbcuVCIir++pP16QSoy9VviD3KxzquqKBCZUERt3?=
 =?us-ascii?Q?T7DlqxrJ74nIrDvcfglEoADg1RyqrXjR8sVmXoyPjgmVojPQTjQd0fA+4GtD?=
 =?us-ascii?Q?GDwJxvziyIGQH2VEKMFlvLC50Nfjf3r6SxfWA8uwrIW3EIhqRzRN1NhVwoSo?=
 =?us-ascii?Q?GR6Df5d2IPNnu8fRWFQCEdvQXdEvc60bVT0/oyeMSNOCVJJ+5NGTFQYuw6d7?=
 =?us-ascii?Q?ZjP4eQpD94do2jG1ZsAMvT2NrsuPiKr4Bfh3gXYjXLi3bLMcy2jvGKbF6keC?=
 =?us-ascii?Q?jn6OwBPo59vnv2nLKaa9R47HmuUhvpJIdyNA6MLcvyfJ8jTm3LxP6kTY30Ci?=
 =?us-ascii?Q?VzQK2rg/+9CIQumO16CTiA+9d3LacksHhf7eXKI/ZTzRJUn4c1SmzSvwquII?=
 =?us-ascii?Q?Unq+b1t7vVMZB1TZyTn5/bCKFE9uPeicBntXuu9Sum8tTy/4Pl0tQmHsng3v?=
 =?us-ascii?Q?z4ogrdPP99/HJGQspb7QVn9T2aVbWUoAIl7gjzhK5Kcy6uBqRICsFd3xT1ze?=
 =?us-ascii?Q?s27F9NqKPFDwytbG9wldfdCTz8aj6D4UowNl2lZLHKP9aEx/RleUXkBlpO0I?=
 =?us-ascii?Q?f/pnFzSNg0yKVC/kHxN63OFFaC3IRjPn/hpwaHWSvH7hr+tL7AI2xE56ORXp?=
 =?us-ascii?Q?3+8CwAKY3inX+d1SPiz1l68ua9geixUF8UQAbYZJ576L6DF3iB+gLKHZ/imR?=
 =?us-ascii?Q?UW0ax50iTH1kUMFDAVxUKZEo3gCGyOFpox1M+z1g/4wbPEsMI6G8XiJYL9+U?=
 =?us-ascii?Q?CLVY9aeDpEOc8EgzT436N99r3y1LCBqzqDBOn7M48sGzBxnSg1rEuR462B47?=
 =?us-ascii?Q?7itm5bEp+gf49XBXNn3+IOrzJ7lQjV5VwIXCGbd9Xj9wKi52aZCwEB3pNHSj?=
 =?us-ascii?Q?WyAHajf9H39kHXSi28WXdWx/fSzaeeWWKmrXP0Nu9PWJ1y6sB9tpRddeCSH7?=
 =?us-ascii?Q?pDM7MxuvY/J4MbpleofKDFSQf8uorqjvNSFZxbUd5KM0/DA98SF2PJl+1IkM?=
 =?us-ascii?Q?hirpej12vOPc7Jl41qFsBurQyDp8FyaMq+QyGjNTVrMMYZyIwT9Jfi9Yggdt?=
 =?us-ascii?Q?qb/T3zc6xl/82/CKwiVNKFQqQPMA+lmoLsO8uoO7jma/LN1AA4btFnBtghsJ?=
 =?us-ascii?Q?otpqUAsAmGvdt5JqX2dh11J4msnaqWbS1E6iuty7JQmxz+KpXjbIMqakEXwW?=
 =?us-ascii?Q?ZHjWi2mu15LrBBPXyI4aq3nhslCs6JeiNVEgGPbHMvxe0QuAUhWVGm5CWFa6?=
 =?us-ascii?Q?r76Wch2/fW+OoL99938MQQjBEqp5b816q+vcKJWae/dCarT8gHAFnZ2gEiPi?=
 =?us-ascii?Q?BSu70whtAtMNyBAmz9yORRDnUaCq/Ci9HMMre9SHpuqWJyXsOU00eDB7CA7g?=
 =?us-ascii?Q?A9gE5oeLPyh6eBgGskq9oLsLv0Vxm4x8h9WznXgdyupDRe/0LyZOIt7zIekW?=
 =?us-ascii?Q?KQbKQ7xiLJq434loUydgMnIR8gJi19Dm?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wcelPCuvymckRpspokVp9q4xBzqbUiuIB9eLDUhoTYc0vgrDCcyB3M3dqOlA?=
 =?us-ascii?Q?qa6OgfhyyDTO5hoFdVSOXN4k1qM8WUm/j4FLsp+yKizESUGUiBUtSgWH9ge+?=
 =?us-ascii?Q?kMGPjQLNXtRx57RyhR1rlMC3Dksnh7zpQJXUmmS99HNc7z4d2GaTNst2u+F9?=
 =?us-ascii?Q?dETXsju3U5viBMF6uVco2Eot4tWSGBqauplPa9K1gSzVzfhyCVjAVMFHqq4w?=
 =?us-ascii?Q?SaQ9KUSZNcoz9LS9zbCCXqmEgdEqvWJzBFQVqG/FqenJ5nIJl1fdH2wKul8l?=
 =?us-ascii?Q?0WqLWkHCsbnYnRcEOc0htUxiQOV2lo1SKW6wh9+wdCB/YWn1Iur0B5EmL3sb?=
 =?us-ascii?Q?YznCNwq0ONKbxXTAgl5hcecm1NS7QWfkv0oyUD7B8JuFaacLkqSUXYEZraJs?=
 =?us-ascii?Q?tj2xbrj81t/NN+TylO5yZ3Yy5sygYuRX0GAL2FqmeJJbnc30y6ZAn9yUj2iJ?=
 =?us-ascii?Q?aOyVejAHCh8XgduzwDjOGFZYaSxrGFAc9qCb4jPeG738fZiKxRpF3obB4BFZ?=
 =?us-ascii?Q?t9NuZ4GCDuZ1spZo7upIgDZvh1ZD00RnwdAoIcOo4D9GxrJ2MHfmKbTlzngt?=
 =?us-ascii?Q?05+Pa0+0fCtme3wu8IpEPXGsoKa94vJHZL1W3vL5pf4L46NGhPMtXkwuWZ/U?=
 =?us-ascii?Q?ZttJV5Kn/fz6+WO3st5iN3dlyXqgJdVCXmS2ibytexnd/yNMEPXY47mI5ZQZ?=
 =?us-ascii?Q?CrNFjbaieRONcGgfmnhjuX1kjXwoiA9/9auNLyjGwDi3197b1tCEO9BggaKO?=
 =?us-ascii?Q?hVJ7HvhTknkX/Om9A+rIh9J0v6jkqeJmD85E1GNjpGDlo03M/fRslh3zD25S?=
 =?us-ascii?Q?2VxW2Wi71KrsYgEo2zCNfURyrvVXDY5Q4Dq2NRSZzJL5oXStWh0kXqtP4Xp2?=
 =?us-ascii?Q?NhZSoIxbARYyIXbWlLP9aW0ZL67DYb1p3+cILlvaA+618XJOIwfKhJ18EzHo?=
 =?us-ascii?Q?TCtB81f6T2UfPcyf4uXM79K/9nLuYnRM5ZdBxFzjtKsIJt+rkantgHTYIXOp?=
 =?us-ascii?Q?TGAjCkg1dKFSJTQ2FtUfnQN3A36OAgk72HUNwNlJlMR0NMpir1FjNMgQOZmx?=
 =?us-ascii?Q?McvsF1aYo7HW4RXgyZcWtsOqZDyEansBSnvw/8gJYjtJboyZFBhr3+8ZFaTj?=
 =?us-ascii?Q?haKmXu0bshidF1h+V05a4Nb5OxR0u3Z/tbFZeZBs4Xlhvbzc2Vi5SEvI/aj7?=
 =?us-ascii?Q?nzXKfs7xKWAplXc2dfMpoVv8gaD2N5Xh+SZOtmScbCy+h1QKDqRQhdBq9IsF?=
 =?us-ascii?Q?p1Dck9bBSRAS40+XCGOmCDL0cNnnBEFrqgOh5dEAmbtQkX2H/Pz9+IXPrTEW?=
 =?us-ascii?Q?20tj3ruAMz71AZvOrqfwd7yo/s1/h6mh6V1Kzn2p0Vv4JNF7CrsXDC7VB2+/?=
 =?us-ascii?Q?BKF4WQvHlQEjbMOxj5PYrWOYUuZFUPm5/ftAAe118xq4RZHEqzTZoOpXRIAb?=
 =?us-ascii?Q?b2NaPyOvPZu1vmSWfUUU6A+UmBFYnhWLF9wYbsry+5cIT5dtH5fRomYrnVNp?=
 =?us-ascii?Q?UuAigm00txdcQeoBfCsnMWhFG9bsMr/u4ywA8DMzI6NNIXGvv2llR+tz5nTF?=
 =?us-ascii?Q?MLICAylTR6zgr215JYyoAWgL9fMq+lGfos9LoEwbNlJLXuJnPF8abxAloSoK?=
 =?us-ascii?Q?3N5ZWfAst65+kPusVI+QHZJHgfAYPX0A/5EcTcy1wt5p8p87xnSVnyi4cJvo?=
 =?us-ascii?Q?rG8/ZrLuJ52+pQb+/L6KDGQhh9D9b5HKIctuhbonjSBuJdoKaW4kHZjsKyF8?=
 =?us-ascii?Q?rD6y8QYY6g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	H18qP/LmefHMP8nnN4SnB4Bj9aOx3izGoPAOjv+JdPWrbx6RFfgthJ/7hiKqoc0e3f8sinSqXft4LdQDLSHApDJfyYNe4Qmq7huQd1LSrTA1oDyqzTJhijWCtaM2k9Ci7mz78YJWHOBBxGnfg44/Wi4NL9dyvV3b67fVJnF25dprogD2s3mzsd3JsZxWqg9ubmLOKS7wQRQlJlvWBNgZQ6AejJWiIPHJ+KxoX5dRQNYZSnivdCMwfCHtIokqzlwbA75/OxNspXTXvssMCGSUrg/fDgolFMl3fBuzv9J+0T98ae/9fxvcM9VBm+F63kn1thbYRAIOLaqcUSKferMpVk35mvJz/IkidfuNAKhZPGModQo3pQhzvkP3Ee8Tke+TZeGDajtcwMLE3OKbm8DSrKq/mp6PhP9lHpBOpH0mFu04m+gIHDUwV2O60P14sQYzHQ4r7t6728l+6dmQJ9DekUeJ1R+tDyCdga/ImTuuldEvaqCUM0CBHqkSvlTaXkI/JFmKaOdN5LKYYxCRMNXrldb54N/8GypexHduX5k6l2klu5bn2cG3ycXDiOxeN9TXH9ftEzujn5CmKSnHv3umW7bDQ23zFD86jGQ6DuAHeGU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa561879-fa74-44b6-b2ec-08de4ce94c6c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 06:03:22.9556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rfDTkDXPBsR4adLPqIMWpGBM27uX7j+mC2ha6neEt5rVOUFj/cL/26An25X/zC7zi9nOFZ2Q59KAftP5b2UvMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7791
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_02,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=932
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060050
X-Proofpoint-ORIG-GUID: 3Wa2mtnVwluCECtcKt2Et3TjQ1xQBN62
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDA0OSBTYWx0ZWRfX5Glo9uC+gml5
 ifgupUH4P4qSZ/b9ihw7x0xo+iOkDWLOrl0ke74oKo0lA6vsIJ/716tlutFIHjtZWMAOEWk/c0P
 4JeLXqFffOH1ki6gz1lkqzKK1wSLaqCyZKQZkaXeVPU/g/TiHrskOIgw1ydxzYzqoGY8a6gO1Wy
 nO2hd4vrbPkr5bjetQwMFR56+FK+7FgJU2t6EXA/SXXYTkN22NcUPi3d7eIKr1RjKHTgdqjyvHc
 NLcF0hBvqi8MoAN8M/x32jqmRTRDg521gPWs1MGEChRVa9qqYTxwJn6XyYEoIdgRhY1MEXrQmw7
 IG0fA3dRy+S0rmTXSIe8dfvv6lcFvJW4jbJNJ1T4jwrc6RQBAc5LKasjaHDiCISHokmLdwyLp4K
 SageefD65FhJPpdo8plwbEhikVYIeVaiW5l24kIeCtR2FtkzsLgyn7+7OOjL1BdUM0J3dkNFFLD
 udhTWfZ4NTUIJVCFxi4FQzVMfG4t7VKvRRsW2vAI=
X-Authority-Analysis: v=2.4 cv=aID9aL9m c=1 sm=1 tr=0 ts=695ca5b5 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=pFG2RB08WNx_kCNatiQA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13654
X-Proofpoint-GUID: 3Wa2mtnVwluCECtcKt2Et3TjQ1xQBN62
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CC18180002
X-Rspamd-Server: rspam10
X-Stat-Signature: njrk5gr3qpa15os4rr46w39cirwz7mz5
X-HE-Tag: 1767679420-145249
X-HE-Meta: U2FsdGVkX1+c5HiZAGqhuB4YKmIgvXn1aG+uLs2utCu00RbCuaDZReETCo41CZDudx/TG2MBk6T0KBRhnJUj/n8WV5zRD52REAo0YhXV7iwgLARvwnxpmhqenwNnzmk6U0jvaWYkWy3PzNAlg4c1/qwN3K8s0z08IjmSBKFPBmhBjBF9DgmZUDyNbRscYarMnrR9LJrymZSuInK0YD7Chi3/YSjcrZeREJUIxtx/4bYMGYil/iWJsU+QrKQg0WI+97YXKpV51q8IsLihcBcadVWeRE/LbBYb2Fm8u6juJeARn9qF8bI6tVDaWMddj1nzrzmFAssfVdP27J4LyL7nP9qtD+UzX0FbTe5iqmBQcBk+rknMGdKFX5Ygi111tssTlH22it1EL6CUeNxDsGNswT1dq9S3hVvBdksvpvw00Y/m5HaIGS/x2upq4RndygNEdghFf0jCAkCTnYYg7V7x/lLALy/z8VsVVupVis37GM8cTfJUFlBHD+PE8R5ZbzKV4vqJG05stSrrbiotqoOCxtnj5RunWSIH9w8iuQAazIP+8ZFTo16l3sGKnhW5ElbxLOROvUwE1D7/UsrAiR5WN/vsc3hXuYL1TPZ41v6zVKS3uETaJKHrAO/6Yc62t4D8GW83hTiNWulVcKi0XmWF2UGw7+UcN6pOW+wyLCidIAtWMG2w1c62hW77RVqLsqVk6v0EnaVj0hQFHDaI11OTKioe1H7AtPXaQD/mZ3uAMiX6CxMX671X6hfYw0mZMnlCqg/VtVlugM74BRTsuUmoWvctusVf3UPzA8V3Wi9s59MdXdBLEcvrOQNDS1HjTgeZeQfCGxBhD02ZLF8qIRr3SkeTfuppdDATVynk3y1e0505VbnwAdWdLKroVqRMpnH70xR/xAzfyM2EgfmoLsgfjWxP5Nu2b0g/u5Ab7gCzt61kYadb/zBAHSYtLniq78y8uJ4kfQtMJZPOdQVDGHl
 IpQtEa5t
 zPZ40hlWVRfx7s939vwicUx0BMkpgkxgcckVlfHmbrJX298YriFQjzUi8EYNz4lsZ7dFs7+so+B1zoVw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 08:11:49PM +0000, Lorenzo Stoakes wrote:
> The is_mergeable_anon_vma() function uses vmg->middle as the source
> VMA. However when merging a new VMA, this field is NULL.
> 
> In all cases except mremap(), the new VMA will either be newly established
> and thus lack an anon_vma, or will be an expansion of an existing VMA thus
> we do not care about whether VMA is CoW'd or not.
> 
> In the case of an mremap(), we can end up in a situation where we can
> accidentally allow an unfaulted/faulted merge with a VMA that has been
> forked, violating the general rule that we do not permit this for reasons
> of anon_vma lock scalability.
> 
> Now we have the ability to be aware of the fact we are copying a VMA and
> also know which VMA that is, we can explicitly check for this, so do so.
> 
> This is pertinent since commit 879bca0a2c4f ("mm/vma: fix incorrectly
> disallowed anonymous VMA merges"), as this patch permits unfaulted/faulted
> merges that were previously disallowed running afoul of this issue.
> 
> While we are here, vma_had_uncowed_parents() is a confusing name, so make
> it simple and rename it to vma_is_fork_child().
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> Cc: stable@kernel.org
> ---

LGTM, so:
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

