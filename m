Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89BBCCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F28F6B00A5; Fri, 26 Jun 2026 05:38:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9D06B00AB; Fri, 26 Jun 2026 05:38:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0086B00AE; Fri, 26 Jun 2026 05:38:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B46A6B00A5
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:38:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8515167571
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:38:20 +0000 (UTC)
X-FDA: 84921563160.27.97DA8E0
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011064.outbound.protection.outlook.com [40.107.208.64])
	by imf10.hostedemail.com (Postfix) with ESMTP id A0C02C0002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:38:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nUPJjCyv;
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782466697;
	b=2WnzEe14jqPvq91JZZTqx3yR5btTXsHCtgRKVvytBv69+3z4qNe72tCXP+6J/FX1NbHHRF
	k0C+2eonJO3olpaQzlHQyf1HZ4JWISM7NUFJ1Ba6NVi2ZFvIDNWT138ie+GQ+8zHuMrdf8
	r8ethFUU1IXPFUpzqcaItXqRWAu5+FE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782466697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CrDYxZafPyy0kHy0L/DwRnSavN8HTbHvJTVJJ0Dbhe8=;
	b=4X5u+R74cZWfwoQoqjgl3K5WmRUsQ0/+NdWEsuBUqDWFD0eY1aY+yJjxJM1TGOWBSZMC//
	wW1lIYIQ77iBgzQcObnVZD4ysyRugEEdq2D1GJPKVCVcsMfDevlgr//bq2rI3CecpC7bc+
	VW7YZWMQ3kNpAeByRPT6ex7tbR/u4vk=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=nUPJjCyv;
	spf=pass (imf10.hostedemail.com: domain of shivankg@amd.com designates 40.107.208.64 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cZ5btNkoRyMi5bqKNgoOu1eGmdxHIGngH1w+EBkpIInAXri11XYAayoRQulJvQxIEU3neUq8SHA5OE/fo4Ux6sH7BMfCgPHRIJoa72s6LXMN8SLxCwLbdo2+A+ZZcXoBN4XaOJaGxD3JLzOK0MD6G5oOZXRSloRUdFbQis4wRhAkfEBDPO5dLPfeBReO7m0HofOLb9tnALZF1fYFud6v8LRLVzAYP4zDCRO4xV21EKTMst6ZFejYOMXIJqR6PpZLS08NLJ/9Y1Pu0pg6pdx/y/LWcdAKQBzCTOmJkhFQBXW0AdNkyFnd6tCTIkflfAyfoJ44ivpDHWj+4G3F06vBLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CrDYxZafPyy0kHy0L/DwRnSavN8HTbHvJTVJJ0Dbhe8=;
 b=vhbzZIxD6/B/K53bH06Q0e3F8nXR84zjSqczHeWdjMZgCTv7aJJLDyz6tKz8nkxa+KD6XYhoCHBsPNs+Tjhi7ThmevFCXuw0HfDvei4hd6ggp/DXQcbBQJ5BAcF2U4+fBh8kxR2qdXBcWurEZUzRBNMWxHDFG5b/DRHqLrqyZVpS9FEJ4WfWmB8ygMtc6CuOPaXDVmaNGN5U/qTgi9erZAVbSV37fvW7s+9GXERglKJ5K41iONbJE2KpynABNSp8jhaoI0G0mDYlfc5jSAQkO8RqgTPoV6Fz7ncPeU+9mv76HJF0UYJHZLXqFPveBSbov3WGAGN3jYee6fUxB3UeEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=sk.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CrDYxZafPyy0kHy0L/DwRnSavN8HTbHvJTVJJ0Dbhe8=;
 b=nUPJjCyvksOIM31oL1JQ9gf1UdtaN1+5NBi/V9CtjmxM2WpZC5sY7T4ojbUUOpj9D+fcXL44Cz3TQQPADzTLM4yYi3QRtcZu8Fa9fubtZ67PRGEXOfTPmp/pdKGjsa8CMjzrs+ZVA47P0+KIj5RkBVVSfV34ulTD70sjzpgPx/A=
Received: from CYZPR14CA0036.namprd14.prod.outlook.com (2603:10b6:930:a0::10)
 by CY8PR12MB7754.namprd12.prod.outlook.com (2603:10b6:930:86::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Fri, 26 Jun
 2026 09:38:12 +0000
Received: from CH1PEPF0000AD7A.namprd04.prod.outlook.com
 (2603:10b6:930:a0:cafe::4f) by CYZPR14CA0036.outlook.office365.com
 (2603:10b6:930:a0::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.159.17 via Frontend Transport; Fri,
 26 Jun 2026 09:38:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD7A.mail.protection.outlook.com (10.167.244.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Fri, 26 Jun 2026 09:38:11 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Fri, 26 Jun
 2026 04:38:06 -0500
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH 0/3] mm/migrate: preparatory cleanups for batch copy and
 offload
Date: Fri, 26 Jun 2026 09:37:47 +0000
Message-ID: <20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAGtIPmoC/x2MQQqAIBAAvxJ7bsEsFPpKdFhsq4Uy0YpA+nvSc
 QZmMiSOwgn6KkPkW5IcvkBTV+BW8gujTIVBK22U0QZ3WSKdjG5j8ldIGCIHtJYUTW2nnDNQ2iJ
 nef7vML7vB3/6qOdnAAAA
X-Change-ID: 20260626-migrate-cleanups-prep-77a0ad340cc6
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>, Dev Jain <dev.jain@arm.com>, Jonathan Cameron
	<jic23@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782466686; l=859;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=KrY+WOrtaj0K0wv3ESrh7KEhLi19wXlDX04XIwDv6OQ=;
 b=PUykrpYuclrMdGkcWJ7tL2Id8DBwQAU9dOVa02X3QqQRzaMSblxdusj7SJbJACjkNnGDE+9lg
 2GBoRUpTaljDqUEBjW+3YAeEbtINkqdsxgP4N8kPoO6JeHKf1fHsumE
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7A:EE_|CY8PR12MB7754:EE_
X-MS-Office365-Filtering-Correlation-Id: e0144d02-0535-45be-9f6e-08ded366a3a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700016|82310400026|1800799024|23010399003|18002099003|11063799006|56012099006|921020|13003099007;
X-Microsoft-Antispam-Message-Info:
	zZTaucnjTBdxBKXiFm1zhk5YaHP1ApPX+YwZp8HStSpjGX4WBaeznMqWcevdKkjjP3uLE43gf8vuWPHbVdw6doTdtgSwbl6vXIbU2DW2y2XqpcsfuHOPD4YoC8i4MjqAZCPVVm0zQAkFspy3QiJJLe/51YfOYGqJTzkk9wWiHBM3xDLSgEKFqexjIOo+ZCDiZXvOiwYXdwukG603Z3R1CLo1ZIfr0w9zt7w6Yebs7+evJ66B4Yx5atII2STWiIYZ2l+9nLInzHHSciyRJywsUYlC/x4+wFYs/UpCB/tS3urXgmNRM+jaTbBq/U2NkbUZUUc5RadRogyjpzv3oNIXATPVXMFlXr0xJuOdlY7M7yal0FiiPoUKC1eLVWPHvF3UxYKdZa8TnFnEofXQq/tyGg3daUuCs00ZQJ/w3QkcGZ7TlgS1s5OkkJ97duDN1NI6eLSTkH5GxExd1S8D9FpOE1EqywzbK5zCIRdGzUrYTQ4+kfzkOPpNaGMQ5rlV+9Ma2kHVLFmDZEULJVj1gl4/JzByKyMQsxw6dV/IA4Cqe3rEtW2MQ2+HPFnZP3fD3HAZIX9yTQb42g1cNyIEOdpWMY6Qp6nhUV3dazgn+V/P+A2ml8uboNZhMVvR18BrJzJL8IHK00iPZfSVGxXyrVosSnVlZpVpa+JuI91KJygMAc61TSrbxL9EJA00WXJW38b4gStg1z1/H3NH3Kwg/BzAsEUA4+7DGPpDSfL00FvbmgPJi3vLgSzfMOcMOdbPLkA0
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700016)(82310400026)(1800799024)(23010399003)(18002099003)(11063799006)(56012099006)(921020)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	kkX9K3sbp6x8hKZ1PpnWU5hnBYBLBWql4RyPUVq1dfnEXMmF8TQVKz/5cm7dFt1sjmmlANEy2lFstXOQ6NrOWpeTXQXfILYin/o1Rsh9xtdNWHuiDYaa/RtfgvDw65fg8Uh79LL5vy4dTSfD2MyrRWiYgpmvkEgczqUXAbJ4QAyF7kmZUbgBtluz841ChkrtB5WzqoI8aTo57JQL2iG25L6Hf6mCnJnHOMuAgs2f/cKGg5JBF5PT4//BimCsU3c4Plcj1h2aNqf8Y29xMPVkmZpGQa/jw9TRBBqbruEIPncFh32GAfzlGJdUpZFM3JAuO4EwTXbQKbLXRQQeGE+iJTLu0FJyr3MGA7dpyXU3YJFc1wJzk2Uf4hE2Gkja5sguCdlIdmkFo8l6h7kMe2zprO7baQv8usy5iZm9HWJfIlSfbKbd8ErSJOrarx7qkLfX
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2026 09:38:11.8520
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0144d02-0535-45be-9f6e-08ded366a3a8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7754
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A0C02C0002
X-Stat-Signature: axozzqimah7do5guo4x89u493y1z1sch
X-HE-Tag: 1782466697-876709
X-HE-Meta: U2FsdGVkX1/qJ/Bfljks1HJxIqbcLIXhPu61PFl9EKwRJbs2Y2nPUaWl+Z4q5n9sm4eBwFpoTZvj9s2YWcDOt4uiTpiijwdGd1QXZXYeNOpUjh6t3Pn27lWV1usKscQ2qbprVRsw3YdHqgIvBSQimeSMWt1ZXH0S5qmvqgjVPG79gNexbih3bReuEGK1i73oXWY0wBG7qjXAJgCRo2hcp8KRpKpkYtlj5iZ2FHx4Fghmod7Rcs16SZOR5xnmPjGmMaMJcfiK5b0E9PVWRpM1s8J2a22OYHba4d77yRKH13XmNroCiYEvZ37P225DFBL+MIJaywvdGGeFoq+52TXtj+hrDoK/jH4FfRJkpgez2xtSRExYA2SG+rot8VkswQLcvNWsOQnZyurRRKPnnbA3Kzjek9v7m1nDuwbPb8faPDMJflIhd9Ic6xYZ0O0yXQT9nWsZjBrDorx3lpe88FDPgj8ooiQ3krcOBWlJWnrLKNDCwupziBJWKK6NibHX1jPyem7NGp89K1nFsPP5zT4UUpx7WSFIjCfKehj4z3sWrogsFW1i/4dWsu+7i4Z5YuaQlhC9/ljAkLe8Ul85vSn+FdvFd373IDcN0BXTDcVMlrslPNN1wfWL5bPZnLqIqaNwlE6xSKoQYFZAL/9q3KzrY70NqO/bG4azG2YK6YpOQrY8tbWC3p9hfyJIvp689DTEg88OXgrnPsyJnYIz9SgLqhkGgNGoHFxlit81YGGj7XL4SY+isA29J1ItItP0+5z+dJ404IPsLPWMluzm7iGc9+21Lnv/WJtwflqMLf8X5anGqgCJXNxAI346Pcg+bGbclNrwaidmdXfiyWVlR1yvvHux1g1NK3wxugNqiJdps49kCKYxv9r8QHrDCTGjxtRUTxPgOB5shaLwy/4+8cyHx5x2NN6UNZWT75Pu5l5JjbwwZqmnl78J6SHSWaZsRmYH9SBiY7zez/vcZejqoR3
 EzlXfoIx
 3IozV178j0foWK13asX2/Dgvrtd27wgJsLcoLKAeuIVIhAJdwTKnDIS5IyoNVCY6Gs0FzBUCo/R5w7ROOLvoU6A+0AGVHPTDWGMXOGU3G9sPkBtKPcvuDhT+Hcg6gqU/frhePqO+LAS1knCckZVtOWOL6jvzaKlOhKya61+zNGGN1elRrlSB5pcdNrwpmZel2wfg/DimYyF65gtSfqonRaGy9Ys20ZywiRfkXVQg/C85ehsew7SMxQYSQumxcdYBkzGnnmPkQ4NDJ++cPQRwi63As3YoZQcimyXCWVrXTbHlpFVQg3eSma11PxfQM0iRs2sJuVhMR21tkiytuHqr4fkJLf/h5vcC/i6DVBVMuJkcHwIkBiSEoEVdho74ujVdes8T7DkBawzJ9zNK5AXBcBO2EJVkW1QKjgu+B92E0+J4WBQz+MxBUA2w9vwGpmDA6jBXf/nCe5hN4Mz/BOYuRLzTLX6aae/HY1DGZDRtZj4bdq8wUR//TJZzH//kEPDyEfCtKpEt/kr/MFWEZVq7Ov0YbjoZ3jwREKhHQmngdlKsqFPTz9yh4v1kFxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a small set of mm/migrate cleanups split out of the batch-copy
and offload RFC [1], so they can be reviewed and merged independently
ahead of that larger series.

No functional change intended.

[1] https://lore.kernel.org/all/20260428155043.39251-2-shivankg@amd.com

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Shivank Garg (3):
      mm/migrate: rename page to folio leftovers
      mm/migrate: fix stale list name in migrate_folios_move() comment
      mm/migrate: use migrate_info field instead of private

 include/linux/mm_types.h |  1 +
 mm/migrate.c             | 27 ++++++++++++---------------
 2 files changed, 13 insertions(+), 15 deletions(-)
---
base-commit: 4edcdefd4083ae04b1a5656f4be6cd83ae919ef4
change-id: 20260626-migrate-cleanups-prep-77a0ad340cc6

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


