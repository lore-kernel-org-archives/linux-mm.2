Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A7FCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EC1A8E002E; Mon, 10 Nov 2025 10:50:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E678E0031; Mon, 10 Nov 2025 10:50:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63E2D8E0030; Mon, 10 Nov 2025 10:50:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 502BA8E002E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05747B6347
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:18 +0000 (UTC)
X-FDA: 84095134116.02.2A7DB22
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf18.hostedemail.com (Postfix) with ESMTP id 272C31C0007
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=CIq9sCHS;
	spf=pass (imf18.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pZOds7tpusA+b/Ook9StS7Ouw5pnS1Efs3gklD4TFY=;
	b=qoxO9kv7wthlclwXlrNyCrIXxWMEdxJv0gN6CJ9ToN5FIwBdTINYuQU23sKdMVuie4XyVH
	tDdZ81/sQp6h3KDbxsqn3cYgnej3cojFwzXELlV6MU/jsR0FJY/lPHcMMOi29vs5B+fBOq
	S0XWLUhfkhtNiM0PRI6/nMSL9ImKT8Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789816; a=rsa-sha256;
	cv=none;
	b=oA99P+fPGbd/I7kF1Bx4EQBgJJU4Kvm52iCGKhP85rEecyxkNN05PjgxNuKWA1Tvmxo5mk
	jADqTwncHtWF9ZxtnEW+0X0ipTknsIqM+GFKdZRpSRBoRnpdQoiVUq3Omj4K6G7yge8vnZ
	+6xHtvUH6AV+Nk4gIX2SH1m2TMOAN/Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=CIq9sCHS;
	spf=pass (imf18.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789814;
	bh=ugVN9niHboQAeoyIjFlIBMlC9NQMf9A8jgepRqHKC8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CIq9sCHS5qZCMCITH8OUa8Oyuks/HVhDE5EOcXQ9vYc2IZidPl3+q5eRZMeWDCRqU
	 SmLrqUF0QnL6mzwgiICKSqzKLRe8Q5kSz4KtlpS6VzZJSCBMduYvUukrnTs8zcjwMC
	 rCz8MVE/7bqEkc1CB8RPSi3gTavYHKrreD42tGwYk88z3T5PWeMOlR5P2KlwzOydJh
	 SbmZ9oSJGOtgJRAqG3a8EB9zxrDIzwBzl/sRKBhkeHgLy6wgR4hnmyX8PUOw7P58jO
	 uxXNMTlTymf4Oldan+HFV03Z9ROjikap8328Kosrwg811CJw2qvD1xhNQdPhK6UJUE
	 dwc63jSSpvjag==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2886817E0610;
	Mon, 10 Nov 2025 16:50:13 +0100 (CET)
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
Subject: [PATCH v7 07/11] drm/gem: Get rid of *_with_mnt helpers
Date: Mon, 10 Nov 2025 16:49:55 +0100
Message-ID: <20251110155000.2936-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110155000.2936-1-loic.molinari@collabora.com>
References: <20251110155000.2936-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 272C31C0007
X-Stat-Signature: mdoz36h8fozrxkax985jrnufkdgcumsg
X-Rspam-User: 
X-HE-Tag: 1762789815-255724
X-HE-Meta: U2FsdGVkX1/p79OSWgPq9Rh9v3P7aiGSjSU74J5eCskNtGJfrLRgSBaPK+noulFr5mRKab6rxEtFMqefSdm+O9FShv0e4h5H8zNsuLg5BNfDlzuNZKFLbaLmqD2mrTXAXovEjC7eWlbFWqpKHi5fe0238xyTqZHwaFurA9UDcSwOwRvhNzYATpadqjDJ3Xr7FGem/UFWPacwqcQ6i9Oal1ifjlkyISIsTrCTab1XSpg+sJXeti6lNh07vmhH41Q5w5rt5kjba2OE5iYarRtNJpRSzK2eUedwg9PuyL0iM4fbclFaQ+aZEuiEKiJ+wVJxsuQQuMB+NUqM42/1OAT0XJfVES9gsWMfBV2CtI/40giWskopPVMgd+i1Fmke3ddGrzM5srM2nkGDjOtJGpHmlbwHaEnTm2T+nkFgZ0mOlv+ioYFjd1obImxTfdXUwpsKdSugduujidCflPdmmsmwN96bpsHrcH9uvweKRU/Kd0BtGmiHyzEuAorAeICHEV9U4RaYIFqFyIgSRRS77km77AjTnGT7dyuFrfPR2vsVDDaOuyMeq7tBZ67X5+64wjc1Y7Il/ybux4W8uf2MxfjnwtmZ/itZbf0LOjr/peml3MQYyT23gxSYE4Ls1lR6yZsWlViDKV5pKFUR4kf97QRqPrchGn88kYV/3HuUlWQyPzROCSDumU0/CqhgxwPXQF+NtdkdTDoiv3CgCpWsE4xuCS/74mTF3ObQsnDhmTfznH9gtLLNgCKHbxoYedo68bXYtX6TL5iaM1pS6YJHGqnB7rSn2gaRQSriQKtOOUC1Ch3GFDPkfdvaPjuqeIXvaQ+t6ihZb/vFg4LMes1yurB4tWgfVmmhmMQV9Wz5NjR4YikZ20ex/bdobl4IUpYHoMyJvN0kyP5llqpl3ugteuCDh733nTR/wq5IXKegW0xE8i2trDdnflqkyDNYrTP3W+eiqu1YqNgjKWmZXWrlBeq
 /0Zuloz4
 koxBNYmF56/e4FzZhlvkRjYdfRZvj9uLV4vGTiyGqRYgfjI73JX/emE3A6TDMoozpn7Bx1rk/bEXeDoe6dJebQmT4qAFRUT4246KaZkZLt79hEKMUNlvgYhdfD605EFLSQcriws2ir4JYmvu1n6wdJO5lKhY5XjcYNUsj7k/JR2gB3IvlSxWwMkOUC+DGn+cmkLQjxGaf6axa4qu4js/Bw97YfL+8fQJ7YhT9aq9OKSbW5i5pq0KovAM+bW+qHqBDRhb5I3RRz6nVL5o+sBQDWODlPc1wg05vMMmxweo3F0K84mhqSh+I4X1DN1CHcChgsyutxyLe2TkHDQILXg1Aq5esa0VSjvWagQJWb+fXVTI7YcKnKSk+l21neNffs2sH3CkyXWGICjbq6r1rR+kSLQErUYzH06YAcE1WMKSPnu457GbIGMH4hfnPPxc721yo1nsH9WpWIHHNoOPWcNkWrh6CLpiArX3pIGCPHwO2tAqtHJKrQgdCZuZ3CYgJz8Pjjg/q8bjnYzrJPAzl8nsTC0Q2cz6QHEMXv/XQ+5FsFHnthpsaC8Q12sIvWQ==
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
 drivers/gpu/drm/v3d/v3d_bo.c           |  3 +-
 include/drm/drm_gem.h                  |  3 --
 include/drm/drm_gem_shmem_helper.h     |  3 --
 5 files changed, 21 insertions(+), 64 deletions(-)

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
index 99c6a775d18b..d3b68ee05dbb 100644
--- a/drivers/gpu/drm/v3d/v3d_bo.c
+++ b/drivers/gpu/drm/v3d/v3d_bo.c
@@ -153,8 +153,7 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
 	struct v3d_bo *bo;
 	int ret;
 
-	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
-						  dev->huge_mnt);
+	shmem_obj = drm_gem_shmem_create(dev, unaligned_size);
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


