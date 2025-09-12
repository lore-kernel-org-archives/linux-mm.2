Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12352CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 13:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 570CE8E0014; Fri, 12 Sep 2025 09:36:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FFD8E0002; Fri, 12 Sep 2025 09:36:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C0E78E0014; Fri, 12 Sep 2025 09:36:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 237D18E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:36:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C38AA140812
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:36:21 +0000 (UTC)
X-FDA: 83880697362.05.A0ABD3F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62AE5100009
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:36:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BxKoJoPn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="RnK/dUrk";
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757684178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NOmQwES/W+zNoL3DgBYLgYkLa7X4kLDOuTUtuO8TS5k=;
	b=Y7NdI1Sdft2JjCmLICivyKvgcXZBmB3kZWfb2yI0ECNM0x3VbENy6r5RDhuz4zjFAwY9gL
	Gm5gm5+Tcoeo7XfWKMF7g1ZCUVkO61Vx5CnEl+ijx+5lC333YRBLAE4sa5ZecIJgTLOLTj
	bXOJDN8XxF/L0chnZg9RA4iKiDC9oos=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757684178; a=rsa-sha256;
	cv=pass;
	b=J+3eZCY6AZgbnaCp/CcGM71K3FcEOwZKmjYslzqBncpzTfGFYxuEczOiby1HCsp/ppcoSD
	BuWSQMTbgu3ALtE93P+iSfymA80K6ubXorFs9dM7agoDuXtHanwQieTqr6hqVkN6ehJpCL
	DYbP2VTmwaRkinrnPAGLglplIDhHH8k=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BxKoJoPn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="RnK/dUrk";
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58C1tq9P017268;
	Fri, 12 Sep 2025 13:35:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=NOmQwES/W+zNoL3DgB
	YLgYkLa7X4kLDOuTUtuO8TS5k=; b=BxKoJoPnDiv3U1yFO6JdSLAfZCfoP4ot7L
	7wd+O1Lw42YeuRZnu0uxpJzQDW1moaopIRhvKSzyOim2xTnGW4JYIy0qNZr7m7OG
	o5U3biEowoktocTgzV9KTg71xXR/ohuuD4N3Sz2RDeeUScp4ByJ3HLQO/xaXbdrc
	SPPPTOpJQELFa02+bHqtlKLe6WO/HvawsKQOhbN2ofRmmUadIOKcsEH+oP/0Yyyv
	Zih0ibXjlt35Bu4UMicKlMtqrnfUaSgsKLlKWKTJyqsotOzsD0GZmuSrau6sTH12
	Gjsz83SQdayEOi8EUgytpZoJblcR1plB9FTJAR5JiqnVCWeOKmew==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226t08j0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 13:35:51 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58CCrYXH026002;
	Fri, 12 Sep 2025 13:35:51 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013007.outbound.protection.outlook.com [40.93.196.7])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bddwwrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Sep 2025 13:35:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ryNEu/qU06m0sQdoxjzWHPhQJ59k/e8R/Bb+2vuchslQTSMgRfJWiIgg8hDk0/Hh/Zybui85Yfrze5Njw8uxvc2rSQ7uLVvh4ss+2TrIdi965dj/GNveHceBKrksUNO8cSRPb+vPRZmnivffGP8FuT/wA4b+x3QALzcggalLHyjXt9P2kkEPqAYVXfOpuxnen4VYShnQiYCQjDL01rBHJ9XO1GyTf9Oo3+JNBp9UnEO1QgodhMYZZ2Szn2y+bGo+4T8CbD+hBVwnBVVP5Uxx+DlwrRwFcT2Fico3zYP0pfQCQ/HwDxhF+dBQmtCZVGPm2EGTwW8wRpNg15uhOA7L9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NOmQwES/W+zNoL3DgBYLgYkLa7X4kLDOuTUtuO8TS5k=;
 b=r+rIHJhwfLY3VmklY7l1+uP3In40SHolxWdyhuwXqEWoJMTFSk8kk0Rd9mfFISHmHFgN7uSRApvZNlWGW8KoGt7ar8V/HZE3jwyyQ7kU+F3IdTiZJLExrZBwHBrpipMGphXvpGaZsA7ekafV57qXO68Dql8+b+HxCwaYvDyyDVgSlhYRmbyqbgGXeoE33pTLHq9/c7MkPpB5RACwjEHkCE+ZP0kxj+E8McPLtmE0+CcKEtbRFICDj/10zH9DPpRInbZ/cvp1vDIl1di2a+bYtoDAfe/Q2aE5+BdLjjzkB9inUDosNiYTa4H/lav038upjg71ja27g6SLEvWw0znMFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NOmQwES/W+zNoL3DgBYLgYkLa7X4kLDOuTUtuO8TS5k=;
 b=RnK/dUrk1dJETTmPdgRrOWCWzrACxTP+dy0aNOSIOLCihc0cj4I3M2x4eAehTyraQ+p0nRYwbPKFK/TS5LlQ50VbTWPowIBCJedmaA/G/DHFpDiMvv8UGfVbo67601f0vBvfLfED5euGxYKybDHmHWiQ5orU0JBfb1Iyw/u6it4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB5809.namprd10.prod.outlook.com (2603:10b6:303:185::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 13:35:47 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 13:35:47 +0000
Date: Fri, 12 Sep 2025 14:35:44 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v11 06/15] khugepaged: introduce collapse_max_ptes_none
 helper function
Message-ID: <4e1fef74-f369-439e-83ff-c50f991c834e@lucifer.local>
References: <20250912032810.197475-1-npache@redhat.com>
 <20250912032810.197475-7-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250912032810.197475-7-npache@redhat.com>
X-ClientProxiedBy: LO4P123CA0663.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:316::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB5809:EE_
X-MS-Office365-Filtering-Correlation-Id: 19b056d2-86b9-46eb-8f3c-08ddf20147eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Iz0byvODK3J+XWEcnpZ9eHudDHu6HSPyZrx4pdyyoHjfHO4q4HkKx5CAS0PB?=
 =?us-ascii?Q?iQFTk2b7kK8Toaik1k950qmDbGjX75g3AZsITzWeXOTXO5xpNFPN1mIPKW5n?=
 =?us-ascii?Q?OyyaTv9qSyxNlIyB28SV23LzjIpCtBj1uBcpDMOmD/XBDqaQ7jV0cqOAFA5b?=
 =?us-ascii?Q?fwVVCv9aj6ppdRcSQAQpMXyhQyfTTP5u50H8I71q2UXeH6d1QkIbHiCjJYiF?=
 =?us-ascii?Q?c0uizIpkCMfqxiwgHQF74PpHMG8GeWgACRjZc7WxDjAu8i+m2o7a8y707BuO?=
 =?us-ascii?Q?qg2yMmbEtn9QiXRKkHE8HjPrwqgkhKeZBDlK6XH+yo1b8ZTJL1OWkkS5tAtw?=
 =?us-ascii?Q?kiU4rdRJvhvpCuWi/QKwd68Rm5oLzlz9wQN55+tdi8RTdCHSM8HEYrpDQtpJ?=
 =?us-ascii?Q?ypt87SJv3kPGlLBMXJcK/+ZgrDvHkTyPF6kTQgj3DqT4lLrnv2e1YY1MuRYj?=
 =?us-ascii?Q?1zTg5eyR/T8hjbu06z66DNGDX2JzVzqyYp9WbpbBcLeid9V0/T59+w/+9Jdt?=
 =?us-ascii?Q?wctmivn+wBV6+PwUQQZkB8HdcIxnzhvX5B3uYIPXX12A+EI1xcrn+y/3AlWn?=
 =?us-ascii?Q?pgoj9llgTwPUHp+PLhfIy710J4xo+CMv0xbOKJy4WpE7TACOPm7k2LuKGszU?=
 =?us-ascii?Q?6E/icnqbMd6iGEggnAZILGZ//2lrzFu9OsBdSu2y4tma54YV0EYvriED5FrI?=
 =?us-ascii?Q?3lqypxb1mkeuUFz2Fzu+gS7IQrtL2d9YZxEBJwX0Sn7pLpzuQNymFTbwC5sm?=
 =?us-ascii?Q?vRtBanc+TY+Zq/ttBgnTL6tgVI/prpsqMnEbzdPE9BFoJqB30qKUnsFXmHRc?=
 =?us-ascii?Q?HBQEKWi8dgPTG2wF8XfpKgIJ23WCXQrW7EntZ+SCfOlt6js+g7ZY6QQub7I9?=
 =?us-ascii?Q?C8uSmcup+BOFVRMBQgH++xpht+XXy9SS16WlE+14aqcNyBMZclqg0qk+nCnp?=
 =?us-ascii?Q?a1dcOK1shnpjjUnxdLKJS19/TRSjlS0ocLT3yV6ZKYs4GmvU93/HPo9u4q7H?=
 =?us-ascii?Q?u90BTfnu42i7rRK7iZ1rLoDDVRwQ3EfKTavgrJFZWl6yxTNB6J8ED0pzSExC?=
 =?us-ascii?Q?S5Que66R+roO+PHFjod9eqgE8BI1jdIYdGYfT4CxdgdTzqjZBX4oemZO9X/s?=
 =?us-ascii?Q?13EGPjCcoWVE209Bg819oKKmrI9WdkEDUxzIO06+9UWSZnQMhYQ7JLmfdZD6?=
 =?us-ascii?Q?Fe+89CdIgXgbVRfBjueAcl0eX+dwu2RJ4SvCZKrGRreefdovGc8JeKDCflit?=
 =?us-ascii?Q?l9hSI58/m5wNkGTvfxpwoDooLGemYiB+XE9Oq7Zx1MxrxNztGmtG+wppeMmy?=
 =?us-ascii?Q?JWo97lqxLMoXCu277FD7FZ3egz65EIuvXxtgM4iQ+5gwoRPI8IZf9g8NshE5?=
 =?us-ascii?Q?2oe79MlHpboMmDksSu1FM3kqdlJPns8e1h4K4G86mDEJ8j1iqypTXoWpngmn?=
 =?us-ascii?Q?oFNX5MyNmMM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jt/gK6nCe/7nGMnkKtgIfx4xKVZCAmxbaFYSkL9QIJ4mVHmHTAycVKPuXeqV?=
 =?us-ascii?Q?JDcFyPEXgx8zlgLKrQjaTI3GFVx+zG/IBRBrLZ+DTH175439Vo7iDRjOiyuI?=
 =?us-ascii?Q?ZvoiVNTpfXpTx9lsshncbWADs3fRvvSMiE+7YsR8BGfuMb9KkHF3o1RcaFdK?=
 =?us-ascii?Q?ffcnnB5mOnRd6RQmnS69IPtE2yUZ9omm0Z670sOH8NZQhdC++S1cDguJ614Q?=
 =?us-ascii?Q?ck9a70DuZOWlp0UBr3D2NTHZJwepY7zC+NQ6QndeLaUXgTnUCA7IjGIs6dw2?=
 =?us-ascii?Q?N9LDSruEoHL3v9w65wRMkEnut2vUNWlEfA/52NS8dmuLTAYD38Ru7S7bdpWm?=
 =?us-ascii?Q?SOKKM17OXuyEXxoQ/LI8LCs6A3h/FQM5Wm6A20sH9AEIaAsNfJXRXkS+6feB?=
 =?us-ascii?Q?6Uqgbo7+laYDMKTYiDzlKbCX78DSv8VYh7iy6/W3BnOvN0PdsfvQNh0AMQZ1?=
 =?us-ascii?Q?lUQnKGDYKlGEJmhxq/KQ6Ey7nZF949zF4P0ZiAa0YiLkm0FUjTh5hokPCOkE?=
 =?us-ascii?Q?4EzkMbTKjLa9CLtE1zaIygOf/TtuySrs8hixbdV/B9Puddu8yQ7RiQiR+391?=
 =?us-ascii?Q?h4uD1DCgvWcTdr0CNv4K+LIxRH/AqHUfFLEJ6muzi20hJy06tgoNEOcmzm98?=
 =?us-ascii?Q?c+HIiVNU6jDt7lMRRiU2Dc8quDMqwIL/teb6qYKluyrARqLmwASncbmRZxDD?=
 =?us-ascii?Q?pQkKyA1yEUxVQLfUFHbBxqpDeVeB1CO/FdN0lGOyHeBPDFGSE1TzV6IVzNAk?=
 =?us-ascii?Q?ymy5gFgDty13nJT36yDKMjYNbPlSkJS6/akMgp8eZ9aIBEM3EwMOIbZpTy09?=
 =?us-ascii?Q?/U0xFTiKOktQ67UP+zDCprglZ/rAUCDs0rXXWL5gzUmc1nHIvctjj/2eRLA7?=
 =?us-ascii?Q?TW8hfWBOUkHN+5AX6Wq8aJj6o8yPnrpBu0M0u0+/sJ/SZcQZdSlDHr3DE3wd?=
 =?us-ascii?Q?hZGIpRziWbqCoCa3wnMlK/spbDXT6dMUlZQXsRSrIbBNitTAkYg9BL+O84lO?=
 =?us-ascii?Q?n+XX+NfcUn5ruVw0iroZke6V/a1GQsM3B3ieONl82ZkzaQ23hrgVHq7WPyZX?=
 =?us-ascii?Q?mKMckGfv0+KwOGCFOqxJw8DVcrfkkOgEARSkozAOcpnj6HIwWkbUWbfu0t1N?=
 =?us-ascii?Q?zGEdHt4P2UDrJBe8RUQD4tmQC30clPLvbMfxz0vnfjOHyPQGrJczVyg/hiVS?=
 =?us-ascii?Q?9ydTTKtZDvR6Nc3nyAhr2ZinRbZBgspX2812cRvajp531jh41UH0FjvICvhE?=
 =?us-ascii?Q?Hp9i2Uh2ER+WebHD3TGONmwTErhA+amTu17wjHuQzjzSULt64NQI0V9zMH/G?=
 =?us-ascii?Q?G2Ych713OPWHPKZYpE2zRGalGIQy2l8MuYzgHDLtU97ikx/t6fwdNjaJ/pJf?=
 =?us-ascii?Q?CG/i9I+VQGOB+8GjM/YkGRZ0UWcJAi+yfkV8gN9Bd5rm0dc2BBRtxlXhRM3b?=
 =?us-ascii?Q?7vAOKYuDdBFUyE/tviF6JXDIDRMLd/AI+i5c647wDDIL1dBQt+nb8mzW8HSm?=
 =?us-ascii?Q?xqcPTtdU7LpmebK0+0yf518+/tmViWC8TLY3TD8g7tWo5a6aNPTUlBdpqU5M?=
 =?us-ascii?Q?bp6nsLQFh55tfkHgdSby5i/VlaxF6hAVkHJF8uua6p2K6SRb5ScSJs/Q2y/8?=
 =?us-ascii?Q?tA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fehxTukluXyVmMOM1JubLNFNQvAliJP+Dvb7B/6DMcnPqwo+w6KDImcdXoKyrHbwMxWsLKtvNCNT4z2Leq0k9zMAp884PMB/p8A4KfjfNWfAQt5GdPoBBXx5NPa5of+lFadgjMORb2wCMq8iJPmgO+IF09tNED2kv+2+3YFCqGTcqchkEENYjUz2TqsS69pIp3nFJZzAXK+SCiZmcVxhA95XApn5hRjos1QIrc3vx6iL63Doi9JKTrDlYXby5nCAeBuxA1CItKMOdtrxNh0fsed7DGgPOg0fdWUAhDgiDlpDSvPcixdgBNrbmajAkB6ujtB58VIV3RYURvqrC0XuS7/xEkkGbBYHznlD5qoPfLTTCBImCK0y5h8Iw0UohTTcEN+awRFGvYlRhr/mia2cDZl8l1V/1iF8zfpq9zAyJAcJcV/MCqSysTpwfjssDhk6sOtHnqrNmOOfD1cE2qaNTlRf7n5ppAtttl0V/HMqEejKgnEKqXwdDOmIIhcHAW3vvD/KwTz+MUZbu/CGyIpLD6mTzAy8gnqlNQE2mOopLRsDpeQkPhFXtl1Z0U1vmNZe8OZpyyO+PzvsA1Y+jJZn+4dMEfShW7xgMEzqo1c5yBA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b056d2-86b9-46eb-8f3c-08ddf20147eb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2025 13:35:47.2729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XAwxSijKDn1+756NGtTwotOfzUTvrIN4VQdgQt4PfvBd3RSrhEJSOLVLfJMHZ4B1KFcYEmlVSYVB7liEkKwleC2JcI1gROnDZ5FdUuZSyHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5809
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_04,2025-09-11_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509120127
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68c421b8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=nbRkX1cIBELV1V8xH9AA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Proofpoint-ORIG-GUID: aAHQgVyNIiDoqa-K9d4Sa7NyOTAd4Tn-
X-Proofpoint-GUID: aAHQgVyNIiDoqa-K9d4Sa7NyOTAd4Tn-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfX1hLYjJFKE584
 hmo04ZFWEJo7OOS5QJHGjfJaqNftVDdJ1bxDVlYgzNg7Njphwd0ArHUOMTMWSBShc3OZ+iw5oBG
 XZIJnJW+HJaXupklP6WQMDveiDULYLOktVpz1Y6Zs+JIOJGP4xoKqas9l6swc0LjQ24NSDHoHWK
 8qt4RjHaBIObp59/jhCHJd0S/rZaF4P6CCDbA9pAvXBGTO+cVTQ5TJpPP4DkPP/qMn1VhtzBXwu
 jDDdHDdDNcWJLsqfNEd9dIPwuyLHc8vtaQp6HFZRF4rMSlT0TPeCqgPt/KcAW5Hj3PsFbjfoOxS
 j/dt4gLDyakZFIIl8Vviz53/yjaOD/ENMjNxuwZaGpDmmtxvprDIjJRIrAb/2Q+kWVsdEI1Uf0X
 wtyzvR+/RAb9SRwtYDndYEIoH+4ZlA==
X-Stat-Signature: br3qn1a5gr1qiin38pfujuprhanz8ob1
X-Rspam-User: 
X-Rspamd-Queue-Id: 62AE5100009
X-Rspamd-Server: rspam10
X-HE-Tag: 1757684178-289900
X-HE-Meta: U2FsdGVkX1+PN2TRzulFSMOBjECv1ySOoJZPAg4IczrDu94nEpPXUC3Q3lpF8Ivbmi2fzAEGkn2wF1l5nGj6sYyC+loyOhqfNFEOsbemlKn66EyNdZMPZWxZSmqHS3tbznL7AqWzPTk6f0qQDUqAM9tA4HBhSSbGK7/57BO8ewj7u7Xt6WrkTo58foKJ4TWxPxNUmw6s8Xz7xeg4x9PGx5CYuawUD/WO9blAnU30Bh0JZNGgfkxKFUIApc1aMSq5e6ZuLclF7p+c2K9GiW9EHyzyoguy7Vhq66cWuNuMVNDgGTLGjQhDZsXUgtthzIWu0LEtSvmmbjKuX+4JrNJp2mG/VY+vQQIY3wiRMfz652+8WvRPhirHIIrtcE5+bYxW4xmDv6dA217yfwWyG6apwKj+vUhSGTq5EuItrDVrM9J5rWBFrDfsrLvU4QGSmScPhDM5vGL7fyOcdmBf3rWHepSfevGs4QKGfv3bfhHachb439c9Q4XwPc9VTyDyjIDf76RM08Xk3OWC7y3Lpsg0w3JcyK7S/F0owqgoLITB4euKCRX23rLsnEsJBvDOuoD8ThM7hydZPEt9K+pycCu/FAGcndmcSrrmpSgCoSSW7HwWFP2IDsHVJLkXoc8zsaJtNYy9f9SoiNoNK9XodR6XPWxFPIln7Lz1GAjoOMLdUIRvqOLUokF/J20gl1EF+oINKz8hHj3GzNvjHZcIpONCnpZb9tr9tp57TftvEbDQ3mEknOxIgP0XpPF719ZlVhs16ZYG/nqClEA3DkvgI+829QFj4dGNEvUQJBBAwKS+CDO4WQovsxwoGgrElB7krNL2tq5sUQ6ZYmA/Y9IR1PkoIYUpxPh6B+FMfBOgiFgrKLcneGXkZUyzMcN5WOskJOy9DO1mMfucRL8Y4kX3FB/u4dGpeOzaXcH5eylS0euwM7okkoycZb8oLuaLZw6+7HiMbhtrkQYXn/VQf/IvjAs
 WMmk+Omd
 fDHEFD4W2agn4/jnacHVFCOLJwa+RIqvjkCEYQl6Arb2x3jwHDM5sJcxh/kJlptXNL/+R9/Od1ngQkwgKL1K9ePwWS1mRT9X+9ICY821v1hghcRl161E5gYcJgkIGqFWynqxIIDxinS1sTxq4eqFslRWYWlaGW6HIL9Fv08vtyMGmwWUpmxCAbd8CcZX0X1x7/590MYK6eFr/5pFyHKYhNEQC2YiaoqUD6teh0fzaQKSKq8NCG6S5m668P3l4e5zG7e8nRftfSLqPjJr0PN0hme0TNdEssn4OMtJgV8eJVcLcywAQIOGwKiP88MFLnRsR8WIo1ZJQCevblKKLvIelWOk7eIuIHjjzV5yg+D8D0rZYcKPyuNDN2c4xJoF8k5cJWykQ3+MmwmDcsoH+F2eXfgWE5qo9RYXRJsg8hXeMJFpJ1GMWV1aLSCrIZS/znWYftxeQKKUZsEdi2XvVli+MZfy3onbbwOBvMmOD27e1p0NiVdSiEwRbZUiKoveKNLISya48m5zb8KgvJwfSkXkLa7NJUenekvXIPSP2Nti2ICZNdQTBxWse500zrgm5MJ7W1UWk7NdO1ZEgu3rzlvdAmtS9T7JsiepYQXXfs2QTaIuFVO+xtBnFswp4wgqCZYLRFTkTujtQ7oFQ0zwmSg+xIo/XEyveOvwVez0Hsy4L1Zyo3snAYx+TDwYjEypYbjv7Ua047QpKnVVS0j0iw3v9dHK9s9IKCO1uwF+M6dt/uQTUkSFn71JHoyEbL7lI/ijKJ0ICTAKq60K1UNoCiXaslGpOuVTrsL7IkjkPW2tVWXs1T9m7yzzqIdiS498Nl5yKYya7aCrrRUZZrBQnqwch5ZF/ggBIYA3iPXVH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 09:28:01PM -0600, Nico Pache wrote:
> The current mechanism for determining mTHP collapse scales the
> khugepaged_max_ptes_none value based on the target order. This
> introduces an undesirable feedback loop, or "creep", when max_ptes_none
> is set to a value greater than HPAGE_PMD_NR / 2.
>
> With this configuration, a successful collapse to order N will populate
> enough pages to satisfy the collapse condition on order N+1 on the next
> scan. This leads to unnecessary work and memory churn.
>
> To fix this issue introduce a helper function that caps the max_ptes_none
> to HPAGE_PMD_NR / 2 - 1 (255 on 4k page size). The function also scales
> the max_ptes_none number by the (PMD_ORDER - target collapse order).

I would say very clearly that this is only in the mTHP case.


>
> Signed-off-by: Nico Pache <npache@redhat.com>

Hmm I thought we were going to wait for David to investigate different
approaches to this?

This is another issue with quickly going to another iteration. Though I do think
David explicitly said he'd come back with a solution?

So I'm not sure why we're seeing this solution here? Unless I'm missing
something?

> ---
>  mm/khugepaged.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b0ae0b63fc9b..4587f2def5c1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -468,6 +468,26 @@ void __khugepaged_enter(struct mm_struct *mm)
>  		wake_up_interruptible(&khugepaged_wait);
>  }
>
> +/* Returns the scaled max_ptes_none for a given order.

We don't start comments at the /*, please use a normal comment format like:

/*
 * xxxx
 */

> + * Caps the value to HPAGE_PMD_NR/2 - 1 in the case of mTHP collapse to prevent

This is super unclear.

It start with 'caps the xxx' which seems like you're talking generally.

You should say very clearly 'For PMD allocations we apply the
khugepaged_max_ptes_none parameter as normal. For mTHP ... [details about mTHP].

> + * a feedback loop. If max_ptes_none is greater than HPAGE_PMD_NR/2, the value
> + * would lead to collapses that introduces 2x more pages than the original
> + * number of pages. On subsequent scans, the max_ptes_none check would be
> + * satisfied and the collapses would continue until the largest order is reached
> + */

This is a super vauge explanation. Please describe the issue with creep more
clearly.

Also aren't we saying that 511 or 0 are the sensible choices? But now somehow
that's not the case?

You're also not giving a kdoc info on what this returns.

> +static int collapse_max_ptes_none(unsigned int order)

It's a problem that existed already, but khugepaged_max_ptes_none is an unsigned
int and this returns int.

Maybe we should fix this while we're at it...

> +{
> +	int max_ptes_none;
> +
> +	if (order != HPAGE_PMD_ORDER &&
> +	    khugepaged_max_ptes_none >= HPAGE_PMD_NR/2)
> +		max_ptes_none = HPAGE_PMD_NR/2 - 1;
> +	else
> +		max_ptes_none = khugepaged_max_ptes_none;
> +	return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> +
> +}
> +

I really don't like this formulation, you're making it unnecessarily unclear and
now, for the super common case of PMD size, you have to figure out 'oh it's this
second branch and we're subtracting HPAGE_PMD_ORDER from HPAGE_PMD_ORDER so just
return khugepaged_max_ptes_none'. When we could... just return it no?

So something like:

#define MAX_PTES_NONE_MTHP_CAP (HPAGE_PMD_NR / 2 - 1)

static unsigned int collapse_max_ptes_none(unsigned int order)
{
	unsigned int max_ptes_none_pmd;

	/* PMD-sized THPs behave precisely the same as before. */
	if (order == HPAGE_PMD_ORDER)
		return khugepaged_max_ptes_none;

	/*
	* Bizarrely, this is expressed in terms of PTEs were this PMD-sized.
	* For the reasons stated above, we cap this value in the case of mTHP.
	*/
	max_ptes_none_pmd = MIN(MAX_PTES_NONE_MTHP_CAP,
		khugepaged_max_ptes_none);

	/* Apply PMD -> mTHP scaling. */
	return max_ptes_none >> (HPAGE_PMD_ORDER - order);
}

>  void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
> @@ -554,7 +574,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	struct folio *folio = NULL;
>  	pte_t *_pte;
>  	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
> -	int scaled_max_ptes_none = khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - order);
> +	int scaled_max_ptes_none = collapse_max_ptes_none(order);
>  	const unsigned long nr_pages = 1UL << order;
>
>  	for (_pte = pte; _pte < pte + nr_pages;
> --
> 2.51.0
>

Thanks, Lorenzo

