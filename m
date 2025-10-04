Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2398CCCD187
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A94E48E000E; Sat,  4 Oct 2025 05:31:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45278E000C; Sat,  4 Oct 2025 05:31:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BFA48E000E; Sat,  4 Oct 2025 05:31:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 70C578E000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:31:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BAD045628
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:12 +0000 (UTC)
X-FDA: 83959913184.02.E7D340E
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8CA32120007
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="LVi5S/CQ";
	spf=pass (imf29.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TerXbbcjFbvr7hFTU1UxeFol9F76ksM/yicdKOdzXLc=;
	b=jrw7RcuIdC18AIvflH1NarP/Px8Idpxp6EQctSFCOuHGTfBeEBnkY7lAJkRL6GTIbowCsH
	3MPHS7S0t1y9vpw/XjUTwqxqEAl4fqpfbDNlPogGeGNBp+HypdFDpAJE75NqrV1N8Ue/GB
	7+q3Sv+c/LdWMRvCeQjksjQ22VRS6q8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570270; a=rsa-sha256;
	cv=none;
	b=rVXnjRRT1z0sqxYVdcbZ8Q1vENAJIxzt1IWAwWv3BewztqH8mRMK7xwrS2+ka7u4gyWB9B
	2bL2SEiAsQb0FGFn0JTrFGeY7WF9JTJGojpjq36e6/jXdgz/RsCbis24trvZEfqCrwroZ6
	m4IsW1fxNf0ZYSRhncX9X4+bgky359k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="LVi5S/CQ";
	spf=pass (imf29.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759570269;
	bh=voXKWIXXc7ZCAqr68hJ7OCR6GhuDkG9/lw40a6vV8HU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVi5S/CQlbVfDW6cyzL+WXoWt12tZuEt9c1NGSM+9kSNI7WSuCyGuK0K8dMbClOXg
	 XvgxF2KjRsa7YwmJrDhCQITg1Y+2DkYwcOVOxXrncTRn50g6vzfnOUM+z3t4mW2d28
	 DANkjgaxRGaMGOzZp9E7j2lDSXImlY6Tw6B9C2pTuO+Weu9uaZiTDB7F8u1kAwsDkH
	 cBJfmi7FcC0f19VcrB3/OQ0KnGSRJU7r9jOmPnWAxz0LVdMbm8UQBW0NpwoGiSXiE6
	 dJugNONAYiY9v116CeBUYlvrQM37g5XgrtZuOVXHlXtCTKgtlFBIr8pAuDaVNcrIko
	 9CoUNCm1hc8xg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 758C717E13E4;
	Sat,  4 Oct 2025 11:31:08 +0200 (CEST)
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
	Christopher Healy <healych@amazon.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH v3 05/10] drm/v3d: Use huge tmpfs mount point helper
Date: Sat,  4 Oct 2025 11:30:48 +0200
Message-ID: <20251004093054.21388-6-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251004093054.21388-1-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8CA32120007
X-Stat-Signature: yqg1zko4dbqpqu75zycbhc6ezj6dr83h
X-Rspam-User: 
X-HE-Tag: 1759570270-278712
X-HE-Meta: U2FsdGVkX1+VQmcJWJOfqmREvWBrwPFRg3F4ANxQVcXivzKkFWpTFGd5Qjjmm9tfUoiBwevX2oC+OkHg5NzUzT7Kr7TvDBjRnrY/4QKQX/6m2lkNrc/jhd8SSoiz9nh8lxCB+C1ssSZRpjOrVUQzOp62CVbNcJxj9/tWbLRpAgTDtIZ3HbOVCuxioycM5K7BWb/HuLt3Cn2Gbuxd1rWhtuEgP+ODxndh0oHnhII2TwqeKBUF8yfUDO8dLVYcKbd1O2HU7Nk6jTDZr9VnPc+H9Q/eS2QzE4v4GcBrAhQpmN/c1tcO6EXLhUm6GMW9zQANeN73zbB/CepzoXoCetPhGKb3SsvtDj0ifj8EUK9BGS9IqxitpxCrEfGhxSkr0vOJMZ2K1WUU7QmnNkwRMga9N8MWjiEGTihEWohMJQAgUTnvW5Z090b7dUlvFtS915fc7BKS8v4/UDJh0vARo5EqyA7BZsrjR6nIln7D4P0A8vsIjZmW0uwEcOUAaSk+HbqA+j3aUgdWESmZPrjl/JRG13PNFEnVk+j7Hx+hX+Q/Wcp2rA6NaPOGwuOnHw4Y08EfhbMvvsyDXoc9PeWl2TezijcSSYWGoduqgsllonQ7TiCj6ZrykqJy+V1mGMH6pK+PTxa7BapjL8UtIZibzZnPh8H84cSFoxGDBqdC7UnolI/s1d0ZTcBNS4/3czd0QIyvzV3wIsdPW2Wy2aUKJd4/w9wA9G+GqpoEPrnElL1b3wH73Y3Ki39TDVQCNMYggCG1MAikNH5hOOznsFQcJflQf+m4zkWwSubrPUunCkvy2iWO68CqpqNZyQnDayhpiNJHJh5djTnRX1KszqHiKzuL+BiBknwlucO/1tg1ullAcBr8iZa1kh7U9qVfytsfNE8q4ptBPx7/r+fQvFCmOdP0IFM7rRDAHdAQ+2tm7QmyzZ5DD+eKAoZfuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new drm_gem_huge_mnt_create() helper to avoid code
duplication. Now that it's just a few lines long, the single function
in v3d_gemfs.c is moved into v3d_gem.c.

v3:
- use huge tmpfs mountpoint in drm_device
- move v3d_gemfs.c into v3d_gem.c

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/v3d/Makefile    |  3 +-
 drivers/gpu/drm/v3d/v3d_bo.c    |  5 +--
 drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
 drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
 drivers/gpu/drm/v3d/v3d_gem.c   | 33 ++++++++++++++++-
 drivers/gpu/drm/v3d/v3d_gemfs.c | 65 ---------------------------------
 6 files changed, 36 insertions(+), 83 deletions(-)
 delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c

diff --git a/drivers/gpu/drm/v3d/Makefile b/drivers/gpu/drm/v3d/Makefile
index fcf710926057..b7d673f1153b 100644
--- a/drivers/gpu/drm/v3d/Makefile
+++ b/drivers/gpu/drm/v3d/Makefile
@@ -13,8 +13,7 @@ v3d-y := \
 	v3d_trace_points.o \
 	v3d_sched.o \
 	v3d_sysfs.o \
-	v3d_submit.o \
-	v3d_gemfs.o
+	v3d_submit.o
 
 v3d-$(CONFIG_DEBUG_FS) += v3d_debugfs.o
 
diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
index c41476ddde68..6b9909bfce82 100644
--- a/drivers/gpu/drm/v3d/v3d_bo.c
+++ b/drivers/gpu/drm/v3d/v3d_bo.c
@@ -112,7 +112,7 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
-	if (!v3d->gemfs)
+	if (!obj->dev->huge_mnt)
 		align = SZ_4K;
 	else if (obj->size >= SZ_1M)
 		align = SZ_1M;
@@ -148,12 +148,11 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
 			     size_t unaligned_size)
 {
 	struct drm_gem_shmem_object *shmem_obj;
-	struct v3d_dev *v3d = to_v3d_dev(dev);
 	struct v3d_bo *bo;
 	int ret;
 
 	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
-						  v3d->gemfs);
+						  dev->huge_mnt);
 	if (IS_ERR(shmem_obj))
 		return ERR_CAST(shmem_obj);
 	bo = to_v3d_bo(&shmem_obj->base);
diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
index c5a3bbbc74c5..19ec0ea7f38e 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -106,7 +106,7 @@ static int v3d_get_param_ioctl(struct drm_device *dev, void *data,
 		args->value = v3d->perfmon_info.max_counters;
 		return 0;
 	case DRM_V3D_PARAM_SUPPORTS_SUPER_PAGES:
-		args->value = !!v3d->gemfs;
+		args->value = !!dev->huge_mnt;
 		return 0;
 	case DRM_V3D_PARAM_GLOBAL_RESET_COUNTER:
 		mutex_lock(&v3d->reset_lock);
diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index 0317f3d7452a..0b4fcb788168 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -156,11 +156,6 @@ struct v3d_dev {
 	struct drm_mm mm;
 	spinlock_t mm_lock;
 
-	/*
-	 * tmpfs instance used for shmem backed objects
-	 */
-	struct vfsmount *gemfs;
-
 	struct work_struct overflow_mem_work;
 
 	struct v3d_queue_state queue[V3D_MAX_QUEUES];
@@ -567,6 +562,7 @@ extern const struct dma_fence_ops v3d_fence_ops;
 struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue q);
 
 /* v3d_gem.c */
+extern bool super_pages;
 int v3d_gem_init(struct drm_device *dev);
 void v3d_gem_destroy(struct drm_device *dev);
 void v3d_reset_sms(struct v3d_dev *v3d);
@@ -574,11 +570,6 @@ void v3d_reset(struct v3d_dev *v3d);
 void v3d_invalidate_caches(struct v3d_dev *v3d);
 void v3d_clean_caches(struct v3d_dev *v3d);
 
-/* v3d_gemfs.c */
-extern bool super_pages;
-void v3d_gemfs_init(struct v3d_dev *v3d);
-void v3d_gemfs_fini(struct v3d_dev *v3d);
-
 /* v3d_submit.c */
 void v3d_job_cleanup(struct v3d_job *job);
 void v3d_job_put(struct v3d_job *job);
diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index c77d90aa9b82..1cf5ebe99c90 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -258,6 +258,36 @@ v3d_invalidate_caches(struct v3d_dev *v3d)
 	v3d_invalidate_slices(v3d, 0);
 }
 
+static void
+v3d_huge_mnt_init(struct v3d_dev *v3d)
+{
+	int err;
+
+	/*
+	 * By creating our own shmemfs mountpoint, we can pass in
+	 * mount flags that better match our usecase. However, we
+	 * only do so on platforms which benefit from it.
+	 */
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		goto err;
+
+	/* The user doesn't want to enable Super Pages */
+	if (!super_pages)
+		goto err;
+
+	err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
+	if (err && err != -EEXIST)
+		goto err;
+
+	drm_info(&v3d->drm, "Using Transparent Hugepages\n");
+
+	return;
+
+err:
+	drm_notice(&v3d->drm,
+		   "Transparent Hugepage support is recommended for optimal performance on this platform!\n");
+}
+
 int
 v3d_gem_init(struct drm_device *dev)
 {
@@ -308,7 +338,7 @@ v3d_gem_init(struct drm_device *dev)
 	v3d_init_hw_state(v3d);
 	v3d_mmu_set_page_table(v3d);
 
-	v3d_gemfs_init(v3d);
+	v3d_huge_mnt_init(v3d);
 
 	ret = v3d_sched_init(v3d);
 	if (ret) {
@@ -328,7 +358,6 @@ v3d_gem_destroy(struct drm_device *dev)
 	enum v3d_queue q;
 
 	v3d_sched_fini(v3d);
-	v3d_gemfs_fini(v3d);
 
 	/* Waiting for jobs to finish would need to be done before
 	 * unregistering V3D.
diff --git a/drivers/gpu/drm/v3d/v3d_gemfs.c b/drivers/gpu/drm/v3d/v3d_gemfs.c
deleted file mode 100644
index 8ec6ed82b3d9..000000000000
--- a/drivers/gpu/drm/v3d/v3d_gemfs.c
+++ /dev/null
@@ -1,65 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/* Copyright (C) 2024 Raspberry Pi */
-
-#include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/fs_context.h>
-
-#include "v3d_drv.h"
-
-static int add_param(struct fs_context *fc, const char *key, const char *val)
-{
-	return vfs_parse_fs_string(fc, key, val, strlen(val));
-}
-
-void v3d_gemfs_init(struct v3d_dev *v3d)
-{
-	struct file_system_type *type;
-	struct fs_context *fc;
-	struct vfsmount *gemfs;
-	int ret;
-
-	/*
-	 * By creating our own shmemfs mountpoint, we can pass in
-	 * mount flags that better match our usecase. However, we
-	 * only do so on platforms which benefit from it.
-	 */
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
-		goto err;
-
-	/* The user doesn't want to enable Super Pages */
-	if (!super_pages)
-		goto err;
-
-	type = get_fs_type("tmpfs");
-	if (!type)
-		goto err;
-
-	fc = fs_context_for_mount(type, SB_KERNMOUNT);
-	if (IS_ERR(fc))
-		goto err;
-	ret = add_param(fc, "source", "tmpfs");
-	if (!ret)
-		ret = add_param(fc, "huge", "within_size");
-	if (!ret)
-		gemfs = fc_mount_longterm(fc);
-	put_fs_context(fc);
-	if (ret)
-		goto err;
-
-	v3d->gemfs = gemfs;
-	drm_info(&v3d->drm, "Using Transparent Hugepages\n");
-
-	return;
-
-err:
-	v3d->gemfs = NULL;
-	drm_notice(&v3d->drm,
-		   "Transparent Hugepage support is recommended for optimal performance on this platform!\n");
-}
-
-void v3d_gemfs_fini(struct v3d_dev *v3d)
-{
-	if (v3d->gemfs)
-		kern_unmount(v3d->gemfs);
-}
-- 
2.47.3


