Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7CC4C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B85856B00B5; Fri,  3 Jul 2026 04:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5DBC6B00B6; Fri,  3 Jul 2026 04:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74616B00B7; Fri,  3 Jul 2026 04:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72CDC6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:24:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D4FB94047C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:24:28 +0000 (UTC)
X-FDA: 84946778616.07.B2BE81A
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 35CC21C000C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:24:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783067066;
	b=KiRYty8BOAt0k2u2hLWtTeiJbk0caZi06dbTcVE0KQc/wesq8iVa1OLtt2DlNjJOzXRSg1
	g5+ed5IsVeSph4Ml/xQnaiiXULGIebprHJCOXfV92ouTcyeWe2887o+yEgvGqTT8g8WzL0
	ZhIFOt7p79Z+m/AxIeq8drw/4dJmldc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783067066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K5LhU1ZZcYWpXuUddr4Uxerj2bfLDCIi4+gbAaZxuMg=;
	b=xIOSjsyiom7OAHfcnQzoplbLpwQ53VJeTFb8hz+4s2sED41Z/v4BQwBdBW4n7avdj0JveA
	269P/cScSEilC/uYXo94qz6JwsNzgswdY5caIEqerFr23GgnRWm6WGdJvqtZ6amUJ0zQLW
	fD8RsBBDK6lcmVx8Vaf3weDCIDqMK58=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gs6HC1vRDz4yjjM;
	Fri, 03 Jul 2026 16:24:23 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 6638NtCG042269;
	Fri, 3 Jul 2026 16:23:55 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 3 Jul 2026 16:23:57 +0800 (CST)
X-Zmail-TransId: 2afa6a47719dbee-9377d
X-Mailer: Zmail v1.0
Message-ID: <20260703162357853iIa-RP7if9hRlAIuTh5La@zte.com.cn>
In-Reply-To: <20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn>
References: 20260703162253688u8Str9eFLR8TGCmo7nIOF@zte.com.cn
Date: Fri, 3 Jul 2026 16:23:57 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYxMSAxLzNdIGtzbTogYWRkIGxpbmVhcl9wYWdlX2luZGV4IGludG8ga3NtX3JtYXBfaXRlbQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6638NtCG042269
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 03 Jul 2026 16:24:23 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4771B7.000/4gs6HC1vRDz4yjjM
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35CC21C000C
X-Stat-Signature: k91s346p7efmfoo1pjrcbkne54zjym6m
X-Rspam-User: 
X-HE-Tag: 1783067066-928824
X-HE-Meta: U2FsdGVkX1+H+xCmFo4REkhR8RuwbcE1DkoYBzxpHSNlrh11jUbFR2CMdPUzmej+CreRbR5pEkFnSDjKxrdZGCMmv0wcwdPfhbP1tWPcMpzZ3otkUYh5pa7uHxdqArSE7gs6yVIx9u3tKeUmuAP63UtBK782HDBj73C0XnYSZlFLgqabQ0Mjr5jYu+Lnwm3U5TA9R4F6xHVRcORez1gXtFlsMTYRxVk6s1vAQS80XbMVa8eUYgXtKt9sKjjCUfsG6aCT/1gpZhOUR8pd/y4wH3hGZoLtxAMHVsRvi+avpTspPkYIKj0pM5K8MZIHLZx1wrduaqH+moEa+mhusj9TXyLEiCrnz9EMxpNA/4RUZviXbYpTt8RPyf4COMDgPl/XBKvtIZ/GsorYQVwGNtrPeNvnuoR9PREV8+xIcNcsMx7stZnf+AWS72/VuacmgHW05+MAQQmUpT3vHd1CCbKzkyEaPPwX+7/+Sa6XvbejVFeczA2H+PERGPYYund8pFCTS8pqvCeiEQG2mW6Lmy/j/GwXki+qMI4NAGMYZdC0M/HYjZDma4SMWC/j3795HXHJsJn0DEJfdDDYgo1YPxiyPLhGDUEffWYVQa9nSQNKe0DHZ6zGZQS7tQ2Qg5PyauwI3rgY5IkFsxj3t51qUcNMP9katWxvEDKu7N0R91Lny4XOLraHbZpc9XiOnJLLX0N+Sj6BFO71YBt8vo4xP6hLlvSPEnl2j9HwROEfZFEptQ+4oddg4SzN0H+OqWAhIfMjGH9b3E4w5bqWFeso++/5fidbNGF2vUF9tdkdppDGJst1c11Vo8UYCVZc0XmmPDltptHnw5Fv8ZilDMyonF3d1zeAq4yDfVxrtHDky28ufQOXPASz7Wcczu1UgWtauJvQVSiYiMarX0ffD4MDE3h5mCDb4ugR5h5m8zLjCtRcZaQkyczeL9ff/dI0rcqbHbzTCAS5oeyOMAHdbEGUmDB
 z+J2+AJM
 IF+EeBgYaR1R0G6LY46iz9dOQWmVllb5+sSZCptjAX5sTFQ5etV1vj6z2oJJJS6Wk0k5DybA/RYdqQ/qcwzN0InnHAGQyzHxpJS0u3gDqnTuUKIMmrYVVJ+rJTvkIVQ9WKF5MLuZ8CwDiQKDrIuiBILRd2+Ju0+xZPe908VPrGDR48STgr2RzuBh7f/JqlKmqLumyRBp425T9AVOGuLE5vWhACET2z6Hq+u3ugs2Yldvd3zGYKJTVQqU0xvBItp2yKRggxexRwBmel28Uf1uXhYNR6irk67e6YUpr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

As preparation for KSM rmap optimizations, let's track the original
linear_page_index() of a de-duplicated page in its ksm_rmap_item, so we can
efficiently search for the page in an address space, avoiding scanning the
entire address space. This was previously discussed in [1, 2].

To avoid growing ksm_rmap_item, let's squeeze it into the existing
structure by overlying some members (oldchecksum, age, remaining_skips)
that are only relevant while on the unstable tree. The new entry will
only be relevant for entries in the stable tree.

However, as the age information is read by should_skip_rmap_item() with the
smart-scanning approach even while we have an entry in the stable tree, but
the page changes (no longer a KSM page, for example due to COW), we have to
change the handling there a bit.

We'll calculate the linear page index in try_to_merge_with_ksm_page(), when
adding it to the stable tree, and reset the index (to reset overlayed data)
when removing an item from the stable tree -- in
remove_rmap_item_from_tree(), remove_node_from_stable_tree() and
break_cow().

To be specially clarified, the reason for resetting the stored index at
break_cow() is:

- When a page successfully becomes a KSM page (i.e., after
  stable_tree_append() sets STABLE_FLAG), both anon_vma and the index are
  stored and remain valid.

- However, during the merging process, there are several failure paths
  where we already prepared an rmap item to be added to the stable tree,
  but must revert that as some part of the merge process failed. Examples
  include:
    1 The second call to try_to_merge_with_ksm_page() fails in
      try_to_merge_two_pages().
    2 stable_tree_insert() fails in cmp_and_merge_page().
  In such cases, break_cow() is invoked to break the COW mapping and
  discard the KSM state.

Currently, break_cow() already contains a put_anon_vma(rmap_item->anon_vma)
to release the reference taken during the aborted merge. Because the index
is logically paired with anon_vma (both are only meaningful when the
rmap_item is in a stable state), it must also be cleared (or reset) in
break_cow() to avoid leaving stale linear_page_index values that could
confuse subsequent rmap walks or scanning logic.

[1] https://lore.kernel.org/all/adTPQSb-qSSHviJN@lucifer/
[2] https://lore.kernel.org/all/202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn/

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 48 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 41 insertions(+), 7 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..60c6f959d81a 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -195,22 +195,28 @@ struct ksm_stable_node {
  * @node: rb node of this rmap_item in the unstable tree
  * @head: pointer to stable_node heading this list in the stable tree
  * @hlist: link into hlist of rmap_items hanging off that stable_node
- * @age: number of scan iterations since creation
- * @remaining_skips: how many scans to skip
+ * @age: number of scan iterations since creation (unstable node)
+ * @remaining_skips: how many scans to skip (unstable node)
+ * @linear_page_index: the original page's index before merged by KSM (stable node)
  */
 struct ksm_rmap_item {
 	struct ksm_rmap_item *rmap_list;
 	union {
-		struct anon_vma *anon_vma;	/* when stable */
+		struct anon_vma *anon_vma;	/* for reverse mapping, when stable */
 #ifdef CONFIG_NUMA
 		int nid;		/* when node of unstable tree */
 #endif
 	};
 	struct mm_struct *mm;
 	unsigned long address;		/* + low bits used for flags below */
-	unsigned int oldchecksum;	/* when unstable */
-	rmap_age_t age;
-	rmap_age_t remaining_skips;
+	union {
+		struct {
+			unsigned int oldchecksum;
+			rmap_age_t age;
+			rmap_age_t remaining_skips;
+		};			/* when unstable */
+		unsigned long linear_page_index;    /* for reverse mapping, when stable */
+	};
 	union {
 		struct rb_node node;	/* when node of unstable tree */
 		struct {		/* when listed from stable tree */
@@ -776,6 +782,11 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 	return vma;
 }

+/*
+ * break_cow: actively break COW, replacing the KSM page by a fresh anonymous
+ * page. This is called when rmap_item has not yet become stable, but page
+ * has been merged.
+ */
 static void break_cow(struct ksm_rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
@@ -787,6 +798,11 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	 * to undo, we also need to drop a reference to the anon_vma.
 	 */
 	put_anon_vma(rmap_item->anon_vma);
+	/*
+	 * Reset linear_page_index that might overlay age-related
+	 * information. (it's still unstable node)
+	 */
+	rmap_item->linear_page_index = 0;

 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
@@ -899,6 +915,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset linear_page_index that might overlay age-related information. */
+		rmap_item->linear_page_index = 0;
 		rmap_item->address &= PAGE_MASK;
 		cond_resched();
 	}
@@ -1052,6 +1070,8 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
 		stable_node->rmap_hlist_len--;

 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset linear_page_index that might overlay age-related information. */
+		rmap_item->linear_page_index = 0;
 		rmap_item->head = NULL;
 		rmap_item->address &= PAGE_MASK;

@@ -1598,8 +1618,15 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	/* Unstable nid is in union with stable anon_vma: remove first */
 	remove_rmap_item_from_tree(rmap_item);

-	/* Must get reference to anon_vma while still holding mmap_lock */
+	/*
+	 * We can consider the VMA only while still holding the mmap lock,
+	 * so lock, so reference the anon_vma and calculate the linear
+	 * page index early, before stable_tree_append(). If anything goes
+	 * wrong that prevents the rmap_item from being added to the
+	 * stable_tree, break_cow() will clean it up.
+	 */
 	rmap_item->anon_vma = vma->anon_vma;
+	rmap_item->linear_page_index = linear_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
@@ -2458,6 +2485,13 @@ static bool should_skip_rmap_item(struct folio *folio,
 	if (folio_test_ksm(folio))
 		return false;

+	/*
+	 * There is no age information in stable-tree nodes. We might end up
+	 * here without a KSM page for example after COW.
+	 */
+	if (rmap_item->address & STABLE_FLAG)
+		return false;
+
 	age = rmap_item->age;
 	if (age != U8_MAX)
 		rmap_item->age++;
-- 
2.25.1

