Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03FF5CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2D08E0030; Mon, 10 Nov 2025 10:50:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D548E0031; Mon, 10 Nov 2025 10:50:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EA888E0030; Mon, 10 Nov 2025 10:50:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 667CD8E002E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:50:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29A4B567C6
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:18 +0000 (UTC)
X-FDA: 84095134116.16.0BE4DFC
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id 411B5180009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:50:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fHMetAgw;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf16.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789816; a=rsa-sha256;
	cv=none;
	b=8GVZjl9YUE9bPzMum4cD3aNxw3UnYC0ct9daqZPwaPztyA/12ZMPtMYvWh7RlHQ5gOgJk6
	/DPRS1SCwbaGbv6zXmbCWwTKcxz9EJQInx6MdE8sWELTe2uWombDHmQBqk3mBN0L3ZlUCe
	/wfBeEjGOoxagIN1ELszD45cJ9eQlyk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fHMetAgw;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf16.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PUM7GvdYOPnlj5T4ZBbxtNIGCGDzjQmCzsl0lz7p84U=;
	b=gVdmk9ktHCyTFM6MVWVQYXphwC6JhzVK5tX3eC3+HvbdxZ7FGuBMQijucoKX8A8/ejMM5x
	AuU/UdkJL1mB/p3UcBUXWk+L5/ERAk7qMriZUdwMrsh9VBChE2oAxVPai3N1G1vhET7NyM
	iF8XGnnHJ0rlz+pmWFV6UTQaTNKATcg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762789815;
	bh=yPuKKm3SVd/KQk4btyBTtMSqWra657FZvtEg6/HJexU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHMetAgwWMjyr6dI/om2HlNg3bBLC+F6gBeOrWwhyPzPjE5cEE8guIEfuSeylHAem
	 zekoq1sKdmCoPRegyHd+BPHBlm5/zhvzCW2ijtvSFcfiQe7LEX9T8sCoy9IEDruITd
	 3ojJ6/wWqQ8pTXaMj/39f1XadNdKhqD54Z1w2Y2P9ka7qDuBxLK6xfPCIZ1Mhr7Mgj
	 uBCfRBfrhQkCz0iA6PmElPY0UYJfhvjCzO1i3s1C6bQl/db+8jkMh2f4eUuhPE+0ip
	 PzDntg9XQGy9okxG7A0bciwP1hICh+laQPZUkA2LTtzILfzPrxjWFdHi5G/IAjW7a4
	 n6zfPjtYpfr5g==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2A2A717E13B5;
	Mon, 10 Nov 2025 16:50:14 +0100 (CET)
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
Subject: [PATCH v7 08/11] drm/panthor: Introduce huge tmpfs mountpoint option
Date: Mon, 10 Nov 2025 16:49:56 +0100
Message-ID: <20251110155000.2936-9-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251110155000.2936-1-loic.molinari@collabora.com>
References: <20251110155000.2936-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 411B5180009
X-Rspamd-Server: rspam07
X-Stat-Signature: zegbpb1z5xw1wrbiikpfg5kyfk1735mf
X-Rspam-User: 
X-HE-Tag: 1762789815-541357
X-HE-Meta: U2FsdGVkX186fWeXEv2Vv5Inw06xqO2CdcQP5PhrHMAeuCxFDelaIYMBijdps1G7+u4qNHOzU0NMNjm59ThEywmKfhNkfiO6u0Mq67L3y/M4iuq5/7lwpMmgeJlfvuxz55axci7aSHEBiu5ZXwtDBZHgF8xDWKTgFQDktxJefwu3ZYIkA0YfJ83Zcm5xkYtRH4OEnKfG+E/LS06VaX1sSqzIzv54Aizck+8g39mpxTU3fsnY/1erEEW7/6ZuLqUBu3YswDPx2VRlspY9TsUdCI1Maib+Cg009CrrKpaFHejVJwjafzgDo/InGTQj2HuYpgdMRQUrj9ouvxduT5OQA7dMlmJSFsodEZQih4VrvfdJ5/cPDihwYO5/SGpiXfuPLoofGrosQE2j65B77qTPonkbzvTeEYnQcVdas9mufDqgdKIAHWvfeyhetK1E8PeA/npB0wt8tIyaWnaOPwXpl+PoYgyv1smsqmLvAn5XRy4jMkkosu53Z721F/RtvJfvSaqS6oU2uCHpD0f5Ya90kBkjuzAsmh/7xunTxIinc931IB+wdJJKmVE/MEATtmO7hmA5bk5dj3/KqPgMx/Ep2FSiqE/f4WNjpoYnRhJgL9aZsHv5dAL3JP+QS855MUf2b9G35aY2VyDh97RmlOlCnNEx4EJCtbUsn09wPL+PJwhQIv9sTJN8eCRv06DOthoHwjOSSOf/NsBj6zhwhI6Ta0Hz0QKZ5nHJBgUmiq5aypiiD+YWUPRFxcIqrrN0N7EQvl7AELow1z7nPYE+NInJdm/OAhL5rf1mO4cxONcXx3VaO67+RPuGyKOZwTs4NWjjGbThS2dC9nS0esAFA4UGjwtsIqym2+rInh4ECIrK6nR+XXvPactZai/E1085sOmfAGh4ggFPkpnoW88ypKW6z1b5OKVivBM5UGLGHuaj1fKkCXG1Kibt68b5j4TXCcSyCIGwku5D8Rn2ArrU2IG
 n1QMa0v/
 6DeI73t38DjkxXpGK54jX2WcRWQGmzgiXcJvI8ulfdB512/17sNJbT+W1EkJQtib6LxLu3H1xz6RwT78An1CijLW1VsGqfEkeBPsGGIxEmuknnUyWLmmZrBQuJJ+xhSa8VE6qSVg1Ku83s/cEDuVPnKICqpBcmLx+qdxIV9w83o5tvj9igxnCkLMoVk/pZrbJdrsiHP2jquY/NrS2GvrjIMJh/GyQzFzCbowYSiINlb+jBWz0JPXsMebZCm7i9JFTPhUdOYp1cLdCZjJQLJ/ps1vSS7p1UeodQWrWLxk/g5PW1sYccbqd1OEGFJVBR3Ndlj2b5jwnYQKnQyU71/Cb1qCBEKwtPKr5jWcDBzyO6iWMhQ/JxuncAAuJ2OSkM78+9jKRofqCSHuWaXNz0QGyCJAPCZTFvKmn+cpfavyQV73PQaDXbqKUmZ5hpbK/LgqgbLhHA/M81dqbeTtv6XCYYLIdLhoxCplZ8Nq1OCxg71pO/5VlWz29swHl7B2EX+RnT1pBValCatT9TCh9JRFNoZJW/YhzHjf4xdAEKlhkjFZwTgo=
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
index 31fb8ed68199..b6795d58fa03 100644
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
@@ -288,6 +289,8 @@ int panthor_device_init(struct panthor_device *ptdev)
 	if (ret)
 		goto err_unplug_fw;
 
+	panthor_gem_init(ptdev);
+
 	/* ~3 frames */
 	pm_runtime_set_autosuspend_delay(ptdev->base.dev, 50);
 	pm_runtime_use_autosuspend(ptdev->base.dev);
diff --git a/drivers/gpu/drm/panthor/panthor_drv.c b/drivers/gpu/drm/panthor/panthor_drv.c
index d1d4c50da5bf..55dbda6dbf9c 100644
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
@@ -1626,6 +1627,12 @@ static const struct drm_driver panthor_drm_driver = {
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
index f369cc3e2a5f..d9cc70739121 100644
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


