Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA45C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 03:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73846B0088; Tue,  1 Sep 2026 23:22:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24556B008A; Tue,  1 Sep 2026 23:22:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39F66B008C; Tue,  1 Sep 2026 23:22:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA4CC6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:22:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EA811A0714
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:22:46 +0000 (UTC)
X-FDA: 85167375132.24.4196BBB
Received: from mta1.migadu.com (out-125.mta1.migadu.com [95.215.58.125])
	by imf19.hostedemail.com (Postfix) with ESMTP id CDFE21A0006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:22:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YZEueczw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.125 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788319364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=554NjEDQbsjom/BkdeweuSKKeLIDFYd7fXDT2z5cuT4=;
	b=ma+UBwllFicR4RFZ2QqlYpErrHeYDnuuFu5v05oZ6Mx1hKNw8vyq8ao+UGSYxJNyiUj2pA
	Nk/a+o5E8vz0ZeKeq9SxIU/9skdPGJgCgJ9b9mYTyOUshDvTfZ0skPx7piUbfX678YW67B
	wvkGt8xLqhsLxUDHAEFaSMo8fyBM2gA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YZEueczw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.125 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788319364;
	b=4I+dU+KadDuBzEOosp5UQ7RU924N62brUqKvm8/6cXLoixv/Z8Vip7MPXL+Mr+zUGnJewc
	2M65IDO0zO0KelGTkZ1V4AsuKWB+FD2cWJE/oi8pz8SwueXguIlo2mVaIEvbey+QNsdIBw
	JqZ4e22kadKa30mXytq+hgPeF28iwco=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7mgBphxysEsczLG5IEkPdVyi4Pv6bNrjCdlgQoFHKQ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788319362; v=1; x=1788924162;
 b=YZEueczwVSVHCliEyGBAW2tC4Y6ey+fiT6Aub2HZWKw2EYse3B+rYQwEQtfJAT+0nO49jLVJ
 ta/rCP8DHFp7TgL+AEjZFqpYDf+s5NKGXY717NjmXKclRZk3bmHuRPWXv/WoD0FWIdNpxsQNLUv
 KUGqknEUyqXMhqQ8NUjjJpN0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 1658734fd711a9b7;
	Wed, 02 Sep 2026 03:22:32 +0000
X-Mizu-Trace-ID: 1658734fd711a9b7
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 11:22:27 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, kasong@tencent.com,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, david@kernel.org,
	rostedt@goodmis.org, mhiramat@kernel.org, hannes@cmpxchg.org
Subject: Re: [PATCH v2 3/4] mm/mglru: skip cold PUD subtrees during aging
Message-ID: <apeWczinE0zVkDAG@fedora>
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-4-hebaoquan@kylinos.cn>
 <CAGsJ_4zFoYNuuVsTR=T4Qtxc5iVBPCK8rgiKa75VqNWqqcO=3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zFoYNuuVsTR=T4Qtxc5iVBPCK8rgiKa75VqNWqqcO=3g@mail.gmail.com>
X-Stat-Signature: m79r87idih9oqp49kq4citrzdwm4srg9
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CDFE21A0006
X-Rspam-User: 
X-HE-Tag: 1788319363-489337
X-HE-Meta: U2FsdGVkX1+i9oEMLSvP9oxma4FHCmPU5yhRDW4lm5he0oOTvdTUYbmLjVHF7jRDBRFIGtzIXgRqmPfs3d0Ysn9lWNkHGgbdCl1y0fu77evDbV5ti/rgM5knMiRy2yyECZ7x86OSWB8jAlh9qO/6kUz35pxnQJxmnXucIiwVdj1goA00LkjgI6IW4ioQJoATmjoNDex0VKHa9VS70n9eCwdD2GluBK47e2aAw2fj4z70Xozu761S867LKLnAku5ML3Z8cusIjOm6GnFBA+IejqWKifqBndzAsyGbJ1Bn9zA8+Vnjea47ZBn50PB7tXK7Vkn9TKIF3dW8qoePIVBLD4sZIVh3/kcePTCSExIeRD/XDNwPm/n+olVn7OQBJhA5MsIIm5r+D1ndQODTQuDw78gWZO2AgZhIfGRZdTOmtYhasket5uqlRvhIMdhHzMW88y0XlDNzXCe5MzVNClACFrJ4Na5mctuOGlAs+LD6LSaY24l+GGdDnQNEnKtTEJ44BtCsiWr5BAo17g/z+MIHHUNMnBbXMaRsrYvTxYg/0nNDn3DWohdcLfYMXpnBVNtlW3Xzo73emRSQPIPs50TUnZi9b8/FqWKKsDmjuDekssU1MMs10RLdiPblp6FOtild4wojD8L5L1FNzOEjiUVO0puupDMWfI5Pl3EzNu+N+cgGrD6lVn6mjFMOtDI3Dr7zR5sBrrihPJ8zdfigbp39WQeSTYRt62uQvkSkTjee4o4fqjDVewpm/hOq73LR8yfxzPCKt/CQCSfA3zr6iY8GZxJamvW78OXZKcSajCLPC5fMsLNJCQQyZMspVp7MBDIgbzVJZZQfIAgihiI+DTOrUe7ZScjRyhABKHmOWdAVh+PJUDam1HGmBHaH3JS4pGjWVMhY8AtiQbjq9mBPjrHmfvH2jF5ZAUAUFC0JqlN1IJEkbmQzjS8B6eLYA+rYF07gVdH0gNEp0LOJt5g8W7w
 ikvU0kEA
 vJiZRpEfTWwXJrcnWVcx/p8CAWiYjSl+KA1n2JPMsgqn/13VcwqoDZ+rL0oMPpK8B3HVUPXNAuO0sQpoxcRHgQfB/prMx32D4KAxEIPlBOGA6PNyvfOHT66glYp9APu+TWxV+yBw3/o4f6fZVMfTpHLG68gh4W2omC37ib7GZJXXxLfsRJAO5yKWve2fuY7oNuy3FEluDc7r0+i3XO71+Y0m+7zBmWLTYfCIYlk3DHKou2GMHz2OJgfUlidgvCmofYgJFwvmnenkizZnqDRJLC0MLECXHb8r9xM4TyHG6oJdalDA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/02/26 at 07:53am, Barry Song wrote:
> On Tue, Sep 1, 2026 at 2:38 PM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > The aging walks into every PUD and runs the PMD-level Bloom filter
> > on each PMD. Add a coarser PUD-level filter (pud_filters) one level
> > up:
> >  - walk_pmd_range() now reports whether it found any young leaf entries,
> >  - walk_pud_range() records that in the PUD filter, and
> >  - on subsequent generations, skips the whole 1GB subtree when the filter
> >    says it had none last generation.
> >
> > The double-buffered filter flips with each new iteration, so newly hot or
> > migrated-in pages are re-checked promptly rather than suppressed
> > indefinitely. force_scan walks bypass the PUD test, so manual aging and
> > newly added mm's always rescan and re-populate the filter.
> >
> > To keep hot regions marked, also report the covering PUD from the rmap
> > feedback path (lru_gen_look_around()), so regions whose hotness is only
> > observed by eviction will be re-scanned.
> >
> > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > ---
> >  mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 47 insertions(+), 5 deletions(-)
> [...]
> > @@ -4397,8 +4431,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
> >         lazy_mmu_mode_disable();
> >
> >         /* feedback from rmap walkers to page table walkers */
> > -       if (mm_state && suitable_to_scan(i, young))
> > +       if (mm_state && suitable_to_scan(i, young)) {
> > +               /* the PUD entry covering the young PTEs scanned above */
> > +               pud_t *pud_p = pud_offset(p4d_offset(pgd_offset(vma->vm_mm, pvmw->address),
> > +                                                    pvmw->address), pvmw->address);
> > +
> >                 update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
> > +               update_pud_bloom_filter(mm_state, max_seq, pud_p);
> > +       }
> 
> 
> Hi Baoquan,
> 
> I am really not against this idea, and I believe it can benefit
> NUMA cases.
> 
> That said, I might be being overly cautious, but I'm a bit concerned
> that this re-walk of the page tables could slightly hurt machines that
> don't benefit from the PUD filter at all. For example, Android devices
> typically have relatively small amounts of memory, so a PUD covers a
> really large range of their address space, which is unlikely to be
> useful on an 8 GB Android device. Also, `lru_gen_look_around()` is a
> really hot path. On Android, we've observed that it can consume a
> significant amount of CPU.
> 
> Is there any possibility of implementing this in a low-cost way?

I made a draft patch, could you help check and test if it's performing
better on Andriod device?

From 5b92a88925a7fe1733ca54595ece7be1bd122909 Mon Sep 17 00:00:00 2001
From: Baoquan He <hebaoquan@kylinos.cn>
Date: Wed, 2 Sep 2026 11:07:10 +0800
Subject: [PATCH] mm/mglru: gate the PUD rmap feedback on filter engagement
Content-type: text/plain

lru_gen_look_around() updates the PUD-level Bloom filter so that regions
whose hotness is only observed by eviction stay marked and are re-scanned
by the aging walker. But on systems where the PUD filter never skips
(e.g. small-memory devices where a PUD covers too much address space to
be useful), this is pure overhead on the page-fault hot path.

Gate the PUD feedback on a per-lruvec flag that is set when the aging
walker actually skips a PUD and cleared at the start of each generation.
look_around() then pays only a single flag load while no PUD is being
skipped, and the feedback engages exactly when the filter is active.
PUDs are only marked from the eviction side when the aging is really
skipping them. So hot regions stay protected where the filter is active,
and machines that never benefit get zero extra cost.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/mmzone.h | 2 ++
 mm/vmscan.c            | 9 +++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 276d0ca8d1c1..803431dfac80 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -617,6 +617,8 @@ struct lru_gen_mm_state {
 	unsigned long *pmd_filters[NR_BLOOM_FILTERS];
 	/* PUD-level Bloom filters flip after each iteration */
 	unsigned long *pud_filters[NR_BLOOM_FILTERS];
+	/* whether the aging has skipped a PUD this generation */
+	bool pud_filter_used;
 	/* the mm stats for debugging */
 	unsigned long stats[NR_HIST_GENS][NR_MM_STATS];
 };
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 035bd9ea49aa..22851b02264f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3143,8 +3143,11 @@ static bool iterate_mm_list(struct lru_gen_mm_walk *walk, struct mm_struct **ite
 	if (!mm_state->head)
 		mm_state->head = &mm_list->fifo;
 
-	if (mm_state->head == &mm_list->fifo)
+	if (mm_state->head == &mm_list->fifo) {
+		/* new generation: reset the PUD-filter engagement flag */
+		WRITE_ONCE(mm_state->pud_filter_used, false);
 		first = true;
+	}
 
 	do {
 		mm_state->head = mm_state->head->next;
@@ -3858,6 +3861,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 
 		/* Skip a subtree whose 512 PMDs all failed the PMD-level filter last gen */
 		if (!walk->force_scan && !test_pud_bloom_filter(mm_state, walk->seq, pud + i)) {
+			WRITE_ONCE(mm_state->pud_filter_used, true);
 			walk->mm_stats[MM_PUD_EMPTY_SKIPPED]++;
 			continue;
 		}
@@ -4434,7 +4438,8 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	lazy_mmu_mode_disable();
 
 	/* feedback from rmap walkers to page table walkers */
-	if (mm_state && suitable_to_scan(i, young)) {
+	if (mm_state && suitable_to_scan(i, young) &&
+	    READ_ONCE(mm_state->pud_filter_used)) {
 		/* the PUD entry covering the young PTEs scanned above */
 		pud_t *pud_p = pud_offset(p4d_offset(pgd_offset(vma->vm_mm, pvmw->address),
 						     pvmw->address), pvmw->address);
-- 
2.54.0


