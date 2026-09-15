Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C9F4C982C1
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 175916B00A7; Tue, 15 Sep 2026 11:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127726B00AA; Tue, 15 Sep 2026 11:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 015ED6B00AB; Tue, 15 Sep 2026 11:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D40B86B00A7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 098991A0454
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:44 +0000 (UTC)
X-FDA: 85216341168.23.4DD9AB0
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9975C14000E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mW2YydQ2;
	spf=pass (imf09.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sv09B+MaJGyVcGZqapK5SgsF5E0P5ewgC7egR+zOg9M=;
	b=p+jYWB07b9iMm+1j+KIuEOYJFXgpp9/w7DkzvoX3KwYIghDSh4CDOVq4XbT/nrChEachL5
	e6kF3yuN+CRJXc34m1QI2WBqqfxrJDvPWXlTkHb6wM2zCA8MPhZjJHVpj1/9PVex9YYBwB
	c9Au6nB6yxULgOVS73nUNXOrCgNQa6Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485222;
	b=A2U8MVgQsV9ONz9E9LyvThqDNup/oLtLXcBRB5w2jc7IuQhsR4DXgkbnZug0j6uDlwo6sj
	RXixDExFPT9FJf+s2Q1mdu8r79usF7nw8eIRa0VSh3hEqB/lk2UhbCkaAimHRY1qMW7wY1
	h1AxewEh5L88UaoM5V8+5EODKdz7mT4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mW2YydQ2;
	spf=pass (imf09.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Sv
	09B+MaJGyVcGZqapK5SgsF5E0P5ewgC7egR+zOg9M=; b=mW2YydQ2/Df4qOjQZl
	WJUurtKDSLzDtccttVq3nN9SgLQEm6EgJfhZYIRdn5vZhOnT21sedebXH+GPvAsz
	UtO8c6RS+ndCRGd38QYIHn82M9bdRvKglhejZfJ8OjV2j+BtSE1alusPKgSWvtq8
	qxF1OwzNtftoXWAO8cPfWOqus=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S12;
	Tue, 15 Sep 2026 23:13:24 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] mm/ksm: extract ksm_begin_full_scan() from scan_get_next_rmap_item()
Date: Tue, 15 Sep 2026 23:12:24 +0800
Message-ID: <20260915151236.5200-11-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S12
X-Coremail-Antispam: 1Uf129KBjvJXoW3Jr4kKFykWF48tr15XFWUurg_yoW7WF43pr
	Wak3yakrs5Ar10grWfJr48CrWavrWkKw48Jw13Cw4xCwn8KryIqF1xt3W0qFy5CFykZwnI
	va1jkF1DCrsay3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jU0edUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xRCO2qpYJRR-QAA3B
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: sjauwytaqmi94u66mh5kb4ep5dd6q8aj
X-Rspamd-Queue-Id: 9975C14000E
X-HE-Tag: 1789485220-226758
X-HE-Meta: U2FsdGVkX1/OUhPjF6xzr+qqjx227g2oia5muKSNbzd/BQmI79gRzFP2ubh0hheoIYQSBlv+GFdyFccrT0AjC4goBVf5Ty3tzd0GV2My31I1Ou18suP2txcevMUHFGyr1bGrouFoWLr+OqWsDuEku/W5v2qHgGBqzT+eiI3mT7CJwswxlw15I6yFrrY6qrodGoODlWCVOyk0uiG1TusYC85U8TbXnLcnelWusmm3cV4PA2dPUJbDTtBcnesSgJQO70Gl22Qb0dl/KucMUz/r5xMC8bWrauZDhHBJjg1EWBMpFmvtQD6OzV60FVscn86JyCCTw2r4T0ZdHYojosDGVKHERJi7cJ0JygD5susFU1Ch3fS52VVoA26/Czq6x7yAu6Q6h643btBT17bhu1J7grPrLcZGOND9TTUyKyb/XPulIKOpbVd0HgiGOUUd8wzm0WRYeS4s0f0H2VomGJACr+h5tCUYzTm6JnqOtP8j3PZuH0ekJLopOBXlFHfNpI0itgC4A6OeSroZMMyB4pRwcJYidN5zstZl+dDsH9Wyg2qbrietJv8oiyFVUVu6hKJAFTwMdTUxKGVQk6agtXcQh50cLoZzR8MBE2nYGMm96nVfPlzlKdr7pfubewL8gn+fftyooR+5AI4lNB/EVtb6X8Svzh6XCX59GRg5avN0BjvnfG+G5xMqOQ5PMDgEMts1L7MaKlM5bUjOEH+bUYXU8PoZxPf0QJh/Z/x6RisJM+insrVXOnttvthtnCfqATf5g9iA6QtIUpiuA7X2kQbeSnrhRQIdo6fSM0YATztROIZ/mSf22u+vjLSENvnMpABdBqstg91wfqs8deTxdB4Aa7z073kgKwJTUaJ1sm9jdtpEhR8Sb35C8zr4NqRoZlCnFBSdnaDehOT2SvBl9w29XH78KQ1WWRg+PhN8Z/Vtf4+ydcQdanyQvFa9hkoHYxT8bUrXNCpam8lr2xyuoW5
 okkB3f1G
 nV7buMBAWlxEt9m8zb2z4kqjHnlFIviMDunW7hRnRiM/v0KSVhK+luy2VZAr7Pv6TcN9h6DxJ0//LLLZT6TqIxauU/lJdYbeV9J4JfdThmUOd+S5W5xFZ0x+tmlV5ZjfWFcJCTAEslssOL2nWSFiBmLr+XXCeOQG3nrzBSbVW7qVaBcQyLpSzHvh097QTb0u57zBflxwNIkoRrDpokCvKUAAQlY7jLVGdnBX1EnJATh8+q1BS7eXAoPJVgnBOfBwdWf57Hth1gtXreAC9weJcQA3PzT1X+9WkAPVt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Extract the once-per-full-scan setup into ksm_begin_full_scan() to
shorten scan_get_next_rmap_item().

Move next_mm out of the if block. Reset address and rmap_list only when
starting a new mm, preserving both cursors when resuming a scan.

No functional change intended.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 108 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 44 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 59887a2b4406..8884964d5a53 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1137,6 +1137,64 @@ static struct ksm_mm_slot *advance_scan_mm_slot(struct ksm_mm_slot *mm_slot)
 	return ksm_scan.mm_slot;
 }
 
+/*
+ * ksm_begin_full_scan - start a new full scan of all mergeable mms
+ *
+ * Called when the scanning cursor has come back around to ksm_mm_head:
+ * drain the per-cpu pagevecs, prune the migrate_nodes list and reset
+ * the unstable trees for the new pass, then move the cursor onto the
+ * first mm slot.  Returns the new cursor, which is &ksm_mm_head itself
+ * if a racing __ksm_exit removed the last mm from the list.
+ */
+static struct ksm_mm_slot *ksm_begin_full_scan(void)
+{
+	struct ksm_mm_slot *mm_slot;
+	int nid;
+
+	advisor_start_scan();
+	trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
+
+	/*
+	 * A number of pages can hang around indefinitely in per-cpu
+	 * LRU cache, raised page count preventing write_protect_page
+	 * from merging them.  Though it doesn't really matter much,
+	 * it is puzzling to see some stuck in pages_volatile until
+	 * other activity jostles them out, and they also prevented
+	 * LTP's KSM test from succeeding deterministically; so drain
+	 * them here (here rather than on entry to ksm_do_scan(),
+	 * so we don't IPI too often when pages_to_scan is set low).
+	 */
+	lru_add_drain_all();
+
+	/*
+	 * Whereas stale stable_nodes on the stable_tree itself
+	 * get pruned in the regular course of stable_tree_search(),
+	 * those moved out to the migrate_nodes list can accumulate:
+	 * so prune them once before each full scan.
+	 */
+	if (!ksm_merge_across_nodes) {
+		struct ksm_stable_node *stable_node, *next;
+		struct folio *folio;
+
+		list_for_each_entry_safe(stable_node, next,
+					 &migrate_nodes, list) {
+			folio = ksm_get_folio(stable_node,
+					      KSM_GET_FOLIO_NOLOCK);
+			if (folio)
+				folio_put(folio);
+			cond_resched();
+		}
+	}
+
+	for (nid = 0; nid < ksm_nr_node_ids; nid++)
+		root_unstable_tree[nid] = RB_ROOT;
+
+	spin_lock(&ksm_mmlist_lock);
+	mm_slot = advance_scan_mm_slot(&ksm_mm_head);
+	spin_unlock(&ksm_mmlist_lock);
+	return mm_slot;
+}
+
 #ifdef CONFIG_SYSFS
 /*
  * Only called through the sysfs control interface:
@@ -2633,65 +2691,24 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 	struct vm_area_struct *vma;
 	struct ksm_rmap_item *rmap_item;
 	struct vma_iterator vmi;
-	int nid;
 
 	if (list_empty(&ksm_mm_head.slot.mm_node))
 		return NULL;
 
 	mm_slot = ksm_scan.mm_slot;
 	if (mm_slot == &ksm_mm_head) {
-		advisor_start_scan();
-		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
-
-		/*
-		 * A number of pages can hang around indefinitely in per-cpu
-		 * LRU cache, raised page count preventing write_protect_page
-		 * from merging them.  Though it doesn't really matter much,
-		 * it is puzzling to see some stuck in pages_volatile until
-		 * other activity jostles them out, and they also prevented
-		 * LTP's KSM test from succeeding deterministically; so drain
-		 * them here (here rather than on entry to ksm_do_scan(),
-		 * so we don't IPI too often when pages_to_scan is set low).
-		 */
-		lru_add_drain_all();
-
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
-
-		spin_lock(&ksm_mmlist_lock);
-		mm_slot = advance_scan_mm_slot(mm_slot);
-		spin_unlock(&ksm_mmlist_lock);
+		mm_slot = ksm_begin_full_scan();
 		/*
 		 * Although we tested list_empty() above, a racing __ksm_exit
 		 * of the last mm on the list may have removed it since then.
 		 */
 		if (mm_slot == &ksm_mm_head)
 			return NULL;
-next_mm:
 		ksm_scan.address = 0;
 		ksm_scan.rmap_list = &mm_slot->rmap_list;
 	}
 
+next_mm:
 	slot = &mm_slot->slot;
 	mm = slot->mm;
 	vma_iter_init(&vmi, mm, ksm_scan.address);
@@ -2811,8 +2828,11 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 
 	/* Repeat until we've completed scanning the whole list */
 	mm_slot = ksm_scan.mm_slot;
-	if (mm_slot != &ksm_mm_head)
+	if (mm_slot != &ksm_mm_head) {
+		ksm_scan.address = 0;
+		ksm_scan.rmap_list = &mm_slot->rmap_list;
 		goto next_mm;
+	}
 
 	advisor_stop_scan();
 
-- 
2.43.0


