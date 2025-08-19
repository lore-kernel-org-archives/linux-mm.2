Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D878CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7AF38E0045; Tue, 19 Aug 2025 07:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2BBD8E0042; Tue, 19 Aug 2025 07:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1ABE8E0045; Tue, 19 Aug 2025 07:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C1E388E0042
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:49:55 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 845EC83E30
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:49:55 +0000 (UTC)
X-FDA: 83793337950.11.73487D9
Received: from lankhorst.se (lankhorst.se [141.105.120.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id DE0B61C000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:49:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf18.hostedemail.com: domain of mlankhorst@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=mlankhorst@lankhorst.se
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755604194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xs/aFm4JWfeqf01+mB0++vsLzDwOw9Zz4dlZSpPreGc=;
	b=K3Z9KC/vsvwMe/TVD+gXRuYCdsAXafvFEw2MjSVrJsQ0EcBXAxaZ2K4V7tHH6Y3YvShVpJ
	xYNDcyhbU4BCMIjJcdZvaJaxeqzNlL+7Y1uZm3SP35J9CeQfODenM2vgmAIRUNzweIKluy
	pPyzDWy9vdfiZaGMm32Jy2tVocVnKTA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lankhorst.se;
	spf=pass (imf18.hostedemail.com: domain of mlankhorst@lankhorst.se designates 141.105.120.124 as permitted sender) smtp.mailfrom=mlankhorst@lankhorst.se
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755604194; a=rsa-sha256;
	cv=none;
	b=Lo0mzg+y5HBOXmqaA5SIeY6vApJqvGY3hhNJomeHB9GD7qEA0vzj7M3tiUEafYcVI919i2
	GGiPRScUSvfWg4W8YtL6WdlB3nDMP8I51P+0UHJBBKIYG9IhDFHkj84VzAMM9EQ8y+Dpeq
	ZV0cTCFi3XCMw+oqF+YnqL3mHfoZY1o=
From: Maarten Lankhorst <dev@lankhorst.se>
To: Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?=27Thomas=20Hellstr=C3=B6m=27?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <natalie.vock@gmx.de>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?=27Michal=20Koutn=C3=BD=27?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"'Liam R . Howlett'" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC 3/3] drm/xe: Add DRM_XE_GEM_CREATE_FLAG_PINNED flag and implementation
Date: Tue, 19 Aug 2025 13:49:36 +0200
Message-ID: <20250819114932.597600-8-dev@lankhorst.se>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250819114932.597600-5-dev@lankhorst.se>
References: <20250819114932.597600-5-dev@lankhorst.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rh6d4r784q3ctr9weugcyj5jtyppk9r9
X-Rspam-User: 
X-Rspamd-Queue-Id: DE0B61C000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755604193-85939
X-HE-Meta: U2FsdGVkX1/QnLmM/J8DKIK9Cxzaf3JV7tKAJFdzCfL7pYiRkfFU8VuhAGFYDcO64ApLM7E7Gyg1BGr6vrAW2AvMzuOKlh2FqkzRxrCIRvv50kiMtXma8iaUV13hXsXsiJxokBHJD7q3DSowvm3n9pQKbrIbWMIoE9Klz5n7Fq7mERlpPkdOM1yudnyPzhNLJA/hbcBtrfQa2mKk/E+CSJZrWGnPibK3gFaF+LoO1QDocJXAueMJQEJbNkXXSlzOBtcV6jqJY5m7ZdguggMwUJRKd39CbPTR9trYHn5lA2jId7QcfdEFTGfxEQvbhQWzfMpKxC/YY7waM2+G2A6Z7sZDKgsY9Pin1YMKmQsVt4AC5PuIuH5vcAjJhLzQgwRd+K9BtSOgLbrwYhSsmVe7xNduEYosSvKVqmKxm0NESOsPedni4FYeyz5A2VYloJlttfzVsieDAb2ME3MDVHfNF2RLjDSYY9W1vknBNs8noQD7AgOpExp6agpwYE1AJfHPPees7s7Dn8PnAvmIAVNsZfAyPchhMgLO9RpnYdZ4FE2r2LOsh7iNavisxWB6fbMDzezUmISqTvIjPZPowNW6ojf6eHn0u/WkNvcyY/JKsJhR+bE+hQvG1HyLA05z9dk1n85DKsaU36CWGM+q+MGAbwGITEUa5HwRdMSrkt/GsExprv0KXfY2pxoz7U4Kr4Ikvvp8s9MJ7fXkIUYRmc/JeHphZG0ZaDh10SaE08cRrLJjf4wt4FB6lSG/y0OmByr2lMyIuHi1QSP4+4S+InKSYiCv/6qYlOtJDz2WciUbG0IUtmD3UQL/hlEh+kNe1NPxQq1/FXFwtj95Linsks2CuavbOoD//W4Xvp6O1TjV920g+YZvm6W3iAon9kwvODoovZ/r2bmrjR3pBFGhZvzOsd4JRE/EGyJt8xf12kPOsF0oa1K0QLyVpPhkcUCkRnkT9rlhPE1/JGmxzg2t4JK
 x5mJ8YvF
 qLa+wyoIiDYbRr0nhPtxOjhY/aHtKwgsT6HAuhr6edBlxBHu4L5LThT2ZXYKX7I/ignykJW7PK0Kr5voBV4kwWIvuOAckXLJbh0bzFZb0es/ow5LfNbFscoU0tAkng4UOVWthCSQ3IZyS1WJBoHLA4RRj6THJb87Ypbbc4WH42jzDyrdqySu5aEDE2cmVWzDA5VREsM5s/V/FMec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an option to pin memory through the science of cgroup accounting.
A bo will be pinned for its entire lifetime, and this allows buffers
that are pinned for dma-buf export without requiring the pinning to be
done at the dma-buf layer for all devices.

For now only implement VRAM pinning. Dave Airlie has a series to implement
memcg accounting for the GPU but that is not ready yet.

Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
---
 drivers/gpu/drm/xe/xe_bo.c      | 66 ++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/xe/xe_dma_buf.c | 10 ++++-
 include/uapi/drm/xe_drm.h       | 10 ++++-
 3 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 6fea39842e1e6..4095e6bd04ea9 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -5,6 +5,7 @@
 
 #include "xe_bo.h"
 
+#include <linux/cgroup_dmem.h>
 #include <linux/dma-buf.h>
 #include <linux/nospec.h>
 
@@ -208,7 +209,8 @@ static bool force_contiguous(u32 bo_flags)
 	 * must be contiguous, also only contiguous BOs support xe_bo_vmap.
 	 */
 	return bo_flags & XE_BO_FLAG_NEEDS_CPU_ACCESS &&
-	       bo_flags & XE_BO_FLAG_PINNED;
+	       bo_flags & XE_BO_FLAG_PINNED &&
+	       !(bo_flags & XE_BO_FLAG_USER);
 }
 
 static void add_vram(struct xe_device *xe, struct xe_bo *bo,
@@ -1697,6 +1699,16 @@ static void xe_gem_object_free(struct drm_gem_object *obj)
 	ttm_bo_put(container_of(obj, struct ttm_buffer_object, base));
 }
 
+static void xe_bo_unpin_user(struct xe_bo *bo)
+{
+	xe_bo_unpin_external(bo);
+
+	if (bo->flags & XE_BO_FLAG_SYSTEM)
+		WARN_ON(1);
+	else
+		dmem_cgroup_unpin(bo->ttm.resource->css, xe_bo_size(bo));
+}
+
 static void xe_gem_object_close(struct drm_gem_object *obj,
 				struct drm_file *file_priv)
 {
@@ -1708,6 +1720,10 @@ static void xe_gem_object_close(struct drm_gem_object *obj,
 		xe_bo_lock(bo, false);
 		ttm_bo_set_bulk_move(&bo->ttm, NULL);
 		xe_bo_unlock(bo);
+	} else if (bo->flags & XE_BO_FLAG_PINNED) {
+		xe_bo_lock(bo, false);
+		xe_bo_unpin_user(bo);
+		xe_bo_unlock(bo);
 	}
 }
 
@@ -2128,8 +2144,27 @@ struct xe_bo *xe_bo_create_user(struct xe_device *xe, struct xe_tile *tile,
 	struct xe_bo *bo = __xe_bo_create_locked(xe, tile, vm, size, 0, ~0ULL,
 						 cpu_caching, ttm_bo_type_device,
 						 flags | XE_BO_FLAG_USER, 0);
-	if (!IS_ERR(bo))
+	if (!IS_ERR(bo)) {
+		int ret = 0;
+
+		if (bo->flags & XE_BO_FLAG_PINNED) {
+			if (bo->flags & XE_BO_FLAG_SYSTEM) {
+				ret = -ENOSYS; // TODO
+			} else {
+				ret = dmem_cgroup_try_pin(bo->ttm.resource->css, size);
+			}
+			if (!ret)
+				ret = xe_bo_pin_external(bo);
+			else if (ret == -EAGAIN)
+				ret = -ENOSPC;
+		}
+
 		xe_bo_unlock_vm_held(bo);
+		if (ret) {
+			xe_bo_put(bo);
+			return ERR_PTR(ret);
+		}
+	}
 
 	return bo;
 }
@@ -2745,6 +2780,28 @@ int xe_gem_create_ioctl(struct drm_device *dev, void *data,
 			 args->cpu_caching == DRM_XE_GEM_CPU_CACHING_WB))
 		return -EINVAL;
 
+	if (XE_IOCTL_DBG(xe, args->flags & DRM_XE_GEM_CREATE_FLAG_PINNED)) {
+		bool pinned_flag = true;
+		/* Only allow a single placement for pinning */
+		if (XE_IOCTL_DBG(xe, pinned_flag && hweight32(args->placement) != 1))
+			return -EINVAL;
+
+		/* Meant for exporting, do not allow a VM-local BO */
+		if (XE_IOCTL_DBG(xe, pinned_flag && args->vm_id))
+			return -EINVAL;
+
+		/* Similarly, force fail at creation time for now. We may relax this requirement later */
+		if (XE_IOCTL_DBG(xe, pinned_flag && args->flags & DRM_XE_GEM_CREATE_FLAG_DEFER_BACKING))
+			return -EINVAL;
+
+		/* Require the appropriate cgroups to be enabled. */
+		if (XE_IOCTL_DBG(xe, pinned_flag && !IS_ENABLED(CONFIG_CGROUP_DMEM) && bo_flags & XE_BO_FLAG_VRAM_MASK) ||
+		    XE_IOCTL_DBG(xe, pinned_flag && !IS_ENABLED(CONFIG_MEMCG) && bo_flags & XE_BO_FLAG_SYSTEM))
+			return -EINVAL;
+
+		bo_flags |= XE_BO_FLAG_PINNED;
+	}
+
 	if (args->vm_id) {
 		vm = xe_vm_lookup(xef, args->vm_id);
 		if (XE_IOCTL_DBG(xe, !vm))
@@ -2790,6 +2847,11 @@ int xe_gem_create_ioctl(struct drm_device *dev, void *data,
 		__xe_bo_unset_bulk_move(bo);
 		xe_vm_unlock(vm);
 	}
+	if (bo->flags & XE_BO_FLAG_PINNED) {
+		xe_bo_lock(bo, false);
+		xe_bo_unpin_user(bo);
+		xe_bo_unlock(bo);
+	}
 out_put:
 	xe_bo_put(bo);
 out_vm:
diff --git a/drivers/gpu/drm/xe/xe_dma_buf.c b/drivers/gpu/drm/xe/xe_dma_buf.c
index 346f857f38374..6719f4552ad37 100644
--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -53,6 +53,11 @@ static int xe_dma_buf_pin(struct dma_buf_attachment *attach)
 	struct xe_device *xe = xe_bo_device(bo);
 	int ret;
 
+	if (bo->flags & XE_BO_FLAG_PINNED) {
+		ttm_bo_pin(&bo->ttm);
+		return 0;
+	}
+
 	/*
 	 * For now only support pinning in TT memory, for two reasons:
 	 * 1) Avoid pinning in a placement not accessible to some importers.
@@ -83,7 +88,10 @@ static void xe_dma_buf_unpin(struct dma_buf_attachment *attach)
 	struct drm_gem_object *obj = attach->dmabuf->priv;
 	struct xe_bo *bo = gem_to_xe_bo(obj);
 
-	xe_bo_unpin_external(bo);
+	if (bo->flags & XE_BO_FLAG_PINNED)
+		ttm_bo_unpin(&bo->ttm);
+	else
+		xe_bo_unpin_external(bo);
 }
 
 static struct sg_table *xe_dma_buf_map(struct dma_buf_attachment *attach,
diff --git a/include/uapi/drm/xe_drm.h b/include/uapi/drm/xe_drm.h
index c721e130c1d2d..3184fa38ce17e 100644
--- a/include/uapi/drm/xe_drm.h
+++ b/include/uapi/drm/xe_drm.h
@@ -765,12 +765,15 @@ struct drm_xe_device_query {
  *    until the object is either bound to a virtual memory region via
  *    VM_BIND or accessed by the CPU. As a result, no backing memory is
  *    reserved at the time of GEM object creation.
- *  - %DRM_XE_GEM_CREATE_FLAG_SCANOUT
+ *  - %DRM_XE_GEM_CREATE_FLAG_SCANOUT - GEM object will be used
+ *    display framebuffer.
  *  - %DRM_XE_GEM_CREATE_FLAG_NEEDS_VISIBLE_VRAM - When using VRAM as a
  *    possible placement, ensure that the corresponding VRAM allocation
  *    will always use the CPU accessible part of VRAM. This is important
  *    for small-bar systems (on full-bar systems this gets turned into a
  *    noop).
+ *  - %DRM_XE_GEM_CREATE_FLAG_PINNED - Pin the backing memory permanently
+ *    on allocation, if withing cgroups limits.
  *    Note1: System memory can be used as an extra placement if the kernel
  *    should spill the allocation to system memory, if space can't be made
  *    available in the CPU accessible part of VRAM (giving the same
@@ -781,6 +784,10 @@ struct drm_xe_device_query {
  *    need to use VRAM for display surfaces, therefore the kernel requires
  *    setting this flag for such objects, otherwise an error is thrown on
  *    small-bar systems.
+ *    Note3: %DRM_XE_GEM_CREATE_FLAG_PINNED requires the BO to have only
+ *    a single placement, no vm_id, requires (device) memory cgroups enabled,
+ *    and is incompatible with the %DEFER_BACKING and %NEEDS_VISIBLE_VRAM
+ *    flags.
  *
  * @cpu_caching supports the following values:
  *  - %DRM_XE_GEM_CPU_CACHING_WB - Allocate the pages with write-back
@@ -827,6 +834,7 @@ struct drm_xe_gem_create {
 #define DRM_XE_GEM_CREATE_FLAG_DEFER_BACKING		(1 << 0)
 #define DRM_XE_GEM_CREATE_FLAG_SCANOUT			(1 << 1)
 #define DRM_XE_GEM_CREATE_FLAG_NEEDS_VISIBLE_VRAM	(1 << 2)
+#define DRM_XE_GEM_CREATE_FLAG_PINNED			(1 << 3)
 	/**
 	 * @flags: Flags, currently a mask of memory instances of where BO can
 	 * be placed
-- 
2.50.0


