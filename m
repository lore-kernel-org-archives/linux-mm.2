Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB51CE8D5E
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:03:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD2C8E002C; Fri, 14 Nov 2025 12:03:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B398E0005; Fri, 14 Nov 2025 12:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 840C48E002C; Fri, 14 Nov 2025 12:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6702F8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:15 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3689016042E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:15 +0000 (UTC)
X-FDA: 84109833150.21.5593C65
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5FF86180014
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="L/4+y9DI";
	spf=pass (imf06.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t2oAeRkKQeJaGYZxoKASFo53KRLs/jpWNdMBmA2tIGU=;
	b=QOdCno5cQRI45djKJ3EP5JYi7IpX8iqUmEBa2A54nJxI0QPLsbeTCZ/UOtT6Pu54XkIPtL
	Ef0pjt7vVnTN7H/Ov2NsNbyqvxXB8kNr2Tulc6ghzLV4C17VFDF7o628mXINNc15TDnXqZ
	ndoKPlcQ8akXLEglybcPXaWasHHx69U=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="L/4+y9DI";
	spf=pass (imf06.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139793; a=rsa-sha256;
	cv=none;
	b=sBZgYK0vdpAqxz+DnkmxAEY0lAYRiD8RiwLTkxQEJzQ5Bxw9dkCqNNDm2DnrRAGpHV6fhu
	OcIW8QwCpHl8oXBmAa6FDNGZMlDH8eOnKCz4MXa8lMGtn6ofuUnrkqt9B1qkvuNtE1Nskz
	fNJlMz92Yg1lc1PGri7x3FNb7AZ3ibU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139791;
	bh=J1LKvO5lT6f8z+EXXffI5zwtqaBqmr8C90rm728Ki5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/4+y9DI6CAKANwSkwAp/eXEV8hVWyh0PBiaAnFcie7KF5uKmcCDaPdZFpkDZfe2F
	 7RgDoHyfZ1J0JAVyC0gdSkPzHPx+1QLnESy88OmpALocWJ7k77Ku1RShp2n3DOK2eG
	 PKcSzQTrII62UZ8z5oquASg9vpwq2OXw/poxoNgASssGmRXJwUf3M+Mnh0j3Wq9jgc
	 wTev1jtf1Vxc8v8ZKetrWtKaTpFclf0Wz1pnuHO9QFFs0ZUTnyIGh2hyqhetUmk2lW
	 WleWHjB7k1mZbhT/VE129fpHkb/RlrauMUtekCWnUv1/VWBoDCnH9idrRJ3MyJ9vYq
	 NtqjiPbPoUPSA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 83ECF17E1401;
	Fri, 14 Nov 2025 18:03:10 +0100 (CET)
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
Subject: [PATCH v9 04/11] drm/gem: Add huge tmpfs mountpoint helpers
Date: Fri, 14 Nov 2025 18:02:55 +0100
Message-ID: <20251114170303.2800-5-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114170303.2800-1-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5FF86180014
X-Stat-Signature: k5auxu8ocds47uhz6brsz1ctezorytxu
X-Rspam-User: 
X-HE-Tag: 1763139793-838561
X-HE-Meta: U2FsdGVkX18EkKJkTpac4iSowH/JeCmEIHBCPUrbp3gkIbu5eteqgsID2ewSxQy5lSQmKxLabb4J9/R4xAR//o1KPTc//iv9BhfBjACr7mXlLgmQO46YWNQpm+Fx/D1eTJQ9SaC+NZmapbSvsv/O5OJsZonshOv/DJncW5vADGeFu6Fn9YV3iPmBTIda7oX1jchLnd3NC7otkIpycp0t17s2SnsXYJ8O7xUxo8WhhEw56EkiNCXX1hoqpj0Qg3UeXTGwU64zBAE/ms/yjJ7Rn5kMI2pHujQJFyupa8/SGGyCkWi9wOAffVhvzxR8ntKdhlk/VgeMzDEk6G0Urk/1Y88wDvr6CAoMS43Omr5WrU8RSsIHLIoe5WAFZ2KDNweXj0Xr4magm+B55jAkrwekqw/TO/6TxSbx3U3S9EeIJJsgjbRdkLwekvvLBw6VgYyoYX8zmucsklzUQoQE6pKQb0yROCH+2RIqTdU3XuXIDF7Awg49LVG2Weal4TAjqftgrgzZYMbTWuEtIAB69Mltyhg02NjRLuF2MiFrmVKzDgcfopRogb+tWT5BewzRA2EdX+Ei3ufF2Psz323iS/tmUy9A/FWUKR25stUaHp6PUa5q7TZHF/Pe4A0HV0OeTbHJw8bpeF1ftP2Q3mnFLI9YsrAH43Q/YsphgNhXCnFbam7N9z+aWLDNkev4OMa2eZ8/OdNe0an3mznb9WdOblaQ1qEHxCy+E0f+dpLWXev8JBT59psjfY3OKkdcmXCLU19lcyNrit7NjahY4n+qn78ku4UK/e9L0uN0fjHjXwOETAsVdjS2xHzYnWKhA4FA491RmeojnrG8A5fUXMrLi8qKFqsMdcQ1tPafRQNNfqM5Ax3iSk2UVKuWufVF6NnEl5kxzsvcEsUwPzHsEZnaoFpFxgAH2JIsdyw/VjY3GwxiTv8H3A9uk1a2/QeH/2GKQXvqgW67XfcTMQALrMa6zDS
 VFRXQ3Rs
 Ev+CbGDQ1ynFvnitwTQJkStAlJQHRVyNAYWAnGZ+ejYU9HruD5dqUj68CLW1oqLYDHb9S1og9jqHcgVLS6nrHnX+q3whfFSd+9p87AiM0AW+UJiBPONBrlWR98Usu8jJ8v2H8P3hK3LJABJgryvgz0bTL96j12f7xBU0I+KTeApabPJ/hAxrSiIgYKVPIZbeStgPTzJUZYVZWgUrbQudfosiVMmmgtsX9pj+8/Dvk/+5cG2VuTs/WvFxiEVDOyBa1jcof1n50JgkQRtMTjOfIjwqqMC0S7+lXTvv1OPQKfFUC4pzspL2mM74yYkDf6aJZmx1C7K/g6HvWGAF/TcLF1kZ+4kscd3Zn+0+hxRZcJSL1kcyvR0ZLAlSSdf0+LL0cHsx0
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
index 2a0eecc0d3e4..ec549130744c 100644
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


