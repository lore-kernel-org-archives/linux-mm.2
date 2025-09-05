Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F7D7CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 14:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE44A8E0006; Fri,  5 Sep 2025 10:58:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC4B8E0005; Fri,  5 Sep 2025 10:58:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84458E0006; Fri,  5 Sep 2025 10:58:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9067A8E0005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:58:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C4581A0180
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:58:53 +0000 (UTC)
X-FDA: 83855503746.14.0A160DD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 70B35140005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 14:58:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=H6VQeSJh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HAVcQmFP;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757084329; a=rsa-sha256;
	cv=pass;
	b=IFr5bpgniiworuN1W9jnMxBLWI1CwHLamJ6BKM3g5tlS65prM6Fggfwmc++xpzzNvwaq1V
	ME4KCAelvdBex3dxUrcuRtHk1A0UR4ftpFq2WU2qCVX7J8X39KF9uLIWVElf82mqDZHSSC
	MZ7njGftk1g1zP+DbHc2b7W/DoEsDuQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=H6VQeSJh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=HAVcQmFP;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757084329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DH8dhAMdgBskVQTkQdWP6a5IdexjvDgYZUM3K6FYT1s=;
	b=HbXF/0ezYmxxZzWpdcjiF4X+hxJO2UjNywP3e+IvLeqCKmJVBCH5CASZQqL0Dh0b2Q3iD7
	aWi5fJd8brRGXc82IS6SpzJQMGcemzwMw19/1W5UI89F7A6NRYKv04VA6CSHl9gXuwajEq
	02rAwZCMkQNJPZvPUXnxF7O+7AE8jyw=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585Edx2e015339;
	Fri, 5 Sep 2025 14:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=DH8dhAMdgBskVQTkQd
	WP6a5IdexjvDgYZUM3K6FYT1s=; b=H6VQeSJh6qqKfWda9Y7wWn2EtvBYI1t+cK
	qq3h2p+S/mPiE+Z2kyGdCQm25RU4Xe0D+tvxYVikuL53+Fja9LhkBQaxYdodCyRw
	ZWhNmmBTooIED5NlHoVFb0JkBCEnfFcc4MAT2dCcGT2XJnxm/L5nZv1rEFZNOZ1m
	wx1nhhQXhI2nHpC4It0Aau6xrsne4AAtdyUbgMxvTfGGBonqdS7aryc9uVULhhOg
	SycbCVsAxhjhsXW7QUxPX1XPZwJRlxdk+p0kVn9vfHPh20FVRliDx1tlUcttM00/
	/kTpuyQ7Roz9t+01h+cF3BRPFetadN+PxjCg5rtP5LnOFZRb3zpA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4901tmg10h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 14:58:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585DojeN026456;
	Fri, 5 Sep 2025 14:58:47 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2073.outbound.protection.outlook.com [40.107.243.73])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrd4b1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 14:58:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nLYknJBhgwzGNlDrBGeEZjNEaV9pTREASyivlrJurrdkJh7KTKv0vRDcpjshUt2T6tIbPhtJKns1EE9Ap0H2PK9AmsZdNDWxWUHGTx0aH5yzMzisc4DR6Jw0g6FBXp9h255GeNrfoDyc90OOPZ19gYVeqwUMYp/KxD7Kt9+ibjr2Q1tSJfsLeyGn1j0EPVy7a7J2YakeRPhus0Kn7SyYD1JONqzUSaaFLa906IcpL66RMkxvNlQjlXI1aT0ax4As45YOhPck1MGiSoQoIz5+M+6nVN1F7Xdw0JP0Sn3xd8D+iLsJuUMPTHC2MdkxRS2H8C4eVvFj5UpxVyzuJtcJxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DH8dhAMdgBskVQTkQdWP6a5IdexjvDgYZUM3K6FYT1s=;
 b=CkyyDCXfurCluLzC+CHvcZIcw8R+j5giSz19ETzxchgwXf2JI5iwMrQDEsBh4d5S2XfIiUSh2mkrAAq3R1S7x4o/MLpWHm5LRdetrjucQqH47XqeKJqQOVm4uvRZT0TMDN/t9OE2hHvc3gBoOeyuc+ZpWz7jv6+nt2A2DtUGtEbXuwg5eVir0CPxzT9+yHEleBPLgieSakn1ZavqOkTEDP7RDkceldzLrNy4ugCQtzzQmFwZPMcZxWGI2b47sw7cV5sq+jPUQtmMRwykkZ552V2rjBb6QlwIj09a5N4GWh4maEMe0w3TUsDtzeLJgz2Ze1R/tj6zPFIQHQJ4FqOR1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DH8dhAMdgBskVQTkQdWP6a5IdexjvDgYZUM3K6FYT1s=;
 b=HAVcQmFPu2Jj8cQDIN6xcaIXQyraBtIGnkEUBIzUOjpzuf6Fy9Z/fU9JtklPkaZvOnV24oIoFL3aogT/Vv3cn+fhHotuxKBP9yk2cLb26D86zhuG7zZ+QJ8GZZ2f8FqNDiHxfNQ89p6pWoXG4pj8j0rYkuAUIJbdsH7SQ/Ih324=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7773.namprd10.prod.outlook.com (2603:10b6:408:1e6::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Fri, 5 Sep
 2025 14:58:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 14:58:45 +0000
Date: Fri, 5 Sep 2025 15:58:42 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, riel@surriel.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: make num_children and num_active_vmas update in
 internally
Message-ID: <7c0101ac-afac-4601-8be9-24587877a5e3@lucifer.local>
References: <20250905132019.18915-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905132019.18915-1-yajun.deng@linux.dev>
X-ClientProxiedBy: LO4P265CA0110.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7773:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b51a4bf-d1b2-46c2-7ccb-08ddec8cb5fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2blRfnKlsyiFCJ/C4ThieQ4YFdU7OTJCw0vpOebbXE8USHhPEj/Xm2yttbu4?=
 =?us-ascii?Q?bAWrSTAtdAszeAiVJHh21s8Ze98M+vDDua5rEx1cOxYJ3tGYypq3SQSagHE9?=
 =?us-ascii?Q?eomwvZG4zXbrfHeeBvq+xmjlYD8ADUeWeLNLekIwyNj7n0sJ02unOtyMiy4J?=
 =?us-ascii?Q?8fBCNPxky1UmuwZIwxz54hSwurW9mIB9WN8rC1teR3S4KNt3Kly+qyA4LzMC?=
 =?us-ascii?Q?hssYs9bZrX6rI+OSjocbUyRmtg9gLlBnkvrweASB1j2C09kfecFQFjA8AjDk?=
 =?us-ascii?Q?j9H5Va1k/ZPATU9r+7VFNsqcc6Dn2f3XROfFA9noOxueLMY4S2MYWQoIsXp5?=
 =?us-ascii?Q?Ex72l5RPZVHNfaaeL8IChkqWwGbtb8rykm8u9xXlYgr1WSezaJTH3GZGzCNv?=
 =?us-ascii?Q?9w6KjAL6cfvaoaPVsNg13SWShUfs90ztbqRqqh9WSKgRcIS0blsKu1bjTec4?=
 =?us-ascii?Q?QTChxA6ISeVqXP0Qr9NHVlmHc0w5uo4bKKrpktjMcQ1GhdoazIQiCDdlCJMo?=
 =?us-ascii?Q?pnJyJrR0qz/sMDL8hV3fDxlMTF/1BGFxw5e9efY2FG1JnGxRbpsuAnLjFkg8?=
 =?us-ascii?Q?F1QUgYQY0siO/GNhg8QwKMoh0Sd8vZwGrT/3dFdkyx1FKkYYpy9h/cn/Yot1?=
 =?us-ascii?Q?GeSbzjhtDdoRP01yUfs4Mr1dMaMlQL3j8FVofaB9QQnS4nj9JLaMrzdeETFo?=
 =?us-ascii?Q?Og+JWwWSVO1TJ6a/0pYiPgUyJ3l2X6pLFgfrxPyU2L7CYU3gLa6II3TXcT/V?=
 =?us-ascii?Q?sXi8yli1kFtnJ7dWH4tFyQYszclNadiOABRDBuQjCQR5LRH8+BaiBqxwGCAq?=
 =?us-ascii?Q?cgRxkQLJS7eMiNaTkK+V4NsHAy6aJI468QUDYc2+yFsPQveD1oL7iufB3qLs?=
 =?us-ascii?Q?E9I2HhLhBRvRfNQDJmzwxFarpdOHBiXSLNLu1AXIU3fOta5HygcOgX4tYotn?=
 =?us-ascii?Q?X5Fn2MdV7yleBN+7TWCRX5KxPY2vgcU1nIslQ62x8DAcNx3/zHZ7tyn84/uQ?=
 =?us-ascii?Q?+pdoWOXYnQ0aHfzbgOFk/I1g+jKCCp0+85K13mCMR1WT8T0Z0p0ShZ1XB0n9?=
 =?us-ascii?Q?sT4cNV0z9rw4gzoA3cyUnj7SWTDmdGktYxS8/jXrtAwkpjnWZe1dzGRnbuer?=
 =?us-ascii?Q?knwWWMtckTybghWG1bWjZeArjquBuVV9cJAqmXOAavsD0pUCBJfxcXnySeLT?=
 =?us-ascii?Q?jzQudfggwvdJXelyCuYT6NGdvOWN00M1RAGTg92OnluxQfVtVDLVHOz2ZtYb?=
 =?us-ascii?Q?H+qUGivcr5thL8bHPXEdMrY5EpIk92VSsAAbYXM9ujsVAx+KWKGsAWudz9t1?=
 =?us-ascii?Q?rLPQSsRP6Zssv6UYj+i2xLsljQEnAffMhQDXfuIHBkBAkfzit5FxTSwwoMTh?=
 =?us-ascii?Q?CP4ZZ0LP7+mqHp4fIKsPzBjax3twtfpbnbWxwUZBesLG2oiTjZenevXp/hOq?=
 =?us-ascii?Q?N5KCqxL70h4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m1ZPmrhII++GgMBoxrzqEXihBpuLOcdlNTtFIxOTszRzK5ilDtPj6qRUojD0?=
 =?us-ascii?Q?VQBR3EVMcj99miAhUHMK9h3ZFp7m2LaouMRB54ZMvgv2lnHsstue25y8hQkR?=
 =?us-ascii?Q?BllQbPjV8Zj2580sso/9/nJ+QwZR66pwgi9FAeMHtXWc23f9YaopRMg1VBRp?=
 =?us-ascii?Q?mMf7pW0VCxPDw3x7qZW5vqbsMjEBc7rbTO2O8Lcy2oy2FtfHA4LWsXsshjIm?=
 =?us-ascii?Q?OzSX4YG6vTD0JjURVjF19DnZ2ERb6PTE4fiAI1uKcvnYbjIM34vtcdHM4WJA?=
 =?us-ascii?Q?LqnhW2qOR8OeV0gvAo7rQM6xvbxEZmPF7h+zVMyBMkeK4eW8Doh3lDtca5Ih?=
 =?us-ascii?Q?Gb6+MfW9ewTQInrdsxs/c9SXWRPa0kdjPIXqe/P/O5IrbqiqJOgwiEifBpH+?=
 =?us-ascii?Q?q3fQaBkPCILxrlZzxruAQgOdnhTaaXd/nlR5/Yovdz9PupkAQvI7l32tAMwl?=
 =?us-ascii?Q?dlPfP1Jh6uRD/VaR1Zmk7WZw/M/EuNbX1chFBF9dSn7Z/LfkHHuAGHAIVOt3?=
 =?us-ascii?Q?cLTFTFfOafsMFqbVu2P0pI6XjQ4NzxI/gBVOt39X8NVpIniPSgGN5fEI9l1U?=
 =?us-ascii?Q?QMi7/aX5N2tPu3cahXJqPU76hcoa0xOFbGvD9WFHlb/k9pyniNpDMzzp9BhN?=
 =?us-ascii?Q?wwnG9Ff786HYzrq2OoKpGPdP9kk0ZCzyqsP2AEhGUDHtXAPdkMGAKO2kYWtt?=
 =?us-ascii?Q?4uDYrfhKDnxsyk62H87DN8cWoETlrTu2sfynly7jOQ22/OflkwRtFLuHuQ9S?=
 =?us-ascii?Q?Q/awtGXn90xXNPi2o3rSV8IF7YzYaTGD9Pt7Wb8onzPnL/fZlJ7h0pvHGSgV?=
 =?us-ascii?Q?uWrC0kTJs3qcVDHqcw16SUVVNQiy5WqUZYzaApnbKwOsY0OKsjB3L/eJkXxx?=
 =?us-ascii?Q?MmpAZUlFFpd6pO108ApzcXVQ/6WWG8ltp8GExizWxLtkuMHW37mRshccLh1k?=
 =?us-ascii?Q?tKas2Sr3Lm/utns6yxMv1F4i5bOrWWRTjPTsawE1Rrz2QODmOCsr2ZTPzOwN?=
 =?us-ascii?Q?UBNiRcKb6ntQQypy2AcZSqBrSH0CzMbre1Hn72/ZpGzvZ8F61gV1gaJQ4XAa?=
 =?us-ascii?Q?N1j2RhFAfa3/58t8rgTt+IlKaw0L/J9OX9xMvO8jFNNA0FAvG29mV5VvIh9d?=
 =?us-ascii?Q?RYTOxNur/T7y8mt6mlP8lSJSGZ5H5sZgtiyfcY0Yv8dzuCvxWIiiMqocqUF1?=
 =?us-ascii?Q?Y07sU9nAZNlLvJgPouTt2z3WLtXltlSbHykdBTob10GPGiG1YCtHjcnIvm1b?=
 =?us-ascii?Q?KRVg9GpZJ827uoFVr7WqzuY5hRZsKf9VXQwk+Qka7ImBvuRATJEm78hRY9vi?=
 =?us-ascii?Q?ngHGBVPpeEA1x+tkyUS0stsU9ikzR3O78kxqAyHjDAEQIByeoiX2ssXZ2uJx?=
 =?us-ascii?Q?sXPX5ZqYqavRcRyfh7WOf9gsGF4Unk6os9nw5qqGHH8KR7qCAZowXvCFyFQh?=
 =?us-ascii?Q?N0shphEWnaJhMCvDu3xcJ/n66ooQOAjxQSCtpVC+INJmMyvdzAZEwZTXVniU?=
 =?us-ascii?Q?Arvx11NmrImqWE8Ib4hNCcnth8OOCR9Z0YpJYIOFrZG8oKNwYMFv6+CUgJr2?=
 =?us-ascii?Q?A3Ggwsnd2CvMR4fhPTLxt14eUE7l97sQ/PeQ89/au87LUfD0x0Ph9d6K3+lI?=
 =?us-ascii?Q?Lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ujvigCsHuSgfWBaho1kTIQ8oGLmX8NZZwQ9U2mcW0qSvYohupMRdvHZiq1L9UYk1opOWveU8hOzL6ezjJ+z0Xl6K7VQ5N8zk/ahSVUdpimSvE3cKPdGAj6o2Ah2NtCvwAOqBLxoBHDyqx8iQD3G9kz1lX5elh0aLhY+QQyiGXZUjh3DPNHI5nThIk5KuFcFfxJXZ0BwjyBFRkpuApmvJNhYlVjje+d733teYnZ+FFjZhKfNX1Al9BTQ6q4dXG6jvz8Eu6K6353rA5HOjC+qkTGpIaHKGIyIb5oOFzC7ip7PcNAHQEFPB6795cVDmFDr6fNhSH4Zs/pCWfQcx2UAk+HiEtp3V83I8sLboQM2WOh1Wi93aQWMB2LPDUbm80MlkgAPn/I2mXHUOpVWMqCc8eFtO1G/FZWAhMy5G2J2pXQYew87ptGc7RoHcmKgwo+bGv9m4pR7IBodEKYYFEfwOEm6Mk3ncd+jzsd8+7pic4ZNFfT8SG/HPUN6hTy2klHZJrP1Dhe4bycY7Heph+kaSdKTbxsoZOtBBWWzIjbXW5nFZlw4ovMHAO+f5L2dYnvYsd5xmoI8moCO7XRWMKvEWZw0QCb9/vqOqmSW9dggrPe8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b51a4bf-d1b2-46c2-7ccb-08ddec8cb5fc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 14:58:44.9944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 867M/TPvEUNYopdOgzuNjMAyBYBARFosRsife7fWls4bO9Fscxbk9+7ESui4vWtkm8kDdT/yEc1JXSzhqPowkGDuMKQhA1Wfhh/cnHAbS+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7773
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050147
X-Authority-Analysis: v=2.4 cv=eKMTjGp1 c=1 sm=1 tr=0 ts=68bafaa8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=JRp-J7r70M4zm-GSbSkA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Proofpoint-ORIG-GUID: v7FswjDfyEUyo2uu3vjlxsnRmzaZf0Cq
X-Proofpoint-GUID: v7FswjDfyEUyo2uu3vjlxsnRmzaZf0Cq
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDE0MyBTYWx0ZWRfX5aYklrL7MgUg
 wU7Rkr6YKRyr6ho6zrltROdpsTerudd23Hx5MYRQHp6NwehoA2RArsGayzVTo9xGX/Kqf9wVA7t
 Sk4JdlqGKwnEQPSZNP8FaGL+wM75UG+m2EZS+pGZWLgAvJ2qlEEGMK4aEVUSd5rlz1p3U4PNULL
 zOx5+AfnBLmiL2qN0N1pu9j77dhFHobIiHBkeTR5yXh4OueQAKhPIaeADB3oAmjCuSD/h3E5FLY
 REMYx0PEy9/zCvLiKx8VwBYHtXhavE12gL3sZwqEZF82HV/ocvA8LAOVTimH6S7Enb4m9zxp4tT
 p7LLcdxUI34Btoo57bThTplW/5Jaa/0jq+0GaT8jftlMVF4uiakmQ+mk1H+D/m1bIWGNnOgmWmT
 LpClL+hsOzxrQHpMpGrR2QR1G5aTXQ==
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 70B35140005
X-Stat-Signature: hfh46u7a9f64f4fui9yqbmmjd6dd77mg
X-Rspam-User: 
X-HE-Tag: 1757084329-995218
X-HE-Meta: U2FsdGVkX19qg+HnW0WXh4m1K3Rqn0Puk6bkxQKBzbbv8dyl36WNZ5JTRVm+dasWBzxjkLUPDh/kkHGB7Qj0CeAewTdVu51DcxguPr+b7YWBxFyuUzLTLEyDpKy4AdMRiTbNuQOpPCVFsWTM7uVFBjmeYOr02FYhiMFPJpcjLrWIg/7fAPffQBg87sX0oIVpX6y7x+Ni84NH7qgdn3TnMeSCI/+ETJsc4+jdDAciZjVk4E9V2bBC56DclSodgJ10lqRdpebqaAR4DiPzPJszgLWhV1j+dwe519aUDz1S9zEJMJpQJtC0NnBEyqkW0q55s8QU5CsI9wbHeF9m89ckfOkzLFs1N2Z8iIthN0zSV9rWZE+iDRweVJa8G4DUx2LQRR24hzYUkqfT3L7rX7Euj0ytpa296Vphio7U2a04+/iblfv2jgwczdpOJf5E60F8thzZe3l729zNWyYG76clLEZewGFUDFDIJX1aKM1ygG3p6wMNsP85r8+2mZZqhW3ZDM0HRk8oxkZXC+JR1K/IZmIEF+pEQ6doI6otC8oSuxUEupnj2BuDONJi0M3tMOlj1+VLgFQHu+hYkev+tWXRiykpRsxM5O0HofgAXrM9WXntpQZlVdMTmq1h15QejykAiyo31L4oNyFLH39Ff7RnHgfXEYSLC6WRz72YWuDUkI9WUZTM1YqYKBuFcnfcfhKtQxsMbvmFHQJCS8Srh7tuCePipU9GVowkWhJrHCAlHXAuTwr9KkU26lrYbH+41rhWp34TKwBaxw6xHbwl9Vos59YNIH/XuDU4kd9o13LTXrLKG+AaBcGJ7FLY3TvoDi9c6h2NORDKKdfgUcBAhOJUEQD95mATFZAwW1d2AUb6ZwlqLfGDWxvaLJA16LbSDj66PjYSfbX+LcckQ/Ex6lw5GAiIGmT4y9+gUOuVtDnJMVNfb/T2NPSdVlfn52eJr7y/2LuS/rMcSswavUiG71b
 ZxrIvpy0
 uoyjpggGfNnUd0QK5CqRmAH3O+2mgRsOdR40lb14+mYxHtYmxJQ3Pqc912JHdwVtR/IPlxLOe458oyMV5c4MAPM4zSlQo+2kTgiu6bsxgCLn1IvbzCNMV4Ue6CrCzDnfOFsxYHTYqMzeETz0/NAubLh4Z1vLuhjc8qYbdgU4JOgyVq4f9ax16bPBmTSX8ojsqLlbjS4pBTKwEGSew1//aSpzXOzJcL1rZuE6O5gG2DeDfCfHn03L1t7KW2glEtZLbNRSNXn1ytLR9CB9d6pn8uNE6E5rsuIGIT99KEzNlMvFVBIpxjcJTFfPoT7a0s0fXkL+ioHSyNq4Wkhlx/VjrZC5pF1A3nt0bUg5CvCpsoG8FQQ4PO+OwNnZPGC3/NIaXnQY4j5kZIH7I5mKzo9jcMOLCz6M2CWW1DGhh8FLvPVl0d1VbtC1dpE277bpo7cpXVjhRBIlYP8wqlhr+3vxk9fEetmjQ0xP2z+OVm2IGdZ+5ZtQMqZK9Y5kZVQ+8IezR3xX2rVKsSwxi257r4G5t4vR5KsUbhbjY4VGv0G+DtThXjbg49+NMQYIsTSlaC6oF09CLo7V0hnMT/gEugHoP+k4HC5vCm5dCoK71g72+X1rly/aW76qsO5t73GSuMSEpNiwP6sGJhkzTyPdjMaUECZs/VTRvFPoItZOAEHGvvqc6IbC98i8WxjdXURqTipf/kuYX3MfUdJ6qdFxePmDojLhNINMfL+7AWBKv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 01:20:19PM +0000, Yajun Deng wrote:
> If the anon_vma_alloc() is called, the num_children of the parent of
> the anon_vma will be updated. But this operation occurs outside of
> anon_vma_alloc().

I don't like that what is supposed to be an allocation function is now also
doing additional work.

And there's literally only one place where this matters, since
__anon_vma_prepare() doesn't have a parent, it's ltierally only anon_vma_fork().

And there are only 2 callers, so I don't see the purpose in doing this?

>
> The num_active_vmas are also updated outside of anon_vma.

I don't know what 'outside of anon_vma' means?


>
> Pass the parent of anon_vma to the anon_vma_alloc() and update the
> num_children inside it.
>
> Introduce anon_vma_attach() and anon_vma_detach() to update
> num_active_vmas with the anon_vma.

I really dislike this naming - VMA detachment means something entirely
different, you're not really 'attaching' or 'detaching' anything you're just
changing a single stat of the ones you'd need to change were you truly doing so
etc. etc.

It's misleading.

>
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>

Did you test this at all? It causes an immediate kernel panic for me when I run
it in a VM:

In exit_mmap() -> free->pgtables() -> unlink_anon_vmas()

I haven't really dug into why but yeah, this is broken.


> ---
>  mm/rmap.c | 63 ++++++++++++++++++++++++++++---------------------------
>  1 file changed, 32 insertions(+), 31 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 34333ae3bd80..2a28edfa5734 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -86,15 +86,21 @@
>  static struct kmem_cache *anon_vma_cachep;
>  static struct kmem_cache *anon_vma_chain_cachep;
>
> -static inline struct anon_vma *anon_vma_alloc(void)
> +static inline struct anon_vma *anon_vma_alloc(struct anon_vma *parent)

I really dislike this, we only allocate with a parent in the fork case, this is
just not a win imo + adds confusion.

>  {
>  	struct anon_vma *anon_vma;
>
>  	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> -	if (anon_vma) {
> -		atomic_set(&anon_vma->refcount, 1);
> -		anon_vma->num_children = 0;
> -		anon_vma->num_active_vmas = 0;
> +	if (!anon_vma)
> +		return NULL;
> +
> +	atomic_set(&anon_vma->refcount, 1);
> +	anon_vma->num_children = 0;
> +	anon_vma->num_active_vmas = 0;
> +	if (parent) {
> +		anon_vma->parent = parent;
> +		anon_vma->root = parent->root;

You are accessing parent fields without a lock. This is not good.

> +	} else {
>  		anon_vma->parent = anon_vma;
>  		/*
>  		 * Initialise the anon_vma root to point to itself. If called
> @@ -102,6 +108,7 @@ static inline struct anon_vma *anon_vma_alloc(void)
>  		 */
>  		anon_vma->root = anon_vma;
>  	}
> +	anon_vma->parent->num_children++;

This is even even even more not good, because you're accessing the parent
without a lock, which is just completely broken.

I note below where you're doing this.

>
>  	return anon_vma;
>  }
> @@ -146,6 +153,19 @@ static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
>  	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
>  }
>
> +static inline void anon_vma_attach(struct vm_area_struct *vma,
> +				   struct anon_vma *anon_vma)
> +{
> +	vma->anon_vma = anon_vma;
> +	vma->anon_vma->num_active_vmas++;
> +}

Yeah I hate the naming, you should have lock asserts here, I don't love that
we're pairing the vma and anon_vma like this, and again I just really question
the value of this.

> +
> +static inline void anon_vma_detach(struct vm_area_struct *vma)
> +{
> +	vma->anon_vma->num_active_vmas--;
> +	vma->anon_vma = NULL;
> +}
> +
>  static void anon_vma_chain_link(struct vm_area_struct *vma,
>  				struct anon_vma_chain *avc,
>  				struct anon_vma *anon_vma)
> @@ -198,10 +218,9 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  	anon_vma = find_mergeable_anon_vma(vma);
>  	allocated = NULL;
>  	if (!anon_vma) {
> -		anon_vma = anon_vma_alloc();
> +		anon_vma = anon_vma_alloc(NULL);

This 'arbitrary parameter which is NULL' is also pretty horrible.

>  		if (unlikely(!anon_vma))
>  			goto out_enomem_free_avc;
> -		anon_vma->num_children++; /* self-parent link for new root */
>  		allocated = anon_vma;
>  	}
>
> @@ -209,9 +228,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  	/* page_table_lock to protect against threads */
>  	spin_lock(&mm->page_table_lock);
>  	if (likely(!vma->anon_vma)) {
> -		vma->anon_vma = anon_vma;
> +		anon_vma_attach(vma, anon_vma);
>  		anon_vma_chain_link(vma, avc, anon_vma);
> -		anon_vma->num_active_vmas++;
>  		allocated = NULL;
>  		avc = NULL;
>  	}
> @@ -306,10 +324,8 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
>  		if (!dst->anon_vma && src->anon_vma &&
>  		    anon_vma->num_children < 2 &&
>  		    anon_vma->num_active_vmas == 0)
> -			dst->anon_vma = anon_vma;
> +			anon_vma_attach(dst, anon_vma);
>  	}
> -	if (dst->anon_vma)
> -		dst->anon_vma->num_active_vmas++;

You're now losing the cases where we didn't reuse an anon_vma but dst->anon_vma
!= NULL? This is just broken isn't it?

>  	unlock_anon_vma_root(root);
>  	return 0;
>
> @@ -356,31 +372,22 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
>  		return 0;
>
>  	/* Then add our own anon_vma. */
> -	anon_vma = anon_vma_alloc();
> +	anon_vma = anon_vma_alloc(pvma->anon_vma);
>  	if (!anon_vma)
>  		goto out_error;
> -	anon_vma->num_active_vmas++;
>  	avc = anon_vma_chain_alloc(GFP_KERNEL);
>  	if (!avc)
>  		goto out_error_free_anon_vma;
>
> -	/*
> -	 * The root anon_vma's rwsem is the lock actually used when we
> -	 * lock any of the anon_vmas in this anon_vma tree.
> -	 */

Please please PLEASE do not delete comments like this.

> -	anon_vma->root = pvma->anon_vma->root;
> -	anon_vma->parent = pvma->anon_vma;

Yeah this is just not worth it in my opinion. You're putting code specific to
forking in anon_vma_alloc(), which means you've made the code harder to
understand.

>  	/*
>  	 * With refcounts, an anon_vma can stay around longer than the
>  	 * process it belongs to. The root anon_vma needs to be pinned until
>  	 * this anon_vma is freed, because the lock lives in the root.
>  	 */
>  	get_anon_vma(anon_vma->root);
> -	/* Mark this anon_vma as the one where our new (COWed) pages go. */

Again, please do not remove comments like this.

> -	vma->anon_vma = anon_vma;
> +	anon_vma_attach(vma, anon_vma);
>  	anon_vma_lock_write(anon_vma);
>  	anon_vma_chain_link(vma, avc, anon_vma);
> -	anon_vma->parent->num_children++;

So now we're updating things not under the lock?... this is extremely broken.

>  	anon_vma_unlock_write(anon_vma);
>
>  	return 0;
> @@ -419,15 +426,9 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>  		list_del(&avc->same_vma);
>  		anon_vma_chain_free(avc);
>  	}
> -	if (vma->anon_vma) {
> -		vma->anon_vma->num_active_vmas--;
> +	if (vma->anon_vma)
> +		anon_vma_detach(vma);
>
> -		/*
> -		 * vma would still be needed after unlink, and anon_vma will be prepared
> -		 * when handle fault.
> -		 */

You are removing key documentation of behaviour, please do not do that.

> -		vma->anon_vma = NULL;
> -	}
>  	unlock_anon_vma_root(root);
>
>  	/*
> --
> 2.25.1
>

Overall this patch is really quite broken, but I don't think the general concept
_as implemented here_ really gives much value.

I _like_ the idea of pairing adjustment of these kinds of anon_vma fields like
num_children, num_active_vmas etc. with operations, but I think there's probably
too many fiddly cases + a need for hellish lock stuff for there to be really
anything too viable here.

Cheers, Lorenzo

