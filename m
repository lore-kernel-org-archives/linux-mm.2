Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A130CD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AED96B0096; Mon,  4 May 2026 02:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E826B0098; Mon,  4 May 2026 02:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426316B0099; Mon,  4 May 2026 02:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2667C6B0096
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:10:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1D141C0925
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:45 +0000 (UTC)
X-FDA: 84728713650.26.9416A68
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012008.outbound.protection.outlook.com [40.107.209.8])
	by imf14.hostedemail.com (Postfix) with ESMTP id BECBD100012
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=F2oprmRN;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf14.hostedemail.com: domain of bharata@amd.com designates 40.107.209.8 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777875043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKkOxvZcc/lEXyHwHuHe7DdBQkLVKZm5h+kQktzq8ms=;
	b=py85ejrxwyXuIErPTrSSVeb4CxTve8+Doix3CRRZGv83l6NiENKhvr6KJ0YxPFSg3QVhMi
	IHoMsiAC1IA0Mkg5UrfSMBNewGTX2o03i9GoCDr1dcoNeiTDqVcs8hQhqWJDY2jkectZmK
	5FIyU9h8v3q+BdB/jwGnVdn3Af6mjzM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777875043; a=rsa-sha256;
	cv=pass;
	b=0+OFQokYi7ZUMgP9Dy0QReiwaUHaXkuIRlXHo77Q41s6U5XyRbn4e7rltjIpioQ6vqDGzQ
	VESsBdVPLfPr5hW/urdXaGoMgiBtJJo/C/Fsuz4id06e0+JCBU1DTm0qMouFz3kH4xx9p/
	IXtXEv7hvUnOD0of4tPNVlu4oJ/fxKI=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=F2oprmRN;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf14.hostedemail.com: domain of bharata@amd.com designates 40.107.209.8 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSITBQ4SiT76/2FYGvQ+fGu+6pCxKt7m+tYXzC2kZ8hEYqM/bFHnONjKR845gH7VhrytrPNht5HmvU7Yvfjn/E89ptxnPExO7WRlh9j4BHMzh2HHPXt4PxrctBW962mn10iMBZ+lXQWMFJ/98UMSv90LpCbu+Pm9dus667ojtTQWszJjKGErT38QVLKbXAUGrUnhP2wW/4qcnm0ukaLxkhajd6g41iem6J92/dwydFijE6H40wZpYDHps24qHnt3IhOn8BuETGlUJ6uyFFSc9e03/Zq/3Cew31Xt5UFO17nqjr72OZLvOXkF2kPxaCEVfRmt60lavbIojKfSGx34+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OKkOxvZcc/lEXyHwHuHe7DdBQkLVKZm5h+kQktzq8ms=;
 b=VScIK/iKQYM2VPutqljs4j/bHpVzRnG5QZPiOa8Noky239i2a603mdLqDka5gdhU+9vglnuZOuBmuzfiLApl9uURSrYAfAuTdy/T+Y1pT4DTBR9hK1VxSUcu+zHF7rpczbc7grJY7AGPwrjdROkXkInBRMIwXLRJgK4Cw/BhlfTjtwXe0YUH3d3yo17tBytZT3DGLmmavyJKBG7pRnthnI6UV1b//4dpjWZv6kMXq9Cuqf25KHxXFlELw89B5hIgXeL2IgabyWpT1UQONiLSf/61m7uoFB0Fk3cISmfH/N3EZw61nw8a3Z2sVX2JeN+Qhl1M4CCz81e8/Qg+39kPIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKkOxvZcc/lEXyHwHuHe7DdBQkLVKZm5h+kQktzq8ms=;
 b=F2oprmRNCphScDDwcVjyk+lKb8eqGtQmdkJGi/HdVhSsHqb1RrmLswCUTHpDeyBMOo2MSutyzuuycbr5eSL/2L640qHoSGrRwjrWiubxculCTCgNNXLdAw0ONwUOki4gpMAU0alEAA/0vVRrazh67qbdDQT+gyIbIcuwP/2zjtA=
Received: from CH5P222CA0015.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::13)
 by LV3PR12MB9257.namprd12.prod.outlook.com (2603:10b6:408:1b7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 06:10:36 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:1ee:cafe::18) by CH5P222CA0015.outlook.office365.com
 (2603:10b6:610:1ee::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 06:10:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Mon, 4 May 2026 06:10:36 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:10:27 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <mgorman@techsingularity.net>, <mingo@redhat.com>,
	<peterz@infradead.org>, <raghavendra.kt@amd.com>, <riel@surriel.com>,
	<rientjes@google.com>, <sj@kernel.org>, <weixugc@google.com>,
	<willy@infradead.org>, <ying.huang@linux.alibaba.com>, <ziy@nvidia.com>,
	<dave@stgolabs.net>, <nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>,
	<yiannis@zptcorp.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<byungchul@sk.com>, <kinseyho@google.com>, <joshua.hahnjy@gmail.com>,
	<yuanchu@google.com>, <balbirs@nvidia.com>, <alok.rathore@samsung.com>,
	<shivankg@amd.com>, <donettom@linux.ibm.com>, <bharata@amd.com>
Subject: [PATCH v7 4/7] mm: pghot: Precision mode for pghot
Date: Mon, 4 May 2026 11:39:21 +0530
Message-ID: <20260504060924.344313-5-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260504060924.344313-1-bharata@amd.com>
References: <20260504060924.344313-1-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|LV3PR12MB9257:EE_
X-MS-Office365-Filtering-Correlation-Id: 18507e61-4a3b-44d9-aa3e-08dea9a3db8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	99on9g/1DurDiEaYS3wZGy+2qYqlsz4isLyjwGBjxDzcmaMzn6xp3G5a6qjzOmSN/SSPTcj9lk8+gAjRt5uwsmrPM+ewPZOsTiMFEKbdudo3pwmq/fQVJ4jI5tifkiMj40joAPVH4w0jZKSjIoDsaNRcITq4auCV3Y6RKJOFO9zi5IlZrOZDTX1W55XVg5id12/MVRZJLVAJOKsNjM2o4GB/22ILDFcQ5rPxQpKjkQsm59OCOKNUROexHiTc/RiS8wsLdp42bVrFMeDRaEduNmTQKuxAhXzDzckmymyTookYiG28Mv2CG2iXWzZwkbYFmO5ivo0raIKWISiyR3D90DOPLmMF/c7R9sd6WNsmJpDB7XGYA+b8Z6MBVqWzyN2Hgf3Xo+5pr1jqbqPZ24xdU4hxbJ9r5DzkwUNh5GhuhMM/NjSqoIe+VVwnwTU1PWOzPII7a36CsZ0bw0KNu6GBsu2niiWC8C2PoYa0HAmUY6H5VfX9PSQ6ETDc4lBS8JBM5AWbqRcHVbehIVZrVEEHUDWNN+5cQuvkyQZzV5gVTEg86GIUNu8Ea/DWfC+E2TsPn8P2x8KqSkgWjCJfkxffEQt395FnbQYmTubyq4OqSaHfwfzmIOvmybqxNAm24KRiKAmNViCk7k4uKplUA8NLB+M4JRrhzKMr9L8KM3+aAcNYAhBMojkU15KqsINznPZpNcWcFYjJDQ/whJSJTgOb27VanN7yJos3bkWBRnFxjGs=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	xpM7qvBc9Zz2FtaGU9qXwQgT0jjxLarCWOt70k5DZYnhMDFf63rnW9R4beKcbzxeFmDaU1Wi/IYGqpbY8/UohOg0gnF7FQlVhWiRlhkLqc3IQuqVzBKGfE16ZJmKdx0MVmRkxvQK2HCe24abzfxi0eg3s7S6c1Zk9qt/BD6OrcXwVZBmNUi6S70qAs5zOoCWz1zC7gEQKDtMQ8d1LbzA7gD7RRNQi7HodnUKXLshSSPezsH9y5l5kOR7TofcvOK7CxbrYo+xMr9qHRTuMdDoV/HC4Nj0lnnXeT4w4nE8RjMh6hufuUtxkx7LDv0oTHGOZv+MVxmzlhI77l1G4eGREtJaqaCQs9Q9JF121P2cXQH4pIQu0rp9+Gk0ElvtAeZxLc7Y4wNqmwGI40efk7xbkS0DJtskhYZJprNGBv0EvUU+q0/B9SKUFc0Nk6smepKD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:10:36.0809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18507e61-4a3b-44d9-aa3e-08dea9a3db8c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9257
X-Rspam-User: 
X-Rspamd-Queue-Id: BECBD100012
X-Rspamd-Server: rspam04
X-Stat-Signature: widhp1tk3dmmh4a3d4jic3tcthzyjzuj
X-HE-Tag: 1777875042-7205
X-HE-Meta: U2FsdGVkX19MoDoFzp5TE0dIYFdcB6PF6R1yX2fSqpd/Yk6C7AEfl4zsVmC/Nr2ww3PLpQ7hLZaNX5WoaaHw3zwilTl7XRv4ohCUh1/pzbZU5iRBxR0epWPL7wVa2TeuWjQcgbsSiIOhRXjaDHackF0WcGiNkuP0yV3XbFk6BqdHi4BwPu5Edm6CDdDhr5bswZh2E8YvaVOvNOhcefxB9ioo2o/qSnOY417eXQGyyPysomxzzdv22glfvF7twKMyiSDquuH6BFVVqgLbMsoJFMXIUwXqis+/CZAuLHPYQozGhD8aOYjHyJwIBsWb6HDmlB3e4xV2aFXA8JOPjYUYMXczjVca1wix4drDWnnmTLPPxd+Bckrk8Lo8epl2juWyfIz82mtPjBKKMcovN0oxaEXIgZcbziIlQ+7Gw0nZMwcte/f1f1JlIBtVz2b+ERqWA/1QMgW+ZeGsapFeeLJz8IiT6ThaI/48HWe3bTZy/1P21B9QeU1pR/WQpfKWK4BIOmS3vOoqYzB3bolyNgHG83Aa5PUiNLlxzmzeyImrrnD/F+3pSZa70EEwi9ITeDzxWt9uY1h/dUWQtDqGMSWINleg19X6+MK4PzrvJR1sUlE6FaOPMHZByDUVszFZY6Ixz5GILv7ao3rs4HwXcOzTRdzSju3mLB8/3Lk7XxQ3ja9hgPISHruhvTA4tqw2pLx76VYpeTyca0GVWku4ZSoLIwWEnAcPt7iR5FUgIFVTk7LZL36SQ3UilPa7prY5htOsYa5akuS0F673+XfEyYQHawgdjPW/7cGdcVWpb1Oo6XYPmEr3jPdv2TyA507aLLCqBX8L5lRHwhpKAB6SERgZ2n3nGy2D4WI/9joUQ9gCQNha3F5XP1mJPAzTWnYga39C4sdDX3CMl6Gl7pwV/YGr3aeVVtWymbnpNX+o+kTsaSTaCJp9rIWg7rE9n6xJvf6KjkQywDpnV0WsQHC9Qzj
 cbUJLYYz
 lvJjoREd2GwCws5oQm718UOx9rdh1pdwQv1ljC1W2ZMq9r31bPu27J3tYRVVKTmaPWz/cw9xUm5SQFRUvOzmOkDqZs14XTH6RW0mKJlTDqQgNatdzykYu6Tt4fwqHUT30vcY8gGmgjVGfKeztbfOMVm2vZo8pFUhCqaTn1aNu1XbuBc/xsvJFWxpd2P1wcQ8ymRvxvQ7TxuSrqHC6cTGO3VKXrm070PAQK048/Yoyfb1stXp27u7fS2cJi6UegsiARBw4HMaudZCIIhHajw+niOhhNks1FEezCygTx9YqRMxCDI7mg71Ucd0xSTGMKuiKFmQIhG8S2p2lJSCVzS8E3KNU8HLCmvdSg+b1ikKIMb22YvVBn5TmtRTMenXMes55Itj1u7J24ChLuXxXApdcEQxlEDGfdeByxkoMJVdHM4axfY2hO+Z1UTyI+m2MBokgUFIhY39xgUWX6IctldflAKISbFotJ5/WetDeyXl+Ek21/QgG7qRQMWtv6lpqoTNgRyeiyffu0IPptq2M91qFI7HNqUCJNpslQNQfBrXzDPDHTO449OoMZNZKcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Default pghot stores hotness in a 1‑byte record per PFN, limiting
frequency to 2 bits, time to a 5‑bit bucket, and preventing storage
of per‑PFN toptier NID. This restricts time granularity and forces
all promotions to use the global pghot_target_nid.

This patch adds an optional precision mode (CONFIG_PGHOT_PRECISE)
that expands the hotness record to 4 bytes (u32) and provides:

- 10‑bit NID field for per‑PFN promotion target,
- 3‑bit frequency field (freq_threshold range 1–7),
- 14‑bit time field offering finer recency tracking,
- MSB migrate‑ready bit.

Precision mode improves placement accuracy on systems with multiple
toptier nodes and provides higher‑resolution hotness tracking, at
the cost of increasing metadata to 4 bytes per PFN.

Documentation, tunables, and the record layout are updated accordingly.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/pghot.rst |  4 +-
 include/linux/mmzone.h                 |  2 +-
 include/linux/pghot.h                  | 31 ++++++++++
 mm/Kconfig                             | 11 ++++
 mm/Makefile                            |  7 ++-
 mm/pghot-precise.c                     | 81 ++++++++++++++++++++++++++
 mm/pghot.c                             | 13 +++--
 7 files changed, 141 insertions(+), 8 deletions(-)
 create mode 100644 mm/pghot-precise.c

diff --git a/Documentation/admin-guide/mm/pghot.rst b/Documentation/admin-guide/mm/pghot.rst
index 5f51dd1d4d45..7b84e911afe7 100644
--- a/Documentation/admin-guide/mm/pghot.rst
+++ b/Documentation/admin-guide/mm/pghot.rst
@@ -37,7 +37,7 @@ Path: /sys/kernel/debug/pghot/
 
 3. **freq_threshold**
    - Minimum access frequency before a page is marked ready for promotion.
-   - Range: 1 to 3
+   - Range: 1 to 3 in default mode, 1 to 7 in precision mode.
    - Default: 2
    - Example:
      # echo 3 > /sys/kernel/debug/pghot/freq_threshold
@@ -59,7 +59,7 @@ Path: /proc/sys/vm/pghot_promote_freq_window_ms
 - Controls the time window (in ms) for counting access frequency. A page is
   considered hot only when **freq_threshold** number of accesses occur with
   this time period.
-- Default: 3000 (3 seconds)
+- Default: 3000 (3 seconds) in default mode and 5000 (5s) in precision mode.
 - Example:
   # sysctl vm.pghot_promote_freq_window_ms=3000
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index eb08431dc9fb..9577bdc575d9 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2027,7 +2027,7 @@ struct mem_section {
 #ifdef CONFIG_PGHOT
 	/*
 	 * Per-PFN hotness data for this section.
-	 * Array of phi_t (u8 in default mode).
+	 * Array of phi_t (u8 in default mode, u32 in precision mode).
 	 * LSB is used as PGHOT_SECTION_HOT_BIT flag.
 	 */
 	void *hot_map;
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
index 525d4dd28fc1..2e1742b8caee 100644
--- a/include/linux/pghot.h
+++ b/include/linux/pghot.h
@@ -35,6 +35,36 @@ DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
 
 #define PGHOT_DEFAULT_NODE		0
 
+#if defined(CONFIG_PGHOT_PRECISE)
+#define PGHOT_DEFAULT_FREQ_WINDOW	(5 * MSEC_PER_SEC)
+
+/*
+ * Bits 0-26 are used to store nid, frequency and time.
+ * Bits 27-30 are unused now.
+ * Bit 31 is used to indicate the page is ready for migration.
+ */
+#define PGHOT_MIGRATE_READY		31
+
+#define PGHOT_NID_WIDTH			10
+#define PGHOT_FREQ_WIDTH		3
+/* time is stored in 14 bits which can represent up to 16s with HZ=1000 */
+#define PGHOT_TIME_WIDTH		14
+
+#define PGHOT_NID_SHIFT			0
+#define PGHOT_FREQ_SHIFT		(PGHOT_NID_SHIFT + PGHOT_NID_WIDTH)
+#define PGHOT_TIME_SHIFT		(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
+
+#define PGHOT_NID_MASK			GENMASK(PGHOT_NID_WIDTH - 1, 0)
+#define PGHOT_FREQ_MASK			GENMASK(PGHOT_FREQ_WIDTH - 1, 0)
+#define PGHOT_TIME_MASK			GENMASK(PGHOT_TIME_WIDTH - 1, 0)
+
+#define PGHOT_NID_MAX			((1 << PGHOT_NID_WIDTH) - 1)
+#define PGHOT_FREQ_MAX			((1 << PGHOT_FREQ_WIDTH) - 1)
+#define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
+
+typedef u32 phi_t;
+
+#else	/* !CONFIG_PGHOT_PRECISE */
 #define PGHOT_DEFAULT_FREQ_WINDOW	(3 * MSEC_PER_SEC)
 
 /*
@@ -61,6 +91,7 @@ DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
 #define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
 
 typedef u8 phi_t;
+#endif /* CONFIG_PGHOT_PRECISE */
 
 #define PGHOT_RECORD_SIZE		sizeof(phi_t)
 
diff --git a/mm/Kconfig b/mm/Kconfig
index ebfa149d8123..cc4b5685ecd4 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1483,6 +1483,17 @@ config PGHOT
 	  This adds 1 byte of metadata overhead per page in lower-tier
 	  memory nodes.
 
+config PGHOT_PRECISE
+	bool "Hot page tracking precision mode"
+	default n
+	depends on PGHOT
+	help
+	  Enables precision mode for tracking hot pages with pghot sub-system.
+	  Adds fine-grained access time tracking and explicit toptier target
+	  NID tracking. Precise hot page tracking comes at the cost of using
+	  4 bytes per page against the default one byte per page. Preferable
+	  to enable this on systems with multiple nodes in toptier.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 33014de43acc..dc61f4d955f8 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -150,4 +150,9 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
-obj-$(CONFIG_PGHOT) += pghot.o pghot-tunables.o pghot-default.o
+obj-$(CONFIG_PGHOT) += pghot.o pghot-tunables.o
+ifdef CONFIG_PGHOT_PRECISE
+obj-$(CONFIG_PGHOT) += pghot-precise.o
+else
+obj-$(CONFIG_PGHOT) += pghot-default.o
+endif
diff --git a/mm/pghot-precise.c b/mm/pghot-precise.c
new file mode 100644
index 000000000000..8e571988b4ce
--- /dev/null
+++ b/mm/pghot-precise.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pghot: Precision mode
+ *
+ * 4 byte hotness record per PFN (u32)
+ * NID, time and frequency tracked as part of the record.
+ */
+
+#include <linux/pghot.h>
+#include <linux/jiffies.h>
+#include <linux/memory-tiers.h>
+
+bool pghot_nid_valid(int nid)
+{
+	if (nid != NUMA_NO_NODE &&
+	    (!numa_valid_node(nid) || nid > PGHOT_NID_MAX ||
+	     !node_online(nid) || !node_is_toptier(nid)))
+		return false;
+
+	return true;
+}
+
+unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
+{
+	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_MASK);
+}
+
+bool pghot_update_record(phi_t *phi, int nid, unsigned long now)
+{
+	phi_t freq, old_freq, hotness, old_hotness, old_time;
+	phi_t time = now & PGHOT_TIME_MASK;
+
+	nid = (nid == NUMA_NO_NODE) ? pghot_target_nid : nid;
+	old_hotness = READ_ONCE(*phi);
+
+	do {
+		bool new_window = false;
+
+		hotness = old_hotness;
+		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+
+		if (pghot_access_latency(old_time, time) > sysctl_pghot_freq_window)
+			new_window = true;
+
+		if (new_window)
+			freq = 1;
+		else if (old_freq < PGHOT_FREQ_MAX)
+			freq = old_freq + 1;
+		else
+			freq = old_freq;
+
+		hotness &= ~(PGHOT_NID_MASK << PGHOT_NID_SHIFT);
+		hotness &= ~(PGHOT_FREQ_MASK << PGHOT_FREQ_SHIFT);
+		hotness &= ~(PGHOT_TIME_MASK << PGHOT_TIME_SHIFT);
+
+		hotness |= (nid & PGHOT_NID_MASK) << PGHOT_NID_SHIFT;
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
+	*nid = (old_hotness >> PGHOT_NID_SHIFT) & PGHOT_NID_MASK;
+	*freq = (old_hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+	*time = (old_hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+	return 0;
+}
diff --git a/mm/pghot.c b/mm/pghot.c
index 02e6959b647a..0b31d5917833 100644
--- a/mm/pghot.c
+++ b/mm/pghot.c
@@ -10,6 +10,9 @@
  * the frequency of access and last access time. Promotions are done
  * to a default toptier NID.
  *
+ * In the precision mode, 4 bytes are used to store the frequency
+ * of access, last access time and the accessing NID.
+ *
  * A kernel thread named kmigrated is provided to migrate or promote
  * the hot pages. kmigrated runs for each lower tier node. It iterates
  * over the node's PFNs and  migrates pages marked for migration into
@@ -52,13 +55,15 @@ static bool kmigrated_started __ro_after_init;
  * for the purpose of tracking page hotness and subsequent promotion.
  *
  * @pfn: PFN of the page
- * @nid: Unused
+ * @nid: Target NID to where the page needs to be migrated in precision
+ *       mode but unused in default mode
  * @src: The identifier of the sub-system that reports the access
  * @now: Access time in jiffies
  *
- * Updates the frequency and time of access and marks the page as
- * ready for migration if the frequency crosses a threshold. The pages
- * marked for migration are migrated by kmigrated kernel thread.
+ * Updates the NID (in precision mode only), frequency and time of access
+ * and marks the page as ready for migration if the frequency crosses a
+ * threshold. The pages marked for migration are migrated by kmigrated
+ * kernel thread.
  *
  * Return: 0 on success and -EINVAL on failure to record the access.
  */
-- 
2.34.1


