Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F66C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75CAA6B0092; Sun, 12 Jul 2026 03:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733D96B0093; Sun, 12 Jul 2026 03:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB756B0095; Sun, 12 Jul 2026 03:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DF256B0092
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:41:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A4310C478C
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:23 +0000 (UTC)
X-FDA: 84979329246.21.145EDE3
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012040.outbound.protection.outlook.com [52.101.43.40])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6E006140005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:20 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="VecKv/LR";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.40 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783842080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwQs3RKX7YYxLl9XMtvz/dS5L1JL+oJgeHqu+mDosi4=;
	b=UAmrLymuJPL1gjc4b6Cv4XSoj1V+WL35vfoVH8n9+UM4w43kUrCGe/M1N18gYABKjntTzZ
	Tc3xD4iPQJ7J9m9YF1UovEd61QHYGTQgxxL4ztpgnhkRbrQeus42iuk4UtFUh8x8Wg0BQ6
	X2O/11k3QxK8nb3GhdeipT4XIwS3Se0=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="VecKv/LR";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of shivankg@amd.com designates 52.101.43.40 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783842080;
	b=nV97pPTZdnVvmFbraNzk/zfG78kWlfYyL8YcLV7pnw0niD3Ho7NT+xlDQNC22WlZ3+6cCm
	e1T9hF7GT/abj97lKIX2zDnNUoR+yzMGv3OWVcjVCs/u1/PYLQaSFLY7w0UhE0qHUXgw98
	pmGuI/8TsK41bMWoXATNGni/rks7Ue0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DD68O0Ar7Js4yvEZ5c+R0/8/SP93a37JFg6WHh/S8uErRlrrkFoA2mrViLoD+c1rUQOIWUvZ4KmG/MxnuRWGkv8NGyNB1uYYwpXd8kv1jGodjeeAYiw8tlHVB2jplEbikRQ2yMDv9YrdpspI+HjB9Ogi/y555APPvw5wTcgPd4Pe+6lk2SHL6ObMDFhmxcijLPM+r9pcnt8RrovY41oljoTPL6rH/vUsGoABcxydqWZaeL69wJf+l1fShRwu77gTIpUH1NY3A5Kkb6Ypz7yhiLkcPhWycT1/Sx4bz73ZXIZw9PcZ7ZEfLXdLCrslHsAXNnrO4U4z8KgXYi/KCHvGcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwQs3RKX7YYxLl9XMtvz/dS5L1JL+oJgeHqu+mDosi4=;
 b=jtmU55KPzGmgnDCS87x/Y4qf+IsxmuInzhz8MoYJo2yoFvc2rPHm0zx2c2iRrDZsNO/4PBmHuTkB3wAVquE1NcodFiVWhuO/0Uk1+vGpHpk3YRhgbvKfqp7nbOsqrALRSjfsTMWmTC6eIjYvcyp6J8qQmRg1IhzhuKYzHMWhKI1WK9PCh2wB8e8s8YcIhBfK+5j4yI00Fkp1JxSJVOieTF8+3xKPBf58msx+xnt7mme4UnI6Aso6zzp97sQMed5Y+VUI0422sa2/9rf9OM/XGlb8IMrIiyGBt0m8jStmEdqNpaJub4orIfsTisHA4C/yhII46OJEvYCKM05REiCz/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwQs3RKX7YYxLl9XMtvz/dS5L1JL+oJgeHqu+mDosi4=;
 b=VecKv/LRKWWjc3Trz+Ncgd7sgigwW7IUJEdP+IbLIPez67Zr6J6Bjj4yd9UP0jCICku2LtSv4FZsj6WrF1WizBE0CGXK/0qydSRUX6bkOUwJVXIbiUKo55mf/7iXxG2VYQwnU/crpfkeQWYFifJN0jf7vGjkWoB6ghh3QCkuoAs=
Received: from BLAPR05CA0044.namprd05.prod.outlook.com (2603:10b6:208:335::27)
 by DM4PR12MB6494.namprd12.prod.outlook.com (2603:10b6:8:ba::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.22; Sun, 12 Jul
 2026 07:41:14 +0000
Received: from BL02EPF0001A103.namprd05.prod.outlook.com
 (2603:10b6:208:335:cafe::78) by BLAPR05CA0044.outlook.office365.com
 (2603:10b6:208:335::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.223.9 via Frontend Transport; Sun, 12
 Jul 2026 07:41:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A103.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.202.18 via Frontend Transport; Sun, 12 Jul 2026 07:41:13 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Sun, 12 Jul
 2026 02:41:06 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Sun, 12 Jul 2026 07:38:49 +0000
Subject: [PATCH 3/6] mm/migrate: split remove_migration_pte_hugetlb() out
 of remove_migration_pte()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260712-migrate-rmap-batch-v1-3-872a734431d1@amd.com>
References: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
In-Reply-To: <20260712-migrate-rmap-batch-v1-0-872a734431d1@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel
	<riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Jann Horn
	<jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>
CC: Karim Manaouil <kmanaouil.dev@gmail.com>, Frank van der Linden
	<fvdl@google.com>, Kinsey Ho <kinseyho@google.com>, Wei Xu
	<weixugc@google.com>, Bharata B Rao <bharata@amd.com>, David Rientjes
	<rientjes@google.com>, Dev Jain <dev.jain@arm.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783842044; l=7140;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=NiZVySPznUPmW9N2SAXqRfMvt9NyXeSzVqXhYk+QTIQ=;
 b=XWoiFd9XKKDU8A4EKlPdtlIcS0Tr7gHWBfBBTlNc4qLtGbvohSlYSZwI2MI4spNK1IEAgOJ7f
 I+IV48B8vhfCdHMLcMUPeLmbA5q9CivnVoSo/GY87mPekM2I8FErasc
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A103:EE_|DM4PR12MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: 160eeed6-9309-44b9-06f6-08dedfe8f335
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|7416014|376014|1800799024|82310400026|921020|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	kZ6MsGL32J5u+YseQPoBNghUTd2yPn9OKshjTe0geQvN/gpAdVY19zuhKOOH+KYYh/aMn8TlIZp+uwSw82Q6ZUyLSY610SY0Si6PuKgRVBWPq1qU/cnEvmkIdeINe95dVkwkMZjSWQaTxe1usNknkrPfXDR1G4MnTtr4AegZhAxA7Ca4++LEvTgRazan9lKSZfXriBhoRQfDeq7kPwsvzoiW8W0lsHYGpeM73GFM3oBmQo8LtgZfa+hAAGTXzPeqOLCpt5K2luH0k3rOm85UzJnQz3mBmZj+Tm9cQK0fzCRO5BnM5L3oxblj7RrTuJLSGoQNli6B7gcntmD0Cr+x9n7ZOFNStFU4iZuXkWpDNTHla59o7iBUJa+W+Kq1DTDmKPGF6Wqf+GldkD7vT8mk72bikKbjVIJMxvOXKVKpMgokEk+tY6su7ZeEGO4u5nJ8NMJq5OHlRhCmVQ78dDYcAiQDbmZyW5ARkfMhHRcke84uJgSFcMOPfcBIlab+VyrKtGYOgjl0HOnTXdlKXo+juGG2byWuQjuoor7DHa86wFsYkP7/lDWp7SrjB69nqQ5SKb9li2RODKObGxBkAb7TFzbqRTzfQ1TW++r6LtJe0ZwQePvlMu2hXTPS54O5yCqND2GtpIt/PgwoHjzOR/bShJrGtejtyann9A2sBfl95tdslDd+nMgiH3qLKu17hK4/Tn6jK+iJFqUFBcY4z1hhcX2OTc8agj9K4t2Y2VhMg/Z+4xcMz+d3TzjfzPMkxOq1
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(7416014)(376014)(1800799024)(82310400026)(921020)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XjRiZsnMw6SnyEC3pZfBnCdVm2kmanuKmWUg+df7dRQcggHl9vBIFvE+ifnGxda+49FjxjoevISbVCMa+XtbY8GdTXhEzNJ+z8fIA2rnda8I01lWGCr7KQV1C+Jo+XcRFxP91016ELS4sJtbAPNEOp0hGcmS4z2sobaibybM7uwENbo2nyf4dkZEc/AR97bvQBhS7O7tm4TufouUDvb2oeNh7ixeYAyekCdI81VsONN6ZL/CKg/Ibn+nGK6o3kAdF1L4WeKB3V9Z7sDPdga4kDyvwTs0azLVtPWJXdCPn/R7wtdHNBbVWbya0Wh3nZ/Y5+zXS4zaaq31GsVfHuzDi7GwogiqsbUDqMfAYyAIwb6BPnYtIUZ4kFETKSVSDtBw4UzGUESfIyQMiCt7wtoHWDE8zTp8KsB0toY+rVCpXZ1xnloFwcFwUvjzKMNV3ZCy
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 07:41:13.8490
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 160eeed6-9309-44b9-06f6-08dedfe8f335
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A103.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6494
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6E006140005
X-Stat-Signature: b7rg96e3pr7zjmiqmoqfz9a4s7wsbckf
X-Rspam-User: 
X-HE-Tag: 1783842080-143701
X-HE-Meta: U2FsdGVkX1/7ns+mbQZ5qV1Cmd+FNQE+OSzASTbjN5zBpHtNj7O1LM1ECeVlGmG7QwQc4B4a8BXdM6H8YlN6uXHp88JvVRdQtOW3CV1Krjtcyo9MVED2iwHConsayHIvkVXznGPwrpv2X4dTnCrt3e8/mloSr2HPGxlmvSISLDS1Cg/fFYAxyZupQgt2ypo289wgBdF6kVoLC2ExVmMQSX8SDgEQbIUjpwXxA9D/SKlX3euEKtyT4dirWW+sGpiHfd9QEPIRC6LykATKuJyJNol9iAB3J5b3ZsufECslUP5yEtAC6fERc7O9jXZfMof8yDtQD2v0VRs2+woH4tVjUsDhB/T+fI1IKHbFc5JKELgnaoQT6OqUscxVC+/8AUbDlo880JYJ3kEwLBlzHVVCc/oYJ1k++EmClCDVzNDf5RoTkOfQD+KlV6lOxddGUR0uFrmt8ZkUlHrbEI3BGKNq+WWyy2XrJoOsQDoghhEVt+v/glhtq1gsmfXMo6DYoYj2sjFkgJUdwtG2TnOuBBiyPNAvoqhpW/6SUibobIUcy5DHiT1nzBEUwv3yn4IH466O/OONcGP7j9pti89qc7QiR2yZNCa+FDGXKc9N8lGkBc7E67i7JbR38DgGsMDo1TzRxFXLgv0En14EWfieZf15OHwxVLyWvvWTlot+ivf/9RSIAMQ7YNkYB85SjJ8V0O3xDTPhfNeDQTNjeSBurRkF7m2tBauRS7D2/1PU7Siakbuj5BfUWj2eId9IT9DTVUQ+YC46jFv3outSLvETbiV7ngLpvSFAwS3SMzq3rVuCJ5PKXD9sZXfB4frRUforubrg1MYbHNqqTDn78nagIGRJuZxRk7vxGeJhbWL+lzshY/2yTbA/4Ia6uIj7fw0LuE+FABcBkWdC8Qk1Zbnwlu2lQW7ygN4TFLn9IK9kKQNjr39s8N6ypmBnhyBafxvwlvM2pwAhnFKdZWC8Sm8Oh6d
 arxZX0Oo
 aaKVcfJv0SYpwg4MWtLp8s1rtUmtyj1OpvZz0A0X3hRwEsUuoP47aFPDpdiPNzjNei+HcA6rYWKGGZTDn2l1xrfbZhqQrhkmuaezZcCffzy2BLSPO3AxNrfwJGkXlrCtV6e4I+gCw3mIrS48I0QNc0LRVApScDdvxTJLqbR3zKYCew+k6y6TqMoOKbLnbY2WD1GvWq40JP6QiP9bQVM0mSk9lhgWSxMkkniU7ZiwGwQYuFMZD15lgcB+iOOayijQG9GyV9F5ujvkeIKVvIudyCuSW4z3pasEB0N+wwkT5ospdtMh7+ASN3JWsXbgbr9rvv9vzTASJKvRckH+LgtDZFXpaSphEBmaQ4ZLRihdH65j6Svgu9WjjrOG9s+FneNBK8xftXAYNSxqSjQ7BWpFAyg7Bha+yT8vqMzPLL3j3xTFuAoC0so22n0SsoxWowQOZrBOORhtekqOvkIj8HhGJxahYam2Iv7lMI69aT8uTlXVXuLETy5XhmLztCLHVlA91EigZadUbjlaG27M/aqBmIt1jukyseaMn+5M/IhT38YgbJUCtueM/IW4rFeismX618omhWtBHA4IAHLfdtZMO6CkzuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

remove_migration_pte() interleaves the regular folio path with the
hugetlb path via folio_test_hugetlb() and CONFIG_HUGETLB_PAGE
special cases. Simplify this by seprating the hugetlb handling into
remove_migration_pte_hugetlb().

Factor out working-PTE construction from migration entry into
migration_softleaf_entry_to_pte(), used by both paths.

While here, convert the VM_BUG_ON_FOLIO() to VM_WARN_ON_ONCE_FOLIO().

No functional change intended.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 153 ++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 98 insertions(+), 55 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 222c8c15f782..8a098402b8c9 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -345,6 +345,89 @@ struct rmap_walk_arg {
 	bool map_unused_to_zeropage;
 };
 
+static pte_t migration_softleaf_entry_to_pte(struct folio *folio, struct page *new,
+		softleaf_t entry, pte_t old_pte, struct vm_area_struct *vma,
+		rmap_t *rmap_flags)
+{
+	pte_t pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
+
+	if (!softleaf_is_migration_young(entry))
+		pte = pte_mkold(pte);
+	if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
+		pte = pte_mkdirty(pte);
+	if (pte_swp_soft_dirty(old_pte))
+		pte = pte_mksoft_dirty(pte);
+	else
+		pte = pte_clear_soft_dirty(pte);
+
+	if (softleaf_is_migration_write(entry))
+		pte = pte_mkwrite(pte, vma);
+	else if (pte_swp_uffd(old_pte))
+		pte = pte_mkuffd(pte);
+
+	/* See do_swap_page(): restore PAGE_NONE for RWP */
+	if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
+		pte = pte_modify(pte, PAGE_NONE);
+
+	if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
+		*rmap_flags |= RMAP_EXCLUSIVE;
+
+	return pte;
+}
+
+/*
+ * Restore a potential migration pte to a working pte entry for hugetlb folios.
+ */
+#ifdef CONFIG_HUGETLB_PAGE
+static bool remove_migration_pte_hugetlb(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
+{
+	struct rmap_walk_arg *rmap_walk_arg = arg;
+	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
+	struct hstate *h = hstate_vma(vma);
+	unsigned int shift = huge_page_shift(h);
+	unsigned long psize = huge_page_size(h);
+
+	if (page_vma_mapped_walk(&pvmw)) {
+		rmap_t rmap_flags = RMAP_NONE;
+		struct page *new = folio_page(folio, 0);
+		pte_t old_pte, pte;
+		softleaf_t entry;
+
+		old_pte = huge_ptep_get(vma->vm_mm, pvmw.address, pvmw.pte);
+		entry = softleaf_from_pte(old_pte);
+
+		folio_get(folio);
+		pte = migration_softleaf_entry_to_pte(folio, new, entry, old_pte,
+						      vma, &rmap_flags);
+		pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
+		if (folio_test_anon(folio))
+			hugetlb_add_anon_rmap(folio, vma, pvmw.address,
+					      rmap_flags);
+		else
+			hugetlb_add_file_rmap(folio);
+		set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte, psize);
+
+		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
+			mlock_drain_local();
+
+		trace_remove_migration_pte(pvmw.address, pte_val(pte),
+					   compound_order(new));
+
+		/* No need to invalidate - it was non-present before */
+		update_mmu_cache(vma, pvmw.address, pvmw.pte);
+	}
+
+	return true;
+}
+#else
+static bool remove_migration_pte_hugetlb(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
+{
+	return false;
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
 /*
  * Restore a potential migration pte to a working pte entry
  */
@@ -363,52 +446,28 @@ static bool remove_migration_pte(struct folio *folio,
 		unsigned long idx = 0;
 
 		/* pgoff is invalid for ksm pages, but they are never large */
-		if (folio_test_large(folio) && !folio_test_hugetlb(folio))
+		if (folio_test_large(folio))
 			idx = linear_page_index(vma, pvmw.address) - pvmw.pgoff;
 		new = folio_page(folio, idx);
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
-			VM_BUG_ON_FOLIO(folio_test_hugetlb(folio) ||
-					!folio_test_pmd_mappable(folio), folio);
+			VM_WARN_ON_ONCE_FOLIO(!folio_test_pmd_mappable(folio), folio);
 			remove_migration_pmd(&pvmw, new);
 			continue;
 		}
 #endif
-		if (folio_test_hugetlb(folio))
-			old_pte = huge_ptep_get(vma->vm_mm, pvmw.address,
-						pvmw.pte);
-		else
-			old_pte = ptep_get(pvmw.pte);
+		old_pte = ptep_get(pvmw.pte);
 		if (rmap_walk_arg->map_unused_to_zeropage &&
 		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
 
-		folio_get(folio);
-		pte = mk_pte(new, READ_ONCE(vma->vm_page_prot));
-
 		entry = softleaf_from_pte(old_pte);
-		if (!softleaf_is_migration_young(entry))
-			pte = pte_mkold(pte);
-		if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
-			pte = pte_mkdirty(pte);
-		if (pte_swp_soft_dirty(old_pte))
-			pte = pte_mksoft_dirty(pte);
-		else
-			pte = pte_clear_soft_dirty(pte);
 
-		if (softleaf_is_migration_write(entry))
-			pte = pte_mkwrite(pte, vma);
-		else if (pte_swp_uffd(old_pte))
-			pte = pte_mkuffd(pte);
-
-		/* See do_swap_page(): restore PAGE_NONE for RWP */
-		if (pte_swp_uffd(old_pte) && userfaultfd_rwp(vma))
-			pte = pte_modify(pte, PAGE_NONE);
-
-		if (folio_test_anon(folio) && !softleaf_is_migration_read(entry))
-			rmap_flags |= RMAP_EXCLUSIVE;
+		folio_get(folio);
+		pte = migration_softleaf_entry_to_pte(folio, new, entry, old_pte,
+						      vma, &rmap_flags);
 
 		if (unlikely(is_device_private_page(new))) {
 			if (pte_write(pte))
@@ -424,30 +483,12 @@ static bool remove_migration_pte(struct folio *folio,
 				pte = pte_swp_mkuffd(pte);
 		}
 
-#ifdef CONFIG_HUGETLB_PAGE
-		if (folio_test_hugetlb(folio)) {
-			struct hstate *h = hstate_vma(vma);
-			unsigned int shift = huge_page_shift(h);
-			unsigned long psize = huge_page_size(h);
-
-			pte = arch_make_huge_pte(pte, shift, vma->vm_flags);
-			if (folio_test_anon(folio))
-				hugetlb_add_anon_rmap(folio, vma, pvmw.address,
-						      rmap_flags);
-			else
-				hugetlb_add_file_rmap(folio);
-			set_huge_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte,
-					psize);
-		} else
-#endif
-		{
-			if (folio_test_anon(folio))
-				folio_add_anon_rmap_pte(folio, new, vma,
-							pvmw.address, rmap_flags);
-			else
-				folio_add_file_rmap_pte(folio, new, vma);
-			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
-		}
+		if (folio_test_anon(folio))
+			folio_add_anon_rmap_pte(folio, new, vma,
+						pvmw.address, rmap_flags);
+		else
+			folio_add_file_rmap_pte(folio, new, vma);
+		set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
 		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
 			mlock_drain_local();
 
@@ -474,7 +515,9 @@ void remove_migration_ptes(struct folio *src, struct folio *dst,
 	};
 
 	struct rmap_walk_control rwc = {
-		.rmap_one = remove_migration_pte,
+		.rmap_one = folio_test_hugetlb(src) ?
+				remove_migration_pte_hugetlb :
+				remove_migration_pte,
 		.arg = &rmap_walk_arg,
 	};
 

-- 
2.43.0


