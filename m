Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20208C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 07:41:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B8F6B0093; Sun, 12 Jul 2026 03:41:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC0F6B0095; Sun, 12 Jul 2026 03:41:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD1B6B0096; Sun, 12 Jul 2026 03:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEA896B0093
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 03:41:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65B311A08C9
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:30 +0000 (UTC)
X-FDA: 84979329540.23.6A3928B
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011022.outbound.protection.outlook.com [52.101.57.22])
	by imf26.hostedemail.com (Postfix) with ESMTP id 477E3140009
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 07:41:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="O6//IY6q";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf26.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.22 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783842087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnMC8aGBoA4+MFdtra1b+Fcp5uvcOnfcFWmUVebdKcw=;
	b=uViU4lih4/uIc1RPRfapDz/ODz3XEW2PbEyfZwlP6SRXFoHfpql8As5tYTtCvhO0NfgQjJ
	G6/AbZZhbiRya41bvTGLwIN+l0je7QAYmx0aoPl152FPmpFQE5zlh9344md49Tj0+mXqXw
	syTKZeMWegdGl4dC8J0DelDA7ZquxPQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="O6//IY6q";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf26.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.22 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783842087;
	b=R1oEGHc62kLsOR6m5f076NtR9S4j+NHPt/8hG67NChETUQVt3o17zdC1EKEr4vJCjeZNz8
	52vXEGxZ8HWsAKfaveR2VZvsXUbLJufLXcbtz6igsQC5avCfXooKbLFbNkqoQdvMUQdjWG
	ApUglFwypd6XS8MIGEoVS2f6BAE0wFc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uewvZedIh8p6mNJyNNJpc7SthXJZ6Z0aBopGvRnzPgDLXBgn+2/LxEy/ptSJFIwPkzxKuczV9i/5Pb/dOT8uDm7mFRQjqbLtgw4rCSxsov2bWRTd1m/Lr4J0dGDn9y5da3AwL/Lwd9UarLELj0uKEIXW/bVVbI9FIl+MJIzK/IroxcH6Mld7ttW0yH+/gPe2WpKtixii5UVfb05q0atBOK/vHo7a5GKuxN1zdZaOxIk6aeWRkedfRheouxi2nYr7N6vyoMDQ2J2146gmeoCZlplTA/RXTKtxaiyFaO0m0L6WHPzfYvl2GhXcPgznzvhv8etEn6WBBa4E4GGmDZGkFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnMC8aGBoA4+MFdtra1b+Fcp5uvcOnfcFWmUVebdKcw=;
 b=QEzXQhJp6ubB04Uk2yeT/bRsOpizB1y4mrxJId8pVGqu/r5ccisO0SMhX0kq1q1T7rtGIDUmG6za0OkT1N4QtnGfDD2DEG4WVQ4nKbLv2lBuEB6piNr7kCnmYlHNBx1iyaHCqfCTw+Zepgje+4pzSPIpaY3sjOuxoRjzvYpVaOOT3UGLVrmMWoQLjylVCFFQzKJc+NKI7TAci6J0erswpoeBcPPlSWPzZRc3d9Mnz6HzkW0t0Ps7NlbkJDoWwx9Et+t5fsR81dA3YlIwdIh7FNa76MIAyVRPbacAjTc+WhEB9nllZ6CNbIp3PNZDUNyROLOxM2wmVE+ur2jTcyUXBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnMC8aGBoA4+MFdtra1b+Fcp5uvcOnfcFWmUVebdKcw=;
 b=O6//IY6qs1wfgVlwcRiDts79vQfLPJ6skd4CzPnq0B7/3zEVxcp7w2oKE8CYBxG9ccPKasja3LruPHOHA/gUD7xbMBnOqCPo4g4SPrmcLc0oQ+B0qfx29AdS8qNSD409aDkxqoGZEpY/yjwzhAUSJt5SkslAO7czbaEmEiTLG2M=
Received: from MN0PR04CA0011.namprd04.prod.outlook.com (2603:10b6:208:52d::7)
 by CY8PR12MB7193.namprd12.prod.outlook.com (2603:10b6:930:5b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.22; Sun, 12 Jul
 2026 07:41:22 +0000
Received: from BL02EPF0001A108.namprd05.prod.outlook.com
 (2603:10b6:208:52d:cafe::75) by MN0PR04CA0011.outlook.office365.com
 (2603:10b6:208:52d::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.18 via Frontend Transport; Sun,
 12 Jul 2026 07:41:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A108.mail.protection.outlook.com (10.167.241.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.223.9 via Frontend Transport; Sun, 12 Jul 2026 07:41:21 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Sun, 12 Jul
 2026 02:41:13 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Sun, 12 Jul 2026 07:38:50 +0000
Subject: [PATCH 4/6] mm/migrate: batch the restore-side migration rmap walk
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260712-migrate-rmap-batch-v1-4-872a734431d1@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783842044; l=4278;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=KPzNifbI7PmPRQvQWc6sP+itQG02VGDINUXQGQWdZPQ=;
 b=eXfk3cc3LyZQuBa6jNPVkKsajnJuqFzigyboOEqF8gJZP/Ihn8sotuuB4RsJ4NiJ0AFVLv/Ey
 CJ9K47gCWx3DHVNDTAJnD+fGIYEtBzWYfjzLFURsbXAO6hkoUG4lxsh
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A108:EE_|CY8PR12MB7193:EE_
X-MS-Office365-Filtering-Correlation-Id: a964e2bc-b374-4aaf-35df-08dedfe8f7f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|82310400026|36860700016|23010399003|22082099003|18002099003|56012099006|11063799006|921020;
X-Microsoft-Antispam-Message-Info:
	oOp9+EMJSIt9hYyBnWzErkQ1IzPsQHS3p+ydwSZTpZfSIAWrfkIutyO0ONFDP85u5dhyWmP94AXuEsw1m6luMv9IhMSTVl+Wg6ZUpboVN/zk+l+TgQ4JbfRHpJ9jJ+c53siA7T7LpawWuSQLlteRzv4LhMWc3pkchnPTbIIymcwIzI9gMN8D0oi/O3xRBjYfaCNVya/jqYpxT2DVwOg18uUF5mngZVfFKSisQglk4GHZA7ykvEQ/W1ml5EOR3XDTitlfaBFRSCaOw9P+IWDXvePGr/4c5/thNPwzNJqirlK5lOdgCruFrDht+GxQVlaUUQXQKcGR5oX0v8yKn2yWLsanugYTa9tt8aHK74QyupZm6Z8llDpeIi8p3CYirL0cN+4AqHlOvGW9dTn+6L+qtgS7hr8VcKqHvjm429YIGezboE/EbHQaZYInKZuyEhDS3x6HFp0HIsZ0wVcCCRhLdkTkqZHFn2D2k/1MMEJ2avHPhYfDV2ysYAJAprbCYlZMaT3plsGoKiLmceLqy5G43xlyEsCpNMRxtcyOrKGmhnf4g3DcC1AGeVDlcemDfc9Q7dsIIemYeBLGbBLiJznjGDjLad2Gu59o7mZkZx6BC7T8LEvBJu/NFrMungXHdkD9dg6JC9nSq0LXEbT3cfAYoSMthxQaWNJsh6ubHT7AtlrjP41ilvSY8lytYO6HxdeUV+mLg1F+g2HkIZmrBcAdP6yLyFDPRgieVBq0Jj0AVoGjFDXC2IX5/COaBK8P4k7f
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(82310400026)(36860700016)(23010399003)(22082099003)(18002099003)(56012099006)(11063799006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	J8CZ9mRqfHETFMt8MwOxiBYMvgWWjFh4OcYmOVfKQ/bDsNce2n2WupoREONXauZrugy1JXh9QgmrMs2Yc7v7ETJRwN43P2W9owRxpyZOKp6dAp8J+ZdAKfP/fkGO8V4Il71ZSuVmyrHUEvzEsyhCUAsJ+g1D7Zm8D5P/s6Fkwf8bnh8w/EMzRG2aC95M968nXNAOy05X4d2wsQU+Pun9jB1/sVY278mEWGbwupxd45aPXODsCEjX2UIyEk2JpnahmWzV/XNNBB/uSP8YPs2hPs6IxEaGsIeZG+lzUidzTuoXaH97OhFmJiriVMPT1iF4ynP245olcVd9YLcRVzk566lIjj3fRnir6vGTnFIj8eahnAx1n+QJ/5m6FevA/o5m+vVV1wYF3eeVcnBr9hcy6CzzDjPtlRDvAe2SVNhOct3zpEP8LSbaCw5SwF3fZfuo
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2026 07:41:21.8419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a964e2bc-b374-4aaf-35df-08dedfe8f7f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A108.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7193
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 477E3140009
X-Stat-Signature: w3e7zgp17pfid9q39mknhnmisuqoyo6s
X-HE-Tag: 1783842087-339923
X-HE-Meta: U2FsdGVkX18o9GdHqbj4hb4jwpgfN+/9K8EZI3BO0V6ghZoLiP6i9M+kYCizQ7gchOW7bMpA2F/5dWOsdPRDCR/W3jAnCz/zr4eVfWudJc2VVnUELk9o0M+zkF1QMV/lRpMojg3nONPyCmi/wSuIvSCOp3jHksgI+svL1xK5DYuuvBekzuyONB+JXpfb62++nG4TcpHtj39kyJCgUv8H07BeSvxxNq/N3I0+0XACbeASUZ/Wv9DWw4YG/UksSHyIYOZRXzSHS1FcuU/lwoMSY/29uH9AnslxgxiS7qWGxYNhsKbE8TC48aG5uukTpWMgTnYap3i9kskDgjJoJmTIQ6sti7Xc0ulsAdGT1py32JPCRFaBxItv7iJegO0KRi4s9XpVLuRwfubk5tHGYFQJbfixOo3AZpAmkJ6OZU9wz5kG/KtbCuRafDAci6IRLM43o9qAYYjjDvk/ooX06JAxufjrvDrQHZDjTTp0bODZynYtc+am4ZGYkOMdEkWnV/dhw9fMY2rFlTHXOv9MUL4te/iReHhIww7uozRK5+GJd6CSiX6l9Dkuf/gQn8pVsYl86fF6HdpcvkMtLOfBeAxqpa7HsYPbqcF7btb4WBI5nZLwg5BE9SSc2xqyGDaWfX6/2OkFokvTr0oI50nrzico9AFuJ9XBuM39r6jOAl+XoJ9KkLV6nYCUD/QYZ14V+e5S1kQqO4aCqYAHRNCMdEu+ZEITVRt1ehjEwOn88Pqonjm8DUIC+Ro0FVZ9/lg9Fw1uBTJ+9AzwifiNIbUwpL+lZoUj/DQein4/f/Z0QsF1nguHPakK92u1jYR0/4JzN7d7jyz6+DSAburxtqjuFcEsCYNI2FR5lekCE+9zETVge+49dzfzG31WoIXiREgqn1iDXbdHXDLofb4Cz3ADqVPxGGEmqaHVUghGbU5mjTrzcWQ7AONzF6Hw99svZE7eh9lg7l/WOYphR644wOTyCkj
 fGTlJoF7
 vKoBaURY6WK/sN/weSWwL0R3gYpSBpm7PqAEV93Et60Xnl85QQlTO7LMZmWZTanJua48AAvKqYz2DZzyAmyJzFimCScDrkW6HZqFQ9YmQFboYlNfhADY6APRR1j9D/upeGfsgaiDpGUGArTuGl7txeLFfg3I2h932kDJSYuxPK8PWt/muz6lHvHIPWZVZCYa7WVKZVCZm07LeaQOY+2fWXh6y8N7e5rlOzGQeF8sWbOvOBpfx7oQtHQeMe+SBRWK6ANY71zaGpvSyEXnqbkHOLCQrhtSuFDftr6fG/LdHOf39q3bMVEtsg0JOjsnbhibkdQ8h8BnfjE1iWbMl/DGTht14+qw/2c4rsxv7Fzr703IE98DQ4p2nL3i7nkURqaFStgOpeGG/oDNJ9pqqqlRwzd9scCwJSWxqFV2NHvlbtwtBrgKBkAFPoRd9u683J3qEisD7gDPshQi7NTX9VggsMSw5DAJOTDbPpzW/1XaFtlqVKbELs5Wk69pbNxFoSUCHkIivRJtKW7RSD127ciBZwEygT8+O8TRyFk8u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

remove_migration_pte() restores migration entries one PTE at a time. For
a PTE-mapped large folio, it repeats calls to building the PTE, add rmap,
set_pte_at() and page_vma_mapped_walk() per base page (256 times for
a 1M folio).

Add migration_pte_batch() to detect batch of contiguous migration entries
that map consecutive subpages, and have identical PTE bits.

While at it, use folio_is_device_private() instead of
is_device_private_page().

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 8a098402b8c9..6d05d3f41095 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -345,6 +345,28 @@ struct rmap_walk_arg {
 	bool map_unused_to_zeropage;
 };
 
+/*
+ * Detect a batch of contiguous migration entries: consecutive (non-present) PTEs
+ * containing migration entries with consecutive offsets and matching pte bits.
+ */
+static unsigned int migration_pte_batch(struct page_vma_mapped_walk *pvmw,
+		struct folio *folio, pte_t first_pte, unsigned long start_idx)
+{
+	struct vm_area_struct *vma = pvmw->vma;
+	unsigned long end_addr = pmd_addr_end(pvmw->address, vma->vm_end);
+	unsigned int folio_nr = folio_nr_pages(folio);
+	unsigned int max_nr;
+
+	VM_WARN_ON(!softleaf_is_migration(softleaf_from_pte(first_pte)));
+
+	/* Bound by VMA / PMD end and by the remaining subpages of the folio. */
+	max_nr = min((end_addr - pvmw->address) >> PAGE_SHIFT, folio_nr - start_idx);
+	if (max_nr <= 1)
+		return 1;
+
+	return softleaf_pte_batch(pvmw->pte, max_nr, first_pte);
+}
+
 static pte_t migration_softleaf_entry_to_pte(struct folio *folio, struct page *new,
 		softleaf_t entry, pte_t old_pte, struct vm_area_struct *vma,
 		rmap_t *rmap_flags)
@@ -435,6 +457,7 @@ static bool remove_migration_pte(struct folio *folio,
 		struct vm_area_struct *vma, unsigned long addr, void *arg)
 {
 	struct rmap_walk_arg *rmap_walk_arg = arg;
+	bool is_devpriv = folio_is_device_private(folio);
 	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
 
 	while (page_vma_mapped_walk(&pvmw)) {
@@ -444,6 +467,7 @@ static bool remove_migration_pte(struct folio *folio,
 		softleaf_t entry;
 		struct page *new;
 		unsigned long idx = 0;
+		unsigned int nr = 1;
 
 		/* pgoff is invalid for ksm pages, but they are never large */
 		if (folio_test_large(folio))
@@ -465,11 +489,18 @@ static bool remove_migration_pte(struct folio *folio,
 
 		entry = softleaf_from_pte(old_pte);
 
-		folio_get(folio);
+		/*
+		 * Try to restore nr>1 contiguous PTEs in one shot. Falls back
+		 * to original per-PTE path (nr=1) if batching is not possible.
+		 */
+		if (!rmap_walk_arg->map_unused_to_zeropage && likely(!is_devpriv))
+			nr = migration_pte_batch(&pvmw, folio, old_pte, idx);
+
+		folio_ref_add(folio, nr);
 		pte = migration_softleaf_entry_to_pte(folio, new, entry, old_pte,
 						      vma, &rmap_flags);
 
-		if (unlikely(is_device_private_page(new))) {
+		if (unlikely(is_devpriv)) {
 			if (pte_write(pte))
 				entry = make_writable_device_private_entry(
 							page_to_pfn(new));
@@ -484,11 +515,11 @@ static bool remove_migration_pte(struct folio *folio,
 		}
 
 		if (folio_test_anon(folio))
-			folio_add_anon_rmap_pte(folio, new, vma,
-						pvmw.address, rmap_flags);
+			folio_add_anon_rmap_ptes(folio, new, nr, vma,
+						 pvmw.address, rmap_flags);
 		else
-			folio_add_file_rmap_pte(folio, new, vma);
-		set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
+			folio_add_file_rmap_ptes(folio, new, nr, vma);
+		set_ptes(vma->vm_mm, pvmw.address, pvmw.pte, pte, nr);
 		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
 			mlock_drain_local();
 
@@ -496,7 +527,11 @@ static bool remove_migration_pte(struct folio *folio,
 					   compound_order(new));
 
 		/* No need to invalidate - it was non-present before */
-		update_mmu_cache(vma, pvmw.address, pvmw.pte);
+		update_mmu_cache_range(NULL, vma, pvmw.address, pvmw.pte, nr);
+
+		/* Skip the batched PTEs */
+		pvmw.pte += nr - 1;
+		pvmw.address += (nr - 1) * PAGE_SIZE;
 	}
 
 	return true;

-- 
2.43.0


