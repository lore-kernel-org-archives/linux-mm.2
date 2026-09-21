Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB86C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962656B00E5; Mon, 21 Sep 2026 11:25:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9127A6B00E6; Mon, 21 Sep 2026 11:25:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801356B00E7; Mon, 21 Sep 2026 11:25:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF8E6B00E5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:25:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB13A1201F0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:25:00 +0000 (UTC)
X-FDA: 85238142360.29.AFA94A0
Received: from relay6-d.mail.gandi.net (relay6-d.mail.gandi.net [217.70.183.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id 00C391C0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:24:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.198 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790004299;
	b=jFXLU50eH8wQsWbwsN4QPKc8Dij7mHzX7s5Yrefklqd9c8VNcbKln44wYGvBWMaT/9LJ6e
	B6RRGgsPa2nnTgHzSsSvTc3Z3q4DzwCI1tY95hUaqXxeH1oAYyYuem/gOkErBfxSa093ee
	HcYAbKiLemQW2Yp1sGEDxMWpWjEWQUk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790004299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=rBphQakF612ZlN6LtcbgiISZgv9SgThW54EhmxijcrY=;
	b=SrPqBERiv6pDLzfRRr3F3L9ClkRivwGRf829CSGTOD2TIlASB7x0LY6Ecls/P4l5s1LUDg
	YfK5BTi/2xzx6wTiOJm6dWOAhdFt1/YaZ2dbn1aMdnaNzsohNTRoWT00cKJW1/W59pJbX1
	LNIGVZIe3/gH4hQQqbku8MXRDZGCODk=
Received: by mail.gandi.net (Postfix) with ESMTPSA id 4F7773EDB6;
	Mon, 21 Sep 2026 15:24:51 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org
Cc: willy@infradead.org,
	jack@suse.cz,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	tz2294@columbia.edu,
	hch@lst.de,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
Date: Mon, 21 Sep 2026 17:24:33 +0200
Message-ID: <20260921152449.629486-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: 0
X-GND-Cause: dmFkZTGJ0K/8e2Pztp+j2sY+ScsUkCHOW/yXvnc8RSSzpo2y7MSWBAdHH95jj7iY86IG3StSez5iGs7YBgB3H839XNyDnjW9zfMdmBkAKsASsvMhaLCmTi1AoeUnuwtG9zlqupdPYX+HawcgSm+JGIpnjCfGFBjvtLDn71zscY4rO8DWFgKDvVTpDKQQiP2J2hPdRCUiJ/zh1RIu+t22boYe0C6TNAvzTG+LsxJUOKCWUUuD2klfWozBAaYw5r8xQzoa6tJ5bmIDwEq+T5TBqqZjBFfBsK44AgPHHgTvaK8WTi7jgX5q7ZWiGPXUO4tU5ZOxX5+wULeE0Aft9rDHh5fQfgW+MdI6EzMCWnFZ+OE+cx7Iw8H7rDbuPMBm2uneJoPvZqxs3FlpdPORsdUK06Edbu5HTggLWH6kFza+POdqZVRwEgUVGKFVamC61XNbu+tQV8Gtzjr/zPBWXZnb3S1Zw0/qdwiWWoOh/i83Spb4MycZLMmVpzFmOJddpil+2FS0WZPIcsQEMmsAJIJbPs66kaDz6/3IUfu0hoDQq4JZZ2zfW9TR4aCetC9YO1wuc4V5Q+fkauY8VZ0+X46MHqwYuo10VcfHqQuwipvbN9YzyGPqaU8p4M3q61GdlTFewpKjDKO9iKhJHoV01XPBf/iiRKg5EAPZ72ju2kOUdvc/kT9OTw
X-Rspam-User: 
X-Rspamd-Queue-Id: 00C391C0002
X-Stat-Signature: gme97ohnruws7ck78j1sph1aemjerdm4
X-Rspamd-Server: rspam01
X-HE-Tag: 1790004298-388077
X-HE-Meta: U2FsdGVkX1+VkSjoOPIuoMdE2MhAFwf2nqm695SEfyWzUqx8I0QaI/KS9odwyqmPjskAx7QZ/eMkgpw5bkBWDN7MW67XVBAwhtgg9y8ahQ+4krTOu8ZH47xhBM6DNAzThlGohfwik7e3412uVx8k1g0BqUmOChMcelm4EeojRJ7qs0kMuXJw/Fju3R6mvxl7hkOiPqb0v3GglHshfCV0z0jB0lC2TYIFiuBt0sGR9fafiavCOlk+0YvzBfYJ2mIbiFxfmZFALNMRWl38ejHsth/T6c1qjKcSFsJl9C7S3rnjKhidr9Wxy8o1gaZIw26txJkPrKe9J/zGmreT/OgXc/JpEe/C7sWyiv5KyZfBscEq5ELN1D9qwkN+gdksdVRF3d4FI7HW5Ft3FBeYGUPzZ7ayNoGV07fsu301ciiJv6nHTQoQOterv00YOvnTTr1MwgI6T20yE1cNwjzwvQuPEM0aGj7wlgW1XkrvHkBkKl98ClLa2jRDUa7eLHBXxhoOiEBAzZgp8IYRe5TwzQ8EJE4VHlGpWeFp9nXaEkxFbqtvh9Dq2jLgU0JXJR91o3ZinJ6rfi9KIQ2QdTl8sLUuHnRU7Su2UVAlwnHCFCGVPdJPqOzpHN7JtwJyljjpQj8l/AmnMhARmzYe7LEeSlojSXFHGaGdrwJ5xZfIQ0Jeny4OFmfDfuwHx9Q0/b3gZcsD4Ii2ylMT6DyxOb1UWb/JnwgSC9//6HRXz+M44EajZneKT6C3fp2FpePzAy4dr4MH/OAgSv//muCmNtPpfHhBc3LSXavCqBrxrimPBnywcOTU38eum6jKJWWsfJn3XQlXktw2Jh+HyRpiTHga0/iFZ30dEQ+9NoTy2lwGkflTFzGyfC77EpT6uzJMyQAXWeBJYcgfm8DnyC30rDQ9YGmhtITgTCXovkr2UXbSH+IVkQqMwAoyUVIHGwR6nT+E36I3ZGMEEvprV9UfWd4k7qr
 fmuJNgyQ
 dNdzvtWaBCrAxo3lEPSLf3jbFdKkiQzLEo7llsxdLO79qiPtNAPhpqISjEPFlhKsrnOaLUP/Rudt1o5ij1fh9Ed3/E69zLED7zIhmEVO8daPzyl3a9HGs0gtuQEoZvnNRemTcVhAdu8+oAIHlvZXjINfykQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On an asynchronous swap device MADV_PAGEOUT only marks the folio
PG_reclaim and rotates it to the tail of the inactive list once its
writeback completes, so the memory is not actually freed until a later
reclaim scan removes the by then clean swap cache folio. Mark those
folios dropbehind at isolation time instead and let folio_end_writeback()
drop them from the swap cache as each write lands.

A dropbehind folio is dropped by whoever completes its writeback, so the
reference the submitter holds has to be released before the write is
submitted. As reclaim does before freeing a folio, flush the pending TLB
batch first.

Note that for dropbehind folios nr_reclaimed is now credited when the
write is submitted rather than when the folio is actually freed, since the
reclaimer never sees the folio again.

Suggested-by: Barry Song <baohua@kernel.org>
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
This applies on top of "[PATCH v6 0/3] mm: zswap: free cold writeback folios
promptly":

https://lore.kernel.org/linux-mm/20260921151306.625134-1-alex@ghiti.fr/

 mm/filemap.c |  7 +++++++
 mm/madvise.c | 23 ++++++++++++++++++----
 mm/page_io.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 mm/swap.h    |  2 ++
 mm/vmscan.c  | 10 ++++++++++
 mm/zswap.c   |  9 ++++-----
 6 files changed, 95 insertions(+), 11 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index e1f1bbe943ce..14fa96fca8b8 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1630,6 +1630,13 @@ void folio_end_dropbehind(struct folio *folio)
 	if (!folio_test_dropbehind(folio))
 		return;
 
+	/*
+	 * PG_dropbehind could be set on an anonymous folio after
+	 * folio_end_writeback() samples it (for example MADV_PAGEOUT).
+	 */
+	if (folio_test_anon(folio))
+		return;
+
 	/*
 	 * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
 	 * but can happen if normal writeback just happens to find dirty folios
diff --git a/mm/madvise.c b/mm/madvise.c
index eeee82cf2b3f..63164f95720b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -359,6 +359,17 @@ static inline int madvise_folio_pte_batch(unsigned long addr, unsigned long end,
 				     FPB_MERGE_YOUNG_DIRTY);
 }
 
+static void madvise_mark_dropbehind(struct folio *folio)
+{
+	/*
+	 * A folio already under writeback is skipped: that writeback is not
+	 * ours to hand over, so reclaim will put the folio back on the LRU
+	 * while its completion could be dropping it at the same time.
+	 */
+	if (folio_test_anon(folio) && !folio_test_writeback(folio))
+		folio_set_dropbehind(folio);
+}
+
 static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 				unsigned long addr, unsigned long end,
 				struct mm_walk *walk)
@@ -439,10 +450,12 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			folio_set_workingset(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
-				if (folio_test_unevictable(folio))
+				if (folio_test_unevictable(folio)) {
 					folio_putback_lru(folio);
-				else
+				} else {
+					madvise_mark_dropbehind(folio);
 					list_add(&folio->lru, &folio_list);
+				}
 			}
 		} else
 			folio_deactivate(folio);
@@ -554,10 +567,12 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			folio_set_workingset(folio);
 		if (pageout) {
 			if (folio_isolate_lru(folio)) {
-				if (folio_test_unevictable(folio))
+				if (folio_test_unevictable(folio)) {
 					folio_putback_lru(folio);
-				else
+				} else {
+					madvise_mark_dropbehind(folio);
 					list_add(&folio->lru, &folio_list);
+				}
 			}
 		} else
 			folio_deactivate(folio);
diff --git a/mm/page_io.c b/mm/page_io.c
index 52eae99de6e3..bf8238768cc9 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -26,9 +26,12 @@
 #include <linux/delayacct.h>
 #include <linux/zswap.h>
 #include <linux/swap_ops.h>
+#include "internal.h"
 #include "swap.h"
 #include "swap_table.h"
 
+#include <trace/events/vmscan.h>
+
 int generic_swapfile_activate(struct swap_info_struct *sis,
 				struct file *swap_file,
 				sector_t *span)
@@ -248,8 +251,19 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	}
 	rcu_read_unlock();
 
+	if (folio_test_dropbehind(folio)) {
+		/*
+		 * pageout() traces and accounts at its tail, which we can't do
+		 * because dropbehind folios may already be freed by then.
+		 */
+		trace_mm_vmscan_write_folio(folio);
+		lruvec_stat_mod_folio(folio, NR_VMSCAN_WRITE,
+				      folio_nr_pages(folio));
+		ret = SWAP_WRITE_DROPBEHIND;
+	}
+
 	__swap_writepage(ctx, folio);
-	return 0;
+	return ret;
 out_unlock:
 	folio_unlock(folio);
 	return ret;
@@ -692,8 +706,45 @@ EXPORT_SYMBOL_GPL(swap_fs_activate);
 
 void swap_write_submit(struct swap_io_ctx *ctx)
 {
-	if (!ctx->sio)
+	struct swap_iocb *sio = ctx->sio;
+	bool dropbehind = false;
+	int p;
+
+	if (!sio)
 		return;
+
+	for (p = 0; p < sio->nr_bvecs; p++) {
+		if (folio_test_dropbehind(bvec_folio(&sio->bvecs[p]))) {
+			dropbehind = true;
+			break;
+		}
+	}
+
+	if (dropbehind) {
+		/*
+		 * A dropbehind folio is freed by the completion, not by the
+		 * reclaimer, and freeing needs every deferred unmap flushed,
+		 * not just the writable ones try_to_unmap_flush_dirty() covers
+		 * before the IO.  The reclaimer flushes before it frees, but
+		 * that is too late for a batch swap_add_folio() already
+		 * submitted mid-loop.  A no-op once that flush has happened.
+		 */
+		try_to_unmap_flush();
+
+		/*
+		 * Now that the TLB is clean, drop the submitter's reference:
+		 * the swap cache then holds the only ones left, which is what
+		 * __remove_mapping() expects when the completion drops the
+		 * folio.  This has to happen before the write is submitted.
+		 */
+		for (p = 0; p < sio->nr_bvecs; p++) {
+			struct folio *folio = bvec_folio(&sio->bvecs[p]);
+
+			if (folio_test_dropbehind(folio))
+				folio_put(folio);
+		}
+	}
+
 	count_vm_events(NRSWPOUT, 1);
 	ctx->sis->ops->submit_write(ctx);
 	ctx->sio = NULL;
diff --git a/mm/swap.h b/mm/swap.h
index 8679cb61268e..81114ad9e44a 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -92,6 +92,8 @@ static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
 	return READ_ONCE(vm_swappiness);
 }
 
+#define SWAP_WRITE_DROPBEHIND	1
+
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
diff --git a/mm/vmscan.c b/mm/vmscan.c
index a02f942418d3..5435fa5111b3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -613,6 +613,8 @@ typedef enum {
 	PAGE_SUCCESS,
 	/* folio is clean and locked */
 	PAGE_CLEAN,
+	/* folio will be freed after writeback, do not touch */
+	PAGE_DROPBEHIND,
 } pageout_t;
 
 /*
@@ -659,6 +661,9 @@ static pageout_t pageout(struct swap_io_ctx *ctx, struct address_space *mapping,
 	else
 		res = swap_writeout(ctx, folio);
 
+	if (res == SWAP_WRITE_DROPBEHIND)
+		return PAGE_DROPBEHIND;
+
 	if (res < 0)
 		handle_write_error(mapping, folio, res);
 	if (res == AOP_WRITEPAGE_ACTIVATE) {
@@ -1437,6 +1442,9 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 					nr_pages = 1;
 				}
 				goto activate_locked;
+			case PAGE_DROPBEHIND:
+				nr_reclaimed += nr_pages;
+				continue;
 			case PAGE_SUCCESS:
 				if (nr_pages > 1 && !folio_test_large(folio)) {
 					sc->nr_scanned -= (nr_pages - 1);
@@ -2198,6 +2206,8 @@ static unsigned int reclaim_folio_list(struct list_head *folio_list,
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
+		if (folio_test_anon(folio))
+			folio_clear_dropbehind(folio);
 		folio_putback_lru(folio);
 	}
 	trace_mm_vmscan_reclaim_pages(pgdat->node_id, sc.nr_scanned, nr_reclaimed, &stat);
diff --git a/mm/zswap.c b/mm/zswap.c
index dc8425d6b21e..640936fe7464 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1051,17 +1051,16 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_dropbehind(folio);
 
 	/*
-	 * Drop our reference before starting writeback so the swap cache holds
-	 * the only one: the drop in folio_end_writeback() needs that for
-	 * remove_mapping_set_shadow() to succeed, otherwise the folio is
-	 * handed back to reclaim instead.
+	 * Our reference is donated to swap_write_submit(), which drops it just
+	 * before submitting so the swap cache holds the only one left: the drop
+	 * in folio_end_writeback() needs that for remove_mapping_set_shadow()
+	 * to succeed, otherwise the folio is handed back to reclaim instead.
 	 *
 	 * Nothing can free the folio in the meantime: we hold the folio lock
 	 * until writeback starts, PG_writeback then blocks swap cache removal,
 	 * and folio_end_writeback() takes its own reference before clearing
 	 * PG_writeback and donates it to the drop.
 	 */
-	folio_put(folio);
 
 	/* start writeback */
 	__swap_writepage(&ctx, folio);
-- 
2.53.0-Meta


