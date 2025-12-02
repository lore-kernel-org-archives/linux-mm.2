Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F4DAD11701
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0346B002A; Tue,  2 Dec 2025 05:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291F96B002F; Tue,  2 Dec 2025 05:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A2D6B002B; Tue,  2 Dec 2025 05:17:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA4946B0026
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:17:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 647EC13B45B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:34 +0000 (UTC)
X-FDA: 84174129228.20.76975F4
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8DCF640003
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="m0C/zvjv";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf01.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764670652; a=rsa-sha256;
	cv=none;
	b=CeYF3YwtKkktI7IP/s4msAqeB1Z/uyPAvQg1uf1L7329QK9QGpXEDOkDxWwrZBQRnM+n17
	NU9xCcivQYDqdUu94shnqipKawLBxCKgXlNchjFQoS+ZAXazLzdoD6rHGENVEj3oEnAiLT
	HO27q73ZVfypO6vgnafLN++2KX5cb0s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="m0C/zvjv";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf01.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764670652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OV/jFWju34GVrqmImUMUd4mjYgk9s6PCcPPR4wpNou4=;
	b=InjCtQ0W4z5b2/GovjuIpXPL8OvKy3Uk7q4ryF8NoWTPxiJq/b7F5v6KWTslRuRRZmOWJ6
	LSQidrENO5oMadPV192zjPkRJeZujbvGapAR6MGWUrh5fcGHhGvWu69lBdYO+mLJyYpd//
	Ju+NsOqebvr9bfmWUGJv3Rkut40qKAc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764670651;
	bh=ZVHBcgpSZ5GrsfYIumMKkK5Gz3mPEwYno3lSFbtUuuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0C/zvjvt1SWVUb3BI2j+Y1hYqAzQU4CXZJK6V4bgSf9nBqoo7tf7kXVsuy9PBD0C
	 fBhFgRAfrkcBJKjziTV111ztf8eOBpC1He8j4Ii9sxNUKHAF4QY9yOBzKbKu6dPQUf
	 zqjcBqtRokBS5rVNuvkAw7gHE7y4TJs9XV85cfh+nC3BVajlZgD9Mro5Tqzxtd45fu
	 qc50b5Xh44DUA+C2zZAi1NqCJqKNfRU8VCQcBUF0xc8sO5mLbLr6VxgCAKq8eqsf3C
	 fMeyiG+J1KmYXIx26n2sXbW3H5kqoV0vf4dbKGrjC41hr+ZuQYPrzVoe7q6urXkSYw
	 41XykPO24FBpQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2884217E114C;
	Tue,  2 Dec 2025 11:17:30 +0100 (CET)
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
Subject: [PATCH v11 07/10] drm/gem: Get rid of *_with_mnt helpers
Date: Tue,  2 Dec 2025 11:17:17 +0100
Message-ID: <20251202101720.3129-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251202101720.3129-1-loic.molinari@collabora.com>
References: <20251202101720.3129-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8DCF640003
X-Stat-Signature: qubk7bj5gs1mpa8arpa178qwgc6oyx37
X-Rspam-User: 
X-HE-Tag: 1764670652-768187
X-HE-Meta: U2FsdGVkX18y39sIo5XF034LuuJfrcxZQmWKbkeFKBUobiqNimLwWZMCjgXzP0bVNpeM7gJ/5csu6mk0aJogT71Mlp3GVeAiu/KK/56MnYh5gN1y4Ma8Y1kW0CtrB2ZAi4MkYkw216luaFeXw6eYyQxzjOJVw80hlv2zjZPBqqeRkpPHOPB9KSESUmsGAYrIl4hf4Y1oNQUsAgAsfcnuH77UkR2G693svKHb0mP68TgrJ/a++2wUobvALhtMS1aH6CnQDA5m2avAP8d2owwZgCyTJvYvOud6sxBEHjIs+PDRn8TbL261rsotKnoYld+ZEOZ5SaKFowTrV5jKhtPNqDyOSXqjs4ZF6u+9QmiCVFk++VzP6FbM/YQSKwX5Xi37aIT3oTFtw+IpxbSnuCOPDQcTVLCZ8Hk0wytnyz7zI+gWbtE42gs9xuVgrQb6XLmxFIDnIlmHNM8C0IdI7SmTIwRCFm7Geadkh6EayuzhORj+/GL4Kk/9mzKcwt8VmRhpFNfdgM6nKigLJxfjBWGynicfael13nk/TZMARLlFsZgknURDfA6wfJql0VVpFCdzFqST9q8Z9OrsuL21dqhSOiCXOy8/CfVpPqcYNpc9ImlQJapkrIyXhd7bScxiSDPfzUSNn9XwTvy3gRxh7yCpP9eXe53FuPcuVxSbyVGG5F1UPlZAaO+v73G7ZlvK7D8ZxpeqkeF8Lm3khuEkwJ3lLrEOJovLUwbIcSqE+caRvmmn7th0hNG0wb99YL30iNXDxaB3kZ+d9rSEbtTZl05BkJBa+X4YzPfT9QggZaYOUOXALHtYuk1DRM3VPGDSgsUr23I7i+LS1jM4a9T77rb2IKdE0gHx9ViqAaBOw237SfVYrPHZFbzu2iJ1HRbGZyYEomt017g9aNWUN4e66yugUBH0pb3+7i/81jcqL6ECKAoN8KJxrH4kFpiJTYVmbkYUOK+DzbsVk6Q98NwhyPc
 WEDZeimI
 Hd94xfTG3V7f8lFWpZ1LDqD7wA+s+FVJPrvksZvGQbqdyY+CUZBeet6DgFvLHxWP6aykahPvy2shYFXOzz2BpkmP15Wkbnf6bv5J0Y1AHPRjqXc/7mcL4oXxxVGpoXdv5J4JIaVND3h48XHgOTHoGP1uPbpeoMz/Q9+7DNHsjn9obLqC5QLokJZXOjQZiANPQfC8idedwvWscMAiaKvnpJIvFqdbIR/1xD/CZQg0EVqOaNTmvLC85DS5pxigFC1qk14UXYJ9rOEGM9FF3LmqqaJHFae14lZNpVTM8F9zJncuhzxsBP5rlJ9gyKL76LAyFH6c99dgiX5NQrs+6hmaOwhJofOcoG/8M8sEl3ttVDjszv7QNpXrljxcMbivs63e6XJ6s7R1+bMNmAATzKtBGc2cnVDBMSwFlu6FAXbTBBytjdjXRz3PWBkwhYhpOsQk+MVSRDYenQLGd/WV0CodzVO65+MeHwUGIQbiadwWub+3rwUw51WpT2DgboTO9/ibRnwrb5Jq287ep3ywZlx0S6b0BzfoHRmpb7jewzEmUR3H+FO4=
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
index 4e2e58d92b36..b00182ffdfaf 100644
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


