Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ABA2CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4505D8E0021; Mon, 10 Nov 2025 09:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FE238E0002; Mon, 10 Nov 2025 09:28:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E918E0021; Mon, 10 Nov 2025 09:28:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 149898E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:28:03 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A380F84E4E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:28:02 +0000 (UTC)
X-FDA: 84094926804.07.A868B17
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf17.hostedemail.com (Postfix) with ESMTP id D3AE340010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:28:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=DS6Lqnju;
	spf=pass (imf17.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Pncc/WJ79o2FLszwJigOVqLKaNLTkYykI16fXHhSHU=;
	b=yb5MjvKxrOBPDBk8innEF3jzHb6vEMazWjxxcP2at7XSd9HHQBvazTg77SZ9FMh4vgiLuA
	pD4ZEeYB7Y6dYzsLipzZPudWF6LIn8O2i5q6YGYh91QPlnJ3SMBLtW5Mak4eBuTeG0iQTZ
	3+oaaPjCnRU5myX2wr3tJ+BnIpgsH9k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=DS6Lqnju;
	spf=pass (imf17.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784881; a=rsa-sha256;
	cv=none;
	b=usbpfQ5gERklu0V93hPHumMqfnDIcBwX8gCKBDmQ23rQkg7YGoAW/PWrBe7sW+i/DaffBZ
	vcGOEA5SvafsuWheSLWpU1FyVvD5pLc2+HNU2yt3OvvgTZJihIq0S4jm2JtGW+RAwti6PE
	aYqsRw5SXVLtDbNPOgclcLD0BuQPQw8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784879;
	bh=2kxORnZqohgg59LcjkC0YKU2FwOgFG+Y1Wny731E5Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DS6LqnjuxhB151qpbhanJA836at/lx9Zo8A9KG7WOYHOShJ2YfQY0gQAptN3Lw1qC
	 SZdJL3N/K7fSnG6tdVxfjvXOjYBsOyj4taO8sUEInq7uLnYLa+zj6TjxL4lkfTt0F6
	 kOvbekE1FTmBfR17As6UHGMwZPMDJKRu3nfOB/7QOvLzTYRC5qq3cuiIIQdFca8BWh
	 axPFRCsU4fyY5bFxjdCHiJvXW3q/5Z9mhgx1iP6JYF06L9lbOAKsmsTyBTGRlpKPHG
	 y1TDaCOzqz+sFkVrTj2pa0LQiSL7MvW357p5Cz71IjyzHvJ6g1sgzPQubvPZtw4N3V
	 2Cb8YcoiB4OHA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 6ED2717E35CE;
	Mon, 10 Nov 2025 15:27:58 +0100 (CET)
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
Subject: [PATCH v6 08/11] drm/panthor: Introduce huge tmpfs mountpoint option
Date: Mon, 10 Nov 2025 15:27:43 +0100
Message-ID: <20251110142746.3490-9-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110142746.3490-1-loic.molinari@collabora.com>
References: <20251110142746.3490-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D3AE340010
X-Stat-Signature: u5daeakjetwr7r9zmiuyfj8zpem7u41c
X-Rspam-User: 
X-HE-Tag: 1762784880-783173
X-HE-Meta: U2FsdGVkX19Kqo65qllYASh7PECOSO3KotnvLfawOopYO48U26qFl21pWmvvElhosQ/oab1Znb4T15bodUorpxwwTlMnRqh9CMql76XEmX+SrOY6jf8lb/EhdC3Fumu0ogPKCJExHuaU0Gtb/c5g8i9tf2545oEioYkCCQ8WWJtT3h9fWNsv2oS134+h+xRIIi2ViUYk+/XDyFZYh8aIrj1vbhjf/1+oaaAhWwflWLfattwA38T4t5uf+YaSXYh69v0oHERflvXq07SvPRaFezzGlOXLqafzp5EOtvJgT16L4h0mIgF0zNnmNWWPx4prHZR6GJSXTUC56tpjgZbQmKTTePumuTxSrZfECoyX08vWKXSBnSAJjCNGY6QM3YJ0nv9z2X7BDOPtoa3OMvi/QgqAxX3pr12CLlKMhmeCDkPnghx8LKDIKhWurs81pr2aTBeMeZ823tukMiTJrxiZnmaWJP0JD7BUr7+101DYiEWOFa56RHQaivwpGOSVOgzjYuim2vJWTc4ZCnS4qT3Ah2GhSMvcFHDK3RUaZsBobuymDMtzY7zyC6VeaHSEqG9FOxyYz6AWUwukCmsm+m9UiyF4fgcSljyAeFIP+vUC8oIXj0oitmYkWfNp4LHszXJfoxDu6J4NKErF1BtmvJZlQ9GMhqybZLJajei5qzE0L7XnqnxTFhtfgri56pV03pdL7xnCJNBwhiCldascMoFwXwr80H9+y7MghefSoWMeozERk8xkTxBrLcD3rglQwVKgPpOLMvRyjDAeyUyntkgRVFh2jgNVvHYgoTw72VIRn4RLrO3CvMBV9ew0dNtW0w2BkuVMfnoLam7zTAe3Hgk4qAHF2hPozJ4+Pp69Qf4nHZjw8X4Bi5lorozvit0QrzyJA21vCfYQFnACwUVJZkGFKI/OE6Iaf8NfHHZrwAWtLKgt/GSB33UiFuXymaqoWVySrkSaGHEp9a3YxMXp67c
 O4WO6GxO
 YmxWmR7+2MthZdJwdqd5xAiBlOCGE2XZXJoo644q70DlNFvz88A4YvEMRI/CW9ZqLRMNRMrt/0nzQf7zfzf8gY4RUn1VWcdSA7WB/mKDJsSFLFSEfs40tpvXdqDXFiyB7BFFnAoGk6hbAeb4+u6af5DgN1LUMm3L08pSCeDp6QfwPE9t41UQIbnulza2C69cpU0lL8Siz3fvA9HLngUmQgIEt2F/OMLFbogQmCmtDC03dRkAl26bRfTf0p9OWrD8VCF4v4YxMFtiMxEjjWwed1lol/iaD83j5y+9OjwR2grZ8imYhL0XwBZqbf7+lnE2qoZME3wFkH/51tESSuU5mXmfEDjR4bWWM7QFMxclC7WGCH87CeiSm6HmuFMOdL8iyxQ6oBxupHMKLvRR9Nbig2YirkO+wjgXB3Fg1B51OCdoEt0snwwGIjn3jOg==
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


