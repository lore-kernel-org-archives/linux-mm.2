Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4DCFFCC056
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 17:18:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14FCD6B009D; Fri,  6 Mar 2026 12:18:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107EE6B009E; Fri,  6 Mar 2026 12:18:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B3D6B009F; Fri,  6 Mar 2026 12:18:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E483B6B009D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:18:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5ED5C23DC
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:18:53 +0000 (UTC)
X-FDA: 84516298146.11.D266D60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0105920013
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 17:18:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e0ECtBkC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772817532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9I7GcAyNMQ4h1nGDO3nrcx8C3Qmu+bCHtWHFR0YCues=;
	b=GzTg0On5pqxiS+IXQJUa+ykaczuQlarZQm/gcqcktigfcRQP/T4dVkIemrYHQoe3uDvPsR
	zxDMu5fbUUk0ZowY4O4ZMaILVJenMAI6P4wXXs7zCfi6c0qGZqCriO9Cnlb2+DcZTIE4rl
	voZ/dydhrz2s0ualu+OYK1R7rBGzkYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772817532; a=rsa-sha256;
	cv=none;
	b=fjzLBAf7hJzfGRFccreuN4XCv973VTANo+046Sy/YnBoOkqkTMJjOaMKytaVFtHoiZnI4C
	dnFd7YgXwknI1o3ZPglQCMbMoApfpeefxbW0ykIoZpfd3SXXgytpOdx31/qc3wicHO0/ST
	+lX4hu7D7fqHOeZcG/zSoAxkLWQ8UJM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e0ECtBkC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 325A2419A0;
	Fri,  6 Mar 2026 17:18:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5992AC4CEF7;
	Fri,  6 Mar 2026 17:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772817531;
	bh=G5arZbl8cQ1Z8+AqNUYSv0raYqzUJNHuE3AX6opuyHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e0ECtBkCqhwlPUhpp20EDW+OTbsO/AwZiJOU8EVYFYjbLEOyU/XGLaAJ7uTlhSiah
	 P8aV4/SPGl5vj+fQEn4d4QaUgyOY/3GUt2qQ4j2J4/5ygt1wuZJ1nH1U88SQ2VETvY
	 GGfEz46WwjatfHliclfeBvPhTpZyYow7bP9jvr5yGANcXBimwFy/o+ho67ia/OCRYr
	 v2AKW/h1tbBX4pmQYCaxLmMITsalTlShiLAHSmWCmqUAxYFat6eCslXF4NSDjm86A/
	 l8Yx5r1NPEasv72Jw2fTXxml9jJdYhvB7Xk8tq4oZj3CAf4W3iBrq2EHnRPJvZZMco
	 C4uhnR215Vu0g==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
Subject: [PATCH v2 04/15] userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
Date: Fri,  6 Mar 2026 19:18:04 +0200
Message-ID: <20260306171815.3160826-5-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260306171815.3160826-1-rppt@kernel.org>
References: <20260306171815.3160826-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0105920013
X-Stat-Signature: tgwrtjyjsk98kdmpqk815qiysdbgkp7n
X-Rspam-User: 
X-HE-Tag: 1772817531-477429
X-HE-Meta: U2FsdGVkX18xxQEr8T6/zE/yXD0nkAlHw1dDyL+WnUBaOvybt+efulXQoN1FcJXvpzuX2f1N8hf+/ZCk0QkLK9qytKkZjv49qHmEaJbUTbSIPoAfI04I//sXXNYMhhahR76qoc1q5V3nzAHEufpOYbcTJ9eM2M2Q7va7Xvx72KZSOTOSyHD8FkgzAb4M83U5bqUSJ30GrGRrtbeDzO6w+1lF4HAuUoc4ty9n9HaX1pX/WcUNt9zPrkMjb6UrcrFWQYVy/SnKxoxgETUNTkY5tXVG4i+Ybydq4op2ZFtBnDHA53sd/Xm0SmbecdBaXSvkUtFoR88a5ihAuJ4LT8Io4uTGhAAGF7AFgn+8iWd1BG67rb3ycF+5qav7KiqP9URHJBHUj2JEZe2czUwOx+9y/Lql7bT0I3QLZ8mseinsRCVG4X7ClYeZiBzB2UwCLHQzw7TXnhUPqhZshcUO9AFfb/wWAenzyzWuP2y/mGwcmooLC9cJBO0AFMDkpUKQyT/MuKGu+cFpanSBi7WfktvpM4N/gJPYcHjH7e0Mr1D5TDw1qVEwZCq2OpQiIVA8Eb/yF9jjTUTWTt78HUVkETiQt1sBAu/waVUlG2Gzz5zGTskXAtJlVQx9S5Noz6v2dBgp8Xg1nIyxi2PtOtnMv3nAOm5hsQghQ11BZE/aK5R06sAdTbMttaCILJq4cPb1P05Nsjalb8Tu4Zbpx2AwGNsTVRQ3KioUCyaqHeubugYQh3VSsx1VGAL/IciY0xYUCsLiQtY57WUJu/wgo2/WDmW+GKTWtddPDu/F5mnm6y2qse4UBgUZ/uLn+BIE0fmTAzp293Uboi3lUSnBocwaLwnIRRBPHtzUEqM+X9Fvqlf9IBUfjq4MFF9DOL5N8XHKn0t6DE2DcCaBlZ5LOXc5pzusbOX+zkFrZWtN7sSLXUEW6qusJ4anI3/7j8IARSueuZlWshkYgznlWiLr/5FtKGl
 u/HZTHvQ
 /1DQIfimcuqB2uoNQYz1DI2J2mzohoBFIVLAAEeiqPjPzjywHpL0+9uDBoUqO0N63mr4QrQ4cziEodHL/0lTMVkE/jyCsYFoX/j7+K/5rShAfdTCm0QimMwBvKDpsxD73xP5DgiDR4Am4wXUPFQxQzPvN+rOSfwaqaPvTH4eaS/tMgftP74n3Qa7zS4/tIpKg8ILJCkXXUBVWy25QRihmQeW4savYij0DFNzshE74qTLliwD3UWbILD/NpLGg1/9dNdE8H+2PKaKhF0IEJhuw5ETpJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Split the code that finds, locks and verifies VMA from mfill_atomic()
into a helper function.

This function will be used later during refactoring of
mfill_atomic_pte_copy().

Add a counterpart mfill_put_vma() helper that unlocks the VMA and
releases map_changing_lock.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 124 ++++++++++++++++++++++++++++-------------------
 1 file changed, 73 insertions(+), 51 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 224b55804f99..baff11e83101 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -157,6 +157,73 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
 }
 #endif
 
+static void mfill_put_vma(struct mfill_state *state)
+{
+	up_read(&state->ctx->map_changing_lock);
+	uffd_mfill_unlock(state->vma);
+	state->vma = NULL;
+}
+
+static int mfill_get_vma(struct mfill_state *state)
+{
+	struct userfaultfd_ctx *ctx = state->ctx;
+	uffd_flags_t flags = state->flags;
+	struct vm_area_struct *dst_vma;
+	int err;
+
+	/*
+	 * Make sure the vma is not shared, that the dst range is
+	 * both valid and fully within a single existing vma.
+	 */
+	dst_vma = uffd_mfill_lock(ctx->mm, state->dst_start, state->len);
+	if (IS_ERR(dst_vma))
+		return PTR_ERR(dst_vma);
+
+	/*
+	 * If memory mappings are changing because of non-cooperative
+	 * operation (e.g. mremap) running in parallel, bail out and
+	 * request the user to retry later
+	 */
+	down_read(&ctx->map_changing_lock);
+	err = -EAGAIN;
+	if (atomic_read(&ctx->mmap_changing))
+		goto out_unlock;
+
+	err = -EINVAL;
+
+	/*
+	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
+	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
+	 */
+	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
+	    dst_vma->vm_flags & VM_SHARED))
+		goto out_unlock;
+
+	/*
+	 * validate 'mode' now that we know the dst_vma: don't allow
+	 * a wrprotect copy if the userfaultfd didn't register as WP.
+	 */
+	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
+		goto out_unlock;
+
+	if (is_vm_hugetlb_page(dst_vma))
+		goto out;
+
+	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
+		goto out_unlock;
+	if (!vma_is_shmem(dst_vma) &&
+	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+		goto out_unlock;
+
+out:
+	state->vma = dst_vma;
+	return 0;
+
+out_unlock:
+	mfill_put_vma(state);
+	return err;
+}
+
 static pmd_t *mm_alloc_pmd(struct mm_struct *mm, unsigned long address)
 {
 	pgd_t *pgd;
@@ -768,8 +835,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		.src_addr = src_start,
 		.dst_addr = dst_start,
 	};
-	struct mm_struct *dst_mm = ctx->mm;
-	struct vm_area_struct *dst_vma;
 	long copied = 0;
 	ssize_t err;
 
@@ -784,57 +849,17 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 	VM_WARN_ON_ONCE(dst_start + len <= dst_start);
 
 retry:
-	/*
-	 * Make sure the vma is not shared, that the dst range is
-	 * both valid and fully within a single existing vma.
-	 */
-	dst_vma = uffd_mfill_lock(dst_mm, dst_start, len);
-	if (IS_ERR(dst_vma)) {
-		err = PTR_ERR(dst_vma);
+	err = mfill_get_vma(&state);
+	if (err)
 		goto out;
-	}
-
-	/*
-	 * If memory mappings are changing because of non-cooperative
-	 * operation (e.g. mremap) running in parallel, bail out and
-	 * request the user to retry later
-	 */
-	down_read(&ctx->map_changing_lock);
-	err = -EAGAIN;
-	if (atomic_read(&ctx->mmap_changing))
-		goto out_unlock;
-
-	err = -EINVAL;
-	/*
-	 * shmem_zero_setup is invoked in mmap for MAP_ANONYMOUS|MAP_SHARED but
-	 * it will overwrite vm_ops, so vma_is_anonymous must return false.
-	 */
-	if (WARN_ON_ONCE(vma_is_anonymous(dst_vma) &&
-	    dst_vma->vm_flags & VM_SHARED))
-		goto out_unlock;
-
-	/*
-	 * validate 'mode' now that we know the dst_vma: don't allow
-	 * a wrprotect copy if the userfaultfd didn't register as WP.
-	 */
-	if ((flags & MFILL_ATOMIC_WP) && !(dst_vma->vm_flags & VM_UFFD_WP))
-		goto out_unlock;
 
 	/*
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
-	if (is_vm_hugetlb_page(dst_vma))
-		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
+	if (is_vm_hugetlb_page(state.vma))
+		return  mfill_atomic_hugetlb(ctx, state.vma, dst_start,
 					     src_start, len, flags);
 
-	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
-		goto out_unlock;
-	if (!vma_is_shmem(dst_vma) &&
-	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
-		goto out_unlock;
-
-	state.vma = dst_vma;
-
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
@@ -853,8 +878,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		if (unlikely(err == -ENOENT)) {
 			void *kaddr;
 
-			up_read(&ctx->map_changing_lock);
-			uffd_mfill_unlock(state.vma);
+			mfill_put_vma(&state);
 			VM_WARN_ON_ONCE(!state.folio);
 
 			kaddr = kmap_local_folio(state.folio, 0);
@@ -883,9 +907,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 			break;
 	}
 
-out_unlock:
-	up_read(&ctx->map_changing_lock);
-	uffd_mfill_unlock(state.vma);
+	mfill_put_vma(&state);
 out:
 	if (state.folio)
 		folio_put(state.folio);
-- 
2.51.0


