Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A666D339B5
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:22:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D916B01FE; Fri,  5 Dec 2025 13:22:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF546B0200; Fri,  5 Dec 2025 13:22:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478026B01FF; Fri,  5 Dec 2025 13:22:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13A1D6B01FA
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:22:46 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C224D1333E1
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:45 +0000 (UTC)
X-FDA: 84186238290.09.6655CC1
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id DC9C616000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=RU9b1orK;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764958964; a=rsa-sha256;
	cv=none;
	b=tK4ouX/MNTA2ilJipa8hB9Q8y6In6w2Ku2sUdgdPqNyUP1Aw2O4j1qJnU9qkWsftai95AH
	J8fWXnnX8wcoQ0O0NGuRFjClewbYSy8Ji97yxD7pI+RBXIXmkJP/tgWXLh3wAD9JCHPBkq
	jBeDJZ/aor2LtudMcVELWTuDdabwtlg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=RU9b1orK;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764958964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcSNriewcQDmmBldCd/jiHHnFc9Kvl5s7FpRX2Ozqrw=;
	b=e+Noc4EISdma8+BIFuO4MMvQcHHyQLQXvtzPPa6KlkEyxFSucfVIa1Gu65xuR2fmaCJ4Pr
	cY1Qk3+Twn6ON2FM5oWshAmaB1ZQUKdFWJQE9BAtAcDlQs1kk+of5EysC2Qu/fODxmrwsO
	VwHInHBTTguUhsgf9bNNN2Q1nflAxgY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764958962;
	bh=Zex2NKxNRl6ia1F7pINdtc/8BVAWXVoWCqYCGqXTtRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RU9b1orKw6VLNF1FvLlFW8JWljtnKqaP55aQbFkiuzNJsZujAvuyigWonlROZ1+pU
	 TPOphJ/7me2CarF3eEPwIAjR+SGQKSchrRoS/PQGhGsMaHF4UJddbB0+Y4d3lV+J42
	 XEF6ZOj0aUAz99AkccN/jls5QZhk85MOJMsdhYwsHKCDu1AeXuqW+8Zx3L6WpYGNxs
	 IDvGMMn3LktkLbZCJaQptvSfn80BT4cikoPxwK68s5euL9BTEOX5fguVCuI7emeIJx
	 3lTLlugGoClowlyeNr1A7JrXXF5cI9hlsiG4Ve9ReaEKjU0RbmPQ9+EJ7MiWqh7XBY
	 DRp35gZBOUHPA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1B8A317E1155;
	Fri,  5 Dec 2025 19:22:41 +0100 (CET)
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
Subject: [PATCH v13 07/10] drm/gem: Get rid of *_with_mnt helpers
Date: Fri,  5 Dec 2025 19:22:28 +0100
Message-ID: <20251205182231.194072-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205182231.194072-1-loic.molinari@collabora.com>
References: <20251205182231.194072-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC9C616000A
X-Stat-Signature: xtex5kj1dq1t7zcnycetoi7z5behws3y
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1764958963-369245
X-HE-Meta: U2FsdGVkX1+YN9Wv8hVXoGQJ3gRKwrVadvoyD7kfshLDZyyynpQfmoVDagHGwG26vulat6OdKOgxoIQ0IlnfcdPJNphcdks88v0f3r1t8ovawtlFnvBA232d5yrZTXMW0PBY4NI+L3f1M9k4XBwEKz9YcAjSjoBstkV5udGudMFhJ2pUUQUlUUA8x0Etk3nTFWe6PoaCjF9PamvDWKtwBLNc12fU7KK0EbnvEbHuKgkTXOSf069cjUsoOsYJvdgUVfYSqEMIRYnkN9WxuvudQKvGyYIPRIbvZqTYS79adyRcvXVSL4FEaHvfavGiJJTM9/PyEWIyM0Z3707R49Nx7zzNmaVsSXiDv448Fp34DvxL9h8Ior6lBSh99D6Df2B/9lPcj6SVWtCs6RxXdTGdlMTeqjxEQykE4yiAahjNOVbKyQpvhVhNWTkMS7bj49NGQ9q4Dns/KMqIx7Gc4v82R7ra4zncMQhAVDGrhT7UKVhvKhEXGuskGQPEoR+kzHLn6LCYlcQAxQ9VYB7kHLUSUONYBWGihdaVResEGtM59FpwPSt+pp8FdRw0EBGZNr3kg+6dH6u022T2bVl8hH7pJA4S4hfhmp0gs4Auwzh6mSPM+NflAZuuzKQ8QNfnWumYgoKArGYyTOpKI73mx/5Q60lxr4gwtioM6biSbXA+IwSZJ8Z//JU8RBDnnNM4N4cNxmHCBL1veavEq/2jCT6w14c3aTSUA47UH/wLsOxz43GRCW5pmgN4p8hY1u+HTdkF+7hE2j6CiBJsWYi6WSBhNq1HfWGyGIsLnC1+hrmP4y/teEYVkDuDtZTrEeqDXZ9xRqKnKdoH4y69lSEpAIABupe5KOVDTcVwELfLtDg0fbWmK/aaJGcBF8nwZpHOetkrJLzYkb99LKeWbzSL0vMwA778fiGNrIjzVR3rg+2YuoBcsTtgc726egaY7TFtmF7PxzHBsxwuM4eWpg8bHYn
 g2Ag/J9b
 DnGj5d/vl8hCgVYG0WQE2knrTPwVh9QMLGMO5zmgI1j8Xmju1+T+xfj0MuoE22emeLPxNZ14/hp1DDJk/tF9wohBAYluwuPG7PPwixjul6qAMJPsIOcYGOFc0UUkU4sqKmqNsedwgd7uroDK0jXG0ISZifHsBepsdzySrkoOkJaUEDTfdtapDd2RkjC2f6tdUIF+4zHi5wI2Ed+/zHMGPfr7aeVGjS/2AhIyASl8Ju5CKYC8r5sYufC7hZ07QnXM8swRH2xzbFlPkBqbKIYWCv2LBRZR8b2deXgIGPpy9HXGNlrPH0FdUcCjt92Z3U+yyY787H2GJR0MIIxOBcjSj+HT8bWOSEfxYVZroFFNHtgxw+uFI2E3Hh97OB9fTkz06t4dgKG+Sbm/72ctaJIevLO3uqMHNy0JbsHEwSAbygvjG30whtjh3Nv3AnA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drm_gem_object_init_with_mnt() and drm_gem_shmem_create_with_mnt() can
be removed now that the drivers use the new drm_gem_huge_mnt_create()
and drm_gem_get_huge_mnt() helpers.

v5:
- use drm_gem_has_huge_mnt() helper
- compile out shmem_file_setup_with_mnt() call in builds with
  CONFIG_TRANSPARENT_HUGEPAGE=n

v9:
- replace drm_gem_has_huge_mnt() with drm_gem_get_huge_mnt()

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem.c              | 37 +++++++------------------
 drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++--------------------
 drivers/gpu/drm/v3d/v3d_bo.c           |  3 +-
 include/drm/drm_gem.h                  |  3 --
 include/drm/drm_gem_shmem_helper.h     |  3 --
 5 files changed, 19 insertions(+), 65 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 32dddb23e211..6021c4087a08 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -171,29 +171,28 @@ drm_gem_init(struct drm_device *dev)
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
+	struct vfsmount *huge_mnt;
 	struct file *filp;
 
 	drm_gem_private_object_init(dev, obj, size);
 
-	if (gemfs)
-		filp = shmem_file_setup_with_mnt(gemfs, "drm mm object", size,
-						 VM_NORESERVE);
+	huge_mnt = drm_gem_get_huge_mnt(dev);
+	if (huge_mnt)
+		filp = shmem_file_setup_with_mnt(huge_mnt, "drm mm object",
+						 size, VM_NORESERVE);
 	else
 		filp = shmem_file_setup("drm mm object", size, VM_NORESERVE);
 
@@ -204,22 +203,6 @@ int drm_gem_object_init_with_mnt(struct drm_device *dev,
 
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
index e67216cbb469..f8bcd1b0eb32 100644
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
@@ -851,7 +829,7 @@ drm_gem_shmem_prime_import_sg_table(struct drm_device *dev,
 	size_t size = PAGE_ALIGN(attach->dmabuf->size);
 	struct drm_gem_shmem_object *shmem;
 
-	shmem = __drm_gem_shmem_create(dev, size, true, NULL);
+	shmem = __drm_gem_shmem_create(dev, size, true);
 	if (IS_ERR(shmem))
 		return ERR_CAST(shmem);
 
@@ -899,7 +877,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
 
 	size = PAGE_ALIGN(attach->dmabuf->size);
 
-	shmem = __drm_gem_shmem_create(dev, size, true, NULL);
+	shmem = __drm_gem_shmem_create(dev, size, true);
 	if (IS_ERR(shmem)) {
 		ret = PTR_ERR(shmem);
 		goto fail_detach;
diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
index 3ee8d9c36d92..c4316b768b3d 100644
--- a/drivers/gpu/drm/v3d/v3d_bo.c
+++ b/drivers/gpu/drm/v3d/v3d_bo.c
@@ -153,8 +153,7 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
 	struct v3d_bo *bo;
 	int ret;
 
-	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
-						  drm_gem_get_huge_mnt(dev));
+	shmem_obj = drm_gem_shmem_create(dev, unaligned_size);
 	if (IS_ERR(shmem_obj))
 		return ERR_CAST(shmem_obj);
 	bo = to_v3d_bo(&shmem_obj->base);
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 97b5fca8966d..cca815dc87f3 100644
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


