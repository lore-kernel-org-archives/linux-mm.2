Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A848CD2F7C6
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 09:12:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD1716B0144; Fri,  5 Dec 2025 04:12:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D335D6B0146; Fri,  5 Dec 2025 04:12:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBE86B0147; Fri,  5 Dec 2025 04:12:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A69BF6B0144
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:12:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 388B613AFEF
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:32 +0000 (UTC)
X-FDA: 84184851744.03.4ABD77F
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 62428160017
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=B0O8Ct9y;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764925950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lcSNriewcQDmmBldCd/jiHHnFc9Kvl5s7FpRX2Ozqrw=;
	b=gp8rsGHzyjXC53+goRMzDt7Hw8oZi+TtwQduWFUDCpMlz/Cu4VQ3y6kYT61yjXWbYd/syu
	TFSjGbUBNRe5HUXiLcPNkxxg4J0xrSNDHlK/jUs5s6lNft0blORGxxpVa6ko7sJh78poXn
	IezXpTeDsgFInrM6gBzSfuHeJFayVDI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764925950; a=rsa-sha256;
	cv=none;
	b=C/4mJchG4WazNQ641+YW3J0ZnDXhREtyXd11hFpTfNM/2lNwGowajsBtCVlSfFaZk3hArQ
	GpOwe/bxf0c6JzVOXbLypPRuwedlBeUfNBUn+ywocjj88zuDgGGOzbqWO8nTA3YUCDeILd
	eDt+3YStneEQSagPtVaK5haxjVn1x6k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=B0O8Ct9y;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764925949;
	bh=Zex2NKxNRl6ia1F7pINdtc/8BVAWXVoWCqYCGqXTtRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B0O8Ct9yxpHDt9iBZpzzu+4ZxNC2XuEDs5BfTgI8X3WApjaTp5S8XVvzpWoWM5JdB
	 CWQTW7YroM2QB+FWy5qUvyX78cL1PJmhc2kixKIf40HzOm0J3uHwB8QgF4uHr4cMW8
	 Fsf51VAsQ/B5bomUuZHJpTZjl6pzGV3fwNBQeK8PwMZbvhgWqSOYx9aqhag7kI4S6Y
	 am54+3UMIuGRF9nIw4iNLIQzD5XBxtA8yJEIAuutdRN+JXO0KGKIktThj7Tzp+R6KG
	 /ozpOH9rQl2jIPi+dN9rnt0Q1qiwgtojSUOyZok5B3sBbVn/8i/VfgrRKEADBrLlbs
	 B2hWcVTY6SG8A==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 3C95D17E3656;
	Fri,  5 Dec 2025 10:12:28 +0100 (CET)
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
Subject: [PATCH v12 07/10] drm/gem: Get rid of *_with_mnt helpers
Date: Fri,  5 Dec 2025 10:12:13 +0100
Message-ID: <20251205091216.150968-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205091216.150968-1-loic.molinari@collabora.com>
References: <20251205091216.150968-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 62428160017
X-Stat-Signature: nrzs3dfzzq3qn6fxa88wd7frgbxki94n
X-HE-Tag: 1764925950-968732
X-HE-Meta: U2FsdGVkX1/JEEwoocfDAIfsJKFXAmvF7Z4zivlvE7k0lTZDUnKzvyRYJ+pCH4+velICWP43SGbiMibEXP+euEc5y/XYo32gQufaAR0E1uAHJd38z5gHKK6L4CGiy222w16hO450lTNg/LAkQ+ZzJV1Li0IJpdXFSo8DB5SUaNO2Dj4tENmplWIFwlU//h7DNhS0EllhOFicmvJdMxHVRAQg4AugiOhnKPl0AQ0yg/UkpVcADpG1/CHZ9M5Xq4yyE7KbTpLP4Wl7X7jEbS9oYe1DxqTU5+gXznz5+rPZpfzFfs7CT1NOtXcB2QVEGiD9bdtqAuyU7vj2xpeDuP+fH+iil3EfXYcICJxwhyvju6h8HRZ0IiCd6LzqhLzVYMIxhL6w7GTsck8uhcdKURZpAk1EKlWgtkFw/voOxeZGbRprEiQ2xUyOBx3BTO3R3SEEpT4o8IXwjVOFf1oyglMTdsuhfeDlDe5PWJPnPD/rKwEd8WKzRNrXuG24IdVsC3Y5ZWEqqB/Jew1EYNEIfX6uZM/mi31CsYmNZvFzHpcyYCVfMJCCZ6ec8QgTxvBfJVcBkKZFbC4JRze6+aD9YZ/ZRNhMvJPhnlAtxp+wmogYJlDC1oi6JGY4R0VffY9N7iuKiJnkjH98jTGGllNFCnzsdQUVG6MKgzspDZgaEgwKWNLnmj46rKK6mZ3xFDOkIlMKGFl961eaE+xXKb7PSUz5guKzz1NfC+Y5Ii55nmITr9Fx2HcOI9aSAfii6EGPcO5yjiYELMtaFhuhEpXpY342tAOceMJIleN6s9C/DJ6sdJ603WbLoZx8jwQbMGa0GSn5XaUz9kV2NNvmLMoeEjgB1VYIxMmlFVQzOC2MdrK8dnj+iJtW+W4ZNE+Meh0xB3m6pKNDndLShnZFhumzrryQvFMtVkEvBV40gtXo+2geyaCgNLSFwEE/oXNsRLKlz+pKYUnTG77uTv87y6X9f6J
 /HaH7pTT
 ftWqQZnCze8qfwPJzb0h5uTNXRcIjRw9+COGFPihYUgNVeXb8sGGsgGi6ZrqRcXer0iJiF1F4JDLUbi3qdG/QnLG0wDqcFWoHooGjRBnl9aPWgbachnRsyCXOeDlOrGZOQ9XwWFk3TFbyM/MBTrRgKBw+OOhw1S2T7EXcKAsEZAF90i8yUZ7Rq0OK3F03PCMImQNnuH6WkyAJgHHduniK9vrHBA1WKpJ2R5H/W3/LcZM/+g9zMYGKRO9SE3oeJfiARCs5RFhA/QaSKaPHa2xVY7U775h8O7vNPH1DQrxw732avhNK6EXgQ65uwsqe3YTmhK7p4H0DliIayyL0RfgX9je+jUDITzF7cbF+081d8ndaYwpMTg51yKg9YKYNL1XP5H3V3/2z9Y64EWIoAFNovF74GTPAarabu5yrMF+5/3MgSVCkdGXmVf8L9OXIXV66NZgFS0IPU4B7RbPM7jBuJUSiBL9h/qw0Y85ej5HtVzaK02caiCsYRyK89/YmS1fBv9LF0ln8ArWvlp5ZToL2EPTfRaBfd2LUxStC7jB4SQOfmH4=
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


