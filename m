Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D66CB104C00E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 11:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEEBF6B008C; Wed, 11 Mar 2026 07:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB50E6B0092; Wed, 11 Mar 2026 07:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8956B0093; Wed, 11 Mar 2026 07:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B5E2C6B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 07:03:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 408091A0763
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:03:52 +0000 (UTC)
X-FDA: 84533497104.01.B58015C
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4EF67180011
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:03:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773227030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hOEFRLd+F4JuwXZyqCGtIP1UkihzJsZD0Mq0x+ZVgF8=;
	b=1SgVbWzlkZahI8isNP9qimfTN/hIOWxkV3Yfjo/2Njwj9lH0LXeU0hKVgDtrojbuwA+qDo
	0Ndq2FaeqRKUGVW+pjSBPfc0auIachmpgnGCeuzo4JXUUsKkZw6xgt1tMATm+JvrUZ98bO
	lCOSIn1Rr/M9d2BV80/dGb2LsVS8Ifs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773227030; a=rsa-sha256;
	cv=none;
	b=S9q7K2XzVcgBN5yIy5wC5r8gffa7BwZko8v6mVtI6qcwGR/d7th38kBM88Yx6xilGMXnam
	t3Dtz2CaI2qUr/U4yZRsj8TxeqVc8U8dXbYsr/0QBSobU0ZzUAz+HJKczLXHEsd8n78bCv
	nM0bNmE/U0FOtjv0rlM33SolVJ1hrC8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 74F38432F6;
	Wed, 11 Mar 2026 11:03:44 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org
Cc: alexghiti@kernel.org,
	kernel-team@meta.com,
	akinobu.mita@gmail.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	gourry@gourry.net,
	apopple@nvidia.com,
	byungchul@sk.com,
	joshua.hahnjy@gmail.com,
	matthew.brost@intel.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH 1/4] mm: Move demotion related functions in memory-tiers.c
Date: Wed, 11 Mar 2026 12:02:40 +0100
Message-ID: <20260311110314.237315-2-alex@ghiti.fr>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311110314.237315-1-alex@ghiti.fr>
References: <20260311110314.237315-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: 0
X-GND-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeefjeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuifetpfffkfdpucggtfgfnhhsuhgsshgtrhhisggvnecuuegrihhlohhuthemuceftddunecunecujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomheptehlvgigrghnughrvgcuifhhihhtihcuoegrlhgvgiesghhhihhtihdrfhhrqeenucggtffrrghtthgvrhhnpefhjeejtdelteefuedvffduheeifeeggeefudevfefhleduvdeutdeiteeukeegveenucfkphepvdeivddtmedutdgumegttdelvdemgedttdemmeehmeefrgeivgenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedviedvtdemuddtugemtgdtledvmeegtddtmeemheemfegriegvpdhhvghloheprghlvgigghhhihhtihdqfhgvughorhgrqdfrhfegofekiedvrfdrthhhvghfrggtvggsohhokhdrtghomhdpmhgrihhlfhhrohhmpegrlhgvgiesghhhihhtihdrfhhrpdhqihgupeejgefhfeekgeefvdfhiedpmhhouggvpehsmhhtphhouhhtpdhnsggprhgtphhtthhopedvkedprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprghlvgigghhhihhtiheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvghlqdhtvggrmhesmhgvthgrrdgtohhmpdhrtghpthhtoheprghkihhnohgsu
 hhmihhtr
 gesghhmrghilhdrtghomhdprhgtphhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlohhrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomh
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4EF67180011
X-Stat-Signature: oo767rxfhgii7hxszogn1e7b6dkncgxw
X-HE-Tag: 1773227030-350320
X-HE-Meta: U2FsdGVkX191Y9XwBDuBkW3ymMH8CNQJETP8oBjVPc1bmsHBMDX58mBCr/6StUaoorMS9pDTdx/sDV5wsAOuzHdJsswKvf/fmzqRJuuybfSauQSIfe2YoeUyFFjQQWa+sxlw8RYMgST1RRMq1m/AONkuNKcdbutRlP4p1Wk9l68emZSO7Jocfvr+nHrP8KcBEMpA5oOOivnebn9w3ghb7NQhVv+DuOZ1llVHF8v8hN1xVTKsPjZyNlO5zz1ozZmENXXPKRD/7WguabmtXxOffR2pBGWsiDXMxNIuC8y1AhozOgB+Xq/o/SOjn4vNTTQokfNqhzI8ZVRLzodqP0P7jOAz5ypnVV7qinVBdzXrTl8OrsVjenrMU2vCnrH6s/TcTQj95rm4VyT4j7Ux/YIHGMb8JGKuoJiq2DD59m+C39tGzEtKJ9VPQ9rF2QB0zpzU4DIVabGSr9cmEaPy5g3i+JC9hwqabeV6yXIInuf9J6Kqa2QjXX95hytf+ooBrLCM1sEgA8UsQtvuan/fIzqkCdH/tJ2vX9NX+viYg8QtSpEcW1/i5L7QwnuiVjPXEArumM4V6Dw6Ff1dmF49oApdFmeYPGgzub7gS3ozMSvQx6wmYeFUqnQ/cO/hXf+7kCvt3quno8Wn5TMOrbvPgQ9Rdm6jSjJNZF3RTaKFQWZlhfV7TQQquir7pukyEMOT4XWamwzuC2izkzCdVcVAIXSbs7ijy7cDi0uN5gnhPvk5wu+RadMT+tLGPpGI7cIQ/opEtHy7hpdaP1XEvNw2Z3gitqMzV4Cir1q9RYrDZfmz34356fz0pI+exgC3mkh6csGJuDXwLe/Rpv56Kv6WHJEJrtpvmKJLr8sK2yMH7m1Mx5/Ne5hHFpcn/PutWwAGkgLGgkiXZRp5gwGklnQUNufQ00dWGdK9JYRdCG8yprda1uOghMqvuIYw7VrGglpISnNAtAfw1mvoZ5bEDN5hMnr
 lsuf6rgV
 a8dDTsrQe73R9SPONE9P6f/JEz0CpiE/cgyTsESYbm4CvCKSlNz0OAB3JSZZCen51ocIXFBBKvbbN42yGWvjp+BXhgiVtL5ePLM1CoEiPIql3rsE9JE4USMphp4WsVKPtJOSZHzOdogd2DdTypoz3tEz24lxwGMz9ywneXp1bSEhP+t0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's have all the demotion functions in this file, no functional
change intended.

Suggested-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/memory-tiers.h | 18 ++++++++
 mm/memory-tiers.c            | 75 +++++++++++++++++++++++++++++++++
 mm/vmscan.c                  | 80 +-----------------------------------
 3 files changed, 94 insertions(+), 79 deletions(-)

diff --git a/include/linux/memory-tiers.h b/include/linux/memory-tiers.h
index 96987d9d95a8..0bf0d002939e 100644
--- a/include/linux/memory-tiers.h
+++ b/include/linux/memory-tiers.h
@@ -56,6 +56,9 @@ void mt_put_memory_types(struct list_head *memory_types);
 int next_demotion_node(int node, const nodemask_t *allowed_mask);
 void node_get_allowed_targets(pg_data_t *pgdat, nodemask_t *targets);
 bool node_is_toptier(int node);
+unsigned int mt_demote_folios(struct list_head *demote_folios,
+			      struct pglist_data *pgdat,
+			      struct mem_cgroup *memcg);
 #else
 static inline int next_demotion_node(int node, const nodemask_t *allowed_mask)
 {
@@ -71,6 +74,14 @@ static inline bool node_is_toptier(int node)
 {
 	return true;
 }
+
+static inline unsigned int mt_demote_folios(struct list_head *demote_folios,
+					    struct pglist_data *pgdat,
+					    struct mem_cgroup *memcg)
+{
+	return 0;
+}
+
 #endif
 
 #else
@@ -116,6 +127,13 @@ static inline bool node_is_toptier(int node)
 	return true;
 }
 
+static inline unsigned int mt_demote_folios(struct list_head *demote_folios,
+					    struct pglist_data *pgdat,
+					    struct mem_cgroup *memcg)
+{
+	return 0;
+}
+
 static inline int register_mt_adistance_algorithm(struct notifier_block *nb)
 {
 	return 0;
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 986f809376eb..afdf21738a54 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -7,6 +7,7 @@
 #include <linux/memory-tiers.h>
 #include <linux/notifier.h>
 #include <linux/sched/sysctl.h>
+#include <linux/migrate.h>
 
 #include "internal.h"
 
@@ -373,6 +374,80 @@ int next_demotion_node(int node, const nodemask_t *allowed_mask)
 	return find_next_best_node(node, &mask);
 }
 
+static struct folio *alloc_demote_folio(struct folio *src,
+					unsigned long private)
+{
+	struct folio *dst;
+	nodemask_t *allowed_mask;
+	struct migration_target_control *mtc;
+
+	mtc = (struct migration_target_control *)private;
+
+	allowed_mask = mtc->nmask;
+	/*
+	 * make sure we allocate from the target node first also trying to
+	 * demote or reclaim pages from the target node via kswapd if we are
+	 * low on free memory on target node. If we don't do this and if
+	 * we have free memory on the slower(lower) memtier, we would start
+	 * allocating pages from slower(lower) memory tiers without even forcing
+	 * a demotion of cold pages from the target memtier. This can result
+	 * in the kernel placing hot pages in slower(lower) memory tiers.
+	 */
+	mtc->nmask = NULL;
+	mtc->gfp_mask |= __GFP_THISNODE;
+	dst = alloc_migration_target(src, (unsigned long)mtc);
+	if (dst)
+		return dst;
+
+	mtc->gfp_mask &= ~__GFP_THISNODE;
+	mtc->nmask = allowed_mask;
+
+	return alloc_migration_target(src, (unsigned long)mtc);
+}
+
+unsigned int mt_demote_folios(struct list_head *demote_folios,
+			      struct pglist_data *pgdat,
+			      struct mem_cgroup *memcg)
+{
+	int target_nid;
+	unsigned int nr_succeeded;
+	nodemask_t allowed_mask;
+
+	struct migration_target_control mtc = {
+		/*
+		 * Allocate from 'node', or fail quickly and quietly.
+		 * When this happens, 'page' will likely just be discarded
+		 * instead of migrated.
+		 */
+		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
+			__GFP_NOMEMALLOC | GFP_NOWAIT,
+		.nmask = &allowed_mask,
+		.reason = MR_DEMOTION,
+	};
+
+	if (list_empty(demote_folios))
+		return 0;
+
+	node_get_allowed_targets(pgdat, &allowed_mask);
+	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
+	if (nodes_empty(allowed_mask))
+		return 0;
+
+	target_nid = next_demotion_node(pgdat->node_id, &allowed_mask);
+	if (target_nid == NUMA_NO_NODE)
+		/* No lower-tier nodes or nodes were hot-unplugged. */
+		return 0;
+
+	mtc.nid = target_nid;
+
+	/* Demotion ignores all cpuset and mempolicy settings */
+	migrate_pages(demote_folios, alloc_demote_folio, NULL,
+			(unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
+			&nr_succeeded);
+
+	return nr_succeeded;
+}
+
 static void disable_all_demotion_targets(void)
 {
 	struct memory_tier *memtier;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..5e0138b94480 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -983,84 +983,6 @@ static void folio_check_dirty_writeback(struct folio *folio,
 		mapping->a_ops->is_dirty_writeback(folio, dirty, writeback);
 }
 
-static struct folio *alloc_demote_folio(struct folio *src,
-		unsigned long private)
-{
-	struct folio *dst;
-	nodemask_t *allowed_mask;
-	struct migration_target_control *mtc;
-
-	mtc = (struct migration_target_control *)private;
-
-	allowed_mask = mtc->nmask;
-	/*
-	 * make sure we allocate from the target node first also trying to
-	 * demote or reclaim pages from the target node via kswapd if we are
-	 * low on free memory on target node. If we don't do this and if
-	 * we have free memory on the slower(lower) memtier, we would start
-	 * allocating pages from slower(lower) memory tiers without even forcing
-	 * a demotion of cold pages from the target memtier. This can result
-	 * in the kernel placing hot pages in slower(lower) memory tiers.
-	 */
-	mtc->nmask = NULL;
-	mtc->gfp_mask |= __GFP_THISNODE;
-	dst = alloc_migration_target(src, (unsigned long)mtc);
-	if (dst)
-		return dst;
-
-	mtc->gfp_mask &= ~__GFP_THISNODE;
-	mtc->nmask = allowed_mask;
-
-	return alloc_migration_target(src, (unsigned long)mtc);
-}
-
-/*
- * Take folios on @demote_folios and attempt to demote them to another node.
- * Folios which are not demoted are left on @demote_folios.
- */
-static unsigned int demote_folio_list(struct list_head *demote_folios,
-				      struct pglist_data *pgdat,
-				      struct mem_cgroup *memcg)
-{
-	int target_nid;
-	unsigned int nr_succeeded;
-	nodemask_t allowed_mask;
-
-	struct migration_target_control mtc = {
-		/*
-		 * Allocate from 'node', or fail quickly and quietly.
-		 * When this happens, 'page' will likely just be discarded
-		 * instead of migrated.
-		 */
-		.gfp_mask = (GFP_HIGHUSER_MOVABLE & ~__GFP_RECLAIM) |
-			__GFP_NOMEMALLOC | GFP_NOWAIT,
-		.nmask = &allowed_mask,
-		.reason = MR_DEMOTION,
-	};
-
-	if (list_empty(demote_folios))
-		return 0;
-
-	node_get_allowed_targets(pgdat, &allowed_mask);
-	mem_cgroup_node_filter_allowed(memcg, &allowed_mask);
-	if (nodes_empty(allowed_mask))
-		return 0;
-
-	target_nid = next_demotion_node(pgdat->node_id, &allowed_mask);
-	if (target_nid == NUMA_NO_NODE)
-		/* No lower-tier nodes or nodes were hot-unplugged. */
-		return 0;
-
-	mtc.nid = target_nid;
-
-	/* Demotion ignores all cpuset and mempolicy settings */
-	migrate_pages(demote_folios, alloc_demote_folio, NULL,
-		      (unsigned long)&mtc, MIGRATE_ASYNC, MR_DEMOTION,
-		      &nr_succeeded);
-
-	return nr_succeeded;
-}
-
 static bool may_enter_fs(struct folio *folio, gfp_t gfp_mask)
 {
 	if (gfp_mask & __GFP_FS)
@@ -1573,7 +1495,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	/* 'folio_list' is always empty here */
 
 	/* Migrate folios selected for demotion */
-	nr_demoted = demote_folio_list(&demote_folios, pgdat, memcg);
+	nr_demoted = mt_demote_folios(&demote_folios, pgdat, memcg);
 	nr_reclaimed += nr_demoted;
 	stat->nr_demoted += nr_demoted;
 	/* Folios that could not be demoted are still in @demote_folios */
-- 
2.53.0


