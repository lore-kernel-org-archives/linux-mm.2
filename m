Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD41606A321
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 01:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aI2KzWyP
Received: by kanga.kvack.org (Postfix)
	id 52E8D6B05B3; Sun, 15 Nov 2026 20:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DE6D6B05B4; Sun, 15 Nov 2026 20:45:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F49E6B05B5; Sun, 15 Nov 2026 20:45:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 199CF6B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:45:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CD328A860E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:45:53 +0000 (UTC)
X-FDA: 85439290986.27.1A3FCFC
Received: from mta1.migadu.com (out-52.mta1.migadu.com [95.215.58.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id AAEF6120003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:45:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aI2KzWyP;
	spf=pass (imf29.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.52 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794793552;
	b=5uSD6F9FXSYe26GQq7aZGGopa2EI13UpfHiyAmg04yf+W7S9I4R4FG/3GVuwFUrrs39K/X
	ZjqxVYQ42KO+ORtWPmptf20JSJx2b0QT8UMhYmHErrcnrATQi7CHqNdFh9/To01xuJriOb
	no2d7mJCNtRATvhyxPOho+2yvWnuF7w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aI2KzWyP;
	spf=pass (imf29.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.52 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794793552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pt8xvDwKeZFNbSLqDy3OvpUkDSrTrAmd4jUA7dH+Zmk=;
	b=Z0OXaFPZbHDS+JcLY6Xk0BA7nMmTTVxc98eCyNZ9fhEC9AqbZm4omvSlni1mlCHiI6BsPA
	rY60Tqad5tU8d5d8oqB0DhWfc+bVd31/OCmY1WVw/nZMRncRmhIai9dO4lk4YU+FkRa8Vm
	kiV3Q2QcqQTO+Pzmbmpz8cQvHIBnrGo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KsT5VlOouw8+wlbQGGPvciVPDA8AmFbkB9L6Bo0igYA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794793550; v=1; x=1795398350;
 b=aI2KzWyPKd0vCzFogv4NuhiGjEgI63Mmu5lZUvGyFwsdnU+MvK/tDbMM71ItaBGcn3cQ+qzs
 WO0ZP5SHGQzKleh+axKi42gwpcHvodN7U4hUDbf6Q9h38G4iD8WLJ1E7IUgxhsy6m3QCC6mXm+T
 OOzxJR4SNX4IBzT/61ITgwEc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 3f9af6bc78a53944;
	Mon, 16 Nov 2026 01:45:50 +0000
X-Mizu-Trace-ID: 3f9af6bc78a53944
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Subject: [PATCH v3 1/2] mm/ksm: extract helper functions for scan cycle cleanup
Date: Mon, 16 Nov 2026 09:45:32 +0800
Message-Id: <20261116014532.310270-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261116014434.310003-1-xu.xin@linux.dev>
References: <20261116014434.310003-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f9gqp8kafjx5rticke9kwqgouzezzzar
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AAEF6120003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794793551-22313
X-HE-Meta: U2FsdGVkX181StBpuihTSa5itLgSTRiGm3T7oo7STACx6nSE9XQYhNj/R3+Zev51hIMkglkWp6UMtjS5f7kdrcUcL3Z0PtMVq8biWOE9b8V6Z698/ADSBdL62kjJYiG2VbxBCbc/iMnBoS06uVRZnNDjjNWTlJWxQkoy9iaw6NNj7/LEIa35W0d1RDmB+00zOpbue+0K2eIi6vdzrMtlCAkxYCeojzfmFDLC3ubAnhohLsqMLLiRWt84eX88LRrh9ZbmMug7QMXUUZUYnGf81KCfaS/du9tQ9LD6ZSyiCDyMN5heFojC21hJSq6LUZ4NvgRIkxc4abCAEXNkJnaWvs+sWucQKy1erzHSSPnGBofKQaYuxGJDJ+Fa5ygxWXD2J0d7f9VGMfNk6QU3ekJ2zWL4HMoQuL0pC3l9U39nSsbFsM2+OaKOp4ykxlaG9xQq+EL+uJwsHTPz2rKMY4j1cPJmFfR5u+DRpMNdysFnJTTVY8S5BCTqLI8TLI5YMAbmGVWNF8nW8pZK3DIBdR+5EK+kLGRpj6fiTCwUNNQVYsQKvp6LRwM5QU/7QKamy4LbJcov+mrsMwKzRdyT7kXqLxLiNz9Oc5GnaZrYxWfJk91hBERar1yRM9GMYb+aWlrzzHElDE7J5TstMIwkoGSG5HgFZ9PrGWLgQCgxh+DLUzldPLjB8mDhFZGe8EHfly6PemH5SAMZn/ucLTiFe3EGrtTEI2rJFAPab+AHfQ6CBnAdlf77JsFxPkyt2nkO/pP+SKHBeggaAuUO1ugRw4M84Sv5adJPSCI2JHISF/wdBcLau98FeRlPbWht33UuEEcUje324rcmL+Mdru1DEjPl6xQ99syyxnIHdRggkKRAtUgLlRSoPL3jtxL+dGbDEBOjNm/5f4fmb308xRzZzNNr5S5s44wS1Nxvf/7sVlQIWTda1buaFAKOQdIFnDCh7Ja9R7GswIMBdBz2Kvqqh0G
 vWibM5oF
 dXJsgWCLhtbA6uXkDPLd2woLb0K2Dr/7HW71TdAYB/pQewlv8kVTFSTw+r9c8kKYuUxR5LYgby9Lq50auWaG4HUw491FsbRsTEOskmJ9za1dXYJou6xQarGpT5Bm397rxJk+JikoeSAVSvodfiuv+0+wRSTsRKGF2ulj+3IeymdtvQegITWhFGGIdPiXhARbOD1qOpCpx7LgvV+y9JYbGcwNJLH0+xGqKyaW9EuaVd6PQLX3Woxp6vi82JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since scan_get_next_rmap_item() is getting too large, extract two new
helper functions, ksm_prune_migrate_nodes() and ksm_reset_unstable_trees(),
to reduce indentation levels, isolate local variables, and improve the
readability of the main scan loop.

No functional change intended.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/ksm.c | 54 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 5e24b5ca8dc8..8db6743ece6d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2609,6 +2609,35 @@ static struct mm_walk_ops ksm_next_page_ops = {
 	.walk_lock = PGWALK_RDLOCK,
 };
 
+static void ksm_prune_migrate_nodes(void)
+{
+	struct ksm_stable_node *stable_node, *next;
+	struct folio *folio;
+
+	if (ksm_merge_across_nodes)
+		return;
+
+	/*
+	 * Whereas stale stable_nodes on the stable_tree itself
+	 * get pruned in the regular course of stable_tree_search(),
+	 * those moved out to the migrate_nodes list can accumulate:
+	 * so prune them once before each full scan.
+	 */
+	list_for_each_entry_safe(stable_node, next, &migrate_nodes, list) {
+		folio = ksm_get_folio(stable_node, KSM_GET_FOLIO_NOLOCK);
+
+		if (folio)
+			folio_put(folio);
+		cond_resched();
+	}
+}
+
+static void ksm_reset_unstable_trees(void)
+{
+	for (int nid = 0; nid < ksm_nr_node_ids; nid++)
+		root_unstable_tree[nid] = RB_ROOT;
+}
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
@@ -2617,7 +2646,6 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 	struct vm_area_struct *vma;
 	struct ksm_rmap_item *rmap_item;
 	struct vma_iterator vmi;
-	int nid;
 
 	if (list_empty(&ksm_mm_head.slot.mm_node))
 		return NULL;
@@ -2639,28 +2667,8 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		 */
 		lru_add_drain_all();
 
-		/*
-		 * Whereas stale stable_nodes on the stable_tree itself
-		 * get pruned in the regular course of stable_tree_search(),
-		 * those moved out to the migrate_nodes list can accumulate:
-		 * so prune them once before each full scan.
-		 */
-		if (!ksm_merge_across_nodes) {
-			struct ksm_stable_node *stable_node, *next;
-			struct folio *folio;
-
-			list_for_each_entry_safe(stable_node, next,
-						 &migrate_nodes, list) {
-				folio = ksm_get_folio(stable_node,
-						      KSM_GET_FOLIO_NOLOCK);
-				if (folio)
-					folio_put(folio);
-				cond_resched();
-			}
-		}
-
-		for (nid = 0; nid < ksm_nr_node_ids; nid++)
-			root_unstable_tree[nid] = RB_ROOT;
+		ksm_prune_migrate_nodes();
+		ksm_reset_unstable_trees();
 
 		spin_lock(&ksm_mmlist_lock);
 		slot = list_entry(mm_slot->slot.mm_node.next,
-- 
2.34.1


