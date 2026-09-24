Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52478C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15ED16B00A1; Thu, 24 Sep 2026 02:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C12B6B00A2; Thu, 24 Sep 2026 02:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E8E6B00A4; Thu, 24 Sep 2026 02:23:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0756B00A1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:23:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAA1F140288
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:23:52 +0000 (UTC)
X-FDA: 85247665104.28.38C4F11
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	by imf22.hostedemail.com (Postfix) with ESMTP id A6398C0003
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:23:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Y8/0cplL";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of bharata@amd.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790231029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nb4S16mvi07CU8gvjSYsZm/mDw+vsAz78lTHXqCI1JY=;
	b=D6z8ZHChDoqGoHiCKbC7hK/eu7VuhNU+OBEfKSs/vkWbppcAErT5J2+8gsyxmpDD+KwKfE
	Ac76mpL7oJza6ekDC3+g70grjF3ZzX9n0ZrJaYER8jFQmWYfxuLjINYtUF8NhggeWx4zTi
	Ne1KOlSIc8T3IFTbWeXkC+QLfES8Swk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Y8/0cplL";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of bharata@amd.com designates 40.93.201.10 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790231029;
	b=AXOTZBFr6hyHyydtU+sH/bWCg3VytJcRifdvb1LsWM9S6mWgMfzUNHiJPYismZT7/9Rdxb
	YJWj3BIs0E+KrrLF1P/dJwmtJ648kxNrgB83rRCSbxC2ld6VwI2jOV9l2oNE6xe1+5KIMl
	y5nr9Aj0NoP1BHBd2qTlqSVSny/6ufc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QLA9VJgw1ZjZMHuMZtkqlCOfNfvaHQYFUFTm0mLH3ALFTu9RwO1Vh6M5fgaeakb3moQjh+JW8Ucfzpj51eFu87m9eduKBYGbekzAY8tYbskAMcssMDiH4YmgUgiH4YrUJurvI3HjDv4ooE9OVfJ0fVo29Xm2ZJERNftrbF9t0V7GArT7G8UGSKLi7yt/n40Z7fD2+lS+KRd3b/Sl32QiDikNxTY77iybtxBgVZaC9/29sqwualCzranFqEQfix4wAPLiIE4I4gda6xwL6aMEg2Qjv/hODaqlFtrtfSPcWlluwqq+YVCz2i06gXRKb+xoc8sCD7gubMFwHLVgzYE9hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nb4S16mvi07CU8gvjSYsZm/mDw+vsAz78lTHXqCI1JY=;
 b=FplmIkBmEo9scVIa3xgfptlrUM8QARgrk7HMxsHJnIFanxGu+XY6PYcZ7jZTmMvdHA6pmtTRYJTIIkHplC4AxMUwKjIl40FtfyundjpYzUV6PG/vNG98+7paJtVB2Eq2HvnJ4z7FdW9iWhoN8g/mKjTX4NjaOkQmQ9TMA79eiI1D9E6WgvB2v5LRT5y1jMsA3M4uowDOduIcYRgP5T490J/rbVRyS7oSJG1h49oLTChRQ3TSdA2KeqRd9wqdY7fZKwAfKSQaOhAyhNWkRvB0VYGxHBjSU+ZmI+7ZE9ThzASqlQiV9khiiySzwOZaVIeRlyk5+YPYKzTzbE4rV+dIMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nb4S16mvi07CU8gvjSYsZm/mDw+vsAz78lTHXqCI1JY=;
 b=Y8/0cplLvT251NkT4KE/zZ1W7vyESbsjk3CRVz/xRT8YLHy6ebqG57no4daFywLwo+F7al8kPDg3/oRPyVxolyNWzHDLntVwJ8L/zB5zrzT+K1azmhE/omo/C6tMploLQUcXLLUschSHqoHtzzYNoLg+tlSJF6OBmkiH60s0btA=
Received: from SA9P221CA0023.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::28)
 by IA1PR12MB7616.namprd12.prod.outlook.com (2603:10b6:208:427::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 06:23:22 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:806:25:cafe::6f) by SA9P221CA0023.outlook.office365.com
 (2603:10b6:806:25::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.16 via Frontend Transport; Thu,
 24 Sep 2026 06:23:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 24 Sep 2026 06:23:15 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 24 Sep
 2026 01:23:05 -0500
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<xin@zytor.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<Jonathan.Cameron@huawei.com>, <gourry@gourry.net>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <shivankg@amd.com>, <donettom@linux.ibm.com>,
	<linyongting@bytedance.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v0 2/3] x86/mm/ibs: In-kernel driver for AMD IBS Memory Profiler
Date: Thu, 24 Sep 2026 11:52:05 +0530
Message-ID: <20260924062206.319314-3-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260924062206.319314-1-bharata@amd.com>
References: <20260924062206.319314-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|IA1PR12MB7616:EE_
X-MS-Office365-Filtering-Correlation-Id: da4a502f-616c-4ddf-1f53-08df1a04514a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|1800799024|82310400026|56012099006|10067099003|11063799006|5023799004|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	4CzHKpdnuPODGIaQZInp8FVE1CDebo46TB6GazjeiA9aUWJhkygjWSf7SuzdB/0BFp1pKGFwb25gHevwxbpLyqlADGl00vGVDGzNsOD4izwStkYdVUaHbG1+sGJWoSadPLBKnIYJFrukbnVwaYoXev63NwDt52jOU4Bu82zZIx7TeRYRdgbRrJFGnQwQQ2daHEUvw/Xjbd690lK4UVEqT+dSl8ySXlQPwyJkS3Y3Rm7KG5EJGt6ORPhlUNLDUj/DUmWP1zRwphakEwTtxQBr9QtBipl/N/XzczSmSntsof4RUm7/V41cajkP5sUK+sUOwLEuzCkf2kCOR8tRDIRZBUoxqqcaA4mP2PSjtNp4nlq2stMASwjAv7dOLRwpALpicBYSZ77xL+SP0dw3FiyrDph17B8e6hzNt/C0I986bPbjcXQ267w3wUB178kpsXeMoHGyQhkicmPdq5bx61wnutkJi8LnsIo4+76gpwLtvlWGgwFFZh0FUxANdcGqaZPe2H36aPUt9CS9PkeJcQJy/hSzHsRMxeN2QoEbeFa3RnX7jinPWl+T6zOSA1UMhRwweKHPkB4KIrjV9Jw2aEGLTFBdRSaFqPHVjkUGM4iem55xZicJlupIovCY8E8rXsOlPGRhZmhcsLvxx1BAqxgUGr1rJarCWhCAq0KrcVHpglGT2nwaDStm/VuwQiVfVWJ8y55J3a4DFwk7ocMNADWA0w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(1800799024)(82310400026)(56012099006)(10067099003)(11063799006)(5023799004)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+7qqmZqUyZQeoILFKSwZDOmXseaiGcCwVJixLZfv9U72JTHlah1lCmB5eOGlzV0KxO5LyOR7kGqzjbl5U2PmunLXi0oz1OxRsPp4KJm+RZzBVwQmdvp2xF0PGyqB2pNq4l8QB7tSr1t8z6hPYaZBnOS4rZTNzjms7PAoW20BKRtQPlaPox2QIsEEgF3Va/m44fBN6KXAVc1iszWQtYIdl+ItdDTavywd2CBwVOTvAtl+DhsjbhnOrJ2VMuAp6acn6/MPtPsFsE2elPwSvM87EmrT0k6Pu1SQL7v7x3ncaDeuO2pTtEBdkXLyjzDitxCgTCqGM0al2JA9pLHt7yZZm/5I5e072W1caAHRaKFcy0Bb7g61A38tkxX4ft9eBe+F4nXNL2abfzDXJ5NqO08ZiuyOycRbmVFkHT1SoPzKarQTMC6sEPgJR+a+y59/DLk6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 06:23:15.5513
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: da4a502f-616c-4ddf-1f53-08df1a04514a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7616
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A6398C0003
X-Stat-Signature: g53f8f3i81e9zyxpbhs935qtd468rbco
X-HE-Tag: 1790231029-120501
X-HE-Meta: U2FsdGVkX19sJr21jbWsep23P7F44lPZvvzjqudoCfbFH+xaVQIcf6LTrcBb9AoApLTHfsyBubkZqpDLXgHbYJxRhJ06xpIlaqHyEkPMl97CbdEGrIIlf3yg75FY4Lc89EcIGEUOyF89QVEmZ2/+uVvLvD4rIxPFZ9PTpphNVXYwLefO1JJT7cYLBsvgbAoiQieQhnSj5ojqTpvgh3RgVgu030wqz/RhAuxiHCAgNSsAvYwodP0ZYrGlew+oK+wztzYCc64Kxa0iI39QE6t42jQuNLUvcfS+uA5wnBUC5vrwAhnWZ08HNvwAoB6mIrne/aKMEuVSJzNyVem7ilLjQRhyAf1hxL5+Bnaz+SgqLfJnchkJVK3kK1gQtPzKqK5pIRwmqty9mtzHN5S75LguuSU2VT7zboPwc9r0xUYYaQRRuXedE6YHl7VF2HALZaHjYxDfUBzixLNXKtbpSR2WeFru/JiRFCK2HEIIcESyzC6H+72Z8a/D171qmbUCnOYfwFlVc0BkVY3EM2D6TFMECePB8ddqZ7IjdXlHgd0ZBn+r6HVWZwnm72TlzZ5EbJJi53qziHwe1+sV1fVhuNAIx4FbKLZVoOComj6S6n2KPGSLb5f89Idi5xjtJSO27AWxWr772Ws98QJR1INmVK9Qnlj8a3KwxKP3w6iKQH1l2khjl/zTc9E4dM0woVcXtW3pwdrZURnODKXtfbgkb+NjhBIAvjeTfd5axrgDpWQmGM1aFigNuzdM2/tBtZxKO20WnuQmuPXGIVPrD4qwYAB0+My8/4rrLI5GRsRKzEHRAce++CeNVlw7xAxwRm5roY7DGvtS1tGA1D/C6aViCIeSEfVK7AWGrqz6TpYa0xi/bRdgh9d+tZx2WyCdovuWOlCIu7h6Nhas3mvSAwDYI3NMzo8dSHroWgiHIEapPOzz7lEyoGSkVibGppfyhL7xPh2wTy4XPtDO3dJMCuOn2Bd
 w6oP66DH
 6RgGtXzM1oUoiORmzCKFdjmVQ3pGKMmJ4LINImBGiN+d6gMDuqNbf82cyv5T6ZmzCT5sV0KbocS90b9CfxDiuwI87dHy969Z3DTKMAMLDt/79SzUTwtCJsH7zv/a9S30NUAhx1BWgMx1iEQvd8khXXVgX3Vi5v6JFREJKxTTx6qIwzkPwU75S15Gu+S6mwvdjO/borgZxENkSEllSi0QJnIW8LcP5S8eymkYMC/15uRgwgSUrsm9FTO6hFAH8JQHnOiB4sATdGP0MZGJCZmYO/eyQ42PJflOs21kg0tP5oaFhtoLdAIpb3Yu+fdbYoAolJgv0tDGjRMcSaEcpNiYqqItqawgjca/Fjs6LnHIyVrZ3g3DfMBf35aoV3jnhJv0VVQv7osKc/GwWYGHKc9hHtUXE1vlsFuh6xt+mJbZZaAv5b63ginFy79SX/B2BDI8eOI+cPI9CJc/CvYaW765MNiiuCXofjTb5yb8++BrraQscwcBlaoApXkBheXYTOoBNN1CfdRGNQbzGTSrGi89mNzqtTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use IBS (Instruction Based Sampling) Memory Profiler feature
present in AMD Zen6 processors for memory access tracking. The
access information obtained from IBS Memory Profiler is fed to
pghot sub-system for further action using
pghot_record_access(PGHOT_HWHINTS, ...) API.

IBS Memory Profiler as page hotness source is enabled by the
new config option HWMEM_PROFILER.

New system vector 0xea is used for memprofiler interrupt.

This commit adds the driver infrastructure (interrupt setup,
per-CPU ring, workqueue, cpuhp state, pghot call site etc) but
the profiler isn't armed yet and that is done in the next commit.

Register cpuhp on CPUHP_AP_ONLINE_DYN (after workqueue online) so
offline teardown disarms the producer and flush_work() runs while
the per-CPU worker is still bound, before workqueue unbind.

More details about IBS Memory Profiler can be obtained from
the AMD document titled "AMD64 Zen6 Instruction Based Sampling (IBS)
Extensions and Features".

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/pghot.rst |  42 +++
 arch/x86/Kconfig                       |  16 +
 arch/x86/entry/entry_fred.c            |   1 +
 arch/x86/include/asm/hardirq.h         |   3 +
 arch/x86/include/asm/ibs-caps.h        |   8 +
 arch/x86/include/asm/ibs-mprof.h       |  47 +++
 arch/x86/include/asm/idtentry.h        |   6 +
 arch/x86/include/asm/irq_vectors.h     |   4 +-
 arch/x86/include/asm/msr-index.h       |   8 +
 arch/x86/kernel/idt.c                  |   3 +
 arch/x86/kernel/irq.c                  |   3 +
 arch/x86/mm/Makefile                   |   1 +
 arch/x86/mm/ibs-mprof.c                | 482 +++++++++++++++++++++++++
 include/linux/vm_event_item.h          |   8 +
 mm/Kconfig                             |   9 +
 mm/vmstat.c                            |   8 +
 16 files changed, 648 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/include/asm/ibs-mprof.h
 create mode 100644 arch/x86/mm/ibs-mprof.c

diff --git a/Documentation/admin-guide/mm/pghot.rst b/Documentation/admin-guide/mm/pghot.rst
index c7242dc04ea2..df8316175207 100644
--- a/Documentation/admin-guide/mm/pghot.rst
+++ b/Documentation/admin-guide/mm/pghot.rst
@@ -117,3 +117,45 @@ This source is enabled by default through the hint faults bit (0x1) of
 to promote hot pages. It can be disabled at runtime by clearing that bit:
 
 # echo 0x0 > /proc/sys/vm/pghot_enabled_sources
+
+Hardware Hints Source
+=====================
+pghot can consume memory access samples reported by hardware profilers.
+This "hardware hints" (hwhints) source feeds hardware-observed accesses
+into pghot for hot page detection and promotion.
+
+Generic in-kernel support for such profilers is controlled by the
+HWMEM_PROFILER config option. It is not enabled directly by the user;
+an in-kernel driver that forwards hardware-observed accesses to pghot
+selects it.
+
+The AMD IBS Memory Profiler (config AMD_IBS_MEMPROF, available on Zen6
+and later AMD CPUs) is one such driver. It uses the AMD Instruction
+Based Sampling (IBS) Memory Profiler facility to sample user memory
+accesses and record them with pghot.
+
+This source can be activated at runtime through the hardware
+hints bit (0x2) of **pghot_enabled_sources**.
+
+# echo 0x2 > /proc/sys/vm/pghot_enabled_sources
+
+HWHINTS Vmstat Counters
+=======================
+Following vmstat counters provide some stats about hardware hints source.
+
+Path: /proc/vmstat
+
+1. **hwhint_total_events**
+   - Number of total hwhint events recorded by hwhints source.
+
+2. **hwhint_useful_events**
+   - Number of actionable events from hwhints source.
+
+3. **hwhint_dropped_events**
+   - Number of events that were dropped due to buffer overrun.
+
+4. **hwhint_dram_accesses**
+   - Number of DRAM accesses reported by hwhints source.
+
+5. **hwhint_extmem_accesses**
+   - Number of external memory (like CXL) accesses reported by hwhints source.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 15fd9ec5ecac..a25fbe201840 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1505,6 +1505,22 @@ config AMD_MEM_ENCRYPT
 	  This requires an AMD processor that supports Secure Memory
 	  Encryption (SME).
 
+config AMD_IBS_MEMPROF
+	bool "AMD IBS Memory Profiler"
+	depends on X86_64 && CPU_SUP_AMD
+	depends on PGHOT
+	select HWMEM_PROFILER
+	help
+	  Use the AMD Instruction Based Sampling (IBS) Memory Profiler
+	  facility (present on Zen6 and later AMD CPUs) to feed
+	  hardware-observed memory accesses into the pghot subsystem
+	  for hot-page detection and promotion.
+
+	  When disabled, no IBS Memory Profiler MSRs are programmed and
+	  the corresponding interrupt handler is not installed.
+
+	  If unsure, say N.
+
 # Common NUMA Features
 config NUMA
 	bool "NUMA Memory Allocation and Scheduler Support"
diff --git a/arch/x86/entry/entry_fred.c b/arch/x86/entry/entry_fred.c
index fb3594ddf731..f52099e3fa85 100644
--- a/arch/x86/entry/entry_fred.c
+++ b/arch/x86/entry/entry_fred.c
@@ -120,6 +120,7 @@ static idtentry_t sysvec_table[NR_SYSTEM_VECTORS] __ro_after_init = {
 	SYSVEC(POSTED_INTR_NESTED_VECTOR,	kvm_posted_intr_nested_ipi),
 
 	SYSVEC(POSTED_MSI_NOTIFICATION_VECTOR,	posted_msi_notification),
+	SYSVEC(IBS_MEMPROF_VECTOR,		ibs_memprof),
 };
 
 static bool fred_setup_done __initdata;
diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index dea60d66d976..2da4930ea399 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -49,6 +49,9 @@ enum irq_stat_counts {
 #endif
 #ifdef CONFIG_X86_POSTED_MSI
 	IRQ_COUNT_POSTED_MSI_NOTIFICATION,
+#endif
+#ifdef CONFIG_AMD_IBS_MEMPROF
+	IRQ_COUNT_IBS_MEMPROF,
 #endif
 	IRQ_COUNT_PIC_APIC_ERROR,
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/include/asm/ibs-caps.h b/arch/x86/include/asm/ibs-caps.h
index ddf6c512c8f9..1f6c4058a0e3 100644
--- a/arch/x86/include/asm/ibs-caps.h
+++ b/arch/x86/include/asm/ibs-caps.h
@@ -29,6 +29,7 @@
 #define IBS_CAPS_FETCHLAT		(1U<<14)
 #define IBS_CAPS_BIT63_FILTER		(1U<<15)
 #define IBS_CAPS_STRMST_RMTSOCKET	(1U<<16)
+#define IBS_CAPS_MEM_PROFILER		(1U<<18)
 #define IBS_CAPS_OPDTLBPGSIZE		(1U<<19)
 
 #define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
@@ -42,6 +43,13 @@
 #define IBSCTL_LVT_OFFSET_VALID		(1ULL<<8)
 #define IBSCTL_LVT_OFFSET_MASK		0x0F
 
+/*
+ * IBS Memprofiler setup
+ */
+#define IBSCTL_MPROF_LVT_OFFSET_VALID	(1ULL << 24)
+#define IBSCTL_MPROF_LVT_OFFSET_SHIFT	16
+#define IBSCTL_MPROF_LVT_OFFSET_MASK	(0xFULL << IBSCTL_MPROF_LVT_OFFSET_SHIFT)
+
 /* IBS fetch bits/masks */
 #define IBS_FETCH_L3MISSONLY		      (1ULL << 59)
 #define IBS_FETCH_RAND_EN		      (1ULL << 57)
diff --git a/arch/x86/include/asm/ibs-mprof.h b/arch/x86/include/asm/ibs-mprof.h
new file mode 100644
index 000000000000..3de1880c4126
--- /dev/null
+++ b/arch/x86/include/asm/ibs-mprof.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_IBS_MPROF_H
+#define _ASM_X86_IBS_MPROF_H
+
+/*
+ * All bits are documented here for clarity even if the current
+ * driver doesn't use all of them.
+ */
+
+/* MSR_AMD64_IBS_MPROF_DATA2 bits */
+#define IBS_MPROF_DATA2_DATASRC_MASK		0x7
+#define IBS_MPROF_DATA2_DATASRC_MASK_HIGH	0xC0
+#define IBS_MPROF_DATA2_DATASRC_MASK_HIGH_SHIFT	0x3
+#define IBS_MPROF_DATA2_DATASRC_LCL_CCX		0x1
+#define IBS_MPROF_DATA2_DATASRC_PEER_CCX_NEAR	0x2
+#define IBS_MPROF_DATA2_DATASRC_DRAM		0x3
+#define IBS_MPROF_DATA2_DATASRC_CCX_FAR		0x5
+#define IBS_MPROF_DATA2_DATASRC_DRAM_FAR	0x7
+#define IBS_MPROF_DATA2_DATASRC_EXT_MEM		0x8
+#define IBS_MPROF_DATA2_RMT_NODE		BIT_ULL(4)
+#define IBS_MPROF_DATA2_RMT_SOCKET		BIT_ULL(9)
+
+/* MSR_AMD64_IBS_MPROF_DATA3 bits */
+#define IBS_MPROF_DATA3_LDOP		BIT_ULL(0)
+#define IBS_MPROF_DATA3_STOP		BIT_ULL(1)
+#define IBS_MPROF_DATA3_DCMISS		BIT_ULL(7)
+#define IBS_MPROF_DATA3_LADDR_VALID	BIT_ULL(17)
+#define IBS_MPROF_DATA3_PADDR_VALID	BIT_ULL(18)
+#define IBS_MPROF_DATA3_L2MISS		BIT_ULL(20)
+#define IBS_MPROF_DATA3_SW_PREFETCH	BIT_ULL(21)
+
+/* MSR_AMD64_IBS_MPROF_CTL bits */
+#define IBS_MPROF_CTL_CNT_CTL		BIT_ULL(19)
+#define IBS_MPROF_CTL_VAL		BIT_ULL(18)
+#define IBS_MPROF_CTL_ENABLE		BIT_ULL(17)
+#define IBS_MPROF_CTL_L3MISSONLY	BIT_ULL(16)
+#define IBS_MPROF_CTL_MAXCNT_MASK	0x0000FFFFULL
+#define IBS_MPROF_CTL_MAXCNT_EXT_MASK	(0x7FULL << 20)	/* separate upper 7 bits */
+
+/* MSR_AMD64_IBS_MPROF_CTL2 bits */
+#define IBS_MPROF_CTL2_DISABLE		BIT_ULL(0)
+#define IBS_MPROF_CTL2_EXCLUDE_USER	BIT_ULL(1)
+#define IBS_MPROF_CTL2_EXCLUDE_KERNEL	BIT_ULL(2)
+
+#define IBS_MPROF_SAMPLE_PERIOD	10000
+
+#endif /* _ASM_X86_IBS_MPROF_H */
diff --git a/arch/x86/include/asm/idtentry.h b/arch/x86/include/asm/idtentry.h
index f400cfac69a6..c98833f64a4f 100644
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -735,6 +735,12 @@ DECLARE_IDTENTRY_SYSVEC(POSTED_MSI_NOTIFICATION_VECTOR,	sysvec_posted_msi_notifi
 # define fred_sysvec_posted_msi_notification		NULL
 # endif
 
+# ifdef CONFIG_AMD_IBS_MEMPROF
+DECLARE_IDTENTRY_SYSVEC(IBS_MEMPROF_VECTOR,		sysvec_ibs_memprof);
+#else
+# define fred_sysvec_ibs_memprof			NULL
+#endif
+
 #if IS_ENABLED(CONFIG_HYPERV)
 DECLARE_IDTENTRY_SYSVEC(HYPERVISOR_CALLBACK_VECTOR,	sysvec_hyperv_callback);
 DECLARE_IDTENTRY_SYSVEC(HYPERV_REENLIGHTENMENT_VECTOR,	sysvec_hyperv_reenlightenment);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 85253fc8e384..575f880cb147 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -105,10 +105,12 @@
  */
 #define POSTED_MSI_NOTIFICATION_VECTOR	0xeb
 
+#define IBS_MEMPROF_VECTOR		0xea
+
 #define NR_VECTORS			 256
 
 #ifdef CONFIG_X86_LOCAL_APIC
-#define FIRST_SYSTEM_VECTOR		POSTED_MSI_NOTIFICATION_VECTOR
+#define FIRST_SYSTEM_VECTOR		IBS_MEMPROF_VECTOR
 #else
 #define FIRST_SYSTEM_VECTOR		NR_VECTORS
 #endif
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 3a8e51a0c9e8..6e13f53143b0 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1319,4 +1319,12 @@
 						* a #GP
 						*/
 
+/* AMD IBS Memory Profiler MSRs */
+#define MSR_AMD64_IBS_MPROF_CTL		0xc0010380
+#define MSR_AMD64_IBS_MPROF_CTL2	0xc0010381
+#define MSR_AMD64_IBS_MPROF_DATA2	0xc0010382
+#define MSR_AMD64_IBS_MPROF_DATA3	0xc0010383
+#define MSR_AMD64_IBS_MPROF_LINADDR	0xc0010384
+#define MSR_AMD64_IBS_MPROF_PHYADDR	0xc0010385
+
 #endif /* _ASM_X86_MSR_INDEX_H */
diff --git a/arch/x86/kernel/idt.c b/arch/x86/kernel/idt.c
index 90a22e24a9eb..50ec5fc82619 100644
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -169,6 +169,9 @@ static const __initconst struct idt_data apic_idts[] = {
 # ifdef CONFIG_X86_POSTED_MSI
 	INTG(POSTED_MSI_NOTIFICATION_VECTOR,	asm_sysvec_posted_msi_notification),
 # endif
+#ifdef CONFIG_AMD_IBS_MEMPROF
+	INTG(IBS_MEMPROF_VECTOR,		asm_sysvec_ibs_memprof),
+#endif
 #endif
 };
 
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 30122f0b3af9..c59a474d9202 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -121,6 +121,9 @@ static const struct irq_stat_info irq_stat_info[IRQ_COUNT_MAX] = {
 #endif
 #ifdef CONFIG_X86_POSTED_MSI
 	ISS(POSTED_MSI_NOTIFICATION,	"PMN",	"  Posted MSI notification event\n"),
+#endif
+#ifdef CONFIG_AMD_IBS_MEMPROF
+	ISS(IBS_MEMPROF,		"IMP",	"  IBS Memory Profiler interrupts\n"),
 #endif
 	IDS(PIC_APIC_ERROR,		"ERR",	"  PIC/APIC error interrupts\n"),
 #ifdef CONFIG_X86_IO_APIC
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 3a5364853eab..050a7379d9f7 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -59,3 +59,4 @@ obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
 
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_boot.o
+obj-$(CONFIG_AMD_IBS_MEMPROF)	+= ibs-mprof.o
diff --git a/arch/x86/mm/ibs-mprof.c b/arch/x86/mm/ibs-mprof.c
new file mode 100644
index 000000000000..a455fdc60d8e
--- /dev/null
+++ b/arch/x86/mm/ibs-mprof.c
@@ -0,0 +1,482 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt)	"amd_ibs_memprof: " fmt
+
+#include <linux/init.h>
+#include <linux/pghot.h>
+#include <linux/percpu.h>
+#include <linux/workqueue.h>
+#include <linux/mm.h>
+#include <linux/vm_event_item.h>
+#include <linux/vmstat.h>
+#include <linux/cpuhotplug.h>
+#include <linux/syscore_ops.h>
+
+#include <asm/ibs-mprof.h>
+#include <asm/ibs-caps.h>
+#include <asm/irq_vectors.h>
+#include <asm/idtentry.h>
+#include <asm/apic.h>
+#include <asm/cpuid/api.h>
+
+#define IBS_NR_SAMPLES		150	/* Percpu sample buffer size */
+
+static DEFINE_PER_CPU(bool, mprof_work_pending);
+
+/*
+ * Basic access info captured for each memory access.
+ */
+struct mprof_sample {
+	unsigned long pfn;
+	unsigned long time;	/* jiffies when accessed */
+	int nid;		/* Accessing node ID, if known */
+};
+
+/*
+ * Percpu buffer of access samples. Samples are accumulated here
+ * before pushing them to pghot sub-system for further action.
+ */
+struct mprof_sample_pcpu {
+	struct mprof_sample samples[IBS_NR_SAMPLES];
+	int head, tail;
+};
+
+static struct mprof_sample_pcpu __percpu *mprof_s;
+
+/*
+ * Per-CPU work for pushing the percpu access samples to pghot sub-system.
+ *
+ * @cpu records which CPU's sample ring this work item is responsible for
+ * draining.
+ */
+struct mprof_worker {
+	struct work_struct work;
+	unsigned int cpu;
+};
+static DEFINE_PER_CPU(struct mprof_worker, mprof_work);
+static int mprof_cpuhp_state = CPUHP_INVALID;
+
+/*
+ * Record the IBS-reported access sample in percpu buffer.
+ * Called from IBS interrupt handler.
+ */
+static bool mprof_push_sample(unsigned long pfn, int nid, unsigned long time)
+{
+	struct mprof_sample_pcpu *pcpu = raw_cpu_ptr(mprof_s);
+	int head = READ_ONCE(pcpu->head);
+	int tail = READ_ONCE(pcpu->tail);
+	int next = head + 1;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	if (next == tail) {
+		count_vm_event(HWHINT_DROPPED_EVENTS);
+		return false;
+	}
+
+	pcpu->samples[head].pfn = pfn;
+	pcpu->samples[head].time = time;
+	pcpu->samples[head].nid = nid;
+
+	/*
+	 * Publish the sample slot stores before advancing head; pairs
+	 * with the smp_load_acquire() of head in mprof_pop_sample().
+	 */
+	smp_store_release(&pcpu->head, next);
+	return true;
+}
+
+static bool mprof_pop_sample(struct mprof_sample_pcpu *pcpu, struct mprof_sample *s)
+{
+	int tail = READ_ONCE(pcpu->tail);
+	/*
+	 * Pairs with the smp_store_release() of head in mprof_push_sample();
+	 * ensures the sample slot stores are visible before we read the slot.
+	 */
+	int head = smp_load_acquire(&pcpu->head);
+	int next = tail + 1;
+
+	if (head == tail)
+		return false;
+
+	if (next >= IBS_NR_SAMPLES)
+		next = 0;
+
+	*s = pcpu->samples[tail];
+
+	/*
+	 * Publish the freed slot via tail with release semantics so the plain
+	 * sample read above cannot be reordered past it. The ring's one-empty-
+	 * slot invariant already keeps the producer from ever writing the slot
+	 * being read, so this is not strictly required on x86; it makes the
+	 * ordering explicit and symmetric with the head release/acquire, at no
+	 * runtime cost (compiler barrier only).
+	 */
+	smp_store_release(&pcpu->tail, next);
+	return true;
+}
+
+/*
+ * Drain any samples remaining in @cpu's ring into pghot. Called from the
+ * cpuhp offline callback after flush_work(), with the producer silenced.
+ */
+static void mprof_drain_ring(unsigned int cpu)
+{
+	struct mprof_sample_pcpu *pcpu = per_cpu_ptr(mprof_s, cpu);
+	struct mprof_sample s;
+
+	while (mprof_pop_sample(pcpu, &s))
+		pghot_record_access(s.pfn, s.nid, PGHOT_HWHINTS, s.time);
+}
+
+/*
+ * Remove access samples from percpu buffer and send them
+ * to pghot sub-system for further action.
+ */
+static void mprof_work_handler(struct work_struct *work)
+{
+	struct mprof_worker *mw = container_of(work, struct mprof_worker, work);
+	unsigned int cpu = mw->cpu;
+	struct mprof_sample_pcpu *pcpu = per_cpu_ptr(mprof_s, cpu);
+	struct mprof_sample s;
+
+	for (;;) {
+		while (mprof_pop_sample(pcpu, &s))
+			pghot_record_access(s.pfn, s.nid, PGHOT_HWHINTS,
+					    s.time);
+
+		/*
+		 * Publish the cleared pending flag before re-checking the
+		 * ring so a racing IRQ cannot leave a just-pushed sample
+		 * unprocessed.
+		 */
+		WRITE_ONCE(per_cpu(mprof_work_pending, cpu), false);
+
+		if (READ_ONCE(pcpu->head) == READ_ONCE(pcpu->tail))
+			return;
+
+		/*
+		 * A sample was pushed after we exited the drain loop; the
+		 * producer may have skipped re-queuing because pending was
+		 * still set. Keep draining until the ring is observably empty
+		 * with pending cleared.
+		 */
+	}
+}
+
+/*
+ * L3MissOnly + Exclude kernel RIP
+ */
+static void mprof_enable_profiling(void)
+{
+	u64 mprof_config = IBS_MPROF_CTL_CNT_CTL | IBS_MPROF_CTL_L3MISSONLY;
+	unsigned int period = IBS_MPROF_SAMPLE_PERIOD;
+	u64 ctl, ctl2;
+
+	/*
+	 * Assemble bits 26:20 and 19:4 of periodic op counter in ctl.
+	 * The lower 4 bits are always 0000b.
+	 */
+	ctl = (period >> 4) & IBS_MPROF_CTL_MAXCNT_MASK;
+	ctl |= (period & IBS_MPROF_CTL_MAXCNT_EXT_MASK);
+	ctl |= mprof_config;
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL, ctl);
+
+	/*
+	 * Exclude samples that have bit 63 of their RIP set.
+	 */
+	ctl2 = IBS_MPROF_CTL2_EXCLUDE_KERNEL;
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL2, ctl2);
+}
+
+static void mprof_disable_profiling(u64 mem_ctl)
+{
+	mem_ctl &= ~IBS_MPROF_CTL_ENABLE;
+	mem_ctl &= ~IBS_MPROF_CTL_VAL;
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL, mem_ctl);
+
+	wrmsrq(MSR_AMD64_IBS_MPROF_CTL2, IBS_MPROF_CTL2_DISABLE);
+}
+
+/*
+ * IBS interrupt handler: Process the memory access info reported by IBS.
+ *
+ * Reads the MSRs to collect all the information about the reported
+ * memory access, validates the access, stores the valid sample and
+ * schedules the work on this CPU to further process the sample.
+ */
+static void mprof_overflow_handler(void)
+{
+	u64 mem_ctl, mem_data3, mem_data2, paddr, data_src;
+	struct work_struct *w = &this_cpu_ptr(&mprof_work)->work;
+	unsigned long pfn;
+	struct page *page;
+
+	rdmsrq(MSR_AMD64_IBS_MPROF_CTL, mem_ctl);
+	if (!(mem_ctl & IBS_MPROF_CTL_VAL))
+		return;
+
+	mprof_disable_profiling(mem_ctl);
+	count_vm_event(HWHINT_TOTAL_EVENTS);
+
+	rdmsrq(MSR_AMD64_IBS_MPROF_DATA3, mem_data3);
+
+	/* Data source is valid only if the sample isn't an L1 or L2 hit */
+	if (!(mem_data3 & (IBS_MPROF_DATA3_DCMISS | IBS_MPROF_DATA3_L2MISS))) {
+		count_vm_event(HWHINT_CACHE_ACCESSES);
+	} else {
+		rdmsrq(MSR_AMD64_IBS_MPROF_DATA2, mem_data2);
+		data_src = mem_data2 & IBS_MPROF_DATA2_DATASRC_MASK;
+		data_src |= ((mem_data2 & IBS_MPROF_DATA2_DATASRC_MASK_HIGH) >>
+				IBS_MPROF_DATA2_DATASRC_MASK_HIGH_SHIFT);
+
+		switch (data_src) {
+		case IBS_MPROF_DATA2_DATASRC_DRAM:
+		case IBS_MPROF_DATA2_DATASRC_DRAM_FAR:
+			/* local and remote DRAM are both DRAM accesses */
+			count_vm_event(HWHINT_DRAM_ACCESSES);
+			break;
+		case IBS_MPROF_DATA2_DATASRC_EXT_MEM:
+			count_vm_event(HWHINT_EXTMEM_ACCESSES);
+			break;
+		}
+	}
+
+	/* Is linear addr valid? */
+	if (!(mem_data3 & IBS_MPROF_DATA3_LADDR_VALID))
+		goto handled;
+
+	/* Is phys addr valid? */
+	if (!(mem_data3 & IBS_MPROF_DATA3_PADDR_VALID))
+		goto handled;
+	rdmsrq(MSR_AMD64_IBS_MPROF_PHYADDR, paddr);
+
+	pfn = PHYS_PFN(paddr);
+	page = pfn_to_online_page(pfn);
+	if (!page)
+		goto handled;
+
+	/*
+	 * Use the accessing CPU's node as the migration target. On
+	 * topologies where all CPUs reside on toptier nodes (the common
+	 * case), this is the desired behaviour.
+	 */
+	if (!mprof_push_sample(pfn, numa_node_id(), jiffies))
+		goto handled;
+
+	if (!this_cpu_read(mprof_work_pending)) {
+		this_cpu_write(mprof_work_pending, true);
+		schedule_work_on(smp_processor_id(), w);
+	}
+	count_vm_event(HWHINT_USEFUL_EVENTS);
+
+handled:
+	mprof_enable_profiling();
+}
+
+DEFINE_IDTENTRY_SYSVEC(sysvec_ibs_memprof)
+{
+	inc_irq_stat(IBS_MEMPROF);
+	mprof_overflow_handler();
+	apic_eoi();
+}
+
+static int get_mprof_lvt_offset(void)
+{
+	u64 val;
+
+	rdmsrq(MSR_AMD64_IBSCTL, val);
+	if (!(val & IBSCTL_MPROF_LVT_OFFSET_VALID))
+		return -EINVAL;
+
+	return (val & IBSCTL_MPROF_LVT_OFFSET_MASK) >>
+		IBSCTL_MPROF_LVT_OFFSET_SHIFT;
+}
+
+/*
+ * Confirm the IBS memory-profiler extended-LVT offset is valid and routable,
+ * mirroring the perf IBS driver's ibs_eilvt_valid(). The trial uses mask=1 so
+ * it programs nothing that can fire; the per-CPU startup callback unmasks it
+ * later. setup_APIC_eilvt() touches the local APIC, so this must run with
+ * preemption disabled.
+ */
+static bool mprof_eilvt_valid(void)
+{
+	int offset;
+	bool valid = false;
+
+	preempt_disable();
+
+	offset = get_mprof_lvt_offset();
+	if (offset < 0)
+		goto out;
+
+	if (!setup_APIC_eilvt(offset, IBS_MEMPROF_VECTOR, APIC_DELIVERY_MODE_FIXED, 1))
+		valid = true;
+out:
+	preempt_enable();
+	return valid;
+}
+
+/*
+ * Arm the memory profiler on the current CPU: route the extended-LVT entry
+ * to IBS_MEMPROF_VECTOR and program IBS from the published config snapshot.
+ * Runs on the target CPU (cpuhp ONLINE callback and syscore resume).
+ */
+static int mprof_arm_cpu(void)
+{
+	int offset = get_mprof_lvt_offset();
+
+	if (offset < 0) {
+		pr_warn("offset not valid on cpu #%d\n", smp_processor_id());
+		return -ENODEV;
+	}
+
+	if (setup_APIC_eilvt(offset, IBS_MEMPROF_VECTOR, APIC_DELIVERY_MODE_FIXED, 0)) {
+		pr_warn("APIC setup failed on cpu #%d\n", smp_processor_id());
+		return -EBUSY;
+	}
+
+	mprof_enable_profiling();
+	return 0;
+}
+
+/*
+ * Disarm the memory profiler on the current CPU: mask the extended-LVT entry
+ * (silences the producer) and clear the IBS enable/valid bits.
+ */
+static void mprof_disarm_cpu(void)
+{
+	int offset = get_mprof_lvt_offset();
+	u64 mem_ctl;
+
+	if (offset >= 0)
+		setup_APIC_eilvt(offset, IBS_MEMPROF_VECTOR, APIC_DELIVERY_MODE_FIXED, 1);
+
+	rdmsrq(MSR_AMD64_IBS_MPROF_CTL, mem_ctl);
+	mprof_disable_profiling(mem_ctl);
+}
+
+static int x86_amd_ibs_mprof_online(unsigned int cpu)
+{
+	/*
+	 * If profiler can't be armed, that must not stop
+	 * CPU online. Hence ignoring the return value of
+	 * mprof_arm_cpu().
+	 */
+	mprof_arm_cpu();
+	return 0;
+}
+
+static int x86_amd_ibs_mprof_offline(unsigned int cpu)
+{
+	struct mprof_worker *mw = per_cpu_ptr(&mprof_work, cpu);
+
+	WARN_ON(cpu != smp_processor_id());
+
+	/*
+	 * The teardown callback runs on this CPU before
+	 * CPUHP_AP_WORKQUEUE_ONLINE offline, while this CPU's worker is still
+	 * per-CPU bound. Silence the producer, flush the pending worker, then
+	 * drain any remaining ring samples synchronously.
+	 */
+	local_irq_disable();
+	mprof_disarm_cpu();
+	local_irq_enable();
+	flush_work(&mw->work);
+	mprof_drain_ring(cpu);
+	WRITE_ONCE(per_cpu(mprof_work_pending, cpu), false);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+/*
+ * The local APIC does not preserve the extended-LVT registers across S3/S4
+ * (lapic_suspend()/lapic_resume() save only the architectural LVTs), and the
+ * boot CPU never re-runs the cpuhp ONLINE callback on resume. Re-arm it via
+ * syscore so the profiler survives suspend/resume; secondary CPUs are handled
+ * by their offline/online cpuhp callbacks.
+ */
+static int mprof_suspend(void *data)
+{
+	mprof_disarm_cpu();
+	return 0;
+}
+
+static void mprof_resume(void *data)
+{
+	mprof_arm_cpu();
+}
+
+static const struct syscore_ops mprof_syscore_ops = {
+	.resume		= mprof_resume,
+	.suspend	= mprof_suspend,
+};
+
+static struct syscore mprof_syscore = {
+	.ops = &mprof_syscore_ops,
+};
+
+static void mprof_pm_init(void)
+{
+	register_syscore(&mprof_syscore);
+}
+#else
+static void mprof_pm_init(void) {}
+#endif
+
+static int __init mprof_access_profiling_init(void)
+{
+	u32 mprof_caps;
+	int cpu, ret;
+
+	if (!boot_cpu_has(X86_FEATURE_IBS))
+		return -ENODEV;
+
+	mprof_caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (!(mprof_caps & IBS_CAPS_MEM_PROFILER)) {
+		pr_info("capability is unavailable for access profiling\n");
+		return -ENODEV;
+	}
+
+	/*
+	 * Don't initialize the profiler if EILVT offset can't be armed.
+	 */
+	if (!mprof_eilvt_valid()) {
+		pr_info("extended-LVT offset unavailable; access profiling disabled\n");
+		return -EINVAL;
+	}
+
+	mprof_s = alloc_percpu_gfp(struct mprof_sample_pcpu, GFP_KERNEL | __GFP_ZERO);
+	if (!mprof_s)
+		return -ENOMEM;
+
+	for_each_possible_cpu(cpu) {
+		struct mprof_worker *mw = per_cpu_ptr(&mprof_work, cpu);
+
+		INIT_WORK(&mw->work, mprof_work_handler);
+		mw->cpu = cpu;
+	}
+
+	ret = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
+				"x86/amd/ibs_mprof:online",
+				x86_amd_ibs_mprof_online,
+				x86_amd_ibs_mprof_offline);
+	if (ret < 0)
+		goto out_free;
+	mprof_cpuhp_state = ret;
+
+	mprof_pm_init();
+
+	pr_info("IBS Memory Profiler is available for memory access profiling\n");
+	return 0;
+
+out_free:
+	free_percpu(mprof_s);
+	pr_info("IBS Memory Profiler failed to initialize\n");
+	return ret;
+}
+
+device_initcall(mprof_access_profiling_init);
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 90827e8b597f..ebd001fcf741 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -183,6 +183,14 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGHOT_RECORDED_ACCESSES,
 		PGHOT_REPORTED_HINTFAULTS,
 		PGHOT_REPORTED_HWHINTS,
+#ifdef CONFIG_HWMEM_PROFILER
+		HWHINT_TOTAL_EVENTS,
+		HWHINT_DRAM_ACCESSES,
+		HWHINT_EXTMEM_ACCESSES,
+		HWHINT_CACHE_ACCESSES,
+		HWHINT_USEFUL_EVENTS,
+		HWHINT_DROPPED_EVENTS,
+#endif /* CONFIG_HWMEM_PROFILER */
 #endif /* CONFIG_PGHOT */
 		NR_VM_EVENT_ITEMS
 };
diff --git a/mm/Kconfig b/mm/Kconfig
index 9237d54a6d8b..6ec71eb6f498 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1536,6 +1536,15 @@ config PGHOT_PRECISE
 	  4 bytes per page against the default one byte per page. Preferable
 	  to enable this on systems with multiple nodes in toptier.
 
+config HWMEM_PROFILER
+	bool
+	depends on PGHOT
+	help
+	  Umbrella symbol enabled by any in-kernel driver that forwards
+	  hardware-observed memory accesses to the pghot subsystem (for
+	  example AMD_IBS_MEMPROF on x86_64). Drivers select this; users
+	  do not enable it directly.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/vmstat.c b/mm/vmstat.c
index cbcbbbbbf297..570615d5f441 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1511,6 +1511,14 @@ const char * const vmstat_text[] = {
 	[I(PGHOT_RECORDED_ACCESSES)]		= "pghot_recorded_accesses",
 	[I(PGHOT_REPORTED_HINTFAULTS)]		= "pghot_reported_hintfaults",
 	[I(PGHOT_REPORTED_HWHINTS)]		= "pghot_reported_hwhints",
+#ifdef CONFIG_HWMEM_PROFILER
+	[I(HWHINT_TOTAL_EVENTS)]		= "hwhint_total_events",
+	[I(HWHINT_DRAM_ACCESSES)]		= "hwhint_dram_accesses",
+	[I(HWHINT_EXTMEM_ACCESSES)]		= "hwhint_extmem_accesses",
+	[I(HWHINT_CACHE_ACCESSES)]		= "hwhint_cache_accesses",
+	[I(HWHINT_USEFUL_EVENTS)]		= "hwhint_useful_events",
+	[I(HWHINT_DROPPED_EVENTS)]		= "hwhint_dropped_events",
+#endif /* CONFIG_HWMEM_PROFILER */
 #endif /* CONFIG_PGHOT */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
-- 
2.34.1


