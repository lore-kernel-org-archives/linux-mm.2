Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E65ECD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B28F6B0005; Thu, 11 Jun 2026 09:15:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68A076B008C; Thu, 11 Jun 2026 09:15:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FCA6B009F; Thu, 11 Jun 2026 09:15:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4821F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:15:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D68E2C2399
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:15:01 +0000 (UTC)
X-FDA: 84867677202.01.41ECF57
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id EF5314000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:14:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf27.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781183699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K5LhU1ZZcYWpXuUddr4Uxerj2bfLDCIi4+gbAaZxuMg=;
	b=VAXTnP71exH7IyDlARGcRa3kKr71arXQFBbm1+khG10GHxJCf4qBk2Hy0ZlbKpVhrFOUNH
	9YkqAfjAP8V/AUgKv0Lv5/1lqU3APx/6c/TumlLp6zMPeLjh0vnCOUG+b02awQQwI0fvHc
	1KQuuPYqfBWfIAZpp7I20jgCE2MeMtA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf27.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781183699;
	b=bGYfQwt/rX5GTy3vePqGBmno0n0aVbE6DJQszKBNcLE8DSSmWF2Tn7q/1D2cC+Ld+q4JKz
	dYq8ZAqiqN0Rx45lW7MAZKDTgPMNkuXmCKVmpsW9HtqqF8OmtgeJnJCn7RCH12ibhG/4E3
	oP5P+G9Dmy8kDUmvtFbSFOU8Fb4gOKo=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gbjmc4Xpvz5B0yy;
	Thu, 11 Jun 2026 21:14:56 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 65BDEq68049883;
	Thu, 11 Jun 2026 21:14:52 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 11 Jun 2026 21:14:55 +0800 (CST)
X-Zmail-TransId: 2af96a2ab4cf1cf-96fa3
X-Mailer: Zmail v1.0
Message-ID: <20260611211455080AYUdDh-QB1227GDBgfxhv@zte.com.cn>
In-Reply-To: <20260611211311025VA1q1gTA-X5NMF0aZjnvh@zte.com.cn>
References: 20260611211311025VA1q1gTA-X5NMF0aZjnvh@zte.com.cn
Date: Thu, 11 Jun 2026 21:14:55 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY5IDEvM10ga3NtOiBhZGQgbGluZWFyX3BhZ2VfaW5kZXggaW50byBrc21fcm1hcF9pdGVt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 65BDEq68049883
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Thu, 11 Jun 2026 21:14:56 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A2AB4D0.001/4gbjmc4Xpvz5B0yy
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: jncuhkgfhz596nwnt9cy8kdhqhe71cpq
X-Rspamd-Queue-Id: EF5314000C
X-HE-Tag: 1781183698-719593
X-HE-Meta: U2FsdGVkX18j4/GxL/xhVu7TduIBlC715/fo68LgoYahk9Us+1GzmaIqnztRTB5ZCXPZ1wA8SDGhGh52wGlQ/xmOMcNoSOF8k7Fqw6cNG6SCyqYatHkw5kCxYAQbdRbFuRqV8smYXFGjf+n9QL9x22MP3tdyaWPjrxU+WLsz6tuufdoc8w/n89K+26BNkFWbFgBxUZ+/YzSYJTNz4ywUFS4nWUHpDNPYc3ggw3lG85Y4EQ8J+9OcCehKOq/jtz/uydGKBppNS0vFCG7+Ssm1fP4vC6pbktgv4jDjpDdxuTBEObV0YCmNg/AjIGQhxT7vQSETiiUYfqsOx07tiUg36Uho/IMXUMgaG+aWneFK+YqPgBL6wxq+n08wD1iGlaECwSKrf7wttD09e4ZOUOHhR3Wc294xYrEQMZX3vEjcuYfdSTIwyVCzcWSZUoJjz0HIoL83FuAsPiu3boNp60LZB6hz3Bz5+1+hjTv1bWHkznv99KdZQQY47h92wbnO2u4Q1wfz8hUMbFpajG0Oc+hSDNKb1TOzAve2xg9ULH302y/22CawxI3ZEvYPwC0D4xqCy9MC+YPU0CpORzI5TUiwQ1TZOn18KOSqwEsSxHzWmRTcrRQ7WhwG5Q/k1EVPUy1zuBDDyZV60fA9GqJo7ODtyE6zs/bz5BBOPRo7hucdOIUDR55lFgr5iL6BRlnvpPm6aGJH9KZ/Txt5GbUrPbt3TYtXwVpFyblTGRj19TW/6cSq7TzZF5nDqeYEgmElzghxM/Q2mbM3ZVWpD2sRxppYcIVhzFf0fpvlUe8YKaAsJMYLYq9Fj6SWkyCKTqkuF3m/sSM+juoWBv48z08fi2QSZIm3DjTKyszZpPoHiGEcYz+k4wUxBBWPENbNBHrwJISc6RZC9LPRbBD7Y2XxngtEOUbgCpsT/RObuOn7oHYigKP6MIwFZBK+igq0rHc+2BuG+uQ2Ok2d784JfMdih45
 i85/AVk9
 NIzq88my96SGnKM8ibvMnjshhwTsqngWhmbincY2D7z7oqhPXZACabGCoVdeX3Oct4cSATlPy3k7+5v3y9Xz6AA1G4a1UTA0LHVmHcVA26snFdQyWxwUKaBx0TmXmU7pRABPKz9mKtQ/jZDbgIx7XH1Bx3xzemEoEQ0O7jhBcra4tLm/8RciRB/cETnpyI4oyWxZsmz6K265SgoyZxOxrCilfh4JwjtgWHya+90c9HR76D9FtX8Y8HNa1PuuONm0037rpj6Cp9aoBqfmxyj7faIbc2bd74WECOgEo
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

