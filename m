Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47850C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358816B0088; Mon, 24 Aug 2026 10:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330EF6B009B; Mon, 24 Aug 2026 10:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E826B009D; Mon, 24 Aug 2026 10:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E08DF6B009B
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:34:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 717F71A014D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:34:47 +0000 (UTC)
X-FDA: 85136409414.27.798C5F6
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 80CC640003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:34:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ADMse8P8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787582085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03W8AdXTU8nvNZrlTGS6pFe21yyktV4JnRO2xEfU4uM=;
	b=rwJ9DBkYFR/v0zmv3LpqP7pAf3psyrS6LQATNCVlzSzlMgk4Gv6+pvehyM6XNUsHQPNqqb
	6TgxRwRC3YLId7J6hkjRIkZVCU1SfE5jTYyWIBpsDbtRGYmYB/KqNPb3IH4sg075pRfXXN
	W5/sbjBpeuEkAisyJO8PLaT82D02X/o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ADMse8P8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of hughd@google.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787582085;
	b=RoGB6Bv05nvDeVHWKlxv8Zh06j3DNnkfWrNZhzzCQizDZuVW7yvJ1I4j/FwJjjQ/DnbHII
	wIhEFwJtqqJSV2JntqUqRkxkw8NoZEMV1s8AINvShMLLLDTlzgeuWBB6EAxuUvXQFQzuSE
	y+uvKzcyL1G8UtLoNaGWcVfVS/sEKPA=
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-66c67a73eb7so6790040d50.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787582084; x=1788186884; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=03W8AdXTU8nvNZrlTGS6pFe21yyktV4JnRO2xEfU4uM=;
        b=ADMse8P8gC74u6KpNRLZ4S7bxZxD7l2YN9rXbwEObOxfHapVHdTPFprw8lFmy6HLj6
         Q3sI+15+VcmUxWnFVDASb5rfMVTzdQjpIDJPWE7ycf0MrQC+zZrvG8lLbUEzoTQTdIaI
         fsjPRgEMVu37GyrFZm9Xd4LF81Md5NiGmknEnBBlBd2LAMyT/ARw3Ozuy8GPsnlXEEDz
         i+NcPI7HyepLPDfPrwZiaabKh2WNKtvVQ/nyURfRhQV37yPHimOB14SMxNDLvQadvAS8
         12UMtNX5Yw0Yl3Pp/ssT0tv2DXNb2I3TZHjQFWwTVPNdWf045X0NSVj46+i+mDeGCg32
         vjig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787582084; x=1788186884;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=03W8AdXTU8nvNZrlTGS6pFe21yyktV4JnRO2xEfU4uM=;
        b=pu+stcPVi63AseJZeOL5iKA48tUxyT+sEljpozzonXCO9mUjeJkIdQEqkcfM8HYnr5
         rFjYOBQsp6zABIAy/M4E0QZBxp+aDEBOWbHIZFhMpc1Dd9LEG+y2Es8KjDbSe6akOM0G
         Nj2iZCCj+Qi0x3WixpfABxTNgUrJybnzKv6jYIBrOglylynMTEXvxh8/+gcikHSb0OcT
         iNLx7KDJTyq1re2uFgUQeA0pXT0PDuPsYWmZSfIt4b0QIQ8VeX7GPy0beEpZPQMHc6r4
         mHMw/NpzWNG5tYhelhH/OztvYn1369dl9joe8Ly5oAvRcftwrQCzgJ5nikbz/BuCnX1Y
         nkCw==
X-Forwarded-Encrypted: i=1; AHgh+RpneQLvn9nxtPoZrWp995HCEHewasKOlkj2+l2bMQU7THtod94ogEkbR67YLHMxl+/SCkbFzsjugg==@kvack.org
X-Gm-Message-State: AFuF++neMCA420QDGJXpA9bjrp3UhFyv2Rz1OXCSdooC67v+HLQiSwXR
	ZUWxQPHOP8cqoIgJjQXaIy2iCR0ogYg3HyZ70gHX6UoILgB3Dz1OKoyu3T6wpB0Lvw==
X-Gm-Gg: AR+sD12QEScrc03CUdzpxe6Fj1rkic5kkmV2HtDcjX1LWlui2L8+txhON58ANa92Eof
	89f7Dg6TcWH5X5/GC8V3BHqqJjusOyESH4pdMjXho3UfddGGMpuvXj4g125oQyPcklihhIeg2wi
	6dADXJftR7mC1n7Op/bb09OFpwU/3jGt4+051jlZ8H1dC3gpKfLA8enJ8yAn2w9Smcim4BoavYB
	E/4WYCq/Fz6IDHp6PFfdCiCbvYIExeTmOCaK7EMNQz8t5kfjanSHtE+G1nrw10xT0v4m0801oXg
	cLuE/dtniV+PCSGMiaEn5brFBaRyczHJrMw47vNE+937kvfRLuViegxY1IHNCvHfzRDmY4PVZjT
	7PFti7zQi/OEUghaH7WpUPrHMZFeDCYpRuSGZaQP0VjmTI5XEtjkKp3M4phBWZp6ORH19g92z7w
	S8nOzBLTxyi6R/mybvFDG6qebVkqIrJM4OWeJQqDFteVgLlmVStU6rPDz+Nm5MEe4hVGLtZQQGB
	ltU3+gCLkf7RRBdk7UtkksG0b/+nfEKhW2Pp03XQe8xibH+EGyNo1c1mS0=
X-Received: by 2002:a53:bd04:0:b0:668:1e79:116e with SMTP id 956f58d0204a3-66ce5bb3350mr6460594d50.27.1787582083708;
        Mon, 24 Aug 2026 07:34:43 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66cf4662219sm3783915d50.7.2026.08.24.07.34.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 07:34:42 -0700 (PDT)
Date: Mon, 24 Aug 2026 07:34:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 18/25] mm/fbatch: remove lru_add_drain() and _all() calls
 from various
In-Reply-To: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
Message-ID: <0b9e175f-edf5-630f-afd5-e71fb4e9d376@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: ayetsoh3898ybbb41r9ftxamyzhnb1m4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 80CC640003
X-HE-Tag: 1787582085-809265
X-HE-Meta: U2FsdGVkX1+cHFeJt0JI9v4iowSZ2RU3WIjBKUgPBGAW1lQFLOv3bGYkmPyBRpOsuOldaekEamFozVV66cudyLnpDIBJdc/dpBrl8ACFdETrjClyDBC8yukrhqBPqnww/4cHHcR15YC9YeLOfAT1caxQ35kwfS1HjWMxTt0aMA4KZacq4nnWctY0dxAZWedrKmF5UKykgjDTFYRaJbeNOZ0AslmW3yC3jrPQKyWSrXLvn3qNeF/0ZAnD94p38nWmhc3AD/+ejzz36chezgHoPoKXdlLlvLRexFXTrvRWTFWgvowwToZXT2CvjbDOwUjp9/WQ88Rdnr2MQYtI0+zu91uUgEhf7XvWCAhdonrDaShQPYlQbyh2qNHoktnc/ETMNYKsq4FPgIdEfHjRHdkl3Dl12pJuP8G4QTSr6nEPwkogHy3d25ylOOIa59iLg5XaOhNi9U716Uggx5bvezxjHkSuiHd20IhF72ZVoJokrgEtTpnS2AE9/bT/cWm5oMy38pmvHdPVLkR9yWTtYvR0XyOX+k97huGIea5diEUneaFJgrsDz7GFIoGAqNjuzkQtOUBRlRxosMCzWMrLzI91WsY+esBKgbRSNGwQYIw3uVhzyM9xTpYv2irtV1EtkX+pk08Hfzo6EAf3A7CgCy9LNMNE/mkm2MuXmEvjmcvMlWbcl3Rl0NBz1+eBND1YKsH2rvJW8CPWXx7rT8+yFhGm18Dl3tBtXuskfBwfDyNUV9kbc+C9DH/dI4SPVvXxlSdxsGLLCqddd/ff+CMBLAH6WM4wUfz/93yTpTO6TviggWoxJ+BiqAA5r2ELVq2yGhnYKsnM2JWvdy6UYL7dxfo0KAyh2qnj/PYSUhX6vldG5UKC9zd4OmRRit///vSURk6Wt7n2gb/gAb1joa1DYYGvtewl0UYPF1sdE/yDA60zExZ6/slsA5uiKtG7ARPOgH/kJNdeKLuSQozIr8fKoeL
 ED88M2mr
 ntGVnqLN47Jc6QF0d8J1SjMkj6m/hsNHqB9NeuHiUjR95TxyUU7CUE3sUhi0qXYP2frKeiTRmElNpiFj71KCCe+2XrbbRiqkcy5HshIzOcfNywmylot7VUC910qnrjkBGK5K9+Yf26Ntm6B2QsVxIbMoPCFsBnrbZNC0TA/gCwzkOXkV82g/0tu+ODBp5fraef9R3rbkIU2IJjH5eVA2P/C6T2dgl4PIJBA6JC/3UW1/EtDmTHDiu5Ejdekv6rutyn5Knkwt5OFou4+CwXLqb58waPsVTwexAqdqjitE2uyQnNgTAQesk2xdTeAZf0kSWIvnpFGazkPuxtU8ZCQonkUe6MISDz67sw1LNp+LhKjgLfnDm6TFJrs3WLjVRHwWFP2L/xZswxQk004lCSS9RlFKpvSFsoZkYVbaJM5dRvkZO2uxnXK4G1vLZPeXap3mqCfecC2ULEV5QRhQM5rrFrGNs/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Splitting into little patches gets tedious: now that folios on per-cpu
fbatches no longer hold an extra reference (and have the lru flag set),
most calls to lru_add_drain(), and more importantly lru_add_drain_all(),
should be removed.

Remove lru_add_drain() from compact_zone().
Remove lru_add_drain_all() from compact_nodes() and compact_store().
Keep lru_add_drain_cpu_zone() in compact_zone(): it was always a bit of
a hack, a cheap way to get a local_lock() around pcp drain_pages_zone().

Remove lru_add_drain() and lru_add_drain_all() from generic_fadvise(
POSIX_FADV_DONTNEED), but still retry once on failure; remove outdated
comment line from mapping_try_invalidate().

Remove every lru_add_drain() and lru_add_drain_all() from khugepaged.c.

Remove lru_add_drain_all() from KSM's scan_get_next_rmap_item() restart.

Remove lru_add_drain() from wp_can_reuse_anon_folio() and do_swap_page().

Remove lru_add_drain(), lru_add_drain_all() from migrate_device_unmap().

Keep lru_add_drain()s in mm/gup.c populate_vma_page_range() and
faultin_page_range(): good housekeeping after a bulk operation.

Keep lru_add_drain()s in mm/madvise.c: the ones after a bulk op probably
do want to "Push any new pages onto the LRU now", and update the stats;
the ones before a bulk op may be trying to stabilize initial conditions,
or to minimize draining under ptlock.

Keep lru_add_drain_all() in memcg-v1's mem_cgroup_force_empty():
it probably does want to push onto the LRU and update the stats.

Keep lru_add_drain() after bulk op in mlock_vma_pages_range(), partly
for "Unevictable kB" accuracy; but remove the lru_add_drain() before it.

Keep lru_add_drain()s in swap_cluster_readahead(), swap_vma_readahead():
they do want to "Push any new pages onto the LRU now" (akpm 2.5.46).

Keep lru_add_drain()s and lru_add_drain_all() throughout mm/vmscan.c:
it works on LRUs, so it does need folios to be on an actual LRU.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/compaction.c     | 12 +-----------
 mm/fadvise.c        | 17 +----------------
 mm/khugepaged.c     | 11 -----------
 mm/ksm.c            | 12 ------------
 mm/memory.c         | 14 ++------------
 mm/migrate_device.c |  9 ---------
 mm/mlock.c          |  1 -
 mm/truncate.c       |  1 -
 8 files changed, 4 insertions(+), 73 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 9e045a90ba21..8ed375b08f3e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2652,9 +2652,6 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 
 	trace_mm_compaction_begin(cc, start_pfn, end_pfn, sync);
 
-	/* lru_add_drain_all could be expensive with involving other CPUs */
-	lru_add_drain();
-
 	while ((ret = compact_finished(cc)) == COMPACT_CONTINUE) {
 		int err;
 		unsigned long iteration_start_pfn = cc->migrate_pfn;
@@ -2969,9 +2966,6 @@ static int compact_nodes(void)
 {
 	int ret, nid;
 
-	/* Flush pending updates to the LRU lists */
-	lru_add_drain_all();
-
 	for_each_online_node(nid) {
 		ret = compact_node(NODE_DATA(nid), false);
 		if (ret)
@@ -3036,12 +3030,8 @@ static ssize_t compact_store(struct device *dev,
 {
 	int nid = dev->id;
 
-	if (nid >= 0 && nid < nr_node_ids && node_online(nid)) {
-		/* Flush pending updates to the LRU lists */
-		lru_add_drain_all();
-
+	if (nid >= 0 && nid < nr_node_ids && node_online(nid))
 		compact_node(NODE_DATA(nid), false);
-	}
 
 	return count;
 }
diff --git a/mm/fadvise.c b/mm/fadvise.c
index b63fe21416ff..f788a5020384 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -143,27 +143,12 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		if (end_index >= start_index) {
 			unsigned long nr_failed = 0;
 
-			/*
-			 * It's common to FADV_DONTNEED right after
-			 * the read or write that instantiates the
-			 * pages, in which case there will be some
-			 * sitting on the local LRU cache. Try to
-			 * avoid the expensive remote drain and the
-			 * second cache tree walk below by flushing
-			 * them out right away.
-			 */
-			lru_add_drain();
-
 			mapping_try_invalidate(mapping, start_index, end_index,
 					&nr_failed);
-
 			/*
-			 * The failures may be due to the folio being
-			 * in the LRU cache of a remote CPU. Drain all
-			 * caches and try again.
+			 * Retry if any failures, in case they were transient.
 			 */
 			if (nr_failed) {
-				lru_add_drain_all();
 				invalidate_mapping_pages(mapping, start_index,
 						end_index);
 			}
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b237f6e7662a..904a45c11fca 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1225,10 +1225,6 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 	if (pte)
 		pte_unmap(pte);
 
-	/* Drain LRU cache to remove extra pin on the swapped in pages */
-	if (swapped_in)
-		lru_add_drain();
-
 	result = SCAN_SUCCEED;
 out:
 	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
@@ -2325,8 +2321,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
 			} else if (folio_trylock(folio)) {
 				folio_get(folio);
 				xas_unlock_irq(&xas);
@@ -2340,8 +2334,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 				page_cache_sync_readahead(mapping, &file->f_ra,
 							  file, index,
 							  end - index);
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
 				folio = filemap_lock_folio(mapping, index);
 				if (IS_ERR(folio)) {
 					result = SCAN_FAIL;
@@ -2981,8 +2973,6 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 	bool wait = true;
 	enum scan_result result = SCAN_SUCCEED;
 
-	lru_add_drain_all();
-
 	cc->progress = 0;
 	while (true) {
 		cond_resched();
@@ -3214,7 +3204,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc->progress = 0;
 
 	mmgrab(mm);
-	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
diff --git a/mm/ksm.c b/mm/ksm.c
index b4142746777e..5bae928620ad 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2626,18 +2626,6 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		advisor_start_scan();
 		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
 
-		/*
-		 * A number of pages can hang around indefinitely in per-cpu
-		 * LRU cache, raised page count preventing write_protect_page
-		 * from merging them.  Though it doesn't really matter much,
-		 * it is puzzling to see some stuck in pages_volatile until
-		 * other activity jostles them out, and they also prevented
-		 * LTP's KSM test from succeeding deterministically; so drain
-		 * them here (here rather than on entry to ksm_do_scan(),
-		 * so we don't IPI too often when pages_to_scan is set low).
-		 */
-		lru_add_drain_all();
-
 		/*
 		 * Whereas stale stable_nodes on the stable_tree itself
 		 * get pruned in the regular course of stable_tree_search(),
diff --git a/mm/memory.c b/mm/memory.c
index 8da0f945141b..1478bee69e30 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4251,9 +4251,6 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
 static bool wp_can_reuse_anon_folio(struct folio *folio,
 				    struct vm_area_struct *vma)
 {
-	const bool maybe_in_lru_cache = !folio_test_lru(folio);
-	const bool in_swapcache = folio_test_swapcache(folio);
-
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
 		return __wp_can_reuse_large_anon_folio(folio, vma);
 
@@ -4264,16 +4261,9 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	 *
 	 * KSM doesn't necessarily raise the folio refcount.
 	 */
-	if (folio_test_ksm(folio) ||
-	    folio_ref_count(folio) > 1 + maybe_in_lru_cache + in_swapcache)
+	if (folio_test_ksm(folio))
 		return false;
-	if (maybe_in_lru_cache)
-		/*
-		 * We cannot easily detect+handle references from
-		 * remote LRU caches or references to LRU folios.
-		 */
-		lru_add_drain();
-	if (folio_ref_count(folio) > 1 + in_swapcache)
+	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
 		return false;
 	if (!folio_trylock(folio))
 		return false;
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 18d097c38853..d3f865904c48 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -575,11 +575,8 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 	struct folio *fault_folio = fault_page ?
 		page_folio(fault_page) : NULL;
 	unsigned long i, restore = 0;
-	bool allow_drain = true;
 	unsigned long unmapped = 0;
 
-	lru_add_drain();
-
 	for (i = 0; i < npages; ) {
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct folio *folio;
@@ -600,12 +597,6 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 
 		/* ZONE_DEVICE folios are not on LRU */
 		if (!folio_is_zone_device(folio)) {
-			if (!folio_test_lru(folio) && allow_drain) {
-				/* Drain CPU's lru cache */
-				lru_add_drain_all();
-				allow_drain = false;
-			}
-
 			if (!folio_isolate_lru(folio)) {
 				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 				restore++;
diff --git a/mm/mlock.c b/mm/mlock.c
index 97134eff6b56..971430e6251e 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -424,7 +424,6 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	vma_start_write(vma);
 	vma_flags_reset_once(vma, new_vma_flags);
 
-	lru_add_drain();
 	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
 	lru_add_drain();
 
diff --git a/mm/truncate.c b/mm/truncate.c
index 4151f7a167e3..7ea5d513f76a 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -571,7 +571,6 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 			 */
 			if (!ret) {
 				deactivate_file_folio(folio);
-				/* Likely in the lru cache of a remote CPU */
 				if (nr_failed)
 					(*nr_failed)++;
 			}
-- 
2.51.0


