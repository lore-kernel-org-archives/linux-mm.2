Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90FD1CAC5BB
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F01698E0002; Sat,  4 Oct 2025 05:31:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8FF8E000C; Sat,  4 Oct 2025 05:31:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC58D8E0002; Sat,  4 Oct 2025 05:31:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C28838E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:31:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94C24160A5B
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:09 +0000 (UTC)
X-FDA: 83959913058.15.5D43479
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id B8E19180003
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=V6rPnmj2;
	spf=pass (imf24.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEHGzZxtN8CMejhzlKBVay5vFWnZ2WsgRrbC7ETdVc4=;
	b=5o+iBs+iR0TbENaDZnrXMDdvyVeNB17eIVvE1g8F2ELVH5IxyYo6lIH1VprN+TVQR8e9Z4
	vHU6DzC4TQ5kTtiheCPCm8M3JeDXsTy9O1PVh4aQYg3nqwvnPvw0eDtvEMX5ZWC49VE1o/
	RPYTzsafZigKDVEl5wUoK86GIj3SkEU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570268; a=rsa-sha256;
	cv=none;
	b=Pt5iCQ0h/NE6fWuRal4ono34Z31Yh60pp3OyfaTg/SIUYr4623rZ5K1M6+TzSr4V/SWGUm
	0xsnlTQ/PN5lGQXR/W4+OeUlrSHrHzATiBjFn4xq/+YHzxvRSmvizIxMVERPtblcG4vRD2
	FYd50/+TgXaQGZ01SB17SmILu/tHAQI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=V6rPnmj2;
	spf=pass (imf24.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759570265;
	bh=OboSG3MspALhfOlg3/ftZlyrbUep+HKm9KoLjZD+P04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6rPnmj2m2VBb2rS7ppjLrf4/NU+Xfui7XcYgvhIHfQ9D9Jdzhhye/775mr8ql9pZ
	 ywDGf88dQWTzVJuo638S5N8xYAHd2Yp9LAy/EVoNQFfNzZZPeV1NWgLePVNsrB3Z80
	 NfXzYFGnnjojybH+4fN1Yp5dh/pe+tW/V5Rg4nJxcbg8GZegzbHhsayua3khtQTvfJ
	 s5/Hd6NB5dWoXH5w1Wiv9DPI/oVK/P7Txx2Vqp8bwLAtloaEa1NhYGMWHENJhcMzC5
	 sZxb3XWYx++yLcsZG0SAkzr8jx8wfb1vQdAORuhHs3lhVmq/KI8Ab+KiahllSJIR+I
	 PVlQ+XUcLU4ag==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D486817E13B9;
	Sat,  4 Oct 2025 11:31:04 +0200 (CEST)
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
	Christopher Healy <healych@amazon.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH v3 03/10] drm/gem: Add huge tmpfs mount point helper
Date: Sat,  4 Oct 2025 11:30:46 +0200
Message-ID: <20251004093054.21388-4-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251004093054.21388-1-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B8E19180003
X-Stat-Signature: scgkqyixt7cofbddoafxjfpntd1adzx6
X-Rspam-User: 
X-HE-Tag: 1759570267-321110
X-HE-Meta: U2FsdGVkX19/HTBxyPrcZSqCryYrKNJasBk6wcKkG5udDtUCPlgxDKkqALyWK4pv2ex9E7UkMAjAcdFgUFetysUJwOOvyFI+AoBmm4wRpWwTAERyt9DcA7n0bHaikxlkCD6R0QV/2ThDsR6MSSqvWLzF0b5KZa3RDWIhlG+jRwGYOM48kMeQk6/Y1zaQvc2ebZPSgcEGMNwNv7bqys7yT2HBYfNghnCSPnJwlvNqIt51iWpamUjbT6dmnJzZw04OD9x3y5ZEqjJbGTEl6rnxMIVGtVipR6MxGrCyV71lvpUoQQ+AxFTFrfPwxEeBuFraGs+o9oV375n9nh77soJKpp9elKg9PG2C23+AmRyMTusx36Q9pXI7oYrbU/VU+tvrrT5RK3Cu845BE53DB+KzMpfM6YJCIbiebiohSACYhjrcHYnLKtfHrRjGWk/pl5vflkt9ztZX2NsnMh8nvb5sRSAIijU60Dtdf472iBwFxqXF01jAPtanR+OePT/UtLTwwWp4ruHGgo4MyZhXUxjy5RdC0LWh+rwfyZivftCYyaM8WMbGshJmFFIzxXb1azNkjJMn2bSw5y7cq0NJqinpTM31hC8cI8Ni+PSTn1WiCHCh390YfArm4PWkrLGarHYtrG6RmYp7xHnKV6fIsDMGrwspsjU562QXfR6SalwLTCaqWk+rb2Qh6qq4wAXhZ9uF9RYlKHMO0ipE1bzFJYRC8xDqaHIkp2o6DM7jMIzJixzE4u2i7HtDtL7jkYNQB82SLgaYBU2++336SpNwZZo9tsLftX3C0BfBAAPW172dVjPO8pKF79aieiU4bLJdBzjLPnIS4VUJSAljDryVpFpfJ9DJYdCNBU+mW2Rhsja+NnQHtvrgEDckciPSPB0hc4GLX0tZ8x76dadLrFbPOr6xQOexXfx6pqggL/zC0QsLidi5Tkm9QmDVFGX1uQeycLN/aABVY4IkhCqFIuwvMRL
 /q+lTOwT
 Q9r8SCxES+HPs7xH4hG+XlPNjkQ5g6GNnSyooXXksK91iDCvN//0tbVIToLXoZGZZ8i/bZLOhs1YMJU+rNFHcan+Aua79tZiEz7BT4FofcnKOCKwfQJNspOh1JKup7y7UlvRxlI4pTJ52NveNHpsnp3CSc7Vo4do+Z0I3sG0iqpiQ4UM35L+xO/e1/PDxAg+oChNc8EH9Txou4PQq7cILDhe4p+S/jgEcvSS2zRYJwqF6CGe9urtJx67j74feVXx1P0mX9VBvIioVd3X/ilLjCzJ9oaS1+9Czorc+ssoDmrbZpzsSFF+BvCGwikLVMfTzlP482bcWALc35MuxnEN0HSfTZC9NxJb2MV6ueCIm61Xw4ACilzyIto9Hw+bLTleGBxbE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the drm_gem_huge_mnt_create() helper to avoid code duplication in
the i915, V3D, Panfrost and Panthor drivers. It creates and mounts a
dedicated huge tmpfs mountpoint, for the lifetime of a drm device,
used at GEM object initialization.

The next commits will port drivers to this helper.

v3:
- store huge tmpfs mountpoint in drm_device

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/drm_gem.c | 67 +++++++++++++++++++++++++++++++++++++++
 include/drm/drm_device.h  | 11 +++++++
 include/drm/drm_gem.h     |  1 +
 3 files changed, 79 insertions(+)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index f5a10ff363c9..b4e4947210ef 100644
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
@@ -82,6 +83,72 @@
  * up at a later date, and as our interface with shmfs for memory allocation.
  */
 
+static int drm_gem_add_fc_param(struct fs_context *fc, const char *key,
+				const char *value)
+{
+	return vfs_parse_fs_string(fc, key, value, strlen(value));
+}
+
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
+ * 0 on success or a negative error code on failure. Returns -EEXIST if called
+ * more than once for the lifetime of the drm device.
+ */
+int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value)
+{
+	struct file_system_type *type;
+	struct fs_context *fc;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		return -EOPNOTSUPP;
+
+	type = get_fs_type("tmpfs");
+	if (unlikely(!type))
+		return -EOPNOTSUPP;
+
+	if (unlikely(dev->huge_mnt))
+		return -EEXIST;
+
+	fc = fs_context_for_mount(type, SB_KERNMOUNT);
+	if (IS_ERR(fc))
+		return PTR_ERR(fc);
+	ret = drm_gem_add_fc_param(fc, "source", "tmpfs");
+	if (unlikely(ret))
+		return -ENOPARAM;
+	ret = drm_gem_add_fc_param(fc, "huge", value);
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
index 59fd3f4d5995..895b0ced972e 100644
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


