Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F889CAC5B0
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714098E000F; Sat,  4 Oct 2025 05:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69BC58E000C; Sat,  4 Oct 2025 05:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53D4F8E000F; Sat,  4 Oct 2025 05:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37BCA8E000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:31:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F28EC1A0875
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:14 +0000 (UTC)
X-FDA: 83959913268.17.74ED22A
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2542C1C0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=CJeRx6Hr;
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLHO03HjuAP5fi3ODAZtTS7g7Rdn0ubYctsRomzgYkI=;
	b=iPo7Mq1HXmE7tvOh/Rl89YN6n96Zo74+WSAvQKD+uycOZ8ATokIc7XoUhTXyODNXlc5fWB
	41khX3L8dff09SKwRmRcaZ1y4IItHxpDrr0863u40OaoU9Vkdtx5F5g1q+MIW8CAFlQjaj
	nQeSnJZDJv9MBHw9Y6CvdjKI/EUTTEc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570273; a=rsa-sha256;
	cv=none;
	b=MSH/qY7biDUl/VkWIZ8sZetw8lvRfFgMJl+WMEUkYF+4Fz3fvQROQTek0IUAA8oNyAMq4U
	ce8+VnS64urQxDF6vwUrPbBfRKHJ80vTOQXHuXykCZyIP3/9v5ugz5y/TWvxWiQGjumQ5Y
	uB/DQRcLZ/Mk2tqUEehEZjRzmdZ/YlU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=CJeRx6Hr;
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759570271;
	bh=8TIIJbzuKSwt0TVqrcMYvvQ6V2YmHZ1Jw8AVO7VfzY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJeRx6HrcbEwJqZ1OjAhiC2078MEVlqSLulbyV9K83amp0QHUkaN80hZQhklszt21
	 2q9NIln5KKsrMEoKGPhuAcEvjW3q4XnQOtulX9YHtOSAPgL0HszJZ7jyqv2R6q66zg
	 uDaIDsCSe+6Ek+DVcEnnBbdwNpxMnt8CMgvYE/kPuETauFRHcXnkHmBmkoaWZ0K21Z
	 3MJAUHKTEEHDtCappuAiuI+rCdZud3k5miaoGS92Q8pZKR47xcEoGXBA+uU0xSdSao
	 HbOVEfEWocG6LKWoWY8MMbkBuXDAheaJQsvUCqxJqNAXNZOY0umMRSaCGudP0TGFrq
	 JHrUvu/15E9RQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 43D9917E0020;
	Sat,  4 Oct 2025 11:31:10 +0200 (CEST)
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
	Christopher Healy <healych@amazon.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH v3 06/10] drm/gem: Get rid of *_with_mnt helpers
Date: Sat,  4 Oct 2025 11:30:49 +0200
Message-ID: <20251004093054.21388-7-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251004093054.21388-1-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 17cdncoeit9aqh5pwbowhnuk7uzbt4pq
X-Rspamd-Queue-Id: 2542C1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759570272-365899
X-HE-Meta: U2FsdGVkX187628JPm1+2ZOSQvrot1GySOj+bp1pSAf/7LZiN4czHPxwCo3ajWeRKEoDv5pU6QBHgwtLdppixOg01aK4nPY1Kwug8HOa6eb19wrrUeJwirLZhTf8fMRcy4C/0JgjoUDkVRLJxvRRZ9RhEYJPXm2F175koYkh6PJbAQDDpimGnN6yMuxbqzHE6+d93qGev+TriJkRI3dOmLkjUh7KMJwSRmiuD0Sjl3JyhJbL//ElxaKeoDNb2uo05PJWN00ruvGU0LaWXxmRpYNH9Y8U9o695AnIUzNzrEs0+b33z/lN2X9wB2PncNgld1Y3CwbL60IjVBJ2l4gqYXKWkl+gPSF61KEIbjQuCCrrm7oxWkC5PTDaWegAcw+tMdYPsrk0CWpt7GuJ1ahityx7ceCfr9Xulg+GKpicnVO557pUKAlBxD1OWmfn1VwCRrxToo7w8bZSAUYXUsyjhqk89YDIVUPyg6O/W5noM6Ef2LU1IMKFFVG1N7vBjIUJ8crJbfIlLP7sFlO+cqs/fareH2nnUCt+perL8C6G+puQ44Z2bJCRz9lpt2YSllKyX5GAde47aRchVkMp+oRwj3CO/4heeP6CLAK9xURX6y0mz0sCZEqPp5r5rWlPOcP7c8jpVVJNCkIDb1F0KLXJbCSAO8yt68VQWoASLFtzSi6I6us80a/4kRUtDXT3jH80EEbai0zKefZI9cV/WzTOv60xGA2i5zfKowY/GTyGIwMLNYmaByxd0tf0XHQOpJ+xB52OgYJ5loNCbE6oAnmyM4QXwc+f9fvw9e/ttmnCo/146I0CTlkWSikzS468gzspaWbd6Yn0j9EDn6NZsFpdy7dZmrDPAB/ZtenMRGS4bLax8LKKIApIGt2C0EQuoa7pIR6qofwMcr5F2yLKuelLqrYwIYCE9PmeUl2VTNl4G1YvQ1JIP26PilL31w/7uWqeUz76jxEkYX4/AmYQ+gU
 WZxQc38Y
 LHG4iu3e8bz8KErj50znhIvru4RlO+nRoZqmKya9gz8isI/HexG7d2NLlv1scxe+ysfxmgnqnEfSsrVbxJBJ2hYobNOT3a/Pe7+SFwI8zRKGRq1ljX87hbvBHb8joErOxWf7rUuKgHlGRJYlAgtXVydMJjeC4KhTZpijcqqPV+aEYxbARVABC7eS7UcO49xr8du/Oec6SKkZOgEG99vkWd+5jQ4SbODRU5BfC3ze6jijU/vbqjyVRXLCDJO5bnnZhZDUgGw8QAJ7fijOCtS/v1haNodsUpXgAigU+E59/rwjutxSJBxal4QdO/XSLV9Dz6PlI3iZxLYzSycURp2L+duKSGrdcBBgS7vM8pbNirWVuXOvcwnjr1yEtGpUtFDiRQ6QEp4KIX+Gn3vbrlTEltNmqXZHjDKnmntcQ6X0a/ZMMMJ9jFyblOrdDbg==
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
---
 drivers/gpu/drm/drm_gem.c              | 34 ++++++-----------------
 drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++--------------------
 drivers/gpu/drm/v3d/v3d_bo.c           |  3 +-
 include/drm/drm_gem.h                  |  3 --
 include/drm/drm_gem_shmem_helper.h     |  3 --
 5 files changed, 17 insertions(+), 64 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index b4e4947210ef..a29f57943b93 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -181,28 +181,26 @@ drm_gem_init(struct drm_device *dev)
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
@@ -214,22 +212,6 @@ int drm_gem_object_init_with_mnt(struct drm_device *dev,
 
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
index 22c4b09e10a3..5c1c1e8040b4 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -49,7 +49,7 @@ static const struct drm_gem_object_funcs drm_gem_shmem_funcs = {
 };
 
 static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_object *shmem,
-				size_t size, bool private, struct vfsmount *gemfs)
+				size_t size, bool private)
 {
 	struct drm_gem_object *obj = &shmem->base;
 	int ret = 0;
@@ -61,7 +61,7 @@ static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obj
 		drm_gem_private_object_init(dev, obj, size);
 		shmem->map_wc = false; /* dma-buf mappings use always writecombine */
 	} else {
-		ret = drm_gem_object_init_with_mnt(dev, obj, size, gemfs);
+		ret = drm_gem_object_init(dev, obj, size);
 	}
 	if (ret) {
 		drm_gem_private_object_fini(obj);
@@ -102,13 +102,12 @@ static int __drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_obj
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
@@ -128,7 +127,7 @@ __drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private,
 		obj = &shmem->base;
 	}
 
-	ret = __drm_gem_shmem_init(dev, shmem, size, private, gemfs);
+	ret = __drm_gem_shmem_init(dev, shmem, size, private);
 	if (ret) {
 		kfree(obj);
 		return ERR_PTR(ret);
@@ -149,31 +148,10 @@ __drm_gem_shmem_create(struct drm_device *dev, size_t size, bool private,
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
@@ -878,7 +856,7 @@ drm_gem_shmem_prime_import_sg_table(struct drm_device *dev,
 	size_t size = PAGE_ALIGN(attach->dmabuf->size);
 	struct drm_gem_shmem_object *shmem;
 
-	shmem = __drm_gem_shmem_create(dev, size, true, NULL);
+	shmem = __drm_gem_shmem_create(dev, size, true);
 	if (IS_ERR(shmem))
 		return ERR_CAST(shmem);
 
@@ -926,7 +904,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
 
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


