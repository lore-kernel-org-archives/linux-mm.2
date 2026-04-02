Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09293CC6B01
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A0946B008C; Thu,  2 Apr 2026 00:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676DC6B0092; Thu,  2 Apr 2026 00:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4656B0093; Thu,  2 Apr 2026 00:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0636B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:12:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BA7E58A7C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:30 +0000 (UTC)
X-FDA: 84612294060.26.A38DB04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5F40840006
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W0wnJHed;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103148; a=rsa-sha256;
	cv=none;
	b=FWMtJ2feBd4PnLefRj81eoF8d89y4nIJc0iVuRtH7Z8oHv+RCSwRvlq9yhjHeu87zM3UQm
	IN/WAfWO4r/KRHXiBgkoXrJ6EOI4LpYtt47Wdbbe/CtY2zQnch3ZX2JTXkzYXFPJ+tOdGC
	0Brwu214pK8JvwKP6prLsUKvG6Me1OQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9ljvXhnWAGn4ITq2gW17wS0RKG3KgsQU1bynwyclhc=;
	b=tiberNaZFDHERy1E7xVDA1mB0e+5iS2KAEH7WY05h8fmtOYhGYDTk/nWcCYx8c5isJbuU8
	seI7uJqK3XosJw4iGV3vjPhnsr2dTU0rMvMf8e0rbgnMBHZFdEP3lLCkxpU0isyzg9pcX5
	NuFcL2JABCqIkiA5QXdYlwPiVc8ZIHI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=W0wnJHed;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B0C440461;
	Thu,  2 Apr 2026 04:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFF1C19424;
	Thu,  2 Apr 2026 04:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103147;
	bh=r29RRcoEme4UqN+o6MMTGc0o3ga+E0dZNYRM9ni1tig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0wnJHed8Py1/QjFAsaFbm+ktVcRQhSvRRsO7j8/qGRWjH3U5vvwyCxf0bJ4KQPQO
	 1arzTZm+aJtyigQO50fSmS7u19Y3yQ7VgvFbfsSKyUPAzBRScBsxpV8JXnBFzQz4uQ
	 +u96RdoVp3uEPPycvXHZVuNBdAM6s7wH6UZWZK81+Rm0ymUd4vNR1HgHwsCJMRjUPD
	 ALs4fw0e4BioIrIr/C9ko0uPbkL6pcA/DVZmdXmesGz6I1dPNfCIoThVdQDdRV/MUz
	 Gqv16BEn6zNP5UFoikllMyeLKP7F4NViLB0Glc+YIZNbWco/xNS0ucpctdpW0P/PJe
	 +f25Wy/Ruj5qQ==
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
	linux-mm@kvack.org,
	"Harry Yoo (Oracle)" <harry@kernel.org>
Subject: [PATCH v4 03/15] userfaultfd: introduce mfill_establish_pmd() helper
Date: Thu,  2 Apr 2026 07:11:44 +0300
Message-ID: <20260402041156.1377214-4-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F40840006
X-Stat-Signature: 9eotukq1mpxg6pkjm5d1zjdctoh6qjm1
X-HE-Tag: 1775103148-790783
X-HE-Meta: U2FsdGVkX1/tg7wgE8aSWNS3P0vp3PjgAvPWZ5DLSlnQqytrenIH1He9PstBnSzC2CkQpN1xy2lGCW9S1FdV9UDb7WZKsg5ojdtV10nRiiOumpvwGSXPGmnNl9bvNPf4s+qZNbZ2fw48heCcPji2Tl7e+mWD+ZsBggxn/B25etFCWx3SCaTva+c4ZpoLLMhG7ekUANmsnpQa2wKnV95s6Igj78aD3/P+F0/1rZrDHEYsSmMSB37uxYN63XHy2Oht50Ad+ar2LLNxrUZgpebSb0koynmB+fa3d/QV/e+2aKEzEDoYwthS4eSZbAZrPyeOqwpxi+iZWKhW3v/kiO53p21yRPXerNz50sC5HsRG9SmuKo11OAk2a8ZVyv8Z5GugB900WZfm/VPXK/dj4D8WjYhZ9zoWywMHQQajvBbAVOyc7PxKfOzRNFfZ514sZ8uo9zJQFCIfm7MXNX6qDNXwSvRud1RcCcRsr3N2mfLvvF9JE9uJbHcnpalmWIL71Nn0JNBsU3Mr7CuBIGBcptkm/Aufk1mMoFBsB5+c2yzYEikPNqiqQtZD+XV/qkpuxEE/EC5LGvy6N+9R11UFaLLMAY8SmaoyP0eoUVkwzHwPAYdKnbz1t2xF47CG1obVH7OA1rtjC5/FAFBWDXF9LyujLL/Mu/SE5iGPmx6XklURio9hMceWlO71lEUAsQ2UFuf4H1gaNW72EADi+S0ci5O8BWj+0F4L3HqI3FDX1Pm345JACeZ8bjLpeSITdJSU86zLuxvtWzymIgaknXs61NKy5MVvty1X6Ca8GYOEz3vSplVeflNGhth3IwKnDdFV74BMu3YLevu/DBD/TJLje3xnj8/sa3AVaf7egfIEtA9JTfG57XymM+fn92wQnUJF3AQmO6Bp0wW47fq6bcvQRYrWHFGjXdCU8unTTci4bN6rX98u8kwZENljLk0rBFCEO/V9tq8FGvFdFIoj42nd9o0
 k/WaUaLb
 1VPw7DPci/AC+OvnewpwpBI+fWrDobvFwZbkOwA5n17ifPDhRqZO1HMo6cZXWexlZz1HYVtn2RWR711GFnzOq5qDy29ET2nP98+bWOuZudSzM1ePMXms9yh3fb4z/FafnElOa/Q+9MkkItnUarXKvrc0AIBAXna3U2DxiWNvZjZtM5gkQ97U4h//D8mVBm0SXTKGLm30xTS2NNYnr8OFlbGx3kGWDGsHCAEVhzwBP+nqS1RYg/GcHZDcz+r9eKf7KUbHTYoXDakuO+4FHj98SPv9LXasNsRiyl4/uXvuUT9Sb3cLy7joKaDdj7mQ3x31GUTqX
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
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/userfaultfd.c | 102 ++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 50 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index c4074b6f4aca..f653fb3f74df 100644
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
@@ -808,41 +836,15 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
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


