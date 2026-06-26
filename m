Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C4F7CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ED646B00BD; Fri, 26 Jun 2026 06:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C6466B010E; Fri, 26 Jun 2026 06:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1E686B010F; Fri, 26 Jun 2026 06:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C667D6B00BD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:30:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5750D1A03E7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:30:53 +0000 (UTC)
X-FDA: 84921695586.04.5CEC1F3
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf30.hostedemail.com (Postfix) with ESMTP id 723A78000A
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:30:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782469851;
	b=08pfjhtUbgq+up/Yk9DTnmZ1tMEfFk9lJCVHD8pQA8tOMhMvKmxNEcsJUvKk0ex1BoAVxn
	kBcz2tjNcXydZl0bppVwiTNM+pIQO3q7QMkH5hfNuyRIbKjg4mAlZmMsVpK5Y+mp6XCpCB
	QyPvA+Y5W/DUO863N3QzyP2XJkPb5fg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782469851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GDvNy9Rw3qN3FuZdikYtyjJSYtRWRerc8oyRUMDRdZE=;
	b=Vz3zZRRXyB+TIMNVZH7uP6kqwAwEpZUzglKMsCJ9MW5pa6Gl1h5pWYRFH5wiuKil+eYNXN
	6vRlhBLLuwyBIFyGjbvvWQbWpxa4SgvFtqy9cvTxcS3n9xQHZqU1Rd03rlR5X2dfiPxF4M
	MoUFmY1tWOmui4nIs14Hemr+L1HKGmc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 758A83E96E;
	Fri, 26 Jun 2026 10:30:45 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 6/9] mm: percpu: per-node kmem accounting
Date: Fri, 26 Jun 2026 12:20:55 +0200
Message-ID: <20260626102358.1603618-7-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTGnYIDq9A11TftEatbke2wSLsM4U/RRnbCHpAUAIQBwHbVmowa+ke86M8Z6PPn5o7UKBvUMbr2gZWgcRiFc7ixLzqgLUvmoF1f6yq0GAxvM7ym0xa3n5f10aBqF/6aF0YuddnSkH5x50aCnRuJBlmRRybtyRnTHEtDjNABLsbF8/J37ko6Bm3zG+eW4NfAtWrkoIM0OVuVjH1i1R2t7kHuPQJtjQvB5ayDwVI8gcfE8wIDI8ctauyWpfQVDC9X4EX6LKQuBwn+BvrBeBO0dxg0WQvW3qtFakFlV8vs7Ehg02InoNEqwXY73y16xKIg4BKzVJqVRXZF2evXpKGHtjYSRf1v/B7FVN3Z06tc7fxHWyCdWXvP2ULvCvevW9v0kxmFCJc3JUq1DDIDKRH+N3FvV2TqE1J4StGRAKPYFn1SmtED7pB6BwHmaqSvT1k/e3ptJrDcVsEWtbAjA0Kqr33CAOC+uYXb3tedJNpHQVLKSvLhvJZqF4zl6LmuUZrA2gpOXOkLnaG+KI8yBIKBjqAKFkn3XZ16MtHL90kSeY7rrQTLYbL1gwjmUAeQm93S2gYjbe1yWuiAjhJKDILiSwUdAmSmzAyzcg/rFCFeLJOuMZaf2YTNUa8wD1BdF1UySRvalZ9/cYtYmGCdy/rGxzX6X3eXCWy0Kus+XmBXJQVrz5g
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 723A78000A
X-Stat-Signature: gtfocjr6xug73toxj9qrpwwbcnyqh67m
X-HE-Tag: 1782469851-641832
X-HE-Meta: U2FsdGVkX1+fxZxGZo0LtsIjzHS4CCMuKUfDLKYqduA8vFPRCYTuckFp7j105DjVRNcWwnqzdaK+9bEqGb/XnbEJ/mR/Vdm+h3k4bMbtjNdFTGIv/dpmxdwQ+1tswVooQjX5zAGfOFpA3IiUBnpFY7BdO3uAaFXrey5EaNoPTWk/Qvbo9163ZkakZogd7PMQtVdjAAXeeKLwRjRo1L7RC5q4xFe91qblZEYSbOxImovOklDKlGrcZVhl7qVNZVk8v25lslQOXXKMuJ9HOhcvg3OdU908eLM9K76Ku+4JBHeAWgoo9LxmBRpssjMVQucllTi5M2uUIRzWU/Hf75TLj7ym64CaSWczCyNhou3fs6ltWKKL+wWk4b2IjxPvVV6zvN4CeV/pmtZu75iopq5x/aYxVXe77VYMnavnUbNW9zyLhX0eRTU6J/JHxdAbW/W0sb61c06tSzeKj3NN02okPjeJrOMNFPjsg8iO/Sf856AacQqPnCekRoY44U+clh2a/ZOZ/Aq4kCwOJGIUa4B5qnALRx1LELUBr5mrcamelQgl8Q0/T0GTf4gZ1vAcDBKHRFpFwV1PZqPOocO8EOiQBP0rWh+hw0vbmW+iSzn6cY0WC21a4/M7HTB3VEqWklBMN60tTghQWBdIdPrSQY/hCnKdgPeVIydbMLXxvospEbDeAxCdghwoZFK7QJOKwTjajbXThSnDji+0DnySvO1/J5i6xECJvhi1fuUjIaSoQ+eXEnsQDTQ6kJmWpGeSi9SKDCb6VOl2v30c0Kk28RT4/Ab5Z/MM4gIK9bt5zaoJiu6y2/bmoMrah2xojIbDfcrtxh69VRMVKM4OKjwt41/g3Y45lJc/UhebfC4n3YCuu7dH8xgRC+MEXH/aJeUgb/qlcVpgvu91LDGbGUFpfgerPGctgnG6LrS9TX+VIZj/9+dvOoKfWjr1XJBFcIdsowxLpH6H8/rMBQatlYUfcsZ
 yQVNS0li
 ic5cN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that the memcg charging is decoupled from the kmem accounting, the
post-alloc hook knows the actual node each backing page landed on and can
account it per node. The backing pages of a percpu allocation are only
best-effort placed on cpu_to_node() by pcpu_alloc_pages(), so some may
have fallen back to other nodes; the hook therefore reads each page's real
node via page_to_nid() and accumulates the bytes per node.

The accounting cannot go through the obj_stock: a concurrent stock drain
could take the pages the post-alloc hook relies on, and the hook cannot
afford a failing re-charge. Instead, accumulate the per-node bytes first,
then for each touched node issue a single obj_cgroup_account_kmem() of
ceil(bytes_on_node / PAGE_SIZE) pages and hand the sub-page remainder back
to the stock. The free hook mirrors this with one uncharge of the exact
bytes per node. Batching per node (instead of per page) keeps the memcg
work proportional to the number of nodes rather than num_possible_cpus().

We have to precharge enough pages to account for the worst case scenario
where the allocation is spread on all nodes. Since in
pcpu_memcg_post_alloc_hook(), we charge PAGE_ALIGN(size_on_node_X), that
means we round up by strictly less than one page for each node. So for N
nodes, we waste strictly less than N pages: so we have to precharge at
least PAGE_ALIGN(total size) + num_possible_nodes().

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/percpu.c | 88 +++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 76 insertions(+), 12 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 01c87e39d366..e9d2d3716b99 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1613,6 +1613,22 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 }
 
 #ifdef CONFIG_MEMCG
+static unsigned int pcpu_memcg_nr_precharge_pages(size_t size)
+{
+	size_t total = pcpu_obj_full_size(size);
+	unsigned int ceil = PAGE_ALIGN(total) >> PAGE_SHIFT;
+
+	/*
+	 * pcpu_memcg_post_alloc_hook() charges ceil(bytes_on_node / PAGE_SIZE)
+	 * pages per node. Summed over the K <= num_possible_nodes() nodes the
+	 * allocation touches that is at most ceil + (K - 1): each node rounds
+	 * its share up by strictly less than a page. Precharge
+	 * ceil + num_possible_nodes(), which covers that worst case with a
+	 * page of headroom, so the per-node credit never runs short.
+	 */
+	return ceil + num_possible_nodes();
+}
+
 static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 				      struct obj_cgroup **objcgp)
 {
@@ -1625,14 +1641,37 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
-	if (obj_cgroup_precharge(objcg, gfp,
-				 PAGE_ALIGN(pcpu_obj_full_size(size)) >> PAGE_SHIFT))
+	if (obj_cgroup_precharge(objcg, gfp, pcpu_memcg_nr_precharge_pages(size)))
 		return false;
 
 	*objcgp = objcg;
 	return true;
 }
 
+/*
+ * Accumulate the per-cpu payload bytes of this allocation onto the node that
+ * actually backs each page. pcpu_alloc_pages() only places a CPU's backing
+ * page on cpu_to_node() as a best effort, so the page may have fallen back to
+ * another node; use the page's real node. node_bytes[nid] accumulates the
+ * bytes seen on each node, to be charged in one batch per node by the caller.
+ */
+static void pcpu_memcg_accumulate_pages(struct pcpu_chunk *chunk, int off,
+				   size_t size, unsigned int *node_bytes)
+{
+	unsigned int nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+	unsigned int cpu, i;
+
+	for_each_possible_cpu(cpu) {
+		for (i = 0; i < nr_pages; i++) {
+			void *addr = (void *)pcpu_chunk_addr(chunk, cpu, PFN_DOWN(off) + i);
+			size_t page_sz = i < nr_pages - 1 ?
+				PAGE_SIZE : size - (nr_pages - 1) * PAGE_SIZE;
+
+			node_bytes[page_to_nid(pcpu_addr_to_page(addr))] += page_sz;
+		}
+	}
+}
+
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
 				       size_t size)
@@ -1641,29 +1680,47 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 		return;
 
 	if (likely(chunk && chunk->obj_exts)) {
-		size_t total = pcpu_obj_full_size(size);
-		size_t remainder = PAGE_ALIGN(total) - total;
+		unsigned int precharge_pages = pcpu_memcg_nr_precharge_pages(size);
+		unsigned int node_bytes[MAX_NUMNODES] = { 0 };
+		unsigned int pages_used = 0;
+		int nid;
 
 		obj_cgroup_get(objcg);
 		chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = objcg;
 
+		pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
+
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				total);
-		rcu_read_unlock();
+				pcpu_obj_full_size(size));
+
+		for_each_online_node(nid) {
+			unsigned int pages;
 
-		obj_cgroup_account_kmem(objcg, PAGE_ALIGN(total) >> PAGE_SHIFT);
-		if (remainder)
-			obj_cgroup_uncharge(objcg, remainder);
+			if (!node_bytes[nid])
+				continue;
+			pages = DIV_ROUND_UP(node_bytes[nid], PAGE_SIZE);
+			obj_cgroup_account_kmem(obj_cgroup_nid(objcg, nid), pages);
+			pages_used += pages;
+			if (pages * PAGE_SIZE > node_bytes[nid])
+				obj_cgroup_uncharge(obj_cgroup_nid(objcg, nid),
+						    pages * PAGE_SIZE - node_bytes[nid]);
+		}
+
+		/* Return the precharged pages we did not use. */
+		if (pages_used < precharge_pages)
+			obj_cgroup_unprecharge(objcg, precharge_pages - pages_used);
+		rcu_read_unlock();
 	} else {
-		obj_cgroup_unprecharge(objcg,
-				       PAGE_ALIGN(pcpu_obj_full_size(size)) >> PAGE_SHIFT);
+		obj_cgroup_unprecharge(objcg, pcpu_memcg_nr_precharge_pages(size));
 	}
 }
 
 static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 {
+	unsigned int node_bytes[MAX_NUMNODES] = { 0 };
 	struct obj_cgroup *objcg;
+	int nid;
 
 	if (unlikely(!chunk->obj_exts))
 		return;
@@ -1673,11 +1730,18 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 		return;
 	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
-	obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+	pcpu_memcg_accumulate_pages(chunk, off, size, node_bytes);
 
 	rcu_read_lock();
 	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
 			-pcpu_obj_full_size(size));
+
+	/* Uncharge each node the exact bytes it was charged at alloc. */
+	for_each_online_node(nid) {
+		if (node_bytes[nid])
+			obj_cgroup_uncharge(obj_cgroup_nid(objcg, nid),
+					    node_bytes[nid]);
+	}
 	rcu_read_unlock();
 
 	obj_cgroup_put(objcg);
-- 
2.54.0


