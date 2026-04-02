Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1259CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62A046B008A; Thu,  2 Apr 2026 00:12:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601FF6B008C; Thu,  2 Apr 2026 00:12:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 518C76B0092; Thu,  2 Apr 2026 00:12:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44EF76B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:12:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCD448B610
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:22 +0000 (UTC)
X-FDA: 84612293724.30.B5F6F93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2AB5D100005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nuySZNSS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wdUP4B8+063/EAXSsqtsZkg6kgQma8SrelR7tYjfMT8=;
	b=bAdq1GxSk9U4T0pwihuPIED9B+Q1SkyuhTHGuSnbaEYhy/cSpvumpAuKJyJ7x/T/22jHyI
	rrWJL1W0VpnWm5wRTK7SbzWlLIomfcy8es5w8JeMJTG7hsVqibrWSMKCe69TpYmYmKp6Yl
	+lTtGFM4jDQ5mO9xaYZHV4ZFOlUoKl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103141; a=rsa-sha256;
	cv=none;
	b=mlH90FrOua3pX3Fpq0T4OTM05FQIS6xIdSARoA8KMX2cjPtUJScnyAbDN6iwwMFlmHjh1F
	e/JjX5GsMkVgUjn5+gXv8U2500fSwe5sPvHMbqU9YSmVE3TLLDOHUQ5yu/67xum62+HBZ6
	sg/Zftqn+rizaO4Z6zbVrHqPvGCA7Jo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nuySZNSS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6581D61855;
	Thu,  2 Apr 2026 04:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D003AC19423;
	Thu,  2 Apr 2026 04:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103140;
	bh=Ibzvh4mmDhdNLy62raQyz44ZZGrqsaxE++tKr6wD2MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nuySZNSSQCsKxusyO9lwYQOvSUv/YBp5honCfrQAdNa7teZJm+oUOW+VAYc1Czpty
	 pvd0i7tYH+/5odbiwyv6sxaDboHJ4siGnADYhy8INw+rVDqxIuz82PlDjCB92gKvJe
	 ikm4HOZFqcR9VcvOR8EWdQV0r0TziEeB72SpeHbdrf3aU5emH/5p8vvm80BPvNhy7O
	 rKLxwqQ/kmMZ0DH6S18ZiXD3YXjXrFHFvK9bBsXZq2zrs4oUuwpauLeYxjJuYPmJJ+
	 6lQMUkNtpvWQqguXbq/jhOn+wpmEDoDB/r++Cr6vMda7Trj7aoTcE1XXJNV5BLLg3Y
	 QVGmVUSRRWVRA==
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
Subject: [PATCH v4 02/15] userfaultfd: introduce struct mfill_state
Date: Thu,  2 Apr 2026 07:11:43 +0300
Message-ID: <20260402041156.1377214-3-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2AB5D100005
X-Stat-Signature: kbfiwkfparxtgth54ruwxzaw5irwj5q4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775103140-456081
X-HE-Meta: U2FsdGVkX1/oZL/BRBitRofsYjcqicVWJfFabrlFX/Y9c1B0yRteUDF0vq5eUBxwyiqqD77XBVZFhbpKa7rCKs/TV+S7voiquBHjYOV5D7iyBGbfoLtrP3Eft39skZz/qfB7eo5zMXBkB9+3sS6WF2dC4VX+WAfOplerqlo1xGabyw13IQpXo998js4KRdC2iH++xbpgvYA4/AQsChxI6Ff/YtfFEacWxxKcgUnnR1zwOXk5n5GGzQ7mvVE0lSvcDuxcXoGrAG3FXJISEHOzkS89ugfRpYBIXVxy1PX075T7g8i8wqrmLIyP7nfMXeZXFdX8fkVStZUacNeK2sHXbAofEymx2X694360yWVj1Yy+tp/GqzgwzMYsWgQ71mpIcDh5lsZJUgWjILQQU2i02eLpAWk4cQLxCkaaA7FFR5XRSDo7dOGgAyFLSqRxNdUX+wcnTxcdl2+mgpZHZS8c4q1N8RDL6eXrOeUAdCRbeuB9zHavpIu4H/eJMOLclJvxTIXWB2B516IJnAcHU5GhCjtW8XVKy1IQOyGqGnbpXqWClkWmhFC6JUDhMhMgbnH+kPxm9uY5noTIUeHDQinkHMtEz1iHNaJVhSZJ45fZZC+23kc1ZWjiKTrWaNy8taYZcLdfJ/ZQUeS97gHZwrVnVihCoWiXgjzIt9hdNEf0MlnIwCtEKVxpR+qha+i73ULzv/YqpXqxgKBG3NXdGbnIeoO3GNRjDcmZpcYuwYO1+oHobqxPeKEQ4BAtd5K5oFxASRGTYKEgpRwo/n2kFuQQAM1Rq8Itx0hj8bwXP5GwEXE+RF/Imvdz7Ny5WfkcMlLx4OJMJO0iKX7NXuZRDlmJdB1ZNWC5jQaL1/eJd+tErriBBkaATjwC+I393byonUIeuqjk/v7V957QUnkodTgpLgsB3IxuPCo+xHqCS75Ogq9rwpqRrSunDpvJ052gOW6p29KB/eB1RBfVIOp+Egl
 tk0zY6ja
 ZZI+HZNygX/+lYIj5X9xnTco60jkqk0z+wIj91IdqmLpnRLlc1jUPjCtmntoMtXlYTtXKciKWTTLp9lBzz7rhGr8+recXZInWEKtkGz9d/TNNGOZ6O5sz+Wzgnqp+ba3i8MNjDVCnTQ2RMB7smM58exwzpKt4D/UUizEikbACzWxhEp1WwD3A4npOpBhdUuwYqtaX+cqrgqvN4CnBc5HeKV9/tajEBM9v5ZjgKDiim3YNswJ3i0rSTfi0C07lCyH3X3JsZPvFKcTE1GSsFeTbmHlaq5eSiHhx7LteX9aiEEO3iM4R0eAFFxyppw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

mfill_atomic() passes a lot of parameters down to its callees.

Aggregate them all into mfill_state structure and pass this structure to
functions that implement various UFFDIO_ commands.

Tracking the state in a structure will allow moving the code that retries
copying of data for UFFDIO_COPY into mfill_atomic_pte_copy() and make the
loop in mfill_atomic() identical for all UFFDIO operations on PTE-mapped
memory.

The mfill_state definition is deliberately local to mm/userfaultfd.c,
hence shmem_mfill_atomic_pte() is not updated.

[harry.yoo@oracle.com: properly initialize mfill_state.len to fix
                       folio_add_new_anon_rmap() WARN]
Link: https://lkml.kernel.org/r/abehBY7QakYF9bK4@hyeyoo
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 147 ++++++++++++++++++++++++++---------------------
 1 file changed, 81 insertions(+), 66 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 32637d557c95..c4074b6f4aca 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -20,6 +20,20 @@
 #include "internal.h"
 #include "swap.h"
 
+struct mfill_state {
+	struct userfaultfd_ctx *ctx;
+	unsigned long src_start;
+	unsigned long dst_start;
+	unsigned long len;
+	uffd_flags_t flags;
+
+	struct vm_area_struct *vma;
+	unsigned long src_addr;
+	unsigned long dst_addr;
+	struct folio *folio;
+	pmd_t *pmd;
+};
+
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
@@ -272,17 +286,17 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
-static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
-				 struct vm_area_struct *dst_vma,
-				 unsigned long dst_addr,
-				 unsigned long src_addr,
-				 uffd_flags_t flags,
-				 struct folio **foliop)
+static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	int ret;
+	struct vm_area_struct *dst_vma = state->vma;
+	unsigned long dst_addr = state->dst_addr;
+	unsigned long src_addr = state->src_addr;
+	uffd_flags_t flags = state->flags;
+	pmd_t *dst_pmd = state->pmd;
 	struct folio *folio;
+	int ret;
 
-	if (!*foliop) {
+	if (!state->folio) {
 		ret = -ENOMEM;
 		folio = vma_alloc_folio(GFP_HIGHUSER_MOVABLE, 0, dst_vma,
 					dst_addr);
@@ -294,13 +308,13 @@ static int mfill_atomic_pte_copy(pmd_t *dst_pmd,
 		/* fallback to copy_from_user outside mmap_lock */
 		if (unlikely(ret)) {
 			ret = -ENOENT;
-			*foliop = folio;
+			state->folio = folio;
 			/* don't free the page */
 			goto out;
 		}
 	} else {
-		folio = *foliop;
-		*foliop = NULL;
+		folio = state->folio;
+		state->folio = NULL;
 	}
 
 	/*
@@ -357,10 +371,11 @@ static int mfill_atomic_pte_zeroed_folio(pmd_t *dst_pmd,
 	return ret;
 }
 
-static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
-				     struct vm_area_struct *dst_vma,
-				     unsigned long dst_addr)
+static int mfill_atomic_pte_zeropage(struct mfill_state *state)
 {
+	struct vm_area_struct *dst_vma = state->vma;
+	unsigned long dst_addr = state->dst_addr;
+	pmd_t *dst_pmd = state->pmd;
 	pte_t _dst_pte, *dst_pte;
 	spinlock_t *ptl;
 	int ret;
@@ -392,13 +407,14 @@ static int mfill_atomic_pte_zeropage(pmd_t *dst_pmd,
 }
 
 /* Handles UFFDIO_CONTINUE for all shmem VMAs (shared or private). */
-static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
-				     struct vm_area_struct *dst_vma,
-				     unsigned long dst_addr,
-				     uffd_flags_t flags)
+static int mfill_atomic_pte_continue(struct mfill_state *state)
 {
-	struct inode *inode = file_inode(dst_vma->vm_file);
+	struct vm_area_struct *dst_vma = state->vma;
+	unsigned long dst_addr = state->dst_addr;
 	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
+	struct inode *inode = file_inode(dst_vma->vm_file);
+	uffd_flags_t flags = state->flags;
+	pmd_t *dst_pmd = state->pmd;
 	struct folio *folio;
 	struct page *page;
 	int ret;
@@ -436,15 +452,15 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
 }
 
 /* Handles UFFDIO_POISON for all non-hugetlb VMAs. */
-static int mfill_atomic_pte_poison(pmd_t *dst_pmd,
-				   struct vm_area_struct *dst_vma,
-				   unsigned long dst_addr,
-				   uffd_flags_t flags)
+static int mfill_atomic_pte_poison(struct mfill_state *state)
 {
-	int ret;
+	struct vm_area_struct *dst_vma = state->vma;
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
+	unsigned long dst_addr = state->dst_addr;
+	pmd_t *dst_pmd = state->pmd;
 	pte_t _dst_pte, *dst_pte;
 	spinlock_t *ptl;
+	int ret;
 
 	_dst_pte = make_pte_marker(PTE_MARKER_POISONED);
 	ret = -EAGAIN;
@@ -668,22 +684,20 @@ extern ssize_t mfill_atomic_hugetlb(struct userfaultfd_ctx *ctx,
 				    uffd_flags_t flags);
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static __always_inline ssize_t mfill_atomic_pte(pmd_t *dst_pmd,
-						struct vm_area_struct *dst_vma,
-						unsigned long dst_addr,
-						unsigned long src_addr,
-						uffd_flags_t flags,
-						struct folio **foliop)
+static __always_inline ssize_t mfill_atomic_pte(struct mfill_state *state)
 {
+	struct vm_area_struct *dst_vma = state->vma;
+	unsigned long src_addr = state->src_addr;
+	unsigned long dst_addr = state->dst_addr;
+	struct folio **foliop = &state->folio;
+	uffd_flags_t flags = state->flags;
+	pmd_t *dst_pmd = state->pmd;
 	ssize_t err;
 
-	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE)) {
-		return mfill_atomic_pte_continue(dst_pmd, dst_vma,
-						 dst_addr, flags);
-	} else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON)) {
-		return mfill_atomic_pte_poison(dst_pmd, dst_vma,
-					       dst_addr, flags);
-	}
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+		return mfill_atomic_pte_continue(state);
+	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_POISON))
+		return mfill_atomic_pte_poison(state);
 
 	/*
 	 * The normal page fault path for a shmem will invoke the
@@ -697,12 +711,9 @@ static __always_inline ssize_t mfill_atomic_pte(pmd_t *dst_pmd,
 	 */
 	if (!(dst_vma->vm_flags & VM_SHARED)) {
 		if (uffd_flags_mode_is(flags, MFILL_ATOMIC_COPY))
-			err = mfill_atomic_pte_copy(dst_pmd, dst_vma,
-						    dst_addr, src_addr,
-						    flags, foliop);
+			err = mfill_atomic_pte_copy(state);
 		else
-			err = mfill_atomic_pte_zeropage(dst_pmd,
-						 dst_vma, dst_addr);
+			err = mfill_atomic_pte_zeropage(state);
 	} else {
 		err = shmem_mfill_atomic_pte(dst_pmd, dst_vma,
 					     dst_addr, src_addr,
@@ -718,13 +729,20 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 					    unsigned long len,
 					    uffd_flags_t flags)
 {
+	struct mfill_state state = (struct mfill_state){
+		.ctx = ctx,
+		.dst_start = dst_start,
+		.src_start = src_start,
+		.flags = flags,
+		.len = len,
+		.src_addr = src_start,
+		.dst_addr = dst_start,
+	};
 	struct mm_struct *dst_mm = ctx->mm;
 	struct vm_area_struct *dst_vma;
+	long copied = 0;
 	ssize_t err;
 	pmd_t *dst_pmd;
-	unsigned long src_addr, dst_addr;
-	long copied;
-	struct folio *folio;
 
 	/*
 	 * Sanitize the command parameters:
@@ -736,10 +754,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	VM_WARN_ON_ONCE(src_start + len <= src_start);
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
-	src_addr = src_start;
-	dst_addr = dst_start;
-	copied = 0;
-	folio = NULL;
 retry:
 	/*
 	 * Make sure the vma is not shared, that the dst range is
@@ -750,6 +764,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		err = PTR_ERR(dst_vma);
 		goto out;
 	}
+	state.vma = dst_vma;
 
 	/*
 	 * If memory mappings are changing because of non-cooperative
@@ -790,12 +805,12 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
 		goto out_unlock;
 
-	while (src_addr < src_start + len) {
-		pmd_t dst_pmdval;
+	while (state.src_addr < src_start + len) {
+		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
-		VM_WARN_ON_ONCE(dst_addr >= dst_start + len);
+		pmd_t dst_pmdval;
 
-		dst_pmd = mm_alloc_pmd(dst_mm, dst_addr);
+		dst_pmd = mm_alloc_pmd(dst_mm, state.dst_addr);
 		if (unlikely(!dst_pmd)) {
 			err = -ENOMEM;
 			break;
@@ -827,34 +842,34 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		 * tables under us; pte_offset_map_lock() will deal with that.
 		 */
 
-		err = mfill_atomic_pte(dst_pmd, dst_vma, dst_addr,
-				       src_addr, flags, &folio);
+		state.pmd = dst_pmd;
+		err = mfill_atomic_pte(&state);
 		cond_resched();
 
 		if (unlikely(err == -ENOENT)) {
 			void *kaddr;
 
 			up_read(&ctx->map_changing_lock);
-			uffd_mfill_unlock(dst_vma);
-			VM_WARN_ON_ONCE(!folio);
+			uffd_mfill_unlock(state.vma);
+			VM_WARN_ON_ONCE(!state.folio);
 
-			kaddr = kmap_local_folio(folio, 0);
+			kaddr = kmap_local_folio(state.folio, 0);
 			err = copy_from_user(kaddr,
-					     (const void __user *) src_addr,
+					     (const void __user *)state.src_addr,
 					     PAGE_SIZE);
 			kunmap_local(kaddr);
 			if (unlikely(err)) {
 				err = -EFAULT;
 				goto out;
 			}
-			flush_dcache_folio(folio);
+			flush_dcache_folio(state.folio);
 			goto retry;
 		} else
-			VM_WARN_ON_ONCE(folio);
+			VM_WARN_ON_ONCE(state.folio);
 
 		if (!err) {
-			dst_addr += PAGE_SIZE;
-			src_addr += PAGE_SIZE;
+			state.dst_addr += PAGE_SIZE;
+			state.src_addr += PAGE_SIZE;
 			copied += PAGE_SIZE;
 
 			if (fatal_signal_pending(current))
@@ -866,10 +881,10 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 
 out_unlock:
 	up_read(&ctx->map_changing_lock);
-	uffd_mfill_unlock(dst_vma);
+	uffd_mfill_unlock(state.vma);
 out:
-	if (folio)
-		folio_put(folio);
+	if (state.folio)
+		folio_put(state.folio);
 	VM_WARN_ON_ONCE(copied < 0);
 	VM_WARN_ON_ONCE(err > 0);
 	VM_WARN_ON_ONCE(!copied && !err);
-- 
2.53.0


