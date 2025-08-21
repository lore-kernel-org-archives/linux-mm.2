Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D35CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33E88E0048; Thu, 21 Aug 2025 07:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5428E004D; Thu, 21 Aug 2025 07:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00CC8E004B; Thu, 21 Aug 2025 07:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B52A8E0048
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:47:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45372B852A
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:47:04 +0000 (UTC)
X-FDA: 83800588368.16.014E800
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2C9FF180003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:47:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L7wrt5sr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf24.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755776822; a=rsa-sha256;
	cv=none;
	b=pZqwKHayQ2wb5YKbuT7Az1t24JNLNZ8fYjAfaWE5GnQEYdJ/i9EPfYhd50JgKPfTfq9VdR
	kVxU8rNm+8nLRGb3o5ksoKTH8bkRMQcaRVPzcmKnLLe19WlzsgEqwvQur4IfsQPGVncM9D
	oO1RgwiU7ndZaE8uCpTeEyDFOtp6q5M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=L7wrt5sr;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf24.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755776822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZrCl3XABoQ7R9oWe92VNDIYZ6+xBgDZxJomNC6REJ0=;
	b=v5znZbc+e5C17+q6AcBMk6415NpYtsEIcxsdyz791op3ejrVIsNNmL0DTRtj+PJwUpfC5b
	tHkb89gprmOGhuctvJ8JQERj/PTZ66bmq6Ah72StR+k1KICvO7vq3g/F+e4b6k9euF8EgE
	BMWrbzceJgPVityXJIoVwk53wSucb84=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755776822; x=1787312822;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b5ab1jehet9PqnPbvotgit7EJJsXSBgrqjKQ7KkFEIE=;
  b=L7wrt5sr6b/bHcxOmrt7pwBremYt31DvaqekO4ixcc3Ei12+IVdcAH/c
   7NDACTRY6TIXGET+iRcti1WXPQeK62IK/m4m+FL5WobgvUTGNQdFalZOo
   6bCEuJ6gbPVus1X9qhd3iRJ1RK74QFmPECEb2NKc2DSp1+/k0s/lJ0xfG
   KT8E7syM1ZkpBi/Dy7Afe7iNV2Z5yaglo/sKsuymH2+DXzswXGc2iBDB9
   jDKFNmGWeXRw1yvAYf25mQ5r6qNradhnYSSpKepTbRRJ7nV5pR5wpAMyx
   qD3smpJeID4hhJap94dOLIiVTB8WH7EvjMhDMh/OnXRQLt0Q3Sec2ouds
   g==;
X-CSE-ConnectionGUID: SOcNU9apRAm4Gv4wfRa0sA==
X-CSE-MsgGUID: 7Mo73Ko+SDy5MqH0KKBE3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57989483"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="57989483"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:47:02 -0700
X-CSE-ConnectionGUID: AaqxK5ZJQPyRqsxSV8Xfrw==
X-CSE-MsgGUID: BLaTMDyWSleG0Ef1CVW2QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172613652"
Received: from johunt-mobl9.ger.corp.intel.com (HELO fedora) ([10.245.245.201])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:59 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] drm/xe: Add fences argument to xe_vm_range_tilemask_tlb_invalidation
Date: Thu, 21 Aug 2025 13:46:25 +0200
Message-ID: <20250821114626.89818-6-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
References: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C9FF180003
X-Stat-Signature: rx8781jtbyjok9kmyutob1doqsesf5kw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755776822-306406
X-HE-Meta: U2FsdGVkX1+slgGHmQeEPu+jJgKCQsZ+pgFoWFyMIxweVLEFdue4KuqQlg4hdQyRt+s+MXPgSOdgSVybptyE+V/zAkdnDdqOqUmhNfOhY0PH+2+mp4rK1wyOiRBdrc8GclleQ7dq3kKMi0z+OvKFq7iQ+pTCHORmp7ucqlGHPQWwvj5r+U/iqKiTR2gC1sNtf1txR2huYkwcKil3XKQKL5Lp5JLTHP2dVfzerUo8mhjMWXJ/LavuL5fVpk8CdOlkkMapsjyzGvcH0g6zuc7uwuiIBdop1jrMtiqaPb46QQA4tZ0JUBt2cVKUMWoCVLwVE25qUNWAQCkfHWquYHkDVLyj+xvbPnQ1B1Jrng65yxkiM8LjLAtnYkxQ95pCMyCVmrjNDL8jj+kFzZpb8e8mHtjyMTR3uzo6n/CSJ71kmbkbEKSc/mVtHrBlyb4knVHzGFBQoSiKtRHpczgspM0Cc8d6rtBFX4Ilrio7H4mbOmBbDoGBcYHEknAAQeGC/InLPc5XhK51vCJrNZCKGHI5tpc6WsFhk3pvVggitPSTNNpLNwwaoEk+Wwh33s9nJ1cYdqMO6ByPRE4vYdJ/E9Mx+d5mhn4H9kkcnOh3XGPHlOyQ/xhIxephtbTkmKjRM+XJnuPfnd9L0Br/26Yc/ot7Yn+xwMLxMS6S1UyZHZjsmzN+/FBZIK1b92AwDB+lltgEh+tTe9CVr504VJ7ZRrGMmMS5nYK0fF1iy75W5wZjLdYwtpjUs390xoRm0m61FvmtUdDkj5o3t2PVdbMx2p7lEtwPytx5AS7T5E1ExfVTjmOf+ImKMRSD+Jnk7fWen/X1VjArCc3StRQ0ANCAExxApGQ/86McdD3nqp+RIvcnntlnnWiu2fsdxomxSfiruzZHX4Xg4hokMZdGi/7mrMStpK9Ro26/W7Krnrfg1BP+3lG6smMMo3F2HQ6Dm30Wzy3r8aH9VayFqULcEq5eww9
 YRJBZ8cX
 vhXPXQstgoOBCcCncQDjLNtJngLSTZsVyM0j9rVraGIG71KM55s7grK6ImuQjTNcdWizhE7YTH4jekwmSNA/v5E2qG7UBJXJ9QtqvBNQUNROa1C42z5/XQ4k/e5xwQkXhjEepiI0ymyR/hITrw0CYiCIO/r5dYHAnge72rnrrvAsVFii147y4yD8SKYtKq2suQthyxqw6S8EOeWNlfe/qJsnHiBVv/S8UA4zHozWoz67G6W36inLBPvgO/rpd+XRV8HD8WV2dPAPNRyj0MgXq0NsvGs4+cKtPVy3UJr2VnkRftiFxQXc7nPhuz8ILLf5kcxczfw5dxB+N2kJ2Rbz4CXr249hxdw/me7gvV/AqmxHcFfEfyzb2W0TpET0qpxsUjCG7mwGIjhUGHE5+ee43BwDDPHoWL5PY1llOqo1X5Av+Z58=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Introduce a fences argument to xe_vm_range_tilemask_tlb_invalidation,
allowing callers to provide fences and defer waiting to a later point.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/xe/xe_svm.c |  3 ++-
 drivers/gpu/drm/xe/xe_vm.c  | 26 +++++++++++++++++---------
 drivers/gpu/drm/xe/xe_vm.h  |  6 ++++--
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index 309bcf8a50dd..5ef673b70575 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -226,7 +226,8 @@ static void xe_svm_invalidate_start(struct drm_gpusvm *gpusvm,
 
 	xe_device_wmb(xe);
 
-	err = xe_vm_range_tilemask_tlb_invalidation(vm, adj_start, adj_end, tile_mask);
+	err = xe_vm_range_tilemask_tlb_invalidation(vm, NULL, adj_start,
+						    adj_end, tile_mask);
 	WARN_ON_ONCE(err);
 
 range_notifier_event_end:
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index c86337e08a55..a594be545d81 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3871,6 +3871,7 @@ void xe_vm_unlock(struct xe_vm *vm)
  * xe_vm_range_tilemask_tlb_invalidation - Issue a TLB invalidation on this tilemask for an
  * address range
  * @vm: The VM
+ * @fences: Caller provided fences, caller owns waiting if non-NULL
  * @start: start address
  * @end: end address
  * @tile_mask: mask for which gt's issue tlb invalidation
@@ -3879,10 +3880,12 @@ void xe_vm_unlock(struct xe_vm *vm)
  *
  * Returns 0 for success, negative error code otherwise.
  */
-int xe_vm_range_tilemask_tlb_invalidation(struct xe_vm *vm, u64 start,
-					  u64 end, u8 tile_mask)
+int xe_vm_range_tilemask_tlb_invalidation(struct xe_vm *vm,
+					  struct xe_gt_tlb_invalidation_fence *fences,
+					  u64 start, u64 end, u8 tile_mask)
 {
 	struct xe_gt_tlb_invalidation_fence fence[XE_MAX_TILES_PER_DEVICE * XE_MAX_GT_PER_TILE];
+	struct xe_gt_tlb_invalidation_fence *__fence = fences ?: fence;
 	struct xe_tile *tile;
 	u32 fence_id = 0;
 	u8 id;
@@ -3894,37 +3897,41 @@ int xe_vm_range_tilemask_tlb_invalidation(struct xe_vm *vm, u64 start,
 	for_each_tile(tile, vm->xe, id) {
 		if (tile_mask & BIT(id)) {
 			xe_gt_tlb_invalidation_fence_init(tile->primary_gt,
-							  &fence[fence_id], true);
+							 __fence, true);
 
 			err = xe_gt_tlb_invalidation_range(tile->primary_gt,
-							   &fence[fence_id],
+							   __fence,
 							   start,
 							   end,
 							   vm->usm.asid);
 			if (err)
 				goto wait;
 			++fence_id;
+			++__fence;
 
 			if (!tile->media_gt)
 				continue;
 
 			xe_gt_tlb_invalidation_fence_init(tile->media_gt,
-							  &fence[fence_id], true);
+							  __fence, true);
 
 			err = xe_gt_tlb_invalidation_range(tile->media_gt,
-							   &fence[fence_id],
+							   __fence,
 							   start,
 							   end,
 							   vm->usm.asid);
 			if (err)
 				goto wait;
 			++fence_id;
+			++__fence;
 		}
 	}
 
 wait:
-	for (id = 0; id < fence_id; ++id)
-		xe_gt_tlb_invalidation_fence_wait(&fence[id]);
+	if (!fences) {
+		for (id = 0; id < fence_id; ++id)
+			xe_gt_tlb_invalidation_fence_wait(&fence[id]);
+	}
 
 	return err;
 }
@@ -3983,7 +3990,8 @@ int xe_vm_invalidate_vma(struct xe_vma *vma)
 
 	xe_device_wmb(xe);
 
-	ret = xe_vm_range_tilemask_tlb_invalidation(xe_vma_vm(vma), xe_vma_start(vma),
+	ret = xe_vm_range_tilemask_tlb_invalidation(xe_vma_vm(vma), NULL,
+						    xe_vma_start(vma),
 						    xe_vma_end(vma), tile_mask);
 
 	/* WRITE_ONCE pairs with READ_ONCE in xe_vm_has_valid_gpu_mapping() */
diff --git a/drivers/gpu/drm/xe/xe_vm.h b/drivers/gpu/drm/xe/xe_vm.h
index 2f213737c7e5..0b08b22e3bb3 100644
--- a/drivers/gpu/drm/xe/xe_vm.h
+++ b/drivers/gpu/drm/xe/xe_vm.h
@@ -22,6 +22,7 @@ struct dma_fence;
 
 struct xe_exec_queue;
 struct xe_file;
+struct xe_gt_tlb_invalidation_fence;
 struct xe_sync_entry;
 struct xe_svm_range;
 struct drm_exec;
@@ -228,8 +229,9 @@ struct dma_fence *xe_vm_range_rebind(struct xe_vm *vm,
 struct dma_fence *xe_vm_range_unbind(struct xe_vm *vm,
 				     struct xe_svm_range *range);
 
-int xe_vm_range_tilemask_tlb_invalidation(struct xe_vm *vm, u64 start,
-					  u64 end, u8 tile_mask);
+int xe_vm_range_tilemask_tlb_invalidation(struct xe_vm *vm,
+					  struct xe_gt_tlb_invalidation_fence *fences,
+					  u64 start, u64 end, u8 tile_mask);
 
 int xe_vm_invalidate_vma(struct xe_vma *vma);
 
-- 
2.50.1


