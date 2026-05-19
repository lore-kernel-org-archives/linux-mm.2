Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00064CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 05:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297566B0005; Tue, 19 May 2026 01:25:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247296B0088; Tue, 19 May 2026 01:25:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C356B008C; Tue, 19 May 2026 01:25:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 043C26B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:25:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92B611201E0
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:25:29 +0000 (UTC)
X-FDA: 84783031578.28.80216A2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E1A9414000E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 05:25:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sk27bgpo;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779168327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YBHYc5MI5kk/XJzkYzS1wzmvfhmbzUL/6bczjVTLg0A=;
	b=XUyu8ISeqPpEnQ+4CCF+9OU0chaNybLhQHVs2h4Ame3yUtLgr9yVgqAORNb223xxFJcRoh
	8gYVkxFme+jH2+N4mVqAlhXKiLmNXO8MjVfxftWqf9DOOk+F81Q3MVVp5afCSwhCJ7q+Ma
	QlYh6j3ZHtTjv4Eigg6iT0naex7yxaI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779168327; a=rsa-sha256;
	cv=none;
	b=GukXHHR/S0eMiBTanRTjPjRk7aVs+Cy4hxas6F73xNHMU2QobPyMDeqzbvEI+uuxT3b7B9
	EnGI9q+qxH6M6/J40oRPiBCQFUyKhu0FN+b5k06vDMibBIFlKqJPxVIuRL7DIO61+Z+soC
	U03fotRRAnf+dP9RYQCnELBItzW+K3Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sk27bgpo;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4399660052;
	Tue, 19 May 2026 05:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BA01C2BCB3;
	Tue, 19 May 2026 05:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779168327;
	bh=V6BbUCGzURMjD3AiJxtmYCqeVn8UlrHsVdAJKJuZgFQ=;
	h=From:To:Cc:Subject:Date:From;
	b=sk27bgpoj02r4mfRmc1zwr6ahiAx325MbdTHd3Z0lLHJJ0+fahDF4joQQsthCZ5kS
	 E63QjsTHq+ZH/LFRj2kDvBJuGf7zGMKO1YL9Ed9xu1peBIxmsY5ZPGaOiu1g30X1Ev
	 STdsnJMqYmD6fBZNQtdMVjvkcNim73/EdnGRKMHIC/D2/xw8bvD4+D9QheYwMW+aHZ
	 rz+1dWDgLs1ySI/eKuoZtiXI1X0z10KvtOXyCssWSjC1F+H2Tb1wpc9IGG7y1ILoeI
	 Uo/CvEQdjlB5VRQOsbdVUxWq/2prXnBUmtUHW+mmjTPemwMStBzfSE9Ukc4tQgNOCd
	 Q31ewOXDCiJ7Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Carlier <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] userfaultfd: snapshot VMA state across UFFDIO_COPY retry
Date: Tue, 19 May 2026 08:25:16 +0300
Message-ID: <20260519052516.3315196-1-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E1A9414000E
X-Stat-Signature: qutxsbrrkm5gh1xbr5fyc99xibmuu1i5
X-Rspam-User: 
X-HE-Tag: 1779168327-949592
X-HE-Meta: U2FsdGVkX18sifewXEXgZF73OAr2pOk6HoJ7uatNgWK7olN4BqgT79NZSKFMQUPaKrXCIoprd8RZRmk+PxkpjwPjgq7o+FXOo1voKsb7Xn8uJ3wSEAmNgwcRX0coExDjq8ElOmb1IbvqOp8Pskg37orWTexN6mOjEboYQ7qUTj+VIXN4pJVGMvz+rBgd/TNPf0J56Ri2SXeOtqYzvUgDSXZR8Oat2dcq39jnlPlPvtPwT+K0Q7Fmb6X8vJTJ/5W8EKr7/pFhxkOseWhc6SzeCG+5qzlLNZe0KmENk5PRgHMsa5p/YEP4wSNzXpt5CQ9gh+wGxMsh+pDDOG4MYFhxG3E5cIbpOW6Wlj+lyyv9E9cZ2WvNCl1n6h4/5tnwy6a5E4Akr3ejw1XwO/GdQkjln5prsgDOOnHRY1h3ZqgNO8XhOweyg0ukk+TI2me3bLfstri9Ex/Sy98Bcjj90dw7gOdgz59csduNT/j0gE/BjJEySjF8EVatZLiPI19vknqNrcQHyxp7PFNWxeVu+W95h/Ecp3fvkEjsfacFm59FUmeY90d+SdrqAxAITIqa3880HVvBQ6I3pELrIKivqEPERDIQrSk2ER3+t1TLBO43PjQSbEytNlwHEX36wZkXDs/Wcx+Ci2wZ8+zyUo8hSUqvMTlA/6CJtgvY1PEnprWnnLn+9OCHMsIjlDKkjTr9nzUTmoi9LmhaGNjETZ8lF+aIUS+57LKUIesrz2+mDL1h2uI0pFT0vzw3Fh6XgLDAIWe1IurjnjYwjDA0m5FOHU7AkukAUAx6DZrhIbjLGk28Uto/HSwtr6Tf61FUNCXIAyHSkLXJkkxj7+ahNgs3o9XHbRv+jP6AW6tFrl8jaV7dW370P3LdsWIPj8RwdDwi1Oii3ODPmaB1/8uRHSRDr+m568i8azZplr45KEr+Bi6/KyfR8gdPQOAsMUisGg+v82cIHyUSeKE9bQQ0GPS7gAh
 fvAUOpig
 Sw4Xb0N/jRUJCWjzSfsTbg0eXrjigv133r0/iU9mo/mlMXkbarPhtOS8xmHVaIancpu+App5RhYPhclTG+mRlpCC73kU6v4dxOAH+SZUdmjEVsjPwjFMmo+3gvCRQ4MTXkFEU7KY+eHkGPZM1qWIZxn5clfDEMuQuU41uLzHpUIguISUNsbJ/u4VT7sUOBioFA/UTrVVWsafNHmU2VKzeZY9lg0E40MViaY7PriNuNpLwmC3P3a9bbQGPO3V4VbA8v2bKJb+sHaXeKJ9PQJXw2pGKeHNhWM8FJ6tNAnr5GJZhSi8bJc2tGvA28nvp7SZXVjgPeU34tb4HF1+qasZnDPGZPjwhmabTLhpLM1z9AkYAbn/ZuLWM2d7EOnLJ8QzyXJIE3ei/vLKs/RdckEsIdtfhotq9YVKKlcKn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

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
Tested-by: Heechan Kang <gganji11@naver.com>
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


