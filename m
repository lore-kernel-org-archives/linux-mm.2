Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0BBFCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B4D8E0023; Mon, 10 Nov 2025 09:28:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B548E0022; Mon, 10 Nov 2025 09:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC368E0023; Mon, 10 Nov 2025 09:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E63C8E0022
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:28:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B816129DE5
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:28:04 +0000 (UTC)
X-FDA: 84094926888.25.E3037E7
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8C802C000E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:28:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AmgqJRlz;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf10.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762784882; a=rsa-sha256;
	cv=none;
	b=ZfO9WZzzB7yCGxpLjJG0zRcqO0d/qscpeVFSAVaDpBVXE/TciHKJQPynBW1wGbocfujTuC
	GwoQinL8a+ICyooR6WB+x1PJMpZR8AKmSuo+cuvBmUf8BcvvS0I9stzc24YNcWCE8PphSC
	QoFcXhAal+QLGMw0PEnRtqkUuKMnHs8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AmgqJRlz;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf10.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762784882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bP5LkgJwrDjNPUDyj4f3BiaW+dNMgKFu7Kh/R4zNcY8=;
	b=dBDHz1LZZcuSKqHJ+my2UqOc4A0iPKB4aa8jjeeROuVrK/m26ywAKcqup1lkC7Wq4+K7qQ
	a98VyWl9MOwlGspwPQ581CULNnKvL62V86Z19+E4OKJAlxD/iWI/7e4jDs6FYiBqBCcyOl
	MNyrZZWOBuQoLzMqy+93tdE20oyp9ZA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762784881;
	bh=mlBi6AMWO1tGRBEEMvytVH6FWqoDNn/HD5c/lE3bK9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AmgqJRlzAwu43l9V95wSU6LASAhEG22YuDJEJmL7kWrXqPNBnUyUgmAvaKacT++/+
	 GVkriYAlUXB2ptOf/1gGJdaO1mxPMVGtUEzz+Lhy01QKqlh8NcrFfv+FaqNZX6MLWA
	 P8vGsJIevQnTqQ1BNsR1030lZRCa0mwycdMkWogebQrkJz20BNd95oKauxhsZJEE3N
	 ChJHstxvNvoLHT1CnlaNGDllsVKMCvCWDtLYEZayJ/RjnUo+bqp0iJH02CB4tVmL6R
	 EuhltSiMxxoSjRZC+i7XUAiV4nP9lIumlCEZbTbatiqJKIKjTQzoeFMFKBgTF+BnqR
	 viU+4nB2PMUmw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 73AC317E151F;
	Mon, 10 Nov 2025 15:28:00 +0100 (CET)
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
Subject: [PATCH v6 10/11] drm/panfrost: Introduce huge tmpfs mountpoint option
Date: Mon, 10 Nov 2025 15:27:45 +0100
Message-ID: <20251110142746.3490-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110142746.3490-1-loic.molinari@collabora.com>
References: <20251110142746.3490-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C802C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: p1hidq6wdhswhx9j9n4prpnt6gjwnb1w
X-Rspam-User: 
X-HE-Tag: 1762784882-73287
X-HE-Meta: U2FsdGVkX1+QnwSTbUYdIDSlUAd7XCXTpruoU/G9MbTViU/IRwwm5lEwJQ+NWKLRyewsI6GuhcBjZEH5qIuvK01CJyMrsGXzndIgJDlNs6WbX090woTeQT1rLGCLhGerQdiopEoKrm/9o37Kgmk7JgGqCU8Woq8c0uwqrLWQi3UNO1fxtspTDNmAeo1kNSKWdWTys5AYOjlZU8wAVz6gNU1/3u0mjk+sMFEisrN4aCAZGahkghBnyx2dma9iPA7C2KkdTW1LrQP1NkHsgUHVSu55zXr5TQt13Jh0kTObck0ZWJU+Io7nAvN3eWGlvqDlwWpwOTd6f5S+T3T+5HX8OJ3rOp8zBc5OgwC3mbjaQE0zEjHrcLJebZNmUH6Qdib+60LMrsfJkP1ftlwuvOPJ8XieBgAgwtQOI53qYOxn73liS1v+rgxEAy3Ta6iK3eqD0ZpMzR41I0FSTTOfhpxIRvoD4M6fuly9IYJHkQTt1LVVskoGRUvwPJTuKW0akWEgWtRSRk9fBIm6M6xRlhxk7YLr6kX3/InrgC2z120k8M6jVus3JxvYgM3x8fo7qDAcI+NnlHVFhdASZ5pss1ewLQhFKT+m4gb65KALweQkpP58yQhKqC2VdtejPryk9ZWVE7YMLVZs34KF6tzy7zkRZ+d79aSf1idNgrbAnK2Q84LrP04xqODgzi4NWti5yRGRG2NTF+3+aY59w8f2lKmPL38gWmDbciZj/4xAUBWWKZCj1MbFnDVVkgyn1Fn9mfaOceZpqXoKRyyopRrI2r/axI2+u/x+/myG7fpUoZtZYRcDN/ZTNRRaID6tnk1fcEB+fkE35hk1ExZrw4mlcuxP+7ii5mzTprh5EM/5c3fZYS/R1Mwb19uhaiU7il+DglULS7zMK/1WJnujW7R6YXAM+hrW7GKJ3UEEYwgFjsViplNTeLXH2ob8W1vJL/A2dBCc5tQdrsuMK+wu1xP7hkU
 QMBazuNe
 tLqx+9DuAZllzWEMdAfruk8Syr3A8OJrjbw2SYoMPte3oBH16XSNMUFzCpt6Uw9n2JG3Q5NGv1VcbvulHskl6PUDgFCSQ99qamymhBFyiRSohM+QLETTuhdwaZWCiS1/0wuwyQa/cNlUyvQ/d5AH1bG8QBXdvuUJCrdYGCIxALeL3IHqwpJhegGohpTJVxrzJuzVuVsrLyfRkm8XwxPIXpspo2cl2mC3bNzVDzsrBpPi9lLIT5lOq6NFc+rjn1Yv/jw7EGErIzwGch//xxzuLt6gD40n+xte5s7uvQJeCvc1slOVonW5w+Y5Q/zKfg+WLV69Kzk+vNYx7VGPNW9TwG4LySlJB16uzFDP+4Z+HFluK0SjEtROfyTfeEiYUNnosWxBMjXsJ0RKPVkjVkR/5cRlWK6biYhnUoZQwkXLhZFblAFZWDwO8k3zUCw==
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


