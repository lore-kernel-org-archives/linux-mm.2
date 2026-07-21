Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECFAFC44515
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 02:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B672A6B007B; Mon, 20 Jul 2026 22:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D1D6B008A; Mon, 20 Jul 2026 22:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D586B008C; Mon, 20 Jul 2026 22:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B3096B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:15:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D20631603B6
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:15:46 +0000 (UTC)
X-FDA: 85011167892.07.EAFC2D9
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47A4414000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:15:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784600145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bgPljP0KNDo3/JWFOIYMCi9Ci9Ha74Vl75l8b43rwfs=;
	b=gsxCJ6IL+aumMSP2vekeQOAHzVksEuvurVJOH4HUF3KBieKfSZybRIbZuJIygowKV0qO5Y
	RC28zNxucCbZU/76RDagLI4dAX7MKgzD+YlvQPtFV8Yq5RPc6V+5CPoF6GI5UDPXvYvW+J
	bPyHlqsMEsH7WzPeMPdUi/NLgP7Vzko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784600145;
	b=PepAUWTBNGU50z7si4111wXmExZ3WmWL07JhOA+nUBqwi7+Uts/1Iutcvm84RZucBM+ntC
	JLtMv+Dc4szus88BNXwP4XpZThYWq5fN+/Ii6Z8DzQwX5oo5d2RdJUM1w4MJktA1/s9QW+
	9NXCc/8vOB58991uHqxf2vK7F/+Skrs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.52 with ESMTP; 21 Jul 2026 11:15:41 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.125 with ESMTP; 21 Jul 2026 11:15:41 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 21 Jul 2026 11:15:40 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
	baoquan.he@linux.dev, baohua@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm, swap: Fix potential NULL dereference when trying
 a sleep table allocation
Message-ID: <al7WTNXanPVSELAH@yjaykim-PowerEdge-T330>
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
 <20260720071342.50742-2-shikemeng@huaweicloud.com>
 <al3mWmCN3lNv8jMu@yjaykim-PowerEdge-T330>
 <0884d36c-06b3-4df1-8fd2-8abc9e6c97ee@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0884d36c-06b3-4df1-8fd2-8abc9e6c97ee@huaweicloud.com>
X-Rspamd-Queue-Id: 47A4414000E
X-Stat-Signature: 4f3fbu1hkz9bpcun9qmior597bwyf1xs
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784600143-163144
X-HE-Meta: U2FsdGVkX1/MaiskWyNOKI37TqvzuCTgT2FHmk18q+edUJQsE631j/dCTiMI7gK4QLyjVbo4gFRAZDZflWL4aghk17HLXBQHMyfywi3g2sIvk+d24MDSnHfbMIgiKC1uNDqATeqG8Qft2Hg5EuzjXPHQ8yJ71a1fae7DX2KyJLurJeh9eXi8Gl4AL3dnG9JZ1tIW6NmBfCOirpYF2DO4U7vT05CcciSc/mgOIuvtuvTLQYEm7ACjC4HpOToXTAIs9daNklNNlTKsSmUyYKZN5g2bdmRHos/LnoyWzVtGciPRI1vIX52kNByU0eQySIqlnFi0ENEjBf/bAOqGqUKN1me9g5XI1mLZ+T49O0LUrhbgsNouHz1exM3KNbJoOykaU3MkBcb1Yos/8/vJfqK9eF8jsfDY8OoCA+dpqwZ30fGOaO6s46tXVrRRhHQrz3aLIhl0NEu8s7BX5Yq05VwfTA3rmJtboxn+r2TW/A+Dok5lELnQO8hBPgeKKQO9NJf+rUqK/NsllTdgzXi5trMjzWnHnXM+5AYwNrp92fIR7bNQdqHU8l/LAX02nVhUbHsy1HDWRnKDGOGY9ku7pfi5MEIrmYuO0BJQZiHCm/R2nv1PsfRPbAJ8hZ21sbU1kE1gyP1dJLEvVNSGqnV/i5d6l3MuHgZK0EVD1MaPsmDZfvNHS0OLFJ2Rv0EnH6P+Op3USF7puA7n+ZN0LtM38571l1CP5PnbqGte1iUiQW6frdlF9SWqyb09HF7rsvvv7C/npdVPfPWHXDa4St4W5CGcOT5CF2XlmcGh5N5XBHzzMaeCBqSVE6ShFVVdh25njXu7brLocMiWLBFpF0DNNYUUVuzl8WZSC99keQh+UnnhJBYMKV0S+cpfFAl9f+g5MscGdazly2erKoc3xo9qRLQ93oZTL/cvYhvR+5gvjdTtzbr1deLBO2CFRf0AhIx+KCtlIQ3xEgB+qrz/mh+FfzN
 byqTPv85
 AWjTgNe7E3BFjok3R5aPgdhPdMO8sQIvQnvkTOtydKMuW4I2VFaJ+4qvyYNDe7tvN2MqjVCmQBloESU5DAxW09BKyWmjeF/4R0Sia6qCksUZtMahs2O26LT6Wrw2zDtE2YggyZcNrwpz1ayn3YSRVvQSiAv9v/nATB39AVW71ZYMaIq14KIQzHXECV8gciP1qcB+LiqLSgeolx8+SLRrwMtX/mCE5izFBAINE0f5P/6UujOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 09:49:53AM +0800, Kemeng Shi wrote:
> 在 2026/7/20 17:11:54, Youngjun Park 写道:
> > On Mon, Jul 20, 2026 at 03:13:39PM +0800, Kemeng Shi wrote:
> > 
> > Hello Kemeng Shi,
> > 
> > Good catch!
> > 
> > it indeed looks like a possible race condition 
> > (though I haven't verified it at runtime either).
> > 
> >> The root cause of this issue is because multi-tables are updated in non
> >> atomic context. To be more specific, the issue could be triggerred as
> >> following:
> > 
> > Here the cluster is isolated (CLUSTER_FLAG_NONE).
> > 
> >> swap_alloc_fast         swap_cluster_populate()
> >>                          /* Try a sleep allocation */
> >>                          spin_unlock(&ci->lock);
> > 
> > And from here, the table becomes visible,
> > 
> >>                          swap_cluster_alloc_table()
> >>                           rcu_assign_pointer(ci->table, table);
> > 
> > All entry on this cluster is freed(e.g process dead) , 
> > so this might be the free cluster.
> > 
> >>  ci = swap_cluster_lock(si, offset)
> >>  cluster_is_usable(ci, order）
> > 
> > Since it's a normal cluster (CLUSTER_FLAG_NONE) and the table exists,
> > it passes here...
> > 
> >>   if (!cluster_table_is_alloced(ci)) // ok 
> >>  alloc_swap_scan_cluster()
> >>   cluster_scan_range()
> >>    __swap_table_get()
> >>
> >>                           /* free table when more table allocation fails */
> >>                           ci->memcg_table = kzalloc_obj(*ci->memcg_table,
> >>                                                         gfp);
> >>                           if (!ci->memcg_table)
> >>                            swap_cluster_free_table()
> > 
> > Nullified
> > 
> >>                             rcu_assign_pointer(ci->table, NULL);
> > 
> > Now it happens.
> > 
> >>     table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
> >>      atomic_long_read(&table[off]); // NULL dereference
> >>
> >> Fix the issue by updating allocated tables in atomic context.
> >>
> >> Fixes: 2fe7a6f5024b8 ("mm/memcg, swap: store cgroup id in cluster table directly")
> >> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> >> ---
> >>  mm/swapfile.c | 21 ++++++++++++++++++++-
> >>  1 file changed, 20 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/mm/swapfile.c b/mm/swapfile.c
> >> index 615d90867111..d29062d9c3cd 100644
> >> --- a/mm/swapfile.c
> >> +++ b/mm/swapfile.c
> >> @@ -490,6 +490,20 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
> >>  	return 0;
> >>  }
> >>  
> >> +static void swap_cluster_copy_table(struct swap_cluster_info *d_ci,
> >> +				    struct swap_cluster_info *s_ci)
> >> +{
> >> +	rcu_assign_pointer(d_ci->table, rcu_access_pointer(s_ci->table));
> >> +
> >> +#ifdef CONFIG_MEMCG
> >> +	d_ci->memcg_table = s_ci->memcg_table;
> >> +#endif
> >> +
> >> +#if !SWAP_TABLE_HAS_ZEROFLAG
> >> +	d_ci->zero_bitmap = s_ci->zero_bitmap;
> >> +#endif
> >> +}
> >> +
> >>  /*
> >>   * Sanity check to ensure nothing leaked, and the specified range is empty.
> >>   * One special case is that bad slots can't be freed, so check the number of
> >> @@ -527,6 +541,7 @@ static struct swap_cluster_info *
> >>  swap_cluster_populate(struct swap_info_struct *si,
> >>  			 struct swap_cluster_info *ci)
> >>  {
> >> +	struct swap_cluster_info tmp_ci;
> >>  	int ret;
> > 
> Hello, Youngjun
> 
> Thanks for feedback.> IMHO, How about resolving everything inside swap_cluster_alloc_table() instead?
> > 
> > We could consider the following two things.
> > 
> > - Assign the table at the very end inside swap_cluster_alloc_table().
> > - Handle the table freeing properly if subsequent allocations fail.
> > 
> > Rather than allocating a temp_ci (which adds special handling
> > for this case), wouldn't it be better to maintain the original intention
> > of the swap_cluster_alloc_table() function?
> > 
> > Although this is not a hot path and table allocation will usually succeed with
> > the ATOMIC allocator, this approach would also save the memcpy overhead
> > and stack memory usage.
> Yes, it will be better to handle the issue inside the swap_cluster_alloc_table()
> and I also consider this before. However, I didn't find a way to properly handle
> the lock as swap_cluster_alloc_table() will be used for both ATOMIC allocation
> and sleep allocation. So what about introduce a new helper like:
> swap_cluster_alloc_table_unlocked()
> {
> 	table = kmem_cache_zalloc()
> #ifdef CONFIG_MEMCG
> 	memcg_table = kzalloc_obj()
> #endif
> #if !SWAP_TABLE_HAS_ZEROFLAG
> 	zero_bitmap = bitmap_zalloc()
> #endif
> 
> 	spin_lock(&ci->lock);
> 	/* update all tables in atomic */
> 	spin_unlock(&ci->lock);
> }
> In this way, there are some repeated code, so it is also a little ugly...
> I will appreciate if you have any better idea!

Hello!

I don't quite understand why we need to introduce a new helper function.
Is it because the table assignment must be done strictly inside the lock?
In successful cases, wouldn't it be fine to assign the table without holding
the lock? (Please let me know if I am missing something here.)

If we just add error handling to free the allocated table inside
swap_cluster_alloc_table(), swap_cluster_free_table() will properly free
memcg_table and zero_bitmap as long as ci->table is not assigned yet.
I don't think this will cause any issues.

My intention is something like this:

-       rcu_assign_pointer(ci->table, table);     /* Remove this */
...

#ifdef CONFIG_MEMCG
        if (!mem_cgroup_disabled()) {
                VM_WARN_ON_ONCE(ci->memcg_table);
                ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
                if (!ci->memcg_table) {
			+ free table
                        swap_cluster_free_table(ci);
                        return -ENOMEM;
                }
        }
#endif

#if !SWAP_TABLE_HAS_ZEROFLAG
        VM_WARN_ON_ONCE(ci->zero_bitmap);
        ci->zero_bitmap = bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
        if (!ci->zero_bitmap) {
                + free table
                swap_cluster_free_table(ci);
                return -ENOMEM;
        }
#endif

...
        /* Assign here! */
        rcu_assign_pointer(ci->table, table);

	return
}
If it becomes visible at the very end, wouldn't it be safe from any issues?

Youngjun

