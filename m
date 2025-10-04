Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C916ACCD183
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 09:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036518E0012; Sat,  4 Oct 2025 05:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFE6B8E000C; Sat,  4 Oct 2025 05:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53888E0012; Sat,  4 Oct 2025 05:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF2B28E000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 05:31:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8848311B1CC
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:19 +0000 (UTC)
X-FDA: 83959913478.09.6CCA2A2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf09.hostedemail.com (Postfix) with ESMTP id AB3D7140011
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 09:31:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=qVW4BEgc;
	spf=pass (imf09.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759570277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQGnbkzf7WmP9XhM9H4r5CDhX8KFTC4Vuk9iF3vqLRg=;
	b=RbYKJuZ+EPJmAgfDSIr0c0SCMN2dlROZbODxtlE20hjCbK1c56kda+2KRFXmEzsz/FitQy
	SmjnO7KSdlEsSxD5m7/mFtanw/trCFPwsVHz12bW/gsIUzRGif5zDEW33E2Vh/9jAXKCn3
	b+l6Qnf3JarmeqPyz3FHKOHxpnUJDjA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759570278; a=rsa-sha256;
	cv=none;
	b=ZNU2dNdy96Sma+M+m3YHQkLIZnYJ0tXjoxlRN3sc30CzIXiMCtXr0Q6WoSSWkvNWqWMJgQ
	8a8P4fbovs8OE4/Z0SgX8aKwkm/nLKDXqLUh+cLj1sSq4ugro7BXUJFevk9Z1Wh4H4K6Gk
	mGxPhpMPFA9w1qK5iOzlDBlJ3ueMa/M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=qVW4BEgc;
	spf=pass (imf09.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759570276;
	bh=5f3j5sCwUUm4zOM7eQNMiBq0+mfIGQqbuZDFMB62Zc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVW4BEgczpRlg+66tqdysqb6yDeiDP1nw9RCe9ZZ80f015QEko/NejBcfYdz9Kb2z
	 1jhA5y36QlTRURsuDSmk84vy00x9LWTQImTdcPwmDiOw1WxEcll0Ss0ERu/gvyAIcH
	 lw6riW++z57enRybhqjT372MdkcF/lqjt3JJnzL4zKAfookzGX+MgKF9LBpUzDU6iS
	 So8h2kBEhZ8r/hzk+dDBDv6R4wocIPLFEg46db6PEGrQ0ihW1F5TwRdzhY7TU/PO6k
	 KWSZxBZPP6Mk0fZYTwYA31YMgHq2Zzd9aN8u/QJJO68dJ2mUEAQa31OuhCF07J+Lxk
	 g0ifKxJN5cxlQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:2e0:4cff:fe03:d8c])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B031717E13C3;
	Sat,  4 Oct 2025 11:31:15 +0200 (CEST)
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
Subject: [PATCH v3 09/10] drm/panfrost: Introduce huge tmpfs mount point option
Date: Sat,  4 Oct 2025 11:30:52 +0200
Message-ID: <20251004093054.21388-10-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251004093054.21388-1-loic.molinari@collabora.com>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8dk9rmnts8cpagsmuo4cukqz49z43srm
X-Rspam-User: 
X-Rspamd-Queue-Id: AB3D7140011
X-Rspamd-Server: rspam10
X-HE-Tag: 1759570277-552416
X-HE-Meta: U2FsdGVkX1/S6Qyx/dveTmlJQeBESC0/HCwUhHCgOLLBX8mTFvITWvWOW5DZTb0FDq0hzXHfJbp84qzLurl0r1k2ZNx+R7iAQU2OhHSsZ1i3JjLwCOD7ti7hSkKDpXvgJYpiIs1RYh1SAlb3aB4qLUKtBJ1TisUqMD4hSJZk89MWMh9zlOZuvoYVAOaRh/GRO5g8KpRDJ3uimo9SdzqDDzcU/SGofUHpPasmMcNlGTgLUTWGmpETlRkQYNZEAaXiX/GpbDRbsM+zccdCAAFK90g4fs4fkjpZwC53EBXe8Pld4zd0IwlH7JGDUqKLetc6oyZR4w1w1D9xllycRPzeGrZ28p1DEcM8dHT/2kx/sKmHxZyXkIf0sOqWTzxXPJfCfLD+Q0KgDWJ2mL93UpcT0v4+imiXkqTFKZo1+nLvHUcPQFgt9vCUYdsi+pOhX4HFrfrtChX/MB/bgvfEz8Ww3sffmHN8k5WxWYHR5Sc/gsoRCY+qvVvDzf6YfuSmQnR84uW20Y+boZ+w81hvIYAMdTJi1WU/Nnk7+2HHTLE7WJOyjhZ8MfeWPA4aF5pvqLxH0Prk8OHA0Mqemkt+qQaWaWHXIFcgrIdxkXSNie8FQ0ZCXRHh6a9NxRbhgS1/pKf2ykBEqYg3MC+TwiHjsJoRyZRgINqMRWtXTC6j31RHZyt//RTbuLe9Ov9mQGLVfovuBvWGbpWyR7qejLGvbw55u+djd+amdEytXl3dm7m4AVZxSeCqKaE966cLgB3zvCu6/Xi9Jdfwy6wSRpdcxL/vyTsD2BwMQi3760stISEO9M4v3Jofd6oIHhgkpjjvOCifG62I+YBuyo/cxD9Sbuo1xfnGSjyrtsK1IhdYUDKN9Trc3Ep4Xvi3iJCZeaH3VbALlyoNZtt59pTQti6xGKJHd9GCpJ/u+BSLVC4eliE3KQDkFPOQTN5JCS4hfj5AjBJALwNYRnw+lB3Hq7hBe/G
 JBAS5iL5
 cfSczvTuMOYA5bLJJYSwHHOH4Ka3EWfTovypZRJax10veMexVGe4ITwzINXLaklLjwImg4vKfdL+1kUqeO9Mv5TgTFep70AVmqFVxQCH8lFsLnH7S+P4rLkJ2/vI4tNSHI2QZ71qP9Aud4fnOvWxBZQVSgiXH45Dcfubr/5MXT+vZDqXSjvCAHTqfl9LEyLnSFQI3xq74h85YweLOeNeqcrjL6NzKzgNpTNQuvyuT5jQh3VyLK4uMTXKuq35hE0TbPnoxiBlbbsZ3ZFeQlC2V6zG9KeL85hjssxFeNm7o6MGhYWp6aArKGFV5lSy4G/y5P23mxGkeVKDzcDaxYpLaSJJ38HS8S0JEa7U5xmsT79Bz/0fdkCmbY9K70ujXvXunwnw24IB6arHJNhiyGu+CqowD2YpGPYU2awKLumvcH446A/Q22zjcka7G1g==
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

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
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
index 22350ce8a08f..e376e70a3379 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -862,6 +862,12 @@ static const struct drm_driver panfrost_drm_driver = {
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
index 85d6289a6eda..c3883a639e13 100644
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
+	int err;
+
+	if (!panfrost_transparent_hugepage)
+		return;
+
+	err = drm_gem_huge_mnt_create(pfdev->ddev, "within_size");
+	if (err && err != -EEXIST) {
+		drm_warn(pfdev->ddev, "Can't use Transparent Hugepage (%d)\n",
+			 -err);
+		return;
+	}
+
+	drm_info(pfdev->ddev, "Using Transparent Hugepage\n");
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


