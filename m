Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58E9606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=Na11z4Rd
Received: by kanga.kvack.org (Postfix)
	id 4AAA16B05BD; Fri, 27 Nov 2026 03:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45B246B05BE; Fri, 27 Nov 2026 03:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34A776B05BF; Fri, 27 Nov 2026 03:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE4D16B05BD
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:28:38 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6B1C580263
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:28:38 +0000 (UTC)
X-FDA: 85480222716.01.C71BF2D
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.9])
	by imf01.hostedemail.com (Postfix) with ESMTP id AF29B4000D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:28:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=Na11z4Rd;
	spf=pass (imf01.hostedemail.com: domain of nzzhao@126.com designates 220.197.31.9 as permitted sender) smtp.mailfrom=nzzhao@126.com;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795768116;
	b=GC2qn7XQiWxWTTHhIlWnWidVP6OLGi8lzlGg31/Y9+zkn0FQAytPVugHQ+fYw+MyfKmOu8
	X5OcWS387RrwJJe2TlkMl3Mzy3MOv8OZ2IbfUa4Qtt2tAPzYZQmfAEkj3EXbjAHt5l+6Tq
	6vKhiStv9WDnzdUiZF63ujcCJXzs/zA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795768116;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNESWvGb/p8QvPX1KB368WqOrHE4U6ua3L78fMFioCY=;
	b=1GqbPYLY4X6P+sf9ii3XUqHpRW1md90Y+F5VWOn91VLm7L5nSa/yV2bpACr9nrByQY9n7w
	KRMH0mqG5ngzbWR5bcjGDQ8aFmGOoHMT2795P/M5zFkVECDQA+TUpkrdTRQm2pSJegjVfj
	D4QBwFd2reWppRq4QPwSho1UUlkWqx4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=Na11z4Rd;
	spf=pass (imf01.hostedemail.com: domain of nzzhao@126.com designates 220.197.31.9 as permitted sender) smtp.mailfrom=nzzhao@126.com;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=MN
	ESWvGb/p8QvPX1KB368WqOrHE4U6ua3L78fMFioCY=; b=Na11z4Rdnwl9QXmS8e
	1efoGbbFTVPBgBQqTT0lkwpM1iGTYD4q+1EhGH/sDKeWu/5lk65gh/cM/mTFTgzY
	ADuhw8PHciWuclvVQbMoHGPMju7QM0XeIWJpCsjyYtHJRZuuWZM806OTX0ZOnFRX
	IS54+HJgxDhLUUS23gFSrfJkY=
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3F9_xPglrbhBtEA--.48132S2;
	Fri, 27 Nov 2026 16:27:30 +0800 (CST)
From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
To: sashiko-bot@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ying Huang <ying.huang@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Wajdi K Feghali <wajdi.k.feghali@intel.com>,
	Bala Seshasayee <bala.seshasayee@linux.intel.com>,
	Nick Terrell <terrelln@fb.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo56@xiaomi.com>,
	sashiko-reviews@lists.linux.dev
Subject: Re: [RFC PATCH v4 2/4] zram: support compression at the granularity of multi-pages
Date: Fri, 27 Nov 2026 16:27:27 +0800
Message-ID: <20261127082728.3624874-1-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-216089@kernel.org>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com> <20261115024455.1465726-3-zhaonanzhe@xiaomi.com> <sashiko-outbox-216089@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3F9_xPglrbhBtEA--.48132S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtFykAr1ftw4rtrW8KFWkCrg_yoWxJr4DpF
	48Cay2kr48XFyUZr4UZws3ur1Dta1fuFWjqryFkw1F9FWfAr93ZFyUtryfXay2gryxCa9a
	qrs0qrZ5JF1UZ3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UkGYLUUUUU=
X-CM-SenderInfo: xq22xtbr6rjloofrz/xtbBsRLouGsJPvJHQAAA3a
X-Rspam-User:
X-Rspamd-Queue-Id: AF29B4000D
X-Rspamd-Server: rspam12
X-Stat-Signature: rc3ypy3n41x85hnc8uwcc8g7mm4gxn8o
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam: Yes
X-HE-Tag: 1795768115-403637
X-HE-Meta: U2FsdGVkX19thUVk7OjQumJt+mqRHrj55W85CN0X/tg1lBfpwQY3HQEQdmEms3bbzKnEI67t6bCJPwPFE/BfcjUmh4jaEizOOroKLowh6ngadqiDz15KL26bNxAb8ZTMDjCituARZTnw7yzjg9xfDDwEeLK10dXpFpu+cDMIZ8XGY+qiFmFFLFgLdfNCQn0LULwipGmBZ6uULBbMWxWhcrweMKtcats13CADp2tkqCH10XzRstSEZdSTkdMzkCfiOqVaXTVYn1zxr0UHvctKBLshLsyRFZtcj6UpBlB8BsN/KitpABrq3OjYaoFVve4d2PgahtiINBrcH+PZz1A0HhNS5Va+ao+yREZLlRKtLSoYjnT6nuOqvLw9r4/ZzeLio0at4ocdFCn1BuFD6JPmIlWqX4W9HdGjvd872ibHGKw8QxZUkZj/Pehq8Fff4+Eui5rB5bIBHuiVtqk8hG5yHbfnmMrmOSXgRi7yT6oDJUpPVzhOB2M55iuzxFdl/ONtETVTG67thY8VywH8r4GsPm8tv0sTFbZHtUIzX0nQs8hTPjyIGfe/MPR2pQoXLtiePgWZKUGIj8Sk/IBAdYDCvP9GR50sVBkES61PLBywN8Bb/75J+wdzj8NEwgGZ1OkBNF6aCwpJerbbIKjorbEHK/D+xAINpyL+SI54xDQel/y34iWlI9xgqWi9QR7qhtsJKi6OXeyrY9XMHEFoFMNRfxgjHMZedmj+V7LN9+5nAS3NonucRloSq6xem7HRuUqcw25NcTXYqcMUgBo17dtr1ePHRabE6qgJ0SbovVih3ROc5dW45VVNbh4PYwQXdQZ7bPwNYMOtSyTmpggvs8vSU93rPDNSvWGfhqN4IY3Pu/2+AO9+wt4UrZj2MY8Gpcjft3m4waOMNx10Wv6kWRhOSHJcYjvNJ0MzL9QUu4oVg07IvaMQNxED7A/sDY08y2PVw/Q5TlSrH2s5LA7pWYQ
 yQmHDifd
 VVk3jkWzao8zAVWdoYUgYn0r1TSQFt88AUCxbtGCT1ufmE8dyPKrCAJX4oRL9NKV5u/QfEZIbnyIkORS3W+3p5Gt+EnR7tGn4Ftxz0M6fs8D3OBe/xxNXpOxecDTofzQGaM4AFwNPH1F6mNZQDDyhNnLe35gICtwmu0jWU2WLNbywhc0QYJEzaieTU3O/jGuRkHn++RRZ7j6nrooR5WawK57LInCfh4dKbXsrSt7RPmSltxBlvh4D/3tmgEuOuFfe9HZL5BDT+NZMvid853vm1eIjYN46RxMVznH0HwAjDogvmvkrXCgfqv1aGIViv478lhMgeG2Ictba2cj42Mu5vSljOD0pkQYF7Hwtptu0mrDgZKua8mV4cLo7dEqgvR386rI8MdAHdtDCB9U4oAPmCmrUyuRXxhHOYjy5x6iwt44AsT0UeHlSo6pZ6Ccg+1em3dymSTHCavBuZB/VcclLXKMQlHJyM/N6m2ZNqtbnvwSzka4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [Severity: Medium]
> Can zstrm->excl_lock and zstrm->buf_lock be acquired in opposite orders?
>
> In zram_read_partial_from_zspool(), an exclusive decompression backend
> (ZCOMP_DSTRM_EXCLUSIVE) takes zstrm->excl_lock inside zcomp_dstrm_get()
> and then locks zstrm->buf_lock.  A shared decompression backend
> (ZCOMP_DSTRM_SHARED) locks zstrm->buf_lock first and then calls
> zcomp_decompress(), which locks zstrm->excl_lock when a two-page object
> falls back to zstrm->local_copy:
>
> CPU0                              CPU1
> ----                              ----
> lock(&zstrm->excl_lock)
>                                   lock(&zstrm->buf_lock)
> lock(&zstrm->buf_lock)
>                                   lock(&zstrm->excl_lock)
>
>  *** DEADLOCK ***

This is a valid issue. I think I can eliminate the lock inversion by
dropping buf_lock entirely and letting partial reads always acquire the
stream in ZCOMP_DSTRM_EXCLUSIVE mode, where decomp_buf is already
serialized under excl_lock.

With patch 4 (allowing direct reclaim for synchronous multi-page swapin
in do_swap_page()), I found partial reads are quite rare. So using
exclusive mode here will not cause heavy lock contention.

--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -79,7 +79,6 @@ struct zcomp_dstrm {
 	void *local_copy;
 #ifdef CONFIG_ZRAM_MULTI_PAGES
 	void *decomp_buf;
-	struct mutex buf_lock;
 #endif
 };

--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -120,7 +120,6 @@ static int zcomp_dstrm_init(struct zcomp *comp, struct zcomp_dstrm *zstrm)
 		zcomp_dstrm_free(comp, zstrm);
 		return -ENOMEM;
 	}
-	mutex_init(&zstrm->buf_lock);
 #endif
 	return 0;
 }

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2907,17 +2907,13 @@ static int zram_read_partial_from_zspool(struct zram *zram, struct page *page,
 		prio = get_slot_comp_priority(zram, index);
-		mode = ZCOMP_DSTRM_EXCLUSIVE;
-		if (zcomp_shared_decomp(zram->comps[prio]))
-			mode = ZCOMP_DSTRM_SHARED;
-
-		zstrm = zcomp_dstrm_get(zram->comps[prio], mode);
-		mutex_lock(&zstrm->buf_lock);
+		zstrm = zcomp_dstrm_get(zram->comps[prio], ZCOMP_DSTRM_EXCLUSIVE);
 		ret = zcomp_decompress(zram->comps[prio], zstrm, sg, size,
 				       zstrm->decomp_buf, page_size);
 		if (!ret) {
 			dst = kmap_local_page(page);
 			memcpy(dst, zstrm->decomp_buf + offset, PAGE_SIZE);
 			kunmap_local(dst);
 		}
-		mutex_unlock(&zstrm->buf_lock);
-		zcomp_dstrm_put(zram->comps[prio], zstrm, mode);
+		zcomp_dstrm_put(zram->comps[prio], zstrm, ZCOMP_DSTRM_EXCLUSIVE);
 	}

> [Severity: Medium]
> Can __test_multi_pages_comp() access past the end of zram->table when
> disksize is not a multiple of ZCOMP_MULTI_PAGES_SIZE?
>
> disksize_store() only aligns disksize with PAGE_ALIGN(disksize).  When
> num_pages is not a multiple of ZCOMP_MULTI_PAGES_NR, an access to the
> final slots has head + i >= num_pages, so __test_multi_pages_comp() and
> the set_slot_flag() loops in the multi-page write path read and write past
> the end of zram->table.

This is a valid issue (and was also caught by syzbot KASAN). I will align
disksize to ZCOMP_MULTI_PAGES_SIZE in disksize_store() so that multi-page
groups never cross the end of zram->table.

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3298,7 +3298,7 @@ static ssize_t disksize_store(struct device *dev, struct device_attribute *attr,
 	if (init_done(zram)) {
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
 	}

-	disksize = PAGE_ALIGN(disksize);
+	disksize = ALIGN(disksize, ZCOMP_MULTI_PAGES_SIZE);
 	num_pages = disksize >> PAGE_SHIFT;

> [Severity: Medium]
> Does ZRAM_FLAG_SHIFT overflow the 32-bit attr.flags field when
> PAGE_SHIFT + CONFIG_ZSMALLOC_MULTI_PAGES_ORDER > 21?
>
> CONFIG_ZSMALLOC_MULTI_PAGES_ORDER allows values up to 9, and enum
> zram_pageflags defines 10 flag bits above ZRAM_FLAG_SHIFT.  On 16K or 64K
> page configurations with larger orders (for example, PAGE_SHIFT == 16 with
> order >= 6), __NR_ZRAM_PAGEFLAGS exceeds 32 and triggers
> BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > sizeof(zram_te.attr.flags) * 8) in
> zram_init().

This is valid. While configurations exceeding the 32-bit limit are already
rejected at build time, I will replace BUILD_BUG_ON() with an informative
static_assert() and add comments documenting the bit budget (PAGE_SHIFT +
ZSMALLOC_MULTI_PAGES_ORDER <= 21).

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -3680,2 +3680,3 @@ static int __init zram_init(void)
-	BUILD_BUG_ON(__NR_ZRAM_PAGEFLAGS > sizeof(zram_te.attr.flags) * 8);
+	static_assert(__NR_ZRAM_PAGEFLAGS <= sizeof(zram_te.attr.flags) * 8,
+		      "zram pageflags overflow: PAGE_SHIFT + ZSMALLOC_MULTI_PAGES_ORDER must be <= 21");

> [Severity: Low]
> Should this find_alloced_obj() change be folded into the preceding commit
> "mm: zsmalloc: support objects compressed based on multiple pages" so the
> series stays bisectable?
>
> Also, the commit message ends with "The following data illustrates the
> time and compressed data for typical anonymous pages gathered from Android
> phones." without including the data table, and multi_pages_debug_stat_show()
> is missing a colon or space before "%8llu" on the failed and partial count
> lines.

Agreed. I will fold the find_alloced_obj() change into patch 1, drop the
sentence that promises a data table which is not included, and fix the
missing delimiter in multi_pages_debug_stat_show:

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2011,3 +2011,3 @@ static ssize_t multi_pages_debug_stat_show(struct device *dev,
-			"multi_pages_failed_writes%8llu\n"
-			"zram_bio_write_multi_pages_partial_count%8llu\n"
-			"zram_bio_read_multi_pages_partial_count%8llu\n"
+			"multi_pages_failed_writes: %8llu\n"
+			"zram_bio_write_multi_pages_partial_count: %8llu\n"
+			"zram_bio_read_multi_pages_partial_count: %8llu\n"


