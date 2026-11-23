Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDDB3606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=S++zaklV
Received: by kanga.kvack.org (Postfix)
	id 82DE56B05C1; Mon, 23 Nov 2026 00:36:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD0E6B05C2; Mon, 23 Nov 2026 00:36:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657E06B05C3; Mon, 23 Nov 2026 00:36:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 395B36B05C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1EF3C07FB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:47 +0000 (UTC)
X-FDA: 85465274454.14.49EDF61
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB6A680009
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=S++zaklV;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412206;
	b=k5mWRk/WvyyYMClBDUA3qydmMlWImX79kWWgEudb6ooaxi89mR4loBf5jK7pBY/fCQvXWA
	nczM2VEcAqLhmyCRusJekbtNM6tEl3erx3wyTDKnUt1p7g6xOnFNFL/CyUda/jVGPTMneB
	Lick2v7eaYsBdS1ZqE9dQzuLedihLIg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aM8BVqxwBlUqi8MCzMYu+U803n1WalH75F8EVPXI6z4=;
	b=zedZowA+jZo8g5Mk9tt1TD7mFLXsOJF2YPYbro0FseNfhsWvQyCS+gaS0b2sKcKfiXgd59
	Z/0W4FJpqY+3DuZyXiRGJhi4/exADwpfoYefaM4Xx11tLFnIPiD90lAUnQXDeHQxGaVZqx
	ucWmiF5cmzA+IbrnX0g5e2FpTNNJ5Bc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=S++zaklV;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cde827b7b95so361767a12.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:36:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795412205; x=1796017005; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aM8BVqxwBlUqi8MCzMYu+U803n1WalH75F8EVPXI6z4=;
        b=S++zaklV30x2RCeOVH33gylLJPltTDbQFdBuuFfGf6UPUNpL9K2o7frcPZepJfsrUR
         6jkpsEXkuaoY+z202CQPRwCz77WkAetQKEDa8TiCqoXwhFxRsalIozAowwcoSp84u+rC
         CxDCYHgGwJ58PBQPdwCJ7pRrJUd083GqqztnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795412205; x=1796017005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aM8BVqxwBlUqi8MCzMYu+U803n1WalH75F8EVPXI6z4=;
        b=W+iZNeLldFJjohmAinne+3juEfVFmmaLGRwbzdgRqOFTdlV4PwE5lzy9i449ow0uK6
         gQ3HnL0JriQOGHgTIJ0TXk4QpZYMzSRcjR+CEmzQX8fEQNv6HhWXjYoFNck/yit6XYN4
         TxqPZwXYuzqMQzCkph8tVIdL1F/0bkES+oT7akKMP4cW70EL+/rqUBFjjQVceLhIwmT+
         lPHJtpne3iPB1KulRYHFQI1GltV5b+M60NjlM09NSVin/OEXyW5Zmb6qZfLyZXH1TNNQ
         dfA344sR3U1gVnbZDC14ExuXbz5TwFp9v0RhwRcSu3M1D8mGRvI/+VZ9HCDy0X3RG4Af
         Ks5Q==
X-Forwarded-Encrypted: i=1; AL+hErE2YEJBGtoEev6nBbfcdX32AOlvJy1caFcJoG3/XqJdVHFIwQEU79Lx/BUi2LpYSpMK/UJ+zsp9Jw==@kvack.org
X-Gm-Message-State: APuU4Z+bzgxYFCPWXyomUWYpjEa1yJ1+8EGyUNd/YfAY5D7VuqAwallU
	VGzTl3CDmXxesJL79PHGQERXBGwhfilO3+AifHtIDHp8xCHboUgd2WWLxxqpVZ3CzoiVRwRO9vg
	g95E=
X-Gm-Gg: AZFdTZcIQ/YKpOI1ZhgXI+Rsfjsaf/bGw29whO9LJC/FPfvnnKOxQvsGTIozSwdaliX
	JnrhGK2C7XQmlU6NeH01adQzXl691rDBiBpKTDPd/W9bzArOe2QVbQT00lUogvcKV9UfI4SfZai
	rCxaPfcN+0jWoIbELZTKvFkTmDVCeGwxD9es3gw51MgruWylNcbXkjqD8Ypzii93bSOq80AR2rE
	7iUdMzVOc/Slaym8pt5B42oGto1+XtHQvnF0edDj0/Db77k+1CUElU+nUd/ZvcKqoVIl1dgP98A
	s/wnmjlO5+AnwB8Ujw5jOuEakikpBRoccOaWUS8wp8TnIMPr4ETCTmNDZnJHSczYt1mDZY9QOLx
	jUgZIHnbhFucy9bfR7TY1YT30pGTYjWQ+U7k2L7VAwYULv+8tekbAK7Okpsh8nrRQqvF63O8vu9
	Ty5W/k19UDr2C7IEc3MfP6bLaaxzMJBbyjMTYfdgR68QQV5dDz8zEtLWUY0amTCCweuWxfdvTkD
	H5uzy340dUEj4EFN1HyiXnU225jAX9b6lnw9pNjwsuTOEyYxQcEKYBWzZu9qcRF/tL0kdT1h0SJ
	A36aY3SoE/klUM+9+HmLlc6+kYYKBTm7ckuARbm2p4YbUG4fD8ckwYCzhg1hJYM1TXXqm0xLAyt
	vrewx1kgYTOYorfziZQ==
X-Received: by 2002:a05:6a20:d10f:b0:3eb:9c9f:8b8e with SMTP id adf61e73a8af0-4014e74d04cmr9200842637.92.1795412204728;
        Sun, 22 Nov 2026 21:36:44 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:d8fa:c511:e415:e0d0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cea7c38sm4636531a12.2.2026.11.22.21.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 21:36:44 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Hongfeng Chen <hongfengchen@xiaomi.com>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 2/2] zram: keep the hot statistics per CPU
Date: Mon, 23 Nov 2026 14:36:25 +0900
Message-ID: <cd96ecab2cfbb9a50a0b5141c09f9fda086780a0.1795412161.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <a74aca7a3d27333972782b29786c7b33861a56f1.1795412161.git.senozhatsky@chromium.org>
References: <a74aca7a3d27333972782b29786c7b33861a56f1.1795412161.git.senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EB6A680009
X-Stat-Signature: d6f69x9butpk8a47ttgygpbpxutrozra
X-Rspam-User:
X-HE-Tag: 1795412205-171476
X-HE-Meta: U2FsdGVkX193aQkX/u9g8Ey0FMlWc7v9Vvt3Qy4j/eVXLDjuaui1TD8qjeqnlQt/39kAdY7/kebya7atj4FIeoxEcsdb2KXUVxcn1NMtu6T833j2w3GxSTk16PNT+7oH2NQfzwf7suGlGGJ6Esy9LRUOar6s+PZrob2TeEagFQotA3IHBZqdN47HBVFiLg74NpCfdudZz81w7JXRb2lRfVaWJPVVo7LoFAdEPndoGKNcVdmElVeIThjUvbYYOvaZx2cqgowBACD1VH6neB55JgcOL1TX+c7GSr0uV9fDG2vO26mDh2Xt32RNA8ZIhkNftawSSVr5aJiAv50htcV97QyOaRsd2Vr9gW0DawHakOcDDmtSHTZ7H+LxnxCbkJ+ovPadY8MFbHIXa1OJ9f+LMme1e/4qVKhIb5YHN7K9qJaM/0HgaBZT7knfhab5wFnU5M7JgI/7Djfek0VqE4f1aa5vVMvuIj+fsP2p6xbpHEk0mrsnuAqfvwpC7bGOYdMxEWQGDyIe2qqM1GUJqVw9467lXcqOyYe/dZVPXhYmupPmy720xiw/ZQK/zcBDDB8JQ677pQYrFGc0q1yNQ2sQLTxkFCxVV/gqi2BgIiIgBuU11GExhU2GAICB2gHPGhtKOd0TB79pitOeor4E7smc9lwkm8aj27MNSNzaHhpCTVLwTd0hVCRpc8b9CVsADijIu6wA1bJVWHIqyNypmRZ8AXfBAJK05O7JQqWvsy83THwW7OBm3aiAj4JhlAtZdAhIl7aHv958a2ibGgIMUs3bdFHg8QsWEwTUIUwBf3uwWu/5rKmjmsY7XapJT5YkPe0PfHBp+Ke08SJV/zuM/GjikLvRjCYdySAIWqBUqTUlU9/8IUswJ0ybjFStgVGVKWj83eobbJeMiRRh634KZMuW3MHuGKC37CRphiXa2FuT0nKWZekeh43S0JrLLZ9Hz2/jS1OgcDGlgHmKkpQ1zBj
 EchmqZrl
 mH0xOEWHnTSGFQj6pPJ9+UisGEpJHaXYXoKo0NE3Ns8MaI14FeLCQG2mIY1kSS2aQbJJV8NUiZgyY23cf9DQWPvGQyTGxL/tI4uxHEY9y6PGHh225sZpLCsffXmPOgF0I9SQf85Xw7fJFcNtYNDAYOzQyu5hyz4lHz15LcldVQUyeUTdjIpZ20aZbRNxnRDEMX7C9a5fps8QyqfWYNEom53UmPxoI0OE87DnjToYkflawVhBWNPssut5r8lwPZjI54zecLesd7Z1i3Toaw3eMEokkQmBLBBK0/VoO/nWAESn4o7iJkST2aKlaBPIMdSTzE++VD/VpOeAWXCnGHk4+ib5cnqS9RiHcQNZR/pAFNLA/XcP3uMHrfgMwbHWsRyyIwh8p8687wlz2X911OTqh2waR9Da2RxjmtjJkUGmF00AT3HGz41IOQaSvXSfkBREtNjOi6KnOTrstIpVTeuPxet+YwsRRI5fuRSK8zKZkF59o2DcpBBk237Rb16uAA0wIbHq9Q6krTRac+rOy4VsKaeIkFPNGVdcVD8QhbFaRLsi8x50fBj4rwnkKK/4iBxoHmlbWhaQ/RMHpoVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When several processes free swapped out memory at the same time, e.g.
on munmap() or exit, all CPUs update tpages_stored, compr_data_size,
same_pages, huge_pages, huge_pages_since and notify_free stats, so
the cachelines bounce a lot [1].  Keep the six counters per CPU
instead, as local64_t updated with preemption disabled.

munmap() test:
                  before     after
  4 x 256 MiB     18.69 ms   14.12 ms   (-24%)
  8 x 128 MiB     14.82 ms   10.09 ms   (-32%)

[1] https://lore.kernel.org/20261017031542.3504947-1-hongfengchen@xiaomi.com

Suggested-by: Hongfeng Chen <hongfengchen@xiaomi.com>
Co-developed-by: Hongfeng Chen <hongfengchen@xiaomi.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 108 ++++++++++++++++++++++++++--------
 drivers/block/zram/zram_drv.h |  26 ++++++--
 2 files changed, 102 insertions(+), 32 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 54eb691f1409..951a38caeb93 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -95,6 +95,47 @@ static void slot_unlock(struct zram *zram, unsigned long index)
 	clear_and_wake_up_bit(ZRAM_ENTRY_LOCK_BIT, lock);
 }
 
+static void zram_stat_add(struct zram *zram, enum zram_pcpu_stat item,
+			  s64 amount)
+{
+	struct zram_pcpu_stats *stats = get_cpu_ptr(zram->pcpu_stats);
+
+	local64_add(amount, &stats->stat[item]);
+	put_cpu_ptr(zram->pcpu_stats);
+}
+
+static void zram_stat_sub(struct zram *zram, enum zram_pcpu_stat item,
+			  s64 amount)
+{
+	struct zram_pcpu_stats *stats = get_cpu_ptr(zram->pcpu_stats);
+
+	local64_sub(amount, &stats->stat[item]);
+	put_cpu_ptr(zram->pcpu_stats);
+}
+
+static u64 zram_stat_read(struct zram *zram, enum zram_pcpu_stat item)
+{
+	struct zram_pcpu_stats *stats;
+	s64 sum;
+	int cpu;
+
+	/*
+	 * Other CPUs keep updating while the values are added up: a page
+	 * stored on a CPU already summed and freed on one not yet summed
+	 * can make the sum negative.  Sum them up again then.
+	 */
+	for (;;) {
+		sum = 0;
+		for_each_possible_cpu(cpu) {
+			stats = per_cpu_ptr(zram->pcpu_stats, cpu);
+			sum += local64_read(&stats->stat[item]);
+		}
+		if (sum >= 0)
+			return sum;
+		cond_resched();
+	}
+}
+
 static inline bool init_done(struct zram *zram)
 {
 	return zram->disksize;
@@ -944,8 +985,9 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 
 	clear_slot_flag(zram, index, ZRAM_IDLE);
 	if (test_slot_flag(zram, index, ZRAM_HUGE))
-		atomic64_dec(&zram->stats.huge_pages);
-	atomic64_sub(get_slot_size(zram, index), &zram->stats.compr_data_size);
+		zram_stat_sub(zram, ZRAM_STAT_HUGE_PAGES, 1);
+	zram_stat_sub(zram, ZRAM_STAT_COMPR_DATA_SIZE,
+		      get_slot_size(zram, index));
 	zs_free(zram->mem_pool, &zram->table[index].handle);
 	zram->table[index].blk_idx = req->blk_idx;
 	set_slot_flag(zram, index, ZRAM_WB);
@@ -1927,7 +1969,7 @@ static ssize_t io_stat_show(struct device *dev, struct device_attribute *attr,
 			"%8llu %8llu 0 %8llu\n",
 			(u64)atomic64_read(&zram->stats.failed_reads),
 			(u64)atomic64_read(&zram->stats.failed_writes),
-			(u64)atomic64_read(&zram->stats.notify_free));
+			zram_stat_read(zram, ZRAM_STAT_NOTIFY_FREE));
 
 	return ret;
 }
@@ -1949,20 +1991,20 @@ static ssize_t mm_stat_show(struct device *dev, struct device_attribute *attr,
 		zs_pool_stats(zram->mem_pool, &pool_stats);
 	}
 
-	orig_size = atomic64_read(&zram->stats.pages_stored);
+	orig_size = zram_stat_read(zram, ZRAM_STAT_PAGES_STORED);
 	max_used = atomic_long_read(&zram->stats.max_used_pages);
 
 	ret = sysfs_emit(buf,
 			"%8llu %8llu %8llu %8lu %8ld %8llu %8lu %8llu %8llu\n",
 			orig_size << PAGE_SHIFT,
-			(u64)atomic64_read(&zram->stats.compr_data_size),
+			zram_stat_read(zram, ZRAM_STAT_COMPR_DATA_SIZE),
 			mem_used << PAGE_SHIFT,
 			zram->limit_pages << PAGE_SHIFT,
 			max_used << PAGE_SHIFT,
-			(u64)atomic64_read(&zram->stats.same_pages),
+			zram_stat_read(zram, ZRAM_STAT_SAME_PAGES),
 			atomic_long_read(&pool_stats.pages_compacted),
-			(u64)atomic64_read(&zram->stats.huge_pages),
-			(u64)atomic64_read(&zram->stats.huge_pages_since));
+			zram_stat_read(zram, ZRAM_STAT_HUGE_PAGES),
+			zram_stat_read(zram, ZRAM_STAT_HUGE_PAGES_SINCE));
 
 	return ret;
 }
@@ -2045,7 +2087,7 @@ static void slot_free(struct zram *zram, unsigned long index)
 		 * ZRAM_HUGE flag for deferred decompression path.
 		 */
 		if (!test_slot_flag(zram, index, ZRAM_WB))
-			atomic64_dec(&zram->stats.huge_pages);
+			zram_stat_sub(zram, ZRAM_STAT_HUGE_PAGES, 1);
 		clear_slot_flag(zram, index, ZRAM_HUGE);
 	}
 
@@ -2061,7 +2103,7 @@ static void slot_free(struct zram *zram, unsigned long index)
 	 */
 	if (test_slot_flag(zram, index, ZRAM_SAME)) {
 		clear_slot_flag(zram, index, ZRAM_SAME);
-		atomic64_dec(&zram->stats.same_pages);
+		zram_stat_sub(zram, ZRAM_STAT_SAME_PAGES, 1);
 		goto out;
 	}
 
@@ -2071,10 +2113,10 @@ static void slot_free(struct zram *zram, unsigned long index)
 
 	zs_free(zram->mem_pool, handle);
 
-	atomic64_sub(get_slot_size(zram, index),
-		     &zram->stats.compr_data_size);
+	zram_stat_sub(zram, ZRAM_STAT_COMPR_DATA_SIZE,
+		      get_slot_size(zram, index));
 out:
-	atomic64_dec(&zram->stats.pages_stored);
+	zram_stat_sub(zram, ZRAM_STAT_PAGES_STORED, 1);
 	zram->table[index].element = 0;
 	set_slot_size(zram, index, 0);
 }
@@ -2246,8 +2288,8 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
-	atomic64_inc(&zram->stats.same_pages);
-	atomic64_inc(&zram->stats.pages_stored);
+	zram_stat_add(zram, ZRAM_STAT_SAME_PAGES, 1);
+	zram_stat_add(zram, ZRAM_STAT_PAGES_STORED, 1);
 
 	return 0;
 }
@@ -2277,10 +2319,10 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
-	atomic64_add(PAGE_SIZE, &zram->stats.compr_data_size);
-	atomic64_inc(&zram->stats.huge_pages);
-	atomic64_inc(&zram->stats.huge_pages_since);
-	atomic64_inc(&zram->stats.pages_stored);
+	zram_stat_add(zram, ZRAM_STAT_COMPR_DATA_SIZE, PAGE_SIZE);
+	zram_stat_add(zram, ZRAM_STAT_HUGE_PAGES, 1);
+	zram_stat_add(zram, ZRAM_STAT_HUGE_PAGES_SINCE, 1);
+	zram_stat_add(zram, ZRAM_STAT_PAGES_STORED, 1);
 
 	return 0;
 }
@@ -2340,8 +2382,8 @@ static int zram_write_page(struct zram *zram, struct page *page,
 	slot_unlock(zram, index);
 
 	/* Update stats */
-	atomic64_inc(&zram->stats.pages_stored);
-	atomic64_add(comp_len, &zram->stats.compr_data_size);
+	zram_stat_add(zram, ZRAM_STAT_PAGES_STORED, 1);
+	zram_stat_add(zram, ZRAM_STAT_COMPR_DATA_SIZE, comp_len);
 
 	return ret;
 }
@@ -2532,8 +2574,8 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	set_slot_size(zram, index, comp_len_new);
 	set_slot_comp_priority(zram, index, prio);
 
-	atomic64_add(comp_len_new, &zram->stats.compr_data_size);
-	atomic64_inc(&zram->stats.pages_stored);
+	zram_stat_add(zram, ZRAM_STAT_COMPR_DATA_SIZE, comp_len_new);
+	zram_stat_add(zram, ZRAM_STAT_PAGES_STORED, 1);
 
 	return 0;
 }
@@ -2711,7 +2753,7 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
 		slot_lock(zram, index);
 		slot_free(zram, index);
 		slot_unlock(zram, index);
-		atomic64_inc(&zram->stats.notify_free);
+		zram_stat_add(zram, ZRAM_STAT_NOTIFY_FREE, 1);
 		index++;
 		n -= PAGE_SIZE;
 	}
@@ -2804,7 +2846,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 
 	zram = bdev->bd_disk->private_data;
 
-	atomic64_inc(&zram->stats.notify_free);
+	zram_stat_add(zram, ZRAM_STAT_NOTIFY_FREE, 1);
 	if (!slot_trylock(zram, index)) {
 		atomic64_inc(&zram->stats.miss_free);
 		return;
@@ -2845,6 +2887,8 @@ static void zram_destroy_comps(struct zram *zram)
 
 static void zram_reset_device(struct zram *zram)
 {
+	int cpu;
+
 	guard(rwsem_write)(&zram->dev_lock);
 
 	zram->limit_pages = 0;
@@ -2857,6 +2901,9 @@ static void zram_reset_device(struct zram *zram)
 	zram->disksize = 0;
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
+	for_each_possible_cpu(cpu)
+		memset(per_cpu_ptr(zram->pcpu_stats, cpu), 0,
+		       sizeof(struct zram_pcpu_stats));
 	reset_bdev(zram);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_limit_enable = false;
@@ -3075,9 +3122,15 @@ static int zram_add(void)
 	if (!zram)
 		return -ENOMEM;
 
+	zram->pcpu_stats = alloc_percpu(struct zram_pcpu_stats);
+	if (!zram->pcpu_stats) {
+		ret = -ENOMEM;
+		goto out_free_dev;
+	}
+
 	ret = idr_alloc(&zram_index_idr, zram, 0, 0, GFP_KERNEL);
 	if (ret < 0)
-		goto out_free_dev;
+		goto out_free_stats;
 	device_id = ret;
 
 	init_rwsem(&zram->dev_lock);
@@ -3119,6 +3172,8 @@ static int zram_add(void)
 	put_disk(zram->disk);
 out_free_idr:
 	idr_remove(&zram_index_idr, device_id);
+out_free_stats:
+	free_percpu(zram->pcpu_stats);
 out_free_dev:
 	kfree(zram);
 	return ret;
@@ -3168,6 +3223,7 @@ static int zram_remove(struct zram *zram)
 	zram_reset_device(zram);
 
 	put_disk(zram->disk);
+	free_percpu(zram->pcpu_stats);
 	kfree(zram);
 	return 0;
 }
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 724f8ce6709b..a3fa6e3d007f 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -10,6 +10,7 @@
 #define _ZRAM_DRV_H_
 
 #include <asm/byteorder.h>
+#include <asm/local64.h>
 #include <linux/rwsem.h>
 #include <linux/zsmalloc.h>
 
@@ -88,15 +89,27 @@ struct zram_table_entry {
 	};
 };
 
+/*
+ * Updated for every page that is stored or freed, so kept per CPU: with
+ * shared counters, concurrent swap frees bounce their cacheline.
+ */
+enum zram_pcpu_stat {
+	ZRAM_STAT_PAGES_STORED,		/* no. of pages currently stored */
+	ZRAM_STAT_COMPR_DATA_SIZE,	/* compressed size of pages stored */
+	ZRAM_STAT_SAME_PAGES,		/* no. of same element filled pages */
+	ZRAM_STAT_HUGE_PAGES,		/* no. of huge pages */
+	ZRAM_STAT_HUGE_PAGES_SINCE,	/* no. of huge pages since set up */
+	ZRAM_STAT_NOTIFY_FREE,		/* no. of slot free notifications */
+	NR_ZRAM_PCPU_STATS,
+};
+
+struct zram_pcpu_stats {
+	local64_t stat[NR_ZRAM_PCPU_STATS];
+};
+
 struct zram_stats {
-	atomic64_t compr_data_size;	/* compressed size of pages stored */
 	atomic64_t failed_reads;	/* can happen when memory is too low */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
-	atomic64_t notify_free;	/* no. of swap slot free notifications */
-	atomic64_t same_pages;		/* no. of same element filled pages */
-	atomic64_t huge_pages;		/* no. of huge pages */
-	atomic64_t huge_pages_since;	/* no. of huge pages since zram set up */
-	atomic64_t pages_stored;	/* no. of pages currently stored */
 	atomic_long_t max_used_pages;	/* no. of maximum pages stored */
 	atomic64_t miss_free;		/* no. of missed free */
 #ifdef	CONFIG_ZRAM_WRITEBACK
@@ -132,6 +145,7 @@ struct zram {
 	unsigned long limit_pages;
 
 	struct zram_stats stats;
+	struct zram_pcpu_stats __percpu *pcpu_stats;
 	/*
 	 * This is the limit on amount of *uncompressed* worth of data
 	 * we can store in a disk.
-- 
2.56.1.750.gf70dc682cf-goog


