Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8131C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5625D6B0099; Fri,  7 Aug 2026 16:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED106B009B; Fri,  7 Aug 2026 16:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6996B009D; Fri,  7 Aug 2026 16:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C1746B0099
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89D7A1601B4
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:14 +0000 (UTC)
X-FDA: 85075592868.09.B528370
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id BDE908000F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rGt1iMj+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxxJcfOvuS2DiwqIjrqP14riK8k/np3VBj64PdkOyLA=;
	b=Ldg5rViKjKYl+vN6cM6fx3XoUq+rXTmyTybF/ptmgOsz+ZXE7r9WpOE99YF3dC9DqdBhdo
	wP82uiFfi0tKKwLYz7ZjV5PdwghniAMgAgGKIGY/P2qvxFa3IN4jtOTmRAtOCEqkP5x0Oa
	Ly5B8x5qRJZJjEKgkPiM7JqEsgdbLMg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rGt1iMj+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134072;
	b=bJ8x9UvT8J29AXPviOeB3dAEBMGh0dO56OhXFFmMmxZ29f+CqKGdb4+Cggz6D88iZQ7T5A
	okXKdifroVaMuCv9VnSgOkTIf3iOeZmZyAjuo3zFR+kxmQu1N/98giPmVT2IlzvZCSYv3l
	XiYFlBI9SfTCdyKQtCt0abM6uFRYN6o=
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-456395f4e7bso2717522fac.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134072; x=1786738872; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lxxJcfOvuS2DiwqIjrqP14riK8k/np3VBj64PdkOyLA=;
        b=rGt1iMj+KJMSxo0IT5DYlfY7T1olSaxJPLx9+3jp1xz6cdOAJc4UfIWrE3adOkoOC5
         GCuwmv+FoExQS7I2k7tTUgxT8T5TutjTikSFvLKCWRNq8j1CCv6rCTCef2g90VjtKqZz
         cmbSlSR1vAnyDvfRD3XE3AwdFFnBv/o98vbYCv9h6Zpi688j3Ms5LoNYHtuWvslFSkbi
         4/nG0COrgeIrRT8dYaxWl+H/v+VxBnl5laDFaJCVZt+msZnF1i8T+E1rxto6ffNvmoGu
         hzmYMc84oLS3F516l1d7fDqpsgV1L5w8n+RAy7XfVdPpxO/u3hrET47KWlXi/qbUBLvd
         La5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134072; x=1786738872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lxxJcfOvuS2DiwqIjrqP14riK8k/np3VBj64PdkOyLA=;
        b=DqLy+6OC8VnGG9n1IZnOB08xyuqVgEXfRsOYcsCzTA7g68f3Zy2+DbFyxfK0qJbIJu
         +o3zk1MMJpiDz/dUySuiPc0SPwqDkwXFpq3JfhRhPFVvITtwM990mBk49ab5xorcSSDu
         9V11CJ7J2Hhh/HQmiOIT3TMLuxbH7fA2fDbBcmvs+rD7Lf4PLgjl8jL6o6qx/Yby5fWy
         vt1db8a0VkZRiS0mnGN5tGvQ62diy+KOU9TyT9HJfCQ0yZKGrnSk0e7s4LO1wcPrFJrI
         y4Yw91DcJnN8fYqncjigerU6sXgVafWfBCHHKR5ivo+Hp+x5Gw2SCKYAPyRvEge2WtIa
         v92Q==
X-Forwarded-Encrypted: i=1; AHgh+RpR9EeLfOysxkcB4mSWA9aUymTsTQcu7FsQJ5kBUODYfh9mJWqdFaqo/Qm7nM3sS8HGv6cNGDQsvg==@kvack.org
X-Gm-Message-State: AOJu0Yx2Qrupr/WgXv80QvpTFXp4vlMEHUpWeFgdOP9TrfCnWCJolhAw
	+kJX01ayPwHuw880q96KcQ4OIwgXik7Sbl0FuTeoqHbykhZF76UxZ4td
X-Gm-Gg: AR+sD12dIUuhNgPd6rpMG6G5HEJvVnjtiyPKgCKrcHNURPKr9xx0cVEpGtDwKu4BbEl
	+4Uso8DCxxuwCKEK+pQy+UKpnOheOCRiko7wyDBGyFQUx61jRFJ/iMGeAzee+Z2ctk7Kkawbnll
	af05mjl9t9jhcuYShHxX9i/WsGZMGdZ0BV/cjObbhgMGexoDpi+2VEo6SFLFXuHWhZxw/nyQW0C
	j1Sjxrr/prCuMrj0V7SoRyPrrS0mA5v+APaywV22Diuk6w+muKys8qZVxBW/8woWKSgI6UBvciu
	22R+7Bk+CfuqqoiXgB/squiSzmKUmIjOSyZlnezx9XDp6h1YN64QKqVDJmsk6praK7akv3bycjs
	gplPJu05Vv15j2TXjTVkqVM7fN10TG5HYxmfM3II1OUlJ1gUD4vLH0qkqQpSi0y7sdb9Mi5LRy+
	UfUu50oZIX2w3nnyzFtRHRSq5NMWtIaW+DOclqbwL2wqVUZKf5Sn1Mh1+P+yewk87iAuGZXqKcW
	GEKQ9ozqa8CNoOmF4yUbEXXalwYPQ==
X-Received: by 2002:a05:6808:1a0b:b0:490:af61:8830 with SMTP id 5614622812f47-4afadf217ccmr13020013b6e.3.1786134070676;
        Fri, 07 Aug 2026 13:21:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:73::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b1af63b441sm422380b6e.14.2026.08.07.13.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:10 -0700 (PDT)
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
Subject: [RFC PATCH v3 07/14] mm/memcontrol: Charge/uncharge tiered memory to mem_cgroup
Date: Fri,  7 Aug 2026 13:20:50 -0700
Message-ID: <20260807202059.2620949-8-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: qjqbdotgqd8rfce9abtuyagme1zt9rm8
X-Rspamd-Queue-Id: BDE908000F
X-HE-Tag: 1786134072-950242
X-HE-Meta: U2FsdGVkX18wk17qt94EuC9cmxHk4JhfPikYiUDKB8yeG0X/PDbjkycuGUc0GJKf0wt5yzvFmvjG36W/ApdugLM6bWa+755LrnNb3tp/s5ctLI0Ch0BB3QKvMQ5DmagChTEC6qH1BXKb1wyN+OwVzFNCiW00paqiGkYPyFrmBUxr024oWoEe+sovG5Nal2DuZGSYJm5ZGhnB/8QA/2MctgzmMlRYHOaocx26TVH/8Zf6ZOLVeq5Es5ED54YLlpxFmN3bPsrPjESDlq4O5jZdpqtUeL0w9n6WZ7TzfDC7yjZxNimXHYFNXsekJrmcvAg+cGJ5qGsQmMu5Ff90RYyF0C5RHcSTxw0nFJ4BBAQO+j/2myVVDhyIdAyOK1ftGwq5kOiFvBRg2W9F0XJizdGN3S4hk3vso6wU2XkouX/y004sgCUiIiBh33hoPsSaVXi6YVFRc7kA1X34L+llsMGPFAczGzpAV4dg4km0vKxbcgVep+ELqcnQdc4MdsXYdrlXxPuTC/NXKyBpnQoNOYrpza2PSArbs4YnY0VLizndp+ODvSmNLxC8hSssL+rzrfKQTHkaVrveRROx9AtrxGlujGeEgrjZ0bAsXQR4Bh0Z4LFBKmZMseJ3bS63PNBNEYAssBa3kAL10Rq5JJumYUpL9rjf3RQKHD+qYZdvGKbMDsZ31y7zoZ8SYpBsNBdh3fxbFN2IPib1uAIN0G6XAv/dr6HmgCMV688p2E+g/bTxo3sOnbTiTSEig7s4Rh4tlQhaNLbu9YJ8YVXbFY/ceagoWQMJGsKM/avkcOoMUQO3ihzTA2BIFG2T0pTtjpA7fGi6N7WfpgL+4UDykpS7eTG3Eg0cwL5047haBcijFi0PNC9vyHc9O0E/hs4e5Bvx0RL2WNlszvVdDyrGRnzZsE67Zo6X1LRPGcctwdoWqLI8//sjMg97v/Lxvytqty0+oMfbJAsSbl5rZGTSuQ/M3JI
 65AtGOB0
 kruj8aP/i3vKMS5XvGZ8WBZycgd+Wtyn2PZzG1bVqOAvxhHjPwlVWU4LEJz/0uU9GPSSIXQAIxtfMTFrYIxBc1b86T7Ygt4mGT7Se2/cbdJmzgu1g+/nQg2qT5LgUKLvk5iD4cPUwdlmF5PvFzC1XAF4eSqqlWKoLD/ZfNwiJsLeno1OsvA15zWzhnCyw23SCwXWRVjU2p9lSYKkSSUZO0lgCgswa3NmurJ6pufm1i4Lj5XMOBpDXocJQc+TDgod9xdRgzGyxLcg0UZdw91r6DX8Ex8ha3tUTVNTsklbj10ByR7U+7EBgWGrmTHXBdGNHvRdE1Gk3KgZcb/6Cs1TM6v+hv33w5JGWH2Gy4TR3vA/MCXYrKgxaTZe3jmgpRUWXNTg97zArw5wyLxBIwBcEYniVT6vapQjQuwSeXXXfcHXR6U1kaZfv0wqMsI9WHtHkDlWDR4OfZNmuv4EtoSQRmh6b6fO4I3r4aWv7cwBxWg1+rLqTyZQlRctvvZwBF7eoPJYn4iK634yc5kucQtEDUlea3xYikIsoGzze/My6HKOhzDs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory cgroup limits isolate memory as a resource, but treat all
memory as equally valuable regardless of which memory tier it
resides in.

Account tiered memory usage in parallel with existing memory
accounting. Add an nid parameter to try_charge_memcg(); callers
resolve it to a tier slot with nid_tier_slot() and charge
memcg->tier[slot] alongside memcg->memory.

Uncharging reuses uncharge_gather to batch. Because the high-volume
free path reclaims per-node, a batch is normally single-tier; if a
folio in a different tier appears mid-batch, flush the accumulated
uncharge and start accumulating for the new tier. Folios on
different nodes within the same tier do not force a flush.

Also, mem_cgroup_migrate() and mem_cgroup_replace_folio() now move the
tier charge when the folio changes tier.

Currently this only tracks LRU folios (try_charge_memcg() callers
from charge_memcg()). The other two sites, obj_cgroup_charge_pages()
and mem_cgroup_sk_charge(), will be handled by a future series that
transitions enum memcg_stat_item to a per-lruvec counter
(enum node_stat_item).

The per-tier limits computed in the previous patch are not consulted
yet, this patch only acounts the memory. Enforcement will come in the
following patches.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 116 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 108 insertions(+), 8 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6c67d9d2c9ac7..f3714dfd85aa0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1561,6 +1561,15 @@ void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
 		*lru_size += nr_pages;
 }
 
+static struct page_counter *mem_cgroup_tier_counter(struct mem_cgroup *memcg,
+						    int slot)
+{
+	if (slot < 0)
+		return NULL;
+
+	return &memcg->tier[slot];
+}
+
 /**
  * mem_cgroup_margin - calculate chargeable space of a memory cgroup
  * @memcg: the memory cgroup
@@ -2645,13 +2654,32 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	css_put(&memcg->css);
 }
 
+static void mem_cgroup_uncharge_tier(struct mem_cgroup *memcg,
+				     int slot, unsigned int nr_pages)
+{
+	struct page_counter *tier_counter = mem_cgroup_tier_counter(memcg, slot);
+
+	if (tier_counter)
+		page_counter_uncharge(tier_counter, nr_pages);
+}
+
+static void mem_cgroup_charge_tier(struct mem_cgroup *memcg,
+				   int slot, unsigned int nr_pages)
+{
+	struct page_counter *tier_counter = mem_cgroup_tier_counter(memcg, slot);
+
+	if (tier_counter)
+		page_counter_charge(tier_counter, nr_pages);
+}
+
 static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
-			    unsigned int nr_pages)
+			    unsigned int nr_pages, int nid)
 {
 	unsigned int batch = max(MEMCG_CHARGE_BATCH, nr_pages);
 	int nr_retries = MAX_RECLAIM_RETRIES;
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
+	struct page_counter *tier_counter = NULL;
 	unsigned long nr_reclaimed;
 	bool passed_oom = false;
 	unsigned int reclaim_options;
@@ -2659,10 +2687,19 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool raised_max_event = false;
 	unsigned long pflags;
 	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
+	int slot = -1;
+
+	if (mem_cgroup_tiered_limits()) {
+		slot = nid_tier_slot(nid);
+		tier_counter = mem_cgroup_tier_counter(memcg, slot);
+	}
 
 retry:
-	if (consume_stock(memcg, nr_pages))
+	if (consume_stock(memcg, nr_pages)) {
+		if (tier_counter)
+			page_counter_charge(tier_counter, nr_pages);
 		return 0;
+	}
 
 	if (!allow_spinning)
 		/* Avoid the refill and flush of the older stock */
@@ -2677,8 +2714,11 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto reclaim;
 	}
 
-	if (page_counter_try_charge(&memcg->memory, batch, &counter))
+	if (page_counter_try_charge(&memcg->memory, batch, &counter)) {
+		if (tier_counter)
+			page_counter_charge(tier_counter, nr_pages);
 		goto done_restock;
+	}
 
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, batch);
@@ -2781,6 +2821,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * temporarily by force charging it.
 	 */
 	page_counter_charge(&memcg->memory, nr_pages);
+	if (tier_counter)
+		page_counter_charge(tier_counter, nr_pages);
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
@@ -2852,7 +2894,7 @@ static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (mem_cgroup_is_root(memcg))
 		return 0;
 
-	return try_charge_memcg(memcg, gfp_mask, nr_pages);
+	return try_charge_memcg(memcg, gfp_mask, nr_pages, NUMA_NO_NODE);
 }
 
 static void commit_charge(struct folio *folio, struct obj_cgroup *objcg)
@@ -3152,7 +3194,7 @@ static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
 
-	ret = try_charge_memcg(memcg, gfp, nr_pages);
+	ret = try_charge_memcg(memcg, gfp, nr_pages, NUMA_NO_NODE);
 	if (ret)
 		goto out;
 
@@ -5280,7 +5322,8 @@ static int charge_memcg(struct folio *folio, struct mem_cgroup *memcg,
 	objcg = get_obj_cgroup_from_memcg(memcg);
 	/* Do not account at the root objcg level. */
 	if (!obj_cgroup_is_root(objcg))
-		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio));
+		ret = try_charge_memcg(memcg, gfp, folio_nr_pages(folio),
+				       folio_nid(folio));
 	if (ret) {
 		obj_cgroup_put(objcg);
 		return ret;
@@ -5376,6 +5419,8 @@ struct uncharge_gather {
 	unsigned long pgpgout;
 	unsigned long nr_kmem;
 	int nid;
+	int tier_slot;
+	unsigned long tier_nr;
 };
 
 static inline void uncharge_gather_clear(struct uncharge_gather *ug)
@@ -5383,6 +5428,34 @@ static inline void uncharge_gather_clear(struct uncharge_gather *ug)
 	memset(ug, 0, sizeof(*ug));
 }
 
+static void flush_tier_charge(struct mem_cgroup *memcg,
+			      const struct uncharge_gather *ug)
+{
+	struct page_counter *tier_counter;
+
+	tier_counter = &memcg->tier[ug->tier_slot];
+	page_counter_uncharge(tier_counter, ug->tier_nr);
+}
+
+static void gather_tier_charge(struct uncharge_gather *ug, struct folio *folio,
+			       unsigned long nr_pages)
+{
+	int slot = nid_tier_slot(folio_nid(folio));
+
+	if (slot < 0)
+		return;
+
+	if (ug->tier_nr && slot != ug->tier_slot) {
+		rcu_read_lock();
+		flush_tier_charge(obj_cgroup_memcg(ug->objcg), ug);
+		rcu_read_unlock();
+		ug->tier_nr = 0;
+	}
+
+	ug->tier_slot = slot;
+	ug->tier_nr += nr_pages;
+}
+
 static void uncharge_batch(const struct uncharge_gather *ug)
 {
 	struct mem_cgroup *memcg;
@@ -5395,6 +5468,8 @@ static void uncharge_batch(const struct uncharge_gather *ug)
 			mod_memcg_state(memcg, MEMCG_KMEM, -ug->nr_kmem);
 			memcg1_account_kmem(memcg, -ug->nr_kmem);
 		}
+		if (ug->tier_nr)
+			flush_tier_charge(memcg, ug);
 		memcg1_oom_recover(memcg);
 	}
 
@@ -5440,8 +5515,11 @@ static void uncharge_folio(struct folio *folio, struct uncharge_gather *ug)
 		ug->nr_kmem += nr_pages;
 	} else {
 		/* LRU pages aren't accounted at the root level */
-		if (!obj_cgroup_is_root(objcg))
+		if (!obj_cgroup_is_root(objcg)) {
 			ug->nr_memory += nr_pages;
+			if (mem_cgroup_tiered_limits())
+				gather_tier_charge(ug, folio, nr_pages);
+		}
 		ug->pgpgout++;
 
 		WARN_ON_ONCE(folio_unqueue_deferred_split(folio));
@@ -5514,6 +5592,11 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 	/* Force-charge the new page. The old one will be freed soon */
 	if (!obj_cgroup_is_root(objcg)) {
 		page_counter_charge(&memcg->memory, nr_pages);
+		if (mem_cgroup_tiered_limits()) {
+			int slot = nid_tier_slot(folio_nid(new));
+
+			mem_cgroup_charge_tier(memcg, slot, nr_pages);
+		}
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
 	}
@@ -5558,6 +5641,23 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 	if (!objcg)
 		return;
 
+	if (!obj_cgroup_is_root(objcg) && mem_cgroup_tiered_limits()) {
+		struct mem_cgroup *memcg;
+		unsigned long nr_pages = folio_nr_pages(old);
+		int old_slot, new_slot;
+
+		rcu_read_lock();
+		memcg = obj_cgroup_memcg(objcg);
+		old_slot = nid_tier_slot(folio_nid(old));
+		new_slot = nid_tier_slot(folio_nid(new));
+
+		if (old_slot != new_slot) {
+			mem_cgroup_uncharge_tier(memcg, old_slot, nr_pages);
+			mem_cgroup_charge_tier(memcg, new_slot, nr_pages);
+		}
+		rcu_read_unlock();
+	}
+
 	/* Transfer the charge and the objcg ref */
 	commit_charge(new, objcg);
 
@@ -5633,7 +5733,7 @@ bool mem_cgroup_sk_charge(const struct sock *sk, unsigned int nr_pages,
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
 		return memcg1_charge_skmem(memcg, nr_pages, gfp_mask);
 
-	if (try_charge_memcg(memcg, gfp_mask, nr_pages) == 0) {
+	if (try_charge_memcg(memcg, gfp_mask, nr_pages, NUMA_NO_NODE) == 0) {
 		mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 		return true;
 	}
-- 
2.53.0-Meta


