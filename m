Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01FCFCCD19A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABBB78E0052; Wed, 15 Oct 2025 11:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A008E0005; Wed, 15 Oct 2025 11:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A418E0052; Wed, 15 Oct 2025 11:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 710D28E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3BBECC01FA
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:57 +0000 (UTC)
X-FDA: 84000736554.18.B3D18FB
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf21.hostedemail.com (Postfix) with ESMTP id 398091C001A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=lYblDiWR;
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ClWZfD+A9Nl3uh1fWJix2BeoUSDfHdX5aM1VplE+nqk=;
	b=OvS33z1Xrguu1flMiNClrL3Yp8hup2s1seUoUE2gt9MVSelAA8z/fsAxBqfaESlYGuRVLI
	7A/QOsVvAcz3tMmViCt0xpd0JtFYqBDX4shasQLi5yhuwsnFg2jfbNYrkCaC2YKQA8fwAz
	XiCUZC3RaJX5bOE2OyDnQOPD69Bamqs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=lYblDiWR;
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542255; a=rsa-sha256;
	cv=none;
	b=OMJy/nd3FUDVUQ/y90fzlYwv9kIrg6um0FriMt9a1i3MVDypAs7fWDeazLIOs/edW1aaH/
	wIx5uTXPvA66Cxv6kfciPwlhGUfqjYbR4uxej86y2AqJbSWXxyEL9Rdo7ZvEZmODG4966Y
	j59it/RNLMUciQnatK+02OxQIKb1IyM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542253;
	bh=0MFrZ+8U4pjX98vlkZE+Xc8sfj14rbqqp40IJzqK240=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lYblDiWRP2ZiZoD1N4aTSKmGyPD8NqQsvlDE6s5Xv71Fc107aPTTmCxNq3C3EXCQI
	 T7axrrnR44h4ihvOHtcBWq8KQyLh9qFiqlET7mTrGOLfLDQfX2EvN/omg4Hj0+JC+F
	 5UF7nNzyszK+HGUMrAUNOYXf3wYrRTqMkpjYOhTvFWCrNaYawcy/W1EGQqmgLbNmVN
	 dTeCt6KkQYXmQ8/RMkOLHCOm6SCQJhRZmTkxAmqwW9VKcN8DrwiYR+zdIpAdAR4kyC
	 cmDvAkm4f7Nx1qjXNMtadMvzp9ZmwR6fYPnRkZ6LJQIncpMt82ldwTMIqA2Ipym35V
	 u+t1CWvPyMP2g==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0F4C317E055D;
	Wed, 15 Oct 2025 17:30:53 +0200 (CEST)
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
Subject: [PATCH v4 12/13] drm/panfrost: Introduce huge tmpfs mount point option
Date: Wed, 15 Oct 2025 17:30:16 +0200
Message-ID: <20251015153018.43735-13-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oge3hus4oarsiha168nkm7beix5ocf68
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 398091C001A
X-HE-Tag: 1760542254-488916
X-HE-Meta: U2FsdGVkX19qMAAcJ1I5Pb8dmpCTTMtCW6kRH1koyJ3CA1LUZNWm/CAd5nRyreQkBFyanza96lE+0Elu7LS3/u7TSPb+4frAEr80NR9cwouISUgBVVg+pbGzRsSVug3umvKjw5mTVRo+QjblNimyyIS1MkmnTBQv1ovRhbePyH9501YjuI7L6s4yyx4mpXi6rEdU7nCHkfEvAcRjUTdYkMQ9j/JHV78Ytug9nLJXW1ZoJ3utyTkoMY2oBi8w5wJ624FLjTBa6wxP+6p7Jcqku3kUfcC7z3vnsoGxD0HT+8UgW64e0PUOdIH0obZIqlqhBB2CoOZDhlq7SOmT6LA2kAK0/T4+5ExQRlBvOb/zA3rW/CAixQWV9lenPPRAbWwhPm2v4pAxO+PxcqjscogwYl7IPfqfg63gLm8RlfUcdJ1kWyBLbpf+0y41vryk/PAQLZFABQ0pu92jKxQ+xS8yCXPmK/xNTck1AWdyUFxNnIvggz8USX7RwpF5yUhz2ZG8KcQ5JAXpaiA9gnornm4uZjT/kFW7zNSzz2CsS8QmwrehBCinaY21mBlzgKTslkpNGukH6HNhlqP3ZH2jUSoWkIUK72o81nJVsaCccyfmSxA674e1CQdjaOuZ0jFlbKY7WqZA3jvccODPaO2kPVw4bj7TAoxuPL3cUNvAlyowYytcOGbsKk81G6kh/c1VhV8Bu06gE7DLjHaOH3tCrn0KZ25lZPGCULxeOE+g+Av5Nj+iX/BCV4aV1ySIx9a0y61muZLreOd/plPpevTe66khhPbCTNo3FTMM9BbBmHIUHwfJESaaWUWlNejWSo0EqM3nL9SRUbEbOd7WeAtwzDi77M5FZk7+EsGRR8tNdjqGTwHNRaHScV3reB9dvE9QExTQli34YwqwcMATCm33+FAML1QVHP/f2+Y6txKmR1Z7aJ1NOfbcGdoNtoBPG5ZUq4z4IxckXpdLu5FM4JRbBrJ
 mR9K8ta8
 RUSkEJCnm3l4MJ6nyzc3F2dyCTtP7mZtmlm1HfAgTG45Haqm9C6z3sCiW9w9REXEe1IG606s3lw9cY2HFYVCdnHuoFz44OLtB6+wVECOoxVqF4SqI9+wNafW6FEDojr+qWMcU+z5rGOVI0anAy2bqgSqsV5AdnSG1lhnlvFXMt/nP01XR5dT5jDK7t9pNWeAYA0C5KVVDLXdUJjznPFnLzzy5HgddYkPWtNmPFF0swLf15+AQDT1EnMB9aiesfRj1jc1reNO+y7QN8Y7X44MCUvcbaRb8/IMrwHbAFy4+pNzgnfUhiJs5zXZcuOv1fcWcGPxs7ubB4CkYhKc50bkbmgvq53CiI/Raw7pt1JpVBk2kvrH/264IYXbWQOGA+2J1qEc7fo3B1ULUshHhr4MucTBeAdxZchUum5KWIYh64U/z5SS5ZutIMLiZqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce the 'panfrost.transparent_hugepage' boolean module parameter
(false by default). When the parameter is set to true, a new tmpfs
mount point is created and mounted using the 'huge=within_size'
option. It's then used at GEM object creation instead of the default
'shm_mnt' mount point in order to enable Transparent Hugepage (THP)
for the object (without having to rely on a system wide parameter).

v3:
- use huge tmpfs mountpoint in drm_device

v4:
- fix builds with CONFIG_TRANSPARENT_HUGEPAGE=n
- clean up mountpoint creation error handling
- print negative error value

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
---
 drivers/gpu/drm/panfrost/panfrost_device.c |  3 +++
 drivers/gpu/drm/panfrost/panfrost_drv.c    |  6 ++++++
 drivers/gpu/drm/panfrost/panfrost_drv.h    | 11 +++++++++++
 drivers/gpu/drm/panfrost/panfrost_gem.c    | 19 +++++++++++++++++++
 drivers/gpu/drm/panfrost/panfrost_gem.h    |  2 ++
 5 files changed, 41 insertions(+)
 create mode 100644 drivers/gpu/drm/panfrost/panfrost_drv.h

diff --git a/drivers/gpu/drm/panfrost/panfrost_device.c b/drivers/gpu/drm/panfrost/panfrost_device.c
index 04bec27449cb..a189bfaac959 100644
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
@@ -266,6 +267,8 @@ int panfrost_device_init(struct panfrost_device *pfdev)
 	if (err)
 		goto out_job;
 
+	panfrost_gem_init(pfdev);
+
 	return 0;
 out_job:
 	panfrost_job_fini(pfdev);
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 607a5b8448d0..dfeb6a633fa1 100644
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
index 000000000000..60454611b6a6
--- /dev/null
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.h
@@ -0,0 +1,11 @@
+// SPDX-License-Identifier: GPL-2.0 or MIT
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
+
+#ifndef __PANFROST_DRV_H__
+#define __PANFROST_DRV_H__
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+extern bool panfrost_transparent_hugepage;
+#endif
+
+#endif
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 85d6289a6eda..9b059a8b0f9f 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright 2019 Linaro, Ltd, Rob Herring <robh@kernel.org> */
+/* Copyright 2025 Amazon.com, Inc. or its affiliates */
 
 #include <linux/cleanup.h>
 #include <linux/err.h>
@@ -9,9 +10,27 @@
 
 #include <drm/panfrost_drm.h>
 #include "panfrost_device.h"
+#include "panfrost_drv.h"
 #include "panfrost_gem.h"
 #include "panfrost_mmu.h"
 
+void panfrost_gem_init(struct panfrost_device *pfdev)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	int err;
+
+	if (!panfrost_transparent_hugepage)
+		return;
+
+	err = drm_gem_huge_mnt_create(pfdev->ddev, "within_size");
+	if (pfdev->ddev->huge_mnt)
+		drm_info(pfdev->ddev, "Using Transparent Hugepage\n");
+	else if (err)
+		drm_warn(pfdev->ddev, "Can't use Transparent Hugepage (%d)\n",
+			 err);
+#endif
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


