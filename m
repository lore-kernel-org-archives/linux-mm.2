Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AD10C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBFE46B00BE; Wed, 22 Jul 2026 12:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95E46B00C1; Wed, 22 Jul 2026 12:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4EE6B00C2; Wed, 22 Jul 2026 12:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 94C666B00BE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:59:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D1E0120230
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:59:19 +0000 (UTC)
X-FDA: 85017023238.21.3878EA8
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf25.hostedemail.com (Postfix) with ESMTP id E2E3CA0015
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:59:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784739557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/XSX0oaALZx5W9NVPQ6H1LFJelp8qpg4CAK6IiFZ2YQ=;
	b=3qCbT/r9kEjjdoNvQQpFEvvkhIHAUmsV68dKyNwqpV1UqLpmlTJemksLHxu/e+riAk92Ka
	EhU7vp1BVbm86PrSK3oKrUJM/lG56jH55oVnG732LufndgIaP8Z8Pr2Bo8J2pckBP4hI6X
	95d0vlcExHfkyQcOSl1UneDj71KUcxY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784739557;
	b=CHu+MQtIto7sVEdbs59b9sg+H+NEfZyB4a391gExhWdVD+cvIK11KE6UPznls02POksNi9
	JEedB77kRjRlf+3R43KqsmWgckStgd8f8oBP6sX18h2jy1czoItUa2YTZ+3hey59eoBpro
	M1nxa3Mb0qKB5eJLFAuFYpX/qTv2AhA=
Received: by mail.gandi.net (Postfix) with ESMTPSA id CA41E3ECFA;
	Wed, 22 Jul 2026 16:59:11 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com
Cc: chengming.zhou@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	ryncsn@gmail.com,
	chrisl@kernel.org,
	baohua@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 1/3] mm: swap: overlap synchronous readahead decompression with disk I/O
Date: Wed, 22 Jul 2026 18:58:59 +0200
Message-ID: <20260722165907.784020-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722163536.773166-1-alex@ghiti.fr>
References: <20260722163536.773166-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTFgQMyRFuZn1rX9NTarebc0I7T7nq/R/ZHBTIlh8IqQClTjfwSu7K0eaziy7tNAM4X53JhtGZzn540eop7U5DCL+rg/U0xQjoy8BIp1n4895pHfjH8NRnuD+WCoIE51kuJMgJt+3mz144YQ0OoxtQd+5Q+MPSYSfpY++79KBWt1+OTE0Uq864soWP3yIunIfAkTiBnyRg9iDK4XuMcE7JPCRw7BBfNAc5d09aB1L0xQJo0tXhhf7wFNpH20cQ/YgyFSBsrfH8bT4mK/43o2QuLFKkCBqWo1s2ra0McFrNw76VuHY/Tm3YsFQSMJAPDmJsfNK8L3V05NFWCwrd/SY5fzVYllPIvqMv/FZrZZrHri/ZQKt5saqKGLHi1Fgg9eBVP5i+sop0xt2mzORJ/qV8ucDLlxwpzDwB4DWMwDXMm8rqIv61gniCwMXnSashTflGLkZBvXHML9epGe6+9jhIO6poLdDUmvt3bGkgLudRyWLaRj/bsP0nYjwh88/XEgpTk9aqC3tI5fqSAzGCMcf7UA67BTcqD7fIkcMJzTvERicax64H+59Q/Hh+t1Evi7HOpTH3PZahZV7xQiwsBM5MNA7BOwlwOmz+tHdSx/t3egAl+oB3r0/8xam9eKIfD1VwwV9ZBXHGpd6hQ3Xr7uLcRUtGkyQVHr4JXK4b+Q62enHg
X-GND-State: clean
X-GND-Score: 0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2E3CA0015
X-Rspam-User: 
X-Stat-Signature: rd1hzfxc46m43juobp647m5wtpc6mrga
X-HE-Tag: 1784739556-574999
X-HE-Meta: U2FsdGVkX195XPjKBTWMegVQTJOFzM3Draxg7B9fUYkK9nBGSHtpprDMtI8Ne5b0p0iatgMT7qk8L21f+J/CqI00gPyD9AReif+zRGnYObMi6jq58ug6y1BgQZs02amtNGlGkJ0VxKbM5Y3hjG60/KCZvo5CCgZAX7YoWuv1lukA30URMCvuLVzn6tMoJodim57KbU3RyDK/tNRBIFCeYWZT7C2/W8Fead8ybLbMymodZhK96RG606I1xahKwzd6vWZyxHnYPrxW9DM3dLfibpJZ2tj6MMGcDralHfotDc7j9r4+KEVcsS6cqLdJ1hsK4QYEUqHJD0PKPkQg/fVBkQSLn3O9JhEz1ESkyiz3219p+fDsbd9NfQdBuUDPF2bFfm9TFkRxsc/29Vp0Lh20Q8hvYXGfrVAxXAuxtSv6ZdGKWIO76u6ilalDUggjn7SdmLy2PC42xhU162lpd5LY+O+pPpWTzig5Y3EeDZE+zOeNiLeoM1DuHGodRJ8J6mX+1EJ0xFfC+CjJaNY+IR3uz4NsOnsalfLy8w2NQ1JGo/goQf9hbiQtW+O9MwN2hlh8GvX0+uw+E97Jm98ZGXuP00zPJ+6VwGc7Vgj1DG/oDRJYw0p3XgW4wHym/I9JNjLxI8qiZvyPFaAIZgFEO1TW0EGg4L+ODM4kmxPwoTrYk5igcZxinSLECTX1MGeFyrlpUPujERADi45VvXP8xLTUPx9bsfmWW+TlXrMbTOllElabZFIgRZfLHQg5RctUP1ZIiMWR77cJJXVMFf8TbSVxFMwKzMl68h9BjHGvZnKTdPMfQJJeek0pEyuV19clgMFS7xNiVZbC2YxHIqkALLHS0HCcVFHjeYs/i8MJv2QPbiCGstshMQ2/3WMuDUJDka5d/eSRe+UgSzfzHTEIYv9xjvh6EP1Mi1v6trEMH6jX3cByHfxF6H4bmg9VARiQpNKszVFE7ziThtU1jEfgVkL
 KniWY66y
 L2Ytb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Swap readahead reads the whole window sequentially: the device I/Os are
accumulated along the way while the synchronous, zswap-resident entries
are decompressed inline. The I/O is only triggered afterwards, at
blk_finish_plug(), so the synchronous zswap decompression is pure added
latency in front of the read the fault is about to wait on.

Trigger the I/O before decompressing the synchronous entries: split the
window walk into two passes. Pass 1 issues the async device reads and
defers the synchronous neighbours; pass 2 reads the deferred entries
while pass 1's I/O is in flight, overlapping the CPU work with the disk
reads instead of serialising it in front of them.

swap_cluster_readahead() walks a contiguous offset range, which is cheap.
swap_vma_readahead() instead walks the page tables so we cache the
entries we encounter in the first pass to reuse directly in the second
pass.

Results [vm-scalability mixed zswap+disk swap-in, 256M zswap cap (~73%
disk), Sapphire Rapids, zswap=zstd, shrinker off, n=3]:

  metric                  mm-new    +patch    delta
  swap-in tput (KB/s)    119247    131261    +10.1%
  swap-in wall (s)          106       100     -5.7%
  swap readahead (pages)   1.56M      1.55M    ~same
  zswap-in (MB)            1895       1872     ~same
  disk swap-in (MB)        5207       5190     ~same
  major faults            260148     260212    ~same

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 include/linux/swap.h  |  6 ++++
 include/linux/zswap.h |  6 ++++
 mm/swap_state.c       | 67 +++++++++++++++++++++++++++++++++++++++++--
 mm/swapfile.c         |  9 ++++++
 mm/zswap.c            | 17 +++++++++++
 5 files changed, 103 insertions(+), 2 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 8f0f68e245ba..6bb35c093d77 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -441,6 +441,7 @@ extern unsigned int count_swap_pages(int, int);
 extern sector_t swapdev_block(int, pgoff_t);
 extern int __swap_count(swp_entry_t entry);
 extern bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry);
+extern bool swap_entry_synchronous(swp_entry_t entry);
 extern int swp_swapcount(swp_entry_t entry);
 struct backing_dev_info;
 extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
@@ -519,6 +520,11 @@ static inline bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t e
 	return false;
 }
 
+static inline bool swap_entry_synchronous(swp_entry_t entry)
+{
+	return false;
+}
+
 static inline int swp_swapcount(swp_entry_t entry)
 {
 	return 0;
diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..cd9efcf9dec9 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+bool zswap_is_present(swp_entry_t entry, unsigned int nr);
 #else
 
 struct zswap_lruvec_state {};
@@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	return false;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 9c3a5cf99778..3ff2896dd6d2 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -811,6 +811,7 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	struct blk_plug plug;
 	struct swap_iocb *splug = NULL;
 	swp_entry_t ra_entry;
+	bool has_sync = false;
 
 	mask = swapin_nr_pages(offset) - 1;
 	if (!mask)
@@ -824,10 +825,16 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	if (end_offset >= si->max)
 		end_offset = si->max - 1;
 
+	/* first, issue the asynchronous device reads */
 	blk_start_plug(&plug);
 	for (offset = start_offset; offset <= end_offset ; offset++) {
-		/* Ok, do the async read-ahead now */
 		ra_entry = swp_entry(swp_type(entry), offset);
+		if (swap_entry_synchronous(ra_entry)) {
+			has_sync = true;
+			continue;
+		}
+
+		/* Ok, do the async read-ahead now */
 		folio = swap_cache_read_folio(ra_entry, gfp_mask, mpol, ilx,
 					      &splug, offset != entry_offset);
 		if (!folio)
@@ -836,6 +843,24 @@ struct folio *swap_cluster_readahead(swp_entry_t entry, gfp_t gfp_mask,
 	}
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
+
+	if (!has_sync)
+		goto drain;
+
+	/* Overlap the in flight IOs with the synchronous neighbours reads */
+	for (offset = start_offset; offset <= end_offset; offset++) {
+		ra_entry = swp_entry(swp_type(entry), offset);
+		if (!swap_entry_synchronous(ra_entry))
+			continue;
+
+		folio = swap_cache_read_folio(ra_entry, gfp_mask, mpol, ilx,
+					      NULL, true);
+		if (!folio)
+			continue;
+
+		folio_put(folio);
+	}
+drain:
 	lru_add_drain();	/* Push any new pages onto the LRU now */
 skip:
 	/* The page was likely read above, so no need for plugging here */
@@ -899,11 +924,13 @@ static int swap_vma_ra_win(struct vm_fault *vmf, unsigned long *start,
 static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		struct mempolicy *mpol, pgoff_t targ_ilx, struct vm_fault *vmf)
 {
+	softleaf_t sync_entries[1 << SWAP_RA_ORDER_CEILING];
+	pgoff_t sync_ilx[1 << SWAP_RA_ORDER_CEILING];
 	struct blk_plug plug;
 	struct swap_iocb *splug = NULL;
 	struct folio *folio;
 	pte_t *pte = NULL, pentry;
-	int win;
+	int win, i, nr_sync = 0;
 	unsigned long start, end, addr;
 	pgoff_t ilx = targ_ilx;
 
@@ -913,6 +940,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 
 	ilx = targ_ilx - PFN_DOWN(vmf->address - start);
 
+	/* first, issue the asynchronous device reads */
 	blk_start_plug(&plug);
 	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
 		struct swap_info_struct *si = NULL;
@@ -939,6 +967,16 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 			if (!si)
 				continue;
 		}
+
+		if (swap_entry_synchronous(entry)) {
+			sync_entries[nr_sync] = entry;
+			sync_ilx[nr_sync] = ilx;
+			nr_sync++;
+			if (si)
+				put_swap_device(si);
+			continue;
+		}
+
 		folio = swap_cache_read_folio(entry, gfp_mask, mpol, ilx,
 					      &splug, addr != vmf->address);
 		if (si)
@@ -951,6 +989,31 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		pte_unmap(pte);
 	blk_finish_plug(&plug);
 	swap_read_unplug(splug);
+
+	if (!nr_sync)
+		goto drain;
+
+	/* Overlap the in flight IOs with the synchronous neighbours reads */
+	for (i = 0; i < nr_sync; i++) {
+		struct swap_info_struct *si = NULL;
+
+		if (swp_type(sync_entries[i]) != swp_type(targ_entry)) {
+			si = get_swap_device(sync_entries[i]);
+			if (!si)
+				continue;
+		}
+
+		folio = swap_cache_read_folio(sync_entries[i], gfp_mask, mpol,
+					      sync_ilx[i], NULL, true);
+		if (si)
+			put_swap_device(si);
+
+		if (!folio)
+			continue;
+
+		folio_put(folio);
+	}
+drain:
 	lru_add_drain();
 skip:
 	/* The folio was likely read above, so no need for plugging here */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 78b49b0658ad..ee2bbfdfc988 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1983,6 +1983,15 @@ bool swap_entry_swapped(struct swap_info_struct *si, swp_entry_t entry)
 	return swp_tb_get_count(swp_tb) > 0;
 }
 
+/**
+ * swap_entry_synchronous - Check if @entry is served by a synchronous source.
+ * @entry: the swap entry.
+ */
+bool swap_entry_synchronous(swp_entry_t entry)
+{
+	return zswap_is_present(entry, 1);
+}
+
 /*
  * How many references to @entry are currently swapped out?
  * This returns exact answer.
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..b91a1ef8869b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -234,6 +234,23 @@ static inline struct xarray *swap_zswap_tree(swp_entry_t swp)
 		>> ZSWAP_ADDRESS_SPACE_SHIFT];
 }
 
+/**
+ * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
+ * @entry: base swap entry of the range
+ * @nr: number of contiguous slots to check (pass 1 for a single-slot query)
+ */
+bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	pgoff_t offset = swp_offset(entry);
+	struct xarray *tree = swap_zswap_tree(entry);
+	unsigned long index = offset;
+
+	if (!nr || zswap_never_enabled())
+		return false;
+
+	return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
+}
+
 #define zswap_pool_debug(msg, p)			\
 	pr_debug("%s pool %s\n", msg, (p)->tfm_name)
 
-- 
2.53.0-Meta


