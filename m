Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6C0EEC1447
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 13:35:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C24296B0197; Tue,  3 Mar 2026 08:35:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87256B019A; Tue,  3 Mar 2026 08:35:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56136B019C; Tue,  3 Mar 2026 08:35:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0316B0197
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:35:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42A50C0859
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:35:02 +0000 (UTC)
X-FDA: 84504847644.14.025B0ED
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf30.hostedemail.com (Postfix) with ESMTP id D278D80013
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 13:34:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EFu60kzv;
	spf=temperror (imf30.hostedemail.com: error in processing during lookup of thomas.hellstrom@linux.intel.com: DNS error) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772544900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1adXpfBsyqkO8GGUG1EtHlH0TPC9S7so4pZMOtOv36M=;
	b=4Nlthnd820MZxqLplr6Hk4VffsDfbZ0vJuVh9nh/+dm8hy/OLV8pH8WkhXrAmkyta34gj+
	tGyfxkQIjvwHp5xzyrYPcOkBHHQuF33VnuHFYtw0SWeZoA6nmuYrSsqJYJ69lA5fzIKc6p
	W8IFzcHFr/BGQq/SZjoLQymA+uE4QHk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EFu60kzv;
	spf=temperror (imf30.hostedemail.com: error in processing during lookup of thomas.hellstrom@linux.intel.com: DNS error) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772544900; a=rsa-sha256;
	cv=none;
	b=ji0gnRBsJz+kx/+QdWDdv+MSlgucU2V5EksaDXyX1T0rs3dSEVAuL+A+44hzzOkEKBlfcH
	SoK86kOoF8xo1d3EfMHtpw2Wzf1YLA4L0BDSX3N9c+CaFB3ylpun9o+AOuhrHz2CUjCpg5
	VUtm1iCGWiH5aYG3TTubEfDxCymSpXc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772544900; x=1804080900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4zSdgJb/3LQV6TLEXBd3FOBd7Vj/A1qMpJaLG/tQvuo=;
  b=EFu60kzv5py2gjGsO8QmHYcWKst/2OnjeDeyCn3CtGUhpVGRXA6zivEM
   3NtTQsKZD3IYeTzfnniMOTB8PjmD645o6NKXValw4HOESr4KvnznMF2Of
   SKn/Oj0/zscSPkVXp2SuRoujN+6mr54J2O2b1VmGF2fcfbazh3f2sntvR
   r8mnGz3dq4+SIV7zPofL+SUvrowSJjV245Hw0xaXWSVKHtoV+3FKkT4Cu
   hOvYDd2pgrfdA3Jvn2y3czXQgEaqpyYkPfMWx5bnbwDyzdz0rdQwIJABL
   opP7hTSkG4DabYfm87uokwrjUS0fGsFhT3T3FLQ+0+36Wv9qTl5WNULBM
   Q==;
X-CSE-ConnectionGUID: ZHElcImwR42VHuqNWOC4UA==
X-CSE-MsgGUID: FYKIhTksSfS9eQlcUAiTdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="76179750"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="76179750"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 05:34:52 -0800
X-CSE-ConnectionGUID: UbDdlhigS1yA6L9Jp2rtNg==
X-CSE-MsgGUID: OGslZIcARRW3iwqoTD+ewA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="217947938"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.243])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 05:34:49 -0800
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
Subject: [PATCH v3 3/4] drm/xe: Split TLB invalidation into submit and wait steps
Date: Tue,  3 Mar 2026 14:34:08 +0100
Message-ID: <20260303133409.11609-4-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
References: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D278D80013
X-Stat-Signature: 7hfdbrojsde44w5obq8fzdqtgez97xfm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772544899-974799
X-HE-Meta: U2FsdGVkX1+l1rxd8KbI88Fsj4Oj4bG2uVhIPb2LuYpI9iAmffYP45DpVjMGuvvoK+yMzTgRJprTsvLV3vC9BAWLUi4sJ2qnZrJ7mppwjT/XfKO8JNO6FBQXhUZXKWC2P/SDN4XCIUxP4Erw8mxYy9LFK8oPp5fCb2OKEi+2qa7x7r+ZFbD8xl04AEsXHwfb25Y+fwxgMZocvr7/b8QatFVD7PsuV4ZdYk1xY1E3FIUaNmSOmSXq5jhVo3VRd6L8j2snw4ltvouqwLxnfS5SzSiHc/MakpeTEXABrWryR/eBj4OTrNKjI5QO8WSJYGMRZ13gYtlb6MCeXQtI2ssqIri0PhYfsHzxBWgrsUygRRf7LZ8QSJAbLGv8P/qNhKmWf3zRRlmuHGic9xGn63pfOVziiaUJSRi/b+1DFD+/hYB2yF5Q0Nw9bAZ7EC0HgTOeRJwhWbeQX0SnQJuYp4fF9WIPMCom+L7VKQIBlZ/vZFB+WfKFR0jGhti3VsUQ1/te9T2x4nMgygneEJHUzBmnPOa1jvc9U5Cnq9eE+4J2yM13wSFss0arcRbIUX4L7Cls/57BKoV/iusrA37pLyF3vFbTRPJgBux04stuAcQ1gwq8psL8K15g9nyZKbTEuOsAy10AuJJuCFAzpn0v23FTzMfWanP8/c1mHrO+OvNaEl7UXINksU/22EDvyNh/aEYlFpTScIDtBL4Coxn8m2wBW40Qvf7EMRXAGf2fDPNwvyD/SpYhxY2FqlU9JQpzddBXTJLnKBdSy1iA0lUOEqPVJlR3H6MHbNVU4rAZPnKXMSTIOWax28V5j8VcYP8br6iPOkdpy2HQZWl9iFgHgowYICSV3ua6rDiAKRQd4WAUkxaq4bVQnCz1V8b/dMkyh//AxLOTaHOAowUFwW7rWSroLFmUNub57Bj8oRXg4YvJcZfP81MwZ1HgqU6+MI53yJ//Wb/+GqHworb7ftpxxRl
 yWEQ2aJX
 10wd54o/v0pJdYEBpWkquhf2IT5kOeyXGUc+dehSyxOWISH2/GdmSu4IOCtPscn6mHrKWQD1ohqfcx88K1VU6hO0oTh/1k5RSOfVNsKEuWtj1wkl1BcljMUdikjuBijcOSA+yF7hP9FwYaX7W8OHZMufSN4hENr9AF0ZHAWqBuJZiDADQxuZxtDl+YgafhLrXGPEVQ2EwTb9xyAeZaDrGHR3gnhDzSG7ahpBe4SbjQZYPi3Yqa6+Z0HvqGb0nqwjxbZ8o8Px6vHz3ebA=
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

v3:
- Don't wait on TLB invalidation batches if the corresponding batch
  submit returns an error. (Matt Brost)
- s/_batch/batch/ (Matt Brost)

Assisted-by: GitHub Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/xe/xe_svm.c             |  8 ++-
 drivers/gpu/drm/xe/xe_tlb_inval.c       | 84 +++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_tlb_inval.h       |  6 ++
 drivers/gpu/drm/xe/xe_tlb_inval_types.h | 14 +++++
 drivers/gpu/drm/xe/xe_vm.c              | 69 +++-----------------
 drivers/gpu/drm/xe/xe_vm.h              |  3 -
 drivers/gpu/drm/xe/xe_vm_madvise.c      | 10 ++-
 drivers/gpu/drm/xe/xe_vm_types.h        |  1 +
 8 files changed, 127 insertions(+), 68 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index 002b6c22ad3f..a91c84487a67 100644
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
+	struct xe_tlb_inval_batch batch;
 	struct xe_device *xe = vm->xe;
 	struct drm_gpusvm_range *r, *first;
 	struct xe_tile *tile;
@@ -276,8 +278,10 @@ static void xe_svm_invalidate(struct drm_gpusvm *gpusvm,
 
 	xe_device_wmb(xe);
 
-	err = xe_vm_range_tilemask_tlb_inval(vm, adj_start, adj_end, tile_mask);
-	WARN_ON_ONCE(err);
+	err = xe_tlb_inval_range_tilemask_submit(xe, vm->usm.asid, adj_start, adj_end,
+						 tile_mask, &batch);
+	if (!WARN_ON_ONCE(err))
+		xe_tlb_inval_batch_wait(&batch);
 
 range_notifier_event_end:
 	r = first;
diff --git a/drivers/gpu/drm/xe/xe_tlb_inval.c b/drivers/gpu/drm/xe/xe_tlb_inval.c
index 933f30fb617d..10dcd4abb00f 100644
--- a/drivers/gpu/drm/xe/xe_tlb_inval.c
+++ b/drivers/gpu/drm/xe/xe_tlb_inval.c
@@ -486,3 +486,87 @@ bool xe_tlb_inval_idle(struct xe_tlb_inval *tlb_inval)
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
+ * If the function returns an error, there is no need to call
+ * xe_tlb_inval_batch_wait() on @batch.
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
index 548b0769b3ef..a3c2e8cefec7 100644
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
+	struct xe_tlb_inval_batch batch;
 	struct xe_tile *tile;
 	u8 tile_mask = 0;
 	int ret = 0;
@@ -4080,12 +4021,16 @@ int xe_vm_invalidate_vma(struct xe_vma *vma)
 
 	xe_device_wmb(xe);
 
-	ret = xe_vm_range_tilemask_tlb_inval(xe_vma_vm(vma), xe_vma_start(vma),
-					     xe_vma_end(vma), tile_mask);
+	ret = xe_tlb_inval_range_tilemask_submit(xe, xe_vma_vm(vma)->usm.asid,
+						 xe_vma_start(vma), xe_vma_end(vma),
+						 tile_mask, &batch);
 
 	/* WRITE_ONCE pairs with READ_ONCE in xe_vm_has_valid_gpu_mapping() */
 	WRITE_ONCE(vma->tile_invalidated, vma->tile_mask);
 
+	if (!ret)
+		xe_tlb_inval_batch_wait(&batch);
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
index 95bf53cc29e3..02daf8a93044 100644
--- a/drivers/gpu/drm/xe/xe_vm_madvise.c
+++ b/drivers/gpu/drm/xe/xe_vm_madvise.c
@@ -12,6 +12,7 @@
 #include "xe_pat.h"
 #include "xe_pt.h"
 #include "xe_svm.h"
+#include "xe_tlb_inval.h"
 
 struct xe_vmas_in_madvise_range {
 	u64 addr;
@@ -235,13 +236,20 @@ static u8 xe_zap_ptes_in_madvise_range(struct xe_vm *vm, u64 start, u64 end)
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
+	if (!err)
+		xe_tlb_inval_batch_wait(&batch);
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


