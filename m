Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D56AAC87FCF
	for <linux-mm@archiver.kernel.org>; Sat,  9 Aug 2025 13:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47886B00A2; Sat,  9 Aug 2025 09:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA7F6B00A3; Sat,  9 Aug 2025 09:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0D96B00A4; Sat,  9 Aug 2025 09:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B88FD6B00A2
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 09:52:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AD0F811F5
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:19 +0000 (UTC)
X-FDA: 83757358398.23.C624196
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0B445A0003
	for <linux-mm@kvack.org>; Sat,  9 Aug 2025 13:52:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KHyazKfH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754747537; a=rsa-sha256;
	cv=none;
	b=ObRF2BoCt23btkOgu3KzI9/4s0OwXYOVn6YLFBouEYlOyXXUmrKeVtGdseXf6urDoIXTKl
	piZcbgQmh9lyJ4sIZEnH4WCYwbYQBlR23nREyovU0nAa0i8DGcPISGi9/EYVOe5fr5gAtp
	Vpfyx1pFVuoLL6CY46YwP+kXl2/coBg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KHyazKfH;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.13) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754747537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TRNAbAEGT/ZKZWMEx4a9FR89j0JYe+cZehrg3Q9JbU=;
	b=F5mf8+d5ltlmvfmenmA9/t7i7ZLiuM4B/4jZq6cB1UaOZt0ZFJ9AhH76SvYPjhF4LQnjFV
	VoQGmMlfHGeT+5Rcqnb3fTfVZxSs3ok59z4sHrjYjRnGShu6STY7h3mI/1s/yzxM/MM41x
	gwbtSqZc9IEcBTjVrFbVX1HJPuYzAwM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754747537; x=1786283537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M1dPRbREHCZNm03J/0kaw2ckl1FuinNQkvsu+9otm4E=;
  b=KHyazKfHOVdFBagKMI6boSzRKAElOs5EtZ57CpK90ETS2B+9pRx9t7UK
   DwBmzeMozNc1tzUYhUhj7nBSLcNqYL5khbLKxe5OsVgEhoJcYB8riOxtp
   sOqkGRgPhr9d7ReHshZQJwXYSI4ZVqgZGhqmfbycYlx6Lzq2IxUFQk7mn
   w1Y81pxHW3WgAY9+Ro/FGLC9ughpaHw5FKkW+2XCV3i5Ic/P/DSPC/RPQ
   VFPpKKa2+IhZjlGMpNy6cy3+aleNrPww2OWTPwG+nYTz5tOgsz4XcEN9z
   al1JvWQUXWPK9PhsE8qiAc1JDtfKZFvpE92S41/qWfXKww6I90Qr3T3su
   w==;
X-CSE-ConnectionGUID: pDOhHiZxRDaGxMD+mxsRxg==
X-CSE-MsgGUID: V7uCevR8Qr6cLsaW4Sk4uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11515"; a="68153551"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="68153551"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:16 -0700
X-CSE-ConnectionGUID: wW5KpTcnRz+LewKSRZMlhQ==
X-CSE-MsgGUID: axquRza3SkGznZ/c7UT2LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="165903751"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.28])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2025 06:52:14 -0700
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
Subject: [RFC PATCH 2/6] drm/gpusvm: Update GPU SVM / Xe to twopass MMU notifier
Date: Sat,  9 Aug 2025 15:51:33 +0200
Message-ID: <20250809135137.259427-3-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
References: <20250809135137.259427-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d6e8ab7ijkuq99ddqpcb8puchcykc63d
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B445A0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754747536-25361
X-HE-Meta: U2FsdGVkX1+YAdlvw89w5UdFFtk9Dmh6KZvc8tRkscNvCuwid9VBIztfivRF0ybAjIuCG+cE6Ip8PpP+s9xabLkpjldi8y2zqPl+UHFQSXrZkNsr/1DACeYV+7a11+SrFJo9NdY6dLwwMLC4EsdhdP93e/YmBjy5Gz/3/haNVxHwX31tPPvZrWynBPp0JYGRaK5y2ECPieZG8poom/ZGenkmOq3QcrZTS7d6DApW+X6StamJoAoJei+Us184F7AcPpOfl8+IfuWRrb8HMcaI23ETNzNLG5meaFWlt+65KECgYerp06ZU10TCpaheCG5zk1W6czg85iLRD+ibaekxpQTUrqHsJ+pnFCJC5aUO7IzUQSVbC+XeNYhrWHuP+ONw7vnqhu9eNn4Nm6LfmZrjbokPfzzJBCfx59dl30QFLGjiQZHTZAsswh6Zdk9GFI+3pS0cJZWf2vPunuTvN0DMiwkIfq5hV5lLlBet5IePBagjQ3wPpIKLBUUKE7+2hlBzUFxlmIYYtMXcu/G9SNNdaHpzGSfRrew+EBHW2UGSsutHJSwTJ9QXKFJBVMzZsHHfjjYqI0bOMPrIq73Hz2gT+JkJ5eodo7WoTiaPXrWlRcneW2JVvqWNQojIzoyOPNS7rQqImmvxvpaXyWHrLwaNlV0YWSppWWVJ1Qy14JwvsDrtygdqVAlhuxptOfkXxGgo/C+s2qwMl9Uuibrr+piNGoLjv/m5ck3q22RneUm4TK7iGYpnBjRg726oB1ulxMR+O4I+auGsSV5Ee8P07uJmeh+p/RAmuCe5VqrFOnOEVvymtoW2vOUBAQvw/iJV5ZCc1SzOZsf63e128ozpnTq0AMazhHIh0FMVtpiLOxwcRbbWa5kh59iJaxDyFlIlmVGK27UAB09j1vhUXb28uBwc8jHw5o3IcpRjtizEUapiYT46XOkD5lh/OJ/w94c/YcI2nkp9Na7KWlf9wb2inz6
 RYVTyzCd
 QLkecm/owVGWFSblUPR4j+ugTAeRlXGK+LxLHdfTkMC6JFvmHdSUJQ5EqrHyreIMVoD0/ZpqcaxJP5vq+fNcFuRAW4Om7ak/3xbHfHPh19qvyS4mRj/C8MqVhmIs10XKMYtXmyG6yYqpAwQ4uJihTgr5chSx5virBm3hkDuA18yGQ9uy9nQYwtKwNcJkuHO4SG9y0qnYcSIkPFLMD5OW5YJ1sKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matthew Brost <matthew.brost@intel.com>

Update GPU SVM and Xe to use two-pass MMU notifiers, enabling pipelined
TLB invalidations across VMs or multiple devices.

The driver-side (Xe) implementation is not yet implemented.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/drm_gpusvm.c | 18 +++++++++++-------
 drivers/gpu/drm/xe/xe_svm.c  |  9 +++++----
 include/drm/drm_gpusvm.h     | 11 +++++++----
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 661306da6b2d..92dc7d2bd6cf 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -374,10 +374,13 @@ notifier_iter_first(struct rb_root_cached *root, unsigned long start,
 	     (notifier__) = (next__), (next__) = __drm_gpusvm_notifier_next(notifier__))
 
 /**
- * drm_gpusvm_notifier_invalidate() - Invalidate a GPU SVM notifier.
+ * drm_gpusvm_notifier_invalidate_twopass() - Invalidate a GPU SVM notifie,
+ * fist pass.
+ *
  * @mni: Pointer to the mmu_interval_notifier structure.
  * @mmu_range: Pointer to the mmu_notifier_range structure.
  * @cur_seq: Current sequence number.
+ * @pass: First pass of MMU notifier
  *
  * This function serves as a generic MMU notifier for GPU SVM. It sets the MMU
  * notifier sequence number and calls the driver invalidate vfunc under
@@ -386,9 +389,10 @@ notifier_iter_first(struct rb_root_cached *root, unsigned long start,
  * Return: true if the operation succeeds, false otherwise.
  */
 static bool
-drm_gpusvm_notifier_invalidate(struct mmu_interval_notifier *mni,
-			       const struct mmu_notifier_range *mmu_range,
-			       unsigned long cur_seq)
+drm_gpusvm_notifier_invalidate_twopass(struct mmu_interval_notifier *mni,
+				       const struct mmu_notifier_range *mmu_range,
+				       unsigned long cur_seq,
+				       struct mmu_interval_notifier_pass **pass)
 {
 	struct drm_gpusvm_notifier *notifier =
 		container_of(mni, typeof(*notifier), notifier);
@@ -399,7 +403,7 @@ drm_gpusvm_notifier_invalidate(struct mmu_interval_notifier *mni,
 
 	down_write(&gpusvm->notifier_lock);
 	mmu_interval_set_seq(mni, cur_seq);
-	gpusvm->ops->invalidate(gpusvm, notifier, mmu_range);
+	gpusvm->ops->invalidate_twopass(gpusvm, notifier, mmu_range, pass);
 	up_write(&gpusvm->notifier_lock);
 
 	return true;
@@ -409,7 +413,7 @@ drm_gpusvm_notifier_invalidate(struct mmu_interval_notifier *mni,
  * drm_gpusvm_notifier_ops - MMU interval notifier operations for GPU SVM
  */
 static const struct mmu_interval_notifier_ops drm_gpusvm_notifier_ops = {
-	.invalidate = drm_gpusvm_notifier_invalidate,
+	.invalidate_twopass = drm_gpusvm_notifier_invalidate_twopass,
 };
 
 /**
@@ -440,7 +444,7 @@ int drm_gpusvm_init(struct drm_gpusvm *gpusvm,
 		    const struct drm_gpusvm_ops *ops,
 		    const unsigned long *chunk_sizes, int num_chunks)
 {
-	if (!ops->invalidate || !num_chunks)
+	if (!ops->invalidate_twopass || !num_chunks)
 		return -EINVAL;
 
 	gpusvm->name = name;
diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index e35c6d4def20..23c5b363261c 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -171,9 +171,10 @@ xe_svm_range_notifier_event_end(struct xe_vm *vm, struct drm_gpusvm_range *r,
 						   mmu_range);
 }
 
-static void xe_svm_invalidate(struct drm_gpusvm *gpusvm,
-			      struct drm_gpusvm_notifier *notifier,
-			      const struct mmu_notifier_range *mmu_range)
+static void xe_svm_invalidate_twopass(struct drm_gpusvm *gpusvm,
+				      struct drm_gpusvm_notifier *notifier,
+				      const struct mmu_notifier_range *mmu_range,
+				      struct mmu_interval_notifier_pass **p)
 {
 	struct xe_vm *vm = gpusvm_to_vm(gpusvm);
 	struct xe_device *xe = vm->xe;
@@ -553,7 +554,7 @@ static const struct drm_pagemap_devmem_ops dpagemap_devmem_ops = {
 static const struct drm_gpusvm_ops gpusvm_ops = {
 	.range_alloc = xe_svm_range_alloc,
 	.range_free = xe_svm_range_free,
-	.invalidate = xe_svm_invalidate,
+	.invalidate_twopass = xe_svm_invalidate_twopass,
 };
 
 static const unsigned long fault_chunk_sizes[] = {
diff --git a/include/drm/drm_gpusvm.h b/include/drm/drm_gpusvm.h
index 8d613e9b2690..8b5e159857fc 100644
--- a/include/drm/drm_gpusvm.h
+++ b/include/drm/drm_gpusvm.h
@@ -63,17 +63,20 @@ struct drm_gpusvm_ops {
 	void (*range_free)(struct drm_gpusvm_range *range);
 
 	/**
-	 * @invalidate: Invalidate GPU SVM notifier (required)
+	 * @invalidate_twopass: Invalidate first pass GPU SVM notifier (required)
 	 * @gpusvm: Pointer to the GPU SVM
 	 * @notifier: Pointer to the GPU SVM notifier
 	 * @mmu_range: Pointer to the mmu_notifier_range structure
+	 * @pass: Pass of MMU notifier, optionally populated driver side
+	 * if a second pass of MMU notifier is desired
 	 *
 	 * Invalidate the GPU page tables. It can safely walk the notifier range
 	 * RB tree/list in this function. Called while holding the notifier lock.
 	 */
-	void (*invalidate)(struct drm_gpusvm *gpusvm,
-			   struct drm_gpusvm_notifier *notifier,
-			   const struct mmu_notifier_range *mmu_range);
+	void (*invalidate_twopass)(struct drm_gpusvm *gpusvm,
+				   struct drm_gpusvm_notifier *notifier,
+				   const struct mmu_notifier_range *mmu_range,
+				   struct mmu_interval_notifier_pass **pass);
 };
 
 /**
-- 
2.50.1


