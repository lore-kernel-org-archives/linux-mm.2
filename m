Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD8BDC624C6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37BB46B0093; Mon,  2 Mar 2026 11:33:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FC496B0095; Mon,  2 Mar 2026 11:33:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BCE86B0096; Mon,  2 Mar 2026 11:33:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07EBF6B0093
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:33:25 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 89AD8139C51
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:24 +0000 (UTC)
X-FDA: 84501668328.30.8272F7A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2E1061A0015
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=POUneRu2;
	spf=pass (imf19.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772469202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RoJu2TZQJ6DUDvByKakWyLdyfBWLzd6QHY5e5dLWvAs=;
	b=hJtmJhtreZccZ5xTCLoGi+DW5cISEeGZGDcPVhtLM4kONCB7UrlFD3YoffyzZcU78F3thJ
	y9Iz1mMP0HMqh20bKp194OygtNV6YIaRzR2zUQiPoShebrTTTUHHCSkOSZGS25pk7P4Xrb
	Ay5SjrBt31JKA1NuE5GP9ydRD/zNLMI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=POUneRu2;
	spf=pass (imf19.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772469202; a=rsa-sha256;
	cv=none;
	b=AIC8rP3mtyHf4giUjWCmlKw3uzf07cBbOcqgLdI0U9eNn28XLq9gPFc5fzPxUNikHLWPLm
	jm06NX8q6dVXg/DVFgcIZZDfO4N6O+41r0VEE8ZpCDFKA1S36fXxTXeW1r3v3xLxxof4ir
	9UvM1/UUrPmNdN833NKQh46DKmXzNbI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772469202; x=1804005202;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gr/Rm/LmHwRqu0m9Cj42RM/GXccyftGf8yIDm0daZ4M=;
  b=POUneRu2jjEuFYt+S1RsLTv0hxC6rveLh9+NuqLI4S/ZUkcMMsepnTMd
   FLjSl02O7hVpLcGviioVoEENpCg5V6R15tdxf4i+v7eOXbrfBOu0KvhG9
   qHck7G9Wq8Juv8IoHXLndaJmhFMy43NvnP4JM/XPjZGkzKi5is4SblRzq
   mYbOOhHMVTjPzITuKCT1y2Ij+0uD8Tz2jufpHJrQ5PK+E38ZAcH2w3ROA
   nOhht0bkcM+59OsmcNIJQ0Ta9qOFofQjx37AHZslY1aiYZu1ncphuoaJp
   DNGNAaO8JkGDo+WulttJyYtbx/OY/C5oWBXWx/a+eKAgHQLesENkbll84
   Q==;
X-CSE-ConnectionGUID: 2KobnuD9SuqeDTa78fNiBw==
X-CSE-MsgGUID: /CBN0oonT8S5dOu2e8hWXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73447871"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73447871"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 08:33:21 -0800
X-CSE-ConnectionGUID: TpC3DWhCS0uNy94/GNPzYg==
X-CSE-MsgGUID: vuRGhG7cSu+atzC1e2EzwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255564537"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.81])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 08:33:19 -0800
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
Subject: [PATCH v2 4/4] drm/xe/userptr: Defer Waiting for TLB invalidation to the second pass if possible
Date: Mon,  2 Mar 2026 17:32:48 +0100
Message-ID: <20260302163248.105454-5-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
References: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m7npw3hm3anxzky8adwa3egrocsd6h8k
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E1061A0015
X-HE-Tag: 1772469202-258612
X-HE-Meta: U2FsdGVkX18Rgr3hUwpzSDba+7owXS2V0KVHQ2MJJyRFeYC4LDiTKyO6R3m+MMeN8/MhtcsSChA9Q1y/1IAWrUxkeo5CcgP24f8AQECtDZWuYv2fbSQFxhQ1f7nm3+UMxCB8fBa2spV70bU+gSryURPDU6lLk3sC+dh/fJB7TEgEsh5LDnpqBb9cTUqp39PAwiH46zBRHgposkr+sq1xgbIXehf7b7znGNCmDvlilXQ7MoKVUNdDm+vO2++fA6td64sELeSQA5MQvWjhohkmUw5rRLBtfSDjtWaDTrhxsMecH5Re1udNHRpGdYBfM/AZwLOqEYQpgBGM7AxCiKmrDEmmfqovi6VZc3YkKPzU7lr7utX3wcloNiHwTmqwrGb/WNWjaNYLqRSTAXIt7o/N78CK7ZUOexe8wyuy0M2sF1D4GGmZjSI3ccfGs4Z4PJa8bMHDSTQ4aIJls09CXrGW5RmsiJhPV6W0Tne/Q5MkoUdHgVVJdiiiOzgDD4wxESW6u1KxZpOgQZ7CVem0ThvqErcdJMhFSrOIGqO6gFL5PBMwCC+6rB8Bl89vJ1cX/FgHMn4vlTDiW355ZFSjFndvDHY5WBbP9pK/nTL87qfgtZQwxfFWyYCXqoSZNfh/vldvvjIBGu4nSEvEA7AR0vIvVvy+ai1bjHjEam+JhfurVkkc/E+QGGs9BYpJ5QydB3FI+ZLtVMvSe9AN4lv9OcxEQlX3O2hGzGPgacHZa9YlO6ktcDXB1SB78vUjRwYmnCX2a4yaWnIqjBMvPMf8pedHx/GaKYMEUueNb8aIcA6rVZt4r9Ti0uxHITtlJoDD+b49fdjQ8w25oh2azfPBdTau2451Q1vFWsd+oN1760Ek1yS7OlQRvgcE9h2Nz1cN+J5uzST72VikA4XwFKYb4PS7EHlCJLrYFpcTJzaF1djL/BF5qfqTHlNzne+PrvZWYorENecgREVSUdS31au3ged
 3YECLHXN
 Mav8tsu6pTygvGSO4mcWYzMBy6vCmRwfz0GohpZzGpSIERVxqF9Fh5L5B6yJcNeCZJ+tQUN66EpLgvbIWsox1MMtQHDgDGRluqiUO0iKM/ut4NRZuf4OgMgfReMyY1S7LfQMCX7iJR8JnHX9Yyvons6+JyJxgtdNtoB9KYqNKwAjeAefxwismzqLWZK+X2qTbSNWV6Eg5n84iINTuyFQ+18qdbP7Fb4tIshSqUf1wyjYDZZ8RYERx3c6X8nAWigACPGbDyUXMFk+TLN8=
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

Assisted-by: GitHub Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/xe/xe_userptr.c | 60 +++++++++++++++++++++++++++------
 drivers/gpu/drm/xe/xe_userptr.h | 18 ++++++++++
 drivers/gpu/drm/xe/xe_vm.c      | 38 ++++++++++++++++-----
 drivers/gpu/drm/xe/xe_vm.h      |  2 ++
 4 files changed, 99 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_userptr.c b/drivers/gpu/drm/xe/xe_userptr.c
index 440b0a79d16f..a62b796afb93 100644
--- a/drivers/gpu/drm/xe/xe_userptr.c
+++ b/drivers/gpu/drm/xe/xe_userptr.c
@@ -8,6 +8,7 @@
 
 #include <linux/mm.h>
 
+#include "xe_tlb_inval.h"
 #include "xe_trace_bo.h"
 
 /**
@@ -73,8 +74,8 @@ int xe_vma_userptr_pin_pages(struct xe_userptr_vma *uvma)
 				    &ctx);
 }
 
-static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma,
-				    bool is_deferred)
+static struct mmu_interval_notifier_finish *
+xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma, bool is_deferred)
 {
 	struct xe_userptr *userptr = &uvma->userptr;
 	struct xe_vma *vma = &uvma->vma;
@@ -84,12 +85,23 @@ static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvm
 	};
 	long err;
 
-	err = dma_resv_wait_timeout(xe_vm_resv(vm),
-				    DMA_RESV_USAGE_BOOKKEEP,
+	err = dma_resv_wait_timeout(xe_vm_resv(vm), DMA_RESV_USAGE_BOOKKEEP,
 				    false, MAX_SCHEDULE_TIMEOUT);
 	XE_WARN_ON(err <= 0);
 
 	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
+		if (!userptr->finish_inuse) {
+			/*
+			 * Defer the TLB wait to an extra pass so the caller
+			 * can pipeline TLB flushes across GPUs before waiting
+			 * on any of them.
+			 */
+			userptr->finish_inuse = true;
+			userptr->tlb_inval_submitted = true;
+			err = xe_vm_invalidate_vma_submit(vma, &userptr->inval_batch);
+			XE_WARN_ON(err);
+			return &userptr->finish;
+		}
 		err = xe_vm_invalidate_vma(vma);
 		XE_WARN_ON(err);
 	}
@@ -98,6 +110,24 @@ static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvm
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
+	xe_tlb_inval_batch_wait(&userptr->inval_batch);
+	userptr->tlb_inval_submitted = false;
+	userptr->finish_inuse = false;
+	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
+			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
 }
 
 static struct mmu_interval_notifier_finish *
@@ -141,13 +171,11 @@ xe_vma_userptr_invalidate_pass1(struct xe_vm *vm, struct xe_userptr_vma *uvma)
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
-
 	return &userptr->finish;
 }
 
@@ -193,7 +221,15 @@ static void xe_vma_userptr_invalidate_finish(struct mmu_interval_notifier_finish
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
@@ -231,7 +267,9 @@ void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
 
 	finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
 	if (finish)
-		xe_vma_userptr_do_inval(vm, uvma, true);
+		finish = xe_vma_userptr_do_inval(vm, uvma, true);
+	if (finish)
+		xe_vma_userptr_complete_tlb_inval(vm, uvma);
 }
 #endif
 
diff --git a/drivers/gpu/drm/xe/xe_userptr.h b/drivers/gpu/drm/xe/xe_userptr.h
index 4f42db61fd62..7477009651c2 100644
--- a/drivers/gpu/drm/xe/xe_userptr.h
+++ b/drivers/gpu/drm/xe/xe_userptr.h
@@ -14,6 +14,8 @@
 
 #include <drm/drm_gpusvm.h>
 
+#include "xe_tlb_inval_types.h"
+
 struct xe_vm;
 struct xe_vma;
 struct xe_userptr_vma;
@@ -63,6 +65,15 @@ struct xe_userptr {
 	 * Protected by @vm::svm.gpusvm.notifier_lock.
 	 */
 	struct mmu_interval_notifier_finish finish;
+
+	/**
+	 * @inval_batch: TLB invalidation batch for deferred completion.
+	 * Stores an in-flight TLB invalidation submitted during a two-pass
+	 * notifier so the wait can be deferred to a subsequent pass, allowing
+	 * multiple GPUs to be signalled before any of them are waited on.
+	 * Protected by @vm::svm.gpusvm.notifier_lock.
+	 */
+	struct xe_tlb_inval_batch inval_batch;
 	/**
 	 * @finish_inuse: Whether @finish is currently in use by an in-progress
 	 * two-pass invalidation.
@@ -70,6 +81,13 @@ struct xe_userptr {
 	 */
 	bool finish_inuse;
 
+	/**
+	 * @tlb_inval_submitted: Whether a TLB invalidation has been submitted
+	 * via @inval_batch and is pending completion.  When set, the next pass
+	 * must call xe_tlb_inval_batch_wait() before reusing @inval_batch.
+	 * Protected by @vm::svm.gpusvm.notifier_lock.
+	 */
+	bool tlb_inval_submitted;
 	/**
 	 * @initial_bind: user pointer has been bound at least once.
 	 * write: vm->svm.gpusvm.notifier_lock in read mode and vm->resv held.
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 7f29d2b2972d..fdad9329dfb4 100644
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
-	struct xe_tlb_inval_batch _batch;
 	struct xe_tile *tile;
 	u8 tile_mask = 0;
 	int ret = 0;
@@ -4023,14 +4026,33 @@ int xe_vm_invalidate_vma(struct xe_vma *vma)
 
 	ret = xe_tlb_inval_range_tilemask_submit(xe, xe_vma_vm(vma)->usm.asid,
 						 xe_vma_start(vma), xe_vma_end(vma),
-						 tile_mask, &_batch);
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
-		xe_tlb_inval_batch_wait(&_batch);
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


