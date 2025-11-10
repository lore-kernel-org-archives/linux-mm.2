Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A47CD13D8
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2508E001E; Mon, 10 Nov 2025 09:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9368E001C; Mon, 10 Nov 2025 09:27:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84B08E001C; Mon, 10 Nov 2025 09:27:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D98AE8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:27:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 999CC52538
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:59 +0000 (UTC)
X-FDA: 84094926678.02.7D5659B
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id C2D7840017
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:27:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=CjD1wuCp;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OrGvH8U83XMv34Vhtr9LYnWu56uV9ioRV1CtA8c6JXI=;
	b=chJCH4onWd29iRdZVQsp6nTuKFlusDwgLJJW5+j1rkTGNduz6OtfB1YUnqPLbL3rJ/6fkf
	tQAVQH6E0btx+PsPxlywj5XrJB2ClfOp7oaMawSl5rrSCpoi0nIfrFtLOqZl3hiD5Neps6
	YUSDExNhQSgrUGpqlAaCBR9Wreyv8qc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784878; a=rsa-sha256;
	cv=none;
	b=pcKjSwkUznrudfMFTna31rYwjbCXYRQENNyiBLl8y8fqsTUvuuSI2lgGSnmZXowwhdZmn9
	5EaYbnRa1esJ7W6zHGSrKK5YPlE2hitD4Phn6aQ4lxTQdvwbPaJdl9I6j48eHcM3xWbJ6e
	aLvvP03Vs4WKuKkg+tzgQJpiJvpdnyM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=CjD1wuCp;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784875;
	bh=25L9PlMR0qQ+ksjfXx0Kh+i2YLQrn4LifGx2eSmta8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjD1wuCpSzMeOVUMKo8g5Kmd5GA+fg0L2slgrNIHNmjvVPStPRDaX3ec58nU3edCO
	 /+ZgAyGioG7xwnq5Ye/Aw+EyVxWHBmQbW6KTJZSl+Bs6XvYzYo7ExG3kH5vmYurWTs
	 zoIB4lUpwFBjbSbE8jPoW8AA4LDhtlLtFHl9UKKcQxqiMa53qGY3UDIn+qaHrZz+sX
	 qU78u+lRJcfxymApllQqEFgTy0Mv8ir3gM1icCvXO6WI5vyLe1TXtH3VKHdN/yIUXh
	 E1nLjFNpX+UeEABLasbzTq8kdTgJ1RW7SikC1JCOukD3jKh/Nhls7TvF68347+0She
	 kJExIxlKODk5g==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 64C7E17E1416;
	Mon, 10 Nov 2025 15:27:54 +0100 (CET)
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
Subject: [PATCH v6 04/11] drm/gem: Add huge tmpfs mountpoint helpers
Date: Mon, 10 Nov 2025 15:27:39 +0100
Message-ID: <20251110142746.3490-5-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110142746.3490-1-loic.molinari@collabora.com>
References: <20251110142746.3490-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C2D7840017
X-Stat-Signature: is8agdzdtd1xyeo9j6zbnsoq8w96fpgq
X-Rspam-User: 
X-HE-Tag: 1762784877-839336
X-HE-Meta: U2FsdGVkX19MOucMFHuGhwdUt3RompixSHCqbArC1gz5JuhQvBrFagxgCArUCA7Bxa+MJRd44zm/K3WO2aGkTClrx3UO3OwnhUg4QWozOATF5RiK47vJbp+MaDLZOPHBgCaWnucCy35/DlX4LbWFGtq5Pj11Jrr0WP9j6DN9C89cVu8OW6dBYx71newTBuE0GqTlzUcJPCEGyTOHbPpMPkAi6u1YFRcpjQH9sz0PvRBrhrjoBO3K8g139V7KZ2yT+M6rgWCT/R3RZDBQs6dYDHeVXuZePzK12ezBaN1gH9ry/8JMLI4Kau8NrX4FzgxlT4DKmgdq6tEy4OYc/EeGAqTo9woE/4kbGDu7yknNIel5bg6y8ZFZ2e3RqnTIm1gvSTsLIxyOkzPiQtnIihNc90wtg0dn3cGy8F2K71K2KzDWp3wTFAP1AGO7YgLpgsv1gkwppdbh2R1O2EtUqtuSLM6/0Th3HSRW8S3kXLx40yVY/xwwCpTksfT6G4b+ZsphF/sOOvqqT1iHE8ubZnpUTi+8MxQ8JPcQ+u1bJDnXQzeC1tdiEg6oijjcmSF+STMDR0a3Ns4J3rq5yaWLicETJN5Ij1DQXKRtSZLmp/RqjQ87yt6YrKBQQU6wEn2VWVwKJOZaKuFvy+199zGDyq0EHa2ICwVwzNxpy9H9thG1745DpMteR9qrQODyuTH02iP9KTV1bsxrfPxbOzAkroLs4NsxPZ+Bn4Iw8TdTRvVPFYR09PjrS9iBfY/RpEk42Fx0FihDoF6omTFzTEKqgv/NnzWga5Aflon81MbTbl9FLl5OQIQjjDU3+P3lUt62lNilk/zgVkcS5noqXWbuHSOhk4K7zinusAfI/JH60qw7735wyO83OBxP+mdE1Z8lf2UUkp5tWzCumatfOzKyLcxb0yPx1fXvjvGcueaK1yE36LxyMWZMkk6Q0M1Jpl2TJUa0+nQ43Zfz14rYMVEZbM4
 g3I68TLr
 yLxY7tN6jnU9jE8WuUN/mXePQ75EDBXeYKZk+PegQy7SJixn96Sz5pIR7tEjtJXzWPlRL/y9axaCL1u3FKxhqs6V/Ne6/kksMHLjNryw3MKrm/AEASq9Ms4WhEXc37j+Scs8Zo2RgAmCBMZ+4+VFfKivaWdkHYsX8224JcqkILK36Jo9Z6Wp3mHQAr+6mQoYWuHqVr0QuDbQxgftkEpskreQtWp28kNQA7KiYEhygN5bwS6pWJ5F7+v+MO/riI+3j/GDKMBeUJ7Ieutd88XIaOXCTpytleiZynPZ09u1ND3Aj+I+cjpjIoI6x4vhoii+xFBwPaEhIGwqsQGN7+U6SG67zGAJQqGur+dKRq0Xpq17rHMxA3ttfZg9OTQp9P3100gZa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the drm_gem_huge_mnt_create() and drm_gem_has_huge_mnt() helpers
to avoid code duplication in the i915, V3D, Panfrost and Panthor
drivers. The former creates and mounts a dedicated huge tmpfs
mountpoint, for the lifetime of a DRM device, used at GEM object
initialization. The latter checks whether a dedicated huge tmpfs
mountpoint is in use by a DRM device.

The next commits will port drivers to this helper.

v3:
- store huge tmpfs mountpoint in drm_device

v4:
- return 0 in builds with CONFIG_TRANSPARENT_HUGEPAGE=n
- return 0 when huge_mnt already exists
- use new vfs_parse_fs_string() helper

v5:
- remove warning on !dev->huge_mnt and reset to NULL on free
- inline drm_gem_huge_mnt_create() to remove func from text and avoid
  calls in builds with CONFIG_TRANSPARENT_HUGEPAGE=n
- compile out drm_device's huge_mnt field in builds with
  CONFIG_TRANSPARENT_HUGEPAGE=n
- add drm_gem_has_huge_mnt() helper

v6:
- move huge_mnt doc into ifdef'd section
- either inline or export drm_gem_huge_mnt_create()

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem.c | 57 +++++++++++++++++++++++++++++++++++++++
 include/drm/drm_device.h  | 15 +++++++++++
 include/drm/drm_gem.h     | 30 +++++++++++++++++++++
 3 files changed, 102 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 2a0eecc0d3e4..bbca2ab9e9a5 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -29,6 +29,9 @@
 #include <linux/export.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#include <linux/fs_context.h>
+#endif
 #include <linux/iosys-map.h>
 #include <linux/mem_encrypt.h>
 #include <linux/mm.h>
@@ -82,6 +85,60 @@
  * up at a later date, and as our interface with shmfs for memory allocation.
  */
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void drm_gem_huge_mnt_free(struct drm_device *dev, void *data)
+{
+	kern_unmount(dev->huge_mnt);
+}
+
+/**
+ * drm_gem_huge_mnt_create - Create, mount and use a huge tmpfs mountpoint
+ * @dev: DRM device a huge tmpfs mountpoint should be used with
+ * @value: huge tmpfs mount option value
+ *
+ * This function creates and mounts a dedicated huge tmpfs mountpoint for the
+ * lifetime of the DRM device @dev which is used at GEM object initialization
+ * with drm_gem_object_init().
+ *
+ * The most common option value @value is "within_size" which only allocates
+ * huge pages if the page will be fully within the GEM object size. "always",
+ * "advise" and "never" are supported too but the latter would just create a
+ * mountpoint similar to the default one (`shm_mnt`). See shmemfs and
+ * Transparent Hugepage for more information.
+ *
+ * Returns:
+ * 0 on success or a negative error code on failure.
+ */
+int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value)
+{
+	struct file_system_type *type;
+	struct fs_context *fc;
+	int ret;
+
+	if (unlikely(drm_gem_has_huge_mnt(dev)))
+		return 0;
+
+	type = get_fs_type("tmpfs");
+	if (unlikely(!type))
+		return -EOPNOTSUPP;
+	fc = fs_context_for_mount(type, SB_KERNMOUNT);
+	if (IS_ERR(fc))
+		return PTR_ERR(fc);
+	ret = vfs_parse_fs_string(fc, "source", "tmpfs");
+	if (unlikely(ret))
+		return -ENOPARAM;
+	ret = vfs_parse_fs_string(fc, "huge", value);
+	if (unlikely(ret))
+		return -ENOPARAM;
+
+	dev->huge_mnt = fc_mount_longterm(fc);
+	put_fs_context(fc);
+
+	return drmm_add_action_or_reset(dev, drm_gem_huge_mnt_free, NULL);
+}
+EXPORT_SYMBOL_GPL(drm_gem_huge_mnt_create);
+#endif
+
 static void
 drm_gem_init_release(struct drm_device *dev, void *ptr)
 {
diff --git a/include/drm/drm_device.h b/include/drm/drm_device.h
index 778b2cca6c49..bcde07c43e3f 100644
--- a/include/drm/drm_device.h
+++ b/include/drm/drm_device.h
@@ -3,6 +3,9 @@
 
 #include <linux/list.h>
 #include <linux/kref.h>
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#include <linux/mount.h>
+#endif
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
@@ -168,6 +171,18 @@ struct drm_device {
 	 */
 	struct drm_master *master;
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/**
+	 * @huge_mnt:
+	 *
+	 * Huge tmpfs mountpoint used at GEM object initialization
+	 * drm_gem_object_init(). Drivers can call drm_gem_huge_mnt_create() to
+	 * create a huge tmfps mountpoint. The default tmpfs mountpoint
+	 * (`shm_mnt`) is used if NULL.
+	 */
+	struct vfsmount *huge_mnt;
+#endif
+
 	/**
 	 * @driver_features: per-device driver features
 	 *
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 7c8bd67d087c..db0ed06a465c 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -492,6 +492,36 @@ struct drm_gem_object {
 		DRM_GEM_FOPS,\
 	}
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value);
+#else
+static inline int drm_gem_huge_mnt_create(struct drm_device *dev,
+					  const char *value)
+{
+	return 0;
+}
+#endif
+
+/**
+ * drm_gem_has_huge_mnt - Check if a huge tmpfs mountpoint is in use
+ * @dev: DRM device
+ *
+ * This function checks whether a huge tmpfs mountpoint is in use after by DRM
+ * device @dev. A huge tmpfs mountpoint is used after a successful call to
+ * drm_gem_huge_mnt_create() on builds with Transparent Hugepage enabled.
+ *
+ * Returns:
+ * true on success, false otherwise.
+ */
+static inline bool drm_gem_has_huge_mnt(struct drm_device *dev)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return !!dev->huge_mnt;
+#else
+	return false;
+#endif
+}
+
 void drm_gem_object_release(struct drm_gem_object *obj);
 void drm_gem_object_free(struct kref *kref);
 int drm_gem_object_init(struct drm_device *dev,
-- 
2.47.3


