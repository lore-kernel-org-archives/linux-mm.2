Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ACCDD339B3
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562AD6B01FA; Fri,  5 Dec 2025 13:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539FB6B0201; Fri,  5 Dec 2025 13:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4026D6B0202; Fri,  5 Dec 2025 13:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 27A196B01FA
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:22:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC3A8B6E9C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:47 +0000 (UTC)
X-FDA: 84186238374.18.7285048
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf06.hostedemail.com (Postfix) with ESMTP id 08CF918000F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:22:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=WXEAP9Dn;
	spf=pass (imf06.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764958966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3mCrmSDMOROjrLbceWFhJy/9JisAvfMvvwSwMuXsr0Y=;
	b=e+ajzOIBrVWNZfXjgSmR2bWQNB3cxKW5SoCkyBPnODXabthXDoL+d3+fENHcL9KTbkPA0i
	mUYfg1N6T8R3e+q/mnlC2oY0fW44eoXG5/XwxXzIde9J1iEqlwEPu0dDI/HKe1lziGdY86
	//iXRP4ko0ft51Svk++vs9kQCfF6qOc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764958966; a=rsa-sha256;
	cv=none;
	b=5PuCZ58LRTiotywe50P4hR8fDD4Z5WdozXZPw9aIRsv9TQrrkz5Jy/ke6r+ryjxn+yFq1T
	Uic+ANaM2KTyagmPkoeVIdz3rSQwlgYVGhlI9o78IQBUFA+2CsRLhR7bd0ZQ6RqA5kAlHF
	rVINHxJTdEU9DgpyX8JkF1HKmBesR90=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=WXEAP9Dn;
	spf=pass (imf06.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764958964;
	bh=wyWso67v2Pmj9cYL41opZ0W8Md0EXL6qC4U3K6oFpbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXEAP9DnLRAa2VqbVgP1ZI1i9yBdfebg6WUuoo4fS3nTMH8hzfwbTrNaksF1dnBJP
	 PC+4q/E4LEi0jRckWJnB179tP3HvqhZp+fRLL4ZVkfRK4UvbjF+Oy6xQlE2YUbO3vQ
	 UUSFNgsjMrUdbL4s6i8aAov3/1das15BYbja2xy/ZyrnTmY0Wg85GpUp/37eSqi4Ce
	 ETSF/t4SMRl+usFAq0QZkJByyjtf+8IeVbLnxvTWLicBrJe97NDMTFgQpH9ZBgdZ4U
	 H6U7ksB8anBevvLjlKE8J5p4bi8gdLeSjIAimiUF5YIpwB5/wEojVcRxH6Y1ETMNh0
	 3NVMha4k2rS5Q==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1E83A17E1546;
	Fri,  5 Dec 2025 19:22:43 +0100 (CET)
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
Subject: [PATCH v13 09/10] drm/panfrost: Introduce huge tmpfs mountpoint option
Date: Fri,  5 Dec 2025 19:22:30 +0100
Message-ID: <20251205182231.194072-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251205182231.194072-1-loic.molinari@collabora.com>
References: <20251205182231.194072-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 08CF918000F
X-Stat-Signature: nafa1epyaygc78u5bhwaaf5ofiekxo9y
X-Rspam-User: 
X-HE-Tag: 1764958965-283392
X-HE-Meta: U2FsdGVkX1+7MfO516DMckzJliTHjeFmoeCgupmiqIqQH+/EH4awM4yxeyT7w+80/X2cQPe2wJi3mJXIEnsoMVthcQhraE6R1Xif/ir+Ftyl0D3cHnqcxWCJ+m/xu0prs/HUNCVnpxkZedOcbuHb6WZDQ0N/jChtoJAGsjuFvBKtiSPutmMCoDMPpBkzZoYSMi09oJ7OlG+4AXVo48Jnmi4zQ1JiOJnt+2PTxN87letM1IPHo9vOQZPbAumBjnmkUEb+swPShuNmRD7Hawu7a5INMCvONV3+SLwbKKzVW4WjhTGu3tt+TdVxX8SI+i7GMF1ji3j/z3P4brVBM64ZkegP3QZIyL2PhiSrQ6yrOiUHJSemU6k7rdwsawMm6kdPx7+QBFJjqrTSBM5lyMqA7ASMRYv7KL59EaV17FNhuHC+cm0T07SqrUcr7OzgWWKCATJx7w6CdEnurf2YXhPtRcJP1s8k4rqjTPpbI9/nVIaa9NRQuykl3fgjlU0PqRSCXpad+tIUg9IHeoQdIXp5KHnt1OU0qtQTOCoO6qEOGQIUh7xuzTJMeTx8Tc2PGKLUia/To36etkKVri8jdm5oDIPu0W1TKb2xrHOoGBJjsnnG49uIMLrWn3ea/DCaeNwQoTZO56WDGLN4D5YSh9iQqEhAt4ON4N6OaSG+5x4150ru4C5cX3MsrJ0Tujy6OJE+uCxVat7BCfTLIKTxcPkZFamr9Pr8YYGwNjo1KUD5b5egIoiTHvp6S4zX7puNo+9cfnKRs+LMTXM2/t4GiFrr0HoPsP4IiPP4flm+sglzpoi690PNViN6MuafXVz5QbLePAdisnSzaujMMayUGRYKF9BzPZabxMjvP2roTDzhWjSVVqvCqxISfGoL0DFau24VbRIdHVqnvoeHbJ1VkRtxGwr081Pzz5ca0+WKMxzOpeeG9hpB5mh9dkNfG8BiHuRZ1cZJP/EIoceB3k2vgY7
 qdkuWoYU
 2cSP4a/6Yy2qy0I6W3xlNWKYeTLhZwtP4qRJZWHRyHGoCPZGDnQMO0vEsHzjiy7EZM2DTx5kdEu3FoDCQsxsK51A94L7Kd+JyfC+VxdjYZMIcHoSbSiarDCoS3Cf521TSosWnO/bvG06mkUGRJFxEd6V+LAMtTeBBacQ9egmCqpR9p/HcPA8F2Qi9SqyyY10k97j/dV0QTm2ipP1Lw+yy61hHoexsExSzSwYOgoL1EiPTOnS61fipPyl0CrJAX4E47Qj9LZOWvnYAOWMTOZp+txnZoPt+n8u886l8aGEUP3GYesXkZJYJ2Qi/WCYQP3CTMCwF+A1UN0Tvsm8PYMNTF3ocNHgbJxkuTR/4DRBqObl1B41pzGW1wSlk9dZxbzmM1HCoVPz7nTXS7f0UrlJzjB3rMBCROymBnPvkkaY0LHuYzoW8KtDJcT6qkg==
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


