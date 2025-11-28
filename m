Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB94D116F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 18:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA086B0093; Fri, 28 Nov 2025 13:53:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B850C6B0098; Fri, 28 Nov 2025 13:53:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9892B6B0095; Fri, 28 Nov 2025 13:53:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 87EE66B008A
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:53:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 494AD13B950
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:05 +0000 (UTC)
X-FDA: 84160913130.07.AA56F60
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf23.hostedemail.com (Postfix) with ESMTP id 67599140002
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IhZLNL9S;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf23.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764355983; a=rsa-sha256;
	cv=none;
	b=ACizrFpu5pbr8Omow8/kT941iFAWoU7o1rKMpr7TsQuV4DzgYARB5Fbhxfvrlkz9ANGOzZ
	TZwNPLEicHxL7exEzYLb9hQiWRf7BDHFOMThit21Lsk/EutS5bzKFFoOgWJ0lLIsrmB0G3
	CtZl4Yo/ZQTHBK/SCegi5wsVSMBB/aU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IhZLNL9S;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf23.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764355983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Gtt0qmyBr1XVMHP+uh6Zm+heiaJcbT81769yAsBJw0=;
	b=3Q+uc07ZijzVCjTlIMAdTN766PCJbVUDc32eyXNaFL1CR2AtsxqBfypNF66dccShjz+sFE
	Vj2KlP4YJbv9JCkzGel6LbFqBt/N/YVF1wndvqcXr9leJn9OD+ievuuUUeMEu5nO3kWuJc
	h1ktPpLU2gZT0zkEDd8GFgykXCFZdUA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764355981;
	bh=lWeRizCFAnoy9k3fq8zKRLrGIQ7rHu7NhvzcfhIg40g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhZLNL9StSduEJYCxG4MWB8MoB5AsHq4o0VM1BynHaim5ZOC6qC+3YZhAl8/jUcP0
	 1GmTGCweLcwcTSyEh/C/VUjyh/pc8M23b3Q78NaV6Kj/1w1wk7BSLYos4y8z2mW+eV
	 1rQ/g5cDTraSDZyC//3aEs+vm8ER2NlTb+kJXVSePEmRDBoqbIHsP/euMRi/bLS2cR
	 qiWdrzXZr43j5RtSCJhHQb7U5jP69ocM/8gc+2Ux9+dTZZKvFD+5TfBsvXHiB8wxX5
	 582uAXk777Dfn6qqO3wyyI0ov8PIXhvTinHnjXf77euy8rJ5M4ynhILbSx93nMYqVW
	 BBlE9fGi8G6Fg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id F1F3E17E13ED;
	Fri, 28 Nov 2025 19:53:00 +0100 (CET)
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
Subject: [PATCH v10 06/10] drm/v3d: Use huge tmpfs mountpoint helpers
Date: Fri, 28 Nov 2025 19:52:48 +0100
Message-ID: <20251128185252.3092-7-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128185252.3092-1-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 67599140002
X-Stat-Signature: z3ng9y3mitmhxursdu3gujpec8w31ys6
X-Rspam-User: 
X-HE-Tag: 1764355983-788705
X-HE-Meta: U2FsdGVkX1+LCsSXZMAdhGJuHXRSFOPC/u7Oo+idDf/38qaD92h3x6BFIxEuHd+kjXxrg1oNUojuMk7tDhKlqhL82FrGYaDOa+kyBiB6HF+yyyDaF4p3RZObQ69zR39Y76m5gsFiiHZ3xEBUv7nJLAGuepPTGHvUVVTEFFHRCXfE0MIZ/8n8/mBkIrGQRBMLQd1Q6IpW+sTDkzbRxb/UY8iMhJhNfrjF3psnN2BivsNPAsTnMKpoGcAgUZXmaafKuENRzi8vSHkJX7DRZlOAKsU9ltQtAu8N60KPJzA3eXbACiMUR4Ee7P8zJ4y6/n0pF8fu8tco0U1GPS282eUUqu4lF01efwRbsKy0VfT0sihniJBSqss5S9elTxHCwuOeO4Im0nfG5f36L+ZHxUNTl3ZGUBph2/t3hugBTYgjm8BOaD4CZDBBkDiM7kPZpeJ2DtiVu4NqhKgv6ja1RUynFfPi5MXvN5qVQCjkYT20Z3arA0MbbPhQoY7S8UQXmnTVw7lQxdoL3wRjwkgX+FUrlJeVeSPkOUKompEmsGm+m4M81BIWQ6HyRCfH7BNQjmCJ99ya527crQUhiRDBkBVvLAwyEet4SpDe4qGnFec5RB3wPe+N7JOI1yURJ7nwwg+xW7TTNZ9vgvlzcV8N5NOZYlap++H4qDDaCXAlhAkHV81w9IM+RCL+wAgTOBPvL74a4SzSwvk/ke9dfMo6Hq3wArGurTNhNw9KB/esYbXifeK15COdmkdTdFsN2zE4PVF8VrtrkYD07H81P27Jd/73zK1GkdEkRg/2Bp0uKrnP0z3y+zwLaAa6OKfbNiqrMf0zpJwzB4125RKmSYcX716gR4SjxMkN3V/5sQhJcp4oxEXZ7dAPFjhHBeuqn4lt7NULUAHgCXXsuCQpYbwEPrQO2ebHKxOzrZ5B52Ino6fnMbYml8OfsyS8h9VUOixLPLScphdV2JvQIKhfPa30SRs
 JWC0Nhve
 BuoZUXi3zn24s3gnO2v/TIrUSVFtvVvtRkuodBroHslDKsx1X0awqElU+bxiqOr/S3xJn4JQclciMHugomk9ZG0QlXdq9CE9zImd95Gg+YWLmPpBOueAeWOadvP1MtAYd0Nr6lX/8pirhITGxbsPHRfsc7XB5bDMgdURkXcM0Lhbi67q3XX70ZHuE/ePUfl7PUoTO/VZpTpm79lmKHHU8MeTAdPhueVskhZWsZI1WVshduKI950tAPi87oQSLP/gmgma9x9ufTYjbwX6pg4aYtzMVfV8cTr6bjvNkDS4RMyUl0CI9PHWy30gFhuKhPK6mUrMkYDdfQtudSK8QBdFxA/4j/BkRR6thaRwCD/ddjQ2wBEZaSUXTb7M+kGy8lg3MZykWXSqdGRZS22E=
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
index 5a180dc6c452..62532a89dd14 100644
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


