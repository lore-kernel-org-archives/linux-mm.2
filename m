Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D623EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 05:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9246B00A8; Wed,  1 Jul 2026 01:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C431B6B00A9; Wed,  1 Jul 2026 01:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4516B00AB; Wed,  1 Jul 2026 01:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7566B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:17:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0350F1C13B8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:17:57 +0000 (UTC)
X-FDA: 84939051036.10.EE4D6A3
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011070.outbound.protection.outlook.com [52.101.52.70])
	by imf31.hostedemail.com (Postfix) with ESMTP id BF4F520006
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:17:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VfCWbYKm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.70 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782883074;
	b=l1dnkUDz9gBPEAuThZyoYauVQckLGaym9vgA4wIGPLABAUHcBSXBtKRKz04+xiM2ghPHtV
	Z6zy4gUm1s4v6KL4AnL6KdyJVu/KJrngcT/LF0TnH5zt/mzZhTxrhdc91C+uuQJcp/5T5H
	89Sr1iAuNtrsUMtoDLSy5HWowgTe2cQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782883074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V1O+RWutyRZfE2iCRE+DuEUpBSyRJGh46UUBikUFllQ=;
	b=CP8WvIT4ENccEwlakKmMoEGXMFimK300OYHGhgL18mc7uMEwtX0ie7OKL6NNoppU9PUO9z
	hzKhW9aQ7hv6fYw0cNtJrshAbrdS83gEKKPzIiMrTuxK7MXyr3DOPz81ebP7UKxw1g2B1x
	QZbpQ9uZgYmT3zNlbYK3NONB7yYzKXw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=VfCWbYKm;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.70 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sQyJ8wKE3EhctGxNA5oMvPy3m526Tw44qVKLxoqGJoOFrdMnRtIxZip0wq1seP6w6JQVh2GpL7zDP9vwy93fxOFl9c7qyXPbV4IYh+DnsVvuygdkanRPfxjU/Z5FpfHdPhczT+WpDdaD8rq5LCy+jw88J7KUAvNDue1PGzjldVvtWK5Qas6Ih7S2sYdLKcyfaloOn35vLzivqMblw4SIIPi3XGzUf+BZWcyUZLSmNvRkIKwAd2NAWpbhGHdr2Aw1S5RhDJYTg8RdZnzgmKwMha/aE6gt0teoFSNIcgzEU/KDUMT1ShCg5tuz3jmHl7D9a7uBDt3bRBvDKme63S73Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V1O+RWutyRZfE2iCRE+DuEUpBSyRJGh46UUBikUFllQ=;
 b=LgRRqFlRAiAVy49CKKxXcZYd+ucQQP/eQ3NRMLoOOzi1nWWFawppu4m1jALgRMYx5OGOUJnvuM1P8kom4Jj2W5UKsLWZk85zScfs1unKureCFWVdjDwYgiy9yApOpHU7A6INol1KvK33yLH/RCZp8anPKBo2DPp9B7q29yz4qC10pj3L+F9Ui1JeM+FXh99HM0BHhCcFJYaWkQmO4mcDfb5hUMgZlG8SG4nYM7KmxHQlt+yoetN3EX3Z4n/GCcAgeRereIgvh9QAGBzSXZUgy/kAaSHuXnUA98qUFyhrJd5vHlgYifYBf71iO9fWtwT3LuoqiiiXjdimmBwYCXmtkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nvidia.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1O+RWutyRZfE2iCRE+DuEUpBSyRJGh46UUBikUFllQ=;
 b=VfCWbYKmQuzf/BdehGN4Cx8S/joNLdAKOSLJwCUUKjyMIx5xR2PvnZUcQ7POQ+wmPQ2vQgGTU1uuBAdTcn4sNBsMYoBUdb6r12HyM5ozU7PqZ0EFT8v0KE2XJGBfKSqJXR+oRvp73ThlcpmufnGpu44Nb78ioLLmI0TnMUWKG0A=
Received: from BL0PR05CA0004.namprd05.prod.outlook.com (2603:10b6:208:91::14)
 by BL3PR12MB9051.namprd12.prod.outlook.com (2603:10b6:208:3ba::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.15; Wed, 1 Jul
 2026 05:17:50 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:91:cafe::58) by BL0PR05CA0004.outlook.office365.com
 (2603:10b6:208:91::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.181.8 via Frontend Transport; Wed, 1
 Jul 2026 05:17:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Wed, 1 Jul 2026 05:17:50 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 1 Jul
 2026 00:17:45 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 1 Jul 2026 05:17:20 +0000
Subject: [PATCH v2 1/3] mm/migrate: rename page to folio leftovers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260701-migrate-cleanups-prep-v2-1-d9e8f17130b1@amd.com>
References: <20260701-migrate-cleanups-prep-v2-0-d9e8f17130b1@amd.com>
In-Reply-To: <20260701-migrate-cleanups-prep-v2-0-d9e8f17130b1@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost
	<matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>, Dev Jain <dev.jain@arm.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1782883059; l=4576;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=v0DwoMihxvlO0FxbDhBHypsRaTJYJ1nZirNT450ol7A=;
 b=KDgENflVP4hh0x1Jkh4qMBP5yXvmcyAkGs3rFG6F5b3oCVsH1S0I2yk2Z8VRAdG2d9iSRsF/x
 fWIqttzgjKCAP1kwniKxfyl1BQcyf2nl3UK5USji1yKMXr9T4Ptjj38
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|BL3PR12MB9051:EE_
X-MS-Office365-Filtering-Correlation-Id: 222d5cb1-69a9-4811-fd61-08ded730188b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|376014|82310400026|23010399003|7416014|11063799006|56012099006|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	1lS8MFbwyc76tRkg1OVB6ykgVzvwIoggvVzGQ2mjw3s5uQQ5qZsYLrF8mJwKwXm1T7jWEmrXLt6FcFfapt06IO/AJgpManpAW5Hn8o2K1ZiIqqkNDimnXdg1V6/x4zuI2OQs8dOtPH5M2bJ8qEPKGBJTDppou2z/JmDH/cpO+SP96PWgw/o9YwyW7+1HwZBogbqHOXVM5dmZ6/RHjTglpjC5pvBkPNf4jnIApIYV2uDjRVkvQp/Q6Iasz7ACyQMMwOfddxkZHL/U3w17fkibMuIXJtH4FFjSpfrDHRI+rb2FPDWFvdl01Q3BPT3HV7Hp0VgHlyt3FOafNWtU6blwBGSBM02EruK0RrP2RJamKfFWgIpjaXtmX4FoUpm6Gx1L3gp9EdIICaRB7NoJcqOQD/kHuh2HDXQeIjrgejjmno/zzQFdowN0PzBuOth7d3f0wRnicGAdTJQVZgd7GNEGOHL5QiHy7iTF/sDvcqh0oW4TyiZgYp4bWpTHwkOU0pGT7VZ0KLUjbfNikaJeuE0Tgn7Wb2ScLFGFQ9L7bsygWL5f0nkifZ+fpY5b7cPRrsVEEfhtibhV9A2J38AiJGPNq4UL1OS/eL1vKAohOvO9+eKi3Dvdjd41+uIO4+iesdz6YTE9uujK/76YexDXXLFNOYNHWmdSAoQUf4o2MsS2TJY5S5xX++VR100zYAAhH5DzHtcQ2aNSDUO5IYE35sE0sKNhNDKam7dS+0MnJ2hPCsVH5ElP/6bpCdvxo9ubzg2R
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(376014)(82310400026)(23010399003)(7416014)(11063799006)(56012099006)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cmKXd6IPmDKOJNDN03jDIefr2GuaSAHy3XaW3ELt2RCsdz2Oa55H1H5LpXzQ3sv8mbs5imoJL79Vtxn2FwndjaddZvQrwDF+Ajbch76geC+a4rFvHZUc+pI1amNgOLOfZ1WTC+U37CPrp0GXy9RYByNIvGR8HSpNlIYz/GOFMKpCHJ46+qX0qgAfaF3csUeqm4QSKvld/xybHQi48AlPDovI3t0HYk8N8FKVNUpO1/g43HDfm7ZWUwxl7gqXpcdSF70MhRt3Qc2wrTKXTcEnVGai50iZWjnvyGEhTkdK/GhEla0r1Z4iAUUidUqxZg/9EzB537mSvvIw18E9uOM8p7elbVC59x6VxHJgMAQti91nJ0jMT/hhLb+vqUBUvRdB0YYXxnGI3DHJFJUDgl01d1Y58E5RgDpjjrNoYqbqfFTJDifC/BdkH73RlvNlrYnv
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 05:17:50.2982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 222d5cb1-69a9-4811-fd61-08ded730188b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB9051
X-Stat-Signature: pjde6httcamaoskks153bno6dm4j544g
X-Rspamd-Queue-Id: BF4F520006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782883074-602693
X-HE-Meta: U2FsdGVkX1+enl/KJJYUgrS1tn/YJZMdSp+d4F7DfyJehfDcd3peaz8njM/ROLoCq2fXMv//jR8P3qngLlz0qpoU+rDWMQMWnv4zrNV4zsTNrKFCvepLk+XqlfAc3fUEp4welsw9hEhNWL0FlRylJE8UHlz7Eos7NVKQ5AXH1emOUIs125yRjJSzvwq71g0F/Dv9PMqV0Qx27o4vWiie54cbcDA6eR+juYQOqfYwBt+vwQCeEEXC/nFcs5nEfyVnKaszzktLh0pA43KbwDGjmH13ixncvuonPBYyDFGhNYD5344Fcb5vft93bwPJ4DNPSln/v2kpTkXKtQRDLND3ZSphrkoFcqkeyo0sQsRSDKEYnAB7zdhAZzX1Gvgw2+mxl//Hv6atJlTvGkxKRRHY9BUenDWFqVJmcyTYjUrfHTWXg01amwb2WaKr+1lfL30fVrJa1rswlJv++Qeb8U6qLMGklCf8H8dHhL88YD/smKrLW8sfU9wc3PaSZATMWaqRLs0w+QYeN9837EzOZplVk9o/PS0cOUqUI93PCMuLniJsOCOcd2rCfC06vemNbLReDDpbivpTRKr5Sv2gGBLBJh6r2XKAVsEltZf7pvWZDH7ECWntEkzpgpMwJ/8mv6Xgr+cSF3OQ/24SV4i+Y1OTkYRkhMNkxv8gqtZQsjE4VjU7jJi7jn0hppakiTH6HUv4WcdkdJSmNhDFsz4UvNxiOubPKojBq2xghdSJO/7zWaj0a8Lvj8P622W2kqCqoHsWQoH7XsTWyc8GfIrs00Xh9T/RnGpvW6xW812OLTdaUqr0B0b17PbV6abDBCi2BjfH24Y2mTb7P9nr2PezQeYLYn/D+PGUa9TAevvwXEcaCsdCDQ5xbyDMfHZIwqywEZSvXFYtCY6Vv9tQF7Jvja7uLw6M/pIayR26aWlGYsSHQ0eP+yki2Xgytjvc38CtUBtPX7V22UYFr19kG1Lh3oL
 aT4E1HUj
 ag0ORmPp7EJ1RAd7/uz8ux727KqzEDAX2/GaPucD1dU9UvFq5tk373P9L0XtzCzgXm3/3NDV56ENRsj0nj8aVApzFsXpd8eTSG3OgTuX0x+IJLZzTSh6DfC2RQPMEI4AGRydiN3SJVC7oDOOhwUsScs+0AN/4wlRJWZx8D63KHLpbHwyzLFr8bcAQDj7dFkg3ba5KPYc8tFmj0n0/hlTcixu8zniTmbzr28850ELexwtOShIXr4p8s7GdBwJbz4nVBmqHb5qbTSC8jA64eGlP8b+xlUNybyoCbRt0wzWI6bT7XidYSntcfJIiTANJnfTaE9o+9bqtft+JZPjO7JIzto7TVQHesmGEOxPqBMRW0GqK1YHYmtu/9sqUW0KozuVp4iFHQSpO3QmFbVaa0uCkTfHZ8w2hd0jYeks72vY1oP3oTiKaWhfIR74nBXBb13VHrKB9LCKI86QqX9xJ4RtALwfjRk7jnTYdGA5IcVNx1kHcpRLXI0mrrzcXlahzKpe205YPviY5ebFi+6zyDwkf7YaX28YqeUEmqAqSoZLuVHA99MLZCH1mV8T2POq/gKHbKm94QoVrgMBoD2+ZSyQN/SUounqZRAMzFx6V1OxVE8wB/CVHABV5d3vKhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename migrate_folio_undo_src()'s page_was_mapped parameter to was_mapped,
unmap_and_move_huge_page() to unmap_and_move_hugetlb_folio(), its
page_was_mapped variable to was_mapped and fix stale "page" wording in its
comments.

Also fix migrate_folio() kerneldoc to say "folio" instead of "page".

Suggested-by: Dev Jain <dev.jain@arm.com>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 mm/migrate.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 49e10feeb094..858350ca58b4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -884,7 +884,7 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
  * @mapping: The address_space containing the folio.
  * @dst: The folio to migrate the data to.
  * @src: The folio containing the current data.
- * @mode: How to migrate the page.
+ * @mode: How to migrate the folio.
  *
  * Common logic to directly migrate a single LRU folio suitable for
  * folios that do not have private data.
@@ -1157,13 +1157,10 @@ static void __migrate_folio_extract(struct folio *dst,
 }
 
 /* Restore the source folio to the original state upon failure */
-static void migrate_folio_undo_src(struct folio *src,
-				   int page_was_mapped,
-				   struct anon_vma *anon_vma,
-				   bool locked,
-				   struct list_head *ret)
+static void migrate_folio_undo_src(struct folio *src, int was_mapped,
+		struct anon_vma *anon_vma, bool locked, struct list_head *ret)
 {
-	if (page_was_mapped)
+	if (was_mapped)
 		remove_migration_ptes(src, src, 0);
 	/* Drop an anon_vma reference if we took one */
 	if (anon_vma)
@@ -1449,7 +1446,8 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 }
 
 /*
- * Counterpart of unmap_and_move_page() for hugepage migration.
+ * Counterpart of migrate_folio_unmap() and migrate_folio_move() for hugetlb
+ * folio migration.
  *
  * This function doesn't wait the completion of hugepage I/O
  * because there is no race between I/O and migration for hugepage.
@@ -1466,20 +1464,20 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
  * because then pte is replaced with migration swap entry and direct I/O code
  * will wait in the page fault for migration to complete.
  */
-static int unmap_and_move_huge_page(new_folio_t get_new_folio,
+static int unmap_and_move_hugetlb_folio(new_folio_t get_new_folio,
 		free_folio_t put_new_folio, unsigned long private,
 		struct folio *src, int force, enum migrate_mode mode,
 		enum migrate_reason reason, struct list_head *ret)
 {
 	struct folio *dst;
 	int rc = -EAGAIN;
-	int page_was_mapped = 0;
+	int was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
 	enum ttu_flags ttu = 0;
 
 	if (folio_ref_count(src) == 1) {
-		/* page was freed from under us. So we are done. */
+		/* folio was freed from under us. So we are done. */
 		folio_putback_hugetlb(src);
 		return 0;
 	}
@@ -1501,8 +1499,8 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	}
 
 	/*
-	 * Check for pages which are in the process of being freed.  Without
-	 * folio_mapping() set, hugetlbfs specific move page routine will not
+	 * Check for folios which are in the process of being freed.  Without
+	 * folio_mapping() set, hugetlbfs specific move folio routine will not
 	 * be called and we could leak usage counts for subpools.
 	 */
 	if (hugetlb_folio_subpool(src) && !folio_mapping(src)) {
@@ -1532,13 +1530,13 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		}
 
 		try_to_migrate(src, ttu);
-		page_was_mapped = 1;
+		was_mapped = 1;
 	}
 
 	if (!folio_mapped(src))
 		rc = move_to_new_folio(dst, src, mode);
 
-	if (page_was_mapped)
+	if (was_mapped)
 		remove_migration_ptes(src, !rc ? dst : src, ttu);
 
 	if (ttu & TTU_RMAP_LOCKED)
@@ -1663,10 +1661,10 @@ static int migrate_hugetlbs(struct list_head *from, new_folio_t get_new_folio,
 				continue;
 			}
 
-			rc = unmap_and_move_huge_page(get_new_folio,
-						      put_new_folio, private,
-						      folio, pass > 2, mode,
-						      reason, ret_folios);
+			rc = unmap_and_move_hugetlb_folio(get_new_folio,
+							  put_new_folio, private,
+							  folio, pass > 2, mode,
+							  reason, ret_folios);
 			/*
 			 * The rules are:
 			 *	0: hugetlb folio will be put back

-- 
2.43.0


