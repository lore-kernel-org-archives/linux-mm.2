Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9631CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49C0090019A; Thu, 14 Aug 2025 11:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BFC900172; Thu, 14 Aug 2025 11:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EDD290019A; Thu, 14 Aug 2025 11:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE7C900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:36:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDDAC1A06F1
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:36:05 +0000 (UTC)
X-FDA: 83775763890.14.3C9134C
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3A42214000C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:36:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=fj7F6dtc;
	spf=pass (imf26.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.92.62 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755185763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZaWbpDRzrNxNxl+NAvt/vlQzbosqTSFRGmvuYGTslqs=;
	b=AesbCrSta2U/70yXcO0cKGDSPf83AujPTaceoUrcg0bYP3HTuWp+3Iv++fnJ5hHBy4gg3E
	+6datWwypJ0BLRC4TFbg1Sdzl9HeGqLlJhy4EZYxTslmeDjIrVM3ljU/OywnNiV2ufeNTp
	wydsP+apiSVA6C+SzdHUyrm0nJXWAwU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=fj7F6dtc;
	spf=pass (imf26.hostedemail.com: domain of Raghavendra.KodsaraThimmappa@amd.com designates 40.107.92.62 as permitted sender) smtp.mailfrom=Raghavendra.KodsaraThimmappa@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755185763; a=rsa-sha256;
	cv=pass;
	b=NydIMXLtSTTDSSpL6YD40RHiyueN06oQ9A2Mof5idy61iTNjFdjmRHUeo0OUOEljTszBkf
	R4HZV++cGi5xMZtO++x0SkJByQX9H1e1wqKiUWvfR5u1pxQZXqP22A7L/6XKp6uGHWUSWn
	J17bVHCq7Qg+iKdGMZ7rB7DmgpI3D+A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HdjRq4vMme31BjUYUUFds10QKRUY43EJxV3LIazOrzVdt4Xd8bDqq1lwbLPj2gUg8IdegCT0cKaQkfgp8AM8UF+8T/aYLKA3M5LD4Jp/BYIp4nn9wG+bzN9KuFqrIwx559mrcq/DXywJGPUl2LFRIMoPU4CTon3tO0mM13Q4ilcfA3wZqgJQ6SYxnpzRGcdWVECSx5acEZwuXfWu2ob8DyWwwj7p/NT+J0dKygjxGuwLE/76L1hOHVWNVKh2tewwjp5yyL6yTGdzFMTvoW6BAAoy/E2evN9/a7jfj3RCE8jP+H2Dzy2IPfcV4PBOyXOg3fcanLyGy7FETBebxnjfyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZaWbpDRzrNxNxl+NAvt/vlQzbosqTSFRGmvuYGTslqs=;
 b=MNb8yG4lv6OJXioU4u4VQLohtoKgXc8pBGEhb8Cv0xEqjwHWelc+dRrvybZupkGEv9KeJ271xB364MRY9ostm+CsaA5TvjPhlq5wuSJrV/d3xCmYTLhB5z5IaV59OWPAD5FRsTmjOxdYbxppxbV4Y5cOTkjq57aMHp5J16c6bVWfSJ7wr9Cdjr+NetHqIuVXsXqzz83SHLxXFuT27gRE5X+fFGG1EAxOMFHp6yABig9CFV76LMs8ALVgx+tiPE7jKNWiuYeQeGFqZPrwg3UK50dK8JSTCyZJZUpe1l0LEAxThwzOlRd7MtnkrF2d0DwqdAb+4GUFkR0solHppgmKwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=arm.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZaWbpDRzrNxNxl+NAvt/vlQzbosqTSFRGmvuYGTslqs=;
 b=fj7F6dtcMqAV2ddLzFTCWq5wYEAWwifcCjIYbW8Xgphj9GoM4dcj9EcRnPx/mDTEvFTA4YuwJL0oy8Z+/yf3rp84dPSxnkgqMXd2AxBkbxtaXzMxBCwbfFqEKsJqL04yRewECr6K3hHG6LEBfeBfkBlYrPggQUhL0FgXVA+ybcc=
Received: from DM6PR11CA0039.namprd11.prod.outlook.com (2603:10b6:5:14c::16)
 by MN2PR12MB4269.namprd12.prod.outlook.com (2603:10b6:208:1d4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 15:36:00 +0000
Received: from DS1PEPF00017098.namprd05.prod.outlook.com
 (2603:10b6:5:14c:cafe::65) by DM6PR11CA0039.outlook.office365.com
 (2603:10b6:5:14c::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.18 via Frontend Transport; Thu,
 14 Aug 2025 15:36:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017098.mail.protection.outlook.com (10.167.18.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Thu, 14 Aug 2025 15:36:00 +0000
Received: from tunga.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Aug
 2025 10:35:49 -0500
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
Subject: [RFC PATCH V3 14/17] trace/kscand: Add tracing of scanning and migration
Date: Thu, 14 Aug 2025 15:33:04 +0000
Message-ID: <20250814153307.1553061-15-raghavendra.kt@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF00017098:EE_|MN2PR12MB4269:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f0a5301-2d55-4991-bb69-08dddb484570
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gKxrV5m1TAr+tL5NuToSy3M4E/550rgARs8irH/6NtPX/jOW7MY0XwwQYtyN?=
 =?us-ascii?Q?uSUst2/iuHxEXscVnSIPDRXoXAXhhnc2z+5Ddx1lcOyjnyyKWJ62m5ii8+k7?=
 =?us-ascii?Q?aSgZT8zhrr3qcRU1ac+55zNjN1nJjw3T7yYMVGNNmNTn8cEzNSMHRqoPz7VK?=
 =?us-ascii?Q?2FDh52QYaFdU+LA6lE0OsueKhwm6kpDSVFAFcHpfB6f1RilTbDTIpG/FK9uG?=
 =?us-ascii?Q?IezFWZImNIIup+yMPH/yaD4UH7ARROuwXfx+ZUw5VfU8hRRwn8lQGp8za+8E?=
 =?us-ascii?Q?s1QtWCAkdGzvBsKLfpXeSKB0xIgs/Dsl+Ii98UCkmni7/brXoKXNjwCMSWLY?=
 =?us-ascii?Q?k+giVFblE2RtSwyIN0zW9n5aPjIdjKCfAu9ssN+Wvc4x0cb+K3Nk13pBwy7+?=
 =?us-ascii?Q?jD6RLdRQ1qw4UL6PIyBSVDrcl95KZ/Ad1BkKlNTLMmGsS9ncWZXL3Bu2t2us?=
 =?us-ascii?Q?MlWjY2awtE2s/hGXcx2sfEkQo08k3lT5Le+yrbi0UNVhwfDwCCaaODHbRCfa?=
 =?us-ascii?Q?BeJRmjy2gqt9HUdOQ9U1vpU5rwdB8tX/167I44jsTvfyDPBy232WzUAjfNp2?=
 =?us-ascii?Q?5tn9QhoOPSmb6Tu8FKXogS/9auJwbfHU7038Sx7YCbUvdBc7wbs3CiiAvl1s?=
 =?us-ascii?Q?M0vF2TRhMm5VpWc5Imr51qz5Z01KmSBuDCULKx+5uqmYl2/N2C+u2Gdd8x26?=
 =?us-ascii?Q?sYppNibWJm2LgzXLCPWeOxtayIqouFQlS8m3/mJgJ4azTUe6E2Lrwn5egGhz?=
 =?us-ascii?Q?zXhbeaMcQbIGou0TBD5nw3tj2CpLz6Qjf2s8TXCJ7TQchtEL/G21veFqZSyB?=
 =?us-ascii?Q?OhN1Gkx5qnyO3/E5okeLkxfuGvo/pmiluj03HFVDePe7JDRBeVADuI6ZMlw/?=
 =?us-ascii?Q?E3b6rZfZc8h1sHeKQFIledDjNgMXQ/IB6x5DqE7kldPW665hevrsOzHgphaj?=
 =?us-ascii?Q?OQQgAC7xaWS2uuC8wEhQt2K5wMIUENJPepHBwga7yI7ohRteCHKEqDwxFHIH?=
 =?us-ascii?Q?VBnSA+IDls+7tBp7QRUcqCybCUm+z9Ga+zCM1R6+GfuHWCiJvYDr1p4XmIhq?=
 =?us-ascii?Q?E3V2fpnQ8UGH4JA2iGXdAMjyW6f8BA8HH/gxlKz7LAParrGRID/BbDhkP6gV?=
 =?us-ascii?Q?kCuGI14O6sKiKothSR2UMBW3j1AWpbEjnc3TgCN5Iu6sdyaYj5zErYZ5D26a?=
 =?us-ascii?Q?KAnVl7t3Mdb0LGOasY0lxF0NxtJ31md5Ja+oGK34T3l1NBwo+v1h311qAbSA?=
 =?us-ascii?Q?9xrdU24l+uiZcO5qvASHtnfQA7FO/tCdIarEEZvC3BFnnas0zYbL6iBTsNDy?=
 =?us-ascii?Q?k99+9obBPKqmkvC6L3nHUHW30MNTqc+nwWPv/Xoy/PtSOdBaBSzUqhH2PbxC?=
 =?us-ascii?Q?/fiOneNaZ7vrfOt5iFhtaxOPRb2PjLTDwNNeEngxAcVDvG6moYZ4BwMK5Ke3?=
 =?us-ascii?Q?hiL3W5iU2iieikUUb273LvnZ/cP/rwuOg9OqeCIyp8bfBO1wdBvbNLWNkDYO?=
 =?us-ascii?Q?hyMrswbsRozGViDPPpewZgWsSe68feCGQ3Or?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 15:36:00.4781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f0a5301-2d55-4991-bb69-08dddb484570
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017098.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4269
X-Stat-Signature: 7qj7hosdqyxmg61cfgw9ggue9k5mo4bz
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A42214000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1755185763-889612
X-HE-Meta: U2FsdGVkX19X0Kf/JZsJdqdcQ+8BOjJueLUGBZg69/8k2D4d2mqPrC7J0IYVLp4hUjgNRzezFOzyGpmiEFGdGZVpn5J0j2Lc+vW1FhzMVv859OLjLxjnxecQpKikVgwfaFm1x4+T+vWtMIwDIl8DLpszMjcQtuDS3DQ6biN6cV0RxzYQ3FbGnArLk3QxzhzZoS/s4KQ7HlwFnBlCKuWcARvg5Cx7hXFwXUg4YhhLNtXMlg47DV3W5v0Mr5iMCXVxep6GAAFy+34xctqh+P0A0DmzSWF3V+UPIxiUo3ZeIg/AP97Nbcd+VUYH1CNuokMvZ3WPUa8u6ieOHpHMD2/CvZeNu4FhIMcvX3V2ftT5UMJnfV/lzTq3i8PXIgDhnloBC+ANQ6AxuATf/3BaYECe0d03NKTVROr2c9/c3fyWfzDkimq8Od156jANPy8sNrcF+6pqdkjhUjso4cRA6zm8sa8yjRnaew5fafljA1v9BrwDgCJvsE/JxU2G33v0G+LzA4QBNV5pSGATyHszPEKpiGQWXKyENSrnmPPnU9Xoi3SKIytn8q2tVEEe7DePlqQtfoj5l2QXwv2BOEXhV3aoQLfo40RPEGnaYXcwgpp8wssayEtCmGp6T435rrHi1mSI7sv7TG0nQQt2DUHjg8LPL4YQcp/+9GpUHz/gEQTqdnTajwsCtPTLyKoo3ttx8htThljS0g1bB4cLHB99XICm6xo5wHG1iZI09PUTa3W1j517kXx5lET1oXhOxXGDeXYnMx93bXkKpIOLY7HgsNTJ4YhREsB6Sv2lKW8z5vfRR3ih/54xo5dYh1quDw2z9DkyNQqEiDFtsm4fDw6sZ+RYzCHP6LCqKh7Z6KNDSpEIWPdItMbgfY7nub2h0B9s5DemvNEImEQS8S7W5XUBrg+c50ei4srCRt9DH6kjMMtQQ25czynRcuxHOV2BI0g3pP8Ha9MHSlFhDDLO2WN0pr8
 65vp3yv1
 nmju3K52TucVFtW4S9M7TswHm8WaT61x3CvGMvCGjIdudc0Xnfx7Pjg2cym02R8XbENOxbYlwqiiTMXd/tzM1nyE2qKhJBYOnwx7OtygyHYAYh98Rw9/IhhNMWRjAufulFemO1ZkKYciFxVU8bl3KKS9WUcQRmiWNDyA4OcJunOvamB0Oew7BGDv0h8yVFZn/l02fE05Ia69121slZA/SjPjjut9hkbJIZuRcCyq0I4ufDbKG8SWQWpBtHNYSHrPyYbv3S/l0KX9wdzb5qYSJo26TzYdTQuR0d44OkhoNE98gCNvdsKDpS/Uu+LL9mbilsJpon7Jq0wHx69o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add tracing support to track
 - start and end of scanning.
 - migration.

CC: Steven Rostedt <rostedt@goodmis.org>
CC: Masami Hiramatsu <mhiramat@kernel.org>
CC: linux-trace-kernel@vger.kernel.org

Signed-off-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 include/trace/events/kmem.h | 99 +++++++++++++++++++++++++++++++++++++
 mm/kscand.c                 |  9 ++++
 2 files changed, 108 insertions(+)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index f74925a6cf69..d6e544b067b9 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -9,6 +9,105 @@
 #include <linux/tracepoint.h>
 #include <trace/events/mmflags.h>
 
+#ifdef CONFIG_KSCAND
+DECLARE_EVENT_CLASS(kmem_mm_class,
+
+	TP_PROTO(struct mm_struct *mm),
+
+	TP_ARGS(mm),
+
+	TP_STRUCT__entry(
+		__field(	struct mm_struct *, mm		)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+	),
+
+	TP_printk("mm = %p", __entry->mm)
+);
+
+DEFINE_EVENT(kmem_mm_class, kmem_mm_enter,
+	TP_PROTO(struct mm_struct *mm),
+	TP_ARGS(mm)
+);
+
+DEFINE_EVENT(kmem_mm_class, kmem_mm_exit,
+	TP_PROTO(struct mm_struct *mm),
+	TP_ARGS(mm)
+);
+
+DEFINE_EVENT(kmem_mm_class, kmem_scan_mm_start,
+	TP_PROTO(struct mm_struct *mm),
+	TP_ARGS(mm)
+);
+
+TRACE_EVENT(kmem_scan_mm_end,
+
+	TP_PROTO( struct mm_struct *mm,
+		 unsigned long start,
+		 unsigned long total,
+		 unsigned long scan_period,
+		 unsigned long scan_size,
+		 int target_node),
+
+	TP_ARGS(mm, start, total, scan_period, scan_size, target_node),
+
+	TP_STRUCT__entry(
+		__field(	struct mm_struct *, mm		)
+		__field(	unsigned long,   start		)
+		__field(	unsigned long,   total		)
+		__field(	unsigned long,   scan_period	)
+		__field(	unsigned long,   scan_size	)
+		__field(	int,		 target_node	)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->start = start;
+		__entry->total = total;
+		__entry->scan_period  = scan_period;
+		__entry->scan_size    = scan_size;
+		__entry->target_node  = target_node;
+	),
+
+	TP_printk("mm=%p, start = %ld, total = %ld, scan_period = %ld, scan_size = %ld node = %d",
+		__entry->mm, __entry->start, __entry->total, __entry->scan_period,
+		__entry->scan_size, __entry->target_node)
+);
+
+TRACE_EVENT(kmem_scan_mm_migrate,
+
+	TP_PROTO(struct mm_struct *mm,
+		 int rc,
+		 int target_node,
+		 int msuccess,
+		 int mfailed),
+
+	TP_ARGS(mm, rc, target_node, msuccess, mfailed),
+
+	TP_STRUCT__entry(
+		__field(	struct mm_struct *, mm	)
+		__field(	int,   rc		)
+		__field(	int,   target_node	)
+		__field(	int,   msuccess		)
+		__field(	int,   mfailed		)
+	),
+
+	TP_fast_assign(
+		__entry->mm = mm;
+		__entry->rc = rc;
+		__entry->target_node = target_node;
+		__entry->msuccess = msuccess;
+		__entry->mfailed = mfailed;
+	),
+
+	TP_printk("mm = %p rc = %d node = %d msuccess = %d mfailed = %d ",
+		__entry->mm, __entry->rc, __entry->target_node,
+		__entry->msuccess, __entry->mfailed)
+);
+#endif
+
 TRACE_EVENT(kmem_cache_alloc,
 
 	TP_PROTO(unsigned long call_site,
diff --git a/mm/kscand.c b/mm/kscand.c
index e14645565ba7..273306f47553 100644
--- a/mm/kscand.c
+++ b/mm/kscand.c
@@ -1105,6 +1105,7 @@ static void kmigrated_migrate_mm(struct kmigrated_mm_slot *mm_slot)
 				count_kscand_migrate_failed();
 				mfailed++;
 			}
+			trace_kmem_scan_mm_migrate(mm, ret, dest, msuccess, mfailed);
 
 			kfree(info);
 
@@ -1308,6 +1309,9 @@ static unsigned long kscand_scan_mm_slot(void)
 	mm_target_node = READ_ONCE(mm->target_node);
 	if (mm_target_node != mm_slot_target_node)
 		WRITE_ONCE(mm->target_node, mm_slot_target_node);
+
+	trace_kmem_scan_mm_start(mm);
+
 	now = jiffies;
 
 	if (mm_slot_next_scan && time_before(now, mm_slot_next_scan))
@@ -1378,6 +1382,9 @@ static unsigned long kscand_scan_mm_slot(void)
 		kscand_update_mmslot_info(mm_slot, total, target_node);
 	}
 
+	trace_kmem_scan_mm_end(mm, address, total, mm_slot_scan_period,
+			mm_slot_scan_size, target_node);
+
 outerloop:
 	/* exit_mmap will destroy ptes after this */
 	mmap_read_unlock(mm);
@@ -1530,6 +1537,7 @@ void __kscand_enter(struct mm_struct *mm)
 	spin_unlock(&kscand_mm_lock);
 
 	mmgrab(mm);
+	trace_kmem_mm_enter(mm);
 	if (wakeup)
 		wake_up_interruptible(&kscand_wait);
 }
@@ -1540,6 +1548,7 @@ void __kscand_exit(struct mm_struct *mm)
 	struct mm_slot *slot;
 	int free = 0, serialize = 1;
 
+	trace_kmem_mm_exit(mm);
 	spin_lock(&kscand_mm_lock);
 	slot = mm_slot_lookup(kscand_slots_hash, mm);
 	mm_slot = mm_slot_entry(slot, struct kscand_mm_slot, slot);
-- 
2.34.1


