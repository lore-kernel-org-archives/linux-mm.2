Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D92DCCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5FB8E0028; Tue, 21 Oct 2025 07:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABAE28E001A; Tue, 21 Oct 2025 07:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CF1F8E0028; Tue, 21 Oct 2025 07:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7671E8E001A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42B28483A1
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:10 +0000 (UTC)
X-FDA: 84021905100.05.4F73DFE
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf18.hostedemail.com (Postfix) with ESMTP id 578791C0015
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=STYkM5hw;
	spf=pass (imf18.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bP5LkgJwrDjNPUDyj4f3BiaW+dNMgKFu7Kh/R4zNcY8=;
	b=0UAfm7hzmZIE4fXUelslVEVZX9bllrSFocTlHsGg15iq6tgK9UWlb0Gs9Cx+Bu2fRxwS1+
	htyKteriWNTVSA1bijS+iaK2Ael7Gh4nKv5eHcogI3l0lx9OhfUtaIlWmGh6lLIpL10l/H
	6GGt5gpyBqSG5fN3+2ycESTxgbMttEY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=STYkM5hw;
	spf=pass (imf18.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046268; a=rsa-sha256;
	cv=none;
	b=IQwCEHfrGmU5p/Geq6CkDxDfiGrqsqg3jDGYJk0RK9PYrmUEeUDSA9AXQ4dFTFPTokjzYu
	tspS93wj+Q54/LA+36hJ9Ks38hhfiIPdNewJEe+P1GlsFVjiOOPU77OnLKDVE+e4DA3IG2
	kOAQYUH8jY3lLsHQwDL7oqmZQ9LhRRs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761046266;
	bh=mlBi6AMWO1tGRBEEMvytVH6FWqoDNn/HD5c/lE3bK9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STYkM5hw2WLY+JRUxKhJkSlv2Db0EtaSBwf372XyePDJYwu2vmQwBsH5HweRiEFIg
	 KrK30iDJKoXgoYjaXvbLsevTL5VVyqUCrsoUPQF6mkxqGT12ADkkmmaK/K8XsqPG7H
	 6UXkZigJelZR2DPrNu5GUb2VCF8W0NmafTvkBOhBfQ6ayVwEXaM4YJqL8OyjCc8MJU
	 vbh9pr5q8Ndkue79LA24F3OR8pQlPLyrWc+j30+cwzTWdZNnTLaaytWzA4j+2gUZqY
	 ncAHSJET6zGvANSk2weHxp/3CuX0hlm/Y1AGqixGVYxFh4+gRx+ogCL0y8iZwI7k4S
	 D12lMAgxTJQTw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E7B3E17E131B;
	Tue, 21 Oct 2025 13:31:05 +0200 (CEST)
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
Subject: [PATCH v5 11/12] drm/panfrost: Introduce huge tmpfs mountpoint option
Date: Tue, 21 Oct 2025 13:30:48 +0200
Message-ID: <20251021113049.17242-12-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021113049.17242-1-loic.molinari@collabora.com>
References: <20251021113049.17242-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 578791C0015
X-Stat-Signature: ruquof57noc4omb68cbayfpf5mkbmqwn
X-Rspam-User: 
X-HE-Tag: 1761046268-882205
X-HE-Meta: U2FsdGVkX180j0PqLV7N+7kHyVpuKcex4ShHcVH/sew27IJfDyoUxsIw2NrWJgiUmG2cxSlKC3s9pwhDAhN0fiEHb1t8DfzacusvSOY78rMo7Ox1xgHt38KDSy3eZvMBJB8XXxkqDv7MRLx0+vOre0+KbNADz3F9pok5MbwkXWbo8mCf3SgORkirCmSMsUyOVX8dJ/KAtDDXvqJjtCVHUVyt2LTOgBKTBZPdXgwPNB/tUeuDM5wQpWiFyTBsXCOgNv/LGXG52tCoiSLHfCwJdCzMVRezBSXhEgoF3N1kfomisp8s+GLjYo0AT+wuoSrRBFn+V0KZ2f7dieDZ6UFJ2EwxWWuWRYirBXKrZPBD61xATU+/g/KHidPhp5U58etsUSdL5MbO/omOE2mydkDfrem6x8BlSwjL7O6cUcbBDXzHmnauR2ftOO7XxaSO9cOsxzcIwQJ93vwFuVDCFO6sTuiJoyRXkEDDFI64e63LPf9ztQYMm/t5a6Vgfc1u0VhuO2kcD1D2Y53hEjoqrTbiR3Nyo7iAUVAAMwf3RNC0jDlRNEgfRq7s+TGj1JWDcae6SePwPK4lS4C1SpN+X/fL6+A2+iabE0CPzQljXM8VWqh02df+55uIEj4DgWr9xto9cJkdUUVABZ6LG05LBIAIyfnlIPTQpbqkBifQ2IZbP04j85j7Ii0g3c+YtUDc7WeIZ7RjgG6KapSOiUrJvPcKan9gVUKY4vg9m3lPKHNErwuntzfsCNxnkYcIpVuFlfY2FejYfSm5uqr2+M1A/EXR5X9Gewx1t9QOXmmHW43TBEeLaQouXrF45KN1PV9FA/KszrWFEliFtQ2za1wPc1OSbM9LajPQt+0VtbS0HjMtcOsp86xBc9oHve9MMhyKwq4jPJ4g4nlrFO+hbBaSccCKN7EBfljw/zC3uLz9uswDBt4nnmkz+D9lyU+j6HWh4RxjEkvYnWfjSLQ3A/faspu
 fhHEveJ4
 qE5lL541xwz8PrVYmX1b9QTN9ZrCj7yGGXMnYxZ6yPoGx1vHt6kHxTmYJLr1wO2I1opb2hqwB5zZnCdUCoKUNcoYYB7uXFmG8OVqbdR1d/+txcu1joJI+6OfxCwuel+hV9J49nRANXYtudMg3jSE5u8v+7cGnKErhhMhvhxvYIyo0oETVW7lU8fbFqjZpO6Glp5/PDL4FQGaFYVtpKcF8DjEcc3UsSf71fNLcb9M9KrkxbiBKklJUF+hKOiRS8b5uqJEcaWfhrQ+xSACj/igaxJFOFfLudquDEbySthLCh7hhHB1q/KZOqhaXPoWdZ4znsmYKaBYPGi29S3qrzLAvCmdBtxx37pyeTzJR5FnQNvDzDsemyd0MAUjVlMP5dbaj03+emnTovMxJVh/+ei3llzlv/oMRpLIM9XnhXLWiXakijMMBnS+xydrqsA==
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
index 1c3c574cd64a..500c1ce96b0a 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -857,6 +857,12 @@ static const struct drm_driver panfrost_drm_driver = {
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
index 0528de674a4f..50fdcb4ef453 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
 
 #include <linux/cleanup.h>
 #include <linux/err.h>
@@ -9,9 +10,26 @@
 
 #include <drm/panfrost_drm.h>
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


