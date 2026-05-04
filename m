Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F48CFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7A606B0093; Mon,  4 May 2026 02:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B29E56B0095; Mon,  4 May 2026 02:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3EE6B0096; Mon,  4 May 2026 02:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83D306B0093
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:10:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 236D41A0A49
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:37 +0000 (UTC)
X-FDA: 84728713314.01.EA9D7E3
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011020.outbound.protection.outlook.com [52.101.62.20])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0C97C160011
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ChNJA2YZ;
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 52.101.62.20 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777875034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tNMZd2VCrP6CmTnqsRr858/zhsfVrxWE9QK5Aizcj8=;
	b=CEoVsVFgyAJVHLBHjQgIfk0s939HTdhbtmmSAr4/U+zMMs6cXT1Z0ZuNo5iHEmJED61zqa
	y5ZQV/sSNnWYCbqusFNQsEgtt+xETEVMEiwqDDFh8Q6JwbIlYpSeyBb3V8ov9593ags0PI
	8dMDChxU9H9oW5o+9jfxroPm2jzpbC4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ChNJA2YZ;
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 52.101.62.20 as permitted sender) smtp.mailfrom=bharata@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777875034; a=rsa-sha256;
	cv=pass;
	b=mr7hgbBYPfe7tU3cj48PJXHudvrVg+RCC6UYm4uHSfYaU9YxWLw/gilm83d9xl+CyoKyNK
	mmwFlYZ2lGY1E4oROazJJySbTQunPByjQfc75o7iZ8f75Ha3B8n9+rg75Ws4mBE0veeExo
	bMDaRK5m/CdO5o7HDX/X6SOMNQnubus=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kZz3r4bpqoNH9udQvUsrqcsJ4edg/3S0eB7su9qTPWK2Cb/Vs+Tzhfyi0ouO36VFbKjmn11vYiigDdTnHg7+Cp1YiuG/LNuEPc0F2Sl81EA1uaS5ROHYWs99/pI1BkQ8tBE8nTbEVjLZY0bpk2xEtyUfCwmmMnkKV3VVhIJHv/kttoSULfE1Xvd9OT9GnjpTGymlaFiltfb3ASwPCh3lZjeIHHcm1Bp5CpxhbGflw2ETPUL+QcLRIQqFLVbjYCP94hO+ZSgayj5+jEueWyHSVSR/sY4nFljKDwVPzHGoEb50uLCgMcXPSGrNW+SWHKVI0dzsht63sBrHavZUMRTCAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tNMZd2VCrP6CmTnqsRr858/zhsfVrxWE9QK5Aizcj8=;
 b=VWYua5UJraFAKW7MPs8jU8OVJx0EThK7LpwOjimBxceOv64WhHIWSc5M/5dJtorxVQ8nCJUYFYn8zrEqz679tCV564IXNXrMRjLNbIBJ8n7TcgngGnTbSVxhx3rRKhS7WkX6pI8oNt/hYoecPEXRW2KU8m6M+MPL1nweolA+NXhkZcUYsGYF7eJj3zwTyAm2S72lYqKnvjSXK/N2nLceLn+Zi7lOmbfxMSJVqBk2+rruGHN4CkC9oizcJpESFHPUQXA0ZGLudH+uI3p/dc8i721Yibkl4B7yCCTaG7hG8poNRF4i/4rZOOI/t1Azf9+dmwZUHSJ8TStc161zDcjL9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5tNMZd2VCrP6CmTnqsRr858/zhsfVrxWE9QK5Aizcj8=;
 b=ChNJA2YZmzssF3Y1SKu0SuLCXSKGbHjhQvPFSM39AvMRSgtomcAnu2++aDJD7J+HdPc3esL2Hi3FxfPkiXvEKM2+1OsHxmucuSz8R6pSXJm/vU5FGRKXyG0pIGqKF1iNAPnoiISPePQxbDSNbK/mfoH60el1uUai+5QLjFHtBBs=
Received: from CH5P222CA0016.NAMP222.PROD.OUTLOOK.COM (2603:10b6:610:1ee::23)
 by IA1PR12MB7662.namprd12.prod.outlook.com (2603:10b6:208:425::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 06:10:27 +0000
Received: from CH1PEPF0000AD7B.namprd04.prod.outlook.com
 (2603:10b6:610:1ee:cafe::3a) by CH5P222CA0016.outlook.office365.com
 (2603:10b6:610:1ee::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.25 via Frontend Transport; Mon,
 4 May 2026 06:10:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD7B.mail.protection.outlook.com (10.167.244.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Mon, 4 May 2026 06:10:27 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:10:16 -0500
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
Subject: [PATCH v7 3/7] mm: Hot page tracking and promotion - pghot
Date: Mon, 4 May 2026 11:39:20 +0530
Message-ID: <20260504060924.344313-4-bharata@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7B:EE_|IA1PR12MB7662:EE_
X-MS-Office365-Filtering-Correlation-Id: c18fad01-4db5-4cbf-069c-08dea9a3d6a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|1800799024|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	UKn5NvTx2nJAwNzTVO17PunZtkc1SYd0mIsGSuO+PZJaLxHuB/CiQQJ5r/Dr2xNThbIsOJh9O2WAFivsN/aXcpIO+tFQIC4Xy/Z+PjxXIYpTTOp7T5mp62Ojvfw/34oMzuydqtljgN8FRp5MqbEX6qYbn5pczgJm+UiKPF1O8C5n7Lrct2hzpviQcUeLJnaXdEpUTMXakR5mSYbHdn/h3JsZNkzv5YZu5TXqSAxhxAxeNV1LFxJ1j3QpVO1PffK/kVdhtjWzst6WlZIwMBXH9ZOTYeYKMkFM317CVluV+6PAdd94g18f2p0YgTzYyrK+lGIDoJfT2qnBRzD2CLlkIx5zl8lH3LNZgDt7kDOFy3of/mncI4l79Ruh+W/H4Qn+skp6F8tbgkRMVeB5tVDVtAAjzy2aBqWvUxV4JxjyTj419y/EcmdUA/W1XP7n5OA0tYtG7sgVINpHrQU1Y8cca/irnTzcEirpZO/KbiaCJtC9AnL6+PHAuabf4e4uIrtC3AMwG+9WiRMJVhAl9t8MkzQu/kABjgITQL0MWPzOUGMPQL/ciqGaH0D7G3lwIq8589w6DYUlf8DP/Z1+JpXiwUNBb4Dv8/C3jKa+vpVdYR1tU7lknoZgX58OcxRob+q3SsajllpoEfmKMKc176rU9dOEHn/m6KL75g37gXQHJmVN38tGtdK/q6BaR2nMFf7reUrAIcM5TIZY4um3NyOaWDSnBcSt31BGS7TyM5d2dy4=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(1800799024)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	WKmBpiRz5gnD3UuC1xKtz5BtRWqyltDXEzzlnym/M9Mf6h2htKqLTBSTNaksVqHuJuDNC2Qyjn0cQThGkTsDDK7+Os3N44ZuuhA2hh0sFAQd7mxbRiA7RNa6nOMnU1LMeECZKyaNR9qSnOhcHlRGtEiy1KrTDeJFCCu7+UHZJXwRkMZ9GBx6DknCoL8orMXe6hjwX2pWsfyBCTHSUO69sM8Yx7TtCzRHDu96kRw0M89cm2a0+Ih6TC2lxXkDi1OMJkHKgkEB03obARfvjRlMdvo3mKX7exfAQv2s38ixQnopVwGCxsBGlAw7mwEaQ80K1NNHKOILZhkPzjTyYq/P7gFiJtq5uD7ZPQS4FOFpIS8AsQAman7uN7xYiP1Cs5QIFwDlEivkMVHax/Iklnlgpz9pqEGHjFJQlT2XYYZ81BfhdFWWR2FaGZ9elXiP4LQn
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:10:27.8497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c18fad01-4db5-4cbf-069c-08dea9a3d6a1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7662
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C97C160011
X-Rspamd-Server: rspam06
X-Stat-Signature: gahs9wxr4qfxkoocett4gtumysqjcnqc
X-HE-Tag: 1777875033-448061
X-HE-Meta: U2FsdGVkX1/HiIc0LuNAFVNwgVcAIbK5Wc7U1/+RgDHMInd7ZUUVMIvZljynvhzNxetSLKjaMZn91q8173EvZRqc72uvnsk9LGpOl0cgTXuas0cvWsdS6pN+zL4HTdud7LbN0Ia2NyFTE+T6H74SP2yJMv9trR1Wf5PMKwZhiWC3m4B8jRNZ2TP0yr9UR3Cw5kCHQZUghp1vpkEzRiB8yQEt0L2oxCWr4XU9A7ioVkFmuywSZ0ZAnxxtHtz5B4eh7l662QKwyXX+dm217rE2InhXdgkfIeFhUL8mH4dI9va8THgTGoVIRxlzaTOtlrEdOKN/UQGq5Rg852mmqk+TK9/ifY1pPRLC5cOoVgmtmHEkyiE2SLraJtmUWhc+FLVpdYIFdW010ZN3tQQA2becXVpwb2KKskDXFtAkIa3UE7rixTQ7peXRx49f4f9X8Od6MAdFO3KejZ8RPQ4p9ZzhzC55TI/GmG8NF1nsTQ+5Tm6s8zLn/NO0euFvCQbP477sZdobczFPYlJeeR9FOXBitHLD6C+DThWQzvqfaPQyJiDcLJSYyjrZaJLjS6GgDapS+ICBZRdSPrvnBTdq/NO8/kQD5Hux6+nOi3ATOSA7uNTpy7IlI/sQN0dKfhSBPugaNI/rfu7ukLt5/1/9ZB7BkT+j1Sa+FKHPApZcdqd5qk9yRdQH6d/w11G+jPsbpuca2HsioE3EEpbs9fZGDWGJkiItTT+azYjh2EpU4EXmPPF04rDlGRYqf1zrAQjtv1+mUB2rHwd5mKuENlbgXbLWOy2c8XW1O6FUC68z7z8k2qXPS1Iqr8BxNca+h2wXkPZcG6H+/ROzrf0/aL1b7SRm44fK3Fs40ODfSUbmg3aM2Da08hAsfo2O0oaFEauJfu4IQD0TqAEF6XQ5prF3ivjISskD347hEsp3uvEQ+O8FHH8Gp9iYIcZaHdK3UoGwggB2SMLCqn7vhVLT9ZvStdj
 6CGRF0XR
 kOv2VRwrSp6fkqnwPIH7mAPsU0i8IC8X5pN4Jf7TRONeatZ2Mfo4gOd6ZTDOkAPtE64Qm6+gg4GDnZ5cXgie2Ga/ECLjBdwyZsvzzppHZEc4Z+C2GiKd7gOW0OuNmEQaFR+QMM0TURtEcEQ39N/OpeXwz5dl58IqQK73x9qxO1WjPRT0E0Ydp1pjPBINfoawcs0XlBLzkwjPV6YG8DXtUl01p16qO7EOprYJrw+qdcr4fiD7Ulf8beHR3hOp7q2p06f+nFjG88Y5DZ2NR+yME350RDzR7FDT01+XXUopGQm2b0cO2HgKHBK8bnopDQCfhyvLqgncrzZy/FvkKVph/3J7oUEjOMQIt6F7dkaFslD/3evWmayh4OldSfwqtEz/SzGIbgxjtKKgXjSRWDtSw5iumYzZYC/bHbPnnT2aSMJvnGWMyRMR6WsMTqNZuTW1h/ZnW3HH5KXb8LvneJbsX60CKaZWnvq6mzrRYsaGWmcwiL4aI08PEo5+jvtQzL8F7f7XUQsEf0Ke1rJezHvD1+l1vPNHD0t+notbuwusJ90eNGbTuWEtiX2dpgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pghot is a subsystem that collects memory access information from
multiple sources, classifies hot pages resident in lower-tier memory,
and promotes them to faster tiers. It stores per-PFN hotness metadata
and performs asynchronous, batched promotion via a per-lower-tier-node
kernel thread (kmigrated).

This change introduces the default (compact) mode of pghot:

- Per-PFN hotness record (phi_t = u8) embedded via mem_section:
  - 2 bits: access frequency (4 levels)
  - 5 bits: time bucket (≈4s window with HZ=1000, bucketed jiffies)
  - 1 bit : migration-ready flag (MSB)
  The LSB of mem_section->hot_map pointer is used as a per-section
  "hot" flag to gate scanning.

- Event recording API:
  int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
  @pfn: The PFN of the memory accessed
  @nid: The accessing NUMA node ID
  @src: The temperature source (subsystem) that generated the
        access info
  @time: The access time in jiffies
  - Sources (e.g., NUMA hint faults, HW hints) call this to report
    accesses.
  - In default mode, the nid is not stored/used for targeting;
    promotion goes to a configurable toptier node (pghot_target_nid).

- Promotion engine:
  - One kmigrated thread per lower-tier node.
  - Scans only sections whose "hot" flag was raised, iterates PFNs,
    and batches candidates by destination node.
  - Uses migrate_misplaced_folios_batch() to move batched folios.

- Tunables & stats:
  - debugfs: enabled_sources, target_nid, freq_threshold,
             kmigrated_sleep_ms, kmigrated_batch_nr
  - sysctl : vm.pghot_promote_freq_window_ms
  - vmstat : pghot_recorded_accesses, pghot_recorded_hintfaults,
             pghot_recorded_hwhints

Memory overhead
---------------
Default mode uses 1 byte of hotness metadata per PFN on lower-tier
nodes.

Behavior & policy
-----------------
- Default mode promotion target:
  The nid passed by sources is not stored; hot pages promote to
  pghot_target_nid (toptier). Precision mode (added later in the
  series) changes this.

- Record consumption:
  kmigrated consumes (clears) the "migration-ready" bit before
  attempting isolation. Additionally the hotness record is reset.
  If isolation/migration fails, the folio is not re-queued automatically;
  subsequent accesses will re-arm it. This avoids retry storms and
  keeps batching stable.

- Wakeups:
  kmigrated wakeups are intentionally timeout-driven. We set
  the per-pgdat "activate" flag on access, and kmigrated checks this
  flag on its next sleep interval. This keeps the first cut simple
  and avoids potential wake storms; active wakeups can be considered
  in a follow-up.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 Documentation/admin-guide/mm/index.rst |   1 +
 Documentation/admin-guide/mm/pghot.rst |  80 ++++
 include/linux/migrate.h                |   4 +-
 include/linux/mmzone.h                 |  20 +
 include/linux/pghot.h                  |  82 ++++
 include/linux/vm_event_item.h          |   5 +
 mm/Kconfig                             |  14 +
 mm/Makefile                            |   1 +
 mm/migrate.c                           |  16 +-
 mm/mm_init.c                           |  10 +
 mm/pghot-default.c                     |  79 ++++
 mm/pghot-tunables.c                    | 182 +++++++++
 mm/pghot.c                             | 494 +++++++++++++++++++++++++
 mm/vmstat.c                            |   5 +
 14 files changed, 986 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/admin-guide/mm/pghot.rst
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/pghot-default.c
 create mode 100644 mm/pghot-tunables.c
 create mode 100644 mm/pghot.c

diff --git a/Documentation/admin-guide/mm/index.rst b/Documentation/admin-guide/mm/index.rst
index bbb563cba5d2..4d6810b02365 100644
--- a/Documentation/admin-guide/mm/index.rst
+++ b/Documentation/admin-guide/mm/index.rst
@@ -43,3 +43,4 @@ the Linux memory management.
    userfaultfd
    zswap
    kho
+   pghot
diff --git a/Documentation/admin-guide/mm/pghot.rst b/Documentation/admin-guide/mm/pghot.rst
new file mode 100644
index 000000000000..5f51dd1d4d45
--- /dev/null
+++ b/Documentation/admin-guide/mm/pghot.rst
@@ -0,0 +1,80 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=================================
+PGHOT: Hot Page Tracking Tunables
+=================================
+
+Overview
+========
+The PGHOT subsystem tracks frequently accessed pages in lower-tier memory and
+promotes them to faster tiers. It uses per-PFN hotness metadata and asynchronous
+migration via per-node kernel threads (kmigrated).
+
+This document describes tunables available via **debugfs** and **sysctl** for
+PGHOT.
+
+Debugfs Interface
+=================
+Path: /sys/kernel/debug/pghot/
+
+1. **enabled_sources**
+   - Bitmask to enable/disable hotness sources.
+   - Bits:
+     - 0: Hint faults (value 0x1)
+     - 1: Hardware hints (value 0x2)
+   - Default: 0 (disabled)
+   - Example:
+     # echo 0x3 > /sys/kernel/debug/pghot/enabled_sources
+     Enables all sources.
+
+2. **target_nid**
+   - Toptier NUMA node ID to which hot pages should be promoted when source
+     does not provide nid. Used when hotness source can't provide accessing
+     NID or when the tracking mode is default.
+   - Default: 0
+   - Example:
+     # echo 1 > /sys/kernel/debug/pghot/target_nid
+
+3. **freq_threshold**
+   - Minimum access frequency before a page is marked ready for promotion.
+   - Range: 1 to 3
+   - Default: 2
+   - Example:
+     # echo 3 > /sys/kernel/debug/pghot/freq_threshold
+
+4. **kmigrated_sleep_ms**
+   - Sleep interval (ms) for kmigrated thread between scans.
+   - Default: 100
+
+5. **kmigrated_batch_nr**
+   - Maximum number of folios migrated in one batch.
+   - Default: 512
+
+Sysctl Interface
+================
+1. pghot_promote_freq_window_ms
+
+Path: /proc/sys/vm/pghot_promote_freq_window_ms
+
+- Controls the time window (in ms) for counting access frequency. A page is
+  considered hot only when **freq_threshold** number of accesses occur with
+  this time period.
+- Default: 3000 (3 seconds)
+- Example:
+  # sysctl vm.pghot_promote_freq_window_ms=3000
+
+Vmstat Counters
+===============
+Following vmstat counters provide some stats about pghot subsystem.
+
+Path: /proc/vmstat
+
+1. **pghot_recorded_accesses**
+   - Number of total hot page accesses recorded by pghot.
+
+2. **pghot_recorded_hintfaults**
+   - Number of recorded accesses reported by NUMA Balancing based
+     hotness source.
+
+3. **pghot_recorded_hwhints**
+   - Number of recorded accesses reported by hwhints source.
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index d136612eef9d..53bae80d11ae 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -107,7 +107,7 @@ static inline void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t *p
 
 #endif /* CONFIG_MIGRATION */
 
-#ifdef CONFIG_NUMA_BALANCING
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_PGHOT)
 int migrate_misplaced_folio_prepare(struct folio *folio,
 		struct vm_area_struct *vma, int node);
 int migrate_misplaced_folio(struct folio *folio, int node);
@@ -126,7 +126,7 @@ static inline int promote_misplaced_memcg_folios(struct list_head *folio_list, i
 {
 	return -EAGAIN; /* can't migrate now */
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_NUMA_BALANCING || CONFIG_PGHOT */
 
 #ifdef CONFIG_MIGRATION
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 9adb2ad21da5..eb08431dc9fb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1155,6 +1155,7 @@ enum pgdat_flags {
 					 * many pages under writeback
 					 */
 	PGDAT_RECLAIM_LOCKED,		/* prevents concurrent reclaim */
+	PGDAT_KMIGRATED_ACTIVATE,	/* activates kmigrated */
 };
 
 enum zone_flags {
@@ -1609,6 +1610,10 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_PGHOT
+	struct task_struct *kmigrated;
+	wait_queue_head_t kmigrated_wait;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
@@ -2019,12 +2024,27 @@ struct mem_section {
 	unsigned long section_mem_map;
 
 	struct mem_section_usage *usage;
+#ifdef CONFIG_PGHOT
+	/*
+	 * Per-PFN hotness data for this section.
+	 * Array of phi_t (u8 in default mode).
+	 * LSB is used as PGHOT_SECTION_HOT_BIT flag.
+	 */
+	void *hot_map;
+#endif
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
+#endif
+	/*
+	 * Padding to maintain consistent mem_section size when exactly
+	 * one of PGHOT or PAGE_EXTENSION is enabled. This ensures
+	 * optimal alignment regardless of configuration.
+	 */
+#if (defined(CONFIG_PGHOT) ^ defined(CONFIG_PAGE_EXTENSION))
 	unsigned long pad;
 #endif
 	/*
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
new file mode 100644
index 000000000000..525d4dd28fc1
--- /dev/null
+++ b/include/linux/pghot.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_PGHOT_H
+#define _LINUX_PGHOT_H
+
+/* Page hotness temperature sources */
+enum pghot_src {
+	PGHOT_HINTFAULTS = 0,
+	PGHOT_HWHINTS,
+	PGHOT_SRC_MAX
+};
+
+#ifdef CONFIG_PGHOT
+#include <linux/static_key.h>
+
+extern unsigned int pghot_target_nid;
+extern unsigned int pghot_src_enabled;
+extern unsigned int pghot_freq_threshold;
+extern unsigned int kmigrated_sleep_ms;
+extern unsigned int kmigrated_batch_nr;
+extern unsigned int sysctl_pghot_freq_window;
+
+void pghot_debug_init(void);
+
+DECLARE_STATIC_KEY_FALSE(pghot_src_hintfaults);
+DECLARE_STATIC_KEY_FALSE(pghot_src_hwhints);
+
+#define PGHOT_HINTFAULTS_ENABLED	BIT(PGHOT_HINTFAULTS)
+#define PGHOT_HWHINTS_ENABLED		BIT(PGHOT_HWHINTS)
+#define PGHOT_SRC_ENABLED_MASK		GENMASK(PGHOT_SRC_MAX - 1, 0)
+
+#define PGHOT_DEFAULT_FREQ_THRESHOLD	2
+
+#define KMIGRATED_DEFAULT_SLEEP_MS	100
+#define KMIGRATED_DEFAULT_BATCH_NR	512
+
+#define PGHOT_DEFAULT_NODE		0
+
+#define PGHOT_DEFAULT_FREQ_WINDOW	(3 * MSEC_PER_SEC)
+
+/*
+ * Bits 0-6 are used to store frequency and time.
+ * Bit 7 is used to indicate the page is ready for migration.
+ */
+#define PGHOT_MIGRATE_READY		7
+
+#define PGHOT_FREQ_WIDTH		2
+/* Bucketed time is stored in 5 bits which can represent up to 3.9s with HZ=1000 */
+#define PGHOT_TIME_BUCKETS_SHIFT	7
+#define PGHOT_TIME_WIDTH		5
+#define PGHOT_NID_WIDTH			10
+
+#define PGHOT_FREQ_SHIFT		0
+#define PGHOT_TIME_SHIFT		(PGHOT_FREQ_SHIFT + PGHOT_FREQ_WIDTH)
+
+#define PGHOT_FREQ_MASK			GENMASK(PGHOT_FREQ_WIDTH - 1, 0)
+#define PGHOT_TIME_MASK			GENMASK(PGHOT_TIME_WIDTH - 1, 0)
+#define PGHOT_TIME_BUCKETS_MASK		(PGHOT_TIME_MASK << PGHOT_TIME_BUCKETS_SHIFT)
+
+#define PGHOT_NID_MAX			((1 << PGHOT_NID_WIDTH) - 1)
+#define PGHOT_FREQ_MAX			((1 << PGHOT_FREQ_WIDTH) - 1)
+#define PGHOT_TIME_MAX			((1 << PGHOT_TIME_WIDTH) - 1)
+
+typedef u8 phi_t;
+
+#define PGHOT_RECORD_SIZE		sizeof(phi_t)
+
+#define PGHOT_SECTION_HOT_BIT		0
+#define PGHOT_SECTION_HOT_MASK		BIT(PGHOT_SECTION_HOT_BIT)
+
+bool pghot_nid_valid(int nid);
+unsigned long pghot_access_latency(unsigned long old_time, unsigned long time);
+bool pghot_update_record(phi_t *phi, int nid, unsigned long now);
+int pghot_get_record(phi_t *phi, int *nid, int *freq, unsigned long *time);
+
+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now);
+#else
+static inline int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
+{
+	return 0;
+}
+#endif /* CONFIG_PGHOT */
+#endif /* _LINUX_PGHOT_H */
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..58d510711bd4 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -175,6 +175,11 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_PGHOT
+		PGHOT_RECORDED_ACCESSES,
+		PGHOT_RECORDED_HINTFAULTS,
+		PGHOT_RECORDED_HWHINTS,
+#endif /* CONFIG_PGHOT */
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/Kconfig b/mm/Kconfig
index 0a43bb80df4f..ebfa149d8123 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1469,6 +1469,20 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config PGHOT
+	bool "Hot page tracking and promotion"
+	default n
+	depends on NUMA_MIGRATION && SPARSEMEM
+	help
+	  A sub-system to track page accesses in lower tier memory and
+	  maintain hot page information. Promotes hot pages from lower
+	  tiers to top tier by using the memory access information provided
+	  by various sources. Asynchronous promotion is done by per-node
+	  kernel threads.
+
+	  This adds 1 byte of metadata overhead per page in lower-tier
+	  memory nodes.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 8ad2ab08244e..33014de43acc 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -150,3 +150,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
+obj-$(CONFIG_PGHOT) += pghot.o pghot-tunables.o pghot-default.o
diff --git a/mm/migrate.c b/mm/migrate.c
index 747277aadf19..726d27b61a46 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2625,7 +2625,7 @@ SYSCALL_DEFINE6(move_pages, pid_t, pid, unsigned long, nr_pages,
 }
 #endif /* CONFIG_NUMA_MIGRATION */
 
-#ifdef CONFIG_NUMA_BALANCING
+#if defined(CONFIG_NUMA_BALANCING) || defined(CONFIG_PGHOT)
 /*
  * Returns true if this is a safe migration target node for misplaced NUMA
  * pages. Currently it only checks the watermarks which is crude.
@@ -2745,12 +2745,10 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
  */
 int migrate_misplaced_folio(struct folio *folio, int node)
 {
-	pg_data_t *pgdat = NODE_DATA(node);
 	int nr_remaining;
 	unsigned int nr_succeeded;
 	LIST_HEAD(migratepages);
 	struct mem_cgroup *memcg = get_mem_cgroup_from_folio(folio);
-	struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	list_add(&folio->lru, &migratepages);
 	nr_remaining = migrate_pages(&migratepages, alloc_misplaced_dst_folio,
@@ -2759,12 +2757,18 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 	if (nr_remaining && !list_empty(&migratepages))
 		putback_movable_pages(&migratepages);
 	if (nr_succeeded) {
+#ifdef CONFIG_NUMA_BALANCING
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
 		    && !node_is_toptier(folio_nid(folio))
-		    && node_is_toptier(node))
+		    && node_is_toptier(node)) {
+			pg_data_t *pgdat = NODE_DATA(node);
+			struct lruvec *lruvec = mem_cgroup_lruvec(memcg, pgdat);
+
 			mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_succeeded);
+		}
+#endif
 	}
 	mem_cgroup_put(memcg);
 	BUG_ON(!list_empty(&migratepages));
@@ -2817,14 +2821,16 @@ int promote_misplaced_memcg_folios(struct list_head *folio_list, int node)
 		putback_movable_pages(folio_list);
 
 	if (nr_succeeded) {
+#ifdef CONFIG_NUMA_BALANCING
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
 		mod_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(node)),
 				 PGPROMOTE_SUCCESS, nr_succeeded);
+#endif
 	}
 
 	mem_cgroup_put(memcg);
 	WARN_ON(!list_empty(folio_list));
 	return nr_remaining ? -EAGAIN : 0;
 }
-#endif /* CONFIG_NUMA_BALANCING */
+#endif /* CONFIG_NUMA_BALANCING || CONFIG_PGHOT */
diff --git a/mm/mm_init.c b/mm/mm_init.c
index f9f8e1af921c..2396c42028ae 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1384,6 +1384,15 @@ static void pgdat_init_kcompactd(struct pglist_data *pgdat)
 static void pgdat_init_kcompactd(struct pglist_data *pgdat) {}
 #endif
 
+#ifdef CONFIG_PGHOT
+static void pgdat_init_kmigrated(struct pglist_data *pgdat)
+{
+	init_waitqueue_head(&pgdat->kmigrated_wait);
+}
+#else
+static inline void pgdat_init_kmigrated(struct pglist_data *pgdat) {}
+#endif
+
 static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 {
 	int i;
@@ -1393,6 +1402,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 
 	pgdat_init_split_queue(pgdat);
 	pgdat_init_kcompactd(pgdat);
+	pgdat_init_kmigrated(pgdat);
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
diff --git a/mm/pghot-default.c b/mm/pghot-default.c
new file mode 100644
index 000000000000..e610062345e4
--- /dev/null
+++ b/mm/pghot-default.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pghot: Default mode
+ *
+ * 1 byte hotness record per PFN.
+ * Bucketed time and frequency tracked as part of the record.
+ * Promotion to @pghot_target_nid by default.
+ */
+
+#include <linux/pghot.h>
+#include <linux/jiffies.h>
+
+/* pghot-default doesn't store and hence no NID validation is required */
+bool pghot_nid_valid(int nid)
+{
+	return true;
+}
+
+/*
+ * @time is regular time, @old_time is bucketed time.
+ */
+unsigned long pghot_access_latency(unsigned long old_time, unsigned long time)
+{
+	time &= PGHOT_TIME_BUCKETS_MASK;
+	old_time <<= PGHOT_TIME_BUCKETS_SHIFT;
+
+	return jiffies_to_msecs((time - old_time) & PGHOT_TIME_BUCKETS_MASK);
+}
+
+bool pghot_update_record(phi_t *phi, int nid, unsigned long now)
+{
+	phi_t freq, old_freq, hotness, old_hotness, old_time;
+	phi_t time = now >> PGHOT_TIME_BUCKETS_SHIFT;
+
+	old_hotness = READ_ONCE(*phi);
+	do {
+		bool new_window = false;
+
+		hotness = old_hotness;
+		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+
+		if (pghot_access_latency(old_time, now) > sysctl_pghot_freq_window)
+			new_window = true;
+
+		if (new_window)
+			freq = 1;
+		else if (old_freq < PGHOT_FREQ_MAX)
+			freq = old_freq + 1;
+		else
+			freq = old_freq;
+
+		hotness &= ~(PGHOT_FREQ_MASK << PGHOT_FREQ_SHIFT);
+		hotness &= ~(PGHOT_TIME_MASK << PGHOT_TIME_SHIFT);
+
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
+	*nid = pghot_target_nid;
+	*freq = (old_hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
+	*time = (old_hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
+	return 0;
+}
diff --git a/mm/pghot-tunables.c b/mm/pghot-tunables.c
new file mode 100644
index 000000000000..f04e2137309e
--- /dev/null
+++ b/mm/pghot-tunables.c
@@ -0,0 +1,182 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pghot tunables in debugfs
+ */
+#include <linux/pghot.h>
+#include <linux/memory-tiers.h>
+#include <linux/debugfs.h>
+
+static struct dentry *debugfs_pghot;
+static DEFINE_MUTEX(pghot_tunables_lock);
+
+static ssize_t pghot_freq_th_write(struct file *filp, const char __user *ubuf,
+				   size_t cnt, loff_t *ppos)
+{
+	char buf[16];
+	unsigned int freq;
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+
+	if (kstrtouint(buf, 10, &freq))
+		return -EINVAL;
+
+	if (!freq || freq > PGHOT_FREQ_MAX)
+		return -EINVAL;
+
+	mutex_lock(&pghot_tunables_lock);
+	pghot_freq_threshold = freq;
+	mutex_unlock(&pghot_tunables_lock);
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int pghot_freq_th_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", pghot_freq_threshold);
+	return 0;
+}
+
+static int pghot_freq_th_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, pghot_freq_th_show, NULL);
+}
+
+static const struct file_operations pghot_freq_th_fops = {
+	.open		= pghot_freq_th_open,
+	.write		= pghot_freq_th_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static ssize_t pghot_target_nid_write(struct file *filp, const char __user *ubuf,
+				      size_t cnt, loff_t *ppos)
+{
+	char buf[16];
+	unsigned int nid;
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+
+	if (kstrtouint(buf, 10, &nid))
+		return -EINVAL;
+
+	if (nid > PGHOT_NID_MAX || !node_online(nid) || !node_is_toptier(nid))
+		return -EINVAL;
+	mutex_lock(&pghot_tunables_lock);
+	pghot_target_nid = nid;
+	mutex_unlock(&pghot_tunables_lock);
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int pghot_target_nid_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%d\n", pghot_target_nid);
+	return 0;
+}
+
+static int pghot_target_nid_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, pghot_target_nid_show, NULL);
+}
+
+static const struct file_operations pghot_target_nid_fops = {
+	.open		= pghot_target_nid_open,
+	.write		= pghot_target_nid_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static void pghot_src_enabled_update(unsigned int enabled)
+{
+	unsigned int changed = pghot_src_enabled ^ enabled;
+
+	if (changed & PGHOT_HINTFAULTS_ENABLED) {
+		if (enabled & PGHOT_HINTFAULTS_ENABLED)
+			static_branch_enable(&pghot_src_hintfaults);
+		else
+			static_branch_disable(&pghot_src_hintfaults);
+	}
+
+	if (changed & PGHOT_HWHINTS_ENABLED) {
+		if (enabled & PGHOT_HWHINTS_ENABLED)
+			static_branch_enable(&pghot_src_hwhints);
+		else
+			static_branch_disable(&pghot_src_hwhints);
+	}
+}
+
+static ssize_t pghot_src_enabled_write(struct file *filp, const char __user *ubuf,
+					   size_t cnt, loff_t *ppos)
+{
+	char buf[16];
+	unsigned int enabled;
+
+	if (cnt > 15)
+		cnt = 15;
+
+	if (copy_from_user(&buf, ubuf, cnt))
+		return -EFAULT;
+	buf[cnt] = '\0';
+
+	if (kstrtouint(buf, 0, &enabled))
+		return -EINVAL;
+
+	if (enabled & ~PGHOT_SRC_ENABLED_MASK)
+		return -EINVAL;
+
+	mutex_lock(&pghot_tunables_lock);
+	pghot_src_enabled_update(enabled);
+	pghot_src_enabled = enabled;
+	mutex_unlock(&pghot_tunables_lock);
+
+	*ppos += cnt;
+	return cnt;
+}
+
+static int pghot_src_enabled_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%u\n", pghot_src_enabled);
+	return 0;
+}
+
+static int pghot_src_enabled_open(struct inode *inode, struct file *filp)
+{
+	return single_open(filp, pghot_src_enabled_show, NULL);
+}
+
+static const struct file_operations pghot_src_enabled_fops = {
+	.open		= pghot_src_enabled_open,
+	.write		= pghot_src_enabled_write,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+void pghot_debug_init(void)
+{
+	debugfs_pghot = debugfs_create_dir("pghot", NULL);
+	debugfs_create_file("enabled_sources", 0644, debugfs_pghot, NULL,
+			    &pghot_src_enabled_fops);
+	debugfs_create_file("target_nid", 0644, debugfs_pghot, NULL,
+			    &pghot_target_nid_fops);
+	debugfs_create_file("freq_threshold", 0644, debugfs_pghot, NULL,
+			    &pghot_freq_th_fops);
+	debugfs_create_u32("kmigrated_sleep_ms", 0644, debugfs_pghot,
+			    &kmigrated_sleep_ms);
+	debugfs_create_u32("kmigrated_batch_nr", 0644, debugfs_pghot,
+			    &kmigrated_batch_nr);
+}
diff --git a/mm/pghot.c b/mm/pghot.c
new file mode 100644
index 000000000000..02e6959b647a
--- /dev/null
+++ b/mm/pghot.c
@@ -0,0 +1,494 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Maintains information about hot pages from slower tier nodes and
+ * promotes them.
+ *
+ * Per-PFN hotness information is stored for lower tier nodes in
+ * mem_section.
+ *
+ * In the default mode, a single byte (u8) is used to store
+ * the frequency of access and last access time. Promotions are done
+ * to a default toptier NID.
+ *
+ * A kernel thread named kmigrated is provided to migrate or promote
+ * the hot pages. kmigrated runs for each lower tier node. It iterates
+ * over the node's PFNs and  migrates pages marked for migration into
+ * their targeted nodes.
+ */
+#include <linux/mm.h>
+#include <linux/migrate.h>
+#include <linux/memory.h>
+#include <linux/memory-tiers.h>
+#include <linux/pghot.h>
+
+unsigned int pghot_target_nid = PGHOT_DEFAULT_NODE;
+unsigned int pghot_src_enabled;
+unsigned int pghot_freq_threshold = PGHOT_DEFAULT_FREQ_THRESHOLD;
+unsigned int kmigrated_sleep_ms = KMIGRATED_DEFAULT_SLEEP_MS;
+unsigned int kmigrated_batch_nr = KMIGRATED_DEFAULT_BATCH_NR;
+
+unsigned int sysctl_pghot_freq_window = PGHOT_DEFAULT_FREQ_WINDOW;
+
+DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
+DEFINE_STATIC_KEY_FALSE(pghot_src_hintfaults);
+
+#ifdef CONFIG_SYSCTL
+static const struct ctl_table pghot_sysctls[] = {
+	{
+		.procname       = "pghot_promote_freq_window_ms",
+		.data           = &sysctl_pghot_freq_window,
+		.maxlen         = sizeof(unsigned int),
+		.mode           = 0644,
+		.proc_handler   = proc_dointvec_minmax,
+		.extra1         = SYSCTL_ZERO,
+	},
+};
+#endif
+
+static bool kmigrated_started __ro_after_init;
+
+/**
+ * pghot_record_access() - Record page accesses from lower tier memory
+ * for the purpose of tracking page hotness and subsequent promotion.
+ *
+ * @pfn: PFN of the page
+ * @nid: Unused
+ * @src: The identifier of the sub-system that reports the access
+ * @now: Access time in jiffies
+ *
+ * Updates the frequency and time of access and marks the page as
+ * ready for migration if the frequency crosses a threshold. The pages
+ * marked for migration are migrated by kmigrated kernel thread.
+ *
+ * Return: 0 on success and -EINVAL on failure to record the access.
+ */
+int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
+{
+	struct mem_section *ms;
+	struct folio *folio;
+	phi_t *phi, *hot_map;
+	struct page *page;
+	int src_nid;
+
+	if (!kmigrated_started)
+		return 0;
+
+	if (!pghot_nid_valid(nid))
+		return -EINVAL;
+
+	switch (src) {
+	case PGHOT_HINTFAULTS:
+		if (!static_branch_unlikely(&pghot_src_hintfaults))
+			return 0;
+		count_vm_event(PGHOT_RECORDED_HINTFAULTS);
+		break;
+	case PGHOT_HWHINTS:
+		if (!static_branch_unlikely(&pghot_src_hwhints))
+			return 0;
+		count_vm_event(PGHOT_RECORDED_HWHINTS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	src_nid = pfn_to_nid(pfn);
+	if (src_nid == nid)
+		return 0;
+
+	/*
+	 * Record only accesses from lower tiers.
+	 */
+	if (node_is_toptier(src_nid))
+		return 0;
+
+	/*
+	 * Reject the non-migratable pages right away.
+	 */
+	page = pfn_to_online_page(pfn);
+	if (!page || is_zone_device_page(page))
+		return 0;
+
+	folio = page_folio(page);
+	if (!folio_try_get(folio))
+		return 0;
+
+	if (unlikely(page_folio(page) != folio))
+		goto out;
+
+	if (!folio_test_lru(folio))
+		goto out;
+
+	/* Get the hotness slot corresponding to the 1st PFN of the folio */
+	pfn = folio_pfn(folio);
+	ms = __pfn_to_section(pfn);
+	if (!ms || !ms->hot_map)
+		goto out;
+
+	hot_map = (phi_t *)(((unsigned long)(ms->hot_map)) & ~PGHOT_SECTION_HOT_MASK);
+	phi = &hot_map[pfn % PAGES_PER_SECTION];
+
+	count_vm_event(PGHOT_RECORDED_ACCESSES);
+
+	/*
+	 * Update the hotness parameters.
+	 */
+	if (pghot_update_record(phi, nid, now)) {
+		set_bit(PGHOT_SECTION_HOT_BIT, (unsigned long *)&ms->hot_map);
+		set_bit(PGDAT_KMIGRATED_ACTIVATE, &page_pgdat(page)->flags);
+	}
+out:
+	folio_put(folio);
+	return 0;
+}
+
+static int pghot_get_hotness(unsigned long pfn, int *nid, int *freq,
+			     unsigned long *time)
+{
+	phi_t *phi, *hot_map;
+	struct mem_section *ms;
+
+	ms = __pfn_to_section(pfn);
+	if (!ms || !ms->hot_map)
+		return -EINVAL;
+
+	hot_map = (phi_t *)(((unsigned long)(ms->hot_map)) & ~PGHOT_SECTION_HOT_MASK);
+	phi = &hot_map[pfn % PAGES_PER_SECTION];
+
+	return pghot_get_record(phi, nid, freq, time);
+}
+
+/*
+ * Walks the PFNs of the zone, isolates and migrates them in batches.
+ */
+static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
+				int src_nid)
+{
+	struct mem_cgroup *cur_memcg = NULL;
+	int cur_nid = NUMA_NO_NODE;
+	LIST_HEAD(migrate_list);
+	int batch_count = 0;
+	struct folio *folio;
+	struct page *page;
+	unsigned long pfn;
+
+	pfn = start_pfn;
+	do {
+		int nid = NUMA_NO_NODE, nr = 1;
+		struct mem_cgroup *memcg;
+		unsigned long time = 0;
+		int freq = 0;
+
+		if (!pfn_valid(pfn))
+			goto out_next;
+
+		page = pfn_to_online_page(pfn);
+		if (!page)
+			goto out_next;
+
+		folio = page_folio(page);
+		if (!folio_try_get(folio))
+			goto out_next;
+
+		if (unlikely(page_folio(page) != folio)) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		nr = folio_nr_pages(folio);
+		if (folio_nid(folio) != src_nid) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		if (!folio_test_lru(folio)) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		if (pghot_get_hotness(pfn, &nid, &freq, &time)) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		if (nid == NUMA_NO_NODE)
+			nid = pghot_target_nid;
+
+		if (folio_nid(folio) == nid) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		if (migrate_misplaced_folio_prepare(folio, NULL, nid)) {
+			folio_put(folio);
+			goto out_next;
+		}
+
+		memcg = folio_memcg(folio);
+		if (cur_nid == NUMA_NO_NODE) {
+			cur_nid = nid;
+			cur_memcg = memcg;
+		}
+
+		/* If NID or memcg changed, flush the previous batch first */
+		if (cur_nid != nid || cur_memcg != memcg) {
+			if (!list_empty(&migrate_list))
+				promote_misplaced_memcg_folios(&migrate_list, cur_nid);
+			cur_nid = nid;
+			cur_memcg = memcg;
+			batch_count = 0;
+			cond_resched();
+		}
+
+		list_add(&folio->lru, &migrate_list);
+		folio_put(folio);
+
+		if (++batch_count > kmigrated_batch_nr) {
+			promote_misplaced_memcg_folios(&migrate_list, cur_nid);
+			batch_count = 0;
+			cond_resched();
+		}
+out_next:
+		pfn += nr;
+	} while (pfn < end_pfn);
+	if (!list_empty(&migrate_list))
+		promote_misplaced_memcg_folios(&migrate_list, cur_nid);
+}
+
+static void kmigrated_do_work(pg_data_t *pgdat)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct mem_section *ms;
+	int nid;
+
+	clear_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		start_pfn = section_nr_to_pfn(section_nr);
+		ms = __nr_to_section(section_nr);
+
+		if (!pfn_valid(start_pfn))
+			continue;
+
+		nid = pfn_to_nid(start_pfn);
+		if (node_is_toptier(nid) || nid != pgdat->node_id)
+			continue;
+
+		if (!test_and_clear_bit(PGHOT_SECTION_HOT_BIT, (unsigned long *)&ms->hot_map))
+			continue;
+
+		kmigrated_walk_zone(start_pfn, start_pfn + PAGES_PER_SECTION,
+				    pgdat->node_id);
+	}
+}
+
+static inline bool kmigrated_work_requested(pg_data_t *pgdat)
+{
+	return test_bit(PGDAT_KMIGRATED_ACTIVATE, &pgdat->flags);
+}
+
+/*
+ * Per-node kthread that iterates over its PFNs and migrates the
+ * pages that have been marked for migration.
+ */
+static int kmigrated(void *p)
+{
+	pg_data_t *pgdat = p;
+
+	while (!kthread_should_stop()) {
+		long timeout = msecs_to_jiffies(READ_ONCE(kmigrated_sleep_ms));
+
+		if (wait_event_timeout(pgdat->kmigrated_wait, kmigrated_work_requested(pgdat),
+				       timeout))
+			kmigrated_do_work(pgdat);
+	}
+	return 0;
+}
+
+static int kmigrated_run(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int ret;
+
+	if (!pgdat->kmigrated) {
+		pgdat->kmigrated = kthread_create_on_node(kmigrated, pgdat, nid,
+							  "kmigrated%d", nid);
+		if (IS_ERR(pgdat->kmigrated)) {
+			ret = PTR_ERR(pgdat->kmigrated);
+			pgdat->kmigrated = NULL;
+			pr_err("Failed to start kmigrated%d, ret %d\n", nid, ret);
+			return ret;
+		}
+		pr_info("pghot: Started kmigrated thread for node %d\n", nid);
+	}
+	wake_up_process(pgdat->kmigrated);
+	return 0;
+}
+
+static void pghot_free_hot_map(struct mem_section *ms)
+{
+	kfree((void *)((unsigned long)ms->hot_map & ~PGHOT_SECTION_HOT_MASK));
+	ms->hot_map = NULL;
+}
+
+static int pghot_alloc_hot_map(struct mem_section *ms, int nid)
+{
+	ms->hot_map = kcalloc_node(PAGES_PER_SECTION, PGHOT_RECORD_SIZE, GFP_KERNEL,
+				   nid);
+	if (!ms->hot_map)
+		return -ENOMEM;
+	return 0;
+}
+
+static void pghot_offline_sec_hotmap(unsigned long start_pfn,
+				     unsigned long nr_pages)
+{
+	unsigned long start, end, pfn;
+	struct mem_section *ms;
+
+	start = SECTION_ALIGN_DOWN(start_pfn);
+	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
+
+	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
+		ms = __pfn_to_section(pfn);
+		if (!ms || !ms->hot_map)
+			continue;
+
+		pghot_free_hot_map(ms);
+	}
+}
+
+static int pghot_online_sec_hotmap(unsigned long start_pfn,
+				   unsigned long nr_pages)
+{
+	int nid = pfn_to_nid(start_pfn);
+	unsigned long start, end, pfn;
+	struct mem_section *ms;
+	int fail = 0;
+
+	start = SECTION_ALIGN_DOWN(start_pfn);
+	end = SECTION_ALIGN_UP(start_pfn + nr_pages);
+
+	for (pfn = start; !fail && pfn < end; pfn += PAGES_PER_SECTION) {
+		ms = __pfn_to_section(pfn);
+		if (!ms || ms->hot_map)
+			continue;
+
+		fail = pghot_alloc_hot_map(ms, nid);
+	}
+
+	if (!fail)
+		return 0;
+
+	/* rollback */
+	end = pfn - PAGES_PER_SECTION;
+	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
+		ms = __pfn_to_section(pfn);
+		if (ms && ms->hot_map)
+			pghot_free_hot_map(ms);
+	}
+	return -ENOMEM;
+}
+
+static int pghot_memhp_callback(struct notifier_block *self,
+				unsigned long action, void *arg)
+{
+	struct memory_notify *mn = arg;
+	int ret = 0;
+
+	switch (action) {
+	case MEM_GOING_ONLINE:
+		ret = pghot_online_sec_hotmap(mn->start_pfn, mn->nr_pages);
+		break;
+	case MEM_OFFLINE:
+	case MEM_CANCEL_ONLINE:
+		pghot_offline_sec_hotmap(mn->start_pfn, mn->nr_pages);
+		break;
+	}
+
+	return notifier_from_errno(ret);
+}
+
+static struct notifier_block pghot_mem_notifier = {
+	.notifier_call = pghot_memhp_callback,
+	.priority = DEFAULT_CALLBACK_PRI,
+};
+
+static void pghot_destroy_hot_map(void)
+{
+	unsigned long section_nr, s_begin;
+	struct mem_section *ms;
+
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		pghot_free_hot_map(ms);
+	}
+
+	unregister_memory_notifier(&pghot_mem_notifier);
+}
+
+static int pghot_setup_hot_map(void)
+{
+	unsigned long section_nr, s_begin, start_pfn;
+	struct mem_section *ms;
+	int nid, ret;
+
+	ret = register_memory_notifier(&pghot_mem_notifier);
+	if (ret)
+		return ret;
+
+	s_begin = next_present_section_nr(-1);
+	for_each_present_section_nr(s_begin, section_nr) {
+		ms = __nr_to_section(section_nr);
+		start_pfn = section_nr_to_pfn(section_nr);
+		nid = pfn_to_nid(start_pfn);
+
+		if (node_is_toptier(nid) || !pfn_valid(start_pfn))
+			continue;
+
+		if (pghot_alloc_hot_map(ms, nid))
+			goto out_free_hot_map;
+	}
+	return 0;
+
+out_free_hot_map:
+	pghot_destroy_hot_map();
+	return -ENOMEM;
+}
+
+static int __init pghot_init(void)
+{
+	pg_data_t *pgdat;
+	int nid, ret;
+
+	ret = pghot_setup_hot_map();
+	if (ret)
+		return ret;
+
+	for_each_node_state(nid, N_MEMORY) {
+		if (node_is_toptier(nid))
+			continue;
+
+		ret = kmigrated_run(nid);
+		if (ret)
+			goto out_stop_kthread;
+	}
+	register_sysctl_init("vm", pghot_sysctls);
+	pghot_debug_init();
+
+	kmigrated_started = true;
+	return 0;
+
+out_stop_kthread:
+	for_each_node_state(nid, N_MEMORY) {
+		pgdat = NODE_DATA(nid);
+		if (pgdat->kmigrated) {
+			kthread_stop(pgdat->kmigrated);
+			pgdat->kmigrated = NULL;
+		}
+	}
+	pghot_destroy_hot_map();
+	return ret;
+}
+
+late_initcall_sync(pghot_init)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..4064ead568cc 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1489,6 +1489,11 @@ const char * const vmstat_text[] = {
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
 #endif
+#ifdef CONFIG_PGHOT
+	[I(PGHOT_RECORDED_ACCESSES)]		= "pghot_recorded_accesses",
+	[I(PGHOT_RECORDED_HINTFAULTS)]		= "pghot_recorded_hintfaults",
+	[I(PGHOT_RECORDED_HWHINTS)]		= "pghot_recorded_hwhints",
+#endif /* CONFIG_PGHOT */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.34.1


