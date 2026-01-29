Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B054D61020
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 14:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC4246B008C; Thu, 29 Jan 2026 09:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97C06B0092; Thu, 29 Jan 2026 09:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B826B0093; Thu, 29 Jan 2026 09:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7AD6B008C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 09:42:49 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15D1B56B7B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:42:49 +0000 (UTC)
X-FDA: 84385268058.27.1DE2959
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011032.outbound.protection.outlook.com [40.107.208.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0FFC880002
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:42:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Jx42MoEt;
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769697766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPKPRhqVubgT7XuLatmNVZ4xiYAilvCkHbTukwGlSMk=;
	b=viM9b3XBqXpU+zs51S7EFosVxqaABh59ZdGQJ+RV5ZfCix9tzS8ZMoqUmzNgfdRzY1lGxl
	mS8BZonVLyl/8MZEAyRT5N39dZckyInzIuykDq+NL1uWseULN5KWIZwblOPBVtOa4KIhhd
	8nqD9CF/AK69CW152eTunCEszvVwK28=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Jx42MoEt;
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 40.107.208.32 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769697766; a=rsa-sha256;
	cv=pass;
	b=FiOR5jaaZQcvNqks03/YJprC1rvpT1k4yOX9HVw+WWcJcJRn5foZspxIsdVYqG9jg68m5M
	VUUrK8CXgQ30wQyzc3ACljGfJQapJNdJQvgbjiE2KyhYOhPQcUQcpnHF0VlfOUV5b0EX2t
	oIuAmgUxIPqPyfGarTwUAKIRB/7L0DI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vKMrtuA82xDCgPFVZeTyiME58waQxubsYwgFH5ESr8CiueaMplRxMsMdLxY3CSx4Cop3IAyYTI6xiL0gg8t4xeIIuSeOt1kJc9wn54yH5dZ55mShMhMS5uZ+TouRxbqcRiKfwz/5DsVscz8/Im/DrkOxTaTFWTIfG82oDWOgBJRVUtKI+TInPETYGakcAKTLNZlNv5XmkZdclCVtubGEnxwLxKbC7pG78VzlC5qAKofJ0/sc7yRVAaEwf0y9Q1/NsgIhIy36nMTR3PmkykN1hLjXwh8vtqy9m+DTitVwZT3d3NxauKjDgVlJTut5U+hg5++FmgR7uo3njHQ85jWZpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZPKPRhqVubgT7XuLatmNVZ4xiYAilvCkHbTukwGlSMk=;
 b=KJR/SBTXh9bgH36enoZN2e1liPZ4Ulhb5p455XJe2U+IGoi7ymS0MhMIgkgmBe5m2VVDCYJOQXZqrVqGDZlm7v6vWzjhLhLAKPTu1V8JNIdaBDOFMaRCm9/Whr+41P9JZk3js3hXOTd2AzoBnt2KjN2r7U+3TGxThbajjh//YwPuG15BnB3Exk28tFXnBH4gRdFWuBAor259HpeESXUh58tS9YDu3zDi6UXqWr/wV27FDTLYw9RKIOwcGjRG9jk838N5yHyom2fLPLIyZre3Hhu1mV9yCrHxL9x3fNRstLVdHBI3IzAnyT3FCC4APZ+JC0PQXsJNggbAVXfCnwwfYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZPKPRhqVubgT7XuLatmNVZ4xiYAilvCkHbTukwGlSMk=;
 b=Jx42MoEtiZHer0s0Raz6YSafj2pTAGKja2oLt4VLLITKJfgukgocgsT2USHDAGnE2KrjLDuixLt2bHWY3ZJ5DPbdB/4Hfc9xjeIfIeUbd30jwDhd+dqZBJPUyorqxu6D3IUM1h/PzSUYWuovdD6uW0sTSJJUDXBpO7vBoleeUKs=
Received: from SJ0PR13CA0173.namprd13.prod.outlook.com (2603:10b6:a03:2c7::28)
 by SJ0PR12MB8114.namprd12.prod.outlook.com (2603:10b6:a03:4e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Thu, 29 Jan
 2026 14:42:37 +0000
Received: from MWH0EPF000971E2.namprd02.prod.outlook.com
 (2603:10b6:a03:2c7:cafe::55) by SJ0PR13CA0173.outlook.office365.com
 (2603:10b6:a03:2c7::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.8 via Frontend Transport; Thu,
 29 Jan 2026 14:42:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000971E2.mail.protection.outlook.com (10.167.243.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Thu, 29 Jan 2026 14:42:37 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 29 Jan
 2026 08:42:28 -0600
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v5 03/10] mm: Hot page tracking and promotion
Date: Thu, 29 Jan 2026 20:10:36 +0530
Message-ID: <20260129144043.231636-4-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
References: <20260129144043.231636-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000971E2:EE_|SJ0PR12MB8114:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d948487-2963-4c2a-d04b-08de5f44a596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?C8c+y7W5nwk5Uspqd6FvRx4qwF0cUEG8b0cIVc2bOCzPgw8v1m9Fh7EZpQT4?=
 =?us-ascii?Q?Y/SC4S/60d4/QQ1RDqnzFbilmFevG56QVfgCQPOyFgKHKmKlFPVhF6JQ3ODJ?=
 =?us-ascii?Q?nCd8AiZce0VAxm+USnAIFDm4rQ2mnvGLDEQkbDMtwrLhOE+kA42BvvhHVzvu?=
 =?us-ascii?Q?u/Dsrqe8uPy/6Frs7q0ecvWtBphB8fl2ImHYPNYejLGt7zgbjkNvONdhPKAf?=
 =?us-ascii?Q?6/oNbRsG7zrdNnU8FuivL9GsghNNZcuxzVDujhIAnK8ky0ZxGtwU1bcDB0z2?=
 =?us-ascii?Q?yPsRZ7J6kKiMf2UMGM7xEy+3YpR5rozyTgKa+dNZyohNSHWM6d8KTzzpnYI6?=
 =?us-ascii?Q?gUqxYFqybjhRB2EVPFq1uOlnhj2CzG0YN7/+1BqrZMX678ME7TLM84ipFK03?=
 =?us-ascii?Q?6wWCvH1ApVDP5MchlDiQ6loohDYSYVL3ELG5k70NBxYgm/oKxKydY7uet649?=
 =?us-ascii?Q?Mgd07ytpAvFMEWM1aKSCX5tG6FLb7YgSfnqtK4hvIqikpbMV4a78twMpMU3D?=
 =?us-ascii?Q?J+AeOZXMlFwiwIhPaA5Z8ApUQROdTR/3tV3+hgDqa6k5JgTwIZXeshtDR75i?=
 =?us-ascii?Q?meDVTlldvtuMZafgNx2z/O9iWNMCK9V2jsUYHHPGvO1B3D8sZy8fZR/LXrVz?=
 =?us-ascii?Q?efCIShc3oA4Q0xcCIc2VX4hp7kUzd++ThW8JsMplJXjYxv/fiDu0R2FwAYcE?=
 =?us-ascii?Q?XBEnCPRRE5mt79OGW6P8u+BO2HRaMajI/L3STkAUEAcP/X62OsQ7EEVLqcpT?=
 =?us-ascii?Q?pKeGjfPXNwnrO8HptI4Wd1fY+w7PyuvRqbqJE2pDq2gtMl5gdGaM6Lkz9XjT?=
 =?us-ascii?Q?i/K4SlcEVgMUf+OPGCJBKaCdOjGtIAjJ8ckCSYCq3aItBJ8H15eXGT2z3OuM?=
 =?us-ascii?Q?nNPUpVKDoezk0mBrA2p14D62YT9TlnvwCBECJfW7fYzgpdnFP6e7kK7GSMHy?=
 =?us-ascii?Q?Pw8bkIOu7TN1qMVi7LJYwyKkUPoFRTEEmIZ3MhVX8RcPNCNpUFzmj4XX8ER4?=
 =?us-ascii?Q?9NQCr2NTsN1R5K/zicRjJlPTjF4RQWozz9lyxjW3kH5qCNpVlONCwPCMLHMo?=
 =?us-ascii?Q?wn/kctmJZm/mN8ZyZ6poFJRP2KyxJ08F3Z/Y6p4vLPaFdxBHvRZd1vGBoAJA?=
 =?us-ascii?Q?YkvC9pXPcECGV5Ph+e6uiwggl+3MzsAkmUbNiAQFQ4aaxmQt+byoCkCJvF4p?=
 =?us-ascii?Q?RvWxZOod5xdwiy10GWaFbX83YAG5us+hyeSLSrKyCZuQVAYy7pgscTSzKhwh?=
 =?us-ascii?Q?5y/bTt1hyPCs9kegahRlhYA8Jdweq3JwptDfPqnwTJtGkmlEdv4jmGXaZfIa?=
 =?us-ascii?Q?F0D6WsgRDf71k18C4grxyDFOM72u8yUCerfLQcjhnX8RkYFclmnuQUuAtOGR?=
 =?us-ascii?Q?XT59GZOhaqgyS7yWSMkPWloCkqW3i8B/Nkio5QCGAuKh7vkZ4eYHg0DyNKlE?=
 =?us-ascii?Q?reA4ewkciertTQIlrj/wDgKMGLAvCn7BmlaAk42A1pfqvh6LpkWxjRWZYOzC?=
 =?us-ascii?Q?QhhHamyJ9EF8If1/Bd8lywpFFjdB48kz3yFQjRr8ulRAlBB5mMVms5Z59qCv?=
 =?us-ascii?Q?MaQWwJl1ShZs9S0lvmPnfaK/cLeM3B1ykJYUeSZjdglg7UkWh+44lxL9UnI7?=
 =?us-ascii?Q?Ipm9hpjoz643CgkvyZdEbh56hkRry7pyzDNLm5UyDxCab/Co9svjWpFMe8tK?=
 =?us-ascii?Q?XTL+ew=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2026 14:42:37.2615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d948487-2963-4c2a-d04b-08de5f44a596
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000971E2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8114
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0FFC880002
X-Stat-Signature: 6g4gs7crmczgcp1imam5cg81jnz7n51x
X-Rspam-User: 
X-HE-Tag: 1769697765-36730
X-HE-Meta: U2FsdGVkX1+uryuzi1OCwIVuQetyllgtBbsiWdfGnJ4UB3BJgy4bHBJHs6Yg0/dWWgXens62CzRd6Kgk68pIPxnCbnY4LSJq1RbTQyqJ/cYrX2C2CDfB5/VrTYDPe19DMKphnoo6rV+96GxG91ntvZ8FU5AimN69uSanSh5wt0XhlHT/kh7yomFmD0UnjZMzhb3hdNltMjYsIz9cgpr7giub4131InJoFa4FaPYmYTxzTZO7Mzq0+16wCbEf3ARHWOji/XK1nVJrS90So3htL9HI/FiiqB/Gqv/Q8enCXvyvP3GU6iJzRQ0eN160iHkCoQ/wf9pxttQqlmL7dJW9W5x8xRW51aLkn+FhIRTw22adCK7gEUIfx5MVDDnaTSJGeJdswedkpHqfxmFE2DXCdhZmi6cEQtcY1C6+m95IRMn2qRzp590GSjjTyy/K8ad1TBczSVW4YEAPjB1b5h3iSxeQz7crjz9QzUTWZoem9B9aVOl6pmlhzIgBda7C/pyjEQZVaRSup+zk7bAyfa7dt0GdM0qbt4RlYT/fVBn3IeroOqdLnf/SA/mDMaHufGlIxCy1F3od6SbkbuDEPXEmbFgCt1tUL8kvvhZOD3x9ud5Ty/t0HPM6j1Y/DXNfOGJ/PgWhBJ49syTSVO066ycrFwjrEmCyNx/XlmsUiLzgU2ojlGIxRZuHVwCXhDbGcXI6MpM1IqfRVkoLjanGs3Yq0buHAZz66JFas5/mau6Sl4DRaIu2+x8VRGP5TzJvjrcqAezSQSglXD0M7kv48LvBBydXF9G2QEx4l9x28ewiKWMRrhyJQZ9WSCnOG3zVRMHv0EAKEO6c2qKe/PctGgpqX/htSjTqAv2FNnvl7DYetBb8DFA6rGOGRB8/L0BjrjOrRwGOIMhlywybVt3RFhBSRtaRKffRJrDYo/Mphb8HsxVuRlz7UvuP/WON1WcgEhMIArXXZs/VsZjYTUOjKJX
 qnBMbR15
 qbCFLF5x3n3iCiUm0DnJZNZ9u9Ly/dhsF9hrNhya4VOe9FkL/hMbFzcJY4kx59cg+jPVTNJy+e0+1XRvmB1QHHMxj/CFR0fNk0/98c01RRuSeN4axzE8fme7hmd366aENnb4d/ch1Fac0P5I4nW1RXSWBljra2YGi46DabqOAopCfWCw23xsU7tVYNNWxZMeEgXa/9pjkL/dnRd+LIaF/ymyXLBOfafO427+wUEe51qBJDTWaTfj3m3lmIgxTqna0wBRcIR8PKnWhl5N9y1yd7IesadKJTEecRSiThnP63ojVhfACliXCQ8gX4H7TT8Mzq01rpPjqH59uPl5W8EYM+jfJrsYwqBDm18Gbl4N3gjFmfMNPyuCWqigLceeESAF362QOHgyZCLjPFZm7Pa7bZqgkB94R5/3jeSQYuEXv1fCprvGGew0DMe/XU2LD4OfOQDGGg4QX2kMlsJBin9yeS5cAhr87qssxecoRJnrkbCC1upte1GhJEmvXHTSoQB1uQH/DjpTds78CwaxoOUVwEau2hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This introduces a subsystem for collecting memory access
information from different sources. It maintains the hotness
information based on the access history and time of access.

Additionally, it provides per-lower-tier-node kernel threads
(named kmigrated) that periodically promote the pages that
are eligible for promotion.

Sub-systems that generate hot page access info can report that
using this API:

int pghot_record_access(unsigned long pfn, int nid, int src,
                        unsigned long time)

@pfn: The PFN of the memory accessed
@nid: The accessing NUMA node ID
@src: The temperature source (subsystem) that generated the
      access info
@time: The access time in jiffies

Some temperature sources may not provide the nid from which
the page was accessed. This is true for sources that use
page table scanning for PTE Accessed bit. For such sources,
a configurable/default toptier node is used as promotion
target.

The hotness information is stored for every page of lower
tier memory in a u8 variable (1 byte) that is part of
mem_section data structure.

kmigrated is a per-lower-tier-node kernel thread that migrates
the folios marked for migration in batches. Each kmigrated
thread walks the PFN range spanning its node and checks
for potential migration candidates.

A bunch of tunables for enabling different hotness sources,
setting target_nid, frequency threshold are provided in debugfs.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/pghot.txt |  84 ++++++
 include/linux/mmzone.h                 |  21 ++
 include/linux/pghot.h                  |  94 +++++++
 include/linux/vm_event_item.h          |   6 +
 mm/Kconfig                             |  14 +
 mm/Makefile                            |   1 +
 mm/mm_init.c                           |  10 +
 mm/pghot-default.c                     |  73 +++++
 mm/pghot-tunables.c                    | 189 +++++++++++++
 mm/pghot.c                             | 370 +++++++++++++++++++++++++
 mm/vmstat.c                            |   6 +
 11 files changed, 868 insertions(+)
 create mode 100644 Documentation/admin-guide/mm/pghot.txt
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/pghot-default.c
 create mode 100644 mm/pghot-tunables.c
 create mode 100644 mm/pghot.c

diff --git a/Documentation/admin-guide/mm/pghot.txt b/Documentation/admin-guide/mm/pghot.txt
new file mode 100644
index 000000000000..01291b72e7ab
--- /dev/null
+++ b/Documentation/admin-guide/mm/pghot.txt
@@ -0,0 +1,84 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
+PGHOT: Hot Page Tracking Tunables
+=================================
+
+Overview
+========
+The PGHOT subsystem tracks frequently accessed pages in lower-tier memory and
+promotes them to faster tiers. It uses per-PFN hotness metadata and asynchronous
+migration via per-node kernel threads (kmigrated).
+
+This document describes tunables available via **debugfs** and **sysctl** for
+PGHOT.
+
+Debugfs Interface
+=================
+Path: /sys/kernel/debug/pghot/
+
+1. **enabled_sources**
+   - Bitmask to enable/disable hotness sources.
+   - Bits:
+     - 0: Hardware hints (value 0x1)
+     - 1: Page table scan (value 0x2)
+     - 2: Hint faults (value 0x4)
+   - Default: 0 (disabled)
+   - Example:
+     # echo 0x7 > /sys/kernel/debug/pghot/enabled_sources
+     Enables all sources.
+
+2. **target_nid**
+   - Toptier NUMA node ID to which hot pages should be promoted when source
+     does not provide nid. Used when hotness source can't provide accessing
+     NID or when the tracking mode is default.
+   - Default: 0
+   - Example:
+     # echo 1 > /sys/kernel/debug/pghot/target_nid
+
+3. **freq_threshold**
+   - Minimum access frequency before a page is marked ready for promotion.
+   - Range: 1 to 3
+   - Default: 2
+   - Example:
+     # echo 3 > /sys/kernel/debug/pghot/freq_threshold
+
+4. **kmigrated_sleep_ms**
+   - Sleep interval (ms) for kmigrated thread between scans.
+   - Default: 100
+
+5. **kmigrated_batch_nr**
+   - Maximum number of folios migrated in one batch.
+   - Default: 512
+
+Sysctl Interface
+================
+1. pghot_promote_freq_window_ms
+
+Path: /proc/sys/vm/pghot_promote_freq_window_ms
+
+- Controls the time window (in ms) for counting access frequency. A page is
+  considered hot only when **freq_threshold** number of accesses occur with
+  this time period.
+- Default: 4000 (4 seconds)
+- Example:
+  # sysctl vm.pghot_promote_freq_window_ms=3000
+
+Vmstat Counters
+===============
+Following vmstat counters provide some stats about pghot subsystem.
+
+Path: /proc/vmstat
+
+1. **pghot_recorded_accesses**
+   - Number of total hot page accesses recorded by pghot.
+
+2. **pghot_recorded_hwhints**
+   - Number of recorded accesses reported by hwhints source.
+
+3. **pghot_recorded_pgtscans**
+   - Number of recorded accesses reported by PTE A-bit based source.
+
+4. **pghot_recorded_hintfaults**
+   - Number of recorded accesses reported by NUMA Balancing based
+     hotness source.
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 75ef7c9f9307..22e08befb096 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1064,6 +1064,7 @@ enum pgdat_flags {
 					 * many pages under writeback
 					 */
 	PGDAT_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
+	PGDAT_KMIGRATED_ACTIVATE,	/* activates kmigrated */
 };
 
 enum zone_flags {
@@ -1518,6 +1519,10 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_PGHOT
+	struct task_struct *kmigrated;
+	wait_queue_head_t kmigrated_wait;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
@@ -1916,12 +1921,28 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
+#ifdef CONFIG_PGHOT
+	/*
+	 * Per-PFN hotness data for this section.
+	 * Array of phi_t (u8 in default mode).
+	 * LSB is used as PGHOT_SECTION_HOT_BIT flag.
+	 */
+	void *hot_map;
+#endif
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
+#endif
+	/*
+	 * Padding to maintain consistent mem_section size when exactly
+	 * one of PGHOT or PAGE_EXTENSION is enabled. This ensures
+	 * optimal alignment regardless of configuration.
+	 */
+#if (defined(CONFIG_PGHOT) && !defined(CONFIG_PAGE_EXTENSION)) || \
+		(!defined(CONFIG_PGHOT) && defined(CONFIG_PAGE_EXTENSION))
 	unsigned long pad;
 #endif
 	/*
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
new file mode 100644
index 000000000000..88e57aab697b
--- /dev/null
+++ b/include/linux/pghot.h
@@ -0,0 +1,94 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGHOT_H
+#define _LINUX_PGHOT_H
+
+/* Page hotness temperature sources */
+enum pghot_src {
+	PGHOT_HW_HINTS,
+	PGHOT_PGTABLE_SCAN,
+	PGHOT_HINT_FAULT,
+};
+
+#ifdef CONFIG_PGHOT
+#include <linux/static_key.h>
+
+extern unsigned int pghot_target_nid;
+extern unsigned int pghot_src_enabled;
+extern unsigned int pghot_freq_threshold;
+extern unsigned int kmigrated_sleep_ms;
+extern unsigned int kmigrated_batch_nr;
+extern unsigned int sysctl_pghot_freq_window;
+
+void pghot_debug_init(void);
+
+DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
+DECLARE_STATIC_KEY_FALSE(pghot_src_pgtscans);
+DECLARE_STATIC_KEY_FALSE(pghot_src_hintfaults);
+
+/*
+ * Bit positions to enable individual sources in pghot/records_enabled
+ * of debugfs.
+ */
+enum pghot_src_enabled {
+	PGHOT_HWHINTS_BIT = 0,
+	PGHOT_PGTSCAN_BIT,
+	PGHOT_HINTFAULT_BIT,
+	PGHOT_MAX_BIT
+};
+
+#define PGHOT_HWHINTS_ENABLED		BIT(PGHOT_HWHINTS_BIT)
+#define PGHOT_PGTSCAN_ENABLED		BIT(PGHOT_PGTSCAN_BIT)
+#define PGHOT_HINTFAULT_ENABLED		BIT(PGHOT_HINTFAULT_BIT)
+#define PGHOT_SRC_ENABLED_MASK		GENMASK(PGHOT_MAX_BIT - 1, 0)
+
+#define PGHOT_DEFAULT_FREQ_THRESHOLD	2
+
+#define KMIGRATED_DEFAULT_SLEEP_MS	100
+#define KMIGRATED_DEFAULT_BATCH_NR	512
+
+#define PGHOT_DEFAULT_NODE		0
+
+#define PGHOT_DEFAULT_FREQ_WINDOW	(4 * MSEC_PER_SEC)
+
+/*
+ * Bits 0-6 are used to store frequency and time.
+ * Bit 7 is used to indicate the page is ready for migration.
+ */
+#define PGHOT_MIGRATE_READY		7
+
+#define PGHOT_FREQ_WIDTH		2
+/* Bucketed time is stored in 5 bits which can represent up to 4s with HZ=1000 */
+#define PGHOT_TIME_BUCKETS_WIDTH	7
+#define PGHOT_TIME_WIDTH		5
+#define PGHOT_NID_WIDTH			10
+
+#define PGHOT_FREQ_SHIFT		0
+#define PGHOT_TIME_SHIFT		(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
+
+#define PGHOT_FREQ_MASK			GENMASK(PGHOT_FREQ_WIDTH - 1, 0)
+#define PGHOT_TIME_MASK			GENMASK(PGHOT_TIME_WIDTH - 1, 0)
+#define PGHOT_TIME_BUCKETS_MASK		(PGHOT_TIME_MASK << PGHOT_TIME_BUCKETS_WIDTH)
+
+#define PGHOT_NID_MAX			((1 << PGHOT_NID_WIDTH) - 1)
+#define PGHOT_FREQ_MAX			((1 << PGHOT_FREQ_WIDTH) - 1)
+#define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
+
+typedef u8 phi_t;
+
+#define PGHOT_RECORD_SIZE		sizeof(phi_t)
+
+#define PGHOT_SECTION_HOT_BIT		0
+#define PGHOT_SECTION_HOT_MASK		BIT(PGHOT_SECTION_HOT_BIT)
+
+unsigned long pghot_access_latency(unsigned long old_time, unsigned long time);
+bool pghot_update_record(phi_t *phi, int nid, unsigned long now);
+int pghot_get_record(phi_t *phi, int *nid, int *freq, unsigned long *time);
+
+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now);
+#else
+static inline int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
+{
+	return 0;
+}
+#endif /* CONFIG_PGHOT */
+#endif /* _LINUX_PGHOT_H */
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 92f80b4d69a6..5b8fd93b55fd 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -188,6 +188,12 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_PGHOT
+		PGHOT_RECORDED_ACCESSES,
+		PGHOT_RECORD_HWHINTS,
+		PGHOT_RECORD_PGTSCANS,
+		PGHOT_RECORD_HINTFAULTS,
+#endif /* CONFIG_PGHOT */
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/Kconfig b/mm/Kconfig
index bd0ea5454af8..f4f0147faac5 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1464,6 +1464,20 @@ config PT_RECLAIM
 config FIND_NORMAL_PAGE
 	def_bool n
 
+config PGHOT
+	bool "Hot page tracking and promotion"
+	def_bool n
+	depends on NUMA && MIGRATION && SPARSEMEM && MMU
+	help
+	  A sub-system to track page accesses in lower tier memory and
+	  maintain hot page information. Promotes hot pages from lower
+	  tiers to top tier by using the memory access information provided
+	  by various sources. Asynchronous promotion is done by per-node
+	  kernel threads.
+
+	  This adds 1 byte of metadata overhead per page in lower-tier
+	  memory nodes.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 2d0570a16e5b..655a27f3a215 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
+obj-$(CONFIG_PGHOT) += pghot.o pghot-tunables.o pghot-default.o
diff --git a/mm/mm_init.c b/mm/mm_init.c
index fc2a6f1e518f..64109feaa1c3 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1401,6 +1401,15 @@ static void pgdat_init_kcompactd(struct pglist_data *pgdat)
 static void pgdat_init_kcompactd(struct pglist_data *pgdat) {}
 #endif
 
+#ifdef CONFIG_PGHOT
+static void pgdat_init_kmigrated(struct pglist_data *pgdat)
+{
+	init_waitqueue_head(&pgdat->kmigrated_wait);
+}
+#else
+static inline void pgdat_init_kmigrated(struct pglist_data *pgdat) {}
+#endif
+
 static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 {
 	int i;
@@ -1410,6 +1419,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 
 	pgdat_init_split_queue(pgdat);
 	pgdat_init_kcompactd(pgdat);
+	pgdat_init_kmigrated(pgdat);
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
diff --git a/mm/pghot-default.c b/mm/pghot-default.c
new file mode 100644
index 000000000000..e0a3b2ed2592
--- /dev/null
+++ b/mm/pghot-default.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pghot: Default mode
+ *
+ * 1 byte hotness record per PFN.
+ * Bucketed time and frequency tracked as part of the record.
+ * Promotion to @pghot_target_nid by default.
+ */
+
+#include <linux/pghot.h>
+#include <linux/jiffies.h>
+
+/*
+ * @time is regular time, @old_time is bucketed time.
+ */
+unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
+{
+	time &= PGHOT_TIME_BUCKETS_MASK;
+	old_time <<= PGHOT_TIME_BUCKETS_WIDTH;
+
+	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_BUCKETS_MASK);
+}
+
+bool pghot_update_record(phi_t *phi, int nid, unsigned long now)
+{
+	phi_t freq, old_freq, hotness, old_hotness, old_time;
+	phi_t time = now >> PGHOT_TIME_BUCKETS_WIDTH;
+
+	old_hotness = READ_ONCE(*phi);
+	do {
+		bool new_window = false;
+
+		hotness = old_hotness;
+		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+
+		if (pghot_access_latency(old_time, now) > sysctl_pghot_freq_window)
+			new_window = true;
+
+		if (new_window)
+			freq = 1;
+		else if (old_freq < PGHOT_FREQ_MAX)
+			freq = old_freq + 1;
+		else
+			freq = old_freq;
+
+		hotness &= ~(PGHOT_FREQ_MASK << PGHOT_FREQ_SHIFT);
+		hotness &= ~(PGHOT_TIME_MASK << PGHOT_TIME_SHIFT);
+
+		hotness |= (freq & PGHOT_FREQ_MASK) << PGHOT_FREQ_SHIFT;
+		hotness |= (time & PGHOT_TIME_MASK) << PGHOT_TIME_SHIFT;
+
+		if (freq >= pghot_freq_threshold)
+			hotness |= BIT(PGHOT_MIGRATE_READY);
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+	return !!(hotness & BIT(PGHOT_MIGRATE_READY));
+}
+
+int pghot_get_record(phi_t *phi, int *nid, int *freq, unsigned long *time)
+{
+	phi_t old_hotness, hotness = 0;
+
+	old_hotness = READ_ONCE(*phi);
+	do {
+		if (!(old_hotness & BIT(PGHOT_MIGRATE_READY)))
+			return -EINVAL;
+	} while (unlikely(!try_cmpxchg(phi, &old_hotness, hotness)));
+
+	*nid = pghot_target_nid;
+	*freq = (old_hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+	*time = (old_hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+	return 0;
+}
diff --git a/mm/pghot-tunables.c b/mm/pghot-tunables.c
new file mode 100644
index 000000000000..79afbcb1e4f0
--- /dev/null
+++ b/mm/pghot-tunables.c
@@ -0,0 +1,189 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pghot tunables in debugfs
+ */
+#include <linux/pghot.h>
+#include <linux/memory-tiers.h>
+#include <linux/debugfs.h>
+
+static struct dentry *debugfs_pghot;
+static DEFINE_MUTEX(pghot_tunables_lock);
+
+static ssize_t pghot_freq_th_write(struct file *filp, const char __user *ubuf,
+				   size_t cnt, loff_t *ppos)
+{
+	char buf[16];
+	unsigned int freq;
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+
+	if (kstrtouint(buf, 10, &freq))
+		return -EINVAL;
+
+	if (!freq || freq > PGHOT_FREQ_MAX)
+		return -EINVAL;
+
+	mutex_lock(&pghot_tunables_lock);
+	pghot_freq_threshold = freq;
+	mutex_unlock(&pghot_tunables_lock);
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int pghot_freq_th_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", pghot_freq_threshold);
+	return 0;
+}
+
+static int pghot_freq_th_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, pghot_freq_th_show, NULL);
+}
+
+static const struct file_operations pghot_freq_th_fops = {
+	.open		= pghot_freq_th_open,
+	.write		= pghot_freq_th_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static ssize_t pghot_target_nid_write(struct file *filp, const char __user *ubuf,
+				      size_t cnt, loff_t *ppos)
+{
+	char buf[16];
+	unsigned int nid;
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+
+	if (kstrtouint(buf, 10, &nid))
+		return -EINVAL;
+
+	if (nid > PGHOT_NID_MAX || !node_online(nid) || !node_is_toptier(nid))
+		return -EINVAL;
+	mutex_lock(&pghot_tunables_lock);
+	pghot_target_nid = nid;
+	mutex_unlock(&pghot_tunables_lock);
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int pghot_target_nid_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", pghot_target_nid);
+	return 0;
+}
+
+static int pghot_target_nid_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, pghot_target_nid_show, NULL);
+}
+
+static const struct file_operations pghot_target_nid_fops = {
+	.open		= pghot_target_nid_open,
+	.write		= pghot_target_nid_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static void pghot_src_enabled_update(unsigned int enabled)
+{
+	unsigned int changed = pghot_src_enabled ^ enabled;
+
+	if (changed & PGHOT_HWHINTS_ENABLED) {
+		if (enabled & PGHOT_HWHINTS_ENABLED)
+			static_branch_enable(&pghot_src_hwhints);
+		else
+			static_branch_disable(&pghot_src_hwhints);
+	}
+
+	if (changed & PGHOT_PGTSCAN_ENABLED) {
+		if (enabled & PGHOT_PGTSCAN_ENABLED)
+			static_branch_enable(&pghot_src_pgtscans);
+		else
+			static_branch_disable(&pghot_src_pgtscans);
+	}
+
+	if (changed & PGHOT_HINTFAULT_ENABLED) {
+		if (enabled & PGHOT_HINTFAULT_ENABLED)
+			static_branch_enable(&pghot_src_hintfaults);
+		else
+			static_branch_disable(&pghot_src_hintfaults);
+	}
+}
+
+static ssize_t pghot_src_enabled_write(struct file *filp, const char __user *ubuf,
+					   size_t cnt, loff_t *ppos)
+{
+	char buf[16];
+	unsigned int enabled;
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+
+	if (kstrtouint(buf, 0, &enabled))
+		return -EINVAL;
+
+	if (enabled & ~PGHOT_SRC_ENABLED_MASK)
+		return -EINVAL;
+
+	mutex_lock(&pghot_tunables_lock);
+	pghot_src_enabled_update(enabled);
+	pghot_src_enabled = enabled;
+	mutex_unlock(&pghot_tunables_lock);
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int pghot_src_enabled_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", pghot_src_enabled);
+	return 0;
+}
+
+static int pghot_src_enabled_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, pghot_src_enabled_show, NULL);
+}
+
+static const struct file_operations pghot_src_enabled_fops = {
+	.open		= pghot_src_enabled_open,
+	.write		= pghot_src_enabled_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+void pghot_debug_init(void)
+{
+	debugfs_pghot = debugfs_create_dir("pghot", NULL);
+	debugfs_create_file("enabled_sources", 0644, debugfs_pghot, NULL,
+			    &pghot_src_enabled_fops);
+	debugfs_create_file("target_nid", 0644, debugfs_pghot, NULL,
+			    &pghot_target_nid_fops);
+	debugfs_create_file("freq_threshold", 0644, debugfs_pghot, NULL,
+			    &pghot_freq_th_fops);
+	debugfs_create_u32("kmigrated_sleep_ms", 0644, debugfs_pghot,
+			    &kmigrated_sleep_ms);
+	debugfs_create_u32("kmigrated_batch_nr", 0644, debugfs_pghot,
+			    &kmigrated_batch_nr);
+}
diff --git a/mm/pghot.c b/mm/pghot.c
new file mode 100644
index 000000000000..95b5012d5b99
--- /dev/null
+++ b/mm/pghot.c
@@ -0,0 +1,370 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Maintains information about hot pages from slower tier nodes and
+ * promotes them.
+ *
+ * Per-PFN hotness information is stored for lower tier nodes in
+ * mem_section.
+ *
+ * In the default mode, a single byte (u8) is used to store
+ * the frequency of access and last access time. Promotions are done
+ * to a default toptier NID.
+ *
+ * A kernel thread named kmigrated is provided to migrate or promote
+ * the hot pages. kmigrated runs for each lower tier node. It iterates
+ * over the node's PFNs and  migrates pages marked for migration into
+ * their targeted nodes.
+ */
+#include <linux/mm.h>
+#include <linux/migrate.h>
+#include <linux/memory-tiers.h>
+#include <linux/pghot.h>
+
+unsigned int pghot_target_nid = PGHOT_DEFAULT_NODE;
+unsigned int pghot_src_enabled;
+unsigned int pghot_freq_threshold = PGHOT_DEFAULT_FREQ_THRESHOLD;
+unsigned int kmigrated_sleep_ms = KMIGRATED_DEFAULT_SLEEP_MS;
+unsigned int kmigrated_batch_nr = KMIGRATED_DEFAULT_BATCH_NR;
+
+unsigned int sysctl_pghot_freq_window = PGHOT_DEFAULT_FREQ_WINDOW;
+
+DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
+DEFINE_STATIC_KEY_FALSE(pghot_src_pgtscans);
+DEFINE_STATIC_KEY_FALSE(pghot_src_hintfaults);
+
+#ifdef CONFIG_SYSCTL
+static const struct ctl_table pghot_sysctls[] = {
+	{
+		.procname       = "pghot_promote_freq_window_ms",
+		.data           = &sysctl_pghot_freq_window,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+	},
+};
+#endif
+
+static bool kmigrated_started __ro_after_init;
+
+/**
+ * pghot_record_access() - Record page accesses from lower tier memory
+ * for the purpose of tracking page hotness and subsequent promotion.
+ *
+ * @pfn: PFN of the page
+ * @nid: Unused
+ * @src: The identifier of the sub-system that reports the access
+ * @now: Access time in jiffies
+ *
+ * Updates the frequency and time of access and marks the page as
+ * ready for migration if the frequency crosses a threshold. The pages
+ * marked for migration are migrated by kmigrated kernel thread.
+ *
+ * Return: 0 on success and -EINVAL on failure to record the access.
+ */
+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
+{
+	struct mem_section *ms;
+	struct folio *folio;
+	phi_t *phi, *hot_map;
+	struct page *page;
+
+	if (!kmigrated_started)
+		return -EINVAL;
+
+	if (nid >= PGHOT_NID_MAX)
+		return -EINVAL;
+
+	switch (src) {
+	case PGHOT_HW_HINTS:
+		if (!static_branch_likely(&pghot_src_hwhints))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_HWHINTS);
+		break;
+	case PGHOT_PGTABLE_SCAN:
+		if (!static_branch_likely(&pghot_src_pgtscans))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_PGTSCANS);
+		break;
+	case PGHOT_HINT_FAULT:
+		if (!static_branch_likely(&pghot_src_hintfaults))
+			return -EINVAL;
+		count_vm_event(PGHOT_RECORD_HINTFAULTS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Record only accesses from lower tiers.
+	 */
+	if (node_is_toptier(pfn_to_nid(pfn)))
+		return 0;
+
+	/*
+	 * Reject the non-migratable pages right away.
+	 */
+	page = pfn_to_online_page(pfn);
+	if (!page || is_zone_device_page(page))
+		return 0;
+
+	folio = page_folio(page);
+	if (!folio_test_lru(folio))
+		return 0;
+
+	/* Get the hotness slot corresponding to the 1st PFN of the folio */
+	pfn = folio_pfn(folio);
+	ms = __pfn_to_section(pfn);
+	if (!ms || !ms->hot_map)
+		return -EINVAL;
+
+	hot_map = (phi_t *)(((unsigned long)(ms->hot_map)) & ~PGHOT_SECTION_HOT_MASK);
+	phi = &hot_map[pfn % PAGES_PER_SECTION];
+
+	count_vm_event(PGHOT_RECORDED_ACCESSES);
+
+	/*
+	 * Update the hotness parameters.
+	 */
+	if (pghot_update_record(phi, nid, now)) {
+		set_bit(PGHOT_SECTION_HOT_BIT, (unsigned long *)&ms->hot_map);
+		set_bit(PGDAT_KMIGRATED_ACTIVATE, &page_pgdat(page)->flags);
+	}
+	return 0;
+}
+
+static int pghot_get_hotness(unsigned long pfn, int *nid, int *freq,
+			     unsigned long *time)
+{
+	phi_t *phi, *hot_map;
+	struct mem_section *ms;
+
+	ms = __pfn_to_section(pfn);
+	if (!ms || !ms->hot_map)
+		return -EINVAL;
+
+	hot_map = (phi_t *)(((unsigned long)(ms->hot_map)) & ~PGHOT_SECTION_HOT_MASK);
+	phi = &hot_map[pfn % PAGES_PER_SECTION];
+
+	return pghot_get_record(phi, nid, freq, time);
+}
+
+/*
+ * Walks the PFNs of the zone, isolates and migrates them in batches.
+ */
+static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
+				int src_nid)
+{
+	int cur_nid = NUMA_NO_NODE;
+	LIST_HEAD(migrate_list);
+	int batch_count = 0;
+	struct folio *folio;
+	struct page *page;
+	unsigned long pfn;
+
+	pfn = start_pfn;
+	do {
+		int nid = NUMA_NO_NODE, nr = 1;
+		int freq = 0;
+		unsigned long time = 0;
+
+		if (!pfn_valid(pfn))
+			goto out_next;
+
+		page = pfn_to_online_page(pfn);
+		if (!page)
+			goto out_next;
+
+		folio = page_folio(page);
+		nr = folio_nr_pages(folio);
+		if (folio_nid(folio) != src_nid)
+			goto out_next;
+
+		if (!folio_test_lru(folio))
+			goto out_next;
+
+		if (pghot_get_hotness(pfn, &nid, &freq, &time))
+			goto out_next;
+
+		if (nid == NUMA_NO_NODE)
+			nid = pghot_target_nid;
+
+		if (folio_nid(folio) == nid)
+			goto out_next;
+
+		if (migrate_misplaced_folio_prepare(folio, NULL, nid))
+			goto out_next;
+
+		if (cur_nid == NUMA_NO_NODE)
+			cur_nid = nid;
+
+		/* If NID changed, flush the previous batch first */
+		if (cur_nid != nid) {
+			if (!list_empty(&migrate_list))
+				migrate_misplaced_folios_batch(&migrate_list, cur_nid);
+			cur_nid = nid;
+			batch_count = 0;
+			cond_resched();
+		}
+
+		list_add(&folio->lru, &migrate_list);
+
+		if (++batch_count > kmigrated_batch_nr) {
+			migrate_misplaced_folios_batch(&migrate_list, cur_nid);
+			batch_count = 0;
+			cond_resched();
+		}
+out_next:
+		pfn += nr;
+	} while (pfn < end_pfn);
+	if (!list_empty(&migrate_list))
+		migrate_misplaced_folios_batch(&migrate_list, cur_nid);
+}
+
+static void kmigrated_do_work(pg_data_t *pgdat)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct mem_section *ms;
+	int nid;
+
+	clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
+	/* s_begin = first_present_section_nr(); */
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		start_pfn = section_nr_to_pfn(section_nr);
+		ms = __nr_to_section(section_nr);
+
+		if (!pfn_valid(start_pfn))
+			continue;
+
+		nid = pfn_to_nid(start_pfn);
+		if (node_is_toptier(nid) || nid != pgdat->node_id)
+			continue;
+
+		if (!test_and_clear_bit(PGHOT_SECTION_HOT_BIT, (unsigned long *)&ms->hot_map))
+			continue;
+
+		kmigrated_walk_zone(start_pfn, start_pfn + PAGES_PER_SECTION,
+				    pgdat->node_id);
+	}
+}
+
+static inline bool kmigrated_work_requested(pg_data_t *pgdat)
+{
+	return test_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
+}
+
+/*
+ * Per-node kthread that iterates over its PFNs and migrates the
+ * pages that have been marked for migration.
+ */
+static int kmigrated(void *p)
+{
+	long timeout = msecs_to_jiffies(kmigrated_sleep_ms);
+	pg_data_t *pgdat = p;
+
+	while (!kthread_should_stop()) {
+		if (wait_event_timeout(pgdat->kmigrated_wait, kmigrated_work_requested(pgdat),
+				       timeout))
+			kmigrated_do_work(pgdat);
+	}
+	return 0;
+}
+
+static int kmigrated_run(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int ret;
+
+	if (node_is_toptier(nid))
+		return 0;
+
+	if (!pgdat->kmigrated) {
+		pgdat->kmigrated = kthread_create_on_node(kmigrated, pgdat, nid,
+							  "kmigrated%d", nid);
+		if (IS_ERR(pgdat->kmigrated)) {
+			ret = PTR_ERR(pgdat->kmigrated);
+			pgdat->kmigrated = NULL;
+			pr_err("Failed to start kmigrated%d, ret %d\n", nid, ret);
+			return ret;
+		}
+		pr_info("pghot: Started kmigrated thread for node %d\n", nid);
+	}
+	wake_up_process(pgdat->kmigrated);
+	return 0;
+}
+
+static void pghot_free_hot_map(void)
+{
+	unsigned long section_nr, s_begin;
+	struct mem_section *ms;
+
+	/* s_begin = first_present_section_nr(); */
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		kfree(ms->hot_map);
+	}
+}
+
+static int pghot_alloc_hot_map(void)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct mem_section *ms;
+	int nid;
+
+	/* s_begin = first_present_section_nr(); */
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		start_pfn = section_nr_to_pfn(section_nr);
+		nid = pfn_to_nid(start_pfn);
+
+		if (node_is_toptier(nid) || !pfn_valid(start_pfn))
+			continue;
+
+		ms->hot_map = kcalloc_node(PAGES_PER_SECTION, PGHOT_RECORD_SIZE, GFP_KERNEL,
+					   nid);
+		if (!ms->hot_map)
+			goto out_free_hot_map;
+	}
+	return 0;
+
+out_free_hot_map:
+	pghot_free_hot_map();
+	return -ENOMEM;
+}
+
+static int __init pghot_init(void)
+{
+	pg_data_t *pgdat;
+	int nid, ret;
+
+	ret = pghot_alloc_hot_map();
+	if (ret)
+		return ret;
+
+	for_each_node_state(nid, N_MEMORY) {
+		ret = kmigrated_run(nid);
+		if (ret)
+			goto out_stop_kthread;
+	}
+	register_sysctl_init("vm", pghot_sysctls);
+	pghot_debug_init();
+
+	kmigrated_started = true;
+	return 0;
+
+out_stop_kthread:
+	for_each_node_state(nid, N_MEMORY) {
+		pgdat = NODE_DATA(nid);
+		if (pgdat->kmigrated) {
+			kthread_stop(pgdat->kmigrated);
+			pgdat->kmigrated = NULL;
+		}
+	}
+	pghot_free_hot_map();
+	return ret;
+}
+
+late_initcall_sync(pghot_init)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 65de88cdf40e..f6f91b9dd887 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1501,6 +1501,12 @@ const char * const vmstat_text[] = {
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
 #endif
+#ifdef CONFIG_PGHOT
+	[I(PGHOT_RECORDED_ACCESSES)]		= "pghot_recorded_accesses",
+	[I(PGHOT_RECORD_HWHINTS)]		= "pghot_recorded_hwhints",
+	[I(PGHOT_RECORD_PGTSCANS)]		= "pghot_recorded_pgtscans",
+	[I(PGHOT_RECORD_HINTFAULTS)]		= "pghot_recorded_hintfaults",
+#endif /* CONFIG_PGHOT */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.34.1


