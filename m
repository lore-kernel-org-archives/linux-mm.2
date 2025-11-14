Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD690CE8D55
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2CA8E003C; Fri, 14 Nov 2025 12:03:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16ADB8E0034; Fri, 14 Nov 2025 12:03:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83BA8E003C; Fri, 14 Nov 2025 12:03:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C49128E0034
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:03:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84D9914048D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:20 +0000 (UTC)
X-FDA: 84109833360.06.F8D501E
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id A24DF40013
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:03:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=NkdbTqr7;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763139798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKm1wDYU4jUKbDSi5VSS1Z+ocnEFEBIRWtHj/HFEBL8=;
	b=Dk7LGdY/Wde7/1/jQ8hlu/5Kd89cDC5s4tVyzOLycJPWKeX/fW0D1EjhUiItNbZmJFDDfU
	3CxOiqZ/h+cdKHaI0iDUXNrAP6i0yeD+8tsHJ0dx4Gmsdey7oRjc2sS76Rsi2lZ24H0aMI
	REd+FJyzPvQ98QFCQP2Govkx4KPSPjs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763139798; a=rsa-sha256;
	cv=none;
	b=vqYY20liIbf5NWNSN1/L0ZqBtzoDLvToh30ptlVy+p4zwGkCcWVtJkGLOjgDEd1yVQFdpE
	ZtP7AUMTVnepqG+90f3YfsSyzn+dfe5duKK8Z0enywwBCA65rUoWd+fXIgB5J+R+UtWyzK
	m6+dm7A2/I1D6/T1sxSRofb/XE3/BGY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=NkdbTqr7;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763139797;
	bh=j71+p9YAh5QPiawZ9VZM73M2pNS6NNm74Zwt268TaXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkdbTqr7MQfBJuSmO5wxsTgv34gS60If9ab7o8gt4B+rDwazvFYO6BuFW6kKOMVae
	 G0jOXK1oaATwQyb5JBSdOq9GVS4Q913ovH5hZ2L50G/EMjUnTKuXZGEr+j+cjzzank
	 NVKMPhP9R22+fcqDA+3pIRk+qPSWBuPsQ9K4F/FPWTH8ZSOcodnTxHknQ/+01R7Ekr
	 ATKd6sXvPZBMHJy9kx7SjGmLqYaRydcHIk5bUrm8RiuPY4SzXlsagqBLzovvgitn2X
	 zQBlZMchQ2bbzkUeBBqnidm2lMk914s5Y1IU7aPd8ODXWnFjvTbL+hdV6ddem/1bhf
	 kT3o0NzmigTKw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 997ED17E368C;
	Fri, 14 Nov 2025 18:03:16 +0100 (CET)
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
Subject: [PATCH v9 10/11] drm/panfrost: Introduce huge tmpfs mountpoint option
Date: Fri, 14 Nov 2025 18:03:01 +0100
Message-ID: <20251114170303.2800-11-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114170303.2800-1-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r1uo3aj6epr857sup1567m89umqhgafw
X-Rspam-User: 
X-Rspamd-Queue-Id: A24DF40013
X-Rspamd-Server: rspam10
X-HE-Tag: 1763139798-242083
X-HE-Meta: U2FsdGVkX1/QJ+rioDeifZHcwE90mOCxgPMDKY9o8eFEcmZfN7gKBnrAT5LLmoLjnANuPrgc3yyosdK1Xm9YvodVNbn9R+h5GMCM//Uid0wWGgucuzccGi5WvuMiFIdrCp6NIm10bt6Jk/5Sa18WTasjqcjtjV99WsDieJ93UYSfWg9YpbXiHNnnkvFLkWDrg4NNLUG8XyqlSJBSSBfooF/1XpYZ/oDy8KDXyqawDzUBk5JMYxYRwB3x4Kim9R62kuQk/H60lD8kXT4iNxCGBRyP/JIJvT9VIbd9pddS5N7jOaoRpCdONYYCnIMMJ6iQcdPoVdWWlOhaG8313HRw1RlHOhojUnBWKSHhFA154LTTczHr8Hb5cEUwPamqhub1U4ERaPu0OBf7Hqxcvrixtgi/fHl9NSoR4h6yQzl2NyDB4NDKxnG4hd9xvdPSscrQIaD/5wC+xsdFCvzzKkgawC6AnTnDm9EB89SFhUX1+2V6esd7kylLvBHC/y3dy5+K0WICVeAT27f5NR6dbNc25gnMQGxGkWxjoDQsKQJtoKQiv0GLJ39vUj1wHWMLAdkhYdJAIqeZdQoQKuEx7fdV2L7WkskqjsDdazF9OBQrDXvfLUuvUy6M7CniBvX7WGuipikAPY2xAkWhMr2s9Mt0fAZUfVvtGZDSYt/o5AM0fqo/IZyPL5nLQU+LXCjMSrNFECFQ1eR+MidfYd1bPjoBGqTZiF/Y09JNV/GR9EAJ67SXBiCir9b9/pDeP1E7Y4MfgRJHiO7qGYu57Q2RdSO6nUdZySzgLgyqQ8BQzfRcFP7Ghp6wcYAHhtxVaC5YFh7hX+5Zt/499QZlFOUOF0hz1kTZ6qPpEw8/G1bsXygAbazInA1vysdr+1ePJm40ZRjjScmB14Bw+WmLy88NoJhHfa8BIIGIMXGlCfHaBoqzkylo8L5tiNqb+JvKAEwmRVyhxjMd9oZd/eV7adWRgdV
 KXOg8ZMN
 cJypLVvjm0bqVv0p4N9EHsGZrdDuxSKVZaqyXFg3zWTgHQdaMN0DBMYtpCjjdjWz2HMtJt54bQbnBKp1oudIxvfpYsDcU5t255xJ7Y8e2BAlvUaTSJZ1bZYRx/EwPucZIresVEcw04GHP+UFrUjJJKX9osDBIKTm4YqrR7+GAm/simrQo4Fk9mpBBhdg508gASoBcHPl7AlzCh2FWCN/uTex2e5qr/2xyoWFLNwTtv14pMSF6WZQz6vbMJaNFR0dp/PzLpaMp31xTiLbcjM15kutkYOM0DfJChqmYgoR8TJX4T7FwJphPvSb/zcTcDqYv/HeRIgLQ9rEgj1skRgRQVv+cl7gw4YT6yfs5VJ/RsrAyX534VT/bgyR5FTmXyPsxZ+rBbwASNUSHI+kMXX6/owCQ7pZamUIzWHJq18DRVsz1D8BVYGmBiy7vkg==
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


