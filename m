Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCBD7606A8A4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=h0rCDRPl
Received: by kanga.kvack.org (Postfix)
	id 099366B05C5; Thu, 12 Nov 2026 08:00:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 070EF6B05C6; Thu, 12 Nov 2026 08:00:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFC46B05C7; Thu, 12 Nov 2026 08:00:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D10A36B05C5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:00:21 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68C82A81A4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:00:21 +0000 (UTC)
X-FDA: 85426475442.29.1664E47
Received: from mta0.migadu.com (out-27.mta0.migadu.com [91.218.175.27])
	by imf31.hostedemail.com (Postfix) with ESMTP id E1ADB20006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:00:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h0rCDRPl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.27 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794488419;
	b=3jyBHKVagkyHqWatc4iYWbEW4PNfru8AC7gC5zorcFU+HE/UlK/Ie2VxMuWAOUOMn1TVfz
	q8OslAnaVXenUufrWinRwSf8wItPP9ILMDN8jDNtbk4spmiD6I5NBm+Fd8OT0GHLzdvNPo
	g7wA+RmBzbt/IT3+kfkFx+AsjUh/3E4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tL9krYLzw1vGXbr6jlGPxdWtdTamdmpD35tBdked0g4=;
	b=N4/rapxPRv1gadUrIbdU1zFZ1qGf4U3yjk9IE3JKCBdtrdYkSe4P446Td3170nQoddD4F8
	tbH50FjJk1v6R+Hx66nPEwQ5EggVNYXiD0uVflbyKZPQaGG+1tO8Ct5PPNyukGlFgU+rb6
	T8omofZgFhibl1zl+jdPOgrUUfbGA3M=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h0rCDRPl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.27 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lP0vpQ7indg5AzBAUuvMNzwAAkYOsAv9TjMwh2sSEhg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794488416; v=1; x=1795093216;
 b=h0rCDRPlhPLUMrhQz+crNRhJqF1/VhmmDBnOKBHbIw1tMD+9TxLI8AkCNQ8y+ucr0ZIqgAp4
 RVK5fFcpOcacL9Ckf8tI/1aodaoc4ZUjgN1KfFkNHpBX5iW2eT0livMVA3JcnBzASMEYq7sa950
 uCUrR2gzovmLDp2EJfYIYeZM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 855efecdfc12cc35;
	Thu, 12 Nov 2026 13:00:15 +0000
X-Mizu-Trace-ID: 855efecdfc12cc35
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Subject: [PATCH 2/2] mm/ksm: add initialization helpers for scan_get_next_rmap_item()
Date: Thu, 12 Nov 2026 20:59:59 +0800
Message-Id: <20261112125959.177881-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261112125754.176930-1-xu.xin@linux.dev>
References: <20261112125754.176930-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E1ADB20006
X-Rspamd-Server: rspam12
X-Stat-Signature: ettpb1jw6wuni41ftjhmfqmyrima7db1
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794488418-215122
X-HE-Meta: U2FsdGVkX1/xqiqN6qZSN4UiH0OdEiiZsYzOWOSzijw8xBdCRBurlBdajTFhePifJrl9qpxNdm53GcJRLJqMWcJsjEEk7cspx0PXP3hcTBzHmcZmt2BcNI4TJQmJ+zXtupwuKO0bXWs4xCbHgcFvyLb8sXprYgJbRG+4EE8Bu6tErChQbkfYAX7HdVSeHG7LLPP61YMBK1OruWYljdCJanQWT+Vn541mEYdUHL6OZ0/q0Y/gWv6/3KD/DqfsZ9c/Y9HmxRXZPNgj6keYKs9avc+sSXFP42sf9YSKpogct41niYxVIl0tiZVbCvMOaphXlnHa6uvzA9xcEyHUOJ6ZXphtl+3kOn59JU036R/h3N9ex8C8mYa1kqb/EMOA4jQs5yBQ7eqV17jD7Vq992xVrvKpl/7Yjb7U7FZQUxgj4NdKU+x3kp7zKNmmXO3MovHQkeI6mEkba7C6OFMJmOlJ10jeX41RGvEMobzCOpEdX6bQ3UEQn1pQaRyKIORJZDAnX9F4S7QtftjVB5YNU6W/yJNdvtiZw8r66AimCSt9utUgzYMG5kb+IngWHPxKQ/4rah7lvnQGAjBdAXahdBfdlXACvmlrW48oD7nCbBhiiAmtpBGRlwvCsYLLWC9DEFnjlCWQI7L2qcwSMT18yh0ayUwdytQmlQwRm9n338HqHHATL+V+RqHD0geRp/3L5M5A5TRe28h11CQQ7XcJz9qfFGRppYP32BFVhbygf/bwLUkG6I5/TAxC2areFWWUUSiiEgfbF7akF3TdJ8oj7LdyhbmzcaBWEkjljraIguVpUmeOgc0hoB+vPeuZnY/l2fp66qjoG0IGf/eYCaM6XbJ3PwS0cokxoRUeEffTAuNYdW2epQWprFAaUgnuZhgNXd8euTF36ayg8DpAv49C2dlpNWeN21SPjqhmKdGvrg9/1LSDuYcXyUzY9I8zAm4OMniuT8C97PcIK6nGYjwARRJ
 uCwVQ7vr
 cicXs5Rn4TKRsClUJv3JflbNyeJ3TYgD+fKlP4HM2rZ/15a67qPqxcCFz8J17mmY8GaUhYQe/LtilnQHlBFLBAJVnXRAlgomNeuvZDwRhCBG9QiQYA8Pgar/+LfTDqXBliTOL+C1tWoDVhJEv6RwPBg1Vd+J7NppuS/BrHMCEheE2Hhig3J0AhEnrhjlTUbG86GxLNoyXE0PGUW8+9sciWEE8HH0R/9DHQCpjqgeKpDiTSQRugx7G/Y8AZ7VPNuzvLqzQnUT301HaA5rDIxRtjMkInspFPbFznC99YFnUACgkOelHb803La5mH1RC3C9K3rUq//LEBkT8Xjw9tVsziAc1P7Ldm2IxYX0bcILKOlX6tgak7cjaen36YcyKKlREkafEtQqg8v0760y2ftpnIXsvQ82S7cPly6FNDqJbH2W9vO7QdWwR1FyFk1H/S9bdJ7OaJHZhn8XWDRIZLe3QJT5Zy25827V025bJceYC+/jByWc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extract the new scan cycle detection (including draining per-CPU LRU
caches) and advancing the scan cursor to the first mm_slot into
scan_begin_new_cycle() and scan_get_first_mm().

This keeps the exact execution order intact while making
scan_get_next_rmap_item() cleaner and easier to follow.

No functional change intended.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
 mm/ksm.c | 70 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 24 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 49977bcf04f7..e79e64372e49 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2640,6 +2640,49 @@ static void ksm_reset_unstable_trees(void)
 		root_unstable_tree[nid] = RB_ROOT;
 }
 
+static bool scan_begin_new_cycle(void)
+{
+	/* Check if the cursor points to the head. */
+	if (ksm_scan.mm_slot != &ksm_mm_head)
+		return false;
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
+	return true;
+}
+
+static struct ksm_mm_slot *scan_get_first_mm(void)
+{
+	struct ksm_mm_slot *mm_slot = ksm_scan.mm_slot;
+	struct mm_slot *slot;
+
+	spin_lock(&ksm_mmlist_lock);
+
+	slot = list_entry(mm_slot->slot.mm_node.next, struct mm_slot, mm_node);
+	mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	ksm_scan.mm_slot = mm_slot;
+
+	spin_unlock(&ksm_mmlist_lock);
+
+	/*
+	 * Although we tested list_empty() above, a racing __ksm_exit
+	 * of the last mm on the list may have removed it since then.
+	 */
+	if (mm_slot == &ksm_mm_head)
+		return NULL;
+
+	return mm_slot;
+}
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
@@ -2653,36 +2696,15 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		return NULL;
 
 	mm_slot = ksm_scan.mm_slot;
-	if (mm_slot == &ksm_mm_head) {
+	if (scan_begin_new_cycle()) {
 		advisor_start_scan();
 		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
 
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
 		ksm_prune_migrate_nodes();
 		ksm_reset_unstable_trees();
 
-		spin_lock(&ksm_mmlist_lock);
-		slot = list_entry(mm_slot->slot.mm_node.next,
-				  struct mm_slot, mm_node);
-		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-		ksm_scan.mm_slot = mm_slot;
-		spin_unlock(&ksm_mmlist_lock);
-		/*
-		 * Although we tested list_empty() above, a racing __ksm_exit
-		 * of the last mm on the list may have removed it since then.
-		 */
-		if (mm_slot == &ksm_mm_head)
+		mm_slot = scan_get_first_mm();
+		if (!mm_slot)
 			return NULL;
 next_mm:
 		ksm_scan.address = 0;
-- 
2.34.1


