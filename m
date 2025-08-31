Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BAD1CA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5E206B0012; Sun, 31 Aug 2025 05:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E7E6B0022; Sun, 31 Aug 2025 05:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6C96B0023; Sun, 31 Aug 2025 05:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91DE56B0012
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:11:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 537998524A
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:11:42 +0000 (UTC)
X-FDA: 83836484844.22.B7DE081
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 829BAC0004
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:11:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WDwT6k7M;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.219.182 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756631500; a=rsa-sha256;
	cv=none;
	b=LzflnhziNlUSU2vbdvZLGckAOzs7duk79rJWS/bJfnrLt1V4lzOTm8YhvAH4ifOljgRdsa
	0oBqvGpjfp+TwafU7/vj503o/hJcg7oK02ZBns2+GjVH9SjGTiBso6R40khTuxZ6YtK2+A
	4KPoFlqEGMU9+/2mWvb8cS1NVGxTb3E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WDwT6k7M;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of hughd@google.com designates 209.85.219.182 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756631500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/75wRAcyAz/pvibic7S8snC2YyoDmLe6V6AOatHHWEE=;
	b=fKjx1d7xvi5tKifLGnaRgjns3nmiKrvRfc0674KGJLR/ZrNU3GfqV9/byjOK7ap3M3Dd8i
	89uKSVICOS5iw9dUXIwHOA3lzYtnCf3W/r8iVvdXR4Jul+w7tDUNUzybvrzBNmrwLOn+/1
	1m+oTP8gyuow8L3aovEWsZbMUOPpe+Y=
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e96c48e7101so2999537276.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756631499; x=1757236299; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/75wRAcyAz/pvibic7S8snC2YyoDmLe6V6AOatHHWEE=;
        b=WDwT6k7MxNVqNoPnXeXZ7CAMSW1ZL9qe2WogLaVXT1W24D8A9JZEZL1Srr5YYlNsUO
         NooxK8thLRl1pHEK0GIpvsqmvNEJTjVw3hGlQUQuWgCIVjpqHQbLsiMDlcqq3kNxL7EI
         nBHFrRtTG/+6yvzhCyEW25g3hUVLJ3A0XNiwlaP7GS1lMU9iVzKcH5iBh/fBlpypQfOd
         DZ6v+8KVj4qNVwR9ZbFeakRTyyvXplSE0qWkZSHLSzhsBHJ6fowRIq7LPTDj3La7YXgD
         4KPzYbAg54LeCDuqsWCAUyeWUSE5fi5ihvjWq+Q9PiENfxWo/29DplZEwIMv3GUbFfzq
         rXfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756631499; x=1757236299;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/75wRAcyAz/pvibic7S8snC2YyoDmLe6V6AOatHHWEE=;
        b=JQA4cquDsdJb2Rr/LprMp03bByFSY5JpS9TFuNE6i2KHD/DxA16M7r2J0pLLjf9wZ+
         bHVN0rVgsZSkZkV++Np1ZKWas7Mualz+P3nmc5hJ//8X+q4vm4so3Bc6XnEzcQj2/ZpV
         E+uxXvmSXs1DgEpZXh10i7FuQGIbnt0mn73dVUCBGwiRDaVYB1aZWV79VYrOLtBO16Vk
         Cy8av27o1hoRhSPK9wpNhxrCGYUiYyXI1Y2wjJ47MGwF9o0y6mFNht6wD+sI4m1/JHQv
         YZoe3CI1htwaBJIc244CpTRpqc29dJdE8kcT+A2QxJSct2UId0c0dWK01aPynWcuHfAj
         bASQ==
X-Forwarded-Encrypted: i=1; AJvYcCVmZiGCVokaqNt+V35YGB+frKmBlZGtUFhpK6Sv5fB+SfO8Qz2ZHRPgpqyee7eCTQ+5mXhUnau5fQ==@kvack.org
X-Gm-Message-State: AOJu0YwtVwYCCFf6w6ydklygvhUyFzTyhVQjxjcFqdaSd7dcoyL4Tc0k
	QY3eG0XiPjD6BhR2J1/t35XIEFYbdt0YN/JyDQexrPMrlsEvUhGgYQ7Zr+ZccqOTeQ==
X-Gm-Gg: ASbGncv6dmPefnYWz3EsV+pDOfrSo+BCthClZcFKxNxUUANFNVDWtQJVinEdl5nBdIs
	pM9gfnWXZ15GO5jzIBI5O8ZrwKfCvm1wYIO0nCU1+G++Q1Fywb4ry8UjBziVlHMFdoz3u7KgnVo
	48ahJBG4E7cotzRbEAp4oq7UqqlIxaYqylCIca+6SaSEEsAqtK8Gz5kn7Vl/lra5lMC0v68wkMf
	7VelMXRj6xGj+7bcJz25Sv9MB1yEjrt6VAb/UB+iEYwf754lak/a0MMjMkgeP/9+Opyt7bIsU+w
	XCptU5V0Dt7bsYzYEq/ee7Sp43xIdPbgLCMlGH6sP8fa6/iU5vKx+/Fzjw5Huu6u3LoQxGLNJ5T
	RycRiCP5YpL1UCnyOqRk99z+Lo2/Q845bUyToCDJtbsx3JYjmRwMmghcg2ja9lAHABqOE4P/94B
	/DH9XnWYB+vtMJ9vlYnh1XDWZt
X-Google-Smtp-Source: AGHT+IGLKGhwhu8szWt1srW9NOv/rN3Wnl8fJgvJJ/o/OhNDl3cOqhK0q/ihGoG3VMxSEEyhguVe3A==
X-Received: by 2002:a05:6902:4387:b0:e97:fef:d53e with SMTP id 3f1490d57ef6-e98a5787930mr3875920276.17.1756631499134;
        Sun, 31 Aug 2025 02:11:39 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e98ac580f35sm988530276.27.2025.08.31.02.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:11:36 -0700 (PDT)
Date: Sun, 31 Aug 2025 02:11:33 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Will Deacon <will@kernel.org>, David Hildenbrand <david@redhat.com>, 
    Shivank Garg <shivankg@amd.com>, Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: [PATCH 4/7] mm: Revert "mm/gup: clear the LRU flag of a page before
 adding to LRU batch"
In-Reply-To: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
Message-ID: <0215a42b-99cd-612a-95f7-56f8251d99ef@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 829BAC0004
X-Stat-Signature: 4ybbaknh6x8xwqa6f9pp9a4s8oquk8ai
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756631500-833044
X-HE-Meta: U2FsdGVkX1+w9KrRMIrRTCX6vb3yaccp18dLpL4Svn2oTGJInMcVpAg4xCs4OKauQscopZUgWL/ATu6isY0EYBfo1G9hReSbhMB/rBv2hS1iQ18X2zvLSNXJxFeyxAj65lx/D0yr/N3Mc3+5YBQoH9eiFmd+Hoy0O+38RMH9il/TwsA66ieptlcusGKQXFDlccNDr1bvxrJ5mZ+gMaNj6KPtqhayh7Ks0koQcixDtOszsDyb2qmnfoIYM2edWrw2X0no41PWO2tL7w1kHQKHgd9QUzYW5QB6+db+4ei3Kh/ZJq3eSG4ngKq+MwbSAbDa2TOwvCHMR2MI9DFsDIGakCwoiBZgSpNJzyO1bLV2mnKEQCZp5G7x3mAK4W4dAL2B4i5tZz53gAWRxks/OwgHblElOgz9USiIUmxaRZQsAR3isbgFRKgztFX7OiB9htXV6rMDKaEXWX7/4Od09gsgOU9GrpeMFVF+SBUpnqD5s88qRNu4BweGuXRLTofqWGYYyhGTxA+R3u2of6ZV2WwUnVTfwUlFyK9gINR9vulhhHg1K+y60fh0EozUhDyBwFjm4Y/SntVJz9zmys1wVBIcOz+gzWxsri2qYA4U0+bLlL7mco6RNgUUrGR3WlQs2gTpyLnnR/+XAD9+Ok1nHq6QBxqyW2ro3gZb6zjzKp2Z1T/v4afZxLxYImylwyn252L0rzdD+7gRVh1iRUgQ+Wn2RIsmg8HVkT2hSqgOMkkJMKgwMpS5kBZ5FI9kpz6Yu2wtHhYfXyZrAMGnmqsFU2GvHachChzGA18s3oYjee7r/IMdjjLOgdcoZBOXMMsd6eV2WeH+/HMWQWtKz9f3Ed4uDxeyBwDxcTfnf+duUZ9yFwz6kpx6TCS3oPYYLGAazEG2qFG/+/VlzJwR2pewtDKIcv4CFd9fN6lhPiC8cRnz8QHobHgFTLxBZ/3IMzSBZrtY8nAzpLF10oOR8F5tEXm
 jMfEz2UY
 TULhJbrzLHVR1mLeKMpoy9r1+HYf9Z5NBb2zKJnOrwxAepwcsd5PPjLuHvSAdxRndj0Jq/PR8omphJkZOdBMuM4TYO5c6zgyZrNHp1i9kDpS9aeNRHGqSK2zkB97HKJy/6eArnpbOvLvzx+qvh5TDk5zQ8kros/CL3rJ94jkd8/lDs1M76h7nviemVRGgxnJ2Ej3RMxI08vNa/gwG/1sqhvipj9xvZEe400ssRSsTapFKCxth0yARTW/+k9Wa9AZDS4TJ0rcshSabILWlSpGjdefUX8EakaXDifOpqgJm/D1ldfDtIcgedFIe/5qA7zqhr7/TjARBBYCAzqEULL74Sn22TOMcXUBUBbG1iohF1W6p3DgqIg4xiTpKa3rGEytcTTzYoLkGIrqBxIrKIeOfSj+yI6JAnMl+eAuvVDs8Sv0BDU3XstsgVq9ArFz12N/OiTK7fdKj73yJBQ2S/lPMb0Detg==
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


