Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B61FCD13D9
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3EEE8E002C; Mon, 10 Nov 2025 10:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA1608E002B; Mon, 10 Nov 2025 10:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69288E002C; Mon, 10 Nov 2025 10:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC65F8E002B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:13 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7CF44139107
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:13 +0000 (UTC)
X-FDA: 84095133906.24.1933607
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9F14A8001C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=djbIlKi7;
	spf=pass (imf02.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXZlC1LWGNTjGxx5SEtcEz+IpRdxOT2Q+s3k4u4oeBQ=;
	b=rpWyedU2U+PGRnf9somXkFLfxcMiE+f8Zp5eFaENOjWesRJKD5Ye5kdBc7cDXo+nE/LVvB
	GNS32t5dB4Dc3291yZIloz92g4xoDkqJOcvY7QDHFjQlBKR5hJO0BL5srXKqSYrBnbYZRm
	hzFUB0JRvnvV30IuIvgpHPXV6sZp8T8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=djbIlKi7;
	spf=pass (imf02.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789811; a=rsa-sha256;
	cv=none;
	b=5vL8qUws3o7ddTP7BUiLmAFqC1B54wAj3attqoZbZ47GtbAz5ubUI40pTyv35nZw/CR2mG
	mmc9cPQG212zag3REDZAA594GLmxyrbg6ow6wVDyZRCThQ0lDAOcEKdeK4rAWj38Foynw5
	6qd58MN5NvrEKgUWugswlBvkG7aR/Po=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789810;
	bh=I/K6ABg88kKcYHk39+29RJpe2ex6nmXz7rImkUyITmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=djbIlKi7TZ/eimGeRQVLPWNgoq4XXn+njC55WaNhM7O0hmrCLTezc3Tcd8YZHS6PO
	 H2TAOVHtOs49re1rD87X+MKicbDKZ2NYLeXW2mLax1F39m09M+UFeMbxxXBc0w7Swy
	 oC/75/dX8pLw4lclpV2KYPaB7hzeTHV6BN0fcaYyIxhSUY4cRAwCInr83sLzhzz4Sm
	 qmQ9ucu49wByVW58PgZlAD2RX2C734XMumRAyp/SENY5KrMhx5mMg1m8CBBbHqoa1S
	 O7XVVveLcVceLm0iwTajGyRmZXpPIJjZMv1uAhqpb7cL0xJCiesir3QRzbq/8xx99u
	 fDMGCe5yYQqEQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1A7D517E12C4;
	Mon, 10 Nov 2025 16:50:09 +0100 (CET)
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
Subject: [PATCH v7 03/11] drm/gem: Introduce drm_gem_get_unmapped_area() fop
Date: Mon, 10 Nov 2025 16:49:51 +0100
Message-ID: <20251110155000.2936-4-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110155000.2936-1-loic.molinari@collabora.com>
References: <20251110155000.2936-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F14A8001C
X-Stat-Signature: b7yyg446ksa57iz1uzjd5zrxz7mbsf76
X-Rspam-User: 
X-HE-Tag: 1762789811-672550
X-HE-Meta: U2FsdGVkX1+5efmlPgCFxG0ZKvmh3+/3ixijL1It5+taS9LXdamUPPsoANAr6kUUyq4eAjObMVCFrx3dnWi0f9CGObcXSRn9F7+2TZyRi8skCSC6WNjyI9L+1scfWIloBzunoXysAAgcBe+rF4s56h2pgOqNN8XE36slxGByQQkyZuXcaXi3aalZ1pNdtxAEuMOJ2raaVpMtVB1cKcUtW87rbuKauCEe57IR0ZS0g21K2cafC3ZELWa+n+sacjWmanV13UL7acMZZcxXex9C94mrvkmx6AHyqYeYL6g/cmHeBA/lEJ87NAohOwkrv+C89jxFC9Ub5AiNy8YqmGfj6DfY/XeFucnAKN1AcgTMgbsQlqiE/Ecq8yqFsMkqiJbKt+YkBZ9yT5cM0qSe/vinal/R2jyu+s/wKkLDMRWZ+rJgEKKNMVs1OVJqaUV2sSNnxJ7yaw1VH7RfbdzID0AvpUM6pSU7IhPN4tZRtuL+OSCP7FtB6kGf7mEbqjqdFrmzzDWHvY5Xlti2tbdZ2WLKwQ0GdXnwKvSuSTsDhRCeaA+kdptGCCU1LeW1gIDHPv5Opc++gWsJUpqsJ7eWY5KTC1/UAGgVqmHV4kdJaeT3w4u2e9/EMWhdcCREG+BDVOSr1LTcpra40fDFFWVg0hSEvii3GW37GM4SwI+7PbSFnH2YFTMmms8by7l01Z/EOU/89C49pLje2VAJb3HXP5GQFg8fRVhzZLLAh8PdBbnX38KA/wPTtSTAROzd7lHjmJkmUqW+bWQa6EHbN2XdtmzcbO+ukzfc4x4bPhuNxqeHk55j7If3uNvLdoPVL8BUehsMUng+Ww/9ZbcBIJ9h9a+hHoQcDs+0nmZlPaEb74GNDKmQnAcmEJ0bSEk/YHfrmcrhwWtY9WVqPB9X747dS4hx7QWsXZ1VpGWqEEE4sLGHOYL1BgnBy0TzaSomJI5YfZsgIgFxp2lJzYmVssfQ0/U
 jATg93Mt
 dAdXzphYm7id084LNGwhstygya35lFRWinbp9IsqR4zcVU1TuOzaADWCo2k7UPLkmz0/Unqp7Qo8oCbZFKwrzInzJUkeP0Duk40UVU+9Fi8GpMgQALOAEowWumq2xnSmfybn+3fDs/7NP924Tl1wTc6cOpiHKYTspgztsdCJlYDOIpW+CysEthljDI0yp5sZ8SJcE27FXwYd6vcXL8sXGVD/wU0xS9W6QorWUEEoctgJHj3X/CUU6lIGNqJpIah1c4AJW2ojymfpdVBm50kf782JLezcvMRLB10e6plVxmI6lBkForOvBm1hAk44DrPqtFAP4CexCZ7ZlNRjekW0BFkRPOd0nnImY2C8hQtJfVDJP5dMbODKZEzsgG+6HODteI8VviKSu6Vz2Bqj+IpnpUj/PBEMYbqUwfALwr3KSv6DPhdw=
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
- include <linux/sched/mm.h> in drm_gem.c
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


