Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B6A60A382E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=j9htu+g9
Received: by kanga.kvack.org (Postfix)
	id 309236B05B5; Thu, 12 Nov 2026 07:59:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0796B05C4; Thu, 12 Nov 2026 07:59:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DB56B05C5; Thu, 12 Nov 2026 07:59:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0201A6B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:59:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88CF31C2948
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:59:43 +0000 (UTC)
X-FDA: 85426473846.17.3D4BC3B
Received: from mta0.migadu.com (out-11.mta0.migadu.com [91.218.175.11])
	by imf18.hostedemail.com (Postfix) with ESMTP id 676D61C0002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:59:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j9htu+g9;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Kq7UED8yWl7smnWaQ122+SHPZANinmdZfnaIZ2GDo4=;
	b=CNXbPX9xsfWZFBUH8lNIXYQ1kgYYCi3NWqXiFaf+i5RIXO65c4ixkDZPRpde6y3SsdHDgq
	8zOp5NrIpJs2UEJ0M5x7QkF8dOAgi/ikawUUjeJf4gKX0itZD8gjFfQMt1mdkkzPwQ8YUO
	Rnzq5QTF7QgddRyDo/9ophLr7I+CXBg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488381;
	b=PH3U89DtJ35H5vcg1fEsxDJY2JnsopEtVFLdPcBvdA2pj7ZU7VeO9MToj6mDDWaHHwehas
	N0Ov1cuslrGDbhPORy26nKEHmaaJZK/R6S8vWIrULaZ8rUsOcmFseovMBPR8oQ5Hqpzvy6
	G3wdhsoxP6PvHrr+khlmwFkpEwSPHgY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j9htu+g9;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.11 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CRfd8+zYcRqY9z+4AYrFkkTq95qSoIZN0ekyLrC8jBI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794488380; v=1; x=1795093180;
 b=j9htu+g9tQIsaEz+W0EKwmRgq9PSInQAy7HTkgCckdwTUzWNm6o1sci12u3doqdnnT+hpfHI
 D0RkwXu3s3ltfe0ZlRvDvQJ2rwmiUmdlPPX//vW/kHTjTYvaFmiPkefE7CMfnTM7pwGZem/mF8p
 60lzjnQD5+sSHB3Wg3V8/3d4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 9721da014f7e0601;
	Thu, 12 Nov 2026 12:59:40 +0000
X-Mizu-Trace-ID: 9721da014f7e0601
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Subject: [PATCH 1/2] mm/ksm: extract helper functions for scan cycle cleanup
Date: Thu, 12 Nov 2026 20:59:28 +0800
Message-Id: <20261112125928.177598-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261112125754.176930-1-xu.xin@linux.dev>
References: <20261112125754.176930-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 4ei11unw3rkz393sa5xtax3wi4pp4wia
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 676D61C0002
X-Rspam-User: 
X-HE-Tag: 1794488381-243821
X-HE-Meta: U2FsdGVkX1+2q5rXvS9XccQ71JNpU/c4uIzWnNHjAGzCVUsbpirY1FxLSteWgBwpFlRMxe+/DXqensKiD9uJ+hqIVzQ/6YXNLF+0xoYuFnE781TEDVe0Axwk/cQBOMoXy8fvMAP7ZyKThgxHCm+4tND/DNuxUm7Aofihs3NO1I3w3M1XE8JGwvMjcRNkcGG1HdMC1LtQNK6eqIDdLwJi9SH087UH5j9w4hYV7eHXBXTXBPEgJ4JfoWWE4EqW9iN2VTM9d6YIzoR6vE1R9MmmV379Gj2jVk7fHCglvWToKe0UoCVpbkm6QuWPq6DxwTyIwxfzJ3zOmL5xYYxMveA0j3K0SVLLwisR2dStY/cVy61UjzKDgMJBE06Brwg/f9k/uyS06CKFSFbcLfP25BDfX7QWF88bHrWOA1yZxyzz7JpOMMUWR67OhcZmm4s0HmYwNdE3PKANQcsOftyadMSj7/7LBbF1BtIsFQOOWbS1Mp/1TvH8BEHnLEXTkBqG9cx3UIrAJ/caciC0mn/qoSqeI40xF4Tify5H+a2eCC1zgmWF6oeBnLZkrdJrDb65IguuXl6DcO2ZU9JTlRn9NgyAOLTN7swxRlTgLdFkkXzTQnRuPaHveyDsDW2oIgFK0LZebtJMIHmMBYccthn5Gy0xRxvfYKtPqUjcWdgRyzMYIVGyIRV0aataedFFeokwlUvqOCbajawnD/Wo1NXA+UU990UKOF2w958dMhNdL/r54awkjTB2KPANyF6ZTWvq3iNvTQ3fVyisJKF1q+L8ICO37TKVc3MwQB4ilpNds6dTCYmalEewhyGWbMyI8bz9Y6glZwFsBPw1a0F5bVVI1aM1tTIt11vtict/NAaaXtnb4E4oVvIsVqq+3YYHPbZYO4OFv0Hpcm+glB6WUYSYlBead3U9+tlonfWwniyjDWQ1o2smiNDFKFrclwjf8rXrCIY7ziYWyOF+0W3+xzWaeGz
 1BJHIla+
 /ELCdPmglD5rukYhabMvwm4BArpdd4CWnHI5pZ4zMA4TRqLTlCXpkg/kNTtf1Ft1wkfprYDuEMHH+IPeTXqI+F9LnddR+vKhiUyFhRcSxhSabUOZJV2fiIvL8OnXpXQGH0prlZVahVaV5zSxHAuVqs4z0U+1RDbDtqaaKpXlS0JZZPczbNdmJs40Bz9JnOCjDTOplO2zFObdU8hwNIKvr3pwUHMqEzMXazOvK
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
---
 mm/ksm.c | 56 +++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 23 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 5e24b5ca8dc8..49977bcf04f7 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2609,6 +2609,37 @@ static struct mm_walk_ops ksm_next_page_ops = {
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
+	int nid;
+
+	for (nid = 0; nid < ksm_nr_node_ids; nid++)
+		root_unstable_tree[nid] = RB_ROOT;
+}
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
@@ -2617,7 +2648,6 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 	struct vm_area_struct *vma;
 	struct ksm_rmap_item *rmap_item;
 	struct vma_iterator vmi;
-	int nid;
 
 	if (list_empty(&ksm_mm_head.slot.mm_node))
 		return NULL;
@@ -2639,28 +2669,8 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
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


