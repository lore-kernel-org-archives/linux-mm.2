Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CA79CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74568E0020; Mon, 10 Nov 2025 09:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFDFD8E0002; Mon, 10 Nov 2025 09:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77768E0020; Mon, 10 Nov 2025 09:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A62DA8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:28:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D13D12A819
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:28:01 +0000 (UTC)
X-FDA: 84094926762.15.B320F44
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id 84237C0005
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=YYf8MQtZ;
	spf=pass (imf10.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifSojQBVX47ofooGortaMUWuY4ZD33w4zzoxy2VRkpg=;
	b=RrBbudtJdxD1GJzQ+tIJoY3+lNKp0RtCoZ4kED/dBHnsUzRj3i8Y1FXk+2boUptRyJlThn
	FfhD6pCWH+lT0P4X2wjmjVfX6cpg/+o/d+bc8VtgNoxBjL+hvmyY+yES9kMa4msWeCAmR0
	eOQhG8qlXdF8InFzXHsDcRKnru5EUzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784879; a=rsa-sha256;
	cv=none;
	b=NeRb7OZBTCl47EX10B9UjxuCmRvPYulj8UH5FUu9Y7W+eF0vB/1hXjxom8DftK4d4RA6Lm
	nMuXw03i2vbbCSgO0en3gAxOnQJd9QyXjCEqFL/p02SX0ItengH97E68CGlyj8Jo+NVcDU
	jzUYxp4wWpkMcB3JEgTfdjsRVusDKVo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=YYf8MQtZ;
	spf=pass (imf10.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784878;
	bh=n3NOwTVq+uP2vCtYvjEwsmwHJU5QZrWMSfv5uva9H8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYf8MQtZCtYIDvnFuT3nPq7NuN3UvsVH1Wr/hNgREVZ3ou+1yPQGv/qIZZBuk0aZ8
	 INs2+vdOawTNFhZRtPVdg6zIDFTs68jdyV/4sZrGM0mufMJGr10lgWnD/AwiYNP2DW
	 o2dfxsFqRGj61fpPx4DyObWdn4eUpmXNBgsfiwULE1EgTr5docDWdoHKdlWwTmdzMZ
	 bo0jHQd1bH4D2Akg6MXQzDTKENgH8lj6OZKGvkKDXwuwvA76psCwU9BLBYSdJ1fCYN
	 8dTde7Ju7hu8vJbcWeKKpF/wVAFYHtKpUJxwatZ1xzen/1RAyKdrMxFQHBZBx1BlDO
	 JgH/wq1Aigr6w==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 67C2C17E35CB;
	Mon, 10 Nov 2025 15:27:57 +0100 (CET)
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
Subject: [PATCH v6 07/11] drm/gem: Get rid of *_with_mnt helpers
Date: Mon, 10 Nov 2025 15:27:42 +0100
Message-ID: <20251110142746.3490-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110142746.3490-1-loic.molinari@collabora.com>
References: <20251110142746.3490-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 84237C0005
X-Stat-Signature: fpdf8x6378dgbm5rmfwz4qdq1jqx6dui
X-Rspam-User: 
X-HE-Tag: 1762784879-874718
X-HE-Meta: U2FsdGVkX1/bHNBIQC/ZUFdHxcfauA2Y+EhG9DDwf3W6fk/79IqaRDBwz8+KU0fsqjE2uPrvuwqE7wCjP6z5wVNIAyT15FbUYhxWzQXPr9eJZJIA0d6UEwyOTRviMv5XS1MH9wpaGllPxdP7mI0Z25BlAZRYm8jHr5qrHrAB6RkR4fUIqDFMQYKCtJN9/pu+YvsKmz5TWMqzz06BtY4Ok8Xv9FkYAj3p0AChb+zI6+2T+7mnN6c6Yi0lO7UJBp/GK1xU5mB3gncNFOxN1rWVuB+sA7T4UM9etYlkXuzA6NPzNLK9TgLGwwTnkWP501IK+34jqfoihMCfIV+vfT21tV5IhZTi9VQ5u4osGSVRZvtxF+J/APRonzcJGBMGiGAuxV42T5/UVVh0763YKCuxR0vNpfUh3clraHYTFv1BfzPtbhbvcWStwI/yzXonIAUZPVT8V5RBPHEHzBYaAvXf4VLzel/q1UBJe2n6K7yrC1TLokZJb03xNuZe3x/3w+ZeDV08glI4kZC95a19DN8nxXsPdeB7b/I7WKVGfIoyzmPi775tNlQAy24MtvdXZSju+HQDphDkna/OzkxL2i+sE58WL+cnfOYdCOxsjl7xn/Zc8xbbp1HMQROWlzCZpvOLk1Pktwqzf8SFMRlljskwCk44jwohuDDkUr6y8Kk21qr1BWFtRejeB74wGN6BaFOE94CgE4gjjb5MEj2t9tbdg7yyaVYTUGNMYFbjkV1cgfFByQlMDAR0u5eTer18iGz3/y1HxAtixFgePQzXAExG/wG4LtmiaQsD5Kr5ikgqfXvDyDRybWE3jrSRnd3WCOm1LNumVRaWA2JwkxI1tkjbpgYhvkPD2JpZBLmEsaxJ8YoKTWg3UMBOVMfiPMWiyFFRjDs+p0okusvgBna5jotz38DzSu3N3TFngEV5EAbSJCPZR+9PKTCySlOwNuhU1D3txwQatQq2N5M4nCAtnAf
 CRF416Kh
 92uyHpWCwK7yBcmmPAM75FnWbMsZO6yzj/nL0862DjQcnOV03LE/ltfN2MCGD8j+1I3Q1arwjCELY/1onngqNRV0Y0hT3WzaDY+EnMVuo7rrOPqXFUEFYuvzU55cyAxYraFM9Yq4IsBLcZPyFmzOC/uRCJsbNgFMYdoTtwQ1ESOkv8InghlTYieEs4LZirPxhHrsQrfU8FW9Rxap5SUMkG+ddwGhsoT2SnQwBioSfPPFFfmNkVYAomcQ0t3IqaGQETE9d8yKUJtHuMYJMpGeGZjNOQV5C5ht1jrFgbTOYIHFzmTLMA/2tIc5jLZF3/Lmm7LJjUI3aeKy2OxWWqQhMbl/ZexsuqTOJagsqbpOUAai525AOMSCXxTO7CUxTrwBuwSnncboF3oyS2wQuFhKq+E+bCMjpOxQOavwicQFRYr3du2TLAMOeU9v84A==
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
index a1e5881e8b62..e0517c0d5896 100644
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
index db0ed06a465c..c72e5411f1e1 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -526,9 +526,6 @@ void drm_gem_object_release(struct drm_gem_object *obj);
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


