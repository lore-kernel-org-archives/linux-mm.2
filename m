Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70836CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:22:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F366B00CB; Thu, 20 Nov 2025 10:22:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F806B00D1; Thu, 20 Nov 2025 10:22:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD71E6B00CB; Thu, 20 Nov 2025 10:22:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96A146B00CB
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:22:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E72A160181
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:19 +0000 (UTC)
X-FDA: 84131351598.06.7B92FBE
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 85423180012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ntcjVc2E;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7bqQNyl0EBA1tCBIt5a+Z0GgRe/Buq+cexkkYbJh4q8=;
	b=htPiIHYkJKzeSL3zisjnrlrOEVQ1A80oHFSElzKQHfWq9ZikBMjRZDANQDlOue2mLjDkYb
	qv4JSkhmx/xXjL7qrgUsPIu6TARypf6azdoDfV/9MN+GkiQd27AVUSDzPotuhNfv+3Q3XA
	XonTJxjt9OlkZDf1E4BRxx3PkUEWVWc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ntcjVc2E;
	spf=pass (imf16.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652137; a=rsa-sha256;
	cv=none;
	b=3rq27rmpjO8fChCTE/hAk1eZ9JygEaCpsdYbUB7KOY8eHWYhrx757wm0ETxGU4da1HYGWi
	t7id8UXaZG2Q9gqpW+DiM922JOUQrutZNWDG3b9Wwzq9v9xlhQNaHqWPf4XbsfL8XmULwy
	+bHiK6lPwXf2vb6CnjvWNEHF7xE9GNY=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7baf61be569so1195079b3a.3
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763652136; x=1764256936; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7bqQNyl0EBA1tCBIt5a+Z0GgRe/Buq+cexkkYbJh4q8=;
        b=ntcjVc2Ebm+uu4oBbIOpVjI8QRj6ObwtxbvwYMugbCu8v/+e+ZLOBwFJuChKZlz2Wr
         2/OpewbS4tHzoGbdgP6uJQiVCdqlg73ElwXBPXJBBk/Xl6cOf6p/6CRHgc240XMA+zsp
         7w1/f4U1KZpIQztPA6s3mXP47mcQu9THS1S1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652136; x=1764256936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7bqQNyl0EBA1tCBIt5a+Z0GgRe/Buq+cexkkYbJh4q8=;
        b=msZ4Z1w9A7W9+1wrfR1Za3Q9PLeyxzBirICVAoX76f9nzalHM+Gy7912Fep+/AKsyC
         a9lgcRPjes6VSoWg22GHgGjWcWgxmE1D+LZbx8SzV4PGU84pCImSVMZurb/wF60TJwrt
         kuf1vD7QGJk05TB1AE28B7+SmjWJGM75XhJAuwLi4tl38z3TNh13dvf1E5vXkAtxQQSv
         SOPjv5hY1Cal+3Ex85j+iLtBNhqmqQwG5oQ1xO5oRKmgy679gl5qPUx2W9IyKic+JbVb
         UT2I/4t63vbWr+2BLlMderoRDUcN7656Pzvu/poPwwJJ+LreVu+WCIg3q1Sn+NOCTYGs
         I/wQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKVBzaXHrnWuDZ27PInUh1a9DaU2CMpqjT5XXNQMlgBUtckZ+f9WUphwM32iJDiLAKRJIJOLgb6Q==@kvack.org
X-Gm-Message-State: AOJu0YybMfqjUsL2Z/OU5YgDY49IJ8YcMSOMtWVYN0pWRrbiTIDSBO+/
	6QYXyfnui0ur+sGIB0XBTl5wz+nDFuqr0E1XX5u/gB2U3QqP5uFGhd8qe3WgkuZ4OA==
X-Gm-Gg: ASbGncvjkXAWDbwrotQExemGb9ZGHjiCbGAjqPNJOsCWGC1laLalRi6xQbMbcs8+Z7D
	GJGG1oYz0DhEPjiubnN/c4AGS5YrpegydAmxJ9O7xJz4U4joX+CrYv3ffbCVJ3CN0oohWaZqcob
	nCyNBZNB0Lw0d8gzXGQLtEoNUBlu1/uPYFkiWlGb/i2k/MPrZm+1HspbVdFy0sWwNq2bKnw3s8a
	6YhQUxOKyCSHuXVJXo2nEN8scR7vpz+3iIdw5JMCKcI6HDMeO8VXYeDSAJvj9SaLpiLUtk0rLX4
	1jxqFyzmYT3uu9doHLXLqJLDuZxJB9dqVNfdUSsx5Q8BBQENjIy9DXXRzcga3fCDniJsWjFS2Zb
	HiKbbOE0QtpX3I+BzycjbqfGswGV0vgdQI1K7dLVGpTqadMz/+SPZMRYIgRo6WJ+h1TNvakfp8l
	baHK6Zuz8Iol0aZX118Ptuly1bcGVaIOygOkITPlh9RKizR70A
X-Google-Smtp-Source: AGHT+IE03gD53APBfw1EXEVlOEjEP8sWWJxhTauo8qfdCA6G5JLbr6CU65y8SGc2126/gbRkzxoUKg==
X-Received: by 2002:a05:6a00:23c3:b0:7aa:d7dd:b7dc with SMTP id d2e1a72fcca58-7c3f0b62fe1mr4912657b3a.31.1763652136376;
        Thu, 20 Nov 2025 07:22:16 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6762:7dba:8487:43a1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f023f968sm3179642b3a.38.2025.11.20.07.22.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:22:16 -0800 (PST)
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
Subject: [RFC PATCHv5 4/6] zram: drop wb_limit_lock
Date: Fri, 21 Nov 2025 00:21:24 +0900
Message-ID: <20251120152126.3126298-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251120152126.3126298-1-senozhatsky@chromium.org>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 85423180012
X-Stat-Signature: z651bxxpbq814b7rnojw31ouintr57kc
X-Rspam-User: 
X-HE-Tag: 1763652137-581493
X-HE-Meta: U2FsdGVkX1/cr7MjS7sPc4bSFcr1l61NMtOkSUF2XqWxl3x6CmO20MJn4C4/luiK/RUefwgxHZHJI1QzOuqk9ZSsASRus8KLiZgh0dwYos3SLRZy4ZOFt4q0EDlgIZZN1q9DZXiJo0mik/L0TPtBsKddD+AUabo8Egv8KYZjsdzSuUI4GqruWIKLYG/z36GGfQ2YGpdx/ZEhnFDQnPgeL4spIQQMz/dDU4njkcYSsdNXlBIIN9MWPV9VvSdqRo3FiuOilzgWB1lphHXEhuwbg2RF0av+51FQqSH+yqzqjg+o2Oeym8vTcvmJ96eFm8fOgErF5cw54HM1Sk0YjUgvHBv9Rs7T7yF1IVI4Mt1sIvjh+SIYCmDJalbPNoVUOmQN6NoyCQ8wZH6OB1+7472Hfzmxl4v3uoIRf7vxxFBiENyM84ibMzRYGbX8+iyCXzb1aKKZ2/RkTYFeuJl8XITAGAr3A4KJTSQt6j2EZsksZQPehX0fwOW+bH0twjIcNVkKJe5gFHRvwW9RfPuGNRApbxjTqVaL26IRZe9W7E8fZs2rbQIPi0HX57EubpQhQYXj/NTDiyuoIwHTA2FSAMATKWrObfLdHRJWnFsGjBrqd5/glomscfgSNrSbTAfXZgj63Gw0cZEiS3cKD7BWUmeo1B9m4dbM6c+JFT87BC9Rj+JifeV3TlxRnfq0uBqp8Hoeih7aKcPfkvUoTRhS67K5Gp/t6rW4jyOvaYW3kFt6MpDteT05FMlluOmfMpP6cJuztelrSnCOx0DOJEFUcxZAvxLsOS7+Q6kUtS8l7t+kii1j7V9x8QdZcbU8cORyGb2Wv38L+KSSx7MSpjdpqFwJeSNp9mfBX30vBh9Zc2ksSEgz9Y2SroconRoVhjqKGc2Qk4yzsCqzknr9ANW0x+uhnKS6PVgwjbTps6n8wJTE5pZSzAkoL/G6yRg3mrt8Z6d0BiueQyYQsHK8adkTPtp
 KsMLmWf9
 w6PcL7+605cUHUToPnSmus9Huu4teNoYu0Cq8BsPX5DrBJVx67TyzX2WY6n/lYOfbiUHhZqliFpP1M5Q+rpmTWbGJmVBM/7HpLMOGhqsAW39FHYKM9h1zBYQSJZqHMfcDtnIs3KuhmtGk1W1AJ1lKfjeu2RdIxUqANbc5UJBGjeaJdwfaUDcsAMGN2hFjOaqzy+5XICzuV65fTen4v2jP8hbW/486cXJ+ESJTeAV7nIb8174DLgO5OfLswjeU9FJ9x8qwIIJ4W0zHDdTmHIIz74sPOL4+2gnFNQan/L2+INrgZA0A7gDMMd7sQ81AskohUh7v9edq5ud710w7qsfoOvkvfRUNjTNuf9Ek
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need wb_limit_lock.  Writeback limit setters take an
exclusive write zram init_lock, while wb_limit modifications
happen only from a single task and under zram read init_lock.
No concurrent wb_limit modifications are possible (we permit
only one post-processing task at a time).  Add lockdep
assertions to wb_limit mutators.

While at it, fixup coding styles.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 22 +++++-----------------
 drivers/block/zram/zram_drv.h |  1 -
 2 files changed, 5 insertions(+), 18 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 71f37b960812..671ef2ec9b11 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -530,9 +530,7 @@ static ssize_t writeback_limit_enable_store(struct device *dev,
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -547,9 +545,7 @@ static ssize_t writeback_limit_enable_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->wb_limit_enable;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%d\n", val);
@@ -567,9 +563,7 @@ static ssize_t writeback_limit_store(struct device *dev,
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -577,15 +571,13 @@ static ssize_t writeback_limit_store(struct device *dev,
 }
 
 static ssize_t writeback_limit_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
+				    struct device_attribute *attr, char *buf)
 {
 	u64 val;
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->bd_wb_limit;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%llu\n", val);
@@ -869,18 +861,18 @@ static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 
 static void zram_account_writeback_rollback(struct zram *zram)
 {
-	spin_lock(&zram->wb_limit_lock);
+	lockdep_assert_held_read(&zram->init_lock);
+
 	if (zram->wb_limit_enable)
 		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
-	spin_unlock(&zram->wb_limit_lock);
 }
 
 static void zram_account_writeback_submit(struct zram *zram)
 {
-	spin_lock(&zram->wb_limit_lock);
+	lockdep_assert_held_read(&zram->init_lock);
+
 	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
 		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
-	spin_unlock(&zram->wb_limit_lock);
 }
 
 static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
@@ -1004,13 +996,10 @@ static int zram_writeback_slots(struct zram *zram,
 	u32 index = 0;
 
 	while ((pps = select_pp_slot(ctl))) {
-		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
-			spin_unlock(&zram->wb_limit_lock);
 			ret = -EIO;
 			break;
 		}
-		spin_unlock(&zram->wb_limit_lock);
 
 		while (!req) {
 			req = zram_select_idle_req(wb_ctl);
@@ -2961,7 +2950,6 @@ static int zram_add(void)
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_batch_size = 32;
-	spin_lock_init(&zram->wb_limit_lock);
 #endif
 
 	/* gendisk structure */
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 1a647f42c1a4..c6d94501376c 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -127,7 +127,6 @@ struct zram {
 	bool claim; /* Protected by disk->open_mutex */
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
-	spinlock_t wb_limit_lock;
 	bool wb_limit_enable;
 	u32 wb_batch_size;
 	u64 bd_wb_limit;
-- 
2.52.0.rc1.455.g30608eb744-goog


