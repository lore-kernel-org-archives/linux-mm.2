Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 529A0CA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 07:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 046D36B0088; Mon, 12 Oct 2026 03:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3AA46B008A; Mon, 12 Oct 2026 03:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51D86B008C; Mon, 12 Oct 2026 03:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4A466B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:23:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37DE6809A1
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:23:38 +0000 (UTC)
X-FDA: 85313134116.22.FB31753
Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	by imf26.hostedemail.com (Postfix) with ESMTP id DFDF3140007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:23:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fVbeXI5V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791789816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8NKwMrhApUwn/G5lRAI/pD4bmXBQTUsnyD5w9wKH4w=;
	b=ZDHecgWizmS/2bF17q+CCXIstIXO5LbYGmL3ai5nvIu8DuDmXEwQ0WOcgyh7cTB5jzxRIu
	czcDDLjA1WLxk/Qu1sn/vibrtMWhvcTxfGTQcm58eCOKY3MlbL0NnHXox0wFD7ePZnFzSl
	vRSelJzaRt8aHWBlI8pspdURY4ftQ/A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fVbeXI5V;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791789816;
	b=djWAeRPW3xeVigZS5TQB4f3+hN4iTqS+hY/zQoOjb618WtYjQIRt7pnZpGlAuYEe+bl3DT
	A3NU7aG/erLSls1awcfDaVMsvDukcYLqJYH6KVwz/9VJEKaRtIfH+R7+tMiJl0TSnr+NOQ
	tI+5w2JoJeZCyoHVO2AfE/1t62D48Yc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UM8adxA/R87Nyq3hvBLH5yR3nIt2GNtot7r6xMKw9+Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791789814; v=1; x=1792394614;
 b=fVbeXI5VtBN7ZbNmd3WiRvFhkaCYz6yIRB1CjT4P+aoXCFmVVNTa4QZmgUj5InjIFQGt8khc
 nWhQocbTTmZuckJajQMFibrhVDtjf5wHPoCCPgC+39fVx6x+709EPkdwDbELHYdfv+pR1xFL4o9
 u7ohHB4b4wdKmXOzAzv3LNP8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 3fb08dc45f88c86f;
	Mon, 12 Oct 2026 07:23:34 +0000
X-Mizu-Trace-ID: 3fb08dc45f88c86f
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 15:23:22 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org,
	youngjun.park@lge.com, yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org, klarasmodin@gmail.com
Subject: Re: [PATCH v4 08/14] mm, swap: defer xswap shrink to workqueue to
 avoid lock recursion
Message-ID: <asyK6t1POEW5c533@fedora>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
 <20261003003136.750633-9-hebaoquan@kylinos.cn>
 <CAN_Opa_JCCd-+o5y9JXbzypPtYjTGvyvnOy7KmSUKHYtVab85w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN_Opa_JCCd-+o5y9JXbzypPtYjTGvyvnOy7KmSUKHYtVab85w@mail.gmail.com>
X-Stat-Signature: 8edomy3pgfxpfawaxat8ktqszpamnhxa
X-Rspam-User: 
X-Rspamd-Queue-Id: DFDF3140007
X-Rspamd-Server: rspam08
X-HE-Tag: 1791789815-920761
X-HE-Meta: U2FsdGVkX1/oweH7CRljbdoNO2Fatbd+8nuI2c5N1d4GCxFNqTD2TdcjgDnzu6fUGIScIulfZPiz6iM/p4bKFwpgkchOuXw6iVpOQkBBxMoHl03FYD6mfBBjsT7e35KQh9E0H8oAGZGPZyQ3ziNcBNl3QHsXV0oVG+TS/rvrsJTjRQfD/vAs118jnzF/OVovt70Bh/BtOW2Kq5pstn6LMqBLCHKdu9R/GgGO97Ivnf7wKkiBLuscNDP3wfmVigznJ+J9y00zIqdpHDebowCBU9L4cjlsIONTDu5RD5iFLnV4bxUvYzxVwSDVboIgGv3bH3Tl78+hHSaL0i+e79OlxcqkLP22XvcskY8AkJ193aGR9uIpNKby0vnTPNHkhoi5BfOCoqgmdcVgJ92HxEoz/QaSyzXoJlLA2g959pms8pfEEtZO9B8NVD8CGREtvdbOrR4mWHR3wCqU9d+Az2d2qNFtQL8BOGyNzrLA4++jd9VuverVzvcz25mFmTcZ5mznWrGQBIKccfBuiWiE4TlH4QCYPue3SvvKvZq2q8DKiGAcdOqM+6/SNTRCwioSUc/pXf6aiwQsVt6bT1a2cS9STG+drE0CvX4mgOVaQ2dQ6RiI0bbU+9p/S3+Pk0d2n21l2PUP3SDR6tUjM6E014fWREz2x4/B0obY6y/zNd/PKCOqpwbzN3tc2X+8CUK4zSIneuQ9rjtkk6bA/ZwTLPW2X7gTWXm/sDgjBwQAPZhUiIc2zycHhTKt+RpQIG+PuJSClWn8oGlHBbu+e5Ngyn2cjzEjpKzMFYY0aDen+jM3V3gLdR0XExUaTMK2FKPVT64ZatN0z02kycIwAvjBBNbI8bwk/bv3p/kFBuFI599oOSDH+Km2kipj4QuudyIzfxqnuxmb6hZ4E9+RFGAz/T5v5sUdDBhRtt6/5H7QkdwitRXmm+DC5+fCTmmETatx0BD96BKmdeIkPkwYXq0p15I
 NRGsWdxZ
 yNJUnGmCqKMnULyA/CiMXC1FWsTvWTpBgC8SXr8JTdK7s0qV0mtH+NOLfsrzjAUA9VEaGkMQJ4tekOtnkPclSod76MmchU4XhCcXVlEsBokT73HqAiiQnb4pskoxqZ9THChwQ3MH3JfplS3c4+fRUmElpNsFu0hmhezrhvATy1ddYej2ZUkcTKmR4/wwSe2ZVKYjkcA0FkxjUVXqNsC37KWErRc1zpC88V6Xt4Jed1l/fS9azSZ2WQMCuNei+k4pgyjxMhs7q4DILjxHv0JR7kbSlWBMBcHAxB88P3v27NA7PzMCv/q+I02ZXCfZf2BplskF/PZ/PkC169gyWNIB2pSDd1gvYfdl+YaN3ZoQqfjfc8enGb+/el9Of0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/08/26 at 05:10pm, KunWu Chan wrote:
> On Sat, Oct 3, 2026 at 8:32 AM Baoquan He <hebaoquan@kylinos.cn> wrote:
...snip...
> >  /*
> >   * Try to shrink the cluster_info tail: unmap contiguous free clusters
> >   * at the end of the mapped range.
> > @@ -4164,14 +4187,20 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
> >  static void xswap_try_shrink(struct swap_info_struct *si)
> >  {
> >         struct swap_cluster_info *ci;
> > -       unsigned long nr_mapped, last, keep, idx;
> > +       unsigned long nr_mapped, nr_tail, keep, nr_unmap, start_idx, i;
> >
> >         if (!(si->flags & SWP_XSWAP))
> >                 return;
> >
> > +       mutex_lock(&si->xswap_lock);
> > +
> > +       /* A swapoff raced us and is about to walk this mapping. */
> > +       if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
> > +               goto out_unlock;
> > +
> >         nr_mapped = READ_ONCE(si->nr_clusters_mapped);
> > -       if (nr_mapped <= 1) /* keep cluster 0 */
> > -               return;
> > +       if (nr_mapped <= 1)     /* keep cluster 0 */
> > +               goto out_unlock;
> >
> >         /*
> >          * Reclaim on our own, but only once the mapped range is at most
> > @@ -4181,40 +4210,73 @@ static void xswap_try_shrink(struct swap_info_struct *si)
> >          */
> >         if (swap_usage_in_pages(si) * 100 >
> >             nr_mapped * SWAPFILE_CLUSTER * XSWAP_SHRINK_WHEN)
> > -               return;
> > +               goto out_unlock;
> >
> > -       /* Find the last non-free cluster from the tail */
> > -       last = nr_mapped;
> > -       while (last > 1) {
> > -               idx = last - 1;
> > -               ci = &si->cluster_info[idx];
> > -               if (ci->count || ci->flags != CLUSTER_FLAG_FREE)
> > +       /*
> > +        * Count the free clusters at the tail of the mapped range.  Scanned,
> > +        * not tracked: the count must be exact to size the unmap, and an
> > +        * incremental count falls behind on out-of-order frees.
> > +        */
> > +       nr_tail = 0;
> > +       while (nr_mapped - nr_tail > 1) {
> > +               ci = &si->cluster_info[nr_mapped - nr_tail - 1];
> > +               if (READ_ONCE(ci->count) ||
> > +                   READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
> >                         break;
> > -               last = idx;
> > +               nr_tail++;
> >         }
> > -
> > -       if (last == nr_mapped)
> > -               return; /* nothing to shrink */
> > -
> > -       /* Below `last` has to stay mapped: the free ones in between are
> > -        * not part of the tail, and unmapping them orphans what is above.
> > -        */
> > -       if (nr_mapped - last < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
> > -               return;
> > +       if (nr_tail < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
> > +               goto out_unlock;
> >
> >         /*
> >          * Stop at SHRINK_UNTIL rather than at the end of the tail, or the
> > -        * range comes out full enough for the grow to be woken.
> > +        * range comes out full enough for the grow to be woken.  Below the
> > +        * tail everything stays mapped, and one chunk of tail with it.
> >          */
> >         keep = DIV_ROUND_UP(swap_usage_in_pages(si) * 100,
> >                             XSWAP_SHRINK_UNTIL * SWAPFILE_CLUSTER);
> > -       if (keep < last + XSWAP_SHRINK_SLACK)
> > -               keep = last + XSWAP_SHRINK_SLACK;
> > +       if (keep < nr_mapped - nr_tail + XSWAP_SHRINK_SLACK)
> > +               keep = nr_mapped - nr_tail + XSWAP_SHRINK_SLACK;
> >
> >         if (nr_mapped < keep + XSWAP_SHRINK_MIN)
> > -               return;
> > +               goto out_unlock;
> > +
> > +       nr_unmap = rounddown(nr_mapped - keep, XSWAP_GROW_CLUSTERS);
> > +       if (!nr_unmap)
> > +               goto out_unlock;
> > +       start_idx = nr_mapped - nr_unmap;
> > +
> > +       /*
> > +        * Only shrink a run that reaches the mapped end; otherwise
> > +        * truncating nr_clusters_mapped would orphan the active tail.
> > +        */
> > +       spin_lock(&si->lock);
> > +       for (i = start_idx; i < nr_mapped; i++) {
> > +               ci = &si->cluster_info[i];
> > +               if (READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
> > +                       break;
> > +               if (!spin_trylock(&ci->lock)) {
> > +                       spin_unlock(&si->lock);
> > +                       goto out_unlock;
> > +               }
> > +               spin_unlock(&ci->lock);
> > +       }
> > +       if (i != nr_mapped) {
> > +               spin_unlock(&si->lock);
> > +               goto out_unlock;
> > +       }
> > +
> > +       for (i = start_idx; i < nr_mapped; i++) {
> > +               ci = &si->cluster_info[i];
> > +               list_del_init(&ci->list);
> > +               WRITE_ONCE(ci->flags, CLUSTER_FLAG_NONE);
> > +       }
> > +       spin_unlock(&si->lock);
> >
> > -       xswap_unmap_clusters(si, keep, nr_mapped - keep);
> > +       xswap_unmap_clusters_locked(si, start_idx, nr_unmap);
> > +
> > +out_unlock:
> > +       mutex_unlock(&si->xswap_lock);
> >  }
> >  #endif /* CONFIG_XSWAP */
> >
> > @@ -4278,6 +4340,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
> >                         }
> >                 }
> >
> > +               INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
> >                 return 0;
> >
> >  err_unmap:
> > --
> > 2.54.0
> >
> 
> Hi Baoquan,
> 
> While following the shrink path across these patches, I wanted to
> clarify the lifetime guarantee for the `cluster_info` backing pages.
> 
> P07 flushes the per-CPU swap cluster cache and calls
> `synchronize_rcu()` before unmapping the tail. P09 clears
> `SWP_WRITEOK` and cancels the shrink work before proceeding with
> `wait_for_allocation()` and `try_to_unuse()`.
> 
> Could you clarify how the shrink path ensures that, before the tail
> is unmapped, no allocation-side reader can still access the tail or
> republish a stale per-CPU cache entry that points into it, and no
> swapoff-side walker can still access the unmapped range?

Hi Kunwu,

Thanks a lot for your careful review, and for following the shrink path
across patches. Assume P07 in your saying means patch 07, and P09 means
patch 09. For the questions,


1. Allocation-side readers of the tail

xswap_try_shrink() removes the clusters to unmap from their lists while
holding si->lock, and only proceeds if spin_trylock(&ci->lock) succeeds for
each of them. After that no allocator can get these clusters from a list.

The flag check alone is not enough. move_cluster() writes ci->flags after it
drops si->lock, so spin_trylock() is what actually blocks an allocator that
just took the cluster.

Then, before the pages are unmapped, xswap_unmap_clusters_locked() does
flush_percpu_swap_cluster() and synchronize_rcu(). That drains the four
readers that use cluster_info[] under rcu_read_lock():
alloc_swap_scan_cluster(), swap_reclaim_full_clusters(), swap_alloc_fast(),
and swap_alloc_hibernation_slot().

2. Republishing a stale per-CPU cache entry

The per-CPU cache is written in only one place: the end of
alloc_swap_scan_cluster(), and the value is an offset inside the cluster that
just got the allocation. That cluster cannot be one the shrink unmaps,
because the shrink only unmaps CLUSTER_FLAG_FREE clusters and a cluster that
just took an allocation is not free. So a racing cache write can only point
to a cluster that stays mapped. The flush plus synchronize_rcu() handles the
entries written before it.

3. Swapoff-side walkers

The swapoff walkers are not RCU readers. swapoff first stops the shrink:
cancel_work_sync(&p->xswap_shrink_work), then waits on p->xswap_lock (which
grow and shrink also hold). SWP_WRITEOK is cleared, so xswap_try_shrink() bails
out too. Then wait_for_allocation() drains any in-flight allocation, and
try_to_unuse() runs. Only after percpu_ref_kill(), synchronize_rcu(), and
flush_work() of the discard and reclaim works, flush_percpu_swap_cluster()
run and the mapping get freed.

Not sure if I answer your questions clearly.

Thanks,
Baoquan

