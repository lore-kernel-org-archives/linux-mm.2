Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2951C606A327
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 10:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSWTZWHN
Received: by kanga.kvack.org (Postfix)
	id 491C76B02CD; Thu, 22 Oct 2026 06:27:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B436B02CE; Thu, 22 Oct 2026 06:27:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9076B02CF; Thu, 22 Oct 2026 06:27:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F44A6B02CD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:27:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A11A11C4120
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:27:34 +0000 (UTC)
X-FDA: 85349885628.29.6B85C35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C7E0B180003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:27:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CSWTZWHN;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792664852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgOOEpqKih5ogHRUxdmTCh2GDiwR8Qk5ZwygPDFgL2Q=;
	b=DTHKm6jlyuocUHlsG/mE6ZoyaDKnyPEqagvCzZy+7Ct8liUpxa85LETGLUNlQT8NbDM1DK
	6mHtwNvhBjCCot5m0ErrDNRdnHo9zP6FyY1X0eSDmb3gYLGZab48iQ7O6FCWe6U47UCdQ6
	eYYSMzawYpcwoVwjB+uHiSjyZYzPa6M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CSWTZWHN;
	spf=pass (imf24.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792664852;
	b=76NgFvIOjZEsvDvdnVIL7+sTDqWLnzxwbINiZyfg8MhTmeSuWAbYYzaasPQbrjAM9qOj7c
	9oszUUyJXbNS/7X2JNmxjNf1azj2KL7f4woC88F8pGcem2e5JIbiFjHb7mkOE36VRbfezv
	SVwXkGbSOTAeaBhowfRhaUOe7EU4vkI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A1FF240E5D;
	Thu, 22 Oct 2026 10:27:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0F01F000C1;
	Thu, 22 Oct 2026 10:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792664851;
	bh=TgOOEpqKih5ogHRUxdmTCh2GDiwR8Qk5ZwygPDFgL2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSWTZWHNAPgbOsZV8oU+qLEamweoNFqgirBvIl5wObWslAcgYViZzguK3G9viL4h0
	 ZEhIj+GxdH0NMm2E7gHROpgyO/RQ07LuvOLtwc1+NLrwmoTM6ry4q9D8seBEltQzkb
	 Pw+pR0leUEOgDclcB8BVGOhGKvVMOdlgzLbIGdfF+lP0FZIxb8rY5jKQ3ax2zR7+Tk
	 z58nK1YiONSh7y/NvYLhPu0YIpH6cwn0KFA0ItHux2S7JPt1cTOVKLgQd2oEP3jVkY
	 xKAhuF1J0ADym5Y6HtHUn5TTf7YNAyynHZjYuPVEBqtoqP1kO7yJEFvSZ572lpWDz5
	 oYBE5SCUFxRFQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: baolin.wang@linux.alibaba.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baoquan.he@linux.dev,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com
Subject: Re: [RFC PATCH v2] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache in MGLRU
Date: Thu, 22 Oct 2026 18:27:26 +0800
Message-Id: <20261022102726.56682-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <0cbd219d-f69d-4f72-aec5-43e1f2d978de@linux.alibaba.com>
References: <0cbd219d-f69d-4f72-aec5-43e1f2d978de@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C7E0B180003
X-Stat-Signature: 4bc6upsqsia5h1qqttf598gy4iqpfyjy
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792664852-436679
X-HE-Meta: U2FsdGVkX1+VgYwumJMsGdd4OgTKg3kJAzpNVFRbxvTW0FFfPX2AsRo7IqDUwjOddKHVetoCLgy3E+DXjSv/FnZr1WmjU2KJuYK75NG+44FV2SmHqXZIafV6GIqgSZ0GcZ//j/SPRAYG8C29IyYSwO35eO3fFzl9tamQgae3XoXwtMyTnVmAKDYC7goLeLie5lCQKFqS1cAnITMMHMALq0DMY3VJZNIe17RWrDiwbMe2/sY/ZNpEH/LsCcbuLQosSUIkRDDG2HX8HQBzKtIl2xeYDMeJ7FMWrcjqWBoHy5KKkoibu0spt0jZx1J1akDhJRH0yOlqADHz7mFW9GRyGHsQ4ie/8qi7NOGzm1IjKtZJw718XsbMR7JiOZ4Fqu71NeURniFnPhiVCgB5SGLO0Pb+Jd8WU2ePh/XyN+9IO60jafazaIOHZjK/9EkcXvK4hi8BxWZBr7mkzGTInTXI/Ukw99C4ejr6aWli1ofZb+H/xI+ufagliRzLFdpSBGB7r22qzkD6wdUeyvqYQ95NB30XbwDaZIrI7EeIy5pxqwMcmhh6myzLo4rCMHgfUo/rP85I6QTa0c9bRAObpOAev5uwqXSVo5AHTD5S8Qna0qLKeVJrh/zwcGfP+C0bqkRptw0Fs79C5elF03UnvCXrNIAhoCgvcZQ+txXMyz6M9fat8kokedRZkn77vYxHejQJdC6b5zkky7Ae39PUndgpSGRQwYSqQcdSEIMrhP1bmGbpcGriVo6T7l3O5/H0ypqfRceZafkYx7ZjwoRgj27CURR5D0cTQrlILOxdcLgqJaOafZtCi1ZL+rm6eHvFq2FuUsQm58NqXMAjE6/wJI/ZW4Mt/vvlZWYt9e+xSu1I2Cuu6MUi/6RKD358aKSeC9eOWoftXf5PrR4iraMak8+jmgpSJleCT4YBsW4HQ+u6OVwBsyGjjWUk9lKEi7jRrqzfpaLxIjQNYVLqQ4W1weu
 FeTtErqv
 SR2jsJui3Cy4GgLQbNv8U/bjhNg3AgRF30/F7LKhofGyxdxhu/GUV9PewEh44rOflPRvThZmUieob1G/ga3vLTQGAjOk4+LBnsI5RKLapwlyw1ImZvcIvZtEnR+VIJTjKgilKiizUl1aokQGNoZUKRT0+ZORako0cgkrUE3TRmDuGf4GoUcvEP4b+x1ZyWTE8LYLpKXwRMnvK3T9bFP1h8BDraMk/TcbtwUV+CKyXdus3ctOBUh5+nyJMIOTAJzIF4db/C/fgCA2HLuylUA0UoVhuED8oS7a7Jo98xiqJKYfZm059fdmOixddGd6DrjZR1agv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 4:49 PM Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 10/22/26 5:55 AM, Barry Song wrote:
> > On Wed, Oct 21, 2026 at 3:28 PM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> > [...]
> >
> >>>    static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
> >>>    {
> >>>        unsigned long total;
> >>>        int swappiness = get_swappiness(lruvec, sc);
> >>>        struct mem_cgroup *memcg = lruvec_memcg(lruvec);
> >>>
> >>> +     swappiness = get_scan_swappiness(lruvec, sc, swappiness);
> >>> +
> >>>        total = lruvec_evictable_size(lruvec, swappiness);
> >>>
> >>>        /* whether the size is big enough to be helpful */
> >>> @@ -5249,9 +5265,10 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
> >>>        bool need_rotate = false, should_age = false;
> >>>        long nr_batch, nr_to_scan;
> >>>        int swappiness = get_swappiness(lruvec, sc);
> >>> +     int scan_swappiness = get_scan_swappiness(lruvec, sc, swappiness);
> >>
> >> IMO, 'swappiness' and 'scan_swappiness' are really confusing. Why move
> >> this logic into get_swappiness()? In get_swappiness(), we already have
> >> some similar logic to adjust swappiness when there is no available swap
> >> space.
> >>
> >
> > Yes. It is very confusing. we can't do that in get_swappiness() as otherwise,
> > we will get cold/hot inversion due to GFP_NOIO. for a real swappiness=0,
> > we allow cold/hot inversion for anon, but for GFP_NOIO, this is not the
> > case.
>
> But can_reclaim_anon_pages() doesn't only handle the GFP_NOIO case, it
> also covers the swap space limitation scenario. The latter is what
> concerns me more.
>
> If we're only talking about the GFP_NOIO case, I'd agree with your
> concern. However, we could introduce a helper to force anon aging and
> add comments explaining why we need this. That would look more
> maintainable than 2 confusing swappiness variables, no?
>
> Just my 2 cents.
>
> Something like below (untested):
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index daa7e37c2236..7c1d26e6b9d7 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2890,7 +2890,7 @@ static int get_swappiness(struct lruvec *lruvec,
> struct scan_control *sc)
>          if (swappiness == SWAPPINESS_ANON_ONLY)
>                  return swappiness;
>
> -       if (!sc->may_swap)
> +       if (!sc->may_swap || !(sc->gfp_mask & __GFP_IO))
>                  return 0;

For GFP_NOIO, we should also check whether swapcache is low, since
GFP_NOIO can reclaim swapcache. We already have
reclaimable_anon_is_low() for this.

>
>          if (!can_demote(pgdat->node_id, sc, memcg) &&
> @@ -4049,7 +4049,7 @@ static inline void flush_lru_batch(struct
> list_head *head, struct list_head **ba
>          *batch_end = NULL;
>   }
>
> -static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
> +static bool inc_min_seq(struct lruvec *lruvec, int type, int
> swappiness, bool force_anon_aging)
>   {
>          int zone;
>          int remaining = MAX_LRU_BATCH;
> @@ -4063,7 +4063,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int
> type, int swappiness)
>                  goto done;
>
>          /* For anon type, skip the check if swappiness is zero (file
> only) */
> -       if (!type && !swappiness)
> +       if (!type && !swappiness && !force_anon_aging)
>                  goto done;
>
>          VM_WARN_ON_ONCE(get_nr_gens(lruvec, type) != MAX_NR_GENS);
> @@ -4183,7 +4183,20 @@ static void try_to_inc_min_seq(struct lruvec
> *lruvec, int swappiness)
>          }
>   }
>
> -static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int
> swappiness)
> +static bool is_force_anon_aging(struct scan_control *sc, struct lruvec
> *lruvec,
> +               int swappiness)
> +{
> +       if (swappiness || (sc->gfp_mask & __GFP_IO))
> +               return false;

As above, GFP_NOIO doesn't imply swappiness=0 if there are many
swapcache folios to reclaim. So we should check
reclaimable_anon_is_low() here.

> +
> +       /*
> +        * Explain why we neeed to force increase anon min seq.
> +        * xxxxxx
> +        */
> +       return swappiness != sc_swappiness(sc, lruvec_memcg(lruvec));
> +}
> +
> +static bool inc_max_seq(struct lruvec *lruvec, unsigned long seq, int
> swappiness, bool force_anon_aging)
>   {
>          bool success;
>          int prev, next;
> @@ -4205,7 +4218,7 @@ static bool inc_max_seq(struct lruvec *lruvec,
> unsigned long seq, int swappiness
>                  if (get_nr_gens(lruvec, type) != MAX_NR_GENS)
>                          continue;
>
> -               if (inc_min_seq(lruvec, type, swappiness))
> +               if (inc_min_seq(lruvec, type, swappiness, force_anon_aging))
>                          continue;
>
>                  lruvec_unlock_irq(lruvec);
> @@ -4249,7 +4262,7 @@ static bool inc_max_seq(struct lruvec *lruvec,
> unsigned long seq, int swappiness
>   }
>
>   static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
> -                              int swappiness, bool force_scan)
> +                              int swappiness, bool force_scan, bool
> force_anon_aging)
>   {
>          bool success;
>          struct lru_gen_mm_walk *walk;
> @@ -4260,7 +4273,7 @@ static bool try_to_inc_max_seq(struct lruvec
> *lruvec, unsigned long seq,
>          VM_WARN_ON_ONCE(seq > READ_ONCE(lrugen->max_seq));
>
>          if (!mm_state)
> -               return inc_max_seq(lruvec, seq, swappiness);
> +               return inc_max_seq(lruvec, seq, swappiness,
> force_anon_aging);
>
>          /* see the comment in iterate_mm_list() */
>          if (seq <= READ_ONCE(mm_state->seq))
> @@ -4295,7 +4308,7 @@ static bool try_to_inc_max_seq(struct lruvec
> *lruvec, unsigned long seq,
>          } while (mm);
>   done:
>          if (success) {
> -               success = inc_max_seq(lruvec, seq, swappiness);
> +               success = inc_max_seq(lruvec, seq, swappiness,
> force_anon_aging);
>                  WARN_ON_ONCE(!success);
>          }
>
> @@ -5262,7 +5275,9 @@ static bool try_to_shrink_lruvec(struct lruvec
> *lruvec, struct scan_control *sc)
>                  }
>
>                  if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> -                       if (try_to_inc_max_seq(lruvec, max_seq,
> swappiness, false))

This is quite tricky. If we pass swappiness=0, anon aging will be
skipped. Do we want that for GFP_NOIO cases? I mean, these are not
real cases where anon aging should be disabled.

static int should_skip_vma(unsigned long start, unsigned long end, struct mm_walk *args)
{
        ...  
        if (vma == get_gate_vma(vma->vm_mm))
                return true;
        ...  
}

> +                       bool force_anon_aging = is_force_anon_aging(sc,
> lruvec, swappiness);

Adding a force_anon_aging argument to inc_max_seq() seems like
quite a burden. Maybe a cleaner approach is to pass sc all the
way to inc_max_seq() and let it detect GFP_NOIO cases itself?

BTW, I guess we don't need to worry about swappiness at all. We can
simply bypass anon reclaim?

diff --git a/mm/vmscan.c b/mm/vmscan.c
index fc823fe3bd1f..fa6d9860156d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4903,6 +4903,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int skipped = 0;
 	unsigned long remaining = nr_to_scan;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	VM_WARN_ON_ONCE(nr_to_scan > MAX_LRU_BATCH);
 	VM_WARN_ON_ONCE(!list_empty(list));
@@ -4910,6 +4912,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	if (get_nr_gens(lruvec, type) == MIN_NR_GENS)
 		return 0;
 
+	if (!type && reclaimable_anon_is_low(memcg, pgdat->node_id, sc))
+		return 0;
+
 	gen = lru_gen_from_seq(lrugen->min_seq[type]);
 
 	for (i = MAX_NR_ZONES; i > 0; i--) {
@@ -5164,12 +5169,19 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
 			     struct scan_control *sc, int swappiness)
 {
+	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
+	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 	DEFINE_MIN_SEQ(lruvec);
 
 	/* have to run aging, since eviction is not possible anymore */
 	if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_seq)
 		return true;
 
+	/* run aging when GFP_NOIO limits anon reclaim with few swapcache folios */
+	if (swappiness && min_seq[LRU_GEN_FILE] + MIN_NR_GENS > max_seq &&
+	    reclaimable_anon_is_low(memcg, pgdat->node_id, sc))
+		return true;
+
 	/* try to avoid aging, do gentle reclaim at the default priority */
 	if (sc->priority == DEF_PRIORITY)
 		return false;


