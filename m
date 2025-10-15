Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C66CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EE8A8E004C; Wed, 15 Oct 2025 11:30:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D138E0005; Wed, 15 Oct 2025 11:30:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58CEF8E004C; Wed, 15 Oct 2025 11:30:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0F38E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6EA1C020E
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:44 +0000 (UTC)
X-FDA: 84000736008.25.C1042EE
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf29.hostedemail.com (Postfix) with ESMTP id A5A88120010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=C7YyY+pF;
	spf=pass (imf29.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=76G+CTM/gYzCKMD9jmtHhxvYQY6paTvRE409Mj8/WvA=;
	b=pRTzKW3WsRxq1e4RgD7CYrIFI1kqGH7BFawNpWqhAr49xNZw5PQhf/nN3h5n1KCOrzNzlZ
	XnM9+KntV/o/N8VRHfGtc1d3bDspj+D3pJw8XMzYin2KER+3+auXfT5ZLw8cUiWc875tU2
	K+6kXP2kUJ2fiesGIxJWDtm534erVK0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=C7YyY+pF;
	spf=pass (imf29.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542243; a=rsa-sha256;
	cv=none;
	b=FyngZVuSMRKrwTHqe/1q5lOgGEGg6Hs11FlXhqEUEryhlyRRI4XzjP8LcxRFEH1vTpZWnX
	MIX9QAy9FdVENIfOG5Eda3VzcxTVB+w68VTVHKfBEROYjijoEMQrAJUF8NvtEeYhx+64H3
	roMGfEfsWSQDDHAhTLzPWXy/bZ4h7QA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542240;
	bh=NNGZxqXvdZMXNrsqK35o/grwPvXGY5zrGR9jS5Fvnhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7YyY+pF+WioRCOzFcpU5hYsJASu/Uwd/V4lI6X7oQeUH5Jfv/iu42d8KI4RpAW3I
	 AiO0dOC47FAIlNc843ATbqQg8U2Y3EbiZu5O1skmd2qD22pADXnlY5gtB3wgIQ6x7A
	 tRk8/u+U6u9hBcKFIAjsBZLT+4LklAdNCEdjDCZcsFmBe8aEYvvgbGB5Wp9snt0j3F
	 XYVLAnDJkqaVjh8E0SP8zd15KTkAiTU9EfXpmUIndLCuvrUXcLWt4yrwKXWANdu+Rz
	 ejp4UyEmTUqodCdMhIB8YfcM2uRn9aLqBh3XJYz7iIY0VjmfiqUSIsU7VzRs687sSQ
	 U1SonWE2VRXEg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9154817E00A3;
	Wed, 15 Oct 2025 17:30:39 +0200 (CEST)
From: =?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>
To: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Herring <robh@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Melissa Wen <mwen@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?Lo=C3=AFc=20Molinari?= <loic.molinari@collabora.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?UTF-8?q?Miko=C5=82aj=20Wasiak?= <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Christopher Healy <healych@amazon.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	kernel@collabora.com
Subject: [PATCH v4 06/13] drm/i915: Use huge tmpfs mount point helper
Date: Wed, 15 Oct 2025 17:30:10 +0200
Message-ID: <20251015153018.43735-7-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A5A88120010
X-Stat-Signature: pp33ogb46w33e6sptrpxmm9sx7w8oagq
X-Rspam-User: 
X-HE-Tag: 1760542242-910791
X-HE-Meta: U2FsdGVkX1/E3bwGf6wI+R09E+RYD75xgo6YG049RMZt6eC2uyjnBhH9+PLq2I8T/q8dP215snOTjjkYDXBwaoCMNoFKVyqyhZLIXJ/f705hyYVlUKmqEvSDDC2+RM6jBCktfW6nIKPPFcCfJOBynALapoQn2yRehHaBVhq0rO209mRHz3YCtmrE6PO9IgQocbSZit5OtUCiiJKED4iVZybrpqmMNTB9XOJw53nN/WhyXYNFEyKegIQFqa9wNPzNKJet8Yt0SY9ethsAuM8bWbIndMkcJgSz28mnYQ6BwFdDubf1etMhZ30H4R4XPtXu7wxtVi/2OHWud5VqPXSlqwtfLl5cMkQqtxvHF+DnQN8j39+ZUNg7j5xJFmy6+TVXeFlmjZzSDsHNX3eeDwjp2uKe9n2+QCDstjdoKDj0pDxQnY/HufHUtETtN+GOhBj9Fv9SkXR9+4u+9zDsWP1zOCOTVK8YBnf36wmp7KemG3DswpGbGpS63arsC6AM0a0dI3XGzkuDYpeIon5cGENfdrPVEFNGe6np4AGr57DKMSNU5FN3CubikkJmmQ4082uKeWBiVXzqtnvLkm7OS2MgUGbjc9eSvvesLlMXV8PX2iXXI5nznTE4UzwTE06amv/xkI3/XespcapdoD9KfBzSuKUElxJb+1bv5xYANUvnLpP2Pvcotmiy+xZCHQOeiLmfImABjWKIBT0OOAuk3fF7FOiCFCmdPINwG7V+E4pXosCAiktp/7KL8+3fntIrqjJBPzcC4dAGNqeEY6LLJVYYyZhwPagxjp3pJ4h9F7wZCM2Y6O1s7VjOu42pswYzOjmFS2fmwDFjW2mSFxeJ5wT5deDwFW/r8SPaxIkSFMYjcRcsh53wpCisoEtLFLhq5KdivtQ8RA5d6KaiOyh1Gpuf30RKn5CBfwxVNBEmmviYoTQ1hXZDC/Aq3le3Qpe0HxbTUNeiSQx8fkIsXIk0CKS
 T5GntDI3
 2L5mHE3mMGp9r+Jwq3yD5bSWcPzzkwR2F57h25s4skVJNVbaSYeQZCMJM1xo/eyikoWN859x37Vs71x9urK8DkpE3+hH/cTpYhrjQ9B5wv2g5U/ct3TV1umyuRH58GFe6rHVA+SqvUXWNXoLbK4kWwlgWGdalWz6C91kW+u70Gnqe9pcPR+u/quYQUenKY/dDr6ZLwKdE/gZ3mvbUKq+oOeSoKCpP9A3FrjfBZ5C5JHotwQMX76b3unubM5aEHT8cdJRCdKB0NXCLXlz75MRW4jKgQ/cQ6mhCWAecgiCS+6JBtv0oC2yxYUarqMfrwZEvUzz7gXosCbPSfbs5Mmna0D0/ElGTP8vJ2mQC23BUDE4j+v3B9UwSAWHUwXUE3Y++ci/T
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new drm_gem_huge_mnt_create() helper to avoid code
duplication. Now that it's just a few lines long, the single function
in i915_gemfs.c is moved into v3d_gem_shmem.c.

v3:
- use huge tmpfs mountpoint in drm_device
- move i915_gemfs.c into i915_gem_shmem.c

v4:
- clean up mountpoint creation error handling

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/i915/Makefile                 |  3 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     | 47 +++++++++----
 drivers/gpu/drm/i915/gem/i915_gemfs.c         | 69 -------------------
 drivers/gpu/drm/i915/gem/i915_gemfs.h         | 14 ----
 .../gpu/drm/i915/gem/selftests/huge_pages.c   | 10 +--
 drivers/gpu/drm/i915/i915_drv.h               |  5 --
 6 files changed, 40 insertions(+), 108 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h

diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index e58c0c158b3a..e22393a7cf6f 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -163,8 +163,7 @@ gem-y += \
 	gem/i915_gem_ttm_move.o \
 	gem/i915_gem_ttm_pm.o \
 	gem/i915_gem_userptr.o \
-	gem/i915_gem_wait.o \
-	gem/i915_gemfs.o
+	gem/i915_gem_wait.o
 i915-y += \
 	$(gem-y) \
 	i915_active.o \
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index b9dae15c1d16..a72d98f1202f 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -9,14 +9,15 @@
 #include <linux/uio.h>
 
 #include <drm/drm_cache.h>
+#include <drm/drm_gem.h>
 
 #include "gem/i915_gem_region.h"
 #include "i915_drv.h"
 #include "i915_gem_object.h"
 #include "i915_gem_tiling.h"
-#include "i915_gemfs.h"
 #include "i915_scatterlist.h"
 #include "i915_trace.h"
+#include "i915_utils.h"
 
 /*
  * Move folios to appropriate lru and release the batch, decrementing the
@@ -506,9 +507,9 @@ static int __create_shmem(struct drm_i915_private *i915,
 	if (BITS_PER_LONG == 64 && size > MAX_LFS_FILESIZE)
 		return -E2BIG;
 
-	if (i915->mm.gemfs)
-		filp = shmem_file_setup_with_mnt(i915->mm.gemfs, "i915", size,
-						 flags);
+	if (i915->drm.huge_mnt)
+		filp = shmem_file_setup_with_mnt(i915->drm.huge_mnt, "i915",
+						 size, flags);
 	else
 		filp = shmem_file_setup("i915", size, flags);
 	if (IS_ERR(filp))
@@ -635,21 +636,41 @@ i915_gem_object_create_shmem_from_data(struct drm_i915_private *i915,
 
 static int init_shmem(struct intel_memory_region *mem)
 {
-	i915_gemfs_init(mem->i915);
-	intel_memory_region_set_name(mem, "system");
+	struct drm_i915_private *i915 = mem->i915;
+	int err;
 
-	return 0; /* We have fallback to the kernel mnt if gemfs init failed. */
-}
+	/*
+	 * By creating our own shmemfs mountpoint, we can pass in
+	 * mount flags that better match our usecase.
+	 *
+	 * One example, although it is probably better with a per-file
+	 * control, is selecting huge page allocations ("huge=within_size").
+	 * However, we only do so on platforms which benefit from it, or to
+	 * offset the overhead of iommu lookups, where with latter it is a net
+	 * win even on platforms which would otherwise see some performance
+	 * regressions such a slow reads issue on Broadwell and Skylake.
+	 */
 
-static int release_shmem(struct intel_memory_region *mem)
-{
-	i915_gemfs_fini(mem->i915);
-	return 0;
+	if (GRAPHICS_VER(i915) < 11 && !i915_vtd_active(i915))
+		goto no_thp;
+
+	err = drm_gem_huge_mnt_create(&i915->drm, "within_size");
+	if (i915->drm.huge_mnt)
+		drm_info(&i915->drm, "Using Transparent Hugepages\n");
+	else if (err)
+		drm_notice(&i915->drm,
+			   "Transparent Hugepage support is recommended for optimal performance%s\n",
+			   GRAPHICS_VER(i915) >= 11 ? " on this platform!" :
+						      " when IOMMU is enabled!");
+
+ no_thp:
+	intel_memory_region_set_name(mem, "system");
+
+	return 0; /* We have fallback to the kernel mnt if huge mnt failed. */
 }
 
 static const struct intel_memory_region_ops shmem_region_ops = {
 	.init = init_shmem,
-	.release = release_shmem,
 	.init_object = shmem_object_init,
 };
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gemfs.c b/drivers/gpu/drm/i915/gem/i915_gemfs.c
deleted file mode 100644
index 8f13ec4ff0d0..000000000000
--- a/drivers/gpu/drm/i915/gem/i915_gemfs.c
+++ /dev/null
@@ -1,69 +0,0 @@
-// SPDX-License-Identifier: MIT
-/*
- * Copyright © 2017 Intel Corporation
- */
-
-#include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/fs_context.h>
-
-#include "i915_drv.h"
-#include "i915_gemfs.h"
-#include "i915_utils.h"
-
-void i915_gemfs_init(struct drm_i915_private *i915)
-{
-	struct file_system_type *type;
-	struct fs_context *fc;
-	struct vfsmount *gemfs;
-	int ret;
-
-	/*
-	 * By creating our own shmemfs mountpoint, we can pass in
-	 * mount flags that better match our usecase.
-	 *
-	 * One example, although it is probably better with a per-file
-	 * control, is selecting huge page allocations ("huge=within_size").
-	 * However, we only do so on platforms which benefit from it, or to
-	 * offset the overhead of iommu lookups, where with latter it is a net
-	 * win even on platforms which would otherwise see some performance
-	 * regressions such a slow reads issue on Broadwell and Skylake.
-	 */
-
-	if (GRAPHICS_VER(i915) < 11 && !i915_vtd_active(i915))
-		return;
-
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
-		goto err;
-
-	type = get_fs_type("tmpfs");
-	if (!type)
-		goto err;
-
-	fc = fs_context_for_mount(type, SB_KERNMOUNT);
-	if (IS_ERR(fc))
-		goto err;
-	ret = vfs_parse_fs_string(fc, "source", "tmpfs");
-	if (!ret)
-		ret = vfs_parse_fs_string(fc, "huge", "within_size");
-	if (!ret)
-		gemfs = fc_mount_longterm(fc);
-	put_fs_context(fc);
-	if (ret)
-		goto err;
-
-	i915->mm.gemfs = gemfs;
-	drm_info(&i915->drm, "Using Transparent Hugepages\n");
-	return;
-
-err:
-	drm_notice(&i915->drm,
-		   "Transparent Hugepage support is recommended for optimal performance%s\n",
-		   GRAPHICS_VER(i915) >= 11 ? " on this platform!" :
-					      " when IOMMU is enabled!");
-}
-
-void i915_gemfs_fini(struct drm_i915_private *i915)
-{
-	kern_unmount(i915->mm.gemfs);
-}
diff --git a/drivers/gpu/drm/i915/gem/i915_gemfs.h b/drivers/gpu/drm/i915/gem/i915_gemfs.h
deleted file mode 100644
index 16d4333c9a4e..000000000000
--- a/drivers/gpu/drm/i915/gem/i915_gemfs.h
+++ /dev/null
@@ -1,14 +0,0 @@
-/* SPDX-License-Identifier: MIT */
-/*
- * Copyright © 2017 Intel Corporation
- */
-
-#ifndef __I915_GEMFS_H__
-#define __I915_GEMFS_H__
-
-struct drm_i915_private;
-
-void i915_gemfs_init(struct drm_i915_private *i915);
-void i915_gemfs_fini(struct drm_i915_private *i915);
-
-#endif
diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
index bd08605a1611..b41a38af63fd 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
 
 static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
 {
-	return i915->mm.gemfs && has_transparent_hugepage();
+	return i915->drm.huge_mnt && has_transparent_hugepage();
 }
 
 static struct drm_i915_gem_object *
@@ -1761,7 +1761,7 @@ static int igt_tmpfs_fallback(void *arg)
 	struct drm_i915_private *i915 = arg;
 	struct i915_address_space *vm;
 	struct i915_gem_context *ctx;
-	struct vfsmount *gemfs = i915->mm.gemfs;
+	struct vfsmount *huge_mnt = i915->drm.huge_mnt;
 	struct drm_i915_gem_object *obj;
 	struct i915_vma *vma;
 	struct file *file;
@@ -1782,10 +1782,10 @@ static int igt_tmpfs_fallback(void *arg)
 	/*
 	 * Make sure that we don't burst into a ball of flames upon falling back
 	 * to tmpfs, which we rely on if on the off-chance we encounter a failure
-	 * when setting up gemfs.
+	 * when setting up a huge mountpoint.
 	 */
 
-	i915->mm.gemfs = NULL;
+	i915->drm.huge_mnt = NULL;
 
 	obj = i915_gem_object_create_shmem(i915, PAGE_SIZE);
 	if (IS_ERR(obj)) {
@@ -1819,7 +1819,7 @@ static int igt_tmpfs_fallback(void *arg)
 out_put:
 	i915_gem_object_put(obj);
 out_restore:
-	i915->mm.gemfs = gemfs;
+	i915->drm.huge_mnt = huge_mnt;
 
 	i915_vm_put(vm);
 out:
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 6a768aad8edd..1bfee23e64a3 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -141,11 +141,6 @@ struct i915_gem_mm {
 	 */
 	atomic_t free_count;
 
-	/**
-	 * tmpfs instance used for shmem backed objects
-	 */
-	struct vfsmount *gemfs;
-
 	struct intel_memory_region *regions[INTEL_REGION_UNKNOWN];
 
 	struct notifier_block oom_notifier;
-- 
2.47.3


