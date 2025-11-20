Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA06DCF8865
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097646B00A7; Thu, 20 Nov 2025 10:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021C46B00B5; Thu, 20 Nov 2025 10:22:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E523C6B00CB; Thu, 20 Nov 2025 10:22:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D65146B00A7
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:22:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A10561A0189
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:14 +0000 (UTC)
X-FDA: 84131351388.02.7463D10
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id B6DD04001D
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Y5vpG/Gk";
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZAmKATgpNu/alXOGtuyOI3W/oFMTAwgOBJmF8/nzO6s=;
	b=pKt9X9lnYjHYs78qKgY3pE7v7Emu5PncOtURC14dyhOPabqKypNI9FZpDMr85RvgFjIvVR
	xlHMnMIXnCv/7btNaN8noyv+m2UlpC3P/0e7eG2Y4Z3tDpnTWw9+EcqrPvs7vdbZE8Ouhd
	pnpLGDXsg2a6KcSNCArLpxHBQ1SrIxU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Y5vpG/Gk";
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652132; a=rsa-sha256;
	cv=none;
	b=3aYou+V0OCBT/jqFdDU9IhSwKcOaI4Ta7IbNRId3QrUqgVE4T2MsnpyeBb5KyiarinOwaR
	Ucd7ITkyXnL/ZMy5xIZ89ebj26YtPtM5Pep1LP7ukFGrQvdTzBAf3JS8aVMe77kUtntQUv
	yHo9A8HHtn0vWfRf5ypnYGNeQNzqfY8=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3437ea05540so876290a91.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763652131; x=1764256931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZAmKATgpNu/alXOGtuyOI3W/oFMTAwgOBJmF8/nzO6s=;
        b=Y5vpG/GkBRNmjYAn+xh+lc504gFIkPxHE9xjNUAMQ0IUvfJ10BW33RptnlQkXxKg4k
         7JrY27mhOUiweflwkbDooUrO8h/eZE9LNdcsjxZi3N21GwA1bwFo7JdF+RZRUkFXR8p7
         rJk+14gIvsWk8NQtzVpP4WHL2jOTbUBpCgw20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652131; x=1764256931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZAmKATgpNu/alXOGtuyOI3W/oFMTAwgOBJmF8/nzO6s=;
        b=mrNxKTMNLXabiO1NRmmlSIr5hxsHKDjAKTAO8mPTiQeu2PVCYxaCUrJ4mCK6u2YDcR
         9sBRtArYi+bY+tCRyZ7UfFnmCf955VPSoloDzCPw1NfgE50zaL9pNM9Xsxq76X5WgBYf
         om0mcjZFp/bZDu+NnsH+HWvxoE0RSrjYT7hAKR75krsqcluc9ESlFUgd5x/oulx1iuHY
         gcjhGfoQWsmHtiyMWGbe7d0Ssfpr0Me/HgIKtax182NLdi9fVMuPyt3uW5h7u1h20YPK
         46qcHaqwb+m8z7pY7CONTeHNpEAq2fmsnsAZESw1i/JKdaXisM02RQqmESu+MF4/5wIa
         TAnA==
X-Forwarded-Encrypted: i=1; AJvYcCXXVkWRUtYgG2Pgvz6fV8ErMtsm0rp/IVSCKPzjV/xDfsKrKR8G7x6vsY2egy6xqSx6N1YFzZg9Tg==@kvack.org
X-Gm-Message-State: AOJu0YwXjXZuUIzOho471a9SnknD2Eey/sgUE3UvUHw3BFhub8YxIDnY
	5fd+cwL24tGQWkslpxHcwbVAVX4mtLG4jmrozfCXMTYBgPCwKCaPH54Fu2DMBAshag==
X-Gm-Gg: ASbGnctiyqIX8KfMcIXCS6Q2uCKJkyIkMSBoy4awIX4s0KvjrmjBMGIt/RxcbG3J9jg
	kHLQ8yJwtPQrrF9EO2UKwD7C6J9sUHm7fOrl4AY067fAxBZgm5m7O9WC5+Yfi3wOAEZTym90x69
	o9/1D9cBy1RjqaEsn7z8fw6pim01Ml9IN1FgssUyUREMCWulsQIu81DqgBu5sfE5jRTU/t7O1eN
	50PBFSwvHeKzJrD344l4js5qRLcdHaKFPIPIIksK4k4UVnOad8y8WG9OoT4OhqP63z4em3+oFru
	/Tqngt7GGJy5VPggDrVUQnr8oQ3Y4UjHmFXXoYnmCEtKVPi8jD9ps5IuGv6LFJF9fsZFanYgqQb
	IBQUJCWDr321yuhivMlSI0M1TYGZM4hs3xUXeaV0i45AfYFTf8jRjh2AJ7XER4VTucz4fZMtMiP
	tgxeGqRcXDLU0W2TTMZZV+fkwJdWzvMHvx7y8Nig==
X-Google-Smtp-Source: AGHT+IGXx99ORaMc9c2Jm3Uyx2w4g0SNrUulESpO10c9NwCK4Ja79Nw8/lRM5g2x9jRJA1DHlD8CCA==
X-Received: by 2002:a17:90b:53c8:b0:340:be44:dd0b with SMTP id 98e67ed59e1d1-34727d5233emr3818884a91.34.1763652131431;
        Thu, 20 Nov 2025 07:22:11 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6762:7dba:8487:43a1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f023f968sm3179642b3a.38.2025.11.20.07.22.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:22:11 -0800 (PST)
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
Subject: [RFC PATCHv5 2/6] zram: add writeback batch size device attr
Date: Fri, 21 Nov 2025 00:21:22 +0900
Message-ID: <20251120152126.3126298-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251120152126.3126298-1-senozhatsky@chromium.org>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B6DD04001D
X-Stat-Signature: bghjgn9oykdawardam45yzjkxbodsi8h
X-Rspam-User: 
X-HE-Tag: 1763652132-512031
X-HE-Meta: U2FsdGVkX1+JBF6nKlAB+1SfwJrARTOm9/dHhazhvWcvqtIQ+OD98vgXcoE1ht0/Nu6+LniRlPNMHNGLi0nilU0541E0wcJ6dwR+Q7NqSjWw/5aVIQkyyjeEA5TkBHXLP4lSF21FUGAkz6giE6gDyfiaNSGc/zZJmWKCcsIav9KbKcWokV0eK+R4QrlndrGLr82ywUhAYr7+L2dcYqMu91v+NXZPZkcPqhl4jkWYw+FiKPbFxA32H3AlXInaeWHWBOsVxfAmfdE8QcguUAPNqaDYRhkSwRUUb9N70QTzy01WDdbWd+eEcEU0RTjMruz7vgcezu3kPCJ8Cg0te+IrQULJg7/WXV4v/rbyYcrfvmNRZ4cutr0bQnNAcxrOlz2KbFAOWlcXTzjP7hBhSpjVfJEQZ4qYF8Rv0hkBPoUDsAjDNYgFs/5cGrW8MTDen4rMn4fn0oQC5NyfLuyFOMCbs2TbQjZ464YLZeCNirwoWzJ9Kxn3CX7bGWr1OE2ttroTjyC4ZoCTJ+tvU/u9iFZCSsnbhqex4Hl2Qfa/eOzQCLeUABovQurXRJFb1vj0Z302R1k6OizG6KmncpSOXKA3k5xezrRDAFdOfyPgy3L3SnkHXewXuScsWHrWLf1e7ZIF0PS63rVYitbDbNRU3fNdN4KYOOuGlxWNz5QPqT5Jbp0Ksw4AhC4uJZa55x2jNm62C15JHhHS5xxF1bJVL+DdrN5IEgkrhXII7TpK8FWHF9bF2iPEyVNSQ+tpAio4jUZ4Z54s9ytmb2qoGcuxYchp/1OCHKlFF3fE7UJXUV32LQakGOk0hjjomSxqjQLxKxp9RPjtCQNbOf1J6oPdOIv/3oXrcGhI14fDyUGnubrdpyFulrIl7OJUSZonn98ym7cpC6G3XiRaRdgkxUDRIqY76ZSvRjzPM2lKVWZvcNMgYVsFS//cSxb2ylO1GyrlYR0QiM7i7OL/St8ajMp1lsH
 fn+v3t2x
 g4hbzSWEOFOebZHuM5KKe7K5fYxR+YhQLUVe3yJORQ4ZT+ENgBrSfrbM7qdLr2BvX32Fb5X3aKQppf5JrDtOvqkCae/0Zvsk0NmLkJcxX2BJ5MmDodhcdUXEtNTHWbC2ym1kUDAsWclKpM1iXk9fbJokghRPkVJzjN8PXEG4TcpdmqwBmYaZyBsd4E2BJ/JESSkaV/TQgaUENnna68xN1H788RuET+qjU+0vO3Au6kwao9vsrYMsiH8yyOcIGDrpNCj/bAMKDctK0Nckt9YJGkKy24yHsTTd2KOaADmD4auWwIaDMKxgJRK6OFQ==
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
index 37c1416ac902..7904159e9226 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -588,6 +588,42 @@ static ssize_t writeback_limit_show(struct device *dev,
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
@@ -779,10 +815,7 @@ static void release_wb_ctl(struct zram_wb_ctl *wb_ctl)
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
@@ -797,7 +830,7 @@ static struct zram_wb_ctl *init_wb_ctl(void)
 	init_waitqueue_head(&wb_ctl->done_wait);
 	spin_lock_init(&wb_ctl->done_lock);
 
-	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
+	for (i = 0; i < zram->wb_batch_size; i++) {
 		struct zram_wb_req *req;
 
 		/*
@@ -1197,7 +1230,7 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2840,6 +2873,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2861,6 +2895,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2922,6 +2957,7 @@ static int zram_add(void)
 
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
2.52.0.rc1.455.g30608eb744-goog


