Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E753ACCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3928E0050; Wed, 15 Oct 2025 11:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54448E0005; Wed, 15 Oct 2025 11:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C984B8E0050; Wed, 15 Oct 2025 11:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A931C8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 803A9B6ED0
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:52 +0000 (UTC)
X-FDA: 84000736344.17.B555D76
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf17.hostedemail.com (Postfix) with ESMTP id 96E254000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Sko1fOkK;
	spf=pass (imf17.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOmqCZQ237a99S337fQFW9cX9j6fNxrmawQKInbTsdk=;
	b=Ro7nE9yA1XBsg9Vt/SkpL8piIUF7eo5Crr8xYbCyRuCEVXVMyQpYxrmIvEEvWzt3fHYA3v
	Mwt16j5d6xMomh6xBrsQmlAIvuRTE0I3TBDg90pWkOR4lZ6aSN7XTN+puVKx+QT6eoEUAU
	ED6mZSXFTwV8eQ2ZiaMYwuzETV4C5+o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542250; a=rsa-sha256;
	cv=none;
	b=WbmP81++7TAWquCptyyX6BfhzO9JEUSW5PXqA5BjYmijphBZnxEl4DdMYus3GV7sULEALz
	wqktWcPe8vbULDWvNSu3of+OBeRDXWByPV9Rq60PeDGru9gK2AVmUe0eFzpVxyPb/gsR7B
	KruSe5zTktySln4m29/Clybf92io3CM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Sko1fOkK;
	spf=pass (imf17.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542249;
	bh=+cl/GzgcT1Fb2lvuYJSy48Zz4ImIu8RmCkKrQxlGrLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sko1fOkKwhU5QJtjbTLNt357vjSNq/kUG6zxztjtADWLI2V+bQ5AvA0/dSCH2xTko
	 X3S86Z2JAt2MIs2p36/0a9E7PVnXYqs6fb9MsE7FWooHUJs0M/N3NfuWGFvY8/hWpS
	 KTbcapTiE+EutYTrsx5nq+RIPWbBmwHrY8TZvyIvOl81FyMqp+9CctxsiXRCSu3vcY
	 yGSQDHCJsEAGzQP6sYRtQuY8opTNhbznPw6+zboNbvl2c7RXtn3nL8wBGmdloIS0la
	 PP9NnWVDzKP3ME/CaXzDE/TodgUfp5v5L5dn0Fs3a5uQvgSdhRIG9NZUvmPywNEW1b
	 02Yua7S1vc4YQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6A18C17E00A3;
	Wed, 15 Oct 2025 17:30:48 +0200 (CEST)
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
Subject: [PATCH v4 10/13] drm/panthor: Introduce huge tmpfs mount point option
Date: Wed, 15 Oct 2025 17:30:14 +0200
Message-ID: <20251015153018.43735-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 77r7sdu4ssojsaktogycssdjohxpif6h
X-Rspam-User: 
X-Rspamd-Queue-Id: 96E254000A
X-HE-Tag: 1760542250-846842
X-HE-Meta: U2FsdGVkX1/SEyDuLoNnC0tKAeJeIMV6ys0tVbTFuVxONBUS5oyIgKxoEWaBnloDvKvNMaJNE6zjCL6Fej+v5Rd0e+PZUvUZjugrt8w2/zcW5lZ0hw58tFdgOGYmU0ZKshIuNQ/GEqK0lfRpeTkJYqItgTWipRHrpT7zKErnzQ1MQT+K78TMMWGEuR9aeWbhpl0gfNEdhX9zc3Cp+uCQ+YsWIsoDwp6m1/kT/5QQKkWVSfwEwKiR/80RG0jOa6qVEdbHDz2J6wNxQCEFEaexLn2po53YaqwpM0Iy0cI9/3RRW1W+pYHEpdFuaNLpHZ7OiqwlRX9/PDrdEoQW52Ai/CZ/qiSzUncoCJu9fvrKEN2OSBYlYV3WYUczwLOZqsV+TgYUrMFHJp6X8J8a6Hn6ever87GsXFHqAGXIuNHWng+64Dc6JhN9FUi4Au6klWMS8LCEVYvcqQwHzcW68CBHi2n8cW4gSqP3ZDS1VsJHfKiFhpk4iTbft6Buw2qS79I2FJl01XJyaklJxsNAQpl8Re9xlGZ+54tww4fribUNdLNZL3cZ2EKXrCkHfAY05gbT6dFUkTAIGZIl1kCqw7amAvaRUq0nEDle1d/HK43pAWuE9GT7ZXg8XT424U3YmYxp+fZ+Mu2ROLrdo9LgJkHkPm2PZb7y7cnLe9CIKdXt34CJuEOGBGJoj+RS1W/AnzMXkC71re0qTZYYlO5DdOx2kNES1iMRyGr0+F5pGHBKErYX059lhVRzdyV33+jGjPTxXYlNf4auW86YMd+KZmsPDM86Ibiw/BivgnW1x16q8Op3Z1btisB9VyfqPaCrTIiHPaTbUCgDFlPvqtvh1QWzXna9Mu/rOMqRINjZMPdMn5mzbnrZV9W9ZDPg8Rbao3sobDLoPK4xnJ8K0Ae2I5YsuCJ7boED32czmRGwHZSB3UL2bgrmdJJUZIWTcTsN1cukuG2qmqaDndc8I9u828W
 D/PqZivy
 eqnDCfPP8Oek2PCYfjI/kDqTaSS76eHBRQ0J6m4WB2YK8xtw4x6sKuGfGsFqDxHlV5S/10iJLq/PC89A1iv6bniUTGevt1vajATxgdqfHAEFsfjbmaYOTRXkS1hHRVaY+Ex25EuGe7pKulWz3vKWpCiyU2A7xbOhR7JRN5DeHkHr6MuLUDTijaQaZpd0J9j2POHbCxopf14GFw6JGn1LG4aMxhYa0oclUL9pCEH4aI8mZKKof/ZQEOFV0PcS0HlA3QKTH89z9GnRLrhUYVA5YnHqC3HgtrPkwQ4Pho2gLmNUE4SjZCnRujV2RWBMiy8T0Ea4UQouRJgbMDfN1vO7R1Zgnfs6jigKl95JnjqcqSqnTb7Hqa3rXTxl6EqxboWLTaskg7545Z07vqSjKsoW2HbKn9+TN8rcyHuJzb/XmWAaIvQNFQVl1XyOJZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the 'panthor.transparent_hugepage' boolean module parameter
(false by default). When the parameter is set to true, a new tmpfs
mount point is created and mounted using the 'huge=within_size'
option. It's then used at GEM object creation instead of the default
'shm_mnt' mount point in order to enable Transparent Hugepage (THP)
for the object (without having to rely on a system wide parameter).

v3:
- use huge tmpfs mountpoint in drm_device

v4:
- fix builds with CONFIG_TRANSPARENT_HUGEPAGE=n
- clean up mountpoint creation error handling
- print negative error value

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panthor/panthor_device.c |  3 +++
 drivers/gpu/drm/panthor/panthor_drv.c    |  7 +++++++
 drivers/gpu/drm/panthor/panthor_drv.h    | 11 +++++++++++
 drivers/gpu/drm/panthor/panthor_gem.c    | 19 +++++++++++++++++++
 drivers/gpu/drm/panthor/panthor_gem.h    |  2 ++
 5 files changed, 42 insertions(+)
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index c7033d82cef5..4ced0bef22e8 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -17,6 +17,7 @@
 #include "panthor_devfreq.h"
 #include "panthor_device.h"
 #include "panthor_fw.h"
+#include "panthor_gem.h"
 #include "panthor_gpu.h"
 #include "panthor_hw.h"
 #include "panthor_mmu.h"
@@ -271,6 +272,8 @@ int panthor_device_init(struct panthor_device *ptdev)
 	if (ret)
 		goto err_unplug_fw;
 
+	panthor_gem_init(ptdev);
+
 	/* ~3 frames */
 	pm_runtime_set_autosuspend_delay(ptdev->base.dev, 50);
 	pm_runtime_use_autosuspend(ptdev->base.dev);
diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
index fb4b293f17f0..9e49af1d0959 100644
--- a/drivers/gpu/drm/panthor/panthor_drv.c
+++ b/drivers/gpu/drm/panthor/panthor_drv.c
@@ -1556,6 +1556,7 @@ static const struct file_operations panthor_drm_driver_fops = {
 	.read = drm_read,
 	.llseek = noop_llseek,
 	.mmap = panthor_mmap,
+	.get_unmapped_area = drm_gem_get_unmapped_area,
 	.show_fdinfo = drm_show_fdinfo,
 	.fop_flags = FOP_UNSIGNED_OFFSET,
 };
@@ -1623,6 +1624,12 @@ static const struct drm_driver panthor_drm_driver = {
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
index 000000000000..27fe9b6f77bd
--- /dev/null
+++ b/drivers/gpu/drm/panthor/panthor_drv.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0 or MIT
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
+
+#ifndef __PANTHOR_DRV_H__
+#define __PANTHOR_DRV_H__
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+extern bool panthor_transparent_hugepage;
+#endif
+
+#endif
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 156c7a0b62a2..1a176e7e35ea 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 or MIT
 /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
 /* Copyright 2023 Collabora ltd. */
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
 
 #include <linux/cleanup.h>
 #include <linux/dma-buf.h>
@@ -11,10 +12,28 @@
 #include <drm/panthor_drm.h>
 
 #include "panthor_device.h"
+#include "panthor_drv.h"
 #include "panthor_fw.h"
 #include "panthor_gem.h"
 #include "panthor_mmu.h"
 
+void panthor_gem_init(struct panthor_device *ptdev)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	int err;
+
+	if (!panthor_transparent_hugepage)
+		return;
+
+	err = drm_gem_huge_mnt_create(&ptdev->base, "within_size");
+	if (ptdev->base.huge_mnt)
+		drm_info(&ptdev->base, "Using Transparent Hugepage\n");
+	else if (err)
+		drm_warn(&ptdev->base, "Can't use Transparent Hugepage (%d)\n",
+			 err);
+#endif
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


