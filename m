Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2B4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A9F6B008A; Mon, 29 Jun 2026 05:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C122E6B0095; Mon, 29 Jun 2026 05:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28656B0096; Mon, 29 Jun 2026 05:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CCD96B008A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:43:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FE991C5CA8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:43:33 +0000 (UTC)
X-FDA: 84932462706.11.8395219
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6866840003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:43:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782726211;
	b=zqY29Gzow0MxLGEwhfAgyINhypyD7VcxhlsbwQ9NadGBvR22q+YIz4Wd+IIbRfviznXz0x
	GcCjzRnvSKzBp6s0SD18XkW2PKDO2XFXp2yPxDgRi1rQj4A4EluB9Ka/qQT3evNAOLR9wW
	Gc1/eaFOtwWEO6QqSDuvBX22gZpftPY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782726211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K5LhU1ZZcYWpXuUddr4Uxerj2bfLDCIi4+gbAaZxuMg=;
	b=qeSluj5ChixCs6hSBXeWlWJsppsL+c4WmBg7ulPMSt6Wa9ndvAOW3zOXTs+tHAJwJgtN5R
	UhoHieHv/SL80kzv+WUdAG0IOIKJeKA3LENF5pHIfyc3SJ5NIHAOMxiZLO1oJk+24wkqo8
	0BlxYL1UujWUcJl4AZL6+aYXaeSRQVk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gphDG6nb2z8Xrrb;
	Mon, 29 Jun 2026 17:43:26 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 65T9gUPl070816;
	Mon, 29 Jun 2026 17:42:30 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 29 Jun 2026 17:42:33 +0800 (CST)
X-Zmail-TransId: 2afa6a423e0929c-e69bd
X-Mailer: Zmail v1.0
Message-ID: <20260629174233442K8deTL1gCFKrOejIXyRL2@zte.com.cn>
In-Reply-To: <20260629174111989hvHNpXBxy36GgPPhOoPi1@zte.com.cn>
References: 20260629174111989hvHNpXBxy36GgPPhOoPi1@zte.com.cn
Date: Mon, 29 Jun 2026 17:42:33 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYxMCAxLzNdIGtzbTogYWRkIGxpbmVhcl9wYWdlX2luZGV4IGludG8ga3NtX3JtYXBfaXRlbQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 65T9gUPl070816
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 29 Jun 2026 17:43:26 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A423E3E.000/4gphDG6nb2z8Xrrb
X-Stat-Signature: ohioq6s159stqufr8hroaxoz178xmfxa
X-Rspam-User: 
X-Rspamd-Queue-Id: 6866840003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782726210-427861
X-HE-Meta: U2FsdGVkX19kiKUsttrStz5yYT/+p9pQxJS6KChrjewYb6p1QUMLLCi+z8lWiaepV0tO97w+jH9Z4A/S0h2AsM8fdX2GjgllFErzhg4b1llheYJzlbglDp1grzk33Ao5dpf5atbxvWZjly5UwC1Dq3unj4X7gYn2HeTaNq3pURb+UFD5KYzdqdLh9nyTRbtxBovAEt27RBDTStxaBWKq7bwYloiWdPFsFzedMpSc2WUPA/ow4IbtCrtilOG4jbx3efIkihNmB9FADYfBVInYVKBxolQY3vVjf8g5lKD0HRO91x27L1rZD5ZTYpZqbITHtV2JXjGCjBE95DyFWUmj8O9Q/z3tEkLB+DjTW+/KCsE83L/UFcepDH9mO8irLXmBUWPcNrvVeGj9JvJCF/ZdCkDN6eaTeM6ZiTrABi09H2UgftcxKszl8/0PaCwRxNiJ9v2sjGUbpYu4I7gwBOtlUZ2h7DVsGKZNVfDzPDhxnOHwNpf/OkH5L4A7x7Ip0qqYS1plamBfGsLw7Z6gxfaeP6ZpXDGQGPDBAhLSmXdPtd8bP7xbm2WQOC0SUXLVTB4tRJ4nyzJOeijCmOPNVh6T6YgacXEJ92Qv8F3SgRc0ayh/WeKVlP8q1BV2fmI9O5QcmJUhT58OX10QocqSXQmkoBWt9EWuIAT2RbDN8j6hMxEUzc7qkajH9KI0nSTPVer9PQ8CeNVZQxWZRVe+t+CpcSzs7j7k01obVM3PHBF4jv5KFPR5v5LpeU/4nbxTKMeyyYnCtLbCONIORv6+b16bHUrF8zhdydzR+cDWo0E7nPQrQuX1vORh6sm4chPm9uz+hYW9+0xxpIEK3PSQqy3P7gGACrIC8Ii1sIXA0ovNFivUxGiuFRVjbeG4MzwqusG1ejXOSrLRt4JF3UFnebutaHEtIjtWxZUERXlrUYvrAiiONhfrXJileivY7gDXpnjNkDQ4rsAwbV5CERxjT6/
 ol9LMFBJ
 Iqj3Cx6DNmw1jXLb8fggVhSiilASmbez5nQqYJqPq70WbRqg/nlI25jU4hHgtFrSQzeK/DvpyBV7vwVO05WNmTGS5Wov8BQqqZQjXpU33fooC43xiJ9zXR6Fn9vupzW6EKM+hpJUOUmARobQ7Ue06KkiDyCflD6z4qE16rxQRWMcrsTxsrpiRKymYYcbXh0p7YweSFkSval+3QYqA6/aQQA7hxKLIkKiW8lgLpW7Q5ii5rCZ1t+GHV1JjMVt3LAzTvYMRyatXfHaL2IeB3fkK32eZCgzK/dUfcaIL
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

