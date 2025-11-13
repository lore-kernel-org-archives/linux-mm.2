Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EF92CD8CA4
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 17:00:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0287C8E001C; Thu, 13 Nov 2025 12:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1ABC8E0002; Thu, 13 Nov 2025 12:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBBBA8E001C; Thu, 13 Nov 2025 12:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA58B8E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 12:00:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82B7A160ABC
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:24 +0000 (UTC)
X-FDA: 84106197168.01.4416501
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5E371C0011
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:00:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=f8C4RoEI;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf10.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763053222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++PepNGLjda06HDSzZr6zUMp2L+H8I2WGjEaW+3VRbc=;
	b=Sn+WIaactqQruZLR1RPCK79XPbRzR61IbBss5inHTDTVZGmXDhhg7j47K1iDA3ZXFJGh11
	dnkAHdLlwJ5ISCVBACYsdOMBxsd1QTPXu68bM4APBw7lyn8AdyATWi8+LRBcX00PJBTKZ7
	+4dRkw9viFK/WbjzAdEFZl7zxNBXrhc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763053222; a=rsa-sha256;
	cv=none;
	b=p3mLPgG2lbeAo+BG6HwX/DorX2fKuYTSwNse0heVBctL6nE2hkhiQASKMWAkA+BJlwMWxm
	Al0U4A0C9jESJN46Bnfy678U95oat5iUgXX/S/ZkcFCvphVnCmMDdvPWdVKT8rhbM7UKca
	9Zs50zyrO7WJA+cVIMDI6Nzdktlv+og=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=f8C4RoEI;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf10.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763053221;
	bh=zYBl/Dqp6Izqq1kQ5gjEICYJes4BCUnNwwCmCl6OpvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8C4RoEIQl4ixC4AaSJTwU/a73ZdGP3iO7JtymnuRD46ZnGLlrX3zXIkeMEE38ivH
	 NWbHWsSVmZVNJLMesX2GA2qEEIDBzOywRh7KpHLr1Enc274iJMUSR8OVGNMkmJkUNT
	 qB4i3GRb1r5qfpBPWiZFYzPrWXoHV2a7w8BWxMzRP7rSAUkUGt7OetJFHHe5bXUwku
	 xALRb4jhPjFNJBLQAZMkwsEwlSgRMdKiCIVdnq1H3tzw1Sb3Nbjvo0Cynx/QCK2zS3
	 lK2uWqC1sH6v4LLyNA3y9ph+dmuiy0HOwT/dAnonGddOVEq8rIkVVsDV4dSsUrWABy
	 PqW485btNwz6w==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 35F8717E35D3;
	Thu, 13 Nov 2025 18:00:20 +0100 (CET)
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
Subject: [PATCH v8 10/11] drm/panfrost: Introduce huge tmpfs mountpoint option
Date: Thu, 13 Nov 2025 18:00:06 +0100
Message-ID: <20251113170008.79587-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113170008.79587-1-loic.molinari@collabora.com>
References: <20251113170008.79587-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wzaonm3396zsn3r1tn87ed4cza78xk9d
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E371C0011
X-Rspamd-Server: rspam10
X-HE-Tag: 1763053222-177649
X-HE-Meta: U2FsdGVkX1/8fHZ467KtQZBht6/Ba1xUfX0Jpas6z98taesi7iSN/Y1Jhufty3BEoO+Lk8cpwbVNSruFz0xY8ih8DO4OJP0o6yUT/jSWwThSeU8Y6LvNXqJlIq7/VYD0S2VoXoWO7aaPCQCEj3In40h7gC3+WfbKZ9VeIlxrWL7m0CEcfVmfVVgO2ihJP3JK1YtHuhIkt/3x/b3mSCR80vEA6dQ4IH/mD9LMPuvthHIHQedYxeenWum/qceeixXtRoLXBGUVi21NwQv9harjipJ2+8XleAZu1zfzLl3wM4ARMIW8iRGqcQVcPrNeAZgfoKt1jKMKH8IpzLuyrMCuEXPuKjpafIS0XHudhR0j27uLfetnHMDTb/NZrL+wedLE1nfYAAVU2tyjOq1cCk5nz5r7VZEjLC1RZT63DM6sLLq6myjy8ueLClVuGaGH+mEu+3/B4V/tFs9a+y5XLDBpSjjYyo1sihQnpISLsj2tKeNxzhfNvhU2KE9T3pyIowLsJMyB+8gby8YQqeVkc1zl0FZQ1nCjr4y4HY6uoxlhBwS757G3BbwDrbxPCeVixOpH/dFR9hCeWgNCkAkLLm+yRTCARwXLXzNuro5p00oYEwhYdNrBXehvtMbDmhNXK4uzRIrh0avaHwdh3yoNYs6bB8caIBDm4ab8qrNStPBKQXeWw3LLQxFj04+P4NS+B6sr40mIEhB3MFdEeZySUFAps/letJTgQNuwG3NT1hHwOP8yog8xKVNBRK5OVARBgEDX192S7kEhK70GtgPBWapFmK66+0PWDihOFjDEkBKSbsss46Tpa+MV3PbJFuvERT9qmkj+ZQLc9JwE/wJNg8Rv024AvlQL3PISM8IHC955Tikt9dwch5mjXsUmAJXSYEYf6CZK8u7DOu7BmlNXxiucaRF7sPmigIHnq7ctJJAectSwONtnU++AWDdPnzz4Fvn7pywReaFwezBXY2e437I
 hW8HflvT
 VbptxthdNWxos1oCF9/n0GaMeuN192uJkHdkMbaHm0l3TG7FaWzPZsVMFLWg2v/j1qHH4lrlZcM7FhdgL5a9B370IYXYSiJaUhPzPhVhK1Xe5HpjQaVHo/WtapG3XaIHAZbHu6rpHGPyhqUH80xcqDFB5O4SCawuA8JSeiabkroB/qbXXyWPWM3W3v3pQJzXAbLbpCv6HiSuIrFyUqchee4Hz+K+s+Eoaj2mq/PPJMtFLlmcT3riQ9NZkLfUZtCVPkYAOJXFZkBifvzHpoL99W4GN9X3/L+owAYMGBSod0kmOD6Qbhy014DvbwaCkjk9jnh5McESS08ntvpx6PsusReiOH3xTNlKMTvZENxY0xe7LpwT/FnY8ItNA42YO8OlXESs5pdknKE6uYib1Ddwxg8voenolEGJ0XkawDZImalNuOqT7UkLGCc5mBCIMFE3XYUc5omHvTeEq3ALoRnlZYtPwO2fw2pWXZ11+ukxRcUGWb+gQvsQEp7Wu9iVzRcKGEcX4DmojQUrk4wi3Z25Mwfk56aRmDhd772s+b/zVuensEjWMW2iCJ9rwjA==
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
index 7d8c7c337606..7f59568faa05 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -858,6 +858,12 @@ static const struct drm_driver panfrost_drm_driver = {
 #endif
 };
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+bool panfrost_transparent_hugepage;
+module_param_named(transparent_hugepage, panfrost_transparent_hugepage, bool, 0400);
+MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount point with Transparent Hugepage enabled (false = default)");
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
index 8041b65c6609..d8472a023e05 100644
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
+	if (drm_gem_has_huge_mnt(&pfdev->base))
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


