Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E098DEC1448
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 13:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D0E86B0196; Tue,  3 Mar 2026 08:35:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7983E6B0197; Tue,  3 Mar 2026 08:35:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67CD26B019A; Tue,  3 Mar 2026 08:35:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 539286B0196
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:35:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 192461BEA7
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:35:01 +0000 (UTC)
X-FDA: 84504847602.28.EB17364
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id DFBF5100018
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:34:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cRUVTf+R;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=temperror (imf05.hostedemail.com: error in processing during lookup of thomas.hellstrom@linux.intel.com: DNS error) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772544899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=35sW0Q42lKDTo9ZJ3V1Pc4KCefBzSjPeCF/pS4LvR30=;
	b=knwiGkK5NOxHLEDWZwDcx1Hw5BhwyxcC2IzZ5435869QSu7Iu+6sm4Btz3JZa+z1Yy7a3X
	N9li+VtaiE4pE5RdWZJV5M433DTJSz3M5ty2YRp5slknjB9H9zUAv6eKI9jVvQXWoSSpQC
	qRJ6TYhaLr1r4L2KUNaRgp/emOBxu8Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772544899; a=rsa-sha256;
	cv=none;
	b=NuBHra6G7GnukIfcM9BEBIFohyVKKjNsuEUbBkQTeJVZXRvcwgGrowPiK725trAT1TThLB
	7HPQJkYGtvnvLwGBoAsnB6Sivfy/z0URjUpHjOuRENHvRN62f0Az4yRXf9UW3T9YVkU79W
	HHhC8hiTMeCmq63IraEFqCvGBy8QLwc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cRUVTf+R;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=temperror (imf05.hostedemail.com: error in processing during lookup of thomas.hellstrom@linux.intel.com: DNS error) smtp.mailfrom=thomas.hellstrom@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772544896; x=1804080896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YZGJmmNg3EbKAgIA+H7TuYjVTQlV24SE9m0GvRzjGaU=;
  b=cRUVTf+RUp/Nc/nH9/ueXtLLq7QMsAXzBzb5LgOPt1BQEpzD0g2R/rmq
   AVo9w3VaqzlrZ2QfXSUrPdwy9Oy8f8MSVsQ37ViwBCs8q4WK6r/SUawPi
   CNX48A704TTH2IM/MO3DpFZ+9/RGqUWhfRE0gL1+B/ufjPgaXTRsvAQQc
   qfchoqpZSwWWPIVRRy4bMvq6AZI2rax2/PISQcEm65fArsxWsG4BetNsv
   GnUiW47atd7iymVK3xuWVlSqqcKf9XK+qQUExbURd0t74Kw212H5ZZQNe
   6GA0hayEVORpxZgOM/YBTeL2y05Zt4PhWkvC9RY7TQzKj2nJuN4MdhU88
   g==;
X-CSE-ConnectionGUID: LGpzvSasRm2Ngv0UdmMERA==
X-CSE-MsgGUID: yksotQ+lQFqpgN2gylelFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="76179739"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="76179739"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 05:34:49 -0800
X-CSE-ConnectionGUID: CTywUC/CSf6JJ7FeTgPsDQ==
X-CSE-MsgGUID: kk11T8kIRSOKa8wVc7QN6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="217947927"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.243])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 05:34:46 -0800
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
Subject: [PATCH v3 2/4] drm/xe/userptr: Convert invalidation to two-pass MMU notifier
Date: Tue,  3 Mar 2026 14:34:07 +0100
Message-ID: <20260303133409.11609-3-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
References: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DFBF5100018
X-Stat-Signature: 7fcoywya69wdcsun6occ9c4zkx75y4db
X-Rspam-User: 
X-HE-Tag: 1772544895-795052
X-HE-Meta: U2FsdGVkX192DKMR4HO8ajEIoXB/GhvLecPR0yOY/lGo9qD/ImijxyNQKQ9n6CkJH+KwUIg/balGBL+LoSmfXwLF31K7iZKl5vagwIS11ZqIANqP8/UVvRLRPZv0B+MxdT9gHeW0JE5naTp+p/+Lx/5ACKQHLroTlryMsFD1y7rAL0oflV/wKVcBWutuI5RACntdDvHOWh11EVJbiEp3Bv0AIuNG+UJiRfTUDrcYXJ3aoUqhOGQrJ0M8H6RGLcEZ+VyLJE9jADM1G1IuERStmPRfaowYPhtz73SQlTJbkYQtpVDn0sFvcp10HYTmTMqs9plzC+7DYj85tlXQ9VycsrEheYeYKQBEfx7B5bIpcs2e6GuWeAW557phlMqDJrJ4pITKSkqdAy93hfW4imCFK2cemrlRF3D4XsPv80FFi8kQrPnhtXLNoh1s+UgM9BoF/9kiscJEOJYx5YV48D6OTTXvi0HymG2si3tsHfLVQ7y+PyO0EtUl9sqHvOMd8iCzgNrMKwAL7OLLQXRV7FG20HFcxScqN2R9mFlCahLfIpen7IyPEj0YDr0s1UbI476sZrPVWJ8SGRJT0AsY978fP4Lpiu/p8MjGLCTHYceXKVDCYov0Dhxj2/QwNHBcJUULKvhDZgZP8cnW/1KVp3gOUUDZpII6/RJDNpiLg7hJe0V0OOsPyZ/z400/3n+yeZp5PwpLOrBKC6prUyJrQyRS5ss13k3qJoIDK69O7b/7o12jFv25g2RiYAnTeadbhUH4f3LG0XMY+xejMcskYW4MzWHgwaXckE+GGS+g64S50aJ4bM2T0k1EIqOnh6IDqwHwXuA4punmeuYB6WvYWn2jdIHzgsrCg/aAKf+bEip6RLK4XkaSn37UaLFagozQv/BiH/R08WqyvNUhU4Ion733cXtgch2GuzfcUEPCTBXU9ra37ZrD2deA7o9Uc0V6obeFMF9A9CNcUMVdLgk3wil
 C3zEZT7M
 zD5Bizi8EtJfiNNmX2BF5OLv5Zw2zR49mtnaljxG03rIBYLW7g4k7dBsK8SNqgLIkntLpshXZpzThxXZFlNqP4Jxap2lMLe/4Q3L/PTecOiTDUpgeKtL0qyrV8MwrGpfPTfS+O04rgxmE8C/22ndHqI4MIQtHGu59H74w+v3/+fmhn7C6JaZdwcI+sfI1SqvRTNKoMOfZfdRB49Krk7lIx0PnJ/lH+YBUpYHBOwHFmf+6bSid6edD4uiRUL3bAO4izlHSuNjOkVZRlij6sfrPKNUrTGvxppti5VHMlC+yE75CGqKjPYIyKvnaz9zOK3EWwluxquUD4GDa49kzPeATZxSEdo9AEwhFoV4T1fzP7hxkp7FzKB+ek2c1c7j9YJe+KKAHyQj1E26/7kw=
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


