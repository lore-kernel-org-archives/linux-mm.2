Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37FFDCCD19A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C5DC8E004D; Wed, 15 Oct 2025 11:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64EC28E0005; Wed, 15 Oct 2025 11:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BF98E004D; Wed, 15 Oct 2025 11:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 29F218E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9CF31401DB
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:45 +0000 (UTC)
X-FDA: 84000736050.13.4F277C4
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf12.hostedemail.com (Postfix) with ESMTP id E002A40011
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OwIMJ0Dc;
	spf=pass (imf12.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542244; a=rsa-sha256;
	cv=none;
	b=YJ64DEYHxDSrxCgGSAj1I49OU27WluRjj6iuoKZvn6Hg0fQk6gP5lgANV3vs3Giwa6taqv
	afPEcVJflKf3FallVS2SQNAf3hJ1SRaSw8DiVNbqgwpUjJsazvRxMl2yxuDtfkc1Qq0sSB
	sZzfX5CD12YsIf9nAfOJUGTy6NLA8Xg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=OwIMJ0Dc;
	spf=pass (imf12.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yGKrm8LaqaRIGbvR05BXnGkBGQSJBXtt4M2xufZWCfg=;
	b=yjBfE6uFzmbQr7AFjfiJSf/J2SWKRIe/2zGpZ11AqL6zV1z6GlTsDLaXTMz1Ukj/7IHpnU
	NI6jTJ14FfF4ybtOVtCjylCtza/WAeLUZkpoKIIwF10XHIpwON6R9fCLaduV2DXNTVXE4j
	5H8EpJGU8WXoOz30Ceq/eiHMECV8CMU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542242;
	bh=mm3M5IWbHJSSC/HZMhCT0yYxpiSW+pNm8+0hCzyQoFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OwIMJ0Dcwtvomqe64Excosp0itSDMxWufpTakTNXPYLWib4FeWjtjeHWY7xm2UG60
	 xQlXW7kjLVStAfwwNr1TxLukaUhqqDQemjDzo17aKbEnXg2131uldcKncMzWzpTrs/
	 UoLw4Htf/fDKDkShypj5obO7tQ75u+i9+t6diLHoeroxFI5E1iyOaJVAY9C8yh8c/X
	 VYyEaVp2SiGKL9OLN7JlZ9A9ag2sjBPj8rsphH9fOKTYcD6si6hDv1+eCVNiOo+r2t
	 b17o16qp5C/yJpMDwmvJ1BtuwyQtLJbcQfN6yyL9ZT/Wj/Adu+vj+4lwNyAV0o+g3Y
	 JRWWBQPK+3b9w==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id C1FFE17E055D;
	Wed, 15 Oct 2025 17:30:41 +0200 (CEST)
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
Subject: [PATCH v4 07/13] drm/v3d: Use huge tmpfs mount point helper
Date: Wed, 15 Oct 2025 17:30:11 +0200
Message-ID: <20251015153018.43735-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: u7neqwa13ws1fjg6qt9hhbnn385zjeyc
X-Rspamd-Queue-Id: E002A40011
X-Rspamd-Server: rspam09
X-HE-Tag: 1760542243-332949
X-HE-Meta: U2FsdGVkX1/nd8NbcppE3hc639+unP+QurRWPka5O8SL2DZ2GMAnmpfCDMbBEYKTt3ZAtcethSP08CQqzuXwj8VRgairDpXPbW6M/+1FDxlKkTM9QRkYw31/hyVzcclfz7Zn9nNkhXwwn2JrZU7Oxw3sTXoBsuL8wGznjipILdfCZqhMFAHnvdGK3jDUFhJIY1F6kApbdEkAhIVFelFAZh/psHXzLLRKGMIJXwpE/N+R2alfSPcB3grlXSEjAJd3YswVpyNYz6xm0GCRTW+8L7MfFqRYdlMGWc50e/z/5Hs5YW/sEl2xgmP34w6yb872rGepxaQVmdSji1Flb6mKIrmaez9o5x5uRlk9LgDpmGoU+pJ9nU+HrGl2kzz0k3HgTFh/Wm3NqrmX0pgPpA/jZ2ztLoR5bW9EKl/VP9/g1MaMZrxfzIs6YUOtWyiY/XIezH+yMYbPne3hGZolOkwAALNAS7vcNPTG0JHL8XahNeCK4S/a/1EY3tpkkJ12Iqa2jCcSXhz+yyCiQfFgcsSodr1iKDatCnkJ9PSpYW0aaCK+Cg47tQgkvl7Ly1VqPfteyxaLLgnpDNreE8FUe7qCA0AgSAaNMkMtSVXXUp118Gzj5x8vvNRORsFzuq+FO1+r4/RPmkkLDwImWOlGJEEqYFxL6t7SXUoFWyVoSuCfFNqqmUop0O9f5Jw7Jps8eYt0t+pAnRxxL5KVfNnXqAfypeD7lkmZRgcLxnHy1+J6nMkcMZbLROKMLQLWQ15GlNcU7rUgPoLGN2tqievcXiyVlGFZtKtboS4b5wirGM5+bYNK4SAXuNUprn88Ogzx1RAFtMq5d5k/dkJLEZQ8Ng25AACqhaL/KnIoyAqH9VRx49OskiQtt6aUdAEn78XPWrJDHm95cLkSanTSsAVT9Q9XfWoSOc3wcDlIpj4Pdni1hc/698SB1wHER+fQ9rMPz+tKbak5P/MVhv0YjBmY6qk
 p8sxdsro
 JzS/jOF/aAaagbAChLer/kZHeFcjhFRlQv9AEWkjjNzXesfA1NhUpVwccLqSpDRY1NxGpLTLFjXPrjtbPiVS+YQaFEhIYDER4gzUN7BG6aDHZCoDy22xDSZwX9LvjqcKlq/9789c+AwN0q8vjtmfRO9E46jS1D70oHvGsc3+b6yEvojh4k9Utw4EJ7jdCg75IL1re1ok5e+5MbbznpjpzqPRTnNro1jXPBQnPjaNDGctMpOm5ezOxM2Ct75vY4UaiE3fd90sg4jnIs+3kHzGnZcuiV0gdGlMOe9qqN9ewhPy3y5CsBANtYf9GVncEihJbUlAc/G4U7rDDhSTpmtyKyenuDolpgiZNyuWd8frgECjveebm5yzCaW815d468wcwFY7g
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

v4:
- clean up mountpoint creation error handling

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
index bb110d35f749..635ff0fabe7e 100644
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
+	if (super_pages)
+		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
+
+	if (v3d->drm.huge_mnt)
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


