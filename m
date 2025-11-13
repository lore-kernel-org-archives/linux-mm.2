Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E48BCD8CB5
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30EDE8E0017; Thu, 13 Nov 2025 12:00:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D59F8E0002; Thu, 13 Nov 2025 12:00:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C41C8E0017; Thu, 13 Nov 2025 12:00:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E839C8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9CD6BC0F3
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:20 +0000 (UTC)
X-FDA: 84106197000.08.DB2F678
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3D33A0020
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Iv924Bly;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053219; a=rsa-sha256;
	cv=none;
	b=zsCOSvQ61oYEWQsZ8y68BK/PrExE5kl47Y6Eg3nQCi1YqwObcUhxWSBj5gSEiM7LteSQJw
	DdXoFR0u6qxN/0tfJ2foIMZj/b6zZSoQFR8V7CGXnU+P3dp7XGJQynarcY0OeJwD7kZaAZ
	UN+bIuI17e1CF9WQRSZN/l1IE4Ns4G8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Iv924Bly;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFcLIsoDwMpwUO7Fr36bLvhIO1VSE6FEnyvp/TNTJPk=;
	b=zNwP53eFFtPO1Mm5ghuD1LDrdhiYRopu4khphonVXNiBiYiK/+iiLH049BNFomrkAT9gCq
	PFpnTXj+wZXrS3KyjOLeCxH3nSP1wpSnqcUzz40iuQ7NZ27E3n9PPIzDKEUK2VmgkGlGG2
	WfgL8m4OSKYWAhK1Fb7aRBEA68i/zYI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053217;
	bh=v6OFrxSoAyYpbjHM20r9xFnmPba+agNd9y5f3ZRnldE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iv924BlysCuYVXp9dzNJuYONWp6IS5gK6U9qiyL1IOg11OZW3tnBevE037LSg/YRD
	 eV1YPYkLXt/qsW2ckdkVz9IWt8LiHkCU6Ui1paOKjBm6E+thJIgrEclNxxDBNPPsny
	 mFH+ziwp07u2WGklPcFuhGB0EmHYIMKHgn3NMVDzfj+6EtwVpVtYKKuj+3SZutaaUF
	 Chk2MH6gOgyOEun8HTPaNm4cie8iJJ0XHpuBksAOjX197BTAzk10+dt21sva9whn6N
	 +QQW3eObP6pV95dbYlX198rCpBxcJcrlhoVYDLUm8G8oKA8UUmbiHirKJfgjnm4Gr7
	 35HVIuyRPRljQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2398617E151F;
	Thu, 13 Nov 2025 18:00:16 +0100 (CET)
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
Subject: [PATCH v8 06/11] drm/v3d: Use huge tmpfs mountpoint helpers
Date: Thu, 13 Nov 2025 18:00:02 +0100
Message-ID: <20251113170008.79587-7-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170008.79587-1-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3D33A0020
X-Stat-Signature: dfhbyxzpd31rwbrdiptx3mjyjzx7zypj
X-HE-Tag: 1763053218-975540
X-HE-Meta: U2FsdGVkX18Ej9mfDwtSHBxjAn9ORAhIMP/m5cdo4WQ9/CjNPzmJJmTqQdn6MVSZUkObLZ48UNtbBmcXs3NS2VMsiFANs9WMULV1mK6dDBivErXl95Fw5HWTfTFIqPs6TVuLYClRak8vBsGqJvigGqRu2HzWYzLXa8Vex/sfT1Mex6IpOckw0OGixgitC3Z8txrmiqk+Uw+wc5P7jsRvHqoYsSpM3jDn+b6tOcUTkM3loZz1UyxX0XDdvs/cyhFZEAn4gWhjiI9ISFiEQbYBkCMEVnHbu/eVzAqe8zCXjHvnwI9UsG+yn6r6gv4bfHQ6x7A+GsAWYC56m7L+TNqHIv5xsa1imk2iPM/pwFv5gVCgpQU1eB4kbV7aWEDndulKAB2Lauf6WnMjR/zyC32fW0a/XNjVeoxUaZ51U+UBrUO3GaUXywHtQCeVpkOYN5bNFIqiZVa1xL5bLgVZ0lnSD1gLTZV1B71Qr1w2klV0HwwVPlbNvRzfWAGINC39LVyzpnvMGh6cEinHtt5kSI/TSMIZBHI4MZtAXLA9guobKBPdieCH1xEbXZtxLDJBVJr7vBWcXSi176+rhBA+mVKVtEvV4CIc2ja8qRJAoG8EgPJQN0cR3PQdSQfz4muTwmt1lBMWDXIB9jhA3ytner9xCCBzeiKfPHB8OsJaFeCfn4I4IQOTsnm5T5CLaJeya93h0E5OVYHvpKtEv+kjXUHhgJoX/rCKO238rmOqKtELWBbbrUwfDlEqeO1n95TLiYpcqFkx7XZORIBndGHwCAFjebzztiP7BHvRmk4PkmW91yFLT/Z9EY8x/Pj2Po7nPInZraw71YXQSZxF9DuNaUiBfTF5sNhD4BfhHFJmL9ouek+dL6A1LXWffGvRUO7hRx94gKSXZ/qMbfDF/1sHjQaU9GsdgU6zoewAgoiJMnZ5IoLYBKoN5xjiB+xTn9Q5wh7q0SIjfxL115kGfYBfTgW
 E97COfaI
 aKJyJiSzr5OiCKKQs9DVvZJ7ZNI3BQKVOOxoXArIXFFgMmwgpSl1gi1Yd6/S4V1QAEtvzK8mV4kwFHpXjuF22Bc8/Gs3235tx9B+s6plTbtkvxIoubCtIFBhsCMypBJ6gxPernOeRMBNW3H1zepbOkEvU90UJjvz6/j5GX4Dme+86dDnQP0W4LwPBlB1/QEuNLUMlKksWt/axn+YcNaysFxUYLpgH7kCbji387RF3Lqhp+gy1BPx6YuqcZAQXyfX6iJz423PmYP7AVsl3dFZAZfCl5Ttx6+NLbfXyBkrdM0dq3kHkiDDLo4c4rDzA8b0DUYgEL+r7AH36DDrgKHswwebIv3GhZ1HfyrRVN9+iXkHczxOEV4zB1kumrP2xco558Ua6
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

v8:
- don't access huge_mnt field with CONFIG_TRANSPARENT_HUGEPAGE=n

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/v3d/Makefile    |  3 +-
 drivers/gpu/drm/v3d/v3d_bo.c    |  9 +++--
 drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
 drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
 drivers/gpu/drm/v3d/v3d_gem.c   | 27 ++++++++++++--
 drivers/gpu/drm/v3d/v3d_gemfs.c | 62 ---------------------------------
 6 files changed, 34 insertions(+), 80 deletions(-)
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
index d9547f5117b9..3bc714ea6392 100644
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
@@ -150,12 +150,15 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
 			     size_t unaligned_size)
 {
 	struct drm_gem_shmem_object *shmem_obj;
-	struct v3d_dev *v3d = to_v3d_dev(dev);
 	struct v3d_bo *bo;
 	int ret;
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
-						  v3d->gemfs);
+						  dev->huge_mnt);
+#else
+	shmem_obj = drm_gem_shmem_create(dev, unaligned_size);
+#endif
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


