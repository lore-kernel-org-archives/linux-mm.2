Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6549CCD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 06:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB24E6B0099; Mon,  4 May 2026 02:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63106B009B; Mon,  4 May 2026 02:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B043E6B009D; Mon,  4 May 2026 02:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9754B6B0099
	for <linux-mm@kvack.org>; Mon,  4 May 2026 02:10:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45FECA08F5
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:55 +0000 (UTC)
X-FDA: 84728714070.28.E99AB84
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012054.outbound.protection.outlook.com [52.101.43.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id 29319180005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 06:10:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VaFjDicP;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.43.54 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777875052; a=rsa-sha256;
	cv=pass;
	b=JLzqQ3bfYOlbFS0Ys0Z2XguARKdAC95ulXTIX2ts7OTVLCaGZ0qjxGb7/AnFgH3YjREZni
	z6j1CBOQqSML7yta3/SKvYmk/zAHkk1LOmbmUp0TrL6FZj+0kLoUUPemUN6Kj+52TtcPGG
	tyL2BKQTScBYwOsI8eIq8d7nRV62QmM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VaFjDicP;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of bharata@amd.com designates 52.101.43.54 as permitted sender) smtp.mailfrom=bharata@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777875052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59jb1BravKhHJMa6QBqdlLHgK9P5LxuGuAFPLje6U8k=;
	b=W+czyVDn32Paia1j6tLcQICXHVWTu+BSxkTTNO8RjwgBNsVW9g9nPeF0d/QuTE3VZzkP1z
	/kUiJio0Asu5KEbNwzZuKi6lfTWZws0k8shaW+ijY6OIYwqqKOhZ7oDfPFQ/MF9orhYhB0
	HM8OC5DhFfhM2IbBwNJd1JOUwK3pPAY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xaIFCa62i+jmlQWy6yem7UnxnzUK0/OtwQJ0ddqr7ffv+Y3qOgqGT0mO6B1n3qxUZXy1tXekC579tgyp1AlAAOVRJXB4HdY9AQFEyBTzdpr36B9rbD/rH4zrVmnvLakxVMYJXy1zd8twLLG6ya2T957LLKzN8URJREXsjgbd+dZtxWlNAwW/UUtuQI4vYxSxNK8fgY6qR4jDV8F7XRhbvKUNzfv+2/I+Kmu60H7JxH/uAByLiVihqtCepCZZ/egvrZHJ/VQm5s2lVjEqEdKjRe21xb8TeKy1OLBRrqb9F/6/qATH6Z2zlxX8CWP0/DzS0br8uaZPTwZ8xLGovfzd8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=59jb1BravKhHJMa6QBqdlLHgK9P5LxuGuAFPLje6U8k=;
 b=wHi8aw9aLMxb7f9LhT3q/4zdM/sLwyHEhHppJTRCH+LtvcTuPAesoFCrGLKguwyOIM0NVw/ZZnLfpEzpCfabIfwTV8CTehDkXd/5/Oijilbo1Jfn1STom76K9X7qhI+QfRaVvYwnSeCAoEnuK2kgVqtwrJBQpxuyX+GqS/0D/7/hs461SZZAr2LbutMcaXCE/ZUgP8bb4Qb4QnPSxLoyxqbBNP6Z3j+mIFBPi1crz7pkHY+rnfk8MDoaVt+XHrh+Mh/1LXyrLlWAyQpmU5vE247J4khE4d8w1Hf2d6IqEtd93ExHIuAi7s9gt40UYiVl46rq4RM/C+9ExqbFG3W4yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=59jb1BravKhHJMa6QBqdlLHgK9P5LxuGuAFPLje6U8k=;
 b=VaFjDicPPHMEWp9k5KELEnZfvJw7eqSRyb6QfbUHA039Z/rpOzUd54zaUEPqDKGrLUw/mKeqSoCH9nHNzZjNJRxnbxVNDIXnBGsyAhaU6JmvaCOgZKPFLMu3ZQaX4yr0SeMqJ3XtdATq9DOPD7xR5lA2YAqDZrZtqpC1+K+Uf7A=
Received: from CH2PR10CA0024.namprd10.prod.outlook.com (2603:10b6:610:4c::34)
 by IA1PR12MB6042.namprd12.prod.outlook.com (2603:10b6:208:3d6::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 06:10:45 +0000
Received: from CH1PEPF0000AD7A.namprd04.prod.outlook.com
 (2603:10b6:610:4c:cafe::c3) by CH2PR10CA0024.outlook.office365.com
 (2603:10b6:610:4c::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9870.22 via Frontend Transport; Mon,
 4 May 2026 06:10:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD7A.mail.protection.outlook.com (10.167.244.59) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.9 via Frontend Transport; Mon, 4 May 2026 06:10:44 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 4 May
 2026 01:10:36 -0500
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
Subject: [PATCH v7 5/7] mm: sched: move NUMA balancing tiering promotion to pghot
Date: Mon, 4 May 2026 11:39:22 +0530
Message-ID: <20260504060924.344313-6-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260504060924.344313-1-bharata@amd.com>
References: <20260504060924.344313-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD7A:EE_|IA1PR12MB6042:EE_
X-MS-Office365-Filtering-Correlation-Id: 868e5b36-7f38-4116-d857-08dea9a3e0d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	GYigqpm/kBdsojbVXNz1mcuo+Ka0cvgw8iBNhwXx2DvlPu4AgIbpMMxgLaOQa02iVR2pMPNIx2vaOAw1WnL0Vg8vNArj5sMxUw1Gx/ZHLF7IgazDmtH0aVKgwkz3LQV+QG38WSZf9uIWFBR4KZhXpGeHRrilw26mawP/xXaaKwod85Tn1ubc0IPl9FsTtZHf7gpU5wZjKP0BhMwqkJuz3lI9+Mss5TvpffKkaIfLbNIc/pIJ2rdnPups2mzdBge5kTU5cxoTsSoBeRm6N0I2LNe6BSViV/nxBDbtNU7kUQDFHs2lU79mPguL6ogOcf5ubFnjwUJ3+T69th+/bHGPTE3X0aK0eYN20DWUdG+94bVmRrmWiEaknN4C/9qAWR35Sj7fbIac76NO/IyU579fJNSFPImzfe6jz0P6xqI0lJpT7byU8LRwdd5JCkMsCQaWlSx0xDy0RFyUY8XH4WKD75nqvLDZKMuaDUEtYzBOBR0lAvUlr3TZz8yV1EMN5b3+n0c+u8HSDSvOmIzH0aTUL2HqQyXgcVUIXBL4lLXj4KMZSDV8y6IhrYoBNFFw/QI8qYyyJ+GcfyCNYmMHvlyJ/J1R3pbAlPYOl8bZRcAJTIabBU1WmzWabl/kMpgnr7dPkxARLSglGBaEf1WBWjRr1PbFJeEZQ+npvOZGc6crFKlIV9ONcnh/jaz416SalOjqbqqeZ6l6ALnrZ1jzqnvKTilrDr6YQrPqJkHaUwlOogQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	VsQTELu00lQ0s47v5u4PbuWaRBEPe27iDcN+FCpfUd12QS0RXO6EC76hlmFxRPp69vaAQXzHzNcGkWtNq0qmbXCt923WlX8NeFiCGG5v0DjlPoEFylgK2CNpTqR02gzH7tcjgc5DFY1hgEq2A+h1GXpkx1KyEwso2coLv4h6XBjtbO5hsC3VqJSC4D21cWqNlv+5fd0KedYHFdDj9DHwuKYbhMnHD35rPZ8PqrCzQsftUrY4NT7em0qqy4JalZ+r5q95fdt3/Whn7KVvgQJk5AoXZAZXnzRDKvq50LlvYTnLtfZhCfid3KaqoRfVXE307QLIkTgG9wCNO1xTAr8nouBSnODwdj263o55vLqPSdmq/xXG2WpTy8nPfO354+MGlx2/vne2UYG8FpwW2zjhOvTH1JASyszHoJGl6EJYCluKg/H5tbFIuKKznJjoSejK
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 06:10:44.9350
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 868e5b36-7f38-4116-d857-08dea9a3e0d3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD7A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6042
X-Stat-Signature: zgbhd5irykzjimx4qqbpc8ibncqzr7ps
X-Rspam-User: 
X-Rspamd-Queue-Id: 29319180005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777875051-398581
X-HE-Meta: U2FsdGVkX19ywjd+KrVFNfb9Tcwszw231e+LtW5pjsI7QHrpIrHHiEcanY5g4ZXGkgDojzIa0seGodAm1BVzAELAXlPoB+xNGKJK87N/OXBCIqdAs25cOO82kWgl+ejJQZpq/g+aWT5JKz6/+XMQw0xydVm+aIGAmohJ+C3MtpdFCkUS54ql53NAK2vrYmgY2UAURuKBH7ikwT6MDPn1EGJPuDD0qAOepTzdDkl9gTvtW4ovT8xKa6Bf84zq1Hg3ijBd1KD5K0XLE3ajR2VLAgWVIe2LAui8IVlqNpHqkOA/bXEa2Uweix5Kny+sht46vxktxYPC16u/zkCyGI7z7yxVYk9w+bNiXX6fhuBVCGLq6cq+qv1FyMg4SNbtl0vRsQUAkBgzetcqWDYLNXi6rZlDKz9BmXYwh6AvT4dIwjjvQj8oPB3yEwMzymyiS4BVQrFPGG7jgdeYa1qus+STxLfoN5ARSJAF9K9chXuqa64oC6At51jmgr9rRGq+PGfCzVgMi8+NiyI3eJ+GKjEUHR5mwXvGPwctjKSBmu9op91YidMWX0n8Kcs/1QIXWhjXkSb0AgJfY/Mb6wRXNSeXqG6Azx5ytliQzeSIH1uiYJ9OkmUwFLuLWO+gG/odQeAmvHV8wcu5Mon/O14qR/SJjYzbayPT9VNcfketSfsg9d+p7+faDqgsi/WhOaCj6ElR1Pz/t9RncxF3+c6kLKMeIpRXWHzjmYol6sWzYmhBrXU2Z2FVNhTcOaS0jx8osOOYzTIyUnfBVc5KS9LKI9dkki9AgmtMAHClGwBdGfgYZGk2UcidkWa/Mn/+BY4rF9bGnXqlVZ0/ob4tv7rzg/pdd41H/FSCCNVJ11PWdb6f4PQdqidr/izO64Z+5r9qsFd06loyf1UBuFLONhs3btFpGkGrLBXBfBmkPCX4+20IMqbL6B8EYmCk8Nc1EEWVf3tW8BkYzXLbxNFDnKjS39z
 O+QO0bl3
 KbOxwfjWpKzAMBXX+yciyt0MPixlt03HQQY7110RWQcF2MCXWfY0oUGC8JIP4bmt3RFyUJ5JRARJ2aMD86Wq0z/jcaw2MQ7AHOwFgYllaAPsR1cL0FCUgctSO1mZgogMWGjGBravUuW3UfGPTjvsqCL8zBSqUmF8Phj0XKx+vbmdEfo7ml7/20Eeuqkkxrcz22dZOo7v3ZD43TT5QEm0VQkqCyVHi621f8yN0RuIpeCZ2iZSZO3wHbBxZibjSPxO1ryktxhuiak3/xNwv4FFw+uk98SZmMJmzOX7R+bYcdCQ6LvZ4jJx3Xq6QOybqiLaMuYU11C1ip/VaG5GXVm8SpG2UTsttKV0LAWkL/Z6tr7TAxMu9VmWLCuctqUJErTbpX+W5TDVhBEzCloyppT0UODlOyEaH1sE3uP3TJK0NP2D0kgVt/P7qHQU71+RR4Ff462jJse7ndev6iVjq24R7eJanq8x0yc4adVmgF+XiLGx9jUcePYDTderbrdOu3FabyZbQmpMmjRcJWw8=
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
 include/linux/mm.h     |  35 ++------
 include/linux/mmzone.h |   4 +-
 init/Kconfig           |  13 +++
 kernel/sched/core.c    |   7 ++
 kernel/sched/debug.c   |   1 -
 kernel/sched/fair.c    | 177 ++---------------------------------------
 kernel/sched/sched.h   |   1 -
 mm/huge_memory.c       |  24 +++++-
 mm/memcontrol.c        |   6 +-
 mm/memory-tiers.c      |  15 ++--
 mm/memory.c            |  28 +++++--
 mm/mempolicy.c         |   3 -
 mm/migrate.c           |  16 +++-
 mm/pghot.c             | 134 +++++++++++++++++++++++++++++++
 mm/vmstat.c            |   2 +-
 15 files changed, 239 insertions(+), 227 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0b776907152e..3b237946b322 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2271,17 +2271,6 @@ static inline int folio_nid(const struct folio *folio)
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
@@ -2347,15 +2336,6 @@ static inline void page_cpupid_reset_last(struct page *page)
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
@@ -2366,18 +2346,12 @@ static inline void vma_set_access_pid_bit(struct vm_area_struct *vma)
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
@@ -2420,11 +2394,16 @@ static inline bool cpupid_match_pid(struct task_struct *task, int cpupid)
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
index 9577bdc575d9..b29d06168826 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -287,7 +287,7 @@ enum node_stat_item {
 #ifdef CONFIG_SWAP
 	NR_SWAPCACHE,
 #endif
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	PGPROMOTE_SUCCESS,	/* promote successfully */
 	/**
 	 * Candidate pages for promotion based on hint fault latency.  This
@@ -1566,7 +1566,7 @@ typedef struct pglist_data {
 	struct deferred_split deferred_split_queue;
 #endif
 
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	/* start time in ms of current promote rate limit period */
 	unsigned int nbp_rl_start;
 	/* number of promote candidate pages at start time of current rate limit period */
diff --git a/init/Kconfig b/init/Kconfig
index 2937c4d308ae..7624be1c739a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1027,6 +1027,19 @@ config NUMA_BALANCING_DEFAULT_ENABLED
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
index da20fb6ea25a..46ce75f00b40 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4523,6 +4523,7 @@ void set_numabalancing_state(bool enabled)
 }
 
 #ifdef CONFIG_PROC_SYSCTL
+#ifdef CONFIG_NUMA_BALANCING_TIERING
 static void reset_memory_tiering(void)
 {
 	struct pglist_data *pgdat;
@@ -4533,6 +4534,7 @@ static void reset_memory_tiering(void)
 		pgdat->nbp_th_start = jiffies_to_msecs(jiffies);
 	}
 }
+#endif
 
 static int sysctl_numa_balancing(const struct ctl_table *table, int write,
 			  void *buffer, size_t *lenp, loff_t *ppos)
@@ -4550,9 +4552,14 @@ static int sysctl_numa_balancing(const struct ctl_table *table, int write,
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
index 74c1617cf652..abf53f3071ea 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -623,7 +623,6 @@ static __init int sched_init_debug(void)
 	debugfs_create_u32("scan_period_min_ms", 0644, numa, &sysctl_numa_balancing_scan_period_min);
 	debugfs_create_u32("scan_period_max_ms", 0644, numa, &sysctl_numa_balancing_scan_period_max);
 	debugfs_create_u32("scan_size_mb", 0644, numa, &sysctl_numa_balancing_scan_size);
-	debugfs_create_u32("hot_threshold_ms", 0644, numa, &sysctl_numa_balancing_hot_threshold);
 #endif /* CONFIG_NUMA_BALANCING */
 
 	debugfs_create_file("debug", 0444, debugfs_sched, NULL, &sched_debug_fops);
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 69361c63353a..f1da4fa95598 100644
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
@@ -1612,9 +1597,6 @@ unsigned int sysctl_numa_balancing_scan_size = 256;
 /* Scan @scan_size MB every @scan_period after an initial @scan_delay in ms */
 unsigned int sysctl_numa_balancing_scan_delay = 1000;
 
-/* The page with hint page fault latency < threshold in ms is considered hot */
-unsigned int sysctl_numa_balancing_hot_threshold = MSEC_PER_SEC;
-
 struct numa_group {
 	refcount_t refcount;
 
@@ -1957,120 +1939,6 @@ static inline unsigned long group_weight(struct task_struct *p, int nid,
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
@@ -2086,41 +1954,15 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 
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
@@ -3330,15 +3172,6 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
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
index 9f63b15d309d..f176643516b5 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -3066,7 +3066,6 @@ extern unsigned int sysctl_numa_balancing_scan_delay;
 extern unsigned int sysctl_numa_balancing_scan_period_min;
 extern unsigned int sysctl_numa_balancing_scan_period_max;
 extern unsigned int sysctl_numa_balancing_scan_size;
-extern unsigned int sysctl_numa_balancing_hot_threshold;
 
 #ifdef CONFIG_SCHED_HRTICK
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..1890b1e534a4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -40,6 +40,7 @@
 #include <linux/pgalloc.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/pagewalk.h>
+#include <linux/pghot.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -2267,7 +2268,7 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	int nid = NUMA_NO_NODE;
 	int target_nid, last_cpupid;
 	pmd_t pmd, old_pmd;
-	bool writable = false;
+	bool writable = false, needs_promotion = false;
 	int flags = 0;
 
 	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
@@ -2294,11 +2295,23 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
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
+		 */
+		nid = target_nid;
+		goto out_map;
+	}
+
+	/* Balancing b/n toptier nodes, mode=NUMA_BALANCING_NORMAL */
 	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
 		flags |= TNF_MIGRATE_FAIL;
 		goto out_map;
@@ -2330,8 +2343,13 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
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
index c3d98ab41f1f..033b80ad248e 100644
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
@@ -1594,7 +1594,7 @@ static const struct memory_stat memory_stats[] = {
 	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
 	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
 	{ "pgrefill",			PGREFILL		},
-#ifdef CONFIG_NUMA_BALANCING
+#ifdef CONFIG_PGHOT
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
 #endif
 };
@@ -1646,7 +1646,7 @@ static int memcg_page_state_output_unit(int item)
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
index ea6568571131..17ea31750573 100644
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
@@ -6062,10 +6063,9 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
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
@@ -6146,6 +6146,7 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
 	int nid = NUMA_NO_NODE;
 	bool writable = false, ignore_writable = false;
 	bool pte_write_upgrade = vma_wants_manual_pte_write_upgrade(vma);
+	bool needs_promotion = false;
 	int last_cpupid;
 	int target_nid;
 	pte_t pte, old_pte;
@@ -6180,12 +6181,24 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
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
+		 * Isolation and migration are handled by pghot.
+		 */
+		nid = target_nid;
+		goto out_map;
+	}
+
+	/* Balancing b/n toptier nodes, mode=NUMA_BALANCING_NORMAL */
 	if (migrate_misplaced_folio_prepare(folio, vma, target_nid)) {
 		flags |= TNF_MIGRATE_FAIL;
 		goto out_map;
@@ -6225,8 +6238,13 @@ static vm_fault_t do_numa_page(struct vm_fault *vmf)
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
index 4e4421b22b59..aef9bb8a6cd4 100644
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
index 726d27b61a46..a468fa4f7963 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2709,8 +2709,18 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
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
@@ -2760,6 +2770,8 @@ int migrate_misplaced_folio(struct folio *folio, int node)
 #ifdef CONFIG_NUMA_BALANCING
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
+#endif
+#ifdef CONFIG_PGHOT
 		if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING)
 		    && !node_is_toptier(folio_nid(folio))
 		    && node_is_toptier(node)) {
@@ -2824,6 +2836,8 @@ int promote_misplaced_memcg_folios(struct list_head *folio_list, int node)
 #ifdef CONFIG_NUMA_BALANCING
 		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
 		count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
+#endif
+#ifdef CONFIG_PGHOT
 		mod_lruvec_state(mem_cgroup_lruvec(memcg, NODE_DATA(node)),
 				 PGPROMOTE_SUCCESS, nr_succeeded);
 #endif
diff --git a/mm/pghot.c b/mm/pghot.c
index 0b31d5917833..1f204a8613eb 100644
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
 
@@ -146,6 +171,110 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
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
@@ -223,6 +352,11 @@ static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
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


