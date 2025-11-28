Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51F4BD116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 18:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBA186B0098; Fri, 28 Nov 2025 13:53:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E442E6B009D; Fri, 28 Nov 2025 13:53:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0B926B009E; Fri, 28 Nov 2025 13:53:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA6386B0098
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:53:08 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8890D50BBB
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:08 +0000 (UTC)
X-FDA: 84160913256.18.8AA8058
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9DA7840017
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:53:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=gsLQ9dQa;
	spf=pass (imf17.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764355986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKm1wDYU4jUKbDSi5VSS1Z+ocnEFEBIRWtHj/HFEBL8=;
	b=0QBjNnl8wePPmiFJ5G8mNO3zf9MxPtyZJAdPFescep8HDL9pNiMTt0TlM8puqg7JgQyrdI
	Y+0Lprxm8SdJRvbU6kHW7VTsyAO7dioRWqvUU4hYaVi5GDasck9vZoPbyRw0C2QRUv/E0a
	3+Vv8AlS9zHomurutjUhhdZNi/OpjfI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=gsLQ9dQa;
	spf=pass (imf17.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764355986; a=rsa-sha256;
	cv=none;
	b=6UWQisdIs0Ys3k6qKXSz9UBVfhh9GwKKsk0G/9PYa20h6lRydmcpIIg7CQPx4mjnpXa8oc
	fitoO4JCfyDIuTJ34PWBvnPMcxooYUBAXrUdCmzznXCkvsf1htxqZNCtO/das27M6XYZlc
	DtiEE1v01ckD0sNmtWuVz/jLcP8/mmY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764355984;
	bh=j71+p9YAh5QPiawZ9VZM73M2pNS6NNm74Zwt268TaXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsLQ9dQaVhez5PL7+FLh3wuYV359noD9/dcixSCZyyysdcPraJXeZt5TQpjWLdam2
	 AGDAqGg6NkYNx4ExwLGV6RR0i5RBcig3mieRftYDP+JQr7ldOJi6a5Cz0D+uuKgxGB
	 NvQDvPuBeVDTXJXT8ooGG+QhdCbyfaWOp+LQ15+wH+mxv3BqZxtTyQQx/J9ykjF/oP
	 4LFo8QNxe9sVd8Q09mfzzAgQxkuJkuBhDTLP6EcbN76kIvXzWw/ukJXI0AIufY6awG
	 pK53lOP/uwlZRnFaD3Wrz/2MAe+JlN2WNbBIn2lNhYXw9gVHf9QpS9LXWT42M7xD/R
	 3Kb8gi9H5yFqQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0EA8917E10F6;
	Fri, 28 Nov 2025 19:53:04 +0100 (CET)
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
Subject: [PATCH v10 09/10] drm/panfrost: Introduce huge tmpfs mountpoint option
Date: Fri, 28 Nov 2025 19:52:51 +0100
Message-ID: <20251128185252.3092-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128185252.3092-1-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DA7840017
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1a9wy114ryh9wsc5xpmjufias8im739i
X-HE-Tag: 1764355986-533709
X-HE-Meta: U2FsdGVkX19Nd1dbYvadOAwVh3belQGX2FvRaZRTMP5Mx4X6PlelAupLPNHa4l3Dk5SKpuJw1nA2Tk4U6qIKPEcavpG9HW99Zx4JatMRLo1z29KUPeB79rlkMEUFF7QNCppea2VJtCQ1hDN3+QxzR8m4pmZlAcqyh/IhPBkVOxIfBb2cdQTcF64Stpzzv8lm9uyrRmmrWqNAR7Y47Ebh+HkbjQx1QJ8HA04d6dIoUhF89DaDs0ubMNxW0VTV6TstjuYIjLz8x7B3IcsIc6wgeLfNP5HC1SgX6Z87a/ax8sTa9IvNJnRSEJdpfc1LHw8e4dj5wCl2BVlL5OIOcZql65lyFnlGH1Xie1N1HTBQ3Fis0n9WaUMnzRcZhpXDqOWz+/eGbjofvAAC0klR7jPpkXedcH5UTWAMutKelQ1eGrHvebjyeqxOuRI7Z2ecVf/trnmqJjbZoLyJDJi/rzA9E33cCmTRkOqrvQ69EaE85S7ch+l1xzl8772F51jk9KGP/CQSn2sn5tiHEUnU2pDrs8MinpIJavx/tYrn7Pr0vsHenmKE0U+3I1M+3lEsv9514xoN0BTTWA7gYf6LFJhtUgYHZMnvMayaOMzgF8eyw609NI60pF0r++2fWqrQuic8N9HQVWnbXK9SSa8urSbT1JarP2jDx1jxJ/AhZusL7wM62Zf7KpyzrPgN5sGzeigSLup1viZWGPWmUdDOa7r++ELeKqDTBs+5sN8KwuZeldXj5oNGr5ob6gpAM1jrMWc/lf3TrldmPmi4TKyU2gVcEM6UBy3zcRV1FGBlcQ9vklH7x5gU9Ug8JBwXK+cpbkEImlxL5HFK+m2szmJTuPg02Qp9Eyhr0r0rR5SoqnQUO8oi1x2wnhS2eSGC2Ny5k06/yFNlmF4I3YGogUqXQIqc5jjFr35C8xZPILOmH0tVzjaSvpfpYvp9SjLOKIpdnQtjJa+O5gTIbvLaMhCuGZ+
 tapP/auW
 iAUF/ZQTfGtD+2tudiDJq81/W5M781uPy+4Q/fFQTVfKmDP57ofmpVAq1V1qrlHX2oDdqtT9i6C97xihR8JdrceJ9hcUMZFxcFT54q7ZzH8HbdsFBicbNzwp3aABEfnvX06YCWxhE8OQDcot4vkxvkYaWp1X3BGwS5Hdq5/h/xmLh9Qsa4FTfNtMxzo609juu/FeJVOTeCczJP4uyYc9Peo6mqmmIEFnECjMQ0jnptCrmO8hHb0N9snbomRo8q0fezcUDlOE87w0IwI35OS3WkFPE8KcSw4uo6pwyJg429gQ2GGWVjhJ6+aeBpQ1caOKEkEJE6yjtuZg8rzNTUtLbiTus8nUX/dUwhtmnjCx08XybnV3MTpmvNNNs0ONnDO01gMkIIA0UosDOlD3ODQTgzwuWIe8yI+2X2bRSiyZWM8zbcNbc43unAkUBJA==
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


