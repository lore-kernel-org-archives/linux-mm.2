Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E427C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960996B00A2; Fri,  7 Aug 2026 16:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2C76B00A3; Fri,  7 Aug 2026 16:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75F0F6B00A4; Fri,  7 Aug 2026 16:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40BA26B00A2
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C976DA1534
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:22 +0000 (UTC)
X-FDA: 85075593204.27.4C8FD45
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1CA19160004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:20 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CSKkCRYf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/o7PyJxYr/auJmws9zryGpCICrELhYgOPRDbTKuSBc=;
	b=GCyTB6HbkMG1j0grOH/KHz7Oco9QfF17TDG2hsoG22hD9Rphr9bNX1B8Wq9rubSpZff4n1
	5jedZ80WyJCys+keCxjTOpf18cdguzgfJa96iLgDii+n5kKn3S9I6eK9TO1Tc4wGBHKi28
	KFKiP2wo/BpxVMzEg6JUPBuoHZodABU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CSKkCRYf;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134081;
	b=0GAmFlNLQnzyOG2gUZHr22ANdhjtcJMyLBWx/t1J0CZ0jchtATLegAWJIYE1aFxkQ+cZzS
	rDRDm02Ec6dqQ30ipWlRTTyQHVmVtrRhtEewhu2vc6mmQQx5Dmr6zutKhCRT9SRStcLfTB
	pGMA9hCOFpqD3lvzpp4O7yPTBzsqpeI=
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6ae5baaef5dso1914974eaf.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134080; x=1786738880; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7/o7PyJxYr/auJmws9zryGpCICrELhYgOPRDbTKuSBc=;
        b=CSKkCRYfDsaQmOd17i9Bce3NGkbjxNvpc5W7yJInds4/Y+U/JfC9M2wNslDgsB6Ajb
         joRzioNOmgiNswn94+p+j6JzInnEJADf4f1A+SPkRnTStsL04H3FWYpm/4aOXOlsW4Xv
         XUrjmik5XkXf3qG05gP/ON7/eTscoZ4NnyCgBYPur/GIIXRfXbZM2q/+Pmgr5dwv0U7F
         qGUjdjwneXxh7JBdzVJSEv0AV3HnFWzOJft++pUshxlrlL/C0ey9nWLw0rqCknhGMx3+
         KUtOGQhRHASgW/ajyyYSA03mPjTw6Gq9woQBl2nPPuMx2yOyk1qSR7+5NGdxJ6gnWw9h
         IUhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134080; x=1786738880;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7/o7PyJxYr/auJmws9zryGpCICrELhYgOPRDbTKuSBc=;
        b=jBtW3O6396kOF9B0P1+c5cbdkeTs+j8N+8NVpCKEbnpLtgrUv9NkUhMzwecZIb6lL3
         FD2e5Lsy0NcF+NKqvViItUmsC86lfVqr2M92pnhOpPbFUBQ3iOl2pQQFtGpP//hS4oiS
         f8ENrUKlJnbTogAvgzOo/XREHDz23ZbEP8q2Tlc+BLCmTZ7hUUjn+hocSkjk1KrM74AX
         07bcWCv+Q++tBM8zgZ3tScjInnwrQ5sb82j3DqOgEgZJlbsr5ZZpl6wLnPMRe8agErHC
         xFQDv30PyEPk9UZhavM2qVpSDA2tYzD8Yg8GKOI0msGCkDd02sHzIvEYAkKoMzAumDu4
         Ollw==
X-Forwarded-Encrypted: i=1; AHgh+RqOKJrsvJFr3X5GyOP7N+KJ6acI2wp2okXhCyrhZCdav1mfAH36HKUR1TIvRYLkFQJUu2n+6WZC6w==@kvack.org
X-Gm-Message-State: AOJu0YygRf6ZBZzX+3FgCgJC+7Taue/8RNajLCVXlYMsN3/uqAGNPbFf
	OMljp34LfagJ/77Te5UQfqev/nW6cVpLftyn6iHhWwdGfOeG/P3gORV+
X-Gm-Gg: AR+sD10kUmWAwUOAV2+Lx7Xn24V4ZjG3mp0P7MH1QXUls2MYwo9nrD5fJFlPTHoCdDZ
	DW8bpcMlmG5zor1CnKcKV4CiwPmMhjZjQDroTeOJhSmWJxOFbcaw8MHY4Tsq/kN8fKV+D5I5Cjl
	zzQYIR+1bfYg3oY7amejNuy1NMveXTluoVNKlYLgEVdBVPHQxqapmMxyQlGk+HzKsymdjWIeEqh
	GvPX2asAOha52FebSZ/xbMnTHxUHC2+Yu0QpqZgRQbl4JXxqEBCgyhrt8bdhJTSa1yLitve1az5
	mGK0z8rqCQe58hAxmQtAbguzeLAms1x5fg8CjntsnZbFWmW7FlRqhrAcqU2iEc3gM/Fh49q3FTL
	CwCCrYIjG0sJjtgr3Cd0HC3Pd01VDDzYzjZGiCDbQi4eI7g+UW5yydEz9JlR1dee1/AmiRb8ozJ
	fO21TzlEFLyZDZ02IUVxApCkAKl0sDE1MFct24nhrWHeyE0c1sZikXIo5BoLC8tF8HklIUeqtnw
	f6V0ez9Blg906eq+ug=
X-Received: by 2002:a05:6820:8c7:b0:6a3:6f5d:4d6c with SMTP id 006d021491bc7-6b044e7bbdfmr825692eaf.6.1786134080128;
        Fri, 07 Aug 2026 13:21:20 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:12::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1a9d9b9sm2606796fac.7.2026.08.07.13.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:19 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kairui Song <kasong@tencent.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Rakie Kim <rakie.kim@sk.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [RFC PATCH v3 13/14] mm/memcontrol, sched/numa: Gate NUMA promotions into memcg tiers
Date: Fri,  7 Aug 2026 13:20:56 -0700
Message-ID: <20260807202059.2620949-14-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1CA19160004
X-Stat-Signature: q6pc1e4badznghkxb516iyu8xhpyd7h8
X-Rspam-User: 
X-HE-Tag: 1786134080-552861
X-HE-Meta: U2FsdGVkX1/b1rpshpi9cRThvF5jklE3+PhDmDczWcinxPg4CkZGb10u3q5Hv6KZdsaaSJAYkm/kgHcEJ2fC+jxxUnmPgI83wPO4KDk6u6NLs0154wx6pwPKk+L8rVBmXEMOISCsC26yx+ngiimonL8fXtWlWQiYn94u34nsqiIMUKiM3OMGw7Khr+QRalMM3QytkW87Zogb4mgVGZOXs68RYwF03p4eIDKTr4ArV97gT0ZaYSgu/jqt8uMkH9xzuoSaLhT6Ym3nE5AWXLmDOI0/J3ltlkfPTo8wxext6aLCbdCcbvbSDvP1x5MOXV4fJ8NrbwAMXokD0PO9EMGDHuwC03DwP09dziyh82T6eGh6I6zJ5o1/syUsMyxZsCOdzTA+jbPdos5abhM029xyEwA7zaoBjzjecWIfitgEh4+/l8GBK6DlFdQEUoxv11WohfuVdbsTS9/7zWRAOK39AM08XHIF+qupK6rPZzWf5t1yA0w6c/MtlwrwOxkneDcIE45oHN6tg7/qH8JbgWi7xAamVst+Eme+MF7oOxPZpP1fXxHoWOxUhUcBVqZWyVwq3r0jMDFm8wcv4Acpbfm0tvUSQ/lu995G9cZp5NINFvzXRxG4QwraJr6e0CQNjqEWPF4x6HgewsWPutRkBuzC07WXiK1WQPjREgjUJGAab1LCXA8gjXNIlWIPwZUjlEPCa2rJBSeUUzVApAqU+K9PXVS10+Puh+Xa9Yhs+bCFnx93bliyLydqPlIOkfMhsL6VtsejV2ufdW0nbx7HUc10bsNc5VMCCZe08g7TptYKQi7IbCcYgXWUzbQD3vg8KvB/Rmhly9lmAgnNGAvr0vABI27MjjtMwkZKd78SiPxpmQlhN9zRjUaXREsL5WSNJdpRC02y1WSMPcOs+uHj8NGEKLYdhyRSut8qQARIO6ZA5/2tx/mUBoEpo8hmpqtW1eGJv3MknNagTd/ECfaWi2I
 F8DZrA07
 grGqMgaTacchKTXOms9QQQGbwMMBDs6rLVYxKfWMKHiOLnAcoFJ5OzNSmmKlvG9FIsko4zTzw0u0zSKespBPKfKLZtAAUCxhhjOX85GrLo/Q5xPkbiGNyH/GOEsmcG/r5P+bDea3uSiCBgaqn4tf/RyCzMdJln1/LZO4Rm13Un3L2lFW4T91nzu5ahXc6+H0rrE6j2a2b+bYUADHj1zTysYTtPtbffmKyCTOhNAOWMuIv5/soyvFrRTFJzSEnfWC+cNoMCQVf16RInJY6pyAeihPDDREoYCxicFsA5gBz/PQY4DGK6/vxIHCPM+1FjtdEpsGRDLFtndNIyPVFmEfYfei7v/XML8e9Ml6KKCvcfwXDfFvnqPOYa5QFEoFSZnqBEZb0Z6UDDq0oEbdrYffNVbtzGW+JlBl3lXAL6Q3vIVkWdneCA5KtssOpNMmUq421sBlynIS+DoD66yY7c0AQDUWsDlqJ5bmC7IiQCuGwA66XaNAmr6peNeGrs6WXR6P3/m7H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory promotions that go through should_numa_migrate_memory determine
if a promotion should be ratelimited / throttled by checking how much
headroom there is in the destination node. If there is enough headroom,
there is no reason to be throttling promotions.

On tiered systems, however, a promotion may trigger reclaim on a node
that has plenty of promotion headroom since the memcg tier may be at
the limit. For these allocations, we should make sure that memcg tier
fullness is also considered when determining whether a promotion should
be able to go through without getting limited.

Add an additional condition to check before letting a promotion
candidate go through un-ratelimited, by checking if the memcg tier is
already at its limit.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  7 +++++++
 kernel/sched/fair.c        |  3 ++-
 mm/memcontrol.c            | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 9c2f11191a499..a7c366b431a0e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -654,6 +654,8 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 		page_counter_read(&memcg->memory);
 }
 
+bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid);
+
 int __mem_cgroup_charge(struct folio *folio, struct mm_struct *mm, gfp_t gfp);
 
 /**
@@ -1172,6 +1174,11 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *target,
 	return false;
 }
 
+static inline bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid)
+{
+	return false;
+}
+
 static inline int mem_cgroup_charge(struct folio *folio,
 		struct mm_struct *mm, gfp_t gfp)
 {
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d78467ec6ee13..397b0f3e67f5f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2697,7 +2697,8 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 		long nr = folio_nr_pages(folio);
 
 		pgdat = NODE_DATA(dst_nid);
-		if (pgdat_free_space_enough(pgdat)) {
+		if (pgdat_free_space_enough(pgdat) &&
+		    !mem_cgroup_tier_over_limit(folio, dst_nid)) {
 			/* workload changed, reset hot threshold */
 			pgdat->nbp_threshold = 0;
 			mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 4dce7c6fefd98..05611a01aa082 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2590,6 +2590,41 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
 	return max_overage;
 }
 
+bool mem_cgroup_tier_over_limit(struct folio *folio, int dst_nid)
+{
+	struct mem_cgroup *memcg;
+	int dst_slot;
+
+	if (!mem_cgroup_tiered_limits())
+		return false;
+
+	dst_slot = nid_tier_slot(dst_nid);
+	if (nid_tier_slot(folio_nid(folio)) == dst_slot)
+		return false;
+
+	guard(rcu)();
+	memcg = folio_memcg(folio);
+	if (!memcg || mem_cgroup_is_root(memcg))
+		return false;
+
+	do {
+		struct page_counter *tier_counter;
+		unsigned long limit;
+
+		tier_counter = mem_cgroup_tier_counter(memcg, dst_slot);
+		if (!tier_counter)
+			continue;
+
+		limit = min(READ_ONCE(tier_counter->max),
+			    READ_ONCE(tier_counter->high));
+		if (page_counter_read(tier_counter) > limit)
+			return true;
+	} while ((memcg = parent_mem_cgroup(memcg)) &&
+		  !mem_cgroup_is_root(memcg));
+
+	return false;
+}
+
 /*
  * Get the number of jiffies that we should penalise a mischievous cgroup which
  * is exceeding its memory.high by checking both it and its ancestors.
-- 
2.53.0-Meta


