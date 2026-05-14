Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B762CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 18:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5459C6B0005; Thu, 14 May 2026 14:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6AB6B0088; Thu, 14 May 2026 14:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E5FA6B008A; Thu, 14 May 2026 14:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29EBD6B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:00:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0635A01B5
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:00:12 +0000 (UTC)
X-FDA: 84766789464.06.9EDF81D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E61D5160007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:00:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wa+TtFxb;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778781611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgqEL2Fq3FbYhvpeW4fngQYTK2okRusffuWxNcGR/t4=;
	b=vwA+0eWxTFMVYGAweh2emJ4cpDJ3N/Q4fX3tt9Mc+6ITRtuGIERu53FohECOyjxiI2adGQ
	eOiKaIYWRA6XrRMbD3bHgXxL823igm+xegARzDPJv7NH3rgxWNbFd6XonRonIzy8BDphMK
	2MWMuqOB1m3feqYdvN1zOxVfTt22vlc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wa+TtFxb;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778781611; a=rsa-sha256;
	cv=none;
	b=bawEFBLuDdoISDPOU7VFbiZNh7mkYDOszDpEEbGAvAMjQKvpKucxMoG8UEyhwgVvTqiGgJ
	UIauoNTkxy/YAPdPrfswhkXGmOxc0L44NUOjTFH71VnVyKo54dgyFL+p/plCoMrEOOmRK6
	LkrVnpJRA9+It3nObKZqcgm3WX743vA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C55BD4388B;
	Thu, 14 May 2026 18:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BC3C2BCB3;
	Thu, 14 May 2026 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778781609;
	bh=5QlYJbUUKZlLZsVroc6GL0rk99V69x6VGCmzaU3JDBY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wa+TtFxbxjrEo/jt0VGMtLSI5HWKxi/OA1NMpjVsygAsyTjTMu6NmJmN3TVyVtKNP
	 OcO5uPP41LKttFzFEIhiQvLpJGNIAi68w5HIMidyXICJqvEpRQlKLE+t5nW/mhlvir
	 /TM0w4VCzPGFLqYKpfehICGJr2k3UU6Ya3A5/x/U9drL8KwQhlRq9U62FrHNrIU9D8
	 1zV1WNn4Vsmn+GTH1thGpL7TqEUDmd9lan1mQr9LZyrfkdt3+BQdIUFizQn8WQAnwm
	 /6ZI+AzUsHFwQ7YItVfbL1TThQ8MoDBm2XQ2PsmDLao6LBvO9G55bP0LiLeC+OR6ZC
	 OXyuGve9eV5hA==
Date: Thu, 14 May 2026 21:00:02 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Michael Bommarito <michael.bommarito@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, David Carlier <devnexen@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH 0/1] mm/userfaultfd: fix UFFDIO_COPY retry private/shared
 VMA panic
Message-ID: <agYNorGjJb3epGdh@kernel.org>
References: <20260514005440.3361406-1-michael.bommarito@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514005440.3361406-1-michael.bommarito@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E61D5160007
X-Rspamd-Server: rspam06
X-Stat-Signature: k3u8y1timjiqbif4pae17i4pe93as3we
X-HE-Tag: 1778781610-192457
X-HE-Meta: U2FsdGVkX1+D4mXg8eCG56s6lcLrJy4iSZEYsQ881HxEyjRQpsypWOGJ3s2HegXPt6L2fF7FSgs5IGRhhRPJfMR877VqunuWam4+PnH73yPOBvGn87eFFkTAl+nikTxg7hk3TKfPU2VUEJ7wY5UsoLFaIF5h8P/mejFXezWZXStU12n+MMJ8/WbGUGDNxQUv4n+BrUkbbp/m0GueeTVB5PhJdi/e2zo9FZHrU2G8lRShCRa3ZjfSffrpCdaJlJhpLmxIg2jKrasMruk/WpeySUG8Cy/UAH+EBOjTdKTDroOK+VKJpS7vBLmw0mdyV5dmvfrbG9cq+8gysYqrGGgM3PjoRUvuSXOkNtrHJg9p0CbJybTGMsHqZa4Qd7SDdF+BLD8mhWXTjwFovk+xz0JP58hlRSuvrykdQN1JWdkkfBxznSz0Fne28myNZnASEwlznhKB6Cr8BFnvOhN3l7kbx/aTzV3qtDAMzpmh09ybt4Up6U+t3xM4SnqsFi9OOpvbz+I+Hn/4PjxhqsGlSXXQ3ud0xL0kPVLelkU8W5hs1/SLbY3RwAamLndLg/ZO8Jq0VBjxw1j+5M87pSjjFeaUM7+NXiK765I47jzldTajhECRRISdC/K+sBj+Ivf1nyuecBoTlXBFvnyGDGLIJ+b6tx9it7TkwQlj/7P4jUw5qZfIIQ0EL6KabKX4NKhAG5djPzk98bT+2NDpogzi2sZGRkcIIEvxub5zKQVapBg0VotCXysc7ptA4d0W1ZY+oVKqS4YwDQAbdS1LIvD77tXTikwNW08rrA7WUTydyXvin4USTQ9c6ZfMiAjv56kc2IfhlOnnQKvvHhg7dBMVTvN24c6+YKceGQcDUYiTSRJhwnnWZOGdC5H7rMx/0KZgixsZsPPR1X5zYQeOLh6+LtjlwWD6NBr98hzW3uC1rcduW6/wnyPRrGHMXdQ8Ds4o/sS2vhD3NujTLyawJUdHJ49
 pzwW4Qui
 fdM2ej5TSumlMvs/VNY9oSiDtih3HaqVuPvFWmpWUulBp7IrnV0eeXPPrgrT43ppAGmis6nacw8rgaSIsfyTwM5tgE2HNAbngwHRCDePrnvZ+ADh6UGhOL5w+GhujqrWUOIT14ffuiar9UUeOjF7+u7YWsSSOxrQrsNARj8kSnInKctV0FMO1pRhQ+23PaaTbD6STkB/Q6doHsafreb6+/jWHighg02cZS70l7ImAGdQ8T8ttd4s37K130O0P0yH37PmTeKWcetWiGwZlC4MucKVFqTgF36EVreZP/LtM0VflUFpGRBKRrRyIj7E1WsaxdLRj1qYQ0bRMa0JBXBdy/Ulkz0GgmNfl3KAnI9J8n9THjABnVpsU0zBCMOocTVXVtqI7ixBoDp1ZHdADZjMAV9Q8lPF55QS3bHGwY42CzMuT/woKUPcAhqgD/6pwYg5SpHhw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, May 13, 2026 at 08:54:39PM -0400, Michael Bommarito wrote:
> Hi,
> 
> mfill_copy_folio_retry() drops the destination VMA lock before
> copy_from_user() and reacquires it afterwards.  Commit 292411fda25b
> ("mm/userfaultfd: detect VMA type change after copy retry in
> mfill_copy_folio_retry()") added a comparison of vma_uffd_ops() across
> that window, but the comparison is not tight enough for private/shared
> shmem swaps: both private and shared shmem VMAs expose shmem_uffd_ops
> through vm_ops, while UFFDIO_COPY into a MAP_PRIVATE file-backed VMA
> overrides the effective copy ops to anon_uffd_ops at
> mfill_atomic_pte_copy() time.
> 
> A separate concern from Peter Xu's review of v1 of 292411fda25b's
> series -- replacement with a different shmem VMA carrying the same
> flags but a different inode -- is out of scope here and is also
> unaddressed by 292411fda25b.

Thanks for the patch!

I'd prefer to deal with all the issues at once and I added vma_snapshot
suggested by Peter on top of you changes.


From a6921db3b2c382a0b57a49847bf75934237ac93b Mon Sep 17 00:00:00 2001
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 14 May 2026 18:51:58 +0300
Subject: [PATCH] userfaultfd: snapshot VMA state across UFFDIO_COPY retry

mfill_copy_folio_retry() drops the VMA lock for copy_from_user() and
reacquires it afterwards. The destination VMA can be replaced during that
window.

The existing check compares vma_uffd_ops() before and after the retry, but
if a shmem VMA with MAP_SHARED is replaced with a shmem VMA with
MAP_PRIVATE (or vice versa) the replacement goes undetected.

The change from MAP_PRIVATE to MAP_SHARED will treat the folio allocated
with shmem_alloc_folio() as anonymous and this will cause BUG() when
mfill_atomic_install_pte() will try to folio_add_new_anon_rmap().

The change from MAP_SHARED to MAP_PRIVATE allows injection of folios into
the page cache of the original VMA.

Introduce helpers for more comprehensive comparison of VMA state:
- vma_snapshot_get() to save the relevant VMA state into a struct
  vma_snapshot (original uffd_ops, actual uffd_ops, relevant VMA flags,
  vm_file and pgoff) before dropping the lock
- vma_snapshot_changed() to compare the saved state with the state of the
  VMA acquired after retaking the locks
- vma_snapshot_put() to release vm_file pinning.

Use DEFINE_FREE() cleanup to wrap vma_snapshot_put() to avoid complicating
error handling paths in mfill_copy_folio_retry().

Add vma_uffd_copy_ops() to avoid code duplication when original ops of
shmem VMA with MAP_PRIVATE are replaced with anon_uffd_ops.

Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")
Fixes: 6ab703034f14 ("userfaultfd: mfill_atomic(): remove retry logic")
Suggested-by: Peter Xu <peterx@redhat.com>
Co-developed-by: David Carlier <devnexen@gmail.com>
Signed-off-by: David Carlier <devnexen@gmail.com>
Co-developed-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 99 ++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 79 insertions(+), 20 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 180bad42fc79..b70b84776a79 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -14,6 +14,8 @@
 #include <linux/userfaultfd_k.h>
 #include <linux/mmu_notifier.h>
 #include <linux/hugetlb.h>
+#include <linux/file.h>
+#include <linux/cleanup.h>
 #include <asm/tlbflush.h>
 #include <asm/tlb.h>
 #include "internal.h"
@@ -69,6 +71,24 @@ static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
 	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
 }
 
+static const struct vm_uffd_ops *vma_uffd_copy_ops(struct vm_area_struct *vma)
+{
+	const struct vm_uffd_ops *ops = vma_uffd_ops(vma);
+
+	if (!ops)
+		return NULL;
+
+	/*
+	 * UFFDIO_COPY fills MAP_PRIVATE file-backed mappings as anonymous
+	 * memory. This is an effective ops override, so retry validation must
+	 * compare the override result, not just vma->vm_ops->uffd_ops.
+	 */
+	if (!(vma->vm_flags & VM_SHARED))
+		return &anon_uffd_ops;
+
+	return ops;
+}
+
 static __always_inline
 bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
 {
@@ -443,14 +463,70 @@ static int mfill_copy_folio_locked(struct folio *folio, unsigned long src_addr)
 	return ret;
 }
 
+#define VMA_SNAPSHOT_FLAGS append_vma_flags(__VMA_UFFD_FLAGS, VMA_SHARED_BIT)
+
+struct vma_snapshot {
+	const struct vm_uffd_ops *copy_ops;
+	const struct vm_uffd_ops *ops;
+	struct file *file;
+	vma_flags_t flags;
+	pgoff_t pgoff;
+};
+
+static void vma_snapshot_get(struct vma_snapshot *s, struct vm_area_struct *vma)
+{
+	s->flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
+	s->copy_ops = vma_uffd_copy_ops(vma);
+	s->ops = vma_uffd_ops(vma);
+	s->pgoff = vma->vm_pgoff;
+
+	if (vma->vm_file)
+		s->file = get_file(vma->vm_file);
+}
+
+static bool vma_snapshot_changed(struct vma_snapshot *s,
+				 struct vm_area_struct *vma)
+{
+	vma_flags_t flags = vma_flags_and_mask(&vma->flags, VMA_SNAPSHOT_FLAGS);
+
+	if (!vma_flags_same_pair(&s->flags, &flags))
+		return true;
+
+	/* VMA type or effective uffd_ops changed while the lock was dropped */
+	if (s->ops != vma_uffd_ops(vma) || s->copy_ops != vma_uffd_copy_ops(vma))
+		return true;
+
+	/* VMA was anonymous before; changed only if it no longer is */
+	if (!s->file)
+		return !vma_is_anonymous(vma);
+
+	/* VMA was file backed, but inode or offset has changed */
+	if (!vma->vm_file || vma->vm_file->f_inode != s->file->f_inode ||
+	    vma->vm_pgoff != s->pgoff)
+		return true;
+
+	return false;
+}
+
+static void vma_snapshot_put(struct vma_snapshot *s)
+{
+	if (s->file)
+		fput(s->file);
+}
+
+DEFINE_FREE(snapshot_put, struct vma_snapshot *, if (_T) vma_snapshot_put(_T));
+
 static int mfill_copy_folio_retry(struct mfill_state *state,
 				  struct folio *folio)
 {
-	const struct vm_uffd_ops *orig_ops = vma_uffd_ops(state->vma);
+	struct vma_snapshot s = { 0 };
+	struct vma_snapshot *p __free(snapshot_put) = &s;
 	unsigned long src_addr = state->src_addr;
 	void *kaddr;
 	int err;
 
+	vma_snapshot_get(&s, state->vma);
+
 	/* retry copying with mm_lock dropped */
 	mfill_put_vma(state);
 
@@ -467,12 +543,7 @@ static int mfill_copy_folio_retry(struct mfill_state *state,
 	if (err)
 		return err;
 
-	/*
-	 * The VMA type may have changed while the lock was dropped
-	 * (e.g. replaced with a hugetlb mapping), making the caller's
-	 * ops pointer stale.
-	 */
-	if (vma_uffd_ops(state->vma) != orig_ops)
+	if (vma_snapshot_changed(&s, state->vma))
 		return -EAGAIN;
 
 	err = mfill_establish_pmd(state);
@@ -545,19 +616,7 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 
 static int mfill_atomic_pte_copy(struct mfill_state *state)
 {
-	const struct vm_uffd_ops *ops = vma_uffd_ops(state->vma);
-
-	/*
-	 * The normal page fault path for a MAP_PRIVATE mapping in a
-	 * file-backed VMA will invoke the fault, fill the hole in the file and
-	 * COW it right away. The result generates plain anonymous memory.
-	 * So when we are asked to fill a hole in a MAP_PRIVATE mapping, we'll
-	 * generate anonymous memory directly without actually filling the
-	 * hole. For the MAP_PRIVATE case the robustness check only happens in
-	 * the pagetable (to verify it's still none) and not in the page cache.
-	 */
-	if (!(state->vma->vm_flags & VM_SHARED))
-		ops = &anon_uffd_ops;
+	const struct vm_uffd_ops *ops = vma_uffd_copy_ops(state->vma);
 
 	return __mfill_atomic_pte(state, ops);
 }

base-commit: 444fc9435e57157fcf30fc99aee44997f3458641
-- 
2.53.0


-- 
Sincerely yours,
Mike.

