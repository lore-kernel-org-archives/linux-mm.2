Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE534C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB1D6B009B; Tue, 15 Sep 2026 11:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C286B00A0; Tue, 15 Sep 2026 11:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919046B009B; Tue, 15 Sep 2026 11:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73E2E6B009B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2F3240427
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:36 +0000 (UTC)
X-FDA: 85216340832.24.77E298F
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id 515E81C0010
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="n97/zZ/q";
	spf=pass (imf20.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gqlmp1JcN66P7HZPc4Um7qYp+zXpL8XMfS9Kv/SGok=;
	b=MruGhJDwsWnI3Os7UQrizhQUjsE7/LkeKNhppKXohMiiJcvNr9IJ+lAul/43eK3EMO+img
	kiDxtebhP37301RyG3kJEMHbLBdcmXR0J8ZzF2HcLSbPyeDJf4sxStVpMojaX8mb6LCy59
	RT1bKfXLk7pzRK6xwWeVr5hcd/ofybw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="n97/zZ/q";
	spf=pass (imf20.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485214;
	b=53I4b9v3QIUPSa+jL1BRJSCWlsdI5GyNjU2L8dG1NDGyqf/U3++ZsEhtyYSlpPe55knJ/g
	vx4ywv3SK1faBnyeUuufK3AbwSe73V8HCj4diY7BTfUAhwTAtU4lwb1xjhEzO1rqiFELhK
	kKJ6QkZHiC0ZzwC21cI6Sem7zPpWh5o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=2g
	qlmp1JcN66P7HZPc4Um7qYp+zXpL8XMfS9Kv/SGok=; b=n97/zZ/qD5hDTvMo0p
	ulmKvaQeDCsFVeiRcIatjgNxTEKFZlDElrp4M26FvDkrqJP2ILZDY44bMIx8j5/j
	xDVXY3HMYPvd1z1CHVqjhVDzmn7BzPHtBF4oB9M8+Fuj3JL0U0RHgB1w0jl0VVyj
	z7wNXXzG0ZuqsaNPCrG8MUVbc=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S6;
	Tue, 15 Sep 2026 23:13:21 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] mm/ksm: add advance_scan_mm_slot() helper
Date: Tue, 15 Sep 2026 23:12:18 +0800
Message-ID: <20260915151236.5200-5-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S6
X-Coremail-Antispam: 1Uf129KBjvJXoWxuFyUJw1xuFWUur1fKw48JFb_yoW5uw4kpF
	4jgFZ8Kr45Ar12gryxKr48ArWYvw40gr48Gw43Cws29r1ag345JF18Gay8JryYkFy8Wwnx
	Xa1YvFs8Gry7K37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07URE__UUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xFBOmqpYJFR0wAA3t
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 515E81C0010
X-Stat-Signature: rbpkx79ofu311wzbneg4tfupo9jamf5o
X-Rspam-User: 
X-HE-Tag: 1789485212-690496
X-HE-Meta: U2FsdGVkX1/GECMn/Y3YcH4twe948Bi7g0+fEe8KP2y4+u0GRieTkjk5vKn4yMLEY9HD3VNMugIYhufBR4iJIDxCRVilDH5PYm4BaZNaq7q9M/Wg2M35X12mMuxESAkw98parjS729Q+RYZOe/hc/a0zboIJMtxPSUBehANOdduwG7yzrjDhDwx7uUWx8FHC3kWB0wwNA9hGKrNEoR0h3awf7PpXGogFBZucQ1XDJgWVBv1uICzKI7SILWIAXq6Yfk/x7mZyK/ubqX4PpK/NzoAk6GS/nVqoh8DEO5BKW5rpmPr+OiPWXb/Tc1Acw3XNjBJ+475YLpLvRuVcz9LgfFuZEEu7c3mOgo//ZhrTxDO4fSIcHJGC3U0WQ5HOSXKUbnHGRpUq9z0VjfdzPGXyWRJiVTcvw5YkWpZkXRbCbZaDb5uCVkXatDG2r5Qj5/tqe5gGyD7ypUC8YUH2CltwrGeMNTOxkyHX49h99/NSw6WDI34O9K7KCralzfxsKoABa7Dzp/4e7DSHaIpiTazZNOf3l9JRtqm3oYuPKrA8gwf2wFpVxOGZ0HHn8UTZCrbv/RW47dCcQpXHAfJzC3TX5WMeqxs1bNr+sazBzD79NEIuzN69lv0JiroJHZZRoumuYSOLr0HD5siaFElD+Nr6t/x62gUj1PHqQQdfcnvXWm9So5Gqjz+tRpgq9S/4basqZel6p3StgD4/JRUd8F/GHunu0Q6Q5TLc/aWrN18WqrIkqY1YfE3Zdkkzb4Q60ligOxmJFOrXAFvJGIdvSCThl6e5+vkViqNK09puoPvxylQMB0hm+xYpk9xkzoFpOcfpsiGHzFIxx9EktpWUcfs4ggAGXS9zrUM82zv4JZkLPPjrG2qMRJJkhBJSFAeoK6mE2mi2hYHSqDC7iOFtWgCsrGyYdNbcqhpgBX3YP1X3Oq8kT+lA5DSa4ZVWKMc6h9vomZ3xb7S7Ih5Vt/fIbiC
 0AaaLT9w
 rHshv2ZnaGW5mwUCkEe1XGM2OccDXuIGy/57/yhiaWNegcqmvCj0g+e68zkGbbPjsy87/V+S8BSIj3pDfkRioC1lx0IMZY3zS23isF1FDQt6pYA4HxUm1GVCG1HH/0RLdXaLDJWLcWavudJV5jAUbhdWr1Zl7V2/7CfHcf/OEsH7m1O8/IZh5OU9DJSYS7UCw9OV7sA/IbZFtWecXUpAhTuxIV6XfpCqvsE0C3SXvdJHd1UuFwDkFxziB0AjVdhkskxu/6APe/ReckH50pbw1xpFbwYjDh4XTgQbH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Factor the four mm-slot cursor advances in scan_get_next_rmap_item()
and unmerge_and_remove_all_rmap_items() into a helper. Assert that
ksm_mmlist_lock is held.

No functional change intended.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 18d037f571d3..aa33522627c7 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1119,6 +1119,22 @@ static inline void folio_set_stable_node(struct folio *folio,
 		   (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM));
 }
 
+/*
+ * Move the ksmd cursor onto the mm slot that follows @mm_slot in the
+ * ksm_mm_head list, and return the new cursor (@mm_slot may be
+ * &ksm_mm_head to (re)start from the first slot).  Called with
+ * ksm_mmlist_lock held.
+ */
+static struct ksm_mm_slot *advance_scan_mm_slot(struct ksm_mm_slot *mm_slot)
+{
+	struct mm_slot *slot;
+
+	lockdep_assert_held(&ksm_mmlist_lock);
+	slot = list_entry(mm_slot->slot.mm_node.next, struct mm_slot, mm_node);
+	ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	return ksm_scan.mm_slot;
+}
+
 #ifdef CONFIG_SYSFS
 /*
  * Only called through the sysfs control interface:
@@ -1215,15 +1231,12 @@ static int remove_all_stable_nodes(void)
 static int unmerge_and_remove_all_rmap_items(void)
 {
 	struct ksm_mm_slot *mm_slot;
-	struct mm_slot *slot;
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	int err = 0;
 
 	spin_lock(&ksm_mmlist_lock);
-	slot = list_entry(ksm_mm_head.slot.mm_node.next,
-			  struct mm_slot, mm_node);
-	ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	advance_scan_mm_slot(&ksm_mm_head);
 	spin_unlock(&ksm_mmlist_lock);
 
 	for (mm_slot = ksm_scan.mm_slot; mm_slot != &ksm_mm_head;
@@ -1253,9 +1266,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 		mmap_read_unlock(mm);
 
 		spin_lock(&ksm_mmlist_lock);
-		slot = list_entry(mm_slot->slot.mm_node.next,
-				  struct mm_slot, mm_node);
-		ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+		advance_scan_mm_slot(mm_slot);
 		if (ksm_test_exit(mm)) {
 			mm_slot_remove(&mm_slot->slot);
 			spin_unlock(&ksm_mmlist_lock);
@@ -2662,10 +2673,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 			root_unstable_tree[nid] = RB_ROOT;
 
 		spin_lock(&ksm_mmlist_lock);
-		slot = list_entry(mm_slot->slot.mm_node.next,
-				  struct mm_slot, mm_node);
-		mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
-		ksm_scan.mm_slot = mm_slot;
+		mm_slot = advance_scan_mm_slot(mm_slot);
 		spin_unlock(&ksm_mmlist_lock);
 		/*
 		 * Although we tested list_empty() above, a racing __ksm_exit
@@ -2758,9 +2766,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 	remove_trailing_rmap_items(ksm_scan.rmap_list);
 
 	spin_lock(&ksm_mmlist_lock);
-	slot = list_entry(mm_slot->slot.mm_node.next,
-			  struct mm_slot, mm_node);
-	ksm_scan.mm_slot = mm_slot_entry(slot, struct ksm_mm_slot, slot);
+	advance_scan_mm_slot(mm_slot);
 	if (ksm_scan.address == 0) {
 		/*
 		 * We've completed a full scan of all vmas, holding mmap_lock
-- 
2.43.0


