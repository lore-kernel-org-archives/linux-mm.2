Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0EB606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=RbIEWnbr
Received: by kanga.kvack.org (Postfix)
	id 552A76B05B9; Sun, 22 Nov 2026 22:11:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5297C6B05BA; Sun, 22 Nov 2026 22:11:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43EA06B05BB; Sun, 22 Nov 2026 22:11:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E77E46B05B9
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:11:35 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C5081C41C7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:11:35 +0000 (UTC)
X-FDA: 85464908550.13.848AAA3
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id 25DDB80002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:11:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RbIEWnbr;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795403493;
	b=qzOPNRIc0cd/MXlX+WSPvR1MyPY3liy4QO8XZujuwCzQ8Sw3pEU0ZjpdQfFZ7qReh3jHS0
	eG4Mjf745xwVUjFW2HZrpwCslop5YCK2C707z9MadDoU/KUVGTihwKzZFkqKHiL4lPZQHf
	Zej0CMZW6H7dzOBoqcjkWtw/V6f63P0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795403493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvtnSnE5peADa21KmqwR0vubKial5w3ayVcoJT5lazk=;
	b=h6vLLKnaNkIMTlP14wlwKqMptHOkyGzeDuJBunHBZQgwXnOQftwDSyoINxcPZ5pfn8Q2H+
	vf7aGLP8CIdyCe54HCjgEKe7K4VbzHTyYqOWL8uQQ96YFfyLlOQzkjRhNzg5yASrFx1Fyn
	WRC/EpeGGgJZuyn36n/BHIuiTyF+vHk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RbIEWnbr;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b405d8f1cfso1297777a91.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795403492; x=1796008292; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gvtnSnE5peADa21KmqwR0vubKial5w3ayVcoJT5lazk=;
        b=RbIEWnbrjPue50WwbH9hGX2DLmjbPljihyB4l3pt7KgJg2GIfqigEpQaqjIsCbXpjw
         WLhWzVj8Q88ezPVd8BNbPW26UPbmtjyuj7NbDTIYf4hDyU/pMWg0i2NcQeARfYOEkQ8k
         ZpC+hdc345qImHJNIk9Dp3Lodghe2KPipb2Sc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795403492; x=1796008292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gvtnSnE5peADa21KmqwR0vubKial5w3ayVcoJT5lazk=;
        b=Z9c7vJFxZW1TzGn7BVOguh7Qt6hb9vF2Y2UVST1T51OHmRKoqpqQNkcDzs6NHdX4jO
         710dSUL9YFu2OpyHousY6vHqO+280tyhLhf11MajNbeykD3xn51BERopWkdFR8s9VTY5
         WYxHrZRh5/RjgXuAyMSYU/ynviOIIKcLBLOOKSmTHnupRxIfafEVuUqtkNJTkEyOG+S9
         AJ6TraorcSQCD29YVq/C9G2ixlaK2AHfC58KrJVbDdIVafEUIML/5iAjdIULlycMHBox
         hEPP6QLDGRtacG2B+iwuqPH8fqroe1js2wpztMyMqz3auIJD/6bwJiUmpqFcwKBV60B/
         Kzcw==
X-Forwarded-Encrypted: i=1; AL+hErEaSTzEPs3ZA8OBDbvzZd0OxEeB6GIw8D9UMcnEtY7gjCnNXVX5Z8CwAiAnICwkrP3l27ZyPsxSxA==@kvack.org
X-Gm-Message-State: APuU4Z+MBL0X5ecZKzXVRnTJzJGolgths6eNyL+D9IrAD4VNraaeDAY/
	AFJze+N79TMxtcbKXMdHcHzJTvPTmHa2Ef7xnjH75yEy5pFWByDrUPK2gUejaevRvw==
X-Gm-Gg: AZFdTZeeowBvH8YFBsXYvcgGnc5/XB09rd0SNKVThRha1J2NZz4uqYFfn+XzAtJgdTW
	rR7KTYgRkfyA94/p9jaJpMAQ6hqdTRmOmfpnWJnYvVltVXj9YBI/s9S5DIt0MM4Z3uNidjaTG82
	UuvCEqwwC/Zvq6enf0YPu+jkuOiFL93m2INm7jJnPziJbB82m1FxjjKXsX4JyJgT0k4zfBkxkKI
	FGfjEGV1oU4LMMRKedTHWDYGPldM7IF00Gtq4JBUWmHalNgGB7Mozvt4lJaXFMeS6zbUuWMhwH6
	Kd/FoTXySe37l5Rbu0CRSrp2y/5gHjqksmxLF9I7ghmofDLyd+sYxUQhKLcSYZNXgmSMhZeY8uF
	SOH66wF/0ojl4yoO07ZsUhphha359qdz3blJ1+px5n9GpdpU18/33qVERpATE7ISgVOUxY/uWWK
	sB/YBDzSqi6j/DmMCbdbMU+oamsEtUVDw9wK7S6okApYnKRCMMwSq4tjxBrUIvico4eH3q0szyw
	9hNMESVv7LQi6eO5aqBwnLqxzFTyivli+VPHbMhe/6S9T5OeYqXKqEGVFV+GBSGQz/HBKESw07B
	2j+73nDTpiOgpbI3e8NvT8zBDif+Ch0fGQbNgnwZQfqG7mhUk3SHmrlLRq7HbDCobhh2y3lYRj7
	HFNL7Pp96h6jEP+k9S1Kp8lvi1dNZo0TWlyzPCY0=
X-Received: by 2002:a17:90b:2cce:b0:3b0:9a1b:b709 with SMTP id 98e67ed59e1d1-3b41c95f64dmr9997359a91.54.1795403491842;
        Sun, 22 Nov 2026 19:11:31 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:d8fa:c511:e415:e0d0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad92c13sm15330240a91.14.2026.11.22.19.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 19:11:31 -0800 (PST)
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
Subject: [PATCH 2/2] zram: keep the hot statistics per CPU
Date: Mon, 23 Nov 2026 12:10:59 +0900
Message-ID: <8f0ec29c0e4230d10db088d29f79bba17c3ee6f0.1795403342.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <5666c1c8c04998784c81fc8fe751e35aa40af578.1795403342.git.senozhatsky@chromium.org>
References: <5666c1c8c04998784c81fc8fe751e35aa40af578.1795403342.git.senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 25DDB80002
X-Stat-Signature: hu74yojftnt6ioktybx5qm8me6tg85b5
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795403492-974449
X-HE-Meta: U2FsdGVkX1+jpV639Mmpso0xfshO3VBlAx+GXOMBM0fnelGfVe6DwM71VfnecmacdRPjjDOfQmjNHh5CdkndDe0kXTjgNIPWstc6gVB4aB4qn0BTPAUbYCoJcn+rMofYZ33LTVe1+5riv3iTU1bFSsM3PNKMKfK9RLZYEJMmt1waxu0/BXgEkrni9ARsSppFmZI9xIsGjG53FmZfL4nQ59bVFI+q2/z3luCXtXbosrXTlHPk+wPADX95T0ukNUC3j3/zlYIb5awO6uvz9N3obMcZ0gMWqsXMpTOgpVz502syk6genqaWdBwtM/wySqmcqM1G6d7Pkab88vel3NVfSDh1rR2+4I2x2fbsKUx5YyLF59tVXg2q92+htHo8cyhKixWp7GSV/AMF761hZGI8dj8neafE2cFyo2hYozojoTCHWn3j5INxAApi3A0rzdUrdqLiXcjVHMR03T5C2rnLMKeeqIFPsrFqAl/WGFEwoOaCrpveq4j+L+nlQ4KVamTJEED3RUdmubVEhRwFymlv0hNcV4T/5pqFW2Mu+YICfNBqNzMLxyx3WFz8V4DZkOtCtpm3K+lHcki50IdL6bCSs3Kk0L6Qh1n/AlFMGB1eDrcJhdMZ+oyGToJbhq69eFzX8f5drQN7AFTR8tVp8DQyxVwlFSFiSrGz1fmLhTP5SFbmL6rR6i9sjHSHbFTLAJstF2V7W8ZpVDhxsNyI3+ONafg8DdUKULdZRCVl+TXohIRW9PMZ7ifmtoFYiPT8StyfvqxSaJ4yHhxCvmqztL9ampHvahxQeMHMCYmdRB4EZ8K50UoV89yC3paltDyidFjcC9aRR3Lc8BaOGX7Tiadm5AP1ox4Bf26zqt2OLDW0s6KJYRIPcwSZzfDM4+KBz4w64y7Jeene/fCDBHI/8NbBzZMZSaVuXcqKNvbErobzP6uSXpJKkA1HND0wH3QJYJVDL400BPqLo5uy9LgCRU+
 X/vCxlb6
 U60peiwNqmMCBY/occybpo6KkYF/u+4vlpQMT+/jFdn75bc66G/JjNyf0JBhAXEhA3aNCerrhASq66E3Q3FmgiY4oc55tBo/q7TensU1GLW2N6Pevi4bKcjvB6GufH2roSfCMMw8YSQPecaP7WE6vmcFx8w3EZo1o+sHnnJZhY9xZWWVjYiTq02RBKIXB5v+ojzsPCCaP4UC8Q0RnJnWQHlMIUAGnt9S2N+UA5399rgix27fYrSlfwA1iH6WBg7dLIjqwEH7jsmuqSh5MnXsC8yRSvi7LdVUjpi9tr1hGwE0g2neRQqnwBEBX+l4Xuy7NSj23Wtonem+D0GmJk6TdjNIkTUgod0o3Gxc1tcrU2e2CMXVrs06zFNRGfSJ7cKdUH+ymd4rVi8LgrUdDx5cwRrTuJMx1HUGjTbGqMrVVz3IsAQ0fELgyevOFdg1DVNJunuvFCVrbsl/ZmPypLYrMq3WUKFWnMTG68D6l4wcLUFj63zM1zk5RQTm1olncjaoh9hTwFsYKmKQ5U4ByxcBYHRUiylI30loRsYGQsAvDZJF+YncmWJSOl8DW1OziaZ1F/T0g
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
the cachelines bounce a lot.  Keep the six counters per CPU instead,
as local64_t updated with preemption disabled.

munmap() test:
                  before     after
  4 x 256 MiB     18.69 ms   14.12 ms   (-24%)
  8 x 128 MiB     14.82 ms   10.09 ms   (-32%)

Link: https://lore.kernel.org/20261017031542.3504947-1-hongfengchen@xiaomi.com
Signed-off-by: Hongfeng Chen <hongfengchen@xiaomi.com>
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


