Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C01EBCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D42B900199; Thu, 14 Aug 2025 11:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E1A900172; Thu, 14 Aug 2025 11:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9C6900199; Thu, 14 Aug 2025 11:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21F89900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:36:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EABAB1A0714
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:35:59 +0000 (UTC)
X-FDA: 83775763638.19.A7DF4B1
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	by imf04.hostedemail.com (Postfix) with ESMTP id E2FA540003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:35:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IWs6HFFr;
	spf=pass (imf04.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.223.61 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185757; a=rsa-sha256;
	cv=pass;
	b=bTH6NQDXgOjwW/+MbYNvatUJYU27OBUHNavkQGR/8L3/Ebez5YDlwU+EYllsfBG6OcACeX
	eipRfbmtRoBzTu4ApbdZQz3dq+KnF1qWf+ExU36Q7hdfFDXXrR24DVDJPTZ88IHkBUgxmN
	AMIAmSP1PzQEQmc2Q6u1HDpVyOZ93Sc=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=IWs6HFFr;
	spf=pass (imf04.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.223.61 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9hE+4BNyN+gD/VwJCW/xU/rYEKf9T8D51JEHv+tgwhY=;
	b=FMzIwpcAGzZbt8B4xPZ/yvA4NgGILDhYRsQE7YpkbAJkv/c7OrdH8MM2sJRl4y5lUMfJJz
	h0lCU9FLxkztxI1213LwB1Fmyycabrg6C2hvsKqORNmMXCfq1N8flfDr+BU+3u1ytQhLk5
	Uz5X8IVCz82sm98f9WFsBhHlSfowhK4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=STBahrl88GG1Dw7Xn9NnhYJ0AO4Z9sxo5dCW9ARRtb9wejqFICJgCThV2lKIiLw/+hiH0MMSSLAvJwamRt1zLvXuPC3apNTSeQASjiXI//KBUeF6xlJeInnovlduKHBdJIvgXqMdRQ7g3LcHkzan4Im9jWaIvFMR9tE2rVHZgSw+1p80z/Fod+jlCiE2cJ1T5k3YouUOLJ6CGqL7o5/wNNUtt5DERD8yziorGxu9I4kDlDT6cuTmPyne54+ZLSOEzqG/qQcYdI5NmBfXo89cDI6FXWZXUG6E9OUoHUktapG3+4YAVe/BRRS0pRr6UVpDNCq/MUiT4hJSir7/mC97aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9hE+4BNyN+gD/VwJCW/xU/rYEKf9T8D51JEHv+tgwhY=;
 b=FcqWg9XBgMltvTk78PAjMsIw2RIo7rqfjZZtAxu1cO5qAuNBu21ictaFcDhdP2QZoSiL1QDCqMjNj8EX65uHRxBatsQIE3SBI1a4US8z7f5rrapeiQqdcW7lc5tQKFV9SIg2I4oRFYQIf8kviem3aGtgeGkOwZa2RVESvsNVHQ02aYtIHymPuhSDZDQv8xXS3dW5myvA6iSymvSRNprOrrhlMxBzIcIzMhwXvxcpw/MLx9snfuhidjlurDJ+zX+9ehZPVKc48Algd1WCUMqCcHfitoL9XcymoLUF7QoN+ym1Om8u1JbNp4AThqUf+klmOTMZiMlpLJ4Yc9wo2j53tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9hE+4BNyN+gD/VwJCW/xU/rYEKf9T8D51JEHv+tgwhY=;
 b=IWs6HFFr4yqec5o3FS6ht58dm8o33a1nw2+AQ1c17ONX0UTVIrFONibkVV8e1dUOWDA0tSYtS5Pw3xjDV9fuKQpElhhC1hurvVz7HFXs5T+tnrbvdgv8D54d3qR3VInD33TYf0hkVmZrfjjNP1EWQBzYBnWVAUvwHCC9P21bsz0=
Received: from DM5PR07CA0075.namprd07.prod.outlook.com (2603:10b6:4:ad::40) by
 PH8PR12MB7279.namprd12.prod.outlook.com (2603:10b6:510:221::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 15:35:53 +0000
Received: from DS1PEPF00017098.namprd05.prod.outlook.com
 (2603:10b6:4:ad:cafe::58) by DM5PR07CA0075.outlook.office365.com
 (2603:10b6:4:ad::40) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.17 via Frontend Transport; Thu,
 14 Aug 2025 15:35:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017098.mail.protection.outlook.com (10.167.18.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:35:52 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:35:39 -0500
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
Subject: [RFC PATCH V3 13/17] mm/vmstat: Add vmstat counters
Date: Thu, 14 Aug 2025 15:33:03 +0000
Message-ID: <20250814153307.1553061-14-raghavendra.kt@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017098:EE_|PH8PR12MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: ffdcd589-b38e-4b0f-640d-08dddb4840dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uIjbIYhhnyNi1qXMJlwYkw+KmmJxXnfu/AWeZQUjjRl/JMvFDAtLQsOyZtlv?=
 =?us-ascii?Q?+QyCrtDRUA+YEqJliZLKmC+fnmXErmHhfHhmoq1vp1FZivPYcQluRCtra9m7?=
 =?us-ascii?Q?H4qJMCJ8zcBnPu2aaBgzYnFKEBRxqmXyO5VsanaMsMtnA1RdZ330ufpZ63YD?=
 =?us-ascii?Q?0ICCkRBdTYWVe4dHKioB1TAxwWvIKfFntjHzTqncJmMzgy1jw3sPviEc4PRZ?=
 =?us-ascii?Q?qLPmSfI4ixHJhYo2Vp3tSrRULZyujWUzYXeD5tOL5zbYCJPXJgTgyJGpGdO0?=
 =?us-ascii?Q?z1YHi1vYQoD9JxR95oGdpOhQKTO4pHxBwZHxM6NZF/w9OhTF6Xar+eWXn79R?=
 =?us-ascii?Q?PjGghqBoAPtNgONA6xXf1AOTQqlzQkM2MgQevv067xb5jKOG0PleAI+Pk1ml?=
 =?us-ascii?Q?WwZjeqfh5sDm1RAKnYk8bHsweao54TcFo2T8zMYMQUrpT6Ot/ZsjfUKcbUZS?=
 =?us-ascii?Q?y5FzkH6LHOK1A7GIP2w18EyMWtdv6tLrh0D5IPIcuzpHTWjCISiKNfAu7SAM?=
 =?us-ascii?Q?IVLLro73e8wfILailNpQb9RAztA0GkyN93FkvC53MTMdS7Iu7sgwygIdgGlv?=
 =?us-ascii?Q?fi6xJn23O0xVyEysYJ4wt78hZVjDC30p4qjU9kzigt0QaGGigQQ0XNYgvNXT?=
 =?us-ascii?Q?oyO+a/ojpV7pR/FL8e7FTSu6Q6VlFviabPfB5EFGApTaX9ESS3bLZn0s5AnB?=
 =?us-ascii?Q?ji9Ao+QyTivVElQO9XMV3Mx4wSlzZnb1ERcBVEgrP1l4mv+xvhuG1AIyvOnM?=
 =?us-ascii?Q?ajHXmqgNdlKY5BNTerlj1crj0gKI9v0hT08UTQeOt3WkaAH8TD+B6G92TeMh?=
 =?us-ascii?Q?6AjusS8BBpQ3ropfBXSeIrBGHTQ6Z+4Sek/XHuJ1fg/Ndtb0xwRKiFxSX+fT?=
 =?us-ascii?Q?mDO9o8ojKFC3+N8IAyg6YuICOZSl0/8ZUZ/X/7WdTcMTUoM1WdQpKYzwCIIq?=
 =?us-ascii?Q?gYCWX3WDmQbkwgbVLsQScdtbr4ovp+TbeykKfOWzTC6Hf1T5ScFod+Rk2Nh1?=
 =?us-ascii?Q?6+r4TrdE+4oFKLLaCnoWtREjQdZeWwrlwosM4BjpRRWx1kD+fVMkBoHGWs/m?=
 =?us-ascii?Q?CDzYiMbejnSs8a+5JgPXH5MPwCEL+TUlbWOXJ2OKYAIWnNQRrGoiT3qKFwLn?=
 =?us-ascii?Q?Ftz8zFZHccG1rrZe1Lfbmsg03mYx1zq42fuNhplau5wJBtCQDU6OVa2uHJrd?=
 =?us-ascii?Q?Jr+Wo2RdlSXiD8UeRARzeRNg2LBO7a3PRCEF7bM1rmpyNN4JpRXcHUOKpcIL?=
 =?us-ascii?Q?KONFU6hSxjFcyGMqpNa6fQCICftzXB1L0RRhAyz2jbW2UVrnlwvkv/TcWsrB?=
 =?us-ascii?Q?73AQcLxblRWDYuB+dSWYvkUzQ1ECvjPB6AlcMN/+Hw2a6KMFp/dZYDUtNgJI?=
 =?us-ascii?Q?mN+XS5RBKNN5GRudRk6waVsAuTIUYQvGa4TvGH2YTA6DWbxOoEREEFxFltxH?=
 =?us-ascii?Q?S9slVoBgBFDKq9M7IJud5MUPzo2DfExcZsERd3EDCTwqBUYfjZeSPAYCt/AP?=
 =?us-ascii?Q?ypkqDOFBI0ixakNxC69LJC/MVsEmKeDhJddJ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:35:52.7976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ffdcd589-b38e-4b0f-640d-08dddb4840dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017098.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7279
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2FA540003
X-Stat-Signature: 1h4z7g7obc3rnjafdnxqyizaaqoodzwo
X-Rspam-User: 
X-HE-Tag: 1755185756-83878
X-HE-Meta: U2FsdGVkX19utuW1c6p46huQgUxc8z6srelv4jSuqHAC0Il2MmrfgXbTlbaR/5AD8ccIzS8Vq/R3fPGtmJvZAnR1vQEa/ib81nFBnoMDn49NomQ6wahhY+1g3aRg4/lz3hHYEkatW081VO34OBgesL6bhxX1VHRaN9uodJeLFcLmPezZ2raBvkTXlVKgDbrgbS6IWE42PUQw7I75K8PAW03TuxLtldTNb9WZVXDq/ZxaPzgbBzilOvaXiNS5SGIJ9x0wIIisIm/vk4c0v/2crrBleT84GxNKmRLNQj9ZhGHh7L2qWVWK1hx70BfXxgAcE57bMgWH/Hq3OejBef5poyA0eETDISSVG82650yQHUR8Mc7y2L86Z4oZ2P3yT4pNkdprFF790D71ohrgQwo5NSaAFJobo3qQhJv3Ju6vuhHff7OBtzlclr5Q1c/tTsW+s8DInE0E4me4zbZwTaoRKXvRf6e4kRn8m9cZYgpYPDIbermNg6YnA7/ZHlVBHh7JoUra8GmDRROxhk8dsZHegX63EnhvvRtBc8luaYilN9Mv8cbo8yBDU7xJ2LBx0UVfHLzXrH7cS5XqTCOZLusUVBnk1+8+0g15570LtJegdseDBKdWKH5fJdWYrVm69Z6monoleewj/YOX5cfaSt2FB4u6BkzT/S6/2j9qq13Tv8j0U2H6fR5CM2Vp4kS4KQF/G/mN4CNge8Sg7+81t6IU3HUHOpU4haoQf5NpHPfqJXXcxHAh3aDVU6vxXJ6xIBtmP/L9QiV62B47ZL5dKxaAy42ovU4nv4i4WCrmWQmOS9BqxlynKcC7WmJgVOHGs3nAjEbEOBVK0HDmRdFA+FAYc43/GgT7TdcUxidZMTQaK4cNhp9HLnCGKN+aXgWvDaOFgZcKptMx21mHO1fVySk6ny82Aqo43ArIwNyhTSBO0g2h/nT1I3ZZIvwEesgwbV7uTWUKRz8kHgZXoCMl0l6
 i7mbU7Jl
 YnqsSs7ROvDj85+NaKH3JhBHecpHRY3+9VtOX67k3rVAR6mgoHEWcAj94nuEDMv1GBiCIKqrnAxXWG80z8kXBEw7MeRxXq836jRCo74AiU28cjJ3VHIb5XQbMNil8I/1+RENXplB7BwGDwhyTxJSTxtnfOt1343CPyGY5GYaznVzI54FTTToKwInDCIxUy0/00qCoyBwIisT5yeAw/621xfAHdX8Y4QRhSa9f8DNnRrFu4fT+8PVJlQM44DQPNJ9t1h05X8et2zEHB3HXs2MvwA/xb2HltK6lYNFBlvtIRfwfTVTczn9ZGaPlfQExTqqAXt9XOlYnkB93cHE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add vmstat counter to track scanning, migration and
type of pages.

Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 include/linux/mm.h            | 13 ++++++++
 include/linux/vm_event_item.h | 12 +++++++
 mm/kscand.c                   | 63 +++++++++++++++++++++++++++++++++--
 mm/vmstat.c                   | 12 +++++++
 4 files changed, 98 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa538feaa8d9..0d579d0294bf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -655,6 +655,19 @@ struct vm_operations_struct {
 					  unsigned long addr);
 };
 
+#ifdef CONFIG_KSCAND
+void count_kscand_mm_scans(void);
+void count_kscand_vma_scans(void);
+void count_kscand_migadded(void);
+void count_kscand_migrated(void);
+void count_kscand_migrate_failed(void);
+void count_kscand_slowtier(void);
+void count_kscand_toptier(void);
+void count_kscand_idlepage(void);
+void count_kscand_hotpage(void);
+void count_kscand_coldpage(void);
+#endif
+
 #ifdef CONFIG_NUMA_BALANCING
 static inline void vma_numab_state_init(struct vm_area_struct *vma)
 {
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 9e15a088ba38..b5643be5dd94 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -67,6 +67,18 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		NUMA_HINT_FAULTS_LOCAL,
 		NUMA_PAGE_MIGRATE,
 #endif
+#ifdef CONFIG_KSCAND
+		KSCAND_MM_SCANS,
+		KSCAND_VMA_SCANS,
+		KSCAND_MIGADDED,
+		KSCAND_MIGRATED,
+		KSCAND_MIGRATE_FAILED,
+		KSCAND_SLOWTIER,
+		KSCAND_TOPTIER,
+		KSCAND_IDLEPAGE,
+		KSCAND_HOTPAGE,
+		KSCAND_COLDPAGE,
+#endif
 #ifdef CONFIG_MIGRATION
 		PGMIGRATE_SUCCESS, PGMIGRATE_FAIL,
 		THP_MIGRATION_SUCCESS,
diff --git a/mm/kscand.c b/mm/kscand.c
index a73606f7ca3c..e14645565ba7 100644
--- a/mm/kscand.c
+++ b/mm/kscand.c
@@ -339,6 +339,47 @@ struct attribute_group kscand_attr_group = {
 };
 #endif
 
+void count_kscand_mm_scans(void)
+{
+	count_vm_numa_event(KSCAND_MM_SCANS);
+}
+void count_kscand_vma_scans(void)
+{
+	count_vm_numa_event(KSCAND_VMA_SCANS);
+}
+void count_kscand_migadded(void)
+{
+	count_vm_numa_event(KSCAND_MIGADDED);
+}
+void count_kscand_migrated(void)
+{
+	count_vm_numa_event(KSCAND_MIGRATED);
+}
+void count_kscand_migrate_failed(void)
+{
+	count_vm_numa_event(KSCAND_MIGRATE_FAILED);
+}
+void count_kscand_slowtier(void)
+{
+	count_vm_numa_event(KSCAND_SLOWTIER);
+}
+void count_kscand_toptier(void)
+{
+	count_vm_numa_event(KSCAND_TOPTIER);
+}
+void count_kscand_idlepage(void)
+{
+	count_vm_numa_event(KSCAND_IDLEPAGE);
+}
+void count_kscand_hotpage(void)
+{
+	count_vm_numa_event(KSCAND_HOTPAGE);
+}
+void count_kscand_coldpage(void)
+{
+	count_vm_numa_event(KSCAND_COLDPAGE);
+}
+
 static inline int kscand_has_work(void)
 {
 	return !list_empty(&kscand_scan.mm_head);
@@ -653,6 +694,8 @@ static int kmigrated_promote_folio(struct kscand_migrate_info *info,
 
 	if (!is_hot_page(folio))
 		return KSCAND_NOT_HOT_PAGE;
+	else
+		count_kscand_hotpage();
 
 	folio_get(folio);
 
@@ -803,12 +846,15 @@ static int hot_vma_idle_pte_entry(pte_t *pte,
 	}
 
 	if (!kscand_eligible_srcnid(srcnid)) {
+		count_kscand_toptier();
 		if (folio_test_young(folio) || folio_test_referenced(folio)
 				|| pte_young(pteval)) {
 			scanctrl->nodeinfo[srcnid]->nr_accessed++;
 		}
 		folio_put(folio);
 		return 0;
+	} else {
+		count_kscand_slowtier();
 	}
 	if (!folio_test_idle(folio) && !prev_idle &&
 		(folio_test_young(folio) || folio_test_referenced(folio))) {
@@ -820,7 +866,14 @@ static int hot_vma_idle_pte_entry(pte_t *pte,
 			info->pfn = folio_pfn(folio);
 			info->address = addr;
 			list_add_tail(&info->migrate_node, &scanctrl->scan_list);
+			count_kscand_migadded();
 		}
+		folio_put(folio);
+		return 0;
+	} else {
+		if (prev_idle)
+			count_kscand_coldpage();
+		count_kscand_idlepage();
 	}
 
 	folio_put(folio);
@@ -1045,10 +1098,13 @@ static void kmigrated_migrate_mm(struct kmigrated_mm_slot *mm_slot)
 			mstat_counter--;
 
 			/* TBD: encode migrated count here, currently assume folio_nr_pages */
-			if (!ret)
+			if (!ret) {
+				count_kscand_migrated();
 				msuccess++;
-			else
+			} else {
+				count_kscand_migrate_failed();
 				mfailed++;
+			}
 
 			kfree(info);
 
@@ -1269,6 +1325,7 @@ static unsigned long kscand_scan_mm_slot(void)
 
 	for_each_vma(vmi, vma) {
 		kscand_walk_page_vma(vma, &kscand_scanctrl);
+		count_kscand_vma_scans();
 		vma_scanned_size += vma->vm_end - vma->vm_start;
 
 		if (vma_scanned_size >= mm_slot_scan_size ||
@@ -1304,6 +1361,8 @@ static unsigned long kscand_scan_mm_slot(void)
 
 	update_mmslot_info = true;
 
+	count_kscand_mm_scans();
+
 	total = get_slowtier_accesed(&kscand_scanctrl);
 	target_node = get_target_node(&kscand_scanctrl);
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index a78d70ddeacd..5ba82d2ffe71 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1347,6 +1347,18 @@ const char * const vmstat_text[] = {
 	"numa_hint_faults_local",
 	"numa_pages_migrated",
 #endif
+#ifdef CONFIG_KSCAND
+	"nr_kscand_mm_scans",
+	"nr_kscand_vma_scans",
+	"nr_kscand_migadded",
+	"nr_kscand_migrated",
+	"nr_kscand_migrate_failed",
+	"nr_kscand_slowtier",
+	"nr_kscand_toptier",
+	"nr_kscand_idlepage",
+	"nr_kscand_hotpage",
+	"nr_kscand_coldpage",
+#endif
 #ifdef CONFIG_MIGRATION
 	"pgmigrate_success",
 	"pgmigrate_fail",
-- 
2.34.1


