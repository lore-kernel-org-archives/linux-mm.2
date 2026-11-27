Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55BE8606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 06:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kDd9bNSQ
Received: by kanga.kvack.org (Postfix)
	id 1FF916B05B1; Fri, 27 Nov 2026 01:03:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D71C6B05B2; Fri, 27 Nov 2026 01:03:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113BD6B05B3; Fri, 27 Nov 2026 01:03:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBC396B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:03:47 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 418A1A7885
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:03:47 +0000 (UTC)
X-FDA: 85479857694.20.5809899
Received: from mta0.migadu.com (out-145.mta0.migadu.com [91.218.175.145])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4975C1C0004
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 06:03:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kDd9bNSQ;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795759425;
	b=30y3vhOVZk+91AA6MQGQleVBpoV86LdvzlGiotH88dUq2Yo9llt8QT+4B+Ff+7dtq1utGU
	8Wg7AGE6m2cDfavXl5g2ggAYknwNGKa6vcaR95ZqXD4rcDmEyfSk6kMgIPlAZsFSZi39WL
	XI43dootj/FiZtlMPpv8wm4bxJPiILI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795759425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QUb1wYeUzm2isYrJI+K7ablDm0oYIR9zSdI+pFNNdUA=;
	b=bk3ujIx4bulxxXD9OxeTTeVbrhbo3/8RuDauSha2EYeOydMoHurjTx0xB4rldZjO3YvxxQ
	nGWF9BJ0i5re+dBsMCY9aTJIdWdDVOf0fYZ/T+BPQfqrcKany6XH4zKQz9aHV9yzmiTJY2
	e1Rn0M35YOrSAxOyhIq9Ep7yk3VlQak=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kDd9bNSQ;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.145 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EKVxzkN5Y+NIAoY6s7UvJOfqQHCdOFwe8OiFVoEq+Dk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795759423; v=1; x=1796364223;
 b=kDd9bNSQgth7dX+rCzqv23CODYxCfZ1js3Jx++wvGqwAIIaG+ndGc6qvbcBCDmLjxiYql9ZM
 Tsuoe3LMGmNAfvtJQB9oZwTy08ePJjx4T2HVYjh3eHkm2ZZ6s26R1f6OioiBx3WpVfihn6SmFGG
 A/UQ+4PGKVyfuMqtFdSEM1ss=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id abe9cbcac2f57245;
	Fri, 27 Nov 2026 06:03:43 +0000
X-Mizu-Trace-ID: abe9cbcac2f57245
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Barry Song <baohua@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)),
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 1/2] mm/mglru: update LRU sizes once per zone when isolating folios
Date: Fri, 27 Nov 2026 14:03:14 +0800
Message-Id: <20261127060315.1119672-2-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261127060315.1119672-1-ridong.chen@linux.dev>
References: <20261127060315.1119672-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4975C1C0004
X-Stat-Signature: am3dxeua73c8tfwkbsty6u775d5rq3hx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795759425-995140
X-HE-Meta: U2FsdGVkX1+BKIpKAZHclc4KUAL5pd3cq2UHZQb1cv+zYdN5Di1aGi8w/XctD2CXEyv5FYvIVyI/T8pca/qvL6OiVP1sQvfNcoWyVQ5yxH5ooKo6HtU6xnhsQO6WJm0BgVUkV6kQU666gviHC6zFoEIz9Wg85FcWvp2vkebp2X21XeIGaObirSIJdsVdzxqmlYZvWYCxsYbvqHfuqVWKzgVD3RmgSM5JOas4xA68euiffqrAi9HAggew25nqrKgzltPbqr1cEK5kqx8FVBmfCwtifGllmaoVu8UmM9stL2F0/K6FSf9JkTrAUhyY/YaggeSnnQOTEbx34laMiS5Gdlul0wrpW4FfSxVZi5WVAhQ/UwOukhed8oQXvMwt5uKKable2dycQ5nlOJVMJKxw7wXPQWCi6FCV6lEFeUklEagAVh4s0Zj46BPAx/4oggQ1waAucNZzG0KAmbqgVBjmVOnzkVtxf/BKybLv7pg5XkdhDPmoo50yIPqhKVDy0f+q5q33h1N4SIP0YlckPldLzoby4eEWunJReM/Rgx6NWROikACgb1OTJq+5hlJ0vXJUWnbMBgMuiSeBuddhXa+6eaJgY7VGRfeil/wlToW87ak6uJZBDI9aRP6qvmjWUozevdKKwVP9wLSya3dk9jo0QN0g2wXtIuAj8PC+wxardXhbULLAQkaMI3dBl7UNetqcMMh0qnD6LXd8mg7hHAVCtcxj9wlaXpkd6aMSJyxqwQz7Jyzzplqw/7a4Ox23zhLvJNMRS52/j/IExC10evZ/cjHRlw3Wk0DrJLxFbpdTe4FDjnF48FcxAB9F3Bnwtnk45xDBweguntCRrkJ2ue5aQg5/8fKcnTl92+OHpz7Jm02I/Nyn2eGFx5ZSxytOruJVmCp/GiageITwo9Gsoz1j4bMpj4tvXFjX+9Xmr9nLMvcDNqFXb6EcJAqp71gdUPOfZBdxaGDbVtj97Pd+RdG
 HkHLlI5g
 Upf2dYZ446bwnZRwBq3B4A0rEOFqvE46hvyDoZ3igaAzxiZFmnHW8F47bGznD90ovw9lRIfHLR8tHYzpO8oj1gEk3AEAfAyLSJH+llDXSACMctFIzw8EpOp7YRt7fMkixR+XAP88kf5uL1Hqqb3+KHQ4TSak7n0qETeZgbtXNYqvGU0qlhGknTm8qF2lwo/KHxlEwpJW97UYeD22Spq4/7QlurUsdXtZLu4TETo/moj+RS1lWsPrnSHyrpYTK4F2zKUBHmputKBbKe1TqgiB7iI3kSm01pxMFYyVTRhRLU8awWrbgVuVZ1OD1fSB/CPH6Uxkfyr4C+iSJto/c7jxr3cavT8XYJUE7hAONnys2rEb++whWP1eaeJuUD9F8ihRdaJ6i0cw3Bp6J09dZYI+lXv8k7ZbbfKwgdSx2isapEN+flTm7UMtHtKDUR2hZ3ORdvp+FSaJMeQyGlqlkUK/GDp+SIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

scan_folios() isolates up to MIN_LRU_BATCH folios under lru_lock, and
lru_gen_del_folio() updates the LRU sizes for each of them. Each update
is a mod_lruvec_state() for the node and memcg counters plus a zone
counter, so a batch makes up to 64 such calls while other CPUs spin on
the lock. isolate_lru_folios() avoids that for the classical LRU by
counting the isolated pages per zone in nr_zone_taken[] and calling
update_lru_sizes() once at the end.

Do the same for MGLRU: let isolate_folio() add the pages it isolates to
a per-zone count, split by whether their gen is active, and update the
LRU sizes once per zone after the scan. lrugen->nr_pages is still
updated per folio, for the gen each folio was taken off. The active
split can't change during the scan because max_seq only advances under
lru_lock, which scan_folios() holds.

Tested on an i7-13700HX (8P+8E cores, 24 threads), turbo off and the
performance governor. 24 files of 128MiB on ext4 on brd, all threads in
one memcg with memory.max=1G, random 4K pread(), so nearly every read
refaults and every thread ends up in direct reclaim. Reads per second
per CPU, mean of 2 runs, with and without this change in one kernel and
the runs interleaved:

  CPUs      base   patched
     1    426681    424975   -0.4%
     2    387442    390272   +0.7%
     4    360312    363840   +1.0%
     8    314549    322322   +2.5%
    12    235058    242638   +3.2%
    16    184086    201351   +9.4%
    24    124478    143734  +15.5%

The gain comes from the time lru_lock is held, so it only shows when
many CPUs reclaim from the same lruvec.

Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
---
 include/linux/mm_inline.h | 26 ++++++++++++++++++++++++--
 mm/vmscan.c               | 16 +++++++++++++---
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 0a055a3fe210..84a1abee3728 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -376,7 +376,13 @@ static inline bool lru_gen_add_rejected_folio(struct lruvec *lruvec, struct foli
 	return __lru_gen_add_folio(lruvec, folio, scanned_seq, false);
 }
 
-static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+/*
+ * If @nr_taken is not NULL, the caller updates the node, memcg and zone LRU
+ * sizes for the folios it isolates: this updates lrugen->nr_pages and adds
+ * @folio's pages to @nr_taken[], indexed by whether its gen is active.
+ */
+static inline bool __lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
+				       bool reclaiming, long *nr_taken)
 {
 	unsigned long flags;
 	int gen = folio_lru_gen(folio);
@@ -392,12 +398,28 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	flags = set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK, flags);
 	gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 
-	lru_gen_update_size(lruvec, folio, gen, -1);
+	if (nr_taken) {
+		struct lru_gen_folio *lrugen = &lruvec->lrugen;
+		int type = folio_is_file_lru(folio);
+		int zone = folio_zonenum(folio);
+		int delta = folio_nr_pages(folio);
+
+		WRITE_ONCE(lrugen->nr_pages[gen][type][zone],
+			   lrugen->nr_pages[gen][type][zone] - delta);
+		nr_taken[lru_gen_is_active(lruvec, gen)] += delta;
+	} else {
+		lru_gen_update_size(lruvec, folio, gen, -1);
+	}
 	list_del(&folio->lru);
 
 	return true;
 }
 
+static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+{
+	return __lru_gen_del_folio(lruvec, folio, reclaiming, NULL);
+}
+
 /**
  * folio_migrate_lru_refs - copy the reference state to a new folio
  * @new: the destination folio
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 621214442f14..9dbdcda04f13 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4732,7 +4732,8 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	return false;
 }
 
-static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc)
+static bool isolate_folio(struct lruvec *lruvec, struct folio *folio,
+			  struct scan_control *sc, long *nr_taken)
 {
 	bool success;
 
@@ -4750,7 +4751,7 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 	if (!folio_test_referenced(folio))
 		folio_set_lru_refs(folio, 0);
 
-	success = lru_gen_del_folio(lruvec, folio, true);
+	success = __lru_gen_del_folio(lruvec, folio, true, nr_taken);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
 
 	return true;
@@ -4801,6 +4802,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	for (zone_idx = sc->reclaim_idx; zone_idx >= 0; zone_idx--) {
 		LIST_HEAD(moved);
 		int skipped_zone = 0;
+		/* isolated pages, indexed by lru_gen_is_active() */
+		long nr_taken[2] = {};
 		struct zone *zone = &pgdat->node_zones[zone_idx];
 		struct list_head *head = &lrugen->folios[gen][type][zone_idx];
 
@@ -4819,7 +4822,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 			scanned += delta;
 			if (sort_folio(lruvec, folio, sc, gen, max_gen, tier))
 				sorted += delta;
-			else if (isolate_folio(lruvec, folio, sc)) {
+			else if (isolate_folio(lruvec, folio, sc, nr_taken)) {
 				list_add(&folio->lru, list);
 				isolated += delta;
 			} else {
@@ -4831,6 +4834,13 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 				break;
 		}
 
+		/* Like update_lru_sizes(), once per zone instead of per folio */
+		if (nr_taken[0])
+			__update_lru_size(lruvec, type * LRU_FILE, zone_idx, -nr_taken[0]);
+		if (nr_taken[1])
+			__update_lru_size(lruvec, type * LRU_FILE + LRU_ACTIVE, zone_idx,
+					  -nr_taken[1]);
+
 		if (skipped_zone) {
 			list_splice(&moved, head);
 			__count_zid_vm_events(PGSCAN_SKIP, zone_idx, skipped_zone);
-- 
2.34.1


