Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34EE6EA4E3A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996986B0092; Mon,  2 Mar 2026 11:33:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958E66B0093; Mon,  2 Mar 2026 11:33:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82D126B0095; Mon,  2 Mar 2026 11:33:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73E076B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:33:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22EC1160243
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:22 +0000 (UTC)
X-FDA: 84501668244.17.9789934
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf19.hostedemail.com (Postfix) with ESMTP id 987C31A000B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PUHTSNQF;
	spf=pass (imf19.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772469200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dHNBdideU2TTb7wnS8rQFhF7Q2JeUKgxa0xmKntGb2k=;
	b=ZGKFl+7XkePaEUfrjWPs2XxLVlZzCq4MnLHBPX3pmGPmRLmuX5ilJYaryHflOyJU35PJUM
	slkF6ZXpIMuI6g0u9+wqYiv/Xd835EU74TJq1/WuEzRHmgSamFRJRarEDAi1jpgHI6sBQS
	3gkNT8UZ0zjye2STA0MjenARdyjjoM8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PUHTSNQF;
	spf=pass (imf19.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772469200; a=rsa-sha256;
	cv=none;
	b=2GoJgXGUXiJK/TLtbzfP3Fr3z3KgN++pjuIvQiCIcAE+njKKX6x1mcZdwXHyR1JHMQ+Suh
	rQgB7QGYqsSbvRlyHUw7MwO5l+sOzwi/3CXNZZ015iTAXZzR9AYugJbefE9KN7KwoNlJqC
	G/OLCwbBKLdHEnAOv+nJetXsHJYp5zg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772469199; x=1804005199;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=REVi10SRu9z3ZPsNcbifTyehMK0hQmtR42Guy7n5z44=;
  b=PUHTSNQFKOuIP9IqaOrYS5HiylK56m37tJ8a3iEaGgYTJtGjs1zgkMc8
   0WL8T2++1zORpiYyBa05KC5qKOeW8hWkvBcX5gUiSdPel8y7es/jIwVgF
   nPL8VDSY2s4o+igfQ4ddgBGtkbvUsu3tRaz6oUSoc/Pn+vlp7WX05rFiW
   ELZClEulpPS4xl5VQAIgg97PqSMw/zEfbsKWpTfxb5GSpKUY8/kQk2oBC
   U2MyEVsc8kRBpUgxhItX1qlJMEaBswR14woBJNcm+Jo5fzXkx8PAISsjK
   kJyXkr8SzOengBOV92vOCXMUYV0V2qlvbqfpwyiLMenhdciBQwep5Lt5l
   g==;
X-CSE-ConnectionGUID: T7/eP6J2RwmlRCI8IfbHPg==
X-CSE-MsgGUID: 3JEoZinjTSKNlsKtQJVTbg==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73447851"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73447851"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 08:33:18 -0800
X-CSE-ConnectionGUID: K+CRsj+RQZ6ru4vAsX+Wvw==
X-CSE-MsgGUID: p97XZGPvQkm1YvytgY0cqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255564533"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.81])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 08:33:16 -0800
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
Subject: [PATCH v2 3/4] drm/xe: Split TLB invalidation into submit and wait steps
Date: Mon,  2 Mar 2026 17:32:47 +0100
Message-ID: <20260302163248.105454-4-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
References: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 43ugfopzsmkwxuuyjbcjh51dq1j6qqom
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 987C31A000B
X-HE-Tag: 1772469199-303316
X-HE-Meta: U2FsdGVkX18mT39nSKSzkHvBdrOkMeSKJDPxuH2Y+D7FeAUFURWURsAzB9CXu8xLiToCC6inxt7PYlKb1vvEyP1e2BmY8fes2y7F/+3bb2Cl3dMkAUg3LWamIy597A1cg9LPFOT/jWCRpNGeblP8CYlq4cNzqeZ+slrsrFdwLZlLw0BLDnz3igFfNWNc3InZq4N23u1DNiANgc+a4C9B5QzgWtuuY5QJYCGw9522MVoG8OlcKJwC6iwcgqt8kNhgzRAV5C1LYLINyiLCxjlsF2MAc+AT0oKXQ0wZpus8QSeKoxbMyVjBvBmO2a/pnYBNaCZEu77tbPJZ6vG3YSMpnqaGcJQMpeQyCfU+S3bw5u9Gx3qGnib0Gg7gdf2rHi4Sx4/VR8cuhDO9AGMwr1d5rCFcDoBkPS45v7XUS6JauGCie9PSWOwPx/fmM+xMWzDkJbM+6xS8R5P49XnxgP0GvyYMrSgRX8M6oBET9QdyYmpmO4MCEqmrYfsq17VXdXVlG+ALmnErYZ0rIzbBrbuFN8vqQw4cKJ66gS7PMYZkQEXNnHIlICUV9eqE/4OMVC1oYB1K9eKjGBdUvrHsT9u0b+Q5wGPR6sWM5gEuQVXWQci6zZTfDRglB0RAF/QtfipdLIsqAuPBjAHLuaIqu9Sg6qbpunBU+zw3Ab+oUNEtQgLhn6olI3eIJBk198M8gpZLmTWGGwPypBCi+Zq3R/PBB0rXwjqGYD/b8md6elZwVk91pjokE9fPepkaSAfz3Kr0MZwFmToxMiK2T+4ZEP8otjGd9W2/sLrn6XXJV9hLO3lBhgxEPhUJBQwHJn4rpwfUPg9jNPKfODl85QeJHY12C5XhMD91Ilog7+GbyNnNqYK1L7o6bMqnwPJptJo88bgVzc1HjTb73zRWRJxeLHJZ7mvuFFfZEvGqNBdU1G094MJmszpUPuqJbd1dSeeYXD/jaaGKqzMSX4nikuva1XB
 c3otrlbB
 nPaYPKnhtbirLHSj24tVP3QSl3ZVsB+hm0rhIsvMxLecd4gFLvClAZvtAlXVmhFAyw2BqzybMmsnkuBpRrEiEpQ8YI0uYH0gh4bereDhZHABVsXO534l5gID/GwhJgK/J/wMrrN4jl1fycdz9KQbHRHmFCyhffjaPqQwY8jiI/gbNSgwW2sgIi7s1k8hpYbTxxtoMHu2zVNNYcW8jqErYKLw7B0eU1PUJ7fxQizT1w1vcnUrxHlzsXJ2yn8zM+Zn+OKAvUj/7wgUuZjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xe_vm_range_tilemask_tlb_inval() submits TLB invalidation requests to
all GTs in a tile mask and then immediately waits for them to complete
before returning. This is fine for the existing callers, but a
subsequent patch will need to defer the wait in order to overlap TLB
invalidations across multiple VMAs.

Introduce xe_tlb_inval_range_tilemask_submit() and
xe_tlb_inval_batch_wait() in xe_tlb_inval.c as the submit and wait
halves respectively. The batch of fences is carried in the new
xe_tlb_inval_batch structure. Remove xe_vm_range_tilemask_tlb_inval()
and convert all three call sites to the new API.

Assisted-by: GitHub Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/xe/xe_svm.c             |  6 +-
 drivers/gpu/drm/xe/xe_tlb_inval.c       | 82 +++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_tlb_inval.h       |  6 ++
 drivers/gpu/drm/xe/xe_tlb_inval_types.h | 14 +++++
 drivers/gpu/drm/xe/xe_vm.c              | 69 +++------------------
 drivers/gpu/drm/xe/xe_vm.h              |  3 -
 drivers/gpu/drm/xe/xe_vm_madvise.c      |  9 ++-
 drivers/gpu/drm/xe/xe_vm_types.h        |  1 +
 8 files changed, 123 insertions(+), 67 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index 002b6c22ad3f..6ea4972c2791 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -19,6 +19,7 @@
 #include "xe_pt.h"
 #include "xe_svm.h"
 #include "xe_tile.h"
+#include "xe_tlb_inval.h"
 #include "xe_ttm_vram_mgr.h"
 #include "xe_vm.h"
 #include "xe_vm_types.h"
@@ -225,6 +226,7 @@ static void xe_svm_invalidate(struct drm_gpusvm *gpusvm,
 			      const struct mmu_notifier_range *mmu_range)
 {
 	struct xe_vm *vm = gpusvm_to_vm(gpusvm);
+	struct xe_tlb_inval_batch _batch;
 	struct xe_device *xe = vm->xe;
 	struct drm_gpusvm_range *r, *first;
 	struct xe_tile *tile;
@@ -276,7 +278,9 @@ static void xe_svm_invalidate(struct drm_gpusvm *gpusvm,
 
 	xe_device_wmb(xe);
 
-	err = xe_vm_range_tilemask_tlb_inval(vm, adj_start, adj_end, tile_mask);
+	err = xe_tlb_inval_range_tilemask_submit(xe, vm->usm.asid, adj_start, adj_end,
+						 tile_mask, &_batch);
+	xe_tlb_inval_batch_wait(&_batch);
 	WARN_ON_ONCE(err);
 
 range_notifier_event_end:
diff --git a/drivers/gpu/drm/xe/xe_tlb_inval.c b/drivers/gpu/drm/xe/xe_tlb_inval.c
index 933f30fb617d..343e37cfe715 100644
--- a/drivers/gpu/drm/xe/xe_tlb_inval.c
+++ b/drivers/gpu/drm/xe/xe_tlb_inval.c
@@ -486,3 +486,85 @@ bool xe_tlb_inval_idle(struct xe_tlb_inval *tlb_inval)
 	guard(spinlock_irq)(&tlb_inval->pending_lock);
 	return list_is_singular(&tlb_inval->pending_fences);
 }
+
+/**
+ * xe_tlb_inval_batch_wait() - Wait for all fences in a TLB invalidation batch
+ * @batch: Batch of TLB invalidation fences to wait on
+ *
+ * Waits for every fence in @batch to signal, then resets @batch so it can be
+ * reused for a subsequent invalidation.
+ */
+void xe_tlb_inval_batch_wait(struct xe_tlb_inval_batch *batch)
+{
+	struct xe_tlb_inval_fence *fence = &batch->fence[0];
+	unsigned int i;
+
+	for (i = 0; i < batch->num_fences; ++i)
+		xe_tlb_inval_fence_wait(fence++);
+
+	batch->num_fences = 0;
+}
+
+/**
+ * xe_tlb_inval_range_tilemask_submit() - Submit TLB invalidations for an
+ * address range on a tile mask
+ * @xe: The xe device
+ * @asid: Address space ID
+ * @start: start address
+ * @end: end address
+ * @tile_mask: mask for which gt's issue tlb invalidation
+ * @batch: Batch of tlb invalidate fences
+ *
+ * Issue a range based TLB invalidation for gt's in tilemask
+ *
+ * Returns 0 for success, negative error code otherwise.
+ */
+int xe_tlb_inval_range_tilemask_submit(struct xe_device *xe, u32 asid,
+				       u64 start, u64 end, u8 tile_mask,
+				       struct xe_tlb_inval_batch *batch)
+{
+	struct xe_tlb_inval_fence *fence = &batch->fence[0];
+	struct xe_tile *tile;
+	u32 fence_id = 0;
+	u8 id;
+	int err;
+
+	batch->num_fences = 0;
+	if (!tile_mask)
+		return 0;
+
+	for_each_tile(tile, xe, id) {
+		if (!(tile_mask & BIT(id)))
+			continue;
+
+		xe_tlb_inval_fence_init(&tile->primary_gt->tlb_inval,
+					&fence[fence_id], true);
+
+		err = xe_tlb_inval_range(&tile->primary_gt->tlb_inval,
+					 &fence[fence_id], start, end,
+					 asid, NULL);
+		if (err)
+			goto wait;
+		++fence_id;
+
+		if (!tile->media_gt)
+			continue;
+
+		xe_tlb_inval_fence_init(&tile->media_gt->tlb_inval,
+					&fence[fence_id], true);
+
+		err = xe_tlb_inval_range(&tile->media_gt->tlb_inval,
+					 &fence[fence_id], start, end,
+					 asid, NULL);
+		if (err)
+			goto wait;
+		++fence_id;
+	}
+
+wait:
+	batch->num_fences = fence_id;
+	if (err)
+		xe_tlb_inval_batch_wait(batch);
+
+	return err;
+}
diff --git a/drivers/gpu/drm/xe/xe_tlb_inval.h b/drivers/gpu/drm/xe/xe_tlb_inval.h
index 62089254fa23..a76b7823a5f2 100644
--- a/drivers/gpu/drm/xe/xe_tlb_inval.h
+++ b/drivers/gpu/drm/xe/xe_tlb_inval.h
@@ -45,4 +45,10 @@ void xe_tlb_inval_done_handler(struct xe_tlb_inval *tlb_inval, int seqno);
 
 bool xe_tlb_inval_idle(struct xe_tlb_inval *tlb_inval);
 
+int xe_tlb_inval_range_tilemask_submit(struct xe_device *xe, u32 asid,
+				       u64 start, u64 end, u8 tile_mask,
+				       struct xe_tlb_inval_batch *batch);
+
+void xe_tlb_inval_batch_wait(struct xe_tlb_inval_batch *batch);
+
 #endif	/* _XE_TLB_INVAL_ */
diff --git a/drivers/gpu/drm/xe/xe_tlb_inval_types.h b/drivers/gpu/drm/xe/xe_tlb_inval_types.h
index 3b089f90f002..3d1797d186fd 100644
--- a/drivers/gpu/drm/xe/xe_tlb_inval_types.h
+++ b/drivers/gpu/drm/xe/xe_tlb_inval_types.h
@@ -9,6 +9,8 @@
 #include <linux/workqueue.h>
 #include <linux/dma-fence.h>
 
+#include "xe_device_types.h"
+
 struct drm_suballoc;
 struct xe_tlb_inval;
 
@@ -132,4 +134,16 @@ struct xe_tlb_inval_fence {
 	ktime_t inval_time;
 };
 
+/**
+ * struct xe_tlb_inval_batch - Batch of TLB invalidation fences
+ *
+ * Holds one fence per GT covered by a TLB invalidation request.
+ */
+struct xe_tlb_inval_batch {
+	/** @fence: per-GT TLB invalidation fences */
+	struct xe_tlb_inval_fence fence[XE_MAX_TILES_PER_DEVICE * XE_MAX_GT_PER_TILE];
+	/** @num_fences: number of valid entries in @fence */
+	unsigned int num_fences;
+};
+
 #endif
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 548b0769b3ef..7f29d2b2972d 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3966,66 +3966,6 @@ void xe_vm_unlock(struct xe_vm *vm)
 	dma_resv_unlock(xe_vm_resv(vm));
 }
 
-/**
- * xe_vm_range_tilemask_tlb_inval - Issue a TLB invalidation on this tilemask for an
- * address range
- * @vm: The VM
- * @start: start address
- * @end: end address
- * @tile_mask: mask for which gt's issue tlb invalidation
- *
- * Issue a range based TLB invalidation for gt's in tilemask
- *
- * Returns 0 for success, negative error code otherwise.
- */
-int xe_vm_range_tilemask_tlb_inval(struct xe_vm *vm, u64 start,
-				   u64 end, u8 tile_mask)
-{
-	struct xe_tlb_inval_fence
-		fence[XE_MAX_TILES_PER_DEVICE * XE_MAX_GT_PER_TILE];
-	struct xe_tile *tile;
-	u32 fence_id = 0;
-	u8 id;
-	int err;
-
-	if (!tile_mask)
-		return 0;
-
-	for_each_tile(tile, vm->xe, id) {
-		if (!(tile_mask & BIT(id)))
-			continue;
-
-		xe_tlb_inval_fence_init(&tile->primary_gt->tlb_inval,
-					&fence[fence_id], true);
-
-		err = xe_tlb_inval_range(&tile->primary_gt->tlb_inval,
-					 &fence[fence_id], start, end,
-					 vm->usm.asid, NULL);
-		if (err)
-			goto wait;
-		++fence_id;
-
-		if (!tile->media_gt)
-			continue;
-
-		xe_tlb_inval_fence_init(&tile->media_gt->tlb_inval,
-					&fence[fence_id], true);
-
-		err = xe_tlb_inval_range(&tile->media_gt->tlb_inval,
-					 &fence[fence_id], start, end,
-					 vm->usm.asid, NULL);
-		if (err)
-			goto wait;
-		++fence_id;
-	}
-
-wait:
-	for (id = 0; id < fence_id; ++id)
-		xe_tlb_inval_fence_wait(&fence[id]);
-
-	return err;
-}
-
 /**
  * xe_vm_invalidate_vma - invalidate GPU mappings for VMA without a lock
  * @vma: VMA to invalidate
@@ -4040,6 +3980,7 @@ int xe_vm_invalidate_vma(struct xe_vma *vma)
 {
 	struct xe_device *xe = xe_vma_vm(vma)->xe;
 	struct xe_vm *vm = xe_vma_vm(vma);
+	struct xe_tlb_inval_batch _batch;
 	struct xe_tile *tile;
 	u8 tile_mask = 0;
 	int ret = 0;
@@ -4080,12 +4021,16 @@ int xe_vm_invalidate_vma(struct xe_vma *vma)
 
 	xe_device_wmb(xe);
 
-	ret = xe_vm_range_tilemask_tlb_inval(xe_vma_vm(vma), xe_vma_start(vma),
-					     xe_vma_end(vma), tile_mask);
+	ret = xe_tlb_inval_range_tilemask_submit(xe, xe_vma_vm(vma)->usm.asid,
+						 xe_vma_start(vma), xe_vma_end(vma),
+						 tile_mask, &_batch);
 
 	/* WRITE_ONCE pairs with READ_ONCE in xe_vm_has_valid_gpu_mapping() */
 	WRITE_ONCE(vma->tile_invalidated, vma->tile_mask);
 
+	if (!ret)
+		xe_tlb_inval_batch_wait(&_batch);
+
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_vm.h b/drivers/gpu/drm/xe/xe_vm.h
index f849e369432b..62f4b6fec0bc 100644
--- a/drivers/gpu/drm/xe/xe_vm.h
+++ b/drivers/gpu/drm/xe/xe_vm.h
@@ -240,9 +240,6 @@ struct dma_fence *xe_vm_range_rebind(struct xe_vm *vm,
 struct dma_fence *xe_vm_range_unbind(struct xe_vm *vm,
 				     struct xe_svm_range *range);
 
-int xe_vm_range_tilemask_tlb_inval(struct xe_vm *vm, u64 start,
-				   u64 end, u8 tile_mask);
-
 int xe_vm_invalidate_vma(struct xe_vma *vma);
 
 int xe_vm_validate_protected(struct xe_vm *vm);
diff --git a/drivers/gpu/drm/xe/xe_vm_madvise.c b/drivers/gpu/drm/xe/xe_vm_madvise.c
index 95bf53cc29e3..39717026e84f 100644
--- a/drivers/gpu/drm/xe/xe_vm_madvise.c
+++ b/drivers/gpu/drm/xe/xe_vm_madvise.c
@@ -12,6 +12,7 @@
 #include "xe_pat.h"
 #include "xe_pt.h"
 #include "xe_svm.h"
+#include "xe_tlb_inval.h"
 
 struct xe_vmas_in_madvise_range {
 	u64 addr;
@@ -235,13 +236,19 @@ static u8 xe_zap_ptes_in_madvise_range(struct xe_vm *vm, u64 start, u64 end)
 static int xe_vm_invalidate_madvise_range(struct xe_vm *vm, u64 start, u64 end)
 {
 	u8 tile_mask = xe_zap_ptes_in_madvise_range(vm, start, end);
+	struct xe_tlb_inval_batch batch;
+	int err;
 
 	if (!tile_mask)
 		return 0;
 
 	xe_device_wmb(vm->xe);
 
-	return xe_vm_range_tilemask_tlb_inval(vm, start, end, tile_mask);
+	err = xe_tlb_inval_range_tilemask_submit(vm->xe, vm->usm.asid, start, end,
+						 tile_mask, &batch);
+	xe_tlb_inval_batch_wait(&batch);
+
+	return err;
 }
 
 static bool madvise_args_are_sane(struct xe_device *xe, const struct drm_xe_madvise *args)
diff --git a/drivers/gpu/drm/xe/xe_vm_types.h b/drivers/gpu/drm/xe/xe_vm_types.h
index 1f6f7e30e751..de6544165cfa 100644
--- a/drivers/gpu/drm/xe/xe_vm_types.h
+++ b/drivers/gpu/drm/xe/xe_vm_types.h
@@ -18,6 +18,7 @@
 #include "xe_device_types.h"
 #include "xe_pt_types.h"
 #include "xe_range_fence.h"
+#include "xe_tlb_inval_types.h"
 #include "xe_userptr.h"
 
 struct drm_pagemap;
-- 
2.53.0


