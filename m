Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A478DD2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:30:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E863F6B008A; Tue, 27 Jan 2026 14:30:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4E6A6B008C; Tue, 27 Jan 2026 14:30:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88EE6B0092; Tue, 27 Jan 2026 14:30:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA59E6B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:30:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47B731B041A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:02 +0000 (UTC)
X-FDA: 84378734244.16.67F6DB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id AE42B1A0003
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ooGptc46;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=921g6WOTzGTUCk0Lus4XbX1zpiayC5x9nuxmemZCFR8=;
	b=oxTZQNCOKlNtq0vwa/jKWFIaMK4Kz3KbRtxHLccy0toTB36NRxzMhgkOYLqF86ihUSNnKG
	Kxb3kxoofMq17sJ+8Vo/qvPKjXzugw0EUe6kwNQK8Hib8t2RumqU+HpEBz+nxNC3Qpk6xU
	gcN0r33aO4StB7X6EX4lwi3xGR3YWlk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542200; a=rsa-sha256;
	cv=none;
	b=ANDWo3WVEy5VRPEq6Lyf6Nzyadyt3S3kCDjge7wu70CiagLRBt9K+FzNBNLGgau2vobSYn
	4uvhOf5bd+P0vU3d3BIKA9IWqVJ2XXfw4N8amRmsID9XmDnLizmMPy9zximoWUlWI4v8pD
	JR0Bi8KaQ15fXawUjp9Jn+z8EwIRqUc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ooGptc46;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 279C9601F9;
	Tue, 27 Jan 2026 19:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2044FC116C6;
	Tue, 27 Jan 2026 19:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542199;
	bh=QA0/2G/K3ZBW3GhC7A4tfiRTq7LYOOc+8j2kW+8FnYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooGptc46J+V4zaOBgMR5V5oW964P8jwsjhTyh26ptaR2Uzz5YCZvZDI+tiwrm+9vb
	 I4FTzO1f/yKV7oi88yV2Ka4LLX0tpS86XWLDFcUeDQ4+5bydO1zCjl9kDLIUStScmu
	 o/65K1e7p8pWAANkdpveXk8qxmqQwxNwpWKlFQ5c4jOqeCyRgcAJ9SwYHS7xaXUEmB
	 X4mgaXSSxKTSU5rgo1wlPGZXwHzQ4FpE3meM3saJUpUNzdzewdmyKKhRpqUSa+vkVz
	 pyHQ8USM1zM3U+R10dlg22Xfm60B5O7bJPS3snC9o9cjUxKiudhrjwgHT/FfrkR8n6
	 +8ZDzXtdfihtg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH RFC 02/17] userfaultfd: introduce struct mfill_state
Date: Tue, 27 Jan 2026 21:29:21 +0200
Message-ID: <20260127192936.1250096-3-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE42B1A0003
X-Stat-Signature: fam71x9pgbpys1xtfs4wcwmnmje4k6c6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769542200-491917
X-HE-Meta: U2FsdGVkX18inU5xUa7Jw1yr6SBiTy/WMjKodd7V9o3sNRIl3mw3uiglhRf0W7hpBnbg281UXtRH/uPSblWnRt9/TLji+LpF4g2TIderHDL/h0zmrVdDpqBFpQxs4UFREf3Mq+TATQ5kCmOd/ozYdJo4bTByPllApi98An7tgjVaPC4A2kSdSwb8fEyRg98HKKdvuvNbgTVQBIxkHHz1nzaicCv6Trcf7tfkR9/p2pGOVSc0SUi20orrNyw+0Hv9jVPQGYQj6j17Kirn10+GbuaMzOVEUES5mHeXsPIOmvLSVtfUf3Kl0/gT294TKfzEztCmsBoufWVUbO7BP4L8ttxN3LfiedztDNT4DiYp08SHayJNGHlxh3hAN1CWqww1yC+raWUmKitclNE95z8mUMIBpfiptH9KoxDaAW/vzcSaui0wRdMUgeErW9HofL1ZAsh9UJD92cQ0tdI+WsLqL5gkh6ZSlW37Yh1N0f9NyG4FE6+kQtBDK0EFPybFI309tF7OqNrpANbSvoxppIEsZ3zMvTJBbUairlVmJJWaWIkns6mLLVhGFQSaJyPtEK9wcPaR+1KYTRha49CRxuokoNYmzEvs/NgGMj/fqXtj8TVWLRMP9DRiwq2XeJ6YMN+F0L5Hi8gpVGzOdFKJqRvvBZRPDanF7yltlK5HRpujiMF1k1XPEOQPgzLb1WCG+VjZxd/IdE327Mv44eVaAygVxR7Vpc/H7rWZ2aLxH+TLVHavepNmEqPH5UJPimdthmYuZR0AuWrrUoMW5CmSSik6hrcvxZgdSSof8xechFKyuJdg02zbdfWZwGR0+gnHUTRVmI4JtrB1nLHQMpnkaKW+q5IQaFvBC6BU3FI3VmBwKlPEx2g+/LdagZrJQ4iVTB6p9ak7KLwxId/zljudkkNw/cCoxeytBrSY3zktBC2wn74Pxl3Fh6RpBJf8ZGKLmHOXxBqaZrDBL2inrF1z6jT
 kT0LbYRk
 NRU+/LkiiXdrnp/1ZhyKTDdqi3t0H8NA1Mnj3fdTsOQJxUDc91oBG90vzPb3lEOgytjK1yLMIvYvAV/33rktX6LqEdC4xyezl3c8fiUPDJJMUBB3ReQypqQ5Pn/9Y+tp+eekEKcwQNemmN1YODj24UB3ZzddyFj+3q2Wz7iW/qn5AH/lTOFWJLOWiZBCAvSls1kgnno/V+/WH0GPhmehWxJhqEthjG01FcajOfogVEzAMzVdVIqegZaF1GhupRM3CE1FHvLqCMkA2Rgx959WBqDYwgw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

The mfill_state definition is deliberately local to mm/userfaultfd.c, hence
shmem_mfill_atomic_pte() is not updated.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 148 ++++++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 66 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index a0885d543f22..6a0697c93ff4 100644
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
+
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
@@ -790,12 +804,14 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
 		goto out_unlock;
 
-	while (src_addr < src_start + len) {
-		pmd_t dst_pmdval;
+	state.vma = dst_vma;
 
-		VM_WARN_ON_ONCE(dst_addr >= dst_start + len);
+	while (state.src_addr < src_start + len) {
+		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
+
+		pmd_t dst_pmdval;
 
-		dst_pmd = mm_alloc_pmd(dst_mm, dst_addr);
+		dst_pmd = mm_alloc_pmd(dst_mm, state.dst_addr);
 		if (unlikely(!dst_pmd)) {
 			err = -ENOMEM;
 			break;
@@ -827,34 +843,34 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
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
@@ -866,10 +882,10 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 
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
2.51.0


