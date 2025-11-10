Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1360DCCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973878E0031; Mon, 10 Nov 2025 10:50:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FC158E0033; Mon, 10 Nov 2025 10:50:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FEBC8E0031; Mon, 10 Nov 2025 10:50:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5864E8E0031
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 247DDC0186
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:20 +0000 (UTC)
X-FDA: 84095134200.04.588CDB6
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf09.hostedemail.com (Postfix) with ESMTP id 47574140009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="g/AftxTn";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf09.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789818; a=rsa-sha256;
	cv=none;
	b=lKP0FQFbOLwVsmkbFGbhETUhFMTA/lzi+L+V55jF90l0UJl4SzpvvSUjnGa8B+mc4MPwOr
	5qrwkxFRnExzyhVYHEEN24rLD0C1gamdlo5jEIxKUxFkdj+zhx0LTleD0jN9WBF/Fk55LB
	sTe2b6cPxu94MdiA4O6+fzzUzHBbfqE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="g/AftxTn";
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf09.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++PepNGLjda06HDSzZr6zUMp2L+H8I2WGjEaW+3VRbc=;
	b=bQOqPqvJvQvQiE+PmghGW+Xj56Ra2sf5x+IRg01gWbc9qxDET7+Vl+afeXT1lLMcMINXUH
	KnBw+TGrtH59PbbIfu7nONDW/Bm1aU4ZblGEAXGQgfoOVmRUdgTk0D20F50l082tU77v0Y
	y5BpymtgwER/yOI+jHgigzlKKBeKF3c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789817;
	bh=zYBl/Dqp6Izqq1kQ5gjEICYJes4BCUnNwwCmCl6OpvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/AftxTnhYm6hc6wpSPhGnMx7+4FRJfT54s0IZdBfUH5tok+x3jzRsEgsj5Kpe9v1
	 cpjk87UB+TGaHHhAT+FByWGEtszwJZpEAdENm8KPwnEsuPI4o8E1t6jW5L7jGJbvM4
	 xML6iui7IpirlyjHMUp/39i2ld4qSOj1dvr3UEVc6oRuZ9Ow4IqbIDpDCfYmixl+73
	 DlwPDIXT6zVVu+Z6Mf/BaMjsK5SRMB8q5TFc2B+uJCEM/0Kuuoibuy28A9+Qm9hUnh
	 kBJyB3UxaLhRVzbvGh1dzNDogCwhsX7TilsVdtPu5yhTOqveCRyvCYPefrLq4pZ84C
	 GzerbsidgmI/g==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2EF5317E15AB;
	Mon, 10 Nov 2025 16:50:16 +0100 (CET)
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
Subject: [PATCH v7 10/11] drm/panfrost: Introduce huge tmpfs mountpoint option
Date: Mon, 10 Nov 2025 16:49:58 +0100
Message-ID: <20251110155000.2936-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110155000.2936-1-loic.molinari@collabora.com>
References: <20251110155000.2936-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 47574140009
X-Stat-Signature: i3yhmmayt86aag3611y34tgo3y6b8adt
X-Rspam-User: 
X-HE-Tag: 1762789818-407621
X-HE-Meta: U2FsdGVkX19c3CffK1GxZqpKA/ezoKGuGe4ELSEgJH6zhFpVibZ8PgRryFwQPL5mlnhuqLyVo5w7t3iHCzRTHsy64OsNR+4fd1LdpRSL6hGZpIpOgSVPuUOJ7UtxNZ2qrbUHKWm4t4sjy2PWLCVn8Zn2ib4f8BdHstk/8x9aGoiMuDi7Lqu550pyU/TUIR3jJ5u3/CfxzlFJasOaOAJ5FK9855ADuKwvbtqAihapm7QVRwvmJjwJ3lfKGt+ijSiwA9DlPm1xaiAvjGeOETD7sAecVrHBb7/AS+mtN1P5cYWPoU11uz6D9ModobIUKtECvcrzz0ziZEbp8g4h3Uew0mK1MUon5aBm55JXOw6p0diONLiOYeyxrtVNRrlQtKHryTVtVl2qbp4CMmqwtmr6O6DnpCf6DMrQ7bmrg5paTXxaBfULHDKe1fNXE20OeGhuJsLYLcXNBcEsZl+buq7Lp8gzm+OVPXwi45037zvDMJx4fKoVTbVsyfuYuwZyJBrUn1yqGOr8R4VVx1xSqUFv/d7lCoB5+gZXOWndiI4YuvHT1vRM+5Xg13oKP2GZyzPb3BsHESKgtWveIclEqsbMMsbFxmPJbO/9Q9bjtD2oEeL1U9lNo1HA7djJtiUg/TT0XmOhp+ibQFpGkuWPNU0gl6YmyD1j5M/JMiN8ErCiYiZbaJAALWWDjPjtGgib2Svkq44+8yUVYBv/KazpYuy84T3PGGKa3/mOjrr/nD72tW3pe8GCxpsWv5liiv+RDCZwQnP+bcLtqXjLO0FXnRg65UT62m0No7N3bOIxI1J2X4GQoLhX3pYsirv/Fj1e7N1r6wo3CPhto0jo3OjfzJ1AmpwllmsX62ne08jiNskfJ7Z6S61//2AoksXZBqa8y2urKri1J1khhV3fa3NAt2fT05VuXSe2YMvU8ldT2mn6Y5WHFm7Ojbseu/KXtk3Fn8zCr92vmBoOLwmpyqsiA9Z
 R/41zh3E
 wqDFR1PqiQ/N6Ndmg7jaN6TQBDyf4kIV4uNwNW1qUVo+WhCexoTjFGMZ5JlCYim4ovRR2GVUAKoP2ItNztVSRqtX3jxCLkBxA6ilbDqgSY8WGO5MiamwaPu+CamTZOww8ytr/kKCc2rrSTdsbl5fsqjWI8CMOO4qx41j8jyNzLRzch3Zmyuw0/A16DST6thfeoY5HGtC80iRPDTDUFAeLOJG8y59JqQP90H4pSysAGJilNhcqqdbWizMZww+tqXQ+f6gT0+xGyrywbpRCKfmsZ69Jk7Y0zQjNJL1BIPIH6MTTjfUAuF811nat5dd3vUBvNLtqBEwtNiJzCtfxozoJNgtwjW3VZe1LGBo0qAcwZ4uEeAm6MskGfxr/Qxh8C9GpjJaW948xdsq8V1FwSYiPFc/1nbrJNN4Ea+mf7x6z1kFnXQnGAh34kVAjA3K/SQzEZzUYl6GuXrELcNm2dvQpCYbzWxaSV0dOldN7b0aL31b+ZUAslZG/7uzLtCTMkGXnzc2Z88caX41g0BMmt4iVS6jKvDtmDouTSGm3Wsm7nETuUYI=
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


