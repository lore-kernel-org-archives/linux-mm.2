Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9EF2CCA468
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:05:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111C28E0028; Mon, 29 Sep 2025 16:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E8E78E0002; Mon, 29 Sep 2025 16:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC518E0028; Mon, 29 Sep 2025 16:04:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7AF88E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:04:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B5FEC04DE
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:59 +0000 (UTC)
X-FDA: 83943366318.17.7C35ECE
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D49F140002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=bPPFqQz0;
	spf=pass (imf09.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759176297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPuj1ke6+vJY7BigIJs2C7hDSb3Iaudp1LjYRO2k/xc=;
	b=vficyFZikF4A6P8VvCYiuxYd8X2ihGtAlYVhvR5XaHx4b0OxIQumQiREFTl1HSrkU8cSIF
	57MD/UPwxUTFaSeHKuQKMSd/kMgDoAvduA6BK3dAMEN4c/12INY5jY2VPglltBc5aBaMhj
	h9zlir9zNc68hCnjDW43XcMHEdBXtAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759176297; a=rsa-sha256;
	cv=none;
	b=79+IoGuHhHN6X07awhDeEwhBdUU5iFN0+fTfNRVetQZ0/IR2UgEGGy9l4hxllpJuG8EEeq
	6QE8+vzHZtDbjokfnnvCvBfoWHaUG4TMLR6Hta05a7NOcBZVK7jsalPMAmjBkVCS6/hPo0
	vE84ZHtMjr3i2R9oUIVlVP8EBsX8QgM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=bPPFqQz0;
	spf=pass (imf09.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759176295;
	bh=xQ/mZxaSllKAi+O3LeitaKzfoEEyb0serr2sHxkUVHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPPFqQz0vREC0Hqc0Qd0LG8oOfUapTSwVKKahr4bhHav1/MhtEeGwPWTu7oaiBqhg
	 eLP2BAymbI9383oWnI09v6kgk9VTJ0h2+h14xuzUBmlzoenOip2ORZVFHPP07ZjYp0
	 8lYfM7BEQ0JQ6qjAHXtwEWpqXbCbhpqZ64SBK3y1pwtV+rhTOFSzMpNSF+/cHHFnUp
	 IiGjfRkGxJ+sFEQYZJtIrj29P9iZlZlMiy4b8kafAX+EUCO3n76pu/8MTD1wQDw+vZ
	 RNm8zWPXRfSZvLKsF+8/edV5lbdZorbNBKPaM1NEZ/hqK5MKMJ+alX9N1eatYKuzSw
	 Xh75Ox1J9f4XA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id DB3ED17E153A;
	Mon, 29 Sep 2025 22:04:54 +0200 (CEST)
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
Subject: [PATCH 8/8] drm/panfrost: Introduce huge tmpfs mount point option
Date: Mon, 29 Sep 2025 22:03:16 +0200
Message-ID: <20250929200316.18417-9-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929200316.18417-1-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9D49F140002
X-Stat-Signature: dmrxn76rqjmsc7i5hdyxnejuincz1bab
X-Rspam-User: 
X-HE-Tag: 1759176297-251080
X-HE-Meta: U2FsdGVkX1/IYpC9fRVdnQ6kJr2agHX3CEMHqNnrwAtE+66SV7slZVhMY2ZVC44BTa3gwvYot6I79QXcgswsBi3tmn//98Wijt7nCGan7HUoLh/XNFBzrIKM+IqNooJ9FCrYEvhnefyGpgg0ZR0JgzOkuk2fRqEE1ujF8q97ZrUCA947Tcn+rvL1iKvAK3XTsx7NBShC0EwkHS6sctaCrbRxZKF24lMiIerCDNmpftGqqicnaogyQTnLl2xkZlVT84CxynOcuTpWk3ZZcEliTYY8FBuDFLhF7WOrnImSIXsUTUs+G1pbqcve4lfVEQq09icI+UBqJahTlt4Og1ZgxYtUg+sb8NpizOiNZDAj1e1NwunwgF/QAYzEZG2FtBsDiuFl5AgzsMD7kbop/FVFcLCS6UWq4WD1gcfdT8rq4xiehGVSwuHapdtE6E0bCYzs5PECRf6EVS4vBBAT4voVBXBoRCO/XUXiKTwUhs3pnf93IEXnAZ4SDr/c9VjFfWQ2EVICohWUrJ1F2vF9KjYe7PO15pF9IywhJ61L2sjMrEynmgDIU3+bl6Nj5Adzng/EctQkXxs3Bd/mQGdXMrkeGLWEPhZlXQFfONiUPu+M5rVxyZ8pA1yEPrmXvNnbFRaPUA3U8XNWUe8TFIouhw/pmxVXkzPyX14uLsYLhiR9qnEf9rHRcsRMQ3XqQ+BQinxl/BUP/kA5dr7l/OZF78B0kfDgEokDxgkBTy2FZrF+DiUjyOu1fmrsYGjcqw+Uv3e6633a2dKhnfiasC3pfwnndYd9JAfLB0Eg/7knA/iTmBRi+FxAFBaw7Loqtq12jR/Af9fU0LzqY3AQ08hKY9lHXtAdQsW//PT7QG3h4ewvBjHF9l/iScMSh9V/caZ9aC3l1+QYPtaAeek+d7hMSjjYOsotQwoxC3U4Mp58PdotYGIfw5z8TyC3yM+ETS7vU7BsgYWRZrjugJEyohwNEPD
 Wjh1zyJ/
 bUcbT81NKy/Hm3/nk3M/8/78Zm1+mVPFe0R+QX8k7VEoJxSZutgeEsRd3maW50MLG4hrqlg7q3U+nnj2llCLR4YN1VDHP2DVprokVJaSsjlFKaWAoKtmbs3wXCsFD+ORXexew9HZmcf/YVgimfb0rTlEG81MppiHi9urqfSt19Fpndt4KS/snsPRtL40ZU0ANRuMZkOLHtcXvQYTfbeidIhqX4ldE2SxAa3Jv+VSX2Ui6mF/gsYSo2pmUaFRwTI3+VEdKDHViLHH8HU2fErZVTdXwlOs4uiiXyS/NM15RdYP7ms47wfza9TZD+MNal8ivRiON77uh/lC82N5qmUl2LgV5HaP9FiFIx+3H7LsTSbdXKKQrYFnWv8IYcVA3EaOt3KrHoannp2edDaajV/3m/WDncZGQs/KKtaEDqo88VdkIsLfgVRHZO0r1Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the 'panfrost.transparent_hugepage' boolean module parameter
(false by default). When the parameter is set to true, a new tmpfs
mount point is created and mounted using the 'huge=within_size'
option. It's then used at GEM object creation instead of the default
'shm_mnt' mount point in order to enable Transparent Hugepage (THP)
for the object (without having to rely on a system wide parameter).

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_device.c |  4 +++
 drivers/gpu/drm/panfrost/panfrost_device.h |  2 ++
 drivers/gpu/drm/panfrost/panfrost_drv.c    |  6 +++++
 drivers/gpu/drm/panfrost/panfrost_drv.h    | 11 ++++++++
 drivers/gpu/drm/panfrost/panfrost_gem.c    | 29 +++++++++++++++++++++-
 drivers/gpu/drm/panfrost/panfrost_gem.h    |  3 +++
 6 files changed, 54 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
index 04bec27449cb..8f551c598a5c 100644
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
@@ -266,6 +267,8 @@ int panfrost_device_init(struct panfrost_device *pfdev)
 	if (err)
 		goto out_job;
 
+	panfrost_gem_init(pfdev);
+
 	return 0;
 out_job:
 	panfrost_job_fini(pfdev);
@@ -288,6 +291,7 @@ int panfrost_device_init(struct panfrost_device *pfdev)
 
 void panfrost_device_fini(struct panfrost_device *pfdev)
 {
+	panfrost_gem_fini(pfdev);
 	panfrost_perfcnt_fini(pfdev);
 	panfrost_job_fini(pfdev);
 	panfrost_mmu_fini(pfdev);
diff --git a/drivers/gpu/drm/panfrost/panfrost_device.h b/drivers/gpu/drm/panfrost/panfrost_device.h
index 1e73efad02a8..b8f368aef9e4 100644
--- a/drivers/gpu/drm/panfrost/panfrost_device.h
+++ b/drivers/gpu/drm/panfrost/panfrost_device.h
@@ -177,6 +177,8 @@ struct panfrost_device {
 		spinlock_t lock;
 	} cycle_counter;
 
+	struct vfsmount *huge_mnt;
+
 #ifdef CONFIG_DEBUG_FS
 	struct panfrost_device_debugfs debugfs;
 #endif
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 22350ce8a08f..e376e70a3379 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -862,6 +862,12 @@ static const struct drm_driver panfrost_drm_driver = {
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
index 000000000000..60454611b6a6
--- /dev/null
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0 or MIT
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
+
+#ifndef __PANFROST_DRV_H__
+#define __PANFROST_DRV_H__
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+extern bool panfrost_transparent_hugepage;
+#endif
+
+#endif
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 85d6289a6eda..e560934bbf76 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
 
 #include <linux/cleanup.h>
 #include <linux/err.h>
@@ -9,9 +10,34 @@
 
 #include <drm/panfrost_drm.h>
 #include "panfrost_device.h"
+#include "panfrost_drv.h"
 #include "panfrost_gem.h"
 #include "panfrost_mmu.h"
 
+void panfrost_gem_init(struct panfrost_device *pfdev)
+{
+	struct vfsmount *huge_mnt;
+
+	if (!panfrost_transparent_hugepage)
+		return;
+
+	huge_mnt = drm_gem_shmem_huge_mnt_create("within_size");
+	if (IS_ERR(huge_mnt)) {
+		drm_warn(pfdev->ddev, "Can't use Transparent Hugepage (%ld)\n",
+			 PTR_ERR(huge_mnt));
+		return;
+	}
+
+	pfdev->huge_mnt = huge_mnt;
+
+	drm_info(pfdev->ddev, "Using Transparent Hugepage\n");
+}
+
+void panfrost_gem_fini(struct panfrost_device *pfdev)
+{
+	drm_gem_shmem_huge_mnt_free(pfdev->huge_mnt);
+}
+
 #ifdef CONFIG_DEBUG_FS
 static void panfrost_gem_debugfs_bo_add(struct panfrost_device *pfdev,
 					struct panfrost_gem_object *bo)
@@ -305,6 +331,7 @@ struct drm_gem_object *panfrost_gem_create_object(struct drm_device *dev, size_t
 struct panfrost_gem_object *
 panfrost_gem_create(struct drm_device *dev, size_t size, u32 flags)
 {
+	struct panfrost_device *pfdev = dev->dev_private;
 	struct drm_gem_shmem_object *shmem;
 	struct panfrost_gem_object *bo;
 
@@ -312,7 +339,7 @@ panfrost_gem_create(struct drm_device *dev, size_t size, u32 flags)
 	if (flags & PANFROST_BO_HEAP)
 		size = roundup(size, SZ_2M);
 
-	shmem = drm_gem_shmem_create(dev, size);
+	shmem = drm_gem_shmem_create_with_mnt(dev, size, pfdev->huge_mnt);
 	if (IS_ERR(shmem))
 		return ERR_CAST(shmem);
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.h b/drivers/gpu/drm/panfrost/panfrost_gem.h
index 8de3e76f2717..0e874d3c1363 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.h
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.h
@@ -124,6 +124,9 @@ drm_mm_node_to_panfrost_mapping(struct drm_mm_node *node)
 	return container_of(node, struct panfrost_gem_mapping, mmnode);
 }
 
+void panfrost_gem_init(struct panfrost_device *pfdev);
+void panfrost_gem_fini(struct panfrost_device *pfdev);
+
 struct drm_gem_object *panfrost_gem_create_object(struct drm_device *dev, size_t size);
 
 struct drm_gem_object *
-- 
2.47.3


