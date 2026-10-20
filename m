Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1131C606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 20:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ZbciRnNe
Received: by kanga.kvack.org (Postfix)
	id 25BDC6B0552; Tue, 20 Oct 2026 16:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C2A6B0554; Tue, 20 Oct 2026 16:07:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FC766B0555; Tue, 20 Oct 2026 16:07:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA82F6B0552
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:07:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56126C03B7
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:07:46 +0000 (UTC)
X-FDA: 85344090132.03.55429BE
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92344C0003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:07:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZbciRnNe;
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792526864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QqajU5KZ2n/0LEgBFjxAuZSd6t0rfl3ggGAXjMiRHVc=;
	b=0dM1w/3TmaLSuToELmlj2s3aOg2+50nWITRXRTOLwc/1Km0KvSezqoCZiv4J6VaTXDuYdg
	HEaWniB1Ae6U4IrytBVh7/tjyk76WKOYUS+PjQDjQyWx9losxWzPRnEpawlWm0aZ65he5X
	yw1P3DcJP4z0lpC2Zp1E1B7gjTkbogk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZbciRnNe;
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792526864;
	b=C0H8wAjeHLbZ6AZuXBQeL1kGik2/VicDOVWRZTF4NSF3RqG84r507m8VMYiBR7vqIy3BU4
	JYGqpov7uGRNjpTIW09L1+tUgZ78vY/lnqT92xp1IY8p61TMqtK0QvgSKywUohe/Fbm7X5
	rK0lPrCrUydDk2Vhu2V3nMl3NEKK81A=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-533861a59b8so778521cf.1
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792526864; x=1793131664; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QqajU5KZ2n/0LEgBFjxAuZSd6t0rfl3ggGAXjMiRHVc=;
        b=ZbciRnNeQ4yRS55zcANrYl6yvyRJt+VimMuUUO+/4/vWcrzqR+dMMv3w+cNb+QTw3N
         Gf9v932nQNGEH/wik2g4rAvQvmAOgfmdpo0BHq/uZH/k/oaPHNGUDyCD7+G3OwziVpw4
         fFiZaLr5UYQZv/Mt0dlCxlEWzfQtvc6bPtqPEprw3FWQqmbWKqVW5S+ukocUNF9fnZyE
         tIcuwlrLL7S76h2zvvxcdg4AnaKdiXziDMHY2MnaT0c2rNC1KR0JQGD2AMxRRuxuo7WM
         N5GuuUtg8z2XDf3yG1aW8bKr9WY32ofXrPbLMrJn3QuU+AE9FgpBOWl+LxEKCywju+mV
         +8wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792526864; x=1793131664;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QqajU5KZ2n/0LEgBFjxAuZSd6t0rfl3ggGAXjMiRHVc=;
        b=ylUY42ww+JJgnqgj9yABTx7PH5CjDbx8wWMsXV4jVmKVPs2hFMvOcVoB/6+e3N7L6E
         kfv7RCyHwRLzu+nvI9doUp0b1eVsxqo8OOjJX+Nn9PDKzvBzuZMRDicUwuZbZUQ2+b8H
         0KQB8dwmrAXCDLJdQbSFMs4JkklOiBpuuVUKDJIxb0eL/OFZWSBVmwdwlMYlxo4RhZWo
         D6rCU86f9GgYjmzbT5PXisGl0NVH98Fk+4bB8fFeB5XPK9UQyyjWipUCtsmHeR65KmOJ
         yWPTK5OCo23XoFIf1rM1Fwd/k928UfiB/Nh0S9DqZs61+DXg+abvGcQl1Bm0hDAAc+jk
         rPmQ==
X-Forwarded-Encrypted: i=1; AKwUvBwl04Pntkv/UEZspRRERvWy43OwHqMcOnOr5kKRix47GX0vV4NQxiAH3WxI1aE6O49m5hu2iY7log==@kvack.org
X-Gm-Message-State: AFq9FYJbikvqZQJ/u2ZnBw+j7DrTlKH2afckzAqCzRT8Rvum5KF5BD1U
	Jy+pdwoOHgC4FBbMN6kTQZ0JtAu4FNVCswzriENQkqS/5Bop6H/Y637q
X-Gm-Gg: AYBFou3/crTpnJaHYSwaFyiw4KzmgS79uu69Lgxnz0g1GCDG7OtqiwGGoRzAMF9WBcc
	rfuRZv3frkQEDQA3BDfaqd2l4qL76fnPDIVauYzXtcIKaAdCqw1RIfQDznHs59kaCOpq+5EoxXc
	ta+QDo7E9G0q/NbTUS9wI/ZX4Z3OpeJNqJrVeMx+ZMtUlkwsq1bAAv7TyNIa175gxILwG9AMNzW
	W6R4NmYJVbuYnqr032EOoXsIUzEQGOUU4MlUEQHnKCr419kW0WAe5A+Y54AuhBNCh9qiWlLU197
	2z2+W4Igs89NowIba/K0GmfrzlOUgW5l9u17dc1AeYfBmkt0rBrbl1cOT4rCvqWh9GlMHwgemOg
	mJfMsI5zNRXLmvQQF9u8rohEDmzWejDnUljz0KA5DxUYnOwYOswKmXaH5NMBcya3bzpMxiIpoBs
	o1dbu/LpyGeoCirpM/r5r0wIAt1c/92gSFv/ROmLFnFeTSxZTzGTYlhpucxJn/QS42QLt2/nJaA
	Ru3cRLQrXAnLLd7PhGA2x7ewhjxXsHhQw5O1Y02i6jglOdxgNyQ1fcT1z0TdA==
X-Received: by 2002:a05:622a:4c89:b0:536:66d7:8ccb with SMTP id d75a77b69052e-53666d79274mr119565871cf.51.1792526863594;
        Tue, 20 Oct 2026 13:07:43 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10c27135sm6510396d6.34.2026.10.20.13.07.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 13:07:43 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1] memcg: fix cacheline contention between lruvec stat updates and LRU lists
Date: Tue, 20 Oct 2026 13:07:30 -0700
Message-ID: <20261020200730.250189-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92344C0003
X-Stat-Signature: 5furpsrdkopa9iiud9ew4phqhoyi5ys1
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792526864-679201
X-HE-Meta: U2FsdGVkX18VC1cUgxRX+vrefCp2TdKZcoe+Rcx5xlfWiRwRVaiardBB49/8tVe8B6NcaM9vwFzzDLQmvzjHkqX2n5XRIn6u+xM8WdUQz/UqGm0ETAcPNFAc3VXeTyXe5BM/MWucWS5tug7PuVLjxBJSHIgIDvmtBJTVU0CojLRs6akkmUk/wv7j/ljNqeMN5e9vb0kuGeJuzH/HUdDhSCFuOM70qiQAiaH/6xzClzRWKOSpJRW59iP4oX4HkTWPibpgw5GEaJKXkjftRz/hK1LuyrI3unTr8B4b4KpwNVlGHjJF0ul5k728BR8qWPxsHaF7gakkC5LJY4tQWrXZCXSnMf3zD9A/sei0Lmi9VN2A1sCLyuaLWDI3gpgXKVoAbL9QP9nv4VsMCzRYmgLhzuzusznE0iTx+3HrSRKYDELi4DXlqrCmfRcEdf0qau4di0C6fBmPKfuoFYV/5n7BVjmX3dGNQhGGoj+VLkDSTstbe9dCrIcX/3xDPjzbaBWP1C/SH8SjJf70dFkGIb0GENKfuYJOgG06SNIGX7ZRgVmGTsRM5wpbBmAgALWYXloQ39grtrDCdToSF924p60jBMgtAuzHMtdcx4gidxWKQCw3Afdonj5N9x7XVJBRBgE/atNxl1oMhYR8vll7DP6h7AlloLDvvswJpHuY25K0Ysh4Bl0/JsEnbj1Y8Q1puaBA60JkTPT0tKiJfMLcRWe86Fcz+CE2aPmyb7cnIRHlXxUOy7A/2Bm3KqJneSFO20tN9TPP1MBGC3likbLWJj+E4Q/JalMpdV0qCMIMS25vTq5E8+hRr0Y2ernnjuRgvKhDfiIMBaSr6W/OEAz2Jzgict5V4xoGByvwwOvrAsYkKoCwO4Cgcsj6G9kAPzV3PL2m0VzZ3VD5cAQu+2s97kjQMqw9l9ngg5KW8EVrLUrufSqlfKpSooOLyCqYwun8DzZKiUoU3te9GG/lyI3pnEJ
 Mm8ljjME
 Bd1u7yUaP+RJoCmzVtiWiVL6u90I8bdKy6/+fV1DnLw935J1eM9lhNldUQiyn5iNmKLJ9s36YoDQK6v+dAGYkSK3MnJAXnZsALjHpM7SxZu/a6BCSB0o6peWirqaHtW6N0ZGw9QyKBkci3ukRXpMnzfqbXth5Fo7h24o3LjADcBZFgKH9aUFgtrv2MJlqXDASOAv8V4i8NM6lLi+ma5ePTP1ZAIzbx+EXZGTmEGOi+1HkDw7iaZytBe31RVkufluddEMMD0hLFt8YWkvTIO/0SVT4q3hyRqQPaiCXXTY7yjGXVV5lcOQbKKnKOks5A+QYuHgaSExrUKKcdJ7qbED1aRJw9AGxt/p8bTVXkcY8sAumWEirlBR0c0vH6ZKMFs3P9BNHjmPk+CizWPBkVQQkzNTqdtw29NjRH3nUd5wAfmcsrDSoIQ5BcMlARbiLA4PigvuGsE3Yfre+S1VGNintjg1z4P03+Pb1+vR7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every memcg lruvec (per-node) stat update reads the memcg and
lruvec_stats_percpu pointers in the first 64 bytes of struct
mem_cgroup_per_node, and the ones that go through mod_lruvec_state()
(such as lruvec_stat_mod_folio()) also read lruvec->pgdat. These updates
are extremely frequent (eg these updates happen several times for every
page that's faulted in, freed, dirtied, or written back).

The memcg_pn_read_mostly cacheline group keeps those read-mostly fields
on a different cacheline from the lruvec, but on CPUs that do spatial
prefetching [1] (which is most Intel CPUs / modern CPUs), cachelines are
fetched in 128-byte aligned pairs. Depending on where struct
mem_cgroup_per_node lands in its slab, that cacheline can be paired with
the cacheline holding the LRU list heads, and the lruvec->pgdat
cacheline with the one holding lru_lock.

When this happens, every stat update also pulls in a copy of the LRU
list heads and lru_lock cachelines, which are written to constantly by
other CPUs under the lru_lock. The stat update has to fetch them from
another CPU, which is unnecessary overhead since the stat update doesn't
use the LRU list heads or lru_lock at all. But even worse, the lru_lock
holder then has to invalidate those copies and wait for the
acknowledgements to come back before it can do its next write, which
makes the lru_lock critical section longer for everyone waiting on the
lock.

This was found when analyzing the output of perf c2c for a benchmark
where many threads fault in pages in one memcg. It showed the first 64
bytes of mem_cgroup_per_node as the most contended cacheline (over a
third of all HITMs and 5x more than the lru_lock cacheline) even though
there are no writes to it. A quick experiment adding extra padding so
that the cacheline no longer shared a pairing with the LRU list heads
showed that this removed most of the contention, which confirmed the
cause.

Fix this by not touching struct mem_cgroup_per_node on the main stat
update paths and instead going through the memcg. The memcg keeps an
array of pointers to the per-cpu lruvec stats of each node, pointed to
from the same cacheline as vmstats_percpu, which the update path already
reads. lruvec_stat_mod_folio() and mod_lruvec_kmem_state() pass the
memcg and node they already know instead of going through the lruvec and
fetching mem_cgroup_per_node->memcg and lruvec->pgdat. Both the memcg and
lruvec_stats_percpu reads need to go, since either one alone still pulls
in the cacheline.

Results from a multi-threaded fault/free benchmark in a single memcg,
run on an Intel Skylake machine (80 threads, 2 NUMA nodes) with threads
pinned to CPUs showed average pages faulted in (and freed) per second
across all threads, over 7 freshly created memcgs per run:

                     before    after
  shmem, 20 threads  4.74M     5.68M   (+20%)
  shmem, 80 threads  7.94M     8.81M   (+11%)
  anon,  20 threads  3.04M     3.13M   (+3%)
  anon,  80 threads  3.23M     3.30M   (+2%)

perf c2c showed HITMs on the read-mostly line from the stat update paths
dropped from ~2350 to ~10.

[1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-optimization-manual.pdf
(bottom of page 62/800)

Link: https://lore.kernel.org/linux-fsdevel/CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com/
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
An alternative would be to turn memcg->nodeinfo[] into an array of
{mem_cgroup_per_node, stats} pointer pairs, which saves one load, but
this would require quite a bit of churn (would need to modify every
nodeinfo call site). Happy to switch to this for v2 if this is
preferred.

 include/linux/memcontrol.h |  8 +++-
 mm/memcontrol.c            | 88 +++++++++++++++++---------------------
 2 files changed, 47 insertions(+), 49 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 74110a324f9e..dd054c9076d7 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -88,7 +88,6 @@ struct mem_cgroup_per_node {
 	struct mem_cgroup	*memcg;		/* Back pointer, we cannot */
 						/* use container_of	   */
 
-	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
 	struct lruvec_stats			*lruvec_stats;
 	struct shrinker_info __rcu	*shrinker_info;
 	struct obj_cgroup __rcu		*objcg;
@@ -314,6 +313,13 @@ struct mem_cgroup {
 	__cacheline_group_begin_aligned(memcg_read_mostly);
 	/* Read on every stat update */
 	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
+	/*
+	 * Per-CPU lruvec stats of each node, indexed by node id. Points to an
+	 * array after nodeinfo[] in the same allocation. Kept here instead of
+	 * in mem_cgroup_per_node, to avoid sharing a cacheline pair with the
+	 * very frequently written LRU lists.
+	 */
+	struct lruvec_stats_percpu __percpu **lruvec_stats_percpu;
 
 	/* memory.stat */
 	struct memcg_vmstats	*vmstats;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aad0498a7bd6..203cae528e08 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -587,7 +587,7 @@ unsigned long lruvec_page_state_local(const struct lruvec *lruvec,
 	return x;
 }
 
-static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val);
 
 void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
@@ -596,16 +596,11 @@ void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
 	int nid;
 
 	for_each_node(nid) {
-		struct lruvec *child_lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
-		struct lruvec *parent_lruvec = mem_cgroup_lruvec(parent, NODE_DATA(nid));
-		unsigned long value = lruvec_page_state_local(child_lruvec, idx);
-		struct mem_cgroup_per_node *child_pn, *parent_pn;
+		struct lruvec *lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
+		unsigned long value = lruvec_page_state_local(lruvec, idx);
 
-		child_pn = container_of(child_lruvec, struct mem_cgroup_per_node, lruvec);
-		parent_pn = container_of(parent_lruvec, struct mem_cgroup_per_node, lruvec);
-
-		__mod_memcg_lruvec_state(child_pn, idx, -value);
-		__mod_memcg_lruvec_state(parent_pn, idx, value);
+		__mod_memcg_lruvec_state(memcg, nid, idx, -value);
+		__mod_memcg_lruvec_state(parent, nid, idx, value);
 	}
 }
 
@@ -990,10 +985,9 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
 }
 #endif
 
-static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
+static void __mod_memcg_lruvec_state(struct mem_cgroup *memcg, int nid,
 				     enum node_stat_item idx, long val)
 {
-	struct mem_cgroup *memcg = pn->memcg;
 	int i = memcg_stats_index(idx);
 	int cpu;
 
@@ -1006,7 +1000,7 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	this_cpu_add(memcg->vmstats_percpu->state[i], val);
 
 	/* Update lruvec */
-	this_cpu_add(pn->lruvec_stats_percpu->state[i], val);
+	this_cpu_add(memcg->lruvec_stats_percpu[nid]->state[i], val);
 
 	val = memcg_state_val_in_pages(idx, val);
 	memcg_rstat_updated(memcg, val, cpu);
@@ -1015,21 +1009,23 @@ static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
 	put_cpu();
 }
 
+static void mod_memcg_node_state(struct mem_cgroup *memcg, int nid,
+				 enum node_stat_item idx, int val)
+{
+	bool rcu_locked = false;
+
+	memcg = get_non_dying_memcg_start(memcg, &rcu_locked);
+	__mod_memcg_lruvec_state(memcg, nid, idx, val);
+	get_non_dying_memcg_end(rcu_locked);
+}
+
 void mod_memcg_lruvec_state(struct lruvec *lruvec,
 			    enum node_stat_item idx, int val)
 {
-	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	struct mem_cgroup_per_node *pn;
-	struct mem_cgroup *memcg;
-	bool rcu_locked = false;
 
 	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = get_non_dying_memcg_start(pn->memcg, &rcu_locked);
-	pn = memcg->nodeinfo[pgdat->node_id];
-
-	__mod_memcg_lruvec_state(pn, idx, val);
-
-	get_non_dying_memcg_end(rcu_locked);
+	mod_memcg_node_state(pn->memcg, lruvec_pgdat(lruvec)->node_id, idx, val);
 }
 
 /**
@@ -1058,19 +1054,14 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 {
 	struct mem_cgroup *memcg;
 	pg_data_t *pgdat = folio_pgdat(folio);
-	struct lruvec *lruvec;
+
+	mod_node_page_state(pgdat, idx, val);
 
 	rcu_read_lock();
 	memcg = folio_memcg(folio);
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg) {
-		rcu_read_unlock();
-		mod_node_page_state(pgdat, idx, val);
-		return;
-	}
 
-	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_lruvec_state(lruvec, idx, val);
+	if (memcg)
+		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(lruvec_stat_mod_folio);
@@ -1079,23 +1070,19 @@ void mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 {
 	pg_data_t *pgdat = page_pgdat(virt_to_page(p));
 	struct mem_cgroup *memcg;
-	struct lruvec *lruvec;
+
+	mod_node_page_state(pgdat, idx, val);
 
 	rcu_read_lock();
 	memcg = mem_cgroup_from_virt(p);
 
 	/*
-	 * Untracked pages have no memcg, no lruvec. Update only the
-	 * node. If we reparent the slab objects to the root memcg,
+	 * If we reparent the slab objects to the root memcg,
 	 * when we free the slab object, we need to update the per-memcg
 	 * vmstats to keep it correct for the root memcg.
 	 */
-	if (!memcg) {
-		mod_node_page_state(pgdat, idx, val);
-	} else {
-		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-		mod_lruvec_state(lruvec, idx, val);
-	}
+	if (memcg)
+		mod_memcg_node_state(memcg, pgdat->node_id, idx, val);
 	rcu_read_unlock();
 }
 
@@ -4192,7 +4179,6 @@ static void free_mem_cgroup_per_node_info(struct mem_cgroup_per_node *pn)
 	if (!pn)
 		return;
 
-	free_percpu(pn->lruvec_stats_percpu);
 	kfree(pn->lruvec_stats);
 	kfree(pn);
 }
@@ -4211,9 +4197,9 @@ static bool alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 	if (!pn->lruvec_stats)
 		goto fail;
 
-	pn->lruvec_stats_percpu = alloc_percpu_gfp(struct lruvec_stats_percpu,
-						   GFP_KERNEL_ACCOUNT);
-	if (!pn->lruvec_stats_percpu)
+	memcg->lruvec_stats_percpu[node] =
+		alloc_percpu_gfp(struct lruvec_stats_percpu, GFP_KERNEL_ACCOUNT);
+	if (!memcg->lruvec_stats_percpu[node])
 		goto fail;
 
 	INIT_LIST_HEAD(&pn->objcg_list);
@@ -4234,6 +4220,8 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 
 	for_each_node(node) {
 		struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
+
+		free_percpu(memcg->lruvec_stats_percpu[node]);
 		if (!pn)
 			continue;
 
@@ -4265,6 +4253,8 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	memcg = kmem_cache_zalloc(memcg_cachep, GFP_KERNEL);
 	if (!memcg)
 		return ERR_PTR(-ENOMEM);
+	/* see mem_cgroup_init() */
+	memcg->lruvec_stats_percpu = (void *)&memcg->nodeinfo[nr_node_ids];
 
 	error = xa_alloc(&mem_cgroup_private_ids, &memcg->private_id, NULL,
 			 XA_LIMIT(1, MEM_CGROUP_ID_MAX), GFP_KERNEL);
@@ -4709,7 +4699,7 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 		if (parent)
 			plstats = parent->nodeinfo[nid]->lruvec_stats;
 
-		lstatc = per_cpu_ptr(pn->lruvec_stats_percpu, cpu);
+		lstatc = per_cpu_ptr(memcg->lruvec_stats_percpu[nid], cpu);
 
 		ac = (struct aggregate_control) {
 			.aggregate = lstats->state,
@@ -5901,6 +5891,8 @@ static void __init memcg_struct_check(void)
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      vmstats_percpu);
+	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
+				      lruvec_stats_percpu);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup, memcg_read_mostly,
 				      vmstats);
 #ifdef CONFIG_ZSWAP
@@ -5920,8 +5912,6 @@ static void __init memcg_struct_check(void)
 
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
 				      memcg_pn_read_mostly, memcg);
-	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
-				      memcg_pn_read_mostly, lruvec_stats_percpu);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
 				      memcg_pn_read_mostly, lruvec_stats);
 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
@@ -5977,7 +5967,9 @@ int __init mem_cgroup_init(void)
 			  drain_local_obj_stock);
 	}
 
-	memcg_size = struct_size_t(struct mem_cgroup, nodeinfo, nr_node_ids);
+	/* nodeinfo[] followed by the array of per-node lruvec_stats_percpu */
+	memcg_size = struct_size_t(struct mem_cgroup, nodeinfo, nr_node_ids) +
+		     nr_node_ids * sizeof(struct lruvec_stats_percpu __percpu *);
 	memcg_cachep = kmem_cache_create("mem_cgroup", memcg_size, 0,
 					 SLAB_PANIC | SLAB_HWCACHE_ALIGN, NULL);
 
-- 
2.52.0


