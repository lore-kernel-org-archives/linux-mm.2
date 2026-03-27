Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BD510A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8386B0092; Thu, 26 Mar 2026 22:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBF7E6B0095; Thu, 26 Mar 2026 22:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE9F6B0096; Thu, 26 Mar 2026 22:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98E706B0092
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:14:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4CBE813C459
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:26 +0000 (UTC)
X-FDA: 84590223732.04.82D0EC6
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9B6461A0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JXh0qus4;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6STvr62iSGyD74aKGWAYxsY9Nv9L3Kw5kG6Q78YS0c=;
	b=WpPfNlwXUjBgzlm2NBbGTXHX1QDbyRzzy/Z+eW9+XeiTvrm1Q3YLY9HheSroEGTOUJ0EQb
	sEJ8BQp93raFCciFommgdjLL4gsdfB/Mdo6ewG+oCXpRknHuSwaIuHUiE6x3gpMjwxgd06
	ReGJrae4j//zLkKwJf/Qtz+M7BIw5fM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JXh0qus4;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577664; a=rsa-sha256;
	cv=none;
	b=ozA5EunqCJUV5hYXhfYEmY83GUWAEGKjYvLQeFO1VuUUEu/Uqql3W+D6ZFSUj/IKLTnzqN
	jVHyDar6fpmGimJ8EyKEY3SdOIwNZ7SQBA/HGtfDYLKuRBJFQ1v8ZoaHcK2CFes7dxRaai
	Q7AzCowW3zGf3SLa86opVdbYEAX1vKM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q6STvr62iSGyD74aKGWAYxsY9Nv9L3Kw5kG6Q78YS0c=;
	b=JXh0qus4OUnHnUJQMBwIISIQ03+Y70d5O+Day5tjDbyx3pzwEpYu0lwJjjVphY24TjxxMa
	1hFfAyuk5rjIO0pLg3gZ3xFgFBzeuJbGE+WXFJEXpCI6xGIZu5xY6u0fIMlGDpXIyghrV9
	9AA/ClvozRfD2U72HJ06fpVqrLPPqR0=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [v3 02/24] mm: thp: propagate split failure from vma_adjust_trans_huge()
Date: Thu, 26 Mar 2026 19:08:44 -0700
Message-ID: <20260327021403.214713-3-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B6461A0002
X-Stat-Signature: wxbufqffzzjaaqd3e6h46ogjt6arhnjy
X-Rspamd-Server: rspam06
X-HE-Tag: 1774577664-440070
X-HE-Meta: U2FsdGVkX1/Kmh9RParXgMt+MmV7lU9uM9rnOBB3lW74TepdoVRGhQgU4uP3xv8/AIQtaOXOXfCus6fE7aIZmMQEbDATmegZoNu7+pUGgHMUyZHVZ8MdSHUp4gY4MqibJXIMn3AKOktg0Up3VPT8qgKqfizBrKpE4nAKKz3r761dZk0etVARS1HbgphIUvnTRNX2v+PFl4+EdH5sSvhm3/R2LMfSOP4hww6kFCChIUfRetBwFtPPOqHjpXHMeao4O0LvM5dbVkkxueDaA3lBvVI5U3yFkdKfk+C2aDx9lOlDywlQP/rOBMWmYigtU0n2RTSG31FsJ2/dpR4VHzGUhDctJ7GIBTuUvMo88Ytm+N7IdIcwuCx6DiIbuyGYIkjWYse7FpCFBULOdBjh0tBow34TVBmGW+/L/uc/goUrqNV4XL+QiYW4gaF8ZUUsvHN076PJZpZuznt+w7/+v3Fxfy/khKfJgJ0RG0F8JL7iN0nLSM2zck5my8L5UxQyOs5fX8g/F7HkAhQfSlIwUC1IhU/bUpwva2XVJF7F3q8DLCItPQXqjpdRB96+ASN6VVOlDwWj+q+L1ZNske0purh9fvGxZR0760hIu1ZqaXaX600nw6i6FUM2X4HvCjXMEo9M+HLGK6/BJFBy5rOuDxpk0SVw9Jyv5WSY+1An/LeK/2FTmfW19BLFcX8dN8EU1anvd07f9fV767OiyTYdDjOlzD12Alogn0XAKjqhx/jI2vA7Yom+duvpTZIkYjCHdx2n+Fd1wA7q1kaOX8IlK9BvndlEui74DHt92h1QGgJMrfx8jHxURDDKd9jlSJbCOYBmh/OSbn/0NY19IMEJXcCH6v80JbXwgYRGMPl5X08hs5l82MQmj4vn0TF3GGi3hgD41wrQTOe5Z1pE5XQE9fCRVCHPcR8bEhlOlHxtV/PG05w6UT1vv5B+yIiCwynEkTtWcQAfBHG8qF74F63hYqQ
 fAftmuQ1
 8+UXKZYfi3ty19Dwb7BTXBEiwWtuytJGQUTgaEXqMWkw7SCJTCbJmiTR2kbBkPIgiDE5CBC6WJf//M20+Mbfljb/RxOJDdx8hFWn9PgH9f9SOgP0KIutO+sZHjrfxPQpE7PtNzvWkbDqb6vGESEqy8Ctc2p8Xgrt/DdfSpqs1fg9myWS4nmBMOPTv5yNp7jII6NGj1GlvgwqGVOzpdwd6yHfwtWfanyAN39agmL8O9OgcojYOlMwDgHaH8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With lazy PTE page table allocation, split_huge_pmd_if_needed() and
thus vma_adjust_trans_huge() can now fail if order-0 allocation
for pagetable fails when trying to split. It is important to check
if this failure occurred to prevent a huge PMD straddling at VMA
boundary.

The vma_adjust_trans_huge() call is moved before vma_prepare() in all
three callers (__split_vma, vma_shrink, commit_merge). Previously it sat
between vma_prepare() and vma_complete(), where there is no mechanism to
abort - once vma_prepare() has been called, we must reach vma_complete().
By moving the call earlier, a split failure can return -ENOMEM cleanly
without needing to undo VMA preparation.

This move is safe because vma_adjust_trans_huge() acquires its own
pmd_lock() internally and does not depend on any locks or state changes
from vma_prepare(). The VMA boundaries are also unchanged at the new
call site, satisfying __split_huge_pmd_locked()'s requirement that the
VMA covers the full PMD range.

All 3 callers (__split_vma, vma_shrink, commit_merge) already return
-ENOMEM if there are allocation failures for other reasons (failure in
vma_iter_prealloc for example), this follows the same pattern.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/huge_mm.h           | 13 ++++++-----
 mm/huge_memory.c                  | 21 +++++++++++++-----
 mm/vma.c                          | 37 +++++++++++++++++++++----------
 tools/testing/vma/include/stubs.h |  9 ++++----
 4 files changed, 53 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index b081ce044c735..224965fce4e66 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -483,8 +483,8 @@ int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
 		     int advice);
 int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end, bool *lock_dropped);
-void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
-			   unsigned long end, struct vm_area_struct *next);
+int vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, struct vm_area_struct *next);
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
 spinlock_t *__pud_trans_huge_lock(pud_t *pud, struct vm_area_struct *vma);
 
@@ -685,11 +685,12 @@ static inline int madvise_collapse(struct vm_area_struct *vma,
 	return -EINVAL;
 }
 
-static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
-					 unsigned long start,
-					 unsigned long end,
-					 struct vm_area_struct *next)
+static inline int vma_adjust_trans_huge(struct vm_area_struct *vma,
+					unsigned long start,
+					unsigned long end,
+					struct vm_area_struct *next)
 {
+	return 0;
 }
 static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 976a1c74c0870..99f3b8b24c682 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3326,20 +3326,31 @@ static inline int split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned
 	return 0;
 }
 
-void vma_adjust_trans_huge(struct vm_area_struct *vma,
+int vma_adjust_trans_huge(struct vm_area_struct *vma,
 			   unsigned long start,
 			   unsigned long end,
 			   struct vm_area_struct *next)
 {
+	int err;
+
 	/* Check if we need to split start first. */
-	split_huge_pmd_if_needed(vma, start);
+	err = split_huge_pmd_if_needed(vma, start);
+	if (err)
+		return err;
 
 	/* Check if we need to split end next. */
-	split_huge_pmd_if_needed(vma, end);
+	err = split_huge_pmd_if_needed(vma, end);
+	if (err)
+		return err;
 
 	/* If we're incrementing next->vm_start, we might need to split it. */
-	if (next)
-		split_huge_pmd_if_needed(next, end);
+	if (next) {
+		err = split_huge_pmd_if_needed(next, end);
+		if (err)
+			return err;
+	}
+
+	return 0;
 }
 
 static void unmap_folio(struct folio *folio)
diff --git a/mm/vma.c b/mm/vma.c
index a43f3c5d4b3dd..b4a3839a8036e 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -513,6 +513,15 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 			return err;
 	}
 
+	/*
+	 * Split any THP straddling the split boundary before splitting
+	 * the VMA itself. Do this before vma_prepare() so we can
+	 * cleanly fail without undoing VMA preparation.
+	 */
+	err = vma_adjust_trans_huge(vma, vma->vm_start, addr, NULL);
+	if (err)
+		return err;
+
 	new = vm_area_dup(vma);
 	if (!new)
 		return -ENOMEM;
@@ -550,11 +559,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vp.insert = new;
 	vma_prepare(&vp);
 
-	/*
-	 * Get rid of huge pages and shared page tables straddling the split
-	 * boundary.
-	 */
-	vma_adjust_trans_huge(vma, vma->vm_start, addr, NULL);
 	if (is_vm_hugetlb_page(vma))
 		hugetlb_split(vma, addr);
 
@@ -732,6 +736,7 @@ static int commit_merge(struct vma_merge_struct *vmg)
 {
 	struct vm_area_struct *vma;
 	struct vma_prepare vp;
+	int err;
 
 	if (vmg->__adjust_next_start) {
 		/* We manipulate middle and adjust next, which is the target. */
@@ -743,6 +748,16 @@ static int commit_merge(struct vma_merge_struct *vmg)
 		vma_iter_config(vmg->vmi, vmg->start, vmg->end);
 	}
 
+	/*
+	 * THP pages may need to do additional splits if we increase
+	 * middle->vm_start. Do this before vma_prepare() so we can
+	 * cleanly fail without undoing VMA preparation.
+	 */
+	err = vma_adjust_trans_huge(vma, vmg->start, vmg->end,
+				  vmg->__adjust_middle_start ? vmg->middle : NULL);
+	if (err)
+		return err;
+
 	init_multi_vma_prep(&vp, vma, vmg);
 
 	/*
@@ -755,12 +770,6 @@ static int commit_merge(struct vma_merge_struct *vmg)
 		return -ENOMEM;
 
 	vma_prepare(&vp);
-	/*
-	 * THP pages may need to do additional splits if we increase
-	 * middle->vm_start.
-	 */
-	vma_adjust_trans_huge(vma, vmg->start, vmg->end,
-			      vmg->__adjust_middle_start ? vmg->middle : NULL);
 	vma_set_range(vma, vmg->start, vmg->end, vmg->pgoff);
 	vmg_adjust_set_range(vmg);
 	vma_iter_store_overwrite(vmg->vmi, vmg->target);
@@ -1248,9 +1257,14 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff)
 {
 	struct vma_prepare vp;
+	int err;
 
 	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
 
+	err = vma_adjust_trans_huge(vma, start, end, NULL);
+	if (err)
+		return err;
+
 	if (vma->vm_start < start)
 		vma_iter_config(vmi, vma->vm_start, start);
 	else
@@ -1263,7 +1277,6 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, start, end, NULL);
 
 	vma_iter_clear(vmi);
 	vma_set_range(vma, start, end, pgoff);
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index a30b8bc849557..952e3cc88ef10 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -419,11 +419,12 @@ static inline int vma_dup_policy(struct vm_area_struct *src, struct vm_area_stru
 	return 0;
 }
 
-static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
-					 unsigned long start,
-					 unsigned long end,
-					 struct vm_area_struct *next)
+static inline int vma_adjust_trans_huge(struct vm_area_struct *vma,
+					unsigned long start,
+					unsigned long end,
+					struct vm_area_struct *next)
 {
+	return 0;
 }
 
 static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
-- 
2.52.0


