Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C0BE606D80C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ObOcnKOV
Received: by kanga.kvack.org (Postfix)
	id 64DCC6B05B6; Wed,  4 Nov 2026 23:48:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601D26B05BD; Wed,  4 Nov 2026 23:48:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F316B05BE; Wed,  4 Nov 2026 23:48:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 23B586B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:48:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ABECC1208E4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:08 +0000 (UTC)
X-FDA: 85399833456.29.230E9D7
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id E81E640008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:48:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ObOcnKOV;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjrFI2LAiEBxbMGOO9GEbnSWXVWxtBu2H3xiPKEbLJY=;
	b=A2zdkj3ak+huKBNAhkXbObbr9gc8d/qCI/B4LacblEM1cbI158Nta+Hd5gcOiz7Tnd3tm6
	twkvYGfTzjtE2D3YZ0C1UU1OwSfrsHJD6BUIyMSczyUbzevnaQ90ZtY8k0q1DIU/v5y3ug
	ZgYl5eeE+9UwpCH77jNURBZm+/cpnqY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ObOcnKOV;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf27.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854086;
	b=43siQ3hn27trBj4tJa+nmkPbMe2ILQ1hdEmL0qrCpu35mMnfvT1gBEXgC6RvcPrGSMVkpo
	zVkaUqnZIhFfW2vSs/mRpgzFBZm7m3q+C2zGBPG3sohAsgZ0obHHOVw+7ok6nITXgv1+Pg
	TSDhFX6E8vYy0cPCJz7jJoa8OY7mZ4A=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-36a1947498bso3941110eec.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 20:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793854086; x=1794458886; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zjrFI2LAiEBxbMGOO9GEbnSWXVWxtBu2H3xiPKEbLJY=;
        b=ObOcnKOVWFFM7MIESoF0nassLfMhGuPCLZGO0utEz5uaFY0n87zhtncKrGHh6yCu6N
         VE5ZO9xyXx+NWChH3DvL8p5TbS20hsASCqaGs090M1gP6oK0KdwNFaJ+7vZGHeKyGLBy
         n9Y7M/GV6FSz6PJ0aBkYLsQt/11ZHx+4j/yIQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854086; x=1794458886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zjrFI2LAiEBxbMGOO9GEbnSWXVWxtBu2H3xiPKEbLJY=;
        b=g6eOVKsaCq6bikljHEkviVLmyWRyIJBMEDBackOYNN1E+2C3fHfvu6E73Rh84kr3KP
         ta34KwkQShbliLvSPj67J7xwYZBvp/C1y/JutZJOWB8q/yfUUbpPOsiZqnL1iTVhV4Bq
         TJ6zILkU8iABaXzOQGIxLHORKoZ9EHY1QUd1Kht8Or5r0YLn6q6TPfHx1gfHDDQWGohz
         /+Bp2LGHOiRmwkEdhGFChmOh2ZvE7QI3VtmA5vXrDx59W/WopAq9HMwCSPbKdVeEBHrY
         SpIi7Jxi5G5cU3OsPxmGhzcGQJL5g6tvB038wrMbEzAsEYVYvtaTCYKTfIC7da/mCg0Z
         jnZw==
X-Forwarded-Encrypted: i=1; AKwUvBzpRzUB1HG1q8SDN9FCDzvaqCTCu18lN+83ov/2MX2KT3tvuFyC8I8NPFQp9F16LhlrvmOGL5qD7g==@kvack.org
X-Gm-Message-State: APuU4Z9uuv+Umxr5P95wczzkozraQI/iC50w3Kc1Qmr6qOrmLvnuYdaa
	7U2r/2F9vM+zZi8lIgqdDf5YrVfQAasRdWs3zViWfj2Vcwzu9gMCl/cpw2kBwjMbNQ==
X-Gm-Gg: AYBFou1JFZTU5r4HQT7fg6GbTRHZnh7aTU/nCLL8ccYXc9j0r0rTOvP9FVYp0FP3VDb
	F7tyy9Uo0mS11kbDYrMhUQ9LB7QzN0P8meu+s3RRjnrxOjpKx6vBmQrs+w1zz/kkszoe6IGsxyA
	HLiV/Gz3ST2rrIG8d2AvrPJiG9DS5n/44mxLYWhh9fVBw8iyGETyUNikUX7hR+tm8Bd0xELq35R
	YinHkPfy8n3DBSMuttZI1QwhgoU/KbB5SFGhNog9lcaFsonR1aAnnJhBtFxopsoJyAi7KuqhP8E
	/5KnmxPS947UO6SmGAFVmeFtL3HIm0lNLw3kRUgcDS8yq4JuYJsbd2NtcvwWULcamzH98400+If
	EaceXJ1OKWADnrEQrl1JvSH1P4UvQ00P+CYPzyjTrWHOYNTVWj14I8Rq66rg5MhZXsy0hmfI3rY
	IlEOkN8g9c/BOsKiF/XdlqbwMHu7NFNgXm44fDnIEfdFUdrGmOJqFgJ/duTwu0X1jpM8Qmr0RWq
	hNonnjz+Zf/PYn4mrFAadOAkiHEDqGxRui1/mRBhQWaPP8VpBsUPEDkLi1US9HRD9xM1wF5zYXe
	wNFM9pR9QZMpABut4kjtwwjUsUAY7JX+bKrnXBljxXljZ0Xpwy0wdyTNGhSDc+iSYm5H8qLnVkP
	iRjxCpRXwfFabZAPVj49syrRWuqRwnOJniNtXXhg=
X-Received: by 2002:a05:7022:3b88:b0:16d:1e24:5cc3 with SMTP id a92af1059eb24-1ac5c64c610mr30136742c88.19.1793854085519;
        Wed, 04 Nov 2026 20:48:05 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:37bc:b763:7ec7:65b4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b245c6f0dcsm17142927c88.21.2026.11.04.20.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 20:48:04 -0800 (PST)
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
Subject: [PATCH 2/7] zram: drop get_slot_handle() and set_slot_handle()
Date: Thu,  5 Nov 2026 13:47:32 +0900
Message-ID: <20261105044752.1997895-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105044752.1997895-1-senozhatsky@chromium.org>
References: <20261105044752.1997895-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E81E640008
X-Stat-Signature: t1chn9f6t1f3jz1m9z6y7rpzxq7eku3x
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793854086-218797
X-HE-Meta: U2FsdGVkX1+l2caJYAvol4kY8NsXav3PcqFoL8CBEP8p3rxbAiIOtT7ENib9ZNGv1DDmouq3DuIOMh7BECp8xg/prEwTjKjoM7PZDQrtO0ZabCPAlApSPQWkQKH3kFOiJPTJ+LZRF/hxyys5PEkrPmTohtsmNfSXU9y0eZzs+Oa8xVu9riUCpqUOq4bjvfFNyNWqBzCealWuNMi0UFEbjvltbfcVfKrVKI0buk54SOlSIP4i6YpMiob/4+sdqMx1fNEb3OL5u9Eob7qg1QkOPVHS5Y0qCdw83OYILr/D9ZE27kl9zd+HfvIu1SgikI8//gzTKz3juZEs1Xl6UA8KxN3JJO8z3W+w2BBQ5+gbt3QP9fMHkZMpor6qE772D/qGDpSetcIHVYMfYpI0oDP6isXw4/qyU0w/0Db2LclkhZDQxgfTIzU3mR2jtArdtlqqUHThr0t0Eag77+1u5+szI+pNa0p5OsZy+UrE7eeFgE7xAcO95W5G6yFfZAWobqRv8oNwhc6zdcZXtKo649oET51hLsnps/qkI7Z7lmM4YUvOcTcPmrxM5GbnntbhKB49OB2RYIq5WhYzCaGMN4U/KderUlcEGb86FBzYPNxQEEErXOFZKPmM1FE/RPTmIS+uaEwLutOx2JwWzZuAptGVJzU+y/jdvCTw6YKAzQ0VwkUJWojhkw7+3G78svoIQ1saM4pbGl+lif0YJBdC+bVrDfA2gK4Fq9C+7J1yRbfrGWKI7/fs0XxHSAwBAoAr0KbZYRqUs9uyiIGzE1bK4wx73TDP6oPtHY12wbhA59wTTERj3NuE5z2/5lfkyACM7L6wXdJTa1cIRHMkpv+61No8pi+uX/SmYdLe59V5sgHRla9tcgg857/B09Rs05XpftImPM3Kh6E+keEZ4C0a4Tw2wgHwCEpM50DzqC3fHP+pBB7VRBokcpRgF4YHQ2nZhZgKIORoLKV0XJsDsrp2CAI
 dpEtndwk
 BbMnLlpqWV9xj+HXKfj2xHnoogvj/nCnbIiu10LXYz/rdoYjYI7UihUJEahhTjJ0TvIhyz0cqE0VafpbU76nzCekrvX95QyBevqHoGMIKSwHi+WSz1Vip1m2xXkH0EC2BMh8O5RlXPh4AghbRbsBO/CAUNUGWv1FDxtvqzgt0f2Sx8kn3pHI0VQVAaEftWzLzhNephkP3eeZG3JYJ/NIqeOhVqOM+wSITbLX8COPWumy7113bXEt8jhZftlLHpP1rIZr4TOrlc1l4w+tYgPIAXWLdglrmz4KIsyieNpki9vXvJUrqvpB6kHz4RXBo7DdjFVlKksFAqY+XbSkOVAV+qjMbIIxUT8N+0aXX
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
2.56.0.398.g882cbad275-goog


