Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6510CE9B37D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 16:33:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78CF6B008A; Mon,  2 Mar 2026 11:33:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981196B0092; Mon,  2 Mar 2026 11:33:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6DF6B0093; Mon,  2 Mar 2026 11:33:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66E286B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:33:18 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17EB91B6E33
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:18 +0000 (UTC)
X-FDA: 84501668076.13.46D172F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id D042D140005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 16:33:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gF6mtCC2;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772469196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7G3nZXHsqE2yQkCZwW4smxLN8eig4I///zOtQCLjyz4=;
	b=f5PoUzeC/J2kduidBnB46p41HdzZGrF5IbcCKi3dWMDseDHVlqNm8jI6ul3HHT90G2xT49
	lJWI77h6AH7qzQD0/St7M2rHuNl8PE5beO/CZ+lOo71Xi+zlgknBdvA4EPL4U7Ee4w2Ffs
	CWcYia+QXNYujpBC2+DXVR28zI0D7dQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gF6mtCC2;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772469196; a=rsa-sha256;
	cv=none;
	b=psLqDCycqVhPCMyg11wA2stlQ+63rve63pltnVHSpV9TXMJDYiWnUoKQFcAdNEqnleuClx
	LRCYBFs1q0AisregI/tzeS/8En/wMurFcOFbV0WTMw1DAYLXZVANM0bHH9pF1iERK1L7by
	4r+F8Oryz1OAob6bOqOnLvw1YaByA2k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772469196; x=1804005196;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xybYJgKcjIrQv217e/P+1Z/wnP7KMdw9tzTC5IHcWI4=;
  b=gF6mtCC2ciLYaLeBp3UALxze3DaVNWG3C8rqj1uO3Pcp+9KsB5v42150
   kVq82JmBO5rf9+eM6hxWpZaEc8DHYUAePdrYHfmHqvmt49xeFW80nDDuB
   dtjR3D5XefFpcvCC+76zsUKxHRE3qLvsXeVN3zvvuRXNOJXfI1FSRGiFj
   YxE9ps2pL8K/XF+m7A9pw9oum6TbUGVV2sKIcZMONVO+1em7oZW3t2FCU
   VE/AUq/ymBPFSlF6x3OM5beOZFVjj1YGZpQRiSxljjhnK+e9z7lVTe4ZP
   5Yd9zI6bsJanGC0qMokA0BtlLwYO2DjlxZWUWQiOFjqBySrG7Rlp3h2nK
   A==;
X-CSE-ConnectionGUID: cpoqKi+1T/+Y23hXgddW9A==
X-CSE-MsgGUID: ildhtUGpQv6kLFJVuJv9WA==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73447840"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="73447840"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 08:33:15 -0800
X-CSE-ConnectionGUID: HyEPAEjNRT+ouo20DbAkTw==
X-CSE-MsgGUID: wN2u68H7QY274Oz8dz2kMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255564528"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO fedora) ([10.245.244.81])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 08:33:13 -0800
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
Subject: [PATCH v2 2/4] drm/xe/userptr: Convert invalidation to two-pass MMU notifier
Date: Mon,  2 Mar 2026 17:32:46 +0100
Message-ID: <20260302163248.105454-3-thomas.hellstrom@linux.intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
References: <20260302163248.105454-1-thomas.hellstrom@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D042D140005
X-Stat-Signature: 9e87r7yooaztcsfaysyrknmddzbkzubq
X-Rspam-User: 
X-HE-Tag: 1772469195-913381
X-HE-Meta: U2FsdGVkX1823Vs9Ey+DREgrjiNCFdh9ptyU5OrERwSBKib60mSpZsnSJU0wLi4jnP03x668wsntj9fRLbFX/kQHC9MQBF5jja9Q26vmxjmnncD9WKtI8jSdXVe9l9mNh0Eqm81pZC40umSyukjMg+vW/QALqhxVErmhiVjsM4sVLfBBmisHo9kXwxk0K8LDnsKmHhaa6+mB2fsMt02GmR/MA3cQZodeQs05tdMng31PJONd00w2z1Mvj39/da5DRRyrZZqCQTEPxW6C1y6zCg1NupPMHYW8HysIr1sHvoA4NCxoz4KTCYMhhBDneExq8x7bX6EcNuuX4t5gkGIJ4D/c5B3JsCAPSqU0je0DDRpmpnEhtVmSXzr1nKCcSnFc29BcBWtegqxbu1h4W+7BVetKMWJN14Jbp6HfOsGluigPshLmWgMmhPlI1G9cjaRTOZH3C+y2ej3xOQVM7GNIZjC5cyt2TO5t/m2JReczvKVGVAMZuft+PIFr1ZDiNJekeOxVUYzVog5ilJbGvVhDoWtt1vT+ss0s9Et0bwp5uS45PJLdpbqkKrqgpzrXd3zFI6u3yUEOANAJah1Cx/JT4SEdAMXEbXKY9tc8J1P7GO69UHne0XjByvdkJ1GljPOl+FAXZO03BpVO2OkhF20EFiX02kdm24pG5h0uRua8hh7Cn1DISWLPkmE20Kszuwv/65TgqvDkg0mFjvfpT+9uNGRwSNtCFPL9hzuX9uWUGYkCgKWaeUfZU9w8neSICi+h600xbTBfQMHyeTHwvgkTzB6tdcuZMF+LL+EPa1952jNm2zfu0cIB569HCtIKsusL6hRn0T9wrsj1YdEFa3MYMHgGA279ip8OUDazEwLftjwvxVPa2wubQmhiBP3NiBgKS/RLGn/a4uuR+O2ipG4YjJMZTny4S+wZXzmvRuaw0o918cHk4zaas4zasmeOP4vLUPUmb9SZtx626dtjpaN
 t6luquX6
 Dl3i2A57WUEQpCsNMvA2ViWVhjnmINX+usYRwbdbpBvFqs8ijSYMl3RO5NtQGwIrSIgeISbe0g8LDiVoWXp/EOjkkI/G5EvgP67gpLZra0UTbQB6m4peMOZwFKQYg4BJo6u+tEQsnR7UnAgud2kxRcuDu60fPdH1PG77q4jHYKTT0DKd85qsA04cVFJmb1//XvFsMvGHVuO11u77ZRkPxm2kNcFrlt9dVgmigTjR1j+kOUkihlt7CONIeGPsHq9qxeXq7CsvCCF2JySY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In multi-GPU scenarios, asynchronous GPU job latency is a bottleneck if
each notifier waits for its own GPU before returning. The two-pass
mmu_interval_notifier infrastructure allows deferring the wait to a
second pass, so all GPUs can be signalled in the first pass before
any of them are waited on.

Convert the userptr invalidation to use the two-pass model:

Use invalidate_start as the first pass to mark the VMA for repin and
enable software signalling on the VM reservation fences to start any
gpu work needed for signaling. Fall back to completing the work
synchronously if all fences are already signalled, or if a concurrent
invalidation is already using the embedded finish structure.

Use invalidate_finish as the second pass to wait for the reservation
fences to complete, invalidate the GPU TLB in fault mode, and unmap
the gpusvm pages.

Embed a struct mmu_interval_notifier_finish in struct xe_userptr to
avoid dynamic allocation in the notifier callback. Use a finish_inuse
flag to prevent two concurrent invalidations from using it
simultaneously; fall back to the synchronous path for the second caller.

Assisted-by: GitHub Copilot:claude-sonnet-4.6
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
---
 drivers/gpu/drm/xe/xe_userptr.c | 96 +++++++++++++++++++++++++--------
 drivers/gpu/drm/xe/xe_userptr.h | 14 +++++
 2 files changed, 88 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_userptr.c b/drivers/gpu/drm/xe/xe_userptr.c
index e120323c43bc..440b0a79d16f 100644
--- a/drivers/gpu/drm/xe/xe_userptr.c
+++ b/drivers/gpu/drm/xe/xe_userptr.c
@@ -73,18 +73,42 @@ int xe_vma_userptr_pin_pages(struct xe_userptr_vma *uvma)
 				    &ctx);
 }
 
-static void __vma_userptr_invalidate(struct xe_vm *vm, struct xe_userptr_vma *uvma)
+static void xe_vma_userptr_do_inval(struct xe_vm *vm, struct xe_userptr_vma *uvma,
+				    bool is_deferred)
 {
 	struct xe_userptr *userptr = &uvma->userptr;
 	struct xe_vma *vma = &uvma->vma;
-	struct dma_resv_iter cursor;
-	struct dma_fence *fence;
 	struct drm_gpusvm_ctx ctx = {
 		.in_notifier = true,
 		.read_only = xe_vma_read_only(vma),
 	};
 	long err;
 
+	err = dma_resv_wait_timeout(xe_vm_resv(vm),
+				    DMA_RESV_USAGE_BOOKKEEP,
+				    false, MAX_SCHEDULE_TIMEOUT);
+	XE_WARN_ON(err <= 0);
+
+	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
+		err = xe_vm_invalidate_vma(vma);
+		XE_WARN_ON(err);
+	}
+
+	if (is_deferred)
+		userptr->finish_inuse = false;
+	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
+			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
+}
+
+static struct mmu_interval_notifier_finish *
+xe_vma_userptr_invalidate_pass1(struct xe_vm *vm, struct xe_userptr_vma *uvma)
+{
+	struct xe_userptr *userptr = &uvma->userptr;
+	struct xe_vma *vma = &uvma->vma;
+	struct dma_resv_iter cursor;
+	struct dma_fence *fence;
+	bool signaled = true;
+
 	/*
 	 * Tell exec and rebind worker they need to repin and rebind this
 	 * userptr.
@@ -105,27 +129,32 @@ static void __vma_userptr_invalidate(struct xe_vm *vm, struct xe_userptr_vma *uv
 	 */
 	dma_resv_iter_begin(&cursor, xe_vm_resv(vm),
 			    DMA_RESV_USAGE_BOOKKEEP);
-	dma_resv_for_each_fence_unlocked(&cursor, fence)
+	dma_resv_for_each_fence_unlocked(&cursor, fence) {
 		dma_fence_enable_sw_signaling(fence);
+		if (signaled && !dma_fence_is_signaled(fence))
+			signaled = false;
+	}
 	dma_resv_iter_end(&cursor);
 
-	err = dma_resv_wait_timeout(xe_vm_resv(vm),
-				    DMA_RESV_USAGE_BOOKKEEP,
-				    false, MAX_SCHEDULE_TIMEOUT);
-	XE_WARN_ON(err <= 0);
-
-	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
-		err = xe_vm_invalidate_vma(vma);
-		XE_WARN_ON(err);
+	/*
+	 * Only one caller at a time can use the multi-pass state.
+	 * If it's already in use, or all fences are already signaled,
+	 * proceed directly to invalidation without deferring.
+	 */
+	if (signaled || userptr->finish_inuse) {
+		xe_vma_userptr_do_inval(vm, uvma, false);
+		return NULL;
 	}
 
-	drm_gpusvm_unmap_pages(&vm->svm.gpusvm, &uvma->userptr.pages,
-			       xe_vma_size(vma) >> PAGE_SHIFT, &ctx);
+	userptr->finish_inuse = true;
+
+	return &userptr->finish;
 }
 
-static bool vma_userptr_invalidate(struct mmu_interval_notifier *mni,
-				   const struct mmu_notifier_range *range,
-				   unsigned long cur_seq)
+static bool xe_vma_userptr_invalidate_start(struct mmu_interval_notifier *mni,
+					    const struct mmu_notifier_range *range,
+					    unsigned long cur_seq,
+					    struct mmu_interval_notifier_finish **p_finish)
 {
 	struct xe_userptr_vma *uvma = container_of(mni, typeof(*uvma), userptr.notifier);
 	struct xe_vma *vma = &uvma->vma;
@@ -138,21 +167,40 @@ static bool vma_userptr_invalidate(struct mmu_interval_notifier *mni,
 		return false;
 
 	vm_dbg(&xe_vma_vm(vma)->xe->drm,
-	       "NOTIFIER: addr=0x%016llx, range=0x%016llx",
+	       "NOTIFIER PASS1: addr=0x%016llx, range=0x%016llx",
 		xe_vma_start(vma), xe_vma_size(vma));
 
 	down_write(&vm->svm.gpusvm.notifier_lock);
 	mmu_interval_set_seq(mni, cur_seq);
 
-	__vma_userptr_invalidate(vm, uvma);
+	*p_finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
+
 	up_write(&vm->svm.gpusvm.notifier_lock);
-	trace_xe_vma_userptr_invalidate_complete(vma);
+	if (!*p_finish)
+		trace_xe_vma_userptr_invalidate_complete(vma);
 
 	return true;
 }
 
+static void xe_vma_userptr_invalidate_finish(struct mmu_interval_notifier_finish *finish)
+{
+	struct xe_userptr_vma *uvma = container_of(finish, typeof(*uvma), userptr.finish);
+	struct xe_vma *vma = &uvma->vma;
+	struct xe_vm *vm = xe_vma_vm(vma);
+
+	vm_dbg(&xe_vma_vm(vma)->xe->drm,
+	       "NOTIFIER PASS2: addr=0x%016llx, range=0x%016llx",
+		xe_vma_start(vma), xe_vma_size(vma));
+
+	down_write(&vm->svm.gpusvm.notifier_lock);
+	xe_vma_userptr_do_inval(vm, uvma, true);
+	up_write(&vm->svm.gpusvm.notifier_lock);
+	trace_xe_vma_userptr_invalidate_complete(vma);
+}
+
 static const struct mmu_interval_notifier_ops vma_userptr_notifier_ops = {
-	.invalidate = vma_userptr_invalidate,
+	.invalidate_start = xe_vma_userptr_invalidate_start,
+	.invalidate_finish = xe_vma_userptr_invalidate_finish,
 };
 
 #if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
@@ -164,6 +212,7 @@ static const struct mmu_interval_notifier_ops vma_userptr_notifier_ops = {
  */
 void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
 {
+	static struct mmu_interval_notifier_finish *finish;
 	struct xe_vm *vm = xe_vma_vm(&uvma->vma);
 
 	/* Protect against concurrent userptr pinning */
@@ -179,7 +228,10 @@ void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
 	if (!mmu_interval_read_retry(&uvma->userptr.notifier,
 				     uvma->userptr.pages.notifier_seq))
 		uvma->userptr.pages.notifier_seq -= 2;
-	__vma_userptr_invalidate(vm, uvma);
+
+	finish = xe_vma_userptr_invalidate_pass1(vm, uvma);
+	if (finish)
+		xe_vma_userptr_do_inval(vm, uvma, true);
 }
 #endif
 
diff --git a/drivers/gpu/drm/xe/xe_userptr.h b/drivers/gpu/drm/xe/xe_userptr.h
index ef801234991e..4f42db61fd62 100644
--- a/drivers/gpu/drm/xe/xe_userptr.h
+++ b/drivers/gpu/drm/xe/xe_userptr.h
@@ -57,12 +57,26 @@ struct xe_userptr {
 	 */
 	struct mmu_interval_notifier notifier;
 
+	/**
+	 * @finish: MMU notifier finish structure for two-pass invalidation.
+	 * Embedded here to avoid allocation in the notifier callback.
+	 * Protected by @vm::svm.gpusvm.notifier_lock.
+	 */
+	struct mmu_interval_notifier_finish finish;
+	/**
+	 * @finish_inuse: Whether @finish is currently in use by an in-progress
+	 * two-pass invalidation.
+	 * Protected by @vm::svm.gpusvm.notifier_lock.
+	 */
+	bool finish_inuse;
+
 	/**
 	 * @initial_bind: user pointer has been bound at least once.
 	 * write: vm->svm.gpusvm.notifier_lock in read mode and vm->resv held.
 	 * read: vm->svm.gpusvm.notifier_lock in write mode or vm->resv held.
 	 */
 	bool initial_bind;
+
 #if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
 	u32 divisor;
 #endif
-- 
2.53.0


