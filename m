Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36B37CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 09:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2836B0093; Sat, 30 May 2026 05:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9931E6B0095; Sat, 30 May 2026 05:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 881DC6B0096; Sat, 30 May 2026 05:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 745746B0093
	for <linux-mm@kvack.org>; Sat, 30 May 2026 05:07:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C7C31A0181
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:07:20 +0000 (UTC)
X-FDA: 84823507440.05.29B3D33
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9E766C0002
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:07:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780132038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MdhhnA8vEjdFXaLOuAUDq/tNb/CAaWxDa9KGNAIetpM=;
	b=1h0RwQ5YYaz2+hwn8pp8n1U9M3mJPs0IvXEU8WctX+ArIg+26FbmLzfFG5yAYbiwjRSK0g
	+gBtAbbPbGqT/SoWI1FhccxCqTZaERmPDjZqJIKXWrzVEM4jr9bwghTey1CeC9HBkLZ72m
	A0iFP9rm/B2KXKpFTnQDY+/9JkG0YK4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780132038; a=rsa-sha256;
	cv=none;
	b=TtwHPCe4Y3A4oNru0C028dYJDu6uWh97jWIMR9CIddjazeDgBpFwuvCGTjs9phd+Y1VL+o
	SMHhzRhswTzZnO/rowUzh9axNhWDL9wH5MCzCBA1xn71xeqhjdRqX8AhjV1azlVBHAVeBT
	ybE1at0W4AA7g1GdcciqL2sVamCBAMU=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gSDrM1dx3z8Xrr9;
	Sat, 30 May 2026 17:07:15 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 64U9794S051514;
	Sat, 30 May 2026 17:07:09 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 30 May 2026 17:07:11 +0800 (CST)
X-Zmail-TransId: 2afa6a1aa8bfa14-28113
X-Mailer: Zmail v1.0
Message-ID: <20260530170711362Lxt422zijBMtOvPlJD-0-@zte.com.cn>
In-Reply-To: <20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn>
References: 20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn
Date: Sat, 30 May 2026 17:07:11 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>, <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY3IDQvNl0ga3NtOiBhZGQgcGdvZmYgaW50byBrc21fcm1hcF9pdGVt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64U9794S051514
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sat, 30 May 2026 17:07:15 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A1AA8C3.000/4gSDrM1dx3z8Xrr9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9E766C0002
X-Stat-Signature: 157kqorakq6sdjhayio71gnp3ypjyb8i
X-HE-Tag: 1780132037-85308
X-HE-Meta: U2FsdGVkX1/1wQqdhRfCKpVrvdrJdduJ4thRUC1VqdQogAzuzoGNnzpDliVgV4pbTgPGv2JHmGTYN5Zp1j+ykW5Rn1BHgunZzmEVOBqWxLGeN7UAufrU0Zwwgovov8xjfnotKILRrFgBACHvarOA5oUsJ/vA7dkZBy0L/MkbT8jEqJ0L4eGuy9/fqvbkiUDVaZckgT/pwygI+Ew0OigFeZx7vp4vEzAWA14NpJ380O/KIG3RUTqfybSKEFLrrIxzPYd6POktTB10ate85uAK5dA5240rDvqKnJyyYsOMGmSPT/bOYcleyCrL5zPmcZYMIZvRTeSbFBt5Qb0KcmvtwoGY5L2eCVZnUGx/i+ZWj9oEXDEVITnk0A0oABmKdkpx8JvktTwRWSiFy2sr257o4eiSf6eddka1XnGsO9MTzFDsrQTDm4TsH/QkxqWYc6kTktzGfFst+WjD4t1EP+yeC3KnM/UcS9BSNJbeFxjvhGfMQh4bm7fKMdWTym6WXK5hyClyBAdcl1HxAxYYmm54IMFa+vxvBcbocZ5HZOs1ybMsago9GTj8dfjYeR+UcifqFBwvPKr/6sUzw6S4OhpazZmaCKDwSF8yFAitZcKv/5d/8hjjJNeBgh38ZpQxh0lI4GIBNSbrl9ZpcPnuiGWQo/RW/351pKoIK/RjMZil0bhatbQ5xTiTm4cgVNDhgtYu2NGiqS6Z9UeA+/S+DwclRdA9bfyev4Y3shV/SGg0+5ZSrgHkmnQmgdMOPfO6/S8QkWesBS0fZAG/6ghRs+esGE6BpCRcfoQ28Z3RuOFsUfSUGm+iUkh4wYeu1OjBvrepsjyjzf5CS7hgY6MfEZH7lOytqwOtMpheP2DuTCi2Dzd6mxD7eptftg/0ZLy7EttA4Ou74C5LuODtyVs0A/fhJ0GOEdXfJPU0yKqn0DLm+ssNIHkjTdMErBQ9dNjk45XX+yZh1AIFT/3g3d3RYgd
 3i3NEvp+
 Sh9wrurX8x1AHKSdzTQTUccOTC0vPx4+ATLcYFLQ8FEKJfDAZmVihRg0iK+Iq882GIj+BBSNdGwBb+bfqzFpNuMl1xse74WsORulxFijmHDj41unrwUyUk7rTj7kTXPIgjiXOSwjwrZfNhZXS6A/fCzahq9wmLiCN/86sZviP4bNg2cHFHj6XxpcQsWpL778uDNQBtX7s1Kab6YLVYJd569KgoeHiJTzgi6oBLE7pFJIa16u+bZ6YE8omCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

The reason for adding pgoff to ksm_rmap_item has been discussed in previous
mailing list threads [1][2]. The main purpose is to allow the KSM reverse mapping
to obtain the original page's linear page index, so that during anon_vma_tree
travering, it can conditionally locate the VMAs and avoid scanning the entire
address space [0, ULONG_MAX].

To minimize the size impact of adding pgoff to ksm_rmap_item as much as
possible, a trick that David suggested is to use a UNION that groups the members
related to the unstable tree together with the newly added linear page index. The
members that valids only when in unstable tree include oldchecksum and age information.
However, the function should_skip_rmap_item() in the smart scanning needs slight
modification, since this function still uses the age information even when the
rmap_item is in a stable state (the page is not KSM), a situation that occurs
during COW faults. After using union, the size is still 64 byte without increasing.

We keep the same way to store the pgoff as rmap->anon_vma which is set when the page
is merged and become a KsmPage at try_to_merge_with_ksm_page(), and reset at
remove_rmap_item_from_tree() and remove_node_from_stable_tree() and reset when break_cow.

To be specially clarified, the reason for resetting pgoff at break_cow() is:

- When a page successfully becomes a KSM page (i.e., after stable_tree_append()
  sets STABLE_FLAG), both anon_vma and vm_pgoff are stored and remain valid.
- However, during the merging process there are several failure paths where a
  page that was temporarily treated as a KSM page must be reverted back to an
  anonymous page. Examples include:
    * The second call to try_to_merge_with_ksm_page() fails in
      try_to_merge_two_pages().
    * stable_tree_insert() fails in cmp_and_merge_page().
  In such cases, break_cow() is invoked to break the COW mapping and discard
  the KSM state.

Currently, break_cow() already contains a put_anon_vma(rmap_item->anon_vma)
to release the reference taken during the aborted merge. Because 'pgoff' is
logically paired with anon_vma (both are only meaningful when the rmap_item
is in a stable state), it must also be cleared (or reset) in break_cow() to
avoid leaving stale pgoff values that could confuse subsequent rmap walks
or scanning logic.

[1] https://lore.kernel.org/all/adTPQSb-qSSHviJN@lucifer/
[2] https://lore.kernel.org/all/202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn/

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..4761ca3fa984 100644
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
+ * @pgoff: pgoff into @anon_vma where the page is mapped (stable tree)
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
+		unsigned long pgoff;		/* for reverse mapping, when stable */
+	};
 	union {
 		struct rb_node node;	/* when node of unstable tree */
 		struct {		/* when listed from stable tree */
@@ -776,6 +782,10 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 	return vma;
 }

+/*
+ * break_cow: actively break the write-protect of the VMA. This is called when
+ * rmap_item has not yet become stable, but page has been merged.
+ */
 static void break_cow(struct ksm_rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
@@ -787,6 +797,8 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	 * to undo, we also need to drop a reference to the anon_vma.
 	 */
 	put_anon_vma(rmap_item->anon_vma);
+	/* Reset pgoff that might overlay age-related information. (still unstable) */
+	rmap_item->pgoff = 0;

 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
@@ -899,6 +911,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset pgoff that might overlay age-related information. */
+		rmap_item->pgoff = 0;
 		rmap_item->address &= PAGE_MASK;
 		cond_resched();
 	}
@@ -1052,6 +1066,8 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
 		stable_node->rmap_hlist_len--;

 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset pgoff that might overlay age-related information. */
+		rmap_item->pgoff = 0;
 		rmap_item->head = NULL;
 		rmap_item->address &= PAGE_MASK;

@@ -1598,8 +1614,15 @@ static int try_to_merge_with_ksm_page(struct ksm_rmap_item *rmap_item,
 	/* Unstable nid is in union with stable anon_vma: remove first */
 	remove_rmap_item_from_tree(rmap_item);

-	/* Must get reference to anon_vma while still holding mmap_lock */
+	/*
+	 * Must get reference to anon_vma while still holding mmap_lock,
+	 * We set these two members of stable node here instead of
+	 * stable_tree_append(), maybe because we don't want to hold
+	 * mmap_read_lock again. Here mmap_read_lock is already held to
+	 * find_mergeable_vma before merging.
+	 */
 	rmap_item->anon_vma = vma->anon_vma;
+	rmap_item->pgoff = linear_page_index(vma, rmap_item->address);
 	get_anon_vma(vma->anon_vma);
 out:
 	mmap_read_unlock(mm);
@@ -2458,6 +2481,10 @@ static bool should_skip_rmap_item(struct folio *folio,
 	if (folio_test_ksm(folio))
 		return false;

+	/* There is no age information in stable-tree nodes. */
+	if (rmap_item->address & STABLE_FLAG)
+		return false;
+
 	age = rmap_item->age;
 	if (age != U8_MAX)
 		rmap_item->age++;
-- 
2.25.1

