Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D313CD8CAC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D5B8E0015; Thu, 13 Nov 2025 12:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DD268E0002; Thu, 13 Nov 2025 12:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5309F8E0015; Thu, 13 Nov 2025 12:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE448E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E59795C440
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:18 +0000 (UTC)
X-FDA: 84106196916.08.D4096D2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0B5D540013
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=kGFZSJh1;
	spf=pass (imf07.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0aY04lOY/CCuWlgh9pgGDrSjRkpor/EJ9scCjjW61I=;
	b=7Brj8iklEjqXjFHTwyIOKO/jDoASr1w33TgxfAueI/qZJmlw+RbyFHqM4PAb+RnaFJCKHi
	NNhT1b9Jh8R19HBV/HOtyfluXpyQiKDjY7SfcUnE8iFfrAy8NE9guJ+OpFZI82Ss/XDeTo
	0iMq2qmc5594KybmseS7Y+5MdCZL8nI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=kGFZSJh1;
	spf=pass (imf07.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053217; a=rsa-sha256;
	cv=none;
	b=mc0ANdbZzX1+FnLDvfsW4Lyj8NlhcA+sh5HP4z/vQEVwEQRu8hyhb/gPQOzOolNu32QI1f
	EGcq6acwWJ1WgLOXjy9huxVOMReZD2rlJ5u5YJ5meU8yHMe9dBkhoeO31Rp4ADXyatF58Y
	nnffDFLTgPIGeL3NHO7N5rSCcKKG2Wg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053215;
	bh=CmZzkccIUL92ZcDISbCLHJ25kFHzLgptyvzB27dAVN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGFZSJh1j+du/b3O+6loVm377l5bUfm85KkzG32kfHAY9ZkMWPv833vf+Fsr+RQf0
	 bIEXstf0vjjSi22WOl+teQgIYy26/B9LWOWg45N1qrbUg+/5jdgbFvcEoMIxNxmqov
	 hzdXp3vzCkWuMY4eY8eOdIAEyYW7FzW7JgRuXjqai9kPkHbA3+9VjeYnM8TuIx5rs1
	 MFY/PwsyOguqHk8RHN85p38xD5ALESFA29TpZeTaA/LFogurlJLFqbobsRGBQ0wxCW
	 vfPYcv/F6wuFQZykguEU0mg+VOEnG1p1+O4Fp/aBQw+5v3jEMv8pJ33mZbAr4Yru7p
	 dEFIe6YDvM8mw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1B8D117E1340;
	Thu, 13 Nov 2025 18:00:14 +0100 (CET)
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
Subject: [PATCH v8 04/11] drm/gem: Add huge tmpfs mountpoint helpers
Date: Thu, 13 Nov 2025 18:00:00 +0100
Message-ID: <20251113170008.79587-5-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170008.79587-1-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0B5D540013
X-Stat-Signature: idnp8gyd33oj63pyrfnf4m8iuk46a99p
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763053216-773859
X-HE-Meta: U2FsdGVkX1/xcnuD3tIPckOHUhtBMspELGaOHSkQIta6tCuyimq4iNCzReplivHSdy4TsXrXMMPCQvlf7IuQ4BZ7IrfSmo4RPp21ne5D+N/KGUdwDexB07txWcr2mrfrFTm3mVIgM17a2w7JeG2ZZW8SuYAk515sSbY3JFnVEQrYeEbo6xjGJYO3TUh5uAY1Ba/5f3HGB4MYIyMbNI0jGmizrgIHA3rNM2CSMSe5Pjol0MByQvLifMfSGkYaZlFKTBU3UYAKPaar5CFU7AeL1pDovLfrbC8fcBIN+3emyQThttouoUmahWwCNTjWRuZFZuB0uobqsIAr4oU+B1dTPP1byY9ec4xX1PnWM/kxnvUPHFnHBfr+Wl+tbKSaZoxLtUh5Q+bZMx8gED+EuTn9mdrhzyPNnghHRuS2vldOqomsWXfCZcgmAs2guqWss+gXN+GFtvyybdKndIMctBNORkPING7w/nT6V3vbm49x5RkzrwCAs2ZLkRt53iolrI7UcCHuJM2v9jZE2sDuAIEmQosFAYP/pZUUfI+CIVoY9m1k4MscBdLYpGSd/JcIfJSZMkZAVhZSdQyqPtzNxBKmN6rxPXzrO0i0+B6RfpXrhviDlcXO1fyhE+dBQI+EOcx/uA+NxdQhJebnjyhtdvV6IgVG2+kJGGsfupnR2B9+mYgK2mYIf3UJcYw2OUQO7coo0gplAsUty9JM2W0mhM9A/dbSsNWE5zSLD9z4wrfheWJuTwcNZ1ByzdFFSmZ6wR0JoNRt82mJNI43BXiFupHoV6FDH8UWBKO0/0PQn0/BY133vyp9R6UhNPXFLVmhcGwDA1QwrTErEN4fAwYLCeWTUPQABibzi1+QStOZVsXZlcfZ5h3+LrL/SOgeYqIf7ujjPj3BKiMmOKs0gP2Ri/MsvhT81vTE0Vmx1BEHFu9kLNHFAPIPOxDZ5u7VFouaJTKw6kB2IvQPAC8S/3yvDqY
 EQJSEI6H
 T93bE0g5MGmP3Kvl9aQragJ+vfzgr8+g55Xt14aPAMo6WJDGcazM8iIue7Oj+iBMRX6cf8ymtiV1sl+/NFEpWAdvylGD5mf3n0Nm1UjAbQFI5fxpXKZI2jZ2SbBmaDD7u+AG+ZtGWOMNhpJSmC1ModF4bseXYoH3RBJBzZ1IRTXps7HYqbArNi+kPwgzNAs/VHf39Vek5c3bVw79Vhn00MKECSJJcW6Znk8XqLkddg4OzHmoXJN3bgCqpVVQ5tvVk91N4ihmAb/Ue/5PktlmEm2KSjpbD9mS9Se4eFYGjGv3FFsDjdI1qYEHFGLb/5Xy4Y1vgo5V5F4j5VxJGJNMLUpWRskjbb3EPR+NfsccLA5MCLmazQ0kmUykgL6vdY1E46zdP5q0wNJdWuUCq+ePVXAQ9sgRUpXKT5r4RAWxYRZ17B75ENkCrNpo8iF/65GxMakIP8MJPvUxOWevSIatIQhjRvSdAlJDe83tmFrY6T892JRBv6QIbXj+h3A==
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

v7:
- include <drm/drm_device.h> in drm_gem.h

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem.c | 57 +++++++++++++++++++++++++++++++++++++++
 include/drm/drm_device.h  | 15 +++++++++++
 include/drm/drm_gem.h     | 33 +++++++++++++++++++++++
 3 files changed, 105 insertions(+)

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
index 7c8bd67d087c..58fa1e6b9773 100644
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


