Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A71ECE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:03:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1ED8E0029; Fri, 14 Nov 2025 12:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B6E8E0005; Fri, 14 Nov 2025 12:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5928E0029; Fri, 14 Nov 2025 12:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ABFC18E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6402F88E4E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:14 +0000 (UTC)
X-FDA: 84109833108.29.EDE51FF
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 70490160006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=iWa2vKr2;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139792; a=rsa-sha256;
	cv=none;
	b=M82WM96MCsFvbt8ih+MExR0KD/bo9l0PGBB4CSJ2exm+8OkbBZiOIyvC+pRzkLJoqC0bvH
	4Gwp8ebfT8NUuqPtcCFX81G/ySmUkZ7Q/O56miG4jh1owC2PG1WJWGl9XnAPnaCOVDeui6
	wLGRqh4WPzPGvK+9Df1m+w8+uYmK+TM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=iWa2vKr2;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qXZlC1LWGNTjGxx5SEtcEz+IpRdxOT2Q+s3k4u4oeBQ=;
	b=0OzhUZa1XDD8K3J+R8rwiT/Flc6Fbj0Pd45pd+bnxuyyoSMQZP9SLsXhHp8mOESyO7N3aj
	F/SvhYdtEDLtqaLJNtqqOqvE+5tjr+nROsVGSEAckDEy8rGjEDb6ZVQiFPtbxQRLOr3mkO
	RLcCclFV3aBfxBRg1T6uj6nBZpWl3qA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139790;
	bh=I/K6ABg88kKcYHk39+29RJpe2ex6nmXz7rImkUyITmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iWa2vKr2bt1d55eTxrBSgK8OX5AKEWXJSZBQZiiPBUyP4BO/5VwOFkmZXQZB+wAni
	 TFOeAIrW4VJ1Pq3RobWhKfBAkS6o2gBiIObfSXhuwlyQ+MPrTYt/dLozUxiNzSS8cD
	 2FXdM+qjl8ujH1D9czCMStU1XnSC3vJTiPigNoItbypkEvwqAbMW3j36yiRgdtO70e
	 yZu0nDAqKFvXAXfdz1SIcvGOeE71VxA8pLtwHlpmm6QsebJ+aD+Ic8uRI6FQqEJqvR
	 J9/JFnwErs0x5WrENPI8CwvDB9Ewg0X1qpNmQlNWsprhOYzfGP1XeLg0JxiFr4sDrt
	 KuHtMC9oQlAMQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 8302517E1340;
	Fri, 14 Nov 2025 18:03:09 +0100 (CET)
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
Subject: [PATCH v9 03/11] drm/gem: Introduce drm_gem_get_unmapped_area() fop
Date: Fri, 14 Nov 2025 18:02:54 +0100
Message-ID: <20251114170303.2800-4-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114170303.2800-1-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 70490160006
X-Stat-Signature: mnb86mjt6uqgerjsj9kb5x3on6jx53m7
X-Rspam-User: 
X-HE-Tag: 1763139792-934278
X-HE-Meta: U2FsdGVkX19w04608rKbU1y7mSeCfxOjFLXb2Nt40GWaoe2t8Rr82FpItD6fchu/9Jc/gSkhV+seCvQJnHMW5YYkm03LEP+ySjlNZqhGdUZqTbJBOaerZvMGX5cn9TsM3jb84OlFedlTZPMpH/gIOO5KkBifJS9nKkLoZJvTUXapZU7+ZAN9qqdlWnoJ2NNZkjJmKbFPiC+DckH5Vu3qG1oJ5w2c9Wqi4T9u3ATDblUMKuY0p6ICsnGr9dpqWORD+HzIfnARZVMKrclA31wSqPDToqlBUnTrttl+i/jdtzt7VeYlCWxPIEDNC3gddBIZPgigLu0zfK4wfk2JzOs1hFU1/gaIFZ55e5Qtht58SYkLqmOF19SqpwUM0UdZT3flFATOCzd1dSE+1ZmCkWXzQCjnxp57ZHD3YTV9taB7Vyphn1BjzVC6pQ3JrbAimN6/NTuKD5fg4/nuCTLq9kVWuhnL3l/9vEVGsafvL0ffr8YXA+dEBzgIwRgjVSvNXDR+LRu+BI+h/ZEmWuADS0WGFtCY+nyzX9fdgv0bu23KjO8P0DoTGNu49QMCqFqFRtaSQB//gx8pd6ZcYEcE4Xt4z22wfiTd1bx3klrd7vWIKBSSn3+5MGJW6M/QEaSY+86LnGauOsifYE41nOltGG0dfKtmH2diGLQ4mjmO47P2muvpdWKMIHxLFyddYGwjDkiLV7z+kUkm+n5mlsgbZKcitSHVSRmpGExHh4QSzyeaEEuqlVhNwo0aUU4HImt9CRJ/Trj9xDNG0IZhtVZ7xX1vnivf2NgpTqa/1gKXC39LvwiVSFnoxA7GUfQe/UDzKul1R50A2KwjFgcOMOTBUhIQ3ePVaEGW11dnJewaPZ8bFPFFFQfnHhU2HI5smQymw1Fp2XCEynpmI6QtVopMymeeaobH6e4ftQur7F8uAkG7nrXXOxLIwJlOnJDv7XboxPAyNdeWNBTBr62Ed9TDAyk
 T5o/0h13
 z0dYq/Qr5s0hLawMONO2H7SW9c645I3C/qn3LFQ15q4mpr/whu6vvhDJy+Dyk+TbQz+Iy3j7Dvk+jKHv1qUXGBwd0/T94zt+Vfh5S4Iz9n+8HIn89DdhztTypr7izdvfC8GVrxnqCqNOwFUimGaO0/72sJzaQ4ELGerntW/6XIJWVUMtHgsn9RcwSqT5Y37w7+XhBIRF1mZ/ULSrZlaTBOXiE2Pi4QPDlIx34m3luYh5bO16wcDRbgy6Rq4ns7ne91nZotY2yutqeZPiwbIkS8O7pvfvbALI8QzuZ2KYfpTQ54vYNjRTAoxOFCkr2KpL7uVPwlV/lwFL2Vak+QcSSNDUXCqroPHWfAFr4FcJZMBcBahyCooJVH/JkLKi9vgHHae5UY9ZfDxp1pxHSQaLyOkzjSgYKM1tuaRX8QPdArLZ0txcZDZtIFw/wQY6h6DXBcqBSB20IF0hV7f8dd2nhG1TGUYgpgMRJ9ZvexdI3TlYRKx8Bv2D7xbbvOvyUy9qTIoR1evYN22Hbmx18EB/DMVQn4Lrl/M534tSl
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


