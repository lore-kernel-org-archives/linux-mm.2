Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA61C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEC2B6B009B; Mon, 27 Jul 2026 12:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC43F6B009D; Mon, 27 Jul 2026 12:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA606B009E; Mon, 27 Jul 2026 12:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 715EB6B009B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:26:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0974880110
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:26:21 +0000 (UTC)
X-FDA: 85035084162.17.B29A682
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 53980180008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:26:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kdejEm6p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785169579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hE5H8fckKPN/KybXJL2X3Y1zfiFpP0Zt/q6Odg6IVKY=;
	b=mDASiz551LYTkfQA6y1OqGbuSIl1R7wHMqj1ussNcJZsoqoo82uk80vywGxE2bq9vAYogQ
	5cASXq5vfuNUIlo791QOuqqpKIBNfbQzodFCErN36937QhxdumwCTgSKW9cDJ5808FOb/7
	Vnqui8BCXTAWldsBThM4uTmb1msqerE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kdejEm6p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785169579;
	b=w9iQwH+93c8hwX8F7MR0lMpwPcly2U6CfJuvcM2L+NB0xIZ+FUQ1wSIzwHjUaVjRzhO72y
	ASgOd/AHGOOw3JCQkRtWUPUp+UC4N1aH+5OfZXxyySJOhVlvcRUQoDqhJlS85lJE4JOFl7
	VcZL6s4YUr5LyPaxCwILAbRx3nFYws4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785169577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hE5H8fckKPN/KybXJL2X3Y1zfiFpP0Zt/q6Odg6IVKY=;
	b=kdejEm6pjVysh0JTY+T0jinI+6498rvPiWK2fDo94EXZ4LzXSYDWHVbBwQ1E0KnEDxhG87
	rCOG6u+nAMj9VVffC5i37eJsvVYsYHsRgyRt23gppulNkrzHtisoY9CoP9bXZr4v3D2v7w
	l72FsKiuD+UtEvkhiesox44uB5lRW6A=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	rientjes@google.com,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 2/3] mm/vmscan: add pgrotate_anon and pgrotate_file vmstat counters
Date: Mon, 27 Jul 2026 09:23:24 -0700
Message-ID: <20260727162550.2032-3-usama.arif@linux.dev>
In-Reply-To: <20260727162550.2032-1-usama.arif@linux.dev>
References: <20260727162550.2032-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 53980180008
X-Rspam-User: 
X-Stat-Signature: 6a5ufzru3g7cimbx18wnxcijtsa76jfp
X-HE-Tag: 1785169579-480200
X-HE-Meta: U2FsdGVkX199cZaIgKoXl4/tY+bGip/hYIHpqVskGz62oLKRRfCXZHykuT04wqHRUUsRSl7S3i5QtCsvC8Zsk0si2neOx8HwOcisVN+twp05Cj6S1+wP+k4fAQDz2WLeAgbmlWY1xnFzqFKuWB6PH3HLpsVWUjQDwoQ1em5nqmHT31J5r8exN2xr8KAhZwIwIAHut7/4YfgiG/PpLVoAV7F7+Ew1G+dj4dPW74xnT5UzS3NrJDkt8xKxr2krRfJO5yntY6z1MnlG+i+P4GA3OK+fzNF3G17jB60/Z3M4H624XrG4NwJy+OPCh9giIKXfijeuKbFoX/VTceflKjE6jQHLYhDM6APjgUDgm3xLz/mXg1VRa7COwHXx0Od2afqz2766I0ohkiT7QisLJRpQf4MImSf/1R5f/dBLwQljsXfESU42uGTRHg1gWzMTQ1isFDfptoKAiSH0j11A/IlSKTFiJP+f6ZN7rvb0RsoHCb2c3y3rb9TwvXaYseiZZE4+MU6km8QiSVFb4iZSzShKwlqi3jYpHuGQVBRQu8e2JVe3JIYnZkV9ONm11n+4nZXWsZ9aG3ioEDpE3kCGfiXHjtsKXP0q6tsLFe7EOmRGatCI3KvJiifG7QfBtOawdTzUofilqwFPxiczKPxfEUpgSeNXZv8xrFKhMAlVFHk52rgWUqC48UdLWKTssru0MZd4NSQXA0DFuch+OxuB4FnrKg1kmaN3cb7OH/EurKWmv6mBD/fUjmn29YzobpVkYHTCJuYHEByKNEugJ/w64oy/lOMnFEA1cultcOXJi/dO/8r1vfXPjfIc3eMxoyMXWr9BkcUAeNzxpFMvntW/ZAI9SI6/C4nypSRw2aQsswKEgqFUz8LGFN0QugvtGR8qtfQz4T1nArr+ap9iVmFfcVBWHC5gzqBQW0jidU0VUJVpoLi9E3HSjJPRqzvQqyOEkYhspl1s36HOO6cUXbuyLGC
 38t74OpX
 uxx6GZcTY/exX8aBqgmpHY04Akvsf6CYws6EjN9xLKHn1jKSftfSqpIT0TpLWluy1KK1mE5kup4i773mp+sq+FdH/kcnMyjUOFln2+tBLleDEosTMmIcJcoA/nWQclAUpdOA3J8EFEMk8gkvicO6VF659WQj/iPqwNUB5P52lqxXNm8YwNELER/WbOGpX+sUgAZa2EaMmuQz4KLXFEbODYirZhakncpHAHj0OO2ngFp65Oas5AA1zn4pTnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reclaim can spend substantial work on an LRU type without immediately
reclaiming or demoting a corresponding amount of memory. Record this
work in PGROTATE_ANON and PGROTATE_FILE.

For classic LRU reclaim:

  - Inactive-list reclaim adds nr_scanned - nr_reclaimed to the
    corresponding anon/file counter when isolation succeeds.
  - Active-list reclaim adds referenced executable file folios that
    are retained on the active list to PGROTATE_FILE. Active anon
    reclaim does not contribute this component.

For MGLRU, add the number of initially isolated pages that remain
unreclaimed after both the initial and retry passes to the counter for
the selected anon/file type.

These counters are distinct from the existing pgrotated vm event.
pgrotated records an actual move to the inactive-list tail, primarily
after reclaim-marked writeback completes or failed invalidation leaves
a folio for accelerated reclaim. PGROTATE_ANON and PGROTATE_FILE
measure reclaim cost and do not imply that a folio moved to an LRU tail.

A subsequent patch will consume these counters for anon/file scan
balancing.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/mmzone.h |  2 ++
 mm/memcontrol.c        |  2 ++
 mm/vmscan.c            | 14 +++++++++++++-
 mm/vmstat.c            |  2 ++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..aab06fb6c6d5 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -323,6 +323,8 @@ enum node_stat_item {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index de84c399cea2..23adb698dadd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -419,6 +419,8 @@ static const unsigned int memcg_node_stat_items[] = {
 	PGSCAN_PROACTIVE,
 	PGSCAN_ANON,
 	PGSCAN_FILE,
+	PGROTATE_ANON,
+	PGROTATE_FILE,
 	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e8a90911bf88..053f41584989 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2043,6 +2043,9 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
 	mod_lruvec_state(lruvec, item, nr_reclaimed);
 	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
+	if (nr_scanned > nr_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + file,
+				 nr_scanned - nr_reclaimed);
 
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
@@ -2152,6 +2155,8 @@ static void shrink_active_list(unsigned long nr_to_scan,
 	count_vm_events(PGDEACTIVATE, nr_deactivate);
 	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
 	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
+	if (nr_rotated)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + file, nr_rotated);
 
 	lruvec_lock_irq(lruvec);
 	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
@@ -4815,7 +4820,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	int scanned, reclaimed;
-	int isolated = 0, type, type_scanned;
+	int isolated = 0, nr_isolated = 0, type, type_scanned;
+	unsigned long total_reclaimed = 0;
 	bool skip_retry = false;
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
@@ -4827,6 +4833,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
+	nr_isolated = isolated;
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -4839,6 +4846,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 retry:
 	reclaimed = shrink_folio_list(&list, pgdat, sc, &stat, false, memcg);
 	sc->nr_reclaimed += reclaimed;
+	total_reclaimed += reclaimed;
 	/* Retry pass is only meant for clean folios without new isolation */
 	if (isolated)
 		handle_reclaim_writeback(isolated, pgdat, sc, &stat);
@@ -4892,6 +4900,10 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	if (nr_isolated > total_reclaimed)
+		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
+				 nr_isolated - total_reclaimed);
+
 	return scanned;
 }
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index c4364f0eb08a..87d4a6781367 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1300,6 +1300,8 @@ const char * const vmstat_text[] = {
 	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
 	[I(PGSCAN_ANON)]			= "pgscan_anon",
 	[I(PGSCAN_FILE)]			= "pgscan_file",
+	[I(PGROTATE_ANON)]			= "pgrotate_anon",
+	[I(PGROTATE_FILE)]			= "pgrotate_file",
 	[I(PGREFILL)]				= "pgrefill",
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
-- 
2.53.0-Meta


