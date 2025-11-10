Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB78CD3421
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3801E8E002F; Mon, 10 Nov 2025 10:50:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BB278E002E; Mon, 10 Nov 2025 10:50:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15B778E002F; Mon, 10 Nov 2025 10:50:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 021E58E002E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:16 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DDD885A29
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:16 +0000 (UTC)
X-FDA: 84095134032.12.1851DA5
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf13.hostedemail.com (Postfix) with ESMTP id C25D52000E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=UmvlAPxY;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789815; a=rsa-sha256;
	cv=none;
	b=RbrOHLANwfUXgOEs+qsNXtXYhLqyUKHJ2/6o8sa3ep9SmDOcoicqfOakwosYc+9LGEiIT9
	pIP1JfsTxhKgZCA93PFKW1mlS92EJ08a92OrERXBWK+uqoP3DOhjA2PQs6KIwjKyadxhcl
	fvHeoIPyakMbPf+liUoGaClHb+ylBHU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=UmvlAPxY;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2Wpzk/FAG4iWh8ESNjAWsls7Jb/OjRYTL+ScqfNW6Q=;
	b=0AFDK2OJC7jYrSO8Wa791tmcp3tFjclaApQLnuUqY2zCXYSIgd9JQucSmM0ybDlmgVDJT3
	cgqU2u2p6DbY0MY9uNsKRGQrc7H/h3zFAJvEtccAWoGVmwEHg+6YL4+XlrDo/bZeUk+ZuG
	eYuZoQuMnjURHKO53lP3QQgfT7Uh0/M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789813;
	bh=IWAePuBfNB+fA0nGKYd8CoMX9Q94dkB+Hi/d1IyYg8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmvlAPxY5g/foPKBIsxe5mZzAxlBNzAE1/TSGk1qp+05dikuIp+JtOHeFhjeZl+u9
	 fEjEQCDdO1d1+KHWit/516UviwKhUVkTnWp+vNqjuajLMw6u65IP0xfMwZO8bj7fJu
	 Uhfn70n9E2y20PV+ikhLDohXscO/iQnQME85aDJ7ExwmYsGd/eLEmoduT8u+pxXk29
	 ZC/NlEyXoG8YKdzkpJz07HYp7EZj0m9vinXVhCt2ZLNZRFLY5PbKt95dR51L6qX0QW
	 RzqxF5OX/HNJuHVsrBHJOsob0SROAZArzWv42wxBzi1WQdhiEbU83Pw1sGhAcTNFDn
	 IhFGXvgixtLsQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2460317E153A;
	Mon, 10 Nov 2025 16:50:12 +0100 (CET)
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
Subject: [PATCH v7 06/11] drm/v3d: Use huge tmpfs mountpoint helpers
Date: Mon, 10 Nov 2025 16:49:54 +0100
Message-ID: <20251110155000.2936-7-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110155000.2936-1-loic.molinari@collabora.com>
References: <20251110155000.2936-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C25D52000E
X-Stat-Signature: q9dqxbztawg3e4o45csubkoo7aw145ju
X-HE-Tag: 1762789814-716208
X-HE-Meta: U2FsdGVkX19Y2zrAZLEMM+rl8sVCkwJv93YaHrEXOLKP1BnP5VpU8vchAtAlyzlN4ZstZuqIpiKOE1LiIDh4InmCpo0+EtlFjO9OK9NBRjG3+LTPwWIz/yhWXmcYqGwWziEZjHOQO+493uFae+jFhUyHcJ80lyWjsTfa5bcXclxSNlkVHKX8t2rkLkb4kkqrM3AERBvhAFog90dk1Gw/XEyrdvSo/CzgEbyeXcUBnNseSBp0y16TbvUDzmzGaz9/3sUqt8/h0h5Mr80Ls+ynnCMj+9jLkNEIFXsnfS/dsPmqIdpDuV+/lhHxtoZHcPErNTCFLYYmeE+rGgDTVdoCsznJUKY0KxiGoSOz6A7FS56Sa9B4EqUesoRUh7173YbZqcRP/BI1rTQnQrB9lCrRj+u4dpLPYJdwZGwOk8KYGvhnwCM/lXIJL8FGb2wLqppPQHfdro4EDiTfc7hd7ETrmwqJ3uP6wEhhEoMqu2vWPNrwPCks1Z4cT2VtpLglTnmW4rUwiNgdQMiDru98WxUnhU/A818qJl/qZlr9tcV6FScwcS+XXfuMmtqYxSYKNmPLdNgKNWVQ6DbGcSHMjKqCr+XY2ir1yCsqjbkyuY73Z0OxdDSa2Nd3OsmBohBFgTfurF2VSCdbp8lViVRQZTij0OdvwiQ3sp4skZsCLs5/pyUSRBC+vrFNE0KnxcQrYpSOu+RnI8zgDE7++p6odDzYSqyTXfuHgwv2VeteRR5W09J0hP4SXfBaxRvcUSaK/4tyA1bfWAVybCh1jmTD4pKjDjUmWvSSxYjyDG83oDu9foLHImeo/PhOzElp7nfbYBHhsfGYt+wIRS37Sxv9/deZD+zEdk1+HHl9RDGuCeYbs80iJHdI1HPC9y0dsZGgMHNBQTHp6Z0Ubz+dGIOsfK6gpfMPeKR04LZZft8+9sdKpe4vQbrbJ2GdwtsSShpfphjJo/oAfoqdHlb0rN70e15
 NFZpkWtK
 MIPAla3AIAzxTE8uDOZZKKjEv4ZkoQwFDTmN3co9G7f/saT0008ycZNdItZPoN1n06hc9VSGVLE2sfkRgLRYhEMRnhf2lW/BZYPEJRHKPLwg+FWich5WTnNfje2dIWe7uZRNTHqZXQlrmHhICp0fJVVwG7MZgMWXtmybzj4abbhLbYORPopb9h3qOEb4UrAMeh+K0GNE3ofh94Lh6x2njx0OAl9u6XkFaq+ZfT8lzON+LZI9xpfqwG5sQhRgTEt74GIdSV8Vl5c3tTpqR44zzUUMUPVK+35ivy/ylXrDggEjtM99BdK5Zy9hT/KET8cy2d3r39b+BhE8/65QlFTEol/0muO/ViJaXOr3xFE89Vj8GnI/+YFC9hJgwfVSo+qT0qay5
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
 drivers/gpu/drm/v3d/v3d_gem.c   | 27 ++++++++++++--
 drivers/gpu/drm/v3d/v3d_gemfs.c | 62 ---------------------------------
 6 files changed, 30 insertions(+), 80 deletions(-)
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
index d9547f5117b9..99c6a775d18b 100644
--- a/drivers/gpu/drm/v3d/v3d_bo.c
+++ b/drivers/gpu/drm/v3d/v3d_bo.c
@@ -114,7 +114,7 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
-	if (!v3d->gemfs)
+	if (!drm_gem_has_huge_mnt(obj->dev))
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
+						  dev->huge_mnt);
 	if (IS_ERR(shmem_obj))
 		return ERR_CAST(shmem_obj);
 	bo = to_v3d_bo(&shmem_obj->base);
diff --git a/drivers/gpu/drm/v3d/v3d_drv.c b/drivers/gpu/drm/v3d/v3d_drv.c
index e8a46c8bad8a..30b55a00eeda 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.c
+++ b/drivers/gpu/drm/v3d/v3d_drv.c
@@ -107,7 +107,7 @@ static int v3d_get_param_ioctl(struct drm_device *dev, void *data,
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
index 5a180dc6c452..f316f67364d2 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -259,6 +259,30 @@ v3d_invalidate_caches(struct v3d_dev *v3d)
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
@@ -310,7 +334,7 @@ v3d_gem_init(struct drm_device *dev)
 	v3d_init_hw_state(v3d);
 	v3d_mmu_set_page_table(v3d);
 
-	v3d_gemfs_init(v3d);
+	v3d_huge_mnt_init(v3d);
 
 	ret = v3d_sched_init(v3d);
 	if (ret) {
@@ -330,7 +354,6 @@ v3d_gem_destroy(struct drm_device *dev)
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


