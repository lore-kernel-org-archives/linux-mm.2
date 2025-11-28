Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 753FAD116F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 18:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E5D6B009B; Fri, 28 Nov 2025 13:53:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C0B56B0099; Fri, 28 Nov 2025 13:53:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A906B0098; Fri, 28 Nov 2025 13:53:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6E7A6B0095
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:53:06 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9752650B8B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:06 +0000 (UTC)
X-FDA: 84160913172.26.88A167F
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id C79564000F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Djlm9gP5;
	spf=pass (imf07.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764355985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xvnnBb3AOM3mpd5iATj+hmFPpp/QYFpJzO3/JaZogg=;
	b=QebL6ymKSvBA9LVFT7jsoEcdaiVY3e1m8GjNo+mbwv4uyHGTibNDfU8yhm9VfmoIQvjIIL
	AySPP5ic2h5RqJspyEZkDEaOGqZC7652HXnXAsQ879ruN0ghlmgbEzd6sxA39wJo7X2xD/
	bCQCdS6PjFTLJWLxLqw7xc3X2Mtlkj8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Djlm9gP5;
	spf=pass (imf07.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764355985; a=rsa-sha256;
	cv=none;
	b=hVdiujD+JdkbqWFHU0mPwzmRi21H3XTQeWCCiZPe315qCfphelWWDNliJMMwALRWDNgvpo
	YMVBYI4NuDu22OK0Csqo7U2202h0W4hOr5t/f51cis4XOwh0VK2eG10BFflx8vxZdLaLlT
	6asvVW94xqAt8DrC+Q4cV7Z7sAiaBCc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764355982;
	bh=aqgHWs6PVS5pm9CGbwvq8LKKb1IeG9wPYVrDgsd8LGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Djlm9gP5gwSN3e5Qbd3i9uXdUgiueEKh06U1/3VfYYjv9DvQwoxp9V84AknIzzPj6
	 iJMeOk54qFrzczYZW8L/PNUjKxWF97Cmw0FM1T31OPwmJ1RwpcfqZBrnYxbEEoMHUl
	 0trAcnf5L+HwSi5Cbogn/xzjPLYmUKt1cccuQNggG54V4KgAh5AuOTHPn33vc9zh3G
	 YY7MrecX9mQmy17uzy2dUCDJAtdUTTvlt/Wjwk2dugdDf01srS1VgqX49ke+rfAAG6
	 niQ8qOVqIvc3dfKDP6DhS2Je5kA6OCKBcPtlfAVnTYDVFcGGaPsFMmkHJchVXZKwKX
	 cJl061qgeogNg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 07E9B17E12C5;
	Fri, 28 Nov 2025 19:53:02 +0100 (CET)
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
Subject: [PATCH v10 07/10] drm/gem: Get rid of *_with_mnt helpers
Date: Fri, 28 Nov 2025 19:52:49 +0100
Message-ID: <20251128185252.3092-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128185252.3092-1-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C79564000F
X-Rspamd-Server: rspam02
X-Stat-Signature: k6pzfem167xo547dgwrax9py658bch7b
X-Rspam-User: 
X-HE-Tag: 1764355984-231587
X-HE-Meta: U2FsdGVkX1/N8hkUWvNr1VcpwCdGqccQ7XpeK6IJ4YQkPAXO+nFAj/Q/mN7qTLjjXKmSRfTy335IddXHnUYIJXAfc6+jaJmNW7V5SY3ADdJOwuArsbVWWsTZmM1PQ3/uIkVuIvYo86G/nt1bmGbpd+qlMjWqTh7wt0VYeyj4rUCF9F3Alje3xmk08W/k7OGAxOwMQ0ER9Fmmpqu7tOw1pBgZeaOpSJkTgnqy5qjRn8BJqRtPtpYejECArAocjqJdNnqTrXWB5LY/vyVWtNTwSlqzkHby8VSHz3BcxRIQKN5Zz+/+pMtKnGZqKOuDe9Pvj1LXgs5wv9bJyducRebAqA6Ma8WDeGffH6D1L+VGbuPLqeJU/+BdsBuGXjSwsMGwV8kU5Dqhrwun0wFYHFlp8ozOyVcHGdFSheJNDqhZlR37E48nT2O5nMXHALiV8L7SzteBoGRXmrfO8caRrRFmDiCpwxF+t3sLUYVtNblBGIOniGA4r6Sfz9ULRWJlRbQf6o7/vH7Ef6rquLdhiv7k6J7bt0uTpmki1D7Zo2xVwLI/vyZo92AlXDk5R9wmgIOM0IaDMxv+r/TYum0ZW9a04pBjVzS2ezPXDovjSm7AZdpYb5XVWp/pP1MmmWnzunNo+M444nPdDAtxpTVu0fPaFa+YsLePTmDYE91KrlWC4DG6cUxHvDxZtZHnKccHZWwuJmjfL93AOuv1+KaWIcrjOVSLhlxWxx3xuknDsOOSJTn9O99ROVgzfuXgz3y/XAVwBolr+WSCvQb3TYhiwtMXI6Rs5tFXr5/P2WQCaOBMtGFBI80IcfgpHAfTquUrSmBuHaPYmGPsM929Oz5gpXbN7CRYIdt4ULi3mUxSDJtfziIBPDoRIad3C2qTAkUxzToDRTCOwCpDG0jNdVMpRR/6Qb0VLBS7bq+V4AcBV1Mko4NyT3EPAjkE8bXkGc+Fcl3i8jC2xcjAoYOK8mkwTyc
 MbePHOBk
 yOuIAtANEhFI/Ez5hBhHoV1Wv/OwLWXMvlcSq8MNhrFKL+Q83ZzSaHGvRjzGHfDiC9lkchXvSZF6XXCt7aiR02u4IuGsiaM2NY8lJ1y4aQWV90r4NuoaCUawRIS1Bhar56XdhTFU0O95iV9TXJUiY/80lP2vL+3g4LAUmglYpzXQvh4cZjnfTZmWH6fPMC74mwG/xmOglnthrPG+d+d7KlPfZl7kcs2WPifqsC3g42GZq3DF6hsCdBLb3OuwJF6lWghj69aSi1aiqjDi2iXENN7zOSs3Sd7YeBoUo+tyXSype6zxhGi7KMTNAhsUGnu2r/NJwD9fELNjO4cKBa8P5s7RzCY519+REfvIoU5Ya1wX8KTYjWeSoYvZar7CNCSR116bKrx2aPyLbI+abSvYFzrXj5GABe3p3p7K2JrNyTx/MZle1gT0XT7Y+Zw==
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
index 94e5e04865ba..a7c79f640e7b 100644
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
index 4e9ab5d294ac..3ecab9cf625f 100644
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


