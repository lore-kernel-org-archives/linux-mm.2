Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4A8EF3092B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A8306B0093; Thu,  5 Mar 2026 04:39:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293976B0095; Thu,  5 Mar 2026 04:39:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0BA6B0096; Thu,  5 Mar 2026 04:39:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09F426B0093
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:39:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D255F1CC8F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:39:55 +0000 (UTC)
X-FDA: 84511512750.09.3A52F3E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id A7E0FC0009
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:39:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SFjC1BMj;
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772703593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3SaKpxlCDKw6H1x9g8N5UjI0STaCadPY1Y1EBhf4m4=;
	b=KdngHsNUzrjOWFlM5G8ZsS3UZ+WSYIJjXpkQCk8VmXbtZErSYsPhMms9xbzA5F7UFWuFwI
	pUUvc72RRSWZyXt2YQ8HXkUXm/4GgJY+jsAOBCwPEwIxc0XJO4lM0MTOsXhF1jVh4MMQiI
	GHaNrb/P9LmSCaHr+I4PSZP8D5LkQ4A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SFjC1BMj;
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772703593; a=rsa-sha256;
	cv=none;
	b=hA/eKCn72MEvnRzDl3NJdAwwoXe/cEAI096WkPQY0mk1hzW3dMFhdTQ3mnrA+XykL7obru
	okpZ7uoq07LoYYEY1w4lal62DQ6EsB/vsxQtVp0HtBdgZcMCj2KUN3GUDxGtsbUkJGmJJ4
	Aj4sNKp3/7t1Tb/dSk4mqVTPwCK5Hts=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772703594; x=1804239594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RxDfvkY1zjSBVKQEcXFdDHmfFd96afZzeTBuuwtsgrc=;
  b=SFjC1BMj32F1V1m7mMEcx2ye8IG9c88MY9PtHkCrhfKrCP+vZQWEuvuZ
   pIg79rz0PL5Fjddfu58u7uoQvFbGHCZn5RjGuXB+23i/WczLJO2v0+ieU
   fxsrgYdInKhezgOHT7J4IjiYY/e9/Lgus620QovR7JtVI2vEeKkiRZxSl
   5ot8auGYb3nDZhFt9EtXGgWXcehbjNzjqf4RyCzhgdAk/P/JePP1Otm9M
   pWTbQ2lSYKFwEV4MaPL8VE2tHg+Ga3UREzNUiK4wXPBdnen8t/MxqIjaf
   RAC1TchBUf59rjwnUhiNK8r8OIx/qvqsgNUIwy2g5nPmfezirxU16vtAO
   w==;
X-CSE-ConnectionGUID: 83Iy4POLRDqM8cU3k17/PQ==
X-CSE-MsgGUID: 6zhJtVC5SOWUY+9OEAzRJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="84870970"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="84870970"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:39:52 -0800
X-CSE-ConnectionGUID: jIoRPFlKQDGYcH4Yx7DLnw==
X-CSE-MsgGUID: jic1ah2sT26hBeUow8COVQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="214685012"
Received: from vpanait-mobl.ger.corp.intel.com (HELO fedora) ([10.245.244.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:39:48 -0800
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/4] drm/xe/userptr: Convert invalidation to two-pass MMU notifier
Date: Thu,  5 Mar 2026 10:39:07 +0100
Message-ID: <20260305093909.43623-3-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
References: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3s3a9detbr7185qqjswdybwzgze8fq6j
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: A7E0FC0009
X-HE-Tag: 1772703593-274089
X-HE-Meta: U2FsdGVkX19f/951R6miCSGBK/yPJub4NLrNUx54nJXXFG+ZSlszZ0m0uHs3qfQffSVFhrsN8NjZb6rQ1eV/VLGUnA+dA6qy8cDEV+aSIW2quVuY+UZxmfQdayNWb1A/+vpjTFxdxuu46vuOzIy6qAMra7fJXVOk2Du6rJErKpL+bfJasct8tLcAeuTWYrfTYDnyObYa2iVV9C6MBZmxlS9/5lwD7XZi0sZWERT1tDXzh7jomsTyTOoETpNlojSihrigiB+oR7VNCWc4UF+QoXpg4tmv017l+lBgL5m0egE3+y3y4fM9MYivBEzvWPtIL8qNsFTZfAdujZiDTdrWXddQ/08o9GcDD4zDe7gS6oKf9FksnV6zDvqkhHKdtLrydMeXDOVlLSQqY2xLXE+3+cCVuwbIqXYq9dRvSmj1fkB9x0HpAsbIdirN+tJZYVIahjDdVABA+G8cOXYucs2pcHt2wDlDH+pItimiROzM3ZiJ23B21/DfXwjdledvURX1uUN7WW22oaHMr7v1pJjYCdLqUbJYoJle+vM+XnTHmawNivr/QcrRR6HBAh5FU3vQbzTMtWaGf3T90nVyBp2d0aD7JrjP8A++onjLS+7gdOrp3Bo1snPR8morvAhGmLWY1ki390xu3I304gn8aT3jQf2HwMGCDGGR7mtQTrcfv3xwt9zhRPEd0zrc22no+DawKM/lwj+1Ay0aTZq6slXO9+nUpS7bLeMIf/WUE7nv5Qy2Qiobh053wp3IG1L7p2s47MzjxypM7OtJoPUOStpqeZ/d3z6QHNCDNnNIui2gRukSeBNTB0BKgbpv3Rv4qv1G5BCgBeMrH39iplIZKZTqNuOw8g7R25fp+N99AoRoPEb5fdN4HzWSeaZrsPF94wT9ou1JCltpcCfO7+Wn3kSdEVvuDFtbzDQ+Q8zhU6Tkzl2vJrZaxtjcY13jXkQddspfvXsNL1BRXjtOL3zolQS
 yJiZssd+
 Y8vwO13MQKG/qrlTMhRxpRoOKOJwN/3mfABvVlia4lT8N/9X7B6YsEn6RU/pSvHIUJi2LDBFcxKib/GnbFz8PN/3qnvpbSlTgRaooT5dr5vtV4xEEFMkp4kV/JqIjBONVrox1ykcEf625V9bx7GccF6CgFWtXbfzpN9Nld8a6PLhQtyIFb4CgbunGfdXaKnEU6hxbkD7MrySw/UB7FG43911Y2coqj3d6C93jLTZy3azDb+ycnTyNPp67YViJkPn3tAvW7eIbhaMyFH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In multi-GPU scenarios, asynchronous GPU job latency is a bottleneck if
each notifier waits for its own GPU before returning. The two-pass
mmu_interval_notifier infrastructure allows deferring the wait to a
second pass, so all GPUs can be signalled in the first pass before
any of them are waited on.

Convert the userptr invalidation to use the two-pass model:

Use invalidate_start as the first pass to mark the VMA for repin and
enable software signalling on the VM reservation fences to start any
gpu work needed for signaling. Fall back to completing the work
synchronously if all fences are already signalled, or if a concurrent
invalidation is already using the embedded finish structure.

Use invalidate_finish as the second pass to wait for the reservation
fences to complete, invalidate the GPU TLB in fault mode, and unmap
the gpusvm pages.

Embed a struct mmu_interval_notifier_finish in struct xe_userptr to
avoid dynamic allocation in the notifier callback. Use a finish_inuse
flag to prevent two concurrent invalidations from using it
simultaneously; fall back to the synchronous path for the second caller.

v3:
- Add locking asserts in notifier components (Matt Brost)
- Clean up newlines (Matt Brost)
- Update the userptr notifier state member locking documentation
  (Matt Brost)

Assisted-by: GitHub Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/xe/xe_userptr.c | 108 +++++++++++++++++++++++++-------
 drivers/gpu/drm/xe/xe_userptr.h |  14 ++++-
 2 files changed, 99 insertions(+), 23 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_userptr.c b/drivers/gpu/drm/xe/xe_userptr.c
index e120323c43bc..37032b8125a6 100644
--- a/drivers/gpu/drm/xe/xe_userptr.c
+++ b/drivers/gpu/drm/xe/xe_userptr.c
@@ -10,6 +10,14 @@
 
 #include "xe_trace_bo.h"
 
+static void xe_userptr_assert_in_notifier(struct xe_vm *vm)
+{
+	lockdep_assert(lockdep_is_held_type(&vm->svm.gpusvm.notifier_lock, 0) ||
+		       (lockdep_is_held(&vm->lock) &&
+			lockdep_is_held_type(&vm->svm.gpusvm.notifier_lock, 1) &&
+			dma_resv_held(xe_vm_resv(vm))));
+}
+
 /**
  * xe_vma_userptr_check_repin() - Advisory check for repin needed
  * @uvma: The userptr vma
@@ -73,18 +81,46 @@ int xe_vma_userptr_pin_pages(struct xe_userptr_vma *uvma)
 				    &ctx);
 }
 
-static void __vma_userptr_invalidate(struct xe_vm *vm, struct xe_userptr_vma *uvma)
+static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma,
+				    bool is_deferred)
 {
 	struct xe_userptr *userptr = &uvma->userptr;
 	struct xe_vma *vma = &uvma->vma;
-	struct dma_resv_iter cursor;
-	struct dma_fence *fence;
 	struct drm_gpusvm_ctx ctx = {
 		.in_notifier = true,
 		.read_only = xe_vma_read_only(vma),
 	};
 	long err;
 
+	xe_userptr_assert_in_notifier(vm);
+
+	err = dma_resv_wait_timeout(xe_vm_resv(vm),
+				    DMA_RESV_USAGE_BOOKKEEP,
+				    false, MAX_SCHEDULE_TIMEOUT);
+	XE_WARN_ON(err <= 0);
+
+	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
+		err = xe_vm_invalidate_vma(vma);
+		XE_WARN_ON(err);
+	}
+
+	if (is_deferred)
+		userptr->finish_inuse = false;
+	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
+			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
+}
+
+static struct mmu_interval_notifier_finish *
+xe_vma_userptr_invalidate_pass1(struct xe_vm *vm, struct xe_userptr_vma *uvma)
+{
+	struct xe_userptr *userptr = &uvma->userptr;
+	struct xe_vma *vma = &uvma->vma;
+	struct dma_resv_iter cursor;
+	struct dma_fence *fence;
+	bool signaled = true;
+
+	xe_userptr_assert_in_notifier(vm);
+
 	/*
 	 * Tell exec and rebind worker they need to repin and rebind this
 	 * userptr.
@@ -105,27 +141,32 @@ static void __vma_userptr_invalidate(struct xe_vm *vm, struct xe_userptr_vma *uv
 	 */
 	dma_resv_iter_begin(&cursor, xe_vm_resv(vm),
 			    DMA_RESV_USAGE_BOOKKEEP);
-	dma_resv_for_each_fence_unlocked(&cursor, fence)
+	dma_resv_for_each_fence_unlocked(&cursor, fence) {
 		dma_fence_enable_sw_signaling(fence);
+		if (signaled && !dma_fence_is_signaled(fence))
+			signaled = false;
+	}
 	dma_resv_iter_end(&cursor);
 
-	err = dma_resv_wait_timeout(xe_vm_resv(vm),
-				    DMA_RESV_USAGE_BOOKKEEP,
-				    false, MAX_SCHEDULE_TIMEOUT);
-	XE_WARN_ON(err <= 0);
-
-	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
-		err = xe_vm_invalidate_vma(vma);
-		XE_WARN_ON(err);
+	/*
+	 * Only one caller at a time can use the multi-pass state.
+	 * If it's already in use, or all fences are already signaled,
+	 * proceed directly to invalidation without deferring.
+	 */
+	if (signaled || userptr->finish_inuse) {
+		xe_vma_userptr_do_inval(vm, uvma, false);
+		return NULL;
 	}
 
-	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
-			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
+	userptr->finish_inuse = true;
+
+	return &userptr->finish;
 }
 
-static bool vma_userptr_invalidate(struct mmu_interval_notifier *mni,
-				   const struct mmu_notifier_range *range,
-				   unsigned long cur_seq)
+static bool xe_vma_userptr_invalidate_start(struct mmu_interval_notifier *mni,
+					    const struct mmu_notifier_range *range,
+					    unsigned long cur_seq,
+					    struct mmu_interval_notifier_finish **p_finish)
 {
 	struct xe_userptr_vma *uvma = container_of(mni, typeof(*uvma), userptr.notifier);
 	struct xe_vma *vma = &uvma->vma;
@@ -138,21 +179,40 @@ static bool vma_userptr_invalidate(struct mmu_interval_notifier *mni,
 		return false;
 
 	vm_dbg(&xe_vma_vm(vma)->xe->drm,
-	       "NOTIFIER: addr=0x%016llx, range=0x%016llx",
+	       "NOTIFIER PASS1: addr=0x%016llx, range=0x%016llx",
 		xe_vma_start(vma), xe_vma_size(vma));
 
 	down_write(&vm->svm.gpusvm.notifier_lock);
 	mmu_interval_set_seq(mni, cur_seq);
 
-	__vma_userptr_invalidate(vm, uvma);
+	*p_finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
+
 	up_write(&vm->svm.gpusvm.notifier_lock);
-	trace_xe_vma_userptr_invalidate_complete(vma);
+	if (!*p_finish)
+		trace_xe_vma_userptr_invalidate_complete(vma);
 
 	return true;
 }
 
+static void xe_vma_userptr_invalidate_finish(struct mmu_interval_notifier_finish *finish)
+{
+	struct xe_userptr_vma *uvma = container_of(finish, typeof(*uvma), userptr.finish);
+	struct xe_vma *vma = &uvma->vma;
+	struct xe_vm *vm = xe_vma_vm(vma);
+
+	vm_dbg(&xe_vma_vm(vma)->xe->drm,
+	       "NOTIFIER PASS2: addr=0x%016llx, range=0x%016llx",
+		xe_vma_start(vma), xe_vma_size(vma));
+
+	down_write(&vm->svm.gpusvm.notifier_lock);
+	xe_vma_userptr_do_inval(vm, uvma, true);
+	up_write(&vm->svm.gpusvm.notifier_lock);
+	trace_xe_vma_userptr_invalidate_complete(vma);
+}
+
 static const struct mmu_interval_notifier_ops vma_userptr_notifier_ops = {
-	.invalidate = vma_userptr_invalidate,
+	.invalidate_start = xe_vma_userptr_invalidate_start,
+	.invalidate_finish = xe_vma_userptr_invalidate_finish,
 };
 
 #if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
@@ -164,6 +224,7 @@ static const struct mmu_interval_notifier_ops vma_userptr_notifier_ops = {
  */
 void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
 {
+	static struct mmu_interval_notifier_finish *finish;
 	struct xe_vm *vm = xe_vma_vm(&uvma->vma);
 
 	/* Protect against concurrent userptr pinning */
@@ -179,7 +240,10 @@ void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
 	if (!mmu_interval_read_retry(&uvma->userptr.notifier,
 				     uvma->userptr.pages.notifier_seq))
 		uvma->userptr.pages.notifier_seq -= 2;
-	__vma_userptr_invalidate(vm, uvma);
+
+	finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
+	if (finish)
+		xe_vma_userptr_do_inval(vm, uvma, true);
 }
 #endif
 
diff --git a/drivers/gpu/drm/xe/xe_userptr.h b/drivers/gpu/drm/xe/xe_userptr.h
index ef801234991e..e1830c2f5fd2 100644
--- a/drivers/gpu/drm/xe/xe_userptr.h
+++ b/drivers/gpu/drm/xe/xe_userptr.h
@@ -56,7 +56,19 @@ struct xe_userptr {
 	 * @notifier: MMU notifier for user pointer (invalidation call back)
 	 */
 	struct mmu_interval_notifier notifier;
-
+	/**
+	 * @finish: MMU notifier finish structure for two-pass invalidation.
+	 * Embedded here to avoid allocation in the notifier callback.
+	 * Protected by struct xe_vm::svm.gpusvm.notifier_lock in write mode
+	 * alternatively by the same lock in read mode *and* the vm resv held.
+	 */
+	struct mmu_interval_notifier_finish finish;
+	/**
+	 * @finish_inuse: Whether @finish is currently in use by an in-progress
+	 * two-pass invalidation.
+	 * Protected using the same locking as @finish.
+	 */
+	bool finish_inuse;
 	/**
 	 * @initial_bind: user pointer has been bound at least once.
 	 * write: vm->svm.gpusvm.notifier_lock in read mode and vm->resv held.
-- 
2.53.0


