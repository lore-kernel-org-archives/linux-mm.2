Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 307E9D116FE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:17:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4B8D6B002B; Tue,  2 Dec 2025 05:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD526B002D; Tue,  2 Dec 2025 05:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 885E66B002F; Tue,  2 Dec 2025 05:17:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB506B002B
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:17:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B81551414
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:36 +0000 (UTC)
X-FDA: 84174129312.25.C5BF6AF
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf23.hostedemail.com (Postfix) with ESMTP id 427E914000A
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:17:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=aoxfp54t;
	spf=pass (imf23.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764670654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mCrmSDMOROjrLbceWFhJy/9JisAvfMvvwSwMuXsr0Y=;
	b=Rw4UMjGN27c+rGCpji243oMSPTDNttBtNgM6bzHDdy3mgkEKWkhWTp2g4Y8xwTIaQtFTrH
	y2Ie1tfv66zv9O0WBT2U9287eeBACOV3dPdIvQnzCdl/lr/hMlcX999tCxFwqcEenRViM0
	MJPKasO7q2z8H7H1YSmFEq5jAesBwco=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764670654; a=rsa-sha256;
	cv=none;
	b=7gHIpFVfWLqbOWu4yX01RGgq3PBk8vKWGDCQvKLylrCMqcsRvw5AwD7zcnb1ymR9JZulVm
	us3zr13yB5mUcFBznNi2TBzvkQ5O1gCQtUyBrbeYsLH6tBNk+1BGMnkND4hpJrHEaqpR6T
	gvAij2WZ1Z9C3380lYeyaCQS+0bdKJ8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=aoxfp54t;
	spf=pass (imf23.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764670653;
	bh=wyWso67v2Pmj9cYL41opZ0W8Md0EXL6qC4U3K6oFpbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aoxfp54tiIpKEvnoXToNHivMgiHJcbiNwhnrwAj0coi+E+b84NTgqUy4uxCj8o0NB
	 2+Swvb+dl4aG1ct8xDW7YTw6ubXhH4z4X7eiReWrXZQYFR2vZyduHR+ppHcX50qJ6W
	 7tn6cbPDPM7fzDSULcGhmZT4howHqNgMCVVuQejjBm1TTP1FcrSfGVwrIC6OYOcnU4
	 WxYn4vqK1tkbJCBz8vRF4p1BR6janolAvCutJEzPtZcKQdc2Mhpjebwo43KEk8k6P/
	 qPii3Rv1U6aNc/QJeGk/Rcd8Nleuq32YmzvDem1r4hjBMhzqjBGlo7YLQneax2tHdp
	 MSr1Dq+WFY5mA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2C73B17E1341;
	Tue,  2 Dec 2025 11:17:32 +0100 (CET)
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
Subject: [PATCH v11 09/10] drm/panfrost: Introduce huge tmpfs mountpoint option
Date: Tue,  2 Dec 2025 11:17:19 +0100
Message-ID: <20251202101720.3129-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251202101720.3129-1-loic.molinari@collabora.com>
References: <20251202101720.3129-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 427E914000A
X-Stat-Signature: kr1is8czghwrw5htkqceuto54pjo5qgk
X-HE-Tag: 1764670654-93663
X-HE-Meta: U2FsdGVkX18Gfx12v4McOXEF4i9V3CWHLQLSA+KgHxQiZCHwpKatuGbJVZ3o25TSpxOkthfsD24G9bCB6kNA9HVIMiKh2WsDna9tLtYZBLQFCT1YOkEgk7lj2D/5bW4vhxufLY9PL2xe2D8/BTNj6ag3qZC45W46wfEwgKSAuUe0BE5Y3P/FtLTUikRHLWUF3ekZt8XbTvkXBQGx2nyrcwT4OYmxmi1bY1aTuJKcFTTtwi5IMNKRGxtqpgXEAJtWlq35LozfCNcszfK82pkCeBP4PI73UI+JNglwZeJTjgP6yytfsULE2jf46PkMF8B2m21KY7J26qMHYjscZn/kQwO0QYnVal9Ua7Ag1Agdc6oYC/StGZP7AhqRpZd15rbzSNixxiT7xjyF3waEsvP6+VUymDuNxfhEUGd48bEE+l3Nmcc6jnw5mdYCUkgFR4c+WC+KTKxJOshRXN4mjJ/7bkEL2S9V1w8wgzBtEASJ8QZBCC305zrtspeIlMcOB/rGB2UESejyBX9dbcd0rouwtJfWrqABb+YbXkquDnY0T2oIBbTR+7X2xaBpU2B0XnTY2XAGjn03yPa1wXDylpGwIiek5rWZHiUZYtN5ullDR83E+5lPjdICP0ITXtNfq26c7jlIp3dFPrSUNOxnpYziOwJUEpAVsV0bdO90Dcwn999sTuxu3I/bWlUP+jp2odsIoIn2h4MdhJWgtw23hk2w4yiC3GE3+zM7/Ilj+YbKpEX+c7W//P1a9m3cURu5J9+f6YJST5UVXEtTjN13vQicpR82EhIo+c5LSCB7rND0AQTpdGc2N7WIo4gDdO/wQv3aVFkU+hf2GB6CrGlfyQT5AGxTcdWbtMNyfwkQHpnEPunADdMmDa4baQYIRR72AIcHTwBmwJvkeZDkoC6fwoQTMP+vVbT/lHsa+Iwye8JB/34hfV9drCK4VC5NP926rCWGbgKf8UFL4QWF2IYm1G5
 8RgQoJPt
 YNcqEc+HxkZbBeztF0+92D9hknVr9NSZQOYd7gOMDNQCx+qe4Fh2jTT1baApkDRZK3poROQLjng5LTsaq4BLk++/fHcPN5rCvLvqOOHkQ4VIp+qC8fvakuYrKsLfL+maeV4TVNVNqq2Mz3iTlsHxesG+XuVlYC0/r4qAW/zs5rLXsJhce2zOW9Xqya8h+MjUt4S2gP7yKjUtvrmoKgvxprNJRlA+2sZuG62Z2GIbxq3wH4dkGaDgbvHwROkYd0DWgbcYxEdh/NY3h9cIXI13GChsg9z8xebo+tQRQL3ckhpYgPWgrga8LXlA5usBKldyXTypsJwU5j5I0e/OnzQELepgsZQWRu8z5KRBqvkrkMmr/oG4+14feC73ZAw2BsylEAWCqx6I54TpqFS34ETgV3b5DMJLq14tPHFWxwhRwwVPpC+T32ED5B0dZIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the 'panfrost.transparent_hugepage' boolean module parameter
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

v11:
- enable 'panfrost.transparent_hugepage' by default

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_device.c |  3 +++
 drivers/gpu/drm/panfrost/panfrost_drv.c    |  6 ++++++
 drivers/gpu/drm/panfrost/panfrost_drv.h    |  9 +++++++++
 drivers/gpu/drm/panfrost/panfrost_gem.c    | 18 ++++++++++++++++++
 drivers/gpu/drm/panfrost/panfrost_gem.h    |  2 ++
 5 files changed, 38 insertions(+)
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
index c61b97af120c..dedc13e56631 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.c
+++ b/drivers/gpu/drm/panfrost/panfrost_device.c
@@ -12,6 +12,7 @@
 #include "panfrost_device.h"
 #include "panfrost_devfreq.h"
 #include "panfrost_features.h"
+#include "panfrost_gem.h"
 #include "panfrost_issues.h"
 #include "panfrost_gpu.h"
 #include "panfrost_job.h"
@@ -267,6 +268,8 @@ int panfrost_device_init(struct panfrost_device *pfdev)
 	if (err)
 		goto out_job;
 
+	panfrost_gem_init(pfdev);
+
 	return 0;
 out_job:
 	panfrost_jm_fini(pfdev);
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 7d8c7c337606..4f5f19eda587 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -858,6 +858,12 @@ static const struct drm_driver panfrost_drm_driver = {
 #endif
 };
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+bool panfrost_transparent_hugepage = true;
+module_param_named(transparent_hugepage, panfrost_transparent_hugepage, bool, 0400);
+MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount point with Transparent Hugepage enabled (true = default)");
+#endif
+
 static int panfrost_probe(struct platform_device *pdev)
 {
 	struct panfrost_device *pfdev;
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.h b/drivers/gpu/drm/panfrost/panfrost_drv.h
new file mode 100644
index 000000000000..edeb093eb6da
--- /dev/null
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.h
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0 or MIT
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
+
+#ifndef __PANFROST_DRV_H__
+#define __PANFROST_DRV_H__
+
+extern bool panfrost_transparent_hugepage;
+
+#endif
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 8041b65c6609..c1688a542ec2 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
 
 #include <linux/cleanup.h>
 #include <linux/err.h>
@@ -10,9 +11,26 @@
 #include <drm/panfrost_drm.h>
 #include <drm/drm_print.h>
 #include "panfrost_device.h"
+#include "panfrost_drv.h"
 #include "panfrost_gem.h"
 #include "panfrost_mmu.h"
 
+void panfrost_gem_init(struct panfrost_device *pfdev)
+{
+	int err;
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+	    !panfrost_transparent_hugepage)
+		return;
+
+	err = drm_gem_huge_mnt_create(&pfdev->base, "within_size");
+	if (drm_gem_get_huge_mnt(&pfdev->base))
+		drm_info(&pfdev->base, "Using Transparent Hugepage\n");
+	else if (err)
+		drm_warn(&pfdev->base, "Can't use Transparent Hugepage (%d)\n",
+			 err);
+}
+
 #ifdef CONFIG_DEBUG_FS
 static void panfrost_gem_debugfs_bo_add(struct panfrost_device *pfdev,
 					struct panfrost_gem_object *bo)
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
index 8de3e76f2717..1a62529ff06f 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -124,6 +124,8 @@ drm_mm_node_to_panfrost_mapping(struct drm_mm_node *node)
 	return container_of(node, struct panfrost_gem_mapping, mmnode);
 }
 
+void panfrost_gem_init(struct panfrost_device *pfdev);
+
 struct drm_gem_object *panfrost_gem_create_object(struct drm_device *dev, size_t size);
 
 struct drm_gem_object *
-- 
2.47.3


