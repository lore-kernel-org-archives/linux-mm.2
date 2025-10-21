Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D98FCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69BB98E0026; Tue, 21 Oct 2025 07:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625C28E001A; Tue, 21 Oct 2025 07:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C60D8E0026; Tue, 21 Oct 2025 07:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 342248E001A
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:31:08 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F371616045C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:07 +0000 (UTC)
X-FDA: 84021904974.06.009AC70
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 392F9160013
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:31:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=LT69Zf2w;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761046266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Pncc/WJ79o2FLszwJigOVqLKaNLTkYykI16fXHhSHU=;
	b=RFxpElRgSa09hgjyR3ItJtt0nX5Wm3JYN0FYHcI/HhFqGVJjRiYJThvAm68mkeDVE4ozMU
	P9ziJNBI2W1brdCrOiQUEwG+jk9OLlCBl/uAG5LSr/1umEclnzRx69j3Fg+ISs/1QoKIVv
	euXGLr7bjZhVUP6koc6Kre/vmRH1HpM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=LT69Zf2w;
	spf=pass (imf08.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761046266; a=rsa-sha256;
	cv=none;
	b=l4QDnPMOpXRRco2ZnJ+0X3TgYj4OJ7GXvuouzWC3RC4A+XU43vYFTkfSmcDthlBwxWemlC
	hdZmqO7BRcaQmmO6fqgThu45rtK+LDOxRLPhmh8+84Nm7SAxHrXWJY99KpO9u9qE0bRnSC
	xfYDW/b2jHh3r1bj23e1zwKKCs71ka8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1761046264;
	bh=2kxORnZqohgg59LcjkC0YKU2FwOgFG+Y1Wny731E5Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LT69Zf2w4TjxCdii1GpVv2a3BuH10tcI7NrWGD5Bywi7YPXTBKhBVaYw4xQtMPeCN
	 2BEv6lmbL+xjJdEIZBCT2wpBj4UlLMzE3NAlhX7l3l7toy+jWwuGkVom1ZuPr1tEpw
	 0S1Yc2IoSMbLNyRF7S0aumzj2bW0wY6ofu6/d6JnfEURR+/CoZGN2jCZRCE06LXiGY
	 6h0L3kMFyFKyG4t/Y6TySbCOu6sViiEQP0cEdYIF8Y1H+VBmAJjt3Va1u/2CwcNITL
	 1hWYfVnutc4BSUJp157gZY0vtymfGmhapc0yKlAKAUqZKU+OjgaONs5WOmsbSYzylW
	 J/62fMysE6CUg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id DC2EA17E159D;
	Tue, 21 Oct 2025 13:31:03 +0200 (CEST)
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
Subject: [PATCH v5 09/12] drm/panthor: Introduce huge tmpfs mountpoint option
Date: Tue, 21 Oct 2025 13:30:46 +0200
Message-ID: <20251021113049.17242-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021113049.17242-1-loic.molinari@collabora.com>
References: <20251021113049.17242-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 392F9160013
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qob4at1crfwnksfrgx8h19qdo74ajaa3
X-HE-Tag: 1761046265-657910
X-HE-Meta: U2FsdGVkX18B1RUjTlwdiUj5v2F+UXL4h7YWtcWP9KuXWCwct8tpErT/SduZUuW5WuUOOF5Tj/RVYlOYHLxKaRVYPLzlwOkVkheDyiXGaMsYhi9TIuQqmUqQeKj19VMUHV+NV/Cp0o3MgWN8CPf2yxPkpW/u6zAu76GohSvtD9BZh+qmdyZ5BvR/XvnhWBbg9TLiQdSxOwUXSraxr2h6lo1ESqMSDq+wFFbO/ZNL4sBCVJiFQfIU325ooo0Y24aSiZTcoI6/16fdJL+TsF8TCR2sGCuwtK8cGvL7dvMP0dA+dVEJm60bGbk6CD+tcgxTPPbTLaIoM4gycYKTOOrMQ33H+XXLKoRQbpSfzetowccYoyvGI1F/CorDdgRWVoJMnt3O+Y8cqTu/HQ08bZzSKc0A7sGnWA2DS5Hic66vxfBZ1PIb+1pwjnM03oB3uoH7Dne3Gx6QCLgW9DZFTJljrUdIgRmdAREJj27RPJXAw2q/nRnuE53V2cjB7POns926oVbZVUHN8oV6AF+s5u+eVL3KjOKYwr/MTXM5qUmRwwb6DyN09ft4d8GElQQ16/iIkL7eHYEV1RSpe5cseJRh4I4LuKsjTWpdYe2Dtvtv+bEzV5IRHzbtlKrTaZkso/wCk9BEQ1s96SzFeJya/xQIORMW2ab7iKofmrFqo3ChFOt93vcPx45n6BL78KxSNuAejpi7vcFk7rH6a9TRqs9kUooaoLgl8wHAaQugbUtDgmLrzJgHRDu8C2+/GxAyTXAG7O7GKgVm8xl2dZLp96p81GwSo9f9+jm+/A09tbrUYjoCaK8gvDAy+8Y+BXY8yNFB2GSp1gW8U4i8WoBTuCWAG2eevg8/cXYyrs9e3LAno+d0+L278sM6jDRKp58fTAjq531LslDXu3C6HvkERwKttrsPskNZ24Cba/TZE3itKjf1TzNeJjWQQlO1/e07alEkSx6PvaB5qLgehgKWgj/
 vECYYJNJ
 bTo3OAlO4kHarZF8XsaKQ4zIe5Jn1wmct+M1skMGXh2WkSGCeFNA/g7KUTZ+lxlZO9gGqC5bVnkPn+8tsdS475sJnN8+lyvzQ387aVj1kXb4mg2krZgmhaDUsxh5SWtKvMkQTl/QhfJIRb3VxQR915Du8o6THDQoZYnSMgjbfPPwFt8TRzSqhU3XHrOSFqZbG4U7Ni+mUy1NvtXSUmqVaW/lRX+zQ5o5HzNGQbtDHZHSWGfn7t94Lq8kfXIgRh5nKwlhUCBFBTJW4IeHPex+4j/RfD2BUMxUI7sVjI9vtV5b2OgGNmXJJl5KslYexQYchdK4z5Fy0t6YerUtcxDdjlC3fJIFg/PnBCXMSox+I0epUDjmllvPpV4enNa6wAmLlxR0TLKT9RWcehBffe7clxUFqjpfLiHHvWOxCGQfdVE2p1Sm8/6Q5rSsagw==
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
index 156c7a0b62a2..b5326b29417c 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 or MIT
 /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
 /* Copyright 2023 Collabora ltd. */
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
 
 #include <linux/cleanup.h>
 #include <linux/dma-buf.h>
@@ -11,10 +12,27 @@
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


