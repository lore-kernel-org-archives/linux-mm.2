Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2ACE606A682
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=oBNKNNqp
Received: by kanga.kvack.org (Postfix)
	id 5D38E6B05C6; Mon, 23 Nov 2026 00:48:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9E16B05C7; Mon, 23 Nov 2026 00:48:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C0B66B05C8; Mon, 23 Nov 2026 00:48:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 167526B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:48:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D06CAC064A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:48:00 +0000 (UTC)
X-FDA: 85465302720.18.ABDE07C
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id F199540004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:47:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=oBNKNNqp;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412879;
	b=6rtMKtHi3+qeoGbEIjz75xf5dDUcgzhFVjYKJzfvaRBduI4Ah7GmPwTreVZ5vek1L9+dd8
	ykG2Ju2wenLtfUwQuFzVVEYke8vgP5zfzP9sOvaygzx+ktXm9GgE8Sb1WDX2AQm+0I0kH+
	eIZ/Ojl//S28Aqs/MeHLHGBO41GbEac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHVBusMJtgIHiAajWwbmDUyt5sZhsFSWPp0kKpvldow=;
	b=TL28WLLffNhW9Q2VnmlL+anWNuxS/IpkwYKdGKpMuIwvlwbvLnGQCJhM1ssgO1U+2Y34tM
	MusoOFqKj6+RWpKxT7Y0H6SQ2UjEpohhhmxAkLmGsplwWXNa6rUWgg9bhMB+tJfxSsfR0c
	mrqS6by/KySe7gChGjoXrAP2VtJ9XMg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=oBNKNNqp;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf01.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.42 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3b08cf16decso1582793a91.0
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795412878; x=1796017678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NHVBusMJtgIHiAajWwbmDUyt5sZhsFSWPp0kKpvldow=;
        b=oBNKNNqpgj609uBqENWKdz7ML2Mhrm2i4tT/PwMUIce5IG8wIuRjxUhzY1xK4y75n5
         gbaJhwoaR1qlqZnnbBJ7DoA7Lei6d1eeub+LKa/vHEsD5XzQJStfwH9Is4dSZ/KorIYx
         vUNREu/Bc+6rK61Nj9BkpP5HbKGwqQvXWa1ZU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795412878; x=1796017678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NHVBusMJtgIHiAajWwbmDUyt5sZhsFSWPp0kKpvldow=;
        b=xjnfRWRiktAXBBBNjUt1CvKGyQkiuAfwgn45mN7WuPUf7oA7vGuqI1/SXgZxr7bA22
         ar15gFMXIP4omy5yyQ9c7qIlAqJxe/nG9EUA73nDtabWBu3Jr0h36OjVnTsv95bWmXrp
         bfaNot+/F7hYvOHhG0ZnBJePB5pSJTx9OV02uKPy9nNcF1FSW5EP6ods+hqp8JTOnRXG
         X+dui8cd9bYefwsd68jz3sfcXnQh+vzXx8UXGmzHhlAfkNxx/SFp/nO/CXuZAseQL7UQ
         0xiNxFDWK0MncIqofqH/eRwgxGq7gR8xyib8U+7RiERXWnnLJex32i8OXoVZkIgBtZSO
         8mkA==
X-Forwarded-Encrypted: i=1; AL+hErES2azPz7MF4b8J1zV3gmBW1YM3VSjtuqc5hh311Tn26tmyJzPJZ75lTu87WcGe+0ECpHcb1wk0Og==@kvack.org
X-Gm-Message-State: APuU4Z8JEtn2TCDfwUAt02XuTBnMDuU645sNhJfOfq0E53xxk8hn3pIk
	bYVDoMumREmhGnLqTaYGylHpTlwAKA7Y2N7TYDbpuIqiC10RIyhZez6JN/zbnbGMfw==
X-Gm-Gg: AZFdTZdAaWvtGeYQVUmOoCmdj8c+2h1Bz9I9ifaGL2Gs0Jn6DAO1f/Lulfpsmbz33/P
	Ixwp1VD5e+IiLwUoliu7ifr1npzDGZeohELwcad3rbV/zkQBBbfRNkJ/pKAt5BXUPIcfnNbD1in
	wkBir//10mnybjDU5QTOa0ph+FY1KnjutYMGmc00KdCtBnn5GzE7lqszemU3aCyOa2OSEtk4HYb
	daeKiOW4pKkDYwVFgWeHF5g+cPJ0zYv2QybbDmX1gUqiR0oom+IOLaaTxwSHpWov+EQFi4wyBtn
	Yt1GzG+C9V4IBOhoBB9vURY50zCcwZgKqdI35Q9oWbhtpQVfxB/C93FJY5hghKxeq3w2JV8+KU6
	jIKbVtVgzxNltbcimSPdn8sTgBNUqXf0ZdpBAVLcXyGrUYL7iNSalgPk0MNJ2kc2Vj+40GMZRZA
	QA9fV3NXpI1FvkgpiRPSaAPvFnjjBfQasdXhxGUR1BLP+VCCi4ng6Y/LqmRz7X0Tv7jrEOVNZTZ
	E5ftY6vHptdOzhjn7GYZbCRKasBSTrBoIXo7WF4pDNe5vsZx1vyUaP/wQsWsxay7Ahel2F+4p0U
	eDWwJ7DbZQI62mW8hVe0OhhpA2LqZMYCStgmIMF5LyKbIIvEM1V4JOd5jb0vRDbc1mtsmPEvD/J
	/z1QNEcFbvhKXnc6KlA==
X-Received: by 2002:a17:90b:1f91:b0:3b4:1cb1:e7ae with SMTP id 98e67ed59e1d1-3b41cb1e88bmr10806557a91.45.1795412877665;
        Sun, 22 Nov 2026 21:47:57 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:d8fa:c511:e415:e0d0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad92c07sm16240267a91.13.2026.11.22.21.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 21:47:57 -0800 (PST)
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
Subject: [PATCH v3 2/2] zram: keep the hot statistics per CPU
Date: Mon, 23 Nov 2026 14:47:37 +0900
Message-ID: <20261123054746.2579253-3-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123054746.2579253-1-senozhatsky@chromium.org>
References: <20261123054746.2579253-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F199540004
X-Rspam-User:
X-Stat-Signature: u6cqeh4wx4ciotp3syca3ni8o9ktyc4p
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795412878-723805
X-HE-Meta: U2FsdGVkX192KNFa1EGGay8CvbXDLtdCO22i25dz9+hPxDb+BlqiOKQO4wPlAwWWhNpFVnbYDQ+Df09ytl/3R9fK+K0uXY36kOLq/J0WA0Drq+BBgatoOd2EHEIyEZC4dBu35fX0oF+DGyFeRkz08RZNjJMWpSTCyrOAxUQRVrs7zatoLvMCi7geQV94NSmdR1m59XLQp3ivVnOjTVWHQNQcz8sk4D46kfdFgrEUR36p9fF5iE4yq5kWRPj/Uj7kND8F0/44+KpC95q4WXNQF/46cd/fNLDXLf4q/Xe++isTCSwCp2UpMVCls6VHRAuodzkk4BHANpHz3YvzQUs9Lt7aqLiDMc9XPUYQlOz/1/KQ249vfW4CmaDu2C9eG/nq8Nnjnpjexe91UY2c4bDpTAuxxCiGcbqicdsrCXPfotW7jeio/uqBCjKBidlpcVKQU+bXvs4S6bOpKJbx4U2DVBsTgiQMT6coSTE15wKEgutgccyMsAiwNJkd9U32jLg42Pxg4emK6ea1H1+ImoEhCCPgFnDdffu7WxE9P4hBPUigh3sCeff9TBgSqmKy35ucDQ03WKJ8Bj1gkmCkVzCEzFoMoyMQ4b7eXfNsHMvjQhEfpO6Uupush0i/xdJmfLMS8mB3Dfp/jqfN19MwHUDJkXx6cT3UVWWyZoPRrEBMnQFt/VUZvp28pBVuozpKbiW7NbIoJ+jKpyl2X/dFHQ9a7PTvAR8g84lgL0fJ7VOIwqk2Fn+kuWsJ7xnlKLxUpLjD30ouJmCapfgTmdpRwCDVo/AnGXM8+63zO4aLDix7LLqjQBy7U2LMxyb1sc+SezqBaPfY/MOYCV1SCCU43vB8B5StwbkA9i6VxjsuvIiHotGMFtKp+/bxsoY91jlix1zAOtgLLhykfvQQg81x2Ydsxtr5S7hJjN+XrXG3H86ZEhixzK1//Nz6gxN3Nkja7s4wL5ziMiuxNaxxXR4tpFr
 1Nf151dR
 SpIp0EASJHk0Ajoxqh/7H4tsGq37di5QT5RPPM9F5Gfc1rlRdcGADIaZcn/JgdNtIOA/kc5wWY2ISPuYR9ePEsGetE9GB7Kun95omq1K/l+Urw8nTbmeJe8Sm2F8JturQMgsdX8aFjW9rN5RMrp3HkTSYA75o9/MBWGhYOajpfiDOLxbdAp6RPo0ks+EhKeskxttT4PXlUjMtf0Jpd8Jmfqp9NbaUPhRYhbo/ItssxDT9F+xmuGKtddJptSFLC7Ef4Tk/GVZZJytm4Ny5YGOwLS2Ws9qHtyJSsPTl9Lce2/YZ7bIl7qaBIUDwdhodFmCUO5CfVNJnEuKAkw//lVVyAvl7flpsLng2nMIu3+Lupoe269AZLIEFmTfClvm8ACOqt7jF4I+oPS205h3SsYgruhCD4XInu2cXOl7kEyuVW/mlxjZcayWUyHHtwdfEQIUKqKwtFUaqhILn7ObmwhDy90+BGLqwV29rCmINZPe3Q01UYLTT2agZ7FOvlbrWvhhBEtKHB+Qcu4kh0z2FnP3c70FtQu5dL0DkTUBplOaMXemfNhF5/1TP9nvkvBs+d2KISysNiojdOrp2gA4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When several processes free swapped out memory at the same time, e.g.
on munmap() or exit, all CPUs update pages_stored, compr_data_size,
same_pages, huge_pages, huge_pages_since and notify_free stats, so
the cachelines bounce a lot [1].  Keep the six counters per CPU
instead, as local64_t updated with preemption disabled.

munmap() test:
                  before     after
  4 x 256 MiB     18.69 ms   14.12 ms   (-24%)
  8 x 128 MiB     14.82 ms   10.09 ms   (-32%)

[1] https://lore.kernel.org/20261017031542.3504947-1-hongfengchen@xiaomi.com

Co-developed-by: Hongfeng Chen <hongfengchen@xiaomi.com>
Signed-off-by: Hongfeng Chen <hongfengchen@xiaomi.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 99 ++++++++++++++++++++++++++---------
 drivers/block/zram/zram_drv.h | 26 ++++++---
 2 files changed, 93 insertions(+), 32 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 54eb691f1409..96b135e3f727 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -95,6 +95,38 @@ static void slot_unlock(struct zram *zram, unsigned long index)
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
+	s64 sum = 0;
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		stats = per_cpu_ptr(zram->pcpu_stats, cpu);
+		sum += local64_read(&stats->stat[item]);
+	}
+
+	return sum < 0 ? 0 : sum;
+}
+
 static inline bool init_done(struct zram *zram)
 {
 	return zram->disksize;
@@ -944,8 +976,9 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 
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
@@ -1927,7 +1960,7 @@ static ssize_t io_stat_show(struct device *dev, struct device_attribute *attr,
 			"%8llu %8llu 0 %8llu\n",
 			(u64)atomic64_read(&zram->stats.failed_reads),
 			(u64)atomic64_read(&zram->stats.failed_writes),
-			(u64)atomic64_read(&zram->stats.notify_free));
+			zram_stat_read(zram, ZRAM_STAT_NOTIFY_FREE));
 
 	return ret;
 }
@@ -1949,20 +1982,20 @@ static ssize_t mm_stat_show(struct device *dev, struct device_attribute *attr,
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
@@ -2045,7 +2078,7 @@ static void slot_free(struct zram *zram, unsigned long index)
 		 * ZRAM_HUGE flag for deferred decompression path.
 		 */
 		if (!test_slot_flag(zram, index, ZRAM_WB))
-			atomic64_dec(&zram->stats.huge_pages);
+			zram_stat_sub(zram, ZRAM_STAT_HUGE_PAGES, 1);
 		clear_slot_flag(zram, index, ZRAM_HUGE);
 	}
 
@@ -2061,7 +2094,7 @@ static void slot_free(struct zram *zram, unsigned long index)
 	 */
 	if (test_slot_flag(zram, index, ZRAM_SAME)) {
 		clear_slot_flag(zram, index, ZRAM_SAME);
-		atomic64_dec(&zram->stats.same_pages);
+		zram_stat_sub(zram, ZRAM_STAT_SAME_PAGES, 1);
 		goto out;
 	}
 
@@ -2071,10 +2104,10 @@ static void slot_free(struct zram *zram, unsigned long index)
 
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
@@ -2246,8 +2279,8 @@ static int write_same_filled_page(struct zram *zram, unsigned long fill,
 	mark_slot_accessed(zram, index);
 	slot_unlock(zram, index);
 
-	atomic64_inc(&zram->stats.same_pages);
-	atomic64_inc(&zram->stats.pages_stored);
+	zram_stat_add(zram, ZRAM_STAT_SAME_PAGES, 1);
+	zram_stat_add(zram, ZRAM_STAT_PAGES_STORED, 1);
 
 	return 0;
 }
@@ -2277,10 +2310,10 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
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
@@ -2340,8 +2373,8 @@ static int zram_write_page(struct zram *zram, struct page *page,
 	slot_unlock(zram, index);
 
 	/* Update stats */
-	atomic64_inc(&zram->stats.pages_stored);
-	atomic64_add(comp_len, &zram->stats.compr_data_size);
+	zram_stat_add(zram, ZRAM_STAT_PAGES_STORED, 1);
+	zram_stat_add(zram, ZRAM_STAT_COMPR_DATA_SIZE, comp_len);
 
 	return ret;
 }
@@ -2532,8 +2565,8 @@ static int recompress_slot(struct zram *zram, unsigned long index,
 	set_slot_size(zram, index, comp_len_new);
 	set_slot_comp_priority(zram, index, prio);
 
-	atomic64_add(comp_len_new, &zram->stats.compr_data_size);
-	atomic64_inc(&zram->stats.pages_stored);
+	zram_stat_add(zram, ZRAM_STAT_COMPR_DATA_SIZE, comp_len_new);
+	zram_stat_add(zram, ZRAM_STAT_PAGES_STORED, 1);
 
 	return 0;
 }
@@ -2711,7 +2744,7 @@ static void zram_bio_discard(struct zram *zram, struct bio *bio)
 		slot_lock(zram, index);
 		slot_free(zram, index);
 		slot_unlock(zram, index);
-		atomic64_inc(&zram->stats.notify_free);
+		zram_stat_add(zram, ZRAM_STAT_NOTIFY_FREE, 1);
 		index++;
 		n -= PAGE_SIZE;
 	}
@@ -2804,7 +2837,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 
 	zram = bdev->bd_disk->private_data;
 
-	atomic64_inc(&zram->stats.notify_free);
+	zram_stat_add(zram, ZRAM_STAT_NOTIFY_FREE, 1);
 	if (!slot_trylock(zram, index)) {
 		atomic64_inc(&zram->stats.miss_free);
 		return;
@@ -2845,6 +2878,8 @@ static void zram_destroy_comps(struct zram *zram)
 
 static void zram_reset_device(struct zram *zram)
 {
+	int cpu;
+
 	guard(rwsem_write)(&zram->dev_lock);
 
 	zram->limit_pages = 0;
@@ -2857,6 +2892,9 @@ static void zram_reset_device(struct zram *zram)
 	zram->disksize = 0;
 	zram_destroy_comps(zram);
 	memset(&zram->stats, 0, sizeof(zram->stats));
+	for_each_possible_cpu(cpu)
+		memset(per_cpu_ptr(zram->pcpu_stats, cpu), 0,
+		       sizeof(struct zram_pcpu_stats));
 	reset_bdev(zram);
 #ifdef CONFIG_ZRAM_WRITEBACK
 	zram->wb_limit_enable = false;
@@ -3075,9 +3113,15 @@ static int zram_add(void)
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
@@ -3119,6 +3163,8 @@ static int zram_add(void)
 	put_disk(zram->disk);
 out_free_idr:
 	idr_remove(&zram_index_idr, device_id);
+out_free_stats:
+	free_percpu(zram->pcpu_stats);
 out_free_dev:
 	kfree(zram);
 	return ret;
@@ -3168,6 +3214,7 @@ static int zram_remove(struct zram *zram)
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


