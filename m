Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1B4CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2AFF8E001E; Tue, 21 Oct 2025 07:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3FE8E001A; Tue, 21 Oct 2025 07:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF578E001E; Tue, 21 Oct 2025 07:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB588E001E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BEF813A32A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:04 +0000 (UTC)
X-FDA: 84021904848.17.FBB71B1
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf19.hostedemail.com (Postfix) with ESMTP id 509F91A0016
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=JLmOrQ5D;
	spf=pass (imf19.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fHfKOf2j/wNV5sB18dVKnWXyUjan/uE+AyxuPimXZRE=;
	b=bgZKMPWf3rpPbCDyNR8fK8/9AknfRQpNDGfByLsumcAb284vIMqCWp84R9iF1d7YrSGybt
	l3uVJ18EoJbe4U6a+iyxKYZm4Wn1m5rWuYzBWl7eXBiO1tlSQAWrDT4viG4UVDelsDKWc5
	2T0PAdn/+mrp53nOBmJ+jPSeiKjDm/E=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=JLmOrQ5D;
	spf=pass (imf19.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046262; a=rsa-sha256;
	cv=none;
	b=BfkZAZaJhNwbNtTFTq8OyC1Ul+Pe2EzfOTtF9W934kydmYLYJd67pMKwvV0567QN1HYxZI
	u9dumj5k17eIQkceoPUmVx87VunTyIMlcsYYQOzEceSPraB0A1/h5na5EsDGXNccqASIjn
	XHUq8jqnCQCu18R/WwxmrOau0xMOmLg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761046260;
	bh=Lj0B4YSWG0eY+jXjrUt0PkKJzRuPbRHNLFpJSe3FosU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLmOrQ5DVJ3w7ybK0KBzkBKY61ue2JH7hxaUu03DkiY8IocpM4seGepfKlMyTtgan
	 gQ3/OwMztTu6ekw1cA/MlN0FwhF+Ci/ZvIcpVjaKwqE2nYTQI0oXpwpK0Rq8xX2pxW
	 Hzqgv1qqkczt3ax1JVol/F96zuzLkhvYmmgWHNF/iLcwwEchHVG5ZZYEC1WDWl9cS/
	 9ONA99TPdxLz9XhId3RhWNi4uPsIROK2lI2zHvjTSj7g00bAObmADq8DJqUkpLCsdA
	 8fLwqd28Z9VllFLkUNpyY+6B1SwfLXxmOZMCOXoWj64On32e+e0Du/1ZdMi4kkdZTk
	 e0rQQqL88rtaw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id C66C617E141F;
	Tue, 21 Oct 2025 13:30:59 +0200 (CEST)
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
Subject: [PATCH v5 05/12] drm/gem: Add huge tmpfs mountpoint helpers
Date: Tue, 21 Oct 2025 13:30:42 +0200
Message-ID: <20251021113049.17242-6-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021113049.17242-1-loic.molinari@collabora.com>
References: <20251021113049.17242-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 509F91A0016
X-Stat-Signature: b73u1ubqnzqh5q96zz8w77nxegfwwbuc
X-Rspam-User: 
X-HE-Tag: 1761046262-102131
X-HE-Meta: U2FsdGVkX1/G308H/XB+FUamMeLsVkfdR9WwxwfWFKxDzJF2Gp+StZ/BEuH8hKbg3hkvr+zpaJ1BC1bBi/2zUtFf5R2o4yG8smPFlPJQsEJa97Gd/vFZ7FXHQNZZdSzHttiVPv4PiZOUHfM9UeiMwLhtgAPAMhJt4VderYIo3JsbvAhS2O5LFrb+eEdKKu2QfNGzZV1kGMEtbey4xiopsW5miE/M7noxuz2sRWmwTa7NRx7Qybszm5VIPk+Kvhiryg1rRSZhmslzW+eqFws+rVDxvSinm0+tyV2TTaL8HyoLGW9wgzsI0kenAyyaTyKJYX+6d4aTh57+Yy7UNJjaNY+NvUvRXY1Hcf7HkOT7EzkdzADbNbyMBB8EyBP1L+7OE97IRCgPn/PbGU8mRrz98l/n2Nzapx+/Wk/ZtjidbcFdgSX/ZrGoxc/hEM/rX/nUBvJNsv+6ibmyHbvrgKhUqiRZ7FKkuSh9K2QXIk48HMMtAmFlJ/q50tgvQqt6S9UGyvgXf4OXa0kymVC0s6x4hMk/zI70EdZuk2vHf0sGdN8u8wXkbk0HRIF3m3AlFmH96+SFdT1j4kKVGYAIhLhS6r3dWwu/byjSDsz5Erzaw2UFwBr+jHvVLUY+uvBRCUh2LkaCJsTqVFMRwEwohaPaRVesEaxyGWmyMKHDg+NeWzcBfztS2H83pZKz6ANeAaeWlRne1DsPK4AEmb90DLVzjcz0fM/+roBDcd/6h1l1IWl/r2qhhuqYvRD2xCTCCu3h5qRcFXWndzO6pA520aLgsX6XyKjF2giWkeIAt4dKZcpoGJe2NiH9vMKQtafpYL0QKy1ZdSbN6TMgpkB1Ot8G/RcyNK3hON3mQbeLuJ4ELETS36LYlRRYymt/zcUjOTvq8h9Ezk6XAleEAHzCXliM0IHFEJVlFdUTFSAe9jMNRqH7Pzm8R5eCDrUe/KsrFGCGju3wV+L2Zd8Flb7LVP1
 nXTJGnyZ
 ZX0Yd5Jglts08yyjZRINxmFu5Ukv+ELoGn8i5cUimLTH5u7fWtnSL9uyJOe4BUT2plUyumX/rsdMSnDRmuFQYhkC05s2tJMCQ7NglIAC+LxL6nV6jSgmNuQevs/Bfi7niWhPJULKUWc1jKNSJWRto/g6F3x3HVC1vGz8/UrcSas2P/0ukaaC3YDXb4/zhPu0oYcKurUu2meLdTPvkqd+b1+OKOOjw1OrvHmb1H86MaInTS6Unf1yOFk1nJUn9XlWZkHlmglBi8tbh3q6hyKRlGvIMA5NmQwLl0hlaXET6s6WIOMnxFzWpE5IMb7QPH7sg4Ukh68T0LYykyaiktFM6aiccEJhpNcLaE6ku5H6VjdBsp0ZqHzDenSJDK3qAsg+3gZZE
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
- removed warning on !dev->huge_mnt and reset to NULL on free
- inline drm_gem_huge_mnt_create() to remove func from text and avoid
  calls in builds with CONFIG_TRANSPARENT_HUGEPAGE=n
- compile out drm_device's huge_mnt field in builds with
  CONFIG_TRANSPARENT_HUGEPAGE=n
- add drm_gem_has_huge_mnt() helper

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem.c | 39 +++++++++++++++++++++++++++++
 include/drm/drm_device.h  | 15 +++++++++++
 include/drm/drm_gem.h     | 52 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index a98d5744cc6c..161da048330e 100644
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
@@ -82,6 +85,42 @@
  * up at a later date, and as our interface with shmfs for memory allocation.
  */
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+static void drm_gem_huge_mnt_free(struct drm_device *dev, void *data)
+{
+	kern_unmount(dev->huge_mnt);
+}
+
+int __drm_gem_huge_mnt_create(struct drm_device *dev, const char *value)
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
+EXPORT_SYMBOL_GPL(__drm_gem_huge_mnt_create);
+#endif
+
 static void
 drm_gem_init_release(struct drm_device *dev, void *ptr)
 {
diff --git a/include/drm/drm_device.h b/include/drm/drm_device.h
index 778b2cca6c49..684939987d83 100644
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
 
+	/**
+	 * @huge_mnt:
+	 *
+	 * Huge tmpfs mountpoint used at GEM object initialization
+	 * drm_gem_object_init(). Drivers can call drm_gem_huge_mnt_create() to
+	 * create a huge tmfps mountpoint. The default tmpfs mountpoint
+	 * (`shm_mnt`) is used if NULL.
+	 */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	struct vfsmount *huge_mnt;
+#endif
+
 	/**
 	 * @driver_features: per-device driver features
 	 *
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 7c8bd67d087c..9845854850fb 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -492,6 +492,58 @@ struct drm_gem_object {
 		DRM_GEM_FOPS,\
 	}
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+int __drm_gem_huge_mnt_create(struct drm_device *dev, const char *value);
+#endif
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
+static inline int drm_gem_huge_mnt_create(struct drm_device *dev,
+					  const char *value)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return __drm_gem_huge_mnt_create(dev, value);
+#else
+	return 0;
+#endif
+}
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


