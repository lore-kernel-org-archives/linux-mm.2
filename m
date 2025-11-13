Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59674CD4F5F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:54:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B26C78E0016; Thu, 13 Nov 2025 03:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFDCA8E000B; Thu, 13 Nov 2025 03:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C63D8E0016; Thu, 13 Nov 2025 03:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 897AD8E000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:54:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5684ABBF2E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:54:29 +0000 (UTC)
X-FDA: 84104972658.22.D0D1FF9
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 75345C000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:54:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=eEiZMVhE;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763024067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aPh7ilOkJcTxNjuYqTovUMBkJNBd0ZFj5iFNSZBggZc=;
	b=Hq6IrQPjb7gB4swcvxonr4Ag260aZCvMnbvKEW58ex2KzP4/x8BapYDmMgMlZ/I/j8bjHv
	daOfY5zSrkOKIWs4LmS+nTbJIiLkDzyl2Ki3TLgyI6rmhySS5+kEP2j5yHIwE9ljhzTz17
	aPeT022BBaCTzMSc4+Sa0L0XjF0z1lA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=eEiZMVhE;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763024067; a=rsa-sha256;
	cv=none;
	b=ZthW9+PxU+7yecMs7wALuz3Fv2VnHdEI2anUMSGS6nVwrB4Y9Tg8WdX2qV9S5XFqRFgVoa
	MZ4DEELLL3MHHgX845QeDM3nDP4/Tedk7ORBz0Q0rn7u/+8LlKQabioMBwTGmUgFXiqzE5
	BZa69AOYPt7aLaMS0a6sliJNi+zAaKw=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-298287a26c3so6314495ad.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763024066; x=1763628866; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aPh7ilOkJcTxNjuYqTovUMBkJNBd0ZFj5iFNSZBggZc=;
        b=eEiZMVhEYT9KKzFI/EkPs6VA6J6dzZI5zCd14VCrSZtbXN2/pC1emyRsMRdBdIiiMJ
         FraUDu6Qq1ug6kW5uJtnJx6TgRFuBa8MVsdZnLO8k40hQqcCnjhG8Dfno42dU7Gr0LXb
         fSi28Sso4xxdSjYjtG5TVhYruKjsvZRUOvEpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763024066; x=1763628866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aPh7ilOkJcTxNjuYqTovUMBkJNBd0ZFj5iFNSZBggZc=;
        b=cqebuR2WbHJcrGaziRFX9oJoY8d1pqoNxG/3d0eujvn9bzZOti6zNTb/9H9NUj8p1f
         perhya+0gcSci1wBhfnE49++Rmxzfkz6wJtrfoKyf6QA7hL+xBxFtXpru5X4s29O6H8Y
         lQ6yVY03yIxN8NzIaDEAERckGpq7cvaM/Bag/as7VrnodMB7NLosw2/KyC6N7zkH6OH5
         mhXVplLzBKU8wZRJ4brSh3DZgy6Agn8rPyIRjA7DxOz/mn/d82oMAzm829i0O5lsvPzo
         CVbuSC+bLfwUkwgXr3MhoqPI3LgVujEva+9hvG742uMmpIGo0adsgUtQH1swGRCivd+T
         0Urg==
X-Forwarded-Encrypted: i=1; AJvYcCWxJICV5RktQ64lR8iiMMnrhthOAGAW7al4mheo6qbuLRv5X5T2lsF7BlJte9HXodfu3yWhx80V+A==@kvack.org
X-Gm-Message-State: AOJu0YzztJg6I4pyQDAW6TtgZ6PTxBDzkPoOE/jj72XGAuZhGBXV0ab8
	k/RuCXBj7PgJciq1efxdjVnRW0vqvX86Tp7OIxhiy2H83a7xj75/WuWnMf8Ytm7L6w==
X-Gm-Gg: ASbGncuoc4HUiixXmaNomkut0QSksp7e6WZvR+5PGCwIXwpJA/01gYkXii0QxvQg9co
	iDtgbnWtm/g/XK6VqiQs0baCvWj3zOYsC0jtJD9a7PZYaCJ08KKkOcKhq6yv4IMtEvjl+d4HjTi
	zkaHbwQdpo4Ht9YQ1FQEQoMa+2JoBrybUID/zfn8LhCkebS9aOLSuhj6sGw03zGdDgJHOF0Wold
	+ljhwShvMAO46KZKiPoMo4k3lqwLVZJBxQgJ59Bj8f9xJtGVVzQAH6vmSY1VewgfV6/uO+XaSgm
	EeTd0wttg+yixhDyw6i4fLcRJRJznHr08WnHHoZ0/BkcC/D1AmePBypDXnaqc5mC+MF2wlzMyB2
	mAmRB+I/cjAIiN6mdQno3e+HiNz59ciO8QYTRabkqrt5kQ9+i3yeS1pkkQPP46keja9nMcSdP3h
	Aw5+WqEvZESJeVxeEpmdEwutTxIVowi0cjAs0tNA==
X-Google-Smtp-Source: AGHT+IHDznvOsg6P+PZ5zeENKccT9BP5vgmm7k+qpOBrv2DZh+4wB1td4Wp2IINZJb4BaEgtt31Ibw==
X-Received: by 2002:a17:903:13c6:b0:295:4d50:aab6 with SMTP id d9443c01a7336-2984ed92f90mr78132405ad.18.1763024066402;
        Thu, 13 Nov 2025 00:54:26 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2346f3sm17486465ad.18.2025.11.13.00.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 00:54:25 -0800 (PST)
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
Subject: [PATCHv2 2/4] zram: add writeback batch size device attr
Date: Thu, 13 Nov 2025 17:54:00 +0900
Message-ID: <20251113085402.1811522-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251113085402.1811522-1-senozhatsky@chromium.org>
References: <20251113085402.1811522-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 75345C000B
X-Stat-Signature: xwo58f3fojjyksj6fu9y8tw1rj3hrys5
X-Rspam-User: 
X-HE-Tag: 1763024067-967002
X-HE-Meta: U2FsdGVkX1+cEN3VLDxTekGIPdZb8KZx0TpNtCP0OunXY3aQkrv65tcERs74+fPTqzq5PVmF0VZLkpTFP6BHBqIyKyEV6BDK96IRQIESBMC52Eeqr1Zb/8olo14et3FYJTRsELevgDScefYx6CZfZ3n+hSzv7LOOERt32/vHfZxyOozY4zCIKok+HM6RdPevmIAke00BQsZo0T7kLaRf4+sGAGEDCAuN7USa5XVvwyFAcQe0/mTARJU5+ict5GbTq2cqvBtDV9/orA6eZKa5Rja9xOUfsJRgjNZ6WDj+Q67imcNNt38HhoLwti14+TAfatmBu6NwF0W6lzVxjvepR1OSNg/37vJF46xwToL66GcY+vZdOLzmCtCasePKZ1QOzRuPIMrZ83XNuP5SVYyoyGDP3UPtsy4oiWH8n5urlrjtwqWCrOQxNPr0OksUPRCeEC199+tAGaZhbpqUryx8YzNp5xU/f33J5tI2EhMI0A/2HxYdLiCPc86IE9sbDoDyhWZxPFX2JB0Do2gNA2+PIpRlK2XtzfSG6f4m6fSXFMjlCkBKXyFDoCg5Ovej28xx+vE5vfD8lfMNkGrqEnfczY5Oc/r3AaDA5R4x+hf7tF69GTsBU+oW+40dW+WxiqUkBWK+wlfEpcczeSAl86T4pJ4itb5djnEvon0Dn+PqnOXkgHvYpDECDs/nVqFzfBWOzmgrFZ8GPSsid8UPoJyCjiibAPdbQQ2gkja+WLGwEoMUCXj8M5MKhTGjLkYWqf8oFiIOBmGAYICOKvkYqPo/6tPtJ8GXY2RXEeH3H/Fs0uYAFOvTWX3hclqWJXFVSvtGA0u9Ei2rBpghYn/wqDsvSV8u7BFagl+1ZFoBKJSJ4cbGXQKsFYlcqQL9sGhd5D1+DAJkGrmlWBQf0YOYvoxqu9K3wtmqzn22LSP7UsgVsh0qJp9BtzF4ebDq3syW7G8/gP4lSY+thzhPzzBrKTA
 9GQVlltc
 TzJeYZjZsCnaUuq+SlA0HJtZg5JYeoWgZQqrNy/80Ocp0Jk2p0h800M8Vi6LXeQmdfsXeUHSASIDnZBRemFAkzlSlj4TNbHWbHkpWhw7QYoJXI+rEEFlEPldb8Annuk+QVCYbSsYEp65phE2mdNCDC/YNWVbPqdoNXfzEVdNFPEzYHiPS97KKtXZfRbJcN8Rh8ceLG9C3oNu+HhVgqsA5fZ3qPZ02HtQKxoRESxQ23iQ8yiuTWwc8daLUibBQ8B0ao1dh80B/Yxc9tfZqtXmrjFUVAjRx5NXkdvjbxj7guksB6UwgX5wGhCzD/Q==
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
 drivers/block/zram/zram_drv.c | 48 ++++++++++++++++++++++++++++++-----
 drivers/block/zram/zram_drv.h |  1 +
 2 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index a0a939fd9d31..238b997f6891 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -570,6 +570,42 @@ static ssize_t writeback_limit_show(struct device *dev,
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
+	val = zram->wb_batch_size;
+	up_read(&zram->init_lock);
+
+	return sysfs_emit(buf, "%u\n", val);
+}
+
 static void reset_bdev(struct zram *zram)
 {
 	if (!zram->backing_dev)
@@ -776,10 +812,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
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
@@ -793,7 +826,7 @@ static struct zram_wb_ctl *init_wb_ctl(void)
 	atomic_set(&wb_ctl->num_inflight, 0);
 	init_completion(&wb_ctl->done);
 
-	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
+	for (i = 0; i < zram->wb_batch_size; i++) {
 		struct zram_wb_req *req;
 
 		/*
@@ -1182,7 +1215,7 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2823,6 +2856,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2844,6 +2878,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2905,6 +2940,7 @@ static int zram_add(void)
 
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


