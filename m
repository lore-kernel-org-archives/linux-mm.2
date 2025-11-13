Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A473CD8CB1
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1C8D8E0016; Thu, 13 Nov 2025 12:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCE48E0002; Thu, 13 Nov 2025 12:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D97928E0016; Thu, 13 Nov 2025 12:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE7A38E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:19 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82A814D749
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:19 +0000 (UTC)
X-FDA: 84106196958.05.33B9157
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf25.hostedemail.com (Postfix) with ESMTP id 87FB1A0015
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=eKDIwQhr;
	spf=pass (imf25.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRii6afk96AlqqmnIAuDY0x3NsW56xPvWJRCtZUQdeI=;
	b=ISVPe/ISFkEcoPacrKE9SUT/FE8HO+VzcqBTSeds+VcFX6wKQzCxe9rw3hv1Zp38J2kI2m
	wiZ3H1WZuat2TSolrJMxkzkopg2q0IomWZUiE5zE63iQa0TjWHqKzfO28X6dBbZPCENWoe
	ZVeP8SDsdI6AKe5gVAEFvd2OmbAYEKw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=eKDIwQhr;
	spf=pass (imf25.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053217; a=rsa-sha256;
	cv=none;
	b=4zEdPwuKWf0Tr3CX2lVksoxJ7/6eiTymJcZjK0RbCbziNn8alEgRhWwRdrM/YfcFvEGfL5
	q1R19VBpBLToHJkA0GsJxyJrkp2s1wKkWO7147pDMs0nmBJXxz2v8sBctqMQMWfsptRMJr
	uVCPdVA74/LcgHisejM7Bh7CYLM3/NY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053216;
	bh=QtPgm0qMMvkcppmfpX/erK2D39kVCu6KGhqagOyodUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKDIwQhrTxCU5YbswukkubsUF5bgEsALXsY+tL/P1FscV/RrkNGUfHfVwpkJ6FZY7
	 iXjsayWb1EjNbHZwMkmCZxn/qio36YcbQsSE13zcz5g6e/0laYTJQnfdSP5XiOcwBx
	 zlIMy1ALwfhUYovC6goUZupAn7yv/b1HsllBxlOFIWLwf+E68V2IgkuSVAs0IRhnwT
	 4aF8Kkow1bTcGQ3aq7nIqZSMZr9cbc2OzCMY8+HyDkXeXdSh5SjQy5wg9WpafCZiJa
	 enfPB4mJSonqnLSNI2uD3rl09AQqq7p9ydPQU7tGkhi8f1zDHeU4jJYvjkIhepQ9tK
	 X5AkMIURElT/Q==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1ECB417E141E;
	Thu, 13 Nov 2025 18:00:15 +0100 (CET)
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
Subject: [PATCH v8 05/11] drm/i915: Use huge tmpfs mountpoint helpers
Date: Thu, 13 Nov 2025 18:00:01 +0100
Message-ID: <20251113170008.79587-6-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170008.79587-1-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87FB1A0015
X-Stat-Signature: 43if1bgtpsktyrt1631nakhkwg5gbctp
X-Rspam-User: 
X-HE-Tag: 1763053217-485632
X-HE-Meta: U2FsdGVkX1/vmGwO34WNItpGtvUI5ExU0flAcfRpIgnnclWWQBtBF/U6gVHVCZ4pCebnnNRUJm/aN/gsYAoj7Btubxd32e7yDkvhW2Kxla6BosCTS1hlAf8FCLHyYaGZB+fjrq6thSNwBiaNZJt9xxpeSLglVYMPO6sgdDnOkME5nFBP7jeT57wkvWP9gnWV7k9CC42M/l9DB5AZa9mhuJtLJ+HSJwG/O+cvVP+U/KizL1nk15tOr36rJHTHHfO2qievU60gJKjsggsSEaLFf5a/SyuDEjjBbxjdY9zzF3dmCEYd8VLQCYB38n4WPHYpxb14/gQ0FXHk6xNOTRId+b6AWimwmM9LWjp6E7gAL168hoMHn9AMChljvWmjuxbq9ISqUsNEb9/srr0L4iFIBhAuOW68mE4to8qjrLRgRlI+bV1ceak5AtTyOpLSYZKuc8k9AqARtUdSv0HeyuHPbZft7tlW4kB4yJVBYcYROcAZPGsAHSgUMkBPFHChaV8MA0GeWfX/qSka5Z3dH5j3GtMDtD4RKiF7pjWX7rwgZXLR6/p3DzULUm0Kw83mR93KxkqTx/8LLlys3GMuMLtlH2KbWEKPdxteEa3RPR1RcPHkoqO6Zh0Q5Qviq6CLRoATksomF/8k4i/wBtK3ThX7DlBf1b5lDPFDiw6Ru553j9HJvjRrqsJngWg5mNnpDeMA+BDYRyjTFZJ/GbWaOCRUkuVgYcJJzrCqRA1H56uEhWX6J+bz5Uh3g54xiiGNPmc7ASEIzRnkiAHHM9r0s80kN6w0UICZdPKfUUM4UB9wUJktD6pfIHd6/e1TZW/5MhHMexwcTUqCa+PKzkiorU3pRoeBBDNJMDhxJKofUSOFB0isrVFVPpk6119XOswPYqfqW9V0mtM/PS44glI4nEqI/fL961BWD3w3QdomJwdADjTE9vZnfZ7AJSLDhIxgmRXG/0A7vLwy7LxVanVPdLz
 foGZ6m9p
 QVh8MV6FvaIhzGzEvOfCTAK34YoczmumRJdvxwMDYtuxrbjmdxkiHrs/mdJ6QIoSjp7GoQtFs+FQ+f/G7EJ8BeK23uDY82aCIZ9el8AU/zZUPCSvWlY2ErNA6yWH0IrXggI87IPZQ9cm26wy3eRKnBKhgdEpNkjZqWWy4tGDMMZqFZoHrm4YewLQIFFbyxOVqQUiTvWYdncR8H/CzWR+UMlzZ1T/ufIEjo2iJybgvskDND/Ef9FfNe3Vj3wDEL+fJiidu0mT2rT2a/cs28qY/Mi0GCndBL2WIcr7FKOrlAezqdKxyte++Qthqx8N47hkNE962WaotyVc+FlWZJWMO0KY7HOHax65h/huernY5HheYWhxDhYjsQztA14BOPs55Hsq24lVtj8AyLO4=
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

v8:
- keep logging notice message with CONFIG_TRANSPARENT_HUGEPAGE=n
- don't access huge_mnt field with CONFIG_TRANSPARENT_HUGEPAGE=n

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/i915/Makefile                 |  3 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     | 51 +++++++++----
 drivers/gpu/drm/i915/gem/i915_gemfs.c         | 71 -------------------
 drivers/gpu/drm/i915/gem/i915_gemfs.h         | 14 ----
 .../gpu/drm/i915/gem/selftests/huge_pages.c   | 17 +++--
 drivers/gpu/drm/i915/i915_drv.h               |  5 --
 6 files changed, 51 insertions(+), 110 deletions(-)
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
index 26dda55a07ff..e6621b568974 100644
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
@@ -515,11 +517,15 @@ static int __create_shmem(struct drm_i915_private *i915,
 	if (BITS_PER_LONG == 64 && size > MAX_LFS_FILESIZE)
 		return -E2BIG;
 
-	if (i915->mm.gemfs)
-		filp = shmem_file_setup_with_mnt(i915->mm.gemfs, "i915", size,
-						 flags);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (drm_gem_has_huge_mnt(&i915->drm))
+		filp = shmem_file_setup_with_mnt(i915->drm.huge_mnt, "i915",
+						 size, flags);
 	else
 		filp = shmem_file_setup("i915", size, flags);
+#else
+	filp = shmem_file_setup("i915", size, flags);
+#endif
 	if (IS_ERR(filp))
 		return PTR_ERR(filp);
 
@@ -644,21 +650,40 @@ i915_gem_object_create_shmem_from_data(struct drm_i915_private *i915,
 
 static int init_shmem(struct intel_memory_region *mem)
 {
-	i915_gemfs_init(mem->i915);
-	intel_memory_region_set_name(mem, "system");
+	struct drm_i915_private *i915 = mem->i915;
 
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
+	drm_gem_huge_mnt_create(&i915->drm, "within_size");
+	if (drm_gem_has_huge_mnt(&i915->drm))
+		drm_info(&i915->drm, "Using Transparent Hugepages\n");
+	else
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
index bd08605a1611..15e18e3010f0 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
 
 static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
 {
-	return i915->mm.gemfs && has_transparent_hugepage();
+	return drm_gem_has_huge_mnt(&i915->drm);
 }
 
 static struct drm_i915_gem_object *
@@ -1761,7 +1761,10 @@ static int igt_tmpfs_fallback(void *arg)
 	struct drm_i915_private *i915 = arg;
 	struct i915_address_space *vm;
 	struct i915_gem_context *ctx;
-	struct vfsmount *gemfs = i915->mm.gemfs;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	struct vfsmount *huge_mnt =
+		drm_gem_has_huge_mnt(&i915->drm) ? i915->drm.huge_mnt : NULL;
+#endif
 	struct drm_i915_gem_object *obj;
 	struct i915_vma *vma;
 	struct file *file;
@@ -1782,10 +1785,12 @@ static int igt_tmpfs_fallback(void *arg)
 	/*
 	 * Make sure that we don't burst into a ball of flames upon falling back
 	 * to tmpfs, which we rely on if on the off-chance we encounter a failure
-	 * when setting up gemfs.
+	 * when setting up a huge mountpoint.
 	 */
 
-	i915->mm.gemfs = NULL;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	i915->drm.huge_mnt = NULL;
+#endif
 
 	obj = i915_gem_object_create_shmem(i915, PAGE_SIZE);
 	if (IS_ERR(obj)) {
@@ -1819,7 +1824,9 @@ static int igt_tmpfs_fallback(void *arg)
 out_put:
 	i915_gem_object_put(obj);
 out_restore:
-	i915->mm.gemfs = gemfs;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	i915->drm.huge_mnt = huge_mnt;
+#endif
 
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


