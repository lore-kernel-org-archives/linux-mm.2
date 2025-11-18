Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35729CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7AF8E0021; Tue, 18 Nov 2025 02:30:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CFDD8E0010; Tue, 18 Nov 2025 02:30:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5C48E0021; Tue, 18 Nov 2025 02:30:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67F4B8E0010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:30:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C574C03E5
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:30 +0000 (UTC)
X-FDA: 84122905020.24.CD3D7FF
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2024C80018
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="N68wV/L2";
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jutJ+oFjCEnvR38mjyioMxG346Cjl5qLDOdOQPQB++s=;
	b=C8z0MFeVtl8j98+c3glQWYlG9lvosUmBp30dZGxTJqnD0qxPcuC6byKnOZx7UpkMZxZ4IB
	81hphQ5mfDgYk2TNtfaCDH7Ld9RNpA6c9aH3buO8uwvct4//+aU2vLhtZHXULp361E+0cS
	5aKnp58dbr7k2KUsWzlN2mWyfWefpvc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="N68wV/L2";
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763451028; a=rsa-sha256;
	cv=none;
	b=5dekdhLTe7Nfh1rh9/32aE21Q7bszrAK3RpWJ5exzGXB81wspmbk5R+yH5qgA7ql6SWBMk
	jfNnJ4yZ63rPSg+L7QrB1NhLQmAIe7TqKST6Fz58Hed6OKz5Pv8sMl1hQxFmmhdSeBppzk
	6Ebv0dD5AcrwMMyrTJh8GIfDHi35CbQ=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-295548467c7so60700715ad.2
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763451027; x=1764055827; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jutJ+oFjCEnvR38mjyioMxG346Cjl5qLDOdOQPQB++s=;
        b=N68wV/L2tk7wKeigQ+flxbSztSFqknOVrcyENnj7gQFMKraouS43kwlTRpwQitN/Bq
         rlq9m7O6tb709ChjxGMJ27v7u4I2K48qLOcmq6rBIQoJ8lab4GqXlbbeyJ22W04TQtw/
         qm193HmtPZ+udyKh15HVwhK5mXtAvmxY3y57g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763451027; x=1764055827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jutJ+oFjCEnvR38mjyioMxG346Cjl5qLDOdOQPQB++s=;
        b=lxLGRB1xB6qATz61w6yfGZT5sVeep0snx3tmXYt7ABbUm1vYbO9eIO7e2/QfKJBhsQ
         TRkhgOMHsxf8S6LdXykqV5jYvsLJIdMPI3M0NUpmUpWb7RVyYj+QvjWIL6hZJLQF++aE
         TH/rPuLmTA5DX9Jvy90zaUtm7tMSCDNglNDhL7tabPsx08H4b/l00j/Y0Aw/vMIQc2nt
         srRVdyKrH7eoYSy68Y9JQt8iWRKGzsCg1peRQVmzjpKENV6GyO0pKNIPj58/B/kgOaoA
         42KwSZ8HyQUDopzavkuyWbF3Ao8xmnP1H09G86aUSIVzMsFOup5fOdhu4gLglFDRIZ3h
         TMiA==
X-Forwarded-Encrypted: i=1; AJvYcCUqY9PL1GIZ0lWudn6Zw8p/Qr9X12dzzQWM/7k0GQDbw+6IPhuZBBvBhEB58RUhDjbgUWGhmf1QUQ==@kvack.org
X-Gm-Message-State: AOJu0Yy4QpHpGBtK+KcnJ8PV4Yh5Y2QAdXlW8AtaMbaN7cKyJUU1ilQN
	FiaejA28foUfYlA2O4IHPSnn9bTDcxuVRqfm1w1eCJNLiONCErP2anf+gPjVVpxU1WIwfjtVN3H
	WyuE=
X-Gm-Gg: ASbGncv6dwnbniattEuqwkp8b+EzAqYpSXKyYXy+kINEVBu8sXn/8xusL3WjjD3lY5k
	n7eIuojXOSuHJRoaqRtHF23gFS6+eJ2tKURFeUp3uHY7DbGsKdQOL7vEEHOjxDcEM2qdDkEVBa5
	O47ZhgaU0xEvLIIHyX3Wn15bDUlkn7uiGqrDOf6MFsON3cdAeiOiUowGiVw7WN5y/YDwmfxsHFR
	ri7XjmVoXgSuGhhQetpuYbcXNRPlloIlww5Yivs6qgs2yvgyD4pUBTrpoR/LdqKq70bfzCsGFdG
	zVh3yQOgQQ7RWKihvuUA8hvRovEsRze22aGXSv6/yTtr2oEQI1DbXNMYwyKNmiaOOwUhHxlcgNd
	U5VXIU8qtQa8S2dutsKGDdpUqThdqXboea98nfVAZRDTieVNl+P+wngP7Wh01Q2dGV8Pj5lMUMA
	FUUshVkx//0Ov+tyj45U20f1vfN0YNticGL7MYWcbOY4mgGa8e
X-Google-Smtp-Source: AGHT+IGTrSIAYxiYWQprs64AyT1Eid4jFJ2RFXxHbIDaASHF+bW10DGkq3qZf/woCLFk2DJb10FTEw==
X-Received: by 2002:a17:903:384c:b0:298:68e:4057 with SMTP id d9443c01a7336-2986a759838mr194649485ad.59.1763451026976;
        Mon, 17 Nov 2025 23:30:26 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2568ccsm163926215ad.50.2025.11.17.23.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:30:26 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv4 5/6] zram: rework bdev block allocation
Date: Tue, 18 Nov 2025 16:29:59 +0900
Message-ID: <20251118073000.1928107-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251118073000.1928107-1-senozhatsky@chromium.org>
References: <20251118073000.1928107-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2024C80018
X-Stat-Signature: 944stnr76r5jmp7eo6p7zibudtegga9r
X-Rspam-User: 
X-HE-Tag: 1763451027-309689
X-HE-Meta: U2FsdGVkX19hnPHjq/FgPIflZ8UJpgAoknkjtT9Zyn7gB4OpUxRMnQItfng3EBeOmuTHMxFZ4IOxJT8bRa+Cy+GGlQKHzwfVEjrF3itvys/kSRDN3CEVtZXAyWnL070qYWN0BEAsCtbO0+h6P/jWCjl5saKioNYtSP9EPdIS6H3XFj/FZPxSZogr/2dWAo6izDtL2Vw9uzweTW2Ggvvgak9pLNrcOn5jfs4ax7YNgyWoZ9/Eb0akwSXr41jcgGAXgG5toQLBzZMyKOYHDyPKZbfcJUZ30vCSVZJmy+APUXz28zgF9m3UCo3dNwFhm+sI4srM9WmHX2KUTWez1vz5tKXikqoVq/R0LShvnKUjrtXjslP1xK3o7CvCCneVi3dT9eQDQOE422agOcIkFCVvyNfKqQ9a6mIzlNFq4ujxBVmJ4DSkmFNFq1LrEGSD50fpQZetgoko7sBKOFxJsTPvoewaWJ0QE7s78DQjtQluebXFBq41pTul3CNfW2Te4yVMh6hpcRaudLgV9LGxt+8lTkBmXU9AxqMg+r2vxZ1yPoNXTIZ3jv00s4XZpKbSyPWvEOVfpQ/82gVnK9m/gHq334I46/+FlwNX+kTAvcnMk18XNCdYibm1n0u2p3wHpwtwcHLs7ZyCkX3AwNyQYYe0LMEBNV3sH+p0xP5/5ltGX6RLr7QfT8QinBzx5d4My+vlJLuCzdgMNu9qF9WcgQPHItOcAFW/J8XNn9SSopBPmAxw/x/JxPLoI0ILWoxgJeFZcxgCqFwVy64MA9CE10D5g5ZL0Pt+3eEt1dFhHCnIchA89RLpI654prsk6x3hyPbuW+qsiBIlR4dJIXvZJXMeiDB1S7sATCUdnL86qaXtTuh+WIWegaHH+6EQkUqdPWWkEY38dci1dMIoDhDtzhV9QlQwQULZ5p4ZybX+QF10Q4HphUakRVRC+O0CxW4uYv09MTvdPJF7hJdYQa1rMNF
 ACIiBXzV
 vXCZLYveApESr3ifTcZXyMMM75sIQgXDmJmg0dvwH0BQjbgjTd0PYoxkYERK4wec+CSmqEg3Q7Yc332fbomYN+dpEp/MTv3EwXN6ISIbrbx+nvlh7jmAV8p11pDdTQvcMkyaOVJAqBi8YbEddQfEioATG0UVkm9nSMkTnmvdIbnQdeYiBOvTcmiV8Q39v+GXydRm/Gcw8Gdf8c0xFsymzfjN582H+KAnmwEh0aPPkdSh/kGjqmpycAOubPqx4mZTzYztd7Uf/NyAXP1Ec70PbY4baUx0M0PeniWsF86CT/etGoYYBZ3AOHQtxtg==
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
index 1cfb58516a8e..93365811781b 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -500,6 +500,8 @@ static ssize_t idle_store(struct device *dev,
 }
 
 #ifdef CONFIG_ZRAM_WRITEBACK
+#define INVALID_BDEV_BLOCK		(~0UL)
+
 struct zram_wb_ctl {
 	struct list_head idle_reqs;
 	struct list_head inflight_reqs;
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
 
@@ -882,7 +881,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 		 * (if enabled).
 		 */
 		zram_account_writeback_rollback(zram);
-		free_block_bdev(zram, req->blk_idx);
+		zram_release_bdev_block(zram, req->blk_idx);
 		return err;
 	}
 
@@ -896,7 +895,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	 * finishes.
 	 */
 	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
-		free_block_bdev(zram, req->blk_idx);
+		zram_release_bdev_block(zram, req->blk_idx);
 		goto out;
 	}
 
@@ -975,8 +974,8 @@ static int zram_writeback_slots(struct zram *zram,
 				struct zram_pp_ctl *ctl,
 				struct zram_wb_ctl *wb_ctl)
 {
+	unsigned long blk_idx = INVALID_BDEV_BLOCK;
 	struct zram_wb_req *req = NULL;
-	unsigned long blk_idx = 0;
 	struct zram_pp_slot *pps;
 	struct blk_plug io_plug;
 	int ret = 0, err;
@@ -1009,9 +1008,9 @@ static int zram_writeback_slots(struct zram *zram,
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
@@ -1046,7 +1045,7 @@ static int zram_writeback_slots(struct zram *zram,
 		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
 
 		zram_submit_wb_request(zram, wb_ctl, req);
-		blk_idx = 0;
+		blk_idx = INVALID_BDEV_BLOCK;
 		req = NULL;
 		continue;
 
@@ -1351,7 +1350,7 @@ static int read_from_bdev(struct zram *zram, struct page *page,
 	return -EIO;
 }
 
-static void free_block_bdev(struct zram *zram, unsigned long blk_idx)
+static void zram_release_bdev_block(struct zram *zram, unsigned long blk_idx)
 {
 }
 #endif
@@ -1875,7 +1874,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 
 	if (zram_test_flag(zram, index, ZRAM_WB)) {
 		zram_clear_flag(zram, index, ZRAM_WB);
-		free_block_bdev(zram, zram_get_handle(zram, index));
+		zram_release_bdev_block(zram, zram_get_handle(zram, index));
 		goto out;
 	}
 
-- 
2.52.0.rc1.455.g30608eb744-goog


