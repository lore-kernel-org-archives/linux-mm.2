Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B95BF3092B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121B76B0098; Thu,  5 Mar 2026 04:40:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D316B0099; Thu,  5 Mar 2026 04:40:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F27AB6B009B; Thu,  5 Mar 2026 04:40:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E3C6A6B0098
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:40:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8ADA716065F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:40:03 +0000 (UTC)
X-FDA: 84511513086.16.2B3D18D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id 40ED7C000A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:40:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="gkA5t/NU";
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772703601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BKq8pDAHjO9GsAf48I1Jml4Vimj7MsJyIsdVC0GaiU4=;
	b=bC2KUm+w6TK9wZV6hNHsuQNLYLDYjT8sEC/n/9BkOTt6HjzWptDuANjD3MFeCXPMn2Aa9s
	/TkYMdrq+rXu4sAmndN/7lcZ8mM9TBDa4buKm0d7sbgpTgJQP3OkD7VWoRF5BGakulFXX8
	RAcFquNY8+cZZ5HoUJLtjBdh7dcEhvQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="gkA5t/NU";
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772703601; a=rsa-sha256;
	cv=none;
	b=jPOTADNmFzbhktkQRKQYP+5fXdGTHmZ/nmYA3wu1HdIPat0oG5AtE5Xddh7kF82driaYJF
	SqCAXxyE/eoDRcjCxhQz2ZEHYnoll8GNaXIUN5XwWCC3Pz2XqkAwIc+bHNeaO7EBcWdGkb
	JFtJeRmCUInRsojjz+qwpR0V6KlR6vc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772703601; x=1804239601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EkW2TPya80geCG27da7LAu868d+oGPxc6iUTc9tfTpc=;
  b=gkA5t/NUlABWk7kGkY6ME5H15/3LtDEyK4PoSSN4IUn5woQ4lpY+3mGX
   +RA5HH5OzrIi2FPAf4PFPmG2n+DShze1DMOuhX8a6fBbOV1MErHlGBJa7
   Kt1pUQOthXC5uWcXEC3ffH4M9p4xaQLy1NJWR4wDXhtE9ryi9ZR7qzshA
   6ZwBFjnq6O2sIRgyIps/8jyfCyvJyDlqiUwgJ3wzJAaqxJpNiEb7Fags3
   PK2ijjDK8x4y1iby8m14E5hymRD0yrCzuA+XXX7egYSistfctAUpijT/P
   Y/t3+iqX0L8kK6UaRCc7n7oX/tCOJQ7Qg4ytA08yMvAwMgcb7065O3VYE
   Q==;
X-CSE-ConnectionGUID: 3MYUhzIQSi6K5TdiMKAecQ==
X-CSE-MsgGUID: KI+Yxau9QY6g04lFeNRXkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="84871007"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="84871007"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:40:01 -0800
X-CSE-ConnectionGUID: O2xpvH8IT1GZu80v/B3Qmg==
X-CSE-MsgGUID: aW/HBbk8RYOpVy0TQlk+eg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="214685027"
Received: from vpanait-mobl.ger.corp.intel.com (HELO fedora) ([10.245.244.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:39:57 -0800
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
Subject: [PATCH v4 4/4] drm/xe/userptr: Defer Waiting for TLB invalidation to the second pass if possible
Date: Thu,  5 Mar 2026 10:39:09 +0100
Message-ID: <20260305093909.43623-5-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
References: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3uoq1zbd5cs9qs4h6axthfiafiuy9k9q
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 40ED7C000A
X-HE-Tag: 1772703601-517460
X-HE-Meta: U2FsdGVkX18Mjk+3G4cwce93ZRQoUCtUvmH6E/UJV0Fs66wob61m+KEtso4ASrvc9EplSB7h0AZZz+xMYuVxSm0c1uaweCJZxLtcBfvRVqXk0o0iRa21RmUEtwlXDV1utq/Kr4zcn/zENzQFJDR/MeBqM2HTg3HTAImu1/4SBEgHYybAE7xpWhfMbDqfnj9Ks4xPM1fd1o5taq983BuQiXhav0ZyPeaQCJVm3lkhnRmNpRYqOvfppqcQbnzB7TDb0FMBTc29vZC49N/j+JXs/VixwH8Sr2Z59qIiqsyFQBu2/hNkjqMR2ShunpPxyCti0/ybd8HN9mxpxCw8HdsXg1q32kXeA48S1T6WHlRRFoDxbN1AnAG4VeaUJfqrn5qwRbXMP013C4SDWp7gdB8YZwPcZ5leleCgiSbhY4bshyiU8L/ORRIxev4HHmq0olMzdqQ5FHcQoLLQ3fs3c2VoFfFS7cPydZLC1mAeUHv0YrdFudwbQEO5fcyopXOSj3aLAAXFPFOLv/eYeM8QifxgODaBK2PKtNjx6k8X3+dynUguUqAUpHplu+rWB0g7tsrT1ewCsmyVYN8I9DhuCYLRYydL1MBXEx82UUKiCQZqSRMX2XA9TOf/evg0sSuhuslx3G1lI7ulU4TmD8mw6y4kaUHbvfrdz39xI7YuPIwjyAc/RAB4sOAa92hRzUjTFJNCD+D+Bxvc926kC/yFH0AsOMHxQ7dNvugklKeAEWPoNV441aroxhmYN4OZCoq4n97YdEgRusIb+faL6z9IiILiLsqtRqFa8XnSxwoEjf2G/2kkwrDGSpsWw2hf/COCTB8zPhOMtephoSDkaH+lF/QK05YR68IjYju8bhFsTQBoVDaXeRyuzxtcyURkQLhl266xy2NxGREWE76gLX4ocGE/jNePTUuhT4/aLRsMMJBOLeeK1B1rR5s0AZVzZTPYgy9va4ZdM9uW6jkoRlYKvPm
 soRr+nkV
 bIIx5y+V4Ko/xFLmJu1DGtacccq/OAjuh/PPcXTKo37WDcnbwckdfvgLugF08jt3jUTKFetqtmGFqnAn1FfMwiu/ZJFBnLfLISH6ReN0COM8qvCYnHAV1EqfSLWRAN7FMTFeJ+oq0s6mHWWDeEvQKGIPh8Vd8AuC0ei5aXmF+k8Ka83RwytojAOUCF2Q97ozcp3blctjlA8TUpqtHldJl/bQpODi++FrFyHyBTID5kfLtP50onB8vRZ/3mEtDaYM/EOfCYmeEBMBZlAc=
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
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
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


