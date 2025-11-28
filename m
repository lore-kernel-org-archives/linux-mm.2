Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C72BD116FC
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 18:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25E7A6B0089; Fri, 28 Nov 2025 13:53:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F586B008A; Fri, 28 Nov 2025 13:53:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B176B0093; Fri, 28 Nov 2025 13:53:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E65C76B0089
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:53:03 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9975A13B91B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:03 +0000 (UTC)
X-FDA: 84160913046.13.D04D7B2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id BA0E4100004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=i4SesXvD;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764355982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVLbh4bcX45wOc6OoOIolg4r9MQNdsxS+dmmLONCK64=;
	b=aiQ6Y33Ve+QVSIQg9/TANQopULVlAhLRPxvRmOHj1XlyAXsN5Lf8Q8FIKNDld/noJOu9VD
	hQgUvxrvmWPR8Hm2QMFm4PqHcgoPMjlFnSd5TMa8pIBS2IYDwOjjCGs4nlrHVZKUFepw19
	GCqpO5dMA+dDDJbeFqqCzki6LN/AolQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=i4SesXvD;
	spf=pass (imf14.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764355982; a=rsa-sha256;
	cv=none;
	b=cCnJQXc5+IRInj2E50qa9TP3pp2kRb8Z3BtRFHCwTGBiJmb57zh32zzpZNmUDzM8AJxRW2
	Mpxe651wIXrSaIu5UlJF4MDwhJdvFebSSRhYR9FW1HBNst0BEOkHGr88o/lck2bmddNAm7
	8hagNUgUxqucJtxEDLRoyNyWlO1N8QQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764355979;
	bh=866+Aonq+BZvoU+OJZH9iYpRtbV7q6pIVDG232Knc10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4SesXvDZUuSE4keRJRclM2c7nbFXzVAEq83Z2mde2p6QE4L+FuP7tX5yd6NZtDN/
	 XTx8Wbzr+CvguQsIFvluvncgpfgeED3ERt2YbAV8l7KGsXA6AEk1SxpM8hvWdyttUZ
	 PJ8g5GdwigubG/8sdPd561U1cq/nz1IJ/HObPcAyY5efhfcc6qlcl6Q30dl8SPMAUk
	 /PMv1bwq6JIXQGN8OTgznsGuBJ6lY2t439A/w5zd5ef6GtrZH3ZdYJBQVsNQ8LZRmu
	 TqUGRjWwBoUmWxYacFWZq7RDSBEcBcj4tsP97duk4uLntxPkmGX6YC2s/iWq5nsS72
	 2vPciL4Ab5/xQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id EC40517E13C1;
	Fri, 28 Nov 2025 19:52:58 +0100 (CET)
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
Subject: [PATCH v10 04/10] drm/gem: Add huge tmpfs mountpoint helpers
Date: Fri, 28 Nov 2025 19:52:46 +0100
Message-ID: <20251128185252.3092-5-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128185252.3092-1-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA0E4100004
X-Stat-Signature: cf7c5pmg9k4upi1uggsjm7tgi158o8e1
X-Rspam-User: 
X-HE-Tag: 1764355981-870487
X-HE-Meta: U2FsdGVkX1+IbFP74M25m4/+R4aHkPIZ3L2914p2qSL7V/Hua/ZIzPBVqnt81SEl3l0Ihuao6kY3f7sBabQdaQb1STqdvoUj+C9y6+HZkljy+3qJS0dfPzjWcV5MSHOGZ+z7ABxdRaGBdpVLplnSaT5R5OVSYU3bkQPbxS4eem6IjJiP93pksN0JBQQLP+9RXl2OM0bYx7x6YWdotyw9Ytbh4sZ5couYqPzNaUzkXkZi9/MrfjIAihkF+OCAPcZsTI3k99TJk/2kthkKWuvQ3SnybEUqOggvhmoBN1YCYpTdm+NWktWhE+PTOe8FWMZvtnFDkSExXUEGfAAmOk22LoJVlIPBVXHdzZzu2IbQ6HEGyJt6pfD37bMueb39XYGI0mV1aPRlLhjB9P5VJ2z3gAoTYPhawaGVPfbzHx5thrBOFK28ylspa/jl3ePnlKi4qwbVxsa5ri53YdW0iUjT2sRSnQja6jwndx+IoSyKRCfxNslKQK0uj4w7moJAONkUvLafbxXjBfJKISX3obUxahMDREutOHcHXajW2LtpwEIjUHuB7mxX0kqAyZR/qOxY226rn7Lht4DlK4sbGwa0zxTtjsVUrUulu4rQ596D9L3OUfTl/EO6/bEjGOUi5vhdlFxNL3ic0S56N7xogyI3tp+idecZktNxDFTDpQWq2zootJs8YWo2MRiMu2xrc6cV3on8oI52HENHHjEqHzw3wWIcNROaN7ucvG3ND3tm6psOSNh5UOkRBcywwkg0nAp9T3mpLNScYwwg6nFCH97uyBqCDiEdiGYdnHFIghCvBHZNX6cETKMGD9Cio4irCtK0EoR7wFgUkmrzutYRUOWcT/LWI5hmsYaqC5Ciw2PVzekV+bE4yF1i1930F8ISrLNYoF3doktWK9Lv1/42wAbcapaYZEdV4AOUB4WPSonsRs4ucnwYMHq7PEgcaUwe2La7ObfB9LUU/RJLLGY32D6
 5mkl84yW
 r+Q1A4eHQhcVkLaJVt/n7CuOqlP8AwGtsPbti2RFDCINXA9YXUGeyTb6ujXy494ZJHnD3MZvanjHD8TAU9nod+jx6lbzCwtYcQY006D4nS7H4wqFqHoR7ft4RX2dFnQxOKqD9fcHN0IApOoKFbrVpnDi7ULDZEJrGIvZVMTuw4cvllcbFJULPm0lb59tXPuzsg9bTz3vu/4/YQrxau0DppVdfk4JKqRa3X5oTsoOz60kuvuvIg5ONbq6inCMTiMkUWNos6fv3gYZ7x+YAu8A6HJ6g1bcYKSvNGqtBr7efTt8rzBDEF+Xpvyxu+s/CHxFK3s7Y6IL566FVakpf+9OdKX1S73obnmXMhl1+WiLsZnZU1DrN/6Mr+e5x+VQ9hfC+ongF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the drm_gem_huge_mnt_create() and drm_gem_get_huge_mnt() helpers
to avoid code duplication in the i915, V3D, Panfrost and Panthor
drivers. The former creates and mounts a dedicated huge tmpfs
mountpoint, for the lifetime of a DRM device, used at GEM object
initialization. The latter retrieves the dedicated huge tmpfs
mountpoint used by a DRM device.

The next commits will port drivers to these helpers.

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

v7:
- include <drm/drm_device.h> in drm_gem.h

v9:
- replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem.c | 57 +++++++++++++++++++++++++++++++++++++++
 include/drm/drm_device.h  | 15 +++++++++++
 include/drm/drm_gem.h     | 33 +++++++++++++++++++++++
 3 files changed, 105 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 41d344c270a7..94e5e04865ba 100644
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
+	if (unlikely(drm_gem_get_huge_mnt(dev)))
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
index 5af49c5c3778..7dc560ad14fc 100644
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
index 7c8bd67d087c..4e9ab5d294ac 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -40,6 +40,9 @@
 #include <linux/list.h>
 #include <linux/mutex.h>
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+#include <drm/drm_device.h>
+#endif
 #include <drm/drm_vma_manager.h>
 
 struct iosys_map;
@@ -492,6 +495,36 @@ struct drm_gem_object {
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
+ * drm_gem_get_huge_mnt - Get the huge tmpfs mountpoint used by a DRM device
+ * @dev: DRM device
+
+ * This function gets the huge tmpfs mountpoint used by DRM device @dev. A huge
+ * tmpfs mountpoint is used after a successful call to drm_gem_huge_mnt_create()
+ * on builds with Transparent Hugepage enabled.
+
+ * Returns:
+ * The huge tmpfs mountpoint in use, NULL otherwise.
+ */
+static inline struct vfsmount *drm_gem_get_huge_mnt(struct drm_device *dev)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	return dev->huge_mnt;
+#else
+	return NULL;
+#endif
+}
+
 void drm_gem_object_release(struct drm_gem_object *obj);
 void drm_gem_object_free(struct kref *kref);
 int drm_gem_object_init(struct drm_device *dev,
-- 
2.47.3


