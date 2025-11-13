Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D02CD8CA4
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24B468E0018; Thu, 13 Nov 2025 12:00:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC568E0002; Thu, 13 Nov 2025 12:00:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076228E0018; Thu, 13 Nov 2025 12:00:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0E388E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:21 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ADFA6140ACA
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:21 +0000 (UTC)
X-FDA: 84106197042.01.A59AA14
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf22.hostedemail.com (Postfix) with ESMTP id C4AC2C0023
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ESswB97U;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf22.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053220; a=rsa-sha256;
	cv=none;
	b=X1OYvG54ivnleSugsBh3IEPmoSJt2+U6Arug0fpmBYfzpplC/RunkUsFANNcCKYMs6nq3n
	rhwb9N3+C0Xy8xVgDpc60viHCbjIuvMgj0l30wUWoqSNVHDrLXfmMecZAscb0X8hBj89uv
	SAucYR4Y3vHTv4HglXg6p6NUFHBPCzY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ESswB97U;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf22.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RL/YvTOV9bq+OGfRes0qO4aHYeqe+HC4hlegWgWO76c=;
	b=ph1H2Yn1vMZW4BtmIO5d3LY55JX5sZeMEGPazMCADQe1y/MT2iXjRqm3S2K/ZfuY0kXhNb
	eEilgfVZPLDyrIlKGHkk7LfpPgy1LshP9r3mPTnfVKC552Rjlp4mOyWQufVf4JJkIJb29B
	+BiExIlsHr3VY0dp3vqbH03qBq4LY3Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053218;
	bh=spYITbrA9e6Nbtm9P1ayDz3RtczGYgXs2HigsbhVHtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ESswB97UVNuJhvTUWhWvUKL/54wgzkFp4uvBML+1+SsV/c8YfuBgNzWQ/494lZYOX
	 3xcgw2DWD6Q/P/OtRAHnRVM3kDvsWImrsmkg4DokweAVvCjINet5J9VsSmW4KJbXqs
	 m3xj9x8Cfo9x/zi1M/TtrE6R5wovvYhHPOdLa+Wk3cCcgaFealRlA+9w7CVu7IWWjM
	 vAchCpTBhAZSGm12JBf9Z8jO4HenbIxwPyxq20djau3BXHEg5HyY8Vhcu5/klsUiwz
	 BpxG69XVMpxjj8GmstX+SoIoms+1JhXSuvKdC1JN98vnh8oryQmR++kIHoKfmu1nue
	 XUZCirARK8Kag==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 29DCB17E0202;
	Thu, 13 Nov 2025 18:00:17 +0100 (CET)
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
Subject: [PATCH v8 07/11] drm/gem: Get rid of *_with_mnt helpers
Date: Thu, 13 Nov 2025 18:00:03 +0100
Message-ID: <20251113170008.79587-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170008.79587-1-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C4AC2C0023
X-Rspamd-Server: rspam07
X-Stat-Signature: qg93555boknfbcc4ada84dpqyxg8ox7i
X-Rspam-User: 
X-HE-Tag: 1763053219-523543
X-HE-Meta: U2FsdGVkX1+DTTgtaHkQN1EqiVt/B1ijW0Q9aID2lGqq+klkkhNPtMUW6r5dI1XFXZCMqPeh/2x4AfjQnoxqkEZ1MKJarM94CZjoGjOLQSr10wBJe3/B63rhaER13juvigtx8OhtlIbLFDoWrGVo7a9qivog/eD89OYvRjUOUSPiMqlHbIditUuYYVObDvUisu7TpGVZkiWFY94bvLFivOG5OgBJlK0OYjck7uEXvGd1TqhXvWk35goMs7VWcuK+sFA2VXlLxuweOVbQXrHm/1P+Bwxmh/Ap2M0x4z3ftFkDDsYsJ8SfhmgLbtOGPuhrbzRvN/YaPimiNjr8DzkK+7wHiSFzZfHDNS2DGYhSI42cfNFd3OGZvVxe4y275Wa7wQUt2lraEmqQpiBkvLdQ6xiQDStAR4ZHIRg0yAPH5dALQaxKqfs5hgMSqAFCRO+z04FnhynVHxIQmEcxFrJnnORXZ1G4GQ8DQJkJVE6oVufMHdG/FYBqQLJx4cSsF9B7JCtzQACUYIN2537ngC5LJ/W6Y6Pym+BmRBU2r8m1qhcKdOY55sQBYSXEwwpDD/H9kqWA2ofIkJjbjjVdv+bdrQMmgZchjB0GYmdMy81M+x4WTjNStgFKbC2AZ9NKQIVIM+tkedwIKzawchwHygjfkRtleh1Wo+Jp7JhTuS+V73JOi7wYdMYc6EGtrgrPbu4/pWIDUR3GbzY3rXHP6G/SxZmrvQ7AEVvTiqcKfwXqP+JYrBUln9NOhwNLDBY8FJocTtNkQGFdfnk9M3E/WtEtXCRhCjgsEVtqw77zEfhd/pWzn9au8u2ERwf5KBlrjZPVW3xfKN02vJOeQUnUijahA2UKKIj3zewiSAbQVmbSz5Hv3LxUzHVKaD52kE4WtITUQaNDJ5R72MUvS24OmiVy4kF9Xfxi0qaMR2YvLQUTqRG/VuSbbVYMRguOhbFRLnOpJ55N9HCDdsMwyREevDd
 NTuYipNo
 fAutYFLm6JI1A2DNY5iY8p1qSmh6GNpACD8aPAKpn8qsGloK04erb/Lc9Cp78R3Ny3VP4np+Yg9HBi6F75JDelB3tkb4cB6MaOfz4t4eS058q8UXTq0GW9axDiSVS3/M3Weub7qkHWZRn3pbP4pjo9h54Zv7YHbRoLkFLvh/4W3K2hSl50svVcEziPy+sYBMZ7CxeeS7o0SRlVUGX2lnoqFrdVwRxWKVzwR6P4BjbNI01WqMpYt0zaYugef4XNKOfjOnYLlIM+TMlG2whPxDQGLSxs8r2Jy+EK0jyKRRcVwAQjsx+42YtR7nkiTWD81Hugi8Esmqsx4styMWb3lt4FcZWPgcIJNPrDQ5U3VtT2YxbNWbyqnON+OOU0A7CYPGeDC6gJj0/FWpNlk7vURcB0K30gBTETZCPEWvGt/QJAowOoCXcNLssFK0vQYDzFZ8svd05ZAub7lIFEnqqrglqoWaAkTvMtgpQ4dy1iZs6v+4xr4VUzFRuNfAyojUrZdgwFyqGzFhsDmhDbz3urdPiM/+3GTMajKbs+zBkAGirfzS9Na4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drm_gem_object_init_with_mnt() and drm_gem_shmem_create_with_mnt() can
be removed now that the drivers use the new drm_gem_huge_mnt_create()
and drm_gem_has_huge_mnt() helpers.

v5:
- use drm_gem_has_huge_mnt() helper
- compile out shmem_file_setup_with_mnt() call in builds with
  CONFIG_TRANSPARENT_HUGEPAGE=n

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem.c              | 38 ++++++++------------------
 drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++--------------------
 drivers/gpu/drm/v3d/v3d_bo.c           |  5 ----
 include/drm/drm_gem.h                  |  3 --
 include/drm/drm_gem_shmem_helper.h     |  3 --
 5 files changed, 20 insertions(+), 67 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index bbca2ab9e9a5..1b0b5813acef 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -171,31 +171,33 @@ drm_gem_init(struct drm_device *dev)
 }
 
 /**
- * drm_gem_object_init_with_mnt - initialize an allocated shmem-backed GEM
- * object in a given shmfs mountpoint
+ * drm_gem_object_init - initialize an allocated shmem-backed GEM object
  *
  * @dev: drm_device the object should be initialized for
  * @obj: drm_gem_object to initialize
  * @size: object size
- * @gemfs: tmpfs mount where the GEM object will be created. If NULL, use
- * the usual tmpfs mountpoint (`shm_mnt`).
  *
  * Initialize an already allocated GEM object of the specified size with
- * shmfs backing store.
+ * shmfs backing store. A huge mountpoint can be used by calling
+ * drm_gem_huge_mnt_create() beforehand.
  */
-int drm_gem_object_init_with_mnt(struct drm_device *dev,
-				 struct drm_gem_object *obj, size_t size,
-				 struct vfsmount *gemfs)
+int drm_gem_object_init(struct drm_device *dev, struct drm_gem_object *obj,
+			size_t size)
 {
 	struct file *filp;
 
 	drm_gem_private_object_init(dev, obj, size);
 
-	if (gemfs)
-		filp = shmem_file_setup_with_mnt(gemfs, "drm mm object", size,
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (drm_gem_has_huge_mnt(dev))
+		filp = shmem_file_setup_with_mnt(dev->huge_mnt,
+						 "drm mm object", size,
 						 VM_NORESERVE);
 	else
 		filp = shmem_file_setup("drm mm object", size, VM_NORESERVE);
+#else
+	filp = shmem_file_setup("drm mm object", size, VM_NORESERVE);
+#endif
 
 	if (IS_ERR(filp))
 		return PTR_ERR(filp);
@@ -204,22 +206,6 @@ int drm_gem_object_init_with_mnt(struct drm_device *dev,
 
 	return 0;
 }
-EXPORT_SYMBOL(drm_gem_object_init_with_mnt);
-
-/**
- * drm_gem_object_init - initialize an allocated shmem-backed GEM object
- * @dev: drm_device the object should be initialized for
- * @obj: drm_gem_object to initialize
- * @size: object size
- *
- * Initialize an already allocated GEM object of the specified size with
- * shmfs backing store.
- */
-int drm_gem_object_init(struct drm_device *dev, struct drm_gem_object *obj,
-			size_t size)
-{
-	return drm_gem_object_init_with_mnt(dev, obj, size, NULL);
-}
 EXPORT_SYMBOL(drm_gem_object_init);
 
 /**
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 81f4ac7cb8f6..43a80f3fcfd9 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -50,7 +50,7 @@ static const struct drm_gem_object_funcs drm_gem_shmem_funcs = {
 };
 
 static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_object *shmem,
-				size_t size, bool private, struct vfsmount *gemfs)
+				size_t size, bool private)
 {
 	struct drm_gem_object *obj = &shmem->base;
 	int ret = 0;
@@ -62,7 +62,7 @@ static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obj
 		drm_gem_private_object_init(dev, obj, size);
 		shmem->map_wc = false; /* dma-buf mappings use always writecombine */
 	} else {
-		ret = drm_gem_object_init_with_mnt(dev, obj, size, gemfs);
+		ret = drm_gem_object_init(dev, obj, size);
 	}
 	if (ret) {
 		drm_gem_private_object_fini(obj);
@@ -103,13 +103,12 @@ static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obj
  */
 int drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_object *shmem, size_t size)
 {
-	return __drm_gem_shmem_init(dev, shmem, size, false, NULL);
+	return __drm_gem_shmem_init(dev, shmem, size, false);
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_init);
 
 static struct drm_gem_shmem_object *
-__drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private,
-		       struct vfsmount *gemfs)
+__drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private)
 {
 	struct drm_gem_shmem_object *shmem;
 	struct drm_gem_object *obj;
@@ -129,7 +128,7 @@ __drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private,
 		obj = &shmem->base;
 	}
 
-	ret = __drm_gem_shmem_init(dev, shmem, size, private, gemfs);
+	ret = __drm_gem_shmem_init(dev, shmem, size, private);
 	if (ret) {
 		kfree(obj);
 		return ERR_PTR(ret);
@@ -150,31 +149,10 @@ __drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private,
  */
 struct drm_gem_shmem_object *drm_gem_shmem_create(struct drm_device *dev, size_t size)
 {
-	return __drm_gem_shmem_create(dev, size, false, NULL);
+	return __drm_gem_shmem_create(dev, size, false);
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_create);
 
-/**
- * drm_gem_shmem_create_with_mnt - Allocate an object with the given size in a
- * given mountpoint
- * @dev: DRM device
- * @size: Size of the object to allocate
- * @gemfs: tmpfs mount where the GEM object will be created
- *
- * This function creates a shmem GEM object in a given tmpfs mountpoint.
- *
- * Returns:
- * A struct drm_gem_shmem_object * on success or an ERR_PTR()-encoded negative
- * error code on failure.
- */
-struct drm_gem_shmem_object *drm_gem_shmem_create_with_mnt(struct drm_device *dev,
-							   size_t size,
-							   struct vfsmount *gemfs)
-{
-	return __drm_gem_shmem_create(dev, size, false, gemfs);
-}
-EXPORT_SYMBOL_GPL(drm_gem_shmem_create_with_mnt);
-
 /**
  * drm_gem_shmem_release - Release resources associated with a shmem GEM object.
  * @shmem: shmem GEM object
@@ -861,7 +839,7 @@ drm_gem_shmem_prime_import_sg_table(struct drm_device *dev,
 	size_t size = PAGE_ALIGN(attach->dmabuf->size);
 	struct drm_gem_shmem_object *shmem;
 
-	shmem = __drm_gem_shmem_create(dev, size, true, NULL);
+	shmem = __drm_gem_shmem_create(dev, size, true);
 	if (IS_ERR(shmem))
 		return ERR_CAST(shmem);
 
@@ -909,7 +887,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
 
 	size = PAGE_ALIGN(attach->dmabuf->size);
 
-	shmem = __drm_gem_shmem_create(dev, size, true, NULL);
+	shmem = __drm_gem_shmem_create(dev, size, true);
 	if (IS_ERR(shmem)) {
 		ret = PTR_ERR(shmem);
 		goto fail_detach;
diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
index 3bc714ea6392..d3b68ee05dbb 100644
--- a/drivers/gpu/drm/v3d/v3d_bo.c
+++ b/drivers/gpu/drm/v3d/v3d_bo.c
@@ -153,12 +153,7 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
 	struct v3d_bo *bo;
 	int ret;
 
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
-						  dev->huge_mnt);
-#else
 	shmem_obj = drm_gem_shmem_create(dev, unaligned_size);
-#endif
 	if (IS_ERR(shmem_obj))
 		return ERR_CAST(shmem_obj);
 	bo = to_v3d_bo(&shmem_obj->base);
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 58fa1e6b9773..75276a12208e 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -529,9 +529,6 @@ void drm_gem_object_release(struct drm_gem_object *obj);
 void drm_gem_object_free(struct kref *kref);
 int drm_gem_object_init(struct drm_device *dev,
 			struct drm_gem_object *obj, size_t size);
-int drm_gem_object_init_with_mnt(struct drm_device *dev,
-				 struct drm_gem_object *obj, size_t size,
-				 struct vfsmount *gemfs);
 void drm_gem_private_object_init(struct drm_device *dev,
 				 struct drm_gem_object *obj, size_t size);
 void drm_gem_private_object_fini(struct drm_gem_object *obj);
diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
index 589f7bfe7506..6b6478f5ca24 100644
--- a/include/drm/drm_gem_shmem_helper.h
+++ b/include/drm/drm_gem_shmem_helper.h
@@ -109,9 +109,6 @@ struct drm_gem_shmem_object {
 
 int drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_object *shmem, size_t size);
 struct drm_gem_shmem_object *drm_gem_shmem_create(struct drm_device *dev, size_t size);
-struct drm_gem_shmem_object *drm_gem_shmem_create_with_mnt(struct drm_device *dev,
-							   size_t size,
-							   struct vfsmount *gemfs);
 void drm_gem_shmem_release(struct drm_gem_shmem_object *shmem);
 void drm_gem_shmem_free(struct drm_gem_shmem_object *shmem);
 
-- 
2.47.3


