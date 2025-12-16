Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92062D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F37126B0005; Tue, 16 Dec 2025 02:14:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3AC6B0089; Tue, 16 Dec 2025 02:14:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF00F6B008A; Tue, 16 Dec 2025 02:14:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA8D66B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:14:06 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67EE0140538
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:14:06 +0000 (UTC)
X-FDA: 84224470092.11.44DAD30
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 97E382000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:14:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gucXpUVa;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765869244; a=rsa-sha256;
	cv=none;
	b=lHcCYQRLrtAqzQvK6pBNcENB+8U2uQnOE6YaeF2FY3cS8t36MX7in9IJbXJbMXjs8hR8pl
	cZOH4P7u+81+WExeOM0h4IH/0w+af5VzQOe6/OuBmsOOjRqgWdY6a9HVtUYx5L2XyX8EGk
	aNnGGvvyToybXEOuOevrXgR713+55ks=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gucXpUVa;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf13.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765869244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oNatl6J6BcJk/S0sXAT6q/VLY30ES4IaJnzY7IJFPDI=;
	b=7RqzXF5Zy4EppUV4uS+2h8hKFpTgCY4rdBLWICx0TYzwBA4zx2jic13Yf2hn5g9L3GWl9m
	7k1LhAvgAG+9CInAT1wlfRFRHUNWe4gfpWpNpqbJwbMdxFp7stlJkrAQGbX80zUlLptxnn
	4WCfk6S6RYbYLQZkcgHu4z4WuMcpx3E=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a09757004cso32246095ad.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1765869243; x=1766474043; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oNatl6J6BcJk/S0sXAT6q/VLY30ES4IaJnzY7IJFPDI=;
        b=gucXpUVaFDE9oQiYiE4l+U3ueywlL8rDpZWYHPWlHyK/4OVi5DZPxQA3Gav0+s2TKq
         nX6SgNEgnWpoY115T6AK9nteS98TjCIvPc0nzP8C3lj/y3gg3TPEIo23EOPU56q0ONXt
         ZyJ5lEKUXl/SsUUzktsCGqUsWd6BOVRET+2wA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765869243; x=1766474043;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oNatl6J6BcJk/S0sXAT6q/VLY30ES4IaJnzY7IJFPDI=;
        b=tTeEGvimINgbE8sHXAnFyjDr8RvA3TAC173vszDCTDMkXltTDNrSvjA7KJ9YmXCq1j
         vYkmi0CQv2wGSrxiaCnOa29mQzDe2zkvg49H6xzmpm3wAHYTcEBIkkd/9y0k8O/QWWeP
         znwWQvY+o/f4UAR/UQtKGRrVkSp4MysURY/di258ATKjVyF8s1Xv9mNNciVl/0vFw3jo
         1/GMcAHlnBIii2fLRxHU33NhQ6y494ZCMWLg+C+0F4cPqXn9AKOJcS5nBRP7G9YU0CfO
         hXrZAtL5N1X3pWruRsUllnUz6ccrNjN3GYowjscoP3S7/w8xLweIdyZf5toBuj7je3o+
         /Y7A==
X-Forwarded-Encrypted: i=1; AJvYcCXVo6bx0QEgcvcykI6OiwDn30Lez7Vb3VKnk35LBXiJl8vuzwxyJEk0FwpwQUqGmnqNrJbuhDeCVw==@kvack.org
X-Gm-Message-State: AOJu0Ywc9OLBsH7VmGzIKJp3jBE96w0091jmelGtQCwf8VkNGtDAu+GZ
	2z1dXWnKT/XwVbhL5iyg8yRTrqqYbaU1IDD5d7BxIKzXqUPX8W+sHKGy5ioWEWVDMw==
X-Gm-Gg: AY/fxX6FDjLWN7btX3ZVmUo76vtSIqR96UIh3CobG7QqRekOHndcd/LRPHJNCl1Z4TK
	tvOWGVBHqvx9wnZoPuJ+ZjfmL1uOu8nqNYAMsmUTMkgnUuTOSA1VloT+YpGcaTmLkmQ/vkVGRE+
	l4eJy3bBVkIQv55SB5C/FnlcaUz7d/mhKOW/bCIZOdGgdKhPNdpE6Jr3A42oaJedXfQ6K+XFOkf
	F1cjk8EEsz/gmbgE6s7pwejXPFTg1/a6zwuWEL98OjRZOcfdDog9aZWrkiEzzbhSYRAXi4S5qII
	L4R76ZhO7qA08sGfaBJR/5f8LCCfoIRMPCq9f9B6v3f3fXBB7wXLa2SXxaZomhFOv5W2Au47IEH
	oFtlYyQA9kA6Nbe8bcBTfFMQoL5awn2vqcpmPfgf1Ls/EKGleiJ4BaLovwWfm6Hy4t4DfOIpogt
	0g/Rsql2D/id534Anm3q23jZAkuUrLbWrzh0WeXRn8Sw0w8wix2y9uPztXeSElTtmIAMXia/Hcv
	w==
X-Google-Smtp-Source: AGHT+IG0syAFJhjlxLN2Aw5XB+eZPhRIhKo3rCILYb8gAbNKQjHe4RCRPMTSFXN3FJZtNVG/AkOQdg==
X-Received: by 2002:a17:902:cecb:b0:2a0:de4f:ca7 with SMTP id d9443c01a7336-2a0de4f122bmr54142285ad.1.1765869243447;
        Mon, 15 Dec 2025 23:14:03 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:a48f:6b66:399d:86cc])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29f2563b116sm119253685ad.102.2025.12.15.23.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 23:14:02 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCHv2] zram: drop pp_in_progress
Date: Tue, 16 Dec 2025 16:13:42 +0900
Message-ID: <20251216071342.687993-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 97E382000B
X-Stat-Signature: zbezuactiua9f1qq8arwc8bxgkwrxftb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765869244-278363
X-HE-Meta: U2FsdGVkX18jPLcDO0TPSTKZCmISP0hXW7u7KtW0DLldYBTycyGSEF3tyaYChHH3UrXewrqxp24ugg5ZgYO+SeeHjbPqia+9LWT1lT9arNaolRRn4BW1/yuRBSDGRgcaCbl3cess7awg26Fy5P9+b6YrVRAjzXBSN78N56gYB0sTIhUXSmREYTU/5XuTaQtKb4zk/N5qYlZVpYIe3Xv13CnH6u4pD9SnVI/c2wiHLzJvz1PBwWzJQGs70JbJZSV4kn3VWlqLLikMmRSOsiUbFmrseYdHQ2OyTnEbt0Jd1sy1CNp/CKu20Sc3M5FWKqa5c1Q9QvEK4GEiBbWne7uJvH6FKU1E+5QfpYz017ZhjnN3ztNUDPyNMPB2NnfNdneq4fPlfHwTmnGf5oD46vlyLDjPOMd4Puf5/+dI2nGOdMCVs4YV55y3DXxa3gXw2D9gbsjAaGV2nIYP/Ebrev6t4BFRdp3eNhT00MiNakqgLEmQWQMnIs5cwQ88jO7rCCm/i4QSnYG+rDAabWHIhMGouxfmEs5N33AnjoSH0/C4dcy/smRUCkphCFGfglRcn4IHq0Z1M8bLUN7XSOMn430dtQL/38Y66aspBKLPof4gPxvuOtGi0YjATn/oiVuyClRdUSnwafQr097+0/5l2on0TaqXSt0PZ7gsCMmZn7Hn4UZeY3JBMVq1gLgiJyIAOCdBrS1ZXzqcCXWsHzHJgYfJpQKxjiKdMn/9ojKGplT+/qH/cV//lnP04RXGzplvtzWdxGuEw9Jc7eVT++K6M+fxz3nvUWKpsWe72ClQWWYiXPES5sPqVKwPou+hU3rktsMfzvI2AmNbPoMWQ+QZYmrRDV9z4fenxIMCKehdd8N0khkeJ7xsap5U2pMGdFzeun6Id1TwlJzd0ACGCBFkJ0j3OyKIuF3i4lIfJSSEKOoB5Ml8HMhMHwtyao3r/XE9wzBt8pIR0w83HR5pez5TaQA
 Mi9VkpwN
 9yb5CCw8kpZAJ9pfE1IrE1ifO95Bs/m81cQ0ziEPI7T3JMtAG7/8SRgwXKbzWgqRqah9/4Hgn6rt/msiybSFeEiu7ZmxG5g26k3uDEJrS9TovTuky/x/NqtGrSrqtORa0z+wbB9lr9wAA3V7EH8888pajghi49PlAtQ7SnXI5UZTQ0Sv8iMBdQ4j6j8O2m+2uN0ibJX5SAeuYS2bD08RpXfJaf74BhhIQchCkLsC790ZJf34WGsFF1vWXtdLSuo/s1d/c8MftzTioXv1m+lKXBk2yHpANe/d36LB7DBBRrKxLBMtlEu9NPB8V7XmGWRJnZ3d7HTD0XGoUxD6BdXt9cQqV25upJ4wKxJc/CyPpoX3gjQLwWMizZbukQG/fsQt3ZCTWLnUlixXe8VKWd++mt9RDXXF79RFoWAwu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pp_in_progress makes sure that only one post-processing
(writeback or recomrpession) is active at any given time.
Functionality wise it, basically, shadows zram init_lock,
when init_lock is acquired in writer mode.

Switch recompress_store() and writeback_store() to take
zram init_lock in writer mode, like all store() sysfs
handlers should do, so that we can drop pp_in_progress.
Recompression and writeback can be somewhat slow, so
holding init_lock in writer mode can block zram attrs
reads, but in reality the only zram attrs reads that
take place are mm_stat reads, and usually it's the same
process that reads mm_stat and does recompression or
writeback.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
v1->v2:
- updated lockdep assertions

 drivers/block/zram/zram_drv.c | 32 ++++++++------------------------
 drivers/block/zram/zram_drv.h |  1 -
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 634848f45e9b..9f91eb91dc72 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -902,7 +902,7 @@ static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 
 static void zram_account_writeback_rollback(struct zram *zram)
 {
-	lockdep_assert_held_read(&zram->init_lock);
+	lockdep_assert_held_write(&zram->init_lock);
 
 	if (zram->wb_limit_enable)
 		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
@@ -910,7 +910,7 @@ static void zram_account_writeback_rollback(struct zram *zram)
 
 static void zram_account_writeback_submit(struct zram *zram)
 {
-	lockdep_assert_held_read(&zram->init_lock);
+	lockdep_assert_held_write(&zram->init_lock);
 
 	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
 		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
@@ -1264,24 +1264,16 @@ static ssize_t writeback_store(struct device *dev,
 	ssize_t ret = len;
 	int err, mode = 0;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	if (!init_done(zram))
 		return -EINVAL;
 
-	/* Do not permit concurrent post-processing actions. */
-	if (atomic_xchg(&zram->pp_in_progress, 1))
-		return -EAGAIN;
-
-	if (!zram->backing_dev) {
-		ret = -ENODEV;
-		goto out;
-	}
+	if (!zram->backing_dev)
+		return -ENODEV;
 
 	pp_ctl = init_pp_ctl();
-	if (!pp_ctl) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	if (!pp_ctl)
+		return -ENOMEM;
 
 	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
@@ -1358,7 +1350,6 @@ static ssize_t writeback_store(struct device *dev,
 out:
 	release_pp_ctl(zram, pp_ctl);
 	release_wb_ctl(wb_ctl);
-	atomic_set(&zram->pp_in_progress, 0);
 
 	return ret;
 }
@@ -2622,14 +2613,10 @@ static ssize_t recompress_store(struct device *dev,
 	if (threshold >= huge_class_size)
 		return -EINVAL;
 
-	guard(rwsem_read)(&zram->init_lock);
+	guard(rwsem_write)(&zram->init_lock);
 	if (!init_done(zram))
 		return -EINVAL;
 
-	/* Do not permit concurrent post-processing actions. */
-	if (atomic_xchg(&zram->pp_in_progress, 1))
-		return -EAGAIN;
-
 	if (algo) {
 		bool found = false;
 
@@ -2700,7 +2687,6 @@ static ssize_t recompress_store(struct device *dev,
 	if (page)
 		__free_page(page);
 	release_pp_ctl(zram, ctl);
-	atomic_set(&zram->pp_in_progress, 0);
 	return ret;
 }
 #endif
@@ -2891,7 +2877,6 @@ static void zram_reset_device(struct zram *zram)
 	zram->disksize = 0;
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
-	atomic_set(&zram->pp_in_progress, 0);
 	reset_bdev(zram);
 
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
@@ -3127,7 +3112,6 @@ static int zram_add(void)
 	zram->disk->fops = &zram_devops;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
-	atomic_set(&zram->pp_in_progress, 0);
 	zram_comp_params_reset(zram);
 	comp_algorithm_set(zram, ZRAM_PRIMARY_COMP, default_compressor);
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 48d6861c6647..469a3dab44ad 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -143,6 +143,5 @@ struct zram {
 #ifdef CONFIG_ZRAM_MEMORY_TRACKING
 	struct dentry *debugfs_dir;
 #endif
-	atomic_t pp_in_progress;
 };
 #endif
-- 
2.52.0.239.gd5f0c6e74e-goog


