Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33018CD13D8
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5379F8E001F; Mon, 10 Nov 2025 09:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4724A8E0002; Mon, 10 Nov 2025 09:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313158E001F; Mon, 10 Nov 2025 09:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 19E658E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:28:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B38DC140127
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:28:00 +0000 (UTC)
X-FDA: 84094926720.29.04ED274
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf03.hostedemail.com (Postfix) with ESMTP id D664B2000C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=gTglF1gn;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf03.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784879; a=rsa-sha256;
	cv=none;
	b=xrBz9cp4NS2MAxq7nJ5o4stSz+WPALzA54YjGvYOs/rpBtAwbFY9OstUPvshNNMkBWDuwD
	6ZJpAooaiwvTy/cagqzOTnxPxYUgMzqdl+ZtgtdV7evoEJ63Sc78gTJB2YJX/xDSNfHKgU
	ID4YgE+T7OGoEW9j1S+Tv49e9zyV5xc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=gTglF1gn;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf03.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEYRZhHrbN+WNTyHjZsu0+gGsmV/WTQ19EskUwEEmN4=;
	b=z3DGwPXcLvRsi03pqbFoL+f1dYnVfkPc9OCQhNyaRytXp5/llvwQV+AmeUJ0IL2L0IRRDv
	TPvm3j5hfqMffzksuOZHc/scsQ/Vqk/LNga6DPYuV44j1KR7/25aCGfSc2pIP0GNoV976W
	iV9FjwbMBeAMRk1WbAcpGCNZ5OC7mHU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784877;
	bh=WziPgVW+ACzrMGtAY7VcmT4aJElDI2y9aFr+UglVVN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gTglF1gns6ORuYYg9Izse63W9UhBn7ZAn+InvBQLJs4Dsjjy8HS71IW1909NjRMGB
	 xBtlpl9tu9QpvA5jTzxsMmpR371NE0+PcT23TyI5Iap7KatiGO44xuv6pN8Wym6GWN
	 jzCmgisRcnRtnctke6nlAgklWl4+P8Hf13s4Q/97310XDUzb0BqkHmtlZ4iJ31yLqk
	 /WtPTqwKRyIQQsL6hkRl1CAVNJxqoMO2mahMDM58DklWPuXjyvM3SKX5XgsjaAD4Nx
	 Vx1hKw9od/7yEtKVOmULxOh6VUw9YWh4EdJUao3obDky5Ey0XjkNDk+9IcBRtB1X8E
	 s5HDMWHtWNTLA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6687F17E15AB;
	Mon, 10 Nov 2025 15:27:56 +0100 (CET)
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
Subject: [PATCH v6 06/11] drm/v3d: Use huge tmpfs mountpoint helpers
Date: Mon, 10 Nov 2025 15:27:41 +0100
Message-ID: <20251110142746.3490-7-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110142746.3490-1-loic.molinari@collabora.com>
References: <20251110142746.3490-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D664B2000C
X-Stat-Signature: 14adbqnn9ctkkn8gkk1hioowmfxy948h
X-HE-Tag: 1762784878-216623
X-HE-Meta: U2FsdGVkX18ipeq+Q7ifPujkQcNC8MI3wj8Qyn+r7GdnHDorP+EUaCmBq7jFAIik3zdhAgPOkW8vJ7n+Nn6ybSmxYoinTIQE49RB+1Bpw6uBX2+F8aa7j3UJrbFL+YpyRYG/gCEh59A5s8eIgVL1sR5j7u1j8YocZfevmljB9vdlhDA2cJ3pe/wZvIrab6wRqwZUwdauxuyFE7Nd+ExFB+9jzF3G1sXIJ6NqPDnu9jN2HCouyyg49VjU3t1akX3k/IbYC4jgrbJ/zNnm+YrxptdrB98uh9v7gesvOdudLBvPPspepuEmDhhw1ckFLalRGjPL3yz/Xi24B6hQZ6GS6k2QOBOpV+sWOMRo6nUF4n2RgrBarnHBpUZzH1Pctl6JOIgYs2UE5bigMfeRNtFfo8BlBjFKuGi/KQWH2cxFYFqzaYWz9pxjAprjTCC3R5U5NIR2DNuzJ+RE1VCaRgOWgeVpNZJbJLaBcqgz8EdfeCe5ThiMZ+eejjuPfJMwu401XIM9FbosIjkz0Bp/lHona2z9bQ+pEiv43+D9ZdryG3+5acwkMDG49ZkYordyVHM4se4OVnqbfkKaKYr97NJ2JiJCglUer/Avm48MFzLAJOsjFcDC+akQ5zhxvkwI7QHLl3ZXkxsxG4c71jY8Q/IXsOE3sP0dULof6ioJnFWHHgBPJPq2Tdb+6Wf8TTAs2ndDVjYr2KqnEv99s/0jv+oLsWnyuuQC266g3/fZlyW5SYVjHCOfl72S16M/i1eHNv8wel1jDJkKHbs88bqWI1yExXCXq9gVF8L7uWBMjuOMpWY3hT9DlWoCg++itlV2oXf5JNMdT+IQzejiMD0U8DgZrNpKb4gGQgeRbLM692a6KcZKXvbmE/oZX4+/oF7X1T51gFKFJDp+nKp7mNIJ+zZoL3ZGMzye+HxQMBX4AkP9PO5TyQrVk9sMjL87x0j6zD0362OCPod5k5vIaqtysRz
 bnSNIdso
 YsLG70+vR8ThrneRXFJlfoRffOqUmUByh+APA0xZuFQUzQMWkiIX97m3/tgk7GoAmexnNE70Vtn4dy42jWheh0XSqqeeYa5nyueVGhS/7RLjj+Ssg+19kiA0OAgTWqRUYxphFUf+7nK3zBuULb5RCkefcY0CADqpL+86aQGkhXRL62D3+YcVlb3jQysNok0knIRNeKqIzis22pokaHyYRy6WEMiFHC1xVW2CZ2DKTYb6Uxkh75zbqU1HaRaa7gat8gjkkQYmtAiD2aCW4DvfUJQBoltWQhKGg5PVOd7s+aG6O2wHGgBzjrGZg4jtdXqH4NCDa1y/cu3ZmjmK3tI5m9HSDM0qatJBCkwEJv+0pm0xLRZ4PQYe6MPJk9HAg82/Z41MugmC7a3OO378=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new drm_gem_huge_mnt_create() and
drm_gem_has_huge_mnt() helpers to avoid code duplication. Now that
it's just a few lines long, the single function in v3d_gemfs.c is
moved into v3d_gem.c.

v3:
- use huge tmpfs mountpoint in drm_device
- move v3d_gemfs.c into v3d_gem.c

v4:
- clean up mountpoint creation error handling

v5:
- fix CONFIG_TRANSPARENT_HUGEPAGE check
- use drm_gem_has_huge_mnt() helper

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/v3d/Makefile    |  3 +-
 drivers/gpu/drm/v3d/v3d_bo.c    |  5 ++-
 drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
 drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
 drivers/gpu/drm/v3d/v3d_gem.c   | 27 +++++++++++++--
 drivers/gpu/drm/v3d/v3d_gemfs.c | 60 ---------------------------------
 6 files changed, 30 insertions(+), 78 deletions(-)
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
index c41476ddde68..a1e5881e8b62 100644
--- a/drivers/gpu/drm/v3d/v3d_bo.c
+++ b/drivers/gpu/drm/v3d/v3d_bo.c
@@ -112,7 +112,7 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
-	if (!v3d->gemfs)
+	if (!drm_gem_has_huge_mnt(obj->dev))
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
index c5a3bbbc74c5..ce82a1ceda5f 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -106,7 +106,7 @@ static int v3d_get_param_ioctl(struct drm_device *dev, void *data,
 		args->value = v3d->perfmon_info.max_counters;
 		return 0;
 	case DRM_V3D_PARAM_SUPPORTS_SUPER_PAGES:
-		args->value = !!v3d->gemfs;
+		args->value = drm_gem_has_huge_mnt(dev);
 		return 0;
 	case DRM_V3D_PARAM_GLOBAL_RESET_COUNTER:
 		mutex_lock(&v3d->reset_lock);
diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index 1884686985b8..99a39329bb85 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -158,11 +158,6 @@ struct v3d_dev {
 	struct drm_mm mm;
 	spinlock_t mm_lock;
 
-	/*
-	 * tmpfs instance used for shmem backed objects
-	 */
-	struct vfsmount *gemfs;
-
 	struct work_struct overflow_mem_work;
 
 	struct v3d_queue_state queue[V3D_MAX_QUEUES];
@@ -569,6 +564,7 @@ extern const struct dma_fence_ops v3d_fence_ops;
 struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue q);
 
 /* v3d_gem.c */
+extern bool super_pages;
 int v3d_gem_init(struct drm_device *dev);
 void v3d_gem_destroy(struct drm_device *dev);
 void v3d_reset_sms(struct v3d_dev *v3d);
@@ -576,11 +572,6 @@ void v3d_reset(struct v3d_dev *v3d);
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
index bb110d35f749..b6479a8a279e 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -258,6 +258,30 @@ v3d_invalidate_caches(struct v3d_dev *v3d)
 	v3d_invalidate_slices(v3d, 0);
 }
 
+static void
+v3d_huge_mnt_init(struct v3d_dev *v3d)
+{
+	int err = 0;
+
+	/*
+	 * By using a huge shmemfs mountpoint when the user wants to
+	 * enable Super Pages, we can pass in mount flags that better
+	 * match our usecase.
+	 */
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
+		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
+
+	if (drm_gem_has_huge_mnt(&v3d->drm))
+		drm_info(&v3d->drm, "Using Transparent Hugepages\n");
+	else if (err)
+		drm_warn(&v3d->drm, "Can't use Transparent Hugepages (%d)\n",
+			 err);
+	else
+		drm_notice(&v3d->drm,
+			   "Transparent Hugepage support is recommended for optimal performance on this platform!\n");
+}
+
 int
 v3d_gem_init(struct drm_device *dev)
 {
@@ -309,7 +333,7 @@ v3d_gem_init(struct drm_device *dev)
 	v3d_init_hw_state(v3d);
 	v3d_mmu_set_page_table(v3d);
 
-	v3d_gemfs_init(v3d);
+	v3d_huge_mnt_init(v3d);
 
 	ret = v3d_sched_init(v3d);
 	if (ret) {
@@ -329,7 +353,6 @@ v3d_gem_destroy(struct drm_device *dev)
 	enum v3d_queue q;
 
 	v3d_sched_fini(v3d);
-	v3d_gemfs_fini(v3d);
 
 	/* Waiting for jobs to finish would need to be done before
 	 * unregistering V3D.
diff --git a/drivers/gpu/drm/v3d/v3d_gemfs.c b/drivers/gpu/drm/v3d/v3d_gemfs.c
deleted file mode 100644
index c1a30166c099..000000000000
--- a/drivers/gpu/drm/v3d/v3d_gemfs.c
+++ /dev/null
@@ -1,60 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/* Copyright (C) 2024 Raspberry Pi */
-
-#include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/fs_context.h>
-
-#include "v3d_drv.h"
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
-	ret = vfs_parse_fs_string(fc, "source", "tmpfs");
-	if (!ret)
-		ret = vfs_parse_fs_string(fc, "huge", "within_size");
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


