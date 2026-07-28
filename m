Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AFE1C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:44:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51CD66B0093; Tue, 28 Jul 2026 01:44:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A72E6B0095; Tue, 28 Jul 2026 01:44:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 348886B0096; Tue, 28 Jul 2026 01:44:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0C576B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:44:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56DD9C0299
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:44:45 +0000 (UTC)
X-FDA: 85037096130.26.343F4BC
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010037.outbound.protection.outlook.com [52.101.85.37])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0BC2C1A0007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:44:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=YcQvYDyu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of bharata@amd.com designates 52.101.85.37 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785217482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mLuYFoNTITFCPNgjhMWe61/yJxjCNOy3pQKj3Wubwj4=;
	b=4GV+ch5tw7gH41Ec0mvSVxBCt/6ww+BfaHR+y/yfSDGqtgxuT3Hi08BN91TIU0oxzaxPBQ
	7dUpQs65RUdgDP2cL0R450tELttEp3p/8m20abCzXm9kuKagM9+ygvIaCT36jhgY2snWfb
	HI6Iuz4Ro8bAZtlPJhtr1qEvu46/ZWc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=YcQvYDyu;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of bharata@amd.com designates 52.101.85.37 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785217482;
	b=niBJdwnkEIOkfPi+wVnjJFl9xmXo7mtS7PbIl1U9YmAxdmvpA/fpy9Elgh61NMaTQdeNa0
	3wp8aq5tPbiA53FO8f6eGZT4A9c++eu1oftfxCJLhxG9nOtrTblXnjFWn2byi6qgnZAiYx
	3vR+/aXNO8cK3veQnWF1V9rbuCioH3k=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oTatqfUIdBSnOhnv6apjR+yhA8+PGV9hwmiQwmpajR94deCgij5d702VI8cfygSVzhLg8stvs3yhhnmg3RADQCf4PFHv5LS7PycUsRO8aOHaIhQeU+J/VaI2bYxVlXMffHMQXPMizA3hxpCXuF11Vm5K4GncvudoyCMxhXJadGTsOCtioqiGbUo+SMCjxHJxe4ONppWkmnEuPoh2EG1RburI39Jz67XBkPGCcG3eCzdJuBRVtxwDC8XEKOXL/F58XB9BNPy5ozkr1wZ1msZAJvEowxKwaPvCuODeM04e4YDGfFD2ANHHdBdJ8mQVLyL4fIQYUnECuaQereXTD+yzaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mLuYFoNTITFCPNgjhMWe61/yJxjCNOy3pQKj3Wubwj4=;
 b=kiKpdD+IGGyoWzSxL7rGacfoM94wWezShZPQMRxBhwNW3Hjnx2l/dQnATvBSFDadAIvcGolvBu8gQ/RDVABH9iyzaP6Jbwk5nB3if+NDiWVQraJHD/uYAA2146wNcxXX036L+20zMfdqWFpxbk7yr5rF4nkaLV6TUvZ6u+rlGXYKT+Q/AYJO3KnOpz36RUvL3u5fcdqrLJISQ4kymbE+xLXKUq+85yikbc8U6qYOZSutgDmL+H/MDvTnZDKvmDcpcX8DEXHK1eedPYvLhmE7cVHBvawigAQk1ZcKZbBafwqNd2LrTyS2zfFuuOsT1LyznEwOzqAhpAnMklwgzj/DZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mLuYFoNTITFCPNgjhMWe61/yJxjCNOy3pQKj3Wubwj4=;
 b=YcQvYDyuH7N1x1DSSCrBqBKpIHmt1OQ1Xxr/D62fjUvkuiEATikbwJhI9/BbEzyHP0Jww2bthhRDK8xsMmOvUeYJKmnkvN7EJRJZj5khbccvmfMRJ4m9d/ncVyB2pcB7Ljg8I8APvNrWOf0VQD5Z6haVaO3sboBxMi5+DuL4/+o=
Received: from MW4PR03CA0300.namprd03.prod.outlook.com (2603:10b6:303:b5::35)
 by DS5PPF4A654669B.namprd12.prod.outlook.com (2603:10b6:f:fc00::64b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 05:44:33 +0000
Received: from MWH0EPF000C618E.namprd02.prod.outlook.com
 (2603:10b6:303:b5:cafe::95) by MW4PR03CA0300.outlook.office365.com
 (2603:10b6:303:b5::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.13 via Frontend Transport; Tue,
 28 Jul 2026 05:44:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C618E.mail.protection.outlook.com (10.167.249.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:44:32 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:44:24 -0500
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
	<shivankg@amd.com>, <donettom@linux.ibm.com>, Bharata B Rao <bharata@amd.com>
Subject: [PATCH v8 0/8] mm: Hot page tracking and promotion infrastructure
Date: Tue, 28 Jul 2026 11:13:48 +0530
Message-ID: <20260728054356.291998-1-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618E:EE_|DS5PPF4A654669B:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bd96ee3-e6a5-4715-0c1b-08deec6b4cd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|82310400026|7416014|1800799024|376014|23010399003|56012099006|11063799006|10067099003|6133799003|18002099003|3023799007|13003099007;
X-Microsoft-Antispam-Message-Info:
	y1hNLK3H9edGMb5T+32F2Q5eXEM2PhYR1a6Zg/KlmxW1dbJ6bM83VX21RawcynvrwppAygml0GrPvQuC+zEoNz/mkpD4P5dv05pqPCYTgr3ZRpKbA3liMbVBm2MoHmyV6MKbFfLrMvgGqa8i4ErZr9Oqpui3VT5EgYPIsmnFK84Y4yc6afncCjhN1RTmWyjJfrpH6CceMC5d6KyOkosK0b4QaHaL+V+Gxn3uDxmkPPOb5SyfOOHaBgwp2UGEKlhQKEMws9bkINoeYlIPVI3hTd5T7VkP6b0gKL7KzPAKSpcAxru1y3fa2d65QpzXNenhdOpQ54+BU/ARCxTN5ZCj+cH1V92BvnuNwjbDP0EZKWpiYhDAJkDGkaaOuamPnOVA4M/m/Qk2E1Vjss9KT3OwkWGPe+wfu0AHAi9+Y4HZCnmXbQn2ESy/W1RcFVaOWXJ82Xh/4Ff72fAh4t6fVW1Gin8QEZb3oHBrYuy/G4q2pqrraphuJ/hrhN/w93rCfvag3iHxF/SiywjScdU07LPE5drloh4a/7omZLZ4JAcSKKrUm9yxGlorlyhi6dsExbdhCk0SrfCsEfVCRv7MzafhKsub9YL21e/mN/XiLQOQVCtv9N6pXjDjwCQ53IBV/xJxW0X+kaR1xWvzar8R2lye4A==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(82310400026)(7416014)(1800799024)(376014)(23010399003)(56012099006)(11063799006)(10067099003)(6133799003)(18002099003)(3023799007)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LlnBiOeiJGJKoHxeYfBd2H8t4FidQVLlspmsxZNn04OIb3JUuRdwHpqk34hBkBU/tDB5m/gR71d+S4H6kq9WbJ9Q9deE6MvWacCplVFZju1a7hPbfs/22uSr/kHom9RwTPbMwAXXBkHdAcTaeSuqKsjU8JXAIr5s17aEC9TctayZWZxnHgcEsk192oS8aIWzW4d9wSgP7KJmcgUcEH0+qb5iUWvhX0bwAFpuYTCni+NIKuudXGuigdzG3TV5ND6n8dgkZbC1pgGT+7ybRF+BEy/MXeLnYCH1titAYaduYPvwtt8wzDVRKzlMHnYaXAKTLtmjQOy6sh2d2blIQzGvGHKe2uwLxxhTon7BpSFypJGjGKgBHhj6C3VucrRZPzPzwX2fH+LdIKicI5yBRRPSCBoyYyoSMYXLcDkRjgV6yy0KNgqf7fDfC1o4hSr0Bk8F
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:44:32.7079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bd96ee3-e6a5-4715-0c1b-08deec6b4cd5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C618E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPF4A654669B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0BC2C1A0007
X-Stat-Signature: 5zs9mhbo4zzaqhfuucw1xb6zt6rt7eeb
X-HE-Tag: 1785217481-729577
X-HE-Meta: U2FsdGVkX18D9k725o3uQQxeejWgqJpxCMd11sUhgTu429gVL6jiGZ9Yt0CxejFB1NxOwj5qCBX8D7lCj8geO/2HV8160N7EP6KvcFhNaJvL6MqLLdj3/b0URpg2jlZEH+gwaHJnfuxwO5j5mE1KXWpLQIOT34uiM1fw5D1hn1XxaNR9exdEl/pJNfKuCRf46d9XLeZP8eN/ijBaEB2lI60SIyq6Hi+uHnthKMc1G0yXJ366eX04cbGv2SpzxQDWOjZD6l9tfaUcE6HR2LV6Yor+wr1ZtUydS1xBZfPvgnhxhg5ZdoaM6ZS+nmudXDDERALpbYZ3fFIenrTH5RGevyv1qK3RTo2uwX5Kgqfj9c/+b256VqWI3Ev4laK3HSEThhRmuUAY2zlIygOttqBOsXVEKUHQyh+J0fGs1LRFWycovbEQDCu8ePqDyXKp94/wuQYHPyVTgNJYsLTQ7RCNX+URx/zELE7BRkktJS9214zi8cn5GYl7r24okgEy/kWOZfr5VJyGo05VFViDXlSWE70Yao+Yd9EwE+EtjDVVjq9WDleMRqBcV9X49S/N2YUd/+g2Wc9ZhOLeFdjqYAt6bmi1CN+gfmqRhtL49aEMZ23GKuilWOnbVaWEQ8BkCZitZArFlXR5vASjwtafyhJH6XLfASJVk7AeSA3K6VmO1/NJdaKjNwG1iTu/PITPwvfAdj1zFN+xprowavrErejX6EiIGF9Rr6Uo+zmFSEW+mRBdd/8AWt/frJv6GjI+QK8Ji/jkl9PjY13ipJBGllPoL3bRlipC5w36el1bp6/ywa9vFEevK+gO+xzJykdEviN7mb8nS1TX8M2Rj4y4pIEbG44RxsnHGddSUoOwOy1y4ZhmoPQWdxDvzsGdWQj2r6/PrGFDk8VPpy5M4Oa5K8KmekeWd8SsHIeqnRC+KANUHcngCokZBws2OlJXaXRXggydktUi5v/xI184rlT5gm0
 KEqNz1ej
 haFGtfcfdyQ9TTW5sw2LWlT+oqHd+MZJW5Yxy9z8WUwsI+3rFsPs+vJyVPgIOXiWZWozD8uZC1yHKDwnCQT8+mH+z1/Ywxlzi6/hzbTATp9QDyL5ztVpBNurhnYnnYalV06yXB7PjOLNzjA2uBNu7A1QawExCB+BU0XCrfe0BJfL2Ajvc/Y5CSWM8Q10bSpyVfKvZ/v1ckLABG3XklGZCQ3cOaGT8zAz3y+P/fbXNxUVZJw/PM+3KuxmR/lVrrnYaxJT9huB3ONVCp5OTMtI52W0Ap5QY5jkKnxIbgk0QeITMxS8yURpkYH0TCkwwcfiY4/y9rPDXotap3pfKjg12gqA3SG+1fucxWlP+xjV7RJ0CHYejrCUC0KKDB3au9VOXRZ5YuWdEXU7gP8KqYeQ5Hw0vVe6c8c4MBbujHnXKLAYGp0cPpLoVlaIGaWVLZ2oYyFAuACWQwizRM1afLLY6NLw8MA4+L230vvVCFLRDVFIxuMPvU+uabd8GsNspfhxtHIJsW2ihxB9iS7wcfSDGQbud9Da6bDD0sdh5DydDLEhmCpnOx7gM0OY2JbiAawtkKIgaL6UKzY3oRz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This patchset introduces pghot, a subsystem for hot page tracking and
promotion. It collects memory access information from multiple sources,
classifies hot pages resident in lower-tier memory, and promotes them to
faster tiers via a per-lower-tier-node kernel thread (kmigrated).

The main changes in v8 are a rework of the per-section hotness map to be
RCU-protected, a move of the pghot tunables from debugfs to sysctl, and a
rework of the AMD IBS Memory Profiler driver that now uses a dedicated system
interrupt vector instead of an NMI handler. The IBS driver is also split
into core infrastructure and a separate patch that adds the runtime
controls and arms the profiler. Also there are a few fixes to the hint
faults source.

Goals of this patchset:

- Unify hot page detection from multiple sources like hint faults,
  page table scans, hardware hints (AMD IBS).
- Decouple detection from migration.
- Centralize promotion logic via per-lower-tier-node kmigrated kernel
  thread.
- Move promotion rate-limiting and related logic used by numa_balancing=2
  (NUMAB2, the current NUMA balancing-based promotion) from the scheduler
  to pghot for broader reuse.

Currently, multiple kernel subsystems detect page accesses independently.
This patchset consolidates accesses from these mechanisms by providing:

- A common API for reporting page accesses.
- Shared infrastructure for tracking hotness at PFN granularity.
- Per-lower-tier-node kernel threads for promoting pages.

Performance summary
===================
All results are on 3-node tiered systems (DRAM top tier + CPU-less CXL
lower tier). Speedups below are normalized to the base kernel with no
tiering (NUMAB=0). Columns compare mainline hint-fault tiering
(base NUMAB=2) against pghot in two modes: hint-fault driven (pghot-hf,
NUMAB=2) and HW-hint driven via the AMD IBS memory profiler (pghot-hw,
NUMAB=0, no NUMA scanning). Single run per config (abench is avg of 3).

Benchmark      Metric (higher=better)   base-NUMAB2  pghot-hf  pghot-hw
-------------------------------------------------------------------------
NAS BT (MPI)   Mop/s total                  2.26x     2.26x     2.13x
Graph500 BFS   harmonic-mean TEPS           2.64x     2.49x     2.68x
llama.cpp      decode tok/s (tg128)         1.09x     1.41x     1.21x
Redis+memtier  ops/sec                      1.05x     1.05x     1.00x
Microbench     completion time (1/t)        2.41x     2.40x     2.35x
-------------------------------------------------------------------------
(baseline = base kernel, no tiering = 1.00x)

Summary: pghot hint-faults reproduces mainline NUMAB=2 with no
regression on every workload; pghot HW-hints/IBS matches it mostly.

- NAS BT (MPI, Class F modified, 16 ranks): full footprint pre-staged
  on the CXL lower tier, then measured cold; isolates hot-page promotion.
- Graph500 (reference BFS, SCALE=28, edgefactor=16, 128 ranks):
  working set on the CXL node; figure of merit is harmonic-mean TEPS.
- llama.cpp (llama-bench, Mixtral-8x22B Q4_K_M): ~1/3 of the model
  demoted to CXL under memory pressure; decode (tg128) is tier-sensitive.
- Redis + memtier (~64 GB dataset, 62.2M x 1 KB keys): dataset
  migrated to CXL, GET-heavy traffic over 50% of the keyspace.
- Microbenchmark: 64 threads, random 4K access over 8G on
  the CXL node; latency-bound.

Detailed per-benchmark tables (throughput/latency + vmstat and pghot
promotion counters) will be sent as replies to this patchset post.

How pghot works
===============
- Tracks frequency and last access time.
- Additionally, the accessing NUMA node ID (NID) for each recorded
  access is tracked in precision mode.
- These hotness parameters are maintained in a per-PFN hotness record
  within a per-section map hanging off the existing mem_section data
  structure. The map is RCU-protected and also carries a section-level
  "hot" flag used to gate scanning by kmigrated.
  - In default mode, one byte (u8) is used for the hotness record. 5 bits
    store time using a bucketing scheme representing up to 4s with
    HZ=1000. The default toptier NID (0) is used as the promotion target
    and can be changed via the vm.pghot_target_nid sysctl.
  - In precision mode, 4 bytes (u32) are used for each hotness record.
    14 bits store time, representing around 16s with HZ=1000, and the
    accessing NID is stored per-PFN as the promotion target.
- Classifies pages as hot based on configurable thresholds.
- Pages classified as hot are marked ready for migration using the ready
  bit (MSB of the hotness record in both modes).
- Per-lower-tier-node kmigrated threads periodically scan the PFNs of
  lower-tier nodes, checking the migration-ready bit to perform batched
  migrations. The scan interval and batch size are configurable via
  debugfs tunables.

Memory overhead
===============
Default mode: 1 byte per lower-tier PFN. For 1TB of lower-tier memory
this amounts to 256MB overhead (assuming 4K pages).

Precision mode: 4 bytes per lower-tier PFN. For 1TB of lower-tier memory
this amounts to 1GB overhead.

Bit layout of hotness record
============================
Default mode
- Bits 0-1: Frequency (2 bits, 4 access samples)
- Bits 2-6: Bucketed time (5 bits, up to 4s with HZ=1000)
- Bit 7:    Migration ready bit

Precision mode
- Bits 0-9:   Target NID (10 bits)
- Bits 10-12: Frequency (3 bits, 8 access samples)
- Bits 13-26: Time (14 bits, up to 16s with HZ=1000)
- Bits 27-30: Reserved
- Bit 31:     Migration ready bit

Tunables
========
sysctl (/proc/sys/vm/):
- pghot_enabled_sources      - bitmask of hotness sources (0x1 hint
                               faults, 0x2 hardware hints)
- pghot_target_nid           - toptier target NID (default mode)
- pghot_freq_threshold       - accesses before a page is promotable
- pghot_promote_freq_window_ms - access-frequency counting window
- pghot_promote_rate_limit_MBps - per-target promotion rate limit
  (numa_balancing_promote_rate_limit_MBps is retained as a compat alias)

debugfs (/sys/kernel/debug/pghot/):
- kmigrated_sleep_ms, kmigrated_batch_nr

Potential hotness sources
=========================
1. NUMA Balancing (NUMAB2, Tiering mode) - included in this patchset.
2. AMD IBS Memory Profiler: HW based access profiler - included in this
   patchset.
3. klruscand - PTE-A bit scanning built on MGLRU's walk helpers - was
   showcased in previous versions but not part of this patchset.
4. folio_mark_accessed() - Page cache access tracking (unmapped page
   cache pages) - was showcased in previous versions but not part of
   this patchset.

Changes in v8
=============
pghot-core
- Augmented documentation with per-source information
- Reworked the per-section hotness map (mem_section->hot_map) into an
  RCU-protected structure (struct pghot_hot_map) that holds the per-PFN
  records and section-level flags, for safe concurrent access and
  teardown. The section "hot" flag now lives in this structure instead of
  the pointer's LSB.
- Cleanup and fixes in pghot_update_record().
- Moved pghot tunables enabled_sources, target_nid and freq_threshold
  from debugfs to sysctl (/proc/sys/vm/). Only kmigrated_sleep_ms and
  kmigrated_batch_nr remain in debugfs.
- Kmigrated walk: Protect folio_memcg() under RCU readlock

pghot-hintfaults
- Retained kernel.numa_balancing_promote_rate_limit_MBps for compatibility
- Filter shared executable pages at NUMA hint fault time in
  do_numa_page()/do_huge_pmd_numa_page(), since the VMA is not available
  to kmigrated's batched migration from non-process context.
- Fixed NUMAB2 to continue feeding to task_numa_fault() so that scan
  period updates happens for pghot-NUMAB2.
- Now hint faults source is enabled by default in pghot so that setting
  kernel.numa_balancing=2 is enough for tiering mode to get activated
  as before.
- To avoid a regression for existing configs, default PGHOT to y when
  NUMA_BALANCING is enabled and default NUMA_BALANCING_TIERING to y.
  Since the tiering promotion engine now lives in pghot, an existing
  CONFIG_NUMA_BALANCING=y config would otherwise silently lose the ability
  to use kernel.numa_balancing=2 (writes returning -EOPNOTSUPP) after an
  oldconfig upgrade.
  Note: PGHOT depends on SPARSEMEM, so a NUMA_BALANCING=y && !SPARSEMEM
  (e.g. FLATMEM) config can no longer use kernel.numa_balancing=2.

pghot-hwhints
- Split the IBS Memory Profiler driver into core infrastructure and a
  separate patch that adds runtime controls (debugfs/sysfs and the
  ibs-memprof= cmdline parameter) and arms the profiler.
- Changed IBS Memory Profiler source to use regular interrupts rather
  than NMI. Unlike the primary IBS which needs to obtain samples from
  kernel and interrupt contexts for performance profiling, with memory access
  profiling only user space samples are obtained. Hence NMI isn't required.
  Also this simplifies the code by getting rid of irq_work hander.
- Fixed lost wakeup issue in work handler that drains the samples by
  draining samples in a loop until the ring buffer is observably empty.
- Drain and discard the samples of the CPU that is going offline.
- Fix the issue where the work item queued for a dying CPU can execute
  on a different online CPU leading to draining of that CPU's ring.
- Added ibs-memprof kernel cmdline option to enable hwhint source at boot
  time itself.
- Added vmstat counter hwhint_dropped_events that provides the count of
  those samples which were dropped due to sample buffer overrun.
- Added a sysfs tunable /sys/devices/system/cpu/ibs-mprof/enabled to
  dynamically enable or disable IBS Memory Profiler.
- Added debugfs tunables (l3miss-only, period, lat-filter, lat-thresh)
  to support configuration changes to IBS Memory profiler.

Compile test summary
====================
The series was compile-tested across the full range of relevant Kconfig
combinations on x86_64 (defconfig-based) and cross-compiled on arm64.
Combinations of PGHOT, PGHOT_PRECISE, NUMA_BALANCING,
NUMA_BALANCING_TIERING, NUMA_MIGRATION, HWMEM_PROFILER/AMD_IBS_MEMPROF,
DEBUG_FS and SYSCTL were verified, including pghot disabled, pghot
standalone (no NUMA balancing), NUMA balancing mode 1 and mode 2 (tiering),
precise mode, the AMD IBS memory profiler, NUMA_MIGRATION=n, and pghot with
DEBUG_FS and/or SYSCTL disabled. Kconfig guards were confirmed
(NUMA_BALANCING_TIERING without PGHOT, and HWMEM_PROFILER without a
selecting driver, are dropped). Since PGHOT defaults to y when
NUMA_BALANCING is set and NUMA_BALANCING_TIERING defaults to y, an existing
config with NUMA_BALANCING=y but no pghot symbols resolves, via
olddefconfig, to PGHOT=y and NUMA_BALANCING_TIERING=y and builds cleanly,
while NUMA_BALANCING=n leaves PGHOT off. allnoconfig, tinyconfig,
allyesconfig and allmodconfig were also built. All configurations build with
no new warnings.

This v8 patchset applies on top of upstream commit 8cdeaa50eae8 and can be
fetched from:

https://github.com/AMDESE/linux-mm/tree/bharata/pghot-v8

v7: https://lore.kernel.org/linux-mm/20260504060924.344313-1-bharata@amd.com/
v6: https://lore.kernel.org/linux-mm/20260323095104.238982-1-bharata@amd.com/
v5: https://lore.kernel.org/linux-mm/20260129144043.231636-1-bharata@amd.com/
v4: https://lore.kernel.org/linux-mm/20251206101423.5004-1-bharata@amd.com/
v3: https://lore.kernel.org/linux-mm/20251110052343.208768-1-bharata@amd.com/
v2: https://lore.kernel.org/linux-mm/20250910144653.212066-1-bharata@amd.com/
v1: https://lore.kernel.org/linux-mm/20250814134826.154003-1-bharata@amd.com/
v0: https://lore.kernel.org/linux-mm/20250306054532.221138-1-bharata@amd.com/

base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda

IBS Memory Profiler part of this patchset depends on the patchset that
increases the number of APIC EILVT registers -
https://lore.kernel.org/lkml/cover.1775019269.git.naveen@kernel.org/

AI assistance was taken to run and summarize the benchmark results.

Bharata B Rao (7):
  mm: migrate: Allow misplaced migration without VMA
  mm: Hot page tracking and promotion - pghot
  mm: pghot: Precision mode for pghot
  mm: sched: move NUMA balancing tiering promotion to pghot
  x86/ibs: Move IBS caps definitions into its own header
  x86/mm/ibs: In-kernel driver for AMD IBS Memory Profiler
  x86/mm/ibs: Add runtime controls for IBS memprofiler

Gregory Price (1):
  mm: migrate: Add promote_misplaced_memcg_folios()

 .../admin-guide/kernel-parameters.txt         |   5 +
 Documentation/admin-guide/mm/index.rst        |   1 +
 Documentation/admin-guide/mm/pghot.rst        | 196 ++++
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
 arch/x86/mm/ibs-mprof.c                       | 704 ++++++++++++++
 include/linux/cpuhotplug.h                    |   1 +
 include/linux/migrate.h                       |   9 +-
 include/linux/mm.h                            |  35 +-
 include/linux/mmzone.h                        |  25 +-
 include/linux/pghot.h                         | 140 +++
 include/linux/vm_event_item.h                 |  12 +
 init/Kconfig                                  |  14 +
 kernel/sched/core.c                           |   7 +
 kernel/sched/debug.c                          |   1 -
 kernel/sched/fair.c                           | 171 +---
 kernel/sched/sched.h                          |   1 -
 mm/Kconfig                                    |  34 +
 mm/Makefile                                   |   6 +
 mm/huge_memory.c                              |  32 +-
 mm/memcontrol.c                               |   6 +-
 mm/memory-tiers.c                             |  15 +-
 mm/memory.c                                   |  36 +-
 mm/mempolicy.c                                |   3 -
 mm/migrate.c                                  |  99 +-
 mm/mm_init.c                                  |  10 +
 mm/pghot-default.c                            |  76 ++
 mm/pghot-precise.c                            |  77 ++
 mm/pghot.c                                    | 891 ++++++++++++++++++
 mm/vmstat.c                                   |  14 +-
 40 files changed, 2593 insertions(+), 308 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/pghot.rst
 create mode 100644 arch/x86/include/asm/ibs-caps.h
 create mode 100644 arch/x86/include/asm/ibs-mprof.h
 create mode 100644 arch/x86/mm/ibs-mprof.c
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/pghot-default.c
 create mode 100644 mm/pghot-precise.c
 create mode 100644 mm/pghot.c

-- 
2.34.1


