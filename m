Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C653CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 04:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CAB46B0088; Tue,  9 Jun 2026 00:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2076B008A; Tue,  9 Jun 2026 00:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF316B008C; Tue,  9 Jun 2026 00:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CDDC6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:40:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1404B1C18E0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:40:42 +0000 (UTC)
X-FDA: 84859123524.26.007C065
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id D456B20003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:40:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780980040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s9IC23zwbJQbfigyxhkyxo536Nhmheos7VJN6lQLGwY=;
	b=wCcLKafBHn/aMp6nwI6FZgwcBZx4FhK6F5NyGYRiyf3LSmH3GiRCwbxxq0JBjFLTCHsS+/
	Y7hf2eXtvE1bT6N5CdUD0UKdb0M29+0wO8i5CcZy5xXnDFkNRA/nljaZ6BcXhY4sMAubtN
	dBVCwIEcZzyOjaYFXWF0ahtGqWQfzm8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780980040;
	b=pxGOcefFb6mB7ZbcUl0KnM8INklHbX3tGIoFY7H/98pSQK0ijin3Qd0QLOUjNdUuoSxV1/
	dEwy2lrwNqvKKSDWiX6RSLgbPXkC+Ol6RwQqKm5FLJPhVi45++XHRm/x7mbhO4pxVjW2Yf
	mP/GmXYi4S/83HRUZjONHJ7O7Zbvk7g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gZGS44jnKz5B13Z;
	Tue, 09 Jun 2026 12:40:36 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 6594eUN5033294;
	Tue, 9 Jun 2026 12:40:30 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 9 Jun 2026 12:40:31 +0800 (CST)
X-Zmail-TransId: 2afb6a27993f7b7-fe614
X-Mailer: Zmail v1.0
Message-ID: <20260609124031750t-yHeQFCJs4gAeOmsvEJx@zte.com.cn>
In-Reply-To: <20260609123931349fw0hnPPf7UBWQT0P7Ej2L@zte.com.cn>
References: 20260609123931349fw0hnPPf7UBWQT0P7Ej2L@zte.com.cn
Date: Tue, 9 Jun 2026 12:40:31 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHY4IDEvM10ga3NtOiBhZGQgbGluZWFyX3BhZ2VfaW5kZXggaW50byBrc21fcm1hcF9pdGVt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6594eUN5033294
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 09 Jun 2026 12:40:36 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A279944.000/4gZGS44jnKz5B13Z
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D456B20003
X-Stat-Signature: x4wmxsw79fgatt7hzyixbzj1wdyipp11
X-HE-Tag: 1780980038-192221
X-HE-Meta: U2FsdGVkX1/dt6z6aikgkzAt3aoxQhXT8pmKTXVMNkfCtnBrbcoxbJrh0D/8xISjpKl6RKhazJNR9M8wCq9zLtM0R87yvsmUF/fWIFS003ugAwE/SFH6BFjfLPzg1nZz+sSdw/NH31oozIGW6Wz0teyLoFYummBBu6bZAxrx+efZx0M8t57uk3FN2qWgeQDrymcX2R9PBr3KMB1NVInYmWx5sUqAPX3f78PTw8POphnwWWzDnorSI99sQhzOG1YxDI7hqSYe1lz5pi+nsVo9vW2UKEfQFc/UN+ww1qGhY2GLfXxikEFhaEArSP/1RiNJfG64zg/uKnOyQnef9LT13rgwlOKi373RHf2PIcLceJArcCEuDgL90Zwf5xGmhjR4YVcrwEXX3pKUi3OlVf2gIKhry7F+EJ5740RLbUMrOuPEFqtiuZrhzPHKuLgce5XzVlIi14V4DXJ3lFgsZ0eaw0AcYaG3P9VIF5upCupTLgegf3qoWiWeGfs3dy7IhbkZ82S03dVho7bwrL9bGuxI33iIafNj9anMoTzTt7jaX1VW0DJcl85NJ0TfGd6LFOZthmKu+R9/JC5o+NY0ROqtamd/tRbeBL1s45o/BOxQEAlItJjCALijV4amPAG1FCbZeQTdCnxP8xZmIxm80K7v8OSqzTfY/HyjP5hlJdBWQl34c8nzM6qv6dhylcHIV9CPvckVnba+ubDo4doicxmSUO9KmTXyKShm/w34P7Z5aRwTE8eEH2JKhyENXmuXRoluQ+vS1zOELeSC5f3KpiBv8u8f07a8wVx76ssE6edi/Kh+cDNk5UqptG9N08tZwW3kV3HvLHMJG53qqbRegFKLxVTGDNE4WUKGF96GArZyzLrFzr+kPSl7vujbBVpJOVBGf39D2UdLN8KEjiRgU/YyfB/nXF5YsUK426F7my1aaBMDpIAwQmA9XylHN7I6hJ35A6su2Ewod7J0UOxurVm
 lDvCkxrC
 LexVDyJeV7LvAN9utPBFh/h1dE+VSK0UUD46lOI4j5Euf53eR569+yxGqR388N3p0PC3EOGO2/OH/OiSZ12eEyCWgd+3TvNc/pTfdQblaSwhmyvgQVDLNOAAltjxtYq6f4x9BkivElCawrD3DFzJTzCCxQEwiB+jlOpe55HqjXLwNv1jSqRy6sdYMFuK+Qk6pnqcFRZoYutMfdxHSXu4VjIP+25t2F7QFb5tfprO07ODph95/HVWl2uuW3cyCKahwVTpa8Hqdad63SerhfzQSLnqgBftNNu587zaO
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
    * The second call to try_to_merge_with_ksm_page() fails in
      try_to_merge_two_pages().
    * stable_tree_insert() fails in cmp_and_merge_page().
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

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 49 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 7 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..e0ba29e3c0a4 100644
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

@@ -1598,8 +1618,16 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	/* Unstable nid is in union with stable anon_vma: remove first */
 	remove_rmap_item_from_tree(rmap_item);

-	/* Must get reference to anon_vma while still holding mmap_lock */
+	/*
+	 * Must get reference to anon_vma while still holding mmap_lock.
+	 * Must can only reference the VMA while still holding the mmap
+	 * lock, so reference the anon_vma and calculate the linear page
+	 * index early, before stable_tree_append(). If anything goes
+	 * wrong that prevents the rmap_item from being added to the
+	 * stable_tree, break_cow() will clean it up.
+	 */
 	rmap_item->anon_vma = vma->anon_vma;
+	rmap_item->linear_page_index = linear_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
@@ -2458,6 +2486,13 @@ static bool should_skip_rmap_item(struct folio *folio,
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

