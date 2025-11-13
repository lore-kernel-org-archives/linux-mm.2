Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C88D9CCFA18
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 05:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04ABF8E0009; Thu, 13 Nov 2025 00:10:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3D408E0003; Thu, 13 Nov 2025 00:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C788E0009; Thu, 13 Nov 2025 00:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D053D8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:10:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7342C5B2D8
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:10:16 +0000 (UTC)
X-FDA: 84104407632.20.25C2E5E
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 856AB180005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 05:10:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gDbbCtN+;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763010614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQMe04Yi7xRdtm756UdrAtfkVrI3s7FJjDivoW7Ul4k=;
	b=0Qmkuammk6VtgwPmaTYek8IRwKmh+JsDQxW1VAgn20nCEtAg/qEXQ8js04Q7DjJA3Hur+S
	2SCwtWTCoJ+tNAyuhhX/4YTcS9d5bndUmiZlkV7TSIg2c00AOYXjhOSyw0FsBSMd2Seg2a
	J15QZZyNnp6o4NPi7eYiO8Hu3E2qgDI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=gDbbCtN+;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763010614; a=rsa-sha256;
	cv=none;
	b=nHW3brp0890QSP6ATyMddrW2XZQGFQotZhQwZdNwJaxjN8cpuqYceKiXazffExoko7BL4e
	w8c8EiRXKNp4etGUhqz3thhhvwyc6ffUUDCNlE+9e5pjeae61MTdwvfHeOfnyXaNC/MBBM
	UVUTCRQCMsh8NDxdO9Rbpsur3uVUWrw=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-297e239baecso14161175ad.1
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763010613; x=1763615413; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EQMe04Yi7xRdtm756UdrAtfkVrI3s7FJjDivoW7Ul4k=;
        b=gDbbCtN+MBhsxdTSfk+F9PLxyYj7vFbiMx/aGUXE9xCGir9vwpTPW/ZtkWKglCYcgm
         gcxaTDNhFn1fF/ZFAlmKKG3pLe8hY79+6JSCIFhyG7Yk9H93lk36F/Y02zfzSfeB4dn9
         fwFN0QJFDPqsIDnbqe79Yh7/QXbyGIOdRRZY4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763010613; x=1763615413;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EQMe04Yi7xRdtm756UdrAtfkVrI3s7FJjDivoW7Ul4k=;
        b=uPIT689n4LvbuGuaEcrtpzoVpdgCjt8hWUnthe8QCsaC+SVIchGu7/V/Ba4lDquGy2
         m6Slx7nFENsiAa0nZJKh3hdyAd2t4NIyWdjKFkt0AXvMAVETHLnLTh2ybqSU15FRyqTX
         zVsLxw6E0zhUdlgtv96474h2HHfLVJPU3USuio3yLFupzObsPXBIJBWxKSwQu778Zn1m
         L23vP3AHV/bp3dy1mO4fux42B8+Vr4l+kNoSdflp+YBZWM66+O5K3x/yMKzPhYZP84g/
         Xr4w7Y4hFKXMgyaTdeDcyZtvZF9zzuFmlCXnzDpvJRAIlLq+C5Z4p0eanrmNSw+1R4Pu
         UG0A==
X-Forwarded-Encrypted: i=1; AJvYcCV0xRSMAuKcCP7KlBnboe4aeAp8aCbpK4tQFjMPEIYiY8tAQBj69Z1M/wSYeHwwwSvwMpkZhOY6Qg==@kvack.org
X-Gm-Message-State: AOJu0YzmD4NLVCDto4WZZUyfp9sUDGqA7SCFjJNPVXTXbPRr/toQPoSK
	Hi/lxxBE2uOwTzrUzDjMZgp8G2TZU6m8MBC4jzrEqUyUsMQ47aQ88r4xnOVDoT+pXg==
X-Gm-Gg: ASbGncsUOlXxbq3Netm9dy7pLfIv6wUsHSyzVHrnRpD2ulQmrXG8QWuPalw0kKMWKGQ
	6GsKPHAwx6xPwRCcn8r4qhU1/Wa+ASDb108XtmrLo+RC2rHLahb3qabRHbICLqvwN2KsnRTU22D
	TuLPIQuas3RNhBOF9hxK5LG3Iksjyk8vaUGsb427WOZmpH81YBiuLY/NP6aglawL4pIIjJLY54j
	yBVLyXjw9iVauTCR949J5mLBlsRgiprYVnOTNr2v3WECev51l0VNdMm7enQS7zzphqFcwp4eQ/n
	/BVNjMaZCbzpfMh/jJLW0paKkdIbPXS+aqRE1zeNHTKGQLTl4I7/zwCn+0Z6AAxA1wD+YGTUi5d
	dDjGtt+w+6zjFBOFUccWe7fSsoC3fj+Np1/AjRa8p1WK9dDO159AvuI1712cmwseoYhALewzJpk
	5fL/Tf
X-Google-Smtp-Source: AGHT+IFaLW8GEDBcsoapOHe3wZi+rPMM3f3HSMv0BD1FRNhd+sUeimcHYmWoETvZ4VyiSFWPGjfTLA==
X-Received: by 2002:a17:902:ce07:b0:24b:1585:6350 with SMTP id d9443c01a7336-2985a4dd2b8mr29219475ad.11.1763010613390;
        Wed, 12 Nov 2025 21:10:13 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2346f3sm9713465ad.18.2025.11.12.21.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 21:10:12 -0800 (PST)
Date: Thu, 13 Nov 2025 14:10:07 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liumartin@google.com, minchan@kernel.org, richardycc@google.com, 
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <mc5ww2wi6islokdc4kwu2pw4a7l5ufwigsfw4b626okq5uk2ic@f5x2otsnarws>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
 <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
 <rjwycg4sfzuroi3yzsovtebwocabyoq4vq4fuc2cbh3w4n3uo3@o7dpmtvqr7fe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rjwycg4sfzuroi3yzsovtebwocabyoq4vq4fuc2cbh3w4n3uo3@o7dpmtvqr7fe>
X-Rspamd-Queue-Id: 856AB180005
X-Stat-Signature: nsrgkzoa9nqi9f7rnesn1kb46fnuqhyz
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763010614-258272
X-HE-Meta: U2FsdGVkX19vDJj91dgLhQ/41VpMWkTUNA8AT6vi4qa5E2AtwYvFeyaffIB007JGf5G01auCSr2e4SDAREtS0oYHJ28DpgRwkpfx6K+vy1JxHjTiJ21d0iRYzMR1LDxTEfPtbiEKY+rTv/7uB9pClTm8Gvzf9LX8PzWnrZquQUzabC1TRX1pbtzU3B3g54QDtHXbOfsARLVUsRV/GT4aIgne5ojx4iL8EOXyrBcSuqyrNE3lN6VhpUrRhwHNzf1SMEdCjISgyDtgafTah3MP18On4ia4N8EKaBqpiGbgtESsQgGcpQSLh97IesFduFFMSVjAQ2mQcySxffToHalwhmH//elpWOBr5ki+y/D1OrZ3oeBo8ExX4qSnZirDb47cqmWNphvXoZxc5QTv7LhZ4EJCdkjR9BPjbLCcuOWwcHqlc7/jzp2HhPrDrjbzDvRnbcDf/z2kEgmhAd+U05echPmqEAsdEVe/26rA5oDoMF/92lNkZpnbz+FiwHVEWwjPYe4S5Zx8Hh63Y9Qa2gQjIHiGcuR4tIX32o29AMRx15VJm3OL09EKhGsgpktjXcVUxV7ZZrFrz/43QZqWHrlqb7Ul+yej+zp3V1620+e/xg0p3IR+wU9mnCy56ihEOaFJdajhNUUxETiQryTY++bczrTvkYEbX20XXhnm7TumVJ90X7LKAhEKq5AJxKe01Cu6ih2MY+XPn+fxdo5uFMBNrvdyhV3Ajkl/C9//1tYdYOSpUBax/cloWsgYBZBRZ3IItj6QoAx9qhXiBerHjjd5hv748bS0PoR4/buhWr0BH9zMmb8GjlFBqaGDVLvLigM2tiMebacZgYaPqwsqVsQ8OqWzHMKS/AN/NmDUqKx0P1UnpjP3dQoFXRvOLbirzHoxi7OO4eqoVH8xfMeMsYA6W5Z+x8a1QIs2Z6oQY7VxDj0X2Cfr8Yst0iE86LpopWmMJvqQn1b57w3E8Fe6ww8
 OHYhMOsP
 waWkYu93h+BqjJxj8pXOJiBRozv7OSRnSkwCoki3kt2jeHNOx8AafAnH0B3kQwjrVxt+3ceT66kgfhY6ux1H9TuRu9Lm8xt/q39LZcXFK9WAZ5czIXyD/XTH2lVykxlN4UEgnZDln78qqsMfc49Mh9xp0E9vohCMIiMtfymLhhcy/C5X70OD1kzBCaU6dVU86NI2sUvxS5o4Vvt2cQBkChpvXCgnJsZAuKoZzO2nzHdObxXo8gNr9sfJMX+TelcJJI6+IJOA6NfLF/JFR05PjhdkpddW/w56K7UJ/Hb0OCNcmEQEw60HZ5y2xKgNwdALqe3laBqGcEDtaFsoa+RrBOKUKQlqu+sKXy6gx3duSCyqm6ik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/13 11:04), Sergey Senozhatsky wrote:
> On (25/11/06 09:49), Yuwen Chen wrote:
> > +
> > +#define ZRAM_WB_REQ_CNT (32)
> > +
> 
> How was this number chosen?  Did you try lower/higher values?
> I think we might want this to be runtime tunable via sysfs, e.g.
> writeback_batch_size attr, with min value of 1.

So I think something like this should work:

---
 drivers/block/zram/zram_drv.c | 50 ++++++++++++++++++++++++++++++-----
 drivers/block/zram/zram_drv.h |  1 +
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 10b6e57603a0..cf92d4e8ca9b 100644
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
 
-/* should be a module param */
-#define ZRAM_WB_REQ_CNT (32)
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
 
 		req = kmalloc(sizeof(*req), GFP_KERNEL);
@@ -1145,7 +1180,7 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
-	wb_ctl = init_wb_ctl();
+	wb_ctl = init_wb_ctl(zram);
 	if (!wb_ctl) {
 		ret = -ENOMEM;
 		goto release_init_lock;
@@ -2786,6 +2821,7 @@ static DEVICE_ATTR_RW(backing_dev);
 static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
+static DEVICE_ATTR_RW(writeback_batch_size);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -2807,6 +2843,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_writeback.attr,
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
+	&dev_attr_writeback_batch_size.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -2868,6 +2905,7 @@ static int zram_add(void)
 
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

