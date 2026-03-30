Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63799FB3CF5
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 10:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8CF6B0099; Mon, 30 Mar 2026 06:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88FA6B009B; Mon, 30 Mar 2026 06:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B783D6B009D; Mon, 30 Mar 2026 06:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A5FF16B0099
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 06:11:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B5FD140622
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:11:56 +0000 (UTC)
X-FDA: 84602313432.23.A1868E7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A4D38C0011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:11:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J9PBouR4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774865514; a=rsa-sha256;
	cv=none;
	b=QpyJshevf6w+scH0da7/uFtprar0xJACSHGHjU/GZePabaBokgObVaNHaa0Tv34VLqoyEL
	3HFwT+O10vh2PGc5cb7S+JXPjHanTFVzyXMPcRSRHOYf0Z5bYGnrtahpir1W+BAytvMsGg
	LnugtVpOHN1tvDzlTBM69lKtKuabjKE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J9PBouR4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774865514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g8J5DtXE4RT5GftJtmwhtOLDl4tKcn/SdloB4AIThyg=;
	b=1utBLlUTtZGww+dVhN1Ag1mJhqQmVQS/eqm4YtBilM2OrlNM7Zc27yNDwkas9/jMNZlmOS
	M+/uOsZQKsXA0tnSNAjm9vHfWy+S3SH/WPsmf2AxAUt18Tz4dzowy9MR0LLdVPeWB6gI6l
	MwNQU68H7jmFXiAP/GEnF1l6Vy+tfvo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1FBAF6011F;
	Mon, 30 Mar 2026 10:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9232FC2BCB5;
	Mon, 30 Mar 2026 10:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774865513;
	bh=ynjTmCe+1IWEv5uzQ9YDrK1M2CISmsrzcaIqVGmX5v0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9PBouR46yBSGMp/xczSDwNBSz01ILMMSUj54LcWOXbIqNAWCWDiQOgfDL2mOpJeX
	 jWmG3aMQSTYTPDkRqV982sQciqG5TEdyiaeAEcRpBwctsK1vNMR8kLvjmKH+OTaMh8
	 ZXPPiEZPMEfVIIMFDVu/qYHj/2MLKn7dwA3DEdchKRyf2i77SsBedtIGw2xcPwO4fw
	 YgMb4eBrNILU5qOsa8Au+P2E4ooFL2zy8mIGhp+S7Anm6rAiRfKpcXiCw8L/gYdBge
	 Ata/+5uKD1wBFajLa+AtZtMH42pL7iE6FbyBqGi+1qfJDSK3Z0NwCVZnovq4SmH0T7
	 KWc50FhDtW59A==
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
Subject: [PATCH v3 04/15] userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
Date: Mon, 30 Mar 2026 13:11:05 +0300
Message-ID: <20260330101116.1117699-5-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330101116.1117699-1-rppt@kernel.org>
References: <20260330101116.1117699-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A4D38C0011
X-Stat-Signature: skbwszusyju3hy77utt9r6tuaiq4hf9q
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774865514-876651
X-HE-Meta: U2FsdGVkX1/9tWhvegtWbeXJ0h7mXS8k316muuiR7NYtqS/g3Q9utIM1y5/kBOrZZ3ythHUQhRYUyTGa61PgwK6A/tTfEit30SqzxPQiACK0y9tNd2WHfBbYZiYNVHJlnGuLyKTR+yb0XxCM+A1WRxnoF4+fx+27UX1E0W1Uuu7WiDGznMFvFSppcy3suKV0eKsKyMQ6vsiX8yvqQTvy+DyxtE3z8K2j704H+ttzuH0qNi9iLnUe+foPzBVBX8PUeMNR5xIiC2Xh870JsUg6+O77Z5dwcAlZ6tsGhKM8qlpMdLd3i7XcgRKnO5vPK+bpekriG1sON+86Ytc5w2WpuC8QEYqGpR9nDcWLl4X0Je921OwwRgp/ru9ePTHs/0JiIfpz52rqm1lluDtp+8oywfJc/prtI1wNfB2jV39OUUriYLILbckb20dJf1yGxsrj1USpaaO9KcsCKrQw4wYBOLAtEOnWHRjk7MS5pTV95hamElK2S28eZnUqtemRTCLUoavHKipjWE82a1QwPiov+yb2HB82+/qMvLvQnCqECdeE0mnHb+RMT4aZht6vVDAYpP5F9WabNfUB4ikMeqv7JLqMVKHSVJb08rhFHu7OTr6p0SOfVFRNqQCwF8qB3j48I93+Bkj6z3s5I/n8NUj+gFcITDb4Y7yGcl/dBsyR2L2gHjm/P93TbNCq7I93XY4LCiLfftkPbDdpXHTf/BCOcZSYWgZq7YKgf4OWEnyf4tD0soAiBV7jd0pcXkeCJaKVCleMGHbAMZYUYgGAokOpymI0Q/8WS9fyoMpWSP7adP0qkmEZf9u64u9GDFI4u6l7W9qRfm2zT1yUEwwDyzI1L2JFqKT3nz/ZHZgj55vAau0sSAOfZGx0XWT9m35oCFWKOZuZJP9/GNeXo5b7Qq4ZUEkuFpLOl9Kp70hwPemIgg8XLFuuhKhv9GLlxsQbKPrlUDdKHwsNZSWBL2BSwWc
 OKkVj21g
 7bQWQUoru2fzXCHurGkkzzwVLbaI95eJjB1FDTqv+ioME7S4YacvxE2qZSkHeWr428SCTylbXx8cRCbspJpNKOv2r3C2RCxoHlQUEAYelsDVOw/pLiq5rBRPGCWgi8bP9oTwmBjf8wi/PBGuaTcMBmHsTU6L3deMhoJuSrWaRc+I1YGOBPJ9DkcQn0ikUMsgyS+bc/gs6T6nXAcRZKQX1opNUuuvimNML2udN3jJrC6G/qdDD+Xgl51GKPlSOkYhlpe9WOa/bjOWfn14fqmT6itgvM4EdjkfKsYNp9Bzray+shOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Split the code that finds, locks and verifies VMA from mfill_atomic() into
a helper function.

This function will be used later during refactoring of
mfill_atomic_pte_copy().

Add a counterpart mfill_put_vma() helper that unlocks the VMA and releases
map_changing_lock.

[avagin@google.com: fix lock leak in mfill_get_vma()]
Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 mm/userfaultfd.c | 126 ++++++++++++++++++++++++++++-------------------
 1 file changed, 75 insertions(+), 51 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 291e5cfed431..c6a38db45343 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -157,6 +157,75 @@ static void uffd_mfill_unlock(struct vm_area_struct *vma)
 }
 #endif
 
+static void mfill_put_vma(struct mfill_state *state)
+{
+	if (!state->vma)
+		return;
+
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
+	state->vma = dst_vma;
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
+		return 0;
+
+	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
+		goto out_unlock;
+	if (!vma_is_shmem(dst_vma) &&
+	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
+		goto out_unlock;
+
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
@@ -767,8 +836,6 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		.src_addr = src_start,
 		.dst_addr = dst_start,
 	};
-	struct mm_struct *dst_mm = ctx->mm;
-	struct vm_area_struct *dst_vma;
 	long copied = 0;
 	ssize_t err;
 
@@ -783,57 +850,17 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
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
 
@@ -852,8 +879,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		if (unlikely(err == -ENOENT)) {
 			void *kaddr;
 
-			up_read(&ctx->map_changing_lock);
-			uffd_mfill_unlock(state.vma);
+			mfill_put_vma(&state);
 			VM_WARN_ON_ONCE(!state.folio);
 
 			kaddr = kmap_local_folio(state.folio, 0);
@@ -882,9 +908,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
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
2.53.0


