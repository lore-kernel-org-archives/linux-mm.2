Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11783CCA468
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 20:04:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 816098E0021; Mon, 29 Sep 2025 16:04:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7785F8E0002; Mon, 29 Sep 2025 16:04:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4BA8E0021; Mon, 29 Sep 2025 16:04:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 464188E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 16:04:51 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2DC65934F
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:50 +0000 (UTC)
X-FDA: 83943365940.08.6004187
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id 148F9180008
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 20:04:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=FaSddbAa;
	spf=pass (imf16.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759176289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3SfTIqK8tFT/p+6EGC0zpEeBNHx93DIu3lumesFqvBU=;
	b=JoOfC8JhNlKUdI7clRMzBpMPa/oaMpgWaKMZUGUg+E9j3l48G4yOBitumFDeOoDmEsCP2Y
	VlaWqD14kb2rfuQXzLFrw88RwhSIKrkiE6oLx1QTP4M+oO+OwaFq0zh8sXPhLTQszkvbks
	n9+q2IEco/Cc7BkNDk/Fa5nRnFla55s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759176289; a=rsa-sha256;
	cv=none;
	b=pthnMcIJedMHdXX2nRKqBju0fGnkw9fjQakxiKxJh9J8V4AqcG3NKIyDjWYuw4mw2GBnrV
	o5wCWFedvmKLlg1wc9YQDhlNtBgRNBjQAjoQYm9GS/Lo90Ypr6ErTUx3vlxRTLvE2KJj8R
	/1vxwZK5BD/PHlDHNIu9SFiG2JNcpKQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=FaSddbAa;
	spf=pass (imf16.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759176287;
	bh=8a0+2vCJjyXNTtdJZlFvg8lNK8djtqhRGCpzH9ay818=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FaSddbAanvCPQ3ohMTVyKMYG4OP06ihGPZDgza9EwKFh7wuuRinArtJpx2ua/06cr
	 brl58VRNx3tPr4j7uDQg6pRbbmVPjtgVfrGXpg9vMNtA9loeitCpQAqSYcsILQzGUn
	 UHVdX77Slebrdm3ybibqtfEbGGz+PZrLrSJVKABMIwtoE1WBRmf+mBEqP4YnJJAdU9
	 /6gV5hEADEX3xkIYZ/IV2mXJzjvdaYxs3OtC2wabBY/PRjIPPUZaR9ae4QU3URLwlz
	 L6nZTLMlQVxby2Ft49+qz4n1ZdN1pVGMASTObXiEINLy+beXm2Zhl8cqjH3Psys3Ob
	 EsPLr8wt/Gpcg==
Received: from debian-rockchip-rock5b-rk3588.. (unknown [IPv6:2a01:e0a:5e3:6100:826d:bc07:e98c:84a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 100FE17E02B0;
	Mon, 29 Sep 2025 22:04:47 +0200 (CEST)
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
Subject: [PATCH 5/8] drm/v3d: Use huge tmpfs mount point helpers
Date: Mon, 29 Sep 2025 22:03:13 +0200
Message-ID: <20250929200316.18417-6-loic.molinari@collabora.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250929200316.18417-1-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 148F9180008
X-Stat-Signature: emc4mn7atguiruzwabzjfqk8p36t8rhg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759176288-345913
X-HE-Meta: U2FsdGVkX1+puxd2UCXe4aCkr4VJbZ4CV9ZStF8hfBEP2b4megWZjOBRbPVU32j2umz2kd/r2IB+F+6C2kiyKP/4XEbw7VUdlOAiDl2V1fnQS3h4JfBWXQ4+lfY7DYvexFHjZS+m+GucAz1qn+rfdYQ78Ly8aoG7KL4Dh5EPibcUUyfTGpe2M1/XuSp3Vx6Cp6vAZ1+8PlHdKz0bvB5agjS+rXNpr70Q4T8ADlgnaATsyVOdziV5TTXBi4l38wJxKbG8kbVHfKf+SIMZjV/xyCWOqE+sFRhSRLcsuf7jRzP4Y32I5a4PmowOjTvk+TM0BCrzdgNbQ/1qb66dNgQsfqLGetEgjOfCHyM12AK3XUtB6pqTSDLaHBybGgBFOAJhXNgDFJWSJsBugtIqIpJ/WJgzXwS83yGQzrbKDWgD3coLCTGpb/0XzNbTPeW4X9TNNrfzT6M67uVs4E2LrqG/mCf+wfqaoqMt8vG5gY4pF5vGqa/2AlzDEKyGCa1H7tjtykCZZCpUPqU0naLlQKD+7OCa9+j92RAPkIYyK2V7ar5wwBgUg6lBy0tvrusGGxto3TLTW4ysYy4S1daPFbg+lsiDJtJTv9gqmNtkRox4iWIz3xYkEYLZJov00Dp/3q77MdL6ISBJt5o30H/W7ZW6GUEwzQjIABizxnGAH7DWs0xFpSaxFlcbfOmi7NInNK/AXHWFYDh1+g7e+TdWKuN75P8Hky8fjoX0FpKBBMdXWL9RlqUxkiyGZGgsmNYaB3o2KC084TwpistgppO892hTb2GS0f95+P0DZYHVQdahlE8bOC3p0Cw0slkwoSfut/sXWEjvNYbrqW7S53fW60TZiVDGv5XaKMyQx+bGwBTU/6M9NWvFNkjOm0v7lv/LyaFdDSwUNs8SvZZfSv96+WkeQgaVJhfTi5mfnco5MR22U3X4WjE9IBnSp5BeWpH5hUlhjGMCoZfMR76UG+9u2Fk
 6kBIrF8x
 9Gqn1EK3ed9+GGUxoQwoOa/xd4WDZsdsjCkJX/SiFF2RwkMJMC+iKVvW6S122rWH7sJj/vA6WLrhbEGUHwgsSfJFbs1ow+TBPD0rmVmM+K5nHYLTj/vLzx9Hw2gAS+msESG3P4lYmobFr2gi93ArWTsKccoNVBN2zypZr1SYy10xuR1iwWGKedPJMXPKkFK7F6N3puq7dhm/lg1rPzi4xtEAQAvyY/d88CqmIYnL367R1gd4mE3mOqKZlhmwNDziFWAXnUhIufPYfZIKvqtliMWt9DdN+QsbmN1ilTxvdp3VYmX4pxww2i+hdtYKoMjIWbK2cbNaES851+RHrvk1ZKil2C42LsbwoYsy5kW8U0ox5qG8d2Dtt76e7SWMO+y5ASMHuuA/vZZW8Fbvp5WkLJixAlyqNf4SO5kIfUM5tZOPO8QU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new drm_gem_shmem_huge_mnt_create() and
drm_gem_shmem_huge_mnt_free() helpers to avoid code duplication.

drm_gem_shmem_huge_mnt_free() handles NULL pointers.

Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
---
 drivers/gpu/drm/v3d/v3d_gemfs.c | 31 +++----------------------------
 1 file changed, 3 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_gemfs.c b/drivers/gpu/drm/v3d/v3d_gemfs.c
index 8ec6ed82b3d9..f54705dba217 100644
--- a/drivers/gpu/drm/v3d/v3d_gemfs.c
+++ b/drivers/gpu/drm/v3d/v3d_gemfs.c
@@ -1,23 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0+
 /* Copyright (C) 2024 Raspberry Pi */
 
-#include <linux/fs.h>
-#include <linux/mount.h>
-#include <linux/fs_context.h>
-
 #include "v3d_drv.h"
 
-static int add_param(struct fs_context *fc, const char *key, const char *val)
-{
-	return vfs_parse_fs_string(fc, key, val, strlen(val));
-}
-
 void v3d_gemfs_init(struct v3d_dev *v3d)
 {
-	struct file_system_type *type;
-	struct fs_context *fc;
 	struct vfsmount *gemfs;
-	int ret;
 
 	/*
 	 * By creating our own shmemfs mountpoint, we can pass in
@@ -31,20 +19,8 @@ void v3d_gemfs_init(struct v3d_dev *v3d)
 	if (!super_pages)
 		goto err;
 
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
 
 	v3d->gemfs = gemfs;
@@ -60,6 +36,5 @@ void v3d_gemfs_init(struct v3d_dev *v3d)
 
 void v3d_gemfs_fini(struct v3d_dev *v3d)
 {
-	if (v3d->gemfs)
-		kern_unmount(v3d->gemfs);
+	drm_gem_shmem_huge_mnt_free(v3d->gemfs);
 }
-- 
2.47.3


