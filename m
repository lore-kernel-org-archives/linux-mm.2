Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B33FB10F2871
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 20:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FC3E6B0099; Fri, 27 Mar 2026 16:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F2B6B009B; Fri, 27 Mar 2026 16:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD316B009D; Fri, 27 Mar 2026 16:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D5B036B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:55:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B4B41412DE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:13 +0000 (UTC)
X-FDA: 84593048106.28.DAC8053
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id BFA75A0006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cAeFDX78;
	spf=pass (imf15.hostedemail.com: domain of 3ru7GaQYKCPsvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3ru7GaQYKCPsvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cAeFDX78;
	spf=pass (imf15.hostedemail.com: domain of 3ru7GaQYKCPsvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3ru7GaQYKCPsvxuhqejrrjoh.frpolqx0-ppnydfn.ruj@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774644911; a=rsa-sha256;
	cv=none;
	b=xgcWfTW0uy3YCtLcvnJsp8AKjol14US2WVhVDW5izI/ekZjXwxLqrD9Lf2S25XcfqnaQLq
	8jsvfx+CACjAt2aGNpWo5vfC6qPZuY6esanaCY7QUx1vPXTp6nJp1Y9VclmowpF13WqrXm
	7DiChSJmNjdFGPiyV36cnqd8vK8qwbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774644911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6skjtd7OxVmiwFu5TmEIQZKDuU+5vel5eIP7VGPQHkg=;
	b=akEyDX5OJpj59OLEc+RXSIqXpFtIqvH18sFYFwIs6c0mzCEtzRFKuvElCOMC/tDee2HYK6
	CLeqecT10TBxrcpTM1yCHTuupE46S8/jIWBeJZUMV1+Kn/yuClOEu+NhyKUdSWnk2OYzg5
	8yciEAjv8MVSU8/QGOks4JN6tUJ0ul8=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2ba9a744f7dso2551577eec.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774644911; x=1775249711; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6skjtd7OxVmiwFu5TmEIQZKDuU+5vel5eIP7VGPQHkg=;
        b=cAeFDX78E6qoDiCSoEVd0jZUWHTj1IIJZnPzf71JJNv8/Dy+55sZ1nULgb6u4m2bvs
         lxH0nQF3w3GUInq+mYVUkYrJH2MbuWTGCMKlfXHTJBjysS35D+Gcuj/5b8Eo8zZEhQKg
         oPO2tQdQi70GFn9ZF3L5XkOn9XUcwD6gb3NAqjGsKvljLB6j4/sjvgM18dK2zsYoZ7Hi
         Ub76voVteJ7bOzJRzQXzxQXSRS6nSYIFfKGBN6SWrTgAhI0uhFu6Esg/uwTfN86VYD0j
         N9VNLSHJHc/A/IIyZGfifXqRcD85nnv+LYdZwf4vacQXJjbEm52zwPiqzseRiTtVLFOV
         FpWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774644911; x=1775249711;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6skjtd7OxVmiwFu5TmEIQZKDuU+5vel5eIP7VGPQHkg=;
        b=c/VgmiyDASVFOZ6jR6rfwWmpk5pjwikEfQ5Mfxx0EuaiFqupeSGKSVTnHO7xNhDSIe
         3InAgm3yOtNJ0MXczX8Oxigquo550r8yvlPXtbWHPW9auMIg+RAwgL9IuDcKLILObdIc
         YEBD9zZXWRRrKejWL1KwJ44sn4zkeZ1NyLaLZuJlUJ1+edYKXoc7SMrUwzPDwIErJlQr
         5RIecnyWv9WSiQKH1Rgyf0Hjzrb0JkR9tVXQ47T0CLKxA2QXkfxKGi/v+EiLb73iTZhh
         8yYVshNDALEYEE0G8Smt4L33hpTztw8jyeaZk9aAVJPLV565od3NtdFd52rHG9Bbi72K
         1Kng==
X-Forwarded-Encrypted: i=1; AJvYcCUtEnNIyLrrVyYEAmI5ewzjSPmRF+TWRCgacaHVUaEYnUxK+AH6n5wceJz4JuzAOQtsHwhiELiG7Q==@kvack.org
X-Gm-Message-State: AOJu0YxzxVMBMCs6OmOwme/bFmb4uYSUngWaUgCLUVQ9lyIfmxqgrrcq
	/hplltr1ShdSZlF5pCBsbombjxQZxzxxqN/veFKdD+eO62je3pSBH6NEMiOobI4yGI2vrzPNiaS
	Yr0nO0Q==
X-Received: from dybrq15.prod.google.com ([2002:a05:7301:468f:b0:2c3:adf7:d755])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:5b89:b0:2c1:1dea:c443
 with SMTP id 5a478bee46e88-2c185e460a2mr2052736eec.19.1774644910254; Fri, 27
 Mar 2026 13:55:10 -0700 (PDT)
Date: Fri, 27 Mar 2026 13:54:55 -0700
In-Reply-To: <20260327205457.604224-1-surenb@google.com>
Mime-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327205457.604224-5-surenb@google.com>
Subject: [PATCH v6 4/6] mm/vma: use vma_start_write_killable() in vma operations
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, ljs@kernel.org, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BFA75A0006
X-Stat-Signature: hi3anmccex8m8qsowsmpu3in9qyj9qg7
X-Rspam-User: 
X-HE-Tag: 1774644911-319841
X-HE-Meta: U2FsdGVkX1+JyqCl7nIXMQkpHyRsbIIj+7GlDMbsP6vL7RAnMyKDnKN1II8FT3DYM8eDTh/bi0eNOMRkFF9FtbLis+dlN2bjL73s3HPVXE/Vggd3/hkkNE+G5JG0tEFnnKMU2hTaoIMRztNpkyUx9SoIth2QErAR9ydSOAEuExFQ1n2UHdRefaqYU0aqJtxlwsucsm7XUXEJ8kUrlWvPqBaIiWrLXLZ2Tc1jJelLoDEeFmDnq/wnpFXvZi8oVzB28qMkInIAJllEBcG69uCYRgby5x3A7rOnHz10ULVOwowNSLV++4RT6F8RRb/hu6dr8TaXl6RRcFaePl6FSSvL9+VPbp4waT4FOP21Pt18LEXZuM0LcJgWYHlHFsGlBOjeXQKYQHijxMp2SZYrm6AeDtfoQfgs3iknrISg0dXsyhSU1GhYDaj61ByjazUVuJyBvAQrMsr+k3hAYemtVs3TRdOK8BkReeGyWVhBpIGTWc6B7gqLR7dINldweDIaFJFWPh63OakCuilBP260HtMGRozuq+dZcQQaTaxYhizIE1aRDvHJPLq6ecFZeYIBoy7Ub2Lw5Tl16Ze/xeL4RoTiBhdUhpNwRTWevpQUsk/lg9IaK1+M4/624na8PHRgRtJGgXLd31Do6r4OMBj/VQEPACyltfuAFKcCavXxgMAN1Gxm54pcEqlPfdx3LGX33QSjoN8zq7sNmlYmjUX492W6muIR5Bx+XKjvPpFXwDWGYi9fUt2T0XXQN3Cl3X3DHwO7yKdxmcufbxcyQkBzvUdZbRCnY+aWrusX7cgnlPL3O5HB6SM1r+1KXGg4hbW+NNPy7PhiNtdmrUYEZALgT3Qmx9ZtjOUr3Lis++8ohJXAKFmKm+orrMOscfyQEuWbjFNHD9qeMg62/AWyTVtaCfBIX4rkOLUoxTS6p3AikfUboa/95Zsg4X5APRGDQc8/9tinQevZGD4UdJ7aHDVC0Jo
 Hh0oRRxF
 Y5YJTdrtHgnOOUojOraa2Pr65kBJ7tmTaep9YAinkwseHJgwO2Mi6/PTR2EE8q/LmTjv9HnnhzU5Fr4J6rNHVkAhCwtY2Fw6fCw/PnlzH2XtCFiSfYq5vUiMkcxpNewqUnCgBNyNEdNvrXhn4/EsfmsO9B7r+sDcLppJnktZ7dKubGCjpOESNTu4f7gpjZMqSs2JOaHCSk4Ai57mG4GZq2Fqe6KiyRKsYjKubL0xB3qwX2ZGudh/LvzgN2AZBcZfhxzXHBXALQvgPo5WJ6XVK4fvP0IskM5J8Jn2HS2QV8O+OvmCfSeZgShxqrJ0WyeFV3TvYXx7iSZAFTQxiVe2BXhFm9Q70xiBQLykrPpIsrCva6IoptjeaQmV7maxbZzr14qABNmtM9L+W0b7BEgayaiYpp7eN20ctCARKest8y9V3i0XnipigsR7e/pDYQ6pSENdYN8EzjuciuUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace vma_start_write() with vma_start_write_killable(), improving
reaction time to the kill signal.
Replace vma_start_write() calls when we operate on VMAs.

To propagate errors from vma_merge_existing_range() and vma_expand()
we fake an ENOMEM error when we fail due to a pending fatal signal.
This is a temporary workaround. Fixing this requires some refactoring
and will be done separately in the future.

In a number of places we now lock VMA earlier than before to avoid
doing work and undoing it later if a fatal signal is pending. This
is safe because the moves are happening within sections where we
already hold the mmap_write_lock, so the moves do not change the
locking order relative to other kernel locks.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/vma.c      | 146 ++++++++++++++++++++++++++++++++++++++------------
 mm/vma_exec.c |   6 ++-
 2 files changed, 117 insertions(+), 35 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index ba78ab1f397a..cc382217f730 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -524,6 +524,21 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		new->vm_pgoff += ((addr - vma->vm_start) >> PAGE_SHIFT);
 	}
 
+	/*
+	 * Lock VMAs before cloning to avoid extra work if fatal signal
+	 * is pending.
+	 */
+	err = vma_start_write_killable(vma);
+	if (err)
+		goto out_free_vma;
+	/*
+	 * Locking a new detached VMA will always succeed but it's just a
+	 * detail of the current implementation, so handle it all the same.
+	 */
+	err = vma_start_write_killable(new);
+	if (err)
+		goto out_free_vma;
+
 	err = -ENOMEM;
 	vma_iter_config(vmi, new->vm_start, new->vm_end);
 	if (vma_iter_prealloc(vmi, new))
@@ -543,9 +558,6 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (new->vm_ops && new->vm_ops->open)
 		new->vm_ops->open(new);
 
-	vma_start_write(vma);
-	vma_start_write(new);
-
 	init_vma_prep(&vp, vma);
 	vp.insert = new;
 	vma_prepare(&vp);
@@ -900,12 +912,22 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	}
 
 	/* No matter what happens, we will be adjusting middle. */
-	vma_start_write(middle);
+	err = vma_start_write_killable(middle);
+	if (err) {
+		/* Ensure error propagates. */
+		vmg->give_up_on_oom = false;
+		goto abort;
+	}
 
 	if (merge_right) {
 		vma_flags_t next_sticky;
 
-		vma_start_write(next);
+		err = vma_start_write_killable(next);
+		if (err) {
+			/* Ensure error propagates. */
+			vmg->give_up_on_oom = false;
+			goto abort;
+		}
 		vmg->target = next;
 		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
 		vma_flags_set_mask(&sticky_flags, next_sticky);
@@ -914,7 +936,12 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (merge_left) {
 		vma_flags_t prev_sticky;
 
-		vma_start_write(prev);
+		err = vma_start_write_killable(prev);
+		if (err) {
+			/* Ensure error propagates. */
+			vmg->give_up_on_oom = false;
+			goto abort;
+		}
 		vmg->target = prev;
 
 		prev_sticky = vma_flags_and_mask(&prev->flags, VMA_STICKY_FLAGS);
@@ -1170,10 +1197,18 @@ int vma_expand(struct vma_merge_struct *vmg)
 	vma_flags_t sticky_flags =
 		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
 	vma_flags_t target_sticky;
-	int err = 0;
+	int err;
 
 	mmap_assert_write_locked(vmg->mm);
-	vma_start_write(target);
+	err = vma_start_write_killable(target);
+	if (err) {
+		/*
+		 * Override VMA_MERGE_NOMERGE to prevent callers from
+		 * falling back to a new VMA allocation.
+		 */
+		vmg->state = VMA_MERGE_ERROR_NOMEM;
+		return err;
+	}
 
 	target_sticky = vma_flags_and_mask(&target->flags, VMA_STICKY_FLAGS);
 
@@ -1201,6 +1236,19 @@ int vma_expand(struct vma_merge_struct *vmg)
 	 * we don't need to account for vmg->give_up_on_mm here.
 	 */
 	if (remove_next) {
+		/*
+		 * Lock the VMA early to avoid extra work if fatal signal
+		 * is pending.
+		 */
+		err = vma_start_write_killable(next);
+		if (err) {
+			/*
+			 * Override VMA_MERGE_NOMERGE to prevent callers from
+			 * falling back to a new VMA allocation.
+			 */
+			vmg->state = VMA_MERGE_ERROR_NOMEM;
+			return err;
+		}
 		err = dup_anon_vma(target, next, &anon_dup);
 		if (err)
 			return err;
@@ -1214,7 +1262,6 @@ int vma_expand(struct vma_merge_struct *vmg)
 	if (remove_next) {
 		vma_flags_t next_sticky;
 
-		vma_start_write(next);
 		vmg->__remove_next = true;
 
 		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
@@ -1252,9 +1299,14 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	       unsigned long start, unsigned long end, pgoff_t pgoff)
 {
 	struct vma_prepare vp;
+	int err;
 
 	WARN_ON((vma->vm_start != start) && (vma->vm_end != end));
 
+	err = vma_start_write_killable(vma);
+	if (err)
+		return err;
+
 	if (vma->vm_start < start)
 		vma_iter_config(vmi, vma->vm_start, start);
 	else
@@ -1263,8 +1315,6 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (vma_iter_prealloc(vmi, NULL))
 		return -ENOMEM;
 
-	vma_start_write(vma);
-
 	init_vma_prep(&vp, vma);
 	vma_prepare(&vp);
 	vma_adjust_trans_huge(vma, start, end, NULL);
@@ -1453,7 +1503,9 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 			if (error)
 				goto end_split_failed;
 		}
-		vma_start_write(next);
+		error = vma_start_write_killable(next);
+		if (error)
+			goto munmap_gather_failed;
 		mas_set(mas_detach, vms->vma_count++);
 		error = mas_store_gfp(mas_detach, next, GFP_KERNEL);
 		if (error)
@@ -1848,12 +1900,16 @@ static void vma_link_file(struct vm_area_struct *vma, bool hold_rmap_lock)
 static int vma_link(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	VMA_ITERATOR(vmi, mm, 0);
+	int err;
+
+	err = vma_start_write_killable(vma);
+	if (err)
+		return err;
 
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
 	if (vma_iter_prealloc(&vmi, vma))
 		return -ENOMEM;
 
-	vma_start_write(vma);
 	vma_iter_store_new(&vmi, vma);
 	vma_link_file(vma, /* hold_rmap_lock= */false);
 	mm->map_count++;
@@ -2239,9 +2295,8 @@ int mm_take_all_locks(struct mm_struct *mm)
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (signal_pending(current) || vma_start_write_killable(vma))
 			goto out_unlock;
-		vma_start_write(vma);
 	}
 
 	vma_iter_init(&vmi, mm, 0);
@@ -2540,8 +2595,8 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	struct mmap_action *action)
 {
 	struct vma_iterator *vmi = map->vmi;
-	int error = 0;
 	struct vm_area_struct *vma;
+	int error;
 
 	/*
 	 * Determine the object being mapped and call the appropriate
@@ -2552,6 +2607,14 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	if (!vma)
 		return -ENOMEM;
 
+	/*
+	 * Lock the VMA early to avoid extra work if fatal signal
+	 * is pending.
+	 */
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto free_vma;
+
 	vma_iter_config(vmi, map->addr, map->end);
 	vma_set_range(vma, map->addr, map->end, map->pgoff);
 	vma->flags = map->vma_flags;
@@ -2582,8 +2645,6 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
 	WARN_ON_ONCE(!arch_validate_flags(map->vm_flags));
 #endif
 
-	/* Lock the VMA since it is modified after insertion into VMA tree */
-	vma_start_write(vma);
 	vma_iter_store_new(vmi, vma);
 	map->mm->map_count++;
 	vma_link_file(vma, action->hide_from_rmap_until_complete);
@@ -2878,6 +2939,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		 unsigned long addr, unsigned long len, vma_flags_t vma_flags)
 {
 	struct mm_struct *mm = current->mm;
+	int err;
 
 	/*
 	 * Check against address space limits by the changed size
@@ -2910,24 +2972,33 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 		if (vma_merge_new_range(&vmg))
 			goto out;
-		else if (vmg_nomem(&vmg))
+		if (vmg_nomem(&vmg)) {
+			err = -ENOMEM;
 			goto unacct_fail;
+		}
 	}
 
 	if (vma)
 		vma_iter_next_range(vmi);
 	/* create a vma struct for an anonymous mapping */
 	vma = vm_area_alloc(mm);
-	if (!vma)
+	if (!vma) {
+		err = -ENOMEM;
 		goto unacct_fail;
+	}
 
 	vma_set_anonymous(vma);
 	vma_set_range(vma, addr, addr + len, addr >> PAGE_SHIFT);
 	vma->flags = vma_flags;
 	vma->vm_page_prot = vm_get_page_prot(vma_flags_to_legacy(vma_flags));
-	vma_start_write(vma);
-	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL))
+	if (vma_start_write_killable(vma)) {
+		err = -EINTR;
+		goto vma_lock_fail;
+	}
+	if (vma_iter_store_gfp(vmi, vma, GFP_KERNEL)) {
+		err = -ENOMEM;
 		goto mas_store_fail;
+	}
 
 	mm->map_count++;
 	validate_mm(mm);
@@ -2942,10 +3013,11 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	return 0;
 
 mas_store_fail:
+vma_lock_fail:
 	vm_area_free(vma);
 unacct_fail:
 	vm_unacct_memory(len >> PAGE_SHIFT);
-	return -ENOMEM;
+	return err;
 }
 
 /**
@@ -3112,8 +3184,8 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next;
 	unsigned long gap_addr;
-	int error = 0;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
+	int error;
 
 	if (!vma_test(vma, VMA_GROWSUP_BIT))
 		return -EFAULT;
@@ -3149,12 +3221,14 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto vma_prep_fail;
 	}
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto vma_lock_fail;
 	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -3183,8 +3257,10 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	vma_iter_free(&vmi);
 	validate_mm(mm);
+vma_lock_fail:
+vma_prep_fail:
+	vma_iter_free(&vmi);
 	return error;
 }
 #endif /* CONFIG_STACK_GROWSUP */
@@ -3197,8 +3273,8 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *prev;
-	int error = 0;
 	VMA_ITERATOR(vmi, mm, vma->vm_start);
+	int error;
 
 	if (!vma_test(vma, VMA_GROWSDOWN_BIT))
 		return -EFAULT;
@@ -3228,12 +3304,14 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* We must make sure the anon_vma is allocated. */
 	if (unlikely(anon_vma_prepare(vma))) {
-		vma_iter_free(&vmi);
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto vma_prep_fail;
 	}
 
 	/* Lock the VMA before expanding to prevent concurrent page faults */
-	vma_start_write(vma);
+	error = vma_start_write_killable(vma);
+	if (error)
+		goto vma_lock_fail;
 	/* We update the anon VMA tree. */
 	anon_vma_lock_write(vma->anon_vma);
 
@@ -3263,8 +3341,10 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 		}
 	}
 	anon_vma_unlock_write(vma->anon_vma);
-	vma_iter_free(&vmi);
 	validate_mm(mm);
+vma_lock_fail:
+vma_prep_fail:
+	vma_iter_free(&vmi);
 	return error;
 }
 
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index 5cee8b7efa0f..8ddcc791d828 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -41,6 +41,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	struct vm_area_struct *next;
 	struct mmu_gather tlb;
 	PAGETABLE_MOVE(pmc, vma, vma, old_start, new_start, length);
+	int err;
 
 	BUG_ON(new_start > new_end);
 
@@ -56,8 +57,9 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 	 * cover the whole range: [new_start, old_end)
 	 */
 	vmg.target = vma;
-	if (vma_expand(&vmg))
-		return -ENOMEM;
+	err = vma_expand(&vmg);
+	if (err)
+		return err;
 
 	/*
 	 * move the page tables downwards, on failure we rely on
-- 
2.53.0.1018.g2bb0e51243-goog


