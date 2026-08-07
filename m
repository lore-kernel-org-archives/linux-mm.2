Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A941C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 20:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 675186B00A1; Fri,  7 Aug 2026 16:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6000E6B00A2; Fri,  7 Aug 2026 16:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42AA86B00A3; Fri,  7 Aug 2026 16:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17BFB6B00A1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 16:21:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A33FA0EF0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:21 +0000 (UTC)
X-FDA: 85075593162.09.3A40DEC
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id CDDD3140004
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 20:21:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="b/m+aTXr";
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786134079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XkMxJlHKp/V+Gx87DIQUe3nc4ANw9n5bBTpUGWIjt4=;
	b=TUFRRSqU2QTgPFXohZTvhNPaDSAKZrOA5pOEvHuctOo/ra9R27mKng6dnF30DymaLm2Ag2
	877Wl7tUHCNn2WCEs5TYwxTFOqfP169jfruZ7ADIGrQXLTELBwYu64AT/cYTYdxoAkVrNR
	+wOUSRmyvzAQ4HRZWHgPMrHzbwDxd4k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="b/m+aTXr";
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786134079;
	b=xG5I/vLpAgDZuUnHrJ6/bvTRHDBHSy88lfB7IiZTu3D7QoqbHw4YpHstnbpX4lYGPsBWZk
	Yzuo1v6C6GfKivvR9iT0lpRi0p+yrKcx9g1cPkpVjsb7sesedTbbFFIeo9BwPstqurNKnV
	HdXTtZu2k1OZ/FLdEg+5JmrmyQFO+i4=
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-4472500e25fso1467219fac.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 13:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786134079; x=1786738879; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8XkMxJlHKp/V+Gx87DIQUe3nc4ANw9n5bBTpUGWIjt4=;
        b=b/m+aTXrWQVPlm17yVT2hP6z0v3atEq3hIzwXxntt0geO9O6te7qsuGkeTGD2pSOQ/
         t2r+JM/1Bo7EqNyLBsYncWdHuDAscO8WX6v7i2YFyI8rzd+eS1Thq+PT4h4gzfcBgLRi
         obkPI+ifyv6CuaiYYFQzNUCUYP21LkHXO4trPpPPGFpny7+BlOQ/EsVucPHWO86hRAOz
         +S+erj74AoIAHeSoQmXtfPSPqN4GTsQBtA2PwSSK1tqlH+cR+TfdJSvhc90pjN8aJgzP
         9N/5f2tuHqKQ4yn5ewsp1kJClsbVKQjId6d/yALgFHDm6j4ERioZJqUuvROQa0ef3Zrw
         DAhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786134079; x=1786738879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8XkMxJlHKp/V+Gx87DIQUe3nc4ANw9n5bBTpUGWIjt4=;
        b=YoBCi9WEZQybK78S7aaI6A1qN81YFZ6P4CrD6X4+UvYgkW72jxPNNrLF1hGEgVUsmY
         9Ea1hZQjMvTdywkp1v4wQb+S27AWAruGYxG/HQKXcwSqUNYcxEys5t+tYYnf55kafprO
         9b06+wYBqCTirJrFFYYlYnBzJbhRo9sB9E8sOXY3xSa6DN6lLq3r8VQtucXL6LLu/m1D
         fzTel5P2fBwVbeGpy+RM+26EQ6fslsz4jdCttGIksgXVGAzpdrz/PTeFjsvJRMSZyVAZ
         rizZr6YBeRsz57PiJfaIp6tuwCzrFhCnZq7YGkNAufPKXp8fxfOpgFUVuuN/Pt1n8+rZ
         fmBw==
X-Forwarded-Encrypted: i=1; AHgh+RopBxdMxigzcDINOvLGGir9XJvfJpXQHyxL/aV6SGf1vlQjk459pnEQROm9ospjhB6sYELJL47q5w==@kvack.org
X-Gm-Message-State: AOJu0Yx4Pe4tzhhs94XTbCsr8YmcKrw1MDuVBFiLJfUBy5R4TfFv/Dd6
	ks2wSkpAWzjC6biVtI7SbleM/d44l+0xqlxML+D1Xh3fJ2tLgQ2/uGmQ
X-Gm-Gg: AR+sD131Ciq29G8IEjvTu3VRc+gf7JZIDew/WC2NG9GJUJCPLiggvUDotFrJmEzwNE4
	3pO2IzpXUmuu8HOsxHRWg0N+VkwumnZmnKzWQVrE+pl3hGid/rTYgDuDArmVJpPyaQn3ouS+a/g
	z7hKwQeAPEtnhbmCZDXT1YEnp+UTwsFN+Yd0EBmXB5arQFGazq3yjUKy1S2Y1WVX+ZVeJZRjEnn
	06UstMh3klsERLhFHQ1WvyKD/uQXzxRIskVOZa3hU+WbbwZKtqSVQ8eNHcd/zaWojJ2E6BYwlbL
	X2xFb/cGj/XTllbvdSj5VPnyXBZfvn3rwQBMHSA1YEJ26fmFpXDX+xop/I/DBlq5uvjrZ1qOYQO
	wRgSNEdC/NRUIlb7tyzqQ4Th4AnDJkHQdMtaZ16ZYzFAp+H9E4faGm4Zg2xe5GFnmWTMd1RbeB5
	sJ3tkSYkhftSAlb9Z0uil5uaR4gi0DZOWIQZE5ol8OppGu8uzs73H1mh9sWjrOUjdGRNsEJQPiI
	fyR4iWgyQahT6Yh2A==
X-Received: by 2002:a05:6871:b0f:b0:456:9b53:c6b5 with SMTP id 586e51a60fabf-4599ef8fbcfmr13854626fac.13.1786134078812;
        Fri, 07 Aug 2026 13:21:18 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1ece1fbsm2770188fac.17.2026.08.07.13.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 13:21:17 -0700 (PDT)
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
Subject: [RFC PATCH v3 12/14] mm/memcontrol: Kick async reclaim on migration and folio replacement
Date: Fri,  7 Aug 2026 13:20:55 -0700
Message-ID: <20260807202059.2620949-13-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
References: <20260807202059.2620949-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ncq4em8apsd8t98xg6bdt5brxbfbzypa
X-Rspamd-Queue-Id: CDDD3140004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786134079-812012
X-HE-Meta: U2FsdGVkX1/nT2DsiX/50wKHE1Pnsrk8XONk1DJLDogKp2QRqjIrh+UyjS4MA3ae4Cg9rYYOi4H7tSjK1uhL+aBKsg5Obr+W3stKBgAH5hcMhx5cFwsKCOV08WjzTormK1F2gp9wFDcks/Tv/aZzD8mlNEnfwgrDMmq4CUhu672sVIThV35Fgt8K+nhEKJACIRBUKBSkmJcCKDX+M3Z3EdSSITzKWtEfpSk+uzKssmTJgeRbIX4WwnHKPr61lMm63OyTFNE7Sa0JnSbU7HBi++pJGvEW4VGo3qqPMCCkJMM4NJQhE/6dat2VSbY0u9N3SBX2AuPk90HERS0pOSUSw5f6oOgAfP9qGzFmOWr1L5+q/Of+c565eX+Q+r6Y7jLZhCP9Cf+wD+5jQYaQiK1se0trW3THAxZuXCveKusKy/o00SkCaS8dgR+JWlS9OpkmQpKdzxK7eC0q1opzTpp0N88KNZR+GgXEugEOGHwikAlc9LzK0+CJPpZIYSxtUSyFplCIIP4/Sp7lKvqv5kuNV8JoqinF8fOSVikOckkOGu1SD/YTTZd/Z+UB8LOY0E7QyS3EfqmpPE2g2VtZKnuTBpjFHatjbQ9X2CxnwGTenE0iWAjor6qWUnfcPPYrvT1foMUpq80GcItvRxf9EXs/1WrqtYtEEINO/dW4bgUyS3QkSaQqN/BPCFZbvM4Z0i9AOID5gALcAuJC/lp7nLffEIFSKPXZCn/lQm2ipW7IA6bCbXgN12MTLxpIYPq4vX6dY6ZrvBQuCw9sEXvVcGNYXMgDhUaX4T0wQl7Im/TrENtuAo1fQ1+88sa1CQYAojPSktHOx/v3RxlAwuIPYPhkfBbIJlz1KVjRO/+zduL2KQrKujz6jwKxdWMariJoIZoOU7HDYWrldXh6W4eSAQDBesIv/+HRLrCn3H88TF27973Ec21q/HsNIuHMA7Kn8UylIJszP9skSiqglPM3qH+
 O9x7SVnm
 quA7hIVW6cm+E0K22pCEOUty22+ZPTycDlwgJtW8evW7krpKcdwxPqSzkxvMuAeizpRHD+KiyLaUDYuiO7BOrbslDR7Ox4Gsm7HzxVTshJ7tTRlW4YKfZ6oILhn1AJsGzCkS5gFH86kTbm9J+DoBO9khwJriwMW4hyAsRwjOM48nNW/dW5GmHpW8ZTJAAc/atxL915BGBUhA9cDy74Q0NOlOf29UZr2bWI7nvwr5vqIAogUyhRk3rz4JQ+bJUuaJwbHEtRniavkY1u3oAVr5je+0g7LHCQSB6Za0MyoqcZuRL7xOUAUebyxQTr8ucUKGGjGj9/AL1n/CYmyFsGIv7xTe8IB9oNpBoQS9J9TasmttKxqtSRjLAkz2qFQwuQy+fIgkLHxbp1Zyf6mZuZ4GfiN6yrnAJLvyl6Mb+3ztf/3z3pLYEpFx1KzBhz/M9hk3EK743pju6adhnsFjRIvLQZrL9B9qUfQ/qEqUPBZllZtSJ2moGhyXeXtK4CgUf7frlJ0SN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memcg tier charges are now transferred during folio migrations, but
this still leaves forced charges and unenforced paths like folio
replacement, hugetlb migration, and memory hotplug.

Forced charges can and should not be enforced by synchronous reclaim,
but if soft limits are set, we can kick async reclaimers to try and
bring the usage below the high memcg tier limit.

No-op unless the system has tiered memcg limits enabled.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/memcontrol.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1161934e81380..4dce7c6fefd98 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5663,6 +5663,16 @@ void __mem_cgroup_uncharge_folios(struct folio_batch *folios)
 		uncharge_batch(&ug);
 }
 
+static void tier_kick_high(struct mem_cgroup *memcg, int slot)
+{
+	struct page_counter *tier_counter;
+
+	tier_counter = mem_cgroup_tier_counter(memcg, slot);
+	if (tier_counter && page_counter_read(tier_counter) >
+			    READ_ONCE(tier_counter->high))
+		schedule_work(&memcg->high_work);
+}
+
 /**
  * mem_cgroup_replace_folio - Charge a folio's replacement.
  * @old: Currently circulating folio.
@@ -5705,6 +5715,7 @@ void mem_cgroup_replace_folio(struct folio *old, struct folio *new)
 			int slot = nid_tier_slot(folio_nid(new));
 
 			mem_cgroup_charge_tier(memcg, slot, nr_pages);
+			tier_kick_high(memcg, slot);
 		}
 		if (do_memsw_account())
 			page_counter_charge(&memcg->memsw, nr_pages);
@@ -5798,6 +5809,7 @@ void mem_cgroup_migrate(struct folio *old, struct folio *new)
 		if (old_slot != new_slot) {
 			mem_cgroup_uncharge_tier(memcg, old_slot, nr_pages);
 			mem_cgroup_charge_tier(memcg, new_slot, nr_pages);
+			tier_kick_high(memcg, new_slot);
 		}
 		rcu_read_unlock();
 	}
-- 
2.53.0-Meta


