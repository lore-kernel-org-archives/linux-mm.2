Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 777B6606A326
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 08:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=atDDT426
Received: by kanga.kvack.org (Postfix)
	id 721176B00EF; Sun,  1 Nov 2026 03:24:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2196B05B1; Sun,  1 Nov 2026 03:24:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7916B05B2; Sun,  1 Nov 2026 03:24:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31E786B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 03:24:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CE02C0833
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:24:11 +0000 (UTC)
X-FDA: 85385862702.18.8ECA807
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id D06601A0008
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 08:24:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atDDT426;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793521449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zr2bACuemphecdv4BzIcfo+dhb7hRoM9xEUnWOT8OQY=;
	b=jaUx9fv/fXypzORP/nLk84Ev98JKMvL9m68sHIcNha8wBd5Tdo2xHGQxbxxFj03ujZjalj
	7Wxt1z2CBzPCNP5dDFmfyFb13w5CWDUGrGergz14B471173u5/l3mM6KRF4kM8FZy97oug
	5qb4xsUDMM5OAw+hwQ7o2f/k9Q2qlWE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793521449;
	b=IYEvGNdiZrIcebnPwVYOsQR8z+7ng2aHUtod1VgRJmDqC70aRiDcfX5nYzZMw6Z/YTQ6SM
	1G5mFrH6sroXQSFLFsVzt+PaZ9aIK9mI+4mOQo0EcWVCHK+I+eIHaPmX5dOK48mLp8J5Ln
	USeFnE2mDWJT8JHGl4fbEt7r7tP/Sp8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atDDT426;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 010BA43360;
	Sun,  1 Nov 2026 08:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1299B1F00A15;
	Sun,  1 Nov 2026 08:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793521448;
	bh=zr2bACuemphecdv4BzIcfo+dhb7hRoM9xEUnWOT8OQY=;
	h=From:Date:Subject:To:Cc;
	b=atDDT4264LDfkryxKKZT+rFaN0zTUANFgOlvsFn/u8QwzMOE/ykAwQl7QyTmcqKJQ
	 P8GY+B7tcEeM0uKHOwqIWyHy9uGOCKS0OVLzcyAHYohKCz371SMt6mzOChngqDk2Y9
	 nM4/NLkAE+NWUF0d2RKqedXyYuL2LQFRwdOUMprkldxG1AKxEdzZP3SoebBcKQuQx/
	 uV12oPvGNBzx+KBVq68cege5ZOn+WMrNiBD+UYCpFoNLaf8OuS0bpB7CVy7/b/Iz+j
	 csaxQyQskRuil6fxX5wvMakqCkv0dzHHjhbBYg9aOl76VL0RcME0P596SMDNEuc+bU
	 +K4wr1Dce2HbA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 01 Nov 2026 10:24:02 +0200
Subject: [PATCH] mm/vma: undo userfaultfd unmap preparation when unmapping
 fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261101-uffd-unmap-abort-v1-1-1588d7a7c61a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWMzQrCMBCEX6Xs2aCNRcRXEQ+7ycZG3KTkpwil7
 26ihzl8w8y3QebkOcNt2CDx6rOPocF4GMDMGJ6svG0M+qQvY4uqzllVg+CikGIqSo9uulpj8Ew
 TtNuS2PnPT3l//DlXerEp3dMXhJkVJQxm7pVILHIUadZckN4M+/4FD4NrW5gAAAA=
X-Change-ID: 20261026-uffd-unmap-abort-21f48dcca3b4
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Noah Weinberger <NoahWeinberger2003@proton.me>, 
 Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, stable@vger.kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D06601A0008
X-Stat-Signature: o96yrn6ntp5hahyykksir1k43bapo5su
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793521449-36272
X-HE-Meta: U2FsdGVkX1/tkqwynSPQlsiDU6oQH4ySBTmY0v8Z5mNjMaXdGtotyq7Dnb9xAsd3q8sQFrTHlQIz3g1o9n6IVqVaG4EupaYPDmDXrc8MChGJsAatOv4nyiw19qrRM9tAXIZDc/ViuUL5da74kWIFBV2iALt7zu/bwvfQ3EMXnv4RJseQB34pfjnXUI+PUkXgOMKAbWoCIdBGdnjqumQKGNxrwHzcL1mp3GJMDaEgbqMVsWqH/x7591ABWyN8wXG77j3V6isZT7IM9mIYP/N2sGwHgmnp45WAOSSlfZKc8nTgrlDmSXwvdz9Lmb2ifgtF+AWaKQsgyiznyN9nJKML+IJV78jYUuQf0FlijWJwPckCwYra2+5CcZsiaIe7VVG32ADufcFQZUpwKqlp90eb9413Xq71Gt2RRRYkt5VpBv/DCjyNSMknPksOyBk1l8gvvPBwfUG6slAHtpjGFyhVIcZd1GlUmo6VS/zbFIylt+4lJvIqnZ8bAgblfWNRD0e2+UTTqd+0BhlyVQyPei+T3azv8HJWmtRtYk7272REAA6vdsUEnQIoUCTwbKNIwIptx2euBfz3EJ5I49a959rFzDLTjITh/kzFEH6FOTINGNSF0alT8N8cyK52AkvdHix4W0JNJ9FTY72NGa7vE8IykrsXiEgFR8Ak3O+Jh4VE6RicI2Nc777mCOtS7yT1Pj0vYHwFzkK5kefP/rCpSNWjJ4OJS5MCFWAoiVa/sCaRq9/9hmE0I99ZaMybgu8y2N/VjGM5qi9GTj+gO7TbieBV/ZbDcXm1HtvrCzQauS8yQXc2zB2mxdgN3MaaGNvXPGl/exg1Y9xylC0jvyXPlNLKTHSJ72vdP2uAOHZ94b8X5I45t7jidIlHMDSxrotKwJk0UqWJsXwuqz9oYWrA2+sS2ei+5Vl4SS+gQ+RmgKpzkNS22D3Hcc4oOMNIGrr43qH1dzp58BRfHHUJ3YCp755
 HbqBERas
 R0olOSf8/REc63i8hvl6VZy+FajU4o5Y5JjGKsKTqOln2tlV0tuF3PlCwfL9CYiBLU7ZyRNLMs60Gt1s4djwYuA4REoJTsj0wzXO24MlA9tiOOJmc0gVoN2DQkxpiPKxIgUTRlQogJjxCA9BYv/ts/nMrcDif4P18vLW2wOsVrO0+Rm/g30w7Ef/cXFFwoIfM0Ji1hU4tX1VAl4FNk0oHB6BSEeoAr3HMG4Yg/jS/K2dOhrxtfubVtl+r6EUyi5g3lgCqOKzPfGh/iGvVLT/afZKPdzZqg52QRogOPT7XLv5kFa3PsaQol7UY6aSYmBIjFH26
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vms_gather_munmap_vmas() collects VMAs to unmap and calls
userfaultfd_unmap_prep() for each of these VMAs. This takes a reference
to the userfaultfd context, raises ctx->mmap_changing and queues an
UFFD_EVENT_UNMAP on the caller's list.

If gathering fails half way, e.g. because one of the VMAs is sealed, or
the operation fails after the VMAs were gathered, the original mappings
stay intact but the queued events remain on the list.

Depending on the caller they are either delivered although nothing was
unmapped (munmap(), mremap(), mmap(MAP_FIXED)), or silently dropped
(brk()). In the latter case the userfaultfd context and the mm_struct it
pins are leaked and mmap_changing is never lowered, so UFFDIO_COPY,
UFFDIO_ZEROPAGE and all other ioctls that check mmap_changing fail with
-EAGAIN forever.

With mseal() this is trivially triggered by an unprivileged process.

Collect the events in do_vmi_align_munmap() on a local list and splice
it to the caller's list only when the unmap completes, because mremap()
may already have events for earlier unmaps on that list.

Drop the pending events with a new userfaultfd_unmap_abort() helper when
do_vmi_align_munmap() or __mmap_setup() fail.

Fixes: 65ac132027a88 ("userfaultfd: fix regression in userfaultfd_unmap_prep()")
Reported-by: Noah Weinberger <NoahWeinberger2003@proton.me>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
Noah reported off-list that when an operation that unmaps memory fails
half way, some UFFD_EVENT_UNMAP events might already be queued for it.
These events are either delivered although nothing was unmapped, or
leaked together with the userfaultfd context and the mm_struct it pins.

With mseal() this is trivially triggered by an unprivileged process.
---
 include/linux/userfaultfd_k.h     |  5 +++++
 mm/userfaultfd.c                  | 19 +++++++++++++++++++
 mm/vma.c                          | 28 +++++++++++++++++++++++-----
 tools/testing/vma/include/stubs.h |  4 ++++
 4 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index ebd86677b052d..5857ff0542905 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -279,6 +279,7 @@ extern int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, struct list_head *uf);
 extern void userfaultfd_unmap_complete(struct mm_struct *mm,
 				       struct list_head *uf);
+void userfaultfd_unmap_abort(struct list_head *uf);
 extern bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma);
 extern bool userfaultfd_wp_async(struct vm_area_struct *vma);
 extern bool userfaultfd_rwp_async(struct vm_area_struct *vma);
@@ -445,6 +446,10 @@ static inline void userfaultfd_unmap_complete(struct mm_struct *mm,
 {
 }
 
+static inline void userfaultfd_unmap_abort(struct list_head *uf)
+{
+}
+
 static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
 {
 	return false;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3b71712edab4c..15d2422345705 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3295,6 +3295,25 @@ void userfaultfd_unmap_complete(struct mm_struct *mm, struct list_head *uf)
 	}
 }
 
+void userfaultfd_unmap_abort(struct list_head *uf)
+{
+	struct userfaultfd_unmap_ctx *unmap_ctx, *n;
+
+	if (!uf)
+		return;
+
+	list_for_each_entry_safe(unmap_ctx, n, uf, list) {
+		struct userfaultfd_ctx *ctx = unmap_ctx->ctx;
+
+		atomic_dec(&ctx->mmap_changing);
+		VM_WARN_ON_ONCE(atomic_read(&ctx->mmap_changing) < 0);
+		userfaultfd_ctx_put(ctx);
+
+		list_del(&unmap_ctx->list);
+		kfree(unmap_ctx);
+	}
+}
+
 static int userfaultfd_release(struct inode *inode, struct file *file)
 {
 	struct userfaultfd_ctx *ctx = file->private_data;
diff --git a/mm/vma.c b/mm/vma.c
index d416ba58eb4c2..4672d420521e3 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1675,9 +1675,18 @@ int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	mt_init_flags(&mt_detach, vmi->mas.tree->ma_flags & MT_FLAGS_LOCK_MASK);
 	mt_on_stack(mt_detach);
 	struct vma_munmap_struct vms;
+	struct list_head *uf_unmaps;
+	LIST_HEAD(uf_new_unmaps);
 	int error;
 
-	init_vma_munmap(&vms, vmi, vma, start, end, uf, unlock);
+	/*
+	 * @uf may already hold events of earlier successful unmaps, e.g. in
+	 * mremap().
+	 * Collect new events on a separate list so they can be dropped if this
+	 * unmap fails, and splice them into @uf on success.
+	 */
+	uf_unmaps = uf ? &uf_new_unmaps : NULL;
+	init_vma_munmap(&vms, vmi, vma, start, end, uf_unmaps, unlock);
 	error = vms_gather_munmap_vmas(&vms, &mas_detach);
 	if (error)
 		goto gather_failed;
@@ -1687,12 +1696,15 @@ int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		goto clear_tree_failed;
 
 	/* Point of no return */
+	if (uf)
+		list_splice_tail(&uf_new_unmaps, uf);
 	vms_complete_munmap_vmas(&vms, &mas_detach);
 	return 0;
 
 clear_tree_failed:
 	reattach_vmas(&mas_detach);
 gather_failed:
+	userfaultfd_unmap_abort(&uf_new_unmaps);
 	validate_mm(mm);
 	return error;
 }
@@ -2581,7 +2593,7 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 		if (error) {
 			/* On error VMAs will already have been reattached. */
 			vms->nr_pages = 0;
-			return error;
+			goto abort_unmaps;
 		}
 
 		map->next = vms->next;
@@ -2591,8 +2603,10 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 	}
 
 	/* Check against address space limit. */
-	if (!may_expand_vm(map->mm, &map->vma_flags, map->pglen - vms->nr_pages))
-		return -ENOMEM;
+	if (!may_expand_vm(map->mm, &map->vma_flags, map->pglen - vms->nr_pages)) {
+		error = -ENOMEM;
+		goto abort_unmaps;
+	}
 
 	/* Private writable mapping: check memory availability. */
 	if (accountable_mapping(map)) {
@@ -2602,7 +2616,7 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 		if (uncharged) {
 			error = security_vm_enough_memory_mm(map->mm, uncharged);
 			if (error)
-				return error;
+				goto abort_unmaps;
 		}
 
 		/* Our new mapping owns the entire charge now. */
@@ -2621,6 +2635,10 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 
 	set_desc_from_map(desc, map);
 	return 0;
+
+abort_unmaps:
+	userfaultfd_unmap_abort(uf);
+	return error;
 }
 
 static bool map_same_file(struct mmap_state *map)
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index 8d030a3ace848..9f5b8e996abf6 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -148,6 +148,10 @@ static inline int userfaultfd_unmap_prep(struct vm_area_struct *vma,
 	return 0;
 }
 
+static inline void userfaultfd_unmap_abort(struct list_head *uf)
+{
+}
+
 static inline void mmap_write_downgrade(struct mm_struct *mm)
 {
 }

---
base-commit: b61fa14ce6bcbba2cb9a96feea31b760226d6b43
change-id: 20261026-uffd-unmap-abort-21f48dcca3b4

--
Sincerely yours,
Mike.


