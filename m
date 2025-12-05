Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBBB6D2F7CD
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 09:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE69D6B013E; Fri,  5 Dec 2025 04:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97836B0140; Fri,  5 Dec 2025 04:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37CA6B0141; Fri,  5 Dec 2025 04:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92FB46B013E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:12:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5BFAD51B64
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:29 +0000 (UTC)
X-FDA: 84184851618.08.88D86E0
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8B48C40006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=iDZ32TT6;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764925947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlkV1iBzrDLIZuPYBOBgasEgZU4g5pRj2/PrSq9li84=;
	b=MnkARbCUCaHAEV+YGBb904FZsymXsyiBmecRVbHVD8meIEjrnTeVqfKGBNeJG4BR1q88pQ
	5+7R2JWIaergkNeIrnRsTGh/iMPT1WDPmDk/Tj5lDSgIFxqzsQmCyldx1/kX9reXP2C7b0
	A0FOcSFVFXxIhb3I9Y1N+aZhaUJu6pA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=iDZ32TT6;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764925947; a=rsa-sha256;
	cv=none;
	b=IOjB0tysByzX/cI3OSTdSF7QvQZZhXCQGawEKawcNsgQVwTAYS12/cJYMbWQuVHPTr9KKo
	3bhcm/NsKGDcTmzMX7OwFt5PeILo2rkURTnXPbw9WICOe4SeQQKbiCo3nXbHvppnhCAppM
	3G+0ubAtEbaWidkZKJECIKgsGUpSf10=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764925946;
	bh=9th0tLAngJVGd6qH652rQnjACAMqlVf6KbfxdfP115A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDZ32TT6H8iFGyCvNNO1TJ6VEiuqvfBFgZt3zhsS6GkUzB/PzYfUNqY0Efe7YTbiQ
	 Ryvih6SDWs2H0o28Sn/1r3T4aXN/NQ9saKc0r9H5JU4BeT5nefgrkICyyxFa/2DaO2
	 PTzrN9/H8niEVYl/tREio4W0689SsISXQ//znVm1yP5zCMuqC1fwdpvhGRbsFNPdHL
	 CncanFrbgnNo/UHSQk3rSaMldFmIamDifWyXwUzhZX/D43btUsvQcOo61VPfXquuA1
	 Licytn4KjyWSU0dNRYf26tXA7ogtfiq6epJ/k2fZfNEYspZrnXMM7V5zDTxTDso4d3
	 OLcxGpFbol6Cw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 247EE17E14DD;
	Fri,  5 Dec 2025 10:12:25 +0100 (CET)
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
Subject: [PATCH v12 04/10] drm/gem: Add huge tmpfs mountpoint helpers
Date: Fri,  5 Dec 2025 10:12:10 +0100
Message-ID: <20251205091216.150968-5-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205091216.150968-1-loic.molinari@collabora.com>
References: <20251205091216.150968-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B48C40006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gwh5dto8ghsepdhkfbx1xzhsj6hpbc18
X-HE-Tag: 1764925947-432438
X-HE-Meta: U2FsdGVkX18d7AB3/o25bzEj7GXbGiu43I0EIze9NYW0MEjrAhR/xE6qn5vShArxUt2+qqRZafvAJBpwrQhb9YJTI26XEk75CK7f29IX+y+KVXhwE0pIUmag07Y+alC+8uy4z8QJZGCa77neymkrLnf4Rb0bY4631zOCk8y9I9w6f8k13qeL9eI90Qsdv3X3YXxP1Upols4foojkJ2KWBbPK/bC5Zi9easiwqyUJEbHGADe9JxH5XnSyvl6qaXeQtuvbaCZdpC09jOjwcu7M6SQd7gkkDSCvdRk38JzdOlKdjlaJQjeCWpuBQlciJi5p6Rk0jVR96zLC6a52CPRrYnMvlpTw1e/LIuXmemWv37vEWGz8Avs1Tne2NVAd+08csjq2W0uuIcxFcrl4JCJc4anQ4n8+Z9D6ODM8nC/lkWdFXYm58kM/IQK/SdAbh3Sdv2yhulNLUzd0RBOM+OWghM3DdWuDFLkc2d5iNexk+XNlO35zkNrMyrR4AgAGtOenmPnmOeOj7/GSTp3RlIo8J2I827d7MvhDXnjc7mhG73k7PYhjAmxfjsaK3RpH9MNTOgafoVwofXLDsbz6oWVHnbXzWyQRMtP6tI+4ElisDHwwacpJl/Ij28AhFYMRF+KbdS8brgh5Eqo+UFtfn/7D+pyT0nAV7SUUNr57yUBm5J/bUD7On4OeowywRPGLYXt6LQ7nFO/c24PMkVA8TxpSQJZ9jSWQG2aDGG82LH7+vIGO7JLraGvbnT8iQAMrP6rhdbN51y8+6am6uwJ3DJ8Jk4I3ruN0OVunxybjPYOuvJBd3dcZs57dNhaBmVk2O1roYzL0MVQx3gVGGjzku6I6F1e8YzKU+UAxGQyzOHTpE70FsmDNuBS4nd4CIkPk9Vcc1ah0N8r14TICySlJP673dDGA15hyfjguP0NJWlj258InV1e7g/dNnIZbRTPFGcdIIGKmE6Vs2We6XDqrUxl
 1OiS02hB
 50DJU/odjGOCptxxt2gDrf/e4WBRiOtKpTQS7MKqS78e1HzkEWWMI5WMiT2YymwU9dNKPH/38ExZtHj3mNnrtD9++ROPYEi9RSTcWKet+JEFeB6FqguXnOgvf85Ll7y99daz1++3ESoajX8j4HXBIGfUeTKGW6iUP5bJaqqO+nNr/Pv0MeQhy0Sc4ekizI6xue79x9VJY1rKgd2hNvUHX8LvJb16hpFxamsPmn4ua4bydQSgetT5+IbGFKCEHfecFeHIJuJsTWWp7Wvs1hlE3pcxivcpnax9i405qntA478VfrAdnhzHjKWViHltC1Fghsq03l4Yh0I+ZW6UJ/hizqElcZqsWWehMpPCE5+g6SvvdpnPRK5ihNXLG+pSMHHjfPHRUNJUCTequ9Fit17CvF1gdfAoDsxhsNYcci3LI6mJQkruhjWpPzWohKK8HxFB8uRBp
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

v11:
- doc fixes
- add Boris and Maíra R-bs

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
---
 drivers/gpu/drm/drm_gem.c | 57 +++++++++++++++++++++++++++++++++++++++
 include/drm/drm_device.h  | 15 +++++++++++
 include/drm/drm_gem.h     | 33 +++++++++++++++++++++++
 3 files changed, 105 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 933fc89dd648..32dddb23e211 100644
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
+ * @dev: DRM device that will use the huge tmpfs mountpoint
+ * @value: huge tmpfs mount option value
+ *
+ * This function creates and mounts a dedicated huge tmpfs mountpoint for the
+ * lifetime of the DRM device @dev which is used at GEM object initialization
+ * with drm_gem_object_init().
+ *
+ * The most common option for @value is "within_size" which only allocates huge
+ * pages if the page will be fully within the GEM object size. "always",
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
index 5af49c5c3778..bc78fb77cc27 100644
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
+	 * create, mount and use it. The default tmpfs mountpoint (`shm_mnt`) is
+	 * used if NULL.
+	 */
+	struct vfsmount *huge_mnt;
+#endif
+
 	/**
 	 * @driver_features: per-device driver features
 	 *
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index 7c8bd67d087c..97b5fca8966d 100644
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
+ * tmpfs mountpoint is used instead of `shm_mnt` after a successful call to
+ * drm_gem_huge_mnt_create() when CONFIG_TRANSPARENT_HUGEPAGE is enabled.
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


