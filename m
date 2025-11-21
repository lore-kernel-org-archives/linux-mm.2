Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FCBCCFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 06:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551E16B002B; Fri, 21 Nov 2025 01:58:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529CA6B002D; Fri, 21 Nov 2025 01:58:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 466DA6B002E; Fri, 21 Nov 2025 01:58:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 375576B002B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:58:19 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07AD4B9A3F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:58:19 +0000 (UTC)
X-FDA: 84133710318.06.96E2AAD
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf10.hostedemail.com (Postfix) with ESMTP id A39EBC0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 06:58:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763708297; a=rsa-sha256;
	cv=none;
	b=2YERZKU0hA3dpKWc8gDxEvd/V7rUsqxO6DwfNn+IdDdeI4hx8GQNDD2YIySWGiAFcGx9sp
	sAO4ySgTQHksj326uzv2P9/6vrNuEsyZRYBuLqTYffSEkToPqiklpBxdMoPkEidKiDvF/V
	25U8/hef7OaMop9AA9SXxHR3ypr4WWc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf10.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763708297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fqtZGj1XLaLvaccq2TnQ0mr9nAyR5QMhHonQJQQLcJ4=;
	b=pp/Mnw39GwFgt2LxT9wfO9ZaoCJi5RNQKyUIVErTC9i+RVxNI3+ld5QtQyoH0Q2DXr/uod
	uvl5jXgI+xNdDB9pWE2H3A385JMT3O2M5O+33Y6RhPFbXCIB+sx1wvAIpE8mkgyMaSOOvW
	dS77mNFdyP8sW+S4WNwqYdjCFqKEv6g=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 21 Nov 2025 15:58:13 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 21 Nov 2025 15:58:13 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/19] mm, swap: consolidate cluster reclaim and check
 logic
Message-ID: <aSANhZC3sMUFxYuc@yjaykim-PowerEdge-T330>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-10-37730e6ea6d5@tencent.com>
 <aR65k5Xxl28MvMcf@yjaykim-PowerEdge-T330>
 <CAMgjq7BREEfVxET=xDU32=K4j_qps1ccmozvw3_X3CnVqHxFKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7BREEfVxET=xDU32=K4j_qps1ccmozvw3_X3CnVqHxFKw@mail.gmail.com>
X-Rspamd-Queue-Id: A39EBC0005
X-Rspamd-Server: rspam07
X-Stat-Signature: sxsgn7zk7uhfmmzfrwadhze1kgr646d3
X-Rspam-User: 
X-HE-Tag: 1763708296-977224
X-HE-Meta: U2FsdGVkX1+4nd+hhvD6gUsD3Ny+2Kd7eq9VTdNTFOQswiEGv73sFm1fMoVj7GFmvH2iEyat0WacwTwfimRBAqyCtJzlKq0DujhmMOTCWIr05x6K8xhpfUYlV1/MGvZ/ndLFS1tT9cFz4VNRLhW9e3bIZP8RpM3lx17uhmEpEz6FjSaNSmB5nCC6pulRNv90PJuhQwvc5HVqmQDIXAa0W+j9wya5TPiebCU9vc9+9bVl7F2wME1an1FZs+KkgBlT+CS3uycZsq3xAAdhLM+qIRIVJDBGVCKNVS+oEnBgtDoy+mHJIdzT5WsaQMLzMHoa6L3EtrPLdFER0L0NPmEDHWr/81BfMg6SGoXiT3jI57E3EMPFwQn+eLY5MAzzGUQgmH/8h6gMIoq6oW1O9eqejGw/JkY3I4oQhkOEuMlNGKRU3toslESRgMc8l35unbz9qImK1YfuwhLIZz0kQdhEjdsPV3gPUUVSILjx9GGbqmVBymQyLu+bWhCwSSmGiXDYDOtHPOUFbgUBxJ4lCxzi9uEf6KQ/vr/vgz+QM9WYWy/zKAErjgHltVxqlDePv/BOPPJnz9kXGOHrNbV5O09PT2BJCfsLT7utEFv1LUCVr9DYGSffDt0e+/l3oK0Mr/Qf2vjAEAi+56XDPcl0ZEFs9JrAULVkeQQIN9xo0TieXb0pywe8Zy/OgCHbRmtq8Jo3mNLVKyiPHfltxKsx2IcIpem+lZQ4z+Ot1gtGmfnbEK9lIvypCbdXH7f4BRKMvvFk2moNlvZF5fK1gnBWT4eHRUowRpwf4vul0db5LQsp+xUa9+CCKG+cndZy9Kl136getgJ0zx/Ocf2TwiGNwHcaCq3vkIO8sBb4mZ2bfRnyCtCSSlDCEM9pn2+Dfi5Y0Ebb8cym5hgI8Q+g1RCj+wgaQ/f8cSN63X4tDFnmfLXXRpeMZnWS1q9rRsPbEXZ8oQQYnyY4MY1KwUgjq5EIvgN
 w26zu5o/
 XOB61AvxOHYnW7eh8740sLD4SwqA+rzmAqjEMLl40sS0K96zTd7FEBVpInnoAzMhfeAJpI3K4twW3SBI69lUogqHcj0CsgTvunhqMMCo0v4s2Hwp8ewtKW/ekvfeRPME6eQB6OBtD8jzJN046WI9xkPCVOA+3bjOkkjRrzIAaYCStasYV+o410WJI9r9IrdILc/GAqqEtSzZNM0Oy0ZY4b50kmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 11:32:37PM +0800, Kairui Song wrote:
...

> > >  static bool cluster_scan_range(struct swap_info_struct *si,
> > > @@ -901,7 +909,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
> > >       unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
> > >       unsigned long end = min(start + SWAPFILE_CLUSTER, si->max);
> >
> > The Original code. I'm wondering if there's an off-by-one error here. Looking at the code
> > below, it seems the design allows the end offset to go through the
> > logic as well. Shouldn't it be 'start + SWAPFILE_CLUSTER - 1' and
> > 'si->max - 1'?
> 
> You mean the `offset <= end` check below? That's fine because the for
> loops starts with `end -= nr_pages`.
>

That's right! I missed that. Thanks for the clarification

> >
> > >       unsigned int nr_pages = 1 << order;
> > > -     bool need_reclaim, ret;
> > > +     bool need_reclaim;
> > >
> > >       lockdep_assert_held(&ci->lock);
> > >
> > > @@ -913,20 +921,13 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
> > >               if (!cluster_scan_range(si, ci, offset, nr_pages, &need_reclaim))
> > >                       continue;
> > >               if (need_reclaim) {
> > > -                     ret = cluster_reclaim_range(si, ci, offset, offset + nr_pages);
> > > -                     /*
> > > -                      * Reclaim drops ci->lock and cluster could be used
> > > -                      * by another order. Not checking flag as off-list
> > > -                      * cluster has no flag set, and change of list
> > > -                      * won't cause fragmentation.
> > > -                      */
> > > +                     found = cluster_reclaim_range(si, ci, offset, order);
> > >                       if (!cluster_is_usable(ci, order))
> > >                               goto out;
> >
> > This check resolves the issue I mentioned in my previous review.
> >
> > > -                     if (cluster_is_empty(ci))
> > > -                             offset = start;
> > >                       /* Reclaim failed but cluster is usable, try next */
> > > -                     if (!ret)
> > > +                     if (!found)
> > >                               continue;
> > > +                     offset = found;
> > >               }
> > >               if (!cluster_alloc_range(si, ci, offset, usage, order))
> > >                       break;
> >
> > I think the reason cluster_is_usable() is checked redundantly here is
> > because cluster_reclaim_range() returns an unsigned int (offset), making
> > it impossible to distinguish error values.
> >
> > What if we make offset an output parameter (satisfying the assumption
> > that it can be changed in reclaim_range) and return an error value
> > instead? This would eliminate the redundant cluster_is_usable() check
> > and simplify the logic. Also, the consecutive "offset = found, found =
> > offset" is a bit confusing, and this approach could eliminate that as
> > well.
> >
> > What do you think?
> 
> That's a good suggestion indeed, I'll try to make the code cleaner
> this way. Thanks!

Great~ I look forward to seeing the updated version. Thanks for
considering the suggestion.

Youngjun Park

