Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B3A6606A338
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pqHs8TES
Received: by kanga.kvack.org (Postfix)
	id AC3836B05E3; Fri, 13 Nov 2026 14:50:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A748A6B05E4; Fri, 13 Nov 2026 14:50:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93EC46B05E5; Fri, 13 Nov 2026 14:50:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69C946B05E3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:50:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60162A791B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:50:15 +0000 (UTC)
X-FDA: 85431137190.24.0D595B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8451140006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:50:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pqHs8TES;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794599413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=icSSFy6GjaSbuEQ4ljb9qXuvnPWw3H9lXh4lbn2mdRs=;
	b=pkYO+Yy6x0lc5QKWirV21VFY4S8Ghivzazy4N0wTXs5NvnV++bJvxsJj4xC6XBzosD6VDn
	GooBms8j0GEgz2thu/ncunhzMMiOghZnnE2zOoTMRaW6Z7LI1atW4x0zDZhhqnl1dtWpBb
	13K4CkelsrWQ0C1olnEE4IIwsNuUQ9M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794599413;
	b=qgcNm4qX/B9GR41sa1PL1D4kO1wWoeVjoKYlqCD3cRwJA0uHqeVK3zDP6EPGWtoqfm97UU
	4hX5noUu0dEDrfKee6zirmDKyG7SUSZlQaWdGX/2Qm3mNz8Kz85vUAwfDmorTOU0BX75sR
	tGM5XI30VtoVwfklzE/tYMCQb2RgMP0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pqHs8TES;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68B91422B7;
	Fri, 13 Nov 2026 19:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820301F000C4;
	Fri, 13 Nov 2026 19:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794599412;
	bh=icSSFy6GjaSbuEQ4ljb9qXuvnPWw3H9lXh4lbn2mdRs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=pqHs8TESSdCkgZCf632amqMara786CCSSZNFMUL2TR9gYOwnTgEW0tzMZpiQvlpEq
	 W4VZT81obVTgxzwhf+4pFBJKGq355mRZ7i41mDGv3pFjJBAX7kAb+g1W9wdSeT0HIm
	 tdJz1J7236QoUVbKn0ehPDa5mltdmB8w//C/4g/w=
Date: Fri, 13 Nov 2026 11:50:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: linux-mm@kvack.org, axelrasmussen@google.com,
 baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org,
 hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com,
 liam@infradead.org, lianux.mm@gmail.com, linux-kernel@vger.kernel.org,
 liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org,
 mhocko@suse.com, qi.zheng@linux.dev, ridong.chen@linux.dev,
 rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, wangzicheng@honor.com, weixugc@google.com,
 yuanchu@google.com, zhangbo56@xiaomi.com, zhuhui@kylinos.cn,
 sidchintamaneni@gmail.com
Subject: Re: [PATCH v8 00/16] mm: mglru: fix swappiness behavior
Message-Id: <20261113115011.f90e267d58a9a88c513ae325@linux-foundation.org>
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c3oj6np4toeopho593q46c9tph7ne7ni
X-Rspam-User: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8451140006
X-HE-Tag: 1794599413-417912
X-HE-Meta: U2FsdGVkX19bDo1WipHoB88iTpnE7kzmmAv12ih3yK1zZSqNH2ynJ1v/EDndbT5Smsx1qK5ayjcI/LR+ucOen/+FWbY81jpE3iesTq9binY+Zl++UCSVPY1c2hMK97gp5YR9PG8zjD+Tf7gMj6AFOF0M0PfFr9AGY1RykT/drL7PQs00+EYe/4DbWnyhMZ7fVY21+52KZzUic0GwMsYZyZcZHwoV9D1O0eWs6YWkJH12WLYYqkgbF1WzyKee1+wfdzmvgpR31n1NFjogc/oja3US2YoaeBO7PvWx4ofcI6WZu1MxdW2RxgFxRT8PctUovoNheQgT4hrfArMNBJif+PcAKz0obH0Kch5/i9R7w3Inl+gr/36qhh47L0F7igMxOSDxQ7Uhr6O5SbHmJE/0zsIPc4gZ+MPTHGNJn1INJom5yq3Vyv4MISTk2jIyjOdBPpR4ek2aRp0P0icp4H8WBL+78LhfwbJkLxRV4uxboZScTS04klr2e2jnCe2ke31LRq/FGRv8WSyLvxhebiHjPxREkz0PtX7NrSV6Bm2IYXm0A7S/gJg2WhMos1iBXRi/oAiRZW09Wst7TjDFFxJWU1DjP9T7tCvI5MoSJuX6j/qkdfbothhcU3LPb9c4BO37+rnH611MTBqwR45ZMjd7NCiPhaV8yuyo3DVmx25yUZc1LHrf5sDPygTYf1EvqG3hntfTWsoXErowgMbBCDdvn8BGCE4HjT6gtXxzuLgkRWdjPwObZxOjBB551UkqCx4jVUB/IG4WHSJyGFmW8LZ+Ijouj+8Y942GtVza9uzF4GeechqmPuJ51qPJfKsJZDXXYVoON/ZmGoSMx5UWX2EMvivK8fDWu6KEaWUXjNSO0CaMCOdz1Olp5D08zwwL/e+JooAxXndZiFyeo6fqkFrEcM4WTLeJzy81SwQurjapbunuKMUEi3xyHoXKRlYB5AEaxifDY7VtPY6SEzIuKzM
 nbC+sB6I
 i3XVC3Mtrc4j7Ih6KD7Sfk0UuqE4dNHF+6vSZiz7+KxoKFOucRyDAFcEcfcpIhVtO04I8YTGf3orccYqvTxUvOsiq+/hxv/xwRRltx1Hpt8MN0qn6bSwfqHQn+hNuVbZ2yy5wI9dpJgk5Bcgu6Jy9MufwO/cCxmlRcjvcNLPk4D3Xn6rNKyDxpcjGtzg7R7zJfKn3DrHc7HN82yQ6P2BXPNRBH+Dwbjf7PPqswzuMlcjoRUWCz8Ctlw4SGXNgo0b3kbp9PO3AyhtlvZDPfvvuRKDrIlL2I4IOPdmvoZvVOOmy/8wturXD7iDfFIdqonUtQaim9DnGAhsuR262OK9MoGeBVe/mk7ehMAdn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 14 Nov 2026 02:55:25 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> Classic LRU respects swappiness, while MGLRU only weakly
> honors it when selecting the scan type. The fallback logic
> can easily override the bias established by
> get_type_to_scan(). As a result, swappiness has a much
> smaller overall impact when changing from 1 to 200, as
> shown by the data presented later in this cover letter.
> 
> In this patchset, patches 1-8 from Kairui introduce a model that uses
> refaults to determine nr_to_scan[] for both file and anon in MGLRU.
> For each reclaim operation, we calculate how many file and anon
> folios to scan, similar to CLRU, rather than relying on
> get_type_to_scan() and fallback mechanisms to decide what to
> reclaim, which have proven rather unreliable in honoring swappiness.
> This model also allows scanning and reclaiming from the two youngest
> generations, including the youngest generation itself. This can help
> resolve OOM situations[1] and reduce the need for aging.
> 
> ...
>

Thanks, I've updated mm.git's mm-new branch to this version.  I expect
I'll advance the series into mm-unstable (hence linux-next) over the
weekend.

> v8:
> * Fixed Gaofei Lyu's name;
> * for debugfs proactive reclaim, use DEF_PRIORITY;
> * refine no-populatable aging (limit frequency, allow an aging
>   after eviction returns 0 scanned)
> * refine "restrict eviction accounting to eligible zones" for
>   potential premature OOM;
> * Collect Baolin's reviewed-by tag, thanks!

Here's how v8 altered mm.git:


 mm/vmscan.c |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

--- a/mm/vmscan.c~b
+++ a/mm/vmscan.c
@@ -4034,8 +4034,6 @@ static void try_to_inc_min_seq(struct lr
 
 	/* see the comment on lru_gen_folio */
 	if (swappiness && swappiness <= MAX_SWAPPINESS) {
-		unsigned long seq = lrugen->max_seq - MIN_NR_GENS;
-
 		if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_FILE] < seq)
 			min_seq[LRU_GEN_ANON] = seq;
 		else if (min_seq[LRU_GEN_FILE] > seq && min_seq[LRU_GEN_ANON] < seq)
@@ -4246,7 +4244,13 @@ static bool lruvec_is_reclaimable(struct
 	if (mem_cgroup_below_min(NULL, memcg))
 		return false;
 
-	if (!lruvec_is_sizable(lruvec, sc))
+	/*
+	 * As in __alloc_pages_may_oom(), avoid triggering OOM for low-zone
+	 * allocations. Also, defer the LRU size check until reclaim reaches
+	 * a very low priority to avoid premature OOM.
+	 */
+	if (sc->priority <= 1 && sc->reclaim_idx >= ZONE_NORMAL &&
+	    !lruvec_is_sizable(lruvec, sc))
 		return false;
 
 	gen = lru_gen_from_seq(evictable_min_seq(min_seq, swappiness));
@@ -5220,6 +5224,13 @@ static bool try_to_shrink_lruvec(struct
 	bool need_rotate = false, should_age = false;
 	int swappiness = get_swappiness(lruvec, sc);
 	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
+	/*
+	 * Avoid aging the lagging type under extreme swappiness,
+	 * as reclaim of the unpreferred type is disabled until
+	 * DEF_PRIORITY / 2.
+	 */
+	bool allow_no_populatable_age = (sc->priority <= DEF_PRIORITY / 2) ||
+		(swappiness > MIN_SWAPPINESS + 1 && swappiness < MAX_SWAPPINESS);
 
 	/*
 	 * Proactive reclaim initiated by userspace for anonymous memory only.
@@ -5238,8 +5249,9 @@ static bool try_to_shrink_lruvec(struct
 
 	while (nr[LRU_GEN_ANON] > 0 || nr[LRU_GEN_FILE] > 0) {
 		unsigned long orig_file, orig_anon;
-		DEFINE_MAX_SEQ(lruvec);
+		unsigned long max_seq;
 		bool no_populatable;
+		long scanned;
 
 		if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
 			need_rotate = true;
@@ -5248,8 +5260,7 @@ static bool try_to_shrink_lruvec(struct
 
 		orig_anon = nr[LRU_GEN_ANON];
 		orig_file = nr[LRU_GEN_FILE];
-		if (!evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH))
-			break;
+		scanned = evict_folio_lists(nr, lruvec, sc, swappiness, MIN_LRU_BATCH);
 
 		if (should_abort_scan(lruvec, sc))
 			break;
@@ -5261,14 +5272,20 @@ static bool try_to_shrink_lruvec(struct
 		if (root_reclaim(sc) && should_age)
 			break;
 
-		no_populatable = (nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] == orig_anon) ||
-				 (nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] == orig_file);
+		/* Limit no_populatable aging to once per try_to_shrink_lruvec() */
+		no_populatable = allow_no_populatable_age &&
+			((nr[LRU_GEN_ANON] && nr[LRU_GEN_ANON] == orig_anon) ||
+			(nr[LRU_GEN_FILE] && nr[LRU_GEN_FILE] == orig_file));
+		allow_no_populatable_age &= !no_populatable;
+		max_seq = READ_ONCE((lruvec)->lrugen.max_seq);
 		if (should_run_aging(lruvec, max_seq, sc, swappiness, no_populatable)) {
 			trace_mm_mglru_aging(lruvec, sc, swappiness);
 			if (try_to_inc_max_seq(lruvec, max_seq, swappiness, false))
 				need_rotate = true;
 			should_age = true;
 		}
+		if (!scanned)
+			break;
 
 		cond_resched();
 	}
@@ -5965,6 +5982,7 @@ static ssize_t lru_gen_seq_write(struct
 		.may_writepage = true,
 		.may_unmap = true,
 		.may_swap = true,
+		.priority = DEF_PRIORITY,
 		.reclaim_idx = MAX_NR_ZONES - 1,
 		.gfp_mask = GFP_KERNEL,
 		.proactive = true,
_


