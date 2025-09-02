Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 905ACCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E71E88E0012; Tue,  2 Sep 2025 04:14:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23748E0011; Tue,  2 Sep 2025 04:14:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9D2D8E0012; Tue,  2 Sep 2025 04:14:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A94428E0011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:14:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 811A6140B5C
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:09:02 +0000 (UTC)
X-FDA: 83843584524.27.434AA1F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3FEC8140008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:08:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XlLQSRdh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=igyBpzE6;
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756800539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNh3Wby6z7ngc/ypX4XiPlFJRohHuZODIe5ylj1io+c=;
	b=06ONk+tvzjlLI38WO7B/RNInCvAhmkB8qeApbf43kV5KayJ9ncL8kB+ydasLGL0w5cuTAB
	OzHEqZ6KkqK8WCf/QZA6oaCC0c27fs9qka5yYQ8WkqbXL6BEehr8vdVpNeA/ZrKGJZFoAq
	MH72rKtxRfH3bP5perYRHRe2ayDFVYA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756800539; a=rsa-sha256;
	cv=pass;
	b=cC9v7+cqT5ISIOMq8tpG4LiyH9dybuWKZEJnn6n0G7Z3IfdjieRjc0djzYQbpQyuSMo91O
	Q7HBHdGuREpBmEFk4zeZ2fJN9KILu1yfzHU9/ecqOJJkjoMoeUCq7ZPg/tl52Ukg+WhBsr
	XSt13mJbFxatAABUonm1bH8mhB/6n34=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XlLQSRdh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=igyBpzE6;
	spf=pass (imf26.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5826fnEh007450;
	Tue, 2 Sep 2025 08:08:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=eNh3Wby6z7ngc/ypX4XiPlFJRohHuZODIe5ylj1io+c=; b=
	XlLQSRdhkXjiGkwaArxidHYQBiqryejK1Zrm5ZT3uYL+uuITmVcRSN8/sMsDdotx
	cXdD3XjSZT3Fb8TzUCnCAnrk/J1zu3mtRIpn7AYdLqHnoqPYDqtGa9uQ+oGbeUnj
	hOJ/QuyNWIP+ymDUfXCxc643LpjY2KLTJfTDSQQadHlDnQPmJ2P/aIudlXBRFN0b
	yRad9QF1vdpltxLIXB0+n3f89UusEXhOlh03uQXqEdRHUDB7tfELhHXMh1tfjdZL
	QgcDjCA/yrXAogfwOXWZxG9/af1dJKaA88HhbOwIh1fXJQ8oJv+9PHwkt4eqcP9B
	ltxQJ3i+6AtZxCftu7Yrhw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48usm9khdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5826Kl9Z024898;
	Tue, 2 Sep 2025 08:08:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr8j6x2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Sep 2025 08:08:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=elmgMh2oPrTEX1TxHa87Uc0+2gyVwnRK3OteCYrqQVrqbDAAuhe/XDwGC+LXFeYSN3zzAJ31rRLWC4M82NbYOSibT/xS8AsplpEQZLpxaJ0bgXzI4NMpBWarFJMwAeybt1lIAWp7/PAZRVPFKQXmP5K1JR62GtW2wdU/u2oHreiRS+eWUywHwFAtMfBkUtI+IfevNb7xbQTMU7X2FvIWYCOfJRl8wpjnR1iL8FnVhNwgibr720/LYQbyhOpR1DV+Gd1N1Rt1oOTI3YyRbSkpixnuJ8h6bmAQO075p1qqGy9TUd88twtm43SJZnTJvzvojamBDCxZEGpM42iujx+JQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eNh3Wby6z7ngc/ypX4XiPlFJRohHuZODIe5ylj1io+c=;
 b=Ma8VKJkODlalM6ZzU0W+UWpIlNb8GUid6+SpIVZxnq4014anV+/ab4BnhYryZvrP9u5L98Q8jI2FDAjz50hOgN/0EgCn+UBI4OjjVZfSZw76IiW6a2Sbt9nGrcF+DFf4jBgLQ51Dkcn1R0wUCCcRwFUSgmkg9IF2yTPA7fOffqESdk48nmJUhUdcYbAjn5OYVZBmi6r+miyLlAEX6/cIlzIwsalmGEgCMZ7ooi/diLzHcW/pp2bnW9AqN7JOuCWixczmGSV7MPhQKOd+UptMjikyTVPGg5NfPSpx3HHnuhgz27GEjIOQfqcn5O9GMbz+oAJK1hTPOblNDHUvprXHWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eNh3Wby6z7ngc/ypX4XiPlFJRohHuZODIe5ylj1io+c=;
 b=igyBpzE61UIOt6g1hR4UY0aSJYxUuVmbgodkFMV+354usjtIzhJgKFTN7M35ovOnZcwVr52wAKjkSXsG+IFUXR1C2+cwUEJMzFLQVb4E5qjqQkrnKLrrIPIpsmHdjmW17+1K/sz7sB+gknl5lISFe1BcUetAH87k2SnXyOpMls4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BLAPR10MB5139.namprd10.prod.outlook.com (2603:10b6:208:307::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.16; Tue, 2 Sep
 2025 08:08:40 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9052.013; Tue, 2 Sep 2025
 08:08:40 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        acme@kernel.org, namhyung@kernel.org, tglx@linutronix.de,
        willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 09/15] perf bench mem: Add mmap() workloads
Date: Tue,  2 Sep 2025 01:08:10 -0700
Message-Id: <20250902080816.3715913-10-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
References: <20250902080816.3715913-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:303:b6::28) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BLAPR10MB5139:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a413c95-83a1-4c24-34d2-08dde9f7ed30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lmZDfnsrIAcoMHMlarGjs3bM1w8hWTXJGQIWP9s1BScbsx4VDoyGHt82aoP2?=
 =?us-ascii?Q?hdTr6vp1HQYuGezTgZ2da2BNVc7F19Cg/U/LPty4WcCz0l6xPRyeT8/xd2vx?=
 =?us-ascii?Q?Z4bHPAYJ3SB/zT8wu4XJ0LRgNPMDzw0+8nXA+pmUZFxNZ/rX8a4qK4+PcUiY?=
 =?us-ascii?Q?nucMh8rwJuzHdGhfuv6ZolHay1nocogi5eJ4Wa8LmvuFA9fVflbshn0wUFYC?=
 =?us-ascii?Q?G2OVH46eo42RWlMPX0OL8pVBZgz5QnMVGKs+ktNTdaVghvoCyq2tuOA4nGq0?=
 =?us-ascii?Q?ZbAfD9xFKihCDjGC3C6pIykfYUOz5Jj9KEVzzFcqpZMQlUIiWme/6gLNttnc?=
 =?us-ascii?Q?ptyHaQjP0vZ1I01yC7A6it32cIvur1NzLP9h2wuQblCnw45TesuUwcaacQBf?=
 =?us-ascii?Q?e1sy+l+EmD/iCKMesRZLBhv670EeHAn0LTnDFAtGz+XEjm3wJlz0HTIOvSu0?=
 =?us-ascii?Q?E6mTlyGxW/t8sMW0rJOQ08Rmz89/mGLa4dG4gxNzl1jyBVI5qGv11TZYevkH?=
 =?us-ascii?Q?S9Y1BGUbcAiUf7fm0ghC9DoA4665Z0P52McT3EXmKY9eYWBfg3l7teWTf8qh?=
 =?us-ascii?Q?eqYGu5+aGHyRyAoRROLtNCI3zINvwTAOl0ji+oacq/23o+Wff/X6IYp1YCUI?=
 =?us-ascii?Q?wFrn0RZZhY3xpryzPq0Yfv6RDX+OHDwiRk/y5u4CMpIdvpvF2ChWibivaUy7?=
 =?us-ascii?Q?cxAvkQL2WjMxvXNlTKCrR+tOVkXnh70k+Hsq5jtoIv7opmYLjH9XShwBmbp+?=
 =?us-ascii?Q?BqbfTbCrOArG5tp3nUGwNmlq2YUT39rHQ64DSJdXqboB9Z9/TjFJQDkAUUaT?=
 =?us-ascii?Q?cIRNWthedn0iHy9QMpowH/tWVDLW/Xh9zNt1RF1fDC2z9TqxcEH6KuUfBtob?=
 =?us-ascii?Q?1RGYVKyjwNiwbERVec7Svs7FTcnnIKMF/SbewdyqBfEhj5Bd+OqZPCcGoG8X?=
 =?us-ascii?Q?2u3JAo27mH5CBVqdF57KxQIXPqY8a+b+2n/wayE3Pmu9xbsRf9JeUnpm5PVh?=
 =?us-ascii?Q?tcgixGbxiXvZPXhT5M81/DtLm9wOTgjIuDpfhLHEp7JPjq4IXpzcYwXgNG5+?=
 =?us-ascii?Q?XgIly1EQiyM8i18UxKpR8dGM/NXU9UPhNEJP5aFlNncS8HrIdn/b2O64uihK?=
 =?us-ascii?Q?a7MSD4NKdWY9s6+hoIcga2cd3O3Zf9PmMm9a8fbLlQN8q6BSd+PToW6wg6f4?=
 =?us-ascii?Q?xOqBM7mWkPDX94KVLhaVxkNk0cy360DNtHUBxeilgQ42QpXTLpd4/ahs4riO?=
 =?us-ascii?Q?IsowT3M5C/7qhh6KWNlRnVqMBCD6FAZf3z9HLbWLZ5IIARsQGsVgO9xjXBVS?=
 =?us-ascii?Q?+IAIZD1ryXoROHTTu9ydZcRekndyD5o7yPkOMZfbNpnoSpPRl3VNz3C+EHqw?=
 =?us-ascii?Q?SZ/MMk32wGOTKCvP2iJHnq6uzg1wF02dYyVOGcPL+k/agEUrothx9UJVebQg?=
 =?us-ascii?Q?f1k5x8KZu4c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8+ljM0RIW/rLKhb8fA/B69AEIEM8LdHWAlEgaVFI/NnrXiVQv9y9cu5TB/Xa?=
 =?us-ascii?Q?jP16+kk9OPnzpdYPzv/vnuwVB/9lp50XtxEPg2HHpSV7QcjPlQRsjzPyn159?=
 =?us-ascii?Q?+x2AArJGD1S1qlVMpEQVSN9ohoXcOY8IpngutGo5xLctguDOTUS8FdDjkwic?=
 =?us-ascii?Q?PmfcMyKV6Z44Y+tl10FoOpIrjxqtn0Kbsv6HsCAqkQSlW4Vc6zqRxY00KICH?=
 =?us-ascii?Q?DtPb06a+AIxu0kND+qjJqyxGOnZso8jqHUFCBAlS+odOyjNfojr0d0rb13y4?=
 =?us-ascii?Q?G6l8n4Hgwb9FKRUKTs6B+IOv2Yg3qMBbAFz5ZP3rRsTTOl94nqeEmK4NPtqi?=
 =?us-ascii?Q?P6bnXJzeeAlD9h8N3x2qBbniuaeFMG1HPhvjbMfuc465Gs5hx0b5lE9QprM9?=
 =?us-ascii?Q?W5ZTbCnntMX4L5fnJ+6YUd42KScaQK9NT5NR95D89hxRzrc6ZIcHwwGs4JWo?=
 =?us-ascii?Q?O4HBRqPnuai0XStQJFBwRKThfzYMfMDaDoQu6P7HGt8BLSSBoGscJwNk9dL0?=
 =?us-ascii?Q?gmA8wUUXMTLGM7H2NY9ED2aiWe515XAwHn+9pJL6yc8fJv5zej6/PSzKZaCB?=
 =?us-ascii?Q?STzk9bUz7A8wYgW7yCSJe6Jzk3KkZ/c0Eu1+WYExhmUxeBPxLHbU4SapaEl+?=
 =?us-ascii?Q?vO3mkkgUX9AoIEBye8KSf7FXGHjmeYzioJKpVae4KCplxImQxpc/f9JpwNGG?=
 =?us-ascii?Q?6jkIVldCSJdNMfM3VF7JhBYwI6HSQykDyoObiloejvFnBc3MN4yS4Qqr3kFk?=
 =?us-ascii?Q?A4+dZF4N5QJ6xmiNtuVzJ1a1nMxyBG8xYYBj8t/Oq6Zkwbspzup6BzDsUBBu?=
 =?us-ascii?Q?FtVUdBXwgMXFadrWPf5dbUez25XTOpNbGF7WX+oh1dqYTuTAT1lRnO0zSypz?=
 =?us-ascii?Q?RW8TwbVW1a/vByl694OKCjRPLsC8qPv97dWG3Jm3lKXO6YkbwCdadW38JzTY?=
 =?us-ascii?Q?Em2xqJd4Y3jixutF0f7q5ONO69VTX5IOst9C4JDuWJwdaqS3MFpHyhot0k5T?=
 =?us-ascii?Q?bbAOTIp1kkKTFfWTYWjU31dOV6LJA5fOiW6P0tckIEbx/bnEKU97DUO57w2o?=
 =?us-ascii?Q?zdoTv0NgYZhlEH1a7ZXAqh4Do7lJAFizMgm161rmxU6Jf6IKEnLbHjv3fOQg?=
 =?us-ascii?Q?UaQ6Nd66D+mK81LirKgg6f9DJulrmWLsu9e1VDQ8s83z8pvRPrXAYiJw3cTM?=
 =?us-ascii?Q?vJxkc6rYS8sFAM4v0jfUIdNy0TG0IUFX2vmJmek+DdB+mLN45bulhtA5u+N1?=
 =?us-ascii?Q?FjrcTUPi9ajtVsqRlCSZpGao3R+IBKE2NePxXpSDhdROXheEGQmZwV1vhBmq?=
 =?us-ascii?Q?70AlMQmo5i4o+IDpGCAWJ18ETaVGttbg4t43RZ75dnRdBLSb9hnJIrjR9xGW?=
 =?us-ascii?Q?Ip/67hoaUeQxgp43PJT88CemtZ0NLLZD/bZZhNG9CgJJGYPrH6YXSNCAUQ7a?=
 =?us-ascii?Q?I8PMv898ov1sP3FdWXXRNyROLWGmN9h/EKez/thmdgkIGghvdJwE3H+i/vh2?=
 =?us-ascii?Q?kxUilOAoInd4CghR5W4r5Zf9IZnyEcMhTwBHPz2dAO1CPnHBvFJI3LdhwuGp?=
 =?us-ascii?Q?FSMzUYHPJOcuQAouaGnmyE5hwBxwwO0kQMO3AQDm3Vs8BTdpO8WE56ikFtqY?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Fy+1ACSKqBHQnZEFMFYmfyWLR3aPkKfKDunQ2W4FtxY6sG+nvdXeSZDbzznSaiz2aLiqDMxJuhi+Mc3CmoL6JF4BWpuMP8VV0xXavNuD5tHnM3c0usBzoeZHYtxk8z55VP60X3g7fDdCipOpcmQQ/Y175SDVjvw7HptPQUW6cZywqE3TrstV0WMXFAaw3LBaXa5zvjuc1uOP2ZVZuGY1k5Toe1+i8ltAPMk8HNOEcnAJWZhkjGTdRGz4MTOvomdexvLLzeqB8BwqgSqOBdTYUw19681GAsOn1eRQVg2SPTBgiCVBIY4F2XLfr7FxDrODaBrIKycdX5acitf+ycGCBs+JDPbyVDRXawv8zMVSbxc3eE28rqyhwaxi3DFWbqxIN7Rd131Knyi4ECbYxywpS93WkVwyDx1IriKZ3QzYZMpK2PA/ny2POYKat0IV0sBPqZayvLLMDFdhIuJGKqEkdcCIJxSGVxv467AygCCSWQaDOQZIIx4x3vYj/Xquezgmp5acC/I2LpuqHHwsAVn6Y10nRwhtylZsWeR+6hwl6CvVHUp6ptepDmdVikUTR81S3QmCG3QGW/1v1Is6HufqGzoSZkOlQ8AMCXcHBEU/GXQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a413c95-83a1-4c24-34d2-08dde9f7ed30
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 08:08:40.3101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QxNSBdtzIduLpGZAlhqAicJHwABq9zL/IXML4graH+UnrYGFxtVV2VfAAUqMfCflaQc7LVNobgKHkMub4XTcW3X1xpEnDRCsO4k8o+9kss=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5139
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-02_02,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509020081
X-Proofpoint-GUID: gdW2f3Zg0bmZmj8euE-u3jg4UnQVgDzF
X-Authority-Analysis: v=2.4 cv=I7xlRMgg c=1 sm=1 tr=0 ts=68b6a60c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=2MWhjARPlSRgpm0SOp8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMSBTYWx0ZWRfX+9iqKvAFfoV3
 Ut33v71JPRXrmaOY1nfm/RICqHiA0GCblZ6FZwf8eY3PwOSbeatEdgaBgbSWEOfCtCHDKaMuF7f
 gR8cDxixijlvAIwDI0AU29S+u4cM6j+boGrNxipYqxuAtt1J8FjsInoP0NwydbF/qrwTuZRhMVP
 y6jKPwNfE3WjydMOq54pQvbAkgG1CbpCLfNyQ8Uiz16unaZTWO9YujBYY7NLbGY+3QLIOoz9b4c
 jUl1ZJlIC1c4xpvWrgliTBqVo2Cdz5WgYCSbanEt910cZsG9iEg3gapTB5M95/53kW5yZMC0lWI
 QNkBP+iwm+zfTLnJkkXJfyzQPXa2FBb25ziaaCebq0ULgeNm2ZTEElr8i8d4k2LrFKg0/wBSFW/
 jTiRl8jA
X-Proofpoint-ORIG-GUID: gdW2f3Zg0bmZmj8euE-u3jg4UnQVgDzF
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FEC8140008
X-Stat-Signature: yrka1b4bfentn7xqx8m9ihw177zbikow
X-HE-Tag: 1756800539-218942
X-HE-Meta: U2FsdGVkX19Lxctebwp+5R9cuwCq2R0ppYi1ZL2rvyL+JG+eAFzkz5UIwsJ3a4WhgVPV2wajdbkwwdCeEY/oKiODTyLyPcJrrpU9Q/fbPdiriIj8TDzqIlLyxH/uQxUNMKB2pqc1lZkBCQcd1HT9UO59P3D4cMnbUWRtjCSgqsxqBrEkCRXUhMEE1eI8rwVribzjqtAKNj+M34DRMdad3m7aUwh45fv3m82uhXZpaKVKf9EFlnNPvHHAnej2/yt0MCyFqZEFkuXJCa4uz/422d4gm34UZQNz/WdWq6VltntNKKoYylWeA7ZyhUBjf8vIzxB2ScdFPvlcCpl+jjmRkhNknHrxDDY6lCJl2MO9oxGLyTs6x6H7Ad9CQC6HLCxHrpW6j7Fch13TmxJMPMt8rYoG4+KnNh3FUfFJxFWMQ+h3xvstGuyhEM7N04AlMDWb3B7e+sajZFgQ6yifGJZCP4M+87PW9jBAuub4HnJ4Kyrv7ilwJPuxir3ic4n6r7/azL2E/6CkiDiC1MiOuLVjP8ws5f5yFLRBEc/bNUe6QXWzMmDkHj1FD0Ij5VS4xuFnhX1m/gNpThraI/gwVTaNYt1aRNPD8jcuTJes+FLjg1GRCFytyQfNKPWFSxSN7mQK/F9y8qhER5Ca3ABQ/dz4f9NBfok33vX+ZfelUt3C+RhxxWmp9Yog430agAEUKUjt5S7oLY6I4MeVVwRmZuugvwAHXnFsvOFZYe/e9vrgo6I3b7SfzrJbnGrQ+3Zlypd/E+IjHplXuXNyDqgvvnOZmIJ7+sKOk/TrsojLYFZW/04xJSRT0/bIfmNtq2jpVbRGUNNtn4PnpY8ZkVekPJYlBrvVAJbkzOuH81u/Vbq2hhmOURI7yV0KrH2Ij/Z2x2IOetCSRZU6lefn5NST9Ya8WJ2xp0pcvNGImiYKATjpBXcJewwO0J5otEZns2JkuM9CQuCmGYy9W2Hla+IGY8O
 HCUbW28Z
 UOs9XpBG05zrwSPZwUjUucjgComj5dde0KLIUkzMKCx33RyQfcbmDSFkEWJgcX8xBziB5rCB1VXHk5s9/NBZiHFI/OggVBAP/QnrldPsNsC6ENoXcPltqna+ni5Ipt5Bg9pSmLIZAXVTduz2DkRn39+PLS4qHe63zjnJfgHKdSNb4MZ+vDSgS5+G3+l3kuT4OIQGSUsjxztP8N7ARh2Vtnu76EcrPdC3touzF0KMxuIzEVbqhC7v68NwcK+zWEqq7wsgizJwuZdXFpPXKVVS59ElaBgVBIPWW82/nshS5Flm4wJ6UArTR4PmVezYWysBHXlOCIiOcM6zZYKZRT05Or5nOk0vWDmNoTCOFzPEuFIMxsPhIpzmdSfrDquIQIf+KRUE+Qg9DmARTEseUQsfzyxxX4GIw7xfS4y1z1GRFK/aOFXdzXAjljosZhv9XnPnlVlIbAxiJWPBjlb37MDNLjazapAMFU786u17AkeutBTxSSqAYrDZLW9yuxoCfMdv4cMsXzo1C54IpC0Eo68guhhvRtJo+bu6lq20vDF9uYi6Evxex/MKfeWBKkKjs2cJdfRocbLUC7Dj8LMkUkQzi2vTKtvcIIkwUT0+gsodr6Vh6YoLfQ2cGRmes4v0z13MVMLzNOgzFwUggPH085dEua1AWZttzLpGt9fgCXvlv4ZoK6u5y63AXFdhQe3q0bp+g/1z1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add two mmap() workloads: one that eagerly populates a region and
another that demand faults it in.

The intent is to probe the memory subsytem performance incurred
by mmap().

  $ perf bench mem mmap -s 4gb -p 4kb -l 10 -f populate
  # Running 'mem/mmap' benchmark:
  # function 'populate' (Eagerly populated map())
  # Copying 4gb bytes ...

       1.811691 GB/sec

  $ perf bench mem mmap -s 4gb -p 2mb -l 10 -f populate
  # Running 'mem/mmap' benchmark:
  # function 'populate' (Eagerly populated mmap())
  # Copying 4gb bytes ...

      12.272017 GB/sec

  $ perf bench mem mmap -s 4gb -p 1gb -l 10 -f populate
  # Running 'mem/mmap' benchmark:
  # function 'populate' (Eagerly populated mmap())
  # Copying 4gb bytes ...

      17.085927 GB/sec

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 tools/perf/Documentation/perf-bench.txt | 34 +++++++++
 tools/perf/bench/bench.h                |  1 +
 tools/perf/bench/mem-functions.c        | 96 +++++++++++++++++++++++++
 tools/perf/builtin-bench.c              |  1 +
 4 files changed, 132 insertions(+)

diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index 3d1455d880c3..1160224cb718 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -240,6 +240,40 @@ Repeat memset invocation this number of times.
 --cycles::
 Use perf's cpu-cycles event instead of gettimeofday syscall.
 
+*mmap*::
+Suite for evaluating memory subsystem performance for mmap()'d memory.
+
+Options of *mmap*
+^^^^^^^^^^^^^^^^^
+-s::
+--size::
+Specify size of memory to set (default: 1MB).
+Available units are B, KB, MB, GB and TB (case insensitive).
+
+-p::
+--page::
+Specify page-size for mapping memory buffers (default: 4KB).
+Available values are 4KB, 2MB, 1GB (case insensitive).
+
+-r::
+--randomize::
+Specify seed to randomize page access offset (default: 0, or not randomized).
+
+-f::
+--function::
+Specify function to set (default: all).
+Available functions are 'demand' and 'populate', with the first
+demand faulting pages in the region and the second using an eager
+mapping.
+
+-l::
+--nr_loops::
+Repeat mmap() invocation this number of times.
+
+-c::
+--cycles::
+Use perf's cpu-cycles event instead of gettimeofday syscall.
+
 SUITES FOR 'numa'
 ~~~~~~~~~~~~~~~~~
 *mem*::
diff --git a/tools/perf/bench/bench.h b/tools/perf/bench/bench.h
index 9f736423af53..8519eb5a42fa 100644
--- a/tools/perf/bench/bench.h
+++ b/tools/perf/bench/bench.h
@@ -28,6 +28,7 @@ int bench_syscall_fork(int argc, const char **argv);
 int bench_syscall_execve(int argc, const char **argv);
 int bench_mem_memcpy(int argc, const char **argv);
 int bench_mem_memset(int argc, const char **argv);
+int bench_mem_mmap(int argc, const char **argv);
 int bench_mem_find_bit(int argc, const char **argv);
 int bench_futex_hash(int argc, const char **argv);
 int bench_futex_wake(int argc, const char **argv);
diff --git a/tools/perf/bench/mem-functions.c b/tools/perf/bench/mem-functions.c
index 2a23bed8c2d3..2908a3a796c9 100644
--- a/tools/perf/bench/mem-functions.c
+++ b/tools/perf/bench/mem-functions.c
@@ -40,6 +40,7 @@ static const char	*chunk_size_str	= "0";
 static unsigned int	nr_loops	= 1;
 static bool		use_cycles;
 static int		cycles_fd;
+static unsigned int	seed;
 
 static const struct option bench_common_options[] = {
 	OPT_STRING('s', "size", &size_str, "1MB",
@@ -81,6 +82,7 @@ struct bench_params {
 	size_t		chunk_size;
 	unsigned int	nr_loops;
 	unsigned int	page_shift;
+	unsigned int	seed;
 };
 
 struct bench_mem_info {
@@ -98,6 +100,7 @@ typedef void (*mem_fini_t)(struct bench_mem_info *, struct bench_params *,
 			   void **, void **);
 typedef void *(*memcpy_t)(void *, const void *, size_t);
 typedef void *(*memset_t)(void *, int, size_t);
+typedef void (*mmap_op_t)(void *, size_t, unsigned int, bool);
 
 struct function {
 	const char *name;
@@ -108,6 +111,7 @@ struct function {
 		union {
 			memcpy_t memcpy;
 			memset_t memset;
+			mmap_op_t mmap_op;
 		};
 	} fn;
 };
@@ -160,6 +164,14 @@ static union bench_clock clock_diff(union bench_clock *s, union bench_clock *e)
 	return t;
 }
 
+static void clock_accum(union bench_clock *a, union bench_clock *b)
+{
+	if (use_cycles)
+		a->cycles += b->cycles;
+	else
+		timeradd(&a->tv, &b->tv, &a->tv);
+}
+
 static double timeval2double(struct timeval *ts)
 {
 	return (double)ts->tv_sec + (double)ts->tv_usec / (double)USEC_PER_SEC;
@@ -271,6 +283,8 @@ static int bench_mem_common(int argc, const char **argv, struct bench_mem_info *
 	}
 	p.page_shift = ilog2(page_size);
 
+	p.seed = seed;
+
 	if (!strncmp(function_str, "all", 3)) {
 		for (i = 0; info->functions[i].name; i++)
 			__bench_mem_function(info, &p, i);
@@ -465,3 +479,85 @@ int bench_mem_memset(int argc, const char **argv)
 
 	return bench_mem_common(argc, argv, &info);
 }
+
+static void mmap_page_touch(void *dst, size_t size, unsigned int page_shift, bool random)
+{
+	unsigned long npages = size / (1 << page_shift);
+	unsigned long offset = 0, r = 0;
+
+	for (unsigned long i = 0; i < npages; i++) {
+		if (random)
+			r = rand() % (1 << page_shift);
+
+		*((char *)dst + offset + r) = *(char *)(dst + offset + r) + i;
+		offset += 1 << page_shift;
+	}
+}
+
+static int do_mmap(const struct function *r, struct bench_params *p,
+		  void *src __maybe_unused, void *dst __maybe_unused,
+		  union bench_clock *accum)
+{
+	union bench_clock start, end, diff;
+	mmap_op_t fn = r->fn.mmap_op;
+	bool populate = strcmp(r->name, "populate") == 0;
+
+	if (p->seed)
+		srand(p->seed);
+
+	for (unsigned int i = 0; i < p->nr_loops; i++) {
+		clock_get(&start);
+		dst = bench_mmap(p->size, populate, p->page_shift);
+		if (!dst)
+			goto out;
+
+		fn(dst, p->size, p->page_shift, p->seed);
+		clock_get(&end);
+		diff = clock_diff(&start, &end);
+		clock_accum(accum, &diff);
+
+		bench_munmap(dst, p->size);
+	}
+
+	return 0;
+out:
+	printf("# Memory allocation failed - maybe size (%s) %s?\n", size_str,
+			p->page_shift != PAGE_SHIFT_4KB ? "has insufficient hugepages" : "is too large");
+	return -1;
+}
+
+static const char * const bench_mem_mmap_usage[] = {
+	"perf bench mem mmap <options>",
+	NULL
+};
+
+static const struct function mmap_functions[] = {
+	{ .name		= "demand",
+	  .desc		= "Demand loaded mmap()",
+	  .fn.mmap_op	= mmap_page_touch },
+
+	{ .name		= "populate",
+	  .desc		= "Eagerly populated mmap()",
+	  .fn.mmap_op	= mmap_page_touch },
+
+	{ .name = NULL, }
+};
+
+int bench_mem_mmap(int argc, const char **argv)
+{
+	static const struct option bench_mmap_options[] = {
+		OPT_UINTEGER('r', "randomize", &seed,
+			    "Seed to randomize page access offset."),
+		OPT_PARENT(bench_common_options),
+		OPT_END()
+	};
+
+	struct bench_mem_info info = {
+		.functions		= mmap_functions,
+		.do_op			= do_mmap,
+		.usage			= bench_mem_mmap_usage,
+		.options		= bench_mmap_options,
+	};
+
+	return bench_mem_common(argc, argv, &info);
+}
diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index 2c1a9f3d847a..02dea1b88228 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -65,6 +65,7 @@ static struct bench mem_benchmarks[] = {
 	{ "memcpy",	"Benchmark for memcpy() functions",		bench_mem_memcpy	},
 	{ "memset",	"Benchmark for memset() functions",		bench_mem_memset	},
 	{ "find_bit",	"Benchmark for find_bit() functions",		bench_mem_find_bit	},
+	{ "mmap",	"Benchmark for mmap() mappings",		bench_mem_mmap		},
 	{ "all",	"Run all memory access benchmarks",		NULL			},
 	{ NULL,		NULL,						NULL			}
 };
-- 
2.31.1


