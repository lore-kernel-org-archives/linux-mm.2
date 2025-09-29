Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D84FECAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA038E001B; Mon, 29 Sep 2025 16:04:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333B58E0002; Mon, 29 Sep 2025 16:04:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAA58E001B; Mon, 29 Sep 2025 16:04:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7AF8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:04:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2FC013B20B
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:46 +0000 (UTC)
X-FDA: 83943365772.24.F97352C
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id BCC7416000D
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=NsPTtOcO;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759176285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xd9cjtwfKMl7aEjEQBdyk9Cr7NBfpJdK6gwKaSfeIUM=;
	b=i9m9eF3YoTDHF4Lx6X1M/RjcM635LKgZKcUrtwvGDhORGLHK1GMHEtXan386GUiNL/ARqV
	N7mVdH9cUEbAriLABdfMcsA+AzEC0VGe1moHl+cZUPxgrLDa1XTb3p7/fLXXjI+x4fvfGT
	6fuKv+N6VnsnCN5Hnxx0y3k+ViFyRCE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=NsPTtOcO;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759176285; a=rsa-sha256;
	cv=none;
	b=6RK5vSmrdEqK1Vy9ttm13BSuDDRKaCd+0sEAfNCwsKDXHybtl/cqE0orzgmQcFVMxm5PoY
	VxiIXwx23llDvFKFhW0CjL/R7tp+/KjWXbFMtOgbWxXzaABiTTKRHXO4HUd0yWJ+CvdTUT
	Eg7r5MmgM9jXi0GXkpe49/U9a8XDhK0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759176282;
	bh=a1OTsZzaI6EEmq0fje1Ikud5+W73fZPK2sKTjtGd50M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NsPTtOcOEHo6cW63wk9JJipS+qzyQ8sHXNj879h5rkribjPEw84HRvxMqHaQ05b+w
	 J4gu/pYX19JDrTPCdtYdGgBhCljDur2Y0f87EiLvGPFbW+2WgHVFyVGVO74UcWa68m
	 DMHCvcE6aHxYRJzvDjzd6sDC9hBILg5/ODsLdhO4QW9vsz0uji7XZDaPQgKKYtYXIe
	 Lbj1KfzaJkRMDrFWJIE3j89nZHkePNMj9Gy2mZjK1DgSJhXGyfA2j42ErLmYiTQ+uY
	 b3qbqt8R1+dcN0/jlJzVu74LmXZq3eID+eqlVqXYDERTBJmBMQ9sx1o+Pe5UtDOB11
	 EAdeyoJizW/2g==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B4B2A17E13D8;
	Mon, 29 Sep 2025 22:04:41 +0200 (CEST)
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
	Andi Shyti <andi.shyti@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH 3/8] drm/shmem-helper: Add huge tmpfs mount point helpers
Date: Mon, 29 Sep 2025 22:03:11 +0200
Message-ID: <20250929200316.18417-4-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929200316.18417-1-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BCC7416000D
X-Stat-Signature: t8j6bdjse7wgdzzuwsnbjm6theqeuzuf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759176284-151693
X-HE-Meta: U2FsdGVkX1/Z4fQaaWntkcI4ujC1PmfNFc4X5dmyNstHLANOxES7YkAHKwT+jkl0+gxaEwNFeIzvBLQCk5DV6EBEfMjuZEmeMpoLVElPUDMV66uNSiZPOS6tehF8q8L7BGf7CT1Un7RCLEgW9X66704SKLDH5VJeYWpfnHqClIlV7OQDfl/ppN+QYoSvgCbZ0IPg9MJG7yQRfnqv/J98b+1B2ETQy8vbXv6na9DmtvqN1yA8bWYlkHaOCp2pe8jwgnkauk11dM1f2Ws4G4IFcJNRCdb3AtfQyhF0F/msT8FC3WisYOi2ZP/pMxYdcdpDK4uhYpwdzvhRqV/RwsSXMZW9JFB+aYEngngyYNJzpVNstOPegjH9rqxDOtxNTv4rJmEgr2wMtsz1R6IDmFRxTq1gwktPl/kqV0CO2+Lj7gpuZn0JwONf+e2k3UQSD4Goi4dlyBpc7WMWfOuBbcLxAO+R2RVxNPt33UhrI0WpHGdx3FQcTO0RW52rWwbT0Xp0hgeiMamQEJExdPn+H34NgA45w8XDldaoMYHadWfBoNRT4vWyDmD5nvG4MIII9dWNRzN2TlkQSHSnTcVmhJc0fW3Pr68gGpS81KakuZdhBOCh5t78qPrCMoqgwnuvJsgprqr76Q5JgmKEOj+XYCmZkxUMNdk0f7TDtAAft0KbJjIcfoFEbNgBBiEAuEA3i2dnX82kmlaMX0qCisB2fq+jSmNmicr41EbG5MA6Jr3fUjCrsfVxCv5tpHTKbrAIJ01XwHGJb25Gq7k3jdUfUTdaw023yHb6shnhGEhr2LJxc31zesDYZ84tiDp7B+V04dMxplkyR5eZecRH1rGkSGhUI47xWeicDDquGwCQ/+Q+6AI1tbAcfMpNxySdSL8Kgbhpt2+hekyTbjYuR3FSGhsMZiOi2ivrILqeNtTCNo8lv4D11bGHnK3hSup5aTh63zy+4V3Y9JIcNYMPs0QIpEy
 1dniSkAp
 GjEZgWbSM94sls2dmxwkLyLha+R6VnBr7deDw8y5ofrU3/O05++dzgk0ebS6wL9cE1BrfxGtdl6rxepDpxxMMEiRBX67OFa5IT7qMo/1CTdJZvkDv8DNjct5p8zgU0EKrnT5E7p4hsTYUO88Sarz9lyE8JRQqlnaPB7rBFNCfRk8xDN89rUeIcuHxt3D37pBK1+SWgz0C6LHAmtvuN6HeldtR5QqgvPSCJSGg1G1Vtr9uj+0mOg7i9H6NRXWToEBoTQuWKWJ87Kk3J/EyJdmK/UfulgdBbt2a7yTQD1ccG+P8lvwVhY0k730tCvhm2B4FKP0ZIA0+x+Qz10O3mpUUukGVrV314X3/uVPAwxHqtRJoSGHXy9YnpZaz4n9xgxmVBtQdHMOuNSdtOnfDgVginv7GB8MKVXHMSNlle8xYrJ8TRsM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the drm_gem_shmem_helper_huge_mnt_create() and
drm_gem_shmem_helper_huge_mnt_free() helpers to avoid code duplication
in the i915 and v3d drivers (and soon panfrost/panthor).

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 56 ++++++++++++++++++++++++++
 include/drm/drm_gem_shmem_helper.h     | 14 +++++++
 2 files changed, 70 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 22c4b09e10a3..808721b8be3e 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -5,7 +5,9 @@
 
 #include <linux/dma-buf.h>
 #include <linux/export.h>
+#include <linux/fs_context.h>
 #include <linux/module.h>
+#include <linux/mount.h>
 #include <linux/mutex.h>
 #include <linux/shmem_fs.h>
 #include <linux/slab.h>
@@ -36,6 +38,60 @@ MODULE_IMPORT_NS("DMA_BUF");
  * drm_gem_shmem_vmap()). These helpers perform the necessary type conversion.
  */
 
+static int drm_gem_shmem_add_fc_param(struct fs_context *fc, const char *key,
+				      const char *value)
+{
+	return vfs_parse_fs_string(fc, key, value, strlen(value));
+}
+
+/**
+ * drm_gem_shmem_huge_mnt_create - Create a huge tmpfs mountpoint
+ * @value: huge tmpfs mount option value
+ *
+ * This function creates and mounts an internal huge tmpfs mountpoint for use
+ * with the drm_gem_shmem_create_with_mnt() function.
+ *
+ * The most common option value is "within_size" which only allocates huge pages
+ * if the page will be fully within the GEM object size. "always", "advise" and
+ * "never" are supported too but the latter would just create a mountpoint
+ * similar to default "shm_mnt" one. See shmemfs and Transparent Hugepage for
+ * more information.
+ *
+ * Returns:
+ * A struct vfsmount * on success or an ERR_PTR()-encoded negative error code on
+ * failure.
+ */
+struct vfsmount *drm_gem_shmem_huge_mnt_create(const char *value)
+{
+	struct file_system_type *type;
+	struct fs_context *fc;
+	struct vfsmount *mnt;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	type = get_fs_type("tmpfs");
+	if (!type)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	fc = fs_context_for_mount(type, SB_KERNMOUNT);
+	if (IS_ERR(fc))
+		return ERR_CAST(fc);
+	ret = drm_gem_shmem_add_fc_param(fc, "source", "tmpfs");
+	if (ret)
+		return ERR_PTR(-ENOPARAM);
+	ret = drm_gem_shmem_add_fc_param(fc, "huge", value);
+	if (ret)
+		return ERR_PTR(-ENOPARAM);
+
+	mnt = fc_mount_longterm(fc);
+	put_fs_context(fc);
+
+	return mnt;
+}
+EXPORT_SYMBOL_GPL(drm_gem_shmem_huge_mnt_create);
+
 static const struct drm_gem_object_funcs drm_gem_shmem_funcs = {
 	.free = drm_gem_shmem_object_free,
 	.print_info = drm_gem_shmem_object_print_info,
diff --git a/include/drm/drm_gem_shmem_helper.h b/include/drm/drm_gem_shmem_helper.h
index 589f7bfe7506..5e153fb63f38 100644
--- a/include/drm/drm_gem_shmem_helper.h
+++ b/include/drm/drm_gem_shmem_helper.h
@@ -107,6 +107,20 @@ struct drm_gem_shmem_object {
 #define to_drm_gem_shmem_obj(obj) \
 	container_of(obj, struct drm_gem_shmem_object, base)
 
+struct vfsmount *drm_gem_shmem_huge_mnt_create(const char *value);
+
+/**
+ * drm_gem_shmem_huge_mnt_free - Release a huge tmpfs mountpoint.
+ * @mnt: struct vfsmount * to release
+ *
+ * This function unmounts and releases an internal huge tmpfs mountpoint. If
+ * @mnt is NULL, no operation is performed.
+ */
+static inline void drm_gem_shmem_huge_mnt_free(struct vfsmount *mnt)
+{
+	kern_unmount(mnt);
+}
+
 int drm_gem_shmem_init(struct drm_device *dev, struct drm_gem_shmem_object *shmem, size_t size);
 struct drm_gem_shmem_object *drm_gem_shmem_create(struct drm_device *dev, size_t size);
 struct drm_gem_shmem_object *drm_gem_shmem_create_with_mnt(struct drm_device *dev,
-- 
2.47.3


