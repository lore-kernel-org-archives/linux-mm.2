Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF89260A262D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=H56PpLip
Received: by kanga.kvack.org (Postfix)
	id 752346B05B6; Tue, 10 Nov 2026 00:48:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703606B05B7; Tue, 10 Nov 2026 00:48:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618BB6B05B8; Tue, 10 Nov 2026 00:48:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3604E6B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:48:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4353A85C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:48:54 +0000 (UTC)
X-FDA: 85418130588.04.B98C16C
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id E8AD7180005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:48:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=H56PpLip;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XpnbsjJLLF0pRRHml5avH3sFfAy4a7G34t01Mzwk4xE=;
	b=w9oFU01ifpwTPr3erZY9DJPrbH/sLgG8cMvH1WbBINM8kvzYAJnzJlPnLl13RtHHNKdvdG
	NEWIEJPAYDQs066js3T9uLI8lNTqFWy0zHmOX7NUDMyW7jsfhjnicZ2ny6cBZQ/MLTtCS6
	LgAPs1oRcIzmxrql7RO0hvr6ZlUmFYA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=H56PpLip;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289733;
	b=4hBpHllS+PaKz6XxIy5lC9yQufuZjuYPTjtYWv247fwwMGMe7bBOJ/W/KsXWiCC6C/1beF
	QlOTqOaIDcrQGpBdE08YZTSFhK2SfnVKcWgDgRztl+OALXGw+O4ARyDWgZiOH/VBzrDucX
	Ssy7fYWU1AsL1Bv3EWSIPuV38T2/KHE=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b2382bf051so950144b3a.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:48:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289732; x=1794894532; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XpnbsjJLLF0pRRHml5avH3sFfAy4a7G34t01Mzwk4xE=;
        b=H56PpLipBR2jQ/l9s63qPIMdhOvlgb2SfuXUl5BhYfDvR2n6xhOQJXHC3r3ikLiN6h
         OOpFCriBdmFG8aloQw3Tj2BK3CQZyGg38dwsTXeFrS8POUcFR7owm0AL3Qmmgz2A8XkG
         UOj8WozEZc3bFX1K1x9DNB+w/7DrhkEKLyC3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289732; x=1794894532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XpnbsjJLLF0pRRHml5avH3sFfAy4a7G34t01Mzwk4xE=;
        b=SWfxyEkRx3bgN/AemINbV5/xNohX5G3LzBWEwc9wAZZJrMQlg5XuE380MXE2I2JK5j
         xmbcj404V8af78jl60TYQfDZWTT9G/s8C7xkonY5pkj3IRtygGxg91bExaToe5bYx4Gx
         3m4jelhG9F+F/PEnY1Q0ESYPKVz7q7FNGlyvGEOJsf12yTaQlu32Trpo8GsN8OZtFDMH
         Ys/0xc2xkweMiHmuuF4I0Bbxy/Atss3ET3YYw2uzKU6bv9QgqLbiEYyyA3efBJI7IEX8
         Mx0TfQWafoP+r/eahsxPzslHz7oRsQoo/k9PBjENhhnRCxarzaTBNFhaqX3755nt2RGp
         dyKQ==
X-Forwarded-Encrypted: i=1; AL+hErETIIYbOlHWgFvDg5TI0/gyd0cMhsqjbhgzCpc39gfoBRE62n2AxUDG2n9PEs8dT9yOQPVSXrq5IQ==@kvack.org
X-Gm-Message-State: APuU4Z9eb6plgc1b1Rlo79waKSIeby+OFmoDGTCWMxkkPmvqGRwXkxtP
	YLpRmtZyqx4SqfrLMVc/i5jfJMHOkdSYISiOw3DPEkRsKHEQXi7Nf+cV0IFe2ptHpQ==
X-Gm-Gg: AYBFou1Xzg0vyicR2h90y6z+ke++XWzz0r395Q1vPmuiM0fka15upIf+YAKw+SzKXdH
	c9EGoUBxNOYWbkSImH1KRMzIP1Gz2426rWQHMpWYlC+ped+7CFf8GqPYgQPFECwSIIeiyQ+0CKY
	QUmJMIm/kQ+u8Xi7pKsFD11G6ApKT9JtfbNuc2jx8gi5Fhyuhrd6rupd2aqhjg+FGjW33MvXJ/s
	eN0Ku7OG23778sDgTLTn4DzTw5pvCGcYNjx+oWswuHUO1kzURF6yVSq5adUk2G5kMfY/FhDuJJ6
	H5EwxGTdZc7XlKKB0ZPTIPkLZmYbD0E44zEg6CwpdvFq/re5ou4u7+zXwXAETGpxiPs4YX397fz
	wOG5sSzahjR/aunLgk23pKnl5jbyYHYbAKb9IiKfyr+y+yt84xj6l70CqnX5AWppq5av5I847Il
	YJlmJD12M1t7kbTPypgRblwyjsfSsTh5fYALcwFfwN/1dB3G/TbT3cTpkN2/xhYCfIURZlfwvyA
	VQ+jjj3P5CfyYDhMdXW2sEL1YHMt19GIaSvydl0/k35krn+llIBQygQfMtzYS7zEC9+N3DvVmTr
	I4IeBwzc0NJJ1Z5sPRnIZg4Q3xrmAYl8QyKHJYK3Rz0DI3mIBo2x6f13KQA8CfT4Df0C+vLmhb6
	TwNMwHlZzSkJM6pIGVE6ZRzUEv+tLvToM7vk6iV4=
X-Received: by 2002:a17:90b:548c:b0:3ab:31e6:12fc with SMTP id 98e67ed59e1d1-3b166a64553mr2044187a91.0.1794289731797;
        Mon, 09 Nov 2026 21:48:51 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:48:51 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 02/11] zram: drop get_slot_handle() and set_slot_handle()
Date: Tue, 10 Nov 2026 14:48:07 +0900
Message-ID: <20261110054836.1515030-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u5d1xi1o78h1gsdtwuw9o9wqjjp5csei
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E8AD7180005
X-HE-Tag: 1794289732-804204
X-HE-Meta: U2FsdGVkX1/RNK7UtSjLlY63pnpK81ncXomluQKmIgYmEBxex8sZPVUzRqrxFrxcjYtPiOLxIKJDFHM4g4CacAx38lvGjXyH4Bg0WpNIFhJCsBqpO5pryUkU6Dw1wlU4O1/RE1w2O3s3IjtL8zSU9U/M1k6AmIMKwkeeu42Yl5kTP7TyjHvodibMb/lCvjNjbOzkwrD0FIHYZQi2EFiXKdi4+R/pJG1++bJKoxg51f34cXDpmnKXe113Zl6OjG89Paq1ETtIGJBQM/4v2oSSmAsHBpTeDOVyavLSfdr9BddJ6XKHUvMFGoTieKaCJStAH5qLvxeBfxgTydAOdvRuUY2sNLOeGGlZTfXMq4wdc2C71wzLzpgiI3K7YXECP8e2vUwwyDWD/GhUIjaGwIuA89f1BjtMRHNRtE4Rw/Df35ww7YAliG34GQ5tzPfmjQsaQS8uBDBZ/Xv41sjMn/18WhZpF9b32siGTH1qrw0GArWptNXZTdVw5ZwqAR0pDRFuGc+l7RcZno8PFTeGTzVNJQ6RgRB5TffrCaV0YL5JB60djhuXfdV9RnE52CKqP0K/xFLdp4gZLU1xVuQK88+4qJD/6UMKC9WjngacIpNG2DHr/YGyeAZbs0bDl3mF0SFDfhEy90S3+bcud6voiZ+dWJ3zL7B2hozZl8IeMBjI/D0SXDiQS682HYKg5PP7kiYjNyC6nnVNMSa6Btv016O2fOiaKUqhXW5c6w+3l4C8VtvgxT5hm35zXduOiBolEOzwAkhshy+UrykFwVE91FTbcSnz3QlHRlZ5Zm5MRCR49ebIHcTlA21Z6398N5cH6Ho+AmIgUVD2L2yfbY1q/jWQgUi8wqsnVdzH7HwFKsxgCWxMepI5B1iJ40xfexwQIweoK+kPTqwKMTwrD/tGIb1BYJW+Wj7iZGR6PvNPMhk2kyksUHDwOxvhPNyu3gdynuvBzsDSuSSN6qxGFlGb7Ql
 +RomDjbf
 vh+1Q4QuY46sWPWIUoZYDf2Jgqzpeszncy6Fb/iHKuh439KzK9X6M0G1R1BLYGH1spm72kSMtWDpRHOnCvUJS0YmpGGutbN/DA64zaCcvc3UaPNRbUZU+8LSY899WIw+WMYU7tJYs1oULIGWLBrnmJqlLgLqlFVbUeiKMnapKH95dubhnVAPOQGBkOsUm5uihsMW+liewBjFP/QJl7U6FYVMOT0VXh1TPg80SFw5y9+Glt6/ICNm0ADOiQ/4oxbjmrRbRuPvffOsV60NmE8np7HTf60XjbpMvnhw9dBhIgofPmjGSS5uduOdQ+lVt3irYrALKVvyiAAIxaqNOogExufkMh6D+AzZ6n/ao
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram_table_entry ->handle is overloaded to store zsmalloc handle,
same-filled page pattern and writeback block index, so calling
set_slot_handle() or get_slot_handle() for blk_idx and same-filled
pattern is confusing.

Turn ->handle into a union of handle, element and blk_idx, drop
get_slot_handle() and set_slot_handle(), and open-code field
accesses.  No functional change.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 43 +++++++++++++----------------------
 drivers/block/zram/zram_drv.h |  6 ++++-
 2 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 380615b73446..5c13addd22f6 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -111,17 +111,6 @@ static inline struct zram *dev_to_zram(struct device *dev)
 	return (struct zram *)dev_to_disk(dev)->private_data;
 }
 
-static unsigned long get_slot_handle(struct zram *zram, unsigned long index)
-{
-	return zram->table[index].handle;
-}
-
-static void set_slot_handle(struct zram *zram, unsigned long index,
-			    unsigned long handle)
-{
-	zram->table[index].handle = handle;
-}
-
 static bool test_slot_flag(struct zram *zram, unsigned long index,
 			   enum zram_pageflags flag)
 {
@@ -962,8 +951,8 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	if (test_slot_flag(zram, index, ZRAM_HUGE))
 		atomic64_dec(&zram->stats.huge_pages);
 	atomic64_sub(get_slot_size(zram, index), &zram->stats.compr_data_size);
-	zs_free(zram->mem_pool, get_slot_handle(zram, index));
-	set_slot_handle(zram, index, req->blk_idx);
+	zs_free(zram->mem_pool, zram->table[index].handle);
+	zram->table[index].blk_idx = req->blk_idx;
 	set_slot_flag(zram, index, ZRAM_WB);
 
 out:
@@ -2064,7 +2053,7 @@ static void slot_free(struct zram *zram, unsigned long index)
 
 	if (test_slot_flag(zram, index, ZRAM_WB)) {
 		clear_slot_flag(zram, index, ZRAM_WB);
-		zram_release_bdev_block(zram, get_slot_handle(zram, index));
+		zram_release_bdev_block(zram, zram->table[index].blk_idx);
 		goto out;
 	}
 
@@ -2078,7 +2067,7 @@ static void slot_free(struct zram *zram, unsigned long index)
 		goto out;
 	}
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	if (!handle)
 		return;
 
@@ -2088,7 +2077,7 @@ static void slot_free(struct zram *zram, unsigned long index)
 		     &zram->stats.compr_data_size);
 out:
 	atomic64_dec(&zram->stats.pages_stored);
-	set_slot_handle(zram, index, 0);
+	zram->table[index].element = 0;
 	set_slot_size(zram, index, 0);
 }
 
@@ -2098,7 +2087,7 @@ static int read_same_filled_page(struct zram *zram, struct page *page,
 	void *mem;
 
 	mem = kmap_local_page(page);
-	zram_fill_page(mem, PAGE_SIZE, get_slot_handle(zram, index));
+	zram_fill_page(mem, PAGE_SIZE, zram->table[index].element);
 	kunmap_local(mem);
 	return 0;
 }
@@ -2110,7 +2099,7 @@ static int read_incompressible_page(struct zram *zram, struct page *page,
 	unsigned long handle;
 	void *src, *dst;
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	zs_obj_read_sg_begin(zram->mem_pool, handle, sg, PAGE_SIZE);
 	/* an incompressible object never spans two pages */
 	src = kmap_local_page(sg_page(sg));
@@ -2134,7 +2123,7 @@ static int read_compressed_page(struct zram *zram, struct page *page,
 	void *dst;
 	int ret, prio;
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	size = get_slot_size(zram, index);
 	prio = get_slot_comp_priority(zram, index);
 
@@ -2161,7 +2150,7 @@ static int read_from_zspool_raw(struct zram *zram, struct page *page,
 	unsigned int size;
 	void *dst;
 
-	handle = get_slot_handle(zram, index);
+	handle = zram->table[index].handle;
 	size = get_slot_size(zram, index);
 
 	/*
@@ -2188,7 +2177,7 @@ static int read_from_zspool(struct zram *zram, struct page *page,
 			    unsigned long index)
 {
 	if (test_slot_flag(zram, index, ZRAM_SAME) ||
-	    !get_slot_handle(zram, index))
+	    !zram->table[index].handle)
 		return read_same_filled_page(zram, page, index);
 
 	if (!test_slot_flag(zram, index, ZRAM_HUGE))
@@ -2209,7 +2198,7 @@ static int zram_read_page(struct zram *zram, struct page *page,
 		ret = read_from_zspool(zram, page, index);
 		slot_unlock(zram, index);
 	} else {
-		unsigned long blk_idx = get_slot_handle(zram, index);
+		unsigned long blk_idx = zram->table[index].blk_idx;
 
 		/*
 		 * The slot should be unlocked before reading from the backing
@@ -2255,7 +2244,7 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 	slot_lock(zram, index);
 	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_SAME);
-	set_slot_handle(zram, index, fill);
+	zram->table[index].element = fill;
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
@@ -2289,7 +2278,7 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	slot_lock(zram, index);
 	slot_free(zram, index);
 	set_slot_flag(zram, index, ZRAM_HUGE);
-	set_slot_handle(zram, index, handle);
+	zram->table[index].handle = handle;
 	set_slot_size(zram, index, PAGE_SIZE);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2355,7 +2344,7 @@ static int zram_write_page(struct zram *zram, struct page *page,
 
 	slot_lock(zram, index);
 	slot_free(zram, index);
-	set_slot_handle(zram, index, handle);
+	zram->table[index].handle = handle;
 	set_slot_size(zram, index, comp_len);
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
@@ -2471,7 +2460,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	void *src;
 	int ret = 0;
 
-	handle_old = get_slot_handle(zram, index);
+	handle_old = zram->table[index].handle;
 	if (!handle_old)
 		return -EINVAL;
 
@@ -2554,7 +2543,7 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	zcomp_cstrm_put(zstrm);
 
 	slot_free(zram, index);
-	set_slot_handle(zram, index, handle_new);
+	zram->table[index].handle = handle_new;
 	set_slot_size(zram, index, comp_len_new);
 	set_slot_comp_priority(zram, index, prio);
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index c563a7c13a49..5416e25e64e8 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -78,7 +78,11 @@ enum zram_pageflags {
  * of each entry and hence of the meta table.
  */
 struct zram_table_entry {
-	unsigned long handle;
+	union {
+		unsigned long handle;
+		unsigned long element;
+		unsigned long blk_idx;
+	};
 	union {
 		unsigned long __lock;
 		struct attr {
-- 
2.56.0.506.g506a7eabc5-goog


