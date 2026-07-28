Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 242C9C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19CBD6B0098; Tue, 28 Jul 2026 01:45:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14C726B0099; Tue, 28 Jul 2026 01:45:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FCB6B009B; Tue, 28 Jul 2026 01:45:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B163C6B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:45:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3792B1C07EA
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:21 +0000 (UTC)
X-FDA: 85037097642.20.898C8F5
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010056.outbound.protection.outlook.com [40.93.198.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1CF63A0013
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:45:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RfkFnHQ3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of bharata@amd.com designates 40.93.198.56 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785217518;
	b=OK1kXGE90RmcpAaxN9pHGjCw2IEFRWqauQzNIRLzjGAdAjW+L5f/eqvglO7ttT4zSoIAYT
	Da0CuS+ykbKbRracbWrTVlUEbOWK3Xj1Neejs8bGqMi9SOgAd7NcrK8Ediks7Id2aITAsM
	7AIQgU9Dsiy1Cq/YJzY3LyipoS/hNcI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RfkFnHQ3;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf25.hostedemail.com: domain of bharata@amd.com designates 40.93.198.56 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785217518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkmULbM3BEJIdBFkcQbmaXAkmwUqSt5UIH7Ul8fhp5E=;
	b=Op582ddMv8GEDJZnqBvtJ4DnGWnBcpklQOiVlN4qWWOYK2uKmCG3qAVEvFAqnOr2U8f323
	bZJMqTcP8idY0EKtrAJoW5AT1KAt9+i9+Ti+XTB6Xbi1Dk25Dp6SKbiY7t2wxJ5igGILFy
	xcsDkx2JXYyHgaHdID6oILIKC2kRklA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JbPpYcm8sKRd9khy/uC34GQuCRJolqw4CE9fhFopTbRoQzqbMqAOvfbZ5Bwg4pwhPRXbJGTn03a9wDI+WTQ0yj06N6XNTUuLj2rvyIjInmnFMZ0yKDgftvIRiOcS3WY0V5+wCGwSu6fL3BazhJsAuuheQM3Pl/SBDegrb42K14K9jHf1ugXHMNKv6AmXfdfScGO6Lxb/ofNvFd7h8E1M8mANQ59wLy2WLgBdzvK/AuSYJnJkcpGtINAXhRMbDCUBwzNs0roY4cmUwn9T/lXMKROYrwrVMuxqWQ4mNj9SObgK1P29905bd9YjR8d1w+5r9AAagzs6YNI8vLK9+ISkPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkmULbM3BEJIdBFkcQbmaXAkmwUqSt5UIH7Ul8fhp5E=;
 b=Tfkrp1L/+JC9rePwv+pUTST1wZl1PDleGR2rMeX7xhCzTaG7YrR2jwPzLcsaJvEkwdtRt3ZBvUk53r7LIxHSJXGqDP5dHJhMmujtgkpaJ3nbeiJ5ubsc3JpA76oWy8MDjYgKV6VHfKBc8a6nYoc+PwsD6qhKVCJtOvFMTDYdI+Sa+fF4+lZ2aIORvg6txz8NgQplq4/4L+YVDGyvwMgjXLV2ezeDrbZuVhFisSCkxVISoHlDiV3gfLCF7KWnzgcbxNXY1ijMSfM9Ysn7Yfml+I8LcAa8fSOtmPkmyk+gIlwb4YuKsRxuj+DkB0FVdDtdu0U3Rv+yuwSSEc7mdNTCfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkmULbM3BEJIdBFkcQbmaXAkmwUqSt5UIH7Ul8fhp5E=;
 b=RfkFnHQ3sBWKtiuHfc5oIxy608MX2w5CwiSMSY26zbyhJCi0aLNjP71JXRNZkeYyCfALrr3yYzHFjy8Zjd+ZZF4q1vvFsVCZmYy5RVpe7lzgMGJ5M9pOzHxPHDwXkLS2qjCycpRmQ76qsXjeobh2ThUjkt7H8p5A++NO3X06+K8=
Received: from MW4P220CA0016.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::21)
 by DM4PR12MB7718.namprd12.prod.outlook.com (2603:10b6:8:102::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 05:45:11 +0000
Received: from MWH0EPF000C6191.namprd02.prod.outlook.com
 (2603:10b6:303:115:cafe::a9) by MW4P220CA0016.outlook.office365.com
 (2603:10b6:303:115::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 05:45:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6191.mail.protection.outlook.com (10.167.249.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 05:45:11 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 00:45:03 -0500
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
Subject: [PATCH v8 5/8] mm: sched: move NUMA balancing tiering promotion to pghot
Date: Tue, 28 Jul 2026 11:13:53 +0530
Message-ID: <20260728054356.291998-6-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260728054356.291998-1-bharata@amd.com>
References: <20260728054356.291998-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6191:EE_|DM4PR12MB7718:EE_
X-MS-Office365-Filtering-Correlation-Id: d3cf66f6-e0a3-46b1-7119-08deec6b63ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|36860700016|82310400026|1800799024|56012099006|11063799006|5023799004|10067099003|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	n87TCaavwTwYe1WjFwOw1t/cQTDiA+4BkqCVaW6/c67fkebkqeREcudOlIv1/P2kSVGveUJtwyN+ZvNwDXC7hey+Mym9POGmM/xsPOOnbY281q4hodTvsTa4k5RF+Fj3AjSdcU0gySO7s49Ve4jVRyRTuSwl6qJ5LmEcPjhTyIjST0uQFOTMUL/yRig+NFn1ur1R90I1EG2ASNJhnedgF0D9hJOdkVX+J4YZxkfxH9wnre7eTXbAXW2KWqdnJCoNB9kz7YFq/JEwd2ZJhJtReK03oih1vLObsh4YaXcwePjv301broqFRF2ttwyssyqmb8DcI4iWbDNj+BD5zruvRBbnYFrl2oczazk2L5ZvdZtWpeayxuwCoFqIUomholaqzwJca3yXiYCy4weRV05G3FtTcleq7waEiRZD0sPUa09rd93Q9LQcq9BXztrkU+/0NdKUTXfKarMBSY85lyE/VVTGX6sCAiLIuG/cZGfkeUeRTdnZZIPo7inWoVu4nVKLSsRGLutze48spdebMfU64n09XtIRkADcjJYWoDjETTiESG5emTQqzT4ahFpB59nFePJCSxYwe1IcWMNhYfNqUYPLJ5Edz8LvPWMfnoPPa71m+2tAEXS3WNietDiXh5HCAnD7mqo1zcajI60VAbGvV3LywlQ4uijqO4qvHa8iJBZAqWzNILMXoC1H4pPX0/UIYMJB6HTJAk4orFtoQBdFrQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(36860700016)(82310400026)(1800799024)(56012099006)(11063799006)(5023799004)(10067099003)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	TnY1QCE9XkMilIcJOM+LR5h2j2aADMx7TvFTtguWQLAl2OV3rpJFaMQlP0v0C7iklSurDSSoGi9E1oVw8PjUEAtj8oKbRiKdeh5EtgaHZ3JPQat+cR3weUM0z1lrfgbv74d4I6d/82BicFgU0G6TrlE816yKNeCYnZmkJgF2fCkz98k0hnPAQtogqzt5603ktR1Bs3uX+XPbZu0Xg7sHGYPSsTfBjK1Ym2ca9Vjgrk7YtytZgeyhDixsxtOwnFQYEhmaigQNEX2w49ZeM7vN8qaHIoJHts6aD9UVP61akumY6VLsgN1R+yTAU9xNi1CcrXNhgWJSe8feQ0mRMO3pYQhzjsLql5MeYTXEN4QoaL9+NzYntGB8K6W3jbBuh1gAsayKBIdzlhW0f2GlspSBaLo3sn8Q4EhnjCmOF+ah2aGfADJ44pTBiam4HywXRD0N
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 05:45:11.1727
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3cf66f6-e0a3-46b1-7119-08deec6b63ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6191.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7718
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1CF63A0013
X-Stat-Signature: bbythgshjfxrf15sgyinhcfdkb6ijruo
X-Rspam-User: 
X-HE-Tag: 1785217517-552927
X-HE-Meta: U2FsdGVkX189zJAEHEDiUyyovB5u7G5dTU6FP07YJv02ppgByoEE26zzcjoRa7i1eo7TdY3aCjIdOmnqhFshOTE061rdFon3ZQf6skNHK87rasYbfvorU3tNqVDX0Ys/xk9rce4uQfnb3T9H6fJuirwJ6O8VODLbJ3DCCgQ0SJ/D3VW/ui8P3bmcjtm7y/uZ5nLONwJaBXscKI5PWbgFRJTB7CIK+2KQiJRzzXZVwRvEyf/Fx6BwIXbz530fzS+qf83ZMK/ReB0ml6Emvy1wjVVE4/ZVukNEqqPIH3FDFaFzgIP9pkbpfYGvzDVru5JuH/o9uSlODN7LTMFzENlldUUhdxvsCserH4+NmBHWoAgfISY90DHhWJamrDwhEP1fJlncok7lshAqEqT7a8cIdCsYbKU45/2EGmXfDiHLqdUzPpuJmMpqD42+XWu6fHPuwGJZ4QzvdQKm6MMfjJ1/qInaks4QxQB+KxdxfGNIdQOMXPe+6Ns5VpvWp4kAJRV5wA/G/+TuXLMCViRXHAwCBSpFAhGfPUqqEkZQeqQKILEmoecF7/GvAqFZ7xPYifjQKKQ8j1xl7hNntjbCzWgsORF9EWq6oot4Y6DYyVH/0vvcCkZKdGPxPUN7quSfEDGLCK1W5NOkLlrqCqi6cIWYRaG3s4+DD+sgq+PCdQQrjtuvS+LdHgnVYRQPmGoiV3Ap8QtQb4D7MPJztKsCs8iyNOBy8z0Oh+JXXPbr4hbdVX/Po1omqHLRG9ZeNGbPQAVIUXdmCGioaa3E+J+brcJTSXcQzHDY1F9eMhpNdHI6/Tyf0W5QwMog9gY7TUCoR8tPmii7gQgz5CjY8Y29VRSfYXJwHW/FB2lqOXhDQ9N4S+TLNnAHNzYV6gIowWmR+/Y58u1CigFmIwzOnqSt2+VQBMW0pA6vCazCr8wCYoYC4t84l3paxVgXXIFXy8Q0evfhj1ngyoxp7Z34q+0DUKq
 I/aXr8V7
 b371atYgwax2NAD1dkPxWu3tLwQpRSOBWGtKFnz/uhK+Oh5++C2MYfY4HNNEhDjsAbqsSq7pwQQG+hH0ovXsjstoNSstqzk5mstxOEVg5nCtCKs9huIl9mfWLkTS/zRoMLWq691y+PdXwySdQl2Sdzz5eAV2EOUkTGIf3nRP0+M2+0WOLyZ4fywfzPdo3wRCMrazNsoq76tqhyqywQQZpNtFIQKRLi8Hyd9iO69rDawCqPaBpytzVzVf9EFZhfrg44+zPvLoJXrlZnMgcqd8RoNiIdnCSCBgIGUngWHRPUSWRhNhvDBcMRKSfZyVLhTTUZelWzmaR2RW8ExH4LgJGmceo+YT0Q60NPgYgeo7PqF7OavDcmUPwAO/a+Ec3GA5SnE7Cyo2gLRv4YMj/AUmFK9vP+nIpJTUyN6zVNNwUkq8b/wh6QO/Ss35Pxkj5Gueenm8Cjz6r0THRrTfAj4wyBhoGahE9QmuCe/uJFobkUk32CHja3baXXEisKnZbUkMfOWm+jc6nz4J7sRNa2JlPABQnCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently hot page promotion (NUMA_BALANCING_MEMORY_TIERING
mode of NUMA Balancing) does hot page detection (via hint faults),
hot page classification and eventual promotion, all by itself and
sits within the scheduler.

With pghot, the new hot page tracking and promotion mechanism
being available, NUMA Balancing can limit itself to detection
of hot pages (via hint faults) and off-load rest of the
functionality to pghot.

To achieve this, pghot_record_access(PGHOT_HINTFAULTS) API
is used to feed the hot page info to pghot. In addition, the
migration rate limiting and dynamic threshold logic are moved to
kmigrated so that the same can be used for hot pages reported by
other sources too. Hence it becomes necessary to introduce a
new config option CONFIG_NUMA_BALANCING_TIERING to control
the hint faults source for hot page promotion. This option
controls the NUMA_BALANCING_MEMORY_TIERING mode of
kernel.numa_balancing

This movement of hot page promotion to pghot results in the following
changes to the behaviour of hint faults based hot page promotion:

1. Promotion is no longer done in the fault path but instead is
   deferred to kmigrated and happens in batches.
2. NUMA_BALANCING_MEMORY_TIERING mode used to promote on first
   access. Pghot by default, promotes on second access though this
   can be changed by setting /proc/sys/vm/pghot_freq_threshold tunable.
3. hot_threshold_ms debugfs tunable now gets replaced by
   /proc/sys/vm/pghot_promote_freq_window_ms with default value of
   1000ms changed to 3000ms in pghot-default and 5000ms pghot-precise.
4. In NUMA_BALANCING_MEMORY_TIERING mode, hint fault latency is the
   difference between the PTE update time (during scanning) and the
   access time (hint fault). However with pghot, a single latency
   threshold is used for two purposes:
   a) If the time difference between successive accesses are within
      the threshold, the page is marked as hot.
   b) Later when kmigrated picks up the page for migration, it will
      migrate only if the difference between the current time and
      the time when the page was marked hot is with the threshold.
5. The max scan period which is used in dynamic threshold logic
   was a debugfs tunable (sysctl_numa_balancing_scan_period_max).
   However this has been converted to a scalar metric in pghot.
6. In the uncommon case of using NUMA_BALANCING_NORMAL mode
   to balance between lower and higher tier nodes, we end up
   waking the kswapd when there is no headroom in the toptier.

Key code changes due to this movement are detailed below to help
easy understanding of the restructuring.

1. Scanning and access times are no longer tracked in last_cpupid
   field of folio flags. Hence all code related to this (like
   folio_xchg_access_time(), cpupid_valid()) are removed.
2. The misplaced migration routines become conditional to
   CONFIG_PGHOT in addition to CONFIG_NUMA_BALANCING.
3. The promotion related stats (like PGPROMOTE_SUCCESS etc) are
   now moved to under CONFIG_PGHOT as these stats are part of
   promotion engine which will be used for other hotness sources
   as well.
4. Routines that are responsibile for migration rate limiting
   dynamic thresholding, pgdat balancing during promotion etc
   are moved to pghot with appropriate renaming.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/pghot.rst |  23 +++-
 include/linux/mm.h                     |  35 +----
 include/linux/mmzone.h                 |   4 +-
 init/Kconfig                           |  14 ++
 kernel/sched/core.c                    |   7 +
 kernel/sched/debug.c                   |   1 -
 kernel/sched/fair.c                    | 171 +------------------------
 kernel/sched/sched.h                   |   1 -
 mm/Kconfig                             |   2 +-
 mm/huge_memory.c                       |  32 ++++-
 mm/memcontrol.c                        |   6 +-
 mm/memory-tiers.c                      |  15 ++-
 mm/memory.c                            |  36 +++++-
 mm/mempolicy.c                         |   3 -
 mm/migrate.c                           |  16 ++-
 mm/pghot.c                             | 163 ++++++++++++++++++++++-
 mm/vmstat.c                            |   2 +-
 17 files changed, 310 insertions(+), 221 deletions(-)

diff --git a/Documentation/admin-guide/mm/pghot.rst b/Documentation/admin-guide/mm/pghot.rst
index 6d9b3d9522d1..accf78d95d02 100644
--- a/Documentation/admin-guide/mm/pghot.rst
+++ b/Documentation/admin-guide/mm/pghot.rst
@@ -35,7 +35,11 @@ Path: /proc/sys/vm/pghot_enabled_sources
 - Bits:
   - 0: Hint faults (value 0x1)
   - 1: Hardware hints (value 0x2)
-- Default: 0 (disabled)
+- Default: 0x1 (hint faults enabled, hardware hints disabled). Hint faults
+  are enabled by default so that selecting the NUMA Balancing memory
+  tiering mode (kernel.numa_balancing=2) promotes hot pages without any
+  additional opt-in. Hint faults are fed to pghot only while tiering mode
+  is selected, so this default has no effect otherwise.
 - Example:
   # echo 0x3 > /proc/sys/vm/pghot_enabled_sources
   Enables both hint faults and hwhints sources
@@ -87,3 +91,20 @@ Path: /proc/vmstat
 
 3. **pghot_recorded_hwhints**
    - Number of recorded accesses reported by hwhints source.
+
+NUMA Hint Faults Source
+=======================
+The "hint faults" source is the tiering mode of NUMA Balancing
+which acts as a source of page hotness to pghot.
+
+It is controlled by the NUMA_BALANCING_TIERING config option, which
+gates the memory tiering mode (NUMA_BALANCING_MEMORY_TIERING) of NUMA
+Balancing. At runtime that mode must additionally be selected through
+the kernel.numa_balancing sysctl.
+
+This source is enabled by default through the hint faults bit (0x1) of
+**pghot_enabled_sources**, so selecting the tiering mode alone is enough
+to promote hot pages. It can be disabled at runtime by clearing that bit:
+
+# echo 0x0 > /proc/sys/vm/pghot_enabled_sources
+
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..1fdb0e143c65 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2305,17 +2305,6 @@ static inline int folio_nid(const struct folio *folio)
 }
 
 #ifdef CONFIG_NUMA_BALANCING
-/* page access time bits needs to hold at least 4 seconds */
-#define PAGE_ACCESS_TIME_MIN_BITS	12
-#if LAST_CPUPID_SHIFT < PAGE_ACCESS_TIME_MIN_BITS
-#define PAGE_ACCESS_TIME_BUCKETS				\
-	(PAGE_ACCESS_TIME_MIN_BITS - LAST_CPUPID_SHIFT)
-#else
-#define PAGE_ACCESS_TIME_BUCKETS	0
-#endif
-
-#define PAGE_ACCESS_TIME_MASK				\
-	(LAST_CPUPID_MASK << PAGE_ACCESS_TIME_BUCKETS)
 
 static inline int cpu_pid_to_cpupid(int cpu, int pid)
 {
@@ -2381,15 +2370,6 @@ static inline void page_cpupid_reset_last(struct page *page)
 }
 #endif /* LAST_CPUPID_NOT_IN_PAGE_FLAGS */
 
-static inline int folio_xchg_access_time(struct folio *folio, int time)
-{
-	int last_time;
-
-	last_time = folio_xchg_last_cpupid(folio,
-					   time >> PAGE_ACCESS_TIME_BUCKETS);
-	return last_time << PAGE_ACCESS_TIME_BUCKETS;
-}
-
 static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 {
 	unsigned int pid_bit;
@@ -2400,18 +2380,12 @@ static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 	}
 }
 
-bool folio_use_access_time(struct folio *folio);
 #else /* !CONFIG_NUMA_BALANCING */
 static inline int folio_xchg_last_cpupid(struct folio *folio, int cpupid)
 {
 	return folio_nid(folio); /* XXX */
 }
 
-static inline int folio_xchg_access_time(struct folio *folio, int time)
-{
-	return 0;
-}
-
 static inline int folio_last_cpupid(struct folio *folio)
 {
 	return folio_nid(folio); /* XXX */
@@ -2454,11 +2428,16 @@ static inline bool cpupid_match_pid(struct task_struct *task, int cpupid)
 static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
 {
 }
-static inline bool folio_use_access_time(struct folio *folio)
+#endif /* CONFIG_NUMA_BALANCING */
+
+#ifdef CONFIG_NUMA_BALANCING_TIERING
+bool folio_is_promo_candidate(struct folio *folio);
+#else
+static inline bool folio_is_promo_candidate(struct folio *folio)
 {
 	return false;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_NUMA_BALANCING_TIERING */
 
 #if defined(CONFIG_KASAN_SW_TAGS) || defined(CONFIG_KASAN_HW_TAGS)
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 11c547a51f43..c5a9237eedd8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -288,7 +288,7 @@ enum node_stat_item {
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	PGPROMOTE_SUCCESS,	/* promote successfully */
 	/**
 	 * Candidate pages for promotion based on hint fault latency.  This
@@ -1555,7 +1555,7 @@ typedef struct pglist_data {
 	unsigned long first_deferred_pfn;
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	/* start time in ms of current promote rate limit period */
 	unsigned int nbp_rl_start;
 	/* number of promote candidate pages at start time of current rate limit period */
diff --git a/init/Kconfig b/init/Kconfig
index 5230d4879b1c..75f5a0cb9065 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1038,6 +1038,20 @@ config NUMA_BALANCING_DEFAULT_ENABLED
 	  If set, automatic NUMA balancing will be enabled if running on a NUMA
 	  machine.
 
+config NUMA_BALANCING_TIERING
+	bool "NUMA balancing memory tiering promotion"
+	depends on NUMA_BALANCING && PGHOT
+	default y
+	help
+	  Enable NUMA balancing mode 2 (memory tiering). This allows
+	  automatic promotion of hot pages from slower memory tiers to
+	  faster tiers using the pghot subsystem.
+
+	  This requires CONFIG_PGHOT for the hot page tracking engine.
+	  This option is required for kernel.numa_balancing=2.
+
+	  If unsure, say N.
+
 config SLAB_OBJ_EXT
 	bool
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 96226707c2f6..10863460fed2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4639,6 +4639,7 @@ void set_numabalancing_state(bool enabled)
 }
 
 #ifdef CONFIG_PROC_SYSCTL
+#ifdef CONFIG_NUMA_BALANCING_TIERING
 static void reset_memory_tiering(void)
 {
 	struct pglist_data *pgdat;
@@ -4649,6 +4650,7 @@ static void reset_memory_tiering(void)
 		pgdat->nbp_th_start = jiffies_to_msecs(jiffies);
 	}
 }
+#endif
 
 static int sysctl_numa_balancing(const struct ctl_table *table, int write,
 			  void *buffer, size_t *lenp, loff_t *ppos)
@@ -4666,9 +4668,14 @@ static int sysctl_numa_balancing(const struct ctl_table *table, int write,
 	if (err < 0)
 		return err;
 	if (write) {
+		if ((state & NUMA_BALANCING_MEMORY_TIERING) &&
+		    !IS_ENABLED(CONFIG_NUMA_BALANCING_TIERING))
+			return -EOPNOTSUPP;
+#ifdef CONFIG_NUMA_BALANCING_TIERING
 		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
 		    (state & NUMA_BALANCING_MEMORY_TIERING))
 			reset_memory_tiering();
+#endif
 		sysctl_numa_balancing_mode = state;
 		__set_numabalancing_state(state);
 	}
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 40584b27ea0c..7918de84abcf 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -665,7 +665,6 @@ static __init int sched_init_debug(void)
 	debugfs_create_u32("scan_period_min_ms", 0644, numa, &sysctl_numa_balancing_scan_period_min);
 	debugfs_create_u32("scan_period_max_ms", 0644, numa, &sysctl_numa_balancing_scan_period_max);
 	debugfs_create_u32("scan_size_mb", 0644, numa, &sysctl_numa_balancing_scan_size);
-	debugfs_create_u32("hot_threshold_ms", 0644, numa, &sysctl_numa_balancing_hot_threshold);
 #endif /* CONFIG_NUMA_BALANCING */
 
 #ifdef CONFIG_SCHED_CACHE
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d78467ec6ee1..f865b93c99b5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -125,11 +125,6 @@ int __weak arch_asym_cpu_priority(int cpu)
 static unsigned int sysctl_sched_cfs_bandwidth_slice		= 5000UL;
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
-/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
-static unsigned int sysctl_numa_balancing_promote_rate_limit = 65536;
-#endif
-
 #ifdef CONFIG_SYSCTL
 static const struct ctl_table sched_fair_sysctls[] = {
 #ifdef CONFIG_CFS_BANDWIDTH
@@ -142,16 +137,6 @@ static const struct ctl_table sched_fair_sysctls[] = {
 		.extra1         = SYSCTL_ONE,
 	},
 #endif
-#ifdef CONFIG_NUMA_BALANCING
-	{
-		.procname	= "numa_balancing_promote_rate_limit_MBps",
-		.data		= &sysctl_numa_balancing_promote_rate_limit,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-	},
-#endif /* CONFIG_NUMA_BALANCING */
 };
 
 static int __init sched_fair_sysctl_init(void)
@@ -2214,9 +2199,6 @@ unsigned int sysctl_numa_balancing_scan_size = 256;
 /* Scan @scan_size MB every @scan_period after an initial @scan_delay in ms */
 unsigned int sysctl_numa_balancing_scan_delay = 1000;
 
-/* The page with hint page fault latency < threshold in ms is considered hot */
-unsigned int sysctl_numa_balancing_hot_threshold = MSEC_PER_SEC;
-
 struct numa_group {
 	refcount_t refcount;
 
@@ -2559,120 +2541,6 @@ static inline unsigned long group_weight(struct task_struct *p, int nid,
 	return 1000 * faults / total_faults;
 }
 
-/*
- * If memory tiering mode is enabled, cpupid of slow memory page is
- * used to record scan time instead of CPU and PID.  When tiering mode
- * is disabled at run time, the scan time (in cpupid) will be
- * interpreted as CPU and PID.  So CPU needs to be checked to avoid to
- * access out of array bound.
- */
-static inline bool cpupid_valid(int cpupid)
-{
-	return cpupid_to_cpu(cpupid) < nr_cpu_ids;
-}
-
-/*
- * For memory tiering mode, if there are enough free pages (more than
- * enough watermark defined here) in fast memory node, to take full
- * advantage of fast memory capacity, all recently accessed slow
- * memory pages will be migrated to fast memory node without
- * considering hot threshold.
- */
-static bool pgdat_free_space_enough(struct pglist_data *pgdat)
-{
-	int z;
-	unsigned long enough_wmark;
-
-	enough_wmark = max(1UL * 1024 * 1024 * 1024 >> PAGE_SHIFT,
-			   pgdat->node_present_pages >> 4);
-	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
-		struct zone *zone = pgdat->node_zones + z;
-
-		if (!populated_zone(zone))
-			continue;
-
-		if (zone_watermark_ok(zone, 0,
-				      promo_wmark_pages(zone) + enough_wmark,
-				      ZONE_MOVABLE, 0))
-			return true;
-	}
-	return false;
-}
-
-/*
- * For memory tiering mode, when page tables are scanned, the scan
- * time will be recorded in struct page in addition to make page
- * PROT_NONE for slow memory page.  So when the page is accessed, in
- * hint page fault handler, the hint page fault latency is calculated
- * via,
- *
- *	hint page fault latency = hint page fault time - scan time
- *
- * The smaller the hint page fault latency, the higher the possibility
- * for the page to be hot.
- */
-static int numa_hint_fault_latency(struct folio *folio)
-{
-	int last_time, time;
-
-	time = jiffies_to_msecs(jiffies);
-	last_time = folio_xchg_access_time(folio, time);
-
-	return (time - last_time) & PAGE_ACCESS_TIME_MASK;
-}
-
-/*
- * For memory tiering mode, too high promotion/demotion throughput may
- * hurt application latency.  So we provide a mechanism to rate limit
- * the number of pages that are tried to be promoted.
- */
-static bool numa_promotion_rate_limit(struct pglist_data *pgdat,
-				      unsigned long rate_limit, int nr)
-{
-	unsigned long nr_cand;
-	unsigned int now, start;
-
-	now = jiffies_to_msecs(jiffies);
-	mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE, nr);
-	nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
-	start = pgdat->nbp_rl_start;
-	if (now - start > MSEC_PER_SEC &&
-	    cmpxchg(&pgdat->nbp_rl_start, start, now) == start)
-		pgdat->nbp_rl_nr_cand = nr_cand;
-	if (nr_cand - pgdat->nbp_rl_nr_cand >= rate_limit)
-		return true;
-	return false;
-}
-
-#define NUMA_MIGRATION_ADJUST_STEPS	16
-
-static void numa_promotion_adjust_threshold(struct pglist_data *pgdat,
-					    unsigned long rate_limit,
-					    unsigned int ref_th)
-{
-	unsigned int now, start, th_period, unit_th, th;
-	unsigned long nr_cand, ref_cand, diff_cand;
-
-	now = jiffies_to_msecs(jiffies);
-	th_period = sysctl_numa_balancing_scan_period_max;
-	start = pgdat->nbp_th_start;
-	if (now - start > th_period &&
-	    cmpxchg(&pgdat->nbp_th_start, start, now) == start) {
-		ref_cand = rate_limit *
-			sysctl_numa_balancing_scan_period_max / MSEC_PER_SEC;
-		nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
-		diff_cand = nr_cand - pgdat->nbp_th_nr_cand;
-		unit_th = ref_th * 2 / NUMA_MIGRATION_ADJUST_STEPS;
-		th = pgdat->nbp_threshold ? : ref_th;
-		if (diff_cand > ref_cand * 11 / 10)
-			th = max(th - unit_th, unit_th);
-		else if (diff_cand < ref_cand * 9 / 10)
-			th = min(th + unit_th, ref_th * 2);
-		pgdat->nbp_th_nr_cand = nr_cand;
-		pgdat->nbp_threshold = th;
-	}
-}
-
 bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 				int src_nid, int dst_cpu)
 {
@@ -2688,41 +2556,15 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 
 	/*
 	 * The pages in slow memory node should be migrated according
-	 * to hot/cold instead of private/shared.
-	 */
-	if (folio_use_access_time(folio)) {
-		struct pglist_data *pgdat;
-		unsigned long rate_limit;
-		unsigned int latency, th, def_th;
-		long nr = folio_nr_pages(folio);
-
-		pgdat = NODE_DATA(dst_nid);
-		if (pgdat_free_space_enough(pgdat)) {
-			/* workload changed, reset hot threshold */
-			pgdat->nbp_threshold = 0;
-			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
-			return true;
-		}
-
-		def_th = sysctl_numa_balancing_hot_threshold;
-		rate_limit = MB_TO_PAGES(sysctl_numa_balancing_promote_rate_limit);
-		numa_promotion_adjust_threshold(pgdat, rate_limit, def_th);
-
-		th = pgdat->nbp_threshold ? : def_th;
-		latency = numa_hint_fault_latency(folio);
-		if (latency >= th)
-			return false;
-
-		return !numa_promotion_rate_limit(pgdat, rate_limit, nr);
-	}
+	 * to hot/cold instead of private/shared. Also the migration
+	 * of such pages are handled by kmigrated.
+	 */
+	if (folio_is_promo_candidate(folio))
+		return true;
 
 	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
 	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
 
-	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
-	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
-		return false;
-
 	/*
 	 * Allow first faults or private faults to migrate immediately early in
 	 * the lifetime of a task. The magic number 4 is based on waiting for
@@ -3956,8 +3798,7 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	 * node for memory tiering mode.
 	 */
 	if (!node_is_toptier(mem_node) &&
-	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ||
-	     !cpupid_valid(last_cpupid)))
+	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
 		return;
 
 	/* Allocate buffer to track faults on a per-node basis */
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 56acf502ba26..84b94f143a23 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3120,7 +3120,6 @@ extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
 extern unsigned int sysctl_numa_balancing_scan_size;
-extern unsigned int sysctl_numa_balancing_hot_threshold;
 
 #ifdef CONFIG_SCHED_HRTICK
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 955a826ecfe9..61ab18f4aebb 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1511,7 +1511,7 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 config PGHOT
 	bool "Hot page tracking and promotion"
-	default n
+	default y if NUMA_BALANCING
 	depends on NUMA_MIGRATION && SPARSEMEM
 	help
 	  A sub-system to track page accesses in lower tier memory and
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..c36092ebca42 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -41,6 +41,7 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/pghot.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2205,7 +2206,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	int nid = NUMA_NO_NODE;
 	int target_nid, last_cpupid;
 	pmd_t pmd, old_pmd;
-	bool writable = false;
+	bool writable = false, needs_promotion = false;
 	int flags = 0;
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -2232,11 +2233,29 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 		goto out_map;
 
 	nid = folio_nid(folio);
+	needs_promotion = folio_is_promo_candidate(folio);
 
 	target_nid = numa_migrate_check(folio, vmf, haddr, &flags, writable,
 					&last_cpupid);
 	if (target_nid == NUMA_NO_NODE)
 		goto out_map;
+
+	if (needs_promotion) {
+		/*
+		 * Hot page promotion, mode=NUMA_BALANCING_MEMORY_TIERING.
+		 *
+		 * Isolation and migration are handled by pghot. Since VMA
+		 * won't be available to kmigrated which does batched migration
+		 * from non-process context, filter shared EXEC pages here itself.
+		 */
+		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+			nid = NUMA_NO_NODE;
+		else
+			nid = target_nid;
+		goto out_map;
+	}
+
+	/* Balancing b/n toptier nodes, mode=NUMA_BALANCING_NORMAL */
 	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
 		flags |= TNF_MIGRATE_FAIL;
 		goto out_map;
@@ -2268,8 +2287,17 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 	spin_unlock(vmf->ptl);
 
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE) {
+		if (needs_promotion)
+			pghot_record_access(folio_pfn(folio), nid,
+					    PGHOT_HINTFAULTS, jiffies);
+		/*
+		 * Even when the hint fault is handed off to pghot for
+		 * promotion, keep feeding NUMA Balancing per-task fault
+		 * statistics for scan-period adjustment.
+		 */
 		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
+	}
 	return 0;
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..295f41f1ee16 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -400,7 +400,7 @@ static const unsigned int memcg_node_stat_items[] = {
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	PGPROMOTE_SUCCESS,
 #endif
 	PGDEMOTE_KSWAPD,
@@ -1603,7 +1603,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
 	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
 	{ "pgrefill",			PGREFILL		},
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
 #endif
 };
@@ -1655,7 +1655,7 @@ static int memcg_page_state_output_unit(int item)
 	case PGSCAN_KHUGEPAGED:
 	case PGSCAN_PROACTIVE:
 	case PGREFILL:
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	case PGPROMOTE_SUCCESS:
 #endif
 		return 1;
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 54851d8a195b..be134a32f5bf 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -51,18 +51,19 @@ static const struct bus_type memory_tier_subsys = {
 	.dev_name = "memory_tier",
 };
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_NUMA_BALANCING_TIERING
 /**
- * folio_use_access_time - check if a folio reuses cpupid for page access time
+ * folio_is_promo_candidate - check if the folio qualifies for promotion
+ *
  * @folio: folio to check
  *
- * folio's _last_cpupid field is repurposed by memory tiering. In memory
- * tiering mode, cpupid of slow memory folio (not toptier memory) is used to
- * record page access time.
+ * Checks if NUMA Balancing tiering mode is set and the folio belongs
+ * to lower tier. If so, it qualifies for promotion to toptier when
+ * it is categorized as hot.
  *
- * Return: the folio _last_cpupid is used to record page access time
+ * Return: True if the above condition is met, else False.
  */
-bool folio_use_access_time(struct folio *folio)
+bool folio_is_promo_candidate(struct folio *folio)
 {
 	return (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
 	       !node_is_toptier(folio_nid(folio));
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..91daba4c2bc9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -75,6 +75,7 @@
 #include <linux/perf_event.h>
 #include <linux/ptrace.h>
 #include <linux/vmalloc.h>
+#include <linux/pghot.h>
 #include <linux/sched/sysctl.h>
 #include <linux/pgalloc.h>
 #include <linux/uaccess.h>
@@ -6029,10 +6030,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 	if (folio_maybe_mapped_shared(folio) && (vma->vm_flags & VM_SHARED))
 		*flags |= TNF_SHARED;
 	/*
-	 * For memory tiering mode, cpupid of slow memory page is used
-	 * to record page access time.  So use default value.
+	 * For memory tiering mode, last_cpupid is unused. So use default value.
 	 */
-	if (folio_use_access_time(folio))
+	if (folio_is_promo_candidate(folio))
 		*last_cpupid = (-1 & LAST_CPUPID_MASK);
 	else
 		*last_cpupid = folio_last_cpupid(folio);
@@ -6113,6 +6113,7 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	int nid = NUMA_NO_NODE;
 	bool writable = false, ignore_writable = false;
 	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
+	bool needs_promotion = false;
 	int last_cpupid;
 	int target_nid;
 	pte_t pte, old_pte;
@@ -6147,12 +6148,30 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 		goto out_map;
 
 	nid = folio_nid(folio);
+	needs_promotion = folio_is_promo_candidate(folio);
 	nr_pages = folio_nr_pages(folio);
 
 	target_nid = numa_migrate_check(folio, vmf, vmf->address, &flags,
 					writable, &last_cpupid);
 	if (target_nid == NUMA_NO_NODE)
 		goto out_map;
+
+	if (needs_promotion) {
+		/*
+		 * Hot page promotion, mode=NUMA_BALANCING_MEMORY_TIERING.
+		 *
+		 * Isolation and migration are handled by pghot. Since VMA
+		 * won't be available to kmigrated which does batched migration
+		 * from non-process context, filter shared EXEC pages here itself.
+		 */
+		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+			nid = NUMA_NO_NODE;
+		else
+			nid = target_nid;
+		goto out_map;
+	}
+
+	/* Balancing b/n toptier nodes, mode=NUMA_BALANCING_NORMAL */
 	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
 		flags |= TNF_MIGRATE_FAIL;
 		goto out_map;
@@ -6192,8 +6211,17 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 					    writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE) {
+		if (needs_promotion)
+			pghot_record_access(folio_pfn(folio), nid,
+					    PGHOT_HINTFAULTS, jiffies);
+		/*
+		 * Even when the hint fault is handed off to pghot for
+		 * promotion, keep feeding NUMA Balancing per-task fault
+		 * statistics for scan-period adjustment.
+		 */
 		task_numa_fault(last_cpupid, nid, nr_pages, flags);
+	}
 	return 0;
 }
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 36699fabd3c2..111ac78c2b23 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -872,9 +872,6 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	    node_is_toptier(nid))
 		return false;
 
-	if (folio_use_access_time(folio))
-		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
-
 	return true;
 }
 
diff --git a/mm/migrate.c b/mm/migrate.c
index 7ab15780226e..4b97d6997f4b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2712,8 +2712,18 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 	if (!migrate_balanced_pgdat(pgdat, nr_pages)) {
 		int z;
 
-		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING))
+		/*
+		 * Kswapd wakeup for creating headroom in toptier is done only
+		 * for hot page promotion case and not for misplaced migrations
+		 * between toptier nodes.
+		 *
+		 * In the uncommon case of using NUMA_BALANCING_NORMAL mode
+		 * to balance between lower and higher tier nodes, we end up
+		 * waking the kswapd.
+		 */
+		if (node_is_toptier(folio_nid(folio)))
 			return -EAGAIN;
+
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
 				break;
@@ -2763,6 +2773,8 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 #ifdef CONFIG_NUMA_BALANCING
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
+#endif
+#ifdef CONFIG_PGHOT
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node)) {
@@ -2828,6 +2840,8 @@ int promote_misplaced_memcg_folios(struct list_head *folio_list, int node)
 #ifdef CONFIG_NUMA_BALANCING
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
+#endif
+#ifdef CONFIG_PGHOT
 		mod_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(node)),
 				 PGPROMOTE_SUCCESS, nr_succeeded);
 #endif
diff --git a/mm/pghot.c b/mm/pghot.c
index f66baacb2862..9babaff7c0e6 100644
--- a/mm/pghot.c
+++ b/mm/pghot.c
@@ -17,6 +17,9 @@
  * the hot pages. kmigrated runs for each lower tier node. It iterates
  * over the node's PFNs and  migrates pages marked for migration into
  * their targeted nodes.
+ *
+ * Migration rate-limiting and dynamic threshold logic implementations
+ * were moved from NUMA Balancing mode 2.
  */
 #include <linux/mm.h>
 #include <linux/migrate.h>
@@ -32,11 +35,17 @@ unsigned int pghot_freq_threshold_max = PGHOT_FREQ_MAX;
 unsigned int kmigrated_sleep_ms = KMIGRATED_SLEEP_MS_DEFAULT;
 unsigned int kmigrated_batch_nr = KMIGRATED_BATCH_NR_DEFAULT;
 
-unsigned int sysctl_pghot_src_enabled;
+unsigned int sysctl_pghot_src_enabled = PGHOT_HINTFAULTS_ENABLED;
 unsigned int sysctl_pghot_target_nid = PGHOT_DEFAULT_NODE;
 unsigned int sysctl_pghot_freq_window = PGHOT_FREQ_WINDOW_DEFAULT;
 unsigned int sysctl_pghot_freq_threshold = PGHOT_FREQ_THRESHOLD_DEFAULT;
 
+/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
+static unsigned int sysctl_pghot_promote_rate_limit = 65536;
+
+#define KMIGRATED_MIGRATION_ADJUST_STEPS	16
+#define KMIGRATED_PROMOTION_THRESHOLD_WINDOW	60000
+
 DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
 DEFINE_STATIC_KEY_FALSE(pghot_src_hintfaults);
 DEFINE_MUTEX(pghot_tunables_lock);
@@ -144,11 +153,35 @@ static const struct ctl_table pghot_sysctls[] = {
 		.extra1		= SYSCTL_ONE,
 		.extra2		= &pghot_freq_threshold_max,
 	},
+	{
+		.procname	= "pghot_promote_rate_limit_MBps",
+		.data		= &sysctl_pghot_promote_rate_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+};
+
+/*
+ * numa_balancing_promote_rate_limit_MBps has been replaced by
+ * pghot_promote_rate_limit_MBps but retained here for compatibility.
+ */
+static const struct ctl_table compat_pghot_sysctls[] = {
+	{
+		.procname	= "numa_balancing_promote_rate_limit_MBps",
+		.data		= &sysctl_pghot_promote_rate_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
 };
 
 static void __init pghot_sysctl_init(void)
 {
 	register_sysctl_init("vm", pghot_sysctls);
+	register_sysctl_init("kernel", compat_pghot_sysctls);
 }
 #else
 static inline void pghot_sysctl_init(void) { }
@@ -258,6 +291,110 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
 	return 0;
 }
 
+/*
+ * For memory tiering mode, if there are enough free pages (more than
+ * enough watermark defined here) in fast memory node, to take full
+ * advantage of fast memory capacity, all recently accessed slow
+ * memory pages will be migrated to fast memory node without
+ * considering hot threshold.
+ */
+static bool pgdat_free_space_enough(struct pglist_data *pgdat)
+{
+	int z;
+	unsigned long enough_wmark;
+
+	enough_wmark = max(1UL * 1024 * 1024 * 1024 >> PAGE_SHIFT,
+			   pgdat->node_present_pages >> 4);
+	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
+		struct zone *zone = pgdat->node_zones + z;
+
+		if (!populated_zone(zone))
+			continue;
+
+		if (zone_watermark_ok(zone, 0,
+				      promo_wmark_pages(zone) + enough_wmark,
+				      ZONE_MOVABLE, 0))
+			return true;
+	}
+	return false;
+}
+
+/*
+ * For memory tiering mode, too high promotion/demotion throughput may
+ * hurt application latency.  So we provide a mechanism to rate limit
+ * the number of pages that are tried to be promoted.
+ */
+static bool kmigrated_promotion_rate_limit(struct pglist_data *pgdat, unsigned long rate_limit,
+					   int nr, unsigned int now_ms)
+{
+	unsigned long nr_cand;
+	unsigned int start;
+
+	mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE, nr);
+	nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
+	start = pgdat->nbp_rl_start;
+	if (now_ms - start > MSEC_PER_SEC &&
+	    cmpxchg(&pgdat->nbp_rl_start, start, now_ms) == start)
+		pgdat->nbp_rl_nr_cand = nr_cand;
+	if (nr_cand - pgdat->nbp_rl_nr_cand >= rate_limit)
+		return true;
+	return false;
+}
+
+static void kmigrated_promotion_adjust_threshold(struct pglist_data *pgdat,
+						 unsigned long rate_limit, unsigned int ref_th,
+						 unsigned int now_ms)
+{
+	unsigned int start, th_period, unit_th, th;
+	unsigned long nr_cand, ref_cand, diff_cand;
+
+	th_period = KMIGRATED_PROMOTION_THRESHOLD_WINDOW;
+	start = pgdat->nbp_th_start;
+	if (now_ms - start > th_period &&
+	    cmpxchg(&pgdat->nbp_th_start, start, now_ms) == start) {
+		ref_cand = rate_limit *
+			KMIGRATED_PROMOTION_THRESHOLD_WINDOW / MSEC_PER_SEC;
+		nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
+		diff_cand = nr_cand - pgdat->nbp_th_nr_cand;
+		unit_th = ref_th * 2 / KMIGRATED_MIGRATION_ADJUST_STEPS;
+		th = pgdat->nbp_threshold ? : ref_th;
+		if (diff_cand > ref_cand * 11 / 10)
+			th = max(th - unit_th, unit_th);
+		else if (diff_cand < ref_cand * 9 / 10)
+			th = min(th + unit_th, ref_th * 2);
+		pgdat->nbp_th_nr_cand = nr_cand;
+		pgdat->nbp_threshold = th;
+	}
+}
+
+static bool kmigrated_should_migrate_memory(unsigned long nr_pages, int nid,
+					    unsigned long time)
+{
+	struct pglist_data *pgdat;
+	unsigned long rate_limit;
+	unsigned int th, def_th;
+	unsigned int now_ms = jiffies_to_msecs(jiffies); /* Based on full-width jiffies */
+	unsigned long now = jiffies;
+
+	pgdat = NODE_DATA(nid);
+	if (pgdat_free_space_enough(pgdat)) {
+		/* workload changed, reset hot threshold */
+		pgdat->nbp_threshold = 0;
+		mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr_pages);
+		return true;
+	}
+
+	def_th = sysctl_pghot_freq_window;
+	rate_limit = MB_TO_PAGES(sysctl_pghot_promote_rate_limit);
+	kmigrated_promotion_adjust_threshold(pgdat, rate_limit, def_th, now_ms);
+
+	th = pgdat->nbp_threshold ? : def_th;
+	if (pghot_access_latency(time, now) >= th)
+		return false;
+
+	return !kmigrated_promotion_rate_limit(pgdat, rate_limit, nr_pages, now_ms);
+}
+
 static int pghot_get_hotness(unsigned long pfn, int *nid, int *freq,
 			     unsigned long *time)
 {
@@ -340,6 +477,11 @@ static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
 			goto out_next;
 		}
 
+		if (!kmigrated_should_migrate_memory(nr, nid, time)) {
+			folio_put(folio);
+			goto out_next;
+		}
+
 		if (migrate_misplaced_folio_prepare(folio, NULL, nid)) {
 			folio_put(folio);
 			goto out_next;
@@ -692,6 +834,24 @@ static void pghot_debug_init(void)
 			    &pghot_kmigrated_batch_nr_fops);
 }
 
+/*
+ * Sync the hotness-source static keys with the initial value of
+ * sysctl_pghot_src_enabled. Hint faults are enabled by default so that
+ * selecting the NUMA Balancing memory tiering mode (numa_balancing=2)
+ * promotes hot pages without any additional opt-in, matching the
+ * pre-pghot behaviour.
+ *
+ * This runs unconditionally (not only under CONFIG_SYSCTL) because the
+ * static key, not the sysctl variable, gates pghot_record_access().
+ */
+static void __init pghot_src_enabled_init(void)
+{
+	if (sysctl_pghot_src_enabled & PGHOT_HINTFAULTS_ENABLED)
+		static_branch_enable(&pghot_src_hintfaults);
+	if (sysctl_pghot_src_enabled & PGHOT_HWHINTS_ENABLED)
+		static_branch_enable(&pghot_src_hwhints);
+}
+
 static int __init pghot_init(void)
 {
 	pg_data_t *pgdat;
@@ -711,6 +871,7 @@ static int __init pghot_init(void)
 	}
 	pghot_sysctl_init();
 	pghot_debug_init();
+	pghot_src_enabled_init();
 
 	kmigrated_started = true;
 	return 0;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 4064ead568cc..da668ff05032 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1268,7 +1268,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_SWAP
 	[I(NR_SWAPCACHE)]			= "nr_swapcached",
 #endif
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	[I(PGPROMOTE_SUCCESS)]			= "pgpromote_success",
 	[I(PGPROMOTE_CANDIDATE)]		= "pgpromote_candidate",
 	[I(PGPROMOTE_CANDIDATE_NRL)]		= "pgpromote_candidate_nrl",
-- 
2.34.1


