Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A259606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 01:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AZJw7nfE
Received: by kanga.kvack.org (Postfix)
	id 23A3B6B0935; Tue, 27 Oct 2026 21:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2117E6B0936; Tue, 27 Oct 2026 21:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC196B0937; Tue, 27 Oct 2026 21:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF2936B0935
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:06:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48CF2A0BB1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:06:20 +0000 (UTC)
X-FDA: 85370244120.05.FCCD50B
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9485640007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 01:06:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=AZJw7nfE;
	spf=pass (imf07.hostedemail.com: domain of 3iUrhagkKCAIvlogtekgtiqqing.eqonkpwz-oomxcem.qti@flex--tjmercier.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3iUrhagkKCAIvlogtekgtiqqing.eqonkpwz-oomxcem.qti@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793149578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJNW2+65j5NYIKmcFdANCwPbFrFgTfSn4JMq31uqTFY=;
	b=PohcOqIthWhBXBHa2I5jnBnum50XwVp4VWuNFky7QlQSqLsBBqKcPlVZF2PFS20RyBRS0V
	slVDgED4rlatpOnq5AFDkMGHb0ZBx9Gks9FGpbudCijS73OpxfyV7BdhJ4VRKPtFNXRlsa
	vHZ1r6Mc9G/I0IgnW205AUZXvtrQTIk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793149578;
	b=3qKoHJ36w7TO1hP8J57lZnpWjt5Vk8Fd39zV76QXE6gI1KaxpnUMSPPCupe3AguoXTc7iG
	zx6jJVoGIO6WEVC1Qaq2asX4Q48M8dmge4INHBLcqdXNanUiI1Tr3/7pWcnFpqIjf71lR+
	lKswU8iirYqqAKJFZawSJ/192rpxzNA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=AZJw7nfE;
	spf=pass (imf07.hostedemail.com: domain of 3iUrhagkKCAIvlogtekgtiqqing.eqonkpwz-oomxcem.qti@flex--tjmercier.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3iUrhagkKCAIvlogtekgtiqqing.eqonkpwz-oomxcem.qti@flex--tjmercier.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3ab2395f104so373633a91.2
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793149577; x=1793754377; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yJNW2+65j5NYIKmcFdANCwPbFrFgTfSn4JMq31uqTFY=;
        b=AZJw7nfEn2CoMOxELNAnwkI3No2cv8eVOWpCpzvYzVgZqlnrQuApg396t0WvVZrFIL
         ENLhbb3veSVQBAFUVycvo7FYPALrryxw2OCVGVZPmlgyGASQFezOuEU1o2kmOCbDmjb6
         UIWGd1gWW2S9EH4L2/T9O+VsesdLd4uchHnpjVZiP9y3pjupLkZkrfgGf/8x62Lu2E/w
         J5p4fajNSOjz++U+BdzusfJlf9fgsX9nJoG0sUTDZoZlop2AvlLCFq3GlzY4YjKezynd
         ldRE1R5vyhmzP4stokFEkKbEEcv8Zu+B4xafe5lwCknlzggY2NngEc3xFLRbTX/idBVh
         u8mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793149577; x=1793754377;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yJNW2+65j5NYIKmcFdANCwPbFrFgTfSn4JMq31uqTFY=;
        b=ahoFypPXbhBhN1Lmjpxwl+crkbwcp5j2vg8YUB1jGs7QnyswNZYW85gNalNyCOnS1f
         53ZAUNCfdjy7ya4FvS27J/5Z4mojfnCbh3WvaD9ymQQROjNp9Whq4NTqdTheIOwPBTjm
         BUlxcR3Twv0RLvcscSYKjX9fhqUuHKbsXByCOQN/NmYB2fRmZWkzZVD9DeODUGewV7V4
         ShMaG4JBFb6EcjGJMsWcti0KxPre51Gzn6uRM7kjf6+mzGU4ZwC14Pvo9p3nSmQ+DVl5
         kaZps82+vWls1neLLukQnhY31hfR7cahZTW7vgV0CsUaIAUEcQ0KO3AM16eYKg4wLXZx
         18xw==
X-Forwarded-Encrypted: i=1; AKwUvBy2n+oOYd927hFGMjzy5oiq1RUL8hyvslYEH0/KKn/0Guz2HvTv81BfxLA/SPK9wnqqGecyvtRyaQ==@kvack.org
X-Gm-Message-State: AFq9FYJSxRPBSEqVxAoO1ZrwRtyPLB55HGUT9diGvVbEOwWJ8WfOUJSS
	f3y1tg7lIibl9cm2dI0usr18yb7Rkd5C+nT5U9LhAZLNyzuKNFFcq2LKbuGVuVno6LYSo3I7ZzT
	F73nJN3Ki6NWVhQxkHg==
X-Received: from pjbpw4.prod.google.com ([2002:a17:90b:2784:b0:3a9:ccc3:cbae])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:564c:b0:3ac:bc3d:6fe8 with SMTP id 98e67ed59e1d1-3ae58150cf4mr614654a91.34.1793149577155;
 Tue, 27 Oct 2026 18:06:17 -0700 (PDT)
Date: Tue, 27 Oct 2026 18:06:05 -0700
In-Reply-To: <20261028010611.3929937-1-tjmercier@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261028010611.3929937-1-tjmercier@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261028010611.3929937-2-tjmercier@google.com>
Subject: [PATCH 1/2] mm/vmscan: remove redundant !mem_cgroup_online() checks
From: "T.J. Mercier" <tjmercier@google.com>
To: roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, "T.J. Mercier" <tjmercier@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9485640007
X-Stat-Signature: 4epwd5sfbx9nebnjibqroz8owsb9wb8a
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793149578-978713
X-HE-Meta: U2FsdGVkX1+ZKHtgEdcteo/GZaQ97VH1aEhVWoCBmx6dFnKDR0mvB0BYFAQAMYwVqsHCuOfSys8llZp214DRzOl/tDgS2V+tekn4hH/v1iG/I+kg0V70uvdEXq8078OGszjNPm5qmJAunNOMBy2qEQwwCX6dDiwUYv8tgv6XuvLzojchtFiLU7hcctQdqPjTIJUjICGR0dq2jSzpwFPtgme6dRtCr2tbjWVihpgt5cPYck0bke0jwg5VKjL8OekXoaV7vQe223e0/8ZiGdGv8rDV3EDl0DQPTTngYipvGOTvbuzV6nQgBVYgzPPVt6byE9mGMBdTJfJAG3I28e2qHKYiLGRNlzXyQcmJhftSQugt+1NkTisT2fuBy3MgNKRN1LSIgQMxOpbjy4gLjntWj4VQtRbSDktHYGOaLNNhiFhwLfGziGHYUyMNmXkpbkjFTDEAZRrQOmTTibPKY1M1M/3t/2+Pe3xcUJGWX9jfAAaVr9wNXIERAXfRvxSZO1IeM9DVHA5PuYvj0JLk0GzGh3rYTmufdGeFiM7+MFVUwX9SGdkx8NwiegnVMqj2Sr2lVW+7Wx6oi5YazZAh5hKVGQTuCfEYfcu8R1AyILM0kXHG6b8E6LarGmtyuNxdEMdFEcDzc//Zz2vddR7/h1dc7c566Kj5YgxjAirdiruB424kAQ+kR4E4kgIDDPVGwcir0mph0JqaiWApXZqeCBrpZtuzKn8/KwCHJ+l7OuuOLusevQ4O3RlKx5bz8V3BtxCOcasVICcJjN4a9aXGBXp8fsV/xUyqp1DFlm8HvN5gi89okQtNnI8IGB0VRNh7HCM2WFFuZH+2LXH4SnjSGpEbLyYRgggacWp5gFXipr71gzGtvRpE8vFbujqRfNbbST83NTzUKzY18vDc2ZFmqLh9duTceHesZenZAYUCUfO43Z1lVwlMT+TCRDSMlUghh2bB2yClVy3uDya9xwXqdUU
 680mZ6O2
 TtSGEpQsumA3IO5pwab07FOwDh7Gws4PAOR958ruMI//d7hAl7iqpcWWSv+bJR3fWJL3EkkThBMnn/M+ly7qCWKC5NG5OccsvZRr2MqMhvT04WH5hCC9A8UXpfWOc8Be7XlGZ6DGWpRhKdtZ1onpbbR+m4hKQObgfvWjcP93N5hpw7I8T6bEXs27pNAHMOm6Tz/rBlmY+IPzgdt+QCNG4OxhGJfJGO10Qa22U3pPpXZxVk2KAs/AiPKZV32zv9O8rlMvvuZsQBdvmsw6E0wMT6NBkdycch4kudiMH8TEsdVPYo8CfwWdcAsEXQPBgsUPjVtIR1EEEdxI9UDOJFhg2X5LMz2rnZtymvXuHwhyOHSHhNUu8IqSG47ayAS6TNiLkbyfkl7m/Z7iKjYEA3ilUmFfG7nP41+fZaQNhhpotX127sSm8uAg2HMkznq8po/J0mTL0Liv5Ck+1qqGPNXGkYOVC8nTxTejrs0UO2V1tbBi/GoHiNFXOiFDplW8Bk9o/01z3U43Ie0dIBQBWtUmVVcUBBQQZAqfU5T+6sAWKKJSbss/tQPavXeqQPlBBWI0d+MFCpDSJYFELY1ClYIwbyNmOgCBNavlqOKHSM9QtMog3uX72JH+6eBkeEXpuPJnBnnDuMEaOP8m3zlQ90eINtlbel63Blu7aBfaLbeszXyKjm8HJhtlUjh0+9DVMzlZ50aP7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit f1cf8d2f36dc ("mm: memcontrol: eliminate the problem of
dying memory cgroup for LRU folios") and commit 0e0ac326c511 ("memcg:
move LRU size accounting on reparenting instead of copying it"),
mem_cgroup_css_offline() reparents all LRU folios to the parent memcg
and zeroes the child's lrugen->nr_pages and lru_zone_size before the
memcg is offlined. Nothing can repopulate the offlined memcg's lruvec
afterwards. A folio that is off the LRU during reparenting looks up its
lruvec through its objcg, which now points to the parent so it is put
back on the parent's LRU.

As a result, lruvec_lru_size() and lruvec_evictable_size() are always 0
when !mem_cgroup_online(memcg) is true, making the offlined memcg special
cases in get_scan_count(), lruvec_is_sizable(), and shrink_one() dead
code. Remove them.

With the get_nr_to_scan() special case removed, an offlined memcg that
still has stale effective protection now has
apply_proportional_protection() applied like get_scan_count() does, so
the MGLRU and traditional LRU behavior is now the same.

Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 include/linux/mmzone.h |  8 ++++----
 mm/vmscan.c            | 28 +++++-----------------------
 2 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3b96d6c7123b..7f078ff0dd76 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -638,10 +638,10 @@ struct lru_gen_mm_walk {
  * The events that trigger the above operations are:
  * 1. The first attempt to reclaim a memcg below low, which triggers
  *    MEMCG_LRU_TAIL;
- * 2. The first attempt to reclaim a memcg offlined or below reclaimable size
- *    threshold, which triggers MEMCG_LRU_TAIL;
- * 3. The second attempt to reclaim a memcg offlined or below reclaimable size
- *    threshold, which triggers MEMCG_LRU_YOUNG;
+ * 2. The first attempt to reclaim a memcg below reclaimable size threshold,
+ *    which triggers MEMCG_LRU_TAIL;
+ * 3. The second attempt to reclaim a memcg below reclaimable size threshold,
+ *    which triggers MEMCG_LRU_YOUNG;
  * 4. Attempting to reclaim a memcg below min, which triggers MEMCG_LRU_YOUNG;
  * 5. Finishing the aging on the eviction path, which triggers MEMCG_LRU_YOUNG;
  * 6. Offlining a memcg, which triggers MEMCG_LRU_OLD.
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce8..636152d8c94d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2754,13 +2754,6 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 		scan = apply_proportional_protection(memcg, sc, lruvec_size);
 		scan >>= sc->priority;
 
-		/*
-		 * If the cgroup's already been deleted, make sure to
-		 * scrape out the remaining cache.
-		 */
-		if (!scan && !mem_cgroup_online(memcg))
-			scan = min(lruvec_size, SWAP_CLUSTER_MAX);
-
 		switch (scan_balance) {
 		case SCAN_EQUAL:
 			/* Scan lists relative to size */
@@ -2769,14 +2762,8 @@ static void get_scan_count(struct lruvec *lruvec, struct scan_control *sc,
 			/*
 			 * Scan types proportional to swappiness and
 			 * their relative recent reclaim efficiency.
-			 * Make sure we don't miss the last page on
-			 * the offlined memory cgroups because of a
-			 * round-off error.
 			 */
-			scan = mem_cgroup_online(memcg) ?
-			       div64_u64(scan * fraction[file], denominator) :
-			       DIV64_U64_ROUND_UP(scan * fraction[file],
-						  denominator);
+			scan = div64_u64(scan * fraction[file], denominator);
 			break;
 		case SCAN_FILE:
 		case SCAN_ANON:
@@ -4355,12 +4342,11 @@ static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
 {
 	unsigned long total;
 	int swappiness = get_swappiness(lruvec, sc);
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	total = lruvec_evictable_size(lruvec, swappiness);
 
 	/* whether the size is big enough to be helpful */
-	return mem_cgroup_online(memcg) ? (total >> sc->priority) : total;
+	return total >> sc->priority;
 }
 
 static bool lruvec_is_reclaimable(struct lruvec *lruvec, struct scan_control *sc,
@@ -5199,10 +5185,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
 
 	evictable = lruvec_evictable_size(lruvec, swappiness);
 
-	/* try to scrape all its memory if this memcg was deleted */
-	if (!mem_cgroup_online(memcg))
-		return evictable;
-
 	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
 	nr_to_scan >>= sc->priority;
 
@@ -5325,13 +5307,13 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 
 	flush_reclaim_state(sc);
 
-	if (need_rotate && mem_cgroup_online(memcg))
+	if (need_rotate)
 		return MEMCG_LRU_YOUNG;
 
-	if (!need_rotate && lruvec_is_sizable(lruvec, sc))
+	if (lruvec_is_sizable(lruvec, sc))
 		return 0;
 
-	/* one retry if offlined or too small */
+	/* one retry if too small */
 	return READ_ONCE(lruvec->lrugen.seg) != MEMCG_LRU_TAIL ?
 	       MEMCG_LRU_TAIL : MEMCG_LRU_YOUNG;
 }
-- 
2.56.0.307.g5fe7bd680c-goog


