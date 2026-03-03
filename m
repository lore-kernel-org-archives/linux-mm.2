Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB473EC1449
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 13:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7841D6B019A; Tue,  3 Mar 2026 08:35:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7A76B019C; Tue,  3 Mar 2026 08:35:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA926B01A1; Tue,  3 Mar 2026 08:35:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA146B019A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:35:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E02DE88438
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:35:02 +0000 (UTC)
X-FDA: 84504847644.02.A764AC3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf19.hostedemail.com (Postfix) with ESMTP id A27D31A0016
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:35:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G31lWFn4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=temperror (imf19.hostedemail.com: error in processing during lookup of thomas.hellstrom@linux.intel.com: DNS error) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772544900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tolCzwpMlAmQ396BXXvTtYSsJsJXI257WuwUMbaQpCw=;
	b=FPqpYt9DwXiR3MKLJLS5iBR4XVpbPoyv9UkBkXQLCIOmgJlhNcgzC5Oi7B3lHGdlvGWVyT
	g3jCYcQy0ULE0POGgnm/6G7yIbtQZCkVVt+NeRY4qHcLbSDXmixiFs0qoC0DPqzpJQT8bM
	YnJHLrt1Xd0kFSETsikUqdo/3h8ctk4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G31lWFn4;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=temperror (imf19.hostedemail.com: error in processing during lookup of thomas.hellstrom@linux.intel.com: DNS error) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772544900; a=rsa-sha256;
	cv=none;
	b=VKw9Bdt70ficdzshYf1f6nycrUoCaoJgmK0Ig5hWH76rAh7gtD2RRN4w3xi++w2fXKPUZV
	QyBAuk2uEOtck5HYewVf/zY35JFU3PeA2z91qNYf90Fhu09vmeHnYMadjiJE9N+Vu176zy
	TMw8I4FYgk0/KVIh2az6sgtN10zuWI0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772544901; x=1804080901;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sDKpKGZ7zZ94WyscCZ4Mby+dM5br8h1NdshW6OVYBAI=;
  b=G31lWFn4xRVh7HVpW3iiAV7yjwwbfYc1Ejvr5oeC6P9I1cRCpHct2uu3
   Qm0BQaleYpLnlWV/EfFiN+FgqCPjAE7spzwpW6SAITb6GPs6OYt+1k4uJ
   tgGXowaJTTGgS0pqrqthBRJmYrEnd7lWjTlXXa6GebZOQegFNNDuk1TYK
   NzhNBAdZ90svKy5UiLVhIeMGPfdr82yGD1okAM6bRvzEKrfU0Mk7eJAT+
   6l9VHnZDTfqBW/vvlkxClYfSOvUzoEWhi24W/BHwkRg7ruo/0kEuaGA72
   CGq75/nfE1vkScL0AU56K0imD4M1OQO1bQaar26K2+PMiumnd8NPUVzVw
   g==;
X-CSE-ConnectionGUID: 6Ni9bmVVSGqvXG6CGtJ7Xg==
X-CSE-MsgGUID: MZg25OKLQWWessdvkYliKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="76179769"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="76179769"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 05:34:55 -0800
X-CSE-ConnectionGUID: xlb+CNX+Q4u9lSUNKXHLIg==
X-CSE-MsgGUID: //CKb90nTSa1x3VPdQ3oDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="217947945"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.243])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 05:34:52 -0800
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] drm/xe/userptr: Defer Waiting for TLB invalidation to the second pass if possible
Date: Tue,  3 Mar 2026 14:34:09 +0100
Message-ID: <20260303133409.11609-5-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
References: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A27D31A0016
X-Stat-Signature: hs9why5j9uqzzfbbmnuksh4x6d9q89ns
X-Rspam-User: 
X-HE-Tag: 1772544900-583080
X-HE-Meta: U2FsdGVkX18bDi+GpODEoYj+tfgqzlNE+lNBkt10K/gWF5u7pQ7lVchWuCzcU56zFk9P/FPFj4azHYbbHd8E762z7mDMqgw3RjfGY4u0yjWiB8WOGupvOQtvm/5vLE6fe1EdGG7QRH+cl/OrfXF/Xe5x8D73DtERnfnqwD2ezp0zoCTvURnD/b5yZ42r9FJmzw99RIdxncgTrppgMpx4zai2eqXDkLC2IYsrzZL6m+EKTmzGi5sRPTKO7KlGENpx42/AzWIz0uuWs4KpZ1iwzNXrKKU8KwptY65AIlAhwPE8zDblJru0jOVNo5ZnQFwz/rZJ5IzvmX18RMvsVqvphEr/dN5znHjY9J9A0GJBydvkBzyUaj6PETY2/SzI4aIvl1PULAijtCmR/hYKIXU1a/LgYRg9EKD9x6jLa31ZnkNYn7vcD9cHgIHPUAGtNK1jY4au7Tp8JSd2dooBqYmu5xBpwXNNZDoberLgxaRMZIk3AxbuxvFwclV5Z4BQ2QKpFnrmBq7FXjll/OxE8GXDWuV5AZJOi68QEWHBfuvY9HEZrWOvXWgb2wXgtHtdQqhfF7zt85g4EoHf/HPlJH+rg2WD11nSdWHSFbdqYkAzLl5TRU9Y5uIh7jhWOceoBVfSpUJoSOSYPTZ2oKtjCflzt3bLC3EDKh2edqWC3Qy0uxcurx9WLwKUfE1HIM/aylgyh/LpuZUXy48D2LjGgdtHmiy9AtCctltdJ7bvYxN0nRw+vao2ahMMspxVhVgZihkBetQ13Hg7m7YHjbcR2Pqja4p8DscqNmP6QMj9ZzNV4hhcMLheY2oVNe88PesYXRweI5ipS5qn9l1Ouw8yEVEfmbAKS3FpZSonpF/+IugftSLevVfFzZ2wM8rixpWPQopIjRGkD7Rhlte8CtEWvhhdDRU2ZMv0EL4npfLrSmtRmsKxbQ81XO8tiAldXb0h4WrZutPz4bhQKb5yjWJHvsN
 Nf943Unp
 QEjcG1MqE8iMob0dQRW2jQxsjcPywQma7GIt88HEiMH9rpyw1xhnKiyNdcrA47ppbWr5aJy3NhhxVa8GQPNmXKa6JlLPSkmgc/NTnPS+CEdRfw+XziCkdw/YYtlVAAhDguVpSozBgfMBx/CupRm7tDZlpzA5uPP5Q9e4OMBURvvKHiRm7rTcP/0Lg6Qkm8/HVL728qE6jlzrR46NqaKeoYOe6ME9MalB7/92pAnX7b/dEtcvQgGqFOenW552hscPyZgHU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the two-pass notifier flow uses xe_vma_userptr_do_inval() for
the fence-wait + TLB-invalidate work, extend it to support a further
deferred TLB wait:

- xe_vma_userptr_do_inval(): when the embedded finish handle is free,
  submit the TLB invalidation asynchronously (xe_vm_invalidate_vma_submit)
  and return &userptr->finish so the mmu_notifier core schedules a third
  pass.  When the handle is occupied by a concurrent invalidation, fall
  back to the synchronous xe_vm_invalidate_vma() path.

- xe_vma_userptr_complete_tlb_inval(): new helper called from
  invalidate_finish when tlb_inval_submitted is set.  Waits for the
  previously submitted batch and unmaps the gpusvm pages.

xe_vma_userptr_invalidate_finish() dispatches between the two helpers
via tlb_inval_submitted, making the three possible flows explicit:

  pass1 (fences pending)  -> invalidate_finish -> do_inval (sync TLB)
  pass1 (fences done)     -> do_inval -> invalidate_finish
                          -> complete_tlb_inval (deferred TLB)
  pass1 (finish occupied) -> do_inval (sync TLB, inline)

In multi-GPU scenarios this allows TLB flushes to be submitted on all
GPUs in one pass before any of them are waited on.

Also adds xe_vm_invalidate_vma_submit() which submits the TLB range
invalidation without blocking, populating a xe_tlb_inval_batch that
the caller waits on separately.

v3:
- Add locking asserts and notifier state asserts (Matt Brost)
- Update the locking documentation of the notifier
  state members (Matt Brost)
- Remove unrelated code formatting changes (Matt Brost)

Assisted-by: GitHub Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/xe/xe_userptr.c | 63 ++++++++++++++++++++++++++++-----
 drivers/gpu/drm/xe/xe_userptr.h | 17 +++++++++
 drivers/gpu/drm/xe/xe_vm.c      | 38 +++++++++++++++-----
 drivers/gpu/drm/xe/xe_vm.h      |  2 ++
 4 files changed, 104 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_userptr.c b/drivers/gpu/drm/xe/xe_userptr.c
index 37032b8125a6..6761005c0b90 100644
--- a/drivers/gpu/drm/xe/xe_userptr.c
+++ b/drivers/gpu/drm/xe/xe_userptr.c
@@ -8,6 +8,7 @@
 
 #include <linux/mm.h>
 
+#include "xe_tlb_inval.h"
 #include "xe_trace_bo.h"
 
 static void xe_userptr_assert_in_notifier(struct xe_vm *vm)
@@ -81,8 +82,8 @@ int xe_vma_userptr_pin_pages(struct xe_userptr_vma *uvma)
 				    &ctx);
 }
 
-static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma,
-				    bool is_deferred)
+static struct mmu_interval_notifier_finish *
+xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma, bool is_deferred)
 {
 	struct xe_userptr *userptr = &uvma->userptr;
 	struct xe_vma *vma = &uvma->vma;
@@ -93,6 +94,8 @@ static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvm
 	long err;
 
 	xe_userptr_assert_in_notifier(vm);
+	if (is_deferred)
+		xe_assert(vm->xe, userptr->finish_inuse && !userptr->tlb_inval_submitted);
 
 	err = dma_resv_wait_timeout(xe_vm_resv(vm),
 				    DMA_RESV_USAGE_BOOKKEEP,
@@ -100,6 +103,19 @@ static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvm
 	XE_WARN_ON(err <= 0);
 
 	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
+		if (!userptr->finish_inuse) {
+			/*
+			 * Defer the TLB wait to an extra pass so the caller
+			 * can pipeline TLB flushes across GPUs before waiting
+			 * on any of them.
+			 */
+			xe_assert(vm->xe, !userptr->tlb_inval_submitted);
+			userptr->finish_inuse = true;
+			userptr->tlb_inval_submitted = true;
+			err = xe_vm_invalidate_vma_submit(vma, &userptr->inval_batch);
+			XE_WARN_ON(err);
+			return &userptr->finish;
+		}
 		err = xe_vm_invalidate_vma(vma);
 		XE_WARN_ON(err);
 	}
@@ -108,6 +124,28 @@ static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvm
 		userptr->finish_inuse = false;
 	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
 			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
+	return NULL;
+}
+
+static void
+xe_vma_userptr_complete_tlb_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma)
+{
+	struct xe_userptr *userptr = &uvma->userptr;
+	struct xe_vma *vma = &uvma->vma;
+	struct drm_gpusvm_ctx ctx = {
+		.in_notifier = true,
+		.read_only = xe_vma_read_only(vma),
+	};
+
+	xe_userptr_assert_in_notifier(vm);
+	xe_assert(vm->xe, userptr->finish_inuse);
+	xe_assert(vm->xe, userptr->tlb_inval_submitted);
+
+	xe_tlb_inval_batch_wait(&userptr->inval_batch);
+	userptr->tlb_inval_submitted = false;
+	userptr->finish_inuse = false;
+	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
+			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
 }
 
 static struct mmu_interval_notifier_finish *
@@ -153,11 +191,10 @@ xe_vma_userptr_invalidate_pass1(struct xe_vm *vm, struct xe_userptr_vma *uvma)
 	 * If it's already in use, or all fences are already signaled,
 	 * proceed directly to invalidation without deferring.
 	 */
-	if (signaled || userptr->finish_inuse) {
-		xe_vma_userptr_do_inval(vm, uvma, false);
-		return NULL;
-	}
+	if (signaled || userptr->finish_inuse)
+		return xe_vma_userptr_do_inval(vm, uvma, false);
 
+	/* Defer: the notifier core will call invalidate_finish once done. */
 	userptr->finish_inuse = true;
 
 	return &userptr->finish;
@@ -205,7 +242,15 @@ static void xe_vma_userptr_invalidate_finish(struct mmu_interval_notifier_finish
 		xe_vma_start(vma), xe_vma_size(vma));
 
 	down_write(&vm->svm.gpusvm.notifier_lock);
-	xe_vma_userptr_do_inval(vm, uvma, true);
+	/*
+	 * If a TLB invalidation was previously submitted (deferred from the
+	 * synchronous pass1 fallback), wait for it and unmap pages.
+	 * Otherwise, fences have now completed: invalidate the TLB and unmap.
+	 */
+	if (uvma->userptr.tlb_inval_submitted)
+		xe_vma_userptr_complete_tlb_inval(vm, uvma);
+	else
+		xe_vma_userptr_do_inval(vm, uvma, true);
 	up_write(&vm->svm.gpusvm.notifier_lock);
 	trace_xe_vma_userptr_invalidate_complete(vma);
 }
@@ -243,7 +288,9 @@ void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
 
 	finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
 	if (finish)
-		xe_vma_userptr_do_inval(vm, uvma, true);
+		finish = xe_vma_userptr_do_inval(vm, uvma, true);
+	if (finish)
+		xe_vma_userptr_complete_tlb_inval(vm, uvma);
 }
 #endif
 
diff --git a/drivers/gpu/drm/xe/xe_userptr.h b/drivers/gpu/drm/xe/xe_userptr.h
index e1830c2f5fd2..2a3cd1b5efbb 100644
--- a/drivers/gpu/drm/xe/xe_userptr.h
+++ b/drivers/gpu/drm/xe/xe_userptr.h
@@ -14,6 +14,8 @@
 
 #include <drm/drm_gpusvm.h>
 
+#include "xe_tlb_inval_types.h"
+
 struct xe_vm;
 struct xe_vma;
 struct xe_userptr_vma;
@@ -63,12 +65,27 @@ struct xe_userptr {
 	 * alternatively by the same lock in read mode *and* the vm resv held.
 	 */
 	struct mmu_interval_notifier_finish finish;
+	/**
+	 * @inval_batch: TLB invalidation batch for deferred completion.
+	 * Stores an in-flight TLB invalidation submitted during a two-pass
+	 * notifier so the wait can be deferred to a subsequent pass, allowing
+	 * multiple GPUs to be signalled before any of them are waited on.
+	 * Protected using the same locking as @finish.
+	 */
+	struct xe_tlb_inval_batch inval_batch;
 	/**
 	 * @finish_inuse: Whether @finish is currently in use by an in-progress
 	 * two-pass invalidation.
 	 * Protected using the same locking as @finish.
 	 */
 	bool finish_inuse;
+	/**
+	 * @tlb_inval_submitted: Whether a TLB invalidation has been submitted
+	 * via @inval_batch and is pending completion.  When set, the next pass
+	 * must call xe_tlb_inval_batch_wait() before reusing @inval_batch.
+	 * Protected using the same locking as @finish.
+	 */
+	bool tlb_inval_submitted;
 	/**
 	 * @initial_bind: user pointer has been bound at least once.
 	 * write: vm->svm.gpusvm.notifier_lock in read mode and vm->resv held.
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index a3c2e8cefec7..fdad9329dfb4 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3967,20 +3967,23 @@ void xe_vm_unlock(struct xe_vm *vm)
 }
 
 /**
- * xe_vm_invalidate_vma - invalidate GPU mappings for VMA without a lock
+ * xe_vm_invalidate_vma_submit - Submit a job to invalidate GPU mappings for
+ * VMA.
  * @vma: VMA to invalidate
+ * @batch: TLB invalidation batch to populate; caller must later call
+ *         xe_tlb_inval_batch_wait() on it to wait for completion
  *
  * Walks a list of page tables leaves which it memset the entries owned by this
- * VMA to zero, invalidates the TLBs, and block until TLBs invalidation is
- * complete.
+ * VMA to zero, invalidates the TLBs, but doesn't block waiting for TLB flush
+ * to complete, but instead populates @batch which can be waited on using
+ * xe_tlb_inval_batch_wait().
  *
  * Returns 0 for success, negative error code otherwise.
  */
-int xe_vm_invalidate_vma(struct xe_vma *vma)
+int xe_vm_invalidate_vma_submit(struct xe_vma *vma, struct xe_tlb_inval_batch *batch)
 {
 	struct xe_device *xe = xe_vma_vm(vma)->xe;
 	struct xe_vm *vm = xe_vma_vm(vma);
-	struct xe_tlb_inval_batch batch;
 	struct xe_tile *tile;
 	u8 tile_mask = 0;
 	int ret = 0;
@@ -4023,14 +4026,33 @@ int xe_vm_invalidate_vma(struct xe_vma *vma)
 
 	ret = xe_tlb_inval_range_tilemask_submit(xe, xe_vma_vm(vma)->usm.asid,
 						 xe_vma_start(vma), xe_vma_end(vma),
-						 tile_mask, &batch);
+						 tile_mask, batch);
 
 	/* WRITE_ONCE pairs with READ_ONCE in xe_vm_has_valid_gpu_mapping() */
 	WRITE_ONCE(vma->tile_invalidated, vma->tile_mask);
+	return ret;
+}
+
+/**
+ * xe_vm_invalidate_vma - invalidate GPU mappings for VMA without a lock
+ * @vma: VMA to invalidate
+ *
+ * Walks a list of page tables leaves which it memset the entries owned by this
+ * VMA to zero, invalidates the TLBs, and block until TLBs invalidation is
+ * complete.
+ *
+ * Returns 0 for success, negative error code otherwise.
+ */
+int xe_vm_invalidate_vma(struct xe_vma *vma)
+{
+	struct xe_tlb_inval_batch batch;
+	int ret;
 
-	if (!ret)
-		xe_tlb_inval_batch_wait(&batch);
+	ret = xe_vm_invalidate_vma_submit(vma, &batch);
+	if (ret)
+		return ret;
 
+	xe_tlb_inval_batch_wait(&batch);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_vm.h b/drivers/gpu/drm/xe/xe_vm.h
index 62f4b6fec0bc..0bc7ed23eeae 100644
--- a/drivers/gpu/drm/xe/xe_vm.h
+++ b/drivers/gpu/drm/xe/xe_vm.h
@@ -242,6 +242,8 @@ struct dma_fence *xe_vm_range_unbind(struct xe_vm *vm,
 
 int xe_vm_invalidate_vma(struct xe_vma *vma);
 
+int xe_vm_invalidate_vma_submit(struct xe_vma *vma, struct xe_tlb_inval_batch *batch);
+
 int xe_vm_validate_protected(struct xe_vm *vm);
 
 static inline void xe_vm_queue_rebind_worker(struct xe_vm *vm)
-- 
2.53.0


