Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E77BFF6E9A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 23:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFA706B00A5; Tue, 17 Mar 2026 19:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62D86B00A7; Tue, 17 Mar 2026 19:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A466B00A8; Tue, 17 Mar 2026 19:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9881F6B00A5
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:07:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B33B140411
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:07:28 +0000 (UTC)
X-FDA: 84557093376.03.9E28243
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id A46ACA0003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:07:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SpcKiP9f;
	spf=pass (imf15.hostedemail.com: domain of 3rd65aQgKCKYHOTMPOGUMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--bingjiao.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3rd65aQgKCKYHOTMPOGUMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773788846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=By9SVSNyV82E5eeo5rQU1kGPzHgbL0ThBDCP4IlBKCg=;
	b=vZmXgZfrMJqlpEBOu972aevF+Fm/G9p8qH6/2qZ99Al/dD7/1NAsm3OG6Jdfks3tLCYfLH
	l+GpBPW4JM3oIyC06UE68+FIH2N8bTrPDaZQyaxR0DmJvl9x/wufNSdb+Bl0dsQoKZty2Y
	LYTDWcSMZlr9xBU4oy027lbAR4ExNUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773788846; a=rsa-sha256;
	cv=none;
	b=C38JlT1O7ZUOiAIh5tedxDwGOWPnEP0UGvPeCEPe4RCDqKU46mGNee57d6SVECaa/RAltX
	YAVz/SDgoD3K6elA5Ybff2scGM1s8qapeptIg/0ckhk6FIr7bsImYE7MGdF2xsnroRi1o6
	mff/cMQDd4/1B/bDCl4BIBOWFDg+c3E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SpcKiP9f;
	spf=pass (imf15.hostedemail.com: domain of 3rd65aQgKCKYHOTMPOGUMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--bingjiao.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3rd65aQgKCKYHOTMPOGUMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aed1beaa73so55436655ad.2
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773788845; x=1774393645; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=By9SVSNyV82E5eeo5rQU1kGPzHgbL0ThBDCP4IlBKCg=;
        b=SpcKiP9fg5F+Q1bzF5nKvVT2DHA309fV+5jBC3xtmkeJ1SaVzDhjlNxZ7wGhFMMtU1
         3NmzvTIar8c28qbTEO+4vX7CySPRqN+B1RkJC4KqQTL6UMMVrIlmOxLgXPqdi0LuhIMP
         UFFOXsG9Xksle8s+ZW4EtHRwIp4V9RP7hrx1Y6SNwp91nS5HkHRx7PUX/hYhN6J/uNHV
         TXH6QqIUOnYLB4yv7gCpay0un9NndhkG0MCx/wClAMcofeoKUl0lAGW2+29rBm6QgurL
         ROw/6ZuAWspdEyLduWvip2XMPeDq1ed8Zqf0jbo5YuEtgI2VhUreY+0Q+H0ZBtDHmy5m
         nqEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773788845; x=1774393645;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=By9SVSNyV82E5eeo5rQU1kGPzHgbL0ThBDCP4IlBKCg=;
        b=UCTwQnrh6F0Jm7cy8Fyce+C5CMA/y1PnhTzP+D2f9fGQjNKz7b133bt0qTR/ConD77
         U9VN2K8LLL0mMGYMFmtkUDs5SYzoBTHsoYn8LGx6jCA7yEoxWgowWh2udybktiGOG2l9
         YeM7BZPOJMvx+b4Dz5yfBYG1/yrhk1Fw64jIl4tzzxq3n61dWzqMbpcrb2TdjYq+l2wF
         ojFoc0R9kFQS6EOcF5n+ymFfckNw7Tl2Wnk4GaTP67MmEhImuPuXfiQYaJfCoSijhqpg
         uPhKGyJFQMBSWmG/YFzw1oDnzCUvFR70l8SKMIlOLgBu6hTdlzi8eKjHRMCqykqzMw27
         0IRA==
X-Gm-Message-State: AOJu0YwiLN2wu8ZiXgtVmuWKyoYmkxHWZPxU0kgDlty4Y6/aVP6CKJNU
	g6p7RPI43mo1NU/Ysmy4YmcKp8Ufnjgebf3ZLjSgs/9fJUsbpE9Kx8FM6AZMJQi74vYhiQV4jcf
	hODtQmgWQQ2jo1sqoPZiuA6lO9U0Ot5QBxSY9ccEqZJ3k8K94oQ5lSd2xfF6h19ZIDf9CdcqTlg
	b+QkD6KbGboXbh9x6/eotY1R5ykzmSo3Cm57k+Dyml2A==
X-Received: from plbli7.prod.google.com ([2002:a17:903:2947:b0:2b0:4e8e:5c09])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f544:b0:2ae:4732:285a with SMTP id d9443c01a7336-2b06e332b4fmr12404475ad.3.1773788845155;
 Tue, 17 Mar 2026 16:07:25 -0700 (PDT)
Date: Tue, 17 Mar 2026 23:07:01 +0000
In-Reply-To: <20260317230720.990329-1-bingjiao@google.com>
Mime-Version: 1.0
References: <20260317230720.990329-1-bingjiao@google.com>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260317230720.990329-3-bingjiao@google.com>
Subject: [PATCH 2/3] mm/memcontrol: disable demotion in memcg direct reclaim
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: Bing Jiao <bingjiao@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A46ACA0003
X-Stat-Signature: dcwf3he1asoudwbx84nd8s8bi466iw4x
X-Rspam-User: 
X-HE-Tag: 1773788846-161363
X-HE-Meta: U2FsdGVkX188chIE1vsSBMljB1SIFLVsWkx7+NWsRuiKfKvo1B623Xpt0HnXhT9AHzH53rLov8nvbu/ZHkqIEIl+pqZMfZDB25xcdsEXOegDES3J1tvC70E/menTyF894FtJ7GWqgO1JdfrgrHO2umiTsNspX/RzqCDVYs4IpRUFGDDUe5Pm/XTFm0yZrnsTTypXLPwDr+XicPvlG00CDrGerLxOlWRfgNkhudFTfR/kPmSUCxbnGU3OSAllQ4Y/T+6qmw09gKqSCQIRCDztJnTNUpvuXmUWz6YEugCDtFsmHfeylxQWD0iSzI1+vrxt2fzC702PXpQOFUC50QxaBssuj9SJIjMIJmrZBcR7QocSBe1xyIsQFv9eycoeaRj0MfquL3y0KAe/hNeFTARfLxHsS1NNNd+2uzvpvIj7S1hyMhc5ss4pperpbviN7C/85h17IMIykmv32XGoZ5y3C2MuDHSp1qC6jcgFLn1p4kxnPjVxF2Welh/v1aTy9p+GWZsnDxKdLJZVabecgcl4ZYHCPAlvKv/shMY+jFfjska4vzp7q26itpxIn7DNaWGPR1fGEf2UX8dAv8js/Kxmyhka1fcD6HJVIwqluahumG/FfZbJrmxc5tSrOfzlKU4WXzYod+V/C0Qvi++6b6jExlUXZI4Ygn+ejK31ODoHxv5pHGtGOyzV71ZDouT8ARH8/QVEpugOPuzhfqfALOKK1RVNyzK4MHgEjunEjmLhOmu5rmr2PV42jCBd0YjrrgGsBWiI7RoqwyeGFmtse617+gIlv9XbXOJ9JZOHyyI72gR0WF0MdEfUlPaExyT02exkbW8VtLT/1iEv2pOq548tq6hEqhr9Bx6XKJxNAphWadOpLoUjIvbE6dj3W+LTI+WGY5jPrtREkNbomODRB9Nrwq5CUmqsSxF+fJqVSxASJcOKoiFj/WRbe6P1KbdTgni/WqlehtiVcAGsWC2/X0C
 LDBjhs+k
 n2ceUJPeK6zdLlr8XI2RyUKnidYbByNgKdTpUcwTaUuc2wAfGjlN6Dm/YMAbuxVd6OjNBMXzfDibJaJzM6ruXzkPDl4O0IL4n74QRTaIR1GjEEmcGKEvzoCWkTHoFV9ibJ5y+JSg5dVocL85NC+hwcgIb5MQrflz7EN7OH6GDsVLkNbt7UsU7U4acT8c8v1M9zIOqxYQMItTd6gRBx+YCIidK2zkfY4KTaaBuTjmxHeZEHe8VJZ8Es9pqWRC+P8vOSDrHmFYf/tItKz7eqaOfFPn6qutdNhKN1lwO1j1g73tMKCBh3NT6qeKxkYKXXUIK3sEuk7I7ccRLJcshxl+UMeQrWflCdKd+ChcQyapHnHtDuFRynPg5mxbNCYOyyTz6MrAdYvnHFw81UHuXim9NNjGq/XeclBK4w5n6T14ZqaY1Sp0IkP5dLxdFLyI58RKYDHAq21NYObucGWLdN89AXypJLXDHvfMUYozgPEoZ9eApRYpJOroZUbkd4XDvodnmKTBA6vSRb4O812fACNhJWcDiEpnRz5skx1bZZf2Myds6jvBqagP644JXms3wyX5AiWNTIlXc7odyLwp3YbqbgKKCAuLUB1g8Z7bbxA9AJ4xNhdctWiQkA5XAkY8IGkiqnkNmllZZp59sEwUBglmBrk8Bed+ZKlGJ+sGptTITjzSvB9W9S2O/eidXJL96KynnoLXCPEuWoVR18vS6JGjL4aCCuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NUMA demotion counts towards reclaim targets in shrink_folio_list(), but
it does not reduce the total memory usage of a memcg. In memcg direct
reclaim paths (e.g., charge-triggered or manual limit writes), where
demotion is allowed, this leads to "fake progress" where the reclaim
loop concludes it has satisfied the memory request without actually
reducing the cgroup's charge.

This could result in inefficient reclaim loops, CPU waste, moving all
pages to far-tier nodes, and potentially premature OOM kills when the
cgroup is under memory pressure but demotion is still possible.

Introduce the MEMCG_RECLAIM_NO_DEMOTION flag to disable demotion in
these memcg-specific reclaim paths. This ensures that reclaim
progress is only counted when memory is actually freed or swapped out.

Signed-off-by: Bing Jiao <bingjiao@google.com>
---
 include/linux/swap.h |  1 +
 mm/memcontrol-v1.c   | 10 ++++++++--
 mm/memcontrol.c      | 16 +++++++++++-----
 mm/vmscan.c          |  1 +
 4 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 7a09df6977a5..e83897a6dc72 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -356,6 +356,7 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone

 #define MEMCG_RECLAIM_MAY_SWAP (1 << 1)
 #define MEMCG_RECLAIM_PROACTIVE (1 << 2)
+#define MEMCG_RECLAIM_NO_DEMOTION (1 << 3)
 #define MIN_SWAPPINESS 0
 #define MAX_SWAPPINESS 200

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 433bba9dfe71..3cb600e28e5b 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1466,6 +1466,10 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 	int ret;
 	bool limits_invariant;
 	struct page_counter *counter = memsw ? &memcg->memsw : &memcg->memory;
+	unsigned int reclaim_options = MEMCG_RECLAIM_NO_DEMOTION;
+
+	if (!memsw)
+		reclaim_options |= MEMCG_RECLAIM_MAY_SWAP;

 	do {
 		if (signal_pending(current)) {
@@ -1500,7 +1504,7 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 		}

 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
+						 reclaim_options, NULL)) {
 			ret = -EBUSY;
 			break;
 		}
@@ -1520,6 +1524,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
 static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 {
 	int nr_retries = MAX_RECLAIM_RETRIES;
+	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
+				       MEMCG_RECLAIM_NO_DEMOTION;

 	/* we call try-to-free pages for make this cgroup empty */
 	lru_add_drain_all();
@@ -1532,7 +1538,7 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
 			return -EINTR;

 		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
-						  MEMCG_RECLAIM_MAY_SWAP, NULL))
+						  reclaim_options, NULL))
 			nr_retries--;
 	}

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 303ac622d22d..fcf1cd0da643 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2287,6 +2287,8 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 				  gfp_t gfp_mask)
 {
 	unsigned long nr_reclaimed = 0;
+	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
+				       MEMCG_RECLAIM_NO_DEMOTION;

 	do {
 		unsigned long pflags;
@@ -2300,7 +2302,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
 		psi_memstall_enter(&pflags);
 		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
 							gfp_mask,
-							MEMCG_RECLAIM_MAY_SWAP,
+							reclaim_options,
 							NULL);
 		psi_memstall_leave(&pflags);
 	} while ((memcg = parent_mem_cgroup(memcg)) &&
@@ -2572,7 +2574,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		/* Avoid the refill and flush of the older stock */
 		batch = nr_pages;

-	reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
+	reclaim_options = MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_NO_DEMOTION;
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
 		if (page_counter_try_charge(&memcg->memory, batch, &counter))
@@ -2610,7 +2612,7 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,

 	psi_memstall_enter(&pflags);
 	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
-						    gfp_mask, reclaim_options, NULL);
+					gfp_mask, reclaim_options, NULL);
 	psi_memstall_leave(&pflags);

 	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
@@ -4638,6 +4640,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
+	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
+				       MEMCG_RECLAIM_NO_DEMOTION;
 	bool drained = false;
 	unsigned long high;
 	int err;
@@ -4669,7 +4673,7 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 		}

 		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
+					GFP_KERNEL, reclaim_options, NULL);

 		if (!reclaimed && !nr_retries--)
 			break;
@@ -4690,6 +4694,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
 	unsigned int nr_reclaims = MAX_RECLAIM_RETRIES;
+	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP |
+				       MEMCG_RECLAIM_NO_DEMOTION;
 	bool drained = false;
 	unsigned long max;
 	int err;
@@ -4721,7 +4727,7 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,

 		if (nr_reclaims) {
 			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
-					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
+					GFP_KERNEL, reclaim_options, NULL))
 				nr_reclaims--;
 			continue;
 		}
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33287ba4a500..7a8617ba1748 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6809,6 +6809,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 		.may_unmap = 1,
 		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
 		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
+		.no_demotion = !!(reclaim_options & MEMCG_RECLAIM_NO_DEMOTION),
 	};
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
--
2.53.0.851.ga537e3e6e9-goog


