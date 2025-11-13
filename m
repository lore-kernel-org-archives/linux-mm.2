Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2518DCD8CAD
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9E68E0019; Thu, 13 Nov 2025 12:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 381E68E0002; Thu, 13 Nov 2025 12:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FC0F8E0019; Thu, 13 Nov 2025 12:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1DB8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:23 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB8571A0A79
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:22 +0000 (UTC)
X-FDA: 84106197084.05.CF130CE
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id E151140029
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Lk7BKYZF;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUM7GvdYOPnlj5T4ZBbxtNIGCGDzjQmCzsl0lz7p84U=;
	b=SpxHaMK3nRoQD/imh/px6LU/quGAocsiPFUh9Mw28PkrfuFz86R7L5tJKWcjG/rqfXzAMT
	hgRWm7xQtB6Jh3FEJjNu8wFhi5ucZr7UvQCtHEpkojXHODXuoTqlN7nKDlY+noMxy6va6B
	Ylf1F8ejq7xaTfxpd44ZN2EaUVbKr5w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Lk7BKYZF;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053221; a=rsa-sha256;
	cv=none;
	b=nDkpvreQHkzJXhKHYYUDOJj3GXLTlATRZzJT5GXP4BSMyV67c68cxytzndFFzXglKpmJgL
	lAneYBfJ2OImSAgfrB2NWr/ffbQdIEtSsvz3AZIdCMJd/141GtqcTd1S9XF/z8tq8Bsuda
	KgmLQlJfiDE4PlkZ+D88V7R6x7yVnjY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053219;
	bh=yPuKKm3SVd/KQk4btyBTtMSqWra657FZvtEg6/HJexU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lk7BKYZFFLeaCnw+lbnG/48XZMOYPoWX5RMq6jsbsw5FPWib26m2yACgqu9g5h4Kn
	 g/A+qoPcXqRBIVkdHxUXpuYdvetHHoLQVQbIjpqfoXDixs1dfw86QN5i8IfTe9KrfI
	 sY6lrtkBth5kz7zNMu/zu7AGrzSrO+kmy8m+K6T/2ndQkhhSY/VFzfsz3CaaG6R6nX
	 wh+ABHr2IvklDVy4d4DBy7OfZQfTLZl7lyhHj9uUdU7hd21wvRkMg5KJe3Y0y4TFm3
	 faCfHLrFNTT8pv40BD5fy++FPo/XpX7SzB+4u/yIBMbcsmTGMhC+UKDyLZFpb1x7fL
	 4fr4gx0CHZaHw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2D4E917E13D6;
	Thu, 13 Nov 2025 18:00:18 +0100 (CET)
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
Subject: [PATCH v8 08/11] drm/panthor: Introduce huge tmpfs mountpoint option
Date: Thu, 13 Nov 2025 18:00:04 +0100
Message-ID: <20251113170008.79587-9-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170008.79587-1-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E151140029
X-Stat-Signature: rrm1naufeewud6oerar77y3n6uinibet
X-Rspam-User: 
X-HE-Tag: 1763053220-438507
X-HE-Meta: U2FsdGVkX1/HeoNvkRHyROWBqbVZJKsv4k7re4DehLDFbFZ/8t/Ez489t1XKv0KhO7PiH1y0ztHuV7mbZL7D6UwKuoWkl7DO1v8Bl879lQEGdBpoYtEhWnK95DeZEnOQrL87ChJG76S0nHt5Lzmjr5jMgOyhK2rwo9kuHBZxv+uuJjNyNeQvTy/8LAzOEEwu9mDsRjp2vMdXNmAO/sM62TSSDfKKP79Jz74LLefatv5At8BIo0VR1AuuxCPHEY8e5b8xToymBFcOCgBCOYFkvzxGOSGAycHSKpzsa1Dep5jMwwcw+fTS5PJlNwZ86EN+cyx8KN/c0WWw/ZZ2fFP6zuaRlohML1rJ4rtNsVVoKt7QyNphPPfliGn5jvaYnJV5+7VchFriMDl8OoFPKnWaidGfVTnzEZt6imShh4UhRFyFcKwsbdtxMKP+hTdyX+X070uRlMgb/EHZzF4YSCOhhGBMfEMIzQ891VuIJ3rRc8uhFQ9H3Uo495HSj+9Pd9ftQZ5ZS8mlOZpT5n5KkhKehmGZ0GRZgMP/KcwTlh849Qpz0jyHyyZycJi2VzAcClo0UnnGdpuG+kkPqdrO3TIOVky56LA1hqo4vb2V5cSq0FaZN5AxQEDnQTcDUnHyfyg6vbJY2M1v9tCBZFfvgHY2rz1jyqACN1+1eEzSdFG9D/dcauJ8Wzu63J5JueMaXVEXfYSaYLb/nsclK1Z76LUOSyFfCTpFZiNVoKYZoWE3ruC24p5Wf2nsX7jffn5+9qPqMsGUThWKlLhyxjL9+HRJMzBP+/S8dc7KLQ3Te1y3I+tDVB94KylYyjU0DoQ+SKc/AsO7IV9gR09Y/esageWhAv2vaPhItjkOkNEguQeAOWvlXro+7iZzL78SI2zzyyWvl3Tqui+0/0cTE5fBsshifRzP1qCyyfw5RGyLipF1Mg3uVtYzsp0S1NSHIOa40wJzm+CGolxJ/l+96ePuWQi
 2TxyEC4D
 u7Y4P5XbQCEtWXhSMdfuD4D089DfEMdi6cbeBDV3qMsH+6+lk3zWFRQmX6DQblgI4lZMMfF5sggZzPZq4nGiOAoVo1PwEaBQ6fiAgHlq/wlIK4Ca9BHPzlqVuH7l9nofvZtR+0FlkVtk/FurZ3nEaNNO27/GDHFp8vnsRMyEQUbPYnsXqT6DLTCqAQ0bumc1zunqCYPhAzHNDtbwoadI90wvBCuGdVGYqTX7dKID+krHBIVCzbgJVmvl7PCWfx8CWdje72bgV7FZXyh0Gn//oPU5GwBdXiEErPqdNj7o+IuXdhNNcdp6Wk8qtgE3KrqjJB6uULPck0bYziN0U+8Jp2nssbNejA3GQV6hbfD/LrmalCd7/YRNcwOXdnZGIObn77aWjFsqVaao0307H3ShloyMui4xhYE/ph5vK9TPokjoWpAliX5A2RnvSF1ugIXEnFHepCwhSvT2i+amrl6WnC8DYjja0DBjqHiVOkYdyqJAFf10AfsB1UgCU/Vlc5H1DE407bodndM8Tvp0upVAqJHcyVcq2KKDypcRHEZrtOvv+iikhzhX0WiZ1cw==
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
index f369cc3e2a5f..d9cc70739121 100644
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
+	if (drm_gem_has_huge_mnt(&ptdev->base))
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


