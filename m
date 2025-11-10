Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CAC3CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:26:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89C1E8E000F; Mon, 10 Nov 2025 00:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BCD8E0002; Mon, 10 Nov 2025 00:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED388E000F; Mon, 10 Nov 2025 00:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5614A8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:26:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 23CDD4C565
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:26:56 +0000 (UTC)
X-FDA: 84093563232.21.F27E43C
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011020.outbound.protection.outlook.com [40.93.194.20])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3D99880004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:26:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AarZjJgT;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 40.93.194.20 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762752413; a=rsa-sha256;
	cv=pass;
	b=0x3VqqWsA8y3hZtnJSwpCizKoAT+2Oe2gVWIgv0O/nc2GKwJqBAtBO2HyjVEHYlsCvlUbA
	MVTQLYkwoiYt4Nc/rqF2numoYCDdD5Gk8JlmuwWRx5gW3OC5PKuR0nmWXbtWH8+1WUFFt6
	ARKcHicGw2Ja9JGAjVuXzC8wKb/XVFY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=AarZjJgT;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf30.hostedemail.com: domain of bharata@amd.com designates 40.93.194.20 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762752413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhrbxzHIppFUQyarUc+VlpeUzD6ZknPk8x64Kwb71+w=;
	b=pZaxjgXN63r69fdiWbxDykboe42clrbVW2YpkSuE2ALn2pSF0Vv8pKiZmIpvJz7asNYRZY
	xY9dmvfAuhelZ4THD8+JiwFd8fjgoeIQYFoT5aNpc36KKZGU+lcMETD9Q/GFyHy2IihHcJ
	ke3WfB5C8ISe/6r8KCKKPlIcPBSWUfM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BFz6KKNseB5g78OIB7QqGJJVHeXnuqHrkF5FAW5nsSOIPKHye1pv/mqE7peE8R5jDh40+yUtbvD/jubWaOMIAMJc3Z2VQc5FwNqReEuuS/m1LVz4/7FtzO8C+b+htk8XbYbkTVgqmGYhPyg5z93wXzIYcivWJR/HA74sjdS1BUCbwfKn2mX38G/Tb9j7xSng1QnGlp/+Xr1LImosv9xDs0ccAUPvEMwni89tVpIDYfvE7Gkd+TEzRGeCWifsdekSy6MuIvMhg01txZ/yqo0VbT7tHHH8w1r91W+yn3Txv6OsnNc2BxrgXoHCfRwKkewIDwhG48c+vh2rV4g8J7vIYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhrbxzHIppFUQyarUc+VlpeUzD6ZknPk8x64Kwb71+w=;
 b=VXzcIWZ8Q+fF6Hzd5rW1m64e/MOYjqdVkC9Y2FvsLUJfmAl5TSeWBThJj+bEtMK1NSBhsO3PnvOoMAbnXU4KNCCLZLxaZtH0sGFkWCwJf4la2Shhq4URZswcwtbGbPOE1VEPOsLuJJ/qQDpwp4Yuuz1mTYEShdbbfJlwdU0Fd5q9OvgO2Gmdkhz9Ko1JR160X7TNsNaHjYUce5OHu4CuhXBA2anuIBSC3pNAEbEBn+EtmitmGFtzAhycBms8rikt5CfXLRfVuHinO11Pva8GPtJ4S8pLKEk5nOHjQC1vIhqU2cnl9+5/gAaTglhRsgdKArapQ40BIN+5eXuQnkuGGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhrbxzHIppFUQyarUc+VlpeUzD6ZknPk8x64Kwb71+w=;
 b=AarZjJgT/xctYLHO233hTvLaIVX1grxNkwci4RKxdaXvFdbv9t1bzx++Jt5RmAISVohuJSP04Hvch1WkduxHYym0oQh0b43JalRokP5Ee3SjhlpcBEw5ZqtiF6wS2+BmjuFc0jbX58mOU4JJxta0kcV7e1oDCjxgmS8PC1TkyUA=
Received: from BLAPR05CA0023.namprd05.prod.outlook.com (2603:10b6:208:36e::25)
 by DS7PR12MB8417.namprd12.prod.outlook.com (2603:10b6:8:eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 05:26:48 +0000
Received: from BN2PEPF000044AB.namprd04.prod.outlook.com
 (2603:10b6:208:36e:cafe::60) by BLAPR05CA0023.outlook.office365.com
 (2603:10b6:208:36e::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9320.14 via Frontend Transport; Mon,
 10 Nov 2025 05:26:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044AB.mail.protection.outlook.com (10.167.243.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.13 via Frontend Transport; Mon, 10 Nov 2025 05:26:48 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 9 Nov
 2025 21:26:40 -0800
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
	<shivankg@amd.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v3 6/8] mm: mglru: generalize page table walk
Date: Mon, 10 Nov 2025 10:53:41 +0530
Message-ID: <20251110052343.208768-7-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251110052343.208768-1-bharata@amd.com>
References: <20251110052343.208768-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044AB:EE_|DS7PR12MB8417:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d78e308-f4c2-4176-934d-08de2019bee7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E0VV5tInnOo9riQ8RT97xX1zE6KyE9FrS0wTdIG1Jvfs1VDO8rMU0i5cSyHy?=
 =?us-ascii?Q?IqPBbqvnE3lTNN20zFfbe93rrBzOSxIB3x9mtipudO818gW19TPSz+4rzRjX?=
 =?us-ascii?Q?oNGOlQ/Zq1yKPP6LqN2+HVd6/JjkvmpAE7547NrTWdGXYCewwLrQ1vYzPX+Q?=
 =?us-ascii?Q?rgGGaD0bmLPci98/6nbkyuBIZx2Q3I9zlTWBZR0qYHfvITw0heQ2mLSAGUZZ?=
 =?us-ascii?Q?mzgWm4uv3rnUIe15P/uwGdPCNF7aYHgjTHFGzaJNUaUEJ4mDoodUuwQ+aIYv?=
 =?us-ascii?Q?P23amI1TU4lJ5XNbLvD9lmhDnIJtT4jwqH8TzqomaBIcsA+8ea6YBqTbDVW4?=
 =?us-ascii?Q?yMir7BvGcKNnlkIyJESG5FdXacOqF1ku/sAKi5KgSePSI8gG6WozhSSVArpf?=
 =?us-ascii?Q?DE8y7MaUBxB6j6xMJaAXxXZQqwLje6itoTt7F1DP9tXID/HpiSa7ugFnZ9ci?=
 =?us-ascii?Q?BrWWzrO8zkqGWsxCbMhulR6uxL6H0SBYb7VQLXrOoD22KtFfogy0uuMRPJGI?=
 =?us-ascii?Q?M4MHLtBawVgYIKYZ0Pe5vO10JP5bDLRYF1Qha8a2hb5M8UWUBos23jr55Ue6?=
 =?us-ascii?Q?4WnAxqyDpAmVVgfj0VSz2o29XyVbzCjVBD06zEr+Qeixq+1TnASINNkLjez2?=
 =?us-ascii?Q?efdvGK868vc9OZlrR+Ikeq94KWACbwzBPEwN1xURXxfbme3gw9ACsF5/Cy34?=
 =?us-ascii?Q?lqbVTOt/bOSvPFt8JD+kSEtEGaPWKF30xA+dpbhgtmlj6bIKoQMlexGU/oop?=
 =?us-ascii?Q?9HCoeKsg6mhgkh93QyUJHekICRaxEpOn/qZk4Jf4bQe92j8b9Uupq5Lbm5sD?=
 =?us-ascii?Q?di3KbxtHAIhe08cdp2gu0FjzYIyeAAsWAp9X5zKI/QPmdzWRrbNX3Upsrc26?=
 =?us-ascii?Q?OHLJBkerNcDkrRN/79aaufuNDXiUdTZpVjgY4V3S+BCBz9l9qgMVxf6HTGyC?=
 =?us-ascii?Q?ZrWqAhQAALsVJBMJza+BbxFiB9fnYA8lXAa+e10SZWo7yhGa7xRLh4EdLOqy?=
 =?us-ascii?Q?2YrgcLrPMm87XDmzfl5lJTcBKaP9oUn2C287jnAwblnZu7TMpwpq1udsnUHe?=
 =?us-ascii?Q?plAfdAO5qC5SI7Nd2kZoge6pbTHMjJdS5466TMGR9dfEqArhpTA5r0Wd0QeE?=
 =?us-ascii?Q?HOi0JgBzqygEzC34TWCL9QZZBZ3VrFA8p6BhMj1tk1408FDtaP8889FSTa6U?=
 =?us-ascii?Q?HVEr/ScBM+l9QY5Tsaa8uI4P8H3siAwqXYJtxHFMU7K4xKl4TDCDI2ngbHpV?=
 =?us-ascii?Q?P7bp4McUjZNB4KLcKjMPlPwdmHFd732+0mJ8wi/K3Kv7zdDBU/KYJuCHKOzF?=
 =?us-ascii?Q?PKN76PCBDzHtDiVDFqm+rA18Y68bvUH9Hws7gT6KyXbtvKxzOam8xB4cKjMV?=
 =?us-ascii?Q?MVSCRClGycBEIjW8UMCzjjDpucvR5rTQo11k5wHVH8B3Ugkcu+WaapbxC/wh?=
 =?us-ascii?Q?Qf770vBv6jouCokrm8grGLAl2i2PdLJGS0AfnAmcSg3pf3mrs8HEN/8TeRmK?=
 =?us-ascii?Q?7ZRNv1T/qWgD+pU3+xr4EqNm9zijonXn0un8Okm7ZSxi4QCMvK988gDgNbQa?=
 =?us-ascii?Q?+XN3/3O8q9UE+dEhWlA=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 05:26:48.1879
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d78e308-f4c2-4176-934d-08de2019bee7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044AB.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8417
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3D99880004
X-Stat-Signature: u4aaeqh8occ8bdjpsp93p5hxkcyotxsm
X-Rspam-User: 
X-HE-Tag: 1762752413-379871
X-HE-Meta: U2FsdGVkX193qKfMgy3fdJ4ChhRzwZLAtotqUu6WgeBJemQZViJ8m8WoLwe4W7aXfXStGWZ3TzaT2BoHjn4tTB1K8F6kKV+0A4Hgk34lqmTAH7BDR3FsIO0ZHjEkdMQJzLsAoJN8qRVygfYKO+qP0HlfXZF9HMY4XJZswWU/ZHiknpLiGmqS56E3I2VAY28fgqegrUvKFWcteDzNt6hD1VopGmwcb+pI9KjCAf4JIPIfurUORXqEZeR8RpUwbcy+fOzy0l6sfFv7LCnPV/l0pJUoGM4FNwvDl6h0FIoHPkZ936+VaKzS+Vnd0wGw8glEY+BlxHkiMN7BXhqyKg8xfgX3YWrl3Ad6mzn5vgNss2WOI6U6U6XNZh40rGuWuKo5UNBb6RHG5IRqgvZ2OOiLMdnq3J4HgDZrqMBM2lx0w9bpG6N6YqHcw3aNIIjXuR3K14D2sPOX6YdMjaDG88JqjybnJ5BOcEr/sUshxAULaitPAaI5Mwag69yZD4K3AoRaFztcdsIVdk/7eC4pRqEHfoRxt6aebIQWFOPr51+a5HQDsN1s72aHzewnyPW/Br2VymOz8MEG9iquCa7hlFkrg+nnhQXoroyUo6B87Cs83G72ihJIncEWTeBRMmnn37sTpaal3x4QydPOMwx5W0yRJiQz3bTyBJrvLk4YPST4CW7bS6xDWm9YAnl6JxsHdKYe4cTmi0aVCXKjBj9UAcYd7fJrSsen3reg8kcctxBJYIRLcu5myu8kCCYZ8FBq1SytwwpU4ep2vP7cAjtw2wRJJAKhfduRhnKAxknGoi5hfC0bYJGmWmiWj1Vu2JBrXmOChmTwl8eNFUwG4lIFM6wvGpby21jaNCOPjh7khSDNYSggbnK8N4vlPwsOcgfhS7iaARpyTtA0hgCboH1SNjVBPd7VICUyptlRRXsrDezp92inum+8vaNf2eHUJ7v2XfcNk1CalpMYm54z+P/dLfL
 dxoH08O2
 S9gYGpDE1REmn/q+AZeLbEidXqUp+WfLREjKshxSMRVZm0RxywgiEG7kC6pV+Iw0nOjUku+NMpiwr0hqgVVExd5Z64aIcyPXygtIrpswGgbT1E6s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kinsey Ho <kinseyho@google.com>

Refactor the existing MGLRU page table walking logic to make it
resumable.

Additionally, introduce two hooks into the MGLRU page table walk:
accessed callback and flush callback. The accessed callback is called
for each accessed page detected via the scanned accessed bit. The flush
callback is called when the accessed callback reports that a flush is
required. This allows for processing pages in batches for efficiency.

With a generalised page table walk, introduce a new scan function which
repeatedly scans on the same young generation and does not add a new
young generation.

Signed-off-by: Kinsey Ho <kinseyho@google.com>
Signed-off-by: Yuanchu Xie <yuanchu@google.com>
Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/mmzone.h |   5 ++
 mm/internal.h          |   4 +
 mm/vmscan.c            | 181 +++++++++++++++++++++++++++++++----------
 3 files changed, 145 insertions(+), 45 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fde851990394..421b012fb60c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -548,6 +548,8 @@ struct lru_gen_mm_walk {
 	unsigned long seq;
 	/* the next address within an mm to scan */
 	unsigned long next_addr;
+	/* called for each accessed pte/pmd */
+	bool (*accessed_cb)(unsigned long pfn);
 	/* to batch promoted pages */
 	int nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
 	/* to batch the mm stats */
@@ -555,6 +557,9 @@ struct lru_gen_mm_walk {
 	/* total batched items */
 	int batched;
 	int swappiness;
+	/* for the pmd under scanning */
+	int nr_young_pte;
+	int nr_total_pte;
 	bool force_scan;
 };
 
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..531104a96c51 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -538,6 +538,10 @@ extern unsigned long highest_memmap_pfn;
 bool folio_isolate_lru(struct folio *folio);
 void folio_putback_lru(struct folio *folio);
 extern void reclaim_throttle(pg_data_t *pgdat, enum vmscan_throttle_state reason);
+void set_task_reclaim_state(struct task_struct *task,
+				   struct reclaim_state *rs);
+void lru_gen_scan_lruvec(struct lruvec *lruvec, unsigned long seq,
+			 bool (*accessed_cb)(unsigned long), void (*flush_cb)(void));
 #ifdef CONFIG_NUMA
 int user_proactive_reclaim(char *buf,
 			   struct mem_cgroup *memcg, pg_data_t *pgdat);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..1bb637fd6e5e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -289,7 +289,7 @@ static int sc_swappiness(struct scan_control *sc, struct mem_cgroup *memcg)
 			continue;				\
 		else
 
-static void set_task_reclaim_state(struct task_struct *task,
+void set_task_reclaim_state(struct task_struct *task,
 				   struct reclaim_state *rs)
 {
 	/* Check for an overwrite */
@@ -3093,7 +3093,7 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 
 	VM_WARN_ON_ONCE(mm_state->seq + 1 < walk->seq);
 
-	if (walk->seq <= mm_state->seq)
+	if (!walk->accessed_cb && walk->seq <= mm_state->seq)
 		goto done;
 
 	if (!mm_state->head)
@@ -3519,16 +3519,14 @@ static void walk_update_folio(struct lru_gen_mm_walk *walk, struct folio *folio,
 	}
 }
 
-static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
-			   struct mm_walk *args)
+static int walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
+			   struct mm_walk *args, bool *suitable)
 {
 	int i;
 	bool dirty;
 	pte_t *pte;
 	spinlock_t *ptl;
 	unsigned long addr;
-	int total = 0;
-	int young = 0;
 	struct folio *last = NULL;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct mem_cgroup *memcg = lruvec_memcg(walk->lruvec);
@@ -3536,19 +3534,24 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
 	pmd_t pmdval;
+	int err = 0;
 
 	pte = pte_offset_map_rw_nolock(args->mm, pmd, start & PMD_MASK, &pmdval, &ptl);
-	if (!pte)
-		return false;
+	if (!pte) {
+		*suitable = false;
+		return err;
+	}
 
 	if (!spin_trylock(ptl)) {
 		pte_unmap(pte);
-		return true;
+		*suitable = true;
+		return err;
 	}
 
 	if (unlikely(!pmd_same(pmdval, pmdp_get_lockless(pmd)))) {
 		pte_unmap_unlock(pte, ptl);
-		return false;
+		*suitable = false;
+		return err;
 	}
 
 	arch_enter_lazy_mmu_mode();
@@ -3557,8 +3560,9 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		unsigned long pfn;
 		struct folio *folio;
 		pte_t ptent = ptep_get(pte + i);
+		bool do_flush;
 
-		total++;
+		walk->nr_total_pte++;
 		walk->mm_stats[MM_LEAF_TOTAL]++;
 
 		pfn = get_pte_pfn(ptent, args->vma, addr, pgdat);
@@ -3582,23 +3586,36 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
 		if (pte_dirty(ptent))
 			dirty = true;
 
-		young++;
+		walk->nr_young_pte++;
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+
+		if (!walk->accessed_cb)
+			continue;
+
+		do_flush = walk->accessed_cb(pfn);
+		if (do_flush) {
+			walk->next_addr = addr + PAGE_SIZE;
+
+			err = -EAGAIN;
+			break;
+		}
 	}
 
 	walk_update_folio(walk, last, gen, dirty);
 	last = NULL;
 
-	if (i < PTRS_PER_PTE && get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
+	if (!err && i < PTRS_PER_PTE &&
+	    get_next_vma(PMD_MASK, PAGE_SIZE, args, &start, &end))
 		goto restart;
 
 	arch_leave_lazy_mmu_mode();
 	pte_unmap_unlock(pte, ptl);
 
-	return suitable_to_scan(total, young);
+	*suitable = suitable_to_scan(walk->nr_total_pte, walk->nr_young_pte);
+	return err;
 }
 
-static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
+static int walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area_struct *vma,
 				  struct mm_walk *args, unsigned long *bitmap, unsigned long *first)
 {
 	int i;
@@ -3611,6 +3628,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	struct pglist_data *pgdat = lruvec_pgdat(walk->lruvec);
 	DEFINE_MAX_SEQ(walk->lruvec);
 	int gen = lru_gen_from_seq(max_seq);
+	int err = 0;
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3618,13 +3636,13 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	if (*first == -1) {
 		*first = addr;
 		bitmap_zero(bitmap, MIN_LRU_BATCH);
-		return;
+		return err;
 	}
 
 	i = addr == -1 ? 0 : pmd_index(addr) - pmd_index(*first);
 	if (i && i <= MIN_LRU_BATCH) {
 		__set_bit(i - 1, bitmap);
-		return;
+		return err;
 	}
 
 	pmd = pmd_offset(pud, *first);
@@ -3638,6 +3656,7 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	do {
 		unsigned long pfn;
 		struct folio *folio;
+		bool do_flush;
 
 		/* don't round down the first address */
 		addr = i ? (*first & PMD_MASK) + i * PMD_SIZE : *first;
@@ -3674,6 +3693,17 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 			dirty = true;
 
 		walk->mm_stats[MM_LEAF_YOUNG]++;
+		if (!walk->accessed_cb)
+			goto next;
+
+		do_flush = walk->accessed_cb(pfn);
+		if (do_flush) {
+			i = find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
+
+			walk->next_addr = (*first & PMD_MASK) + i * PMD_SIZE;
+			err = -EAGAIN;
+			break;
+		}
 next:
 		i = i > MIN_LRU_BATCH ? 0 : find_next_bit(bitmap, MIN_LRU_BATCH, i) + 1;
 	} while (i <= MIN_LRU_BATCH);
@@ -3684,9 +3714,10 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
 	spin_unlock(ptl);
 done:
 	*first = -1;
+	return err;
 }
 
-static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
+static int walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			   struct mm_walk *args)
 {
 	int i;
@@ -3698,6 +3729,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	unsigned long first = -1;
 	struct lru_gen_mm_walk *walk = args->private;
 	struct lru_gen_mm_state *mm_state = get_mm_state(walk->lruvec);
+	int err = 0;
 
 	VM_WARN_ON_ONCE(pud_leaf(*pud));
 
@@ -3711,6 +3743,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 	/* walk_pte_range() may call get_next_vma() */
 	vma = args->vma;
 	for (i = pmd_index(start), addr = start; addr != end; i++, addr = next) {
+		bool suitable;
 		pmd_t val = pmdp_get_lockless(pmd + i);
 
 		next = pmd_addr_end(addr, end);
@@ -3727,7 +3760,10 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			walk->mm_stats[MM_LEAF_TOTAL]++;
 
 			if (pfn != -1)
-				walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+				err = walk_pmd_range_locked(pud, addr, vma, args,
+						bitmap, &first);
+			if (err)
+				return err;
 			continue;
 		}
 
@@ -3736,33 +3772,51 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 			if (!pmd_young(val))
 				continue;
 
-			walk_pmd_range_locked(pud, addr, vma, args, bitmap, &first);
+			err = walk_pmd_range_locked(pud, addr, vma, args,
+						bitmap, &first);
+			if (err)
+				return err;
 		}
 
 		if (!walk->force_scan && !test_bloom_filter(mm_state, walk->seq, pmd + i))
 			continue;
 
+		err = walk_pte_range(&val, addr, next, args, &suitable);
+		if (err && walk->next_addr < next && first == -1)
+			return err;
+
+		walk->nr_total_pte = 0;
+		walk->nr_young_pte = 0;
+
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
-			continue;
+		if (!suitable)
+			goto next;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
 
 		/* carry over to the next generation */
 		update_bloom_filter(mm_state, walk->seq + 1, pmd + i);
+next:
+		if (err) {
+			walk->next_addr = first;
+			return err;
+		}
 	}
 
-	walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
+	err = walk_pmd_range_locked(pud, -1, vma, args, bitmap, &first);
 
-	if (i < PTRS_PER_PMD && get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
+	if (!err && i < PTRS_PER_PMD &&
+	    get_next_vma(PUD_MASK, PMD_SIZE, args, &start, &end))
 		goto restart;
+
+	return err;
 }
 
 static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 			  struct mm_walk *args)
 {
-	int i;
+	int i, err;
 	pud_t *pud;
 	unsigned long addr;
 	unsigned long next;
@@ -3780,7 +3834,9 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		err = walk_pmd_range(&val, addr, next, args);
+		if (err)
+			return err;
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
@@ -3801,40 +3857,48 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 	return -EAGAIN;
 }
 
-static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+static int try_walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
 {
+	int err;
 	static const struct mm_walk_ops mm_walk_ops = {
 		.test_walk = should_skip_vma,
 		.p4d_entry = walk_pud_range,
 		.walk_lock = PGWALK_RDLOCK,
 	};
-	int err;
 	struct lruvec *lruvec = walk->lruvec;
 
-	walk->next_addr = FIRST_USER_ADDRESS;
+	DEFINE_MAX_SEQ(lruvec);
 
-	do {
-		DEFINE_MAX_SEQ(lruvec);
+	err = -EBUSY;
 
-		err = -EBUSY;
+	/* another thread might have called inc_max_seq() */
+	if (walk->seq != max_seq)
+		return err;
 
-		/* another thread might have called inc_max_seq() */
-		if (walk->seq != max_seq)
-			break;
+	/* the caller might be holding the lock for write */
+	if (mmap_read_trylock(mm)) {
+		err = walk_page_range(mm, walk->next_addr, ULONG_MAX,
+				      &mm_walk_ops, walk);
 
-		/* the caller might be holding the lock for write */
-		if (mmap_read_trylock(mm)) {
-			err = walk_page_range(mm, walk->next_addr, ULONG_MAX, &mm_walk_ops, walk);
+		mmap_read_unlock(mm);
+	}
 
-			mmap_read_unlock(mm);
-		}
+	if (walk->batched) {
+		spin_lock_irq(&lruvec->lru_lock);
+		reset_batch_size(walk);
+		spin_unlock_irq(&lruvec->lru_lock);
+	}
 
-		if (walk->batched) {
-			spin_lock_irq(&lruvec->lru_lock);
-			reset_batch_size(walk);
-			spin_unlock_irq(&lruvec->lru_lock);
-		}
+	return err;
+}
+
+static void walk_mm(struct mm_struct *mm, struct lru_gen_mm_walk *walk)
+{
+	int err;
 
+	walk->next_addr = FIRST_USER_ADDRESS;
+	do {
+		err = try_walk_mm(mm, walk);
 		cond_resched();
 	} while (err == -EAGAIN);
 }
@@ -4046,6 +4110,33 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	return success;
 }
 
+void lru_gen_scan_lruvec(struct lruvec *lruvec, unsigned long seq,
+			 bool (*accessed_cb)(unsigned long), void (*flush_cb)(void))
+{
+	struct lru_gen_mm_walk *walk = current->reclaim_state->mm_walk;
+	struct mm_struct *mm = NULL;
+
+	walk->lruvec = lruvec;
+	walk->seq = seq;
+	walk->accessed_cb = accessed_cb;
+	walk->swappiness = MAX_SWAPPINESS;
+
+	do {
+		int err = -EBUSY;
+
+		iterate_mm_list(walk, &mm);
+		if (!mm)
+			break;
+
+		walk->next_addr = FIRST_USER_ADDRESS;
+		do {
+			err = try_walk_mm(mm, walk);
+			cond_resched();
+			flush_cb();
+		} while (err == -EAGAIN);
+	} while (mm);
+}
+
 static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
 			       int swappiness, bool force_scan)
 {
-- 
2.34.1


