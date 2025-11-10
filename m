Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B570DCD13DE
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B338E002B; Mon, 10 Nov 2025 10:50:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1FC98E002E; Mon, 10 Nov 2025 10:50:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A342F8E002B; Mon, 10 Nov 2025 10:50:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 854D58E002E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3F6B816012C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:15 +0000 (UTC)
X-FDA: 84095133990.16.A94D754
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5917E4000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IAYig12n;
	spf=pass (imf12.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7qZo3spaoeH4FHX1NprJVejzcckVUvdFsQiq4zdDAo=;
	b=nzFC8BvJDHHL/CM+Zt2QDy/VEZJTJfHsj4TkCOaPmOR5p6dsQ79dqUsciefNBFtqZS8uAa
	dXZIRSh8wHfcI9jMmr8T1VCqtMaotoZruf8puT47kJs8LgjrwznigLMW3W8GCDrKfImaS6
	t3wUkD/x5sRa8wA9zv/7T1WfnrBFRA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789813; a=rsa-sha256;
	cv=none;
	b=GV8OcRdwhqdYjJqo7rO/gtX9ED8ze6Pdag1Fg0C2Q5dxtZISOoDcUmx3pT0R1jAnIEL4Zv
	hPN2//jUdvqnEN+zReLFmnz/Y1UVjk36LLaWLgQRkLhBFhPUliX5PJfyUBv9bJ47Uli1+w
	wpHFtO7n9sfJypAyG+YGs7rqCCVff78=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IAYig12n;
	spf=pass (imf12.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789812;
	bh=W3I4REPB257DpLvZHH/+RQ7946QS1ctC6ANIb05qFTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAYig12nQt7XUAjU5sWd49aNPS40h4dRUS1a/1eG9ex4qNSadNtlMwdL1JvnfeFXy
	 Usgqo6dnaxrZ/3EqfMM4/JQYkBD2L705Fc0rHTNJuCaRgTmpcGlrzqQ8nwAGh8k0+y
	 6jLYerEJ1XmWCo9cZbsUgrUubpMyCRsh96m/No22bNsUllhfcmcAPnft/yHKuhB7+N
	 v/0Vc0isO8caTnhoPduoMjnIhyy5ebOxm6RKTe1b1NCWJqf6PHsiZNQT5DrjCz2f1U
	 5Nh6psNhdf5+m7+1AJgMyjVC6p1zcgEBjO9viH1yS3zr447fuC5b4ncWIqI2y+PCws
	 H4d0vYWzYvYkg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2281E17E1401;
	Mon, 10 Nov 2025 16:50:11 +0100 (CET)
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
Subject: [PATCH v7 05/11] drm/i915: Use huge tmpfs mountpoint helpers
Date: Mon, 10 Nov 2025 16:49:53 +0100
Message-ID: <20251110155000.2936-6-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110155000.2936-1-loic.molinari@collabora.com>
References: <20251110155000.2936-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5917E4000F
X-Stat-Signature: xu4exfdz9nu9w8khjc5o4soz8tnxgz9m
X-Rspam-User: 
X-HE-Tag: 1762789813-454508
X-HE-Meta: U2FsdGVkX18fpnGfiBmyG8GyoM+Vsj/1lDFi3WLVseAHRb6Z/UegMv2sWQacyhUon+x698gmw+3j5oyZK2fPnmY9/Hx+d+qgSaxv8jImirXoE5gXrq5MFw7sYyyBOoCIjDHJN0+pbAEEA0nb96hcnbEUN6k/fTdpMP3z2DYYWUFvLRhta+HccEmxpOtt/WOi6CXczUIUCW+6SAALbzRy4wTctXJdAD4KDYzEbxQzapVQqubxyQRMneZ9u7CdRzCqtt+rrqxJf/k2ONXhFdPVOJ9gR5ETJR2bjwpLo82a+DMqgGUaxu+Gf+6hB0yeQhnL/WG4+3I2SiRgCTosHjJdfnHrVrzizH/SbZBaJg3VoBxQoD77xdrp8O16CH6Vl3+fMKHg5BBt2SyYR8TrVMihpC6IMuzwAHNxocUu2KFEICSKnL7YUOKMaJXoUS1F5GE+sm5N6q35JMWRQNU/tGhut21zfKtCCJPNa1PzfwUunlnNPlTQvvhFzVz6zZhsFoDsbWPZwXOY695ASPT/YhzoCG5WTtwxgyOyxkiFzRoO8Do4FlZsonsxgkvDmd24t9NEKFnY94WU6b96tDSW96B6lm7Hm58dKf0yEGOOvHBXP6OebWJmYBXXuZPH3jPTE4HxwklmIp5jd29s2N5C385dIFovpT03BmSXEFpBhFWm+y6e4Y8TZoSdAY/QRiKV2ybr7JBpZTvv2Wu6ruBW3ECLd3PNcYEWc8pZr1JkJ2DP6rrwZEucr0YHUAX5I6LUqKwMHrDYSGu7qMCk3CrI9H7JNIxDSbUZim1woF0AzzLWCMTMuxGY/EEH8iJE9jQH01mbYlaUuumGsduYFRyPsw0tehltJx5FfX5vp73tb+VNlQ/KUFLYC9sbCOa+XVTJhBlWmHMwJZUSsr2fN0b0qRoeIs7VwZXsEhJt1kklgXCnLPre9Q9k5vOcjCzkJ8doKt07fVRY4HIS0xSZbUlzpR3
 WGWTwPrb
 4PeSawPKjXEsoXSv7IYAZuPwnSmANfT19Rq4AxMgpRHrWb91pp+hCLJETKZhVUBfr1MR/KISH3I0xFkVdA2Z5iensIZnF6PWnLtaJ+h7lPHclsZC13yrBPLSHDLGlBvL7P9jN1hCYFinROWSRSSaI7T2om91zvSrixVshx4NbBg3KFVNtZkTt2aMTrpQZo1cESAeE3yeuSTz/xpx/vJrIfNfbrCCM4qsadzXWMRSJQDtHOqOGLIXvEClSe7gqSKrfk3hs7KlWs4+/yvyV1VYWTSL51cqcqMTUPWUUfwqGChnSkZ4by69UvDUgDwUtHsz8GRA6JWAnexhcCVzZDmbKMVDlWTXCV6n7+DOl7BgipWF/hxtL716mT6D8tAcZlxQF07Fo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new drm_gem_huge_mnt_create() and
drm_gem_has_huge_mnt() helpers to avoid code duplication. Now that
it's just a few lines long, the single function in i915_gemfs.c is
moved into v3d_gem_shmem.c.

v3:
- use huge tmpfs mountpoint in drm_device
- move i915_gemfs.c into i915_gem_shmem.c

v4:
- clean up mountpoint creation error handling

v5:
- use drm_gem_has_huge_mnt() helper

v7:
- include <drm/drm_print.h> in i915_gem_shmem.c

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/i915/Makefile                 |  3 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     | 48 +++++++++----
 drivers/gpu/drm/i915/gem/i915_gemfs.c         | 71 -------------------
 drivers/gpu/drm/i915/gem/i915_gemfs.h         | 14 ----
 .../gpu/drm/i915/gem/selftests/huge_pages.c   | 11 +--
 drivers/gpu/drm/i915/i915_drv.h               |  5 --
 6 files changed, 42 insertions(+), 110 deletions(-)
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
 delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h

diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 84ec79b64960..b5a8c0a6b747 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -169,8 +169,7 @@ gem-y += \
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
index 26dda55a07ff..9bba6f8cdee2 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -9,14 +9,16 @@
 #include <linux/uio.h>
 
 #include <drm/drm_cache.h>
+#include <drm/drm_gem.h>
+#include <drm/drm_print.h>
 
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
@@ -515,9 +517,9 @@ static int __create_shmem(struct drm_i915_private *i915,
 	if (BITS_PER_LONG == 64 && size > MAX_LFS_FILESIZE)
 		return -E2BIG;
 
-	if (i915->mm.gemfs)
-		filp = shmem_file_setup_with_mnt(i915->mm.gemfs, "i915", size,
-						 flags);
+	if (drm_gem_has_huge_mnt(&i915->drm))
+		filp = shmem_file_setup_with_mnt(i915->drm.huge_mnt, "i915",
+						 size, flags);
 	else
 		filp = shmem_file_setup("i915", size, flags);
 	if (IS_ERR(filp))
@@ -644,21 +646,41 @@ i915_gem_object_create_shmem_from_data(struct drm_i915_private *i915,
 
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
+	if (drm_gem_has_huge_mnt(&i915->drm))
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
index 1f1290214031..000000000000
--- a/drivers/gpu/drm/i915/gem/i915_gemfs.c
+++ /dev/null
@@ -1,71 +0,0 @@
-// SPDX-License-Identifier: MIT
-/*
- * Copyright © 2017 Intel Corporation
- */
-
-#include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/fs_context.h>
-
-#include <drm/drm_print.h>
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
index bd08605a1611..2b9f7d86b46e 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
 
 static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
 {
-	return i915->mm.gemfs && has_transparent_hugepage();
+	return drm_gem_has_huge_mnt(&i915->drm);
 }
 
 static struct drm_i915_gem_object *
@@ -1761,7 +1761,8 @@ static int igt_tmpfs_fallback(void *arg)
 	struct drm_i915_private *i915 = arg;
 	struct i915_address_space *vm;
 	struct i915_gem_context *ctx;
-	struct vfsmount *gemfs = i915->mm.gemfs;
+	struct vfsmount *huge_mnt =
+		drm_gem_has_huge_mnt(&i915->drm) ? i915->drm.huge_mnt : NULL;
 	struct drm_i915_gem_object *obj;
 	struct i915_vma *vma;
 	struct file *file;
@@ -1782,10 +1783,10 @@ static int igt_tmpfs_fallback(void *arg)
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
@@ -1819,7 +1820,7 @@ static int igt_tmpfs_fallback(void *arg)
 out_put:
 	i915_gem_object_put(obj);
 out_restore:
-	i915->mm.gemfs = gemfs;
+	i915->drm.huge_mnt = huge_mnt;
 
 	i915_vm_put(vm);
 out:
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 95f9ddf22ce4..93a5af3de334 100644
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


