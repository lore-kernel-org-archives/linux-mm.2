Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F05C7D5B86D
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 20:49:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0E16B0088; Mon, 15 Dec 2025 15:49:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E296B0089; Mon, 15 Dec 2025 15:49:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438056B008A; Mon, 15 Dec 2025 15:49:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1DBE26B0088
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 15:49:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D348713AA7A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:53 +0000 (UTC)
X-FDA: 84222897066.12.665F822
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77371A0009
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 20:49:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hru3Xqwl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=edgsFyst;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765831790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eLc5LnWSKy9jC8PZyUNH/TV9JzQm4DmA2F/kc5/O7OQ=;
	b=4RN/YeYjRJQwlrOXTjuwCoqF/WxDwd9nsIaNyw/Pn3kJt559gdygsXiReD0jhAUMaKGEzu
	GbESx7BaMse18Wih4l/jA3fF1qybid5Om4gMwkp4H/X8ZOQ3xFsWUV5SOZwkYNfDgFPhmy
	9REMnUnVYNRwWUFKCQ8pytazYcnxGT0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765831790; a=rsa-sha256;
	cv=pass;
	b=wQS9v9/6U7/MOOzJI8JwyKqwmeb24Tqpu80Xf35WnihfxrIlu0mXac/mmE0Kc2+jIXz4NT
	XdfX6n/r3xpqWBe3r3igWuuoUt4JQIOtavDC4nBaE4NAprD+LcO8iIorIEAaUnZVnatWQk
	0pzfVEZ4fbKtnbgyp+KqKeKpaQuElYQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=hru3Xqwl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=edgsFyst;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BFJC4NU2858947;
	Mon, 15 Dec 2025 20:49:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=eLc5LnWSKy9jC8PZ
	yUNH/TV9JzQm4DmA2F/kc5/O7OQ=; b=hru3XqwlyHYvv96UJZEE/6U5iGgjqb2F
	L8OWrpZdcxFpOUVrV001UIcdTeZ1knZQTCBPzfAMlOcgoP9DyfnasCqiVOMlFbnA
	DFpceH5UuBqvEbgfQrKb2jV1Xk2y11zePk3GDXsQdaIpY/RNuPB5fVncDVamw+H9
	ce7bw7q9a9nyEcsb9MhmqJ5TH1qibtGrmtmEgvo+AheoiXWd9NMosLMTEG+wXC9S
	H1Od7jEozTb3skPZkr3BN175pABUZMiTPi8YsysyTu+JqfNZRY20ZrMZ9mLfm1ZW
	641jg4qo7yf7yYbxlBrLMmLQ2p4Jl8iqkUVEe1HOWHoro+a3sS5jzA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b0yrujrrw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BFJJR1h022444;
	Mon, 15 Dec 2025 20:49:31 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011056.outbound.protection.outlook.com [52.101.52.56])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b0xkjej2n-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Dec 2025 20:49:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hXyoO2ewjfg4oWTlpvmkNBQ1guIbv1TZofIBARme9FvPbLbYXfcmV9LRtMWuubDAQRdKM8wRdGTZGamDmQMHBh2vNqgZIRJPecPQssIyU/28cmNPUSD9RnMugTak9g+Qu0Zj/EECyHW/hOJflGlpW8onqJDFjozEhTsrHZlcNawcOhVei5b1ofAnLUG0U9iuwFKhUmnWuWNoJhMgWw4Kux25UuZKl5UAph34XU+RI5XXl0+IXBIP+zwkXqKXZtR9HLeBSBCT/v3E4skbBoBOW2rq7zTJCXKp0sHyzAl01/hv9P5codBIM/WCDDuHOHpihYc+9O2lN+k0rRE8u5KVVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eLc5LnWSKy9jC8PZyUNH/TV9JzQm4DmA2F/kc5/O7OQ=;
 b=ePgfXvplLrX2sQ9E8XDYE4DjNA5WdzCnDw7EToWAq7tl28qKKIXnR97mvAc3l68WnSBD4525M3Ixc/sncyWiTimGRGLEUxS1M1wHvKpV5IhmNoNwoC6cYlwKQAZMZ4GHW6IpD45kO7sYrkGEGR062xbwZueZ1Vpmj19Cjg5FWF88tQn0+TNguSJUwoYSfAWoNnXsrgqOsohStq37DMYlo0+UMvjg9McIBy3sDvBMYkIM/21P/exVsCFYmZmJxXygJP3pkzVo7fS6yg8SrZ7BRNm956dO/zaUx+X+zfSGWunmLz2RPUYlhnxujwo4CvpZgDAK7XF8nEyy1E5hZmM5Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLc5LnWSKy9jC8PZyUNH/TV9JzQm4DmA2F/kc5/O7OQ=;
 b=edgsFyst621KTQmMKQ8cO3b6LVIE8wSsqgd4hH5B4pLSmHMZKX4iTdC/i9Loc680UMiADVndCgyL0YquTGYAX29dcVNhWTIVmTeHUeMhKyfkAQvUVqG6X2vuJtIJZg0zceol/QtWqvvlBNFXa78o7OU5mxyCmcR0zpuTklO9ecI=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7992.namprd10.prod.outlook.com (2603:10b6:408:1fd::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 20:49:24 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9412.011; Mon, 15 Dec 2025
 20:49:24 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, ankur.a.arora@oracle.com
Subject: [PATCH v10 0/8] mm: folio_zero_user: clear contiguous pages
Date: Mon, 15 Dec 2025 12:49:14 -0800
Message-Id: <20251215204922.475324-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0270.namprd04.prod.outlook.com
 (2603:10b6:303:88::35) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7992:EE_
X-MS-Office365-Filtering-Correlation-Id: 46cc1833-43a1-4259-2aab-08de3c1b6e04
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iF6fhSgrsTSMnwhKm+mYDRaYi+9+NTC958eYrJeO49e4+Rs/3ybNP7HM/MCA?=
 =?us-ascii?Q?+AKPM6uphvectOqxN5Fe0VTwMvBSo1IUXC4L/tBpi9wKCziJACsDvhNSXw2j?=
 =?us-ascii?Q?Z4d6/IPMIWLydRW+cnmktY2ckmtxf1e0xdTy6Aw+3oaI8g6yY2RDuHJQgWvo?=
 =?us-ascii?Q?7C1p1clb0kCaU0UclQLRiH0yXSMJiiwg6XbENK9fOkBauBOYPX/uzUqozUfM?=
 =?us-ascii?Q?GZYZjShqidWUImrPx5oCbpRXJVtjkt4sN7u5BCBf/wLuE0JGe9zUpE0MtjOT?=
 =?us-ascii?Q?FEy02lP+YbhNnZZsJpn5SGtiISGJDOPXH61lrIQeRFolaPZC26ILpWOLfep/?=
 =?us-ascii?Q?3ZP+8kPueEQeeHR8ruUm17R89oLPffP2wrGnQq4aLqZk8WufiQvOLt1A2Wtw?=
 =?us-ascii?Q?XXhXM2GuPPqNWCt9m3k5XaYwKNbVFw9pMHC3+I/nMJiX6Z3pUYzjac+wrv3/?=
 =?us-ascii?Q?bNbwwwrevG2bd4tEiz7iI1QCPFn8dpfvIiAxqZ4t4RIUjue+WgE4gas5tfJp?=
 =?us-ascii?Q?2SQ6sp9qKvbtay4vjx8GLlrNcCxrKSs0CK3zdTs0k9Gyn5EPfX3ZlYDf+lr+?=
 =?us-ascii?Q?Sw8KA6ZljI0ovHrtbAhZIoiv41CJ3q9M28h+g0iaGVVOjC/JpNatacIbUxyI?=
 =?us-ascii?Q?RtLaRnJh4V1JwvYrpMZSmQkgkQIloGh4F6GfQYmdKSqkDvkFZ6GXNtEj+t4J?=
 =?us-ascii?Q?kR3FiLPcxA6W4DZ1x8dpzzBtMnmhAwdFNJK9HHxV77XEzohraau//4CpM0Fy?=
 =?us-ascii?Q?CY3R2+S/GRACflrW65KHjByYxwgc55kKH+E14i94rEOXoXxFJKhUvQ3Lbp0/?=
 =?us-ascii?Q?URtfLfffWWwGsjMR9/6UUeFUBZZ2DzkobMhEcrtBm4ID1GyCpDahtOEOidoA?=
 =?us-ascii?Q?jhzEF5OFpqAL5lhtoi9ROHFDjf4Vc+pM3uAQ9JNvVvNIC1FTlySpRRGlVD1I?=
 =?us-ascii?Q?tzNE1hHSS9JRogRk1BGavwUaxuSEBm5dEM04++Nt7ASTm3IJlqEwvZ1l4dVY?=
 =?us-ascii?Q?X91ATBIyltqLrbmQpHSowu9ULItuOQr8641oJufBmoaAw3BW2RjKIr4dQ1K7?=
 =?us-ascii?Q?N51ptVdwrERymUKlVzhKjleMB+nraPYbSK9TVmVk1IAx5glzT0dutFZNwNQJ?=
 =?us-ascii?Q?eE4ahUkqnszCbBiBMNqa8uvfXLEozHq94+EIlGUSKX8yPzs8lkgSnxZSjrz0?=
 =?us-ascii?Q?jkPnE1I/kee2bpReIOX1N1clYFkAepN7h84YXwG+4FC6IirGX296gR2bnOOc?=
 =?us-ascii?Q?ZZZHGAGF3AgI7vjA3I3X2ijoxY1ZIH2CwQflKfbQXYPHC7ViDjlezAef+Mpm?=
 =?us-ascii?Q?S8IsFgtXs/ou2MyNjVPA/WXT9ChKItdn3Ff3VIMlNM4QcY7R0n2Szfgio70T?=
 =?us-ascii?Q?t53d0ZJcu1z914I1W+6dOxbn1E9rBQwTUOCdJHbQhVZau4nFmL97KXWmxRME?=
 =?us-ascii?Q?jEiSVXPn2QmzBHpDcuO9POWoU65f+NK/tnEDkF2SpnHX5DdkMK5qkA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kediOwx65qW0VEG+v2OdHf9hsW5ujWnBH7oRFPZ3bwHq8/yTebrfJ+ofwSqR?=
 =?us-ascii?Q?p0TBogCp7APeLKKkpaXig1gzjtlwh9hhPzpnyMSTwYb8tIN3zw6EGSns7gkj?=
 =?us-ascii?Q?g7qua/ZR359kgG+ZQ0OBj/1arRi5GEtrV+zQbWkLpwZiVDyBDAY/JbNZjjGz?=
 =?us-ascii?Q?0qppjCpB6RmhjKnZh5vGOE6u6i1P1Lu0oIj41VBsxQDyDimK1CiXQ8Cj3scf?=
 =?us-ascii?Q?XM/wUUDXarrLCbSHe8VD5J7wnz9UXd9aDa1f/Oho8kKZYA8uZiZPWEpGb+sM?=
 =?us-ascii?Q?rcnoJXLu9VqQw5CgKS0w6JVvjeQLAF/V53kJjNJxgttyWS2se/I9/fKUsvSY?=
 =?us-ascii?Q?v+FOcor/ucYYBzueLwd8ETICwrpzF7z0UssbOwxDvud7iEyKv5j4W4uMvgQp?=
 =?us-ascii?Q?ZoNfoOcGCkuAWRdJqoIqZ9SdkufjP7P/6mMzQN536ZYoAbQbZnH0gmZyMW+s?=
 =?us-ascii?Q?RDbRtKgeygeGmMSI/fqomBffkz5HHws6jEgUiSLBfg/r7On+HJGavLnd9ok/?=
 =?us-ascii?Q?9kiUham0OC4rSJP23j2y0GzQbhbHiKlSCxGAMIZGjsNHIge7kGeKBd767NgI?=
 =?us-ascii?Q?eUMDwJGUYkQ8Bm7/tspBivbaqe1bnQiWCk6tueFZLb6MNpaOY0uJilBkh4HM?=
 =?us-ascii?Q?+7K0jh9e0LdkQUcL9ScWlJ4zMfduhIVsR2eYjKLmWmqdLQpfTzGJDBVAB+gT?=
 =?us-ascii?Q?ym7szrGi7UOC0GLjKfL+aqcd3bVjqAe4Ks56ch6EhmsBu/CtIyewHPp2WDOl?=
 =?us-ascii?Q?HtBj2dXgVnmrQxZNkeDf75gJnuC5XpBlFwOeSqhkBeyxkwwbBRCMcaQ1DZYj?=
 =?us-ascii?Q?tAKw4NZ5t+nCaYO1CfpPlDIbwCIR52oamNxA0kF3qY7yZPlT7ZzEI6JqRPiz?=
 =?us-ascii?Q?tqvMmHTrUgFFtsvLa7XSUxZw7r1jtRGS5KQECZ1Qtu5+Yi9STjj4w1jD7OXd?=
 =?us-ascii?Q?H3CBS7GxAcbxkZ94N44FSG0uWX4yBlTrIaqgmirjVUtYUK6A3//Wc+HJXiKf?=
 =?us-ascii?Q?QIr67MMNST32hUPqFiLgcYkx+3C4tMV3xWW1iKbFgHuiq3d2M9taHw+8U4vB?=
 =?us-ascii?Q?JdnJErfB7O22KrbvgcYlbNxuOBTWJGU+o63M5AUHtPM7WbXbTydKGVH0NKHj?=
 =?us-ascii?Q?3FsqeKM5lp4RhNP+jivnmpWCfifNDkXi21A7GmccCYEqjJYt5pGckEIc1XtR?=
 =?us-ascii?Q?7/3/Q4Aw+8ulJK9e8353VCP4O3zfMJU6Qk6zE4Lav7hLQZZNDzOrnWPE7NSQ?=
 =?us-ascii?Q?COe0aMxJj/KbIOIfmAJCgJ+L8bG8/NRLnxwrdAdPj2/oQz77UrNJWrVlDGTp?=
 =?us-ascii?Q?HnP4lHs+o7zaHWS0/rR0+o82IvD3hQhvnO2gHbyYRSmFqAPvvujYLhcsxgeK?=
 =?us-ascii?Q?Iq05GIAOPqfLvEahh1KW8drksh3dI2iunCJo+yysfCx4+SjGfhF61rdN1uR8?=
 =?us-ascii?Q?mVM+0R5XZ5g4Q1i6CFOcY+owlPbLTynz/LhY0B7iafopfB/m6z4NAMh+QXCG?=
 =?us-ascii?Q?kdhbIE/7rc39cHtKGpwOVWPYgqSc2CW+dx8F0sCTtr1jKJGzPNxt5VuLZ87E?=
 =?us-ascii?Q?8ImEarsBm3oH9tY8zOZA9txuTSnEKp1nwpBpwU8USSxYtfANbYmQBV5e7Gwa?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	nvhRDwKO/cF8C/9qVykexewKHimU2ZfYi8ed5cT+ADOQMH6HSbT9n3d8juuFxGo9nyq3N6s3Aba4zqstjz4uBah6CKln69NxK4W2Rypu2sVnMbNiNJgGLGY1nnu9Hax1JGFQK2Wx9GXOp7rdOJYosRTBcVmtXRYKO7STAw8WFtXtfKv2reHruFGo0d2PZRlwBYkX99FuH2SfNzYlAj17H50Varxi2lsjn3+iUN70UIcMPFCn3MVrRy9fwCfyNzvRFrybOjvGN7uHKKFMfVykhqFzI7nsF9103bFut4IFjXzAYbBnkwPTFLrJxVM2a87Zx7c7O+tKtZef8TqbFc3nNXEildo/sBS+7FcS2dV6g5MSV7BuRZyTeYiBQH6hBz9wgUwzMkour8jE6vG9Fi+Th7djO9jLWwqWGUbP/5vaSDk8PKYOqR1BkjvrPYVgJMADdqnXqOBurX6o2BOdnkVkuDdh361D75DAHPvi2ywFTYl8kTuSarHxKCNag2Zt5x1gTl3SwtVJ8pbDntpjZg/2jcxBWa/yEzT0R43PNj5Uybj9arl/0AmVaUr/OSlq1wqi6N3osDHyw8qGMyEuZpXBXQUjA9s/4rvCQ71g4yz1PeI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46cc1833-43a1-4259-2aab-08de3c1b6e04
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 20:49:24.1957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULD42eRHsOTf7Y3auP+MKEAIFDCLIDUwKCm6LoSjYcZddEC2umqvfrvJRgoHy+CkcgNm/EnhY2u+IwK5naFkinbN9svQM2VKxNrIyWz4v4Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7992
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-15_05,2025-12-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2512150179
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE1MDE3OSBTYWx0ZWRfX+S/PAbxJjMPY
 QYt1Dzkz5B2T2xCsCx3zIeYsNOGBdy3cFFVxg4XLWXb1pFejXaETuus1Vjlc8fnixPL+KB+XPX0
 IbnVY1fzXHYZkHZC6vBO8YjQJWeYRxk0rRzz4vnw5ebffRcgls13WeKZ6Obnw7pkzRSFig9JYhz
 9FhxtJtRZHpF48Asv+eJKdEfE6U+2QBwNt0BVZAoqOjR53zH4hH2zEaqJ1M8ELqwk4ePtBq+c5o
 H2RC6RKBCP6Vz9Adh03Ld5/RTwUD7Mc1NfKJY532hsqoVVwRHt/2bVpf4+FeLdwNQ9f7zTGBV5F
 lETDGzs3hDYbmRzdNxB0vTzeZVA+03M56DMMu9O2EmsU1/7V+xGzLk7fogz0ltNY8GrxfOunaEP
 a0EfW80jleSsx6EChCo8jonaVA0OPizxIV9ND5yAxfGl5lh6RXA=
X-Authority-Analysis: v=2.4 cv=TL9Iilla c=1 sm=1 tr=0 ts=6940745c b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=zd2uoN0lAAAA:8 a=NEAV23lmAAAA:8 a=sqr0N8PgWN6HkAuJOcEA:9 cc=ntf
 awl=host:13654
X-Proofpoint-GUID: OgBhA6FQLZZdh82AY-sDZ0uWoQgTr8oi
X-Proofpoint-ORIG-GUID: OgBhA6FQLZZdh82AY-sDZ0uWoQgTr8oi
X-Stat-Signature: 8yhqm3f7mywua6i6po4ufwh3aiwz7fmm
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 77371A0009
X-Rspam-User: 
X-HE-Tag: 1765831790-34064
X-HE-Meta: U2FsdGVkX18289dtu/ZQqg2ugs+lknpwMi9njzwOqaRlyVmqVqFoO/e2ercmCVNp+A/lCH9wKrmnAD3DOftkYkdM0S/J9/0ODnQnNTnkjaIxmMS8WXTrchbfUM4MsegNMSBW7cbpO4YWip19V5TGXHYazJdPTeB9M0vZ9f2LJoqGNx9zQbbUib42npmMjxW27aq3jW3WsgLUoiQVeyvqkoe8XvkjYNZm0SSyXh2ijpyV3LdOLDidTcP98Cnsx1dBWi3TaixIcoEio8Gn2km5TVAB6QuTKfUMAifk/2iubqiiPjtAQXNJXeFxwqgihZDJcwKgTVMqSP0LaOC5JJsiJEJPSQvIimTRropgR9NSfQRA8+m7lNtrPcnfgSzKE9PzM7xs5TJPI82QNAqd7oSgvkKKpjfVlXThHJav7TQ1EfwDMWk2riU/CjKqbUW/wiwsY/HQfOgBSknGXGekier64ifneYvjA/lij+Q3DaXMS+cSLEtuenv5bWmuH1145bbfRGJgddrSiNEMOlkdz4Mg0/0vYOjkuB8CyO241tkFlGT82zR31dcOO+elwuDtA1jOJ9imxWfOoJfsQTt9pfVetRC2C1WYMKgjWDEIxhPItQBcnhbK0frFrNfsT7w1Hcgqhy1lpYPqKzmo+tm0V0SoNis+0POGaTxvM7M1hn3WFWCAs7swJpDpFhGOmJl0y5IcGuiiNZdljvp++ZAQwjsfHLrNnAvBJeIJwOnethJtrqoWsZanap4pm1mvnTJntm+JSysaC0XCZ+BSY+SnFEl2LGQgnbXb20bd1ZRK/qtCIvluNGfMVAyEn9or4t9O4CUJX6z6cQtu8BnWTbXNQB9qypyf2AmvValMLiPKZiB9geyxLPaWcbds1+ZfEKo3sfrC/8TEGba5u4kyPvJzxA26Ixo7/zDqP1DnGgqiNFPNP2KYInfwFAkKeRpeWlSSEJ0upRgOYe69ngxKiCkY1AY
 o2Bvc8Gc
 qZvRJt30FrFCXegJNr6OrS+F7aK1QyUl084IPEXD4zGLxQEffINAeQhYkDaq/brDVn8zCmKN6aSanZo8GXAeMzARapDCUyiAlg7LgRTNSJbVHi4Z419Z7HJL97jQ0sxkXrkoH592XvDBX7+TcsLTxYZLmcTFk/GqkwABEmf9xpbJ7Vk9IcHFNh0V5pbPcGWf4SIBWIgwTwDU5umjGB4Mz7lUG6gscEtdymW+7E+HzGOD9twx8+k6gVIq7GWOfSItMdTFK6lStM6rJav/m1pDc8G9ed0s6yJ0iA8xiBu6IO/cPyMc7AfNZvoBWDDqPicbsck/2zsnx/PpF0tNumPwcunwapREJWJVzPPOS2AYu+8dlsY9ah0RqqomLleFrRQ9k04QbYQpqugQnoLlDEhf1kiwZR358kcaBQk9G/cM8wmhKcLJ1sgopW/jbtsicDeh83vkxZNumChBjNeBFEG3BlIxlX4envni9izkB9pDdbh6kDjtahjunXFesJ96LYaz7Gab/KbEkM1iqbszRyIlQ+5Jsmo7s6uSGd+zGTHCqsl+fqmCnqClClb9uczPLRK+QLfqUa1ijP9zwyrVWYCtj89EmnbmDzjkgxPvP6RymWipjD6G7ITaChuJAHiceFzL2Zb0DdYrt+dnSbV1ITSv4YxhqWC2OW9sHAZEBN/Qs/y/ABZmOIUHbZPO+ZcNp3fJ1TEtaGoqjosA1z5JOnf6CLiPcbIcYDl/J+dlIAJkuJS+7WhF70JMxdrpkGb3U6MC7m3u0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ Resending with the list this time. Some of the recipients might have
  received a duplicate copy of this email. Apologies. ]

This series adds clearing of contiguous page ranges for hugepages.

Major change over v9:
  - move clear_user_page(), clear_user_pages() into highmem.h and
    conditions both on the arch not defining clear_user_highpage().

Described in more detail in the changelog.

The series improves on the current page-at-a-time approach in two ways:

 - amortizes the per-page setup cost over a larger extent
 - when using string instructions, exposes the real region size
   to the processor.

A processor could use knowledge of the full extent to optimize the
clearing better than if it sees only a single page sized extent at
a time. AMD Zen uarchs, as an example, elide cacheline allocation
for regions larger than LLC-size.

Demand faulting a 64GB region shows performance improvement:

 $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5

                       baseline              +series             change

                  (GB/s  +- %stdev)     (GB/s  +- %stdev)

   pg-sz=2MB       12.92  +- 2.55%        17.03  +-  0.70%       + 31.8%	preempt=*

   pg-sz=1GB       17.14  +- 2.27%        18.04  +-  1.05%       +  5.2%	preempt=none|voluntary
   pg-sz=1GB       17.26  +- 1.24%        42.17  +-  4.21% [#]   +144.3%	preempt=full|lazy

 [#] Notice that we perform much better with preempt=full|lazy. That's
  because preemptible models don't need explicit invocations of
  cond_resched() to ensure reasonable preemption latency, which,
  allows us to clear the full extent (1GB) in a single unit.
  In comparison the maximum extent used for preempt=none|voluntary is
  PROCESS_PAGES_NON_PREEMPT_BATCH (8MB).

  The larger extent allows the processor to elide cacheline
  allocation (on Milan the threshold is LLC-size=32MB.) 

  (The hope is that eventually, in the fullness of time, the lazy
  preemption model will be able to do the same job that none or
  voluntary models are used for, allowing cond_resched() to go away.)

The anon-w-seq test in the vm-scalability benchmark, however, does show
worse performance with utime increasing by ~9%:

                         stime                  utime

  baseline         1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
  +series          1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )

In part this is because anon-w-seq runs with 384 processes zeroing
anonymously mapped memory which they then access sequentially. As
such this is a likely uncommon pattern where the memory bandwidth
is saturated while we are also cache limited because the workload
accesses the entire region.

Raghavendra also tested previous version of the series on AMD Genoa
also sees improvement [1] with preempt=lazy.
(The pg-sz=2MB improvement is much higher on Genoa than I see on
Milan):

  $ perf bench mem map -p $page-size -f populate -s 64GB -l 10

                    base               patched              change
   pg-sz=2MB       12.731939 GB/sec    26.304263 GB/sec     106.6%
   pg-sz=1GB       26.232423 GB/sec    61.174836 GB/sec     133.2%


Changelog:

v10:
 - Condition the definition of clear_user_page(), clear_user_pages()
   on the architecture code defining clear_user_highpage. This
   simplifies issues with architectures where some do not define
   clear_user_page, but define clear_user_highpage().

   Also, instead of splitting up across files, move them to linux/highmem.
   This gets rid of build errors while using clear_usre_pages() for
   architectures that use macro magic (such as sparc, m68k).
   (Suggested by Christophe Leroy).

 - thresh out some of the comments around the x86 clear_pages()
   definition (Suggested by Borislav Petkov and Mateusz Guzik).
 (https://lore.kernel.org/lkml/20251121202352.494700-1-ankur.a.arora@oracle.com/)

v9:
 - Define PROCESS_PAGES_NON_PREEMPT_BATCH in common code (instead of
   inheriting ARCH_PAGE_CONTIG_NR.)
    - Also document this in much greater detail as clearing pages
      needing a a constant dependent on the preemption model is
      facially quite odd.
     (Suggested by David Hildenbrand, Andrew Morton, Borislav Petkov.)

 - Switch architectural markers from __HAVE_ARCH_CLEAR_USER_PAGE (and
   similar) to clear_user_page etc. (Suggested by David Hildenbrand)

 - s/memzero_page_aligned_unrolled/__clear_pages_unrolled/
   (Suggested by Borislav Petkov.)
 - style, comment fixes
 (https://lore.kernel.org/lkml/20251027202109.678022-1-ankur.a.arora@oracle.com/)

v8:
 - make clear_user_highpages(), clear_user_pages() and clear_pages()
   more robust across architectures. (Thanks David!)
 - split up folio_zero_user() changes into ones for clearing contiguous
   regions and those for maintaining temporal locality since they have
   different performance profiles (Suggested by Andrew Morton.)
 - added Raghavendra's Reviewed-by, Tested-by.
 - get rid of nth_page()
 - perf related patches have been pulled already. Remove them.

v7:
 - interface cleanups, comments for clear_user_highpages(), clear_user_pages(),
   clear_pages().
 - fixed build errors flagged by kernel test robot
 (https://lore.kernel.org/lkml/20250917152418.4077386-1-ankur.a.arora@oracle.com/)

v6:
 - perf bench mem: update man pages and other cleanups (Namhyung Kim)
 - unify folio_zero_user() for HIGHMEM, !HIGHMEM options instead of
   working through a new config option (David Hildenbrand).
   - cleanups and simlification around that.
 (https://lore.kernel.org/lkml/20250902080816.3715913-1-ankur.a.arora@oracle.com/)

v5:
 - move the non HIGHMEM implementation of folio_zero_user() from x86
   to common code (Dave Hansen)
 - Minor naming cleanups, commit messages etc
 (https://lore.kernel.org/lkml/20250710005926.1159009-1-ankur.a.arora@oracle.com/)

v4:
 - adds perf bench workloads to exercise mmap() populate/demand-fault (Ingo)
 - inline stosb etc (PeterZ)
 - handle cooperative preemption models (Ingo)
 - interface and other cleanups all over (Ingo)
 (https://lore.kernel.org/lkml/20250616052223.723982-1-ankur.a.arora@oracle.com/)

v3:
 - get rid of preemption dependency (TIF_ALLOW_RESCHED); this version
   was limited to preempt=full|lazy.
 - override folio_zero_user() (Linus)
 (https://lore.kernel.org/lkml/20250414034607.762653-1-ankur.a.arora@oracle.com/)

v2:
 - addressed review comments from peterz, tglx.
 - Removed clear_user_pages(), and CONFIG_X86_32:clear_pages()
 - General code cleanup
 (https://lore.kernel.org/lkml/20230830184958.2333078-1-ankur.a.arora@oracle.com/)

Comments appreciated!

Also at:
  github.com/terminus/linux clear-pages.v7

[1] https://lore.kernel.org/lkml/fffd4dad-2cb9-4bc9-8a80-a70be687fd54@amd.com/


Ankur Arora (7):
  highmem: introduce clear_user_highpages()
  mm: introduce clear_pages() and clear_user_pages()
  highmem: do range clearing in clear_user_highpages()
  x86/mm: Simplify clear_page_*
  x86/clear_page: Introduce clear_pages()
  mm, folio_zero_user: support clearing page ranges
  mm: folio_zero_user: cache neighbouring pages

David Hildenbrand (1):
  treewide: provide a generic clear_user_page() variant

 arch/alpha/include/asm/page.h      |  1 -
 arch/arc/include/asm/page.h        |  2 +
 arch/arm/include/asm/page-nommu.h  |  1 -
 arch/arm64/include/asm/page.h      |  1 -
 arch/csky/abiv1/inc/abi/page.h     |  1 +
 arch/csky/abiv2/inc/abi/page.h     |  7 ---
 arch/hexagon/include/asm/page.h    |  1 -
 arch/loongarch/include/asm/page.h  |  1 -
 arch/m68k/include/asm/page_no.h    |  1 -
 arch/microblaze/include/asm/page.h |  1 -
 arch/mips/include/asm/page.h       |  1 +
 arch/nios2/include/asm/page.h      |  1 +
 arch/openrisc/include/asm/page.h   |  1 -
 arch/parisc/include/asm/page.h     |  1 -
 arch/powerpc/include/asm/page.h    |  1 +
 arch/riscv/include/asm/page.h      |  1 -
 arch/s390/include/asm/page.h       |  1 -
 arch/sparc/include/asm/page_64.h   |  1 +
 arch/um/include/asm/page.h         |  1 -
 arch/x86/include/asm/page.h        |  6 --
 arch/x86/include/asm/page_32.h     |  6 ++
 arch/x86/include/asm/page_64.h     | 76 ++++++++++++++++++-----
 arch/x86/lib/clear_page_64.S       | 39 +++---------
 arch/xtensa/include/asm/page.h     |  1 -
 include/linux/highmem.h            | 97 +++++++++++++++++++++++++++++-
 include/linux/mm.h                 | 56 +++++++++++++++++
 mm/memory.c                        | 86 +++++++++++++++++++-------
 27 files changed, 298 insertions(+), 95 deletions(-)

-- 
2.31.1


