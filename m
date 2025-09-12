Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0258CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 18:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F03A8E0008; Fri, 12 Sep 2025 14:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7F58E0007; Fri, 12 Sep 2025 14:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F6F8E0008; Fri, 12 Sep 2025 14:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15BA38E0007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 14:32:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94943160830
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:32:38 +0000 (UTC)
X-FDA: 83881443996.12.994E060
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1B1D4140002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 18:32:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cyFNIB0v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jdj7IlVa;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757701955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnFyBWwP8jznGL14Ch1faIRJtf9Xvwm4bd9UwcLv5NI=;
	b=heyIsiCrrXeYDUxw7bnhGb7Pt0NGDhNfzDert1SpUNgUBoBm8AsXoX4cnZoMOu8d7EFGTo
	Zzojv6cp6DdHgnSRWwtDpmGp6NHFjabY9yarxiUasBSD6Yft6318CFhUcMoO2/4/+wGyw6
	PGb+5U8hKnqtYvfFXV2rGeTrVyKbwyE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757701955; a=rsa-sha256;
	cv=pass;
	b=PyYqqYpBv2ol8IeGLs1aZNbyQ/CM/7/TnsYm2TnitcjQPkQjzx7wARAWxRRmnK2DWrAD/s
	+2NKzR0Hfv10HWiqxHMxx/P3HhTrLE6LJ8/qimiRE0vvD0/hTeoh6wkEsgrzBsQ+Emncd+
	NIU+USgHqb/RBiuP38kT/Faaa8BvDq8=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cyFNIB0v;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jdj7IlVa;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58CIMk9g028686;
	Fri, 12 Sep 2025 18:32:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=CnFyBWwP8jznGL14Ch
	1faIRJtf9Xvwm4bd9UwcLv5NI=; b=cyFNIB0vDAMN4JwPqJw7n0dmXwZerY2d6A
	iYEcFB6rGPP9o72FkJUGaN843rnrtLU/9ewluSCTU5yl/+DqkUt15eFD+sMHbJVL
	3HXah8Js3jrf/Mv2NBm42zSOXWGpedgqmRsZYhoQPBuWzjPNIbxBqJD/zDSBB1mE
	OMHW62KLjhFADWXv+KHRuAK+OrftvQbIp2RpEdIJ53W/r/Hzk/xO6bY+532EcnYO
	C3bl1yygc66W5Tk53T8pRC8yEQex3j7dXT+q0M5G4fVE5GA7B5811J3qHFXckvam
	TpgNyLQrUCgOjf9zfODNf+Kq1pVq0itV+PGPGCNljpwmqwgkb7/A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921pegsng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 18:32:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58CH1fKG032890;
	Fri, 12 Sep 2025 18:32:26 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010039.outbound.protection.outlook.com [52.101.85.39])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdf779d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 18:32:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UoiUTzREtM+t5SDbR2FJcJn3lImP4MvJ6KX5naA4AWblL1vf37iDOZQol/MSmCRunZvoItVcLqh7SUidcmrcB/m72uCoNpfxlJenBkY2CIt/n5HcojSx1m35bu+wpeM4Iy4TAp2i3Iw1vwAZW/77zEtQO13qeGNViqhP/N3i+DKybbJkyHQ/Aak7ua1kdOLFWopfysIU0fmWi/p4/WmNFkprblskev2LVALD6RjhsQC08Sr/9Quw29Nuyj3UTv5HmzY3L/+buQvf8TviiLARGdC4ebLXdP1EpbfDazhMwn3aMwc7L02fjgC2+XZujO1CNULQGmDEjSHrmI/DiFbp6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CnFyBWwP8jznGL14Ch1faIRJtf9Xvwm4bd9UwcLv5NI=;
 b=eBmDcT6w3yPT0TuyRolW39LGTFXELuXHiQV4JQ+6MeR7oWC1bHPvM3WXKBIYhUg5mg7WFmnCum+VdIT+FavDkkDY7BJhoEm9y6XCR3RJ26b5RGBRRn7eRb7t27ztSmg1WP7VYWvWpEPvKciu9nwTfAfSsbLjdW+O9+xYSOdpsgN/8u2iPXKRAT+zDcOwsyppXvt9NalYrjKCy/RJUZuxnUq3M71207/rZSOtxmmVjYPx0/zDGdZujuAfj35DufV6hEirFd/vFc2fXteyKJGMTMut5V3bVI/Vi8OW2Yhpmrvbn563+5gJN7uhazD8I7OulVoIlJu7n389qXE8ECb6Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CnFyBWwP8jznGL14Ch1faIRJtf9Xvwm4bd9UwcLv5NI=;
 b=jdj7IlVaMoWsQGh+YTSMp9mm0VTLApVo4WNielwfTNWqx1xEnTIeuIakpenoz/IEt7KNnDEg7z7JpFTXMjEeGhK5xljjiWLpu8bn52rYKYxdCrbGwyFqAS/pxgMuHNTMXfwXMDfiw70Ef3r5NIGsuIaJojt4zgapSMo8J1NaCJo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPF077CE0592.namprd10.prod.outlook.com (2603:10b6:518:1::785) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 18:32:24 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 18:32:24 +0000
Date: Fri, 12 Sep 2025 19:32:21 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/khugepaged: Do not fail collapse_pte_mapped_thp() on
 SCAN_PMD_NULL
Message-ID: <b98c792e-c603-47a9-88a0-fc03ace63ebf@lucifer.local>
References: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xhan2av3fyl7qpsl4bhjtds2zeegrl57ehtc5grtkua3c3v3nz@vain5s6gpycl>
X-ClientProxiedBy: LO4P123CA0592.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPF077CE0592:EE_
X-MS-Office365-Filtering-Correlation-Id: acdfed69-78d0-438b-50a8-08ddf22ab7a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q5kCRQEfiCy6evf5bg9c5R2OMT+e3YQ8rqJkRQU/jdXA+h8scH/lQuax0C/P?=
 =?us-ascii?Q?3cKe4w2R52W9iH2lNEi3j7pHFtH3UdrnRBPrAzjAzn7A/neybZE2eG28vyTe?=
 =?us-ascii?Q?E8qDgp6ci8xg+va8YNhfdiA05VmtYbr3/Sem/JOuh5gF2LITKckU4EXxfuEa?=
 =?us-ascii?Q?0CqsPj2rihGnoozas/mytapJnJDdjW7dZC15QBraDR6sCJTAtTz/jqtWMGVY?=
 =?us-ascii?Q?Lf+UZLrMad42WAQxbFdDXlCxwgjo6JVQFawjweFk1p641V2ZCazkc+pr84lS?=
 =?us-ascii?Q?hN1nqLr4RZ1KyZKZ04AN4xnsRGC8/O9vwAXrrC2LWhn+pXeWRLfh/bknQ/+r?=
 =?us-ascii?Q?4eKT1PRtmc5WtgX/pL3zWDIL7yORCUlDVHxF8+VSC3qI4U0l1gheNgKhZ+JZ?=
 =?us-ascii?Q?ay/WMnaDyG79oBgEjZK60sC84eHMbjQia7pZm5UAl0oPjie1VNNyuXqvB9lw?=
 =?us-ascii?Q?tgxZbfYiOB0Xt1IuNNL3faiA0SPy5f9OzQLlYgmZGjU2Rrqk6fTEK1Mp1gGq?=
 =?us-ascii?Q?c7TA51hwgypEDIe+kGVNUZI7baWNC16c8wngAwgYhywE9/ngrYuHZUHLT9Yw?=
 =?us-ascii?Q?++ctM+wYnLy0q3uuemAfDcpWBiHHXQiQPANpYfONAos5StSQonCWUxHY2+bS?=
 =?us-ascii?Q?gCIAvneKzO7pFUZAf7kvI040Z2SIX2TF9pL828J4PyHv6pNaWFPeZ5zm25MN?=
 =?us-ascii?Q?KWx7EzdqoFWAVxD3kzDDFQx1cQuMKLyJgyfHzXNiYAe04LNX+b4A7xkb/oPH?=
 =?us-ascii?Q?Gt8pcFGA9kCr8qk2zNqoIjZR6Hy1Wvm6Q3ZXN7Zr+vPByzivCrLPR5Hwkc4i?=
 =?us-ascii?Q?W9sGtJfeKIf7aPeh1e2M9/dIFh7s1hnAimh3W3OJon9+NCBHjAYMqu5oCRwa?=
 =?us-ascii?Q?rBsg43OgWuB6aWZPLOYPHpktNexe4e5o2IPkMYVlJ0Hq76aXMwmyG7BHN1yy?=
 =?us-ascii?Q?BxQf54He/ezgru1UpZalWqHg1awsHu7h/2ALLYk5fbzXN58XrnrcRcc2TKU+?=
 =?us-ascii?Q?xwkt7ud7v1KC11O6J37QDfmro6vIlzB9qdtO58kfcdkjQzk651BHveoCxgl4?=
 =?us-ascii?Q?mZzzAPG8P8HJOuqebPi3Yqpivuek1zmZJfR6L0aRUTX5UNAJ/OstpDfDDXPd?=
 =?us-ascii?Q?SKK9ZXYYks1pEL5dSGGUcXixdH+8IDlR2TclcBYQDBrrHNqqlIjVSSLYUPeB?=
 =?us-ascii?Q?sjS3SuDmR8npfzT09XRW7dIrPkEXdkOdtHdsfQK5TYFJ9cDeSUmJlmEQd/mt?=
 =?us-ascii?Q?v4ybQSvU+h5i9lDrY1JSAWratH/Xcjh1SV74le7xYempzKDJo5/4FRoKNWtz?=
 =?us-ascii?Q?4Jr58nFSgLP4v2IkE7a2NnaAJR2WLp20ycGq/bbF5vDjgZTY+zbxKYXJc3H7?=
 =?us-ascii?Q?6QXZ27S1MHVe6ITpNt3YBbedTIW2HcTB2datIimD4oTJGNvhVy5eA40pv9+P?=
 =?us-ascii?Q?M1ELlhDozdc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HYmLSv2t8WFwlv9m+oZl91l5qCl9LheOK+p5Y/G8AIzoCYvQc9o1dW3K00dg?=
 =?us-ascii?Q?mQ4UUKmaLbDTnJv18Dbv7wX6upqRtmE+BDb9VcpgZU9/JXz2DoUm21sNI/a8?=
 =?us-ascii?Q?k8jeGbh48+/gufA3u9JADOAqruPwGDriWCcMMPD3xkB+ogaPb0b4H6TaJuWP?=
 =?us-ascii?Q?4cQV4ImsmmYTEN4RdH6wwgPBu8s7zlsZruBlXJw5EjdvTqYRaEdLnkfqXs7D?=
 =?us-ascii?Q?F/mweOfcGtNO3CxOmOdIjCRlBfkxN5WfY4qTG/K8GSc2sZvN0bEtpPoOR6LT?=
 =?us-ascii?Q?zwPQ+uE65Rj8SeNeKWQVq7yvStYAcwFukNj95sPMsh4BJNFuShlYTEIgtOcG?=
 =?us-ascii?Q?JYh/05UuhesDc7g+zrsTXi+H46UrADnP13QJ7GmJNZloLT+3lOhEILMx13Pn?=
 =?us-ascii?Q?WDQj6gPf3dzUrVxLEhCIbsTIvj2ruRjINmQ6mo7y7MT8faraFfFrk5OjgANT?=
 =?us-ascii?Q?U/E2UtOKFQmruEVRQnR1sJkzZKFbmf9hTlO8P/ICnK1kPis6vMJD9ivP478p?=
 =?us-ascii?Q?VlBeLsCIsyvqI3JBJUS4eDoErZzYIKNVyrUW4Pv7YGeZjr0Wk/BKfp3VRWI2?=
 =?us-ascii?Q?2Pq3sY2sxf4JIaKaLK1ygxXK2Bf947n/hS6vkSjU/5jxK1YA7GDx4YcHM6zG?=
 =?us-ascii?Q?RcLOY0s4mDCzfLGV3dwaVKOZ5cNG7T/t0TJTheOIauSzvCmladfLsjbqhcbk?=
 =?us-ascii?Q?XB+VkI8RiG6FaHUOJKZHCBvb++ljeVoFqtARaSfEAHyF03WAiwzjKMG1kTnZ?=
 =?us-ascii?Q?Y5tR7Isz+1J7Jfpey99d3KObw724hf3Y1d8/xUVb8T4/B1LbELgbxaYw0tS7?=
 =?us-ascii?Q?aLKCNQxCr+Y0lo7EoS4JzZ6LcYaTMtsk6HgqvLWwBpAWaOxvoWQoDejlgaMz?=
 =?us-ascii?Q?R4+VxGoaZSOMxAtOOrRVj6G/RCXsRpcxLYEbAd1ayrftnbNbmlfoyIoeqg3x?=
 =?us-ascii?Q?eOLR+fiLDQVVcFHQ0c4JaLod4Q7B2/cNlBkpiiIhMLxMcuxcC1i5nEQlSY+W?=
 =?us-ascii?Q?/NbUw+lWL8mAbVihixvNXzcjLvJCiFBbaOtZKC7RUPL3J0vZveofdKcAl00+?=
 =?us-ascii?Q?sDnToQR3J5btAg5T64T9KPSKlDhseGReYTt7ESd7pGc/o8wtZQaz9QATv1SK?=
 =?us-ascii?Q?ZvL6P09rGRcW0/RwWgEcsv19+9zTW6+Gm/phVyj0uGMHp+LpQAWHUOKScBo/?=
 =?us-ascii?Q?x/VpCUfhwaP4oz7bNPnKBMnp9ZJGBNbdMFg9+KRX+xIWqpfRkVHHtqzcKFhA?=
 =?us-ascii?Q?h14WKrgc8v/wmUFDhhW8vb1whwMv4wTntCZPH+H/w6W7ykm+EQnjNEcaZfyw?=
 =?us-ascii?Q?4bU8jfa9nAVnWlDFfM+pjmQe2JqvDo52xSyHSAn6fUDGYlhdW2nO+xLa8WO9?=
 =?us-ascii?Q?pyH+9NXkEj4gTO+WFL5KPiGDeqJ7rU4l4lqb/6c8HwEhgLi229JTdKas5PDq?=
 =?us-ascii?Q?QNsfXb41eXSt9gKmG0VC7+0hv6tgmSq8PSuEu0DF6s3nXBUsKYTru0gsip4k?=
 =?us-ascii?Q?Zc0kXKrOLSAhzs2J/bQST6lsbfDA9b5tXGzMZ/Jpn/fa4djqX92lfW8d8UHL?=
 =?us-ascii?Q?oB6mgKG7GdXRfz6WOZkmhmsyLbA3t9308bsur9XnYjZRjcqfp72a0qGcCATg?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Eks2lvAoNM0V54JbbE1W5J3/6UeAlMQiI+w5qtSaNxVinnWd3YjoEZl5ueAhx5TYpOnicg1cx0rsz7NKsYNIesjA7TeoMrPqbXVTlak7BVkVsX8d85Px4aJrw2WccGpU/CTL2vYGvOkrVuq1iEDeA8xZQAsO38duTX+Y/JLTbT5alQVvasiKmNAtoPEAjoWvok5QftCz9LQ0Yg2lfy159OP8h2n/WmdJPp9XvDJ7jFVFCoJoCoS2ahTC/d4R/xEv90G9ArCfdKiqQyGyQOQfUe3GiFTR1yIpUVMZE2EMjIQ3n6ylhzrZ72kB/azBVbj4fDljsBDKzPvN40P8MBYz657wng1YaXwX0oDy3LdAwLOMpLKew9ImHxbqVVjO0lRP6NY0MdLc0iWAKuMhYM3Ml55HdGqAugCpxgKvOUXlsLfTJwOTPnYMLgyvKSjJjfykBEdUofMTRKc+XPIpbzgVDVAzfnjUhrgs7b9vYMV08yoADeKYv3sZkh+WLDk71PLgo2Nb4IU5atgvxlJIn2pNIyLvsuuTeTni5/NgmSC5BtmQt0YrQMgLOkjHe7hendcEZ5bxjGgBKWP9ys2CfbVJ/+DU2edQUoHgCja++fxyuPA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acdfed69-78d0-438b-50a8-08ddf22ab7a5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 18:32:24.1818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osDwosbYfwYeHX6vpaBHa8WW7CGrCqLIfNvK+p6gY/BHQe0jkQ1XZHQWo+7RjOZHzubYC+Z0NW1ru3SxpS7wQAMzmsGWNpNXNJ6lCYRoAVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF077CE0592
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_06,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120168
X-Proofpoint-GUID: _oMzPHRcZywuGg85dDq0vUAqZNvBH4Nl
X-Proofpoint-ORIG-GUID: _oMzPHRcZywuGg85dDq0vUAqZNvBH4Nl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MiBTYWx0ZWRfX38MmfTbwXui8
 eBno4q6/zrmb9qxdGvPpi/3+y61QCMnHsqSyMBmi77EOIR3XTnqykxusC/0ipiY63MLk0+tzouO
 FlP/XF0AKFyuEQHCEP7FXzm/avN1T29HTG34dgoSXZ2+fiJWMKlGDGDV/CBMTCtb29Zw79wQxe4
 MUUgUz7hxaUy38cbzVFWo0STXTfC2/UQZyw/Kz8jU50YHK5KNll4g6UXHVc/cb3LOwruJ1liPD0
 5eZ51B/GcfHMpwviTB+dEfQtGvNzDcX9USM9mQsIijb3HYjyHYDKWT8T0JsoZvcrf8n60GPXV2n
 gYAmt8R6NgZ5jPGo/WHWPg2QYHiCFxbhJ5ygrn8nxM2vv8AjlIiVBByLliQloURPqSEVdA2Jsen
 q9/BoxtT
X-Authority-Analysis: v=2.4 cv=b9Oy4sGx c=1 sm=1 tr=0 ts=68c4673b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=dsin297h58ZBs74DGyoA:9 a=CjuIK1q_8ugA:10
X-Stat-Signature: oiu63naoc65p8ne58htgozibqc4t17yh
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B1D4140002
X-Rspamd-Server: rspam10
X-HE-Tag: 1757701954-130739
X-HE-Meta: U2FsdGVkX19OQY1bvlBfyAgY4I8R7x1Gkg6cFIfV4qThOEt0RviDMhPMzAIaXhGCcGHD5wmOkKrOSKdPnJAY+JxGTzhZ1hWzySnNcm5MdiSOVFrv6O9p50JUdvIfIjzFOoqNgsT19NCZUvIQXIiJoX2yXLwu+K2lf5pHhfvzzVjXegPx3UhgYSeZBfo4cSYFj65AkrWslEux3pSZRGp77uGKEco4LPH3gIz6iBpbwFGkT2ppMPCUNKXAasZt/pV+fMllHOy0gHs8GRWQO/EN5VborNn03xB2m28Q/FM48G1i9CPzEx5Gwdu5g/xjTa9lznr4wdOJ2FdhiwJ7+Lm1n/Dl4cgXW7AsN/n/5Cj9aLHDHiFZ7+1uicsXjG/qSHXXq+8sJ5j3ddXA86442HYkYoHPR/JOLHODA0+zg3FtNnDNJSeXBFBqPj57cSoIeEwMRBo5ZzT5eVQ2Q0p0ZS0RSLLWIUgTQ0htvEGiuO7sxgzwZO1PwIipm2P85bFIlT6qlzQ+ILI3gJk1I689aP4+LhkRGr/mCNe2AG98Sl+ZFR/eYwRfxdpslHaMGDT1L52miqzRVha2Vd380UzkE/XYzJqpYiyX2Syb2bVEGV0Wk2d1tSucf/+9Vi6zyiMlqM9D0cQp9jd99LO0kXsYU/GBQK9LBDBOOVlHyn8BcSK+/lWYVdwsz4+0kFHxNv//pVw+SCEil5sUSKL5ZK6LvUvM2PgjEsAXAF7etbzyZhG1NEDAgQC87k4cCjaBPiRAd2WaocTDSrFuISWJJQliWHRJ062spNrwy62HVVeQa1ew+gwg57TaCHOQLTgvU8kmo/R2oOjFIwpNWo8cPgcp0LikC3N7Rz/NZC7Sz1SaZoxzdhmi9NMhqAIQUrsEm+TerbniGbsF//dE0AdRC2xlew1YrvHX3usqUftR/ZH5xf/gUPMSp3StlyWtgKsKb0oKfyVkiZUq1GLsTePiNHf3ml5
 4IjCXKaz
 P6s5w6N43fejjNZQYL5KHbYVDdividZQ7dYJ67mzutdZlM3Qm77oNv4RwBifJ+ZvrUDzpvqgvTCrz9XfqXD1j2xkZZF+iM3vZY+qfvZRuFreXeZ++11wmALek2MWTsEoYmQ1Jm9mlWb5mm/tzUvKM7y2yHVFa3v0dPPjRBnlmJPZHvg9gPVw1LLQbGFEl7m5SLQO2qsU2iFj/ywhHHFVmBYg4+Fqd4xR6nqp4dD8cIUm0wSVRM1FUYfMtlfAgroUdR6gqtIpq0qXQCs+Sfs0KkxdFAEyZlT8gFdaXQ6kNKf5jrWCHvovfCSs+htujzsZQk/6oJ9/ykV2z+Vf1oW4It10dsxoRgW2v5C3m5SIqG8HJbnWi5gpOqmoeop358bMLNvUfd6GRmuC5s7L0/scz4dg3JUZkTVczFkGhvhK+MQJ0I0cFNwSif0mwj20x1YwXelGTSXQTZ/KR2QQm0oEi2VanADi5SC0eEj4y4pK/K4klH/vhBlu77q6dva5L94e5mngiMV7sHAfEPyjN9XuGuszRh1bYf19BCAjfby56FST9OIqVhYAKSeRu3A/TY534OOUjJtGRH0brDz/xYPV/X3wXCtWUu2Q8u+0PFcvdA2HbSxCljt2ecVkad8T91gwiBHnEMvoH6UgEKuwF8MiHgVbJ724PeT7yvf/r+vSUwkcngscYCHze/YLKsWKA2YFXQ2tes59cewoaI0KNl6XcEJfor6cu/2KbHDJqQnkcdeF3uapGI5MQF8w6sthlbE1Qu4DFgFWbGR7MCNPDDW/mTtMUcYk65cS92KIO12DPf/UU8UWPIHc5EEOfNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 05:58:11PM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
>
> MADV_COLLAPSE on a file mapping behaves inconsistently depending on if
> PMD page table is installed or not.
>
> Consider following example:
>
> 	p = mmap(NULL, 2UL << 20, PROT_READ | PROT_WRITE,
> 		 MAP_SHARED, fd, 0);
> 	err = madvise(p, 2UL << 20, MADV_COLLAPSE);
>
> fd is a populated tmpfs file.
>
> The result depends on the address that the kernel returns on mmap().
> If it is located in an existing PMD table, the madvise() will succeed.
> However, if the table does not exist, it will fail with -EINVAL.
>
> This occurs because find_pmd_or_thp_or_none() returns SCAN_PMD_NULL when
> a page table is missing, which causes collapse_pte_mapped_thp() to fail.
>
> SCAN_PMD_NULL and SCAN_PMD_NONE should be treated the same in
> collapse_pte_mapped_thp(): install the PMD leaf entry and allocate page
> tables as needed.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

LGTM, nice!

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/khugepaged.c | 25 ++++++++++++++++++++++++-
>  1 file changed, 24 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b486c1d19b2d..9e76a4f46df9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1488,6 +1488,28 @@ static int set_huge_pmd(struct vm_area_struct *vma, unsigned long addr,
>  	return SCAN_SUCCEED;
>  }
>
> +static int install_huge_pmd(struct vm_area_struct *vma, unsigned long haddr,
> +			    pmd_t *pmd, struct folio *folio)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	pgd_t *pgd;
> +	p4d_t *p4d;
> +	pud_t *pud;
> +
> +	pgd = pgd_offset(mm, haddr);
> +	p4d = p4d_alloc(mm, pgd, haddr);
> +	if (!p4d)
> +		return SCAN_FAIL;
> +	pud = pud_alloc(mm, p4d, haddr);
> +	if (!pud)
> +		return SCAN_FAIL;
> +	pmd = pmd_alloc(mm, pud, haddr);
> +	if (!pmd)
> +		return SCAN_FAIL;
> +
> +	return set_huge_pmd(vma, haddr, pmd, folio, &folio->page);
> +}
> +
>  /**
>   * collapse_pte_mapped_thp - Try to collapse a pte-mapped THP for mm at
>   * address haddr.
> @@ -1556,6 +1578,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  	switch (result) {
>  	case SCAN_SUCCEED:
>  		break;
> +	case SCAN_PMD_NULL:
>  	case SCAN_PMD_NONE:
>  		/*
>  		 * All pte entries have been removed and pmd cleared.
> @@ -1700,7 +1723,7 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
>  maybe_install_pmd:
>  	/* step 5: install pmd entry */
>  	result = install_pmd
> -			? set_huge_pmd(vma, haddr, pmd, folio, &folio->page)
> +			? install_huge_pmd(vma, haddr, pmd, folio)
>  			: SCAN_SUCCEED;
>  	goto drop_folio;
>  abort:
> --
> 2.50.1

