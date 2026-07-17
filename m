Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1F40C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095B26B00AE; Fri, 17 Jul 2026 13:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047246B00B3; Fri, 17 Jul 2026 13:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC6C6B00B6; Fri, 17 Jul 2026 13:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9BD6B00AE
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:01:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A12FA01EF
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:13 +0000 (UTC)
X-FDA: 84998884026.29.AD6E703
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5A10AA0017
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YwGl7lBV;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784307671;
	b=pAF0axUZx71KCtdLiiXRT1UImScBf4TS2xPYWqDevApPi9bQjUZ/NHawABlP72p67sj4FE
	3gACMt1VFAXT3C+zNlWDtE1SDP8l5Hqcgg1+v6a93srccV1LiGX3CUUXkvRC8WnRjWeHgq
	VAKPO0N8jo7PzGBlSKcEZX4Nhqt7pOk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YwGl7lBV;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784307671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ycByTKs8w8BOZ5CAU6T2CUK+Z0yZNJ7KHC7qxhBjQcQ=;
	b=NgBbucOx7y+wtu083oey3N1ESno82DKx5fIbLO28H5iQL5VI8UcOaqtI1QqebbhlwTfQTZ
	qB1HV8oB+ZFateBjcbIdQXzKM44ziPi9rdVG3SfJ+LBKHt6uae+2itVIOiVvdceFYdJJ+j
	1gsSbOXQ+jpe/xFasiitzgnqoTjCueM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ycByTKs8w8BOZ5CAU6T2CUK+Z0yZNJ7KHC7qxhBjQcQ=; b=YwGl7lBV2zuCG+dru6ABU02zCv
	kThElr5XZ7lupziDRBBDtKp7AZtHCZO3yQz7E7joKYB55GnFv90sh2j3JFGBsZhA/nJyRhMrFq9Tj
	dFmUuGqmU+SKzII0pvT5SZa7ltrrHB2ZYeTN8zYjs9zp9gKHDCY7LaXjprvTnQqVnfkyEK4d4ojMD
	yM7dNPxeHvaGSfvxHCl1x8B6bSEQpZhuTScC6OVNSpG67THBOXvra38Jj/BkI+LRCW8Tw3o1rcyGZ
	XT+RzyFY33EzAHmLjZOYCGNrJwG+UWJ9U3qkDiI02GbsgsNJffpllUBuIk/ZBur3l0a3qjwQWtggj
	jofxVLOQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wklvS-000000001w4-0WyJ;
	Fri, 17 Jul 2026 13:00:38 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: [PATCH RFC v3 4/6] mm/gup: add get_user_page_vma() to fault in a page under a held lock
Date: Fri, 17 Jul 2026 13:00:34 -0400
Message-ID: <20260717170036.743149-5-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260717170036.743149-1-riel@surriel.com>
References: <20260717170036.743149-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A10AA0017
X-Stat-Signature: pgmcxtrq3am4ujmj3a8cuyayubasrwwg
X-HE-Tag: 1784307670-854698
X-HE-Meta: U2FsdGVkX1/Eun2Tko+auVPJCbZ9MSU3u6P+ac4AJHmZNIj71D5VTAH2hSkSzR3zwBRXRMlMorJ/FY/GJ6Ia92KcuzKG7iuB9PEGxf0CpjUC+5bTqU/yXxcgN3bS1KM9Pp5RpycTeDQ5KOHKYz3bKtZ8MZPbCLBKZVjX9/YgEXIBSP/fHJtleDhCPugqpLsizudttx0FDrmp0Z1u/VPJwvMHVxVOm8OO7r5n3MHIuvLRdZ9uEQZCuYJ8UrTZkAu4uZejDv7sDvQStnb0qPpSqKBIlOacoNhOtuui5NwRygoAytHwpBu64MgFG6Z2VmnylAxrfgwuVOjbeVhegTwyZxHurF60rB0dMvZY9rr1hZIbNsAf7yrhkDhnlmWrpPRW8UDs3c2+gbkTjCUqdCslsdOid/ID7xDRNUNitBm+ykNpFDRPkX1OJCVUeydfwt6RXjfbDNwk8edJlTl+hPBUB3iXTCWR35UWL3twkRz9SsQ+B9qyO4V3ZsAezNahodze3TvjtripIQHsGp01K0vP9fDs5auoo2QcD4pN4Olxv+cG+L45wjuSzvLl6mDMvRbbG5gFXU3v3TiF7PL94a7osUVgW7H66V6LMGvzL3cch5T8tCWcvSqiWSRCZb8kke92SDGnVlqVzGy1e/iz8RVerZmn8sa1Dg5T3eFvIT1Ug40AJrD+VMx8RGMosYea75C6qHSnb1r2Fkk5qHXtjVbq6FK+rmpletmnGS38/bkqg+1kFN8df93dY0kA8/qaeMeXGpCV6DwlwOE3hOnX5+iNBza6bCdMFd2luiTC/l2NXovWsK6oX1WPgx7QYBKt3LfJzl9C8yOki8xiYqzWVc6atvuwUdxSIRR4t0g3IC85Wg8RLpy51rfvbBL0NTBU6Qtlyi411Lzz8Z8OsnZr9YRujBfq7t2mPwt8VW4ZVR3gcBywtacWeYZCm+6oMmjLW5BG7GAgd+l6HT8qqW9ARFI
 A+zxanNe
 sKzZKpzXXzZgu9fLDyk4EzezYGJRNEqY9aRQggpxtR4Yq2t2wqu5LMLq25ZFeuOgWVrHfyctUQylpVYHq9DTUJKO96Q5vPrMA4AssJD0AZZ4mdAdiTCFjqYmAwFKHAzgMkAifynfYpAnux1d5bLLT4oxwn1ON9a4pJQezPZB1ZQe+UgclxvqW7R5I+li3L5pci24ia99rPV6maB5sFxFhzTynLn+4jxEL8wdxTj7TqFhSEttcADAppYzdQsEhho3A6pV/AXN9zhrGSTxMySyf/N7PmzvbHUok3hrGHwAoa4wFif/RXLUst86DJsqMjzqktvCq
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
only the mmap caller records the dropped lock in *locked. A
VM_FAULT_ERROR that decodes to no errno warns and returns -EFAULT
rather than BUG(), since the mmap-lock retry produces the definitive
result.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c      | 154 +++++++++++++++++++++++++++++++++++++++++++-------
 mm/internal.h |   6 +-
 2 files changed, 139 insertions(+), 21 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0692119b7904..69b834a71708 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1082,7 +1082,13 @@ static int get_gate_page(struct mm_struct *mm, unsigned long address,
 /*
  * mmap_lock must be held on entry.  If @flags has FOLL_UNLOCKABLE but not
  * FOLL_NOWAIT, the mmap_lock may be released.  If it is, *@locked will be set
- * to 0 and -EBUSY returned.
+ * to 0 and -EAGAIN returned.
+ *
+ * The return value does not depend on the lock type: a fault that made
+ * progress but needs a retry (VM_FAULT_RETRY / VM_FAULT_COMPLETED) is reported
+ * as -EAGAIN for both the mmap lock and the per-VMA lock (FOLL_VMA_LOCK). Only
+ * the *@locked side effect is lock-type specific, as the per-VMA lock path has
+ * no unlockable mmap_lock to drop.
  */
 static int faultin_page(struct vm_area_struct *vma,
 		unsigned long address, unsigned int flags, bool unshare,
@@ -1097,6 +1103,8 @@ static int faultin_page(struct vm_area_struct *vma,
 		fault_flags |= FAULT_FLAG_WRITE;
 	if (flags & FOLL_REMOTE)
 		fault_flags |= FAULT_FLAG_REMOTE;
+	if (flags & FOLL_VMA_LOCK)
+		fault_flags |= FAULT_FLAG_VMA_LOCK;
 	if (flags & FOLL_UNLOCKABLE) {
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
 		/*
@@ -1125,41 +1133,147 @@ static int faultin_page(struct vm_area_struct *vma,
 
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
+	 * Validate the VMA up front, like __get_user_pages(). A VM_IO/VM_PFNMAP
+	 * VMA is not rejected outright: it can hold COWed pages that have a
+	 * struct page, so let follow_page_mask() look for one, and treat only
+	 * its struct-page-less PFNs as unreachable. Any other rejection
+	 * (secretmem, bad permissions, ...) is final.
+	 */
+	ret = check_vma_flags(vma, gup_flags);
+	if (ret && !(vma->vm_flags & (VM_IO | VM_PFNMAP)))
+		goto fail;
+	pfnmap = ret;
+
+	for (;;) {
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			goto fail;
+		}
+		cond_resched();
+
+		page = follow_page_mask(vma, addr,
+					gup_flags | FOLL_TOUCH | FOLL_GET,
+					&page_mask);
+		if (!IS_ERR_OR_NULL(page))
+			return page;
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
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..0899a37907c1 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1595,6 +1595,8 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
  */
 int __must_check try_grab_folio(struct folio *folio, int refs,
 				unsigned int flags);
+struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long addr,
+			       unsigned int gup_flags);
 
 /*
  * mm/huge_memory.c
@@ -1641,11 +1643,13 @@ enum {
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


