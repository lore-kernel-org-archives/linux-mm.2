Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD9F4CA0FE1
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7A68E002F; Thu, 21 Aug 2025 07:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 767EF8E0048; Thu, 21 Aug 2025 07:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636958E002F; Thu, 21 Aug 2025 07:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7D88E002F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:46:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C94CD1DA8C1
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:46:55 +0000 (UTC)
X-FDA: 83800587990.03.017834A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id 97EF840011
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:46:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m3m+LXI7;
	spf=none (imf27.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755776813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTRi0Yfe+UTF6fqfdTSduWno3p8pQUg74u6MYzEQ3vU=;
	b=DB6d9jgVL7dRBbRQmx2wRBmLHRwDxT2x4h4w+jko658kxAq1scbV06p11boolFgAqNSjMF
	/y/XOxYeiwHoCBY6z3g2v27/cQJL0Vinx/WmY25ShmSsxdze6qmON1EH4h2U2L8XnP9ZfJ
	eussWbuIx7AisZfpA5Z6kmE916zz370=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755776813; a=rsa-sha256;
	cv=none;
	b=JGDcXIGojJNL60UMjPBGCR16lmBe8YO0LIpi67gzj0ozrEdMw56u67jDzBnWaOaZK9xrsZ
	VcrP3BS8g7n/3wOG7z+8rc8Ru2xvbnUER74RCChvEzlCrlcTnlMpt3OYltin13Gzj46ojm
	XB/uJCAvXkKhuHFKzJ3avex7bypsHfk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m3m+LXI7;
	spf=none (imf27.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755776814; x=1787312814;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9zPtk0Fd79KtAXSij4bOxVEarAOiqZpcZDvJQ12K1oA=;
  b=m3m+LXI7O8fag4Vx1MrerGoA0uegE+sCKnsoaYHw8yzyj5LkoSFPIwTO
   Myg+33yK6GtM1ZMcd3rc6Lih4/vHDuK8AXi4J78NuAkAWWuZYn4PMuGqa
   sj8N+Z2X/LnHE+BxGlZl886MsLlxyovea1QFF+liQ43GCNWd0ElB9VZsm
   kyNq96nmt2fXdgORqjtBQOGWkbk73ryXbscOmNa7egb9NZeRZxXf/Py6N
   iWBb0YPq8T5UiJAPf9vZxVKtPtAmIG68eDpwLs6dwsoFSx71wYExEMDF3
   kRvXsFOqxeG1pQF1TEwKkfVGgJ2i4Ws5Nbo1vVjcmRdXmPmQHeXt2BNKl
   Q==;
X-CSE-ConnectionGUID: gELW6o7bQ2Wf/bqPAQuDPw==
X-CSE-MsgGUID: k4Ja+RF3RRi1mpWCuKOcsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57989451"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="57989451"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:53 -0700
X-CSE-ConnectionGUID: kf1KpAspTQWu/4QcTxvEiA==
X-CSE-MsgGUID: eqUmgzk0RWyZZNS4TzRRwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="172613632"
Received: from johunt-mobl9.ger.corp.intel.com (HELO fedora) ([10.245.245.201])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 04:46:50 -0700
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
Subject: [PATCH 2/6] drm/gpusvm, drm/xe: Update GPU SVM / Xe to twopass MMU notifier
Date: Thu, 21 Aug 2025 13:46:22 +0200
Message-ID: <20250821114626.89818-3-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
References: <20250821114626.89818-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 97EF840011
X-Stat-Signature: dwww5npehn45n85ku4asi7k1pmjze3gt
X-HE-Tag: 1755776813-922174
X-HE-Meta: U2FsdGVkX184Yloz7aKymz5nEXuD3DJ7VkN6lFQdeUJULw/go4DS+kb+NjUUzcOrSqELm+paQ35vKDoISvO33dSnMS3wzgO6+pKc2cAAtDNMDfYp9c1GdRLaJHUWeFkpmy40rA8CmZOayRtwsxaa6SmArApZC3jML2/wSHYsfbBIhVi1VN8VS8yjZ8gdRuDyBdp57KLDC8prrdX5CDyPA2rVvZX8oh4gXEJwqkiH9oYOHH8Q+Npkl6Z60lyTch5tdxIxnD9j9eSTngqB5Ih/AUuWM+ysBhUpzWIigM76TYYIg2DWKC45kBfSAJ6+XokGcasNbnCAhBzCbw0o5sPVTl9t6T2JxwXD0kCXspD5n6y/rN+DXPHCM7yeBaHMXaejHKOmaJRlDOgg1PaMyniZnBmSW66k+YWmKR/Tc6MEJLH+7XbfP/VdX3Y0UlCIaMBNhly9z/aLGayjD7HeN1SkRBdbJ3jm1IqmIZ9l4z6gTnIkYawe0M1CESxbXXBDDx55ud7ZWFtTq3afpoDS+7kIkgomwrC0mPu2etFGFzFd83e8pETyhRbLPFTtQQuRuq5dkURzOWpqRnCXeuacqRwwXECYXN8r5u/LtTQAwmugFxtimx3MY4qHMWd/fsrlUNOj48gJWxXqmvYl58ri4VB6VWBmjXVIsfWNEQ/R/1OCyAl8Q+tFa2gqDIhoRe3w+7G/Pvn/v0jTuqyYOnr5O99rfcPKsMvdSG+fWa9xDDdPeLCKHwrjOfOM3hQ89PomCUF4rnWvqQJZ8nLkRap4GZXeeedpOfsmSfch3l8QjWYXQi1aU1mCg+duYlRhVf+0tt/cCl+mXxmirxIKJ9/nPtYL76eSXdr/5zziqzeqEpYLHek8op9trD7ESJ6sZDpyum7wA/Fq3Nh9W/NVruUoatrsh3mgOVl14vaVssT7aC6dArJTv4l6C6bZgrjbb5LaRdDSgdncZ0PL+FuFwbaRJ6s
 NWf7noBq
 jqmPqHlqizy8+OeMhs+F78ZLKIDWjOdPJ9HoqcZUn6dFbkc/ZJf2FXxcObruMNLJrSZbSgZ0qUo8S97eXMg2glMD4RbJ3cc8sOvFcf9dq3PiEkqm2l5wPyMLi9r1mxuYLiu0L19IYOq72Zc/xyhrEwj7+83wVgph64pc9Ru4+JshoPiFkKEPMf+U2mB4gHT3ksHuC1EE46vqws9IU/oTjPGZ/Og==
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

v1:
- Update function naming and comments.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 drivers/gpu/drm/drm_gpusvm.c | 18 +++++++++++-------
 drivers/gpu/drm/xe/xe_svm.c  |  9 +++++----
 include/drm/drm_gpusvm.h     | 11 +++++++----
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/drm_gpusvm.c b/drivers/gpu/drm/drm_gpusvm.c
index 661306da6b2d..c8d74c728cdd 100644
--- a/drivers/gpu/drm/drm_gpusvm.c
+++ b/drivers/gpu/drm/drm_gpusvm.c
@@ -374,10 +374,13 @@ notifier_iter_first(struct rb_root_cached *root, unsigned long start,
 	     (notifier__) = (next__), (next__) = __drm_gpusvm_notifier_next(notifier__))
 
 /**
- * drm_gpusvm_notifier_invalidate() - Invalidate a GPU SVM notifier.
+ * drm_gpusvm_notifier_invalidate_start() - Invalidate a GPU SVM notifier,
+ * fist pass.
+ *
  * @mni: Pointer to the mmu_interval_notifier structure.
  * @mmu_range: Pointer to the mmu_notifier_range structure.
  * @cur_seq: Current sequence number.
+ * @final: First pass of MMU notifier
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
+drm_gpusvm_notifier_invalidate_start(struct mmu_interval_notifier *mni,
+				     const struct mmu_notifier_range *mmu_range,
+				     unsigned long cur_seq,
+				     struct mmu_interval_notifier_finish **final)
 {
 	struct drm_gpusvm_notifier *notifier =
 		container_of(mni, typeof(*notifier), notifier);
@@ -399,7 +403,7 @@ drm_gpusvm_notifier_invalidate(struct mmu_interval_notifier *mni,
 
 	down_write(&gpusvm->notifier_lock);
 	mmu_interval_set_seq(mni, cur_seq);
-	gpusvm->ops->invalidate(gpusvm, notifier, mmu_range);
+	gpusvm->ops->invalidate_start(gpusvm, notifier, mmu_range, final);
 	up_write(&gpusvm->notifier_lock);
 
 	return true;
@@ -409,7 +413,7 @@ drm_gpusvm_notifier_invalidate(struct mmu_interval_notifier *mni,
  * drm_gpusvm_notifier_ops - MMU interval notifier operations for GPU SVM
  */
 static const struct mmu_interval_notifier_ops drm_gpusvm_notifier_ops = {
-	.invalidate = drm_gpusvm_notifier_invalidate,
+	.invalidate_start = drm_gpusvm_notifier_invalidate_start,
 };
 
 /**
@@ -440,7 +444,7 @@ int drm_gpusvm_init(struct drm_gpusvm *gpusvm,
 		    const struct drm_gpusvm_ops *ops,
 		    const unsigned long *chunk_sizes, int num_chunks)
 {
-	if (!ops->invalidate || !num_chunks)
+	if (!ops->invalidate_start || !num_chunks)
 		return -EINVAL;
 
 	gpusvm->name = name;
diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index e35c6d4def20..309bcf8a50dd 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -171,9 +171,10 @@ xe_svm_range_notifier_event_end(struct xe_vm *vm, struct drm_gpusvm_range *r,
 						   mmu_range);
 }
 
-static void xe_svm_invalidate(struct drm_gpusvm *gpusvm,
-			      struct drm_gpusvm_notifier *notifier,
-			      const struct mmu_notifier_range *mmu_range)
+static void xe_svm_invalidate_start(struct drm_gpusvm *gpusvm,
+				    struct drm_gpusvm_notifier *notifier,
+				    const struct mmu_notifier_range *mmu_range,
+				    struct mmu_interval_notifier_finish **final)
 {
 	struct xe_vm *vm = gpusvm_to_vm(gpusvm);
 	struct xe_device *xe = vm->xe;
@@ -553,7 +554,7 @@ static const struct drm_pagemap_devmem_ops dpagemap_devmem_ops = {
 static const struct drm_gpusvm_ops gpusvm_ops = {
 	.range_alloc = xe_svm_range_alloc,
 	.range_free = xe_svm_range_free,
-	.invalidate = xe_svm_invalidate,
+	.invalidate_start = xe_svm_invalidate_start,
 };
 
 static const unsigned long fault_chunk_sizes[] = {
diff --git a/include/drm/drm_gpusvm.h b/include/drm/drm_gpusvm.h
index 8d613e9b2690..48b90c44849b 100644
--- a/include/drm/drm_gpusvm.h
+++ b/include/drm/drm_gpusvm.h
@@ -63,17 +63,20 @@ struct drm_gpusvm_ops {
 	void (*range_free)(struct drm_gpusvm_range *range);
 
 	/**
-	 * @invalidate: Invalidate GPU SVM notifier (required)
+	 * @invalidate_start: Invalidate first pass GPU SVM notifier (required)
 	 * @gpusvm: Pointer to the GPU SVM
 	 * @notifier: Pointer to the GPU SVM notifier
 	 * @mmu_range: Pointer to the mmu_notifier_range structure
+	 * @final: Final pass of MMU notifier, optionally populated by the driver side
+	 * if a final pass of MMU notifier is desired
 	 *
 	 * Invalidate the GPU page tables. It can safely walk the notifier range
 	 * RB tree/list in this function. Called while holding the notifier lock.
 	 */
-	void (*invalidate)(struct drm_gpusvm *gpusvm,
-			   struct drm_gpusvm_notifier *notifier,
-			   const struct mmu_notifier_range *mmu_range);
+	void (*invalidate_start)(struct drm_gpusvm *gpusvm,
+				 struct drm_gpusvm_notifier *notifier,
+				 const struct mmu_notifier_range *mmu_range,
+				 struct mmu_interval_notifier_finish **final);
 };
 
 /**
-- 
2.50.1


