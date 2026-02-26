Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 563EFFD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 02:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2556B0088; Wed, 25 Feb 2026 21:55:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A02F6B0089; Wed, 25 Feb 2026 21:55:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 875346B008A; Wed, 25 Feb 2026 21:55:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 70B2E6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:55:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 122468BF22
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:55:18 +0000 (UTC)
X-FDA: 84485091516.11.2240397
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3DCBB40007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:55:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=TmhdchdF;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772074516; a=rsa-sha256;
	cv=none;
	b=m/z/00uakIOnK6vF4Gj2zeB683/+xFF24ACEaxHyaGTugT8SxUzVVafs6R6TGozSH8Hz7U
	dSiqtkl3vxve5QkD3uvLxnkH2DWVk0hzFW8O0cGFBD3strvZJsvToQ0zeLcH4+URGFoDk2
	GOrG7eXPDVp2Ck1/ozhyJ+DWxFx8GaQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=TmhdchdF;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772074516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EaJpafr6czHHudzxJg6tiucI2ej6OmZ2sEcinKt0YCQ=;
	b=aVoStGrk4mcl4sky2wsx03D586nG4c4pxgpw43IMHzxiUYFBGKGydF6g/9za3Nz6c94C7n
	fXxV0PlaLJgEbLwd9+tsBtu7N+79wAp6FyLWiDpFc/yUOyCbQ1fqAZLddzir9k+PXVqCMO
	QRuq/avXYIePk3heP/3K5IKyUrrwj7A=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2adec255754so1852005ad.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1772074515; x=1772679315; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EaJpafr6czHHudzxJg6tiucI2ej6OmZ2sEcinKt0YCQ=;
        b=TmhdchdFJM8twhKGh4/uRX3wd0ugZ0Fz8OPJFYB4o3z2nsrzi8POA3M+cBjd5a4C+7
         pluKfLrt+oiCOcT8+ye3hCatz0pVywyPBI2fFLf2h7le0/X6BCp//WS3O5uHa10MeRCK
         JQBrB2+vPzqdA4IawnMqndapeLQzpX3n94ISs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772074515; x=1772679315;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EaJpafr6czHHudzxJg6tiucI2ej6OmZ2sEcinKt0YCQ=;
        b=RsAtq4tqDUeAGQ2/TrQig4f6KQkuoZlH053fgTwRBekcouWXBmjWAUHHfTBev/kkEj
         TIaKwBopJgx68SUaj13+gm0WXs7/g1W9FIsj5rzOwxozbmPwbGuV0tmCfZ0PAHBVS8ag
         hXRzYk7r2SdaM+ylbCf6IWwzJZWrc3q1wt+OVT3E/cJrLhD0KXmylXV/wwc8uuognXmY
         cYBmy3O5IFnLNkUcJ5HrlisDGTlo3Zr1ucWj3Wu9aODZtiD68HgVUdpbL7ByA6kn9eu0
         zNJg7Owc33lI/pjpBB47Yu0I/i6qqPcPJhJMt1XBNUr6RBSw9mERA7/ucjuIxtXNsTjl
         5WWA==
X-Forwarded-Encrypted: i=1; AJvYcCU0uj21EePumiiE6wzNrgA001U7E7LaocnOCt9u4JMtayM3/UaT6iYaQ+kAWreeItDe5i8e8nMP+A==@kvack.org
X-Gm-Message-State: AOJu0Yzt/aOewRYtQth/bfSk+x5/zStIe1mtQJ9whWZ8UYXC5P+CPY4s
	pif5dh96kmYYvlmLaeFQlojMLs3rVg+Y8UDO2DSn4U8in6OefPYWNSU0x5SU7fMBlA==
X-Gm-Gg: ATEYQzyaOs5UW1PgTeDUSQhs8QvLAnaocgY/LazzmCatU+Ixj7noOfAAd2jUIQHXfKS
	pTe+bwHsFkscCJdwWM0GzjIM5mz4ZyNH5sTG63fB2xf4IlcwjTwV7KRHoA6dZ0mrMOsy87hDTy5
	8xd5zNMJTJh0CBODF31Bg2XtHO3c39ml84FnoedQu6nn8my+0JpOLuarQBePrULdccZ4DhRkZLy
	+g7gsdRfv5BxFunNgA7bALDJXOLZ/9qpYaulZBYCu4c6zanSBnwFDbt1cIOkHnXvKc9e+9zkl/6
	Vmh56eUBbdCq0fjjukQFk7kNwa67ahkIT3emfQ3Cuo+G4ALxgEfNrJDi9p+EgNb1GbAoyxMf4G3
	pNVzAh3Em2vWghebmUlo16wP1vzNPteRCZ3/TMTrw8ottsQd0r9U3g9S+vaUtFhTPojFUXb4hXw
	MvlhPKnk+vbygMeFxHPw21hVOUd8hn0CZZhGOksYCpeBYvOQodIwwXYgO4jn0Vc0Btr5C54Tg0s
	YL008yZvpbqEA==
X-Received: by 2002:a17:903:3b83:b0:2a0:ba6d:d101 with SMTP id d9443c01a7336-2ad74463a70mr174086735ad.21.1772074515021;
        Wed, 25 Feb 2026 18:55:15 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:f7cc:c9c1:b4d7:b50d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb69f277sm8716145ad.55.2026.02.25.18.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 18:55:14 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	Richard Chang <richardycc@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [PATCH] zram: rename writeback_compressed device attr
Date: Thu, 26 Feb 2026 11:54:21 +0900
Message-ID: <20260226025429.1042083-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6syizp6yy9jboo9brrdqxgzua3t6xkw6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3DCBB40007
X-HE-Tag: 1772074516-728662
X-HE-Meta: U2FsdGVkX19vXfkT+BQ5A0AEUZ4bNWZT0DIh3wLojTWaC/8hDL6GBHXvqNUY7axw88czqBbNwJt0SLGhCyCjQEJFktzx0T5Q4IBlVeoChiL1WPNgWIr1EigwMToUB7t9nVK+bvnKeh2Z8e89az4xw+UHCs4Mru1JUyqWHftBGsCUn4JF125u85Lkc1eQkqZ682qDUmp2U6Vsjx4GeGqDuC6tSzIfY4r8lBdEI3od0fnty5OBwlWRZk+5loWrQAsHsVWjj1hSgCdSpf1Acx42hvoQCxNYRcNwZ92MlZqKcsa1lFXgGfD+odmM8U3hhksZ5Je+X1Qp0HGtIA/jMYLNqVoIznGW6eqqpYfxfZRZtUaI4TE1gg6NNexGbaQfQ9YBzIURtcSVJWa59RsZO6++SYEUimrFlcZ472cGnJXdUwuXwV+G1Gh/I97Tw+1QUrSavmTIZJwKvvWCoD1fJ+m/lbc32VOg/ODwAsT3AV+okAYy7I6/VkEVtL81DVV9mdfnCKTJInbQHbfwxJ5RlAGpjBG8ubn1qhHDaVPkFB5qEQ6YXmtuc/BEZ0Psyzt3yNwq6VT89I6aPbGij4VKXwOZ8gMuf0chn3iDCgevwo+Dqq7aV1RczFd3Ot9XeXkwk1/e0hyusxsqSa2aqI6H1m9HWE/nu7yu/fdPPGR8I7qLPwu5MYPlNR7D7Bt9mZYYWAWL/s9JJdFt0MF792PqLEIuFvv/6lvZNyxs1jpDOurSi2XFDYQ3kaP+xIs7/8cXbQIHc3XHsBm+N4nTFkIrLgBTIwr63+MgsJ04alqi/v8MRD8UVtR1oYEYO9QAiI3M/fVCb0rssZUPy0/jQ7Ysgd8mCyvm8KvH4JOe4UyyQ6MbS13qyk38nFMVjqAj8TOCSqGvL4ILBOTPyiCJJhxP/XZPoaUD4r1WTJS2+712G+VKNg9se51HNwHO8VgobdQ3GdrvT5rqruZYeJdVOXejdt1
 7rXH8wcA
 2+zeEUBUOtCuYSBEJgNE99aMcqJaczc9EUfMMoUg4AbScQB+wL0yrSXnq1w+wVWtYe6u3JUNsCisnZ41MyAxk7OOvLfRf9lnFPKPT4jN9iYeEjQ7mjKvhg4928tnJTOz9XmT/4KCtQmpHJNnLShM7Payp3DHUUGxtyz1Df9+n42BlCIZF345aSj1uRmJZTq7oDpIJJF9dwpQwSf8pOCv+Nqoo/NzmVoCusS49d8wjWq3YXtDxM9Yv3WwBeme0Z8oVC8MEhM+DNZD032fQbCacVlroAtpbw/D1SAAiDIDVQn3166Km24ZP+1BbD8mHFdMAshql6mKtvmeAER33HClJhgzwNpRWS4nFvZeDMArZhgSdLlUNkt5CGmoD7qoTmlGhxHIUGcgAh8MR8rWhpPnk8KaUsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rename writeback_compressed attr to compressed_writeback
to avoid possible confusion and have more natural naming.
writeabck_compressed may look like an alternative version
of writeback while in fact writeback_compressed only sets
a writeback property.  Make this distinction more clear
with a new compressed_writeback name.

Suggested-by: Minchan Kim <minchan@kernel.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---


Andrew, the code in question is in 7.0-rc1, it has not been
released yet, so we think it's safe to rename the attribute
without breaking userspace.  Can you please pick this patch
for 7.0-rc2?


 Documentation/ABI/testing/sysfs-block-zram  |  4 ++--
 Documentation/admin-guide/blockdev/zram.rst |  6 +++---
 drivers/block/zram/zram_drv.c               | 24 ++++++++++-----------
 drivers/block/zram/zram_drv.h               |  2 +-
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block-zram b/Documentation/ABI/testing/sysfs-block-zram
index e538d4850d61..64c03010e951 100644
--- a/Documentation/ABI/testing/sysfs-block-zram
+++ b/Documentation/ABI/testing/sysfs-block-zram
@@ -151,11 +151,11 @@ Description:
 		The algorithm_params file is write-only and is used to setup
 		compression algorithm parameters.
 
-What:		/sys/block/zram<id>/writeback_compressed
+What:		/sys/block/zram<id>/compressed_writeback
 Date:		Decemeber 2025
 Contact:	Richard Chang <richardycc@google.com>
 Description:
-		The writeback_compressed device atrribute toggles compressed
+		The compressed_writeback device atrribute toggles compressed
 		writeback feature.
 
 What:		/sys/block/zram<id>/writeback_batch_size
diff --git a/Documentation/admin-guide/blockdev/zram.rst b/Documentation/admin-guide/blockdev/zram.rst
index 005266b0ef15..e83c2860f2f0 100644
--- a/Documentation/admin-guide/blockdev/zram.rst
+++ b/Documentation/admin-guide/blockdev/zram.rst
@@ -216,7 +216,7 @@ writeback_limit   	WO	specifies the maximum amount of write IO zram
 writeback_limit_enable  RW	show and set writeback_limit feature
 writeback_batch_size	RW	show and set maximum number of in-flight
 				writeback operations
-writeback_compressed	RW	show and set compressed writeback feature
+compressed_writeback	RW	show and set compressed writeback feature
 comp_algorithm    	RW	show and change the compression algorithm
 algorithm_params	WO	setup compression algorithm parameters
 compact           	WO	trigger memory compaction
@@ -439,11 +439,11 @@ budget in next setting is user's job.
 By default zram stores written back pages in decompressed (raw) form, which
 means that writeback operation involves decompression of the page before
 writing it to the backing device.  This behavior can be changed by enabling
-`writeback_compressed` feature, which causes zram to write compressed pages
+`compressed_writeback` feature, which causes zram to write compressed pages
 to the backing device, thus avoiding decompression overhead.  To enable
 this feature, execute::
 
-	$ echo yes > /sys/block/zramX/writeback_compressed
+	$ echo yes > /sys/block/zramX/compressed_writeback
 
 Note that this feature should be configured before the `zramX` device is
 initialized.
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 346a99561a95..6b76dbe7fb80 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -549,7 +549,7 @@ static ssize_t bd_stat_show(struct device *dev, struct device_attribute *attr,
 	return ret;
 }
 
-static ssize_t writeback_compressed_store(struct device *dev,
+static ssize_t compressed_writeback_store(struct device *dev,
 					  struct device_attribute *attr,
 					  const char *buf, size_t len)
 {
@@ -564,12 +564,12 @@ static ssize_t writeback_compressed_store(struct device *dev,
 		return -EBUSY;
 	}
 
-	zram->wb_compressed = val;
+	zram->compressed_wb = val;
 
 	return len;
 }
 
-static ssize_t writeback_compressed_show(struct device *dev,
+static ssize_t compressed_writeback_show(struct device *dev,
 					 struct device_attribute *attr,
 					 char *buf)
 {
@@ -577,7 +577,7 @@ static ssize_t writeback_compressed_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	guard(rwsem_read)(&zram->dev_lock);
-	val = zram->wb_compressed;
+	val = zram->compressed_wb;
 
 	return sysfs_emit(buf, "%d\n", val);
 }
@@ -946,7 +946,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 		goto out;
 	}
 
-	if (zram->wb_compressed) {
+	if (zram->compressed_wb) {
 		/*
 		 * ZRAM_WB slots get freed, we need to preserve data required
 		 * for read decompression.
@@ -960,7 +960,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	set_slot_flag(zram, index, ZRAM_WB);
 	set_slot_handle(zram, index, req->blk_idx);
 
-	if (zram->wb_compressed) {
+	if (zram->compressed_wb) {
 		if (huge)
 			set_slot_flag(zram, index, ZRAM_HUGE);
 		set_slot_size(zram, index, size);
@@ -1100,7 +1100,7 @@ static int zram_writeback_slots(struct zram *zram,
 		 */
 		if (!test_slot_flag(zram, index, ZRAM_PP_SLOT))
 			goto next;
-		if (zram->wb_compressed)
+		if (zram->compressed_wb)
 			err = read_from_zspool_raw(zram, req->page, index);
 		else
 			err = read_from_zspool(zram, req->page, index);
@@ -1429,7 +1429,7 @@ static void zram_async_read_endio(struct bio *bio)
 	 *
 	 * Keep the existing behavior for now.
 	 */
-	if (zram->wb_compressed == false) {
+	if (zram->compressed_wb == false) {
 		/* No decompression needed, complete the parent IO */
 		bio_endio(req->parent);
 		bio_put(bio);
@@ -1508,7 +1508,7 @@ static int read_from_bdev_sync(struct zram *zram, struct page *page, u32 index,
 	flush_work(&req.work);
 	destroy_work_on_stack(&req.work);
 
-	if (req.error || zram->wb_compressed == false)
+	if (req.error || zram->compressed_wb == false)
 		return req.error;
 
 	return decompress_bdev_page(zram, page, index);
@@ -2982,7 +2982,7 @@ static DEVICE_ATTR_WO(writeback);
 static DEVICE_ATTR_RW(writeback_limit);
 static DEVICE_ATTR_RW(writeback_limit_enable);
 static DEVICE_ATTR_RW(writeback_batch_size);
-static DEVICE_ATTR_RW(writeback_compressed);
+static DEVICE_ATTR_RW(compressed_writeback);
 #endif
 #ifdef CONFIG_ZRAM_MULTI_COMP
 static DEVICE_ATTR_RW(recomp_algorithm);
@@ -3006,7 +3006,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_writeback_limit.attr,
 	&dev_attr_writeback_limit_enable.attr,
 	&dev_attr_writeback_batch_size.attr,
-	&dev_attr_writeback_compressed.attr,
+	&dev_attr_compressed_writeback.attr,
 #endif
 	&dev_attr_io_stat.attr,
 	&dev_attr_mm_stat.attr,
@@ -3066,7 +3066,7 @@ static int zram_add(void)
 	init_rwsem(&zram->dev_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_batch_size = 32;
-	zram->wb_compressed = false;
+	zram->compressed_wb = false;
 #endif
 
 	/* gendisk structure */
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 453e27ea4525..08d1774c15db 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -132,7 +132,7 @@ struct zram {
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
 	bool wb_limit_enable;
-	bool wb_compressed;
+	bool compressed_wb;
 	u32 wb_batch_size;
 	u64 bd_wb_limit;
 	struct block_device *bdev;
-- 
2.53.0.473.g4a7958ca14-goog


