Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1434DCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 14:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 702B58E001D; Wed, 10 Sep 2025 10:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B3E18E0011; Wed, 10 Sep 2025 10:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554808E001D; Wed, 10 Sep 2025 10:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 389F58E0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:49:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C1901A0947
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:49:14 +0000 (UTC)
X-FDA: 83873623428.26.E7081FC
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3954C16000A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 14:49:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="oyAZryh/";
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 40.107.93.67 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757515751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFUXSCHA/BwKc7XP9PNRz/2krK6hKSkQckMDIabpVlk=;
	b=sMLPR0BDi4vVKzGTvZOmUbd84hTrpZHWBwwqQ5wpJmdQH/wWFCqjAiWwPXPPhC4WrsQz1O
	xbwGKGZskc61XQhOFi6KlFnh77vRKMnKmU7tD3Nd2uBTa7WqwcurghmkkmjY03xr6ZSo25
	cW9/acn1UO4u8kwZhBM3R5/AczLGqd0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="oyAZryh/";
	spf=pass (imf08.hostedemail.com: domain of bharata@amd.com designates 40.107.93.67 as permitted sender) smtp.mailfrom=bharata@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757515751; a=rsa-sha256;
	cv=pass;
	b=QCBpA0ewmw1fTW5v0myAegDxU5Vs1l71meUeuRDXkFoZ2MQ3iEeOSzPOFCfuZO++Mg8tlg
	C7JRABle1dml8SRcuu+Sqr6nIX3NsDM4/4gKwFA4+pCghZ4dR7XaHC6ZM+SCk1dVHze5zi
	q8kiH7ldwomUhSKCv4eAhNsYhK7ZNuo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3UM9ocRGhjq8xWGRIfg7or4yarSHsHju0iIH9WsN5GRfR7lCEmmXtRLMUCRV7XeJu/V6lwpK1sAjNL2IFevIx2vgJT0To/3JUeOnOyFjnHj+2DHnidIrl+rykYwTBtxA1yO9ezRdPNCJxQXVKGHDiexR/SMcLJo6rGSlU6aGsLCuy3M0S+UbHXYRGMPMNKsQzVn8uDTtacLRvUFxX9XvqQQ5EZvJS35Y96ALx8dP/qDv6SXzuDg72unU9YN9gs1QqqMzQVsjh1tG8+KqMbuyPgvdG/2psUlF7yzubXBLN686sJFsAvjYDNN1DrIcCD3bZUFxLAd9cY8zMyxsWNBTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PFUXSCHA/BwKc7XP9PNRz/2krK6hKSkQckMDIabpVlk=;
 b=fEapk74Pl9Ln82JGU0g7ke/Wm/F5a4xU5LUbNqVdve9AcfdoV4fp4OF/qk9itIRbbqJuek2grtdC51slicehDg3NlOpjAs1Tpe9vXv04KSMi5VnwnnGyRDCogUJT5m7dQDlLsV7nVCEoXHc+BmpCEEPmvfB2+Y0D9rRIXbuadk0qiwrh0sIGbEWLHFQ51nVggSi7jdp0tigSIHIymZigIpwkiFhCAfEvD/sASJfseFfgONtA5swmtgKvLQuxfBnmcDfLgPucI3jHiZJssJfwnLdMVYvHg+MJVVzU5i55QvrMusslXQ84iuUsvRv/t9T2TUQqPwKHR7BZuieXP87Tig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PFUXSCHA/BwKc7XP9PNRz/2krK6hKSkQckMDIabpVlk=;
 b=oyAZryh/uEJSyV69VgtV4YSI6zCYJBY/97S9ckoG9NYe6t86dgXyFrIhsHn8sG08lzNjiL/okbTcAvQ4P/Yn8eHFxkBaKPVeqzm++Sve77dL8/N3drZ4pR6RoNeVKdUKjOB95ZlF/HpRlo9j+ZIOFKwiJ8MoD++Ex/G7W0n0N5c=
Received: from SA9P223CA0007.NAMP223.PROD.OUTLOOK.COM (2603:10b6:806:26::12)
 by LV8PR12MB9084.namprd12.prod.outlook.com (2603:10b6:408:18e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 14:49:08 +0000
Received: from SA2PEPF0000150B.namprd04.prod.outlook.com
 (2603:10b6:806:26:cafe::6b) by SA9P223CA0007.outlook.office365.com
 (2603:10b6:806:26::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.23 via Frontend Transport; Wed,
 10 Sep 2025 14:49:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF0000150B.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 14:49:07 +0000
Received: from BLR-L-BHARARAO.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 07:48:56 -0700
From: Bharata B Rao <bharata@amd.com>
To: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
CC: <Jonathan.Cameron@huawei.com>, <dave.hansen@intel.com>,
	<gourry@gourry.net>, <hannes@cmpxchg.org>, <mgorman@techsingularity.net>,
	<mingo@redhat.com>, <peterz@infradead.org>, <raghavendra.kt@amd.com>,
	<riel@surriel.com>, <rientjes@google.com>, <sj@kernel.org>,
	<weixugc@google.com>, <willy@infradead.org>, <ying.huang@linux.alibaba.com>,
	<ziy@nvidia.com>, <dave@stgolabs.net>, <nifan.cxl@gmail.com>,
	<xuezhengchu@huawei.com>, <yiannis@zptcorp.com>, <akpm@linux-foundation.org>,
	<david@redhat.com>, <byungchul@sk.com>, <kinseyho@google.com>,
	<joshua.hahnjy@gmail.com>, <yuanchu@google.com>, <balbirs@nvidia.com>,
	<alok.rathore@samsung.com>, Bharata B Rao <bharata@amd.com>
Subject: [RFC PATCH v2 3/8] mm: Hot page tracking and promotion
Date: Wed, 10 Sep 2025 20:16:48 +0530
Message-ID: <20250910144653.212066-4-bharata@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250910144653.212066-1-bharata@amd.com>
References: <20250910144653.212066-1-bharata@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF0000150B:EE_|LV8PR12MB9084:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e7c9bee-555d-4471-61c9-08ddf079322a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lu9lR2dyc+FZxA8VDubSTfWmTOLO3RpaFTYbYvv5vlB3/L8J0Dk69hbHc6k2?=
 =?us-ascii?Q?dKOT90epbEDYAGSK376H2ySIeGXG2FbchdKMsp2jMMofVF9CJuhsijeTCh23?=
 =?us-ascii?Q?hOpGhCovBlkM5Q0ACbHNxu81tNV60zMC24ggas7QMm8pLjODvBUi1tloJUa3?=
 =?us-ascii?Q?5grBJAzjI8DjT2W651qLn5iqd8DYiuOVkKja5hH/svVG2MvzcXUI6o206GhA?=
 =?us-ascii?Q?x3Hh8ckgCeib/XVwkR9L7A4w09y4GJJUIJojG1BOSdR5LlnbW2f33RUvG47c?=
 =?us-ascii?Q?X6hPZyQrD7oNcf9MNHgqVOAc71pu4NOvRp6e/4omXR7V6tTBuvcP/JcZM8oG?=
 =?us-ascii?Q?SQvd+LJ1aYvyLJqnOP3dG6xcZBuVxB2/PnTDwNyn12tS8QMrmPmjyEWvcIJj?=
 =?us-ascii?Q?eNWsWKlE+KTDv/qCUKbYPV2rKMHU3IOdJBJVVRGn9stdecbk/uudVNYl7F/f?=
 =?us-ascii?Q?Jww+NLtYTXACFlLUrqARSWb0uoTAnzqqhA5O+RrainfssWyzsyIwgLyOISwU?=
 =?us-ascii?Q?GjyUYydRT2nHGeAabhnVv1LgI6lPhys0LGDNCgVFYGc+LKJZ6v4K+vV9G7kB?=
 =?us-ascii?Q?eN2Jp7CKcolOsRGE5EZHDEg6QG1zeJ73qIiHTQt1eNcEEwDpnCAoX3BWEn4L?=
 =?us-ascii?Q?/5SPq2SbM6ZZ0gEPBvmH4EkGamzQIprSdnO7pdYDw6ylb4bG5Ww43zMJ92Xb?=
 =?us-ascii?Q?SttoaeHjonRxUnqgMBb+sPh6jbx27GxmZkk8FpRtHwW/uKoE9Zx8SZwIqXlr?=
 =?us-ascii?Q?/2dyfzObnA0tgSzkaL/WcHhdhUMREbNER2lg3oAItjTgdEoLtluAox01amGs?=
 =?us-ascii?Q?WqQeIM+lKokTatIu9hOSWBHeIZ5kBb+19jGlo2w0CREkGbp37Hjm6p7rSUq2?=
 =?us-ascii?Q?SxJsT8xNmVhNuwvMAVKAPogNDjjDbMDLR0extrZ+zYthVj1iuNCCPB0PxUsQ?=
 =?us-ascii?Q?9khSHegf94z4WnDjXyhH4XXmQtvnBWdZrKVawOJS3ozqhUu0st6QW8WqyHGB?=
 =?us-ascii?Q?TUXNW+tN0w3gRM+QwmuakB1ZtAlYC5L2J9scy3Dcs0Y9yDQJo5L1+ovQ1SC/?=
 =?us-ascii?Q?ye0tZpLl9cYRdWRxn4Jbl5bR1Y2fBKfmLxpRXhAmCAd5wkUTYrcQJO+kuIeG?=
 =?us-ascii?Q?Mu/SRmNbfrTyPl7BQ/DKNQQ0aPQZA5gG3ZZAfMgIFbhKbj/DCUh+Jk8ncJC5?=
 =?us-ascii?Q?WuTC4B9gBr7K7T2M+xdJWk5nvHi2XZQL9cfYH+Q353oH/xoq/CfmFXsfQ3fV?=
 =?us-ascii?Q?eUetM0vE0xtcBA6wNKynrOvAfWG0XXHul/d8TkuBwdcNVtLvePkdK0tH6fxR?=
 =?us-ascii?Q?+Z7G3uw/rW5GzB1iT6TRblP/S2PIb0Subj3nnHgo1rFy6mcQatOlpAkqGAtE?=
 =?us-ascii?Q?cqdn4nFhFN6JFG79BzKdprm4PtNKuqn8vIQnFNWxXYW02A8YjraBs3BcdSas?=
 =?us-ascii?Q?/ZosI9mF2SqF3ImuekK0WTi0MCIthM2mjxOqN34xYEuBZDDQh39hH8mJeKZB?=
 =?us-ascii?Q?V9gCCT+3/7ruxGjXS1uunvoGbkJaEg7KN+MG?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 14:49:07.9143
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e7c9bee-555d-4471-61c9-08ddf079322a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF0000150B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9084
X-Rspamd-Queue-Id: 3954C16000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: rb6a1d8631npbiu6u8yk7zm81qefdtki
X-HE-Tag: 1757515750-668174
X-HE-Meta: U2FsdGVkX1+RB5/8aajXeR+mA65YhKP4J7WGpU67MQe6a+AiVKWqbR05RJV+YvTgD83daw+L8hD/64tF4RjWu5FPmPgASmVhv6ofmSNCPsFNr6PVbfNbh+mF0YCg5pAVyyrhfENPxLwT6V1ZGRqS85huse4URpv1YbPe9giHAZWF6MaQRAUgkPAuxWeidY0G2RqHdG4e0inRstoFp98XrApk8ocHdX9PeuvthhXtVJ83B4YVgw4e2dRW+kkFZxqAdprjm0vkNCK/hFwjScRHmye9Izg3qYAaBDf3Ti/poSS/aL2xk2RLo81n2f49nc7xl6wO+kQFNLjrHBlu4brgxZVMWoT7MtPVOMQ9HI1tvN1KEkB92EVpPlPvcr8olO2GK5TrN0B5/MjQTxif3VHLm/S8jUudzdEpBKjAaPp7DH4764YsLGFsxrVYDCtvJXvPQDVtTT3zooOKTCJtHePCok326xgpQDpZ5uq11pakvdqquCNnyCh+LXSeADOAyaIzffvcGN5BmrEGuZnG84QMpJQu+GuUSvyQHdQyQeHTK2s3lfp16tieHi0JcQwtETWSZ9cONaR5U1hClRJSA0z3ALK5xSUFL3aTB4S8xlLLFfZNy/PtJC2AqzzYV2QAY8cpE9PQQVRe3X6VKhWkLC2/Ct708/wVpqI8yMMHr/VEl8/wIPf4qnrnNJ+Ap4J0JyJCjLg4Wi11HXxHdeS4cOi+dZNz3tLO8isyx3x3VG6f0neaBNEStLp5LpIbzLC/rLkVQ4A+AVt3ThsBuHjFlgDS0bpMP1CzQy/nqdjuWc7TTuTzJ2MGhdFu5n0VV1t5JhRFSyNj+ItG06f2lNuzK7JjHO4pEJStfD8eKiS5VbtsdLO6Y65DUcY5a0p0Hw4cxNl9W/moKG/3BC/qWOr5kmLveHDo7W27DEEpefHoCbPEntuk2dCkkxw5uJqMyw6U722PSI8hfBxYFFNEVZEaADI
 beBu+yfJ
 /R41tM2POir+5EcjdzDItlM8zEa7KcPu4qEH92xbJBeK5e2wKJnWFDL2VeW4JQnVTL2ZE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This introduces a sub-system for collecting memory access
information from different sources. It maintains the hotness
information based on the access history and time of access.

Additionally, it provides per-lowertier-node kernel threads
(named kpromoted) that periodically promote the pages that
are eligible for promotion.

Sub-systems that generate hot page access info can report that
using this API:

int pghot_record_access(u64 pfn, int nid, int src,
			unsigned long time)

@pfn: The PFN of the memory accessed
@nid: The accessing NUMA node ID
@src: The temperature source (sub-system) that generated the
      access info
@time: The access time in jiffies

Some temperature sources may not provide the nid from which
the page was accessed. This is true for sources that use
page table scanning for PTE Accessed bit. For such sources,
the default toptier node to which such pages should be promoted
is hard coded.

Also, the access time provided some sources may at best be
considered approximate. This is especially true for hot pages
detected by PTE A bit scanning.

The hot PFN records are stored in hash lists hashed by PFN value.
The PFN records that are categorized as hot enough to be promoted
are maintained in a per-lowertier-node max heap from which
kpromoted extracts and promotes them.

Signed-off-by: Bharata B Rao <bharata@amd.com>
---
 include/linux/mmzone.h        |  11 +
 include/linux/pghot.h         |  96 +++++++
 include/linux/vm_event_item.h |   9 +
 mm/Kconfig                    |  11 +
 mm/Makefile                   |   1 +
 mm/mm_init.c                  |  10 +
 mm/pghot.c                    | 524 ++++++++++++++++++++++++++++++++++
 mm/vmstat.c                   |   9 +
 8 files changed, 671 insertions(+)
 create mode 100644 include/linux/pghot.h
 create mode 100644 mm/pghot.c

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0c5da9141983..f7094babed10 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1349,6 +1349,10 @@ struct memory_failure_stats {
 };
 #endif
 
+#ifdef CONFIG_PGHOT
+#include <linux/pghot.h>
+#endif
+
 /*
  * On NUMA machines, each NUMA node would have a pg_data_t to describe
  * it's memory layout. On UMA machines there is a single pglist_data which
@@ -1497,6 +1501,13 @@ typedef struct pglist_data {
 #ifdef CONFIG_MEMORY_FAILURE
 	struct memory_failure_stats mf_stats;
 #endif
+#ifdef CONFIG_PGHOT
+	struct task_struct *kpromoted;
+	wait_queue_head_t kpromoted_wait;
+	struct pghot_info **phi_buf;
+	struct max_heap heap;
+	spinlock_t heap_lock;
+#endif
 } pg_data_t;
 
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
diff --git a/include/linux/pghot.h b/include/linux/pghot.h
new file mode 100644
index 000000000000..1443643aab13
--- /dev/null
+++ b/include/linux/pghot.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KPROMOTED_H
+#define _LINUX_KPROMOTED_H
+
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/workqueue_types.h>
+
+/* Page hotness temperature sources */
+enum pghot_src {
+	PGHOT_HW_HINTS,
+	PGHOT_PGTABLE_SCAN,
+	PGHOT_HINT_FAULT,
+};
+
+#ifdef CONFIG_PGHOT
+
+#define KPROMOTED_FREQ_WINDOW	(5 * MSEC_PER_SEC)
+
+/* 2 accesses within a window will make the page a promotion candidate */
+#define KPROMOTED_FREQ_THRESHOLD	2
+
+#define PGHOT_FREQ_BITS		3
+#define PGHOT_NID_BITS		10
+#define PGHOT_TIME_BITS		19
+
+#define PGHOT_FREQ_MAX		(1 << PGHOT_FREQ_BITS)
+#define PGHOT_NID_MAX		(1 << PGHOT_NID_BITS)
+
+/*
+ * last_update is stored in 19 bits which can represent up to
+ * 8.73s with HZ=1000
+ */
+#define PGHOT_TIME_MASK		GENMASK_U32(PGHOT_TIME_BITS - 1, 0)
+
+/*
+ * The following two defines control the number of hash lists
+ * that are maintained for tracking PFN accesses.
+ */
+#define PGHOT_HASH_PCT		50	/* % of lower tier memory pages to track */
+#define PGHOT_HASH_ENTRIES	1024	/* Number of entries per list, ideal case */
+
+/*
+ * Percentage of hash entries that can reside in heap as migrate-ready
+ * candidates
+ */
+#define PGHOT_HEAP_PCT		25
+
+#define KPROMOTED_MIGRATE_BATCH	1024
+
+/*
+ * If target NID isn't available, kpromoted promotes to node 0
+ * by default.
+ *
+ * TODO: Need checks to validate that default node is indeed
+ * present and is a toptier node.
+ */
+#define KPROMOTED_DEFAULT_NODE	0
+
+struct pghot_info {
+	unsigned long pfn;
+
+	/*
+	 * The following three fundamental parameters
+	 * required to track the hotness of page/PFN are
+	 * packed within a single u32.
+	 */
+	u32 frequency:PGHOT_FREQ_BITS; /* Number of accesses within current window */
+	u32 nid:PGHOT_NID_BITS; /* Most recent access from this node */
+	u32 last_update:PGHOT_TIME_BITS; /* Most recent access time */
+
+	struct hlist_node hnode;
+	size_t heap_idx; /* Position in max heap for quick retreival */
+};
+
+struct max_heap {
+	size_t nr;
+	size_t size;
+	struct pghot_info **data;
+	DECLARE_FLEX_ARRAY(struct pghot_info *, preallocated);
+};
+
+/*
+ * The wakeup interval of kpromoted threads
+ */
+#define KPROMOTE_DELAY	20	/* 20ms */
+
+int pghot_record_access(u64 pfn, int nid, int src, unsigned long now);
+#else
+static inline int pghot_record_access(u64 pfn, int nid, int src,
+				      unsigned long now)
+{
+	return 0;
+}
+#endif /* CONFIG_PGHOT */
+#endif /* _LINUX_KPROMOTED_H */
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 9e15a088ba38..a996fa9df785 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -186,6 +186,15 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+		PGHOT_RECORDED_ACCESSES,
+		PGHOT_RECORD_HWHINTS,
+		PGHOT_RECORD_PGTSCANS,
+		PGHOT_RECORD_HINTFAULTS,
+		PGHOT_RECORDS_HASH,
+		PGHOT_RECORDS_HEAP,
+		KPROMOTED_RIGHT_NODE,
+		KPROMOTED_NON_LRU,
+		KPROMOTED_DROPPED,
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/Kconfig b/mm/Kconfig
index e443fe8cd6cf..8b236eb874cf 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1381,6 +1381,17 @@ config PT_RECLAIM
 
 	  Note: now only empty user PTE page table pages will be reclaimed.
 
+config PGHOT
+	bool "Hot page tracking and promotion"
+	def_bool y
+	depends on NUMA && MIGRATION && MMU
+	select MIN_HEAP
+	help
+	  A sub-system to track page accesses in lower tier memory and
+	  maintain hot page information. Promotes hot pages from lower
+	  tiers to top tier by using the memory access information provided
+	  by various sources. Asynchronous promotion is done by per-node
+	  kernel threads.
 
 source "mm/damon/Kconfig"
 
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..ecdd5241bea8 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
 obj-$(CONFIG_EXECMEM) += execmem.o
 obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
 obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
+obj-$(CONFIG_PGHOT) += pghot.o
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 5c21b3af216b..f7992be3ff7f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1402,6 +1402,15 @@ static void pgdat_init_kcompactd(struct pglist_data *pgdat)
 static void pgdat_init_kcompactd(struct pglist_data *pgdat) {}
 #endif
 
+#ifdef CONFIG_PGHOT
+static void pgdat_init_kpromoted(struct pglist_data *pgdat)
+{
+	init_waitqueue_head(&pgdat->kpromoted_wait);
+}
+#else
+static void pgdat_init_kpromoted(struct pglist_data *pgdat) {}
+#endif
+
 static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 {
 	int i;
@@ -1411,6 +1420,7 @@ static void __meminit pgdat_init_internals(struct pglist_data *pgdat)
 
 	pgdat_init_split_queue(pgdat);
 	pgdat_init_kcompactd(pgdat);
+	pgdat_init_kpromoted(pgdat);
 
 	init_waitqueue_head(&pgdat->kswapd_wait);
 	init_waitqueue_head(&pgdat->pfmemalloc_wait);
diff --git a/mm/pghot.c b/mm/pghot.c
new file mode 100644
index 000000000000..9f7581818b8f
--- /dev/null
+++ b/mm/pghot.c
@@ -0,0 +1,524 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Maintains information about hot pages from slower tier nodes and
+ * promotes them.
+ *
+ * Info about accessed pages are stored in hash lists indexed by PFN.
+ * Info about pages that are hot enough to be promoted are stored in
+ * a per-toptier-node max_heap.
+ *
+ * kpromoted is a kernel thread that runs on each toptier node and
+ * promotes pages from max_heap.
+ */
+#include <linux/pghot.h>
+#include <linux/kthread.h>
+#include <linux/mmzone.h>
+#include <linux/migrate.h>
+#include <linux/memory-tiers.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/vmalloc.h>
+#include <linux/hashtable.h>
+#include <linux/min_heap.h>
+
+struct pghot_hash {
+	struct hlist_head hash;
+	spinlock_t lock;
+};
+
+static struct pghot_hash *phi_hash;
+static int phi_hash_order;
+static int phi_heap_entries;
+static struct kmem_cache *phi_cache __ro_after_init;
+static bool kpromoted_started __ro_after_init;
+
+static unsigned int sysctl_pghot_freq_window = KPROMOTED_FREQ_WINDOW;
+
+#ifdef CONFIG_SYSCTL
+static const struct ctl_table pghot_sysctls[] = {
+	{
+		.procname	= "pghot_promote_freq_window_ms",
+		.data		= &sysctl_pghot_freq_window,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+	},
+};
+#endif
+static bool phi_heap_less(const void *lhs, const void *rhs, void *args)
+{
+	return (*(struct pghot_info **)lhs)->frequency >
+		(*(struct pghot_info **)rhs)->frequency;
+}
+
+static void phi_heap_swp(void *lhs, void *rhs, void *args)
+{
+	struct pghot_info **l = (struct pghot_info **)lhs;
+	struct pghot_info **r = (struct pghot_info **)rhs;
+	int lindex = l - (struct pghot_info **)args;
+	int rindex = r - (struct pghot_info **)args;
+	struct pghot_info *tmp = *l;
+
+	*l = *r;
+	*r = tmp;
+
+	(*l)->heap_idx = lindex;
+	(*r)->heap_idx = rindex;
+}
+
+static const struct min_heap_callbacks phi_heap_cb = {
+	.less = phi_heap_less,
+	.swp = phi_heap_swp,
+};
+
+static void phi_heap_update_entry(struct max_heap *phi_heap, struct pghot_info *phi)
+{
+	int orig_idx = phi->heap_idx;
+
+	min_heap_sift_up(phi_heap, phi->heap_idx, &phi_heap_cb,
+			 phi_heap->data);
+	if (phi_heap->data[phi->heap_idx]->heap_idx == orig_idx)
+		min_heap_sift_down(phi_heap, phi->heap_idx,
+				   &phi_heap_cb, phi_heap->data);
+}
+
+static bool phi_heap_insert(struct max_heap *phi_heap, struct pghot_info *phi)
+{
+	if (phi_heap->nr >= phi_heap_entries)
+		return false;
+
+	phi->heap_idx = phi_heap->nr;
+	min_heap_push(phi_heap, &phi, &phi_heap_cb, phi_heap->data);
+
+	return true;
+}
+
+static bool phi_is_pfn_hot(struct pghot_info *phi)
+{
+	struct page *page = pfn_to_online_page(phi->pfn);
+	unsigned long now = jiffies;
+	struct folio *folio;
+
+	if (!page || is_zone_device_page(page))
+		return false;
+
+	folio = page_folio(page);
+	if (!folio_test_lru(folio)) {
+		count_vm_event(KPROMOTED_NON_LRU);
+		return false;
+	}
+	if (folio_nid(folio) == phi->nid) {
+		count_vm_event(KPROMOTED_RIGHT_NODE);
+		return false;
+	}
+
+	return true;
+}
+
+static struct folio *kpromoted_isolate_folio(struct pghot_info *phi)
+{
+	struct page *page = pfn_to_page(phi->pfn);
+	struct folio *folio;
+
+	if (!page)
+		return NULL;
+
+	folio = page_folio(page);
+	if (migrate_misplaced_folio_prepare(folio, NULL, phi->nid))
+		return NULL;
+	else
+		return folio;
+}
+
+static struct pghot_info *phi_alloc(unsigned long pfn)
+{
+	struct pghot_info *phi;
+
+	phi = kmem_cache_zalloc(phi_cache, GFP_NOWAIT);
+	if (!phi)
+		return NULL;
+
+	phi->pfn = pfn;
+	phi->heap_idx = -1;
+	return phi;
+}
+
+static inline void phi_free(struct pghot_info *phi)
+{
+	kmem_cache_free(phi_cache, phi);
+}
+
+static int phi_heap_extract(pg_data_t *pgdat, int batch_count, int freq_th,
+			    struct list_head *migrate_list, int *count)
+{
+	spinlock_t *phi_heap_lock = &pgdat->heap_lock;
+	struct max_heap *phi_heap = &pgdat->heap;
+	int max_retries = 10;
+	int bkt, i = 0;
+
+	if (batch_count < 0 || !migrate_list || !count || freq_th < 1 ||
+	    freq_th > KPROMOTED_FREQ_THRESHOLD)
+		return -EINVAL;
+
+	*count = 0;
+	for (i = 0; i < batch_count; i++) {
+		struct pghot_info *top = NULL;
+		bool should_continue = false;
+		struct folio *folio;
+		int retries = 0;
+
+		while (retries < max_retries) {
+			spin_lock(phi_heap_lock);
+			if (phi_heap->nr > 0 && phi_heap->data[0]->frequency >= freq_th) {
+				should_continue = true;
+				bkt = hash_min(phi_heap->data[0]->pfn, phi_hash_order);
+				top = phi_heap->data[0];
+			}
+			spin_unlock(phi_heap_lock);
+
+			if (!should_continue)
+				goto done;
+
+			spin_lock(&phi_hash[bkt].lock);
+			spin_lock(phi_heap_lock);
+			if (phi_heap->nr == 0 || phi_heap->data[0] != top ||
+			    phi_heap->data[0]->frequency < freq_th) {
+				spin_unlock(phi_heap_lock);
+				spin_unlock(&phi_hash[bkt].lock);
+				retries++;
+				continue;
+			}
+
+			top = phi_heap->data[0];
+			hlist_del_init(&top->hnode);
+
+			phi_heap->nr--;
+			if (phi_heap->nr > 0) {
+				phi_heap->data[0] = phi_heap->data[phi_heap->nr];
+				phi_heap->data[0]->heap_idx = 0;
+				min_heap_sift_down(phi_heap, 0, &phi_heap_cb,
+						   phi_heap->data);
+			}
+
+			spin_unlock(phi_heap_lock);
+			spin_unlock(&phi_hash[bkt].lock);
+
+			if (!phi_is_pfn_hot(top)) {
+				count_vm_event(KPROMOTED_DROPPED);
+				goto skip;
+			}
+
+			folio = kpromoted_isolate_folio(top);
+			if (folio) {
+				list_add(&folio->lru, migrate_list);
+				(*count)++;
+			}
+skip:
+			phi_free(top);
+			break;
+		}
+		if (retries >= max_retries) {
+			pr_warn("%s: Too many retries\n", __func__);
+			break;
+		}
+
+	}
+done:
+	return 0;
+}
+
+static void phi_heap_add_or_adjust(struct pghot_info *phi)
+{
+	pg_data_t *pgdat = NODE_DATA(phi->nid);
+	struct max_heap *phi_heap = &pgdat->heap;
+
+	spin_lock(&pgdat->heap_lock);
+	if (phi->heap_idx >= 0 && phi->heap_idx < phi_heap->nr &&
+	    phi_heap->data[phi->heap_idx] == phi) {
+		/* Entry exists in heap */
+		if (phi->frequency < KPROMOTED_FREQ_THRESHOLD) {
+			/* Below threshold, remove from the heap */
+			phi_heap->nr--;
+			if (phi->heap_idx < phi_heap->nr) {
+				phi_heap->data[phi->heap_idx] =
+					phi_heap->data[phi_heap->nr];
+				phi_heap->data[phi->heap_idx]->heap_idx =
+					phi->heap_idx;
+				min_heap_sift_down(phi_heap, phi->heap_idx,
+						   &phi_heap_cb, phi_heap->data);
+			}
+			phi->heap_idx = -1;
+
+		} else {
+			/* Update position in heap */
+			phi_heap_update_entry(phi_heap, phi);
+		}
+	} else if (phi->frequency >= KPROMOTED_FREQ_THRESHOLD) {
+		/*
+		 * Add to the heap. If heap is full we will have
+		 * to wait for the next access reporting to elevate
+		 * it to heap.
+		 */
+		if (phi_heap_insert(phi_heap, phi))
+			count_vm_event(PGHOT_RECORDS_HEAP);
+	}
+	spin_unlock(&pgdat->heap_lock);
+}
+
+static struct pghot_info *phi_lookup(unsigned long pfn, int bkt)
+{
+	struct pghot_info *phi;
+
+	hlist_for_each_entry(phi, &phi_hash[bkt].hash, hnode) {
+		if (phi->pfn == pfn)
+			return phi;
+	}
+	return NULL;
+}
+
+/*
+ * Called by subsystems that generate page hotness/access information.
+ *
+ *  @pfn: The PFN of the memory accessed
+ *  @nid: The accessing NUMA node ID
+ *  @src: The temperature source (sub-system) that generated the
+ *        access info
+ *  @time: The access time in jiffies
+ *
+ * Maintains the access records per PFN, classifies them as
+ * hot based on subsequent accesses and finally hands over
+ * them to kpromoted for migration.
+ */
+int pghot_record_access(u64 pfn, int nid, int src, unsigned long now)
+{
+	struct pghot_info *phi;
+	struct page *page;
+	struct folio *folio;
+	int bkt;
+	bool new_entry = false, new_window = false;
+	u32 cur_time = now & PGHOT_TIME_MASK;
+
+	if (!kpromoted_started)
+		return -EINVAL;
+
+	if (nid >= PGHOT_NID_MAX)
+		return -EINVAL;
+
+	count_vm_event(PGHOT_RECORDED_ACCESSES);
+
+	switch (src) {
+	case PGHOT_HW_HINTS:
+		count_vm_event(PGHOT_RECORD_HWHINTS);
+		break;
+	case PGHOT_PGTABLE_SCAN:
+		count_vm_event(PGHOT_RECORD_PGTSCANS);
+		break;
+	case PGHOT_HINT_FAULT:
+		count_vm_event(PGHOT_RECORD_HINTFAULTS);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * Record only accesses from lower tiers.
+	 */
+	if (node_is_toptier(pfn_to_nid(pfn)))
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
+	if (!folio_test_lru(folio))
+		return 0;
+
+	bkt = hash_min(pfn, phi_hash_order);
+	spin_lock(&phi_hash[bkt].lock);
+	phi = phi_lookup(pfn, bkt);
+	if (!phi) {
+		phi = phi_alloc(pfn);
+		if (!phi)
+			goto out;
+		new_entry = true;
+	}
+
+	/*
+	 * If the previous access was beyond the threshold window
+	 * start frequency tracking afresh.
+	 */
+	if (((cur_time - phi->last_update) > msecs_to_jiffies(sysctl_pghot_freq_window)) ||
+	    (nid != NUMA_NO_NODE && phi->nid != nid))
+		new_window = true;
+
+	if (new_entry || new_window) {
+		/* New window */
+		phi->frequency = 1; /* TODO: Factor in the history */
+	} else if (phi->frequency < PGHOT_FREQ_MAX)
+		phi->frequency++;
+	phi->last_update = cur_time;
+	phi->nid = (nid == NUMA_NO_NODE) ? KPROMOTED_DEFAULT_NODE : nid;
+
+	if (new_entry) {
+		/* Insert the new entry into hash table */
+		hlist_add_head(&phi->hnode, &phi_hash[bkt].hash);
+		count_vm_event(PGHOT_RECORDS_HASH);
+	} else {
+		/* Add/update the position in heap */
+		phi_heap_add_or_adjust(phi);
+	}
+out:
+	spin_unlock(&phi_hash[bkt].lock);
+	return 0;
+}
+
+/*
+ * Extract the hot page records and batch-migrate the
+ * hot pages.
+ */
+static void kpromoted_migrate(pg_data_t *pgdat)
+{
+	int count, ret;
+	LIST_HEAD(migrate_list);
+
+	/*
+	 * Extract the top N elements from the heap that match
+	 * the requested hotness threshold.
+	 *
+	 * PFNs ineligible from migration standpoint are removed
+	 * from the heap and hash.
+	 *
+	 * Folios eligible for migration are isolated and returned
+	 * in @migrate_list.
+	 */
+	ret = phi_heap_extract(pgdat, KPROMOTED_MIGRATE_BATCH,
+			       KPROMOTED_FREQ_THRESHOLD, &migrate_list, &count);
+	if (ret)
+		return;
+
+	if (!list_empty(&migrate_list))
+		migrate_misplaced_folios_batch(&migrate_list, pgdat->node_id);
+}
+
+static int kpromoted(void *p)
+{
+	pg_data_t *pgdat = (pg_data_t *)p;
+
+	while (!kthread_should_stop()) {
+		wait_event_timeout(pgdat->kpromoted_wait, false,
+				   msecs_to_jiffies(KPROMOTE_DELAY));
+		kpromoted_migrate(pgdat);
+	}
+	return 0;
+}
+
+static int kpromoted_run(int nid)
+{
+	pg_data_t *pgdat = NODE_DATA(nid);
+	int ret = 0;
+
+	if (!node_is_toptier(nid))
+		return 0;
+
+	if (!pgdat->phi_buf) {
+		pgdat->phi_buf = vzalloc_node(phi_heap_entries * sizeof(struct pghot_info *),
+					      nid);
+		if (!pgdat->phi_buf)
+			return -ENOMEM;
+
+		min_heap_init(&pgdat->heap, pgdat->phi_buf, phi_heap_entries);
+		spin_lock_init(&pgdat->heap_lock);
+	}
+
+	if (!pgdat->kpromoted)
+		pgdat->kpromoted = kthread_create_on_node(kpromoted, pgdat, nid,
+							  "kpromoted%d", nid);
+	if (IS_ERR(pgdat->kpromoted)) {
+		ret = PTR_ERR(pgdat->kpromoted);
+		pgdat->kpromoted = NULL;
+		pr_info("Failed to start kpromoted%d, ret %d\n", nid, ret);
+	} else {
+		wake_up_process(pgdat->kpromoted);
+	}
+	return ret;
+}
+
+/*
+ * TODO: Handle cleanup during node offline.
+ */
+static int __init pghot_init(void)
+{
+	unsigned int hash_size;
+	size_t hash_entries;
+	size_t nr_pages = 0;
+	pg_data_t *pgdat;
+	int i, nid, ret;
+
+	/*
+	 * Arrive at the hash and heap sizes based on the
+	 * number of pages present in the lower tier nodes.
+	 */
+	for_each_node_state(nid, N_MEMORY) {
+		if (!node_is_toptier(nid))
+			nr_pages += NODE_DATA(nid)->node_present_pages;
+	}
+
+	if (!nr_pages)
+		return 0;
+
+	hash_entries = nr_pages * PGHOT_HASH_PCT / 100;
+	hash_size = hash_entries / PGHOT_HASH_ENTRIES;
+	phi_hash_order = ilog2(hash_size);
+
+	phi_hash = vmalloc(sizeof(struct pghot_hash) * hash_size);
+	if (!phi_hash) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < hash_size; i++) {
+		INIT_HLIST_HEAD(&phi_hash[i].hash);
+		spin_lock_init(&phi_hash[i].lock);
+	}
+
+	phi_cache = KMEM_CACHE(pghot_info, 0);
+	if (unlikely(!phi_cache)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	phi_heap_entries = hash_entries * PGHOT_HEAP_PCT / 100;
+	for_each_node_state(nid, N_CPU) {
+		ret = kpromoted_run(nid);
+		if (ret)
+			goto out_stop_kthread;
+	}
+
+	register_sysctl_init("vm", pghot_sysctls);
+	kpromoted_started = true;
+	pr_info("pghot: Started page hotness monitoring and promotion thread\n");
+	pr_info("pghot: nr_pages %ld hash_size %d hash_entries %ld hash_order %d heap_entries %d\n",
+	       nr_pages, hash_size, hash_entries, phi_hash_order, phi_heap_entries);
+	return 0;
+
+out_stop_kthread:
+	for_each_node_state(nid, N_CPU) {
+		pgdat = NODE_DATA(nid);
+		if (pgdat->kpromoted) {
+			kthread_stop(pgdat->kpromoted);
+			pgdat->kpromoted = NULL;
+			vfree(pgdat->phi_buf);
+		}
+	}
+out:
+	kmem_cache_destroy(phi_cache);
+	vfree(phi_hash);
+	return ret;
+}
+
+late_initcall(pghot_init)
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 71cd1ceba191..ee122c2cd137 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1494,6 +1494,15 @@ const char * const vmstat_text[] = {
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
 #endif
+	[I(PGHOT_RECORDED_ACCESSES)]		= "pghot_recorded_accesses",
+	[I(PGHOT_RECORD_HWHINTS)]		= "pghot_recorded_hwhints",
+	[I(PGHOT_RECORD_PGTSCANS)]		= "pghot_recorded_pgtscans",
+	[I(PGHOT_RECORD_HINTFAULTS)]		= "pghot_recorded_hintfaults",
+	[I(PGHOT_RECORDS_HASH)]			= "pghot_records_hash",
+	[I(PGHOT_RECORDS_HEAP)]			= "pghot_records_heap",
+	[I(KPROMOTED_RIGHT_NODE)]		= "kpromoted_right_node",
+	[I(KPROMOTED_NON_LRU)]			= "kpromoted_non_lru",
+	[I(KPROMOTED_DROPPED)]			= "kpromoted_dropped",
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.34.1


