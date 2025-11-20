Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01279CF8861
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 887DE6B00D6; Thu, 20 Nov 2025 10:22:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837ED6B00D8; Thu, 20 Nov 2025 10:22:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727DE6B00DB; Thu, 20 Nov 2025 10:22:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A03E6B00D6
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:22:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10CA51DBEB2
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:22 +0000 (UTC)
X-FDA: 84131351724.12.8D86739
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 29992180006
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:22:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=b6rjiP9c;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763652140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60qtdCMZp80VF5yuM/N6mmuFIve0x6cnvVTEq7lRrcI=;
	b=vwu1wcjF6TfjDQRf4CA2TlyQN9UgGS+oXpQPJq/ujTkXbY0kxsiu6TeyFOpNjyVcQOWJib
	xAnJSSVggQNZvSoeLrd8F3WbeYCiOnmjImzk4BX1t6B8i4mKa+ecvnqZEWHXufTw/U+iuh
	6l2qAXE/a8SCgj4knycZQ3KcHcvSX04=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=b6rjiP9c;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763652140; a=rsa-sha256;
	cv=none;
	b=LHUWjJ5PQAz7r3HPIIQHK/VeZ+TtZKVWHGYGK6+zUQcrnpzZiVLLCBnUOgTX3MrSx1VCrs
	YVOZ1/lfgWL+xO6YNrxfSpvQMPt+p/KzVZ5F8Hq9cgbrp7IRcLJBGuD13VxJuqKHJQYvup
	uR8ZCVnZkPUbadAgJtD4WAQMGR5/Uvo=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7ba49f92362so686007b3a.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:22:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763652139; x=1764256939; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=60qtdCMZp80VF5yuM/N6mmuFIve0x6cnvVTEq7lRrcI=;
        b=b6rjiP9cfVBjPraAKPJRBqgz60ZHahF4QDRz+kDLeNtzS1YethnNvcRgi0WN26wgAh
         lvynel4adNkhMaOmnU2e+aeDHA9bbEXzZT+lSsncdlbOkYIi9JppELAzAz7fYV3Mqs5c
         P/mgehGM8aJcwhEGKBhfLIUqDPnpwXa4WgwhA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763652139; x=1764256939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=60qtdCMZp80VF5yuM/N6mmuFIve0x6cnvVTEq7lRrcI=;
        b=hI4w4Y0VL4WADUdUAfsaxN9GE/SAjJgB1SppVtHHocd+AaUrkGbol0SrWCkn70srRl
         w0PZlpJElZ3BopjQjzx8gNYK2k93U2OPW8wWQu9YFHnlBoTp2acNpHK0DvQ4gySVReu/
         0nJ1yKMI5U1Z5DisUkdtVRlVWvYUTBNmXbzh9TDTtOrUQ+dZOOqCGp+X6Qy1ZSagsI/V
         ikrRcpznK4YqbBghJgYB1apDGdWNK6vlV/72TpZCuYWxfK9gfokmm8ew+qTyaFrGjESz
         qOh0QOqLed3i9HWylKW4WQ5pXY9NhQH9UAEbzP1pJ7eFz+9iizNM97R/u4b33/N2ooxA
         //jw==
X-Forwarded-Encrypted: i=1; AJvYcCVF+uBayNVrAtdY9CNgRBPzibPlvEoVkbaZyEnYVHqgx9zRqqWTb+BMyKIV7QRPd0/4nN186O0apQ==@kvack.org
X-Gm-Message-State: AOJu0YybagykY4ilkvvDR5r1Sv0uPHgzi79Z+k0WfzAepmpupms4Lpwq
	+rQe3DTnUjeLtAhHvv9dUIkBeu23zM5hYtXJSP8ldHwtYcml6hYM5M0B4WTmB7D+Vg==
X-Gm-Gg: ASbGncvRiOSFeuc8DayltA/4Z+5Kwva48nUwC4Eayxb2u+6fXlIMFug4tXgKVYnmAVG
	MSDHONlqCmdzNNU4Hs6bQtyjzqEuSZCqanqjNbGm0eCNW3/rPODZl9NYEUyw0YOIH8EdgoXh6EX
	S/JG77pVayDxFKh/tuwrej8t8mQ36CC4vhfu5MDQnP3WoWMiwUKob4v7bAdExuB1ZvEYIEV9NOc
	QavtWlyAvHC8GJNk/He34sy0JxVlpxiisK0hcc16vBPf6jyU4Qpg36OyNEuRAfJo/jUr6mpIKhm
	s80lLj9jkt5DeMzgHujM7jOpcB+1xGi1haizapwU/OpYPxVdnOjzxr3w4Sy56jf1OklxiFTmPQH
	bJY5LGm6WbHDT4m1bTKA58S4zx/HF1M67VOLk8VO74A8FtxpmbR64qvq168Gu6VfgADU9NaQaqS
	HtsHKNktBBvSdO80289/rY9UAwSsMDCZQz0Ets1Q==
X-Google-Smtp-Source: AGHT+IF55sfvtR57vKBk+ytDZecrzkU4GEMllnIDmAZESJWF3inRrxqebY2ATzJpA3aK4tJ/iPpEuw==
X-Received: by 2002:a05:6a00:ae09:b0:77d:c625:f5d3 with SMTP id d2e1a72fcca58-7c41dd0b2f7mr3534869b3a.1.1763652138839;
        Thu, 20 Nov 2025 07:22:18 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:6762:7dba:8487:43a1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3f023f968sm3179642b3a.38.2025.11.20.07.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 07:22:18 -0800 (PST)
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
Subject: [RFC PATCHv5 5/6] zram: rework bdev block allocation
Date: Fri, 21 Nov 2025 00:21:25 +0900
Message-ID: <20251120152126.3126298-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251120152126.3126298-1-senozhatsky@chromium.org>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 29992180006
X-Stat-Signature: xzr6u6jwk31mh41cxc3chcaoskw8kwij
X-Rspam-User: 
X-HE-Tag: 1763652139-994987
X-HE-Meta: U2FsdGVkX1+HquW9DIdN02JyEtYzrknSr0pb/KZSavJ53a3r2sjl3j7URjfi57wicGwm1Zp1eBXkJ8bVUvLJAfKfDnDQEsIA32W40oNlkwIHtHyMi6JKt4+MHfV6Sd1/6FSD8PaOOQQL50xROPVNuR8Zk44gTh0nPGMdcMJ+jS1ojtk5wGPfVcSc9ixrgQffryHNNVhqCAFHb2S8fPIQLk2TcM5FfGpJ9G4giikAVdKbq4so311MOuGRhb9aEMIv7HtcQwyQsgBkZPS0Ad+F3PFrx8nzPXjs3v+Gs6w7GN/rteQOBrSzKmVI4dVyskqPMA5kNPNNktbUwbP7W0MVIhC2ubbfD+fgBqvwPV4BydBoB8841b5AxZs5jq/czYPdWMbQ1Rws8whhvaVx9xH4Kp0aN3RzZWZQG7z0PU1FhQHDzJBnERxX/7u9s+G9Mqkk/a4DcodNyorZhDnOC/15WWl7iTf4P9CwweHpXDKPMTUOVlvqhQmiu/VovNGHzjB2v/v8wKhtGqX0wZxNiNuc7X+iD96Ok6DLKxaiVB0wmuFHy6qGYO2+cFXOEzc6IB+0uCS1kF01v5O2TJz20zD5yk3ysBdInhEDj8Tw8HuvclUIglnzG/gtKIEMY7RBD7xKRTQGgDxPKSm8Ld5UrHgA1F8Q4NFohbshCSZTQCAI7lPPV1m3njxIme/EvF2UinJ9/hUNsp0soBQM2HKScyIPu70DFSCdzIqiPfdRdawOPyyhxBl67bkt6pFbrwrCx9CkBIbQDCTqM52VbrliyPMgF6dfP3aMqrajPtW8k5wVoRJmE6I/DNmkpDX7tY2Sj4TpwfcRZ7LXZ4vtUvoyEScluU1Y67SHnphBZZwtCbApi5tHHjY3J46Qk/7QKnxiczGqHqxMg5AZ6CptiF3kjOz2z2+8Sy7i2g8KYfnEtU8K4uhDfKNS9jixg1N7faHLueQKcxLwsUcyYbqozZFRyWN
 SSk+DuZK
 kv+4CDMbUJ8FvQ2bBQIY6LOmbrvX1s5Izdh4kl2/JzYaMYZW95hE03YX7zOERoXDGW8DFrpOYTHhH+GF/kFC2PurXTB9+1u+Wh/yd5sPYITBtssbe8fwjQ/5Yr2ijs2EUHu2XfCjqbWnCQoeV/ZaszWybZTmqGlQgA0KgjsEvTR3Q4yvZaHsZ9404O0ajTcjqmQOJNlaN3+u1BnjfTStu03hfW2L4UI1W4RHETdDOCSoIVYHhHpl3fxM2evzlI5asFfljUxaRYOneMff4/kUCynbJaD2wYo+21/DjBlah7i+1RlDVFzeXiSEM+g==
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
---
 drivers/block/zram/zram_drv.c | 37 +++++++++++++++++------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 671ef2ec9b11..ecbd9b25dfed 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -500,6 +500,8 @@ static ssize_t idle_store(struct device *dev,
 }
 
 #ifdef CONFIG_ZRAM_WRITEBACK
+#define INVALID_BDEV_BLOCK		(~0UL)
+
 struct zram_wb_ctl {
 	struct list_head idle_reqs;
 	struct list_head done_reqs;
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
 
@@ -989,8 +988,8 @@ static int zram_writeback_slots(struct zram *zram,
 				struct zram_pp_ctl *ctl,
 				struct zram_wb_ctl *wb_ctl)
 {
+	unsigned long blk_idx = INVALID_BDEV_BLOCK;
 	struct zram_wb_req *req = NULL;
-	unsigned long blk_idx = 0;
 	struct zram_pp_slot *pps;
 	int ret = 0, err = 0;
 	u32 index = 0;
@@ -1022,9 +1021,9 @@ static int zram_writeback_slots(struct zram *zram,
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
@@ -1058,7 +1057,7 @@ static int zram_writeback_slots(struct zram *zram,
 		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
 
 		zram_submit_wb_request(zram, wb_ctl, req);
-		blk_idx = 0;
+		blk_idx = INVALID_BDEV_BLOCK;
 		req = NULL;
 		cond_resched();
 		continue;
@@ -1365,7 +1364,7 @@ static int read_from_bdev(struct zram *zram, struct page *page,
 	return -EIO;
 }
 
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+static void zram_release_bdev_block(struct zram *zram, unsigned long blk_idx)
 {
 }
 #endif
@@ -1889,7 +1888,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
-		free_block_bdev(zram, zram_get_handle(zram, index));
+		zram_release_bdev_block(zram, zram_get_handle(zram, index));
 		goto out;
 	}
 
-- 
2.52.0.rc1.455.g30608eb744-goog


