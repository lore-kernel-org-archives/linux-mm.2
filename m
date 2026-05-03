Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F5BCD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 12:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE70C6B008A; Sun,  3 May 2026 08:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98606B008C; Sun,  3 May 2026 08:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B10B6B0092; Sun,  3 May 2026 08:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2336B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:48:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20BAB1C1406
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:48:55 +0000 (UTC)
X-FDA: 84726088230.14.1C0FFDA
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2552E80008
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:48:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777812533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+kPmY9kfM7bTACL+RkqQv//16fNk6GPgmyPfFD/YPQw=;
	b=OYKjdO4PKImLaIAjBr/ky3NpRpAMJMFV/udzYNKxyYLqcvRDOIY3xEFDP78qTR44l0pjjm
	RJVEHldeAqD9lOGsCHk2Jt9K9gOAQ6W3VFEkfsC+SksdER0UloGP1mDycI/S+hrloB6LB5
	OOyyTflzwlDC0rrqqzZhwOZ01IaRyOA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777812533; a=rsa-sha256;
	cv=none;
	b=EE8NEZF0nGToRi4i3LAaJ0QL03kMn7W6A1V5JGUQNAjFTD+oXSYrRBzUeAE0yiRW3iN85s
	Ggd5SdVO94Mn7chvenKWJrlVZdS5sHQpX8Y0okwCEDDELzcEAJpbzt1wJBUjChjne8M7ij
	68zAfVq5IYDLH9HTJ4gBvKIBhGd1slk=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4g7l2T2WtSz8Xs5J;
	Sun, 03 May 2026 20:48:49 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 643Cmeb4064627;
	Sun, 3 May 2026 20:48:41 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 3 May 2026 20:48:43 +0800 (CST)
X-Zmail-TransId: 2afa69f7442bd62-5aa29
X-Mailer: Zmail v1.0
Message-ID: <20260503204843889ik1YHe8LX_5N0Neyn0ner@zte.com.cn>
In-Reply-To: <20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn>
References: 20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn
Date: Sun, 3 May 2026 20:48:43 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
        <hughd@google.com>
Cc: <hughd@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY0IDMvNV0ga3NtOiBhZGQgdm1fcGdvZmYgaW50byBrc21fcm1hcF9pdGVt?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 643Cmeb4064627
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Sun, 03 May 2026 20:48:49 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69F74431.000/4g7l2T2WtSz8Xs5J
X-Stat-Signature: cydg371uyss3hcg8ftcw3j1rx8cgjb9b
X-Rspamd-Queue-Id: 2552E80008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777812531-302654
X-HE-Meta: U2FsdGVkX1+Yp1GzR7bzw8T5lnsXrpaKh5d7inFvacl3OhUSjK8yRnq/c/ClnDq5IHcw8NzPAjygYzs6LQoCzN0OpTPe2rFn2wVNAJ+o4gcCHJHB3K157KaSdrbRr8DrYheKPbdPJhmO0fZaTls+aUxOCWRrT/5bf+JYZ7zGhubZFH/u2K9Vu7nqqDhxaPwVjIASk02eSxLdU15mI4p2XxIMRE9ThlbQJvROQ3ymRQBGVKJZ7jRu4AW9XHqbz6SyaDaVC7flogdex4/+HA7+9LeOV8YYkaWjhHcDo/c5/aubQPcqtiXoIbpArbkHKdqx/+hSDF9pIafrrLC15pYUxXnrGrrMs5H4IJ4aijKdn4fJzffmS1+K6nqJIu60kARoH7JTHwSR2VRIa9nir8G5Gy0lqQW27RlvGDcBEtczwdeQJRyTK0bjJmPGJ0kF1RFYr4o/Meq/Y2TA7S457YyZsSHtFhh+VfnPjkFuTe97s3mDN8Tlc199VCTJT9rdmbgyNhIotNeXpWAJGEC4sxS0qaghz0vBsJOFu2tk5kdN4haNHHsfbDuGDGV62eQIhrZcgSV7rPXVtffvH+z7gP0TmegJ17aP15CDtiIosTlz8v7nefCEHgV0cayYS6qyzxmgAJ7gMWIJrvfIvS5Z08Rs8AoemkCTnEQM/g9JepQA95wyTVi5WHDFh8n3GXCbqJXwRZQrcSVlTlBV0gT9JPOs9ozOAb2YJqbOWrF8q5n6eCHZXdMmqThl5Jrk/SzEPbprsgt/WF3n6s42gKx7ys+vfceorZ04hM8cOylXp1UiTDHtp+Ne+C+E2OrHK3aXICm4qlVKHnAk7fPOwmqRSHe1BiUW/J+QT6VUPIqzAPbZyNIw7ARqTdBVU5wIRXMngr687dC4zE2oPxNHS9KR63Ca5BzjiE9HDG1pEHmhi++9ku5VvztD2BMZo2KeMh2d9xVMyR9AWzaU8FzWtMz1Kpi
 yCUWacNH
 EcK5kXppctN9F9zpwGFEkQhyHE3zWAE7ry92TvAi3gV+ezp1IJDiQfw0NcrwKWZ9InNGPtqYy1SDe7ee3k37143+Y35gs/MOSA6afMhSs2pNnl6Y6125Rjq5jIVEkbq2NP3nzGQTFpMaMP0lAFAakRoAwTfbvWxIssJk61vg7d3SeAFL/g6PgEPEU9a1DHxZIaxn1qFrbKzMCJDuwjs4+DkYKsz5earzb0wy/wu18qSJaKhliwgsmJ2tIVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>
The reason for adding vm_pgoff to ksm_rmap_item has been discussed in previous
mailing list threads [1][2]. The main purpose is to allow the KSM reverse mapping
to obtain the original VMA's vm_pgoff, so that during anon_vma_tree travering, it
can conditionally locate the VMAs and avoid scanning the entire address space
[0, ULONG_MAX].

To minimize the size impact of adding vm_pgoff to ksm_rmap_item as much as
possible, a trick that David suggested is to use a UNION that groups the members
related to the unstable tree together with the newly added vm_pgoff. The members
that valids only when in unstable tree include oldchecksum and age information.
However, the function should_skip_rmap_item() in the smart scanning needs slight
modification, since this function still uses the age information even when the
rmap_item is in a stable state (the page is not KSM), a situation that occurs
during COW faults. After using union, the size is still 64 byte without increasing.

The setting and resetting of rmap_item->vm_pgoff are similar to rmap_item->anon_vma.

[1] https://lore.kernel.org/all/adTPQSb-qSSHviJN@lucifer/
[2] https://lore.kernel.org/all/202604091806051535BJWZ_FTtdIm3Snk24ei_@zte.com.cn/

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 7d5b76478f0b..0299a53ba7c9 100644
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
+ * @vm_pgoff: vm_pgoff into the original VMA where the page is mapped (stable node)
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
+		unsigned long vm_pgoff;		/* for reverse mapping, when stable */
+	};
 	union {
 		struct rb_node node;	/* when node of unstable tree */
 		struct {		/* when listed from stable tree */
@@ -776,6 +782,10 @@ static struct vm_area_struct *find_mergeable_vma(struct mm_struct *mm,
 	return vma;
 }

+/*
+ * break_cow: actively break the write-protect of the VMA. This is calld when
+ * rmap_item has not yet become stable, but page has been merged.
+ */
 static void break_cow(struct ksm_rmap_item *rmap_item)
 {
 	struct mm_struct *mm = rmap_item->mm;
@@ -787,6 +797,8 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	 * to undo, we also need to drop a reference to the anon_vma.
 	 */
 	put_anon_vma(rmap_item->anon_vma);
+	/* Reset pgoff that overlays age-related information. (still unstable) */
+	rmap_item->vm_pgoff = 0;

 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
@@ -899,6 +911,8 @@ static void remove_node_from_stable_tree(struct ksm_stable_node *stable_node)
 		VM_BUG_ON(stable_node->rmap_hlist_len <= 0);
 		stable_node->rmap_hlist_len--;
 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset pgoff that overlays age-related information. */
+		rmap_item->vm_pgoff = 0;
 		rmap_item->address &= PAGE_MASK;
 		cond_resched();
 	}
@@ -1052,6 +1066,8 @@ static void remove_rmap_item_from_tree(struct ksm_rmap_item *rmap_item)
 		stable_node->rmap_hlist_len--;

 		put_anon_vma(rmap_item->anon_vma);
+		/* Reset pgoff that overlays age-related information. */
+		rmap_item->vm_pgoff = 0;
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
+	 * mmap_read_lock again? Here mmap_read_lock is already held to
+	 * find_mergeable_vma before merging.
+	 */
 	rmap_item->anon_vma = vma->anon_vma;
+	rmap_item->vm_pgoff = vma->vm_pgoff;
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

