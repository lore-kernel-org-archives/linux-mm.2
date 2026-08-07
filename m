Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C00C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737D76B0093; Fri,  7 Aug 2026 16:21:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C23F6B0095; Fri,  7 Aug 2026 16:21:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563306B0096; Fri,  7 Aug 2026 16:21:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 259FB6B0093
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94B69140183
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:09 +0000 (UTC)
X-FDA: 85075592658.12.3E8FF5B
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id CC25E100010
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bAM2y/wz";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/MfpY/lSQ8qNOiw/HDxNskiAGRLvzb2J5gjoLFAHE4=;
	b=Fm8igxWGca/v7g65DkZo388Ll38AAPVSA8hbrNzFpZLdUCOdi9ACeLmk9yhTznwGpNJr5F
	pjJv9zutC7MOEX5YGmRI0rjiApC6Sdqyz1HVswHrphYuRXJNcPhOT507uY0EQGRMwHBr3a
	T0x5rAemyCuAlWcyCeGa4WY6CDmWuYw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134067;
	b=eSPbfJARxO9xjcZrpEv45ncqY6b8Q0duy6lJhCXUXZW+hgazNfNI3/m317zwJSgDpSq4/j
	i26iKE3I2PwsZEAHsJ3YM4S1fqM1NvUIBmPxyekOoKOAA27MRcReo+eiFFTg2q0yPEAd+9
	DPGznFQVQrXYRN+7R2seiGDCapZf4j8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="bAM2y/wz";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.182 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4a4cb36ae00so2295568b6e.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134067; x=1786738867; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k/MfpY/lSQ8qNOiw/HDxNskiAGRLvzb2J5gjoLFAHE4=;
        b=bAM2y/wzSRLcLO/4rUly21FFo08LvW0S4cQqcjWsd3kIRiEjgQza6eeFfyiThhWKon
         vgDWeqsGNfHJVUe90Zz6Ef6NNWPK6qlFRe3uClWfjeMkLVmlAkx2P/le1SaDvJAxgU4J
         115h8APRqLLFEdfyjch1036VZ98+xRjSy5n3pcXjdAP0WBIYPH2bPuIT3A2fVVf6oxoR
         Q2cyWRn+n+EYdPy6NQAW0/z/czEm//3yYZVKjWaPYP2bDYBeHDaU6w7FXMRN2AgNkhEw
         PQ6cGtADZleTVnXfcctTes/82guBWqS0Uay9q72ltGjWKyh1lRM/CNYA6rKpdWdJoD0B
         KtRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134067; x=1786738867;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k/MfpY/lSQ8qNOiw/HDxNskiAGRLvzb2J5gjoLFAHE4=;
        b=iRR4eMQty3HEUcntaHsg5uq4vzVUGwYEbdlr1pwNcHysMihkE3aax+FHKYromT93sz
         VmMmGxQVU2+YzwKIBAc6eEcvKYP5cX7FGLmyXKZy6bW0aRwD9TfqePJTvnwaBQJeb+u8
         08ycB2C3kB7wV2BxeuHCznTGkxixh+B4MNFyF+xBLf0MbmIedozMK5tDj972TPCObrgI
         QNgK6VEC9ReuItTC/etCciJEoPAB+yp/GLGDtz2zsSUvl38zKcnhdSioiPHJmViRLJ23
         WsDpZpL3BYe27tuxtLpL+H6ToZGD3w/TzdCPlDXYpZuZNBt/43DgXxEgcLeoYHxUWjWo
         P5xw==
X-Forwarded-Encrypted: i=1; AHgh+Rqxdhj6LQc0R8Fw5Px4Bie/G17p1EneFiowOajA8Dt/9xC6pmC4oHIwoTXk4IgiMacLE0u/wtx/iw==@kvack.org
X-Gm-Message-State: AOJu0YzugtxZVokgwg/AEV9vKL3yBMSYlef/bm/mAmY/negyFi0h3x8H
	6xsKVVK6MMr/uQNivIKGo0kj5rKYWltcNWaYd3fGo+NVrjvWhx8H1BBl
X-Gm-Gg: AR+sD12iLaP5y7BIIl8fyN51aIsiBdg6iSdOY8IGjN7xG88H0jcmCYkNDRSjNysswZG
	d9VKhY1I1IG2DkTYVrE7rovYwfQutaOYMgQowX7QqflWBH+glLXupBJoPxwk58/R+CV6/n0RqdK
	GqozIpUKoWOwGmMCz+H0zkIETpyrJzBElonWXgw+0EI5xHcXxdmf28kIeE3oOZXyUZ/uIx0sa+y
	Pv7cPI8A0RAGztyfG/27NCc5t+TT5Ko58lSiR4aex7ESa1ZSAgeOhjzti7tjQFeFE3uWeFowyvG
	ffQE0qV9oHwilnlih993fnFIzNUIKrwRnzMc6ZaSFrTURHFFFT/y5WflVB7IBZdRW2Glmc0I07b
	J7ICNI8KkjyWyOD0NeQ4XdjPNTcNJTiWJ+1/EGvqB3/jTSKCxpKsJq2/0PdTb+CWIwzKWYmeVN7
	/dyh9wftDVQot5MmkqFbK+n75H542zS5QbKkgsx8XkEzMAzLLzGSLRjiH3JN2a4L2J/eK+QGuAv
	Y9Dv7h/31ShITI4qvU=
X-Received: by 2002:a05:6808:15a6:b0:49b:c387:36c5 with SMTP id 5614622812f47-4afae16d6cfmr14165498b6e.17.1786134066779;
        Fri, 07 Aug 2026 13:21:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b1af0b57f6sm442378b6e.5.2026.08.07.13.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:06 -0700 (PDT)
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
Subject: [RFC PATCH v3 04/14] mm/memcontrol: Allocate per-tier page_counters
Date: Fri,  7 Aug 2026 13:20:47 -0700
Message-ID: <20260807202059.2620949-5-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: pwqhuru8kbggt4gp55mndk11frd3qdhx
X-Rspamd-Queue-Id: CC25E100010
X-HE-Tag: 1786134067-454215
X-HE-Meta: U2FsdGVkX1/ZRC2dkDo7fgwAy4OH86ZFqOcRppdZ2Tt6SmL5oqAP/kfQPQqKFphodUOr2IqPryrarcXzI7QgjrsImbcfTC6mwElgrVDsshyKBCLfaGEvUY2MKShLr3oNTtcB0Y+cRgk/lSCR29sZeE9aK7qnqKVOKY+NDf192DnSysL8XN8ho38JgT0d2RMkAaFC9gQZdHft2PRqnM6Y6dWP+U8NpueyEPye792XKZAe3cA2BhwlTgFeP5dnc0hwznmRlyZcNQbW78u/H3ZJUNyG8j84l8bOmmGd6JCnRAcAkc7Ecj4IfKjT/LM6BEF0uI/iP47aziKjyTimjLEjaRM1YIRGdFe9HKST8hikxH8MWCjJgBjLlT10uj6BKvNGCEfLQaBzrLROO932XNLyEq6D1m4JuBwDMAhwVJOaJcdqlYqcd2Et0z92tevf4n6GLePAP2YStWkZtREkvzByE3UJHzNjtT4nfmUk8JP5oesxqi7Ogkgz60Ct7RIMKI+7fyE9NciLansWiNhIWuv7ys2hbHb2QbgnRBEUJ0dEcK1g9IzAdkHNgh5xUDZyN/6BVvSk+8rl1/1BOsSMpoBzPL0YnJg1KvwzriTrDGf/+IPhl3ybWc7HwAvrqMcFpOS3nhMRfPoQtk3uwqExMXy8O3cXKtJFHqFHPrrC9dAi/rL3lBhmyrzC4jLBQlYjq5MHw5ShvWoR827hlO+cAfT9KB0fLi9sdMipdA3B6pXl/5Ij9pSVp8Uto651HC04vFT89HrVjiKgegpfJlaqSSw3hfuMwwmMfRqbC758zfslUTeoxJXJUkt8C16k3xBZ4HPUA46+Zw00mrZ7AsurPOImwEISOC638nowgSR33q2oEWz/y45RSMdJJWTuQjwJhY+GBNVVmSuhCz+dpBHzMnJCGZaXyhfQwN4L2MZbDKYZO+EVOFEpWbMGgZc4rzA+D9ljIhgLl0vrWZpzoXF/gN3
 8Cf+41Oc
 4suWlz/b/gS70iVcUq0VCpi+5Xga5UkI6dAmFGN/2gtihGCO+vefQgKcI5mQaLf63RNvSkPElsNq8NPt+1dUsdXDk7RqCzLDzpHqSlkTJzqdVJ339RHtk7x+7YTf1OF/2oTUgYvd3WcEIBi4g2UJLXC1cx9OqwDt/39YAulwoIL5dIxW1/hTwLz9lmf82yqM7xRZUn86TQbvPBYACJWmx+wbKA5N7lwzDBf4BI9glD3MgyCaQXTtwlwLcR6DWKxIfJRTXj32pJUokJjtklE0dr7p9Fh/q0KtpRSJI2BC1ri8GOjolHWAGQLPAjulYH2hvbmL0FEquu1NeAVbhU3DbajlxXXDFhHVT6K1vkGW7WuB5FcIIgRx9JeQ2km7ZRc9nprGbDuLZw7W0nZL6hPUcwLv2ybWVwSc45Y1V0eRGW0iG31WSIyv6zAfCVy7gKbFdE25sNuDKsFTDknkgs23LS6c9lorj5OgxU5KmXYGWkgx2neVDUiHuxOaNDKywzuatuLcwl3oyRvnMUqgOI4ntIBnrdjfLEHrIClONxWjR+QG47Vk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tier-aware limits need one page_counter per memory tier.  Add a
page_counter array (memcg->tier) to struct mem_cgroup, sized to
nr_node_ids (an upper bound on the number of tiers) and allocated only
when tiered limits are enabled, so memcgs pay nothing when the feature is
off.  Initialise and parent-link every slot in mem_cgroup_css_alloc(),
and free the array in __mem_cgroup_free().

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 23 +++++++++++++++++++++++
 mm/memory-tiers.c          | 17 ++++++++++++++---
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index dce03df7eae05..bb5bde87ac85a 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -207,6 +207,7 @@ struct mem_cgroup {
 
 	/* Accounted resources */
 	struct page_counter memory;		/* Both v1 & v2 */
+	struct page_counter *tier;		/* v2 only */
 
 	union {
 		struct page_counter swap;	/* v2 only */
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index ec28512de6a23..d096010366515 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -53,6 +53,7 @@
 #include <linux/seq_file.h>
 #include <linux/vmpressure.h>
 #include <linux/memremap.h>
+#include <linux/memory-tiers.h>
 #include <linux/mm_inline.h>
 #include <linux/cpu.h>
 #include <linux/oom.h>
@@ -4126,6 +4127,7 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 	memcg1_free_events(memcg);
 	kfree(memcg->vmstats);
 	free_percpu(memcg->vmstats_percpu);
+	kfree(memcg->tier);
 	kfree(memcg);
 }
 
@@ -4178,6 +4180,13 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 		if (!alloc_mem_cgroup_per_node_info(memcg, node))
 			goto fail;
 
+	if (mem_cgroup_tiered_limits()) {
+		memcg->tier = kcalloc(nr_node_ids, sizeof(*memcg->tier),
+				      GFP_KERNEL);
+		if (!memcg->tier)
+			goto fail;
+	}
+
 	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
 		goto fail;
 
@@ -4206,6 +4215,16 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
 	return ERR_PTR(error);
 }
 
+static void memcg_init_tier_counters(struct mem_cgroup *memcg,
+				     struct mem_cgroup *parent, bool protection)
+{
+	for (int i = 0; i < nr_node_ids; i++) {
+		page_counter_init(&memcg->tier[i],
+				  parent ? &parent->tier[i] : NULL, protection);
+		page_counter_set_high(&memcg->tier[i], PAGE_COUNTER_MAX);
+	}
+}
+
 static struct cgroup_subsys_state * __ref
 mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 {
@@ -4231,6 +4250,8 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 	page_counter_set_high(&memcg->swap, PAGE_COUNTER_MAX);
 	if (parent) {
 		page_counter_init(&memcg->memory, &parent->memory, memcg_on_dfl);
+		if (mem_cgroup_tiered_limits())
+			memcg_init_tier_counters(memcg, parent, memcg_on_dfl);
 		page_counter_init(&memcg->swap, &parent->swap, false);
 #ifdef CONFIG_MEMCG_V1
 		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
@@ -4243,6 +4264,8 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 		init_memcg_stats();
 		init_memcg_events();
 		page_counter_init(&memcg->memory, NULL, true);
+		if (mem_cgroup_tiered_limits())
+			memcg_init_tier_counters(memcg, NULL, true);
 		page_counter_init(&memcg->swap, NULL, false);
 #ifdef CONFIG_MEMCG_V1
 		page_counter_init(&memcg->kmem, NULL, false);
diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index 36187c0ea9ded..bd5c78cd26ec4 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -52,6 +52,7 @@ static int nr_tier_slots;
 static int tier_slot_ids[MAX_NUMNODES]   = {[0 ... MAX_NUMNODES - 1] = -1,};
 static int node_tier_slots[MAX_NUMNODES] = {[0 ... MAX_NUMNODES - 1] = -1,};
 static nodemask_t tier_nodemasks[MAX_NUMNODES];
+static unsigned long tier_capacity[MAX_NUMNODES];
 
 struct memory_dev_type *default_dram_type;
 nodemask_t default_dram_nodes __initdata = NODE_MASK_NONE;
@@ -307,8 +308,10 @@ static void establish_tier_slots(void)
 
 	lockdep_assert_held_once(&memory_tier_lock);
 
-	for (int slot = 0; slot < old_nr_tier_slots; slot++)
+	for (int slot = 0; slot < old_nr_tier_slots; slot++) {
 		nodes_clear(tier_nodemasks[slot]);
+		WRITE_ONCE(tier_capacity[slot], 0);
+	}
 
 	for (int nid = 0; nid < nr_node_ids; nid++) {
 		struct memory_tier *memtier = NULL;
@@ -323,8 +326,16 @@ static void establish_tier_slots(void)
 
 		WRITE_ONCE(node_tier_slots[nid], slot);
 
-		if (slot != -1)
-			node_set(nid, tier_nodemasks[slot]);
+		if (slot < 0)
+			continue;
+
+		node_set(nid, tier_nodemasks[slot]);
+		for (int i = 0; i < MAX_NR_ZONES; i++) {
+			struct zone *zone = &NODE_DATA(nid)->node_zones[i];
+
+			WRITE_ONCE(tier_capacity[slot],
+				tier_capacity[slot] + zone_managed_pages(zone));
+		}
 	}
 	WRITE_ONCE(nr_tier_slots, highest_slot);
 }
-- 
2.53.0-Meta


