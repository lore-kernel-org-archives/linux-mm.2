Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8764C87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 13:52:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 658F16B00A8; Sat,  9 Aug 2025 09:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609326B00AA; Sat,  9 Aug 2025 09:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8CD6B00AB; Sat,  9 Aug 2025 09:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4836B00A8
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 09:52:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAA891A021E
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:28 +0000 (UTC)
X-FDA: 83757358776.08.B1D4BEE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9215A100007
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PcSY2EH5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf05.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754747546; a=rsa-sha256;
	cv=none;
	b=GtfHqyzvS0+cU/PQ/7FbFCSTR6J62/5KLZior2x+BKA7s/VrOFfzcsuVZq2j/rQMGf+b2A
	3waRMyTJMAg65MZFAqaiODA4J3xu73Ts7YbRhZyaFv1COkXbEwAax4NbFSMi7eOh1xO4/7
	+aEwKJOKTFgUfr/nD2A0SbJ0KKkO5ew=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PcSY2EH5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf05.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754747546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJofzkxEY+qNJ2SvfDlbsuODV3B+f1nzcpYhA0laOmo=;
	b=h9avnxY7U14+7y3mb4z4s3I6egZosHMLgG9Xe9PqTVqFgINt6SEFAUb5/PfP4DT8S+qkIc
	hoi/3LlhEXpQRIW0KpIoiDs/k1VIJQuVbaMNX8CW7m7NHJDF8RE+3sAOu+hP2cs8YY9QxH
	QiprNfNZF4am+rbeFe14KD2hGvsxYzc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754747547; x=1786283547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eVwlttIO5cPoFbzrqx0Zh2eNe66yN5Gkt7LN4QnB250=;
  b=PcSY2EH5TC461TkKEuOK3cyFaXNcllnGuaGg4g7Ctp50BzCruhp9TPdl
   jnDwzQJNIWyq+wq0/REupbOoMSduXoBip4ANxMd9tA2sCmMjhpwKMYP0a
   WAhzR9pCG10G4oWNwpONUlCZo7ijiVJKxTtrGPVYtpgNcr3C4m0Gt3l7V
   8xssvzc0V1pnB0txn7Y9vQNVg626f06+eWrU81VxzgyDKX0fkbJFDGAmO
   2zPVLcWW0QGoov3lP6PY09Qn1O5+25UnN9d9oPUsWEDyyeZwpBFSB6gLe
   SBJaLDvCzejV9ASWJGlKSgvAUEzQvpzfKx+2U8Ke0tutxz8qgon2pcFOa
   A==;
X-CSE-ConnectionGUID: LZCY1b5QS3m5so9NaRwhmg==
X-CSE-MsgGUID: KWFZWHF1TBCEDTixnHQSVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="68153590"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68153590"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:26 -0700
X-CSE-ConnectionGUID: R3aCHRgpQ4+mVFpxSPBY2Q==
X-CSE-MsgGUID: zuNnvxMYTpSWm7CSeb31rg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165903777"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.28])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:24 -0700
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
Subject: [RFC PATCH 6/6] drm/xe: Implement two pass MMU notifiers for SVM
Date: Sat,  9 Aug 2025 15:51:37 +0200
Message-ID: <20250809135137.259427-7-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s8du4ad8xb5ghk1ehygh1g4egqb4t1um
X-Rspam-User: 
X-Rspamd-Queue-Id: 9215A100007
X-Rspamd-Server: rspam02
X-HE-Tag: 1754747546-400911
X-HE-Meta: U2FsdGVkX1/0RukOgAduuD6LzOxPYqpokdwWZjNW4mb3Nh7BylpfwdVRvowjJ4f7olktlKKb+Ln6fukic+2mdAsdpI+Y2nsGwYt3XLh2NIDEIsG85+KCr/001igfA+LZwRdDEt8R5Gpnc/hUCal7ukdt8NoLDrtG0QU156Yhf7xSBFJs9w/hXfleAx9tKsfEY5UOqPJPlqltj6mK6flnR51S9kIN/sYVIMncs+1HcLTu9ZrmrDsOhjpZLjgrRJ37VuAZWHgEWQRrsQ7ykLXQMJ9W2FrCXbODLs7/W3JvI4Cz54KI7u+xsLN1+KrGQBAHwVcWtobEISJkWkNRH4KbgxG3pRlxY95zmWkk2vbV6KNRue1OfJ6HG8biEw92KVM7UvKgrHLINHDPwgwQSHYGVOEdR0vXYVZRBMEl4Z9lvuosIGVAavaYEXF+bv1dGWYbwXhzg/+dgeYUuXuWNp7QAdnmqVBxprULu1imMMavI7D2+9dDKdmkezFmiH9+gRh+2anxucFTrrcL7pU9mMqpD6ozQaB3fXusZ6FsuerBpVGC2rJZnOGHkn1CLEdQ7ewByI1r5MrcMg/kPFlJtCqfK9/d7lkpSi/1pYe2EM7nhZG0OMvXA2esX2/OqpQ5oNp9Jg7PIa1CDFBZ3UMgfbuB/Ek7gvyQ5CwEVmDQY62z3FKg8Oh98jL8rDRRipv0YmtPWHhQppUFIH6ftE80TsO9omel2NMIl3Y6b+wKakGX19LylILIY7tQLQqglZyCPwEevUXSdCcdDGSvvWHjVLOOVGZh7oAqY1Q48iH1rVTXIAM7nGjyI+hriXS/xwYJz5Oei26eAsCE+Zhjj0uhYVGUIV73NckdgDM+9/JSDtVlWhOiePVxzs6BPzVSqihwVXNkoHVI3DkjBtQfl4N+bUeDiRif4ianY82RcTt9I9yL3JsqJayKFTOYwuC1QUpU6aFtjIMPobAXoT5DX5qvKVz
 8vSwV5zz
 XrZjzomwrx4+L0DrQdrV30wg9bXShduaTPPLEm2o2OST4zzJ7oOk05D7JtbBXhU9zwKLxNAEia67nkcyJ1WNq0PPE/LzIRsFQE+xHM1dWzsgBoW/9Pggkl3+jZUl0rJzwVXwhvr7efG3Ik8+BuTEDzEADiA8yyhw6Dfhea0rQyb/vCeOzp22vpU5YxgpwtDmrKSTptXAO4zAYJyQw4tAvX0lKhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Implement two-pass MMU notifiers for SVM, enabling multiple VMs or
devices with GPU mappings to pipeline costly TLB invalidations by
issuing them in the first pass and waiting for completion in the second.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/drm_gpusvm.c |  2 +-
 drivers/gpu/drm/xe/xe_svm.c  | 74 ++++++++++++++++++++++++++++++------
 2 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 92dc7d2bd6cf..f153df1bc862 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -413,7 +413,7 @@ drm_gpusvm_notifier_invalidate_twopass(struct mmu_interval_notifier *mni,
  * drm_gpusvm_notifier_ops - MMU interval notifier operations for GPU SVM
  */
 static const struct mmu_interval_notifier_ops drm_gpusvm_notifier_ops = {
-	.invalidate_twopass = drm_gpusvm_notifier_invalidate_twopass,
+	.invalidate_multipass = drm_gpusvm_notifier_invalidate_twopass,
 };
 
 /**
diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index 82a598c8d56e..5728394806ca 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -144,15 +144,8 @@ xe_svm_range_notifier_event_begin(struct xe_vm *vm, struct drm_gpusvm_range *r,
 	 * invalidations spanning multiple ranges.
 	 */
 	for_each_tile(tile, xe, id)
-		if (xe_pt_zap_ptes_range(tile, vm, range)) {
+		if (xe_pt_zap_ptes_range(tile, vm, range))
 			tile_mask |= BIT(id);
-			/*
-			 * WRITE_ONCE pairs with READ_ONCE in
-			 * xe_vm_has_valid_gpu_mapping()
-			 */
-			WRITE_ONCE(range->tile_invalidated,
-				   range->tile_invalidated | BIT(id));
-		}
 
 	return tile_mask;
 }
@@ -161,16 +154,60 @@ static void
 xe_svm_range_notifier_event_end(struct xe_vm *vm, struct drm_gpusvm_range *r,
 				const struct mmu_notifier_range *mmu_range)
 {
+	struct xe_svm_range *range = to_xe_range(r);
 	struct drm_gpusvm_ctx ctx = { .in_notifier = true, };
 
 	xe_svm_assert_in_notifier(vm);
 
+	/*
+	 * WRITE_ONCE pairs with READ_ONCE in xe_vm_has_valid_gpu_mapping()
+	 */
+	WRITE_ONCE(range->tile_invalidated, range->tile_present);
+
 	drm_gpusvm_range_unmap_pages(&vm->svm.gpusvm, r, &ctx);
 	if (!xe_vm_is_closed(vm) && mmu_range->event == MMU_NOTIFY_UNMAP)
 		xe_svm_garbage_collector_add_range(vm, to_xe_range(r),
 						   mmu_range);
 }
 
+struct xe_svm_invalidate_pass {
+	struct drm_gpusvm *gpusvm;
+	struct drm_gpusvm_notifier *notifier;
+#define XE_SVM_INVALIDATE_FENCE_COUNT	\
+	(XE_MAX_TILES_PER_DEVICE * XE_MAX_GT_PER_TILE)
+	struct xe_gt_tlb_invalidation_fence fences[XE_SVM_INVALIDATE_FENCE_COUNT];
+	struct mmu_interval_notifier_pass p;
+};
+
+static struct mmu_interval_notifier_pass *
+xe_svm_invalidate_second(struct mmu_interval_notifier_pass *p,
+			 const struct mmu_notifier_range *mmu_range,
+			 unsigned long cur_seq)
+{
+	struct xe_svm_invalidate_pass *pass = container_of(p, typeof(*pass), p);
+	struct drm_gpusvm *gpusvm = pass->gpusvm;
+	struct drm_gpusvm_notifier *notifier = pass->notifier;
+	struct drm_gpusvm_range *r = NULL;
+	struct xe_vm *vm = gpusvm_to_vm(gpusvm);
+	u64 adj_start = mmu_range->start, adj_end = mmu_range->end;
+	int id;
+
+	/* Adjust invalidation to notifier boundaries */
+	adj_start = max(drm_gpusvm_notifier_start(notifier), adj_start);
+	adj_end = min(drm_gpusvm_notifier_end(notifier), adj_end);
+
+	for (id = 0; id < XE_SVM_INVALIDATE_FENCE_COUNT; ++id)
+		xe_gt_tlb_invalidation_fence_wait(&pass->fences[id]);
+
+	drm_gpusvm_in_notifier_lock(gpusvm);
+	drm_gpusvm_for_each_range(r, notifier, adj_start, adj_end)
+		xe_svm_range_notifier_event_end(vm, r, mmu_range);
+	drm_gpusvm_in_notifier_unlock(gpusvm);
+
+	kfree(pass);
+	return NULL;
+}
+
 static void xe_svm_invalidate_twopass(struct drm_gpusvm *gpusvm,
 				      struct drm_gpusvm_notifier *notifier,
 				      const struct mmu_notifier_range *mmu_range,
@@ -179,6 +216,8 @@ static void xe_svm_invalidate_twopass(struct drm_gpusvm *gpusvm,
 	struct xe_vm *vm = gpusvm_to_vm(gpusvm);
 	struct xe_device *xe = vm->xe;
 	struct drm_gpusvm_range *r, *first;
+	struct xe_svm_invalidate_pass *pass = NULL;
+	struct xe_gt_tlb_invalidation_fence *fences = NULL;
 	u64 adj_start = mmu_range->start, adj_end = mmu_range->end;
 	u8 tile_mask = 0;
 	long err;
@@ -226,14 +265,25 @@ static void xe_svm_invalidate_twopass(struct drm_gpusvm *gpusvm,
 
 	xe_device_wmb(xe);
 
-	err = xe_vm_range_tilemask_tlb_invalidation(vm, NULL, adj_start,
+	pass = kzalloc(sizeof(*pass), GFP_NOWAIT);
+	if (pass) {
+		pass->gpusvm = gpusvm;
+		pass->notifier = notifier;
+		pass->p.pass = xe_svm_invalidate_second;
+		fences = pass->fences;
+		*p = &pass->p;
+	}
+
+	err = xe_vm_range_tilemask_tlb_invalidation(vm, fences, adj_start,
 						    adj_end, tile_mask);
 	WARN_ON_ONCE(err);
 
 range_notifier_event_end:
-	r = first;
-	drm_gpusvm_for_each_range(r, notifier, adj_start, adj_end)
-		xe_svm_range_notifier_event_end(vm, r, mmu_range);
+	if (!pass) {
+		r = first;
+		drm_gpusvm_for_each_range(r, notifier, adj_start, adj_end)
+			xe_svm_range_notifier_event_end(vm, r, mmu_range);
+	}
 }
 
 static int __xe_svm_garbage_collector(struct xe_vm *vm,
-- 
2.50.1


