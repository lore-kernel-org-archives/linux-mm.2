Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3000606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=S2Jw7Io1
Received: by kanga.kvack.org (Postfix)
	id F1EB06B05B1; Mon, 16 Nov 2026 20:51:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF58F6B05B2; Mon, 16 Nov 2026 20:51:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33CE6B05B3; Mon, 16 Nov 2026 20:51:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9A056B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:51:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F7B71202E2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:51:57 +0000 (UTC)
X-FDA: 85442935074.18.B4D5C49
Received: from mta0.migadu.com (out-118.mta0.migadu.com [91.218.175.118])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6EC271A0005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:51:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2Jw7Io1;
	spf=pass (imf19.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.118 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pt8xvDwKeZFNbSLqDy3OvpUkDSrTrAmd4jUA7dH+Zmk=;
	b=6eIvTUjRz+C737GsxrXjVCEHI+F9cCRgpw3mnnagp5feQEqe4aN5Q1HgE05+XnPNGEACMh
	R9kZCuoAROYGAzVtRwxdsT3YewcA0hTT3OOuA+qoUGtaaqu+eZsNG4gVyxNt+kKWKi3HAa
	xjrZ2smvppOBWqdkbi/VOcsGiAdg0Bw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880316;
	b=g/UuTptGyltXm0//yKg88OpeL+Cy/ateikG+Pc9n2jANIF1TVj0ElwaKxF+cybMhz8sRvT
	GVrO5FT2LLgC3N6tmumlpHwrV8TWQw+GqoHtiblBCkCcwlAI674Gc+yI0oadLhORlpfQBL
	u/uiaX7tTyiXWjARTnhhiyQIsLahxkQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S2Jw7Io1;
	spf=pass (imf19.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.118 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KsT5VlOouw8+wlbQGGPvciVPDA8AmFbkB9L6Bo0igYA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794880313; v=1; x=1795485113;
 b=S2Jw7Io1U06ijobrAUij6SrLLss/9SNn2aFpyekCY3tg8xFgDm9DXGvCI8qhNsuwktEcmMo1
 62CJV/FjOz2vHFQubJTta1UWLRMeeRNa58UfPbzD+TasR4/c0ntTGlUbUM9P19OOWMWl52udXY7
 XAHZZy68bLnPaYBPzsnfpfWs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e35cf60e195adc0b;
	Tue, 17 Nov 2026 01:51:53 +0000
X-Mizu-Trace-ID: e35cf60e195adc0b
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Subject: [PATCH v4 1/2] mm/ksm: extract helper functions for scan cycle cleanup
Date: Tue, 17 Nov 2026 09:51:38 +0800
Message-Id: <20261117015138.612340-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261117015009.611551-1-xu.xin@linux.dev>
References: <20261117015009.611551-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6EC271A0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: pj5rztp9mp1g4xpuktcm1baynp5igbks
X-HE-Tag: 1794880315-881595
X-HE-Meta: U2FsdGVkX1+gRnM4qVoSpfpREHLts5xkOSJpkHaKI7E2K7xFFlKvNgjmw7F6zJi6Mv8LCovTlCinMb4hb+z5cxkJbwKo85AwAYaCJijtFnTYlbnfoeIoB+TYv4cXiTHE1daeUgmv2cRxSuljKWdJZEuUoO1e5ga/3yN2+SjRYzCFWTaAiLnkv+8oE982YtHzu0+shOVppGGyDEs+9rK/RRDjelvAtJSsSXEDNLU+d1qXZOYnyttsL0y2ccxC7lM+tidJ9mtaCKtXv3yNwzFn2DMDup7a7+yI+LCJgMCM+JxVq60G5r6lIY0qhpWZ1rwogHyij+FEBJNOPY2egwhHsnhXl7WGyFoxFn153rGiIJPyQlU1FgyKrAVsCM1jTqTUbAS1STfnlBouUD/hOU0tkKtLpnz9jzEyW1/2qB6h3P0rqEmLeKJBMi8XMGjxcsiJl6z10Ftyqb1/jwgYMLdyCXqOhONLGTlEBDmho48HodG7siw2ojm5t9x/RvQxinKxX/H4tjMy0IYKbAThh049icq5wOomiEkq21+hUwi/3olQ9hKw0b2LCrhNA7JqZI8x3nx4tp2OgZw18BfWd/3isOQrlq1OT3QbURfy3j0hXKxyfupJmZalW7pJJmOjupN1xSIicbvHRNp+sE6z1R+CUyqJuanF5qbYEeQDBM/hVRn/hgLCymclScCNk3+xyAc8VCBOa0Po/5ZVUslclw1RvBegGWtfLxyk79KKmmJ1lGEHm9yNdM6IA+0Tkfcs6CLOKHDH4PBzsS8Y+UV/nIdmZvaudJXim1fMnaBa9cZwjIfrbACfmDyY/WdIHVQjcI27m87dikkkd+NL0XUGciWFEIZ7dyoAY5wraTH/aovw05h8yvK7DO0x+XUyuCJKf5lE1rrxXJEzqofKjOfm9bVvennIP0WtLmGEbdePEXOy8QYWipa8uvbZwGfJY/Ao+9Wa1AT0C/Rbdb/nK1uYylP
 vjLX/TbW
 ta+a0zBgS1qxgIsQYsBtL4cL5qoJjQgjn86Gt77/TO73q7b4mtkR3MrEViajpi+CQiXf6OBdKvVLAi0yZS9bkAbj6XRPt7/ucfIH6sYQgdXrstORWWwjKtvs3DV3V3g50CYN4WJH8h0IolzWs+gSoOwx8yfycQfICKi0HRUonC6dGgrJF5xJCAdKvarE5kAHUAjAzxDoyfvHLk4Qd76P1cv3mGh60THCAZzsvQEneV4WJO/A4LvJjlh7rtg==
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


