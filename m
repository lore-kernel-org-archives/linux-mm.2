Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA2BCD4F5F
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9338E001B; Thu, 13 Nov 2025 03:54:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8A2C8E000B; Thu, 13 Nov 2025 03:54:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9789A8E001B; Thu, 13 Nov 2025 03:54:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 854938E000B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:54:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DABF12E56C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:54:36 +0000 (UTC)
X-FDA: 84104972952.29.7A074D5
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D33720008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:54:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UdAyU8so;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763024074; a=rsa-sha256;
	cv=none;
	b=a3l/fsuCkb3UsBABAnrXnML1WQx2wTJpmyw4/NR7IEDnJPQO3pAp5ehtxID0EV3wuZIQjg
	DzXwNFnoEQjviiMg4+6ZPlot8c3fiVAErb5Nbob2IW+ZiZGiOqqejBnGlZ8VLTCyylvmGx
	NXCXGnU/v95T1Xg9GLD606Ta6O1pukk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=UdAyU8so;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763024074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7+JRL9kiPv0pDFSMaNJ0bpAVD07o+mb0mBj6g1Zy7bM=;
	b=MBHxpexzz6TLuRBJ4XZCMG0Z1furxbjnLXh3jxe81b2pLDIA1jZQn0LSjRgjGcNQ1lOTL0
	5nXfi3pjLr3xO3mTVoLg3CnfSgZ6YEVnIfvkHVxvODlyaLkU3nxQosOIHeY79HtBz0hWeE
	ijJ+yP5QTw85eQcCwMbxELpRpdoP+i8=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29586626fbeso5547015ad.0
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 00:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763024073; x=1763628873; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7+JRL9kiPv0pDFSMaNJ0bpAVD07o+mb0mBj6g1Zy7bM=;
        b=UdAyU8so77JmOMhIlBZp3hFVXFVp+fz2cl5Ntij1qYIZvaJXo14q9uyF6uNuyDEBgd
         V53BiAYWFwzJdXqGeyuaRl1b/xvDmR3d0YNi/XtiN6gCIM6Dfu6jfm368NMYs3nwMmVj
         Ad/8qrbL9EBfPxJQIFtZp4pG+QGVwL4EXkFz4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763024073; x=1763628873;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7+JRL9kiPv0pDFSMaNJ0bpAVD07o+mb0mBj6g1Zy7bM=;
        b=k+k96DZly7Gwgg3d5GWu+ZjGTN/xo2zIO3mKx8hWSiSzFJ7LzO32cirTxptf/ooAMT
         BsEX08KaGSGe+EzJBW/ZyQ3Kxp+Rkmm2vA1+OU+qn5K851WdeXDysPbdsU6yEqFCYwOt
         Se/5mvF3/cwSLZNAvdrcZtp6bh0RceLAZrXB2gaXOqqZngyaHm2oyYZOgonvjozIAZ2O
         Or2ss2bOGQ35KKXgBQsZwQpwFDG+sbEqJizYSJop9Zp3IUDrjOHioWZ65oGemk+sP/mA
         A85MNJr8gx/R3leDsnbiQ1R6h6q/QDe75koDHxFQriX1B89qPXmMrEktAK6TyVcdZ9LZ
         2fcA==
X-Forwarded-Encrypted: i=1; AJvYcCWT6pxNJuGlcMBHpZ2FcLBMP/v2TFWAWb3kI0+PoMCprvVYRy5DuGoy2gFWOw8HpZm+dCssgQzWXw==@kvack.org
X-Gm-Message-State: AOJu0YzH9bcuBP4dYTOr88YYxxyVYk/PAvoso3gR+qmp+gm0NwHa5XNS
	mo9K+FQolf1WXzDsx5p+Kl0WjeUxZgc5LHeQUHyfsP+UCBAqffJgOrVv6HJ7GsqU+g==
X-Gm-Gg: ASbGncu8GDD/7zbJO/jtN1eCospkl+gpTKLL641VfeCfQvPHtrSXEt44dA5pBq9M9VA
	V7/dslacyuV8fvNi71r4jEdt3pBd/WL/CphGeBaNMH3LVD+uRbnu0Cl6ZSU3aq0nz9ATkAmcoJF
	aWCXy/TRX52mA7qCxtoeG50JC5/r8Egs7Ukcal95nqa3FTdH4FhxWPHyj/qGIJCBmtP7qKOMzZV
	dnQsTiTDaZSlUYBZBUiDkMbWtg3mQQBbHy2pduSaNAl/o3+/jWW8yYPPKTEgCPq2HpLTcOtHOBA
	6AFjwFTuBE6eV0MMDg0qcu5bVDzqcuPQcuVFK2cHE+3n/GGAGRws26H2TsvXRJJtHWpIHnD98mV
	lCG1DCO24kq4lnW3gRovafRyk93doz3qE0nx6XZFAQxEdhAOKUwl+wqTAoG8OPLkLwqaZxvy7tc
	PyHI0EJ62yFyLL7RQjM1a3ZwvbC0Y=
X-Google-Smtp-Source: AGHT+IGGZxYQr+LLoy8bEdHUKGbCLuJQ0gfi58q4jvR2bx074SYFubzhdfhY5JKnP3Pyt5bf5k/gtg==
X-Received: by 2002:a17:902:dac3:b0:27e:ec72:f67 with SMTP id d9443c01a7336-2984ed27ec5mr76936745ad.6.1763024073273;
        Thu, 13 Nov 2025 00:54:33 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2346f3sm17486465ad.18.2025.11.13.00.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 00:54:32 -0800 (PST)
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
Subject: [PATCHv2 4/4] zram: drop wb_limit_lock
Date: Thu, 13 Nov 2025 17:54:02 +0900
Message-ID: <20251113085402.1811522-5-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251113085402.1811522-1-senozhatsky@chromium.org>
References: <20251113085402.1811522-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6D33720008
X-Rspamd-Server: rspam07
X-Stat-Signature: d3tdyms1hqdrz8mpsyg9kpya31enya74
X-Rspam-User: 
X-HE-Tag: 1763024074-272494
X-HE-Meta: U2FsdGVkX19B+D0rCPJkC/HPwYE2xX7F7kxi3Wr/hSNOywQ1H7Zzhm2/mwHHUvQkfOFDYByqmDjnL3W8ZcAmI6ofCm+BS8yUWsSgiu7Ek63ZLKOuw7SmhfxAwzCwtFFS2lK0cGUuoJmEalaG1wiAgDKUVvvVNAWhoTP7zMlF71756T881YiHEQJ2dj7pTXSWvA6+YhyY8Bvi178Fh5S93+li6eYfBK0ecHGWc136V212EMmHi0HXlLJr+EjMa1G7VJRJuUEqsAUrMSw7JwXyfyyYTNBa2FxNAaN1yn/Ku4g2CH9qGgohLUeh6JwVaJcPaKRAn0EIDET6SbxJIytNV42I0awdTgSC3cZTKa7ICCOZgVBjV+fdQdyXSts1/8Eoze0hSLF9srzlTKqP2PGfvfNPQnzc2uP5vTRAOkZ7rxHEGYlTIhFBCOWX3v7rtyZoW/VE3ARK/608HZs4dPkulPhzdyCs11Cv2Kt59NIBZ22PPvaxafiEY1S1ICOcgG/QsC3kDbYgFu4bsOiANOVv4K+58bmtoWfWdkPYtp84M5Aun2axON9IoSTstdlfmi2gLb8BxylIYJR9q+SpMZgs+J3H3y7gLLpxkqoh1P3jI9ONqWzuW7nUUSPWZCcF0KF+9f/aJBAdwSkIXI5yAkQzHwzuerQBGWs4cz73hUFHaR0JL/zcpWC+pyQJLRLiLuwO/ZptZmP2TPT+5drilfBoofbLpzEM3GF2eXE9t3S2pEYeNV2ymOVoU4gGIPm7cfONyJN20D6cdi0g6JQhip7ensIqVxXt3jFJLVS6xW8rrjpGBNEcR0RyqIAheqfGsBkxTjizv+Ah04MA1VCiX1BWBW6q0giXi6GXi8Zywk9SIyHvM5nbpHEjsdSbnbFC21jCMc/ThK9Gxj5I9WDObfOCRanCpeWgk/Va+DJFGcKQx3i74P94Wqd5oR6aqQPWwGKWDWflwgnHQ/6m7RkA2Bc
 Nbe4AVfN
 5C7h2T/K422uNDXk2gzL/xgM0IxzD6uFj5lEmQZ3l827hzQbCil6Eok6sOa+GvmDNXIkurIMNBFXO42+va6/Ou/G3IeZ9JoTIvZkZjBbt6p7hw8MzLP3H21kC6QfMYPikTmuLigF/azGv90H/+3H4b7aCls31LBFVNLj2oyeUxcF0GsSB8UiQ6lAZa6ztPzx9f1cbH/8wsY4TqFi5FMh7YZih+4fTVUpNSbtDVRuuc/7DwaLzFdueTQfwngG5KN8jSn9LWXn5jLY0XTNxYlrcMTcqWCU5nwz5jQcjMZSAYBhv/GqMlgkwypBMYP3Q9PirRETOw/J0JlcG+2ELZuLqRS9+XN/w+9m2eA/Z
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
index 6312b0437618..28afb010307d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -512,9 +512,7 @@ static ssize_t writeback_limit_enable_store(struct device *dev,
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->wb_limit_enable = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -529,9 +527,7 @@ static ssize_t writeback_limit_enable_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	down_read(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	val = zram->wb_limit_enable;
-	spin_unlock(&zram->wb_limit_lock);
 	up_read(&zram->init_lock);
 
 	return sysfs_emit(buf, "%d\n", val);
@@ -549,9 +545,7 @@ static ssize_t writeback_limit_store(struct device *dev,
 		return ret;
 
 	down_write(&zram->init_lock);
-	spin_lock(&zram->wb_limit_lock);
 	zram->bd_wb_limit = val;
-	spin_unlock(&zram->wb_limit_lock);
 	up_write(&zram->init_lock);
 	ret = len;
 
@@ -559,15 +553,13 @@ static ssize_t writeback_limit_store(struct device *dev,
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
@@ -866,18 +858,18 @@ static struct zram_wb_ctl *init_wb_ctl(struct zram *zram)
 
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
@@ -991,13 +983,10 @@ static int zram_writeback_slots(struct zram *zram,
 
 	blk_start_plug(&wb_ctl->plug);
 	while ((pps = select_pp_slot(ctl))) {
-		spin_lock(&zram->wb_limit_lock);
 		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
-			spin_unlock(&zram->wb_limit_lock);
 			ret = -EIO;
 			break;
 		}
-		spin_unlock(&zram->wb_limit_lock);
 
 		while (!req) {
 			req = select_idle_req(wb_ctl);
@@ -2944,7 +2933,6 @@ static int zram_add(void)
 	init_rwsem(&zram->init_lock);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_batch_size = 1;
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
2.51.2.1041.gc1ab5b90ca-goog


