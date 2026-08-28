Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C8AFC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 07:26:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E4276B0088; Fri, 28 Aug 2026 03:26:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994B06B008A; Fri, 28 Aug 2026 03:26:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883D16B008C; Fri, 28 Aug 2026 03:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E42A6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:26:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4422A028F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:26:42 +0000 (UTC)
X-FDA: 85149845844.12.6483E99
Received: from mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
	by imf12.hostedemail.com (Postfix) with ESMTP id BD8E040006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:26:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wpp1C6qz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.44 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787902001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWXsBd101uoPLtQpn1+4mOXqmsinyUBG23B6Dw7eP1E=;
	b=UR+AsLuY5T2govjJ2w3wRiZlmcFcoKtzZ1T4Tl33HtO6s+lkcMR+f5Bik7Ec2boM+ybpSs
	lY8+7npf32Yfdu+ZsrRgDUSwDrAPCtnG6BhLhffnYIIQSxcOFW1s5n003orhvcuDhAz9Yh
	fUo0+H9cWHzC4ChifDEhegNOyX/0aX0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wpp1C6qz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.44 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787902001;
	b=V6aIpYtsdMCAcRB/LJ0pWXyy0uocumGFWWWthDT+R+N19oyMxpzDF3FYntl5MFR2QRNI82
	FvN4n6T6aj97CVg7dQTFDBYopcWIhrp2YqJdI5prjgPWF37edn1EV4rQh/55gb6b6/WGKh
	lgDyOYJJDnP2r5+FQGOI4lPdG0L4MhQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kckWbcCWwzGpC3oweqdN/h/vS4FFlKvUVHQRTYQfcLo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787901999; v=1; x=1788506799;
 b=Wpp1C6qz7pdxz0C4jTsx5XB7EhoBkRBwV/4BGmpq+GEAfCNy5sYYgq1GbEzCmcHJCiZg1czu
 GFmUrdQd+EEC4lJffA2datSr7tOYG4ntPtjR/tASuuxwY9/s835pJOCRLc3vV0w6hU0tE0ca+/G
 sZ5fuD5Texyaki0w6MD8ZzrI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id dfa73102092ea13f;
	Fri, 28 Aug 2026 07:26:39 +0000
X-Mizu-Trace-ID: dfa73102092ea13f
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 15:26:35 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, david@kernel.org, rostedt@goodmis.org,
	mhiramat@kernel.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com,
	baolin.wang@linux.alibaba.com, hannes@cmpxchg.org
Subject: Re: [PATCH 2/9] mm/mglru: suppress cross-node empty page table walks
Message-ID: <apE4K3PnupiUG63g@fedora>
References: <20260824073806.629593-1-hebaoquan@kylinos.cn>
 <20260824073806.629593-3-hebaoquan@kylinos.cn>
 <CAGsJ_4yC+2-Hx8wXop9bXPsAk7ZH=p=ZS1QmfyePKYK-VKhRXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4yC+2-Hx8wXop9bXPsAk7ZH=p=ZS1QmfyePKYK-VKhRXA@mail.gmail.com>
X-Stat-Signature: 1fnigg66dtmrmc8o1xrhz8nzn51p4yar
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD8E040006
X-Rspam-User: 
X-HE-Tag: 1787902000-349600
X-HE-Meta: U2FsdGVkX1+l1Z+IQl7VlTJF6DE9wI99eFU9v8oyqsvvNSn/CLZ6R/hIpu2fnXY9jny8ne12O4jpssTvENDoSnmYkvGW5pqvPz0DX1ysomjV3QkqQLj4uffUPj8pLmrnAcRo6qaeKImREC4Y/ZWvU3a919FsM1/QPR2xVyCZYweE34I8J29i90DyiDR9ADCuQyNHyjdaVwdncFVTdZuvcyOc9ld23xbsxBvs+o3fwGu6VHMG+xAg8CXxlC4qIm3ajq3B4a6pBsepXMWd7Mxcib1SwhWYsY9Aab7ExK98nSbaPKKcn/bvfqxIaTlZpJqj6rM4z7P6//qzDoi9EZjZNQBTPTjDnSc6ZjRp8ZYlwb4HDp3KoT12FptBYA67GReu8rRA8AY6g4rsM0Vgc5v+7rfICNQrLDK0pQlp/E2DGTD7AfbjqBXAIo2NcWF8tdmdRXWKb+X2QauASKNeQKKVjq8oeZeMKd8PkjgIHUu7KZwp9evLfeEsUDlkqmV0kEw3UQmMXNa+BHcKPAXMvaQLex1Eny10va6NeUCw6FiHkf1u+0DFsZHdFM+dBuv2+6sLXwzYGVPCa7IbwSj47kDHpQ7leZz3EvoOZGeQt9/squms0DZKX0z13fMPCig9xqicYSS2jYARexK4ISF9iGxAUuKJYDJWcoYP5jUd9zkrViNByCPHa345H4BOBxRI/rFCd4QQUNIiTyvByA3vK/AeaC1s8NqdIm0JZHmJvWXfQ0z+dW+X/54CQdg96TpEVUsJ2UB4+bn9ErJ2Rg/GdLFBn4bcPhwrz0vW4kBzFa0rJNcKueCH4bf2oVe3njeN0eQH0irOGsNNesUFF6lhWM5bE3sStqW9uYVuS7GPXuXDOd6AOSke4yA+ei6xcliN8bBvKmpzGnglAmP7+itD9CWtIF382r741n76+QYPrRFM8gq9g+HESZqr8CYJm6VlYX2oHv79xklqLWzE0wh/19H
 yd3eUScL
 ee6niRZuSGHZQcI+5adTs3m4V6qetpZSx7pPgmvFRVidiDcs1KdWiox8xUtYdZxdE/oKnzCx8VM4B86//jZNHLMyxmcFIeuZXXxmU2zEQsY8SY+f3nf0oVtYSMxo8377GCSnhkDX2Q6NICeIP7Zk1W7o/6dFUCktRTRiIaKDEit/R4m7BbYM36Oa9awmAjzaVPPA9xHfungnKI8INhNm/7yOtM2++PN7MnUHUAdoWizO5wo2kc32ne7+jzTCvc7lwnSwR2pvf8oZroG2TKxiTrAVlRvdOtpMSSyhAmpsD2RXwosc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/28/26 at 02:35pm, Barry Song wrote:
> On Mon, Aug 24, 2026 at 3:38 PM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > In the current MGLRU, lru_gen_use_mm() will mark one process's mm used
> > on all nodes at each context switch. So each nodes's aging walks into
> > each mm's page tables. For an mm with memory on one or only a subset of
> > nodes, the other nodes' walks find no pages for one lruvec. While these
> > empty walks are pure waste.
> >
> > Track per-mm, per-node empty-walk marks: bit N on mm->lru_gen.empty_map is
> > set when node N's walk of the mm found no page for this lruvec, and
> > get_next_mm() will skip the mm on node N between re-scan passes. The re-scan
> > is driven by each node's own pass count (mm_state->seq), so every
> > mglru_empty_skip_gens-th (default 4) pass re-walks all empty-marked mms to
> > close migration/NUMA-balancing windows; keeping it on the node's own clock
> > avoids a shared "oldest marking" sequence latching at the slowest node.
> >
> > A walk is "empty" when it traversed the page tables and found no folio for
> > this lruvec.
> >
> > A page that appears on the node during the skip (fault or migration) is not
> > aged until the re-scan; a later patch invalidates the skip on those
> > paths. mm_struct grows by 8 bytes per process.
> 
> Hi Baoquan,
> 
> As mentioned in my reply to the cover letter, I wonder if this could
> be achieved by the PUD filter instead.
> 
> For example, if we find no associated folios in a PUD, could we simply
> filter out the entire PUD?
> 
> BTW, is this related to memory policies such as `MPOL_BIND`? If so,
> could we inspect the mempolicy to avoid these empty walks in the first
> place?
> 
> I'm not quite sure what the best solution is. My gut feeling is that
> `empty_map` adds quite a bit of complexity, so I'd like to explore
> whether there are alternative ways to avoid the extra code and the
> additional space in `mm_struct` before going with this approach.
> 
> So far, I'm not really against `empty_map`; I'm just trying to get a
> better understanding of it and explore whether there are simpler
> alternatives.
> 
> I mean, I really like your PUD filter, but I'm not quite as fond of
> the `empty_map` approach. :-)

Thanks a lot for your careful reviewing, Barry, really appreciated.

I totally understand your preference. When I found the defect of
mm->lru_gen.bitmap, I was also very hesitant about the final solution.
empty_map is the specific solution, PUD filter is a generic one
while benefit mm->lru_gen.bitmap too. I agree with you that PUD filter
is good enough to resolve the defect of mm->lru_gen.bitmap, and benefit
even non-NUMA systems. Maybe in future when huge system RAM, e.g several
TeraBytes of memory becomre normal, we can come back to consider adding
the empty_map solution.

That said, I will drop the empty_map related code changes and post v2.

> 
> >
> > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > ---
> >  include/linux/mm_types.h |  3 +++
> >  include/linux/mmzone.h   |  2 ++
> >  mm/vmscan.c              | 52 ++++++++++++++++++++++++++++++++++------
> >  3 files changed, 50 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 6d815f6440c9..3738e8877b73 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -1410,6 +1410,8 @@ struct mm_struct {
> >                          * page table walkers cleared the corresponding bits.
> >                          */
> >                         unsigned long bitmap;
> > +                       /* bit N: node N's last walk found no folio; skip until re-scan */
> > +                       unsigned long empty_map;
> >  #ifdef CONFIG_MEMCG
> >                         /* points to the memcg of "owner" above */
> >                         struct mem_cgroup *memcg;
> > @@ -1503,6 +1505,7 @@ static inline void lru_gen_init_mm(struct mm_struct *mm)
> >  {
> >         INIT_LIST_HEAD(&mm->lru_gen.list);
> >         mm->lru_gen.bitmap = 0;
> > +       mm->lru_gen.empty_map = 0;
> >  #ifdef CONFIG_MEMCG
> >         mm->lru_gen.memcg = NULL;
> >  #endif
> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 229d27fbfb54..30213a880db0 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -633,6 +633,8 @@ struct lru_gen_mm_walk {
> >         int batched;
> >         int swappiness;
> >         bool force_scan;
> > +       /* this aging pass is an empty-walk re-scan pass (every K-th) */
> > +       bool rescan_pass;
> >  };
> >
> >  /*
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 92cb83a78971..e8ba49683b28 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2710,6 +2710,14 @@ static bool should_clear_pmd_young(void)
> >         return arch_has_hw_nonleaf_pmd_young() && get_cap(LRU_GEN_NONLEAF_YOUNG);
> >  }
> >
> > +/*
> > + * Cross-node empty walk suppression. lru_gen_use_mm() marks an mm used on all
> > + * nodes, so aging on a node where the mm has no memory wastes a full page table
> > + * walk. Skip such an mm for up to MGLRU_EMPTY_SKIP_GENS generations after an
> > + * empty walk, then force-rescan to close migration/mlock/NUMA-balancing windows.
> > + */
> > +#define MGLRU_EMPTY_SKIP_GENS 4
> 
> Is this related to `MAX_NR_GENS`? Does that mean that, over a full
> aging cycle, we have a `1 / MAX_NR_GENS` chance of doing a rescan?
> 
> Best Regards
> Barry
> 

