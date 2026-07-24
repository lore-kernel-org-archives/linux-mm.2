Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F881C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4026B00A3; Fri, 24 Jul 2026 18:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A646B00A5; Fri, 24 Jul 2026 18:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8CF6B00A6; Fri, 24 Jul 2026 18:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 36F356B00A3
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B08D91A01E4
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:23 +0000 (UTC)
X-FDA: 85025115126.23.1134C23
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2B3CD40009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ablmeSFS;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hHdI4LWlDC8ULGYHra6LN9uCKn7OJXzJpyk4YtJG+A=;
	b=zfB9uuHdBxE0fOAXbeAGDFMGXxkcu6GpVDxWFibmPV780+FTF8KQ4tG1c1jA+OrCCCH/ib
	WA+dgRsuun7+QRnVRVkA6WZJ5eSowgFD/M+0yVQohooy6n3/oXdZKGU659co2cHGLRFFp7
	C1oIe3xF7DvkDy4lKWDENiKCgvGQnL8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ablmeSFS;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932222;
	b=lydKLof8RHDXkP2vhDmp79ujfulmdTT7qKy+vB+99tQ6+1XiBJaxk4jmnzKUVlliTFGqmD
	ctFMOCbM8PGLcONUpDzO7YtDQRu/42wHO+diUqWU4dwp9zcLne32B8uOJ5KlKn/g9Nvgk4
	id2klU7b7H7QZ7gjuURwy9avXHTt2E0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+hHdI4LWlDC8ULGYHra6LN9uCKn7OJXzJpyk4YtJG+A=; b=ablmeSFS7MEeH3jzONlP/3XcqT
	2eSf4O1EWC2jWrOLkzzY3D4oXJ+MehzOMZ3Zy4ejrUQAmaG0N/LzqSyZoOyL3oYuFiYDNBCE4bw5u
	e0yV5uIKRfVNjiDca92SDcRWItCQyf73coJrAQhqL9YlyFoU738gA6+9Pp06GQ8TIxZZFWKJSDK1c
	xeSiK9+JNCLLeXE1ItuOhOM3CGJfDDzMRUo5dI+i0s1i/I6lL+xmkKwvvVxdHGUKoawSdopc95wWU
	XkDLRq2gKGKBGP24gK11aSoE/+maegVNFUhPw6mTOJzOrwSKKnaUfDLxcSI2YgWWAeLy2YbrG+6MI
	5lS/lSJQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-1Q3T;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH RFC v4 05/12] mm/gup: add get_user_page_vma() to fault in a page under a held lock
Date: Fri, 24 Jul 2026 18:29:27 -0400
Message-ID: <20260724222934.1463812-6-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2B3CD40009
X-Stat-Signature: jodo5c5psksj96gr677c1c4up59r8srn
X-HE-Tag: 1784932222-138436
X-HE-Meta: U2FsdGVkX1+U5RIp1rdZ6xsK/NH2SL7xEc4NLHU7C45ANO97LpqeY4OQ9Jpgyr7HqsR/wj+Vtpvj9qWpbQfp19GZ6J3QJ348GdTU6ISunRIRq2muGJM47kUSqfcu4XeAH1lk/4raTxhHvlx1YkUwKzpYG56dK0cA2KeIFqF5IgGA7UtP28B1UOF60zwW7pOP+pbYaGPMWOxsGhEqJdS/rf0ydLUqxM8aXL5Rj10FEcCZe6+C6TO5qfSWGUSTeBqwYE4TmxRbUyZLkl4oTvh6j1Oe4poVjReW9Zj4xj4VzTdBoNtMSgHqodotgaq0VCE7t+KL09dHtZSOszAK8wS9WZJciKEMzQUjizHv0F7eqcxh8/n+l2HMm9m+tde3IB/uD/wZvVztD1fwwg5ogSeN/86sEj/WA8VurQNg8Lcif13vQCvm1bskMDmpN9YxLcYtkRi1gbNvFpQ96wkjaxORQyKlVKWsKjxQDky4tvG43I8lfKNNcFBISxhIGdpVHOdyK3/Mzvly+HU9Sdgsc8DTUNpVAPYgENcJENL4/SC2mB+kExhVz86MLNULuP/FxVyQk57bRdY2+jGL2vcEM4VM13VfwGyVdCkD1QSh3BazMBCz2aGFSANxKvLYWQrjLf5yzPELAOqHoO/527illgdNdwgoN6J6FWlu0Ilh/WJDyQ7iSfT6hxbj3IOxPlWdBObtFaJ4jdYXS88x9yDqeO5iNuArTghLIqM25QiKn09XeYREhrXGYF5fd3ADSuAShoCvgRQl/x2l/eLDSN+3VMGIboDXljgLZW2it4fs6k8BPF1ZBpp86nFZOmbetI22gHa8UmSvgbDKGXIkdAVrOVXGYZr8V2SL2UoJpjep8nDB8nna/e75Q0L1FHYWygWboloviZdLJXLp4GG3fYXpW30BMp5LCyJ4NE6i9QgRMnmsQdWtIREpBGGAAr/PaopweIod7cIzl2rtLW/cJ0kcmFh
 57CiXN7X
 lg7TEuP5z/NPH5jnwLhrv+8yBlbJIe0cDEBkLDK9oVXeqSbPBq/UWNq21gKQhzrqswI/wTOxUwLLrANlVcopRcu4rQg0ABChR3xJ61J36reSZP0L4llJVmc5ZmzgN89Yglwk/iPLSW966oWcnQDRKtYL6iAfUguBQun0g4w6xrgphrA3B+Q2TSijRGT0Nk3Bk0xmlaKq4eDHd6rgiYOyJ9q97x6isl70KtORynr6q5Fj11v/kdIcwELWGuROYH9ceEu8aNw6nBJI+cBU6804kti0rk3ucrNZyUMgRNspDTWsAoa92n8OCblwJn0PrwQcr3sQY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__access_remote_vm() needs a single page from a VMA it has already
looked up and locked, faulting it in when necessary, under either the
mmap lock or the per-VMA lock. get_user_pages_remote() does not fit: it
hard codes the mmap lock and re-looks-up the VMA, neither of which is
wanted here.

Add get_user_page_vma(), a simplified __get_user_pages() that walks the
page tables with follow_page_mask(), faults a missing page in with
faultin_page(), and on success returns it with a reference and the
caller's lock still held. Like __get_user_pages() it runs
check_vma_flags(), so callers need not pre-check the VMA.

A VM_IO/VM_PFNMAP VMA is the exception to that check: it can still hold
COWed pages that have a struct page, so follow_page_mask() is allowed to
look for one. Memory with no struct page -- a raw PFN, or a present PFN
reported as -EEXIST -- is returned as -EFAULT, so the caller can reach it
through vma->vm_ops->access().

The caller sets FOLL_VMA_LOCK when it holds the per-VMA lock rather than
the mmap lock, which reaches the fault code as FAULT_FLAG_VMA_LOCK.

Anything that cannot complete under the per-VMA lock -- a dropped fault,
a userfaultfd VMA (uffd assumes current is the faulting task), a hard
error, or ->access() memory -- releases the lock and returns -EAGAIN,
so the caller retries under the mmap lock.

faultin_page() reports these retries as -EAGAIN for both lock types;
only the mmap caller records the dropped lock in *locked.

A VM_FAULT_ERROR decoding to no errno now returns -EFAULT instead of
BUG(), warning under CONFIG_DEBUG_VM. This relaxes the same case on the
existing __get_user_pages() path too.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c      | 176 +++++++++++++++++++++++++++++++++++++++++++-------
 mm/internal.h |   8 ++-
 2 files changed, 159 insertions(+), 25 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index dcece7b5253c..cb7245b7542f 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1080,9 +1080,16 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
 }
 
 /*
- * mmap_lock must be held on entry.  If @flags has FOLL_UNLOCKABLE but not
- * FOLL_NOWAIT, the mmap_lock may be released.  If it is, *@locked will be set
- * to 0 and -EBUSY returned.
+ * The caller holds either the mmap lock, or the per-VMA lock (with
+ * FOLL_VMA_LOCK), on entry. If @flags has FOLL_UNLOCKABLE but not FOLL_NOWAIT,
+ * the mmap_lock may be released. If it is, *@locked will be set to 0 and
+ * -EAGAIN returned.
+ *
+ * The return value does not depend on the lock type: a fault that made
+ * progress but needs a retry (VM_FAULT_RETRY / VM_FAULT_COMPLETED) is reported
+ * as -EAGAIN for both the mmap lock and the per-VMA lock (FOLL_VMA_LOCK). Only
+ * the *@locked side effect is lock-type specific, as the per-VMA lock path has
+ * no unlockable mmap_lock to drop.
  */
 static int faultin_page(struct vm_area_struct *vma,
 		unsigned long address, unsigned int flags, bool unshare,
@@ -1097,6 +1104,8 @@ static int faultin_page(struct vm_area_struct *vma,
 		fault_flags |= FAULT_FLAG_WRITE;
 	if (flags & FOLL_REMOTE)
 		fault_flags |= FAULT_FLAG_REMOTE;
+	if (flags & FOLL_VMA_LOCK)
+		fault_flags |= FAULT_FLAG_VMA_LOCK;
 	if (flags & FOLL_UNLOCKABLE) {
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 		/*
@@ -1125,41 +1134,160 @@ static int faultin_page(struct vm_area_struct *vma,
 
 	ret = handle_mm_fault(vma, address, fault_flags, NULL);
 
+	/*
+	 * A fully completed fault (VM_FAULT_COMPLETED) or one that needs a retry
+	 * (VM_FAULT_RETRY) has released the lock it was holding. Report both as
+	 * -EAGAIN so the caller retries: the mmap lock caller retakes it here,
+	 * the per-VMA lock caller (FOLL_VMA_LOCK) falls back to the mmap lock.
+	 *
+	 * Dropping the mmap lock is recorded in *@locked. There is no such lock
+	 * to drop under the per-VMA lock, where @locked is not used, so leave it
+	 * alone in that case.
+	 */
 	if (ret & VM_FAULT_COMPLETED) {
-		/*
-		 * With FAULT_FLAG_RETRY_NOWAIT we'll never release the
-		 * mmap lock in the page fault handler. Sanity check this.
-		 */
-		WARN_ON_ONCE(fault_flags & FAULT_FLAG_RETRY_NOWAIT);
-		*locked = 0;
-
-		/*
-		 * We should do the same as VM_FAULT_RETRY, but let's not
-		 * return -EBUSY since that's not reflecting the reality of
-		 * what has happened - we've just fully completed a page
-		 * fault, with the mmap lock released.  Use -EAGAIN to show
-		 * that we want to take the mmap lock _again_.
-		 */
+		if (!(flags & FOLL_VMA_LOCK)) {
+			/*
+			 * With FAULT_FLAG_RETRY_NOWAIT we'll never release the
+			 * mmap lock in the page fault handler. Sanity check this.
+			 */
+			WARN_ON_ONCE(fault_flags & FAULT_FLAG_RETRY_NOWAIT);
+			*locked = 0;
+		}
 		return -EAGAIN;
 	}
 
 	if (ret & VM_FAULT_ERROR) {
 		int err = vm_fault_to_errno(ret, flags);
 
-		if (err)
-			return err;
-		BUG();
+		/*
+		 * VM_FAULT_ERROR always decodes to an errno; a zero here would
+		 * mean handle_mm_fault() returned an unexpected combination.
+		 * Report -EFAULT rather than crash: under the per-VMA lock the
+		 * mmap lock retry produces the definitive result.
+		 */
+		VM_WARN_ON_ONCE(!err);
+		return err ? err : -EFAULT;
 	}
 
 	if (ret & VM_FAULT_RETRY) {
-		if (!(fault_flags & FAULT_FLAG_RETRY_NOWAIT))
+		if (!(flags & FOLL_VMA_LOCK) &&
+		    !(fault_flags & FAULT_FLAG_RETRY_NOWAIT))
 			*locked = 0;
-		return -EBUSY;
+		return -EAGAIN;
 	}
 
 	return 0;
 }
 
+/*
+ * get_user_page_vma - get one page from @vma, whose lock the caller already
+ * holds: the mmap lock, or (with FOLL_VMA_LOCK) the per-VMA lock. Walks the
+ * page tables, faulting the page in if needed, and on success returns it with
+ * a reference and the lock still held.
+ *
+ * Runs check_vma_flags() like __get_user_pages(), so callers need not pre-check
+ * the VMA; most rejections are returned as their error. A VM_IO/VM_PFNMAP VMA
+ * is the exception: a COWed page with a struct page is returned, while a raw
+ * PFN has none and yields -EFAULT, to be reached via vma->vm_ops->access().
+ *
+ * Under FOLL_VMA_LOCK, anything that cannot be finished under the per-VMA lock
+ * (a dropped fault, userfaultfd, a hard error, or ->access() memory) releases
+ * the lock and returns -EAGAIN, so the caller retries under the mmap lock.
+ */
+struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long addr,
+			       unsigned int gup_flags)
+{
+	bool vma_locked = gup_flags & FOLL_VMA_LOCK;
+	unsigned long page_mask;
+	struct page *page;
+	int locked = 1;
+	bool pfnmap;
+	int ret;
+
+	/*
+	 * Two lock modes are supported: the mmap lock, with neither flag, or
+	 * the per-VMA lock, with both FOLL_VMA_LOCK and FOLL_UNLOCKABLE. An
+	 * unlockable mmap fault would drop the lock and report it in *locked,
+	 * which this function does not relay, so reject a lone flag.
+	 */
+	VM_WARN_ON_ONCE(!(gup_flags & FOLL_VMA_LOCK) != !(gup_flags & FOLL_UNLOCKABLE));
+
+	/*
+	 * Validate the VMA up front, like __get_user_pages(). A VM_IO/VM_PFNMAP
+	 * VMA is not rejected outright: it can hold COWed pages that have a
+	 * struct page; let follow_page_mask() look for them, and treat only
+	 * its struct-page-less PFNs as unreachable. Other rejections
+	 * (secretmem, permissions, etc) result in immediate failure.
+	 */
+	ret = check_vma_flags(vma, gup_flags, VM_IO | VM_PFNMAP);
+	if (ret)
+		goto fail;
+	pfnmap = vma->vm_flags & (VM_IO | VM_PFNMAP);
+
+	for (;;) {
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			goto fail;
+		}
+		cond_resched();
+
+		/* follow_page_mask() requires @page_mask; it is unused here. */
+		page = follow_page_mask(vma, addr,
+					gup_flags | FOLL_TOUCH | FOLL_GET,
+					&page_mask);
+		if (!IS_ERR_OR_NULL(page)) {
+			/* Match __get_user_pages(): flush for VIVT/aliasing caches. */
+			flush_anon_page(vma, page, addr);
+			flush_dcache_page(page);
+			return page;
+		}
+
+		/*
+		 * No struct page: a raw PFN of a VM_IO/VM_PFNMAP VMA, whether
+		 * seen by the up-front check (@pfnmap) or reported as -EEXIST
+		 * for a present PFN. Return -EFAULT so the caller reaches it
+		 * through vma->vm_ops->access().
+		 */
+		if (pfnmap || PTR_ERR(page) == -EEXIST) {
+			ret = -EFAULT;
+			goto fail;
+		}
+		/* A hard error from the walk itself. */
+		if (page && PTR_ERR(page) != -EMLINK) {
+			ret = PTR_ERR(page);
+			goto fail;
+		}
+
+		/*
+		 * The page is not present, or needs unsharing. A remote fault
+		 * under the per-VMA lock cannot deliver userfaultfd (which
+		 * assumes current is the faulting task), so fall back for those.
+		 */
+		if (vma_locked && userfaultfd_armed(vma)) {
+			ret = -EAGAIN;
+			goto fail;
+		}
+		ret = faultin_page(vma, addr, gup_flags | FOLL_REMOTE | FOLL_GET,
+				   PTR_ERR(page) == -EMLINK, &locked);
+		if (ret == -EAGAIN)
+			return ERR_PTR(-EAGAIN);	/* fault released the per-VMA lock */
+		if (ret)
+			goto fail;
+	}
+
+fail:
+	/*
+	 * Under the per-VMA lock the caller cannot reach ->access() or act on a
+	 * hard error (both need the mmap lock), so release the lock and have it
+	 * retry there; the mmap-lock pass produces the definitive error.
+	 */
+	if (vma_locked) {
+		vma_end_read(vma);
+		return ERR_PTR(-EAGAIN);
+	}
+	return ERR_PTR(ret);
+}
+
 /*
  * Writing to file-backed mappings which require folio dirty tracking using GUP
  * is a fundamentally broken operation, as kernel write access to GUP mappings
@@ -1197,8 +1325,8 @@ static bool writable_file_mapping_allowed(struct vm_area_struct *vma,
 	return !vma_needs_dirty_tracking(vma);
 }
 
-static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags,
-			   vm_flags_t ignore_flags)
+int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags,
+		    vm_flags_t ignore_flags)
 {
 	vm_flags_t vm_flags = vma->vm_flags;
 	int write = (gup_flags & FOLL_WRITE);
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..706f7f08fd18 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1595,6 +1595,10 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
  */
 int __must_check try_grab_folio(struct folio *folio, int refs,
 				unsigned int flags);
+int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags,
+		    vm_flags_t ignore_flags);
+struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long addr,
+			       unsigned int gup_flags);
 
 /*
  * mm/huge_memory.c
@@ -1641,11 +1645,13 @@ enum {
 	FOLL_UNLOCKABLE = 1 << 21,
 	/* VMA lookup+checks compatible with MADV_POPULATE_(READ|WRITE) */
 	FOLL_MADV_POPULATE = 1 << 22,
+	/* caller holds the per-VMA lock, not the mmap lock */
+	FOLL_VMA_LOCK = 1 << 23,
 };
 
 #define INTERNAL_GUP_FLAGS (FOLL_TOUCH | FOLL_TRIED | FOLL_REMOTE | FOLL_PIN | \
 			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE | \
-			    FOLL_MADV_POPULATE)
+			    FOLL_MADV_POPULATE | FOLL_VMA_LOCK)
 
 /*
  * Indicates for which pages that are write-protected in the page table,
-- 
2.53.0-Meta


