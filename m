Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F53CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742CF8E004D; Thu, 21 Aug 2025 07:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5448E004B; Thu, 21 Aug 2025 07:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D808E004D; Thu, 21 Aug 2025 07:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40B998E004B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:47:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05C45B7E55
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:47:08 +0000 (UTC)
X-FDA: 83800588536.26.E7C6565
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id B8A0E1C0009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:47:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cYUSy/xe";
	spf=none (imf20.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755776826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K/2YqCP6iD4qlMr37dUfpn5IO6sHumYf/0rJOYWEyVc=;
	b=EimV0xO0AtaMd6TxMQ/+LUGdDv+MfSkva5k/sOH4eirWoRPre92QdxUKz0eOqnfyLlOAZE
	zpl9PB3wBXu8hwlhZsQf29OO7v5vGyb3nxled82RKRWhr/cDYEY0R+oJLwCmOPJjQPwb5F
	Uh9EXC3pIfNSv6cFFWc6+pmUINJbJBg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="cYUSy/xe";
	spf=none (imf20.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755776826; a=rsa-sha256;
	cv=none;
	b=3ErNpAH+Yh3ecUQ2dl6QrC+GP4YJtxL8TQhZmO728rHyGJu5LQJpzBi8mAmQKjmGgqQYDp
	93zqOdrGKl6B4yQkSwH+CjE4JPSFJ/NMWzVRsKEot9OIInIHDOOwq311p/SqL0B7JRSJJf
	va+Ayogv1zt1ApKNYPv4TQkjfViApq4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755776826; x=1787312826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iJneFFGjQzLecO0NbP6dLUmEON+W6rvWnRMxdzIQpkM=;
  b=cYUSy/xe8NGqYWML+WP1E34lZKNWLQL5/9UJ9sMnW48jD2F0FRbW/G1S
   xkL5deRAYYVLv3Oelfz/PNH3jx9WXE5HvpLK+Crvghj8xT7hB8X4ISCYZ
   GUuRcaZ8FDQhJFCzA8P37JrikIhJegbPkdhaJ0Zal9ljnC2tQi44foJu2
   j4Bz1aThUyhTgrIq9JtUl8iUYHn7QfuQ2SrkYtFB3OA8RIP0N0R4qlyHI
   +6U0VFIP05miCujaEaOZ+Se14EZC/ac+QMXQj9HrsMS8b/cyG/8srIVP7
   msLDqdOstYaeU4hn2Otz8/Fp7DdYKVdPLdgMDaZe/6UvikBsf0QaT8qIu
   g==;
X-CSE-ConnectionGUID: OiB8Y7c6TK+57x6ay/6x0A==
X-CSE-MsgGUID: yK+at74wT4StVOLVgqYVdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57989495"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="57989495"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:47:05 -0700
X-CSE-ConnectionGUID: m/oDoepnQumFqMGRpcZkOw==
X-CSE-MsgGUID: xiY/gQ3BRTuN2LEm+B2oOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172613664"
Received: from johunt-mobl9.ger.corp.intel.com (HELO fedora) ([10.245.245.201])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:47:02 -0700
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
Subject: [PATCH 6/6] drm/xe: Implement two pass MMU notifiers for SVM
Date: Thu, 21 Aug 2025 13:46:26 +0200
Message-ID: <20250821114626.89818-7-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
References: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: me9w9kbs7ncmeekucq6ymqebxgzrnkgh
X-Rspam-User: 
X-Rspamd-Queue-Id: B8A0E1C0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1755776825-318900
X-HE-Meta: U2FsdGVkX1/EWXRpGNBUV/ORJpDiGxM27ewxlEFDl6+DsCsDsn7PT6FRib572R1NnmUrjXmZEqVhwoLxdSykdsAkEO+jfUUnlWiHwdwQ8VIJlxhqxqGc4fiiZEHEOCx2+wTqOZvQDCXb5Lc8g5U8dbCDRyZdcjplSTJfy4YH9YqtaMVhJ8MHSHRs0XWY6Ll57ZAlHSVdjMGG1wQ33zvdoMzDKtSWwqevzmvPKm/g4RGjmRW4v9wIRgsYEZmGX71Wv9XE63hDJy3vZO9QEQ6Qd6mUBkNWuTso/pbj4HK+7+wbbr8vtYPuGeLfmdCkGhQy5BsOuJoFxwER9aNybIcU8nDhBMxvoTAEMGYR30A6YfvAbKaVSvj8AXzPIZWa5eOuA7Mw3Eun4ukKCZh7uW6jLT7nOX0dc+e7Hw9YvCfhFNJYg1tt5CTDRYYSWvCv84vN6n+70kUMjyzM7Eqj+NhZZPL2GzoGF2lZGcOo8oudfW5V0BQ5sP8vpiz5t5611rb97yYhM14ofg9PCSPrXfQN/7snPR38/VZl+D7Zl2E9SGWrbNteVbaOHlwVAPCRcIsLAsh2YYiVHN9YrodlZUIECyw6VP9L1bZU+SwPWl29ZrUcDPBTJWpPmEIWs+U2Ag9nGMVD6nglo89r6mfMHa3VET8ltj2mFt+5QWd88bU90YHca9N3TJ7GssMN0gNTvtavkV0aUdqlbdMuNVo17Twpa89kBNRSHWT8BMDdHdr1GmmCq24ifMnEDL3VfFTPcoFeAmKa2apz82ysZSdKXnh4jzxH1HQ/fnbepH1UIbB+QlfxOpFRQ4uVrJ2QgRy7s3rfKrxHiPJLdMQvaOMoYRnoynZ59kclLYe7w3UlbA/LhEaJz+usPh/GTzx+geF0HdscsrUjfZYZ08dbSCLNctbJtv4NVn0QD8m75Hw8PekoaI1jhU8fLL1fy0EmgS2/v9ZXXW0Icgn+NJGnzKkdYqq
 +BV6zEFs
 fLJj/fErKkzF7A5BuIEbwwwdZnGcMXhLHQeaN7n6fP7JD3XjFoECBFLua/ZvfRnUryWrc8zeQVSGVrOl1pTuDretaeNSmYAnXqqYbFyw3HsEPhW3tRXQFWNGGz/Onz2ddKDSJlmyrKXbRjiUDeqtOhPRu5Vtvzvz97m6U4yJp6ittSNDa0mV0yq0OQRl64x+7cgdeQTHEkqg1vrP0bUeS6OZrQzXqmMnMvLJYGTserHryMRCqpNIKQ5v1hA==
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

v1:
- Adjust naming.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/xe/xe_svm.c | 73 +++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index 5ef673b70575..a278c9dc5306 100644
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
@@ -161,16 +154,59 @@ static void
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
 
+struct xe_svm_invalidate_finish {
+	struct drm_gpusvm *gpusvm;
+	struct drm_gpusvm_notifier *notifier;
+#define XE_SVM_INVALIDATE_FENCE_COUNT	\
+	(XE_MAX_TILES_PER_DEVICE * XE_MAX_GT_PER_TILE)
+	struct xe_gt_tlb_invalidation_fence fences[XE_SVM_INVALIDATE_FENCE_COUNT];
+	struct mmu_interval_notifier_finish f;
+};
+
+static void
+xe_svm_invalidate_finish(struct mmu_interval_notifier_finish *final,
+			 const struct mmu_notifier_range *mmu_range,
+			 unsigned long cur_seq)
+{
+	struct xe_svm_invalidate_finish *xe_final = container_of(final, typeof(*xe_final), f);
+	struct drm_gpusvm *gpusvm = xe_final->gpusvm;
+	struct drm_gpusvm_notifier *notifier = xe_final->notifier;
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
+		xe_gt_tlb_invalidation_fence_wait(&xe_final->fences[id]);
+
+	drm_gpusvm_in_notifier_lock(gpusvm);
+	drm_gpusvm_for_each_range(r, notifier, adj_start, adj_end)
+		xe_svm_range_notifier_event_end(vm, r, mmu_range);
+	drm_gpusvm_in_notifier_unlock(gpusvm);
+
+	kfree(xe_final);
+}
+
 static void xe_svm_invalidate_start(struct drm_gpusvm *gpusvm,
 				    struct drm_gpusvm_notifier *notifier,
 				    const struct mmu_notifier_range *mmu_range,
@@ -179,6 +215,8 @@ static void xe_svm_invalidate_start(struct drm_gpusvm *gpusvm,
 	struct xe_vm *vm = gpusvm_to_vm(gpusvm);
 	struct xe_device *xe = vm->xe;
 	struct drm_gpusvm_range *r, *first;
+	struct xe_svm_invalidate_finish *xe_final = NULL;
+	struct xe_gt_tlb_invalidation_fence *fences = NULL;
 	u64 adj_start = mmu_range->start, adj_end = mmu_range->end;
 	u8 tile_mask = 0;
 	long err;
@@ -226,14 +264,25 @@ static void xe_svm_invalidate_start(struct drm_gpusvm *gpusvm,
 
 	xe_device_wmb(xe);
 
-	err = xe_vm_range_tilemask_tlb_invalidation(vm, NULL, adj_start,
+	xe_final = kzalloc(sizeof(*xe_final), GFP_NOWAIT);
+	if (xe_final) {
+		xe_final->gpusvm = gpusvm;
+		xe_final->notifier = notifier;
+		xe_final->f.finish = xe_svm_invalidate_finish;
+		fences = xe_final->fences;
+		*final = &xe_final->f;
+	}
+
+	err = xe_vm_range_tilemask_tlb_invalidation(vm, fences, adj_start,
 						    adj_end, tile_mask);
 	WARN_ON_ONCE(err);
 
 range_notifier_event_end:
-	r = first;
-	drm_gpusvm_for_each_range(r, notifier, adj_start, adj_end)
-		xe_svm_range_notifier_event_end(vm, r, mmu_range);
+	if (!xe_final) {
+		r = first;
+		drm_gpusvm_for_each_range(r, notifier, adj_start, adj_end)
+			xe_svm_range_notifier_event_end(vm, r, mmu_range);
+	}
 }
 
 static int __xe_svm_garbage_collector(struct xe_vm *vm,
-- 
2.50.1


