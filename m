Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B473FC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:33:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D3666B008C; Thu, 26 Feb 2026 06:33:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A066B0092; Thu, 26 Feb 2026 06:33:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761FA6B0093; Thu, 26 Feb 2026 06:33:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 63A376B008C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:33:17 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A74CBD1EA
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:16 +0000 (UTC)
X-FDA: 84486396792.02.4480DDD
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id 753C28001D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ntm7c4wG;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2wV75ycWB4G3qq8SlJolQA0LHwO/bo1HFS74uWGxBRw=;
	b=Y/J2JxyfmHQa6YyQmn2nhUUIzTUzmLUz33p6n3aauIw2onMqpo9JobaW3FQHSq8lBW2Hlp
	YOBU6inqdfTm+lrtFvhNZv2jhovg5771pRkUnWpCSPvdTkVkCcdYqnakGLm+J5bkz2gcdj
	JdtlimB95sq7fTM1y+VxOP3UBAofrP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105594; a=rsa-sha256;
	cv=none;
	b=qrw8bYKw2XH9bARfDjQb2zc45WCFPSonzru4dYRQKx1pclA8Ivi9DR9eQxGlLN1Vx/haz/
	j4MsrIqvQtAiOxktP2XmgBTxqaG2LKPyQwwNFqIOdFvHt3+Tz2yNW68rtOmIwDvoEp3URc
	t8h3RudQEZ2nOj/iEFpOGGCv4TeuFU4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ntm7c4wG;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2wV75ycWB4G3qq8SlJolQA0LHwO/bo1HFS74uWGxBRw=;
	b=Ntm7c4wGMxkHypNZVQKbHs8TTIz27iUQ6yNvJF8E1SZ+Fq3QLZZ+cJB62Cw0Bd3ziCm6pj
	SmukNQafpR/c4gmMWxFcvO732rYRlWl8/zW+U+JjZixPks++JafCzkFlL73zeKLtzOPfAf
	PD/PlDtkk+CZZAVIdlqmB0cfhdOs3OA=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
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
Subject: [RFC v2 02/21] mm: thp: propagate split failure from vma_adjust_trans_huge()
Date: Thu, 26 Feb 2026 03:23:31 -0800
Message-ID: <20260226113233.3987674-3-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 753C28001D
X-Stat-Signature: ib9nzp3gjs45wtuik1oux5jjao9f1j65
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772105594-514123
X-HE-Meta: U2FsdGVkX1/Hiba7MISSsTwG14CiVS4d4uuiZTq4dUxUM77GTsFetjluub6gtsc5wstkNmNK+UUiXbMo/Rkobh1M0bRXHXVpD09keCCyru8FViCt64oSkNfYQI3DJo7XH/Ue6hePug1a5T84Tg9cB1wefGRsUGVvW92R8Ihsx3nMERdW1xRqg12PZrksA1Ln8+DonyHduXQFLIkwpyydOv3Q9/55WbJwqLcNxgpRmoj41y7hOytXX6PIIWmDmDh+AqBsxolTdqu+Zl8Z03yUAgHKwpurHddLAkW/R4BmpMfFylSrUEBRChJaNoSsttOlB0FXGppbltgEh+zZ4QSy0O6xYw5f/1EonSkeHA8Lc95bj8xiF7zN3WYbXyHQM5d8Lthba4ZRXpydlO3FqbjUMcuiGa8urKoHYoQeCQBMjbVK7GkH1vB3mzoKR2qjU21J9ztz+xM/2fYZ4WmAzwb8mlwQdHtym/AlO4sFuwOMEy7c2NT9vcVrxCYd5oU1ZlM6/FrQs6L2jWavQ3OYBWHeB/6mErkjXEOS+WWHetZcal3IcF/V80n9Zb0NC+1t+5uPuve2WVRbqGfWTiVVmvaXqb/+ajU2EW9hOrObDroXaO51F0+v/aEBtYnw7/1YTwppedYKKQl5MmzNW2PdAvOQZLHb/wJCVUhGSMdwgV91G0rOn1Q00s4UXJpkkR8QreHHpFCW+8fAszxkVxIICDAZ4POC/pUPAOOmNIzyryp+qNprrGZ/X7/VZsrY00Bm/PK7LmlUoeYPynUxXgW07XJB+AI7l5Ys5Qj7vhQWFIE4OPuPxD3iW87pgxfqvXwMYIe0rvOD8n05qUKPyRYNU77j9PM7xmLo7UKQ6KiWneacKFAH+Mz3c+8zvsk+Qk/RJSLngxD//5RT26zY1OuLQKTk2B7KPWsKcblEmGvvyvmOIhQo+seH3e9i89CKPAjmpvsgGeqLLZ923PMzrYMu3l4
 dWnr2Eyx
 RVxwoTnS3UpZ/ZSPCKIyfM76MlOMvLNV69wwhj4tjDFX/yUZZY0qQ/gqNb7mL3cwgE07XOPZUWA9FisNErnhwlKqc7GTp9koyJbGMR3Szs7LSW7607Ti9g/DEljfSYu8nb0NNFOI9qDJIUj2SN/WRzosqkh3nfdqXq0mBnHN2QNrlY1XwQz6sAh1UhzoKV0nVDGzDuMPvxh1t7mmPZ9xwODOl6PmI2BT0/11Q9FCVJ6hp/Xqr4JYhJ8Xy/A==
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
index e4cbf5afdbe7e..207bf7cd95c78 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -484,8 +484,8 @@ int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
 		     int advice);
 int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end, bool *lock_dropped);
-void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
-			   unsigned long end, struct vm_area_struct *next);
+int vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, struct vm_area_struct *next);
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
 spinlock_t *__pud_trans_huge_lock(pud_t *pud, struct vm_area_struct *vma);
 
@@ -687,11 +687,12 @@ static inline int madvise_collapse(struct vm_area_struct *vma,
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
index 125ff36f475de..a979aa5bd2995 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3316,20 +3316,31 @@ static inline int split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned
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
index be64f781a3aa7..f50b1f291ab7c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -510,6 +510,15 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
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
@@ -547,11 +556,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vp.insert = new;
 	vma_prepare(&vp);
 
-	/*
-	 * Get rid of huge pages and shared page tables straddling the split
-	 * boundary.
-	 */
-	vma_adjust_trans_huge(vma, vma->vm_start, addr, NULL);
 	if (is_vm_hugetlb_page(vma))
 		hugetlb_split(vma, addr);
 
@@ -729,6 +733,7 @@ static int commit_merge(struct vma_merge_struct *vmg)
 {
 	struct vm_area_struct *vma;
 	struct vma_prepare vp;
+	int err;
 
 	if (vmg->__adjust_next_start) {
 		/* We manipulate middle and adjust next, which is the target. */
@@ -740,6 +745,16 @@ static int commit_merge(struct vma_merge_struct *vmg)
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
@@ -752,12 +767,6 @@ static int commit_merge(struct vma_merge_struct *vmg)
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
@@ -1229,9 +1238,14 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
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
@@ -1244,7 +1258,6 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
-	vma_adjust_trans_huge(vma, start, end, NULL);
 
 	vma_iter_clear(vmi);
 	vma_set_range(vma, start, end, pgoff);
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index 947a3a0c25665..171986f9c9fcd 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -418,11 +418,12 @@ static inline int vma_dup_policy(struct vm_area_struct *src, struct vm_area_stru
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
2.47.3


