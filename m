Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37353F3092B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 09:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4CE6B0096; Thu,  5 Mar 2026 04:40:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 487656B0098; Thu,  5 Mar 2026 04:40:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 388716B0099; Thu,  5 Mar 2026 04:40:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F0F36B0096
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 04:40:00 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3E715B883
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:39:59 +0000 (UTC)
X-FDA: 84511512918.17.6E4171D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf10.hostedemail.com (Postfix) with ESMTP id 53AADC000A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 09:39:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cCP7LtJr;
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772703597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=96l+QNVaK30BH1H0AA1yup+7ZIkc8gq3QJPNknduLBk=;
	b=WVF7xkmrMGXGykPl5ByIVWcIqnCu1GDK5P/CkNOMWyzyTvBDXwl3Xkd+UChb9cINTaaGa1
	muP6ETVIVhj/1IyfI3liwQ0I8WEybqVx7SfAgpQS7u+FlMNtZBriuXUE1kDt99089sSpGb
	urGW3z2GLwYD5KyidZiDcb5NV90GoZs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cCP7LtJr;
	spf=pass (imf10.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772703597; a=rsa-sha256;
	cv=none;
	b=B72wWfAMACZlpbHdxJjtLB8FOxJnP+lsbW4oeCUFgR2Ax+7veu47xRCrhJ8bYVNOEpdcsL
	YM3U07kS4Rz47LXD+GrA62+RS2uBZwRmN/wp5lgOAj53KnjX/Brn+iDfDhvnmpgfmiILI3
	m1fCq+R5NeD2CEvUPa7zN25mKdXDTjo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772703597; x=1804239597;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vqu2mBttwBYNe3AtussgI0qd6tz0JHkp+5Nwz38MtP0=;
  b=cCP7LtJrwR/U+DwFyIpXOP/2d1FKHZRQnVKfyzTkonoM+j+VEc7agX1E
   RIqSRU7wQzGEjIQwCYFPShnMMSMMMq6BYXsKBcrGqUJNkN5A2eWBKOLVF
   /ThtZX88ni6sjTp8ng856DBxM8+IeHBEac/3afbYUJ23IxIdrFGX4ii/t
   6hFBN3aI4yaVuSPxD/9f4WXUeiGoBYqK+8427/gRRgXN6O+hNCz3m0QBB
   KrMIaS8kLhT2sH5l4xwAT71pG9OsfH5GP2lk/YyAsfcwir8DNipoWdMBl
   PlH+LWqsURsQQ+19u9YBm5IVC+/2RzZVHLlQWmaeF9PkSy4/7I3MBAGBI
   A==;
X-CSE-ConnectionGUID: eWxgpL38T4KyKgnFhA6k4Q==
X-CSE-MsgGUID: pRtURK17TMyyERI4W3hBVA==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="84870988"
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="84870988"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:39:56 -0800
X-CSE-ConnectionGUID: jBY6NJDiTZKeM7cOBB8TfQ==
X-CSE-MsgGUID: DkUumHz0TWmi+je2Kt1Tww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,102,1770624000"; 
   d="scan'208";a="214685023"
Received: from vpanait-mobl.ger.corp.intel.com (HELO fedora) ([10.245.244.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 01:39:53 -0800
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
Subject: [PATCH v4 3/4] drm/xe: Split TLB invalidation into submit and wait steps
Date: Thu,  5 Mar 2026 10:39:08 +0100
Message-ID: <20260305093909.43623-4-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
References: <20260305093909.43623-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qgnz4k6gecopjyz31d9oab5fg41ysc76
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 53AADC000A
X-HE-Tag: 1772703597-46950
X-HE-Meta: U2FsdGVkX188WMc4yhtF80fzTB1/QCeWWhFotgi1npB2MLGc22uO6a448bSftTuiAeoo10gzyPfc3JwoAAiomYx+LIcJfieATiiv79+vzwrt/bHZOsf9dEdXfKjhJFY+X9UZMgwb9I2Kc/OwD0OZQebzVytVfmor1AjH2KXsvuQhlRSbQQa+ifeU+174q0hGfy1X5E5x7x2EZQj/5o3mj48S98R3R8prYe+upIGbNgQL2MlLfEZQCxlPcLidOkrJ+NkoehclHTKGjnJpadqRi5Vbq+bDUcaRYxExvP9csdlpq1MV+TjvXepetXKy8T/lAGcUuwtblU2bJRG41EeX+iU2r7NmnTqicPN/221eqJPv2ri5bkScZwvKKIkGL4ocPfJqQgxt89KV0QVKC9W+t+CNIQOX1oekeorwkZE3s7qfk6Ko44BxeeUUwU8TrV2RWEnl0CnWfHoH4FvKYpt7KmSdYap7BXqzlyhS77+TKsRWeN3Vpb06Jlo5w+fl+RQwaL1Zf8ux7WVcbbw7+NqQ7uRiRCL4t0Lxt5KPDJafS+DIUNqBUgt+QEx0gMf2aozeZi9FDo7S1DZl0L9RazhDqmvVx8BgZHuK3bYVLNdJtyU36STKXcrudKHi5X7UByrff2KMjWgAkv1djgKMzxZ+7GW46qwY5LeGUfFboMLdO3GWlAN1DUJKi+7LCXDHHgntZyzA5U5HfAyOHO+w/Ng334N5Xm9nbH0qVJVM8IDHSh3mlxlD9gtUhXZF201WNqgfjnI5Qh2tfiHgF84k4IU1SlYoY+QXvXTuSQ7XsyEcXuwZxXgHCT1GCjeGFlXvl0aX17eTL3vLpZQuX54xCwj9dt8Ve5FPRC7n6DHWRwK1/MFy/KRjlOeel9GTqvJPDgskCzIRfQ7qhPm/PJMEBhEwyvIblCgCCLBwLjbIyunol6YnSm1ZWMUlMgtczByMGM1KttJUJqRuFTmwCkWaBUG
 w+k+16uh
 /U1htukaqa2my7xEdJkPkaFkYCrs3O5fK3XHrpWSweTwQOLpbEy2A6/M+RAgN9O6HyQuv9DWgXDLQan4I360ddHw2GpZUusfu0yA4ivMArTXZDwtJ1tUgkoEM9Hh/Q+xp0d4NZm4CW/AlXMlMRXOps5ChVnJUtoi9fCOguvyCU4mvhBHmq8VLX8LXcVq+7qI8bwnFIeu2l8uQT8+TyjbYIN460WhdKUg9qxN2aEgl5GiGNi8a9lInTUNaTlG2EgN4gTpoyr+WBtN3ieg=
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
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
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


