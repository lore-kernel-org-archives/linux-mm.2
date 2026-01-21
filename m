Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAA8D46956
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1311C6B00E7; Wed, 21 Jan 2026 11:57:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB6C6B00E9; Wed, 21 Jan 2026 11:57:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B6D6B00EA; Wed, 21 Jan 2026 11:57:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA2606B00E7
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0DC2BB791
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:53 +0000 (UTC)
X-FDA: 84356578026.11.B26D0F5
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2CB13140002
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mRyFS7WT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GoEv5aEl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Y2Ns4+dpl5/KO1A/bm8/LqsaVSgmvxZWW0Rv736UBg=;
	b=HEl0YDnNnNo/KlwAsgXO4ddTg5Qmi1g5kLxwtYmC2wYB096/pT65K/Iz2NNAn2YLQVSbGJ
	DexnCWs2n90hxA0m1JXcKlBqy1KC/Yn2qmWoHlZ3zGqCU8ObL/40RUcUD56etCbHDK0ydn
	KLf9xGerNbpodnroUH7yChxcTVuiyq0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014670; a=rsa-sha256;
	cv=pass;
	b=hPSX2UVH0JmuEGdF/m2psvhrf5iI7VKwtpbYa2sVWWVyonQThLo2A/i6QKpLHDIWyDFETC
	j1hhrNrZ7IyC/Vz83Jt6oW66MpBHae+E21cqihasvUzsGVx0HtZF3X//Dev8W4NFj0YHok
	k4+qOFvoZO9u92Sct5TJ9Lh42HaipbU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mRyFS7WT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=GoEv5aEl;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LDNTs43028859;
	Wed, 21 Jan 2026 16:57:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=6Y2Ns4+dpl5/KO1A/bm8/LqsaVSgmvxZWW0Rv736UBg=; b=
	mRyFS7WTrVIhB/ewvnl8PSna4HGmdRR3P9CrXpoEeCnur4AInIRvYxq0Gqsqdlfg
	45DBcxvPFjossg6Rv99lKfjWtILK+tf45r4i1ftlSNGazOBIVaSwbpw2CjxyuQuA
	tS4ZqhOsfyS0MBZxba3VM4zA02BepdYide0awtkOw8KoxU22vnYaPa7v8aFAS1JK
	rNI2CYvQyQH9cFCu/HUv59veObRxRoc8gQ8JuF+MK/5f4nPLfSwNII/Ne47KyRCj
	oYlPunidGN6bvAUL4QOjCKlYeVCTFBuChgdB9uaaGz+f0qxylD2OKXq5bIJfTdhJ
	PgMIUw4aiFmTt5Ek+ktO4Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vx8p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGqusL032182;
	Wed, 21 Jan 2026 16:57:39 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013018.outbound.protection.outlook.com [40.107.201.18])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfan5d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yCRJ1CqgnsLbyYyDqOi0mbtkKHyBlusMNlJ1/NPqtEtWlVoXt5Fw7kaIU+Q2CqxI4108KMvIMqTyXs+rEbKg+a80HAe/cas+EIwgzjIvrGQP9PeHSR3o8mSUmLpCMN8VDzO6Xv2Z3L4tD1eW+Ehz+bqDLocY9+bbNNq4v75mhpO1cyMzOd+T8BxkQ+ksg8EIYr8P38WI87YIBAVn5DWXsCUmlUwk8+SBj+v2ObXtdJu44Nj7pVuVlXiwtmNMzAM1DpCqOFq1gqW5aPO3A5txYUxql91KazYHMpBS2PtuFrmK6cdaLsxkGTl3E1RjUDWbuOUFfjBeLpKEmVrAPAIHpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Y2Ns4+dpl5/KO1A/bm8/LqsaVSgmvxZWW0Rv736UBg=;
 b=lRLAopVx0bDPiejYBZ+BCCsy/OkfjDD585Bp3gAvKHoyuHmGKOcZNqydMC7DM0UHMTV+r6QnGR5bujzMpcykvUobO6h38jogDtuArGHa8cggGbEpyC0GREaie9pEiMMjO3Ax5eiffS1NmdZzDuAc4dVxFqFa/mBn15ewAXIcmE9YXCZy2xWbzj6YwbtdqjH9M0uqzZN1S5iq7JiHgZGKr4AlmBrbxgzWb9N5yABC2mKrsg1OPjT+B9DHdYqj8dKUDUARnCA3ebpV7/5BEba5SXgt/uX/lF4vh3/2DKpu2VrtHfhTAp6nwMYyb5ZiDtrSJ3jdJKErl4qMVgakDy3p0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Y2Ns4+dpl5/KO1A/bm8/LqsaVSgmvxZWW0Rv736UBg=;
 b=GoEv5aElpFJPdJjJqOJX7kRwWM+3N7T0Ofh9+/VBs5V8DLQm1DBCTYsA+NS1r2D80IxcLNcEplDUfDn4qeHQXiWQJKNcga9Qe4BfsmgwGzIpEd9iNoXpSKH9ASppn/CqI53YuYL74UwtAlR8XCDMKOk02KtHMe5qj1zxPN1c5yE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6696.namprd10.prod.outlook.com (2603:10b6:8:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:34 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 23/29] maple_tree: Add copy_tree_location() helper
Date: Wed, 21 Jan 2026 11:45:20 -0500
Message-ID: <20260121164526.2093265-24-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0066.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d66613c-a69b-4d85-b274-08de590e2c7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cWZ6vrl2KhGj8ZkDvYneLkku4D127WdCLf0uJHvFH5FzlxJSW1TiqzekzsNr?=
 =?us-ascii?Q?HxvyaQHdPjpdhTWhkotZSO+Aja5Ac3NTPVsmE+TmUuRTtBrHZftPNUe4z4JS?=
 =?us-ascii?Q?wc9SLdvbTSP8LyHMZ/pxOt/5MLjUCY9qD6027pyUdKwSg087Yy3g4XHHSPkv?=
 =?us-ascii?Q?XjE7ekUXQSbIs3ZEFrgbiklHlWcvlHjrwucLPOZ6fR6vM1JOmduxxoBzk9RW?=
 =?us-ascii?Q?uRWRmuAfViGKV9lwJuSa+jmOq/zRgaMHDVFXGgaabCF065EOsv8Ynm+mhcak?=
 =?us-ascii?Q?Hd9nci2mRuAsi5H+WLcITWOwe8SpMIyIbqfGqyiKTLwBpSK0+TQ+21Z8J6l8?=
 =?us-ascii?Q?AWKBAuw87BcDFbN7d95Qx5gD4+8bVaWuHEGkbNhADR0VDLrhKe/m2oNu2K8b?=
 =?us-ascii?Q?OGG4/pDnlJirancLZl+3MCqPR23cmoBTaIuVQrJHZha/liiHPltUDY49asua?=
 =?us-ascii?Q?JCucUlcgWH/idryK/smdu2iUiXnkr6CKjHq3guc8bfFEJm4NWQuQwcqTC6Am?=
 =?us-ascii?Q?eInz294kaiLhK9w93U3cpjOwXP4i2EnzZqwmI0nvk5hUb5umZOvvn9MnNTN3?=
 =?us-ascii?Q?f7m+AGk1xxKKFISBNVvXkSnJgbNx4e3+g1n9tALelutWgt0KotG0yr9cG8oX?=
 =?us-ascii?Q?H+jXEfMZesHkcHEIKxgvHIwoYKr3TAf2caA5rmsJeYP4ts9XiVtPeS4UQDFN?=
 =?us-ascii?Q?wsFcMdVNKDG6N7va/6bBhOeI5M7DKqg+dX+9VIFOR7GKN0pz/4wqWTAMiuFU?=
 =?us-ascii?Q?vP4yrQ8TLOA+lG4Ee+XXfn4k+SdnX0tBWaI5B47v1hYhcql7NpA+6na+uyPw?=
 =?us-ascii?Q?WGVbDs4ILJafnMGe2x9IDjdkbFGLKCAhi66eayIcDamuMK5cFyq5SRIQ2/ob?=
 =?us-ascii?Q?T6Bh9cf30FDaXzloJdFmBweeEMc3m4fqs/KcmpBK2Iq14Fgcme1YOxLeRHV1?=
 =?us-ascii?Q?iBvLYQ7TJzd4g/8RCf8ph3PgNMeBiQayjRy52TI5GzxUMb9KU6ITs+JLH58p?=
 =?us-ascii?Q?jCupnvLoOgzlNUzMCsdv3yc02UPysLiEkcPLauphns67xc3mTKiuOGBQMybe?=
 =?us-ascii?Q?2aZD615GRm8r/8P6NHYZ6zWumOw2riHHDMUhxb3zHWKdBRETh5YZQFanh+Pd?=
 =?us-ascii?Q?0gFrgPxzvdxdKYj8IIRcGRpZn0RAQ89pfMwkU0oBeDO0b+NkgStAoDAGv1xm?=
 =?us-ascii?Q?gsdtiCYglF9s61DhCnO3xgajfy8Zum87qn7DWxbizAlDwsYsk0g/Lrp5FAH9?=
 =?us-ascii?Q?+JqqgKEzM8KW3vNDoSdfr11McXoNyr5cjCPssaIt33g3b+8Js+yb0H+QYCwM?=
 =?us-ascii?Q?t6yOcY8pPuu0ZNxDKjBwph6V75WNfxMUiEVQD9E6HXP419c4Jzt1oDFJkkbN?=
 =?us-ascii?Q?wLAoEAeSQ1MbfHxVGDBnLUHgmSuTvGbnW26Hfgqe/g5CxzNbFT2BJm8l6yfp?=
 =?us-ascii?Q?am/hmC0IGdvsM14yHY6jJPtfmT3itZWT7qK0NSB0ib9TaYjMQc2zpJbhFcfs?=
 =?us-ascii?Q?r+d9tDak9xXekDIaKKj6n2f4ABGONjvU8mOZ+bYXWc7JknQj5vn4vEQRUqin?=
 =?us-ascii?Q?8u2quHEWAN5hrG5iiIk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/ye8mFoR0R9xlxPglbVkbUdHFNHE33JTZW/+8wm8VBFQB215K/GVtXbgcO8n?=
 =?us-ascii?Q?I4LM4BVOUffxvRhMd5PMufQbvlDC6nuSONxgMhhWlxD4XcjnaxrHYbNEvyHe?=
 =?us-ascii?Q?SFcLKhrCoFHlBI49Yxh8fs1NlTwrYxXEBvGFdOtuZNTmpbck6lBAlCnrqG6o?=
 =?us-ascii?Q?QNrQVggBiFFk8IpvXcnExV/GKf9WJWBbv4a1GA8UmLHaMJa+CwOoyobrBxTQ?=
 =?us-ascii?Q?JGiP7Kzrv1hSXhiCfOeXPvKKXfY+T1rQUMrr5HJ5YzXebJoMWQA0zGQlILUv?=
 =?us-ascii?Q?GpSc8tCaSrfMOPqnrv3bhGXJy8ezbd1F4crvMwwq5tVb1yB719IJovz33dK8?=
 =?us-ascii?Q?aZAfg4Cl52AKR7innAR/3eGhJKjPd0wkbKEhEai4Qf2LWauAclajkmd1yDHm?=
 =?us-ascii?Q?SrfdDlgpQfYjYCOtILDiInLv8uBJqtyVYx1deR5dNPaQn+iBvkrEzgeC4rsw?=
 =?us-ascii?Q?cMl0cbVxNVyDOhGEkHUig4gPUSs2kbgSQ3Yj1/f+opOt8JXaJ9iPpLrX5l5K?=
 =?us-ascii?Q?86VlESKsjYs2bQxXiQN/4yrlhmDi69sjBJFXvlMJsxLkkgxhZgtyh0QBvaF1?=
 =?us-ascii?Q?l0M9qpOhQFbgQI9VGeEmfXlSWfRdQfch5ZTwxvyBzEEy6qKLuwa/5i8GJET/?=
 =?us-ascii?Q?1X1tdGlLj3DEtDnSP/XJSTWhuZKmglvs/fyIsqMGcMNSMyZmK/wNdqq1kxyE?=
 =?us-ascii?Q?q4T0NQOjRQRRWM34ndN/b8a8lVf5I6Ue+H1RGaXV5EHTyJA6tXD99FVj5exK?=
 =?us-ascii?Q?0AAY5HlYuB0DkVofp8k3xA4fnLZUasYt93BY14UFgeUS7bKq0F5gESzHK6bv?=
 =?us-ascii?Q?gA+pjjIZmOpBFDML3xjF24s8ybeaVwtj3cQaDBTs101jxCQIyNWfXCjrE5WM?=
 =?us-ascii?Q?z6WLZ08Go4AdJZNWsviHM3LVJO5u4DAhK0DwboN2AoQJbK9E+8esNVYuD+3j?=
 =?us-ascii?Q?KNDxW8MpxuTBYMlRMdwBf7psC5MW3kDhKzjbsxg+WJ46AN8YHVJiWjNfSOQU?=
 =?us-ascii?Q?725ADDGgUEgPCl6zFaKjZmooTQScODCoo0nzGNkZxHdtD7rxk5axeWJSAMjU?=
 =?us-ascii?Q?dDLs0e+IzqrDAnPixfS5oRxUJeNIqwNP/7JSkG1t/mEvUR/Q3vBBIC8XoWH6?=
 =?us-ascii?Q?LJwR8cgmy9XrsSfeyIC49BJuyjfk0EY6fKbWGf2Vuq59ipIzV/dOhplI9oUo?=
 =?us-ascii?Q?oTyVXeGOplJA/SWf9gbSxYxZMsHeXPj0/On+lAtV8Qlo3B0weTj1evJa5XsM?=
 =?us-ascii?Q?QgdH7Z1JNTwGAQLfM2dU8WQCLNbsPezXu2JAtdQxnKOrMwN/aTio9AWMz6vm?=
 =?us-ascii?Q?iK6KhkvWqDmgKFYV76GqdxS/l+zy/LAp6Gdp8V36k5YNuedghs0bh5kpr6A5?=
 =?us-ascii?Q?+lYWGnrclfvu595yN/UCWkp1GGzWMibHMPA4K2RXkL63oKkKUxZbudiGM6q3?=
 =?us-ascii?Q?MPd5/7MFuFGFi3N0uHAC57SYpLFoocuFjxRvmQ+IRWm5MKaShpT7M5XgFdV8?=
 =?us-ascii?Q?XaFey6MH4v4V5hDx+h5XrePhmqwabSzNqm0Iy90Cfi+BWJCNLhncF1E0RloI?=
 =?us-ascii?Q?zd1p6yAyENiHHSoxGvQiAFcy8PRvHiircmM1KSbSN339iRhu8B0WIvt2k8za?=
 =?us-ascii?Q?PaqdoRPejILNvbZBGM0h5XVm5kYmbcQxqBapz4MwDnTjnlk5ETKvC7AF/sD2?=
 =?us-ascii?Q?FO1LR95hOO6GNGoK6lE1Dbgt0gXfOxh2nkC97WBI8mwnwDuPuOAczIZ9YJWO?=
 =?us-ascii?Q?NmOBgoKu9g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i3zmuhYV69gVit+4vOU4VDhzg4Zu0xqyHhaQ2sCF6AkgeUoY403c52IBvV2rrYp1/3U8eYng0zhyxUp+IobeYblZjgC/qKZvp/+Q1ToNlN4h1LMaYsKfVRbG5sy/7zWKZ74KM8Bu5tsQQs+1/5iPCVdHo6vuxAh1mjzh4rWOoVutUtGQOTbkZ5DzV3fIfgVEGmwhGWIiWp62FiA6Nui9NOLKiUiyIhBGW+zv3Ldi8APzW8Cdy4Y1aKMKyQTbPyPIDQjUzqKXFBVKOH87oRzSMk2GESBL+vh9E7H2Rxc77x36vLxqNqjBXV28OknWK4E2WrtsMq6FjeaPgSAA+6c9+G1uZb8021/HJyT4zr//0fEGSzI2OdFTk8qX9aSNjQxebRyHGc9QzW8zYlDyEuIE0ryAyXpHIzRKD54u7re77MCSFATfah38uXAUOITLh7gHyLZYo37+1CIFcRJHd/oXp1nGK61p3VI4f16I82osnlMYWCYDQ5+uB6vIgp91xiV5NbLVGLD7Wgfxbxpb2IGt1I+4RnoTmiBsncPEZ8nCvsyqwXlhuwNdcdKq6hJd7VA4cz/t1ZP7zOFV7f2q6Mej0h8Oil6ggN4KZis6W7K1Sxs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d66613c-a69b-4d85-b274-08de590e2c7c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:34.4864
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: agqluL6qN8sKFxRA1HpXoZA0fdsWTniTmhdSN9al3MsmjdlI41Dj7ibX8YG2dAEimU822cOyn9zef6g40DrA4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69710585 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Ql65JoKsIb5UmNcyGUkA:9 cc=ntf awl=host:13644
X-Proofpoint-GUID: vtR6SkUzEHof-gSpDgT36C11dYvbxp-Q
X-Proofpoint-ORIG-GUID: vtR6SkUzEHof-gSpDgT36C11dYvbxp-Q
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX3MoCeBoQcRf/
 NeUxWfly7eWfPtpGZS1dTvUtStPn0bSB1dtBEvIhqkVhqqVz7cO/0TZO29KwC7iFJCrbfxowfhu
 9pGV/QHQaeSQWN2Qt5X9C12dfgUi0LPhALPDcAXzMm02pwkJrSZHkxOLBi9K/oED3thf4ckwGLL
 UzhuITa8ZmVm6az/uXC2sGpes6qwt0vGRRaSFP4AdE5IdsxSQyFFggyIiXo2jJwv4DVR21vkZ+D
 DrM3lVdv5zhxuWJyNuuw7QIbSSXr89a4aDm7Ed0WqCFJQdXgtyzLlncqrLrwFR6596t1aKiXZz2
 c6h9wSYH8J2dzZNjrkY75p5eBhNoS7gCFzsM0bRhR3RCytQASqSkUAXSZOpiroZM9z5MOEkjTax
 5skC0ibKCGyx7dgo29dcX6X14ZCxVXrkIznj/hevmHC2L93DOrpkd0TFVbiDKpQP+upGehHCk5q
 wmg+ypAT1on9c8wFOK/cMitSPoIUNf3Sj3sUa6IE=
X-Rspamd-Queue-Id: 2CB13140002
X-Stat-Signature: eer1cm8wjkxmzbahsqw3jee74foo3ufc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769014669-531955
X-HE-Meta: U2FsdGVkX1+HFDbsHBvdgvabxkxN39kcylmQ4UdOKGYMl6qoHW9HlGAb2UQkwdT37OxCJq8ps+ShFdWemZCpiw1PjM33j9RJR23cj7VVLEN4DVc2d6KbRCvgINxK+YLDOLoWaQ+ODz9ao6ikdJ47ip8btUj/ySS7MIizfruscnDohs08FUdPEsYx84hfkDN3I8SYMEo5q4CtnjGwH4CzH7mpH9C2n8pmS59kDTvgNm8gl9tORb/uQJoQwcctv5IA5N8NOfuQHFZsIyeW88yjVXxo+Aymcw9lifmFMFPwiGAMQTL2xB+ronFSSOtGmdZfenNEx8VZsdP0AfIY4SDRev7COnkQJrtEbYPAgjXKmRSA6dRBiRsAjJ9hSz9CkkWx6M5oI78iePFu8iKxmEiOR53Rinf7Akm2tZCFazccJsGga6COehH+aqpx9kvBfeh+nopoZED3BB5/PMeX1kYmgqdxRIs3KFVL62JjbuoXJRGNZg41nWfyqs3jSjAuDlldiGff77Q63AR3g4TSMq1GsbInNtlwe7QNSTtTAwottuVD1dKk8u5VI+E++PHbh4BZvRyW/CvJucoKFuRg1+vtmMAnYeLSTTbGLUDCo0dxIKFI1ZRFcLAU0CKMP+71eiBpvaTczBPK/1BcE3Hc06X0JcBDW8RRDnRmcHdJ8QLiEuOzTV0XksjYYIh+I0jNNBH9miSCTxmZ5Jc+D2W2zJiseJDgb+2wOUzcdQbxfdzNU1KZOsq/t3/87sFgwoTeVPISz3IzoqLpe51/NFoeb47ta6PQAXbofCvzfjEOnwUGl25DagunjcI7AtptcluEwdyMFi/tfiw1v3Fr/PSI5gVg2EOquyMQdzxp9q9SKPAf2mY6PcBgEjyyaYtYPGgkXKlWylw41vqb+ZrFGr8z98zuZcsC/Q+NQI4vrcdfbDLIQphyZw+AUv3pjEX1KsOZOqk1xO/WntA3Z2MrxWO0Ia2
 a4OkrWFy
 dtnMDhB+LZUHCECBrxOlko2zPeWifhGxz6JJs56+Z73dTwvLYZOLUWVnFDG12DL1zVfSyQqNRcjKpd+tAnd7c0SbsOtUpW89RfAQA+XYRkWpOEYBFyfOCZycFQAuTyRy5IYKvgZaiXCUfr3dhzzywuXzpW6GDpoD3pTW+WuxSVVt97duMBEAj94cljjNHUpIct7dZ/3qg4GssQgoF4hzM/GyskrpW20X6HFLJKaz7iORuzROBcRQXgawbXRSjgis8iqBXPjR/i1IlrUOZDWDwCRJgHuSBlZrQtURA1zqsiq7zexSF2wi6TgvFfPptH7U03TGFsyDQ6+Uwuf5UUqGDOh19KEkVDObOnkjf5+qe0ag5ZPHXaoFhIhXtaJ1/lJOTRVLbfK5zBjWmxHXvfq3qlb0rbGl187NYKJeTuTlTW77gctvXLBkDR5q69Ylbs64B40qMfQgbDTz5SUbduFe6Xa2DCXVkAuGn73EW6k6vu2opFlhSQuTWMUACXqp97H5c7wHq1rxasEUZf50ehHF4zRg13NiJB88LyBD5u8iwlb6bzCSPqZGsS4890EtPMcfapl31Hskfs5SlNrWzZOL39/Fqna0TbbybPZd9O1FL7R0407Uqw8lT1HM+3R9di4D7xa2UjC6V7lgR4ERuipQqIurIEAdJMa92RqxoqKQ/DxZ3R3nJuLN0gGFfWb+IT2i051ai
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the copying of the tree location from one maple state to another
into its own function.  This is used more later.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 9b1686fbd2d8e..22f52a9b26a9e 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3523,6 +3523,17 @@ static bool spanning_ascend(struct maple_copy *cp, struct ma_state *mas,
 	return true;
 }
 
+static inline
+void copy_tree_location(const struct ma_state *src, struct ma_state *dst)
+{
+	dst->node = src->node;
+	dst->offset = src->offset;
+	dst->min = src->min;
+	dst->max = src->max;
+	dst->end = src->end;
+	dst->depth = src->depth;
+}
+
 /*
  * rebalance_ascend() - Ascend the tree and set up for the next loop - if
  * necessary
@@ -3562,12 +3573,7 @@ static inline bool rebalance_ascend(struct maple_copy *cp,
 	}
 
 	cp->height++;
-	mas->node = parent->node;
-	mas->offset = parent->offset;
-	mas->min = parent->min;
-	mas->max = parent->max;
-	mas->end = parent->end;
-	mas->depth = parent->depth;
+	copy_tree_location(parent, mas);
 	wr_mas_setup(wr_mas, mas);
 	return true;
 }
-- 
2.47.3


