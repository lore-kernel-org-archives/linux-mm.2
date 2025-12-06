Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92555D3B7D1
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 10:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F268C6B00C1; Sat,  6 Dec 2025 05:17:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDE96B00C3; Sat,  6 Dec 2025 05:17:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDCB6B00C4; Sat,  6 Dec 2025 05:17:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C9ED16B00C1
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 05:17:19 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 59626B9788
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:17:19 +0000 (UTC)
X-FDA: 84188643798.11.1803A22
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7922B1C0012
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:17:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VdaVRShP;
	spf=pass (imf20.hostedemail.com: domain of bharata@amd.com designates 52.101.62.66 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765016236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oykREHuvFyldRKu866V8hUgo1P0rpT8re4u+1a5Xrms=;
	b=0ajZKGZ5MpNXoJ6gsvXwHEIWO9CopXbEtWj1yQU8rEUxodeDRMkwsIbmlIaylsL0oGrKWR
	i/TSrQ9uM+Va3H5dOfALGZo992Q5jHWeTE0Zp6GOGQx2jgPlHM3WK8tmO/rvTUK4FjNafG
	j1dLko2H/JE3O8CPEOhKVO9snbleXV8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VdaVRShP;
	spf=pass (imf20.hostedemail.com: domain of bharata@amd.com designates 52.101.62.66 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765016236; a=rsa-sha256;
	cv=pass;
	b=cYBkvL1U45hLq8wGAshtxV7f95odjCl7ek0oF1xKx3g0JZ2vfwgkWbUtthHadUq8ZKGBZw
	5APVIsxIVuYB2UaqLAPWy6fhhDwY6FssJD1ZqjL/iZiC4Ed9AMEDETWEQPmFu2ENEljeb3
	7cYKmPIjyqwuNtnEQ3TPO1paFFTAdW0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AjAGtzz/1yghhzTlqwg9+tLa7PaIHP6/g3JFxNaqrhKj2Lx3Mc8sahSCZwfXp/sRO13Nc/HwKvam88SXHGeYRaO/NwErfsp8GKR0SftLkJUwuszmBzUL8QGDSmROcKV95uZIzWdp4Tr4wRmZbPZWhpz7TI+347JsW2J2mSCprc4qWpwJcHSwTnbgoPQb5/6p5ZtVJwDBOTPUHW4TwCais7Z9L+m+FBgPgjHWtAv84olnzbx1+mArPbqeHEkWmeIsoriGa13Kv+JaHPjCv6wRZ6HOaFDP3SxNdd/W2iKiMWu8LYQsP5vbhNZ3Cm8ZBsJMU8qZYbafu7tKZH47vQYJGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oykREHuvFyldRKu866V8hUgo1P0rpT8re4u+1a5Xrms=;
 b=CBb3Ny1tePUmZcXTQ6Khh3CNXyuHNAGBi84YmbHszXl49rfGuQm5PEruP/J9FnK4ona0LnZehEpzELbKH51kc94gXGHIqsjc1+Y5Ua6egB/2fvuXLt9czpvTkkJQUdyYQ9cuOZQ0UFVyn1d3w+1JhkK3LNkXP1KVee5N0X4I8zqerFUU9Ft92hT2khwt4zICQJyA1C7PTjmR8y1WPbXu9Sif5Zg0+om4PEvzp/NyA8ifK02/Wud9KosWa3+iM8S2lsZMySK4ZQqA8EkSK+JPFMTQt22rx1YZBYH/g/NvtXb0FRRzYw/8qcvAvmRybGw4Jc/TW7jCz/Hc/TIiWil5iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oykREHuvFyldRKu866V8hUgo1P0rpT8re4u+1a5Xrms=;
 b=VdaVRShPGUE5b5hSuEkjrHl1ObAjm6h8GqiVb2fMm3mgGyFpufakzomwavWXE+It/Aft75HsbXuw8d92LAwF4Q/EMfsQc1Kk7V9mzxej9FfhELUFRHx9twmJYvtnulQJzTkTnyzV5QMVcuPUlWdsB4DbJhpJt0kv268A4koE9n0=
Received: from BL1PR13CA0281.namprd13.prod.outlook.com (2603:10b6:208:2bc::16)
 by SJ2PR12MB7798.namprd12.prod.outlook.com (2603:10b6:a03:4c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.12; Sat, 6 Dec
 2025 10:17:09 +0000
Received: from MN1PEPF0000F0DF.namprd04.prod.outlook.com
 (2603:10b6:208:2bc:cafe::de) by BL1PR13CA0281.outlook.office365.com
 (2603:10b6:208:2bc::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.3 via Frontend Transport; Sat, 6
 Dec 2025 10:17:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000F0DF.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9412.4 via Frontend Transport; Sat, 6 Dec 2025 10:17:09 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sat, 6 Dec
 2025 04:17:01 -0600
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
Subject: [RFC PATCH v4 5/9] x86: ibs: Enable IBS profiling for memory accesses
Date: Sat, 6 Dec 2025 15:44:19 +0530
Message-ID: <20251206101423.5004-6-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251206101423.5004-1-bharata@amd.com>
References: <20251206101423.5004-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0DF:EE_|SJ2PR12MB7798:EE_
X-MS-Office365-Filtering-Correlation-Id: a57012bb-5199-4140-54bb-08de34b09d65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mOab2R4D7y3V2Oq2ZYky/SU4YKu+dK4QNA8uRr9xjGx76UxboOaVdjVh9kXL?=
 =?us-ascii?Q?uCXFmEydABMk6pGIB56X2FQU9xVfo+jU0yDaWphbbstbrjUL8ZgjmRD8jZYp?=
 =?us-ascii?Q?HxpDa7UMc0ZZ6b9LQxYGc7H72GtGSQeIngp7MTVN8DTEflIPi3XUn8jJZjk9?=
 =?us-ascii?Q?0Kb+WeEDZnV4OB/TxEFVxdziaDxQ5nuyTQ0xA3tdHqJrulOwvbQ2wpJIt2Px?=
 =?us-ascii?Q?4VerFMenU9tllHk9PycZh4I7iiReai1UpvEoN+2Ecd5G/qJ7uJRSP6NCdDwM?=
 =?us-ascii?Q?YrV42qVXNi3CR9NvZmtN91YNYy8Rd2lPWTqhXwp4mrcTPjMEslfay2meJ87L?=
 =?us-ascii?Q?x5KBfO+RsMciZ/S/NF/LOY/6V7b9B1GfqemlNUWzOjaa/TRj2XM8ZTkbK33I?=
 =?us-ascii?Q?4RGjoC4MuPxP/rbQ0OxvSeedKsa+h+RAh3TgZRqsrBc7AZJDnuUQVNb1JnQ9?=
 =?us-ascii?Q?2C83nwydX5gXCgaJPEvlofsBxUmHYFj4ngSQDY60SWjcjXaFBQ4NtKjJw+2I?=
 =?us-ascii?Q?O2sjpbDDQDHudCCrQoGVveYBysPDrTT9rRkaDIhaTeqY6hXFc44aO8I2qO6L?=
 =?us-ascii?Q?Tly+yJQYPsyk8RNzkk9Rm1QhqtNNNZEMrBI11V3AoZWf/7L0Jn7HxGptkszG?=
 =?us-ascii?Q?62F/YHANGDnIjhe/nQdG6ArNmS/B9kF46EUvwhBqYaA+7Og7/2A9wmTDSwrW?=
 =?us-ascii?Q?nneAaXNxu0iyw6TnLUn5aQL0b1odRKhnRqo/xZnG7SmZ5e8uPWVLBM64uwPB?=
 =?us-ascii?Q?XfGkHmaiRP+Q6vtUuusB/K8sMPdW+KUZ8SmItK4Dd4IqURW+4WB3kMv9kIeP?=
 =?us-ascii?Q?LE2AiUraiv6RQtgJjOodEd87RoiTDWyLyVH1zTdyt2ycz4PJf+TmBie6VNtl?=
 =?us-ascii?Q?QwCvnfh/m3bn6JHMF9VJH4zmS8c/XlbTkMbXw3ZXfKxsPamPBEDDtuclLIn2?=
 =?us-ascii?Q?Ms5bV9pyhx7hyIca21nRZlyG03AqvENdOTu+mBZtY06HWIcFeMSxgDZV2827?=
 =?us-ascii?Q?Tc5BgIBdKkxVrUeCRmBFvQ7NKvgJLcdGlu3lYnHQ0QT1rAz4d8tFEbX3/yKD?=
 =?us-ascii?Q?DJQxRNkFm2tUdbHdMeVrBJNS7FxZG+JgNUWZf0qSWZt+5LJvCImtJKf3NTl5?=
 =?us-ascii?Q?hFN0ad4j474kMZyC+Ge8Lrr5rjqgx9sI4/wy55NrGjz7sC6YF7VzTXBbrcPW?=
 =?us-ascii?Q?xed4JXdWiYl4aPU8z/B+vll7nIoHti+UdswVInvS3Z+vf3NbB5lBrVk1IWhv?=
 =?us-ascii?Q?V+uOywPFE+4KbTRD66c8ar08y0KGqJBKNgqevTWCnaXBTKp/9hohAkRxBjk8?=
 =?us-ascii?Q?JLFvPxY8EKEIX1Uh5I53eWJDP6Nreaq+Ri5Tp/LuJM054+x7xr1i2MWU2LBy?=
 =?us-ascii?Q?z3/lwzqmc2rwYWW2SqScmZaMm+imXj/xZ11eZDUCVnozC7zdNQH/FZnk96VB?=
 =?us-ascii?Q?v2vVinU7+ads7rn43kP3//i/g0sVKkHYSS+fiOGcgGDCLOR/kb3te8EGTF8W?=
 =?us-ascii?Q?Bffv+b3F6CwdZHLb7KuKxO2+bYwbpbKJcH8aSHUIeGf+sAlYALWf9cuKhq2z?=
 =?us-ascii?Q?aFZK48uMNGm5iZrbuU8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2025 10:17:09.2304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a57012bb-5199-4140-54bb-08de34b09d65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0DF.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7798
X-Stat-Signature: g8bpgcxkr6nbbti1pmpykwqndtguphhi
X-Rspamd-Queue-Id: 7922B1C0012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765016236-794316
X-HE-Meta: U2FsdGVkX1/VEIeUvajyvKbgpZtLX72bQOR6x644/PcmKtJnY6/u7dLo+6u1xMVazr0TfTGGEhwRK7+gGb/rCZzphcIEopA+FpRcbA29/L/JWLuxhdZiC+0p094AUKu3svj0R8qs9YuVszvGMkhHLkCuMw4Kh6u09yqawJ1HCB30oZTzye61Palwvp1ERs26O101eO+h86mHdhJmrk+UTZEdzHdOCTQCO5oRBIcnhRZCmgHdGCbU44L9sYiamCMCsdpKVXnG9bfeGSCc+KDHbzkVhKdS95BGKCK0W8YbQmDi3AOLwflS9t97qxZ91tYT7RVQZNTdy0f3UbEZPHkUW98i3fxOjpQ6OTN1bHo1vnrD7oZY2P5dumJTGElp/FTZQcep3Z5y0cWHYL3aVarcWc6WmRo2pNhLmKa96AzNMeF/TIvbRYS3aVcL9TC+/DbrUSQG1469IBilWm/MkqSyzrDYz74kETxRNseonhMKYxw1Dys2nZF/xLrjy7kWDgHF6gjnLNqpMoFiynXHgdXPQThYTm1wykfwL9LrHB0wmihgJC3FLXP+3TPi4K3gtkZQtclbuXdHEPyYdAyDXw8Otcjoeu63tsN4FyIOHMfLfLtkvsAb1Bdw31H/6b7rBOtM6XzfwHSYTKWOx3NpuHGWNy3hytDBfZeWr33RjtYJKP4mEWzaSM8ITmRIR+Oqi2CnhYMfj4UCjfujr94swijsa7dBjvxeQP/VtDGucqjGxbmWySmrGJLj9GzTUFL72Ib7/ndHqSUDzRc2XCbz+f/7LTNXGmLg843EwI5iGYcNxgPYnZV5Hm5qYufVEac1rYiMOqOjg3MRIfJ8ZuiZy6KIu7xPMG850ids4VEMPPcMdKJzBZKLsRNo2p6je/P2ZDoYJRfdpd2NscchIMTxd6guM654QlGBqhWic27PNYh0VmTFjXpW0N9qHOubBgNNsD61jhQvqhNe4nvAeyqRec8
 4Taqf1FN
 v+aibSW9LTEwlYNbY2XLYYkRf3AcVj5vJGSvlBakoXhpfGIT0EVuMjZKoMn6peHfOFf2wkdlORQprEgQi4zzJKvdwqbc76BpIRxhB82YtHLknl4khGKr47cijaG+VDDNUZt+dAn43PPvePqwb3h2/3vTMHZklAaJ1aKDofipQzrivG2ykKrGMhnSUuAAJDMpgKhGzZbHpcksJa28S6m38cHuCYj62XIaTP5CgPxCPky7LgUPL5HzZ438tJEmGeTRooTw80U0fNLr1XOjk/5pLBw4wLHaEdp2HfZlZ5jTZN1m2s8X7qEjIjVIO47kHVd7IrUPPA+kkSk5eN5LlloQOlzZoTuLRzpKeMV3GKCFzTw8BAneUd0WCvCgshix/KyuO/IK0Oa3ZE5xHOe3ZFKdVXSsRetpm0n+X8BjMZMMUi09xlAYO1h+wtdun5/dxn1Tow688d8T2P3XXl2W0khUNJcoubwGWn80DZn9EhlOj0pB7zwM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable IBS memory access data collection for user memory
accesses by programming the required MSRs. The profiling
is turned ON only for user mode execution and turned OFF
for kernel mode execution. Profiling is explicitly disabled
for NMI handler too.

TODOs:

- IBS sampling rate is kept fixed for now.
- Arch/vendor separation/isolation of the code needs relook.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 arch/x86/include/asm/entry-common.h |  3 +++
 arch/x86/include/asm/hardirq.h      |  2 ++
 arch/x86/mm/ibs.c                   | 32 +++++++++++++++++++++++++++++
 include/linux/pghot.h               |  4 ++++
 4 files changed, 41 insertions(+)

diff --git a/arch/x86/include/asm/entry-common.h b/arch/x86/include/asm/entry-common.h
index ce3eb6d5fdf9..0f381a63669e 100644
--- a/arch/x86/include/asm/entry-common.h
+++ b/arch/x86/include/asm/entry-common.h
@@ -4,6 +4,7 @@
 
 #include <linux/randomize_kstack.h>
 #include <linux/user-return-notifier.h>
+#include <linux/pghot.h>
 
 #include <asm/nospec-branch.h>
 #include <asm/io_bitmap.h>
@@ -13,6 +14,7 @@
 /* Check that the stack and regs on entry from user mode are sane. */
 static __always_inline void arch_enter_from_user_mode(struct pt_regs *regs)
 {
+	hwmem_access_profiling_stop();
 	if (IS_ENABLED(CONFIG_DEBUG_ENTRY)) {
 		/*
 		 * Make sure that the entry code gave us a sensible EFLAGS
@@ -106,6 +108,7 @@ static inline void arch_exit_to_user_mode_prepare(struct pt_regs *regs,
 static __always_inline void arch_exit_to_user_mode(void)
 {
 	amd_clear_divider();
+	hwmem_access_profiling_start();
 }
 #define arch_exit_to_user_mode arch_exit_to_user_mode
 
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index f00c09ffe6a9..281dd76f5efb 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -91,4 +91,6 @@ static __always_inline bool kvm_get_cpu_l1tf_flush_l1d(void)
 static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
 #endif /* IS_ENABLED(CONFIG_KVM_INTEL) */
 
+#define arch_nmi_enter()	hwmem_access_profiling_stop()
+#define arch_nmi_exit()		hwmem_access_profiling_start()
 #endif /* _ASM_X86_HARDIRQ_H */
diff --git a/arch/x86/mm/ibs.c b/arch/x86/mm/ibs.c
index 946f3a82ca11..cf21052118c9 100644
--- a/arch/x86/mm/ibs.c
+++ b/arch/x86/mm/ibs.c
@@ -16,6 +16,7 @@ static u64 ibs_config __read_mostly;
 static u32 ibs_caps;
 
 #define IBS_NR_SAMPLES	150
+#define IBS_SAMPLE_PERIOD      10000
 
 /*
  * Basic access info captured for each memory access.
@@ -43,6 +44,36 @@ struct ibs_sample_pcpu __percpu *ibs_s;
 static struct work_struct ibs_work;
 static struct irq_work ibs_irq_work;
 
+void hwmem_access_profiling_stop(void)
+{
+	u64 ops_ctl;
+
+	if (!hwmem_access_profiling)
+		return;
+
+	rdmsrl(MSR_AMD64_IBSOPCTL, ops_ctl);
+	wrmsrl(MSR_AMD64_IBSOPCTL, ops_ctl & ~IBS_OP_ENABLE);
+}
+
+void hwmem_access_profiling_start(void)
+{
+	u64 config = 0;
+	unsigned int period = IBS_SAMPLE_PERIOD;
+
+	if (!hwmem_access_profiling)
+		return;
+
+	/* Disable IBS for kernel thread */
+	if (!current->mm)
+		goto out;
+
+	config = (period >> 4) & IBS_OP_MAX_CNT;
+	config |= (period & IBS_OP_MAX_CNT_EXT_MASK);
+	config |= ibs_config;
+out:
+	wrmsrl(MSR_AMD64_IBSOPCTL, config);
+}
+
 bool hwmem_access_profiler_inuse(void)
 {
 	return hwmem_access_profiling;
@@ -309,6 +340,7 @@ static int __init ibs_access_profiling_init(void)
 			  x86_amd_ibs_access_profile_startup,
 			  x86_amd_ibs_access_profile_teardown);
 
+	hwmem_access_profiling = true;
 	pr_info("IBS setup for memory access profiling\n");
 	return 0;
 }
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index 6410cb131d3d..00f450f79c86 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -4,8 +4,12 @@
 
 #ifdef CONFIG_HWMEM_PROFILER
 bool hwmem_access_profiler_inuse(void);
+void hwmem_access_profiling_start(void);
+void hwmem_access_profiling_stop(void);
 #else
 static inline bool hwmem_access_profiler_inuse(void) { return false; }
+static inline void hwmem_access_profiling_start(void) {}
+static inline void hwmem_access_profiling_stop(void) {}
 #endif
 
 /* Page hotness temperature sources */
-- 
2.34.1


