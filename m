Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4DD6D116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 18:53:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0C06B0095; Fri, 28 Nov 2025 13:53:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C3D6B0098; Fri, 28 Nov 2025 13:53:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CED6B0096; Fri, 28 Nov 2025 13:53:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5026B0095
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:53:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC4A8140718
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:06 +0000 (UTC)
X-FDA: 84160913172.14.48FD776
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf22.hostedemail.com (Postfix) with ESMTP id 22193C0013
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=JDmoFm9s;
	spf=pass (imf22.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764355985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DbIJX9DzAKJhkx12Cskv8I4pSLOofExD0X+tQlLeP3g=;
	b=iQa7OyRdQ2ZkqJSXgKts+Bj5h0HZCiZbt3IHiZDR7xWjvoY5NoRNw+YHnb86OC2C5NuywB
	y6V4JNroikP53oBwYdV0JnEwVBdb0noQkd0vNS9QdoDvKK/KfwlbPFJkhWbTpB+/Rt3hhW
	eqFITD/E87cYNZqaitYgL4ApTjY0ncE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764355985; a=rsa-sha256;
	cv=none;
	b=DMnaBh9kLy8ZyvIemQt29nsiM/4La36KMIeGpM3IYBTO33rnk3ZGlPFeayMJ3pe3a8IGwU
	js3AqKHBiQxeSx5QzHIsfeRAaw8ysLXqXIhh+NM22Yt8LLTE4rXvL8B1y/TU9iRmuRD59S
	meQSnFS1weWMLQRvWVCmrZcJ8d00Sxw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=JDmoFm9s;
	spf=pass (imf22.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764355983;
	bh=rZghyx94iYUUgXSZnWKsyKkGP7PLMHmFoXccUZ/6idM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JDmoFm9s0cnW9OJRzi6TevGx3Zhdu/qpHdHHwBI4VprYsYPm8D7/LGKH6UEa7V4du
	 t9H9XpZL2kjcozBu0W1Dc5JdpRXUGvEhIaQnEfKkJYgh9+q7GInfIplzu26PrGC14V
	 Xu408hLFiD0y7YwXkMxFI5XYdo7ErFMHwMq/RgayWfJgDRVOE3aTOZdGVfg6XAMB/T
	 NLUJTgEpYVMfHmsYZ3/mYYIUptsZ0zNq3CftndMWEH+LPfF5SDVf3tqpRdm7Lm48cx
	 qgpSouWEOzXnkl4PVPrWunXnVFFCY/M4VwTMsOPoJPKcEufy1oBT7XRg3Q8hsVUHFt
	 zYQegedr+pW0A==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0C03D17E156E;
	Fri, 28 Nov 2025 19:53:03 +0100 (CET)
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
Subject: [PATCH v10 08/10] drm/panthor: Introduce huge tmpfs mountpoint option
Date: Fri, 28 Nov 2025 19:52:50 +0100
Message-ID: <20251128185252.3092-9-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128185252.3092-1-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 22193C0013
X-Stat-Signature: a63fexi4g1wigg8tke8rqhrptybdjuuy
X-HE-Tag: 1764355984-535713
X-HE-Meta: U2FsdGVkX1/d7gVzBI6Ez36BgtHcrFaCbkVtbXWStORZUFgSNNcbZoDUpjv7Pmwpt2tOIxfDBAMaOIpWwSblvWtrwylsrsaJ1AzYUUhtJBgtouKfLhqWEErL850usiFET7nKdWzfmIke6OkWRzS80islM0/e9bfNz6qnFNDKQmIhMEtrd1KePW+AnIA1rTW2VgPxOqJH33wrg49jNUDNjnLQFC2EcvUoboaqOo0JEoNvrtJZCVT41k64MJO3O0RigfF6dfGR33EPupBfa5noI+NJUseRtWjyZKe4t6BKUkjtnB3sHVS6w/1QJscY0tXuLXpKo2a0pwqWWc8LyWXmLX2E7KGvyQsL6lCXLRZ8mG2nweCm0d+040gJTrTSSUdjbMcikwIntdhkqN+7jOZYGO1cdS0p+9wx/oh9UZVdKZQjuC/kTTu4Z1YquMGnOa28J6z1CTShb7dj35/SSoXJlGVu2ENk8BlWRiDN8Qg6Rge+0AMq/io2oSSMk42O8XKdnyWLbex4w/kf5rCfe03rKNbT33AHZMYgxK2KeRW330IEV6isXJWQD2xBjyO75pDUUxoFwD68a7Sx7kdiL6If6+1KHxvlw5HPvrvberSD5gZ8Roop7gwdVZn1Dto4Tup5dhcTb82JTHg3BMGKqVcfYcHVv2KxqCDU51bOAUV/UUUxGpsJQm2bf7eq3U5CGqBeNuXkP0lFvOx9UJY2xb6ZNZlNcsZGCq6EEGbe/G/EMokR5T9JjHlW52CptqpiOjHK9R5DbReVo5CGl1tG2S2+dyFcXU4bx17jQlUDB/N49rbRQZhouSRtHrBK1N3na2t7Ddp66OcUqXf+nMrkhcsy/ck/KMqsFpYZH/DDRVkuQMim85i1b265qIw+odxlOILaxfK0nAxlcsmaO1Mr6jnEEFjZ3u2CcA0URbPIHHVWhxu/THL4HVDKVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the 'panthor.transparent_hugepage' boolean module parameter
(false by default). When the parameter is set to true, a new tmpfs
mountpoint is created and mounted using the 'huge=within_size'
option. It's then used at GEM object creation instead of the default
'shm_mnt' mountpoint in order to enable Transparent Hugepage (THP) for
the object (without having to rely on a system wide parameter).

v3:
- use huge tmpfs mountpoint in drm_device

v4:
- fix builds with CONFIG_TRANSPARENT_HUGEPAGE=n
- clean up mountpoint creation error handling
- print negative error value

v5:
- use drm_gem_has_huge_tmp() helper
- get rid of CONFIG_TRANSPARENT_HUGEPAGE ifdefs

v9:
- replace drm_gem_has_huge_tmp() by drm_gem_get_huge_tmp()

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panthor/panthor_device.c |  3 +++
 drivers/gpu/drm/panthor/panthor_drv.c    |  7 +++++++
 drivers/gpu/drm/panthor/panthor_drv.h    |  9 +++++++++
 drivers/gpu/drm/panthor/panthor_gem.c    | 18 ++++++++++++++++++
 drivers/gpu/drm/panthor/panthor_gem.h    |  2 ++
 5 files changed, 39 insertions(+)
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index e133b1e0ad6d..2979ee0e52c2 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -18,6 +18,7 @@
 #include "panthor_devfreq.h"
 #include "panthor_device.h"
 #include "panthor_fw.h"
+#include "panthor_gem.h"
 #include "panthor_gpu.h"
 #include "panthor_hw.h"
 #include "panthor_mmu.h"
@@ -294,6 +295,8 @@ int panthor_device_init(struct panthor_device *ptdev)
 	if (ret)
 		goto err_unplug_fw;
 
+	panthor_gem_init(ptdev);
+
 	/* ~3 frames */
 	pm_runtime_set_autosuspend_delay(ptdev->base.dev, 50);
 	pm_runtime_use_autosuspend(ptdev->base.dev);
diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
index d1d4c50da5bf..55dbda6dbf9c 100644
--- a/drivers/gpu/drm/panthor/panthor_drv.c
+++ b/drivers/gpu/drm/panthor/panthor_drv.c
@@ -1559,6 +1559,7 @@ static const struct file_operations panthor_drm_driver_fops = {
 	.read = drm_read,
 	.llseek = noop_llseek,
 	.mmap = panthor_mmap,
+	.get_unmapped_area = drm_gem_get_unmapped_area,
 	.show_fdinfo = drm_show_fdinfo,
 	.fop_flags = FOP_UNSIGNED_OFFSET,
 };
@@ -1626,6 +1627,12 @@ static const struct drm_driver panthor_drm_driver = {
 #endif
 };
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+bool panthor_transparent_hugepage;
+module_param_named(transparent_hugepage, panthor_transparent_hugepage, bool, 0400);
+MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount point with Transparent Hugepage enabled (false = default)");
+#endif
+
 static int panthor_probe(struct platform_device *pdev)
 {
 	struct panthor_device *ptdev;
diff --git a/drivers/gpu/drm/panthor/panthor_drv.h b/drivers/gpu/drm/panthor/panthor_drv.h
new file mode 100644
index 000000000000..79dccd289881
--- /dev/null
+++ b/drivers/gpu/drm/panthor/panthor_drv.h
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0 or MIT
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
+
+#ifndef __PANTHOR_DRV_H__
+#define __PANTHOR_DRV_H__
+
+extern bool panthor_transparent_hugepage;
+
+#endif
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 10d255cccc09..7ae07a9bc996 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 or MIT
 /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
 /* Copyright 2023 Collabora ltd. */
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
 
 #include <linux/cleanup.h>
 #include <linux/dma-buf.h>
@@ -12,10 +13,27 @@
 #include <drm/panthor_drm.h>
 
 #include "panthor_device.h"
+#include "panthor_drv.h"
 #include "panthor_fw.h"
 #include "panthor_gem.h"
 #include "panthor_mmu.h"
 
+void panthor_gem_init(struct panthor_device *ptdev)
+{
+	int err;
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    !panthor_transparent_hugepage)
+		return;
+
+	err = drm_gem_huge_mnt_create(&ptdev->base, "within_size");
+	if (drm_gem_get_huge_mnt(&ptdev->base))
+		drm_info(&ptdev->base, "Using Transparent Hugepage\n");
+	else if (err)
+		drm_warn(&ptdev->base, "Can't use Transparent Hugepage (%d)\n",
+			 err);
+}
+
 #ifdef CONFIG_DEBUG_FS
 static void panthor_gem_debugfs_bo_init(struct panthor_gem_object *bo)
 {
diff --git a/drivers/gpu/drm/panthor/panthor_gem.h b/drivers/gpu/drm/panthor/panthor_gem.h
index 80c6e24112d0..2eefe9104e5e 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.h
+++ b/drivers/gpu/drm/panthor/panthor_gem.h
@@ -136,6 +136,8 @@ struct panthor_gem_object *to_panthor_bo(struct drm_gem_object *obj)
 	return container_of(to_drm_gem_shmem_obj(obj), struct panthor_gem_object, base);
 }
 
+void panthor_gem_init(struct panthor_device *ptdev);
+
 struct drm_gem_object *panthor_gem_create_object(struct drm_device *ddev, size_t size);
 
 int
-- 
2.47.3


