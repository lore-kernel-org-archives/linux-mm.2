Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36432CE8D55
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208008E0037; Fri, 14 Nov 2025 12:03:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B1898E0034; Fri, 14 Nov 2025 12:03:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0789A8E0037; Fri, 14 Nov 2025 12:03:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1EEF8E0034
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B18F588EA7
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:18 +0000 (UTC)
X-FDA: 84109833276.18.D21CF01
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id D668916001E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=PFFELhgS;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+1urB75DVLk2pp+iQKi7oI3mlLPKzljc4RC/euUK/Y=;
	b=cpekXDbvx/k3iEcpOhPNvhrM0d9WHjZXJ1RyTjiYEO0MQ3AS7fPh4Ocvoe5xt85ajhTHuv
	nOPN7fmqta1dwEsmXXSLmwPIDNE0LoWXTS1uDMxK85MCtOngyRkUXh5evtv1UHNb/gO3rX
	uMdYkD3D8sjEZEjSLSZjVwuYDdUp3A4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139797; a=rsa-sha256;
	cv=none;
	b=i0UrKVK9NXI4ivSK8j7OfAwCt2J0WPWj89TUlFye3fRVIWeZMckC6HRQd0ZciOAC3/nu8J
	guqqSQjhkQeVZUhw/VNYAMTGLWfPVIhQ0tDQsn9ECkS8GCMm2cjg3k40JS6bG/v0z32Bv+
	a6EJimqaDR3r0JX88QgJiNe9rjYdtis=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=PFFELhgS;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139795;
	bh=lRwauJY45yghkHUPVD34PRex0BOyOxzNsCIif80qyHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFFELhgScQ+MUwIZxw8tYMpXWxtZtehauXYu1yBJcDLc14Gr2RWZw4voTBimlNsGL
	 WFMijVo95mU7wXPeXQE0GBwIuUhBW9KfxjG1fv8GvEfHKrHsmlLXXyrN39kvC/5nFH
	 0cT+A4cZhlwUsjlD1fYRIkcgnvmwNaAjpcEeSXExpsd+BtBcqRaWTISGkCqcyIKh6+
	 39w7rPEFqYxxJp+QVfc/44iCjUyJcm3OJAqC7Xx+2AwoNnJqKcbjrMN+97bnxDawsx
	 Eocxlli+KQAAlbJRUG1ntN6rXD3hrlGJhsADrMfNxkk9GDG57qPragg2PzPXtnxDgn
	 ByITAzc7EnBMg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 93C2017E15DF;
	Fri, 14 Nov 2025 18:03:14 +0100 (CET)
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
Subject: [PATCH v9 08/11] drm/panthor: Introduce huge tmpfs mountpoint option
Date: Fri, 14 Nov 2025 18:02:59 +0100
Message-ID: <20251114170303.2800-9-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114170303.2800-1-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 535xx6181hqcjg13jcfnjxznniuzxnfo
X-Rspam-User: 
X-Rspamd-Queue-Id: D668916001E
X-Rspamd-Server: rspam01
X-HE-Tag: 1763139796-189758
X-HE-Meta: U2FsdGVkX19PIC6ClK/ZJ99Eo4kqGmuNyfZ2pTkIOq3XudGy/tLejvvZsd8Ttx+iE1Ngw5DdBtOY8hySXsUlocl474g6nBk599M9LXZDYm4Ui7X8MSSo3XXPdDt0UR+xztM47t7UM2Cxg3DgX5QbdD2G0WUAclCVb1pD8SioqsuqIBK4oCkJNiiy62w9sosRbALldMm+N2I6Nu7uqKThyGkJE0nLdG+gRZRoFOPiF5ciVUkrhcn+OLa9/sAWiRb5JTEUIAglVUKeGLx/SpeOJMw/+hjnI6BMOwR2m0ZaSLAUXioNgj/oqP1kEHjWHNVGLKnheLHw0HNA0VEaertP5iRW5JkF3Yy8O/9+LpPnriQlGVRA8zLyu/x5Lzi/kGNpR8bEs5jZc6btl53G6/s8DzHBDXLeeslVdQ598Igm1y/I3ywRCFhHHuAD6QcQT1a4nd6nawZzdwpP+rNxs9ri80l8QnU+FbwntcvPFopy+cyIA3lucHSpDDE9cdTsvLvz7BtbC2tlUrxJ10O39PWnm/SmNUIaNGu7d64N4P/IzoomYoXi/EjwQIZUDAkQh7641FJNiu/PHEp9c1gjNCCsC29BqVZJy+4K7kRXervevahy1H8Bacq5nP7KAfpBGDTIjf8pkrPa5hbsiqOlKDa66F7sbq24nn7Cg35R/3FjvswKsmGfGOAHnnwVzzVaWpA/nRLGYQ0LemafOt2tLZMuo/4uqfCozpTikYldCFxoyEaDtBxL161NgAgVvHdUiPiQ6vU9lWdednY9lTXVCotDXNq+Vbjsrj9IU505bzNIuWBx01PQKd/7qVdp+INhPE1p6r/VgMZYs0L/kfyYGBgxwaFR0ekTuGo9IrWpZQyOh362T8bI2mopjfYw4AE0W6ZReTlFWokBYTWRbJKF4G8juEWZOOGlLJE61/TaWjUJNhCmf9ro4eAU7uxNoqz+4v2K/DrQNRxiz1qUYaH2LDj
 NfDPSaOY
 wJ8IIY099iVR6AdlgkIL9gm3iZr8uczuS9AV+vveOBxtB40EBOBq3UzOPpCNvlUCZbLzrKedWpMMps/4eKLaXbsvWrYU4aEvSXDuxX85nRerDN8LN9twXLdSQn+XR5KXr3S3LuciDgT5ufd4Il4RAOwpc7sOTK9tsJXlRA+dnhuCfr53J4rr+O10hRAABoaFNB1lU1hVA8rKm2ls0SE6T23lzfBfMeuTEJHQMMdwxw642QEM5A5a6ftYiczTUJBJvhvPkVPEZJMS8Bbt3WsTqERD//5g+PLadY9EmFjde97LZGlctrz0WPvZl0KCVf9b7wImILDdTH8UiJpHHNZhkE81FXweQNKaeSTprIqr1IFr/vu4VTQGdyLvL+eGE51epNkJyUhTkxq6I1JEpcEchwgl4C1CvI1wn4EyHcxDuszxZwweBuY3SxELPmg==
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
index 31fb8ed68199..b6795d58fa03 100644
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
@@ -288,6 +289,8 @@ int panthor_device_init(struct panthor_device *ptdev)
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
index f369cc3e2a5f..11c01b24b116 100644
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


