Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93C5DCCA471
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 000428E001F; Mon, 29 Sep 2025 16:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECC798E0002; Mon, 29 Sep 2025 16:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D688E001F; Mon, 29 Sep 2025 16:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C03858E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:04:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6EDDB11A399
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:48 +0000 (UTC)
X-FDA: 83943365856.29.CF4C465
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf04.hostedemail.com (Postfix) with ESMTP id A6AE74000C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Q7z+zCtl;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759176286; a=rsa-sha256;
	cv=none;
	b=FToL5fFk/BUFoJ3HsDDuzrnQa35/rWvKsq3HahnK9xKxMTHaXm7hva1Nc729nunonaEyLc
	7yPOESXmmqRIyjI804ERSsGIp103dj5PTYGTV9GPKXgMeIVRBXqXbukG9jJ0x4yIQYpcHE
	lf8PNhWslNmBNmQYXvCTKOzkNG72nxs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Q7z+zCtl;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf04.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759176286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AwYBTqL9ElKrnKcxPZ68IbqLLK3KaPxf4CBQPKzOkk0=;
	b=Z4UEoK+qrI0x+KwxQ/d7S1rLzkfEYoDlYp1mWEWezk3wsYWjFmEdXhvnxJOgH1oiTlj6rx
	ZVLUfHyhMLoiM/IYqWpXar0hpTpEo9SloG6crkXhvCn0oCyBLe7gfxlnjJE7NPWeXp847x
	1LdT+f59LwZJqrJ31kNyPOGLfJ7TEDk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759176285;
	bh=C8A0EwhcfuuAx55XHopx7Qq6/pw64JlfGfx0Qq2YB1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7z+zCtlSgOSfIU3O3rBHAbr/TNn4/JCyAo+kwFkcyU4Y3JXDJgNeh+KhSRxppLs3
	 hwnh3qKVnUUoBe1CmbidWRp+9v1f6Orh7T7sOH7q7C7E0CydoRKa809oBV70+WvYuN
	 Dn/OfwDTGPWn6UMxDf/7iX1OzdD9kjkhSjlXDOqX16JxOsCMQhw7GXkDsWfw/ovy7t
	 +QpPvT/eao3Xaq3V6yLgtCzt0uU+A8bjbj6RZg886mqgEwZT0KN6cuh0dzblyHSTRG
	 0ExGK0id0KStgofh9LxeEGimxShRT+xc5RXZzvIheDAapQjje/ZVhrikL+ScVikRbd
	 nzdC2ccadCCGQ==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 3BE2A17E1465;
	Mon, 29 Sep 2025 22:04:44 +0200 (CEST)
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
	Andi Shyti <andi.shyti@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	linux-mm@kvack.org,
	kernel@collabora.com
Subject: [PATCH 4/8] drm/i915: Use huge tmpfs mount point helpers
Date: Mon, 29 Sep 2025 22:03:12 +0200
Message-ID: <20250929200316.18417-5-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929200316.18417-1-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A6AE74000C
X-Stat-Signature: s9fqq9ebjwhhmf61pibqgf5pqbmyc9yc
X-Rspam-User: 
X-HE-Tag: 1759176286-367014
X-HE-Meta: U2FsdGVkX1/pbKLPrsIa9HMNblravb3mA7S5zqXkJEVi6MtFQhOKEgN2YqaEt3VaLmyg/Hnwcgf9WrpkhECgCehIC46z3qIsL2RQzVWIDUtC9hq4QgfLpf9AcrSZlBn/y+WjbS5duAyetSYxmtEw3O37OiPJba5No57JO8c2aEq7MOlT92BKzv7Eq+YGjzfX3GIYFwuwjkeJpf8SAAC0ZDI/EpygYAm/5a6jwfBe74LDTg/P+lJ0JUsezfU4fr+uU5fHSvvXUuWIa3ciO1z5nyki84TukpktvWzPrDTpwgoUJuz8q6hSgXIEcWk19cHLnT7NXhjZzrh2SOYcL8Rr/kRHfQ45IXai8jrDmzr4tqMjD+DKpxGpd0Ex9fgirCI31XaCnB/m9EaGKs4Ag3omPouDmLlnc2J6eGocKAxo/SjpaCy4ISPqayhh1+qk8o/5SkSrnNwqP5IjJfAdWTXT67LEjQCqL5G/6nReKoYOO9nT8iHm/FqUG/eATG5i+6H8er8KA54UnV/xk146FmeNYl0W4Wr3Y2SB40CoOEoBg2SLVPJdEwfKEFARjpvcBcyohPOOIPDwPM6NCJNvCmk1zfqJwgDajmvHtJ1tYi4Cin0erwu0mKYYJP0fQHXcPvtB/o2RTEu2h9wK382fKWn9BtDwx4wj7L7yy1gl6fQ1aSTMNoHt7G0hbQmIxRJqIX11vr27thFDT833lHHOSGhH+jVfRS78sa67BakKHwSjmSM4FC9F6NDw0OnzNCxJDZ+E9Agj6oU5rt0oVnyHTlBHH7OtK49i1397dO4M4Qd0zNYruyFBYHWSkBP+ToGoPcUDW3Ayqq5xcFvD/ttHfc1kxZsy8ryvh+L8NkfJ3CtVY7/Gd7lEA/xXgPxxAmKR4fOnfAP08Lm7OaC6N/pWhVLAjXWhAxqzBqccFeU4mr4xOu0hp1yRiMCKmy2giAG5GSN+HoBEqYrMq0/r1Sgay8I
 Ewe3galm
 4ed+Io6AhERDG3HsVktTdsm4d0L+MFr6PT5TGt7heBUcxd6XIg0Oonzsy/PmFSEpWqIfT5Q9iMC3cBYf9AQ9vh5Ys9Pe5C/GyroFpMI0tpuEZi9i5kujaKw6FJaT3ZSumyO5qwHLOCaqMVWNxSsIAOq2JrhgNiw69TVY80FO4iSHLib1lz9XW8A00PQf2cXY8vtTrFHRBV8sI7q2cmDFKLn1FhhjGj9A2CO6NMlg17+8DlchQRIVyyNLnCdz6ZvSpYYl3axAfPHbLAHF/TTvQSp9MM6lnNmz15L67F/qeQLkUX0SHIZ42hlpSTBp7ng0Fdue63KkaCCqhk0Oz7+T7/3KpTYuw2owhgLzbJjgHjMmsfZ0wwOiP9WyLXWWpZHVqcIs5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new drm_gem_shmem_huge_mnt_create() and
drm_gem_shmem_huge_mnt_free() helpers to avoid code duplication.

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/i915/gem/i915_gemfs.c | 33 +++------------------------
 1 file changed, 3 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gemfs.c b/drivers/gpu/drm/i915/gem/i915_gemfs.c
index a09e2eb47175..70563a6a0b81 100644
--- a/drivers/gpu/drm/i915/gem/i915_gemfs.c
+++ b/drivers/gpu/drm/i915/gem/i915_gemfs.c
@@ -3,25 +3,13 @@
  * Copyright © 2017 Intel Corporation
  */
 
-#include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/fs_context.h>
-
 #include "i915_drv.h"
 #include "i915_gemfs.h"
 #include "i915_utils.h"
 
-static int add_param(struct fs_context *fc, const char *key, const char *val)
-{
-	return vfs_parse_fs_string(fc, key, val, strlen(val));
-}
-
 void i915_gemfs_init(struct drm_i915_private *i915)
 {
-	struct file_system_type *type;
-	struct fs_context *fc;
 	struct vfsmount *gemfs;
-	int ret;
 
 	/*
 	 * By creating our own shmemfs mountpoint, we can pass in
@@ -38,23 +26,8 @@ void i915_gemfs_init(struct drm_i915_private *i915)
 	if (GRAPHICS_VER(i915) < 11 && !i915_vtd_active(i915))
 		return;
 
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
-		goto err;
-
-	type = get_fs_type("tmpfs");
-	if (!type)
-		goto err;
-
-	fc = fs_context_for_mount(type, SB_KERNMOUNT);
-	if (IS_ERR(fc))
-		goto err;
-	ret = add_param(fc, "source", "tmpfs");
-	if (!ret)
-		ret = add_param(fc, "huge", "within_size");
-	if (!ret)
-		gemfs = fc_mount_longterm(fc);
-	put_fs_context(fc);
-	if (ret)
+	gemfs = drm_gem_shmem_huge_mnt_create("within_size");
+	if (IS_ERR(gemfs))
 		goto err;
 
 	i915->mm.gemfs = gemfs;
@@ -70,5 +43,5 @@ void i915_gemfs_init(struct drm_i915_private *i915)
 
 void i915_gemfs_fini(struct drm_i915_private *i915)
 {
-	kern_unmount(i915->mm.gemfs);
+	drm_gem_shmem_huge_mnt_free(i915->mm.gemfs);
 }
-- 
2.47.3


