Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71BB0CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 22:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4C8A6B0007; Mon,  8 Sep 2025 18:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24236B000D; Mon,  8 Sep 2025 18:19:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39E96B000E; Mon,  8 Sep 2025 18:19:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2BE6B0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:19:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4587D1A02D7
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:19:24 +0000 (UTC)
X-FDA: 83867500248.18.96E39FC
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F31714000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 22:19:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PnZ7Pv++;
	spf=pass (imf26.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757369962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nKmTdIpeS7PLxyfeMC8A21vcUc3Lgf8ocBEs9nNb+0=;
	b=vgTRB6tbagVueRJHiP+BlAHh6Do+uQKpIO672auh+j37ohkILe1O2Jov6CM5zyvj0f1xOs
	y2Q/u4SswVcQiJQjX52sYSf+e4pStAYtZbfYxSq/91X59JoXEiZY8EG4GK+Ll6bLmKODEn
	7PcguAUyyLqYx5RFEV5iA1dEQFt3S84=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PnZ7Pv++;
	spf=pass (imf26.hostedemail.com: domain of hughd@google.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757369962; a=rsa-sha256;
	cv=none;
	b=I4U+HXejhRvCTIFw29vdnJRbwva5GawtjmZdz/F5+HVWwXI4pY5wjSxuBobc15rv6qyIR+
	hVCioHZ+/fSTiUkZchvtZlYaoDiFvQdGkZvC970zexumSvfw8pRJWPG4uHfsUonBIkbUgl
	WMmQFAt0QMGNvVEEXxXNIvJU4ha/AY8=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-723ad237d1eso44578797b3.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 15:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757369961; x=1757974761; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0nKmTdIpeS7PLxyfeMC8A21vcUc3Lgf8ocBEs9nNb+0=;
        b=PnZ7Pv++wQfWvNZrU3aDn9awbXQJ+aRaOt29jERzVzFSHKvOSzrqd06UnXXG5AI9Uu
         Dxe1UQ8DnqKZ62W+skcG7zj24051/36SaG1Wy5urITFpHZHwI01P3MGdJZQmmhb9xcq1
         4HBb1lee/+508U+qvUiH/W0Wol3XAnmDjihoDMJVKSAR69X2IkWhtOtYQVxTN5Eg+R1q
         1fDbUmmdCKbrbUnSkEX9ErYygKsBztr+snkLLJltvPL+//lTbBG74DkC/MRa5MbHfDp8
         It27+YY7p8EqVEVOJFbUTAEnl7az1k3yQXDBOj7Kc+KKGwJL+Xk1T5jeF6WSDHRsnp/V
         ivhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757369961; x=1757974761;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0nKmTdIpeS7PLxyfeMC8A21vcUc3Lgf8ocBEs9nNb+0=;
        b=A4qzfq4A3SDX4yzHu4WW70ERQ/73ZpDzkUr8mP19UyKA5VbgJuaxtmSXHNS7fFgX7F
         ZWvsjhvKNKb9Qz2vMPruVoxoX70pbD9AZNW8nVQWIOdsaHrgLlSw96Hpa6gXQiz7FHQw
         LWSApRY2wq2rWwzuCC61XuTEDCr5hopGmnMDaDuv5AnFU/wIQ9por4SEKtCkK+FYjC7v
         raOuwXlX3xsDPDRrxQ/OeqbHdFt7ZwrFHfUOqju3BOxTKlolLjHog/HObCynA1EU1S4X
         wZ6v4HhL/0GCtnrssMuEgji/RlCa3Jz7mqiEpEgGr2yRMjd8q9K+j0nj7SlIYcEayIZZ
         wVaw==
X-Forwarded-Encrypted: i=1; AJvYcCU7Hu35FY5L+aRBlsUS6avYmOd9F9rIf5dqygLsW++AQI6kB8kcnIsSvrne5Ctf3+Pvm5sGR39h+w==@kvack.org
X-Gm-Message-State: AOJu0Yw6iXlHLyy7jR2EqpeNKGg3JYcaUz1o4SRt8LHJs5/U2dxIi0Az
	Po2J37r4qSa3j1H+BfNS6SuOB+jYaZ6A0piOkozwaEkNTgogX82jQKEMLMgEiw4GrA==
X-Gm-Gg: ASbGncupm5aCSQW1BWFVx31VsohaG6MIJQ9aoML8SGoIujZ3CUZzv8f16otLjE3jLjj
	nHLNqii0gQOF/kiRsm+9AoPYzVxecan7SEkfGgR0tTJsPC4/hoU9WuDj4ryuKMUBuP/Cp0Ve2vY
	xNuuyL79BtSZuyhOU+A+R1ISUvOBkXMBBaW+YgxUCULYg7ZWR/E9JaPdC7/6jDCld3yp156mN6v
	WeNS5sDkQtgPmbGRqLJmB6kWtPsMtj7xISRheM0F4g5Zh1W+msJjlXGQlXLUFGHItpejQ+J0FYc
	pw+BGFPZIkVeN2b/wwIif2awhS2a/Ob5faF0fUjQdzQygsMCKmBzTW/Jktq4Gmxan6sYkle9NGC
	vRk/eEJWUvi+HLLHFb+eHFZQIsG5T+p2RsbwfzrqkcVt3bpBFBiSvNn1rjJpPe+PmDHU8UbHasi
	r68sSNuH7u/13dZQ==
X-Google-Smtp-Source: AGHT+IFqQlqmrOh/oql4z+l2T+HqRRernXj//jbExJMrmWbstfFIE+mLXYbw9wt3KjgX0uSjw8WSMQ==
X-Received: by 2002:a05:690c:620d:b0:724:a06b:cafe with SMTP id 00721157ae682-727f388271emr94315057b3.24.1757369961162;
        Mon, 08 Sep 2025 15:19:21 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a850287fsm56874777b3.47.2025.09.08.15.19.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 15:19:20 -0700 (PDT)
Date: Mon, 8 Sep 2025 15:19:17 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Alexander Krabler <Alexander.Krabler@kuka.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Axel Rasmussen <axelrasmussen@google.com>, Chris Li <chrisl@kernel.org>, 
    Christoph Hellwig <hch@infradead.org>, 
    David Hildenbrand <david@redhat.com>, Frederick Mayle <fmayle@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, Johannes Weiner <hannes@cmpxchg.org>, 
    John Hubbard <jhubbard@nvidia.com>, Keir Fraser <keirf@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>, 
    Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>, 
    Will Deacon <will@kernel.org>, yangge <yangge1116@126.com>, 
    Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 3/6] mm: Revert "mm/gup: clear the LRU flag of a page
 before adding to LRU batch"
In-Reply-To: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
Message-ID: <05905d7b-ed14-68b1-79d8-bdec30367eba@google.com>
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 6F31714000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: cw4yuuhwe8pr3s4q6piugdbe9y3g4ok7
X-HE-Tag: 1757369962-459889
X-HE-Meta: U2FsdGVkX1/9NBe9YaMGB3oSmv3l4OGDLjoKeGg8d3OPPLAUcllaXPEGmyHC2cwaYEhJ/GYjw5oS2ZKFqW4CWeT6oGLyaDRpFEwyGj77cISGbAloFNYl2nJ+iYvKRheScNP2/WSHXO+Eg2b8h6O1WCtylndAZ8cdkVc606UPGLFhIXlJgRdaBAZnqVBwMOKnNeueB41IdE/F1RYQG2F9bIPrqQ9QxRv374l5AIR2m62I6RZDl3SAOmgDehcyQDwLzK/HAMzm5EthgQeKqEo8B2CajZmy4XT/v1sG96cfedeFaz6gNkUVx8YZJMsN/Zc5wCHIg44fxEcYi9uaQEzRel7NlLzuW9EHJ1l7GExqZuTS4HBNbW++WnYUIk+EFA5udsehhXjNXYescUf1wKEKRbO5wLemlI0x+w7V72bq/frsY1wBJOz0BQ4fvns+usPnoGeQJ4uPt3JpZndnTqilnG73E+QiYHMvQnKXi4iQ+WAT/IzDLSgjWzCKqDl58CbhPb5b3FGHiIBmMdP53BM/llMzHhv9zvVFeOGap3UcnOMVJjKhIrXwXfbBxbyBwgEr5A5T7wAq2zz5geSRiYRqwE3iogoc9iefKvzuivtcikeibocpWT8cBVa1KIUyWYHf+m9GvVMjy1uJIGw6I7ims8b/qkytZ4SF2z9G4pCctPaHpeYsfP6apUEClfbRYcSYf5hAT3r8A2HvWHbA9np2HAjBqxdXk3dJepFVL3v8JzRRyKANTRwx7vwVuiaK/2KiBsWDIuXcMHrtCTU4Z6y0RHmyZsXGZ9Gzz+wTNCVYcwgllZUV/hn92ne//Qs8h45ewy895KEw+ibYf7atJHGdO/W4aOTcdE2CT3VE0r+wSzJ43GPlbSK4BKMxzSoLQ/36l8XU+ZySt1Z/kKvdaN0VlYOTV/+gbM/g3tm1m4EkN0/ZqMqljK5qBh7bQ/GjDevfGszO4ov91oFpBH1Rv8d
 0LW4R/pe
 TeD8IfDvRGUe/iO1uICGcIH9tL4Ikni409tBDelzQjUHscizejCPNN96IK4RNxwcVAHK9om6u5kOR1m7McLxv9T/7oZvf6VZT6vscEPwmYJsNhk7RwDc6a0asfJyUJSadFCrozPDhZ6Zd2aVYg44px0tFMC0TfwyBoLOLJxiI1hSLsqR5GVKHJo+ldYKKRia6RTdy1h4JIZrGy/y+FKa+A+WtBVOJZQrlemxZY/L9oAX/rUkUrqms03mOmixbNAv11epg0/SvxfLqnx0t4Im391Bu6g45WzO09gWlWR39fT/M4adDiCGQ417JSECX9GYHP4O0AssSJ+fczVZX7Fcu/BB2eKXI1VXpIg0XWKtXpuv0/2QqLtqud0G5YmWK5GKKo3nKLr9CaNcX3I2DEuLrRPaIxb7rTJn+pFIZG0i/suP4VpX2LGvjT96oMjdCLPbHVun4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit 33dfe9204f29b415bbc0abb1a50642d1ba94f5e9:
now that collect_longterm_unpinnable_folios() is checking ref_count
instead of lru, and mlock/munlock do not participate in the revised
LRU flag clearing, those changes are misleading, and enlarge the
window during which mlock/munlock may miss an mlock_count update.

It is possible (I'd hesitate to claim probable) that the greater
likelihood of missed mlock_count updates would explain the "Realtime
threads delayed due to kcompactd0" observed on 6.12 in the Link below.
If that is the case, this reversion will help; but a complete solution
needs also a further patch, beyond the scope of this series.

Included some 80-column cleanup around folio_batch_add_and_move().

The role of folio_test_clear_lru() (before taking per-memcg lru_lock)
is questionable since 6.13 removed mem_cgroup_move_account() etc; but
perhaps there are still some races which need it - not examined here.

Link: https://lore.kernel.org/linux-mm/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
---
 mm/swap.c | 50 ++++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 24 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 3632dd061beb..6ae2d5680574 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -164,6 +164,10 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 	for (i = 0; i < folio_batch_count(fbatch); i++) {
 		struct folio *folio = fbatch->folios[i];
 
+		/* block memcg migration while the folio moves between lru */
+		if (move_fn != lru_add && !folio_test_clear_lru(folio))
+			continue;
+
 		folio_lruvec_relock_irqsave(folio, &lruvec, &flags);
 		move_fn(lruvec, folio);
 
@@ -176,14 +180,10 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 }
 
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
-		struct folio *folio, move_fn_t move_fn,
-		bool on_lru, bool disable_irq)
+		struct folio *folio, move_fn_t move_fn, bool disable_irq)
 {
 	unsigned long flags;
 
-	if (on_lru && !folio_test_clear_lru(folio))
-		return;
-
 	folio_get(folio);
 
 	if (disable_irq)
@@ -191,8 +191,8 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 	else
 		local_lock(&cpu_fbatches.lock);
 
-	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) || folio_test_large(folio) ||
-	    lru_cache_disabled())
+	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
+			folio_test_large(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
@@ -201,13 +201,13 @@ static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		local_unlock(&cpu_fbatches.lock);
 }
 
-#define folio_batch_add_and_move(folio, op, on_lru)						\
-	__folio_batch_add_and_move(								\
-		&cpu_fbatches.op,								\
-		folio,										\
-		op,										\
-		on_lru,										\
-		offsetof(struct cpu_fbatches, op) >= offsetof(struct cpu_fbatches, lock_irq)	\
+#define folio_batch_add_and_move(folio, op)		\
+	__folio_batch_add_and_move(			\
+		&cpu_fbatches.op,			\
+		folio,					\
+		op,					\
+		offsetof(struct cpu_fbatches, op) >=	\
+		offsetof(struct cpu_fbatches, lock_irq)	\
 	)
 
 static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
@@ -231,10 +231,10 @@ static void lru_move_tail(struct lruvec *lruvec, struct folio *folio)
 void folio_rotate_reclaimable(struct folio *folio)
 {
 	if (folio_test_locked(folio) || folio_test_dirty(folio) ||
-	    folio_test_unevictable(folio))
+	    folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_move_tail, true);
+	folio_batch_add_and_move(folio, lru_move_tail);
 }
 
 void lru_note_cost_unlock_irq(struct lruvec *lruvec, bool file,
@@ -328,10 +328,11 @@ static void folio_activate_drain(int cpu)
 
 void folio_activate(struct folio *folio)
 {
-	if (folio_test_active(folio) || folio_test_unevictable(folio))
+	if (folio_test_active(folio) || folio_test_unevictable(folio) ||
+	    !folio_test_lru(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_activate, true);
+	folio_batch_add_and_move(folio, lru_activate);
 }
 
 #else
@@ -507,7 +508,7 @@ void folio_add_lru(struct folio *folio)
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
 		folio_set_active(folio);
 
-	folio_batch_add_and_move(folio, lru_add, false);
+	folio_batch_add_and_move(folio, lru_add);
 }
 EXPORT_SYMBOL(folio_add_lru);
 
@@ -685,13 +686,13 @@ void lru_add_drain_cpu(int cpu)
 void deactivate_file_folio(struct folio *folio)
 {
 	/* Deactivating an unevictable folio will not accelerate reclaim */
-	if (folio_test_unevictable(folio))
+	if (folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
 	if (lru_gen_enabled() && lru_gen_clear_refs(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_deactivate_file, true);
+	folio_batch_add_and_move(folio, lru_deactivate_file);
 }
 
 /*
@@ -704,13 +705,13 @@ void deactivate_file_folio(struct folio *folio)
  */
 void folio_deactivate(struct folio *folio)
 {
-	if (folio_test_unevictable(folio))
+	if (folio_test_unevictable(folio) || !folio_test_lru(folio))
 		return;
 
 	if (lru_gen_enabled() ? lru_gen_clear_refs(folio) : !folio_test_active(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_deactivate, true);
+	folio_batch_add_and_move(folio, lru_deactivate);
 }
 
 /**
@@ -723,10 +724,11 @@ void folio_deactivate(struct folio *folio)
 void folio_mark_lazyfree(struct folio *folio)
 {
 	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
+	    !folio_test_lru(folio) ||
 	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
 		return;
 
-	folio_batch_add_and_move(folio, lru_lazyfree, true);
+	folio_batch_add_and_move(folio, lru_lazyfree);
 }
 
 void lru_add_drain(void)
-- 
2.51.0


