Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 764CCEC01B6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D082E6B0093; Mon, 23 Mar 2026 05:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDF426B0095; Mon, 23 Mar 2026 05:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7746B0096; Mon, 23 Mar 2026 05:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A29506B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:52:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 63976160AA5
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:52:21 +0000 (UTC)
X-FDA: 84576862482.10.998A0B8
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012010.outbound.protection.outlook.com [52.101.48.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 25C71180009
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:52:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Kj+5KOpu;
	spf=pass (imf06.hostedemail.com: domain of bharata@amd.com designates 52.101.48.10 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774259538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Bh1tNTEDyOoLpzM7ddxEjV+T34L4DxEJITFV/hqmJk=;
	b=17MhFK+xZfh3xEiHnznKeO1658YoMqxwco7ZAgcNSeiaJ+DS4KZBtzJSQn8EV9ALUtviJ2
	dGkbqMxjH0sDTTJmCUONOZD+KzvnZuV5UG+BCFrleCi8Wpej/hUwWpJJJRjakwmc2qJw20
	x3FNo9nsZjedbTwo2Yowk35KmLWkQc0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=Kj+5KOpu;
	spf=pass (imf06.hostedemail.com: domain of bharata@amd.com designates 52.101.48.10 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774259538; a=rsa-sha256;
	cv=pass;
	b=Ed4gD0T+Gv9kYzWVJ09XueCm2e9iUXfL40O35RKn2HJeBa+grdTIQz5dQ04KZr1haoNHBA
	cQGfCCok6lEgrJF9NgEA5KSCksVxbFCw74ny+CEMll/F72r5oNA2tW3DA+JzyFSL3c15i8
	KbWNkHQrOeSI26kHF9O+5UmzjboMXZQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KM/SMmNVm07F1XIALQDFzRhL1ICLaFUu6qOx9ZvXfCYMRIlfYjAEoa1EMB8j1xLsWKy6rJXcRZOntPDT7l/LsOU4FP1YV3/l2qvJeXYnjBX7X3vWZ2Gt/oD2dCu5CPapm/bLJwrFKVRjLajT3HJgTLU6jBMdNmmR1lT22eObzKjxAS7oM44wx/IC7kJhysJbrWJxSuyAoGohP748v+ksPIDfe9Im32FD7O7sBIFKyVk5QnSYcRKsMBlUyMFMtMuFziYvJqe/QrhkhX2vzdrjC0DI36n+TOe9TQ1w18IporgXDOIRmY9SLlYeeIWGspEnnJJBVof3WeUzy+VymZtQCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Bh1tNTEDyOoLpzM7ddxEjV+T34L4DxEJITFV/hqmJk=;
 b=mOAwpCwJdJ2tWpYjHEWw1ye3TXX95x0hcmLel4Rw/LToLhnfFuWbDJOffH7sMfls7FZ9dIyKqU47rfyRxy+igemv+rxhXR2jUUW4t7pf0rcSBQH9lKf/7tI+DL+P7G8ljDn0pokJVs6pWf+zSyRxxhZqqk6VCUXSSKbM1U5O6/JbFsl/bbkeVZuw5gowPJaD0KjcRm3yqnrEION7Oz9RZRCE6uDDCCBTNOX6m9Un9qJl8yYlCuDVQEDXgBye6t8NiMPAYZFGkPIfp/TRZQ36WRudK16d67q1fFxSfoPutINUmJqfmWBSzbk3X6SH0gDq0goBpUIS2MbyW4hgq0X8tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Bh1tNTEDyOoLpzM7ddxEjV+T34L4DxEJITFV/hqmJk=;
 b=Kj+5KOpuhTBIW32xdvRZUvNEdV43HrjtHXy3SDNkSxWWFrNTAOOOJmrRehjYdj/GsSyRiTnBEfusI836miJWbenQkstgNvO9gPpVs/+TPt8G0CMn44rylLFJzsNHCYBWfxnaDARUrPerAkz1tUF9cLYQOl5uJjO0hP49Q/EtOWQ=
Received: from CH0PR13CA0042.namprd13.prod.outlook.com (2603:10b6:610:b2::17)
 by IA0PR12MB8088.namprd12.prod.outlook.com (2603:10b6:208:409::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.20; Mon, 23 Mar
 2026 09:52:12 +0000
Received: from CH2PEPF0000009C.namprd02.prod.outlook.com
 (2603:10b6:610:b2:cafe::46) by CH0PR13CA0042.outlook.office365.com
 (2603:10b6:610:b2::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9723.31 via Frontend Transport; Mon,
 23 Mar 2026 09:52:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000009C.mail.protection.outlook.com (10.167.244.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.17 via Frontend Transport; Mon, 23 Mar 2026 09:52:12 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 23 Mar
 2026 04:52:04 -0500
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
	<shivankg@amd.com>, <bharata@amd.com>
Subject: [RFC PATCH v6 5/5] mm: sched: move NUMA balancing tiering promotion to pghot
Date: Mon, 23 Mar 2026 15:21:04 +0530
Message-ID: <20260323095104.238982-6-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260323095104.238982-1-bharata@amd.com>
References: <20260323095104.238982-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF0000009C:EE_|IA0PR12MB8088:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b23b909-de75-44e3-b20d-08de88c1db33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|7416014|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8bkE/b3C4ndTtSngGjzqN/f14LIfHaupMl1GUdoMdQbpTzY0BJsMTfmn3LsmiGSIZRQaFg8v7IKVVuve3+YQfMW5IzZdCEK59bnbaYlh0K3uit5Ydnbvd6QeZzftclJeBgAeiz8oLlJQfhh/jFq1YmoIDfYvNwaT8BoMO3IJhEqZKK43baVTplwu8KQrp4LBEc2mS1UnKmOFrWbF4sjRy46oaTO1wq2v4iqmqDF4m+p+mwDFRJy6/oEk6boRi+IzA35dXcLGLb6f9MDpPyX1I+Zqe+KnBWQb/S1vFNagfnjl1mEH67qc0rCAeWoRwonQh6mxy37Kca73G0FKWlKK5YrIwfnmqH/pr2l5K7qz5r7SguRhp/O1KQsZ0YhIWlRlGIwlpO7cGAzrgoImPScSkL6zDWkECeoQBHOxDsw76uxjWJhfC+F9JIIIcoQSd5OeVTt36HGqkfsyvqvQPTcxjeDVrhcJbATXozxPCmntd4qW3jd/LZA4Rs/YuqGc+gpLQT9U8Zxfr9VPR30Z1NGJA7QI/sTZbzysCVud3+q8HxZUPtecLoFQtzyZFWSKrNNxtIqV9clFrjGhivca9i1m7ESvRDE8n1CVdhstDCA4LTIxLkHS9mTln6QWW5TR/UWD/vsgbKhU6+LCUHwCXksWqRcO5TTPQk6qgw9NTW4PIObJLi/IC5z2lllarEERDu5tef/J3rukzrYPzemolMuJztAFLB+b1JNeBRPcNb/2A1wiBdDrrnkyVDCrEbIIWNyfXgTdYovHE2QktnrZufbFiA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7it+ieiw2kTEyHC6AHA/mkXjqTrdeZkpp23+JdayDKU0Q+cBISc9/077ZVLcoKUXQkR1asC1FzC89PSHdL2MEidLAVJpSz/VYdMLhkl/126575s8WPDTGlpKMbhzFWpYbmWgnVKsenCsLkN0RF5xOSMpg8PVCfMVgYZkd3JqXLRVjW69/aZ9wgySrlwaG7im+BsGTzrksVOUuuyyJ0Zhh3y4qhstPXdPO8J0aCb0Q3Hs5oIxDDvbUrcCdWwzWPtmK+kj7b3lDf0AE/VE1qbiVz4RPO0mLN9h1txmUmv7kHmO+fimbFbTtkovRqeAYwuVyHcP0nBUkNbJ2PRHV/VHBDFWTOcxsmGWsvf1xgYnXYUKcSXMtMlqdK0i0+0cHsnHNoGbdYlXlQeq1krWAyDGup5viqM2G465hjv78TNJwo15M6+Tvn2rSTUsH46g7yly
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 09:52:12.0309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b23b909-de75-44e3-b20d-08de88c1db33
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000009C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8088
X-Rspam-User: 
X-Rspamd-Queue-Id: 25C71180009
X-Rspamd-Server: rspam08
X-Stat-Signature: w4mnzm6c1u6f6y4gbg96fstob8jmj346
X-HE-Tag: 1774259537-904354
X-HE-Meta: U2FsdGVkX18GW35dtfRCtdmjdaiyYA1UH+biTYa1aufQ4JRovOC4KolhkkRPhi3k8Ok9TRQhLQX2N5ur1/FFIRN4xYaEaDJTQiTARnrn+HFqZeXmqX6cnfDkvhRdV9sV4FSS0AOFEuWES5yNXNa3qwnq1EVT5fk2+fCTEEFoNH/bHIiRPTR59WX9uvGrn/s9Mw4etFWbS9GrmCw/9d5LSHTVdwj07AwLrty32zgDDDSUcf/P4OjKYcFNlYtran/A+31WIbn1x2mUJjn/2cQ9X5OnzRxXHszA/Ln7bpjLSEVqD9NrtZDJONmX5rrXkjBnl3vUhgz0zssecVVA2vMVG6bUhDXMTvKPUTMjgYZ03jWmXpPRvBI36i1d10nJJJJd2oQ39eUvUjANK1vlGp9koS03hmZBHYDTVWUJkzpPWZq8JqFkbjzB8s4LD8pADSjFq7wFCmTp2q0VPpIDDdkY08qDdv3EQbgzNMFEFnWsAsM3gvyCVq/EDroMx3P9/9GEof/SC6Dr+Jly4PBbTK31kBfdYVAG6x1YtsfzWoFbo5XJdhmXEah6ATuhWGpjf8G5BHJITQQO3/JuYAeDiXeY82PqC/l1Z/h/mIQEEMVFGlDXtxggCdnZUnim4hFJUZtnoG14hiecC4kUTscmNs6qXQJ/0EGeEiJnifFY7B/pLAB1tMJy1asMN02n9wNFnIt0+7jdgOYoPUhGMAddVi/9QQm3R/fMkP8MhJL27/Gf35YS+8K+lm0fNZG2w/gJ5vnyyH0056gGTd815TZE3bpZp50nn5dPTqiUIXPmIQJ1AHAthZ+XTHHxS/n0uyfYkiOmyMQgJpu/lMFESOb6Cveb0+hX3UZdI9nYmhFGHzVsht7p7mynzgyacr3+PkN5afDAtOEUTzNjl1vGMq961Oa3klkjg+XEAlNrb0Zq38JnUe14HamfI0fl8MaRqY2+CjEaCTFZpPUL+D0A5KzeFO8
 1G1uDVwj
 2SMnNKJid65VwxuzIW2fuYzZa3PckBmAVJYTo6uPHYUwFqOFmHIC9JXz39AXfeylMt/fLD2E5U5oBoy2+IJjq6J+2XcAYfMzr8hpNnBqtANVZjHwplk05aeTyH/DD9tBXMt7YaRwxjq3bM+5v6/Ky9s9hoBXEodrGGSY1hsH5oJ7uNyDimgN6RVdtSEcRcPu8+QGP+YmbcOhkxhjpHnQcTepIJXFypGE1KnU9GGxdHJNtGu4daki3YalE60mhOSIZ+S3Ql/7hPnVqS0WoSWcUFTuWqPHOZGhIM/89vms1f9fRhMoH9mOCkLCuquWpnqIGohCIp/SxOoH93k3eQUS4/2btGWkJPrgAF4Gjsbja7pxgl86/mClULpQUqWTmWfI1GXXPd9Q8mrEbl8OkLhTx3rmf3c8tHZjJShI4JlgEtFKY50Wu8spxrOjIr1MzmnKaTxzv1fBx4GoZpvCZVnJPBEjOzLmOk1T+35le7XAl8fXe6euKAxozVL0OHtKY6vCDgXgV+I31qqvVWJw=
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

To achieve this, pghot_record_access(PGHOT_HINT_FAULT) API
is used to feed the hot page info to pghot. In addition, the
migration rate limiting and dynamic threshold logic are moved to
kmigrated so that the same can be used for hot pages reported by
other sources too. Hence it becomes necessary to introduce a
new config option CONFIG_NUMA_BALANCING_TIERING to control
the hint faults souce for hot page promotion. This option
controls the NUMA_BALANCING_MEMORY_TIERING mode of
kernel.numa_balancing

This movement of hot page promotion to pghot results in the following
changes to the behaviour of hint faults based hot page promotion:

1. Promotion is no longer done in the fault path but instead is
   deferred to kmigrated and happens in batches.
2. NUMA_BALANCING_MEMORY_TIERING mode used to promote on first
   access. Pghot by default, promotes on second access though this
   can be changed by setting /sys/kernel/debug/pghot/freq_threshold.
   hot_threshold_ms debugfs tunable now gets replaced by pghot's
   freq_threshold.
3. In NUMA_BALANCING_MEMORY_TIERING mode, hint fault latency is the
   difference between the PTE update time (during scanning) and the
   access time (hint fault). However with pghot, a single latency
   threshold is used for two purposes:
   a) If the time difference between successive accesses are within
      the threshold, the page is marked as hot.
   b) Later when kmigrated picks up the page for migration, it will
      migrate only if the difference between the current time and
      the time when the page was marked hot is with the threshold.
4. Batch migration of misplaced folios is done from non-process
   context where VMA info is not readily available. Without VMA
   and the exec check on that, it will not be possible to filter
   out exec pages during migration prep stage. Hence shared
   executable pages also will be subjected to misplaced migration.
5. The max scan period which is used in dynamic threshold logic
   was a debugfs tunable. However this has been converted to a
   scalar metric in pghot.

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
 include/linux/mm.h     |  35 ++------
 include/linux/mmzone.h |   4 +-
 init/Kconfig           |  13 +++
 kernel/sched/core.c    |   7 ++
 kernel/sched/debug.c   |   1 -
 kernel/sched/fair.c    | 177 ++---------------------------------------
 kernel/sched/sched.h   |   1 -
 mm/huge_memory.c       |  27 ++++++-
 mm/memcontrol.c        |   6 +-
 mm/memory-tiers.c      |  15 ++--
 mm/memory.c            |  36 +++++++--
 mm/mempolicy.c         |   3 -
 mm/migrate.c           |  16 +++-
 mm/pghot.c             | 134 +++++++++++++++++++++++++++++++
 mm/vmstat.c            |   2 +-
 15 files changed, 248 insertions(+), 229 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index abb4963c1f06..81249a06dfeb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1998,17 +1998,6 @@ static inline int folio_nid(const struct folio *folio)
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
@@ -2074,15 +2063,6 @@ static inline void page_cpupid_reset_last(struct page *page)
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
@@ -2093,18 +2073,12 @@ static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
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
@@ -2147,11 +2121,16 @@ static inline bool cpupid_match_pid(struct task_struct *task, int cpupid)
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
index 61fd259d9897..bfaaa757b19c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -232,7 +232,7 @@ enum node_stat_item {
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	PGPROMOTE_SUCCESS,	/* promote successfully */
 	/**
 	 * Candidate pages for promotion based on hint fault latency.  This
@@ -1475,7 +1475,7 @@ typedef struct pglist_data {
 	struct deferred_split deferred_split_queue;
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	/* start time in ms of current promote rate limit period */
 	unsigned int nbp_rl_start;
 	/* number of promote candidate pages at start time of current rate limit period */
diff --git a/init/Kconfig b/init/Kconfig
index 444ce811ea67..56ef148487fa 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1013,6 +1013,19 @@ config NUMA_BALANCING_DEFAULT_ENABLED
 	  If set, automatic NUMA balancing will be enabled if running on a NUMA
 	  machine.
 
+config NUMA_BALANCING_TIERING
+	bool "NUMA balancing memory tiering promotion"
+	depends on NUMA_BALANCING && PGHOT
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
index 496dff740dca..f8ca5dff9cad 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4463,6 +4463,7 @@ void set_numabalancing_state(bool enabled)
 }
 
 #ifdef CONFIG_PROC_SYSCTL
+#ifdef CONFIG_NUMA_BALANCING_TIERING
 static void reset_memory_tiering(void)
 {
 	struct pglist_data *pgdat;
@@ -4473,6 +4474,7 @@ static void reset_memory_tiering(void)
 		pgdat->nbp_th_start = jiffies_to_msecs(jiffies);
 	}
 }
+#endif
 
 static int sysctl_numa_balancing(const struct ctl_table *table, int write,
 			  void *buffer, size_t *lenp, loff_t *ppos)
@@ -4490,9 +4492,14 @@ static int sysctl_numa_balancing(const struct ctl_table *table, int write,
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
index b24f40f05019..c6a3325ebbd2 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -622,7 +622,6 @@ static __init int sched_init_debug(void)
 	debugfs_create_u32("scan_period_min_ms", 0644, numa, &sysctl_numa_balancing_scan_period_min);
 	debugfs_create_u32("scan_period_max_ms", 0644, numa, &sysctl_numa_balancing_scan_period_max);
 	debugfs_create_u32("scan_size_mb", 0644, numa, &sysctl_numa_balancing_scan_size);
-	debugfs_create_u32("hot_threshold_ms", 0644, numa, &sysctl_numa_balancing_hot_threshold);
 #endif /* CONFIG_NUMA_BALANCING */
 
 	debugfs_create_file("debug", 0444, debugfs_sched, NULL, &sched_debug_fops);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index bf948db905ed..131fc4bb1fa7 100644
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
@@ -1519,9 +1504,6 @@ unsigned int sysctl_numa_balancing_scan_size = 256;
 /* Scan @scan_size MB every @scan_period after an initial @scan_delay in ms */
 unsigned int sysctl_numa_balancing_scan_delay = 1000;
 
-/* The page with hint page fault latency < threshold in ms is considered hot */
-unsigned int sysctl_numa_balancing_hot_threshold = MSEC_PER_SEC;
-
 struct numa_group {
 	refcount_t refcount;
 
@@ -1864,120 +1846,6 @@ static inline unsigned long group_weight(struct task_struct *p, int nid,
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
@@ -1993,41 +1861,15 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 
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
@@ -3237,15 +3079,6 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	if (!p->mm)
 		return;
 
-	/*
-	 * NUMA faults statistics are unnecessary for the slow memory
-	 * node for memory tiering mode.
-	 */
-	if (!node_is_toptier(mem_node) &&
-	    (sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING ||
-	     !cpupid_valid(last_cpupid)))
-		return;
-
 	/* Allocate buffer to track faults on a per-node basis */
 	if (unlikely(!p->numa_faults)) {
 		int size = sizeof(*p->numa_faults) *
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 43bbf0693cca..a47f7e3d51a6 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3021,7 +3021,6 @@ extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
 extern unsigned int sysctl_numa_balancing_scan_size;
-extern unsigned int sysctl_numa_balancing_hot_threshold;
 
 #ifdef CONFIG_SCHED_HRTICK
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b298cba853ab..fe957ff91df9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -40,6 +40,7 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/pghot.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2190,7 +2191,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	int nid = NUMA_NO_NODE;
 	int target_nid, last_cpupid;
 	pmd_t pmd, old_pmd;
-	bool writable = false;
+	bool writable = false, needs_promotion = false;
 	int flags = 0;
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -2217,11 +2218,26 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
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
+		 * Isolation and migration are handled by pghot.
+		 *
+		 * TODO: mode2 check
+		 */
+		writable = false;
+		nid = target_nid;
+		goto out_map;
+	}
+
+	/* Balancing b/n toptier nodes, mode=NUMA_BALANCING_NORMAL */
 	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
 		flags |= TNF_MIGRATE_FAIL;
 		goto out_map;
@@ -2253,8 +2269,13 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);
 	spin_unlock(vmf->ptl);
 
-	if (nid != NUMA_NO_NODE)
-		task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
+	if (nid != NUMA_NO_NODE) {
+		if (needs_promotion)
+			pghot_record_access(folio_pfn(folio), nid,
+					    PGHOT_HINTFAULTS, jiffies);
+		else
+			task_numa_fault(last_cpupid, nid, HPAGE_PMD_NR, flags);
+	}
 	return 0;
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 772bac21d155..fcd92f2ffd0c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -323,7 +323,7 @@ static const unsigned int memcg_node_stat_items[] = {
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	PGPROMOTE_SUCCESS,
 #endif
 	PGDEMOTE_KSWAPD,
@@ -1400,7 +1400,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "pgdemote_direct",		PGDEMOTE_DIRECT		},
 	{ "pgdemote_khugepaged",	PGDEMOTE_KHUGEPAGED	},
 	{ "pgdemote_proactive",		PGDEMOTE_PROACTIVE	},
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
 #endif
 };
@@ -1443,7 +1443,7 @@ static int memcg_page_state_output_unit(int item)
 	case PGDEMOTE_DIRECT:
 	case PGDEMOTE_KHUGEPAGED:
 	case PGDEMOTE_PROACTIVE:
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	case PGPROMOTE_SUCCESS:
 #endif
 		return 1;
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 986f809376eb..7303dc10035c 100644
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
index 2f815a34d924..289fa6c07a42 100644
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
@@ -5968,10 +5969,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
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
@@ -6052,6 +6052,7 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	int nid = NUMA_NO_NODE;
 	bool writable = false, ignore_writable = false;
 	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
+	bool needs_promotion = false;
 	int last_cpupid;
 	int target_nid;
 	pte_t pte, old_pte;
@@ -6086,16 +6087,31 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 		goto out_map;
 
 	nid = folio_nid(folio);
+	needs_promotion = folio_is_promo_candidate(folio);
 	nr_pages = folio_nr_pages(folio);
 
 	target_nid = numa_migrate_check(folio, vmf, vmf->address, &flags,
 					writable, &last_cpupid);
 	if (target_nid == NUMA_NO_NODE)
 		goto out_map;
-	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
+
+	if (needs_promotion) {
+		/*
+		 * Hot page promotion, mode=NUMA_BALANCING_MEMORY_TIERING.
+		 * Isolation and migration are handled by pghot.
+		 */
+		writable = false;
+		ignore_writable = true;
+		nid = target_nid;
+		goto out_map;
+	}
+
+	/* Balancing b/n toptier nodes, mode=NUMA_BALANCING_NORMAL */
+	if (migrate_misplaced_folio_prepare(folio, vmf->vma, target_nid)) {
 		flags |= TNF_MIGRATE_FAIL;
 		goto out_map;
 	}
+
 	/* The folio is isolated and isolation code holds a folio reference. */
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 	writable = false;
@@ -6110,7 +6126,7 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	}
 
 	flags |= TNF_MIGRATE_FAIL;
-	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
+	vmf->pte = pte_offset_map_lock(vmf->vma->vm_mm, vmf->pmd,
 				       vmf->address, &vmf->ptl);
 	if (unlikely(!vmf->pte))
 		return 0;
@@ -6118,6 +6134,7 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 		pte_unmap_unlock(vmf->pte, vmf->ptl);
 		return 0;
 	}
+
 out_map:
 	/*
 	 * Make it present again, depending on how arch implements
@@ -6131,8 +6148,13 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 					    writable);
 	pte_unmap_unlock(vmf->pte, vmf->ptl);
 
-	if (nid != NUMA_NO_NODE)
-		task_numa_fault(last_cpupid, nid, nr_pages, flags);
+	if (nid != NUMA_NO_NODE) {
+		if (needs_promotion)
+			pghot_record_access(folio_pfn(folio), nid,
+					    PGHOT_HINTFAULTS, jiffies);
+		else
+			task_numa_fault(last_cpupid, nid, nr_pages, flags);
+	}
 	return 0;
 }
 
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 0e5175f1c767..6eed217a5917 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -866,9 +866,6 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	    node_is_toptier(nid))
 		return false;
 
-	if (folio_use_access_time(folio))
-		folio_xchg_access_time(folio, jiffies_to_msecs(jiffies));
-
 	return true;
 }
 
diff --git a/mm/migrate.c b/mm/migrate.c
index a5f48984ed3e..db6832b4b95b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2690,8 +2690,18 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
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
+		 * up waking up kswapd.
+		 */
+		if (node_is_toptier(folio_nid(folio)))
 			return -EAGAIN;
+
 		for (z = pgdat->nr_zones - 1; z >= 0; z--) {
 			if (managed_zone(pgdat->node_zones + z))
 				break;
@@ -2741,6 +2751,8 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 #ifdef CONFIG_NUMA_BALANCING
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
+#endif
+#ifdef CONFIG_NUMA_BALANCING_TIERING
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node)) {
@@ -2796,6 +2808,8 @@ int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
 #ifdef CONFIG_NUMA_BALANCING
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
+#endif
+#ifdef CONFIG_PGHOT
 		mod_node_page_state(NODE_DATA(node), PGPROMOTE_SUCCESS, nr_succeeded);
 #endif
 	}
diff --git a/mm/pghot.c b/mm/pghot.c
index 7d7ef0800ae2..3c0ba254ad4c 100644
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
@@ -32,6 +35,12 @@ unsigned int kmigrated_batch_nr = KMIGRATED_DEFAULT_BATCH_NR;
 
 unsigned int sysctl_pghot_freq_window = PGHOT_DEFAULT_FREQ_WINDOW;
 
+/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
+static unsigned int sysctl_pghot_promote_rate_limit = 65536;
+
+#define KMIGRATED_MIGRATION_ADJUST_STEPS	16
+#define KMIGRATED_PROMOTION_THRESHOLD_WINDOW	60000
+
 DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
 DEFINE_STATIC_KEY_FALSE(pghot_src_hintfaults);
 
@@ -45,6 +54,22 @@ static const struct ctl_table pghot_sysctls[] = {
 		.proc_handler   = proc_dointvec_minmax,
 		.extra1         = SYSCTL_ZERO,
 	},
+	{
+		.procname	= "pghot_promote_rate_limit_MBps",
+		.data		= &sysctl_pghot_promote_rate_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+	{
+		.procname	= "numa_balancing_promote_rate_limit_MBps",
+		.data		= &sysctl_pghot_promote_rate_limit,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
 };
 #endif
 
@@ -141,6 +166,110 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
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
+					   int nr, unsigned long now_ms)
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
+						 unsigned long now_ms)
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
+	unsigned long now_ms = jiffies_to_msecs(jiffies); /* Based on full-width jiffies */
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
@@ -218,6 +347,11 @@ static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
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
diff --git a/mm/vmstat.c b/mm/vmstat.c
index d3fbe2a5d0e6..f28f786f8931 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1267,7 +1267,7 @@ const char * const vmstat_text[] = {
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


