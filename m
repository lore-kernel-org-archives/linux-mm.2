Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79333CFC51D
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 07:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70F16B0008; Sat, 22 Nov 2025 02:40:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20AD6B000C; Sat, 22 Nov 2025 02:40:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10076B000D; Sat, 22 Nov 2025 02:40:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B08EB6B0008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:40:58 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F3298A0D8
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:40:56 +0000 (UTC)
X-FDA: 84137446512.21.F8A0773
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6D6A180003
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:40:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="n3/X4L3W";
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763797254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SX4VpemLPNnHEK+as4wej/2Q8OupmjwjrzAvH21+biQ=;
	b=3wYh3bDxnpv/E2pUJtB+RbNpTUYDD6uE+lFdiwBf2u6ybNjCNEWL4uYF0qRl4kKC06UFmV
	UtEQfhivwgntcUk/X6oPtWSbR40gDA9DghTvTT3wcyvisYteO+dR4k6K6L7OEoLW02iHhS
	fwMoA3UUhKgp78fqaFL1lIJtPoeDxVE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763797254; a=rsa-sha256;
	cv=none;
	b=jWdLkLyuOUyGHL703lpzoyiwD+Ssyee/ZWO52VWAYGooELr99i98UswuR9BJof3xSzrw7S
	+q5C+WBXgBaaZLKQJZVh72H+gFezPB0FHA+4eC2KIrOqDn3xh5lAGNZUyT+MEc9dzZt5rZ
	EmPmlOv7PRsD5gq0kMCRaHZCcC41hLo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="n3/X4L3W";
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-295548467c7so32619895ad.2
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763797253; x=1764402053; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SX4VpemLPNnHEK+as4wej/2Q8OupmjwjrzAvH21+biQ=;
        b=n3/X4L3WRayQrDceZ9TyaDm8PWSm6D3AAzm5is6MZj5DpqgTjabHpq97bPenx2MgeM
         LU0op2rK1n97S4fqrnm/e/UPeu3NXTiQbWGolfWEZrjZlYUz8plUeJHv7Qk6hAX/wtt4
         vAiTwaNu6iAgWriQkxTdXRtAhe2TduNdTdb0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763797253; x=1764402053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SX4VpemLPNnHEK+as4wej/2Q8OupmjwjrzAvH21+biQ=;
        b=UhnP4sXo2nTWvoaDtoX9FgAxAqLSuBTs5LLMUvC+F0btSTqTJ2BinEcezvl9O2AOfz
         HvDzoKoOIS2e+4CzE4GdwrowrzmC8nJsZCp+KGWG/Q7qoCphEZRwiJSYjGkbLO7yWVby
         hGfvAt+j0/QD3eP+TdM+4FmVhBv9nriJpyHfwPbOqOOLNTcznkeo3moVtfgyRkGJ0Zca
         n0GGCU9pBFgdysXXABv6NBT5O5wsYWPDwAG9Mp5ITnuMuUMw5OA/J7zi0tupHbhtpJkq
         esFjRnHqmvvMPMAgTShG1hkBOBjhk2FQVXzl7p1DR1wb4cA0miiQz43CingowVSt+au2
         H5jQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8iZuVxMfNeS3dgFZ95srM1vy4QyEBJu32p4DbSUM3dLk7SIBgIdguCGGC77jHM0RdkqdWWrMocQ==@kvack.org
X-Gm-Message-State: AOJu0YxwQtmWpO0mRjsnHE4BXFNeXPY9AwPvG3q3Ke2aYZK65jqM1hUL
	Y9mu1EAcG1V00Y3cuPJasa+c4vJiNZdU/QVbx5pa3GNKh9fnCdCWFPXuHXVKXTGDCw==
X-Gm-Gg: ASbGnctrFqLcTkcIQ0ds+KeCfcTgw1x8F0u2G0xJ/ixMdxYmvXhdzdPD2j+sPHiNdAr
	+213olY9sAEe4xlvUGWf557+UQLXIcyrAS0LtbvpmNSOodsOPKmpjqzZ59qpdoW949tyUIh/fqy
	8fJ4a3ILCHE0hyNrwLsE2dnjYMjTVpLVLZ8LPWURUF0Ik4a90zSKH+47FntTTCYckbSMt2nGGKr
	P4qVdcvZzwtyKbChnwKLp5lDG2rM1BC4aFGdW1sFw6TeWsd2PAEhIJhyklVgSC6cBnmbdPuw3it
	eodIFVF6iYtUCRdgffNzwfZKi8Nlx71ZUu2OLlSaeJ8BZMPsq1sK7jThQuRTDS8F20x8MKqu41Q
	/jWmA9l0187pRBL7El6xtCr0kia0oCptKF1RBj+uKknzwrJ8b67CvIjvIJZ9Qa2i0aTgpBGTAmj
	V1/bvTbfXgP9yKZ3WZ3dkcqB8in+mFne5o2xkrNRQQ+BqeVKHFnFROsGyBRwZ53/nWunrmxyQoL
	WSioKkeelas
X-Google-Smtp-Source: AGHT+IFnu2Sudoe6jxzn5HtnDaCFVbXUPGcH4YtmUDiSHkmwz2BuN3F8fTnfFOOCqEYv14rgm5x3cw==
X-Received: by 2002:a17:903:320a:b0:29a:5ce:b467 with SMTP id d9443c01a7336-29b6bf9e98amr65542735ad.54.1763797253269;
        Fri, 21 Nov 2025 23:40:53 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:948e:149d:963b:f660])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b138628sm77771555ad.31.2025.11.21.23.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 23:40:52 -0800 (PST)
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
Subject: [PATCHv6 2/6] zram: add writeback batch size device attr
Date: Sat, 22 Nov 2025 16:40:25 +0900
Message-ID: <20251122074029.3948921-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251122074029.3948921-1-senozhatsky@chromium.org>
References: <20251122074029.3948921-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9k3k8xtxefpngbw1tpyt3k7beu79nw68
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D6A180003
X-Rspamd-Server: rspam01
X-HE-Tag: 1763797254-95818
X-HE-Meta: U2FsdGVkX19j0xW+QZhYqV8NXdNuL7BLejzn64GbIg6/fZf8qwqVMYr4LNPn8NzK2nifYaPXbobFlAxVvqW6JurOnkblLFIOECixT65xGL3b77P+fxagMSRpTfOlRy3SKfW2Ln3V7KIq+uLao1v5cIOn8ODNKhFKZV7xidTBnFi2Zy8vYy2burZ5Vug5kxtFs6pxU2Cxp+BX0yFt5KOdQzDRgy3yx13RFVnkECWSzzGB0L2bufry3JjkyLcuYLfVaYLUkSYkp7HanXi3gCwHK2Qzdyy+K0fTWZinYzAJvyahhbv68mfyh6NGbQXFYR4Eg9tV5h2qHVrm4wik7VhBPKJvjmdmeSXgkd1+9tcVdRWo/yWmJ8dgui1Uwg2+/hb8km/ymVdSydle0wjlbmzsnlrE3vf4WbxFTTV7cU/PiEUOGTf3TTuj1zXAqYnnE1Kh0239noNYpugLz3+LMvg3KMKkO7GcOkueMSkMNbRdYJJeRqixjYKIClpISthEvmh9y6aIANmuefmmydQf/fJvuXpy9tKvqr6L+SoxxyCVwlaSLmNB2j1hJVhtwTK+M1T6CxeUesz9+pOkGDJJkWNXYkZ13ktbLJDwAl+akrtAIOLZmqfeSq2cJbjSF53zuMs04GKzbkykZfcXHgkGQArEciG2OAD+/lRa0ZXHCj2ZN+4b7qWd7sV4OTBirvfvTg2rwDG2owKRnrxZzixREiou4T+gb9YyVsfM6O9pG/6tfteMv9FaE8MW77yzQnadkYu3cd98GaoRYAEQ9yCFQnSaVmXnk7r+2RIUTnw5gnsOLOjEOmHJGiTMRFQl9f1FUyk54W9shGMkMyxIY50OwYeDLwws/WQ7lsfu4yo4IgHkfTRYpNQdzV4ePoqxvNeOBq057JfEu8UzV+t5w/sOg02G06IVapSzuOvPK1FdccpRfRE4rvkPY6Zbn4B6B68krt4rjUe4dcsfZuynFnkVoRt
 7BfrVODp
 VqiopgYY2TVhxrt/sbbEVVkTLxaBNUOFLvl/zSGz00s9xy3cifiSp4qJgw0LGPUR3MQb2+F7qsqT9+rSbgB1A4WQd9oOyNrRHqnKoPzfI42OwjuLyE5Sh+x8vWnxyvKFUtdxTyeQ0gmukHRjM9rs4hbGVnIrYvHgKilYdLfhOdY1JyluCOjbqOSX7Ttml5vJeFufh2+TSGzS7jieqg3YS07y38XZBaBCgYf6fwrdUBWb6y2MX5MG6HyLYmkzL9DZ3cr02UxxXXXeVMvx1mam4A7ZVqpZlvlqYU4f5pXDdvqMwr8BpJV08+c8zFg==
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
 drivers/block/zram/zram_drv.c | 46 ++++++++++++++++++++++++++++++-----
 drivers/block/zram/zram_drv.h |  1 +
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 06ea56f0a00f..5906ba061165 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -590,6 +590,40 @@ static ssize_t writeback_limit_show(struct device *dev,
 	return sysfs_emit(buf, "%llu\n", val);
 }
 
+static ssize_t writeback_batch_size_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+	u32 val;
+
+	if (kstrtouint(buf, 10, &val))
+		return -EINVAL;
+
+	if (!val)
+		return -EINVAL;
+
+	down_write(&zram->init_lock);
+	zram->wb_batch_size = val;
+	up_write(&zram->init_lock);
+
+	return len;
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
+	val = zram->wb_batch_size;
+	up_read(&zram->init_lock);
+
+	return sysfs_emit(buf, "%u\n", val);
+}
+
 static void reset_bdev(struct zram *zram)
 {
 	if (!zram->backing_dev)
@@ -781,10 +815,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
 	kfree(wb_ctl);
 }
 
-/* XXX: should be a per-device sysfs attr */
-#define ZRAM_WB_REQ_CNT 32
-
-static struct zram_wb_ctl *init_wb_ctl(void)
+static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 {
 	struct zram_wb_ctl *wb_ctl;
 	int i;
@@ -799,7 +830,7 @@ static struct zram_wb_ctl *init_wb_ctl(void)
 	init_waitqueue_head(&wb_ctl->done_wait);
 	spin_lock_init(&wb_ctl->done_lock);
 
-	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
+	for (i = 0; i < zram->wb_batch_size; i++) {
 		struct zram_wb_req *req;
 
 		/*
@@ -1200,7 +1231,7 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2843,6 +2874,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2864,6 +2896,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2925,6 +2958,7 @@ static int zram_add(void)
 
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
+	zram->wb_batch_size = 32;
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
2.52.0.460.gd25c4c69ec-goog


