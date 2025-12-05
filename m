Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A248FD339B7
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64E026B01F8; Fri,  5 Dec 2025 13:22:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FE086B01FA; Fri,  5 Dec 2025 13:22:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477A66B01FB; Fri,  5 Dec 2025 13:22:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1266B01F8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:22:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D0FFD57F3E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:44 +0000 (UTC)
X-FDA: 84186238248.26.C879D3A
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0396D40013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="FN0z/xnC";
	spf=pass (imf07.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764958963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LCne4kqglhfBuqjjr6AWVG8Aso8Th+5jnORfD0IXeQA=;
	b=FKgbLYkoqij6HKhrLDJQeb0mY7OGkeH7eme1igR9gCt34irff1vTeXcLOK0DmGzLfwdNgp
	hWl4Ls7NLb6d+ogBMuBpAvT41wLAxWcNqYgF51n+5FuquIT5v8vd5zDsnxb7VYbzHcU4iL
	HaP4KvFCpZ9YqkC70Ks/yqH4CG+d2B0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="FN0z/xnC";
	spf=pass (imf07.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764958963; a=rsa-sha256;
	cv=none;
	b=ONoxB7zJx5mYztUgBxzvJ/dJ2XdSgYoF7JHg29TGzJmbLTDT9WtkiX0UrZlJkuOiUd7h9v
	I1nOCrwcmbEFoI8w2xGYf2hokJML6KztS3qIdr9ZrvswLkJvx73bCTrD4O98m6XJ/uTcTt
	dCGrowYrzBnODsRH+kj4aAtlTQlfR24=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764958960;
	bh=EuOrtawPFONPLL/kLdWEf7FrwFEddCnrCOFPNp5/XKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FN0z/xnCXfooKK2m6054jta1EAW9zLMcmA6FMREX9hC7Mi2QuD/YFQmYFQJvuJOUe
	 bznBBs2TkM3DbHFg574Xj7cx9hslvqd3Pjt0GHyJVUdGolZm+wwjm6d+wVF9Xvq/h9
	 tY9mSJRL1E6ZqkyT+9aIn7RYyQfj/Yw6IWIXICfDJmHtV9gbJbIw8xucZGcFVhzp4l
	 8j7/wneIl/iL8irBu4qtI8nypVeElehb9hP25QBgJkj8igQ0PwAAZB3k1HBBX+92RK
	 TkYBd0wltyPrhzSJrTHCOfN7uQ4C8o+OQg/4MyxSDR0qkw8j1JPEMtxhFx214t7vuG
	 TSy5UocgXmOuQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 17BEA17E1428;
	Fri,  5 Dec 2025 19:22:40 +0100 (CET)
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
Subject: [PATCH v13 06/10] drm/v3d: Use huge tmpfs mountpoint helpers
Date: Fri,  5 Dec 2025 19:22:27 +0100
Message-ID: <20251205182231.194072-7-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205182231.194072-1-loic.molinari@collabora.com>
References: <20251205182231.194072-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: az9qi969icnecmiiy8zfxeco9ndpwbqr
X-Rspamd-Queue-Id: 0396D40013
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1764958962-214861
X-HE-Meta: U2FsdGVkX19hEcSnXMPqm6W4mj0ixiGN+nCgrn7Np00xrOQTaDAVJRnScB9a8h851mRCnc1dMdzTiO20IneSMTtmndgltkAr4OoMY/JMHrUXs0aMkpde0l6/RuxVg5Mw0Aw0fKS3n/+z6yKQUgeLN6Stc1JH+S8d6xd/LP0rspAig/Nqqbtnzr34L4okUWZ4IS3q8GQe1sJIHDNuBvt7N6nRn45jAicvJOSg0pqcs1sOorOhvJ9G5P13K/GH5yxya/Ysn4hxCB/lsps9rgyS6yKXwIMiPgWxlMk4cq4h8AEJa05KieOjYExaPMPmbj+mXN4PHI+Qm2KCcJTHKzdi3bRoWW18csLBardz2eQ5zDg92Rvp8TxD3SL4WnvGHQtDpeklqpzxfCzSnUpMmi3H8CkaQcYA+XHDRgJu6Wvy9Ko++TGKs+GDkVQrRzSGPtCKiss1veHp67iSXp4NnVpSMiYQIbC161C4f/LP4mBoEEF944O5EtdZ+wIwkLJLgKFDYejsyDqNKDhP+iEhyO3OCkn58tVyMdv6vp7OSFEeAv+3Rj7ubjP3dFdxlXOiRUyw4iS/SiwZrn1xr3rhMwtD0La2/aqDbbdGI7We/sZBTDYIaI7Qx1wgjLag3LuLKe+Y82ONr+vcxkC668n9U+NWkb4tPOTozYW5cJDebd1Gn5Z3nNSSsZDfrMwg2QhXIQtR/EYSSXEgAldq44tUGt+OU5wR3hLWVjjvGlDxCvBmK1xuwY8XB6vLTY1o6keG6t6UlXTLINtvs2u0SbEyPxOCLEwsEkZCxXp1jasUcOfHhN7NQhhLBf2l0UjTdesf03UKdpmEm2EwLvvb9LTtWm/DfoUq5snaeswbazZkwgK8WY+ZZ30d9mZ+t1MT3yUXngWL8/MrxRAOJPrFyLIZ5nLajNBfq5SDLmpmXW4MP0+YM1J+VYZ6IGwRSk6YOKAvKVL+EYzgbj7W5B8uyHr05B9
 1MCpuZW3
 +KYhqd73lOC4J2VmBacKI733QuDhMZwmkBfublwgfaQFUW09VRID1OxynEjM+agFZG7XXKyWtOA8t1PeXk2uT+vdahkZv969be+fR9048umWR5vOJi+dVW5wyUYWKvqHbxj8aiIhfq0flgnh6VZoSH3tQtnyzywsF3lLC5pU6VTGQNnSwxVE5oFvclJzjMhA/T1x1vwncmRSiJ+jZU29bennHcgielR/z4c0zIkmP/UhTkLJc0Fd2A9ZSrSp+ucOL7GUMRJdp5HMu32vWXy5cFfG4szYsVbAdlX/7l5rod8s9QGF7c0jeoh6TB4hJ9xgA1cClNEj/2uX4f4Q/1LMZPnieOTLcGWo2TCbN2F6eaQfPKY1CvExCvYYUtcdnvwhbo8PVO+DiqohzoI5ty/UctNjAocFbsLnY2WG1U6SLamPllZNUjkcemtez06sKLjde3SWx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new drm_gem_huge_mnt_create() and
drm_gem_get_huge_mnt() helpers to avoid code duplication. Now that
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

v8:
- don't access huge_mnt field with CONFIG_TRANSPARENT_HUGEPAGE=n

v9:
- replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()

v10:
- get rid of CONFIG_TRANSPARENT_HUGEPAGE ifdefs

v11:
- remove superfluous comment
- add Maíra and Boris R-bs

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/v3d/Makefile    |  3 +-
 drivers/gpu/drm/v3d/v3d_bo.c    |  5 ++-
 drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
 drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
 drivers/gpu/drm/v3d/v3d_gem.c   | 21 +++++++++--
 drivers/gpu/drm/v3d/v3d_gemfs.c | 62 ---------------------------------
 6 files changed, 24 insertions(+), 80 deletions(-)
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
index d9547f5117b9..3ee8d9c36d92 100644
--- a/drivers/gpu/drm/v3d/v3d_bo.c
+++ b/drivers/gpu/drm/v3d/v3d_bo.c
@@ -114,7 +114,7 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
-	if (!v3d->gemfs)
+	if (!drm_gem_get_huge_mnt(obj->dev))
 		align = SZ_4K;
 	else if (obj->size >= SZ_1M)
 		align = SZ_1M;
@@ -150,12 +150,11 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
 			     size_t unaligned_size)
 {
 	struct drm_gem_shmem_object *shmem_obj;
-	struct v3d_dev *v3d = to_v3d_dev(dev);
 	struct v3d_bo *bo;
 	int ret;
 
 	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
-						  v3d->gemfs);
+						  drm_gem_get_huge_mnt(dev));
 	if (IS_ERR(shmem_obj))
 		return ERR_CAST(shmem_obj);
 	bo = to_v3d_bo(&shmem_obj->base);
diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
index e8a46c8bad8a..8faa9382846f 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -107,7 +107,7 @@ static int v3d_get_param_ioctl(struct drm_device *dev, void *data,
 		args->value = v3d->perfmon_info.max_counters;
 		return 0;
 	case DRM_V3D_PARAM_SUPPORTS_SUPER_PAGES:
-		args->value = !!v3d->gemfs;
+		args->value = !!drm_gem_get_huge_mnt(dev);
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
index 5a180dc6c452..697b0b3ca92c 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -259,6 +259,24 @@ v3d_invalidate_caches(struct v3d_dev *v3d)
 	v3d_invalidate_slices(v3d, 0);
 }
 
+static void
+v3d_huge_mnt_init(struct v3d_dev *v3d)
+{
+	int err = 0;
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
+		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
+
+	if (drm_gem_get_huge_mnt(&v3d->drm))
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
@@ -310,7 +328,7 @@ v3d_gem_init(struct drm_device *dev)
 	v3d_init_hw_state(v3d);
 	v3d_mmu_set_page_table(v3d);
 
-	v3d_gemfs_init(v3d);
+	v3d_huge_mnt_init(v3d);
 
 	ret = v3d_sched_init(v3d);
 	if (ret) {
@@ -330,7 +348,6 @@ v3d_gem_destroy(struct drm_device *dev)
 	enum v3d_queue q;
 
 	v3d_sched_fini(v3d);
-	v3d_gemfs_fini(v3d);
 
 	/* Waiting for jobs to finish would need to be done before
 	 * unregistering V3D.
diff --git a/drivers/gpu/drm/v3d/v3d_gemfs.c b/drivers/gpu/drm/v3d/v3d_gemfs.c
deleted file mode 100644
index bf351fc0d488..000000000000
--- a/drivers/gpu/drm/v3d/v3d_gemfs.c
+++ /dev/null
@@ -1,62 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0+
-/* Copyright (C) 2024 Raspberry Pi */
-
-#include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/fs_context.h>
-
-#include <drm/drm_print.h>
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


