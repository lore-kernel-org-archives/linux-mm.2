Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0618FB3CF5
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277DB6B0098; Mon, 30 Mar 2026 06:11:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202056B0099; Mon, 30 Mar 2026 06:11:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0CA6B009B; Mon, 30 Mar 2026 06:11:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F29AB6B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:11:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC9578BFE7
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:11:49 +0000 (UTC)
X-FDA: 84602313138.23.B57A09F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 28A4A140012
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:11:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PkFVBcKE;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FkpjBBMDahVnoJHQTLrKky2w/Y+q9m6xuZg0sZyc/wU=;
	b=Zym6w7e4S/OsWvGyCd4WTrW2hMaYfne8cJo3NdsjpedtiSTTOk0F/o8wHG3HzEHYBgW7tS
	aYqxSBia1evSAiKjjPE9OZZTdzN34lkQxqZBnTbl+48rQINKA3gSCbiUVvfdrBHUU2+N1i
	RxsBt8hJn+30aanjAcsejiQYxkX098A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865508; a=rsa-sha256;
	cv=none;
	b=7o/Lti+40F1PzzOpiNXEYnBmWu8uLynYkRdOjqC+CWyTdB52EwRzxkQiW7CR+SWZBbp43C
	B8xTmZYxe6pMNWbIEEMy6j+GXhw3Cra0VjG87OGX2ZOnnbbaIFnHh3hoirfOZqs2ERYyAW
	vqqvhMLalW8lvs5NHY1Qz3gNU2GtQr8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PkFVBcKE;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34A6540889;
	Mon, 30 Mar 2026 10:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40C8C2BC9E;
	Mon, 30 Mar 2026 10:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865507;
	bh=1DrXuSwiAhOzaulO5G9xZyzpNsLyxsrB7l2LjMZyGp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkFVBcKEy+nKe+MP3hw+nxp/uTTTK4Qt4cC8Bp1NGkORfgNDuWEFsMdvuEca3uIAO
	 7dmS1MwmwLrXJeSYaKHyDqI+hElmO5KM67rKEKP9DPwf1eYV0It5rn2IUMPVjXkBB3
	 DU4nzNtK+zF1YZwuOFrQHXDwbISsHEPADqec87BJiw7aBw9tCeB6LiKlD8QyEZezE7
	 BRmRNjLofhHABT3Lf0uBQvTeT4Gxz20Xj9nSclmPBkEqQphgeaY1cOnjKgR3PWMHdl
	 oFTDblZOKQHdtqcmqPlvaB5b0Xzwzj3p4Q0cEswOxmJ3zV8dTl1qejLsSeKyEFda55
	 VHDlFfXmWMFVg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 03/15] userfaultfd: introduce mfill_establish_pmd() helper
Date: Mon, 30 Mar 2026 13:11:04 +0300
Message-ID: <20260330101116.1117699-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 28A4A140012
X-Stat-Signature: qnkyo545am8eptj8oppuskhutfp93rf9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774865507-346225
X-HE-Meta: U2FsdGVkX1/IV5P9BEl7SXcC56YZII1/cTZoWcI6BhMAJAQh2erUrFGq9idDtSVDwaEliGOTb9Xj29HvvLYjyv3VnsLk8cbbYBOaBuXHSRGRnU9czfGiL9Ptn2LhxILzBRnvvf+AkghWBnbjUTZoE2vK/0K/IR7vVLRrrgZJR2ks29lrdEWSYJ/43FDZ8R7ooCSVGyiREi+QD6/AsitiNDCb4qzMKxMziz0i1OATfu88DOD4ZsciR4K//ns989/RrFCvmP3YGlwpw6qj5v4ax5RNApUBZ3SZdIHl+54KG6HlODf3eaONd6xO1JOxg3zU/UmQPNN60/y1pH0RpAoKrhmwHtx9Ukq33dYBIYrqBtgTH0AN6IgxU720XheSxE5Kjeu+UAbYkdPcgcoc94zzytxRUWqfVhMupjMbXhT7YI9E9l8YeXMhh7aAXU6XokKaHfiRzuJOUtoYl7fCnkARrFIPaiGDsV1icpFx73Ppidf/pWtofJxTzUSf0ar+1uiTq+ofalFAkB4/mfPULV//WyWVPmMxpaxge5ekACiorNNlX/bACvXn4W6O+/7g7fR2gX6txnKEhn/8jk5RYeKymxFltFWqoy0Ly3FRwGI7PnxB3zzKm8d5krMrtfRlU8VcSLVRDgVsgsEu8CXeMqTR5WdaHxAX+qMCURQWieftbM4pk641suW/RIf65uLTIOah5wnCxWU352f/oJM5IWNzpDphAEmD0HLHJXxCaeqzV23WFIPPWhEZBFRdfiJ8oj980wUFtnOQp3RX5JScOiDZub86g/vRx6Matr1uVZtMQuQeP2ZzbzretpKCHh1DoVODgwPWJ5i1CkmIDAH9r161tVTbky4dhsz6y9TK3rrtvVEHzeVli1PVcHhqnJYu/ORAcTPZEDBQJXvJJJAuqVkQ15k6I83xJ34l36uIOlfOlZI+bjkC7j85sTZW/c3g3/pbx/CTEpHORf1qb3H8xSy
 Jujghj4m
 QZnc7ebf+A4X6j2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

There is a lengthy code chunk in mfill_atomic() that establishes the PMD
for UFFDIO operations.  This code may be called twice: first time when the
copy is performed with VMA/mm locks held and the other time after the copy
is retried with locks dropped.

Move the code that establishes a PMD into a helper function so it can be
reused later during refactoring of mfill_atomic_pte_copy().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 102 ++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 50 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index fa9622ec7279..291e5cfed431 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -157,6 +157,56 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
 }
 #endif
 
+static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+
+	pgd = pgd_offset(mm, address);
+	p4d = p4d_alloc(mm, pgd, address);
+	if (!p4d)
+		return NULL;
+	pud = pud_alloc(mm, p4d, address);
+	if (!pud)
+		return NULL;
+	/*
+	 * Note that we didn't run this because the pmd was
+	 * missing, the *pmd may be already established and in
+	 * turn it may also be a trans_huge_pmd.
+	 */
+	return pmd_alloc(mm, pud, address);
+}
+
+static int mfill_establish_pmd(struct mfill_state *state)
+{
+	struct mm_struct *dst_mm = state->ctx->mm;
+	pmd_t *dst_pmd, dst_pmdval;
+
+	dst_pmd = mm_alloc_pmd(dst_mm, state->dst_addr);
+	if (unlikely(!dst_pmd))
+		return -ENOMEM;
+
+	dst_pmdval = pmdp_get_lockless(dst_pmd);
+	if (unlikely(pmd_none(dst_pmdval)) &&
+	    unlikely(__pte_alloc(dst_mm, dst_pmd)))
+		return -ENOMEM;
+
+	dst_pmdval = pmdp_get_lockless(dst_pmd);
+	/*
+	 * If the dst_pmd is THP don't override it and just be strict.
+	 * (This includes the case where the PMD used to be THP and
+	 * changed back to none after __pte_alloc().)
+	 */
+	if (unlikely(!pmd_present(dst_pmdval) || pmd_leaf(dst_pmdval)))
+		return -EEXIST;
+	if (unlikely(pmd_bad(dst_pmdval)))
+		return -EFAULT;
+
+	state->pmd = dst_pmd;
+	return 0;
+}
+
 /* Check if dst_addr is outside of file's size. Must be called with ptl held. */
 static bool mfill_file_over_size(struct vm_area_struct *dst_vma,
 				 unsigned long dst_addr)
@@ -489,27 +539,6 @@ static int mfill_atomic_pte_poison(struct mfill_state *state)
 	return ret;
 }
 
-static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-
-	pgd = pgd_offset(mm, address);
-	p4d = p4d_alloc(mm, pgd, address);
-	if (!p4d)
-		return NULL;
-	pud = pud_alloc(mm, p4d, address);
-	if (!pud)
-		return NULL;
-	/*
-	 * Note that we didn't run this because the pmd was
-	 * missing, the *pmd may be already established and in
-	 * turn it may also be a trans_huge_pmd.
-	 */
-	return pmd_alloc(mm, pud, address);
-}
-
 #ifdef CONFIG_HUGETLB_PAGE
 /*
  * mfill_atomic processing for HUGETLB vmas.  Note that this routine is
@@ -742,7 +771,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	struct vm_area_struct *dst_vma;
 	long copied = 0;
 	ssize_t err;
-	pmd_t *dst_pmd;
 
 	/*
 	 * Sanitize the command parameters:
@@ -809,41 +837,15 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
-		pmd_t dst_pmdval;
-
-		dst_pmd = mm_alloc_pmd(dst_mm, state.dst_addr);
-		if (unlikely(!dst_pmd)) {
-			err = -ENOMEM;
+		err = mfill_establish_pmd(&state);
+		if (err)
 			break;
-		}
 
-		dst_pmdval = pmdp_get_lockless(dst_pmd);
-		if (unlikely(pmd_none(dst_pmdval)) &&
-		    unlikely(__pte_alloc(dst_mm, dst_pmd))) {
-			err = -ENOMEM;
-			break;
-		}
-		dst_pmdval = pmdp_get_lockless(dst_pmd);
-		/*
-		 * If the dst_pmd is THP don't override it and just be strict.
-		 * (This includes the case where the PMD used to be THP and
-		 * changed back to none after __pte_alloc().)
-		 */
-		if (unlikely(!pmd_present(dst_pmdval) ||
-				pmd_trans_huge(dst_pmdval))) {
-			err = -EEXIST;
-			break;
-		}
-		if (unlikely(pmd_bad(dst_pmdval))) {
-			err = -EFAULT;
-			break;
-		}
 		/*
 		 * For shmem mappings, khugepaged is allowed to remove page
 		 * tables under us; pte_offset_map_lock() will deal with that.
 		 */
 
-		state.pmd = dst_pmd;
 		err = mfill_atomic_pte(&state);
 		cond_resched();
 
-- 
2.53.0


