Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C57CC87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 13:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48126B00A7; Sat,  9 Aug 2025 09:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9E56B00A8; Sat,  9 Aug 2025 09:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B6B6B00A9; Sat,  9 Aug 2025 09:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B32AA6B00A7
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 09:52:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A1E51A01D8
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:26 +0000 (UTC)
X-FDA: 83757358692.07.DBF5BEF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf12.hostedemail.com (Postfix) with ESMTP id 74CDD40005
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BrZcuPEB;
	spf=none (imf12.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754747544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKHCJGyGDtJpFQv/CMUe7w2ay+kZqc0ZqiF2w+BsYhk=;
	b=aP992gf+5MXk63MtCt/xpJIZ1v8UpERNCHXHEpz5X19jWSR0sRBc9gdABDV+XustgpP5/O
	jm0VqV3etQOYLHfLf3rluZY3j4TXmrVljhNTr5tuQsOiynCaAF9rUJiQNXk84Q2iTLkAGX
	LAE55NRlJkNHNqFmQhywC2AdPIua29I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BrZcuPEB;
	spf=none (imf12.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754747544; a=rsa-sha256;
	cv=none;
	b=RwZ+29RCQ+fh/eqUh94WNTTP8Qg4SFA0xwA5S//897/Ae/EBS9/beVRZwqn98w0LLZgiJA
	BCwG8bNHEn70ZynTUhyD65aWC4CEiC9gxPyVSVLrouxdqbPe/RVOx1JqggJm0CwxpkrDzn
	qI4YAgdXvg7zjhasb6CPO9ztMLZPskY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754747544; x=1786283544;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bt+QjLeCHx2Rrs4pAwueu1ZrAv3yQzvpcrOLeaDiagU=;
  b=BrZcuPEBSO+MoCrXGLfHSg+CXjNp1MLPZuMFQX+vclW/aZ99WPIO5/X2
   NlY9WdOF7pQnRr+eZyM2PTjnQu5fcdbguqkKS1UQr/hvadIsMKTBGwdPV
   nD+Tbs8ZoHORASvdyvrE0AY7YVDmj1MTV3YChhBvSe0q5VHgtfOx0jTHY
   D7PvV5S3268PxlLZCOfOWprbdnLH9cKEzE1tt4BE6UpO2Q8S/DRXBEfgo
   HbDMWLyoYtCe+455amDpWdTSapBWIBWPqBIZCXgcxvXXhrhFmnlOiXIj2
   hTti9HCyDwknY/bQb+mK00EYGqfsnql7a+OgFauGo20QnKU1AjZxUOo2z
   g==;
X-CSE-ConnectionGUID: Bmi8UhDhSzWpH8K9MqnXUg==
X-CSE-MsgGUID: 3F+ybwFeTUufCS3DuodMsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="68153581"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68153581"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:24 -0700
X-CSE-ConnectionGUID: 6+wTSiSvTz+Kr2Xn8p5B7A==
X-CSE-MsgGUID: UD2z8XlYQ1+G0MlHcfjemQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165903771"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.28])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:21 -0700
From: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 5/6] drm/xe: Add fences argument to xe_vm_range_tilemask_tlb_invalidation
Date: Sat,  9 Aug 2025 15:51:36 +0200
Message-ID: <20250809135137.259427-6-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 74CDD40005
X-Rspamd-Server: rspam06
X-Stat-Signature: qnwtuj8ebpgeza9tab9itg7d51sir6mh
X-HE-Tag: 1754747544-753583
X-HE-Meta: U2FsdGVkX1/j79D3Bfi08Ju49zLN0GkuRcn+1Wh3Z+Fyxqr8kV+HGWdvIVD/VD6hB4VZM5C5t4TAztVmOUct9wXqp/f3v4kag7dyCbivWlXQFdCUiORaYJWfl4YfZgFr/Ts45axU7tqDOqofLw30tjztPfYXAplCkVAagfzTUxnTzzTDet/4ttvVLVq8J41g4Xdjs62i0RjRELaijnxTpGpeSlznd+7Eii0GKO2pMgsqEo4YUyl93QNj5gdJ9VoC2P01t1EZqmeF47c4AKE1UZezW8KKW3uMGxzhFGs+ZTXkH+CGiZX++5ft+Gw3JXMZZx3I9CwntQuSI19V2JaPJjTCSgRyoEoljSrkF4mbpU5jJOw05Ac5yZmDXMahOHVaezkRX1LB08ANGXplaP12GwTKm2iTUukODaSE0fCx5c47O/41fW5ro/zTAYO4P4tPzw0OD2JyILQREOZtb2JQsUD0IHLvtiz4b0vfefvjh9GlKBANxckUcHbnrwkKBXeE4QlNRGwBVL1OO5MqhQzcmD0ehSu2MCpyrXjoKTQdzF2qgIW349rlSBnz5EDlbJToKirXGVzIUGcD/q0LNc0lzWFM92rldARyuAXbvtTRh+JYZkX9xg9L0hg7uEkpNE5A6wBH5Rv62V5oGEnSuES+DYGX9N/9Xhae+SI0Qwpv24rRjiCM6Rw1EPq9Zs5TBWSVkSoAXBKMJQtV/Dp8/Ju+WvSQorFjpyK3P6EdYu7TMTJRz5QluzakzXgZPd8kxO9w5aqA48OdThB1QY22ePTN35ecZDwsBJNar6COcX9vtW7QGDUSU5aNOAIB4okLGziGB+UW9zCMs2EnPz/Z85s70CeyXWJpC/jSYVcXdJ27m4a5jRr4LfIWI4APE1+Ke8MvKjXVgpnwzjmA+0sSyLpmP7sG+RoWJcXShXnKSa8lTybSbE9xQkv8SeSQLOOGNiv8HZpH6kSYkml4JNAr7Xh
 /V3vXxJP
 gVltNAoPbw4I5xief4MJgEEN/FwEDcgNq5Wsx2JXwSteqgLWF7zf5QZp9tE6KXMYetChfepoe1CyLhh7Ny9hZ16XHd+x/VxkKqJkVopU7Y4ib3v50IMQCRFM4UPMeIb+RZrNanpWgC+eKq9G0pQpW+15YzkyPAIkQv7SO1QN1i2T/SPkdelQ47zacZDfS5Seq/ZHrVRvLfok19Q18O7+K5wOdmjvDxR8Q6RGHt9uJJB/xRlW4M3TXaTngjuKnY3+v7a96EUNIAF8oXo/VdC+XuTR9vg4cD7eaNEVWYqR/V9n1+lE=
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
index 23c5b363261c..82a598c8d56e 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -226,7 +226,8 @@ static void xe_svm_invalidate_twopass(struct drm_gpusvm *gpusvm,
 
 	xe_device_wmb(xe);
 
-	err = xe_vm_range_tilemask_tlb_invalidation(vm, adj_start, adj_end, tile_mask);
+	err = xe_vm_range_tilemask_tlb_invalidation(vm, NULL, adj_start,
+						    adj_end, tile_mask);
 	WARN_ON_ONCE(err);
 
 range_notifier_event_end:
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 148a2425006f..52242fac6969 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3846,6 +3846,7 @@ void xe_vm_unlock(struct xe_vm *vm)
  * xe_vm_range_tilemask_tlb_invalidation - Issue a TLB invalidation on this tilemask for an
  * address range
  * @vm: The VM
+ * @fences: Caller provided fences, caller owns waiting if non-NULL
  * @start: start address
  * @end: end address
  * @tile_mask: mask for which gt's issue tlb invalidation
@@ -3854,10 +3855,12 @@ void xe_vm_unlock(struct xe_vm *vm)
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
@@ -3869,37 +3872,41 @@ int xe_vm_range_tilemask_tlb_invalidation(struct xe_vm *vm, u64 start,
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
@@ -3958,7 +3965,8 @@ int xe_vm_invalidate_vma(struct xe_vma *vma)
 
 	xe_device_wmb(xe);
 
-	ret = xe_vm_range_tilemask_tlb_invalidation(xe_vma_vm(vma), xe_vma_start(vma),
+	ret = xe_vm_range_tilemask_tlb_invalidation(xe_vma_vm(vma), NULL,
+						    xe_vma_start(vma),
 						    xe_vma_end(vma), tile_mask);
 
 	/* WRITE_ONCE pairs with READ_ONCE in xe_vm_has_valid_gpu_mapping() */
diff --git a/drivers/gpu/drm/xe/xe_vm.h b/drivers/gpu/drm/xe/xe_vm.h
index 3475a118f666..d1c3c9aa8d03 100644
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


