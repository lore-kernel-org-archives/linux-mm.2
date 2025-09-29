Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C06BCCA46F
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0268F8E0025; Mon, 29 Sep 2025 16:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A118E0002; Mon, 29 Sep 2025 16:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CADA78E0025; Mon, 29 Sep 2025 16:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6EE08E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:04:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7FD88591DB
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:53 +0000 (UTC)
X-FDA: 83943366066.02.AC012FE
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id AE774180015
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=bS7Fd34L;
	spf=pass (imf24.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759176292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xX/K9RVKf/6fBNPjV0L5bv4rYicPTGPzrTNhkvh/Aq0=;
	b=kuI5Uha4thbN29Rcc69fp7XOhQ+X7jDlsrzOYUjzCBhB5gQR83K6mAM4qP3wFsGjUWrb2e
	FqW/05+d6utpxMRdixf/q/6UvVCrMXRY4YcXt08tL+FeaiYU4vvamo5xZ5jBAMzJvpJKop
	KOSM+pgJ+Oya+nt4dsqKYsy6xqyjGyk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=bS7Fd34L;
	spf=pass (imf24.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759176292; a=rsa-sha256;
	cv=none;
	b=0sGWnMrWj08fNKkzB20lQ1z06aEUXh7T5nw7o7IYHDkK/Syrh5l/GYhsQqJP/ZtwNavhe/
	LKdSFZT6jy5qScXJ8snvZn/C80ET+EjADgqflJpwbLkO4gKJ+CryN1lNlP484jVH5PcFIu
	6bG2NZS+TNJUE6HEejEZ/2WerxlVUfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759176290;
	bh=q/cLnX6T/zKGoOmaRFeLoOBAUyb5A+C4olkKKEQG25I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bS7Fd34LgkadzAhRnQOjrTixvSu46UulYXMbwibGAXHRgJSG6/cTaGQLtYP4RaDaX
	 Q5N8rg666xDlo5JOZw/WJumJlQU8mQDJPM5bVK4L5ihM3QMbe8ZDplCNCg9a5JBY02
	 gLXaoVnqqpUF27OuHLFVbWjfnUhmvwBuOlHhOTpvYe6KVbTQzuQE5aEpqmYBRYo9e0
	 CbGzdUaClhbye64P592jAFA+MD+iivmwI5GnWgCrczwJY2WvGfrioyjYaUUipUIO9E
	 vE5p6NpyeLBe5rakX8RGfg19dlU7XFCnq5K3lHz8Og3XkjA2Kl+WLfBO7VLI3E4hAi
	 tuIGCWcgNjp5w==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 985E117E0AC3;
	Mon, 29 Sep 2025 22:04:49 +0200 (CEST)
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
Subject: [PATCH 6/8] drm/panthor: Introduce huge tmpfs mount point option
Date: Mon, 29 Sep 2025 22:03:14 +0200
Message-ID: <20250929200316.18417-7-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929200316.18417-1-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AE774180015
X-Stat-Signature: x59ecen48kadimspot9kdouy1wh4mgf7
X-HE-Tag: 1759176291-225049
X-HE-Meta: U2FsdGVkX18sjLQjVTJjoG1D4hR9kGl3nyHLigy+pjfvDL2t02adbqZMFFDNJV8BhGfirnlYf3HxO9GUAqpqnccWsHEa3wMuTU3ZCtR+2MdVrKwLOj/Pf2Gy0Pk5kKT3KoJglm5I3ZtS534szjmddQZc+MbnY/KT+YyszgiW2OGEz2DpPXjXveB0Zt3gCD1HzEcoCmTqd9+iqXj090BxCovXz+4I3UOIFgj8ZzW/0KOLiIWctAOKTyYWvSO63XhPSuGRJNYyl2NcICGQY1JUSD9p3RzPFMlw1pFyCBmRIoeZywjHpPBWlYShqHl8Ihpel/KsgioDWpySv9BYDYFzWBi4n6ZPveFbr/qZslVDzLpr4mIfOYozTBRzL9yTLYMgGRFSPn8xW7LSdiQ1hyIMGILv4rRila7Gr6lLo5TUG08cPZSSF7CAHjqKUwaaejRkBKS4SUW5v4BP4jF1932I3fz+fMMIUfav8HvKBPluE6jGKDTqtqmQ/SXLSB7oxbW5ckXfK88YkhMgQwtTLAyHVFMug3ifXm82+ZEuVBq6sD/OXBQzccMY7hS49vgzjBHFlg7iiaqUUG7yX7saf+szycfjpWa8Ewozsiwm0yOW4XYS6Eh9cFFGkUpjdNsiF+a6LQ6InAInFQE5WJW5A5iFc7H1m2lmXJ6DYie3VY4uE514PJH4EWluSimeE7mVYdoxtcPjhOZq/y9ht3UqMrTvCWYLhnIQv+371A80vvgbt1Is850dFLlvAiGbglMbNNQSY2iSIfcn0L/6Q7jaFMUB/1zWJtaQfPpm+mApeKSp01u2+uE3rk6O/WYrnC9gwTVasmRqKPsmaDzSaEVrZ8lcMjivcNB/90agIRQMxU/1PWc6D04DV+aXr2rnDbp/tOE1rADGeg0YFHOkD3sCCXJq9WO1xhoo1jyoHJSBYCePBCTzUEZ5mZOJEnWisDmltPa6lFnBOTiondY/8CwfWzo
 gYhqQo5D
 qA3lJsATXwifdszAHQd9zwUq06wHwleT2BOxtvK7+R3rrfY0jogj8dYHA4iQLLsdGw/6+MULA7ldsseZT73b5BZdGF780RlztlTJowyv5vb2Xt3emAYLMi5inDCrN8zDnBcbAmW5W66762K0r4Uyc2ppBhO7awCrdG4OHkd31v81cgdSNOdcQw7dpPOh/B6pbtnqPemhhZMrsfrfmY9vRbd5BqScM8vTcy8dj5woyFRC787xg6ko9UHwtsUkPJ68WdNs/Ls/gw/nJmAi2GiVl3p5S9WyX3orzFhe7xlx8RZqva6CMFZeU5QyCa2yByJf4LVHB+67/Nu5rlWhFGvAI5/ReL1Wl/bFZiJsedy1nZ6c/uEDYPt7WWF+bHs9viZGzt/BdZd1fIhR7cgFOMbPCE8e6WpjiJPI/4rrmz/92ee3rwO/mPDr5Hp+7XA==
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

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/panthor/panthor_device.c |  4 ++++
 drivers/gpu/drm/panthor/panthor_device.h |  3 +++
 drivers/gpu/drm/panthor/panthor_drv.c    |  7 ++++++
 drivers/gpu/drm/panthor/panthor_drv.h    | 11 +++++++++
 drivers/gpu/drm/panthor/panthor_gem.c    | 30 +++++++++++++++++++++++-
 drivers/gpu/drm/panthor/panthor_gem.h    |  3 +++
 6 files changed, 57 insertions(+), 1 deletion(-)
 create mode 100644 drivers/gpu/drm/panthor/panthor_drv.h

diff --git a/drivers/gpu/drm/panthor/panthor_device.c b/drivers/gpu/drm/panthor/panthor_device.c
index 81df49880bd8..4f254b574287 100644
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
@@ -98,6 +99,7 @@ void panthor_device_unplug(struct panthor_device *ptdev)
 	/* Now, try to cleanly shutdown the GPU before the device resources
 	 * get reclaimed.
 	 */
+	panthor_gem_fini(ptdev);
 	panthor_sched_unplug(ptdev);
 	panthor_fw_unplug(ptdev);
 	panthor_mmu_unplug(ptdev);
@@ -269,6 +271,8 @@ int panthor_device_init(struct panthor_device *ptdev)
 	if (ret)
 		goto err_unplug_fw;
 
+	panthor_gem_init(ptdev);
+
 	/* ~3 frames */
 	pm_runtime_set_autosuspend_delay(ptdev->base.dev, 50);
 	pm_runtime_use_autosuspend(ptdev->base.dev);
diff --git a/drivers/gpu/drm/panthor/panthor_device.h b/drivers/gpu/drm/panthor/panthor_device.h
index 4fc7cf2aeed5..54ca61567426 100644
--- a/drivers/gpu/drm/panthor/panthor_device.h
+++ b/drivers/gpu/drm/panthor/panthor_device.h
@@ -135,6 +135,9 @@ struct panthor_device {
 	/** @devfreq: Device frequency scaling management data. */
 	struct panthor_devfreq *devfreq;
 
+	/** @huge_mnt: tmpfs mount point with Transparent Hugepage enabled. */
+	struct vfsmount *huge_mnt;
+
 	/** @unplug: Device unplug related fields. */
 	struct {
 		/** @lock: Lock used to serialize unplug operations. */
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
index 156c7a0b62a2..16916e0b6d89 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 or MIT
 /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
 /* Copyright 2023 Collabora ltd. */
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
 
 #include <linux/cleanup.h>
 #include <linux/dma-buf.h>
@@ -11,10 +12,35 @@
 #include <drm/panthor_drm.h>
 
 #include "panthor_device.h"
+#include "panthor_drv.h"
 #include "panthor_fw.h"
 #include "panthor_gem.h"
 #include "panthor_mmu.h"
 
+void panthor_gem_init(struct panthor_device *ptdev)
+{
+	struct vfsmount *huge_mnt;
+
+	if (!panthor_transparent_hugepage)
+		return;
+
+	huge_mnt = drm_gem_shmem_huge_mnt_create("within_size");
+	if (IS_ERR(huge_mnt)) {
+		drm_warn(&ptdev->base, "Can't use Transparent Hugepage (%ld)\n",
+			 PTR_ERR(huge_mnt));
+		return;
+	}
+
+	ptdev->huge_mnt = huge_mnt;
+
+	drm_info(&ptdev->base, "Using Transparent Hugepage\n");
+}
+
+void panthor_gem_fini(struct panthor_device *ptdev)
+{
+	drm_gem_shmem_huge_mnt_free(ptdev->huge_mnt);
+}
+
 #ifdef CONFIG_DEBUG_FS
 static void panthor_gem_debugfs_bo_init(struct panthor_gem_object *bo)
 {
@@ -270,10 +296,12 @@ panthor_gem_create_with_handle(struct drm_file *file,
 			       u64 *size, u32 flags, u32 *handle)
 {
 	int ret;
+	struct panthor_device *ptdev =
+		container_of(ddev, struct panthor_device, base);
 	struct drm_gem_shmem_object *shmem;
 	struct panthor_gem_object *bo;
 
-	shmem = drm_gem_shmem_create(ddev, *size);
+	shmem = drm_gem_shmem_create_with_mnt(ddev, *size, ptdev->huge_mnt);
 	if (IS_ERR(shmem))
 		return PTR_ERR(shmem);
 
diff --git a/drivers/gpu/drm/panthor/panthor_gem.h b/drivers/gpu/drm/panthor/panthor_gem.h
index 80c6e24112d0..6804b3912cc2 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.h
+++ b/drivers/gpu/drm/panthor/panthor_gem.h
@@ -136,6 +136,9 @@ struct panthor_gem_object *to_panthor_bo(struct drm_gem_object *obj)
 	return container_of(to_drm_gem_shmem_obj(obj), struct panthor_gem_object, base);
 }
 
+void panthor_gem_init(struct panthor_device *ptdev);
+void panthor_gem_fini(struct panthor_device *ptdev);
+
 struct drm_gem_object *panthor_gem_create_object(struct drm_device *ddev, size_t size);
 
 int
-- 
2.47.3


