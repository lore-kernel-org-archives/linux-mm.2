Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56C34CE8D55
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44BF18E0005; Fri, 14 Nov 2025 12:03:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FBFC8E0034; Fri, 14 Nov 2025 12:03:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1938E0005; Fri, 14 Nov 2025 12:03:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13A6B8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BD6AC12D50F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:17 +0000 (UTC)
X-FDA: 84109833234.12.860DE30
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id D5D2710001C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fjww1ngV;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dNKVGfjF5wfnO+bvRcm9xr3njdxDoUyMNImzhhe3/GI=;
	b=HI9OtA9KegzwR4SQw+AIEd9bbESbLjmgV/bck2UQX3BmMiVsOFEM6gXk0sLYWGn0xqaPtZ
	YKwwz5yipGct+CXdk4q2qPnvT2TsqPONBE74cyYbiWyaRpT/1MLCEC60R0i4u9ryEXtBDx
	rGDmVriUDa+hpTBS7kepHIDMxgOv474=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fjww1ngV;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139796; a=rsa-sha256;
	cv=none;
	b=Stbn2er9DRerdHeTdJLvJUMVfmDFIrqYd8sGT1f3H75mUwU+2PPDh7NOEcVAgmHZJ9onPF
	cW2FE0uQy7++bslF49G+heo9pclXuTXweGQqP804JL2mL+HxFeK9D1H13/HzxgTTxc93SG
	UScs9qYygmsC+cOtZUTnU2ygW1uvZIo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139794;
	bh=tceZn14ER4C81qNdHRIGzn7yq68toDNgICpCmQahyEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fjww1ngVtT6MDrxaH2rx2EVKsIyoUkbEkVh+LPECVqba7ZdYjvn1I1Wq0Y4V35Nqk
	 mMIc8/73bQZlAQjVm+zKCuT5w1MVHL3i96vqXMyIdDkoGK/bDRZ8kv+L/pQnsMLQNN
	 Xex7Nh/XXPpvJBuvo+G9TXJIsUZ3fFN8ksK2VpmJxQRubMXhLHoTNocsQKAcrxfrZW
	 wOTRIxugF6XdDTdJWUU2FdkkEeLTdwvY/VFfeuevxK2zrzKqpTS05wnneygj9ZVeMb
	 XxtLTS7WtxC6RUj6FSpfOh+IftjLaoaP2tWXdbvubGJnhH2lgwkf6Rt8DE3Xr5qMvg
	 sy+4cskBC5lIw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 924FA17E15AB;
	Fri, 14 Nov 2025 18:03:13 +0100 (CET)
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
Subject: [PATCH v9 07/11] drm/gem: Get rid of *_with_mnt helpers
Date: Fri, 14 Nov 2025 18:02:58 +0100
Message-ID: <20251114170303.2800-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114170303.2800-1-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5D2710001C
X-Stat-Signature: fdhr3hpcracxdi8wp939adpxqx3zq7dk
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763139795-553137
X-HE-Meta: U2FsdGVkX18qy9bLn9CIwGfPKoCz7NqecMBcLLd6gJAgIybFIA0C2gEZ+gxcwGAS38UScdCwqeUjAbHBn69u3eDsHKgccVSOADP5CggLikeO4uQPu/7RByMLnX2GpB/dgTjM8HWeDCyfKGvf5h8f4ldivIUoWY6VGAt+WsoZtlq3otiRtmAgjVhg8pcQb2CqBZMSyJlMeffONSWUriZthGitgKPlCtzcXMXLV/S3WcyL5YHOprfeTRgSnRW+u8jGJ6emRwSIQiVnj9QpWOh+ovcKwTQIR6pnJM56zikC84tz7bgoMyx8GpGKXQE0CP/cXYaDGx6mQ7drtOW7Ea2gLLhsxtpACynq085L30hso9jQuh4WhymL2a9mqy9hpGWIg+z3cbSXzwWuk536IBMRCp32Lsq2a/W14kKJnYb4Bn+ZYmD98GRms01+aUdpOwZFPul8b9OEOPIaVJGU9BYDIaTCzm0EramuWZ2PFTPGJkfik5JP7Er66rWv13ZLXktNLwlBQReO9lEodFOiNDXn3YvGB2qqX3jG3Ua3WqrbSXUs+rqMXX8d5ihHoimJrP9ouu5k1ZK4sVASMPOZjgopcLmEdqmAhTScCTG6mLbsgjb+T+EG/U8s9Tx0+L8uhLi/Ut36NheHXgT4W0hguYnodKnm/XDsc91wSaRhAl+JrmqzB9RFtloV8KjP+URF2CVw0Pz5g/j69h4lLEzc0Lc0tB+GmgDodWjmHOvVue0c+R+2svKG/8/1xGTR0f4E/CwS+fJTZ2pQ0G+L0iqT41Dp3pX8YmDLQ7tO0R7dnipmFNrir+tIPnWDiHF0WwGWmkOVjFzk3Jv6UwhYs15r+UZj4Io9p2KKuoQiXAkT3z3S0ZrbOdCtIk/yK7+aVed1LnFMp49oyGLTauMSxY2aj6zE7zbqA7lOxOr7y9HEFbPQmd0mxrBXQdFLff0BnDNhyP6GiCH3wSTkl1wrQdhHBNu
 PXrNf2PV
 42KPLHmggmdapTYUB90FrszD6cHS4raiMiUo9XJL6E6rGSPXXcJA4RVL4COcnDijWipOtkW5jkDY0wWzNqCquXwsuAIdX/8fFY4m7mCfOrpIs/zvc8va10Ct7BvxiWnWszX/IYS5DbmY1SllIlTAQCMJURetug4eG3XeU+z1QwlEik0XzIP6VGmXRoVfGLuH9tVeUBE/mJKQg1CrnRgj5rnMt/0/OYt8ObyaJ4sSR41eIcz1BejBaeWFh7nmYNNpHIO8QxnzX0f2/BYaOmE+ZCj0EBH9Y5DNscTDmZ98rPl65vd9jShMmOUJK70TbwJtD7Uv36Pp0YoHSrJGuOlZLmPnl6/bi5jFVEtluFfB2T7H0RrWMIQA/4lRzWSI3lPOHYoTjMn35XTRmi0Wt4xL7C7K0po5BvBYuIeUwAc0ZH22dCTM4NvKOw2kfow==
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
 drivers/gpu/drm/v3d/v3d_bo.c           |  5 ----
 include/drm/drm_gem.h                  |  3 --
 include/drm/drm_gem_shmem_helper.h     |  3 --
 5 files changed, 18 insertions(+), 68 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index ec549130744c..9e1cbf2f1136 100644
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
index 211578abf9b6..c4316b768b3d 100644
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


