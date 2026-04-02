Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72462CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 04:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56606B0092; Thu,  2 Apr 2026 00:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2DC16B0093; Thu,  2 Apr 2026 00:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C44076B0095; Thu,  2 Apr 2026 00:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B932F6B0092
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:12:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D0FD1A03C0
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:36 +0000 (UTC)
X-FDA: 84612294312.24.44A33C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id BE1262000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 04:12:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O6LpCCvm;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775103154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4HMBcouyXvncFNKYcyI8NDDi+6JAJ4akpzdTsGezr4=;
	b=PNAv7lzQEt3v1SjS2QDBJW9l/WaYr0HT6YmJMaPO7OpJ2RefFnxjn9XV/9kLutEeRpg70x
	Y2T9AdU77X2CL43HbCeUxEWH42hRBl1ZjFPQvoP4mWgDTniBRgpnoyq2G/Qa//QJD+qXjp
	WPnDEuIHI03R5iAdwVgaCoMRbfmwjSI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775103154; a=rsa-sha256;
	cv=none;
	b=rIXF2wpH/SXiNv37qZWJNuUv7gzAGQBnyzUyT5XKmyAz2cfKFYTHLlKiB+CTxPZ563V7yk
	RmdebbCFiLV4MmdgNarp4hSM7v0iy3JIWF/Hy7yc8RKiEawSxRkf84nLAe5pMiGUldKoo7
	IKdt3yFCKBxcFHaJms8DMfYwS7QKVVI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O6LpCCvm;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2DF0661866;
	Thu,  2 Apr 2026 04:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990E0C19423;
	Thu,  2 Apr 2026 04:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775103153;
	bh=ioV0AIuZ8YXMYtun9GJuzmLOOslMKT49lU11YBPNu3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6LpCCvmyoASnA3Ul3G2H5VZP5ja5GFeNlfotTaUKFNEDJPBWQasBquvOFTxmwGkX
	 2Upft2ZfOHlPacRUK7hKJ4YWFsDP8lD9x7bySPvv4lBy5/UG0AiFm4Ol2PM5i2/iJ1
	 Yv61x1HnIEf/9L68PpHQkRLw0bsKdaXhzqGCBJCoSsfAuex6zu7ZBwJ3lQDiqjWFRE
	 NhIoFNOU1Pv0K5Z6sMOtdiK4AwCqaW+XDKlgPwPV7nI03LG5YADmDduRjqjE3bcAiu
	 Ygw1t0jmuQ3T5xJM1ZQvljWHrzU/5MAjRUmPVAF7L3I/U+C7JjqPjlu88cFRvLFqcv
	 vtCJiSnyz6AJQ==
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
Subject: [PATCH v4 04/15] userfaultfd: introduce mfill_get_vma() and mfill_put_vma()
Date: Thu,  2 Apr 2026 07:11:45 +0300
Message-ID: <20260402041156.1377214-5-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402041156.1377214-1-rppt@kernel.org>
References: <20260402041156.1377214-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BE1262000D
X-Stat-Signature: ejjp4d1sseyugkm4mu3rgzbs3ruwxaga
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775103154-421773
X-HE-Meta: U2FsdGVkX18YVHkfaADrgjjSwYldolNgjdPHgnYum8AoABjhKUNQzUfFY/C5TnW4RP/Z03tiWSuRYQIIPVP/90mH2fPbfX2vvl1Jmb6v9btFosEGmqJnW5kFxrUPTbrGTx7SNq3eKBR8o5jsruQdJiDAAMsNEEXhL7gstzPFVUL03W/FpYv7tfMc/uaRbOb7z3VyDKwoPY3kRhGSqBLEOnY/h+aUGWugMf5la4O/JZlFVbmdzX8ydGQtTDI66Y4QP7+3NkMdGVAApkyAjkFbA5xOaYVrNCTVRPVqRPakREnre1YT8qRaoW4SZRTVh703BMXD5AE8qnGnu5VQAEnPMfbdAgzWDxD5SeG5kBREh19w2rmcTwOPztbYCARe6u5mjMm2uY2WEYMzjPS8Lbd20cwrVRsEwahMSQrwbriiy3QwrLKAIqg1S/TcHqRh+65hrjfjOkrWsgO2BsBJ1G5mVT0+K/OYWpkfDDDLBUt5JJiM2ru6bIr6BsrzPMFBFWdyt/wHHTavmv61ZbbYArBts9qfLaclPTQBgTD1Z5V7qkOS0Y6bzdASpJK7WwOSPN+ZI4Ew34cD31iutzUOt4pluxIzkRZFmFeIBCy7gs6aBkODmcTL3seCsIhFj71I1Nxtx/QYKFkf/DSHvU6q1EoCNiNRJCsTEKB2NZbFKF7TrJT17CheWRteKJiSyhOBJ3acY/VEDAe8Tl+WvBbbtPNlec37uo6zqBDfhy4e+vKU9inM0dwghNqoxd3bxDDkbcfLBKvEMGrUmzTT+ynlJTEpVhq2D2/6Ggh+LR2szHTzn7UJUwVKURnpV4tBjOl4xRThuvgfobdye15VQ1xW3QcRKiclGQiF+O/5y8TYcFylPBwNGRZkSTab+Ekced2ktEo5BVT3iKxWwJtuSmcvEwWRi+PfPKk5oMG04ZZVzNispsheXHsXyGOJnEWMvLf4gYmp9EQbCwIVejVaZyRPYaB
 Dj3mjibL
 JxgogUapEQMVvIPjEUVWvoHT0mxmikhx/lR08PJeqXmIQOad679+zCAXiwD+AQYieUG//QlTRvy3o4doxkdl3XM80M4XbrrSs2WNvMaDN2RnzG6WNX9V4va61tJB5eKZBJWu1Kpm0rK78oIHX3g3dD+cTuCH7EAIbn/52xL6vL6+qjZZggMUeQb8jAe5DLEm3Gi8PhaPVU7fbEQqb8fWPo8G4L25OIJzQSk5h0Yb4gVbDys+DY/9eCkIQKx/SXhveZwwoE0wklVhqdMWPk1x3oMcV4+b2/TY6JJ9wCEk3lHZVAa4=
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
 mm/userfaultfd.c | 125 ++++++++++++++++++++++++++++-------------------
 1 file changed, 75 insertions(+), 50 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index f653fb3f74df..c6a38db45343 100644
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
 
@@ -783,56 +850,17 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
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
-	state.vma = dst_vma;
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
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
 
@@ -851,8 +879,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 		if (unlikely(err == -ENOENT)) {
 			void *kaddr;
 
-			up_read(&ctx->map_changing_lock);
-			uffd_mfill_unlock(state.vma);
+			mfill_put_vma(&state);
 			VM_WARN_ON_ONCE(!state.folio);
 
 			kaddr = kmap_local_folio(state.folio, 0);
@@ -881,9 +908,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
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


