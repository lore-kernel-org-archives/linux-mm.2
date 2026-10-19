Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A507260774DF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m8LxZuuc
Received: by kanga.kvack.org (Postfix)
	id 66BBD6B02C3; Mon, 19 Oct 2026 11:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CEF56B02C4; Mon, 19 Oct 2026 11:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496A06B02C5; Mon, 19 Oct 2026 11:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16B446B02C3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:50:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9688980756
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:08 +0000 (UTC)
X-FDA: 85339812096.10.21711FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7E5F440005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8LxZuuc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+S/ugjb/OJ8R7PrPj5yXY/1bn/4OHkMP3wOgkiMBWs=;
	b=TrLBn0T+8c9LjZvxTMN1Py5PSylk5rrFE6ANxHelb16s+AgdYc8DCCdUy69zu1+q9oCLBi
	ifBPNbDeTN5XESzpP3hv5kymr1unrBDlOrbdN/yC6TvmtUCTLDgqD22k9j4HYDcvuQqC8J
	jw5+ILpODC8qVJhyd6u5Tof6f09ejQQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m8LxZuuc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425006;
	b=1FZx7HBwAgC5f2z3S9iRwPDL004bKpeDtJo6UtTdjQfXOjOd1Xe6IF9FNnQ0kCr/hc3wsZ
	ULKeXbLpFUG/yxOmdYnbAKtx5muqIjEpo2vUHw3jwo1cupDVFSJS9m26+xVeKKbPN+UwX9
	qTpT1Z3t01tzJQyOOOjUqCOxqoMrHEk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB92643DBA;
	Mon, 19 Oct 2026 15:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27471F000CA;
	Mon, 19 Oct 2026 15:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425005;
	bh=n+S/ugjb/OJ8R7PrPj5yXY/1bn/4OHkMP3wOgkiMBWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m8LxZuuclx4RHUS5jJjxSkOswRLlo5pjpQ9wupaEyFZ89DFiWI5oq+M9ZzjgAB5R1
	 WPcMXMgZzy1vi4i/u5ggPMYZkLowHSr74F/i92yHV0QEVfNmxhyg8G2NeUkQZt799w
	 feBYtEiHDm8syHRZsZGzw2kebSdhmFvt1+EMyEWvBGtehsIUQw+oa+wP7VGuomIw7Y
	 2bEWbG6aITVhZMmPQKe416GSU50vDxW5pvwPhZwh6VKxax2HyQVGDCYHLo0qyFn5Dn
	 uB7w65BUXz74SDKmQpLLGupvtAB6qxNXykZJ6azmmFMNxxmAOvK9eZbCPZmHmxrHPP
	 8j2EK1MsXYTSA==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.ams.internal (Postfix) with ESMTP id A05B3198003A;
	Mon, 19 Oct 2026 11:49:57 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 19 Oct 2026 11:50:01 -0400
X-ME-Sender: <xms:JTzWaopAIuIDyf2I74LXEv-XB9cVY8to4rbSy9ZZmVSfqR6AKR35Ag>
    <xme:JTzWagKTkPu3TQuZhTFQ0pY31niVDCx9HEIJNcWzTtu8xnox9YoMGBNc9j7643UPg
    64JwUP8kKO9d9WaRGEZT-L2-1BboOAlMUiAbWbr-15PWaoUnWkyggV7>
X-ME-Received: <xmr:JTzWal3ykveCNXQdPFRa5ZVVKd7BcXSNTlYTfQ0BKiesKt82pNTriG4lGtY>
X-ME-Proxy-Cause: dmFkZTFpjrG+2jfVBfklNRE95oThC60xlhUtv5sioyJrfpDDHbEB/2cXkTI411oJriXTLs
    N7RLfOUdBbmoibSFu4zT/f1BKPPyxkEYUp5eDeafGhPQjcnfJv/29ZtYwE6q77Fr7A6zQu
    C94bEu3EPqJJ50fLC5xP9PtYZOq3sS+jMfKkgkZFNUAdZxkDiyHArLijwBk9MwzijLWdvR
    4raSXvkSyIGvp9XYd2doZUGuEANzDQejgJzzg3ARZCjBL2yZfXIvLZCg0AMujDeTHEemYv
    cvWt94P7AS+P1mtikHZvyS9eAaK3Fy2/TwDlvaPXULPDsZK9f0sj0aca+uCBBoNs4d3uVo
    YdtzlwPs9YNSDvT8I3PUckOtBZwF77w7yengukH2a2sZdb3tiP6Qlt9T5excPi6bNA+J9g
    mqbobw5Mi702UDCjkOsfr5wroidnBhzWPbrlA+FCXpkk1xOe0/EVkUvBzzMoafJuBeCCLL
    WBPgNlBt2yek1h9VvQvgT19ztxgajydWWVggL5ja5MkU8lXwa1Ls+occorai2u4Q8LDn1P
    8mDhUG6AEuUB2cC14L0ld1brKkx1KVX6VyYLkLq4OMYy5fXiCB2XT9oTKPtorFOMkSTp2b
    he8TCnhUR6vRkWMBzCEpOD/1xv5Omsu8k9kWVo4e6H2Xrswc560yXC96kwaQ
X-ME-Proxy: <xmx:JTzWah7SZciXoDdIPr_MZb8C70JfG8HRwOh9031XvV3-l1ZMoQnJBw>
    <xmx:JTzWarOkSc0YPOKweoj6Gk8H_BneJzTgdHfoULE1UJS_dq_jlzagXw>
    <xmx:JTzWatI3M2QHX0XvNPEGidQgeEZdeE5HtYJGCvCl_qU9LrUzxxhW7g>
    <xmx:JTzWaupm7Od-1U0qODek8Ph3PRhfJ9-90Yvai0JtyCwnQy8v1fbzEw>
    <xmx:JTzWaoZ3WArj8sNRHixTlUdM0S7AD21SZyTwmLZB8Z5Ha7ZLKfsOH_d5>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:49:56 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH 06/18] mm: free the pages waiting for a grace period before OOM
Date: Mon, 19 Oct 2026 16:48:59 +0100
Message-ID: <20261019154913.1765974-7-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E5F440005
X-Stat-Signature: s5mweb6czqomkxijc79dd86gaf9dmo9g
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792425006-692095
X-HE-Meta: U2FsdGVkX19r9ZewJzzEJNIdi531VgnM1cnhwN7RC8V8t5aeyJdcf0/JJgku/pyI+3Hcf4mNawHETf22Y902vivE9tf3imQV2cVTblyKmsN/J8zB8cDuXaeel3bq8VDDu+oE/TsMolWc6SJrZnpIDUe4F4czdtJDwYlKLqVMhvHIycH/NmhCVIyGx/FizhwdP4T3LfQQJpfW5EeejiwOaNNryTzOnGP+BhTX1/nTiUKoq95Y0Qt6gh9C0Xm8VSbArjn+95pofPG+rowqKGL/zf2vjrkmExJHv6s/ib+ZTMJQMtgu1xymCpLx45CUN8y3UuCIjYNumZdLv8jc8aM7kYbF+SQWMHrBiuvbZ9G61RcBjoWGWarXEwmKbDbHStD69vYwDu3NJCG1xXcPzSU2Z8sMgu8drtcEtzKdaCVJb8VQc62Cs3OcZytcEfloFB1piIupyTdz/6ZFBemJzGDaySAsrhfl59qbU0YotMuOVJGZsWnoEtNj1t5U4o4w3A7ygicz8IP76OLfhw54Zw3La0WL4Bd7h/7pMXxXmqpbPyzn5OLloAMVKhaye6w8xynoYR0NbkgnW1qOt51uEy/XBO7LJ6iu7FiRv6Z8+lmqrVSxl5eZ7kBYy5eIylFSFznL0YztyPU6B7NngQN14OI4sRJfmm4IjHqTvg8ZEg5vGWUVydeiFjfrwOn0QNmLgpLLx82FcF+9ZpO9gslxsxYhBs3UivO4GNyz2Z51n1UB6MT9fcKGH9Af9hjtSu3w52pJkVvpzEtolh4tZbhpEVEhWjloyYvrj/xXrj5UzuwG+6zfD33u4jAAjb4Odrzp8DAthFJc9Wvk7dOlxucVbnHMQn60WFpFPZlYbtvQqRjLmBognNckwzm9/JLLR4MjInuulNkJ4tfAIggnOGsuAER5wM8IINkoDPJAFAzouRvKwbxuNLdTJuau9H8Rkq40zEMMpAyb0KaxkJatBhN5AMe
 m+8VTg97
 37ppp+X0glgRXFFNchksl0rKQeufwpT2v2zWVPUIiFbLjWxtWri3e2YGK0BGdKS3ogyJmmychDF1UXxfkWbRdOMlA2E3hXnQQ0NbCjhP0GV4ZAVrExVUPbIjjAXPAFIrgJt8s35NDSrhp6+t321h2+qzQQ1SPQUp9WVVR005uJyN3/Zgg1eyfFXiTQVuwgFU8ZxnU63+sOu/Q5To+77jjaoIiPsRZgecU3Yin3CXJK1vDkJx2rBHDtnGwAP2sEfT/r1iyNmUhHk0rkWEw3VKvnuK5l/yBvLKxsuCwvHHKUcoMzBEGb2l8gX+xy9RG81ZV111P+XmxjWsShw0PRYqhjZcYew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When reclaim fails, should_reclaim_retry() looks only at free and
reclaimable pages.  It can hand the allocation to the OOM killer while
enough memory is about to come back from the pages that wait for a
grace period.

Before should_reclaim_retry() gives up, free the waiting pages if they
would bring an eligible zone above its min watermark, and retry.  That
costs an expedited grace period, which is cheap next to the OOM killer.
The retries are bounded per no-progress streak, so a drain that does not
help still ends in an OOM kill.

pgfree_rcu_drain in /proc/vmstat counts the drains that freed something.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/vm_event_item.h |  2 +-
 mm/page_alloc.c               | 88 +++++++++++++++++++++++++++++++++--
 mm/vmstat.c                   |  1 +
 3 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 45527fa7d0c1..7626a3e3a07a 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -36,7 +36,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		FOR_ALL_ZONES(ALLOCSTALL)
 		FOR_ALL_ZONES(PGSCAN_SKIP)
 		PGFREE, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE,
-		PGFREE_RCU, PGFREE_RCU_EXPEDITE,
+		PGFREE_RCU, PGFREE_RCU_EXPEDITE, PGFREE_RCU_DRAIN,
 		PGFAULT, PGMAJFAULT,
 		PGLAZYFREED,
 		PGREUSE,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a9058d414f92..bec9128d80db 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1445,6 +1445,29 @@ static void rcu_free_defer(struct folio *folio)
 		queue_work(rcu_free_wq, &r->expedite);
 }
 
+/*
+ * Free what every CPU's lists hold.  A concurrent drain holds the lock
+ * until it has freed what it took.
+ */
+static void rcu_free_drain(void)
+{
+	static DEFINE_MUTEX(lock);
+	LIST_HEAD(list);
+	int cpu;
+
+	mutex_lock(&lock);
+	for_each_possible_cpu(cpu) {
+		struct rcu_free_pcpu *r = per_cpu_ptr(&rcu_free_pcpu, cpu);
+
+		spin_lock_irq(&r->lock);
+		rcu_free_take(r, &list);
+		spin_unlock_irq(&r->lock);
+	}
+	if (rcu_free_flush(&list))
+		count_vm_event(PGFREE_RCU_DRAIN);
+	mutex_unlock(&lock);
+}
+
 static void __init rcu_free_init(void)
 {
 	int cpu;
@@ -4792,6 +4815,52 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
 	return !!__gfp_pfmemalloc_flags(gfp_mask);
 }
 
+/*
+ * Reclaim is about to give up: if the pages waiting for a grace period
+ * would bring an eligible zone above its min watermark, free them and
+ * retry.  Not for a dying task, which frees memory by exiting.
+ */
+static bool rcu_free_wait(gfp_t gfp_mask, unsigned int order,
+			  struct alloc_context *ac, int alloc_flags,
+			  int *rcu_free_waits)
+{
+	struct zone *zone;
+	struct zoneref *z;
+
+	if (!IS_ENABLED(CONFIG_PAGE_RCU_FREE))
+		return false;
+	if (tsk_is_oom_victim(current) || fatal_signal_pending(current))
+		return false;
+	if (*rcu_free_waits >= MAX_RECLAIM_RETRIES ||
+	    order > PAGE_ALLOC_COSTLY_ORDER)
+		return false;
+
+	for_each_zone_zonelist_nodemask(zone, z, ac->zonelist,
+				ac->highest_zoneidx, ac->nodemask) {
+		unsigned long waiting, available;
+
+		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		    !__cpuset_zone_allowed(zone, gfp_mask))
+			continue;
+
+		waiting = zone_page_state_snapshot(zone, NR_FREE_RCU_PAGES);
+		if (!waiting)
+			continue;
+
+		available = waiting +
+			    zone_page_state_snapshot(zone, NR_FREE_PAGES);
+		if (__zone_watermark_ok(zone, order, min_wmark_pages(zone),
+					ac->highest_zoneidx, alloc_flags,
+					available)) {
+			(*rcu_free_waits)++;
+			rcu_free_drain();
+			return true;
+		}
+	}
+
+	return false;
+}
+
 /*
  * Checks whether it makes sense to retry the reclaim to make a forward progress
  * for the given allocation request.
@@ -4805,7 +4874,8 @@ bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
 static inline bool
 should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		     struct alloc_context *ac, int alloc_flags,
-		     bool did_some_progress, int *no_progress_loops)
+		     bool did_some_progress, int *no_progress_loops,
+		     int *rcu_free_waits)
 {
 	struct zone *zone;
 	struct zoneref *z;
@@ -4816,10 +4886,12 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 	 * their order will become available due to high fragmentation so
 	 * always increment the no progress counter for them
 	 */
-	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER)
+	if (did_some_progress && order <= PAGE_ALLOC_COSTLY_ORDER) {
 		*no_progress_loops = 0;
-	else
+		*rcu_free_waits = 0;
+	} else {
 		(*no_progress_loops)++;
+	}
 
 	if (*no_progress_loops > MAX_RECLAIM_RETRIES)
 		goto out;
@@ -4872,6 +4944,10 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 	else
 		cond_resched();
 out:
+	if (!ret && rcu_free_wait(gfp_mask, order, ac, alloc_flags,
+				  rcu_free_waits))
+		return true;
+
 	/* Before OOM, exhaust highatomic_reserve */
 	if (!ret)
 		return unreserve_highatomic_pageblock(ac, true);
@@ -4961,6 +5037,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	enum compact_result compact_result;
 	int compaction_retries;
 	int no_progress_loops;
+	int rcu_free_waits;
 	unsigned int cpuset_mems_cookie;
 	unsigned int zonelist_iter_cookie;
 	int reserve_flags;
@@ -4985,6 +5062,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 restart:
 	compaction_retries = 0;
 	no_progress_loops = 0;
+	rcu_free_waits = 0;
 	compact_result = COMPACT_SKIPPED;
 	compact_priority = DEF_COMPACT_PRIORITY;
 	cpuset_mems_cookie = read_mems_allowed_begin();
@@ -5163,7 +5241,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 		goto restart;
 
 	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
-				 did_some_progress > 0, &no_progress_loops))
+				 did_some_progress > 0, &no_progress_loops,
+				 &rcu_free_waits))
 		goto retry;
 
 	/*
@@ -5206,6 +5285,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	/* Retry as long as the OOM killer is making progress */
 	if (did_some_progress) {
 		no_progress_loops = 0;
+		rcu_free_waits = 0;
 		goto retry;
 	}
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index aa7280b5e69c..d994de1fd739 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1346,6 +1346,7 @@ const char * const vmstat_text[] = {
 	[I(PGLAZYFREE)]				= "pglazyfree",
 	[I(PGFREE_RCU)]				= "pgfree_rcu",
 	[I(PGFREE_RCU_EXPEDITE)]		= "pgfree_rcu_expedite",
+	[I(PGFREE_RCU_DRAIN)]			= "pgfree_rcu_drain",
 
 	[I(PGFAULT)]				= "pgfault",
 	[I(PGMAJFAULT)]				= "pgmajfault",
-- 
2.54.0


