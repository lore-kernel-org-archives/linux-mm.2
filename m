Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F36B9CF64B1
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 07:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55AB86B0011; Sat, 22 Nov 2025 02:41:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50AC26B0012; Sat, 22 Nov 2025 02:41:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3166B0022; Sat, 22 Nov 2025 02:41:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2702E6B0011
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:41:06 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5C9BBB945
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:41:03 +0000 (UTC)
X-FDA: 84137446806.27.009A9DB
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 12F1340010
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:41:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=eOGHq3uq;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763797262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqXmvB06Z2fB+k4+MBqw/8L077gQXIHuVUXIRxAoKgE=;
	b=CQQ5hQ0zRdCB/akPoS/AMXNhET15oU7HBmW+ggKcxOYTf+tXxAnEI5bhbZR6sW28imWvMF
	IqP7NJCdiH9xa3M+mHIBVZYv8iWmfwHxJqt1nS8/eR+z0+zgg7BW5Ru9ECuD4PYxzsq4Rx
	L5KY0EaB+8rp4YQu/91FV0ycYEwxa4E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=eOGHq3uq;
	spf=pass (imf12.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763797262; a=rsa-sha256;
	cv=none;
	b=0zqua1Jdyhq8GabcJ5n7gkBtZvJ8d5NEB4qiSLT+tesOx/eyLeoBuOS6kDXxj5PsMeGSz2
	tQBnXxJqYNcN5rPDXgT47+1ZKLGFI17nlVKXkKH929LsRD8VE9kjW2oSmoo+xiaDn2Ygr6
	HX79k0L4Gie8mE1tMVEWlk1TyMuS2DU=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29845b06dd2so34504725ad.2
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763797261; x=1764402061; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eqXmvB06Z2fB+k4+MBqw/8L077gQXIHuVUXIRxAoKgE=;
        b=eOGHq3uqy6zId8n72t+WTcVSs89yHQYAN3ydJNaG0SLB7eNaepsJiImEkS9yTRPHrq
         pI09EXfXSY7J13sDba3qqSRe4/78WJl1F0Kt/h4Gl7YC5xWjOEF00Yz0C+n3xZB4Ofn2
         hXyZh3wfhVWXXu7mX/RMz9+4lP4eOnOj5+fZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763797261; x=1764402061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eqXmvB06Z2fB+k4+MBqw/8L077gQXIHuVUXIRxAoKgE=;
        b=wMD3T93vfTHICU96MTVICTGBgk3l35dDmuZpJyiCXOsNFbTMSrg9kWN2yWJsc/5qTn
         O3l37zjTqM8Was9+uPhgzeKfTqqL+/QDuhSByP5hsqTwMRTFc65VsA7ThDw/yf4BTAue
         BMgJHy1TlDwA6LI/coO/rD9u3LkuzQZL4FtCtpTZrZPoDCS2MJLIn7ZEK/XEHSAPDBFa
         iUi8Ux3RHXKUpp1R1Le0ZskVdSoZ9msDoTGXmK0lX3Rd5JlmNVbct0GcMQU6CuXfdPNx
         ebv4A1mPfWciy1/FHdJ052/TntAKMuTzkSzp17cCnTNQV+JFHVlJbd637r4ZwKHQ0OGc
         162g==
X-Forwarded-Encrypted: i=1; AJvYcCWf8kaRXeti7a1e9/nZkluUqfhKJEwrsqyNAvzGy4HKUmUwxxFtmSsMCk1bsLlNHBC7QZpWuSBlMg==@kvack.org
X-Gm-Message-State: AOJu0YyfxxJczuWjNIYhiNC4Hx1/GqJN49Xs4ev826C65dHXfYTZj1ib
	+gMe4fAvVpgU5Cvn6hDfyUXvi4VxIaNJz+uM/v/vGdj9/SY8fhAWVT0WXLzN7ryMHw==
X-Gm-Gg: ASbGncsli+EbFezbUeASK49WkkVWvPfKeq+nlFcbkUw/p15LZFpuW438nBQwV1uWupg
	XnjtyNS8RxaoCLwZJHyM2vdvJx6HXaGzPymjw7tmC4XhAS+gNl6AOUgI3EWGkFa7fYWmrYDRhFd
	UGRjSN8lUY7MVMNzQo8wkE+DrTWERcg/mjdS1rSFlxJAHWCss202eqxnzFUEwLdy96lsgCKrFrH
	mtfm0+7is/k+PhDE1mE30n1QEc37r6VSH9lnQqlpJDrCcArX1H+hKkJokuZyBximH9fb4dOGLLB
	YIQ/IOMbRJps+qvjOwqAE7NrjuK1kYDpyFZxLC5+5P3tN+fbLo1XnGyAFJVmQxFhcUKpJnrAffy
	DbIMuluBQ/MWfdTEGfjMR8v02Gneq4x4ZwkWs/v6ydiIRw8OHp2LrTcteOBPy+10NKIzVCiJBbs
	D6dmh4+Erg6UcenUvW1ibrRZtu8uVYfcORtlcr4a2GrIjT4Tx+dCV9v+tkC4915tu/PXHZTK65d
	dNmMtT8EM2o
X-Google-Smtp-Source: AGHT+IFDKI29A6Uqi041LAbC6kcpz5R1IMRKmCudzuYMIMwbcjwLb7vtZ5IKwHJVMEc42d2kp0CPqw==
X-Received: by 2002:a17:90b:3cc3:b0:32e:d600:4fdb with SMTP id 98e67ed59e1d1-34733ef71f2mr5625087a91.18.1763797260926;
        Fri, 21 Nov 2025 23:41:00 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:948e:149d:963b:f660])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b138628sm77771555ad.31.2025.11.21.23.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 23:41:00 -0800 (PST)
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
Subject: [PATCHv6 5/6] zram: rework bdev block allocation
Date: Sat, 22 Nov 2025 16:40:28 +0900
Message-ID: <20251122074029.3948921-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251122074029.3948921-1-senozhatsky@chromium.org>
References: <20251122074029.3948921-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 12F1340010
X-Stat-Signature: dfhi81yj1wbe9hhbfnn3obqybeehosqz
X-Rspam-User: 
X-HE-Tag: 1763797261-870827
X-HE-Meta: U2FsdGVkX19tZCm3G3/vdsHFCOs/0FYTXTnZhtay0yLdrFvRLnLjgbuK0NNnq3Q9pskb2t4L0C31Nr3v7Q06Y19w1N+KZ4EqYNCsMF1I1KhFsF5Ya+SRGW9IJJNs3fLWrZ2DbNbAm1Jk83WKCleoRMSHOg1loVkmu+ELAdF27spYPwcT02CLM6FAIn3nYDIuxQ0S0kZSYjR58RauGm1YJ9kxRE+jsSBIn9IVqCJBWH7OAXNre1TbWPQtTdYTschp9h8emM0UXXluin4v+7IMFkHnmGAWE3sa7MGL7FhKIm9DiZxu35Vjt258XCrGlXs/211VhimwRWc+efIwAKct3ohTc8sVY0QqoA4BgDozROygjj3g2F2YtyCmLVEtZ8YQ6VOypc47ejx9dIXkbZge8md//YnDHIl9cnwK0swcJlq0W1sF1GPT9cr5nvfCjtog8pU3AHGp8DkzHpLhHDc2wQjO51jsVc3NowLJ5yrUvfJGrMMmuAFgdo6PaSJzfQQx7kq7CDrG8yA3vaeia3F7OLG0/wTkZRuLzQF1q4oMEr/p/QK5lgRyJm/YLRi/DJiXJHZWi4L92paWPxK/le20iDAIb3q6N1ycELj7qadLpo5SZP1maI7Fc/VCDrUZrYJmgGjUI0bdlnt+eZD4iB3v++KgeaClyxW4ttZvfm6kZUJjJdDecJi5QDilCrEhK8Z2bH4LGo5lpFwYPhHNZc7MIbo4oOC+q9QTmRxnG0KgwjJF5/ik50TrYt5IwjoDRXBtOtpmkpsjEzhm2iqF/p+mp8LRNc2FQ88xVm0zusRIUmJdPei4k1kqlzF5GDuXjOVsTK/6o/4k2tpTtHwN50y73TvmbWCXZ7MW7m6qw2UiETRY6I3faBMWvIzqb1egIQM2dMOdhOmUygqrSTrCaWQaS8L1D2PfGJJ4qkKuv6Fgy28kvLHsgi+bKIoQ/vIjR8j7Y65uClyyBmeAR4dglDc
 ILysGaMY
 +9G+YGXkjG53hqSbu6AHmL3ygFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First, writeback bdev ->bitmap bits are set only from one
context, as we can have only one single task performing
writeback, so we cannot race with anything else.  Remove
retry path.

Second, we always check ZRAM_WB flag to distinguish writtenback
slots, so we should not confuse 0 bdev block index and 0 handle.
We can use first bdev block (0 bit) for writeback as well.

While at it, give functions slightly more accurate names, as
we don't alloc/free anything there, we reserve a block for
async writeback or release the block.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Brian Geffon <bgeffon@google.com>
---
 drivers/block/zram/zram_drv.c | 37 +++++++++++++++++------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 806497225603..1f7e9e914d34 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -500,6 +500,8 @@ static ssize_t idle_store(struct device *dev,
 }
 
 #ifdef CONFIG_ZRAM_WRITEBACK
+#define INVALID_BDEV_BLOCK		(~0UL)
+
 struct zram_wb_ctl {
 	/* idle list is accessed only by the writeback task, no concurency */
 	struct list_head idle_reqs;
@@ -746,23 +748,20 @@ static ssize_t backing_dev_store(struct device *dev,
 	return err;
 }
 
-static unsigned long alloc_block_bdev(struct zram *zram)
+static unsigned long zram_reserve_bdev_block(struct zram *zram)
 {
-	unsigned long blk_idx = 1;
-retry:
-	/* skip 0 bit to confuse zram.handle = 0 */
-	blk_idx = find_next_zero_bit(zram->bitmap, zram->nr_pages, blk_idx);
-	if (blk_idx == zram->nr_pages)
-		return 0;
+	unsigned long blk_idx;
 
-	if (test_and_set_bit(blk_idx, zram->bitmap))
-		goto retry;
+	blk_idx = find_next_zero_bit(zram->bitmap, zram->nr_pages, 0);
+	if (blk_idx == zram->nr_pages)
+		return INVALID_BDEV_BLOCK;
 
+	set_bit(blk_idx, zram->bitmap);
 	atomic64_inc(&zram->stats.bd_count);
 	return blk_idx;
 }
 
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+static void zram_release_bdev_block(struct zram *zram, unsigned long blk_idx)
 {
 	int was_set;
 
@@ -887,7 +886,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 		 * (if enabled).
 		 */
 		zram_account_writeback_rollback(zram);
-		free_block_bdev(zram, req->blk_idx);
+		zram_release_bdev_block(zram, req->blk_idx);
 		return err;
 	}
 
@@ -901,7 +900,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	 * finishes.
 	 */
 	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
-		free_block_bdev(zram, req->blk_idx);
+		zram_release_bdev_block(zram, req->blk_idx);
 		goto out;
 	}
 
@@ -990,8 +989,8 @@ static int zram_writeback_slots(struct zram *zram,
 				struct zram_pp_ctl *ctl,
 				struct zram_wb_ctl *wb_ctl)
 {
+	unsigned long blk_idx = INVALID_BDEV_BLOCK;
 	struct zram_wb_req *req = NULL;
-	unsigned long blk_idx = 0;
 	struct zram_pp_slot *pps;
 	int ret = 0, err = 0;
 	u32 index = 0;
@@ -1023,9 +1022,9 @@ static int zram_writeback_slots(struct zram *zram,
 				ret = err;
 		}
 
-		if (!blk_idx) {
-			blk_idx = alloc_block_bdev(zram);
-			if (!blk_idx) {
+		if (blk_idx == INVALID_BDEV_BLOCK) {
+			blk_idx = zram_reserve_bdev_block(zram);
+			if (blk_idx == INVALID_BDEV_BLOCK) {
 				ret = -ENOSPC;
 				break;
 			}
@@ -1059,7 +1058,7 @@ static int zram_writeback_slots(struct zram *zram,
 		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
 
 		zram_submit_wb_request(zram, wb_ctl, req);
-		blk_idx = 0;
+		blk_idx = INVALID_BDEV_BLOCK;
 		req = NULL;
 		cond_resched();
 		continue;
@@ -1366,7 +1365,7 @@ static int read_from_bdev(struct zram *zram, struct page *page,
 	return -EIO;
 }
 
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+static void zram_release_bdev_block(struct zram *zram, unsigned long blk_idx)
 {
 }
 #endif
@@ -1890,7 +1889,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
-		free_block_bdev(zram, zram_get_handle(zram, index));
+		zram_release_bdev_block(zram, zram_get_handle(zram, index));
 		goto out;
 	}
 
-- 
2.52.0.460.gd25c4c69ec-goog


