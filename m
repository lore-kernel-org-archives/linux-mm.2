Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62644CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20B1F8E004F; Wed, 15 Oct 2025 11:30:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2B68E0005; Wed, 15 Oct 2025 11:30:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AA548E004F; Wed, 15 Oct 2025 11:30:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EB2508E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C340A1A01DB
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:50 +0000 (UTC)
X-FDA: 84000736260.12.77D954C
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id CA2B4A0007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Jb7T6g+a;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4yTW+5KQXT16PBMvJsYY7tTDw6TWdODghK7pROAC2qU=;
	b=TUaiErpIdwOh4US7ymnpTOYXkYbbXm0FA9j8f0BCVrsV4Gxgi345G5rul9KU4CgJSrj2zL
	xw/H3tv8qbZmW3xk21GUXj42N3ZM7UX8d55AyXiqrI8ox6EuTNAPhRhVfuBM+CGqGQSA8f
	jEU1v8FufbENg+mJ/6gZgqWX/FhmXHw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Jb7T6g+a;
	spf=pass (imf15.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542249; a=rsa-sha256;
	cv=none;
	b=nYtldoZcxxov7LKjtulJdqZckr6lz3uzuCHy+nKkc1KydLVGhErenoqJKy7c/sUK/f7l9f
	LxKJUUmQtRQwxdqBhCzIkQBx1CXUvdFhkIktuTYHgeBkZHBWObA9yQAIyxf63YTc2TtYzD
	qyyAoEpcnCEVJJ5RUZ1ceJyAHWjUPE4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542247;
	bh=kTIWND+a8wk3F9Zm2bolmicWjJFPvKRfO75cSh1AbVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jb7T6g+a7jJR0+/+0RjYJYg1nRDwKC+EqcrbP++h/QraoRIQhetWUz3k2CiFiODJt
	 ZQtdJJISr0C+YHGXq6TOgGq/+y58aH+D3DsSHP12WVxMbvmbJ7NwtxPIaTFIErrsdS
	 d2nMTeMP0iEfFUuSTJN2g8w/pBVlz+M2XgRh7pttovOr2e7/WzIaG3EsUyj+0t6acA
	 xVA/n8So/OPdPHcNoA1XlYT97OH60glRJvTGIKfmvuWgIj/e+XOvPL8/YhS6SZ17IB
	 lwSJkj3+nQD+XAzFO2UiAkTF2DAZF+IzXrodsJ0nQmJWJsHtnlL5gBTd6mhvkMDnYX
	 ih0wlMgAC3Xjw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5794217E1305;
	Wed, 15 Oct 2025 17:30:46 +0200 (CEST)
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
Subject: [PATCH v4 09/13] drm/gem: Get rid of *_with_mnt helpers
Date: Wed, 15 Oct 2025 17:30:13 +0200
Message-ID: <20251015153018.43735-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA2B4A0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: i75g17bzxprxj774718fhzzem37dkss7
X-HE-Tag: 1760542248-736789
X-HE-Meta: U2FsdGVkX1+/Rlxd4SvRX9VMGqkNz8Nnei8CwygCjnZwMOai5u4mj78D4uCH4JqN87Z+RcgKMRbL8clwEc5mwhgnGjI8s0TZwAtvEdVZtoJNLy/CW34/qIo/JfrZbGqhd56cJRrV+jpOAzXapqNZevDgQJ2D17JVPDzswK43Avsx4YY908TbixGFO1d9s/326vOCh+XvwnR7QB0j6c16yr8vYB9Rj932GHWkJEwAotsvX0V88V1UjUyqteMrSMgrxy+4QfcnTY1l4U5YMty2+HTG+vDs9cooN7vLDSdhAUiMtamFHICPrV3Fjk2rZre0uiSzV8zC982fY+JCx9iQqVcI+Sg3Jz/ibdwdN19rQDg/NXsn3ZwQMhFqlNolU5J4SfYgUqLltjdDTjtgDuJEtGFlx9wkOYBnhemwrIwx13qlh+1tPRff5945XlBuEhjBNWRtaaMoMF6EUkOQYEBVVUynBA7gbNPstzh4W2z+siKdXvlq3Ouw/upTLlPeow+ZoOzin/N3+9EXHv8svO1D4P9PwjEkW5ubC+lW1b0HBZ9N0aqkeeLrJkt8eGx7jw7DhfeSDJTraGtDyU22ZHYODpnY+Aa5Hgueylnk6v/MinjRUH0tXdp3RpsuxCdfzJ9UO9If5xFVMM7pEz1UhJdfRFXuxbhfISIIJ44xsq6YcSNQc8b5s+KijBJtAAhT6BXslNH59FAZBOh+xoQgYxgbQhSGtFE0SQjMr8y7vJSht40p22Csjnr2F7Lsn2eqtfKbNGn8geGzqwvdr/OBw+TicjGK9dnB2zMJYlSqrqS1QPq9DPFuYOjOQo0dpOPH9HFgWH+feeOPVtL0F3GulkllMpHF/Aez3g2bvxXCE0t6C9LhVdf+O05TDNsLsRyV++TJi98qsloddkHDJmvYwEMOd/SSvpkr8vV0t+WiVl5agzxERqGzt4JTeQt7LMQG83Oe8wvBeIzu1dIP0xHielP
 WkkLxOOX
 Ep6BzPIXdB/vav4kudnJdoRM4FD9Bexs2GnyfT5r4uviPrKCl8msuN4ahYEyjXk/ycmCgb2MFkz/J7B19UwKX78G4jshEu0ucuIzvZQYUrKi24poSCM7TFEwkmQOoCgGaVAYipkv9N05ND7JkrCGcNX58bl41aaGZ5qWL5qLO7JJn/5n5DRAMYtJmo6FtLtS0eU9RM5DKnSDE1SVJRAby0ivxEiOsMlrPccJpqAd/JwqFHWDrTUk5rh4sWf8CUhyweoU8/vTy46OZgCvjJfVF1WuO8a+PAyGJvPpvpQeRANqiguVgymVQX8j0ue1WCqnh9YVCj85yhlzJ0Ka7qZaZXM60qIfWMWJdAhn21MMVzlZnHWIebEF0KX6STZ0p7D+DvwFqZdnsIfCA+va71Qgis/mztbH/jICkmJOfFEn+p3znEg6NOvA38ccxPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drm_gem_object_init_with_mnt() and drm_gem_shmem_create_with_mnt() can
be removed now that the drivers use drm_gem_huge_mnt_create().

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem.c              | 34 ++++++-----------------
 drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++--------------------
 drivers/gpu/drm/v3d/v3d_bo.c           |  3 +-
 include/drm/drm_gem.h                  |  3 --
 include/drm/drm_gem_shmem_helper.h     |  3 --
 5 files changed, 17 insertions(+), 64 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index db8c0a217add..d8fa789cf330 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -172,28 +172,26 @@ drm_gem_init(struct drm_device *dev)
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
+	if (dev->huge_mnt)
+		filp = shmem_file_setup_with_mnt(dev->huge_mnt,
+						 "drm mm object", size,
 						 VM_NORESERVE);
 	else
 		filp = shmem_file_setup("drm mm object", size, VM_NORESERVE);
@@ -205,22 +203,6 @@ int drm_gem_object_init_with_mnt(struct drm_device *dev,
 
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
index 5d11bea573fe..33f2ecc5f31f 100644
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
@@ -902,7 +880,7 @@ drm_gem_shmem_prime_import_sg_table(struct drm_device *dev,
 	size_t size = PAGE_ALIGN(attach->dmabuf->size);
 	struct drm_gem_shmem_object *shmem;
 
-	shmem = __drm_gem_shmem_create(dev, size, true, NULL);
+	shmem = __drm_gem_shmem_create(dev, size, true);
 	if (IS_ERR(shmem))
 		return ERR_CAST(shmem);
 
@@ -950,7 +928,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
 
 	size = PAGE_ALIGN(attach->dmabuf->size);
 
-	shmem = __drm_gem_shmem_create(dev, size, true, NULL);
+	shmem = __drm_gem_shmem_create(dev, size, true);
 	if (IS_ERR(shmem)) {
 		ret = PTR_ERR(shmem);
 		goto fail_detach;
diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
index 6b9909bfce82..ef9e9c15da3c 100644
--- a/drivers/gpu/drm/v3d/v3d_bo.c
+++ b/drivers/gpu/drm/v3d/v3d_bo.c
@@ -151,8 +151,7 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
 	struct v3d_bo *bo;
 	int ret;
 
-	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
-						  dev->huge_mnt);
+	shmem_obj = drm_gem_shmem_create(dev, unaligned_size);
 	if (IS_ERR(shmem_obj))
 		return ERR_CAST(shmem_obj);
 	bo = to_v3d_bo(&shmem_obj->base);
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 7285a62d9afc..42d9066b1785 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -497,9 +497,6 @@ void drm_gem_object_release(struct drm_gem_object *obj);
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


