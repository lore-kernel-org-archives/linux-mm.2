Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54283D339B2
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CFB86B01FF; Fri,  5 Dec 2025 13:22:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956BE6B01FA; Fri,  5 Dec 2025 13:22:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64BB86B01FA; Fri,  5 Dec 2025 13:22:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33C966B01FE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:22:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 005EB1602C5
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:45 +0000 (UTC)
X-FDA: 84186238332.23.6A204BF
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf25.hostedemail.com (Postfix) with ESMTP id 31221A000C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AStTFNa1;
	spf=pass (imf25.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764958964; a=rsa-sha256;
	cv=none;
	b=OFq6un64Va4nJ5bbn/cK8HKZ/jzqkmJRBz4KNJ+I0OdgCqDhBjOg9wmLH8+dn43RvbZjY2
	hv+mpLZcNLZnBu6wHdOvZuhXoB4yO1+6SG5j2QHJdS8y9gac92fsY5JP/ZR+Ojnsmq/ZDZ
	P79WUYpLdQKpRNglzzzLXRawmxbMofQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AStTFNa1;
	spf=pass (imf25.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764958964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZubJpgXA/r8iZSfFYRtgtxF7bvJQQILscdO2Gxc0EA=;
	b=d9ew3r9cAeDDBP6J1R5/srfLqnNPKGQZv0gMWjwcYlj7MQlfKCs1ZVBudsAgfyenxevyYb
	fSXfY855okG66rOdyAiU8LQ9jQCWlFyBXfwoG3RfhJxTfblR/ToHG+Cy81NhuM42OfgEhQ
	miIPkEot3LJ6a/l/pQLH0mqDHk+nRQ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764958963;
	bh=F1rCRjHVfh8bH8B/+i0BPfPQ3yN/lBB5cVPjicSkJlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AStTFNa1hCXVDuCDNp9ysd3WHiZr6oyc7UdUV+sI2f1ofubWBiiJJPa8XKYSPsR49
	 M9VsTS1ZdupEV0zEb5BBlqnMgRaAihUE1Pc5PsjCWNqrwjqEELGL2VZwhcqlPZbgdE
	 7Erl1SSy2vttkVDjOCBCBEju0V9OsId4trTa1apOhpG5zPmqc8Ye/E0IJ0I2931mip
	 kb/KvLRzX7a0F+pXeSS/Jbry9JXBvaBvOXJBbXHJAjGTOVYu1iD6UvAdzteL5yBYxr
	 G97Uc4oJ3fRRF963ZExQtIhVEfVj/sArrTmSwKvdCfwKpLbv0e5h6dsldAlfi1aQy+
	 5Nw2ZHHo1tBAA==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1D97917E0610;
	Fri,  5 Dec 2025 19:22:42 +0100 (CET)
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
Subject: [PATCH v13 08/10] drm/panthor: Introduce huge tmpfs mountpoint option
Date: Fri,  5 Dec 2025 19:22:29 +0100
Message-ID: <20251205182231.194072-9-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205182231.194072-1-loic.molinari@collabora.com>
References: <20251205182231.194072-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 31221A000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: hjfujbufeepcez6ns3wch4nsh4pbrk4n
X-HE-Tag: 1764958963-373542
X-HE-Meta: U2FsdGVkX1+jL+kRZV9mvbrScOUcaeHlsNuNOKl3bKRAwg56KabcQjPOAhvJ482vYjvtZd4+rugCYVwNNfPi5JkJsBdVVUkX9fCGaRW+ydsT3NvxHzv7oP+V6c8OiPFqWdyDFnTxZTuELti0Qeuk+hJD/n336IVlejPsWnoLBJByJmUFboPAZz5yDHXesMtucbPgkVt7It024pKYenxrdguYiE7vI/4NPw/tz7mrnhiLj8nbAJNHUAzac2ot7ViZgalMq9+xhVwlKH/Yc8+z425wRDsGShkd9hgCSqHZ/4IRupvcYfd0TlKjoIWMEhdUZ5oSLe1jaVdokeQjOH0K4oHlSbS8Vclw8cAXn1qYQ1iH1k7yaTPnBdY+ZDb9YAJkDHnTfrr5UkmCnLg7nP8a1AoN1R5Lu+OSSpRKYTRYei/WVhRT1/Lh1S/3YGSBqVFNEETIRgXeqra599WBcQ+pe3dpsjiJmNNyLs68XEJounv+obbEzTKM0dzFk7FxGLHet8EETcL4b9WWCrm1Hu2M5xlSksYzh8pIM+STrGqlPwWNJt/p4rhNcNxBdaRyvnORzcpiVFiNS+aGWu9XdZatbG0V1Mxy9NqiJKNJtdUtlDN2SH73vqdkbxDqdCERjMfLA/fHHWH56LbJmrK6G6OwYzo+rUqIraCEWSez8EGrLqptb3+f5oLBQYU3w35olZsybxrxItySonkndg6GpnceEG5QJR5ndX8wLbGajHpZ3M/i4/RjHJHBuM+8dIwk0TJnasUN/GraeEu3LHBUrNvM/7ktdRakqRktUr4QqcxsQnivIjdw9mTRyMvoqZMpEF6ytg3R0rlWj75KmnXxJ7ov8vrlRjxVsreb1irWrgjHbL7jVXGOjRueJg6uE5vbwuCdJo8JXaWxGe8Zh4nlcP2j+IOGCJl7Fq49cYq8MNcPEQ2aU5g4HSGLrIn3JFKB3fS47KpcRYPzgBacrsBePUX
 50M2527e
 hkJVU7XdJ95Gc3hpfpTWLOCkl2fCHMSDTPlLdYV2Uqq7hrVE+tSrOTGMfQaCmC/RpQ2JIbcC3DbsWy92qqkXfGzysSt9zFNS03FxUK/aKSEy/7OhJXcliJVRi9XY81UdpgwerUNtLn6vFwKEnYr+fQZQD8pj4S8vnnnYtY9QuJ7da80LLRitYvGtbTry/7rIxGpskinOhlceTzHh13O2ffrSuTKzIfbG6C968VNnEt5NGnZ1zXKGpbW1IHkUhqUD2q7Y528FbKQBgIHMYDFIRU4LOEPcjlyZmL5QCkwI2VLorJPDJ+g6b/NFjRyVoyvGIXNvD+1aqBrZMG/YS7Sf1mHSjMOsR1392BsWUr9lY/08dDdtISbIHjxbKpS7tQYwhJenKQHGOhJnqJCv1v6IDxns1QtEKny1BlJRrAz0A0Kjw03YfKX0c50KiQA==
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

v9:
- replace drm_gem_has_huge_tmp() by drm_gem_get_huge_tmp()

v11:
- enable 'panthor.transparent_hugepage' by default

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
index e133b1e0ad6d..2979ee0e52c2 100644
--- a/drivers/gpu/drm/panthor/panthor_device.c
+++ b/drivers/gpu/drm/panthor/panthor_device.c
@@ -18,6 +18,7 @@
 #include "panthor_devfreq.h"
 #include "panthor_device.h"
 #include "panthor_fw.h"
+#include "panthor_gem.h"
 #include "panthor_gpu.h"
 #include "panthor_hw.h"
 #include "panthor_mmu.h"
@@ -294,6 +295,8 @@ int panthor_device_init(struct panthor_device *ptdev)
 	if (ret)
 		goto err_unplug_fw;
 
+	panthor_gem_init(ptdev);
+
 	/* ~3 frames */
 	pm_runtime_set_autosuspend_delay(ptdev->base.dev, 50);
 	pm_runtime_use_autosuspend(ptdev->base.dev);
diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
index 0b0ec3b978c6..1cfed4fc3503 100644
--- a/drivers/gpu/drm/panthor/panthor_drv.c
+++ b/drivers/gpu/drm/panthor/panthor_drv.c
@@ -1559,6 +1559,7 @@ static const struct file_operations panthor_drm_driver_fops = {
 	.read = drm_read,
 	.llseek = noop_llseek,
 	.mmap = panthor_mmap,
+	.get_unmapped_area = drm_gem_get_unmapped_area,
 	.show_fdinfo = drm_show_fdinfo,
 	.fop_flags = FOP_UNSIGNED_OFFSET,
 };
@@ -1627,6 +1628,12 @@ static const struct drm_driver panthor_drm_driver = {
 #endif
 };
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+bool panthor_transparent_hugepage = true;
+module_param_named(transparent_hugepage, panthor_transparent_hugepage, bool, 0400);
+MODULE_PARM_DESC(transparent_hugepage, "Use a dedicated tmpfs mount point with Transparent Hugepage enabled (true = default)");
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
index 10d255cccc09..7ae07a9bc996 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0 or MIT
 /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
 /* Copyright 2023 Collabora ltd. */
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
 
 #include <linux/cleanup.h>
 #include <linux/dma-buf.h>
@@ -12,10 +13,27 @@
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
+	if (drm_gem_get_huge_mnt(&ptdev->base))
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


