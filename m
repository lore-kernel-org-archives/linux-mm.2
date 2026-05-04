Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD06EFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD446B0088; Mon,  4 May 2026 02:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E676B008A; Mon,  4 May 2026 02:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFEAB6B008C; Mon,  4 May 2026 02:10:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB2F96B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:10:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5086A140A92
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:09 +0000 (UTC)
X-FDA: 84728712138.18.185D117
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012060.outbound.protection.outlook.com [40.107.200.60])
	by imf22.hostedemail.com (Postfix) with ESMTP id 48EC7C0012
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=tbfrJJze;
	spf=pass (imf22.hostedemail.com: domain of bharata@amd.com designates 40.107.200.60 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777875006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fWsj7W9A315JHrEZEKV+vVszz8B5+mPY3pbRqhzqHHM=;
	b=ZkjXZBsDQLRsOD6CjLPG7YVDC6dwE12MG4je+8lsIez1x7k50FXUNgQ3Ml3hwb9fjxrhoQ
	NJo2tGDlv/AErkX8Oo4l/Fjt0FPQOs/UUSRLPIeEQO7OqbdlePqv399zhw8PQqeITmdy/A
	P/nzKWE4zDH2lwYxvSzb/fxFiW6BSOI=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=tbfrJJze;
	spf=pass (imf22.hostedemail.com: domain of bharata@amd.com designates 40.107.200.60 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777875006; a=rsa-sha256;
	cv=pass;
	b=Vh3OKLOfdnZhILWghDFWkrnuIcNIwnfT2QqJbcjeOb6bGJWUlj4qIFHUAXmliD78LVvpd6
	6AYpM2tPZ7scDmBz423OakFg9ADD5qqJDIOxXvvQOEC+9/0Ke8NsZFWPLOg+tWT30n+UUW
	86fQ5HUk6bkA/ttEfphb+Jytg1YEcHY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zBELWhvy+97smd3Hl4uUzkKK9Z1tdVyGblJS4C/NDrBgN3mn34yk5Kj6TIOeDCZ/z+P5WBUULeAh2hprAgv1GL51Mh2PmJ+lb/JTAhvKjURmzo5jNFRzB4VQCza78zpE6arcWlBH0oYohBuPul3GSBKms2UeOK0OIZZrPtAGwxVZHeIBD7dXf8IMhxXh8u95KSFuuaLpO0WmulyrOSN6eXnmhRevpXzF1O8eAQlIv8ZIW2mjH+0bRY6pwDckiADHo/MrEfnzIYa1WbotdG580b3ocCIt7SWO7XHT1e7Qna6gtkkdVS1DNINo+u0qt3RZAGc/VdnvRkR8ihB6YmwiMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWsj7W9A315JHrEZEKV+vVszz8B5+mPY3pbRqhzqHHM=;
 b=iw/ri8Qxwrs5H/yl+vyqojEFUxLhHmgZmp0LA2vl8vQ4/nPPYhhb/WJcwYb0BZrnJQ1SRPGOu5DJGd7XH+P3Xtv13rCMBA8huDiv8JgS4+GldgMGVOq3YhJzwmrEzkzs12GHINuDUsdsYMeg3G5iSsqW+yWtmj8DnMpozi5WCrbAScThaioGhGPM551BjFQ5HzI4C4yHKwIz6hoSTudqmP8ysDo5X9/deu9CDId8PYU+UudylLPHIR9OU6dLctYLNcEUzTr7rR+YazSW2BuUVuVp3iArOSRvm6LnQ8OAsdFXWh7SkdPtTIHavnNXIyJwsgbXBcZ1jSElz66t677wdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWsj7W9A315JHrEZEKV+vVszz8B5+mPY3pbRqhzqHHM=;
 b=tbfrJJzeYHFiKMwM9/l49AFh1wA+ScQ+v7hIpSaO9HSOh2K6Vg5ggrpACIx5rgx5bEePV3brvhoVpWQPMCrYwfg/rwrtz+ZVNhBo6qWEHctPxhfPAXTzcCGSyUdPscBHq8fgQ0YfobldOz/J6fPMI7nzKU8gXJJsfK9CaqoV9gc=
Received: from CH2PR12CA0026.namprd12.prod.outlook.com (2603:10b6:610:57::36)
 by CH8PR12MB9814.namprd12.prod.outlook.com (2603:10b6:610:26b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.23; Mon, 4 May
 2026 06:10:01 +0000
Received: from CH1PEPF0000AD75.namprd04.prod.outlook.com
 (2603:10b6:610:57:cafe::59) by CH2PR12CA0026.outlook.office365.com
 (2603:10b6:610:57::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 06:10:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD75.mail.protection.outlook.com (10.167.244.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Mon, 4 May 2026 06:10:00 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:09:52 -0500
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
Subject: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
Date: Mon, 4 May 2026 11:39:17 +0530
Message-ID: <20260504060924.344313-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD75:EE_|CH8PR12MB9814:EE_
X-MS-Office365-Filtering-Correlation-Id: cc161ff2-af60-4889-3be5-08dea9a3c64d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700016|1800799024|13003099007|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	K4CBCscT+FFQlHwok5sntkrWDjBg48YsPHhGoxzyAnQtUSPbJKw/wmmBAqmO0HCnd+CAq+DF9cObwI3tJIEaUDRwSevIQX6zfeFXkhsu15LyKt9KbjN/gpIy2MX68p+9fJ377KLVXi9k33r3bK0/tjlOeK80Zui7rBghsUdCrgCsJEKve78bDM6jsnlQlgH5oAVsyE+/7MxrAi0FIfF5k6chiTffoO0HW1fr8WGoBcFyhgpGvfLQfhFgXDSiSHqow9Y0eVyMdyvP73vCm3zx5NcJmUXzVK+H376KwQDGdqn+evWgJU+uUKn03wi3tSwV6Iuvd5i73yQrgtAYt0HKWgJ9CtAPuvQhj/lCFgsJnEskc5dlRmlu4CR2AJimL5/HaQHW4+vwc3G/VKFhFSLr8LwyLcwJMJvDg7aWfLjQaW6QEcBdi34SIJuAnFZbVUSMNIbuNUcBc5XUr3Th1OOvwqIWGVeySF/dW370+UNmjVqVOUfEmFc03c81ZjXsSE8OzTlHyALtEtO648P7EfiyoSWT2i68mdvgBUBawL9eOBvZxMm1B/8bbKQcWjS5mL3l1fzIHp3Pa0ds7j+YdqyiCAV6id+ALzZe9G7TM9Pt5F72WTe+mVF3/tTRMGG+uWCzpe+XMJEZFFG1LGlUjv5GlEJXPAV0k0Tf+j4Ih8hqfQqOil0rhdYU6sG8YtK3XrxSi0Bb7AqTZg3DAfZHpphJaW0iwwucBkzX3c0am3LN8PU=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700016)(1800799024)(13003099007)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XOB3nDKtzMp6QsXDTTum9cwTfZnDdjzjE+P8opBGRe4X38ASGKkJf+baQ4UEOLkId6nIEKaQ8Ffe1o/6BigojshuQCLLv3zAVuR53yOQgWZEJYr0HTA5zJZv3dKDOxh/dfpQH9V8dN7b6UvB27j95IuYmtaKN2YH6Lxym6PB2fxwqdlzriB25TSaHzaTMoYFqsuh1BQ/IY6MZtZJ7Nsopr7X0I704O1wMMLKYOJZgQpedTvCfpLpjpjLvlOPkgt2t+HLmgDP/bbEYd+Y1x1XaUb4cMXLrETvXN8cfwInNCL5jmoEjMsqeEPEVYpWTJ6zXwT3MLvzCb/0gBHRI0vr+iPGyqFijXj8VxvAnPyt9ttp8S7egYF8mRfT9LpzkKashAaw26UAsyaWBgqRUtLYL0inVXOfb6nNEtWwYOsfzitBzSu2OI/BX0XjPH6Oyt3O
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:10:00.4368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc161ff2-af60-4889-3be5-08dea9a3c64d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD75.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9814
X-Stat-Signature: tb97pxdfzygakyw3m8whcdm4jhaxro17
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 48EC7C0012
X-Rspam-User: 
X-HE-Tag: 1777875006-601535
X-HE-Meta: U2FsdGVkX19c4gqUEfVYUKBLRdNkgBuvuYcXFTFH02L1uEHWxfDeziEXH8jyThiINHXW+ueFexF7IOQU+Zy2+5otjNbTG3hn+RxRz5qXaptHqSCrkdw7oam1l406PnOl7l5XjwWAnLrvE0uwPxd0wcK/Tvi3E91pA/3++97xmQmgJmti51Ddac6TKcj+EEF7c4a3KBTmkm0tNNwmtyWHismvxKqPnUFtCq6VRBEd67AAjWHnt272SAyc3msouiCXnUOACPis9Qt/nJZrYuOv/lQeEOP5yKFUikobQB+Kue5FvXnldBDtjoDbfvxfQEFy97KZoNz1nPHxaxmNaAU/O+Xwv5JCIjluvqst83m/c07kA2UGK1waXOIUq4olrHA5a1iQ7subfRkBuLKJnUXnZ7LoZOOCXC3u3TUDL4De4z4JHI6jctYrS7dG7QtHjE4FrThJnwNpFT9rYj6itoUAdaRKdFZUlSK7Pt+Ho6fje10avz06rgI8MVyuHfB5XsVXfM7o+11FYMV0m8JB4BaK3dI/+8taxB0/4ssdpEdDEmmGutpPHbTgkzC18UISaqVEE6aSS9E5gext6TgvtUZEHRJ8lQd2amzLKjWz8CyvrjTuH2i4SaSpMaUGjJD7DgvnUFvg9B2ysp7ou3UYbg8RxIUwKF/RMuN66ijO/0YCaJ+3X25GmY7ZfF51iB7MPZGkKqlxjAfIyqPyV3vq/fwa1oxmQtaVPByhDd1jGWFvJezZAYTJgL2I5s0MGMQE6hcPjgte14dXMHo9pyhTgyqirQi3/acVne2dxRantNdT66wtSASBYNAhHRs33Cc8yNtJli3qKsVpeMiFK5EtzkXK3MeYrNv9YaT/NuTCr4r0IPrLTWuydRUhCBcwdrTXfg7/m9zOWhDyaZpX/LpfdhNMYsn4RdzJbax9I56CdMPrcPHgHhD3NcC3GCvqZbro/CNTyKJU9BcvkNGyQxhZ23j
 u6aVeSkv
 iwICqOwCUlTUoMMIYS6w4non+sEZ3wZcYZZaLJnHItKUdE6XfWg9ozTiR2jMplesCObce3e1aqFt5L3WSpjzmdODAK4T5p3erAJBqJbEQcoN6GiiN4H8FBrc0AyYFMBMa/EEolVIJMkGybF1vvzPc0187yYL0l34qah2LhjH3B6g9xGIJkpHBtyxrpNxUsKNe/rVd4DMHE7Kkq857bjQaXxEG4bLFNWOUg/qBvdCFEsDeD+og6WrwJ9z+BL3vHp0b7jyQE0M3O5PZZkSJryqcpmDcKOacJUzAck9g8H7CLL0axDyb6ACxsJHJT2Uf+hU6RbwXJUsmw71SAiEQQTEzIeGZ+stkmTB2qxUQj4bEiMd25AR8VQcvZReXfn5boUe020iJNjgqUCjLg3rbCXwBp+8z79Xy7HPNW3xLuTL19Bx0FblF2HE5hM16l/UmTmIKMXaz1ETXyl8VFeFKYX0QMtalBeY9tB2eHRi5vtC8LzMlCR7uuBZWJ4a+ajq6QXz2nVs0KY8bk1QbYq+1/qM16SnaQCxiJzT+yA9CFwdEUT/u6nLIJEXVcm+hKoeG4EI1zG3Kc3jntgf/quubD/Ue2tkw0cQbc6E3dM2M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This is v7 of pghot, a hot-page tracking and promotion subsystem. The
main change in this version is to add support for IBS Memory Profiler
as page hotness source(PGHOT_HWHINTS). IBS Memory Profiler is a
facility that will be present in future AMD processors. It provides memory
access information and is independent of the existing IBS instance that
is primarily used by the perf subsystem.

This patchset introduces a new subsystem for hot page tracking and
promotion (pghot) with the following goals:

- Unify hot page detection from multiple sources like hint faults,
  page table scans, hardware hints (AMD IBS).
- Decouple detection from migration.
- Centralize promotion logic via per-lower-tier-node kmigrated kernel
  thread.
- Move promotion rate‑limiting and related logic used by
  numa_balancing=2 (NUMAB2, the current NUMA balancing–based promotion)
  from the scheduler to pghot for broader reuse.
  
Currently, multiple kernel subsystems detect page accesses independently.
This patchset consolidates accesses from these mechanisms by providing:

- A common API for reporting page accesses.
- Shared infrastructure for tracking hotness at PFN granularity.
- Per-lower-tier-node kernel threads for promoting pages.

Here is a brief summary of how this subsystem works:

- Tracks frequency and last access time.
- Additionally, the accessing NUMA node ID (NID) for each recorded
  access is also tracked in the precision mode.
- These hotness parameters are maintained in a per-PFN hotness record
  within the existing mem_section data structure.
  - In default mode, one byte (u8) is used for hotness record. 5 bits are
    used to store time and bucketing scheme is used to represent a total
    access time up to 4s with HZ=1000. Default toptier NID (0) is used as
    the target for promotion which can be changed via debugfs tunable.
  - In precision mode, 4 bytes (u32) are used for each hotness record.
    14 bits are used to store time which can represent around 16s
    with HZ=1000.
- Classifies pages as hot based on configurable thresholds.
- Pages classified as hot are marked as ready for migration using the
  ready bit. Both modes use MSB of the hotness record as ready bit.
- Per-lower-tier-node kmigrated threads periodically scan the PFNs of
  lower-tier nodes, checking for the migration-ready bit to perform
  batched migrations. Interval between successive scans and batching
  value are configurable via debugfs tunables.

Memory overhead
---------------
Default mode: 1 byte per lower-tier PFN. For a 1TB lower-tier memory
this amounts to 256MB overhead (assuming 4K pages)

Precision mode: 4 bytes per lower-tier PFN. For a 1TB of lower memory
this amounts to 1G overhead.

Bit layout of hotness record
----------------------------
Default mode
- Bits 0-1: Frequency (2bits, 4 access samples)
- Bits 2-6: Bucketed time (5bits, up to 4s with HZ=1000)
- Bit 7: Migration ready bit

Precision mode
- Bits 0-9: Target NID (10bits)
- Bits 10-12: Frequency (3bits, 8 access samples)
- Bits 13-26: Time (14bits, up to 16s with HZ=1000)
- Bits 27-30: Reserved
- Bit 31: Migration ready bit

Potential hotness sources
-------------------------
1. NUMA Balancing (NUMAB2, Tiering mode) - included in this patchset.
2. AMD IBS Memory Profiler: HW based access profiler - included in this
   patchset.
3. klruscand - PTE‑A bit scanning built on MGLRU’s walk helpers - was
   showcased in previous versions but not part of this version.
4. folio_mark_accessed() - Page cache access tracking (unmapped
   page cache pages) - was showcased in previous versions but not part
   of this patchset.

Changes in v7
-------------
- Added AMD IBS Memory Profiler as page hotness source.
- Addressed review comments from v6 (Thanks to Shashiko AI, Gregory and Donet)
  - Early exit from batched migration routine if input
    list is empty
  - Changed the name of batched migration routine to indicate
    that it handles "promotion" of batched "memcg" folios.
  - Debug code in batched migration routine to check if all
    the folios in the input list belong to the same memcg.
  - Kconfig dependency cleanups.
  - Fix one-off-regression in nid check in pghot-precise.
  - More checks to validate nid in pghot-precise.
  - Early check to not call kmigrated_run() for lower tier nodes.
  - Handling PTE writable and ignore_writable conditions correctly
    in hint fault handler.
  - Using unsigned int instead of unsigned long for representing
    time in ms.
  - Misc cleanups.

Results
=======
Posted as replies to this mail thread.

This v7 patchset applies on top of upstream commit c1f49dea2b8f and
can be fetched from:

https://github.com/AMDESE/linux-mm/tree/bharata/pghot-v7

v6: https://lore.kernel.org/linux-mm/20260323095104.238982-1-bharata@amd.com/
v5: https://lore.kernel.org/linux-mm/20260129144043.231636-1-bharata@amd.com/
v4: https://lore.kernel.org/linux-mm/20251206101423.5004-1-bharata@amd.com/
v3: https://lore.kernel.org/linux-mm/20251110052343.208768-1-bharata@amd.com/
v2: https://lore.kernel.org/linux-mm/20250910144653.212066-1-bharata@amd.com/
v1: https://lore.kernel.org/linux-mm/20250814134826.154003-1-bharata@amd.com/
v0: https://lore.kernel.org/linux-mm/20250306054532.221138-1-bharata@amd.com/

Bharata B Rao (6):
  mm: migrate: Allow misplaced migration without VMA
  mm: Hot page tracking and promotion - pghot
  mm: pghot: Precision mode for pghot
  mm: sched: move NUMA balancing tiering promotion to pghot
  x86/ibs: Move IBS caps definitions into its own header
  x86/mm/ibs: In-kernel driver for AMD IBS Memory Profiler

Gregory Price (1):
  mm: migrate: Add promote_misplaced_memcg_folios()

 Documentation/admin-guide/mm/index.rst |   1 +
 Documentation/admin-guide/mm/pghot.rst |  80 ++++
 arch/x86/Kconfig                       |  16 +
 arch/x86/include/asm/ibs-caps.h        |  93 ++++
 arch/x86/include/asm/ibs-mprof.h       |  46 ++
 arch/x86/include/asm/msr-index.h       |   8 +
 arch/x86/include/asm/perf_event.h      |  81 +---
 arch/x86/mm/Makefile                   |   1 +
 arch/x86/mm/ibs-mprof.c                | 308 ++++++++++++
 include/linux/cpuhotplug.h             |   1 +
 include/linux/migrate.h                |   9 +-
 include/linux/mm.h                     |  35 +-
 include/linux/mmzone.h                 |  24 +-
 include/linux/pghot.h                  | 113 +++++
 include/linux/vm_event_item.h          |  11 +
 init/Kconfig                           |  13 +
 kernel/sched/core.c                    |   7 +
 kernel/sched/debug.c                   |   1 -
 kernel/sched/fair.c                    | 177 +------
 kernel/sched/sched.h                   |   1 -
 mm/Kconfig                             |  34 ++
 mm/Makefile                            |   6 +
 mm/huge_memory.c                       |  24 +-
 mm/memcontrol.c                        |   6 +-
 mm/memory-tiers.c                      |  15 +-
 mm/memory.c                            |  28 +-
 mm/mempolicy.c                         |   3 -
 mm/migrate.c                           |  98 +++-
 mm/mm_init.c                           |  10 +
 mm/pghot-default.c                     |  79 +++
 mm/pghot-precise.c                     |  81 ++++
 mm/pghot-tunables.c                    | 182 +++++++
 mm/pghot.c                             | 633 +++++++++++++++++++++++++
 mm/vmstat.c                            |  13 +-
 34 files changed, 1922 insertions(+), 316 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/pghot.rst
 create mode 100644 arch/x86/include/asm/ibs-caps.h
 create mode 100644 arch/x86/include/asm/ibs-mprof.h
 create mode 100644 arch/x86/mm/ibs-mprof.c
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/pghot-default.c
 create mode 100644 mm/pghot-precise.c
 create mode 100644 mm/pghot-tunables.c
 create mode 100644 mm/pghot.c

base-commit: c1f49dea2b8f335813d3b348fd39117fb8efb428

IBS Memory Profiler driver part of this patchset depends on the
patchset that increases the number of APIC EILVT registers -
https://lore.kernel.org/lkml/cover.1775019269.git.naveen@kernel.org/
-- 
2.34.1


