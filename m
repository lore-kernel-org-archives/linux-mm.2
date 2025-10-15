Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9BB3CCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F028E004B; Wed, 15 Oct 2025 11:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EF6A8E0005; Wed, 15 Oct 2025 11:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7C48E004B; Wed, 15 Oct 2025 11:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 212C58E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D20A3C0210
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:41 +0000 (UTC)
X-FDA: 84000735882.11.4241360
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf13.hostedemail.com (Postfix) with ESMTP id C594320019
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=anvXxSpt;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nEicrh0MZ+MMU7+L01UwSSv60FCS23MuSKuKYkayFeM=;
	b=8RFKsoRfY76dwSFJ3a3iu1tScXcmTIJ/r40WFeEb2QZPiNsHwlaKFHonIR16HRe2ERWbfN
	lteJEiyaTsMIB1HKe+DvuOdnZdriNbwPRM2x/UZ0RhEa8WB+Wu0TfHldFEfSALm5rPCl0b
	GKMnjkjfnTRmUCZHh49MrPnE5PSdlR0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=anvXxSpt;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf13.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542240; a=rsa-sha256;
	cv=none;
	b=Q5kR4jS2QwuNlqxdknk5X8mX0Db0lhK+Vy3H/C4dmqXxSnvCidnwEm+KCvOwCWBATJLjMU
	pOMLxQNMCOm5060HGROI1DZoULueeHtmHis/TqpTkOP/XagXJ3R92Odv9VZTKlQg7EGeai
	dDF6ubSP4rmxLOPWM453UpBSLwjV0DM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542237;
	bh=2YyHnJ7MG9Sk+eB8X8EQ2czQs/R8vZqVR26EnmlFgQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=anvXxSptCiIgOuEsSH5DjAHWDBZLh4/OWy4y/sLeOha9IsxpqBMOWJtzGnyVjvGr4
	 WQqx8qzJeyzJ7puOnBg7dq6o/RuIDKgWjnBYWcECEJtrlf6nX8RZWB/8dEIL7LZDJc
	 L9HBPWOekFbsGbnW9LvpukRcrPBU2bHB5IPo9SUsO2ycN6l0lC3btFYNbH+Q7CbSDx
	 ezu6N8IZPuOQ6ZC3Y7velZQ80GGHxahF0nrYtgMUixxqU2LG8Cd0z8pnoPxrR5kXru
	 7a+U5qeZ1EMEFPAfuEaHddCtLHMgLPsYXnftfOaedjeszqK5brUqS8SWeTgNMPnnqX
	 vO7qbk4bCp1ag==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0D01E17E0CA3;
	Wed, 15 Oct 2025 17:30:37 +0200 (CEST)
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
Subject: [PATCH v4 05/13] drm/gem: Add huge tmpfs mount point helper
Date: Wed, 15 Oct 2025 17:30:09 +0200
Message-ID: <20251015153018.43735-6-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C594320019
X-Rspamd-Server: rspam03
X-Stat-Signature: pwhfpuoa3ycizqtfhoz358pzjb8y1fr6
X-HE-Tag: 1760542239-488551
X-HE-Meta: U2FsdGVkX19qKHDQPrEimp/8qGDeXK7iVxtXnND9FjIWBFdDeNe8QDk42we9me+qxOJKMYqnZCaMvGBhQktrZgDg09v0yxFyaxNm6ZHSIjwpCcN91HyvBKXgQ+l4oy5HV9KiqeD1xnU5GTaSbGHOuGJ1CZiTPX+MZxwJN1AYRADljnZbYv7xXTcknkq+UjkwyoYZGoGCwZri+niO3YCW81yBpj3PsfP2Jbok9Z3oodBXUqKoqBmw83/gs2oUslIsfAwEsCiFWCfMFnGX4FNYp0v0m+PNIAiGShTVBF5O2Rsz9v+82VarfN1wQB9fjFu4U5TAVscqW7OwOoSH3Xz7ah33FTa8XFLHGqL6m0vR7fqJ+OnNT5SW8jUg8B2iGsJt7uAvFlm3/94cPBkoGvqgTya27UeoPcnpgMh/RlDF3Nc03eY0UnkL24d5SXK0ix3QY7uHCs9hWGQ4q8TqFQWIU+d1pY16Hk5EjZQ5hTFIxawewf3DlaSAh4KHsq07KYJyF1rKaQoqwfNZDCCDYb7nd34X8SHkRExawf/4MwzATqWLSBSE8ukfkkFI5p4LQw+VAgTkOUv1vpiSNEr839w/EODjhfM83Y1SZh+10uvf3n+yQfJM80Uvpj5ccgJpVWRe8ECwkzE2qt7wmI2gyKFLEOpa6hMSWj7a6/Ui+VWKpPWCbYNGuEleKsC1JfIEGWeyKC1eJfOFek6Cq4yuvjBsoBfvtffltqayktH5P27Gr2ESdCsh2TihWj2ZVkr7gpMqMsfbomsWowmvsyxl5qk3lgbqp34032aeWifWupBjfoS4QF+tYhqmbzhvXpx/nhH9dOmOiDyoH5ahDrZszWMNFc0VHXnbnPxxSW+P1g91AYybKI6D5ZWWYvT/CkuqcLWOuvbRx5mRja0DYwQ7QUF3Zg+aLaXxo86bIMiLKxm57WCpdQXUy+VHzwDr2CdwBqEi1DfTOQOTiDGbW8Z2SNO
 /7uUDALx
 u/idG5ZOmrs1UTJkE2tz6pTNqPNlsgKuBXb/BObcIImGGhD0kGFoEJy2LM01gCNfqnWZtTpFSmFdnD+8XG/t9c6Nzj5PtTM7etbspZ+UIbTBa78MIHo/blIO3tPeFyXttDsvodFGGLxiT/48u3gOpOuuzO1JB92iKlUiOikVfbtKCGhPK4s/j1KU/D30HB1DgZdxu8XuPnxKUX8G2RMX+F9Ak2SLttfp57DoHDl2vyGc0+5Xmg0iLJCI934w9UfIiB6hMZrd3iuCPsXTa+ChZg3UA/zhqkS3rPjNWfkmwdyKVPyUHAr7VZ3iz7Co6O0xmsgLH7U7Ru4pWDj24oK2wacQPWTV0Aqe0jl0a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the drm_gem_huge_mnt_create() helper to avoid code duplication in
the i915, V3D, Panfrost and Panthor drivers. It creates and mounts a
dedicated huge tmpfs mountpoint, for the lifetime of a DRM device,
used at GEM object initialization.

The next commits will port drivers to this helper.

v3:
- store huge tmpfs mountpoint in drm_device

v4:
- return 0 in builds with CONFIG_TRANSPARENT_HUGEPAGE=n
- return 0 when huge_mnt already exists

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem.c | 58 +++++++++++++++++++++++++++++++++++++++
 include/drm/drm_device.h  | 11 ++++++++
 include/drm/drm_gem.h     |  1 +
 3 files changed, 70 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index a98d5744cc6c..db8c0a217add 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -29,6 +29,7 @@
 #include <linux/export.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fs_context.h>
 #include <linux/iosys-map.h>
 #include <linux/mem_encrypt.h>
 #include <linux/mm.h>
@@ -82,6 +83,63 @@
  * up at a later date, and as our interface with shmfs for memory allocation.
  */
 
+static void drm_gem_huge_mnt_free(struct drm_device *dev, void *data)
+{
+	drm_WARN_ON(dev, dev->huge_mnt == NULL);
+
+	kern_unmount(dev->huge_mnt);
+	dev->huge_mnt = NULL;
+}
+
+/**
+ * drm_gem_huge_mnt_create - Create, mount and use a huge tmpfs mountpoint
+ * @dev: drm_device a huge tmpfs mountpoint should be used with
+ * @value: huge tmpfs mount option value
+ *
+ * This function creates and mounts a dedicated huge tmpfs mountpoint for the
+ * lifetime of the drm device @dev which is used at GEM object initialization
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
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		return 0;
+	if (unlikely(dev->huge_mnt))
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
+
 static void
 drm_gem_init_release(struct drm_device *dev, void *ptr)
 {
diff --git a/include/drm/drm_device.h b/include/drm/drm_device.h
index 778b2cca6c49..352e3db402d7 100644
--- a/include/drm/drm_device.h
+++ b/include/drm/drm_device.h
@@ -3,6 +3,7 @@
 
 #include <linux/list.h>
 #include <linux/kref.h>
+#include <linux/mount.h>
 #include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/sched.h>
@@ -168,6 +169,16 @@ struct drm_device {
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
+	struct vfsmount *huge_mnt;
+
 	/**
 	 * @driver_features: per-device driver features
 	 *
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 7c8bd67d087c..7285a62d9afc 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -492,6 +492,7 @@ struct drm_gem_object {
 		DRM_GEM_FOPS,\
 	}
 
+int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value);
 void drm_gem_object_release(struct drm_gem_object *obj);
 void drm_gem_object_free(struct kref *kref);
 int drm_gem_object_init(struct drm_device *dev,
-- 
2.47.3


