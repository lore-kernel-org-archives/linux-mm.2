Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D001D2FEDB
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 19:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3236B0092; Tue, 27 Jan 2026 14:30:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9A606B0093; Tue, 27 Jan 2026 14:30:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9B06B0095; Tue, 27 Jan 2026 14:30:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB0C66B0092
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:30:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44A13C18A9
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:15 +0000 (UTC)
X-FDA: 84378734790.13.41071F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 864B420018
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 19:30:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOrrWt80;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769542213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HqniRApoyr7i8EtFujgm+yFxKExuGHlYqgHEdq8qYs=;
	b=J+vtb70sTT0IMvSdlPZw6inwTD+GySVgW/NFZI/6N/0Bo6BA6JPmIHnsL7E73OyTcwiW5G
	FfgMhf/6XEw3Mn6MjqmCaLS6jGLj9HsikwLR+SMrDQNFsi0rs9hkaSo1GqF2C1TbCDLQXW
	4ZJ1esDxQsZrKedz88iLFfc39ZG6fSU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UOrrWt80;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769542213; a=rsa-sha256;
	cv=none;
	b=RPbxviU4fztJId8pCOQLaCB3q7dgKkkdomjxp7fM2byLupEYVDfhishV44/EWhP5nZWRHr
	57vNb1s49hLp1IJMtTY2lTwWVX0ZBvS37Hn09GetAEp3YRFkt4RPn3fjli5gX2yZX7sYMW
	dQW1AgTkS1+5AUEJxuuYGfpb4o7lMRs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8944541AAA;
	Tue, 27 Jan 2026 19:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA799C116C6;
	Tue, 27 Jan 2026 19:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769542212;
	bh=lY9tdKAS4lHCu99XKdeK7IKZ185P9DUlwH987ofAD1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOrrWt80qHGsBbSId56SPZ2zTVBoHejq4lV9GhdtO0i/h9+oXRhpBpZjjpsHTquxK
	 KxlhPjyDP1gxoJM8eetOG2X0B5fumAhom14BLpMPVC5J5x4AJBfZn+HfJ+xSiixW5Y
	 FHTdUyunbnOsgaZOPVW1INzWOS2dA2eOrqvPsgk/NBXPpLjxdDJGfWHSnHhA8zgCXS
	 JnAo32lUYG584W4yo/cBR/QgTdNFV3Uho+5BTiwLhpx0d0zByhvHzhSlVatYmx/jXf
	 Q7keJpSBv6gyha/q1XD23w2/sBKm7t6gMtII9/leccGU4WxMkajYD8iJbytYFiIiWx
	 v4qTH/OX9uIFQ==
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
Subject: [PATCH RFC 04/17] userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
Date: Tue, 27 Jan 2026 21:29:23 +0200
Message-ID: <20260127192936.1250096-5-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260127192936.1250096-1-rppt@kernel.org>
References: <20260127192936.1250096-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 864B420018
X-Stat-Signature: ggwfnjegcci4fzr48zc1p8ids7mitc64
X-Rspam-User: 
X-HE-Tag: 1769542213-520059
X-HE-Meta: U2FsdGVkX1/a1blf9dVdTRxry0DKLjTkWNSOs2SKMVFc+AONyyzcKloG3QWhtnZ0mhWtzsUS8E+BNT0upKpk5sNc7wu6UTTwKS5X+HJ+Dsgx9iilaUsot50xs5fo39x6rYSlfttrO8jxQWC13F+DOQNQrwEx12Kv6LclSRu9MaCgaOG9xdJWQ9m4r/yuiptoSCad6TKoikdyD0PpMqNA8PGEKryu8qTLLTHPL0P4Ukjt8gxB8TqdXDqmulI8kVg4sUurK4RNFEbmuNsicKE9PG6az0ppvsm6IXfrm/QsEhRcqNC2MXh4m0CEKlMt0tKO18outlq4AvyWtctj6Z+wDjB5Ton74TdfJyzXaWRama2p6msOfZtLKofQKRYzNrTqbaXPVDuqKG+IVzO0XJARTof8lDKgz0288FsrzL4l/9Zvfn4KxFlOBHJ6974b000XNJiotn4vUc8vDhcNEIzfTo6c/MrSWy9/ufrBziB6Bw4ykt2RIplXM/yiufS8besZddk/pFEp5fbKQKHjZSDCd19TGMj1sGo9Z4TnQKZLz6H0uRGd2f4adl8yJBmgSckHQv4Nj0Hbm+M0YltQa5nQ4RWzlujNEyUyJoJByxWkFgm1iOgjMz1OLjpDrAxuw0V/16sHSNngM/NkIEPw/12GuHQyO0JItxrWX8n/DYBNpy2HuVSQgIZjDQwxD+zfdDAafP4xLhchNwCrUeLZQjS7hNoolrKIB7/Z0DRavaeJijSR0ysgklZA3mPlvZNB+ih/IEaXS6uNKNJZY7TKkaVY/wCZkvA/BrpoEbqHUSRDPhKfGIFw5TcRtRKQ0SJgeLiMsVtQHPNN9zxAFabqcbsaheKTW5WsqXJHzcWQtYrIiMPQQGMrsYgpZiktqZcoldkBarDYqz8kDR5H9+i4MxqoufWwTDF1PmJhd+jBNtZvsQYs7E/6XJNKU6GAxtSBRhsrujYS65/Q6MPXL4YxwBB
 cQQTt+XZ
 4hFEY7F62NEYOsECMomVQvggJqiHdmkfhVTbu6cpqa5RMGzT+hgnyMFiq1bz3To3X7Yax6m0RLysAqRPaZZ8dj8xYP3O5uRIMVmqYbR/oOEjzkb54NJm5UfEOGsNBle7M57m4cs/Yups4rDCBwH/PmCYye2R0wXVNeK9I7uOAo1bdDzm6GH5NeP60uGMEAZAHVvyMsgikxKOUcAtAsrHV8UdQS+6q2CQ3bEAT6nGgmbaEI/XK3/31Z3K10A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 9dd285b13f3b..45d8f04aaf4f 100644
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


