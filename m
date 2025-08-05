Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4015AC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 10:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D90406B00A0; Tue,  5 Aug 2025 06:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67D66B00A1; Tue,  5 Aug 2025 06:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4D96B00A2; Tue,  5 Aug 2025 06:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC2686B00A0
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 06:58:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C6B8B6BD5
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:58:17 +0000 (UTC)
X-FDA: 83742404634.07.DCB1ABB
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9DDB720005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:58:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OKKRy6jG;
	spf=none (imf03.hostedemail.com: domain of maarten.lankhorst@linux.intel.com has no SPF policy when checking 198.175.65.15) smtp.mailfrom=maarten.lankhorst@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754391495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3//sNl7QRpDdWZ1BStQliSMQe5eplmCG5IazvDgXRlQ=;
	b=MPKspLQbQX3aSouZk1A7lPUn0DHh8PQPOZNcJBqlI8XhqHlsY66rTPdPaR8r6cstwuTSos
	g7JIo1fOUCdRDXzs6908GtrEIg8BjpV+I0zalmxFDpiJpl58ItWjcN7hOMJl9dceAprNuM
	0IyCk+4uSDguCd1XsgHOUpd4vsEju8c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OKKRy6jG;
	spf=none (imf03.hostedemail.com: domain of maarten.lankhorst@linux.intel.com has no SPF policy when checking 198.175.65.15) smtp.mailfrom=maarten.lankhorst@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754391495; a=rsa-sha256;
	cv=none;
	b=za/zEOEbgRhzk3azg/kemx/EO4o4+6TGITOtegTwZhk9WplOBDP3x9tqrvvTXWw68Q6XkU
	0qbdBoZl/zGFxWcXe60L6QD/WdrXXQ6CFnNEXe1DAMRNwbWG64Nq9sCrFHWjn4JM2N1Rg7
	dS0ujLj+Bt1ne05xVCP01ZZeiG4+FfI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754391495; x=1785927495;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LsstS12qwuNbRPypXl7/pCr1CD29AYX3YGKnOtBB/tc=;
  b=OKKRy6jG5/bfxjOhYg1YeeNQVQyttZJWx4q8Ehnp2Br7zrSZ2t3mFlw3
   XKs2OmIzjLDGZYQ8bi9UJOir5XCFUxUbWEOqK+VawIHMxl++g83NV2vHB
   zuGWu57rQMq7xVguhtCb0YOZDrnbpWD/E63fE+i0bhxWTaKKbJ//NoshL
   0Cc3eHZz9gmq/zEWii5cQqmceJI3MXe3nsVCLx0DsuFY00p0JxB5GGpv1
   s9MIXR7T0YGzgl7eXhwne95ioIK8XjPpiP9OXYGhfN0XC0Sr+ZaVryAij
   s5ywEsgnVROL7QtNaqRyTdSlRZetlfd/1y50BKy/r/GMbwVVipB9hOF50
   Q==;
X-CSE-ConnectionGUID: 7H/up/wjTp+BBAnANgt9HA==
X-CSE-MsgGUID: rCVnWyjNSC6K9zOEEJfKHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11512"; a="60321019"
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="60321019"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 03:58:13 -0700
X-CSE-ConnectionGUID: qE3EXGKwR32WYUZypuksaA==
X-CSE-MsgGUID: BgzNqP2cSTe43tHbTPbSdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="195426466"
Received: from jkrzyszt-mobl2.ger.corp.intel.com (HELO [10.245.245.254]) ([10.245.245.254])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2025 03:58:11 -0700
Message-ID: <4a45548a-ad37-4778-b6de-1cda7ce258dc@linux.intel.com>
Date: Tue, 5 Aug 2025 12:58:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: drm/ttm/memcg/lru: enable memcg tracking for ttm and amdgpu
 driver (complete series v2)
To: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>,
 Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>, Kairui Song <kasong@tencent.com>
References: <20250714052243.1149732-1-airlied@gmail.com>
Content-Language: en-US
From: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
In-Reply-To: <20250714052243.1149732-1-airlied@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DDB720005
X-Rspamd-Server: rspam06
X-Stat-Signature: hif3m3awh6p9pw8a8eqrrqsearhunp68
X-HE-Tag: 1754391494-615591
X-HE-Meta: U2FsdGVkX19Gery4gXk+1sKVHMOL0sMAO7eQGHdZleBdAWe0XQipgTNqAUQAa2PyCxKBWECcscD5fddZwr2LLE/v4iWYCIlqqJfwAFOkUXi2i4obPG8uUXq382GToKWJ9ej3BVtPgjfdSlVbh+u/FQ17jKmsW+4vB8Tod7mJmWu9AkQgpykE71HwZSaOkMxBxbqAPG2ZVU8QI2p+licuhylnog8GbsDckj24E+85eN/TmaVh2HS6E6evfn8uQgBcuZrrUQIhA51xz//ZtsUa5fGzfBpqTJmm52PLBSxKo5oxGV+yTGpM/vuUsA5q9CazT4w6/bs8FnALoHhx5DSMYUNNd6uz5u1zfQWOJAsH/0NEIKEUsDLoMxvKNjnex2vYjaXDmS9ZZGhTUDipp5RqSOV8JQHNF8j5Rg9O1DdLbtU0t0QS2t+fNbtbZdKgQc9Or3p1ASZl+5X5bddwXcBDwxKkU8pBlStu2DZocBs3YjWnDJlXtp9qwY5/fWOz2lg+iiYt0MQUe1OJZfN/niTAAdozwprtY4Dp3FsruJyDFfTWtF7yj0lr5WpIP42FA8H9xCek4D/hZxM+qOLYigLbYwoFgjN+yg+jLScUGU2+JtyHMnZlFXHDo+S8t0HFZtKza1oAVeaSMBu5IBViVW46ybZU4SQuyh6RfgpjD68eNXgtiM5UuBuph1Z+rc0ZI8eGuxXyhWN2ddnold8zYm2Z50uopmljY07Ut5YZG2f4zPlSWmTJC8UvXX81l0TJBzLMrHjrIkfFgO/wGvGZSbmA5Z9SNHmlq+eJ4gKgNTUGOF3P3MwMQNx32iSYIuqlZwgn2tHK3c2dzYdn6BRe0OhuSLO04Veh3u/hRbd/8y5E0pS+WB1LblE2lNJ0g7xCicL30tdp704sildX2xcps8btkc/UnKzpHeZmupc5zoP8nPdVjs2i8ao3ad8Mm6RsTXY8aniSJqkUJocf/hGx4yw
 tGJyDIb2
 GWI/rDfiZ4Y4iLL9Y9aQE9ZbIes2fPeY7BMGPPfbeFLwGnySIlR3BVx6QSm1wTAgRFhuBfoG2D6anc3hQ9r0tVeZey9FoMkjgeaK9BoHUk3nIPokXE/t0XeAaGYv/XFoDaRKKlmMUrlifSzOkrxLqEFrPkQ6uDiIV8v3NhBMfRK2qMz3ZZLxb2HKWbDYdxUQYAz0TXrp31Eyl/VipTQhR0P+8U/Hgo+bpNaK/c2xR0+Td1sqzIxN7h/LU8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey,

Den 2025-07-14 kl. 07:18, skrev Dave Airlie:
> Hi all,
> 
> This is a repost with some fixes and cleanups.
> 
> Differences since last posting:
> 1. Added patch 18: add a module option to allow pooled pages to not be stored in the lru per-memcg
>    (Requested by Christian Konig)
> 2. Converged the naming and stats between vmstat and memcg (Suggested by Shakeel Butt)
> 3. Cleaned up the charge/uncharge code and some other bits.
> 
> Dave.
> 
> Original cover letter:
> tl;dr: start using list_lru/numa/memcg in GPU driver core and amdgpu driver for now.
> 
> This is a complete series of patches, some of which have been sent before and reviewed,
> but I want to get the complete picture for others, and try to figure out how best to land this.
> 
> There are 3 pieces to this:
> 01->02: add support for global gpu stat counters (previously posted, patch 2 is newer)
> 03->07: port ttm pools to list_lru for numa awareness
> 08->14: add memcg stats + gpu apis, then port ttm pools to memcg aware list_lru and shrinker
> 15->17: enable amdgpu to use new functionality.
> 
> The biggest difference in the memcg code from previously is I discovered what
> obj cgroups were designed for and I'm reusing the page/objcg intergration that 
> already exists, to avoid reinventing that wheel right now.
> 
> There are some igt-gpu-tools tests I've written at:
> https://gitlab.freedesktop.org/airlied/igt-gpu-tools/-/tree/amdgpu-cgroups?ref_type=heads
> 
> One problem is there are a lot of delayed action, that probably means the testing
> needs a bit more robustness, but the tests validate all the basic paths.
> 
> Regards,
> Dave.
> 
Patch below to enable on xe as well, I ran into some issues though when testing.
After shutting down gdm3/sddm, I ran into a null dereference in mem_cgroup_uncharge_gpu_page()
from ttm_pool_free_page(), presumably because of the objects that were created without a
cgroup set. I tried to fix it in mem_cgroup_uncharge_gpu_page() by conditionally calling
refill_stock(), but that ran into an underflow instead.

Anyway, patch for xe below:
----->8-----------
drm/xe: Enable memcg accounting for TT/system

Create a flag to enable memcg accounting for XE as well.

Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 867087c2d1534..fd93374967c9e 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -54,6 +54,7 @@ static const struct ttm_place sys_placement_flags = {
 	.flags = 0,
 };
 
+/* TTM_PL_FLAG_MEMCG is not set, those placements are used for eviction */
 static struct ttm_placement sys_placement = {
 	.num_placement = 1,
 	.placement = &sys_placement_flags,
@@ -188,6 +189,7 @@ static void try_add_system(struct xe_device *xe, struct xe_bo *bo,
 
 		bo->placements[*c] = (struct ttm_place) {
 			.mem_type = XE_PL_TT,
+			.flags = TTM_PL_FLAG_MEMCG,
 		};
 		*c += 1;
 	}
@@ -1696,6 +1698,8 @@ static void xe_ttm_bo_destroy(struct ttm_buffer_object *ttm_bo)
 
 static void xe_gem_object_free(struct drm_gem_object *obj)
 {
+	struct xe_bo *bo = gem_to_xe_bo(obj);
+
 	/* Our BO reference counting scheme works as follows:
 	 *
 	 * The gem object kref is typically used throughout the driver,
@@ -1709,8 +1713,9 @@ static void xe_gem_object_free(struct drm_gem_object *obj)
 	 * driver ttm callbacks is allowed to use the ttm_buffer_object
 	 * refcount directly if needed.
 	 */
-	__xe_bo_vunmap(gem_to_xe_bo(obj));
-	ttm_bo_put(container_of(obj, struct ttm_buffer_object, base));
+	__xe_bo_vunmap(bo);
+	obj_cgroup_put(bo->ttm.objcg);
+	ttm_bo_put(&bo->ttm);
 }
 
 static void xe_gem_object_close(struct drm_gem_object *obj,
@@ -1951,6 +1956,9 @@ struct xe_bo *___xe_bo_create_locked(struct xe_device *xe, struct xe_bo *bo,
 	placement = (type == ttm_bo_type_sg ||
 		     bo->flags & XE_BO_FLAG_DEFER_BACKING) ? &sys_placement :
 		&bo->placement;
+
+	if (bo->flags & XE_BO_FLAG_ACCOUNTED)
+		bo->ttm.objcg = get_obj_cgroup_from_current();
 	err = ttm_bo_init_reserved(&xe->ttm, &bo->ttm, type,
 				   placement, alignment,
 				   &ctx, NULL, resv, xe_ttm_bo_destroy);
@@ -2726,7 +2734,7 @@ int xe_gem_create_ioctl(struct drm_device *dev, void *data,
 	if (XE_IOCTL_DBG(xe, args->size & ~PAGE_MASK))
 		return -EINVAL;
 
-	bo_flags = 0;
+	bo_flags = XE_BO_FLAG_ACCOUNTED;
 	if (args->flags & DRM_XE_GEM_CREATE_FLAG_DEFER_BACKING)
 		bo_flags |= XE_BO_FLAG_DEFER_BACKING;
 
diff --git a/drivers/gpu/drm/xe/xe_bo.h b/drivers/gpu/drm/xe/xe_bo.h
index 6134d82e80554..e44fc58d9a00f 100644
--- a/drivers/gpu/drm/xe/xe_bo.h
+++ b/drivers/gpu/drm/xe/xe_bo.h
@@ -48,6 +48,7 @@
 #define XE_BO_FLAG_GGTT2		BIT(22)
 #define XE_BO_FLAG_GGTT3		BIT(23)
 #define XE_BO_FLAG_CPU_ADDR_MIRROR	BIT(24)
+#define XE_BO_FLAG_ACCOUNTED		BIT(25)
 
 /* this one is trigger internally only */
 #define XE_BO_FLAG_INTERNAL_TEST	BIT(30)
diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index 540f044bf4255..4db3227d65c04 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -1266,7 +1266,8 @@ static int xe_lrc_init(struct xe_lrc *lrc, struct xe_hw_engine *hwe,
 	bo_flags = XE_BO_FLAG_VRAM_IF_DGFX(tile) | XE_BO_FLAG_GGTT |
 		   XE_BO_FLAG_GGTT_INVALIDATE;
 	if (vm && vm->xef) /* userspace */
-		bo_flags |= XE_BO_FLAG_PINNED_LATE_RESTORE;
+		bo_flags |= XE_BO_FLAG_PINNED_LATE_RESTORE |
+			    XE_BO_FLAG_ACCOUNTED;
 
 	lrc->bo = xe_bo_create_pin_map(xe, tile, NULL, bo_size,
 				       ttm_bo_type_kernel,
diff --git a/drivers/gpu/drm/xe/xe_oa.c b/drivers/gpu/drm/xe/xe_oa.c
index 5729e7d3e3356..569035630ffdf 100644
--- a/drivers/gpu/drm/xe/xe_oa.c
+++ b/drivers/gpu/drm/xe/xe_oa.c
@@ -885,7 +885,7 @@ static int xe_oa_alloc_oa_buffer(struct xe_oa_stream *stream, size_t size)
 
 	bo = xe_bo_create_pin_map(stream->oa->xe, stream->gt->tile, NULL,
 				  size, ttm_bo_type_kernel,
-				  XE_BO_FLAG_SYSTEM | XE_BO_FLAG_GGTT);
+				  XE_BO_FLAG_SYSTEM | XE_BO_FLAG_GGTT | XE_BO_FLAG_ACCOUNTED);
 	if (IS_ERR(bo))
 		return PTR_ERR(bo);
 
diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
index 330cc0f54a3f4..efcd54ab75e92 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -120,7 +120,8 @@ struct xe_pt *xe_pt_create(struct xe_vm *vm, struct xe_tile *tile,
 		   XE_BO_FLAG_IGNORE_MIN_PAGE_SIZE |
 		   XE_BO_FLAG_NO_RESV_EVICT | XE_BO_FLAG_PAGETABLE;
 	if (vm->xef) /* userspace */
-		bo_flags |= XE_BO_FLAG_PINNED_LATE_RESTORE;
+		bo_flags |= XE_BO_FLAG_PINNED_LATE_RESTORE |
+			    XE_BO_FLAG_ACCOUNTED;
 
 	pt->level = level;
 	bo = xe_bo_create_pin_map(vm->xe, tile, vm, SZ_4K,
diff --git a/drivers/gpu/drm/xe/xe_svm.c b/drivers/gpu/drm/xe/xe_svm.c
index 10c8a1bcb86e8..fdf845bb717e0 100644
--- a/drivers/gpu/drm/xe/xe_svm.c
+++ b/drivers/gpu/drm/xe/xe_svm.c
@@ -700,6 +700,7 @@ static int xe_drm_pagemap_populate_mm(struct drm_pagemap *dpagemap,
 	bo = xe_bo_create_locked(vr->xe, NULL, NULL, end - start,
 				 ttm_bo_type_device,
 				 (IS_DGFX(xe) ? XE_BO_FLAG_VRAM(vr) : XE_BO_FLAG_SYSTEM) |
+				 XE_BO_FLAG_ACCOUNTED |
 				 XE_BO_FLAG_CPU_ADDR_MIRROR);
 	if (IS_ERR(bo)) {
 		err = PTR_ERR(bo);


