Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED7AD116FE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:17:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98CF66B0024; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91FFF6B0023; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B0D6B0024; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 41A8A6B0023
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:17:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A9571318EE
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:31 +0000 (UTC)
X-FDA: 84174129102.05.4107D13
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 42998160017
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=pIIMWwv4;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764670649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sxv/sZQcGM/SMoc4oAyCr8/yr9l0f+9bhHKNj0qXtzY=;
	b=cRf2a4qveVPEkHZkKRR//XCzVfs/eo6ZiybG6ei+RwpZ6nTBtaOe6NC94YaouQrkQQ4iJ2
	pZ8duui9T6qA1mdy2VE+hPxfEetl9M1D410GB3E6pJjuBSOp38sRprL8sXepAn251dMX8J
	laYRCNP7hk6ZdFsoohYfhnMMc5k+rpY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764670649; a=rsa-sha256;
	cv=none;
	b=2IDZjSLgY+2Q6zGlhzAxFe5f7UAnrGqDgGfGY0yo/9rIGgsOKjYk8NALQYG0GEPUBOP6mC
	2urPm19eY6wRka9z+KwjvduDRmd/GkY1vzrfh6EuGifT/p35gVkSCJf0zRAgfQ19gNdRBf
	H1+AUn/jtH6qjaEUS/HWUyB5YEfqGGc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=pIIMWwv4;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764670647;
	bh=l3KOxgbsDeFvoAA9+oMRdpSVUin1NtFGF9oS7CWPszw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIIMWwv4fZeLsCYc9IZYNmE+ueGzChnoIPlLO8GA9OToRTmXDsst1DhDv3vtwUo6y
	 xgstvvBmLgzbm/0DKJ1iS9SuAs4SUrlEr+I+Rpo1nWLx/WjW85Uu95+BJZogUn5qi3
	 +rqqIrfvCIIkcL/jNjYzvMSqhaRpoCdaHyyDRcDEEsjREafXuj9q4fTVqVjcTwDLiz
	 +mq6nP+g7opLYlkhooqCyb0AaiFlyFyczPcf2bGEcKRaMdHxa1Ussxyg7Ft+MDiUbg
	 bzBAeeWaeC26LBnpPK9303ZOupH86jDBJt3rbb0kxJZsxqOJhQyvb8KbKTcyKgaimG
	 yuQBaowJzUu9Q==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1C94217E1352;
	Tue,  2 Dec 2025 11:17:26 +0100 (CET)
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
Subject: [PATCH v11 03/10] drm/gem: Introduce drm_gem_get_unmapped_area() fop
Date: Tue,  2 Dec 2025 11:17:13 +0100
Message-ID: <20251202101720.3129-4-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251202101720.3129-1-loic.molinari@collabora.com>
References: <20251202101720.3129-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 42998160017
X-Stat-Signature: yodg3e43rrmr1kjwzc3xyi3wokyo3qtq
X-Rspam-User: 
X-HE-Tag: 1764670649-64338
X-HE-Meta: U2FsdGVkX1+PpVzeHZgS2pCYFdPd50Xh4mZdzyEq1vpMQtbjUwzJJyDPX+tzGGfYz88QzQ4cl+LKQEpPfVUrYsw5nLIPTZYEulFNYGd4NGpEMx/ANYzzedjqzL5LBgE+HPW9XQOH3nHH57PHnpWqNJ/0yzcq1M+8EUNbwPw09WlZWs0xFAloDcYlo+4kC/tWLgtjJoku7sMFajf0WMRh11z5+f0K40nzfEgLI6juDY5XHaWNZgI5R5qRmsZeinZ2zFbFHX/nqBgy5FOfhdTq8/W8upY96gv8cR2zUrVSva33//vrxphOHGkf46ZE5k7RSR1+nJz4CIFPK1HTkknHCQxY/Np2Ns/EDjrCrkXUVZ1Isn2xQR46nK9wwp/Vu4WW3SbxdHab5LLBoiT7SEvCIUJI4/xn0xVQnyfYanr+DolXiUqyHPbz/EDOcfGb0w9pa2cH2WHJtt4ZiidX3np2EUEiIW1ijUM8FEO68gU9AGmPfRfiRe/tr+86NU5rL5qKf+GbIJ5oJ4FWxqKkKpPq4HI4HsDwFVaa5iRY0m34WIBgTUCyNQ1+38Mv1qpvSMXIsIq31cbXHjCgzt9Zyk66NV7BrZCQK07DtCSCnoKKvfpChqjP5zfCkEo0QXOGdGuKSF+SWlgrz8lKyOWIlTywYGL2gCH7ACqZDLnm4gBI68c302pLYyFJA6stFDKBb7Tp1HZ6YgGxjeF3DfLNP09bz+dhUV0SSOqwDxPxCWKX59IgtmS6S2Fmnhivvq35a/eyFDS4DOM579PWnaZVbc+KJNDAPCHZqf6GJql5Gl4YhDQ5vMH+bb3nDru8mT5hWE6RWkbCvfnQ+OY0fOZICd2NJMtVIhktyzhz2cBec7SvOmd61jgtHQhfra4MyJ/WggYz5rLKfgQGjaQI0HHOZEFhZjQkiM0BStyyzDqsYPQHZ5XEvYe+DgbieiZ7WWhKJL3HASW7/49DxhO20Jzf7XP
 H1e+L3wM
 AcHqbzZC8pdvanaJOR1/Y7yNE2pJZy9JAcH5zZxkzDOmew4ZQj/ZX8gc71cdyMOOtgKlUkAUP43ZaUTK1IpkPHU5wgLuP0Rga4VbyMdYpr7qCUFz1G8zy8vWJGwqKSz6S2AQLbNbxUqly9OgOrxZG/++c2nrbzryePUPXZsVuuxexQ7A9mTBdX9v4NDw+98GL8nQhtBjzeVGlk8L+CSBJJVRVqv7fqeDrqHe8YWGa4UqmnjILE+SETFLElQYtWcdvyUJ2+cAKUCbteJjOlFkp1JDQwXQDOHcn52xpLBEqet6vpGqLd3oV9lGaNyS11ykl6BGSPQ0yiDRxV2Sqb9GHGBfFvm/VaN5EV3vqCW7M2kre+9EPCCN+Dfwqjm0skAV6Tt0G/vgD9PAoFCbtUE4DZkdnYpgzyv0YM9bPj9FPhUMN+9M=
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

v11:
- rename drm_gem_object_lookup_from_offset() to
  drm_gem_object_lookup_at_offset()
- add Boris R-b

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/drm_gem.c | 108 ++++++++++++++++++++++++++++++--------
 include/drm/drm_gem.h     |   4 ++
 2 files changed, 90 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index efc79bbf3c73..933fc89dd648 100644
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
@@ -1177,36 +1178,27 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
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
+drm_gem_object_lookup_at_offset(struct file *filp, unsigned long start,
+				unsigned long pages)
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
@@ -1225,14 +1217,86 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
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
+	obj = drm_gem_object_lookup_at_offset(filp, pgoff, len >> PAGE_SHIFT);
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
+	obj = drm_gem_object_lookup_at_offset(filp, vma->vm_pgoff,
+					      vma_pages(vma));
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


