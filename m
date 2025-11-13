Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD4BECD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 06:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493FD8E000A; Thu, 13 Nov 2025 01:00:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46BA68E0003; Thu, 13 Nov 2025 01:00:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9268E000A; Thu, 13 Nov 2025 01:00:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28C488E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:00:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CEA2712E3BF
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:00:20 +0000 (UTC)
X-FDA: 84104533800.22.9FEF7B4
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA5EE40012
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:00:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=is6+ae+k;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763013619; a=rsa-sha256;
	cv=none;
	b=UboAOLxCVMV3o/TO+8dqIUnZ0MOPn6EJFOdGZfKC+5wAXbU/AdpQU0SuIvKtfDbSpuRxPM
	KT4btMlPuYG14Odze02m9SkBc2gwsBTJ1bnVeGPyDhQC9PInCFiKQcPk/92Jeifj1QeE8u
	cxuGGdfIQmdgxj7Kvsy+dbop1ntA6hs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=is6+ae+k;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763013619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2MsKwRjHGet0iZdm+L439mos6s82lSRuz+v4AoCdTkQ=;
	b=2QCLcOr0iqTN84Ent1dQbtxKgGOxWXMbY9xSrwgNGH+yXQOfCKsh8m2sp0iG+0Kp3CiT/e
	IVMOZwKqlrC3NpWSZm5nHfJYEn1LQgrhA6wCYD3YjECMbHDmbJ02ywqSMjHG07P9ZWoCEt
	K48iQUTx0nkc6y0rCSFiLn2l6qqeUYs=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2953ad5517dso5183875ad.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 22:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763013618; x=1763618418; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MsKwRjHGet0iZdm+L439mos6s82lSRuz+v4AoCdTkQ=;
        b=is6+ae+kWJp+gkYTtsmWiVZOrMYHPxK5XLIwl3QTbcfzI1b50AGXDM6zXqfE02WcUj
         YAhGocOQDnIISwKNSFYMaj0YVOtGAjlkg8mEfdXrlizmmoPmJJv2I0GBZPq4QFR9wheX
         wIlu4miljLX+6zvhwgnl+r1lzgGWjZWwxOZ4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763013618; x=1763618418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2MsKwRjHGet0iZdm+L439mos6s82lSRuz+v4AoCdTkQ=;
        b=cY6ZS3YS745i9CImAaPtiTWni8NuiCN5SgVUSlpFAI6Oqfawx1G/8vTbwRXK6tJ0ll
         WZjuv+FCU/gkBqNMclZlihbycKEtvc6tVe/aErN7HIcJBPJU/oCykebmkXs2HIXvBw8p
         85W47z6rBpVPRGwFcl8zQewVcJxiYp7I/u8QhuaPcxZ6cu0Z/2pTRcwz65v0pxYMJ6Bp
         EcNKzr/zG8wcIAOR8PEwe6xUECPJdS1W6w8t2q9cmUHX15Yqeorwe9mcYAtu2XzCaVst
         Z9RFLbTi7Go486GXWJclNZCpaqmxi0k9O7+OT2V5ZRPTjonTlzVXNNkqA7IplY7D7Gl4
         w/Xg==
X-Forwarded-Encrypted: i=1; AJvYcCVIXj/LyV7aQ9avZNvBho/a+LrteOtRMenvtfm1z6w6NOXRB24aCXJitQBftCLHGGg2ONdgy9oKLQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3ZhM+UR7YyFmIjUHgJqYdyiR3Qex6rms7cHFZCBBgAgeDrCTx
	ashHw/3qYYOZmfJTzimoL4tgMzfRMYYskAToI4mxxcJzS1srYrvar1XZYnhYLf6W9Q==
X-Gm-Gg: ASbGncuYTj/4iBEhnM4gfHGl29aomL9fOZ9GlrCxGfKKWZrDReOECacigFj5J3AZcOU
	pZYfisA/FO09Dd8T3HrIPGstDmbYUCq3MJu0k+vI9gNybtDzegkXoVc352QeGbELshhtTPKAZTE
	0gUQi1jM8o2mzedxLzizzLR+haHEsTHHPpTKwSbaA0Fw9IA5wASPGlqvaguynT65zpHLoRloX/8
	xVuxDIZ3NpF+xutvnnBMSqVeP00U4kicBZPyrYj/O4PHsG2gGFwcTgjcfTswyB4C53teqbKa2mj
	lg4oEaGRO6ds0F8W1U1/xK+1DbxS8K60qexzdxbETSAOE1tmD3BkBdAlK80Pb41NYx6hBDFNOUC
	B8M9LbEmwD9FvMDYgougMiVO1npkYpVfqbstbcgGN5pG7SH6jtgzrYlVS7CxdGWXuZlZSJ4Ti1W
	ndwbCIir1dczG7YxNbxCsdeSlRwho=
X-Google-Smtp-Source: AGHT+IHKwqOTdz8fSIHFxYzQn2PnYKM/6MOyoWIZGjd+D6fPeGOjbUoj6EnnIIRSeDn2FCLZmBDA1Q==
X-Received: by 2002:a17:903:2385:b0:295:1a63:57b0 with SMTP id d9443c01a7336-2984ed9d5a9mr75947175ad.23.1763013617796;
        Wed, 12 Nov 2025 22:00:17 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2376f6sm11463145ad.21.2025.11.12.22.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 22:00:17 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH 2/2] zram: add writeback batch size device attr
Date: Thu, 13 Nov 2025 14:59:39 +0900
Message-ID: <4b7b8f9c68f1a05ec6ada8aa7be9b735eae57446.1763013260.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <45b418277c6ae613783b9ecc714c96313ceb841d.1763013260.git.senozhatsky@chromium.org>
References: <45b418277c6ae613783b9ecc714c96313ceb841d.1763013260.git.senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA5EE40012
X-Rspamd-Server: rspam07
X-Stat-Signature: 765kwtpqrqkwk1zk97f54k5xg15erkgf
X-Rspam-User: 
X-HE-Tag: 1763013618-785345
X-HE-Meta: U2FsdGVkX1+DwDn7mnExFDTI6Ly0wYjxG+KZtpakjOsOlHHiAPsBhflUgq/xi71AypctpvlptekNKsD+tvJGEaePKqbEErVBZuKfz2TLz/2Pcq+PNWp6KNmMC4002lEM/qiDVQQrM7VVWoLnwHk7lEM1tQKGIi+PyPoTnBf88+Y+cQqNhS/64dHH1yTDECnEFctBfm5tB9kTNCjuN1TcnB6DFM7GFHl1ifr4YvWe5CEH95F98/OvHtwe5nDKG30on/3Xc5m/Ux44llS8nX+ThfrhGf+TmUCdeCanJxZi7k3wnmDaAFPNbraYzYMXPB1v6Dlr+4FW5O2AGFNhJvGgSnyCI8KL1EC5aflHpFduw+6v9JI5OQs+0C0uijrWcrB4YLjQAk+u3+0WVxY33Bs+8fWVDE78MFCQA7iT7FTI3mXiWF2VS5cazxNxQVP2sOfhw6rYJAL1aa8U9dEmutoLNPVnFDeTBFrNdPd/aYmFY0Mio3S1pQgsAkrHsc3pCjEcAs3RNxK8xlyrAOfKP4VfdxtSrb4AOLvi5YhfyhwHMFxBNdV62kNl2gz8IdGSpSX6MHG6xEPoA+hQMrQXufuYI0VByFx7FRXD8bblSu7ZUt15HahfjNtx/allSzVY/DVRbMoEI7U/NlLhYNtSRKYTDYClThpyZsgPWtyc+Hgn5QXcvMGrdtrVTb0OVW8uOmAQMAhV63fhS8IH5KOYo+QE2jzFq4NIwOsW0CB8WTQ8Xq+4vUf0eZ/539/YP+qfLtmmpZMSZV7HOoZvPjQnlrRbscJtCHve6evpRM7KRGQMLXJ0Bi+/caoZJQyhIpC6rBACrWxFUShbxS+RDfizs4Ia8hKrPo51YEYdYf2f4Rk4beIAMB/SZvtDXElZzdZ/k/RN7sc9uGX+mqHrBXxDIfGQng9eNgh4q+Bl53bmGsGIVQA+/XAgK4s0+kozkroolqr8QnfWZsfMGO7w51x40vI
 jLHWUUUt
 AphcGVp+KRRcrWmoDz6fTj2saryIBl2pKVYv66mV1YF3PRHIkQVYcPSDVY+M0YbR8JqCe3yi8bktuBbal2TJ9EzROsHcBvIMZCaCYwnw1gb+VhfX/g4x4i2/tRqE+r40Gq4uT7tatEnlUtMGQz7QjkwTQuzztqvYvKMVfi4YQyfIocK/G6h4CsbI+JLgcnrW5K5NpTWxtZJQ5GXeLyBDhQMNvH2wiamfo76ng4kpihKzXY9O1lJ/Jl3XYzjbKDuou3AE/q9FmtGRBZ/diYZQYbnaC1KOO5mian43DMow59brCD6pBeNkgHp78JQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce writeback_batch_size device attribute so that
the maximum number of in-flight writeback bio requests
can be configured at run-time per-device.  This essentially
enables batched bio writeback.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 50 ++++++++++++++++++++++++++++++-----
 drivers/block/zram/zram_drv.h |  1 +
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 92af848d81f5..d5afe5956a1f 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -570,6 +570,44 @@ static ssize_t writeback_limit_show(struct device *dev,
 	return sysfs_emit(buf, "%llu\n", val);
 }
 
+static ssize_t writeback_batch_size_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	u32 val;
+	ssize_t ret = -EINVAL;
+
+	if (kstrtouint(buf, 10, &val))
+		return ret;
+
+	if (!val)
+		val = 1;
+
+	down_read(&zram->init_lock);
+	zram->wb_batch_size = val;
+	up_read(&zram->init_lock);
+	ret = len;
+
+	return ret;
+}
+
+static ssize_t writeback_batch_size_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	u32 val;
+	struct zram *zram = dev_to_zram(dev);
+
+	down_read(&zram->init_lock);
+	spin_lock(&zram->wb_limit_lock);
+	val = zram->wb_batch_size;
+	spin_unlock(&zram->wb_limit_lock);
+	up_read(&zram->init_lock);
+
+	return sysfs_emit(buf, "%u\n", val);
+}
+
 static void reset_bdev(struct zram *zram)
 {
 	if (!zram->backing_dev)
@@ -776,10 +814,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
 	kfree(wb_ctl);
 }
 
-/* XXX: should be a per-device sysfs attr */
-#define ZRAM_WB_REQ_CNT 1
-
-static struct zram_wb_ctl *init_wb_ctl(void)
+static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 {
 	struct zram_wb_ctl *wb_ctl;
 	int i;
@@ -793,7 +828,7 @@ static struct zram_wb_ctl *init_wb_ctl(void)
 	atomic_set(&wb_ctl->num_inflight, 0);
 	init_completion(&wb_ctl->done);
 
-	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
+	for (i = 0; i < zram->wb_batch_size; i++) {
 		struct zram_wb_req *req;
 
 		/*
@@ -1156,7 +1191,7 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2797,6 +2832,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2818,6 +2854,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2879,6 +2916,7 @@ static int zram_add(void)
 
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
+	zram->wb_batch_size = 1;
 	spin_lock_init(&zram->wb_limit_lock);
 #endif
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 6cee93f9c0d0..1a647f42c1a4 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -129,6 +129,7 @@ struct zram {
 	struct file *backing_dev;
 	spinlock_t wb_limit_lock;
 	bool wb_limit_enable;
+	u32 wb_batch_size;
 	u64 bd_wb_limit;
 	struct block_device *bdev;
 	unsigned long *bitmap;
-- 
2.51.2.1041.gc1ab5b90ca-goog


