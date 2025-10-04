Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEF1CCD183
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC91B8E0010; Sat,  4 Oct 2025 05:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79438E000C; Sat,  4 Oct 2025 05:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68D18E0010; Sat,  4 Oct 2025 05:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9C268E000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:31:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C34713BCA6
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:16 +0000 (UTC)
X-FDA: 83959913352.02.FB5C64F
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8AE2F1C000A
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IkjyBIgn;
	spf=pass (imf18.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aQg+R8Wji6Ekaoiv/D8dK7nIpJkxLm1qY55bRY3D41U=;
	b=iKU+g5Mfcoxyz9rD1ghyFy2ik/OVjPSzlhHKYYqeb5nA1mujZ/LGqy7jKRraExkJrd3f0+
	KnxhD19VNiEbDybbIQo4oydLImcp7zYDifeCSQ7ioA0bXPbWORtV2kRyiGOTuXcbiXmuP3
	N+yeu4YJGuZKhEisnM5eXiSGZ5hDqa0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570274; a=rsa-sha256;
	cv=none;
	b=dNFNO1P12PRDDKLHxnxSs/Zy8GXILviH7UPtlmpKs7eZO/NaTzFUWDibyrykOL/j6nibJu
	Ftoee0Q3g5QYHWENy93twobPMkQwRR4MywA0otjf3MN8ympX8fUPE66CUQjG5oo2/r0nKt
	wsJO3o3UbqmAZgC9gOvozNIdr6jrWms=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=IkjyBIgn;
	spf=pass (imf18.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759570272;
	bh=AORDOWjgp5Q4DcRSWOWZx/uO1pC7mO8Jrs5Hqc+CYdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IkjyBIgnEgvKaipuM22XhK0fOTN3pqXVTh9JCwq7JSKFPm1Ijl1u9CswFPIV7zz4P
	 4Dhr5If6IGYZ/S5msgUTonsJGxj5z4m+Ow4f5e0PWHUcQQ6NJRXaSwER6DHKWShoDi
	 8dctHU9cuizpNAAJXzuY6UK9tT98PDl62A4cu152chYB5pXjYY9UNOT+IuUoSbpEx/
	 kHHmeoaU78anbMlg6POE2Qct6+9hXUPMChhsOO7PD70tw3b+JwR2zEIii/DJO9+mRq
	 qkoiuo6SXEkbFTTUIBMVYE1/x1UVd9A9nqR/zmG+SwcE2LeU0cuUz5aLcpz5DEgQt4
	 V3FEhPyn9iiDw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 04CFA17E07EE;
	Sat,  4 Oct 2025 11:31:11 +0200 (CEST)
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
	Christopher Healy <healych@amazon.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH v3 07/10] drm/panthor: Introduce huge tmpfs mount point option
Date: Sat,  4 Oct 2025 11:30:50 +0200
Message-ID: <20251004093054.21388-8-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251004093054.21388-1-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b5dzcakoh3ba6t3d48tcm6oas6gfmbpm
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AE2F1C000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1759570274-980293
X-HE-Meta: U2FsdGVkX18lZBf2qsa6clQVOY6mT1SezrOkkH5m2CwqPmwGeQHpOyw8kpOn6/Z/Av0bnSO/WRPH7ROuU1sTxUIrCmJyeIpApeqVpuL099Pd11Qnm3GBsWHe/ZZaGbm9JgaDtpmPjTLXyUhAq87op9/X+4aoqygP3Rt/kUklN2emVu31WzokIktr2XkCm73Dq4izVxO1bD81LiOJVR9oM1vlAeoAxlJdZwc30ta4jqWvUSIKuc7lhlFZug3E027kNfqwjAY9dLjVtpCMte0YG/1y3VjjU5dERsfXwVzAaTpWCg516N0nhCMbLiLrj1wuPwrmowfjSOBtZyh845H4D40ZQERT+R/gsdQVBlnguAeUbdzhugenYgiEqM69v+GwbsvP0EjgrugURCeFJ0A9AAcEASwH1pua97dF4AYi6F42rJgLI+y8+IfF/BMNti77VZtQFPhs92/KZMIrHRtW/BVCYbfWUSdWeoYb7fH3+/DkM4GW1gWKKB9mV3NwyuWpELwLEs3o+G9Xpwizj0tWD9nnwU304jWO8PFuJAvY6ChN+JqTbLMOHyAGlULHkdAZyFo4sCeUn0nmdvb02Cv8clRXijIe/IhgWxIZDbxhKiNETXKolkYvYPPf02CiRs5TFxXI3KAyuTMs43enItOqtb5CpMECO9TJi6MO9Vi0sOx7buE9P9nTbHsMKaHxtvu/pZYvdf2XcgoPWv2kSwwxdnklzzD7qK67SZmhbmv2ZqyofvSRrSB4N7JalezSLjnbRSiHMbeBC58O4kSJfRHOy5f/ipi5iF01xKaFwTZkbbVjK7uE0hShzSrWHJG6TS5DfjDnxzoXv1qs7/wIy4204LYx1UQZW7Jzkmp8ltxnlMlsQmqqHA2n5OcStNWRJq0nKJF7LnObSe2FIacy1dmy8P+yhYGt4EQQPSKtIn6Nnr0K3ETsYS4mXiXfNSkxwhT1lcvND2efWcdwCLiR/ew
 MGvVLgNC
 okwMfCrGh5a85e8IgZ+UwBrWYJI5zx5bcfYJi1s+mK0OXFA1M+4K0SlrOXiDR2oxtWcMlXOoz3ygmIkKBa0nMQNBIR3jmxBEnUENhEPd9t0Axa5dBRkEuwclQz11T5emsJ44XTwv2/LkPgu9oaQNU+t7CO4wQ30CPYXVpyVcZBtDJluj7Ny0/EViBRYX7wKH75IuzCWxAynvBK9+/snKeN85beSELod6OMO/WnrZcnU3/yD+l9TazqOXV8ep8yd++qR+S7rSskQhZN2W5bh7RdHSp698EV01bUSZEfbVjx1YTcicLTcyVxr7Yi7g6VhcOysgqKu+hLwb3pKa7EPsLro8O0hQaUivkTF8ZU89dWbDc8ukSHUDbMUz9AAWg7rvsrU3EJ66O6Xvzu7cmOUM+/eqCF/JHly2WVUIjVxMWKADWZ6Iuuvjvf5vugA==
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

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/panthor/panthor_device.c |  3 +++
 drivers/gpu/drm/panthor/panthor_drv.c    |  7 +++++++
 drivers/gpu/drm/panthor/panthor_drv.h    | 11 +++++++++++
 drivers/gpu/drm/panthor/panthor_gem.c    | 19 +++++++++++++++++++
 drivers/gpu/drm/panthor/panthor_gem.h    |  2 ++
 5 files changed, 42 insertions(+)
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index 81df49880bd8..3c0387156bb9 100644
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
@@ -269,6 +270,8 @@ int panthor_device_init(struct panthor_device *ptdev)
 	if (ret)
 		goto err_unplug_fw;
 
+	panthor_gem_init(ptdev);
+
 	/* ~3 frames */
 	pm_runtime_set_autosuspend_delay(ptdev->base.dev, 50);
 	pm_runtime_use_autosuspend(ptdev->base.dev);
diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
index fdbe89ef7f43..a2be3b904ca2 100644
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
index 156c7a0b62a2..49b7d288bfdf 100644
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
+	int err;
+
+	if (!panthor_transparent_hugepage)
+		return;
+
+	err = drm_gem_huge_mnt_create(&ptdev->base, "within_size");
+	if (err && err != -EEXIST) {
+		drm_warn(&ptdev->base, "Can't use Transparent Hugepage (%d)\n",
+			 -err);
+		return;
+	}
+
+	drm_info(&ptdev->base, "Using Transparent Hugepage\n");
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


