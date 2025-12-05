Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84CBDD339B5
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785586B01F7; Fri,  5 Dec 2025 13:22:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7361A6B01F8; Fri,  5 Dec 2025 13:22:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0986B01F9; Fri,  5 Dec 2025 13:22:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B3216B01F7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:22:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8C06B7AB1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:42 +0000 (UTC)
X-FDA: 84186238164.09.CAA6CF6
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4976D4000C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=U6osbava;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf27.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764958961; a=rsa-sha256;
	cv=none;
	b=UOsycFq3+CUN69Js3+5wR4P2f+YbmEtjitnqxpU/7nVZNpzbNLxKZqiK17eT/s8dwBWr1L
	qnPnl8NrzyOgac5jO0RJog4BDOXYJnuhI9ow9/ziHEfRze/6NaBBrREP/7pzjvyPjrVUpE
	s+tQ6CH1PJb7Iqr065UVBL6RPkt8dks=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=U6osbava;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf27.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764958961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjxt4AYLel6ziYUQZdV8B+/LoDJdz56ro2RadWu3O9E=;
	b=4PoUSV+Q4Z+3BKuilgaLYWJaXUdifAMcsm1gkDd1iHIYTlTIBIWjpOFLGrYHK1pZM0ITNq
	OR7OUKqbnraVEv/RfQHidKrtv4jM6FdaKHFhsYJCEvd4kzF0RsDChtyt+8z0bIpU7INIoc
	GvNLgLC4dQJPpKh838w5Xf2G+HNfym4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764958959;
	bh=tkXVMopVP8ytmM/QS/qA3jJ674NWAyvDXIyHfasJspo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6osbavaLwmpTNlZ+eaVmRPGMXIgjp8gq1V0S0i5Pp7ljWRli7KSjAm2bID9rjXx9
	 jLDKgvnZDF1Xn3m5bW6ftvUXd38Mx0DU2iIRyLQ1VAGZdwcIqDH/IKhoEIivXu9ym+
	 L4k2ggI4h5y/pdxx2nMUyAtDkwoRM/TMM3NKeL7b80OiGITrhdapCkCCwfcJuTqfoN
	 0WOurFmqtGLZOo61NPvJiK2ydf1pf5sRcU0ocY593SZX2906/MB9ovF7yiTP/7neUa
	 crESkYouirpVhg6tJu7TXCrV5/vkjb9nEqg6ErVSnTEYAwB9B50IS+cJZ01LnNL9Tv
	 jnedqZqq4tpAA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0D7C617E1572;
	Fri,  5 Dec 2025 19:22:39 +0100 (CET)
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
Subject: [PATCH v13 05/10] drm/i915: Use huge tmpfs mountpoint helpers
Date: Fri,  5 Dec 2025 19:22:26 +0100
Message-ID: <20251205182231.194072-6-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205182231.194072-1-loic.molinari@collabora.com>
References: <20251205182231.194072-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4976D4000C
X-Stat-Signature: tjokmcnjf4skpmzuccy63afw134ucaus
X-Rspam-User: 
X-HE-Tag: 1764958961-159677
X-HE-Meta: U2FsdGVkX1+8HKHSaSLC/b5rk6+nbZ3fg3gUcICW+batMJlW+Qi1iQVrzdkuB4KVfTcC2tmHMA3Vxb5tXnA+YrDhgrPiivtGcbwfwBJTVvo8HeiA8GiU0SsHE1Nc4EgM0XufiE/3A+4nRv5stOVkN9UNHQJGRWOug9Ho/joWAn7zkuuNnZAOYHZ6coduC1J5cGOmbGFsQqKD429/gvqlDgoZSV1MBe3MZhS2GCxrCxOlJLyWFSwIzob3rjAM1fIED830/fakbI6cHmIX4ZyxBv0R+dqH3LCCKdbgRrunkbYTd7vRIruk+K63jIOz4NUoSN1uyucvEQ8GLAFS9PctMN9My1shw5NihF84+6uxZboVnJtHPsaoF8v8mXe9ENS8Bq+4IuK6sPsF8dKAmJGLZ77FXXUgsYniciUtyB7y8IKz4MScXLI09mhPXUfRCJ2OeGw01ydcy3kMmQpi8whzzmvL5gwsYzoA+1l/C0UB+0tVdIP/o5o714SwVbCQzSbhuSdXtFH+plPSOzFjmAcMHXWB4hpAwNYLcPNXjSlPaT5M0ZaV7zuzxJj5BhGtq/EYtn5Y0lXqRyNbuLlX13z3HOVi4VTp5CSZhaHM6kAkLmLHpO3db1h6jfYgLnevkOLSCGHrKkUF1j0miHqWlw7IABausgwczkhC1q/jKukGjqVqhSD6jVBumX/S3vAv1cZzI2ogdRDFBF/U1zTCceIRFpQ8EkhmnzYOE2Q8s+iTxI0NvoxtE7OTpVfqUFPE674paKf0j086VwvqbNK6hcJoBhOlbSYJIt1SmAkYbaoKEUgKvyvEtXOAiXhmCN132OYdgnGbXiilgBb22ggLDG0Jde3OuioO4+IUUCYHauJss+fuh0H8yVk2ItY/jKPSYTwQcXca9luvQOnG8Fj4kpDRYpG7GhaVTII3KWLqZQIVsh2gNO6JJCdL3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new drm_gem_huge_mnt_create() and
drm_gem_get_huge_mnt() helpers to avoid code duplication. Now that
it's just a few lines long, the single function in i915_gemfs.c is
moved into i915_gem_shmem.c.

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

v9:
- replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()
- remove useless ternary op test in selftests/huge_pages.c

v12:
- fix layering violation in selftests (Tvrtko)
- fix incorrect filename in commit message

v13:
- add Tvrtko A-b

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Acked-by: Tvrtko Ursulin <tursulin@ursulin.net>
---
 drivers/gpu/drm/i915/Makefile                 |  3 +-
 .../gpu/drm/i915/gem/i915_gem_object_types.h  |  9 +--
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     | 58 ++++++++++-----
 drivers/gpu/drm/i915/gem/i915_gemfs.c         | 71 -------------------
 drivers/gpu/drm/i915/gem/i915_gemfs.h         | 14 ----
 .../gpu/drm/i915/gem/selftests/huge_pages.c   | 15 +---
 drivers/gpu/drm/i915/i915_drv.h               |  5 --
 7 files changed, 50 insertions(+), 125 deletions(-)
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
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
index 64600aa8227f..f94409e8ec4c 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -348,12 +348,13 @@ struct drm_i915_gem_object {
  */
 #define I915_BO_ALLOC_GPU_ONLY	  BIT(6)
 #define I915_BO_ALLOC_CCS_AUX	  BIT(7)
+#define I915_BO_ALLOC_NOTHP	  BIT(8)
 /*
  * Object is allowed to retain its initial data and will not be cleared on first
  * access if used along with I915_BO_ALLOC_USER. This is mainly to keep
  * preallocated framebuffer data intact while transitioning it to i915drmfb.
  */
-#define I915_BO_PREALLOC	  BIT(8)
+#define I915_BO_PREALLOC	  BIT(9)
 #define I915_BO_ALLOC_FLAGS (I915_BO_ALLOC_CONTIGUOUS | \
 			     I915_BO_ALLOC_VOLATILE | \
 			     I915_BO_ALLOC_CPU_CLEAR | \
@@ -363,9 +364,9 @@ struct drm_i915_gem_object {
 			     I915_BO_ALLOC_GPU_ONLY | \
 			     I915_BO_ALLOC_CCS_AUX | \
 			     I915_BO_PREALLOC)
-#define I915_BO_READONLY          BIT(9)
-#define I915_TILING_QUIRK_BIT     10 /* unknown swizzling; do not release! */
-#define I915_BO_PROTECTED         BIT(11)
+#define I915_BO_READONLY          BIT(10)
+#define I915_TILING_QUIRK_BIT     11 /* unknown swizzling; do not release! */
+#define I915_BO_PROTECTED         BIT(12)
 	/**
 	 * @mem_flags - Mutable placement-related flags
 	 *
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index 26dda55a07ff..6ad1d6f99363 100644
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
@@ -494,9 +496,11 @@ const struct drm_i915_gem_object_ops i915_gem_shmem_ops = {
 
 static int __create_shmem(struct drm_i915_private *i915,
 			  struct drm_gem_object *obj,
-			  resource_size_t size)
+			  resource_size_t size,
+			  unsigned int flags)
 {
-	unsigned long flags = VM_NORESERVE;
+	unsigned long shmem_flags = VM_NORESERVE;
+	struct vfsmount *huge_mnt;
 	struct file *filp;
 
 	drm_gem_private_object_init(&i915->drm, obj, size);
@@ -515,11 +519,12 @@ static int __create_shmem(struct drm_i915_private *i915,
 	if (BITS_PER_LONG == 64 && size > MAX_LFS_FILESIZE)
 		return -E2BIG;
 
-	if (i915->mm.gemfs)
-		filp = shmem_file_setup_with_mnt(i915->mm.gemfs, "i915", size,
-						 flags);
+	huge_mnt = drm_gem_get_huge_mnt(&i915->drm);
+	if (!(flags & I915_BO_ALLOC_NOTHP) && huge_mnt)
+		filp = shmem_file_setup_with_mnt(huge_mnt, "i915", size,
+						 shmem_flags);
 	else
-		filp = shmem_file_setup("i915", size, flags);
+		filp = shmem_file_setup("i915", size, shmem_flags);
 	if (IS_ERR(filp))
 		return PTR_ERR(filp);
 
@@ -548,7 +553,7 @@ static int shmem_object_init(struct intel_memory_region *mem,
 	gfp_t mask;
 	int ret;
 
-	ret = __create_shmem(i915, &obj->base, size);
+	ret = __create_shmem(i915, &obj->base, size, flags);
 	if (ret)
 		return ret;
 
@@ -644,21 +649,40 @@ i915_gem_object_create_shmem_from_data(struct drm_i915_private *i915,
 
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
+	if (drm_gem_get_huge_mnt(&i915->drm))
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
index bd08605a1611..02e9bf87f654 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
 
 static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
 {
-	return i915->mm.gemfs && has_transparent_hugepage();
+	return !!drm_gem_get_huge_mnt(&i915->drm);
 }
 
 static struct drm_i915_gem_object *
@@ -1761,7 +1761,6 @@ static int igt_tmpfs_fallback(void *arg)
 	struct drm_i915_private *i915 = arg;
 	struct i915_address_space *vm;
 	struct i915_gem_context *ctx;
-	struct vfsmount *gemfs = i915->mm.gemfs;
 	struct drm_i915_gem_object *obj;
 	struct i915_vma *vma;
 	struct file *file;
@@ -1779,15 +1778,8 @@ static int igt_tmpfs_fallback(void *arg)
 	}
 	vm = i915_gem_context_get_eb_vm(ctx);
 
-	/*
-	 * Make sure that we don't burst into a ball of flames upon falling back
-	 * to tmpfs, which we rely on if on the off-chance we encounter a failure
-	 * when setting up gemfs.
-	 */
-
-	i915->mm.gemfs = NULL;
-
-	obj = i915_gem_object_create_shmem(i915, PAGE_SIZE);
+	obj = i915_gem_object_create_region(i915->mm.regions[INTEL_REGION_SMEM],
+					    PAGE_SIZE, 0, I915_BO_ALLOC_NOTHP);
 	if (IS_ERR(obj)) {
 		err = PTR_ERR(obj);
 		goto out_restore;
@@ -1819,7 +1811,6 @@ static int igt_tmpfs_fallback(void *arg)
 out_put:
 	i915_gem_object_put(obj);
 out_restore:
-	i915->mm.gemfs = gemfs;
 
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


