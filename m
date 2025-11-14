Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A43CCE8D55
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3E248E0031; Fri, 14 Nov 2025 12:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE818E0005; Fri, 14 Nov 2025 12:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819B48E0031; Fri, 14 Nov 2025 12:03:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 635FF8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:16 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 359351A045D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:16 +0000 (UTC)
X-FDA: 84109833192.15.95DCBC6
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf19.hostedemail.com (Postfix) with ESMTP id 00F2C1A000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=XdJGQk1d;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf19.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139794; a=rsa-sha256;
	cv=none;
	b=xgzmSYlEA8mBZURrA2Gh3TJdIFG0XepnkQyYjQz1BLRX0lLaZN3KowRFOoT1+e8ujxZCmg
	wAfEPSYD84uMncUXogznwWLwMGLM8ol1vKySsd5U6aLsUX8caZBFvHa9O2MB8OtNFkB8wJ
	WuTNM5sPe1Fit4wQ8DQpzELTRlEoJT4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=XdJGQk1d;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf19.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lstCuSIFZRVw6rWba4dlAJEe6zYQSGpa0cmkpPWxXKg=;
	b=EH9jVFUKk+y3M0/Mcqq9mDrXldCgRMRXbRCFiCPPzjrjPYo1oIyCdHcVx+8G6q46qVr9Lb
	k4wxb4J9wsRclHo8+V1NAWulbT6We+DLJlUH0fyzJXUEzdW1p0aYKutsitzvW3MRDvtqDt
	qlFQWvV0iZ07JHWM/nIehd4xBafpw6I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139792;
	bh=F21lcLtx1NkP7OSa7ulUeqIgfho6clTQ3QePI0r5YA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XdJGQk1d1SaixqYQdlSOMh12H5v2n5wZCFeqpDRV6y9561fTbkwzLqQmP7zWokTFM
	 NTrvoC8Crqe9CTz6lSFKOm3NJkEBiPakt1rIy6hpOTPvnqPutDNciwpEp6Zil9fi7z
	 8aW1T7FjzeuHw3AFDE1FW0rCKzODl5kct57deWCzKcJ3XXu4QbZTm5i/TFnLc/7yqP
	 e7UVS4IpZEOX/roIAH6+fVlgb2pdG2Jg/Y7oXZyDi/JKYJGktvZ1h1H4w41hvpq3/z
	 +56MklWl6CZ6g9YSZxx9f9ElXciolv04Jg3Hf3DkbgWD6zTiMqqywaoPTYq+bfiSiN
	 bTnd0fTiwS6Qg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8685317E14FE;
	Fri, 14 Nov 2025 18:03:11 +0100 (CET)
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
Subject: [PATCH v9 05/11] drm/i915: Use huge tmpfs mountpoint helpers
Date: Fri, 14 Nov 2025 18:02:56 +0100
Message-ID: <20251114170303.2800-6-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114170303.2800-1-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 00F2C1A000A
X-Stat-Signature: c4kzps1utgnp3ymprqrozmjdfp8oi9g5
X-Rspam-User: 
X-HE-Tag: 1763139793-714698
X-HE-Meta: U2FsdGVkX18AZejWXP8GZlR5ubQtctECW6nF2xIxshu5PDSx0FMNBvuUzXvtnH6Vmdk/EjqzYxOpAbdDCAIe6fRkbudFTQ0tkV4hzQ8UIw6lole4DlgUcWBh8g2g8hr3lP9oG9m/9hKSr7xn8lUwDOLwrOfW7PkMOhzx7SIfTkXAxxj4lX5Di6OLWEn8PjNyvjoHiGsr1WS5EfMlwe72lAmiLXqGekd/0BlgQ2FLde+xdXhIzVCmqyisFesltkJxSh2v9oZY13dCwAjXpdE06xdz4ISDxGEesspQkZhAyLBIcw8IkHWFt8x45UhY1VLxNbkC+/rFOumJDXiDDLbnkW2SzD1gMUttxq4IS4SJmYhT2KfaFAAuWKp/JB1acZ7N9IgIKhIosnPB0bwrjsfg3Z+eIcVssR4hXUPBjwx86tGFgrm6/NuVxJgrfHsEairAcGL94iqjZ1N6lNJanttW90Y3shLQjwkqGqfUxxUQVWnJyfUbZcRP4AvCX7Iy/4wlO/4v9G/Q1YJIZTrfqBArWZP7heIE57fdUF4UndIy8p8eQ6YxOQ78B0UzX0E6fE05Q50Bj+zMTW0tNqM7x7FTHwP5480D8PaHlP6I2vWxmnjp1IRfYKzx8jwANcYQ6+j9QBesO17gJ2coQQY+FkEesgW5a6+bG6LQGDkppCdsozod9oxSV4xti6i32APCLeMfdQxRIfWyH6bMUHzk7pUS8N3Y7m2yebkGBAzSrQ/r4ztDtUSS72BVyUpFJUfidqpSjGuFkqcTB16fPkjdMF1F+o7jHz7NuuGFi8sFY6Po37/WpZRqT96PhDtIMLJbOPCsr/LKpC7/KOye/LQumhX7WRy8vFPU4FNZTCAWcSIw15DEKUw/ubi7njo2b/qNHayLitSCTH9tkKZ7VMStuUgD6uHUSpAG/w20W8prl9IkNgE7zCGb2750qRH+A5qqdzXy7gWS3OYyIUA4FbFJF5v
 DrwH55WS
 UuvwoBjJX16XCVmc2W+JOTkj1MtQW3nEHY1HU6o3WtFQC14OF6xP3JaheY+1h0qNkLOfLNCALD1P3P0OBPkgWqw99iiiP6YIKKCqxAOpZLN9q0qcphhuEUMnFPkt8LIFnwMQGTr277FOfHGgjfeU2LTuWLmauTkS5tsQXbBXPe4ANxO6+V4a0AwUm5Hj9Do1uES6jGMrXomWSMlx4XmB21md161D7Ah1AR4MyOkr67Ju81VKiC/TUP7AH1mLjB6omF0bOZ87OABMnk17bu87IMVzNHaV7y4Jz2cjlrx6dYY/bCOq7VE9Noz5M4qYjRW1T2MbKuN53ck2E80GGuDAeHRREVpTLGleIRtW6lJzeWgzg+Yh4hFQrJVSBhyk+ZJrKk8jOYIi0zlI6nzU=
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

v9:
- replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()
- remove useless ternary op test in selftests/huge_pages.c

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/i915/Makefile                 |  3 +-
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c     | 48 +++++++++----
 drivers/gpu/drm/i915/gem/i915_gemfs.c         | 71 -------------------
 drivers/gpu/drm/i915/gem/i915_gemfs.h         | 14 ----
 .../gpu/drm/i915/gem/selftests/huge_pages.c   | 16 +++--
 drivers/gpu/drm/i915/i915_drv.h               |  5 --
 6 files changed, 47 insertions(+), 110 deletions(-)
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
index 26dda55a07ff..15c2c6fde2ac 100644
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
@@ -497,6 +499,7 @@ static int __create_shmem(struct drm_i915_private *i915,
 			  resource_size_t size)
 {
 	unsigned long flags = VM_NORESERVE;
+	struct vfsmount *huge_mnt;
 	struct file *filp;
 
 	drm_gem_private_object_init(&i915->drm, obj, size);
@@ -515,9 +518,9 @@ static int __create_shmem(struct drm_i915_private *i915,
 	if (BITS_PER_LONG == 64 && size > MAX_LFS_FILESIZE)
 		return -E2BIG;
 
-	if (i915->mm.gemfs)
-		filp = shmem_file_setup_with_mnt(i915->mm.gemfs, "i915", size,
-						 flags);
+	huge_mnt = drm_gem_get_huge_mnt(&i915->drm);
+	if (huge_mnt)
+		filp = shmem_file_setup_with_mnt(huge_mnt, "i915", size, flags);
 	else
 		filp = shmem_file_setup("i915", size, flags);
 	if (IS_ERR(filp))
@@ -644,21 +647,40 @@ i915_gem_object_create_shmem_from_data(struct drm_i915_private *i915,
 
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
index bd08605a1611..28aef75630a2 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
 
 static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
 {
-	return i915->mm.gemfs && has_transparent_hugepage();
+	return !!drm_gem_get_huge_mnt(&i915->drm);
 }
 
 static struct drm_i915_gem_object *
@@ -1761,7 +1761,9 @@ static int igt_tmpfs_fallback(void *arg)
 	struct drm_i915_private *i915 = arg;
 	struct i915_address_space *vm;
 	struct i915_gem_context *ctx;
-	struct vfsmount *gemfs = i915->mm.gemfs;
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	struct vfsmount *huge_mnt = i915->drm.huge_mnt;
+#endif
 	struct drm_i915_gem_object *obj;
 	struct i915_vma *vma;
 	struct file *file;
@@ -1782,10 +1784,12 @@ static int igt_tmpfs_fallback(void *arg)
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
@@ -1819,7 +1823,9 @@ static int igt_tmpfs_fallback(void *arg)
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


