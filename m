Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E666BD35697
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 09:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E8BC6B0093; Wed, 28 Jan 2026 04:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B34F6B0095; Wed, 28 Jan 2026 04:30:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CCC76B0096; Wed, 28 Jan 2026 04:30:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA7F6B0093
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 04:30:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E40551A0533
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:52 +0000 (UTC)
X-FDA: 84380853144.20.514BB1D
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id D84C04000D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:30:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lo45FIOZ;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769592650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CkTKKula0DQd5wgE6uWfgSKH0QJhpKGSFifSGYvHSoo=;
	b=0KsP9n4f8yJ2hpuezy4n9itIcTtXTQgy4E6EFy0yYKHzgMwz9jEhzAP5LLx2QBRFzaabz1
	g/81xxIavfN4i40ZBDOXFLIfJr647Ik0DO4AOhDe8uoindse6ukOzldGrTiXNeOL7kA6IZ
	4eXcvdK3aywm929dNOoZe5+Sj5Mcu/Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lo45FIOZ;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769592650; a=rsa-sha256;
	cv=none;
	b=QoZF7Y5vdNSmIQMgNjXg9oOSPs8esT8A5IZkGFE6WuOVjtI5VIkvmv/TZrazZD7U7Fb5+o
	LT6uCba+5z8ysqNZD114CVWYfYs5KboeDX2IfUCE+yDtkijEYgIHI9XdSODZc2dWRgIhH3
	V77XZGVhiwlYxFQUzykqoLMjSYYmYmE=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3540266d356so892909a91.0
        for <linux-mm@kvack.org>; Wed, 28 Jan 2026 01:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769592650; x=1770197450; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CkTKKula0DQd5wgE6uWfgSKH0QJhpKGSFifSGYvHSoo=;
        b=Lo45FIOZDJQLkDaNRr7H5FXe5i+UOaOG8QZ649Wlap7hrDl5fKVR6S41m9pyS5azKy
         STOdNm123c8kyloafSFLS0mx1qYJWH6iigk8tTXNbYi2EAvVrURk7zDhfDLgBp4TVpA3
         lJ8h2J4QDJkNQV7xyYi+IKHZTshybhYzsBxJ+x4y1BusKkCB9cG1Hs7q8/UCB/uJAgL8
         7iigH4eEsBlnKUGhbzBmak8cn+MGhvoGW9E9UVI6/TzDWvco8P9xcFhvpOm8Jl8ZaSDf
         gXX+EAppddrsraDLDHMFOLgG8umTZrOY1cG6mJYsuPDH25t7I+OgLuPpBkjOXc4XGuHq
         jaHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769592650; x=1770197450;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CkTKKula0DQd5wgE6uWfgSKH0QJhpKGSFifSGYvHSoo=;
        b=r6fcSqzEh8MzirN7sXpt3cdLn30jKaMzrtBbR/iWCYgZ6Bgp6yYThjvy5aq86v2Zkv
         i8f8ohdCkQBKPDgoxLY8LfeaMnhy7JqdHtgQFYf+YQZhLRKHGi1T28z99qyJNrkJ+rWp
         BpamGJnA+/YLGIddqGKAqju3+CO93E0ciaTI2HSFWt5JTfHpM0ab4pGoFcnx4xAdRDMD
         IZO+1fVshyLC0wI+PL+l2mqOBUUtF72UkCjxpHhl0y4zMoulXE5H40S30JxejdJrg36o
         D7yU3l5sZxHni4+RMWFt2IdoLO0HDHwQlmCYeFNXGaIp0zRc99AHQVzC9G4nWAM/cp8e
         xz8A==
X-Gm-Message-State: AOJu0Yw7y4jM5BDLuPY7W4CRZkdOx3MXo2ZFD9FmM+BBLKskEoYXx54/
	fcSRmwFwNlqpmfy0D1VX93tFSmmS8aGtqtMNwxoSkYuv/BBdHP1oPqcFlFb2Zuazwmg=
X-Gm-Gg: AZuq6aL16tfeGdhfJN0ASMYaL++EzP8Ti15c3snujlVn+qllQeExXddo7PNVK91nv9K
	xGFf1B2xYoj+0EgOQPEryZETvRVihwQ2hcpQk4wEfGAqN0D715ykM7HGDs1yeZbYdcyLjczS9Zx
	vqsFy45lbkLanMK1wtaPWYsHTpWruW3BM6PslKRXq9kv5wRkjAmfLdKjPZvwavjrIyfglesb0Qi
	qd3D/jVso/BIpc16iyFeb8lkLIKsD96HSkbAiWhT1HLBeVT1OE2zeGobJCHPlUfKVt0TbLpGeS6
	oS6PWyxxy1MPIFSJ/d76StroDZr8IiDDRbC0MSs4e5CyDq7ZolLoCY5SGb1YwWgz1OoO37OyisF
	3ao91O3d5RXhbHy51tvu/j2xUo5rKHkabJ9yyWkt7NyLEY/zjxLZugt2hzzki9xuNUs3RzNqe5t
	YmFrRKiFiwb5aPq4GiQRT/MY42Vbqbz5TnRBqmaRJ6rXK/AXsbxp1RMrFXUA==
X-Received: by 2002:a17:90b:3a08:b0:341:88c1:6a7d with SMTP id 98e67ed59e1d1-353fed8fc85mr4504462a91.18.1769592649720;
        Wed, 28 Jan 2026 01:30:49 -0800 (PST)
Received: from [127.0.0.1] ([43.132.141.21])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3540f3eca6dsm1872235a91.15.2026.01.28.01.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jan 2026 01:30:49 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Jan 2026 17:28:29 +0800
Subject: [PATCH v2 05/12] mm/workingset: leave highest bits empty for anon
 shadow
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260128-swap-table-p3-v2-5-fe0b67ef0215@tencent.com>
References: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
In-Reply-To: <20260128-swap-table-p3-v2-0-fe0b67ef0215@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769592628; l=8883;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=FaLMbQqW7ETAqIJMdO/kAwe98yiKvc5zz/kgiu2u1QQ=;
 b=wcdA5+u19hk2eVOm518EnInTkK1Kz2Uhd2N4ABKu63Gee9CLdcQfxDzjgT60+ZoOXlERb9Eos
 McI0ABQcO7DAEtMZZwcmYmiDO16gZMJ7sitnYARk+mNktRlEbX3JsKa
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Stat-Signature: 6nbfbytmxdwkfm9dypyj8kz6si9ein87
X-Rspamd-Queue-Id: D84C04000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769592650-238708
X-HE-Meta: U2FsdGVkX18S+gVujpvgdC4Qg1FR5qTbUreMzXI+gHpFinrlYzQv0ADclw7W33XcrPHC/uHd3P7nNcIxX+XeQRHbDkldA+X2Y6gjF6qFbyYXn70S8vQOTfB0tH0QwZRfeLmDeEFy2eZfZPa0co82D5nIi6u76nS9FPIzfBkgD6t+bynnOIko8enQfbBBCbIo7X9/QvJLPhuJ82o0+3Zel9Ava553MLrZ/3t6yTxThyoC2++0t1cdquGmZ/yoprJhXVccoWrEAZvL67WR+UH5ApzkKGuRKqyUg0e0FPU+pHAmlpjuhk46gfC/B/iLAXBeSaXhS/JB72/8UL9uBnLI/y5UqFJgA3SQcfgGfvqZOfHNT9RbCvmpbfA5a2mDP+fGgRZK8IQfJNV2FqEaT7QFq56A8nlP82RPrQuRocdek9/zYokoE9wakLnjFn9Fo2xm7jvd7dfq39hHU5D59sjL+2xagZlKMOWOJoflpJo6Gce6NeKi4tsbcg6aD7NhuSc/fmYnq0Q56h/6lS4cizstw/FjIs8Pi+pGUemQMrHbY4gZA9B4RPr9jqj6+DHONmMNefssNbywsxMyonNoY4nIjpzf2P1gX5zoKcfvJyPvoJ59KhNzm3o4gTRkiCGy2/QZFOHU8Yn/vbl+/xu6uK6o2Wp5Q5JgU5J4bDR70tYaFSwbXCN80NEtNm4xPw6U/zesFTGwbYXn99IKYttH85ZqLGgcY9XD3sfheIBpiFvrTDj7czlJJOcXsIJVER5WRwCHKDYk0qOrXrWjoJahCZn3ck7kHKl0c0F8WIwjj+v48P6oZqimb5rruO4GchjTZBsSgywiXrmoR86Fv+Sl8P04fpudCK3W9oJdV4BHqWeg7T4/yB/HcgGUCoaksl1yZZm+wSTdvoDtOSzvWjR7d0SBg3CZvP7WPG4yGw4PFGY+8NxhOgG//esxOLkF7ZZVz7HcNMZo+vuYAw+z1jX6s6T
 D3MH11a0
 My6Vmz4uEZ9fO542daQFm0Gh54C+PeLMey31AeHJqH+l1Uc+5Ep/qf7g/apEDbBmRooatxoyZiYpP2SI/HLRjK/IfeigFGdDlnW55rCfrNPm5iW1f8zFxR3JT+CMFRWXmiH7WvGY834qUTYZ+AYyW7e98hBBa26cjFQG3SF1xETAZlxtUuXjJ/dCNH1SJt1Fw/QWNVP3mQ3XFcMQTrI5Ms1UD82CwJaQI46lIzPiJeHAy8IXZmQnm3CSMzg/yl3X2G0TnzZYjJM/EWYIGGZgCRkjgQ5KJxUnicCTJc8QMqup/KT+I+7BM3IMgcWAvC7GKH6nwO6rmq93TIVoQxmkgAAYGSAGQxao7sNRotwdZlb8r+BUmwxLzGEl7gNL7566my9Z17ILxX3CdGwpY9/ZGSMVvUwNTjsodwsRJINuL4t5iwECUkuIobZ+IkA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap table entry will need 4 bits reserved for swap count in the shadow,
so the anon shadow should have its leading 4 bits remain 0.

This should be OK for the foreseeable future. Take 52 bits of physical
address space as an example: for 4K pages, there would be at most 40
bits for addressable pages. Currently, we have 36 bits available (64 - 1
- 16 - 10 - 1, where XA_VALUE takes 1 bit for marker,
MEM_CGROUP_ID_SHIFT takes 16 bits, NODES_SHIFT takes <=10 bits,
WORKINGSET flags takes 1 bit).

So in the worst case, we previously need to pack the 40 bits of address
in 36 bits fields using a 64K bucket (bucket_order = 4). After this, the
bucket will be increased to 1M. Which should be fine, as on such large
machines, the working set size will be way larger than the bucket size.

And for MGLRU's gen number tracking, it should be even more than enough,
MGLRU's gen number (max_seq) increment is much slower compared to the
eviction counter (nonresident_age).

And after all, either the refault distance or the gen distance is only a
hint that can tolerate inaccuracy just fine.

And the 4 bits can be shrunk to 3, or extended to a higher value if
needed later.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_table.h |  4 ++++
 mm/workingset.c | 49 ++++++++++++++++++++++++++++++-------------------
 2 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/mm/swap_table.h b/mm/swap_table.h
index ea244a57a5b7..10e11d1f3b04 100644
--- a/mm/swap_table.h
+++ b/mm/swap_table.h
@@ -12,6 +12,7 @@ struct swap_table {
 };
 
 #define SWP_TABLE_USE_PAGE (sizeof(struct swap_table) == PAGE_SIZE)
+#define SWP_TB_COUNT_BITS		4
 
 /*
  * A swap table entry represents the status of a swap slot on a swap
@@ -22,6 +23,9 @@ struct swap_table {
  * (shadow), or NULL.
  */
 
+/* Macro for shadow offset calculation */
+#define SWAP_COUNT_SHIFT	SWP_TB_COUNT_BITS
+
 /*
  * Helpers for casting one type of info into a swap table entry.
  */
diff --git a/mm/workingset.c b/mm/workingset.c
index 13422d304715..37a94979900f 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -16,6 +16,7 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 #include <linux/mm.h>
+#include "swap_table.h"
 #include "internal.h"
 
 /*
@@ -184,7 +185,9 @@
 #define EVICTION_SHIFT	((BITS_PER_LONG - BITS_PER_XA_VALUE) +	\
 			 WORKINGSET_SHIFT + NODES_SHIFT + \
 			 MEM_CGROUP_ID_SHIFT)
+#define EVICTION_SHIFT_ANON	(EVICTION_SHIFT + SWAP_COUNT_SHIFT)
 #define EVICTION_MASK	(~0UL >> EVICTION_SHIFT)
+#define EVICTION_MASK_ANON	(~0UL >> EVICTION_SHIFT_ANON)
 
 /*
  * Eviction timestamps need to be able to cover the full range of
@@ -194,12 +197,12 @@
  * that case, we have to sacrifice granularity for distance, and group
  * evictions into coarser buckets by shaving off lower timestamp bits.
  */
-static unsigned int bucket_order __read_mostly;
+static unsigned int bucket_order[ANON_AND_FILE] __read_mostly;
 
 static void *pack_shadow(int memcgid, pg_data_t *pgdat, unsigned long eviction,
-			 bool workingset)
+			 bool workingset, bool file)
 {
-	eviction &= EVICTION_MASK;
+	eviction &= file ? EVICTION_MASK : EVICTION_MASK_ANON;
 	eviction = (eviction << MEM_CGROUP_ID_SHIFT) | memcgid;
 	eviction = (eviction << NODES_SHIFT) | pgdat->node_id;
 	eviction = (eviction << WORKINGSET_SHIFT) | workingset;
@@ -244,7 +247,8 @@ static void *lru_gen_eviction(struct folio *folio)
 	struct mem_cgroup *memcg = folio_memcg(folio);
 	struct pglist_data *pgdat = folio_pgdat(folio);
 
-	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVICTION_SHIFT);
+	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
+		     BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_ANON));
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
@@ -254,7 +258,7 @@ static void *lru_gen_eviction(struct folio *folio)
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
 
-	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset);
+	return pack_shadow(mem_cgroup_private_id(memcg), pgdat, token, workingset, type);
 }
 
 /*
@@ -262,7 +266,7 @@ static void *lru_gen_eviction(struct folio *folio)
  * Fills in @lruvec, @token, @workingset with the values unpacked from shadow.
  */
 static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset)
+				unsigned long *token, bool *workingset, bool file)
 {
 	int memcg_id;
 	unsigned long max_seq;
@@ -275,7 +279,7 @@ static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
 	*lruvec = mem_cgroup_lruvec(memcg, pgdat);
 
 	max_seq = READ_ONCE((*lruvec)->lrugen.max_seq);
-	max_seq &= EVICTION_MASK >> LRU_REFS_WIDTH;
+	max_seq &= (file ? EVICTION_MASK : EVICTION_MASK_ANON) >> LRU_REFS_WIDTH;
 
 	return abs_diff(max_seq, *token >> LRU_REFS_WIDTH) < MAX_NR_GENS;
 }
@@ -293,7 +297,7 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 	rcu_read_lock();
 
-	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset);
+	recent = lru_gen_test_recent(shadow, &lruvec, &token, &workingset, type);
 	if (lruvec != folio_lruvec(folio))
 		goto unlock;
 
@@ -331,7 +335,7 @@ static void *lru_gen_eviction(struct folio *folio)
 }
 
 static bool lru_gen_test_recent(void *shadow, struct lruvec **lruvec,
-				unsigned long *token, bool *workingset)
+				unsigned long *token, bool *workingset, bool file)
 {
 	return false;
 }
@@ -381,6 +385,7 @@ void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_pages)
 void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 {
 	struct pglist_data *pgdat = folio_pgdat(folio);
+	int file = folio_is_file_lru(folio);
 	unsigned long eviction;
 	struct lruvec *lruvec;
 	int memcgid;
@@ -397,10 +402,10 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_private_id(lruvec_memcg(lruvec));
 	eviction = atomic_long_read(&lruvec->nonresident_age);
-	eviction >>= bucket_order;
+	eviction >>= bucket_order[file];
 	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 	return pack_shadow(memcgid, pgdat, eviction,
-				folio_test_workingset(folio));
+			   folio_test_workingset(folio), file);
 }
 
 /**
@@ -431,14 +436,15 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 		bool recent;
 
 		rcu_read_lock();
-		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction, workingset);
+		recent = lru_gen_test_recent(shadow, &eviction_lruvec, &eviction,
+					     workingset, file);
 		rcu_read_unlock();
 		return recent;
 	}
 
 	rcu_read_lock();
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
-	eviction <<= bucket_order;
+	eviction <<= bucket_order[file];
 
 	/*
 	 * Look up the memcg associated with the stored ID. It might
@@ -495,7 +501,8 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 	 * longest time, so the occasional inappropriate activation
 	 * leading to pressure on the active list is not a problem.
 	 */
-	refault_distance = (refault - eviction) & EVICTION_MASK;
+	refault_distance = ((refault - eviction) &
+			    (file ? EVICTION_MASK : EVICTION_MASK_ANON));
 
 	/*
 	 * Compare the distance to the existing workingset size. We
@@ -780,8 +787,8 @@ static struct lock_class_key shadow_nodes_key;
 
 static int __init workingset_init(void)
 {
+	unsigned int timestamp_bits, timestamp_bits_anon;
 	struct shrinker *workingset_shadow_shrinker;
-	unsigned int timestamp_bits;
 	unsigned int max_order;
 	int ret = -ENOMEM;
 
@@ -794,11 +801,15 @@ static int __init workingset_init(void)
 	 * double the initial memory by using totalram_pages as-is.
 	 */
 	timestamp_bits = BITS_PER_LONG - EVICTION_SHIFT;
+	timestamp_bits_anon = BITS_PER_LONG - EVICTION_SHIFT_ANON;
 	max_order = fls_long(totalram_pages() - 1);
-	if (max_order > timestamp_bits)
-		bucket_order = max_order - timestamp_bits;
-	pr_info("workingset: timestamp_bits=%d max_order=%d bucket_order=%u\n",
-	       timestamp_bits, max_order, bucket_order);
+	if (max_order > (BITS_PER_LONG - EVICTION_SHIFT))
+		bucket_order[WORKINGSET_FILE] = max_order - timestamp_bits;
+	if (max_order > timestamp_bits_anon)
+		bucket_order[WORKINGSET_ANON] = max_order - timestamp_bits_anon;
+	pr_info("workingset: timestamp_bits=%d (anon: %d) max_order=%d bucket_order=%u (anon: %d)\n",
+		timestamp_bits, timestamp_bits_anon, max_order,
+		bucket_order[WORKINGSET_FILE], bucket_order[WORKINGSET_ANON]);
 
 	workingset_shadow_shrinker = shrinker_alloc(SHRINKER_NUMA_AWARE |
 						    SHRINKER_MEMCG_AWARE,

-- 
2.52.0


