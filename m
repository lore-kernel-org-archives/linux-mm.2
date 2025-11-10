Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD18CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858348E0018; Mon, 10 Nov 2025 09:27:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7608E0002; Mon, 10 Nov 2025 09:27:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621628E0018; Mon, 10 Nov 2025 09:27:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BF4D8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:27:58 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 030AF136246
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:57 +0000 (UTC)
X-FDA: 84094926636.02.DD6AB1E
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3080A10000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=W0znbpGC;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf05.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784876; a=rsa-sha256;
	cv=none;
	b=h9wuHPUbfU1YiLB3hDGShgSfyLgBSC4LsrA8uL+wZe2LIlI0DSXUbyM7DE/XBz8qIZbV0L
	q3q41WMWrJdfsVzTQOojlzk/KDZC2YCOgqEssV3IWhFCTDMJge/xRS35yQOPOOHB86TX+k
	2WkZzNRVdD67mDYKMql28V2VWsMdJSE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=W0znbpGC;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf05.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmVDuGNnmaZ86Aykami4gyuE4C25MXG2E/05gyLUsFs=;
	b=cuMAvCnpfhZeOgfBxe1y2eQily4QttkK8C2CIvXM23N/LubkB8Qm3w6Nv1Zue4MnOSzEOf
	nQmIiPs+abK+zs+d7O1JbeCd66lvpr1aatJEwi/pEzv9cDamIrEpHcKGxXVXkmrOtVRFfE
	1VhQG1ExJkYUhlxJNrOGdh4MQeG+Ces=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784874;
	bh=RR3/m37ug45OwSUOl1kIPKvmq4P+/gHkWyLO7Jm610A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0znbpGCg4TmxhqqUdcUGYAFNuEeIExAkW+5hrjDb/ekrEJHBD8CprzJRQo6Bje2v
	 wDyg+WWALx90dN9BkfuuYdLkg+TiqdRd0RBi5mxhdViSMIQHes901VZ496OxuJXvfe
	 gycGF4rzRlPzkZTsAO62Lxd2Prark49q9KqLDM5z/QqzEtrrOaRg28HYL4OXY2nQue
	 ym/PBuUIDvbOO3DGP5qUrNsZt1kUgw1q0uLgMVJFCXxXtJ/hMWuknCfL4DLsBjapTS
	 Cn6SvzBMRBP8r/RlovLjo9beetj2qgogmBzj7pRGnsL3J/MyftS+Ky3xP+6DynIfc/
	 NA3pkG8noXWaA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 64E9717E12E5;
	Mon, 10 Nov 2025 15:27:53 +0100 (CET)
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
Subject: [PATCH v6 03/11] drm/gem: Introduce drm_gem_get_unmapped_area() fop
Date: Mon, 10 Nov 2025 15:27:38 +0100
Message-ID: <20251110142746.3490-4-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110142746.3490-1-loic.molinari@collabora.com>
References: <20251110142746.3490-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3080A10000F
X-Stat-Signature: to4ngjkqrmjkj69ww6mqzo3n9npasf8z
X-HE-Tag: 1762784875-488394
X-HE-Meta: U2FsdGVkX18db8wBVb8mv1wRYR5zZlnqAIlTUK6k72r8g4G0HBOqWrScduZOwG0jcPLtfuoc2P3KbUvJ+MLEGaX+XPpLXI/VprYXXNMw5yNxjhnLNIlBC8fEEjcurUWD1SPKIlWdZX6QjCDLJVomyEksasauetBLuZGdfi/+QBNpZy/vZmLkSzXQAiOALaFbmZR/v5DkM6blYKhbuotigOADYGeoc3+xB50d8spdY1eCYV456o5xH8NaZhk+9NTZ/SCbgS732uD+Nx2zXe0RnCfGYTFSTPdLNKd3l454huKr+UFwzb3fBLAHUQc4thAeJuJbkupDvKz8JLsVlaJ0/Kesa/aYJu84kXNk/fTEkPYLngOxpzVwbYs+3OImUEgRC3Y93ZB14Y4nLYsq2jiXZkN4SYu25qODviXB3ct3aI0FWskVFI9IBNH288ueNaXVB39WKxlT+GTTWPeRj5DQH1W/8hMZTqa5XuLyJyzTBRdM/D3IWSDLHonlzKfLeKLE5W6EwRCLiyYNVvZq4WXULAO+56xz76DFMgVzlMVmqxqmQnIYR8DL9yroS21xqI6jhukIen40o7umjh0V7v8wOGI/JNrRUqqBmWWjLQ3VFo85/dj/6OJHZJanuD+rCr4Dx4gUhk4V3wycLTR2vLtk2o20FXTR4spG2uDo8kdcxsO42M12bm7iDIYVewVswZ8Xd32PY3nKjpDeJ5lOAXZZD8eUOApLYMmoC8wbbaG76ji5Y3NTfSWAzU4WbgrJdp4FaY8s1DXNYkPNuXwMjdklcYYmscYPwFsUYalJuVsTSWqhT/JvdeKD6pbxN5aZq7t9ooNm0c4iTGNeZFdKYZ3dY9j8WFQ0vhmtp/JuMI+qGeOVxyTZbIYIzkoZgBNkmWryzG4genfEsuwLC/fLL6y3MxwkNjaCL3DjgSbBG8ps5wTNRMfzRjtvsWMh3BoTy0iD/iv2gvB6F0HB9AJr2kI
 UZpEoF2X
 vkIfBLpdJdMP7MFRVHfcjMndLOEAXWgM7p+dwrsF3QV40ulx0vig05mfVso5KiZC2YvsbqI23juJG+gmRuXH8qz/HPs4VgwbnKZXT3Se2ZJy0x3TywisklnpwHI+QbFELCGHZcrqXa9DzWS25pVlS+HNorKtxlxowaYpPZmaWOIqVl5B5tCC2jcexFSik9LrVRcQotlW9rHRa4chd5Z/fPuzGRG6Wnk7R2MI0B76+TN6Eot3q69CVqidIrfXW9xRfho726NpqFyUvbpSk4pXh5JCCVsebAr2xoG2ZB6NIHpTwXYlUMAzh46om3gekd5IzKLqznuYabENOfSh8AJT9uTUy464R3oi6RcMkHoDFFmf8tN5W3o6jMe3KqKJnEkPI2h6qmpq6GEAWrdTKg13fLN5/G+c+VMjlNiQ1IF/Rry118Ks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap() calls on the DRM file pointer currently always end up using
mm_get_unmapped_area() to get a free mapping region. On builds with
CONFIG_TRANSPARENT_HUGEPAGE enabled, this isn't ideal for GEM objects
backed by shmem buffers on mountpoints setting the 'huge=' option
because it can't correctly figure out the potentially huge address
alignment required.

This commit introduces the drm_gem_get_unmapped_area() function which
is meant to be used as a get_unmapped_area file operation on the DRM
file pointer to lookup GEM objects based on their fake offsets and get
a properly aligned region by calling shmem_get_unmapped_area() with
the right file pointer. If a GEM object isn't available at the given
offset or if the caller isn't granted access to it, the function falls
back to mm_get_unmapped_area().

This also makes drm_gem_get_unmapped_area() part of the default GEM
file operations so that all the DRM drivers can benefit from more
efficient mappings thanks to the huge page fault handler introduced in
previous commit 'drm/shmem-helper: Add huge page fault handler'.

The shmem_get_unmapped_area() function needs to be exported so that
it can be used from the DRM subsystem.

v3:
- add missing include: 'linux/sched/mm.h'
- forward to shmem layer in builds with CONFIG_TRANSPARENT_HUGEPAGE=n

v6:
- use GPL variant to export drm_gem_get_unmapped_area()
- don't export shmem_get_unmapped_area() anymore (use f_op instead)

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem.c | 108 ++++++++++++++++++++++++++++++--------
 include/drm/drm_gem.h     |   4 ++
 2 files changed, 90 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index a1a9c828938b..2a0eecc0d3e4 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -36,6 +36,7 @@
 #include <linux/module.h>
 #include <linux/pagemap.h>
 #include <linux/pagevec.h>
+#include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
 #include <linux/string_helpers.h>
@@ -1187,36 +1188,27 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
 }
 EXPORT_SYMBOL(drm_gem_mmap_obj);
 
-/**
- * drm_gem_mmap - memory map routine for GEM objects
- * @filp: DRM file pointer
- * @vma: VMA for the area to be mapped
- *
- * If a driver supports GEM object mapping, mmap calls on the DRM file
- * descriptor will end up here.
- *
- * Look up the GEM object based on the offset passed in (vma->vm_pgoff will
- * contain the fake offset we created when the GTT map ioctl was called on
- * the object) and map it with a call to drm_gem_mmap_obj().
- *
- * If the caller is not granted access to the buffer object, the mmap will fail
- * with EACCES. Please see the vma manager for more information.
+/*
+ * Look up a GEM object in offset space based on the exact start address. The
+ * caller must be granted access to the object. Returns a GEM object on success
+ * or a negative error code on failure. The returned GEM object needs to be
+ * released with drm_gem_object_put().
  */
-int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
+static struct drm_gem_object *
+drm_gem_object_lookup_from_offset(struct file *filp, unsigned long start,
+				  unsigned long pages)
 {
 	struct drm_file *priv = filp->private_data;
 	struct drm_device *dev = priv->minor->dev;
 	struct drm_gem_object *obj = NULL;
 	struct drm_vma_offset_node *node;
-	int ret;
 
 	if (drm_dev_is_unplugged(dev))
-		return -ENODEV;
+		return ERR_PTR(-ENODEV);
 
 	drm_vma_offset_lock_lookup(dev->vma_offset_manager);
 	node = drm_vma_offset_exact_lookup_locked(dev->vma_offset_manager,
-						  vma->vm_pgoff,
-						  vma_pages(vma));
+						  start, pages);
 	if (likely(node)) {
 		obj = container_of(node, struct drm_gem_object, vma_node);
 		/*
@@ -1235,14 +1227,86 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 	drm_vma_offset_unlock_lookup(dev->vma_offset_manager);
 
 	if (!obj)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	if (!drm_vma_node_is_allowed(node, priv)) {
 		drm_gem_object_put(obj);
-		return -EACCES;
+		return ERR_PTR(-EACCES);
 	}
 
-	ret = drm_gem_mmap_obj(obj, drm_vma_node_size(node) << PAGE_SHIFT,
+	return obj;
+}
+
+/**
+ * drm_gem_get_unmapped_area - get memory mapping region routine for GEM objects
+ * @filp: DRM file pointer
+ * @uaddr: User address hint
+ * @len: Mapping length
+ * @pgoff: Offset (in pages)
+ * @flags: Mapping flags
+ *
+ * If a driver supports GEM object mapping, before ending up in drm_gem_mmap(),
+ * mmap calls on the DRM file descriptor will first try to find a free linear
+ * address space large enough for a mapping. Since GEM objects are backed by
+ * shmem buffers, this should preferably be handled by the shmem virtual memory
+ * filesystem which can appropriately align addresses to huge page sizes when
+ * needed.
+ *
+ * Look up the GEM object based on the offset passed in (vma->vm_pgoff will
+ * contain the fake offset we created) and call shmem_get_unmapped_area() with
+ * the right file pointer.
+ *
+ * If a GEM object is not available at the given offset or if the caller is not
+ * granted access to it, fall back to mm_get_unmapped_area().
+ */
+unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
+					unsigned long len, unsigned long pgoff,
+					unsigned long flags)
+{
+	struct drm_gem_object *obj;
+	unsigned long ret;
+
+	obj = drm_gem_object_lookup_from_offset(filp, pgoff, len >> PAGE_SHIFT);
+	if (IS_ERR(obj) || !obj->filp || !obj->filp->f_op->get_unmapped_area)
+		return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
+					    flags);
+
+	ret = obj->filp->f_op->get_unmapped_area(obj->filp, uaddr, len, 0,
+						 flags);
+
+	drm_gem_object_put(obj);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(drm_gem_get_unmapped_area);
+
+/**
+ * drm_gem_mmap - memory map routine for GEM objects
+ * @filp: DRM file pointer
+ * @vma: VMA for the area to be mapped
+ *
+ * If a driver supports GEM object mapping, mmap calls on the DRM file
+ * descriptor will end up here.
+ *
+ * Look up the GEM object based on the offset passed in (vma->vm_pgoff will
+ * contain the fake offset we created) and map it with a call to
+ * drm_gem_mmap_obj().
+ *
+ * If the caller is not granted access to the buffer object, the mmap will fail
+ * with EACCES. Please see the vma manager for more information.
+ */
+int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct drm_gem_object *obj;
+	int ret;
+
+	obj = drm_gem_object_lookup_from_offset(filp, vma->vm_pgoff,
+						vma_pages(vma));
+	if (IS_ERR(obj))
+		return PTR_ERR(obj);
+
+	ret = drm_gem_mmap_obj(obj,
+			       drm_vma_node_size(&obj->vma_node) << PAGE_SHIFT,
 			       vma);
 
 	drm_gem_object_put(obj);
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 8d48d2af2649..7c8bd67d087c 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -469,6 +469,7 @@ struct drm_gem_object {
 	.poll		= drm_poll,\
 	.read		= drm_read,\
 	.llseek		= noop_llseek,\
+	.get_unmapped_area	= drm_gem_get_unmapped_area,\
 	.mmap		= drm_gem_mmap, \
 	.fop_flags	= FOP_UNSIGNED_OFFSET
 
@@ -506,6 +507,9 @@ void drm_gem_vm_close(struct vm_area_struct *vma);
 int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
 		     struct vm_area_struct *vma);
 int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
+unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
+					unsigned long len, unsigned long pgoff,
+					unsigned long flags);
 
 /**
  * drm_gem_object_get - acquire a GEM buffer object reference
-- 
2.47.3


