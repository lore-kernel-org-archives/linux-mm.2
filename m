Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BDBCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 644B36B03D2; Mon,  1 Jun 2026 10:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3C06B03D3; Mon,  1 Jun 2026 10:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E20F6B03D4; Mon,  1 Jun 2026 10:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 386356B03D2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:35:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D55251C09F2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:35:52 +0000 (UTC)
X-FDA: 84831592944.12.C8D5BFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1EFD018000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:35:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZYC69qu/";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tYOOpvy9IkMZmwJi6amy7zUop+0VBeSC22/cOh/2QJw=;
	b=l8BMPSI+5iSPRmzXhma+4HdwseYDRA/U8Rcy05TguRWu409nZvz4V6y2pDX0itDR5ILxYT
	oHDqdr/SRagre6wWEyisRYx8eY2dPCOL5XaqQl9hpbPyaaP2bGknGZBEHlhhU3b/Oythqh
	nA2DScJVr+kr5mwevrO8MTisUfeePFc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZYC69qu/";
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324551; a=rsa-sha256;
	cv=none;
	b=MXiotk5sYI4Kyj9uWibKN3UtJdaktonYxnfZpmJBKIDSHnMLBN1x0SRyadNvQ2/XYTKihD
	/Imu6WmoDyp0fQwHL1aFrbk3Rn5mw8IxemTH+hecIpmYH7TBikYPomxEYRsPUJ9uFLbCJx
	8jBX/EKZtKunClHmnDq0F4Xl+aYQoiE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DEC242D73;
	Mon,  1 Jun 2026 14:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E93B1F00893;
	Mon,  1 Jun 2026 14:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780324550;
	bh=tYOOpvy9IkMZmwJi6amy7zUop+0VBeSC22/cOh/2QJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZYC69qu/CF9Gne0HL5HBrmA8/pzxabQLTF+YrpZEVBUNIzPQ1W/hUAkrxAMdOvJ5u
	 nERvqAIkhWNvzPn7WmgBDQStrasNyXBPZuCje2J4ksp3Y3rjjHV2nyEe5tLrnF8pGe
	 E3v7Ezg1LNwZ5hmDVltmBNckcIAVQTQyiZy7TI0VESefwi/orLXZoXtWnl4qdWLwqd
	 W2yLpGG9p47NxTV7MMalaw+DLrMRiBDZnRbqDyGjGeOL6ST5M7AWoAuCkxGhOf7wTA
	 UyrJ6zw4DT6Q8SBcCTwkE2xtbQpk+Q3Zju/GbdPrgYB/nGfnBbtNE/DccLJP4smclf
	 vzd6q1MNqigtQ==
Date: Mon, 1 Jun 2026 15:35:35 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, jack@suse.cz, jackmanb@google.com, jannh@google.com, 
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v18 10/14] mm/khugepaged: introduce
 collapse_allowable_orders helper function
Message-ID: <ah2UhZb9EYgYxj1F@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-11-npache@redhat.com>
 <b7ddff01-9adf-4ff7-84a6-021087936c34@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b7ddff01-9adf-4ff7-84a6-021087936c34@kernel.org>
X-Stat-Signature: 8bwsukpmbhhafymdf3jxfxbnf15oxo9b
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1EFD018000E
X-HE-Tag: 1780324550-710176
X-HE-Meta: U2FsdGVkX18JqxONCza+1zbTqQdizyVjxzCAKCRQhG2JohAMIIa7RddOCzaAxkM8zRdPa8ZblGiY2vVEQifcqkm8pDCXxVfTI4aGq0QBEk5uH0Pnm05Qlqa1SX/XVocymVwuCT1HkxNb+F4G1ITLT3aRrEN1nfW6hXTq5dIpTyVSceiGUIU0WoA5evjgJXNc7Mir2gpcImNlJdTEnvL9fYrneKh/+l9ncUD2wKwKVG8QW4xf02Hn86cb1vesB8fz1m1ExuWHHxjbLY3NSgfRrhuVq1+sqP5QQ9tdNxDU10fNpS9s4K+fltlHhhAYzWjGgCVbXoRsv3xX/6PlyPOUQZ2JgmKaZScjFsdnaHXhLDqX/4I+SDV5fRQAuAhEzfHEolNJomzLW4pE1oKCKh0vGgEXiUmCHcMOaHvuW0p5YMlbgjxog0ctNQjjc7+pqXw2bVO2uZsn0u6LKQCAdciPolFidj0N5bpkgWKJnCghEDIIYTu84kMtVojjCXTXxeaaVZ4P1D0Hs8FsPE7VtSF7PcsEJKzPC/RYHuIL0Kk44SOEtuHVDeLqVm11xPBMFADxZxNUIUqM3kE+IJaiE471vJO3oGXIja1b3nTApZZkI2B6FYnCvG6dYzacWwHuxQRZGrzAb8DiJSdSN/qw1BSQED2KEIeKg/JK7HzkbA3UhmGZB2+fFt+p5pQfq+czvhmTQz7fmWrDxYa93SfLwlRAlWykgL0Db+KdxQMzJPE/XzUDvVASC5+HEiKnDRbn9G2VPalQT7C399vF5GQBckhzC8laQ38eDUldxNaybbwlDaH0aMhtuoT5zeUwuKKz9xlZItYq0yirmO5fIDHrVjKprvaTEfIQIzQidZKKS/LGIVh2bbXkWldzqpWyQ40kR3Rtmu/5AtW2/Nej64AYm4OCBic7Ynqn7G99fVq7tyC5ibtpNaG6CR/8W8nJzSqDLGjBVw3geyZ/66eNhEQNy9h
 XisETy4n
 lP0kVT7SSnyPGr5ARcOlI6chW+gFgtYXfSB72JfT0M/DWQ5B2OKU2ZZgnpXFAqFfNaDgzaQpk2NGbKBsrvz5zok2+c0nATCk1kj/d9mJU6SlgqYyLDzUAWAqWrsb9OQLPyr04nE9y5Ygva/UgBILxeC2MmLD+ROsWkx7fzUrJVW6hrZuDehnBfyU4TFr+vrmN2Thy+sAoaEOnkCUMGi8W7/6A9gmMSytwu9kCSKoSy/J1YBgkBYy6xSIUgusyYyVldV3djRv18DkWTG7yBbBtsdx0TgqmQDvNzExebvDoSlQQLa4bvtv58VOoZbo/O/epg/+jgoV+pwB3MgxltuMM/oGCSFsz7YpcZvJDbHIemyu/C1XKBbSBklRWc9XBh41ma+Dv8DQltxtEVZKdbdBq2KdJnm+l0Dktq9uOI987E8D4Lg+IpgRzB++AyM4sKJLhMy6t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 10:18:16PM +0200, David Hildenbrand (Arm) wrote:
> On 5/22/26 17:00, Nico Pache wrote:
> > Add collapse_allowable_orders() to generalize THP order eligibility. The
> > function determines which THP orders are permitted based on collapse
> > context (khugepaged vs madv_collapse).
> >
> > This consolidates collapse configuration logic and provides a clean
> > interface for future mTHP collapse support where the orders may be
> > different.
>
> It would have been good to describe here that, for now, it only ever returns
> PMDs, and that it will be extended next.
>
> Logically, this patch belongs to #12, not #11 ... so seeing it before #11 was a bit
>
> ... and there, it is clear that we don't even want to know the orders?
>
> So can we just call this function
>
> "collapse_possible" and make it return a boolean?

Yeah agreed.

But I also don't love the naming, we now have thp_vma_allowable_orders(),
__thp_vma_allowable_orders(), and then collapse_allowable_orders() and we also
have 3 different ways of collapsing, one of which we call MADV_... COLLAPSE,
and the other khugepaged + fault-in too for laughs.

It's like a big circle of confusion.

And of course we call THP collapse 'collapse' in general, so :)

Anyway I'm fine with collapse_possible() so we can move on and then maybe
cleanup later.

Also - if I look at khugepaged.c I see thp_vma_allowable_orders() still used in
hugepage_vma_revalidate().

Wouldn't it be better then to do the abstraction once mTHP order checking is
properly introduced and change this also and have _every_ order check be
consistent in khugepaged.c?

>
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 15 ++++++++++++---
> >  1 file changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 4534025bc81d..64ceebc9d8a7 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -552,12 +552,21 @@ void __khugepaged_enter(struct mm_struct *mm)
> >  		wake_up_interruptible(&khugepaged_wait);
> >  }
> >
> > +/* Check what orders are allowed based on the vma and collapse type */

I'd expand this comment to explain that it's explicitly for accounting for
whether mTHP is used, but that also argues for this to be moved to a later
commit as David says.

Otherwise the comment is useless.

> > +static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
> > +		vm_flags_t vm_flags, enum tva_type tva_flags)
> > +{
> > +	unsigned long orders = BIT(HPAGE_PMD_ORDER);

Could be a const also.

> > +
> > +	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
> > +}
> > +
> >  void khugepaged_enter_vma(struct vm_area_struct *vma,
> >  			  vm_flags_t vm_flags)
> >  {
> >  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
> >  	    hugepage_pmd_enabled()) {
> > -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> > +		if (collapse_allowable_orders(vma, vm_flags, TVA_KHUGEPAGED))

I hate that we separate out the VMA flags like this just for this case, but
that's something for a follow up probably from me as part of a VMA flags
conversion series...

> >  			__khugepaged_enter(vma->vm_mm);
> >  	}
> >  }
> > @@ -2680,7 +2689,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
> >  			cc->progress++;
> >  			break;
> >  		}
> > -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> > +		if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
> >  			cc->progress++;
> >  			continue;
> >  		}
> > @@ -2989,7 +2998,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >  	BUG_ON(vma->vm_start > start);
> >  	BUG_ON(vma->vm_end < end);
> >
> > -	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
> > +	if (!collapse_allowable_orders(vma, vma->vm_flags, TVA_FORCED_COLLAPSE))
> >  		return -EINVAL;
> >
> >  	cc = kmalloc_obj(*cc);
>
> Having a simple
>
> static bool collapse_possible(...)
> {
> 	return collapse_allowable_orders(...)
> }
>
> Would make the above slightly more readable.

Yup.

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

Cheers, Lorenzo

