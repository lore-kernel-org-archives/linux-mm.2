Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14676D2F7C7
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 09:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4D5C6B0117; Fri,  5 Dec 2025 04:12:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF6E26B0149; Fri,  5 Dec 2025 04:12:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5F1A6B014A; Fri,  5 Dec 2025 04:12:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 960146B0117
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 04:12:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E6A788CD7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:34 +0000 (UTC)
X-FDA: 84184851828.20.946C7E2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id 64ACC40015
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 09:12:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=NENoyCjs;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764925952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mCrmSDMOROjrLbceWFhJy/9JisAvfMvvwSwMuXsr0Y=;
	b=kZ/kf/QdvleSfGGbdrN1vh0thBQyBAdtnx1qqfYeGVYFds3Pyc/TBLhrJd/IIROAsZZlNj
	YEg54FTyJi2HbQSsqfTULw7zHGyvJLdfNp/rPUU5fTJvybAu8TWWfC4EpHmiaplHh+wMeP
	KJuT+pHRDBuUsE2HVVlNWavWcbOX8sM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=NENoyCjs;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764925952; a=rsa-sha256;
	cv=none;
	b=38lLOkoNgxiq5NWf+9gO8LWsDKZ6KmLu3AA2JCHr4eq10S/cnLxcoF1c+IwwgX8lCP+dr1
	PrDqqX4K+7PGBmMg+Qbfnu7oMvlL2hS9SdCeeFnupp4bD070KQ2iYjQmuwsz9ebZcz2i8W
	tuPULWP7SqOWC9t099nBhhK1yDAxYQw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764925951;
	bh=wyWso67v2Pmj9cYL41opZ0W8Md0EXL6qC4U3K6oFpbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NENoyCjsKZ4d46f7d9lQX0/Zp9ZoIDxxJAHTKo0wKEqs4wVaxfp/xDI5ETN8VfNef
	 reWSS2L+CxGZuKS5ndSCMTrYze3CLKx2pL8GRb4NVvv4DcM7LxjQHYzwcMGIyL5Vtr
	 s90q8vv4fL+fukMwFEWKuxM172i8W6g3cOOCmNLhYH5j8oahOsg4a1Lr4H6+luX8dZ
	 I75O+RzJaLO2ljsbtHv0c7hVLKX1qnHHTdCJFjjuNm4eGai1YF3+qtaL838Do1gXWW
	 HeF5Jx1SebrVq+qPuF7+t0WCAMdbegK/ctniEetTvaWnk7Y/Lnp0js/ppjgmEy0bB1
	 TMjfjZ96YIv+A==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 48EC917E368F;
	Fri,  5 Dec 2025 10:12:30 +0100 (CET)
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
Subject: [PATCH v12 09/10] drm/panfrost: Introduce huge tmpfs mountpoint option
Date: Fri,  5 Dec 2025 10:12:15 +0100
Message-ID: <20251205091216.150968-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205091216.150968-1-loic.molinari@collabora.com>
References: <20251205091216.150968-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 64ACC40015
X-Stat-Signature: ajmb3sjk9pws39qm7b9akdfwakxjk6hk
X-Rspam-User: 
X-HE-Tag: 1764925952-787286
X-HE-Meta: U2FsdGVkX1+a3pSGTglERxFAx5+ZsbJOG/pQ9pZIt7dBi6yf55LPIFR5cI/yLO6OpZ9DXqXVaQ1BLa9cPy6+wsuHeojpkDOMHANYI7Z8tMKUrbT2jorM77K3dORL4pm0WgEWxdx5lKGWQ4BGNPKjRiZcaNaHst/3HyKn1PHuDwDkT25EPcvCoQ23GEGhM17uBtgTEaapHhza3X7yU9d65Zj7EFd4+ANzeGA7RtDBhCSpLmZbL6qAgAtn8jyOQpsnD4iw9RixalAyqFH5zD/vJMSyiSD6HsGGZwhLc5iAR8kfrZh1HF4J7ab92o5vdS0r2xLsBt3TQm43sZmvjNQzbk/4EJ9MGM03GKNNROZ7cZboCyw+yFGyYytdofI9rr1FtQd5/WxZ3/dgIDol2fbxh6C50v8Da5bzLQHBMeqeFLIBc4kduk06xZBgoOmj5B+BtHK2FabMtAYVubMJRfOio0POX7FfB5z81jd5sEUkuzmM64P7MeRcEt18N2TjbLWfduthdjdV6QykRReOIaSofrQBf9e1zctf6KrnNs/6Myv8Srm2/252reDVtmmEft2NLZB439DvGs4E44p+yNlZpcDqDQaIBbjBbqV5l8FojEEkGOFdv9+Lc4S2AaMlre8lO8sxuVT1cmrwXJ3mtPEVRvSOcn+s8vY49Ca3cDACrD+HiZweOPDi1bb3alK2Nqk8+cuQOL/hXztLg+FdIFy9Ew8iWJ8kmACPqhKAEhjKlspYKwiR1GqiIQlRWdOh3cPTfMyxJD4H7K8sp05uW/ztigt4brnpgYIzQzyYQCivMwa55hI8EZ1g7c4FdCeY1CdowYAE31+tSfA7VqXopEy5sRJIegdorwTIUOm7DxGIXZoqIZRBo0S+OsG1t1glFvd72Siw5cGE6rDzxOZRyApKjKmLkH7/YdYyf/QDjUL3BnsYN7icb6J2WTwpHVzwL9H4cqrHH+s9muJ+/b/rR77
 VmLx6zJc
 2krxFXAkLi9JoHIS45AND0DZiAipuIJi9rJOmPCe5CwQz0sWrzbEjXVVSseXX1JN6YQupCStSFETFu8tfrJrMdCBXb9qokTQNjmlqm//tHFmRioDAwCvYA4M7qjE2wOV1dm8Kswh8PhFHq6KJRm1e0+l+l+BZE2KWysukHW1UUiFX/Ff2iVxSBd1EtvXh1+s8erUVYn/46k4NdN/C/qyXSojH04nIxqkhoe6JvixiQJRUJ2j5STaWyJ9oBB6fhyyBGJ02zyUY9l+OKwbunyUH1hBZXW5+srZy4wTDx9uky/kBe4Hv7Mw8VWNHiSP0XXfTdAV8Ukn9skukTylYB3vsOheYfWhLdxgapfakcxFXKUuOH+dACHD0SWOpbMsvWRsaRjPhIxVTXc9hhTLJEchhjd89akPQjZO+UVzpfZTfY7VBx8k5QlDgQAalLro5qpBaBNpVC5mTXxYjEAzW2O7rr8FhK459LbDZxoxkiOsHHEyNamzYr7vTIrJSdQUj65i5xzkyttmpK/myQATDCwVevDd9K71Q9sP9d10OH3uVhqTaqcI=
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


