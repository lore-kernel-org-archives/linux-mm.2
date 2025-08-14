Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0E1CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:35:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2826900195; Thu, 14 Aug 2025 11:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB36900172; Thu, 14 Aug 2025 11:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFDE0900195; Thu, 14 Aug 2025 11:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B919A900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:35:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 933521406AF
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:35:21 +0000 (UTC)
X-FDA: 83775762042.29.F17CC78
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2081.outbound.protection.outlook.com [40.107.101.81])
	by imf23.hostedemail.com (Postfix) with ESMTP id 231E0140010
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:35:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="PUvuD1/6";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.101.81 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185718; a=rsa-sha256;
	cv=pass;
	b=GNyOgxjFOUCCWv3YJ5xaw+suo6A7rx8oBQOi7t+pSnrqAMShNUlcBn08IM+mKELYYcZKDG
	6r34EWfU7plMawR6qRJgbrB5EgKQ0G6tDztF26+P63gfNPPg6YTNMgYBCrbv4cw+lVzXHT
	x3nM1aKDP7QKlM7XoGfihoHiK24PHoU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="PUvuD1/6";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.101.81 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woX07bXSCoSE29Y9wKE+L2cWmZShzkBFCGt3WmiIeoM=;
	b=fGxO5w+VVsav2otRDHYI9EKpElPi9TiqEO79w+7WV5GqzRhpGQJmTURzmqcdhZyWyigO9R
	kyKVy8jV1ScIUSwXe82WicSDYRmJf9Uovx+mpNmMQrZakAaL1XMZfMUGvvyzsdkmVlOSW/
	12MG44C+yvd4wAZRcAVfukyT63stnOo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qqLqiiGXd+X+F4PWXy7oHVaixU021X9evXbmT0oV7tf4O77pWi6rnVFNoJmcEnsKM+7oDTyzjt5w0NmH8kFCV9/0JBmFzDyc8RdHGH6XMfxX7eYJZSUdMwqDZPtWvY3BalzWimVTmyI1+ngAn4b9ihFRQUc+CAfTikCzfYA82Fg6p/4WQQssT2IgDnFtoLYIN9qePgiZTiqU0L/Dct42zGnMbTS55GvtWUZZO8o7ximPj2eY2zaF0uGH72UnEj2qpujg/ZweDYR9nsGNoKWHqXCA9IEYr+CtbxJt1LBvCCfj8Glo471+os73wKGUxtmZIwJeFS5RmUtc0X5f+oI4Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=woX07bXSCoSE29Y9wKE+L2cWmZShzkBFCGt3WmiIeoM=;
 b=EgcQ+ku1jnYow+WowCfw7LmTuuIwMEC3PHH3C4ttQwOxdXcNX+UPoJELH82WIjyMiXl1KA6rFbDhs9i6abc3qQfLrEnOpDJ2U6gEQt5eQQmEPUSi7XkfzjHtKXA0ryF4oMN/sVVTHQiUslZYTi0ZWLDvAJESjm3AkWYYW0OxjwA7viZIK3amrb76fszrF68DZ2++BPShw4Zgn2hviRRUSPPGn71//7hJJD5po/KkNcgbGnw4T1OHZ/Sg5W08kkIVY2i6/g6Y2pBkRKnDzWblRUW7vFhRcdHCz5+HxuItVeC/oSKpzDSUjlYGk0J2OBQ2xLVV0XVY81bvrsIYSBFdxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=woX07bXSCoSE29Y9wKE+L2cWmZShzkBFCGt3WmiIeoM=;
 b=PUvuD1/6HsdFcViD08WTKKHmf4JIxXhBQigPGPz5j5Z2OyOXq391aUDXV7fgMV6jJgCkkSVkzryx5IZZlOhkjPckUhaQK06z/NdI7LEXIsAb++Nq6/sFLs/QOp6A6SYcPQvfy7n1CgwGhJeE12tCewGefgSJUMjS91KpyO53C9k=
Received: from MN0PR04CA0028.namprd04.prod.outlook.com (2603:10b6:208:52d::27)
 by MN0PR12MB5980.namprd12.prod.outlook.com (2603:10b6:208:37f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 15:35:13 +0000
Received: from BN3PEPF0000B074.namprd04.prod.outlook.com
 (2603:10b6:208:52d:cafe::53) by MN0PR04CA0028.outlook.office365.com
 (2603:10b6:208:52d::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.17 via Frontend Transport; Thu,
 14 Aug 2025 15:35:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B074.mail.protection.outlook.com (10.167.243.119) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:35:13 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:34:56 -0500
From: Raghavendra K T <raghavendra.kt@amd.com>
To: <raghavendra.kt@amd.com>
CC: <AneeshKumar.KizhakeVeetil@arm.com>, <Michael.Day@amd.com>,
	<akpm@linux-foundation.org>, <bharata@amd.com>, <dave.hansen@intel.com>,
	<david@redhat.com>, <dongjoo.linux.dev@gmail.com>, <feng.tang@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <honggyu.kim@sk.com>,
	<hughd@google.com>, <jhubbard@nvidia.com>, <jon.grimm@amd.com>,
	<k.shutemov@gmail.com>, <kbusch@meta.com>, <kmanaouil.dev@gmail.com>,
	<leesuyeon0506@gmail.com>, <leillc@google.com>, <liam.howlett@oracle.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <nadav.amit@gmail.com>,
	<nphamcs@gmail.com>, <peterz@infradead.org>, <riel@surriel.com>,
	<rientjes@google.com>, <rppt@kernel.org>, <santosh.shukla@amd.com>,
	<shivankg@amd.com>, <shy828301@gmail.com>, <sj@kernel.org>, <vbabka@suse.cz>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <Jonathan.Cameron@huawei.com>, <dave@stgolabs.net>,
	<yuanchu@google.com>, <kinseyho@google.com>, <hdanton@sina.com>,
	<harry.yoo@oracle.com>
Subject: [RFC PATCH V3 09/17] mm: Add initial scan delay
Date: Thu, 14 Aug 2025 15:32:59 +0000
Message-ID: <20250814153307.1553061-10-raghavendra.kt@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250814153307.1553061-1-raghavendra.kt@amd.com>
References: <20250814153307.1553061-1-raghavendra.kt@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B074:EE_|MN0PR12MB5980:EE_
X-MS-Office365-Filtering-Correlation-Id: e20a28e1-8ea9-475c-d4d7-08dddb48293c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3QjItbxSWK55f9S8dJPN8kJzmutDu8gaeU6Xz9KXs8LZZMM34wtS9STeL9+W?=
 =?us-ascii?Q?OYL0PNYV7vQNcydspLuUb0nqjxBUWzXcx+pgJA9L2BvXFFjI61q4SPdhtDfC?=
 =?us-ascii?Q?MrtI3KBLNT1rtTZNc4FD578qGHhlnGjpMTIeAUC53qFu/6qZ92XpoWC2J1D7?=
 =?us-ascii?Q?iBRzOz1FAuxNOWrxQ7gPKBkyMCjsusEaRFVORB2zD1pOfLx9U1ptXeCh3R2P?=
 =?us-ascii?Q?dVlmpKb3GC4Zj8HPLEI9hcQ5sxRTUNNV4saROoJ3nJBQ2dqn8eFibYLrrwA4?=
 =?us-ascii?Q?p8x+6j36Ptx6XOCVD8ROZXGJvjvYgqh8KPqfwBpsZVWpjkWX36pvHkaTPgAp?=
 =?us-ascii?Q?HJijaOmxVwHc53J0r1EMTEhMBNlbPYeXGyTjJs1VBirKO4NG4wy4WFoI3IJW?=
 =?us-ascii?Q?wiNgqEFic6FuTtzgD63rKM0BttRE68RsRnJVk4hXcbZzvamtE1/vQVBX75CB?=
 =?us-ascii?Q?v7Mv3XAzY3vDE1DQ5OSOcZlbHQ8ytJXpHw+/tXjC5WMi6hSAIUMNrWhopMk5?=
 =?us-ascii?Q?CS4G0L6W40dC03xp9qm49+EyDyIq44GOVGoLyrTuWvaXrpMpjo7B5WDYIPvx?=
 =?us-ascii?Q?i8T1MxPhW04PS2s4VAtP1oFyIXJG3T44O6jImDHuCHFm4yrFDJWjqnqi3Ri+?=
 =?us-ascii?Q?kylzML5OLz7GCxPCaAysFykHeO49UBm/6dUi+7hiEcs0Ko4XjQ2R4swR9nD2?=
 =?us-ascii?Q?0CKGvnKy8XQIah8utA8HSmbqT83dSiceivXXCc95d83sCg/OtONnp/yDLc4M?=
 =?us-ascii?Q?hZD6DWBERWURUUgrAqbbczkgSVxre7ND1brrrCDb5Tt1VRNu4lpgxDcBsTV6?=
 =?us-ascii?Q?ozFQ/AR9zxaFW5rxwhPpybJr4J3YzjNSTt7rRtS3ywuYs4adN8S1vzeNK9J3?=
 =?us-ascii?Q?Td7WsK16v96H3chF3QO9cfY2iIteFNyoxhtJD7CsH6+rIG3uAqBD2VWesFqa?=
 =?us-ascii?Q?NGJ27Bypi2bQIcIkTB6L0G7yxyl+beKYLnJclcFpmzzVgQRtTF1Z1Dh8XHoO?=
 =?us-ascii?Q?VqLMlxD1C0iod9410TxFn95pw2bEddocbvBClPRHtEq48+if+iUv2d5ruW0t?=
 =?us-ascii?Q?4TEFhzy6Vu5nPrz6mPHqWLEfVuMGo01R+f16LJQTGPg4Wfk8X/F9A0NtH7Oy?=
 =?us-ascii?Q?nhmXPYPT3l7wVRoRgvJal+AZghPGjiSnSddXF+VKGaKO0KccoeFttOr4YdCf?=
 =?us-ascii?Q?UydJWOrV45w6yulZYrZx0W2pcRLoFCdOUw4y4JLOq5tGOGp8F7fK0FmgsB0W?=
 =?us-ascii?Q?1OKu53BJxBrb/zZVHe/XzD8c2YGdR/F+1irRmrZV/Cm1fOmxkCpFqJLKcD6a?=
 =?us-ascii?Q?UVzZtnguNs4je1g9wPrliyKE1pi3SuQxgeVdeJ9KxrjoGTfsTQjtaAL0NF4S?=
 =?us-ascii?Q?rgc2opJGtNiDNxdugTJipJtr/LaLDZp3+OBZn87IZWKTx55tPe+P4zDLkbWp?=
 =?us-ascii?Q?np3nduxCmOMVU+IMnHwhJJj6e14WIVLCGbMTogSp2Jh0Z/zTMcN4WyN25+vj?=
 =?us-ascii?Q?n9YvFSQygAYKao6TJqTTusOKllbpWarJaEvn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:35:13.2043
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e20a28e1-8ea9-475c-d4d7-08dddb48293c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B074.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5980
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 231E0140010
X-Stat-Signature: oe3bsf4bdwbytcbehpioo5q3ea8yub7w
X-HE-Tag: 1755185716-834550
X-HE-Meta: U2FsdGVkX1+B56fGVaD6sfcHQsIH5cgj9AS2RC2/QglOKjhNWGTcjtLMO0s9ijNvu3RgjH8HLOTXtbas77qapcdS/sqFQBac8hflE6OMk17IPMNcdWWdG8Ygt0HK00WbKzN1czwI7CMQZUP2HUthA1EJLzdxJMe5BocQYXKLjZHvovYPe1SUcMdLL+hubDZNL26o36juP9phHdXG6S4loaBp0ty+hCmfOjwpzS3UWBRfgtb7PnBEGI09j6U95qt1Ap3ySvzUcNLALtXF7OZQM0duq9BhS6Le0HvU4evHsYWVczRLD5lcQClux+weU9i89XiDveFmmr+NP7mf4QjIOeGMdDcqh+KVA7UQtFE4Safr2CfzLwCdjI1xYLjBR31lHvDOuM201mdeHLL52n7JMONk9PmJFMoD4/ukIy9IA4F4uwCDvq37+FXJhw2NSZ9WDvTgcmWgjOrNYaNKVYijrCez6CQRenT9JzKH0ySQSYeVbgRGPATB9olXlmMhEEDrfUozdpLs5Cerse4jjHLWsijxVVvEJxrp8WSOrbLDbWBXccYi4KlKjpHV/P+f9wpjz0TM+N6sSoaaVD/VH3zRQKaTWR60FiVfuLikJx9D05jcaoOXXhxvm84QQD+tLBOu+NzFj308cNm/Rlv9YlXKLM5VzMp9TiMmwrjL8PuFqD9lEyTJcQbn7TuSodwVQPU84m7l43STaTGr94E2YkSM5juLmlme602PGHxybqX4ruvWL4wmIpfTqk88MAMnCVmMfJoc0PLZyMByEcZvUF5qnnmHOjGtXGjAKUmMYMV3+UwfwCQ2xStaX/mluq0IOAboWh+YOtGubW0rH3Nymj5dZnNqJdj8gaBDIchkYQX/ewpBPoxB9UXXt6LwC3uj+05uLFpvX2q5SxnXogimoPvAYLY0C+Csqm7PeS1RiEh7JElP8DTAPwSsVIM/lkZAkI1v4qD3FfiAYUWN9s0jz4O
 Nip0iNQp
 qQoeWQJjCkY6vYPkoixltifzR9PK2WUAxDFnjgZ7Wyp1asuIiuB7NOtaRmdSYRlTA2UPCALrNpBieIMnuP8SAZM4UMlUPiHFXVZhBoyiXxXcEbCeITLGZJoKy52j39d6Ks03HYMOSyp0cQrKlCdK8se91mCdmaKnl3T1mRxN0MAKaUuVCU9nkAiZDQVuRye5Zvbz+pUBoxox8j1puaBtwA+x1t0rMS1JqT6RjBvIYfODzNPe7jZ1HZhOjxJEZQvVrD3oOI5Raf0feoGl3M4hQQi6N46Lcnwj7F+Lrt+u/al1uGwUdRm26AhPSC314jFxxEl4K6jU3PVgRnbRtIR/K04hpipbqd8Tmwpk8bGubnCLmm06IRcxeOOXovlwYjRJweE3/QNssFWEO3BEnz/Ary6uKHjt5JKajGDb9ycV/KN0UCz4UTEYl3g2ZM+LAkNXotN4JUqXD6Gui9mbZTqGMYTvP1Sk2upAiVyhE6ovJAJ/Bzu0Axhy5unN59mV7T8GaM/FZ25TvFR7LtBIKhvcD5f+Zh80qOe7j3f1Aat3CzGFOuZLNGXVOxBwIfYJT5rtOOABrx8l02FoirPAiuqZV7pOeT+esCdcKh+z0IserBcPjLCRKsDmvH50fnCDIB7HJwf82+3vh5cWvuMlCUHAY82+HWIytj0aGUjK54D6uhFTDx/Nd30F5n4olN9r4S3higJ8wBDJ8DQKu5Px4eyfqkkaGfPnl4GnUzWEIPjK39z/p5B77PTc9ZtQuhXlFU3DJzzuSoUwIaOzkirF2dMwmz1v4egcYiL61s2P5MKogZIrSl07DSpggnLs6xvOhxXmZyvUIcVRl23f1NWRFYuR/L3uTSBy2tLS5DQNeMIl4IQ4QV2E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

 This is  to prevent unnecessary scanning of short lived tasks
to reduce CPU burning.

Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/kscand.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/kscand.c b/mm/kscand.c
index 39a7fcef7de8..880c3693866d 100644
--- a/mm/kscand.c
+++ b/mm/kscand.c
@@ -28,6 +28,7 @@
 
 static struct task_struct *kscand_thread __read_mostly;
 static DEFINE_MUTEX(kscand_mutex);
+extern unsigned int sysctl_numa_balancing_scan_delay;
 
 /*
  * Total VMA size to cover during scan.
@@ -1010,6 +1011,7 @@ void __kscand_enter(struct mm_struct *mm)
 {
 	struct kscand_mm_slot *kscand_slot;
 	struct mm_slot *slot;
+	unsigned long now;
 	int wakeup;
 
 	/* __kscand_exit() must not run from under us */
@@ -1020,10 +1022,12 @@ void __kscand_enter(struct mm_struct *mm)
 	if (!kscand_slot)
 		return;
 
+	now = jiffies;
 	kscand_slot->address = 0;
 	kscand_slot->scan_period = kscand_mm_scan_period_ms;
 	kscand_slot->scan_size = kscand_scan_size;
-	kscand_slot->next_scan = 0;
+	kscand_slot->next_scan = now +
+			2 * msecs_to_jiffies(sysctl_numa_balancing_scan_delay);
 	kscand_slot->scan_delta = 0;
 
 	slot = &kscand_slot->slot;
-- 
2.34.1


