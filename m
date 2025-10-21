Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDC57CCD1B9
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45538E0025; Tue, 21 Oct 2025 07:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5778E001A; Tue, 21 Oct 2025 07:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897EC8E0025; Tue, 21 Oct 2025 07:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 70F348E001A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E2671DC0D5
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:07 +0000 (UTC)
X-FDA: 84021904974.03.AFD1D55
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf28.hostedemail.com (Postfix) with ESMTP id 761ADC0013
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=krPcQNES;
	spf=pass (imf28.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBIPb3gw0tdlz+NZcIAf0E2A8NDdok8eQZIVETy0Ksc=;
	b=iilzPu/3xIADsSM0MiN2PevaHGAR15+3sAQcdGgea8NpHyX6ns0FagmD0kzf2lJYMJpl5x
	AdrTxQP9v2YJxp+YZMwoxdFR/5HAzpdjY+ml5S+AmeCW4+Cbu4of4f7aQQ/CXY5V2TEwaj
	d2acN3XZYz9Ivrf2P/P2RPalbzUh9Qk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046265; a=rsa-sha256;
	cv=none;
	b=y5yP98qTrIpkmo9XK4SwQtx2QewlbPusOgV9BnGlzNTFSaJB6yTWj+A4KVJmzfCwA5ZNS0
	GeEiA50OPYLiR+X1BQu4rE/of84mMuh0meDIptJcsaUeI/AOgHAaDYHnW+MElDX7BF2ZRZ
	0XnW1Ut3M7Ue+viAYs5p/cqSDIabusY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=krPcQNES;
	spf=pass (imf28.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761046263;
	bh=arXokuBVNhc5lGWiXbULYXWEb+a1YPkDkrl7zBSqUMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=krPcQNESoDtWPWjkw6zHNbpPC/dGoLEYWJBu9btlwNh1Dbkh5THP9dP8t7279a4V3
	 VHmfqiRksCi2nRDP2JF6bpvtf1qazeuDaCjjjWCC1C402JFD1B7TjrfZcuf8GhU8IX
	 gqjvsEEFtaeyF6dQkE2wyWxMXfeMbik3HwLKGtPWirIdd6jF9SCsbqdirfTtVFeNDT
	 LHXItR0Bv2EcZaynTPeNZh0oMYLOlTESlDiGV6qagYLCAOMIuml1i6OXoF2rEsbCGM
	 PuDUfqdNUPz2A+Yt/7B6OXn4cX8vxNlEpjsdPSUgdcRMmaQ+I9jJZljq05ZuBiBcQL
	 eN5XluXgLc7hA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D740F17E1580;
	Tue, 21 Oct 2025 13:31:02 +0200 (CEST)
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
Subject: [PATCH v5 08/12] drm/gem: Get rid of *_with_mnt helpers
Date: Tue, 21 Oct 2025 13:30:45 +0200
Message-ID: <20251021113049.17242-9-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021113049.17242-1-loic.molinari@collabora.com>
References: <20251021113049.17242-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: tzdpcqf43m64mn8qsbz5unidru8og7hx
X-Rspam-User: 
X-Rspamd-Queue-Id: 761ADC0013
X-HE-Tag: 1761046265-203852
X-HE-Meta: U2FsdGVkX19Z22zn5nnfHRDr+W0kU6/7EJYP92YaJCTcsCAP7V6nSPR4UxwyEpyn+xMpFQwqxgGKeqKiODq5QXPWTAa8hMTZl3V96J18czs1yNR31KhhYFGgoLhXRIvLdArvAZ+Tw6/lj4JsqkGkxlTz7Ig/n3wcqIhtqBU4Iodb4LFY2vspGHDI0NPvam6YaxTOzZEYdHtXs5ndeomHgKaBh/Rp5x+NeCnSQCnOPdLVs04P2A3x8THBjR2LbkncF4JsttrJuym6IHCFkzxDzIRpoEjU0At/drypeXOdCbDQNAXBb2H54QUGlQi+V1jVI/a3DaiaLFcf9HloTd+svUXTnppnVumjNILnV+bn4Mf6WexnHW3WcYf6hArjCNTISzF8d/mz2oSRX9Fca7VSR4wLG07WCgiVM/jx2CoDuDavA1Pleqpxu+bb20Vaz3pUjW7HZXwq7XWMc3gOl0jAUg3nnaKddo1F8V/ZxwkFREW+Z2bUKGP8GPt1ZUFBnFWqccKVb2opewOW+5mG43ADg9Pksftb6FlAvG11+Ro5g2i9Nr0vXa08uh7e2M8RSwXuUpk2TzIEj4bJ+AdP4DqDMKBST+TcaIlY7PpfUanR8rKoMj+wTk4n6tsrj/kdw4T+1npxj+BTkSP/4D5whHvtH/02URhoQrEqZOhV8Xh5Nae31P0QqcGT5dxb0KVwSMnIJYVTmjmFFhF8N3yPqeC6hFytSh3vKxiLLALHjNDYnytqlILCHerqYtL291hsSW8JpMG3I/+ql3B06fx+iflaJsaJM5gM+vGnrceJJSECZTVfGLJ/TLtX+TwiDxYdtOY4FiKOiNnWIPABouBTXnT8dIKXLzio6HLVwsIEf1Jq3VLgO5E0r1G4IkgNYm2s16d7QkpWsDwJKPVsW2ZrEHmPAT+IvAZtsXU+zTccSea6kRSmOX6FTdypy/ASXhtnPzxA7TH/TrH/Kh00jC0umfR
 1OYqTt96
 fShJIHiAAFgo5/qD93lb/sJDqPy4T3/+vJKaSipJGQY9siVWQSWiLgDlEpwYLh++kq3X/HBojwe4f9JVNL0UkpJ8FMh/hoSICNPyfQ4n8sP2J0UU7zEEMQa53kRXEWT5IzBBRai33XrNnil+UICULmp9oolm335m5BH744ZlvvdT56/dkpqACoqmt5VMKNiLWWT533XzsAMIAN7rKzuHMw+hK9ih9orORss8E9ztGQJR/rwqghCoxSfQe4K2MM669F8ZKC3LyxqIOQfEmLuaMOdG//7ama6IPzyfHUOjAQrOhYv6OReL/oTzuVnaJp6Qh7RGI8fghtUrnijhrVhQ1eR9UvIG9E/n+VbcXQp2N7d4oZylM4S+jInaD4nTVbU4PBUaTRkNBann3uruXTkVoU5BB1FkIJ+15eUdElETyQH5uZpP51PkhRbbotw==
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
index 161da048330e..ffb1d374d259 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -153,31 +153,33 @@ drm_gem_init(struct drm_device *dev)
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
@@ -186,22 +188,6 @@ int drm_gem_object_init_with_mnt(struct drm_device *dev,
 
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
index b7238448d4f9..415d19136de1 100644
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
@@ -906,7 +884,7 @@ drm_gem_shmem_prime_import_sg_table(struct drm_device *dev,
 	size_t size = PAGE_ALIGN(attach->dmabuf->size);
 	struct drm_gem_shmem_object *shmem;
 
-	shmem = __drm_gem_shmem_create(dev, size, true, NULL);
+	shmem = __drm_gem_shmem_create(dev, size, true);
 	if (IS_ERR(shmem))
 		return ERR_CAST(shmem);
 
@@ -954,7 +932,7 @@ struct drm_gem_object *drm_gem_shmem_prime_import_no_map(struct drm_device *dev,
 
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
index 9845854850fb..b57017ed38d1 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -548,9 +548,6 @@ void drm_gem_object_release(struct drm_gem_object *obj);
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


