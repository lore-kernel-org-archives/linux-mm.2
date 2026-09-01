Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B219FC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:04:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6256B0092; Tue,  1 Sep 2026 14:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7E736B0095; Tue,  1 Sep 2026 14:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994576B0096; Tue,  1 Sep 2026 14:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B89A6B0092
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:04:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02FB64050E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:04:54 +0000 (UTC)
X-FDA: 85165969350.20.7EE7701
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id D278340016
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:04:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=glUN2h8V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788285893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dOz1krN267PV7V17AIqqrWGTGxRYupDIfzMS/Lg6eMw=;
	b=nf6r5OYygtPTFkg/r+WO5doK5+aaMghk+nZnS+ToeE2VpOXUJjWE1VZTHJkfUKblaWGRKL
	nNZJN2/SGRi3oPQD69nDJRqLczLQpbrXvdgqSuGjKZUtYZ1GVni98Z/7Lygn52N/k4JFiu
	x5UC09IAjM88EEPy53/yDbT9A+hP3bw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=glUN2h8V;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf17.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788285893;
	b=KvCy12dOAoAhL2QuUChBn744yVFSwYlNiwRLAWLO+kAXfBmpWytme7rQcrVFD3nmb3bQDo
	Q69e8OfeovPHig/Qup+eEDzJUqLS3r9blcs4DKpZAA9e+BZODMZY/EkyoKWJWtqRfUDRcP
	ZohmIfOiK/I8iGSMvO3Ea59JFVOaDck=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788285892; x=1819821892;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nNUOQ53mCgMpPjgv1qlY+smXo0g2ub8CG3rXMPfCGKU=;
  b=glUN2h8V47xpu4+6HmdvRbyVi0EMDOyHWKH1nlJoH4C2pYXPCMN7kaGh
   yS/CW3U0bY1hSeQ0VtzDG/xxd9poN5TTmml9HmB4r49nsAnrMV4680p09
   oOgdG73iu/w3gYhSFoqDMag2SI3Xs7y34ctPCBWt9JKl5TXcHvxRzeja3
   DI39cjIgS5WqhQaM3h8iDtlEUOA5KFSFgRXUD4atmeaeu7iiq7kmGSXZx
   qWnqadmGBNr45Pn+XXDELdcWHxqMNzNTnIB1tRcmmj3AirnX42RrJsSaz
   hR1d+oyNJOQIUjfXUp/mOJqE4rqmRHfrE31eS/YkY1weUxDu1iFZxnMoz
   w==;
X-CSE-ConnectionGUID: uq1j8IvcSfmIEbiAuJNj2g==
X-CSE-MsgGUID: mguY9VhRQZmsO6JeOFzT0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11893"; a="88776756"
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="88776756"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 11:04:51 -0700
X-CSE-ConnectionGUID: NFPKzk6/S9CCfkjjhZM3fQ==
X-CSE-MsgGUID: 7NKwwtBCQqGdY3BjvqLHUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,256,1779174000"; 
   d="scan'208";a="299058696"
Received: from jf.intel.com ([10.165.154.102])
  by orviesa002.jf.intel.com with ESMTP; 01 Sep 2026 11:04:50 -0700
From: Ehab Ababneh <ehab.ababneh@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Yu Zhao <yuzhao@google.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-kernel@vger.kernel.org,
	Ehab Ababneh <ehab.ababneh@intel.com>
Subject: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios under refault pressure
Date: Tue,  1 Sep 2026 11:06:43 -0700
Message-ID: <20260901180704.168106-1-ehab.ababneh@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rnt3y5ex5kxx7prdnowzh83jw6ar1zt9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D278340016
X-Rspam-User: 
X-HE-Tag: 1788285891-579030
X-HE-Meta: U2FsdGVkX18ukaIZmZK6Tj+klZHu9c/Bl4rDkKS3Q66IGOYLr/VWhj9tWDYYC//R2m7JlPlwZiaJNPG5S/3PIL6JJ8BoxG4JEqLAeTb7vGg5aqsirHZNiKKMxgZ3TmT/CcMUql1FaGsyAsxsoOnE10SkhCwcs9fCih1iVgmbkxC7c0yHJATueQfC7hoi8ovcqh5nMt7CGpn5weXkbsuRcaUmakwFfM+TP0rbggc/WyT+l4Xll0K6mgLtVbh8OsHWnY0bufEhKuLB0uFTG0RlNEOp8vVbvPJUZ3AeLCKL+1Q6XpddOKk12KqMYHGDTqcUu35A8SkcaYE8ZyBymKTKNBbreJm1j5sN7fhn5T6uYOT0c/TLasNoXr3duVz4q+w+Dgq2HUEkEatj/04dREcFvKzW1BchN1Rudz1UUVowR61rTerKCOr0BIkgenub8Ff0z+kiDdCvt1MI6nEIONlYa1sCvMxsehcgLp1CJZD8Znw2MddMYERPdTwusXQLJ+4TQMi42r2S6g3JlW81uFtteKezRTif3bFSbfJBgcv1y5xlOjzgu4hBfQt9+RD5tWeSRnhQCob6jK5tE2dv7rU1K/LvmLePd5h7o1mwVo0vwz+Ueop0t6/k1gnb5jHNKkmkrTcxuh7/2KrVQE2rjvmhVgVYHaD6AIWwUl1ya1Ai/MziuuAXcNTOqtYhdSqN99lAx3cAjV3ooSGF+yEOZvapQ9AbMN971Wz5aI+kz1B33RWi1ddzzwWqgCnvdqD51yregWQs+U9Kcqh9JlSnxmPd4p1tGLN7KyXj6oRCoAGbb9ebJxAejoTguMsXzI3NsUZ6f3xQ+8kK8MZv30UmGTKhlK8VenYleVYyeEXa2aIAXROslX1bSb/NjlAKiaPUj9dtfFYBQJXz3XOJwhSvoEx9ju8DDGQEYhEYBHmA66jelXpdF7tYQ/3QUq/0gqEZR6tg+9xhIYK1C2X4B80dOjO
 Xsezv7cD
 KCw6Gjx4pCU1eNRh6FXKu+1SzGPpmi8/wfdowQiLwKamMI+SY2ojizxyvu5WDqcuAAv17WvdZipfw0gKrLWSWfIZYKImQ0BCQ+m+xfA02PYrmIFGK/ugGXb6z7LeRpy7CQL8UKlbhWBpcVJDsMhkd8nzAEij1CJDcRYDcE0ivQR9uc965uwj+45ZhRSWuOpb/J19CPHUNsn9Fjsj726QoBrf8KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to replace
folio_set_active") introduced a regression for workloads that rely on
readahead to keep sequential file access efficient.

The problem is that MGLRU can place fault-path file folios in older
generations, so memory pressure can reclaim readahead folios before the
workload touches them. In our Cassandra read benchmark, this raised p99
latency to about 9.2-9.5 ms and cut throughput to roughly 41.8k-43.6k
op/s; the revert restored the workload to about 5.5-5.6 ms and
51.9k-53.1k op/s.

Readahead is important for sequential I/O and mmap scans, but it should
not be retained when the workload does not benefit from it. The goal is
to keep the optimization without keeping readahead pages alive forever.

This patch provides a middle ground: keep the original behavior by
default, but temporarily protect fault-path file folios when repeated
file refaults show that readahead is actually helping.

The mechanism is dynamic and self-tuning:

- add a per-lruvec readahead/refault credit
- accumulate credit on file refaults in the MGLRU refault path
- consume credit in folio_add_lru() for fault-path file folios
- keep the folio active while credit is available, and otherwise let the
  original behavior stand
- decay/reset the credit as generations advance and when an lruvec is
  initialized

This means we only protect fault-path file folios when refault pressure
shows that the workload is actively benefiting from readahead. If the
workload does not need that protection, the original optimization
remains intact and we do not keep readahead pages around unnecessarily.

Benchmark results for the Cassandra read workload
(4 nodes, 720s, 100 readers):

- with commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
  replace folio_set_active"):
  p99 ~9.2-9.5 ms, throughput ~41.8k-43.6k op/s
- with revert of commit 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to
  replace folio_set_active"):
  p99 ~5.5-5.6 ms, throughput ~51.9k-53.1k op/s
- with this fix: p99 ~5.8 ms, throughput ~51.9k-52.7k op/s

The fix restores the readahead protection lost by the regression while
preserving the original intent of the optimization: do not keep
readahead pages around if the workload does not need them.

Fixes: 6cbdd9726fb5 ("mm/mglru: use folio_mark_accessed to replace folio_set_active")
Signed-off-by: Ehab Ababneh <ehab.ababneh@intel.com>
---
 include/linux/mmzone.h |  2 ++
 mm/swap.c              | 82 ++++++++++++++++++++++++++++++++++++++----
 mm/vmscan.c            |  7 ++++
 mm/workingset.c        | 18 ++++++++++
 4 files changed, 102 insertions(+), 7 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..c998b1e0b8a7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -578,6 +578,8 @@ struct lru_gen_folio {
 	/* can be modified without holding the LRU lock */
 	atomic_long_t evicted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
 	atomic_long_t refaulted[NR_HIST_GENS][ANON_AND_FILE][MAX_NR_TIERS];
+	/* credit: file refaults indicate fault-path file folios need protection */
+	atomic_long_t ra_refaults;
 	/* whether the multi-gen LRU is enabled */
 	bool enabled;
 	/* the memcg generation this lru_gen_folio belongs to */
diff --git a/mm/swap.c b/mm/swap.c
index 588f50d8f1a8..a31c9000868a 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -70,6 +70,70 @@ static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
 	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
 };
 
+#ifdef CONFIG_LRU_GEN
+/* Refill two default readahead windows to amortize shared-counter updates. */
+#define RA_REFAULT_LOCAL_BATCH	(VM_READAHEAD_PAGES * 2)
+
+struct ra_credit_cache {
+	/* Batch shared credit per CPU to avoid a contended atomic RMW per folio. */
+	/* only compared for identity, never dereferenced */
+	struct lru_gen_folio *lrugen;
+	long credit;
+};
+
+static DEFINE_PER_CPU(struct ra_credit_cache, ra_credit_cache);
+
+/*
+ * Spend readahead protection credit from a per-CPU bucket, refilled in batches
+ * from the shared per-lruvec counter, so the fault path avoids an atomic RMW on
+ * a contended cacheline for every folio.
+ */
+static bool lru_gen_take_ra_credit(struct folio *folio)
+{
+	struct lru_gen_folio *lrugen;
+	long nr_pages = folio_nr_pages(folio);
+	struct ra_credit_cache *cache;
+	bool taken = false;
+	long old, new;
+
+	rcu_read_lock();
+	lrugen = &folio_lruvec(folio)->lrugen;
+	cache = get_cpu_ptr(&ra_credit_cache);
+
+	/* credit cached for a different lruvec is forfeited, bounded by the batch */
+	if (cache->lrugen != lrugen) {
+		cache->lrugen = lrugen;
+		cache->credit = 0;
+	}
+
+	if (cache->credit < nr_pages) {
+		old = atomic_long_read(&lrugen->ra_refaults);
+		while (old > 0) {
+			new = old - min_t(long, old, RA_REFAULT_LOCAL_BATCH);
+			if (atomic_long_try_cmpxchg(&lrugen->ra_refaults, &old, new)) {
+				cache->credit += old - new;
+				break;
+			}
+		}
+	}
+
+	if (cache->credit >= nr_pages) {
+		cache->credit -= nr_pages;
+		taken = true;
+	}
+
+	put_cpu_ptr(&ra_credit_cache);
+	rcu_read_unlock();
+
+	return taken;
+}
+#else
+static bool lru_gen_take_ra_credit(struct folio *folio)
+{
+	return false;
+}
+#endif /* CONFIG_LRU_GEN */
+
 static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
 		unsigned long *flagsp)
 {
@@ -545,18 +609,22 @@ void folio_add_lru(struct folio *folio)
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
 	/*
-	 * For refaulted workingset folios, set PG_active so they
-	 * can be added to active generations.
-	 * For prefaulted file folios, folio_mark_accessed() sets
-	 * PG_referenced so lru_gen_folio_seq() places them into
-	 * the second oldest generation.
+	 * For refaulted workingset folios, set PG_active so they can be added to
+	 * active generations. For file folios in the fault path, consume refault
+	 * credit to temporarily protect folios that are likely useful readahead.
 	 */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
-		if (folio_test_workingset(folio))
+		if (folio_test_workingset(folio)) {
 			folio_set_active(folio);
-		else if (!folio_test_referenced(folio))
+		} else if (folio_is_file_lru(folio)) {
+			if (lru_gen_take_ra_credit(folio))
+				folio_set_active(folio);
+			else if (!folio_test_referenced(folio))
+				folio_mark_accessed(folio);
+		} else if (!folio_test_referenced(folio)) {
 			folio_mark_accessed(folio);
+		}
 	}
 
 	folio_batch_add_and_move(folio, lru_add);
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 56708d1d2dfd..767311593296 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3931,6 +3931,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 	bool success;
 	int prev, next;
 	int type, zone;
+	long old, new;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 restart:
 	if (seq < READ_ONCE(lrugen->max_seq))
@@ -3983,6 +3984,11 @@ static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int swappiness
 		reset_ctrl_pos(lruvec, type, false);
 
 	WRITE_ONCE(lrugen->timestamps[next], jiffies);
+	/* decay readahead protection credit so stale signal doesn't persist */
+	old = atomic_long_read(&lrugen->ra_refaults);
+	do {
+		new = (old * 3) / 4;
+	} while (!atomic_long_try_cmpxchg(&lrugen->ra_refaults, &old, new));
 	/* make sure preceding modifications appear */
 	smp_store_release(&lrugen->max_seq, lrugen->max_seq + 1);
 unlock:
@@ -5784,6 +5790,7 @@ void lru_gen_init_lruvec(struct lruvec *lruvec)
 
 	lrugen->max_seq = MIN_NR_GENS + 1;
 	lrugen->enabled = lru_gen_enabled();
+	atomic_long_set(&lrugen->ra_refaults, 0);
 
 	for (i = 0; i <= MIN_NR_GENS + 1; i++)
 		lrugen->timestamps[i] = jiffies;
diff --git a/mm/workingset.c b/mm/workingset.c
index f351798e723a..63baa7220136 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -319,6 +319,24 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
 
+	if (type == LRU_GEN_FILE) {
+		/*
+		 * Cap credit at total file pages to avoid runaway while
+		 * allowing sustained protection.
+		 */
+		long cap = lruvec_page_state(lruvec, NR_LRU_BASE + LRU_INACTIVE_FILE) +
+			lruvec_page_state(lruvec, NR_LRU_BASE + LRU_ACTIVE_FILE);
+		long add = (long)delta * VM_READAHEAD_PAGES;
+		long old, new;
+
+		old = atomic_long_read(&lrugen->ra_refaults);
+		do {
+			if (old >= cap)
+				break;
+			new = min(cap, old + add);
+		} while (!atomic_long_try_cmpxchg(&lrugen->ra_refaults, &old, new));
+	}
+
 	if (workingset) {
 		/*
 		 * see folio_add_lru(), where folio_set_active() is
-- 
2.43.0


