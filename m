Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F7F1C5DF9A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 16:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970586B0095; Fri, 21 Aug 2026 12:41:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9215B6B009B; Fri, 21 Aug 2026 12:41:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8373C6B009D; Fri, 21 Aug 2026 12:41:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6331A6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:41:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 595E61601F9
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:41:54 +0000 (UTC)
X-FDA: 85125843348.15.41549EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BF7FB140003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:41:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMud3xQq;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787330512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34Su/I9rz3BnICZOrzMkpZ5mtIBm7aPDtUnt6JfY/Rs=;
	b=dzHpDkc8HAnanacS+807olhkxGsObAdE0l8AN4D6JZvWhmCtIMnD9RQHklhSAkWJMllJLu
	2ibI5rqYbPSI8+gkZMzqdx0GBfGktOGbMOt89ej7oGiMQgKorL13QO2zTaQndqKYJLGk8b
	dWPjw2WzfV0mdhJR8lKtHojSngBlcm8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GMud3xQq;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787330512;
	b=JMH7u8TuTH9VdK6NN4yiWHidoucrcAae4HGfQZN6doyVtTuzFJXRc+6eS/3L22vczJ4tti
	hrv7Mxp2RxMCydgMJr3ZPMY5XygYPqANlJiu6lZeCOLCHrsT+rGv/HtpJAAS+9lzY6DT4f
	p+PBMUpo3ib+75239XojEVGcPD4s0Rk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C1AA600E2;
	Fri, 21 Aug 2026 16:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE2A1F00A3E;
	Fri, 21 Aug 2026 16:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787330511;
	bh=34Su/I9rz3BnICZOrzMkpZ5mtIBm7aPDtUnt6JfY/Rs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GMud3xQq+L+cnRIFXzW1KK7vR8GGpFHzhvsg9UKHx/hUQDNNI4W7qHFL+MEigbxsf
	 L7/7XBt1HJb+ZOPcQ8i7hP74H9BcY1FQsHAPLqO8UcNjAsK6noUdeKr7uAXjkzGrxg
	 AnUdtuggETdjutxQujo820lC6eIgdJDIfxke4Ly3NayUU25ver6udtvct01Srwcb5Z
	 QHbBeOBG3/Pz+VxsS72VAAyYBPFP7SKPanLrYiaoTd8eySEy4YlKem+O0Ic/jx5025
	 DtiOAnR57HdQQt9VVgdRNwzIOWLULbxcH3T3opfVnbyCXA57VsV9vbWQ7rX7P+ahLi
	 VUTXpK/AGuGNw==
Date: Fri, 21 Aug 2026 17:41:46 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Ferran Duarri <ferran.duarri@me.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: thp: default defrag mode to defer+madvise
Message-ID: <aoh_eq4NlxwaVUbl@gremlin>
References: <20260820190825.221308-1-ferran.duarri@me.com>
 <DKU1PF6DM6NN.YOF6NN3OWQUF@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKU1PF6DM6NN.YOF6NN3OWQUF@nvidia.com>
X-Stat-Signature: ki9in8874n3yjttuacpxiqjub37ogaih
X-Rspamd-Queue-Id: BF7FB140003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787330512-981126
X-HE-Meta: U2FsdGVkX1+NPxSLkpZMLAM9S3NJEuWZ2uQWiuHrLHVlSUFZLNeudmWyjXgf1cjMtE3GGmFYxPFMiqiWt2LNg6Ki58fWSCm47n/+8VmurdiOXpGYcoCnwq/FP7YDrUcu18/SuMTfsIdO9wcWGcHCYA1NpxSnNg4AcLfS0ojzEDzz4TJ2ERAkl/gLEZMxftmYB2SM5JWNiU69EZ+eATWzPYpPlLB8VYkfpFtSYLo8M4R9bR8/mM54KM5Ic1NbQZdAEpDUFgWvc7j11hMXKaybR5oVgwuB9IfNjxhsLhbG8mPQKfRQqr7S/eKRFQuZnnf3Dn73E15PcCy3Je+Ct2ksIyOJ+stlE1K54bODZlM+4l5qOzFezPDZM/mHh7TKDxUWnod5lCkDOE2K/DXDEKnHVDSHcei5+sS87AMtNp4Tl1DsTrcZ2Jmrmwy4+Qp/qYy3MM+7Gf5tuF6ujR42M0oSvvRcYSiJ/UiIrLvfKKnzz/YP7UiDVXU9FsYq1Q598CoPJsq7JXcoez9UzrkNC48pC56CgcD4nX12MDEgsws9hgGlaRW24SzdFPXq0bN/QyVTV65D0NtCfi0jqTV0HeDw+cewQKruCt3egSVvcIWMo5hvrWVpO+2HE4IoxjReI0rl+QRxunq/wam+9IhDgFF//PKqN1IR0XYcMuSX4Ir+CPValF5EWMrK8UUmj9y0javNjG4sPmzMOUqrMS9ArnFxzn73BPpN/KoQr5d7Drv5+sK4lzXexSKxz8O9Rq8VbIU5JhA8S9tgshhdG3U449nQaeLbJQ1N1/N4lu+pYMvz1vHyb71ZtygrxP3lavfJd5cVZGE68fFtJu9GVqSjeVlJVQYIYxQdtF3mFbsgtUqpv1TLI8zmENyl/aYh7bfqZiFrXygBbVYef/+u8fSOaT6UYIVvugoRk1w3XQD3Oj8AG5q7i6uOkzkoGnhZ11cK1t+s2EPz4iuhp/yC6GvWiGY
 Dp+/PPeN
 x8rKdmCMutqKQJJyF0WG9A5elU4HTtY8TEL600KhT77Kr9JN9fhK4vJPvjnLLXBmfjtYoR9X/QuPa1XVb7ohI1BKHsRRO3y/bB3m+oQmztD2YQFRyaCz9WgfEOxXJ6IM8D/enOSxeUE9/maung+6GAfJD8MaxRBuNdfSNsVu2ypS9+pCqQYP2CN1bj2ZQepi9OHj+3e6QcLVtJ2STQ7lCOTm7brMpWJveUGw8VRqYtBOyY/ghrj8aoemTbLpZgysCFZKYbqyZkFYF6cwwdF1FyOk1RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 04:15:30PM -0400, Zi Yan wrote:
> On Thu Aug 20, 2026 at 3:08 PM EDT, Ferran Duarri wrote:
> > transparent_hugepage_flags unconditionally sets
> > TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG, so the built-in defrag mode
> > is always "madvise" regardless of which of CONFIG_TRANSPARENT_HUGEPAGE_
> > ALWAYS or _MADVISE was selected. Those Kconfig options choose whether
> > THP is applied by default; they do not express a preference about how
> > hard the allocator should work to produce a huge page, yet the defrag
> > default is pinned as if they did.
> >
> > In "madvise" mode a fault on a MADV_HUGEPAGE region performs direct
> > compaction in the fault path. Paired with transparent_hugepage=madvise
> > that is a bounded cost, since only regions that asked for it are
> > affected. Paired with transparent_hugepage=always every anonymous fault
> > becomes eligible, and under memory pressure the faulting thread can
> > stall in compaction.
> >
> > "defer+madvise" keeps the same set of regions eligible for huge pages
> > and the same allocation attempt, but on failure it wakes kswapd and
> > khugepaged to compact in the background instead of doing it inline. The
> > fault proceeds with small pages and the region is collapsed later. This
> > is the configuration long recommended to users running THP=always with
> > large anonymous working sets, and it is a strictly weaker stall
> > guarantee to make the default.
> >
> > This changes only the compiled-in default;
> > /sys/kernel/mm/transparent_hugepage/defrag continues to accept every
> > existing mode, including the current "madvise" behaviour.
> >
> > No stall measurement is offered with this patch. On the machine that
> > prompted it the fault path never reaches direct compaction at all:
> > thp_fault_alloc is 60682 against thp_fault_fallback 0, and compact_stall
> > is 0, because memory has stayed abundant enough that no huge-page
> > allocation has had to fall back. That makes the box unable to testify
> > either way, and a number gathered under those conditions would measure
> > nothing. The argument above is a correctness one about which knob the
> > Kconfig choice is entitled to set, and it should be judged on that.
> >
> > Signed-off-by: Ferran Duarri <ferran.duarri@me.com>
> > ---
> >  mm/huge_memory.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index b118bcd392cb..749f669cca56 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -63,7 +63,7 @@ unsigned long transparent_hugepage_flags __read_mostly =
> >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE_MADVISE
> >  	(1<<TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG)|
> >  #endif
> > -	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG)|
> > +	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KSWAPD_OR_MADV_FLAG)|
> >  	(1<<TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG)|
> >  	(1<<TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG);
> >
>
> +Johannes, since he said Meta heavily rely khugepaged to make good use
> of THP, he might give more insight here.
>
> The patch adds additional kswapd/kcompactd work when a system fails to
> allocate THP for non madvised THP-eligible memory regions. If the
> system's CPU utilization is high, kswapd/kcompactd can take CPU
> resrouces from others, right? Performance numbers are needed to justify
> this change.

This patch is completely ludicrious so not really worth considering beyond the
moot discussion points.

People have seen really significant issues when changing this setting, it's very
sensitive, and distros can set as needed. :)

But maybe there's an interesting discussion to be had?

>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

