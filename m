Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D72CCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 15:30:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20AA98E004E; Wed, 15 Oct 2025 11:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC6A8E0005; Wed, 15 Oct 2025 11:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDB598E004E; Wed, 15 Oct 2025 11:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CEB058E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:30:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98E471601FD
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:48 +0000 (UTC)
X-FDA: 84000736176.15.E04729A
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf30.hostedemail.com (Postfix) with ESMTP id B7AA68001F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:30:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=jeeeN8Bx;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf30.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760542247; a=rsa-sha256;
	cv=none;
	b=qfXtuPwynQjTTLjQeO09mqq2sUyTOLEw8Xg4Syg6lxy+A8emC1JJkEFL/PMBsXSwKXW7x0
	7jv+I83n/4Z8KSES4ruw86P73QI+PaszdKoS2QgtDlaPokJ8+uES+vboW6A+Sjm8sVXp8j
	SiNGHiaV/dZ+IpJU9xQP3DJ69nRj/fs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=jeeeN8Bx;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf30.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760542247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5c+lLEeAYho2XHC0dUBtFZbKBw6/nHJQoenpZYtS+BA=;
	b=AAJhhcOPJ+eQ5bHIO1x4ZG461r4K8A4PgH4KI2+i95orko1c9IjtlF7jOBL6kmTU8Qj1U8
	1wdGouUuuQ2+Xxzmc/noFeLg90tDhx0P09xCLG93PlUsqYyEMZCCvW6goUBImOIXXGF9/s
	FKt7KUGpWzHk0w9520LtHctF/gMpZSA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760542245;
	bh=UPaCf2ud0ScDDITxAmGIS91OLHTTJaUwZwLkZIUbeUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jeeeN8BxcXaTgnHKIpiYrn+CKNf3vzZAwdLoR0Jbg0cLukwhxxryk1mNoaHnmNpLR
	 tJi2gd9VdiUhAVVPlo52Kli1RsxYYbfe8Jhe+s303YZRmAOsQcgPgQGLB8eqdLvO0N
	 wo037Pz+BKczYBMKpsPgLSgoxRj4rPWV2Q6l2/4Ye6bbBwR+6+dWa2NtojiXOZgQcs
	 wVZpQRvNzPtq2jy0E5uDXIFv2IZ3jiljNtn006VVEx2yz7INFAeIBkzXrfr6Svv8xe
	 ArQ4AZpx1jwe2iPIK6a1wtLoE3BkoMuXQB94OH0CXBi+RCki/6rz83FkeunpUZMgD0
	 3YtRzPYkV6Qhw==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 28D5317E1340;
	Wed, 15 Oct 2025 17:30:44 +0200 (CEST)
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
Subject: [PATCH v4 08/13] drm/v3d: Fix builds with CONFIG_TRANSPARENT_HUGEPAGE=n
Date: Wed, 15 Oct 2025 17:30:12 +0200
Message-ID: <20251015153018.43735-9-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251015153018.43735-1-loic.molinari@collabora.com>
References: <20251015153018.43735-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B7AA68001F
X-Stat-Signature: 85dqwfe89yhn996d684ck87jfjb6grnq
X-HE-Tag: 1760542246-250242
X-HE-Meta: U2FsdGVkX181FTPAcYFpDdZCEwiFTI62HZ27TfwQccbSVL2h4YK/FXEphHq+llbXm4iGSsSagaPWp7+rPQEkLDbnUgwCtJt0JOc0Z9cE2tclSGgdUr4zV39Wc7VZvWtL4OAY6SpuysQGXAAw74d4NF9paDFz/Wr1MWMr8aRKbYvc35FKbSC0sRQAnGA4P/xuW1pPI3t6GVsq/cHz6KTTvkYhGCYJ+p/aflHwT6EFoypXntPf4RUBaMJqa8KVTxAjagVJZgg8JWyDp3xNOiZ+RVgPUe+aoZm+2yqmSeq9EHo4z8kECwjMEEfeILxQE9E93Riq8MNiO8nApVe6VL/DvxnNPDgPHnDx/WPty+tKTMLp8JEkF1CodGIRo/CI+rOplHWChDU937hzTPB7CnYrVU0YxDxXvWsbzDARLJ84LXytCny8f4h4Tx0I9+GHwODtwRNwOIaBUoa8SIbM/a+LSe6K45fgvCnkHoHAp/Iu8d9GSyeb7d8D9LF+mbYzobt20renxnSc7Wi1ArT5iQkvxkzqPUAH69bYC3GdNTa1Ui/hS5uZpswLA8KYGLgVpfsvIQmCsdm8h6DXcLj29r3vNzWsSnX+dGmk/ywtRZuOM2LNF6RVi35DTHtLT6l0BdJjerzotIHoo9oMLutUkIWzPWAjUEtgDHE982S9uiwf9Y4D74SuuqBD0qMaDsvOT4ygHaW/9f63OB7HpqGBhNGt2b7G69ZDKKZYCJgwINB/jBoUmvoae8+ZUgY4dUd0eQhbCU4j3stqS8xjYbFc09WtxmlfpzZrowwxb9diJGf24OvFGmDe16dCcBOgWDGvSF8aL2vo2JXktuNsmu9D5bxzq5KQGcdnAX+NOOetwNfXwscTN3sJwMwzTxCh/RN6++hFTB3EUvj0DmnXlc1LbnQt/djRTMEbvb26YtULu3UOrPcM65V0zv/TXpPGeSasusVoOmxRDgxL3Ue2Fy/NNGE
 rVUQWqka
 DWG+cT9Z8Vvj83gIC466bxBSbWD2aMqizYy45fMsTnryn3UwtYPZ/BQcN2EPQ1QySpeEgLSn+w2rYphH19IWzE2jF1rGMVm3R5Lg8Y2eEFQQZnnH8yfhE/wgbWXiahPaQ7sVNJOUJd5hJ2PJ5oSdO7oP91NyIO02VwKCDKqHxhJZcgjfYbbJXQLS8I22A9swCQGO87KiMlVafSE5IYH1uOnPCWV0AYu5gPoZskGgsJNc88oPlW8aAAoXsGw3eVNe49U2K2NaMfljRT9d6GLJtXOVwW76lb/BoVRahGBIL2xh/OIM4sB9fFkSLsZiipCOBU1arkVLxGlXiPiTw/xCK5RAeeKVESwWh0EYlDaBfNfHHV9Oal0vJFKotcjDvUlG1JqrtgCfQCeSy7JEke3qM1W4AR/u/XXfHe5xks7KvOxQPmc+rNRvSRRDGJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't declare "super_pages" on builds with CONFIG_TRANSPARENT_HUGEPAGE
disabled to prevent build error:

ERROR: modpost: "super_pages" [drivers/gpu/drm/v3d/v3d.ko] undefined!

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/v3d/v3d_drv.h | 2 ++
 drivers/gpu/drm/v3d/v3d_gem.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index 99a39329bb85..481502104391 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -564,7 +564,9 @@ extern const struct dma_fence_ops v3d_fence_ops;
 struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue q);
 
 /* v3d_gem.c */
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern bool super_pages;
+#endif
 int v3d_gem_init(struct drm_device *dev);
 void v3d_gem_destroy(struct drm_device *dev);
 void v3d_reset_sms(struct v3d_dev *v3d);
diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index 635ff0fabe7e..0039063eb8b2 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -269,7 +269,9 @@ v3d_huge_mnt_init(struct v3d_dev *v3d)
 	 * match our usecase.
 	 */
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	if (super_pages)
+#endif
 		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
 
 	if (v3d->drm.huge_mnt)
-- 
2.47.3


