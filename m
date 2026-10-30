Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA559606A321
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 09:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DwUkwQUT
Received: by kanga.kvack.org (Postfix)
	id D542E6B05B4; Fri, 30 Oct 2026 05:53:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D04436B05B5; Fri, 30 Oct 2026 05:53:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF34E6B05B6; Fri, 30 Oct 2026 05:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94B6F6B05B4
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 05:53:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2332F805F3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:53:04 +0000 (UTC)
X-FDA: 85378829088.12.869B29C
Received: from mta0.migadu.com (out-130.mta0.migadu.com [91.218.175.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0F95F100009
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:53:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DwUkwQUT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.130 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793353982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpf18pDcFg7YI4Q/hA2kdDPSsZmQs/Zw5I1QxGAxjTA=;
	b=GBvUaCUfQTh+vWsX+EOX5qxqv18L3ntsmjcHHbMJINDJtDxeoeo7t8VKIxgg8A4CWmI6FK
	SusgUCIE+i/WYAq8FSZzg0BAXYcHv1ng73yo61wyQDREOpDEVP9ddSpiUHEhuqlE+BU3Wr
	I7fgtCpPT1HZ1H2wV4vpvHBhbsoJZww=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DwUkwQUT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.130 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793353982;
	b=ve3G8eFmVaEaKFf56i9wpLXU/xy9P+lMcjWEjzfDl74+7dL5RC0WY3XjZK869R9ym0WHaU
	SH2jA9YGvIp07tky7epDDAhpalw7ob8/12zEic415uK5jpKa5k9zdc7wf+EWpNZVfIb4yW
	4LX6bA5XB42yidkYENExiPqhwS4e+rA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3SGQa6//mCID9yoxC+UtR/mi1QnzOZbaQcTixVLqPKc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793353980; v=1; x=1793958780;
 b=DwUkwQUT78EfGSoSZzi6PS3g6bGSX8F3YPXW0axgEQ3taj43YQxZw/v/8tVnfqr2VrXEKVuf
 MrS9JApFmnn9kSaanNkPl3L5sL89DZa0eSy9ZIk5do0UTUbSP8NsuS9siDo77iqjKNZ4H9uNfyl
 QraIyj3+4TxRS1GB07S3yNrI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ec9f5d29722253b4;
	Fri, 30 Oct 2026 09:53:00 +0000
X-Mizu-Trace-ID: ec9f5d29722253b4
X-Migadu-Flow: FLOW_OUT
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH mm-new v1 2/2] mm: vmscan: skip anon folios zswap would refuse when writeback is off
Date: Fri, 30 Oct 2026 17:52:18 +0800
Message-ID: <20261030095223.325309-3-jiayuan.chen@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261030095223.325309-1-jiayuan.chen@linux.dev>
References: <20261030095223.325309-1-jiayuan.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0F95F100009
X-Rspam-User: 
X-Stat-Signature: p18whs4oi9mpp9395fqkous6wj1obxmu
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793353981-906206
X-HE-Meta: U2FsdGVkX19R/avcP1s8QGzE2V6PVfJDs5lfJ3RHWM4lPxLq+tOefA5GycP9fAF39g3yZM+jqFmOkY3WMeIr1AqWLVJLKGrgU2WNHn6hK887DAYIooH/JADutRhg8QmLZzvZlUwNVU6pTJjmqIn2d0HmuSetVeF+ziWbuTQLdzozY3xFjMjn379Ws5vzMviWqnuJsaCIGuJSU8hRVTtcDr86DYGQFUPGpvx62dFGsdy3Ws8yBGuSFdwxEjLJTf/YTu4aFs4Y8FyIFWBM7pRZZODPO0Emao43hCUfSwu0O1AjtovvjztcCR0ClTCuEss243HR/tsUSl87gzpB5jrdVmPDsCXBjuN/zsI978Spn0dnD5kaJzowlbObfTnVhgO4h+UqbJYX8ZsD3Hutf0tjageHiQ1CVXgF+3ZseFFuAX+x6AnlAgPgdv37CNli7rQcXHKkarLpB5tdhFsqaIscFExM0waA9W0JQievclY25l9D64/Dxw/PbV/LDaqRjmYgZxoldzm1UvMCY5FYliw45Axu6vttp0gkeNT+Ckel/kQ+IbRXJatVPQ8PTO6oZFqca3V8706l2PU+E9X0fcgI2nen5duQm3Cu/JgBOHxmQfgVUXhn0BaFhAjBk52an7HY7U0nFIDSQ0qdiOn/9Ftmt2puzw8DQcAc7JPgaDmabarSsSIcMSobW1bQk/Sa9PzeHnu7NMcYst85ilx06Tv4FIPsZuHtqzzDQXEwEBhBsQeyCfOixCRz1086+doBGHSAxfJbL6hMEnvBJ4cvK5T3Q75w4x3i/rKirSzo/dFcxAs0gD+rS7nPDC06AwkFqpZvpAf2q/qw4M2i7uLdVgvvSrgJq0pUh3ndkYn7JBXNp5+ApDU1Mt4098Lbhbz6zOjZhA7FQzvDzH+2rpnV5xKjk/YUlDVZAFUtMpgHEG3wjG2yvKx45wy7baqzHO/RcthoBiIJz89m5QE8y2huazb
 2BHLTd5O
 exV5RbeAFc1XqZX9Crz0aKricTbqrjpx2uXYOZqCDvga/hvBlqWok35ZxdZ9BsMQbjEsTPh3JEegi3Bk8Rr4e1hzDAPbyrEHrmkQwSkugMorh9h/sWBsPBzXhziqLE5942LAqy7l5iG8VtPeL47w55B9NLLAIHcxXwmH0641yWqcLn122p5AWuytJyatOFwiUUQDnyBRLJdDwYglXjLus+81hKdnyPI3nBRG55uaGKvgvBC4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A memcg with memory.zswap.writeback=0 can only swap into zswap. Once
zswap stops taking its pages, because the pool is at its limit or the
memcg is at memory.zswap.max, swap_writeout() has nowhere to put a
dirty folio and returns AOP_WRITEPAGE_ACTIVATE.

shrink_folio_list() only learns that at the very end. Every folio it
picks gets a swap slot, is unmapped, fails in swap_writeout() and goes
back to the active list, to be aged and tried again. Each round costs
a slot, an rmap walk, a TLB flush and a minor fault for the owner, and
frees nothing. The folio also stays in the swap cache holding its slot.

The obvious place for a zswap check is can_reclaim_anon_pages(), but
it cannot go there. Zero-filled folios never reach zswap:
swap_writeout() marks them in the swap table and returns before
zswap_store() is called. They need no pool space, they are common, and
a memcg-wide "no anon" decision would keep them in memory for as long
as zswap is full. With zswap full they must still be reclaimable.

So decide per folio in shrink_folio_list() instead. When
swap_writeout() is bound to return AOP_WRITEPAGE_ACTIVATE for a folio,
activate it right there, before it costs a swap slot and an unmap.
Zero-filled folios go on as before (that check reads the whole folio,
so it comes after the zswap one and only runs when zswap is blocked).
A swap cache folio with a clean flag may still be dirty in the page
table; it goes on too, unmap settles it and the next round sees the
dirty flag. An unmapped swap cache folio goes on as well: nobody holds
its slot any more, so swap_writeout() drops it in folio_free_swap()
and the folio is freed without a store. Large folios go on too. They
may still be split, before the swap allocation or when it fails, and
the base folios then come back through this check, zero-filled ones go
on, the rest is stopped. Keeping the split path as it is keeps the
change small.
zswap_store_blocked() asks zswap_check_limits() itself, the same call
zswap_store() makes first, so the pool-full state keeps being updated
while vmscan turns folios away and pool_limit_hit counts once per
batch instead of once per folio. A refused store would have kicked
the zswap shrinker to make room, so zswap_store_blocked() does that
too.

The check is made once per batch, at the first folio it could stop,
and the whole batch goes by it. A batch of file folios never asks
zswap anything. zswap can change state under us while the batch is
being worked through, that is fine: at worst the tail of one batch
takes the old path and is refused in swap_writeout() as before, or is
activated once more. Most folios are still stopped early, and the next
batch sees the new state.

Only anon folios are handled. shmem splits large folios and zeroes
fallocated ones on its own way to swap, that is not for vmscan to
second-guess.

Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
---
 include/linux/zswap.h |  5 +++++
 mm/page_io.c          | 15 ++++++++++++++-
 mm/swap.h             | 12 ++++++++++++
 mm/vmscan.c           | 17 +++++++++++++++++
 mm/zswap.c            | 11 +++++++++++
 5 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index df6cafbe95dc..b64fcdeda575 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -33,6 +33,7 @@ void zswap_swapoff(int type);
 void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg);
 void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
+bool zswap_store_blocked(struct mem_cgroup *memcg);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
 #else
@@ -62,6 +63,10 @@ static inline void zswap_swapoff(int type) {}
 static inline void zswap_memcg_offline_cleanup(struct mem_cgroup *memcg) {}
 static inline void zswap_lruvec_state_init(struct lruvec *lruvec) {}
 static inline void zswap_folio_swapin(struct folio *folio) {}
+static inline bool zswap_store_blocked(struct mem_cgroup *memcg)
+{
+	return false;
+}
 
 static inline bool zswap_is_enabled(void)
 {
diff --git a/mm/page_io.c b/mm/page_io.c
index c6824fcd483e..b4a9fe401a3c 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -125,7 +125,7 @@ int generic_swapfile_activate(struct swap_info_struct *sis,
 	goto out;
 }
 
-static bool is_folio_zero_filled(struct folio *folio)
+bool is_folio_zero_filled(struct folio *folio)
 {
 	unsigned int pos, last_pos;
 	unsigned long *data;
@@ -197,6 +197,19 @@ static void swap_zeromap_folio_clear(struct folio *folio)
 	swap_cluster_unlock(ci);
 }
 
+/*
+ * True when swap_writeout() would only activate the dirty folios of @memcg:
+ * zswap refuses them and they may not go to the device. Zero-filled folios
+ * are the exception, see swap_writeout().
+ */
+bool swap_writeout_blocked(struct mem_cgroup *memcg)
+{
+	/* The device takes the folio, also when zswap is off */
+	if (mem_cgroup_zswap_writeback_enabled(memcg))
+		return false;
+	return zswap_store_blocked(memcg);
+}
+
 /*
  * We may have stale swap cache pages in memory: notice
  * them here and get rid of the unnecessary final write.
diff --git a/mm/swap.h b/mm/swap.h
index d5bf21f517dc..51d00e37870c 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -259,6 +259,8 @@ void swap_read_submit(struct swap_io_ctx *ctx);
 void swap_write_submit(struct swap_io_ctx *ctx);
 int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
 void __swap_writeout(struct swap_io_ctx *ctx, struct folio *folio);
+bool swap_writeout_blocked(struct mem_cgroup *memcg);
+bool is_folio_zero_filled(struct folio *folio);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
@@ -428,6 +430,16 @@ static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	return 0;
 }
 
+static inline bool swap_writeout_blocked(struct mem_cgroup *memcg)
+{
+	return false;
+}
+
+static inline bool is_folio_zero_filled(struct folio *folio)
+{
+	return false;
+}
+
 static inline int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp)
 {
 	return -EINVAL;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index daa7e37c2236..d732cd378b55 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1169,6 +1169,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 	unsigned int nr_reclaimed = 0, nr_demoted = 0;
 	unsigned int pgactivate = 0;
 	bool do_demote_pass;
+	int swap_blocked = -1;
 	struct swap_io_ctx ctx = {};
 
 	folio_batch_init(&free_folios);
@@ -1355,6 +1356,22 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 			continue;
 		}
 
+		/*
+		 * swap_writeout() would only activate this folio. Do that now,
+		 * before it costs a swap slot and an unmap. Zero-filled folios
+		 * are marked in the swap table without a store, an unmapped one
+		 * may only need its stale slot dropped and a large one may still
+		 * be split, let them go on.
+		 */
+		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
+		    folio_mapped(folio) && !folio_test_large(folio) &&
+		    (!folio_test_swapcache(folio) || folio_test_dirty(folio))) {
+			if (swap_blocked < 0)
+				swap_blocked = swap_writeout_blocked(memcg);
+			if (swap_blocked && !is_folio_zero_filled(folio))
+				goto activate_locked;
+		}
+
 		/*
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
diff --git a/mm/zswap.c b/mm/zswap.c
index 572075bb1c1c..468bdec6931a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -566,6 +566,17 @@ static bool zswap_check_limits(void)
 	return zswap_pool_reached_full;
 }
 
+/* True when zswap_store() would refuse every folio of @memcg right now */
+bool zswap_store_blocked(struct mem_cgroup *memcg)
+{
+	if (zswap_check_limits()) {
+		/* A refused store would kick the shrinker, do the same */
+		queue_work(shrink_wq, &zswap_shrink_work);
+		return true;
+	}
+	return !mem_cgroup_may_zswap(memcg);
+}
+
 /*********************************
 * param callbacks
 **********************************/
-- 
2.43.0


