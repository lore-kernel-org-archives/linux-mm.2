Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E547BC98315
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D9D6B00A5; Thu, 24 Sep 2026 02:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCC466B00A2; Thu, 24 Sep 2026 02:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85ED6B00A2; Thu, 24 Sep 2026 02:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 504496B00A2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:23:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 93CEAA5A0E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:23:53 +0000 (UTC)
X-FDA: 85247665146.05.D3A575B
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011018.outbound.protection.outlook.com [52.101.62.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8C0774000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:23:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AqB0U000;
	spf=pass (imf11.hostedemail.com: domain of bharata@amd.com designates 52.101.62.18 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790231030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Id3Sxnc7sVquFPn84cUqN4ZfAmkkYwIVJmC1MLkb6Bs=;
	b=pYD5z/dvQ+yj+R7lbzhIaTOEscmAcVpcJC2PFWul1w8apZXgWwks605WdamGybcdPHFknb
	wfvDoc7a5g5lYz+AbcqBn3245XGfZwZ13A6vuS3rLUqKMr2VNcqQUqIpnch47fW55npEzs
	13Bh4cnQW2UVT0LliY7F7GWQTM1F3/8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790231030;
	b=PJrxey0pTV3pr5rYJjG511p3DcHYsD7BSesVIx+UIJZeWDfJ4rO/hU3Naw2P4UT93yfVjF
	O9RilL5zUmeKNaNYeF60mUSHuyeHJyM0UPwkfw6h7dbCN1Z0OS5EEIScKTYSAvGy3dRIrr
	emaO07gyHNhfHZyQv8yY1lXv8i0hO50=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AqB0U000;
	spf=pass (imf11.hostedemail.com: domain of bharata@amd.com designates 52.101.62.18 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a2nHt9SpgjwSHVswrMvLgQ5M6Khhtwz8apXw8RVyPGnmVheUlFLefjOEHSmFQUz4GceHlIqKeNvClmunv+ltk6qvk/H9PDBTbbZlNci9yNiiPJ1luHVGBqdHIhOS1NVapTEMspJmi0hjuQN8r7B0VQmylPrluWVMgtRVky4vQPnM3Db2W5N+Gar1iveis6W44VQgCMbo49d48ZerrapNspc+bpjZMV1F8n5MmArxURZ6xQXiri9m+k6ASbKHlmfjjo2rGXjqIk7oC48nrdK1N9CB+q/+AFqncSiQ4Q1eTiT3oybBXy5gc7+yEDE+PPmjfhB4AaNjxwg9dfYbvDtmKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Id3Sxnc7sVquFPn84cUqN4ZfAmkkYwIVJmC1MLkb6Bs=;
 b=xsqwiVz7rUhCSdMLdSHE5nF8zAM8rEVGGRmpuU0/Y8/OpRIyuOVA9cSq/cCGn9jiRgQnOxV2wQ/EFlpdF0JqkPcWdqQYdQWk69VbYjgiLcyV3hRoGopSpMgbjRBetAZBNejxF9xoV0QoAx8SIo6zNk6uiQxFq7xcakgxyhOFrXP6M2V0sL1c4Clj9xNraeADf59+AcNwYJAlAaaKSkAFmVxTcVN06EOJE7M3o5SwOI9dPdBg++mooPXRNvyW4r9L7eHuaVdM6N7AtGl6W+ychoa48HQxXekFxJhItdXeFoIxdCp6VYEUSkxR4tRPU+5g+BoPL+RPZuVLrJzcs0JfaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Id3Sxnc7sVquFPn84cUqN4ZfAmkkYwIVJmC1MLkb6Bs=;
 b=AqB0U0009EETMZTgRj+fG9s4vsI9U6Utd7t5zkE0dlWMS6MEp3QNKFCASYK/W6J2a1ug39iUrE52pVQUWBJRQyAzb3LydcQiuKwStsOzOo/1fIe2BmjEXOI1JyowtYS2g8mpdqqexty5Yn8991h3oOyWXdKXMCNO0lKHUHu1Msk=
Received: from SA1P222CA0071.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::18)
 by IA5PR12MB999324.namprd12.prod.outlook.com (2603:10b6:208:609::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 06:22:58 +0000
Received: from SN1PEPF00036F3D.namprd05.prod.outlook.com
 (2603:10b6:806:2c1:cafe::2a) by SA1P222CA0071.outlook.office365.com
 (2603:10b6:806:2c1::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.451.18 via Frontend Transport; Thu,
 24 Sep 2026 06:22:56 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF00036F3D.mail.protection.outlook.com (10.167.248.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.451.8 via Frontend Transport; Thu, 24 Sep 2026 06:22:56 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Thu, 24 Sep
 2026 01:22:46 -0500
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
Subject: [RFC PATCH v0 0/3] pghot: x86: IBS Memory Profiler for hot page promotion
Date: Thu, 24 Sep 2026 11:52:03 +0530
Message-ID: <20260924062206.319314-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3D:EE_|IA5PR12MB999324:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ceb72f4-a145-44f7-45d3-08df1a0445f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|23010399003|7416014|376014|13003099007|10067099003|11063799006|56012099006|18002099003|3023799007|6133799003;
X-Microsoft-Antispam-Message-Info:
	pWx8DHT8ivc2u1FJxP1nhFGRG+N0DFDShv6kk3WfPxfrHv+f0DQFD24ATwoLOnKkj/7fUaK/winEKgW8lN3GwWOLh+CECkt6MSWu8n+pNDsfii70XwonIqgfi5hhri5Jl6CMm/ZmREUNLxqQkhBZpXNWaamzItlKBrmjV2J3s8+caWDAQbXk4ABxQOcAPn2v5GUxAqT9rkkjn6mR9za2g1Hk/Y9jXCfnnw0GV38eH2k14+o1xZ5ItMozX/QNaToM+y2CR3QQeT59H5MDVx9cKS1B9Kn9QzwEaC+PLHPnjU/tUUuTWhYHufV7pxeVG8o8NzUN1o/KIOfM9Wp6e21DaqgTX/80wxoMDE3Lf03EF0D1gp56OSdRxFzq8focYMBpfq8qu+ZjlFYz4L4sZp9t0ox1gciNIp22xSHA2zANX7/XtG5MGV3tZeoKzxQ+qQbDDt2n8pmHFAcLeFsE4/igcHb2utXoQktBVSS5orHqrgk4llc50MUks6bLRxftzjAYwivv/djHcwApFmoKXdb+E9C2Y5ptvJgKHOQDMzNrQsq3ipSG2KyQRaeN5qzApJKwaMtSuuuijq70ebEP6GA6dFBKEKE8pvm++XgORY9iyU8IjwOoCDNx46LNzW8kM2SBrLQYB2hzMg//zJ/4dhxSJqd5Nep2Aunb78bMbyEiZ7U=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(23010399003)(7416014)(376014)(13003099007)(10067099003)(11063799006)(56012099006)(18002099003)(3023799007)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	T42thZF8FrkG5VrBL3CZzYvF8LEEQhLvQb9LrIB52B//7XGb9eB9SM3b+oqkPq1QcEuxk5o9/8+re3kC0EgUppRGt/EjdeEoeEteJSwdpVb/0+KQGL8Fix7+W8i9U0yY2kVjd09nPI7fVhJ8/BWGXhv1w/1ya8J07UXJujsAQRt3ldnnblhFSh95PST75bWra4gsro/TpAEftK7auc+VXb4htycdosVbnHbA6xJjeXDLNUPcX8tNJodBC6GikLhdnjA5/QShpw5mxl/2893B07SusNhKq2f9rwp43AT3QuFI1E39pF68oR2soYHhIqIx1TRc/ddhHlZeMGfZEm9kofyBwyGHZEO69qCTVrZAkWaXJtrdT7HyMxlyfdsoYiukpQSxAnNgsHCSJCX8aIlHf5Yh9ODkel05Pna5ovXBjoujzbvRbSsnPEK+85F/XCAT
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 06:22:56.5166
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ceb72f4-a145-44f7-45d3-08df1a0445f5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA5PR12MB999324
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8C0774000A
X-Stat-Signature: jc7rq1uxs135fjk65r5nqkziebfpnaau
X-Rspam-User: 
X-HE-Tag: 1790231030-214896
X-HE-Meta: U2FsdGVkX19lrlqoNaAL8TlBW0kumiYQ9QR0CygKY92rUBCOrbqershNeIxpmUSj2T26egV/5BnhxX60UZmEb0piLcPbbA74AL7m558vTQHTEyVrMdb+QGk0snJnd7Gc3kfXL+Q7ljWAJVI1BWZAWVp5OXiZ0G8uf+DCJ12iYzWKCi+Z8WaO6caKCbUyQyRft5+IDsqXJHR6b4NDnSCC+u5XYV+JE1HFVMsSVThpv7b9pSCnNtOAew8LPe4+cxMgD8x9Ba7YTgqEFJ9s1WCjk8e16zbRzeOhtpNOTN+b/CsEBW1Z2txYlFDjDyXJy6LinqPIXJwelb3r2SGzdGf/7bUMD/ZPoGTxsJYA6FR343d9xxVoBvKXCOmgl6U/Onx90KCFeN+5p6z6uZzNwSiLPmTZOzGeQiPOr0SNUGjE27jkVjd/hp/aatJcm3jfF2T237yPwsz8cHTUB7W6MWs1Asdi/qpWz43h7Sxaj055C1MrNZpFMg2WhWhrj4Cbd6PvUj6UnRAeZcfKTPjDEP0YTPAeE7v6VSqhRs9qVCqt/2HGUdoYvOUBQtHhvfi/OZnxfUX0VXA9bBiSnY5jrYRVj0cEH7bn4NhmXCRtZBVgZ20Zs5DhIjphqb2eWha163bQ8dlpSv2GNKvR3ChSPLj5/idaoAjudVlBW4nUuDHnvm1eUZFfFrdyag6dtCA7Uc//+ifFdrFaIYGHcZ+Nedz8u9NXXQnKrcIShVQ0Dh4PSDHYpb84KqWvfGCkqKGHt960xJo1BuWGktiRhkve5Hd5bfJ6IV2KOokFf+SLm51eHUIDzh0SbEDveF896bueSF0QdC2vP7vIZR/n03WDL2Oe4zpbc5VK59s7MqiHuxTXhm6TmJIcwgH2PB2T/HzMyr9K62xG4qTFXmDDkLg5YcllRqegcn6WTrcttGbrJ36qx1vdoHXjpKZEexnNXdw6FX4ThQJBSTmt1BNsZGMZaQ8
 S8XvduM1
 l4A9m97d5+xNFknFVIWMCTfEifUVYFV19UYDBLIoZIkRcUhixH0Ngmf3cpvG0fN5alEt9wZsH1qQM/CPSrYK01eXf7rQm3JD+CmmGRAK1TTQ+jkddDJIe5mObdNmMIIjtdybCS+PbyiYk9K7s3obI9JX4Y8n8EcMiJg5T5RLdqI0txCchwSNPzXeiGWkJSIf2GLpua7ZJ2tWRBzMWn/cJoipwjEBCphV3313xOt9jSE2bORNglId81L9RNez0mV3qWTA3ci32ZN6xYezCZ87SQODhgYvjdJv8O16+slDw8R0bKH/EdqAPKqHGs6nC2Q6TKXiIL0FH/dh2h0SJApyWUAjWYl7oM0sJ9Vzc61usNF4HuELye7Ex7dueB4gRUSk8UR43BEiLhTD66UHTfTZd2J7BLo4VO8LCFnVOe0X1i4bMHcvYYQQcFvASkRF3iz8rLNV5PZEfvXp0E0nYxoDEOLl427awiQqJYBcxRQDmx9517EDpvskbDa/EP/akmOy9MSqG0kvmAog8pCP8z/5PJ56GOvFnTfI0aVDWSnxEEofmw4mNV/iz4GddLhXD676/Giyn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

AMD Zen6 includes IBS Memory Profiler that is independent of the
primary IBS instance. This second, light-weight IBS instance can
be used exclusively for memory access profiling.

This patchset provides a driver for the same. Till now this driver
was being posted as part of pghot patchset [1] where IBS Memory
Profiler was used as an additional source for providing page hotness
information (hardware provided hints source - pghot-hwhints).

Since this driver is x86 specific and also to make review easier,
I am separating out the hardware-hints source into a patchset of
its own. This patchset depends on pghot infrastructure and hence
applies on top of the base pghot patchset. The small bits in the
patchset that modify the pghot documentation and pghot API itself
can be ignored here for the review purposes.

pghot in brief
==============
pghot is a proposed subsystem for hot page tracking and promotion. It
collects memory access information from multiple sources, classifies
hot pages resident in lower-tier memory, and promotes them to faster
tiers via a per-lower-tier-node kernel thread (kmigrated).

Goals of pghot:

- Unify hot page detection from multiple sources like hint faults,
  page table scans, hardware hints (AMD IBS).
- Decouple detection from migration.
- Centralize promotion logic via per-lower-tier-node kmigrated kernel
  thread.
- Move promotion rate-limiting and related logic used by numa_balancing=2
  (NUMAB2, the current NUMA balancing-based promotion) from the scheduler
  to pghot for broader reuse.

pghot provides an API (pghot_record_access()) that other
sub-systems/drivers can use to report memory access information
to pghot. IBS Memory Profiler is one such source or driver.

IBS Memory Profiler
===================
- Hardware samples an op every N core cycles or N dispatched ops,
  with a software-programmable period, so sampling overhead and
  coverage can be traded off at runtime.

- Each sample reports both the linear and the physical address of
  the accessed data, so the kernel gets the accessed PFN directly,
  without page-table scanning, hint faults or any address translation
  of its own.

- Samples include a data-source indication that identifies where the
  access was satisfied from (cache, DRAM, external memory etc). This
  lets software distinguish local DRAM traffic from CXL or other
  lower-tier accesses.

- Hardware filtering lets the profiler report only the accesses that
  matter for memory placement: L3-miss-only, a load-latency threshold,
  and exclusion by instruction-address bit 63 (i.e. user vs kernel).
  Filtered-out samples are discarded by hardware and never interrupt
  the kernel.

- The profiler raises its own interrupt, routed through a dedicated
  extended LVT offset that is distinct from the one used by the
  primary IBS instance. It can therefore be used by the kernel without
  interfering with existing IBS users such as perf.

Spec: "AMD64 Zen6 Instruction Based Sampling (IBS) Extensions and
Features", publication 69205 rev 1.00, section "IBS Memory Profiler".

Benchmarks summary
==================
All results are on 3-node tiered systems (DRAM top tier + CPU-less CXL
lower tier). Speedups below are normalized to the base kernel with no
tiering (NUMAB=0). Columns compare mainline hint-fault tiering
(base NUMAB=2) against HW-hint driven promotion via the AMD IBS
memory profiler (pghot-hwhints, NUMAB=0, no NUMA scanning). IBS sample
period is 10000 unless noted. Single run per config except llama.cpp
and microbench (avg of 3).

Benchmark      Metric (higher=better)   base-NUMAB2  pghot-hwhints
---------------------------------------------------------------------
NAS BT (MPI)   Mop/s total                  2.34x     2.15x
Graph500 BFS   harmonic-mean TEPS           2.34x     3.17x
llama.cpp      decode tok/s (tg128)         1.19x     1.22x
Redis+memtier  ops/sec                      1.04x     1.00x
ptr-chase      1/latency (p10k / p5008)     2.24x     1.49x / 3.48x
Microbench     completion time (1/t)        2.55x     2.22x
---------------------------------------------------------------------
(baseline = base kernel, no tiering = 1.00x; pghot-hwhints uses IBS, NUMAB=0)

Headline: IBS/HW-hints recovers most of mainline NUMAB=2 on
bandwidth-heavy promotion (NAS BT 2.15x vs 2.34x, ~92% of NUMAB2
throughput) with zero hint faults or PTE scans; it beats NUMAB2 on
Graph500 (3.17x vs 2.34x, ~1/4 the promotions) and matches it on
llama decode. Coverage is the limiter on very large, uniformly hot
sets: Redis stays flat until sampling captures more of the hot set,
while pointer-chase at period=5008 reaches the lowest latency of the
set (3.48x vs NUMAB2 2.24x; DAMON 2.69x).

- NAS BT (MPI, Class D, 16 ranks): full footprint pre-staged on the
  CXL lower tier, then measured cold; isolates hot-page promotion.
- Graph500 (reference BFS, SCALE=28, edgefactor=16, 128 ranks):
  working set on the CXL node; figure of merit is harmonic-mean TEPS.
- llama.cpp (llama-bench, Mixtral-8x22B Q4_K_M): ~1/3 of the model
  demoted to CXL under memory pressure; decode (tg128) is tier-sensitive.
- Redis + memtier (~64 GB dataset, 62.2M x 1 KB keys): dataset
  migrated to CXL, GET-heavy traffic over 50% of the keyspace.
  IBS at period 10000 and 5008 both ~1.00x vs baseline (hot-set
  coverage ~10% of NUMAB2's ~40 GiB promotion).
- Microbenchmark: 64 threads, random 4K access over 8G on
  the CXL node; latency-bound.
- Pointer-chase (64 threads, 64 GiB buffer, 16 GiB hot, 240 s):
  latency-bound; NUMAB2 places the exact hot set. IBS period=10000
  under-promotes in 240 s; period=5008 promotes 12.0 GiB of the 16 GiB
  hot set and records the best latency (92 ns vs NUMAB2 143 ns,
  DAMON 119 ns).

Detailed per-benchmark tables (throughput/latency + vmstat and pghot
promotion counters) are posted as replies to this thread.

Test reports
============
Compile test matrix
-------------------
The series was compile-tested across the full range of relevant Kconfig
combinations on x86_64 (defconfig-based) and cross-compiled on arm64.
Combinations of PGHOT, PGHOT_PRECISE, NUMA_BALANCING,
NUMA_BALANCING_TIERING, NUMA_MIGRATION, HWMEM_PROFILER/AMD_IBS_MEMPROF,
DEBUG_FS, SYSCTL and PM/PM_SLEEP were verified, including pghot disabled,
pghot standalone (no NUMA balancing), NUMA balancing mode 1 and mode 2
(tiering), precise mode, the AMD IBS memory profiler (including with power
management and suspend/hibernation disabled), NUMA_MIGRATION=n, and pghot
with DEBUG_FS and/or SYSCTL disabled. Kconfig guards were confirmed
(NUMA_BALANCING_TIERING without PGHOT, and HWMEM_PROFILER without a
selecting driver, are dropped). Since PGHOT defaults to y when
NUMA_BALANCING is set and NUMA_BALANCING_TIERING defaults to y, an existing
config with NUMA_BALANCING=y but no pghot symbols resolves, via
olddefconfig, to PGHOT=y and NUMA_BALANCING_TIERING=y and builds cleanly,
while NUMA_BALANCING=n leaves PGHOT off. allnoconfig, tinyconfig,
allyesconfig and allmodconfig were also built. All configurations build with
no new warnings.

CPU hotplug stress testing
--------------------------
The IBS memory profiler's STARTING-phase cpuhp callbacks (arm IBS and
set up the APIC EILVT on startup; mask, disable and drain the per-CPU
sample ring on teardown) were stress tested against concurrent hotplug.

On an AMD Zen6 (256 CPUs, CXL lower tier) with PROVE_LOCKING, PROVE_RCU,
DEBUG_ATOMIC_SLEEP and SLUB_DEBUG_ON, the following ran concurrently for
20 minutes: IBS armed at the minimum sample period (5008) feeding a
node-bound memory workload; 8 parallel CPU offline/online loops plus
periodic mass offline of 96 CPUs at once; and continuous profiler
reconfiguration driving on_each_cpu() re-arm against the changing online
mask.

No oops, warning, lockdep/RCU splat or hung-task was seen. The profiler
kept sampling and pghot kept recording throughout, the per-CPU ring
dropped no samples even at ~2M samples/interval, and every CPU reliably
came back online with per-CPU state correctly reset.

Changes to the driver since it was posted last time with pghot
==============================================================
- Register IBS Memory Profiler cpuhp callbacks on CPUHP_AP_ONLINE_DYN
  instead of a dedicated CPUHP_AP_MM_AMD_IBS_MEMPROF_STARTING state.
  This elimiates the subtle races due to worker getting migrated
  to other CPU before teardown.
- Make SPSC tail handling symmetric by using smp_store_release().
- Mark the clearing of mprof_work_pending with WRITE_ONCE() in
  mprof_work_handler() and x86_amd_ibs_mprof_offline(), so every
  access to the flag is uniformly annotated.
- Take cpus_read_lock() across mprof_publish(). This keeps the online
  set stable so on_each_cpu() cannot race a CPU's ONLINE arm path.
- Drain the per-CPU sample workers before free_percpu(mprof_s) on the init
  error path.
- Add dram accesses stats for far memory accesses too.
- Made reading of data2 optional to L1 and L2 hit.
- Protect debugfs and sysfs readers in ibs-mprof.c with mutex.
- Validate memprofiler EILVT offset at once during init time.
- Ensure the period reads back what is written into the HW IbsMemOpCnt
  - Minimum value changed from 5000 to 5008 to make it 16-bytes aligned
- Reject over-sized writes to IBS Memory Profiler's debugfs tunables.
- Change ibs_mprof_enabled to static definition.
- Include linux/string_choices.h explicitly in mprof for str_enabled_disabled().
- Handle failure path in mprof driver init proper rollback.
- Added suspend/resume support so that EILVT/IBS is properly configured
  for CPU0 post resume.
- Gated mprof init with X86_FEATURE_IBS check so that the driver
  refuses to move further on non-AMD platforms.

Dependencies
============
- [1] pghot patchset:
  https://lore.kernel.org/linux-mm/20260728054356.291998-1-bharata@amd.com/

- IBS Memory Profiler depends on the patchset that increases the
  number of APIC EILVT registers:
  https://lore.kernel.org/lkml/cover.1788425679.git.naveen@kernel.org/

- Full tree with all dependencies included:
  https://github.com/AMDESE/linux-mm/tree/bharata/pghot-mprof-rfcv0

AI assistance was taken to run and summarize the benchmark results,
to run compile test matrix and CPU hotplug stress tests.

Bharata B Rao (3):
  x86/ibs: Move IBS caps definitions into its own header
  x86/mm/ibs: In-kernel driver for AMD IBS Memory Profiler
  x86/mm/ibs: Add runtime controls for IBS memprofiler

 .../admin-guide/kernel-parameters.txt         |   5 +
 Documentation/admin-guide/mm/pghot.rst        |  89 ++
 arch/x86/Kconfig                              |  16 +
 arch/x86/entry/entry_fred.c                   |   1 +
 arch/x86/include/asm/hardirq.h                |   3 +
 arch/x86/include/asm/ibs-caps.h               |  93 ++
 arch/x86/include/asm/ibs-mprof.h              |  61 ++
 arch/x86/include/asm/idtentry.h               |   6 +
 arch/x86/include/asm/irq_vectors.h            |   4 +-
 arch/x86/include/asm/msr-index.h              |   8 +
 arch/x86/include/asm/perf_event.h             |  81 +-
 arch/x86/kernel/idt.c                         |   3 +
 arch/x86/kernel/irq.c                         |   3 +
 arch/x86/mm/Makefile                          |   1 +
 arch/x86/mm/ibs-mprof.c                       | 867 ++++++++++++++++++
 include/linux/vm_event_item.h                 |   8 +
 mm/Kconfig                                    |   9 +
 mm/vmstat.c                                   |   8 +
 18 files changed, 1185 insertions(+), 81 deletions(-)
 create mode 100644 arch/x86/include/asm/ibs-caps.h
 create mode 100644 arch/x86/include/asm/ibs-mprof.h
 create mode 100644 arch/x86/mm/ibs-mprof.c

-- 
2.34.1

