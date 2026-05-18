Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05F8CCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 19:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21EAD6B0005; Mon, 18 May 2026 15:33:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6E96B0088; Mon, 18 May 2026 15:33:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134766B008C; Mon, 18 May 2026 15:33:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF2876B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 15:33:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 711CB120A7A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:33:08 +0000 (UTC)
X-FDA: 84781538856.08.7D176FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CFECE180004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:33:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vDmvFmZ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779132786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1vTM5lbdYVRXIADxKQU69lbt/2gkCoNSD5Yln/e78Y=;
	b=psY+QpOzIKlHoVKmZWE8vG4edufq9jcjFyMIDj8AnUf6w8kTf0JXf+HMhCfPPi4TVymaxM
	omkRhqUlHU7/o2K4b4iNPSguOAZ0lNwy+hhnUtyTrzX/4FVF/egb3gp034s8/0+oL+8XIN
	m4v8522wmd1xPohaiB3npGcXhGTNPEI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779132786; a=rsa-sha256;
	cv=none;
	b=UuJ7VA7H3AoEhhEqMp+KozsGKhIol9sfn6U6fE11XmaCWtERTCRQk71t4WczSrw0V6DjsN
	sgEW0Yv/t407e30NrJXaOiyp7yKbaSX2xftxK/IDPObHi1kcOvynFGqGIPzZTEvXkeawgX
	UmgAylxCj5CcRRq6wE/HRhFqCaX3a5A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vDmvFmZ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED4A460123;
	Mon, 18 May 2026 19:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D75C2BCC6;
	Mon, 18 May 2026 19:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779132785;
	bh=YkGCI2ydQOiH18bfYuav9c9v7raj6NjUh/q2u2zqGQ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vDmvFmZ+iTrW6rG0Gcm9nWDPvvRK1Rsj48dFtKprQeQ1e6lYyM5VMFRhBpg8rwS61
	 0TNXTtczIM+BVYe4dk6R82ZVaWwaFbuN+I3al6alVhDH1MljGD3eYqKFw/QXi7Qvm0
	 JKoE6kG5Db51dOjr9Juw7dqsEFy3nED8MYgsGtG2paTjp5kcRM6tNacnnxJWHErq5S
	 M8Qrai0JHOMsBE7ZTTpOx6tIkJOYjnAKZFKHD4doWsSaZi9ZYNp4SbjR5D1f4rsOHj
	 H3beDvWRIUdalnXZNIQ+HM/9w5MnR/fIEerEMaPESJ8Zc3zgsQGlP1eDVwfo09KpCR
	 ofuvouMs7WwgQ==
Date: Mon, 18 May 2026 20:32:50 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, 
	Lance Yang <lance.yang@linux.dev>, npache@redhat.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, 
	hughd@google.com, jack@suse.cz, jackmanb@google.com, jannh@google.com, 
	jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v17 04/14] mm/khugepaged: generalize
 __collapse_huge_page_* for mTHP support
Message-ID: <agtpK1x27B-E7mMo@lucifer>
References: <20260511185817.686831-5-npache@redhat.com>
 <20260512074202.10253-1-lance.yang@linux.dev>
 <20260514031009.f66cgop3ctgiqxz3@master>
 <9b33339e-157a-45b7-942e-3be3418a5142@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b33339e-157a-45b7-942e-3be3418a5142@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: CFECE180004
X-Rspamd-Server: rspam04
X-Stat-Signature: aypdhz6xd39nq1f9qpeintu4fizrkcch
X-HE-Tag: 1779132786-493896
X-HE-Meta: U2FsdGVkX1/kKPBhRoq9f/KbjM0k8VXPm28bkA8jh2mlM9WUwBsABFDWjyapgLdzFUZlO0LbaLoHxI/U2V/bllkAxNCTN4m9EGjQsev0csc4C3CZCezokQytlYWEPxBFC4Sgzf1P9GbiSIqcrHGnhqURQfJABx5IOLZaqcnLChbR2Iy/wBuJc3Hp9I+d6jBzlBDG9GXDHgMmBdBK3WG+hNwL9IBbNqFcKo8gtAEzqBVY+sLia+YHbPf7eRGiYr8nBNIl5JkAHQBXCOJvYh4slFHrXJwgW3fcuWUhQu+Pg58aaliFwIFLEhZsjjbZqMR/EC7l1IxrucSE+n2emM2DRhrUeWnmhRJCSKnKef2yi+0dWyhDxMyOEPYp53BydLrpW16m/jK5ocS+wtOXTjqwYJ1f07++O1FFdAuSv4yy3G7e8Jn0yswfHVTcDL7GHrRNqZHus47jJz3Y/tEKYG7JEc1ImPfAdNxnGLD1nkgw6/sw48ihqOf2RS08qeHSE9k7/RjGkrH5CXzzVgem2tnMoNPpU1fA7D6+XaLsa+lx9CnzmeLEe6uqGQ2WoBI3Q6E1n3W2dHd+z5HDCw3dNO4M7LIlJPeh99gaIeJPIn5VTrDnMjnI/BWN6OVeOUMXnC0k2mSoCoxYz/xuNXtm/n50P7tw+rbYWctnSoSZ5wFKFrN8G4zdMcRUx8ofA8NmtIBQNdzxlmJNEv/FNvgtQJaWnQSDvlNr6ONpxumKAa5giRBBEPwv/OCmypOKwhvfhKGrLHu3PNaAajx+tbXBCFVQfXYZ4kPbzyl8Gat4kbaPHUq2yGPpjoTQ3TupsLe2icvHOuTm33j63JOwRxJxu6LoiazQ6jg0jvbpwVEmhr7idUxGtCzAWfwLYYpGj79u01SO3kV0rGcWoGlRzbj/YoBBUwwZKuLWvYQuH2P4NINXwzUCnuxu73+N/6nl3Whrg4LJh4zNPCE37Ij2r+S31KM
 2ww5DnqX
 2mT4fVt5k5yQR7EqubN43C5lhzTvAYnMUv5P0ulgaWUyJ015Svv+/JDtb7mJR/od8NSg8jqgal2yKCJLfuo7I2HTHd6yIeDqx9uVBoSYzwkDXjIdCaziWc9pQw5cAR26rl3uBpI3/zL3W/uPc7Xn8eiJdk/2bR1e5UvvDmvqMImhEyttViX9s8rL66cwawu2VE7drFvClpF/d1qu+P2bZNyvH8+ou19PtXNpx9WaOwO7bIRc1mma2KPEojQ3yh/AwvJWdqgwtajega0npII7uCCllrvMbwuL5jgeeN4s9WTtWNkmCiPfLIx8rgoLTPKEL8WA+yFVSWIxXkuKKwXpzXw6NF1Mj1jHfWp/tmNwEPtoF9KbhEQti42YmYRK9N+cxQEmeWY0XtfMbQFAzWZIuaVgL80Hln3OXQYzITc470V7vR+kddSF8H0X6L/i2xf390p4N6ORb443qVci+MRJuW97V3LiEf/NhOtVY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 03:16:11PM +0200, David Hildenbrand (Arm) wrote:
> On 5/14/26 05:10, Wei Yang wrote:
> > On Tue, May 12, 2026 at 03:42:02PM +0800, Lance Yang wrote:
> >>
> >> On Mon, May 11, 2026 at 12:58:04PM -0600, Nico Pache wrote:
> >>> generalize the order of the __collapse_huge_page_* and collapse_max_*
> >>> functions to support future mTHP collapse.
> >>>
> >>> The current mechanism for determining collapse with the
> >>> khugepaged_max_ptes_none value is not designed with mTHP in mind. This
> >>> raises a key design issue: if we support user defined max_pte_none values
> >>> (even those scaled by order), a collapse of a lower order can introduces
> >>> an feedback loop, or "creep", when max_ptes_none is set to a value greater
> >>> than HPAGE_PMD_NR / 2. [1]
> >>>
> >>> With this configuration, a successful collapse to order N will populate
> >>> enough pages to satisfy the collapse condition on order N+1 on the next
> >>> scan. This leads to unnecessary work and memory churn.
> >>>
> >>> To fix this issue introduce a helper function that will limit mTHP
> >>> collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> >>> This effectively supports two modes: [2]
> >>>
> >>> - max_ptes_none=0: never collapses if it encounters an empty PTE or a PTE
> >>>  that maps the shared zeropage. Consequently, no memory bloat.
> >>> - max_ptes_none=511 (on 4k pagesz): Always collapse to the highest
> >>>  available mTHP order.
> >>>
> >>> This removes the possiblilty of "creep", while not modifying any uAPI
> >>> expectations. A warning will be emitted if any non-supported
> >>> max_ptes_none value is configured with mTHP enabled.
> >>>
> >>> mTHP collapse will not honor the khugepaged_max_ptes_shared or
> >>> khugepaged_max_ptes_swap parameters, and will fail if it encounters a
> >>> shared or swapped entry.
> >>>
> >>> No functional changes in this patch; however it defines future behavior
> >>> for mTHP collapse.
> >>>
> >>> [1] - https://lore.kernel.org/all/e46ab3ab-a3d7-4fb7-9970-d0704bd5d05a@arm.com
> >>> [2] - https://lore.kernel.org/all/37375ace-5601-4d6c-9dac-d1c8268698e9@redhat.com
> >>>
> >>> Co-developed-by: Dev Jain <dev.jain@arm.com>
> >>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >>> Signed-off-by: Nico Pache <npache@redhat.com>
> >>> ---
> >>> include/trace/events/huge_memory.h |   3 +-
> >>> mm/khugepaged.c                    | 117 ++++++++++++++++++++---------
> >>> 2 files changed, 85 insertions(+), 35 deletions(-)
> >>>
> >>> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> >>> index bcdc57eea270..443e0bd13fdb 100644
> >>> --- a/include/trace/events/huge_memory.h
> >>> +++ b/include/trace/events/huge_memory.h
> >>> @@ -39,7 +39,8 @@
> >>> 	EM( SCAN_STORE_FAILED,		"store_failed")			\
> >>> 	EM( SCAN_COPY_MC,		"copy_poisoned_page")		\
> >>> 	EM( SCAN_PAGE_FILLED,		"page_filled")			\
> >>> -	EMe(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")
> >>> +	EM(SCAN_PAGE_DIRTY_OR_WRITEBACK, "page_dirty_or_writeback")	\
> >>> +	EMe(SCAN_INVALID_PTES_NONE,	"invalid_ptes_none")
> >>>
> >>> #undef EM
> >>> #undef EMe
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index f68853b3caa7..27465161fa6d 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -61,6 +61,7 @@ enum scan_result {
> >>> 	SCAN_COPY_MC,
> >>> 	SCAN_PAGE_FILLED,
> >>> 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
> >>> +	SCAN_INVALID_PTES_NONE,
> >>> };
> >>>
> >>> #define CREATE_TRACE_POINTS
> >>> @@ -353,37 +354,60 @@ static bool pte_none_or_zero(pte_t pte)
> >>>  * PTEs for the given collapse operation.
> >>>  * @cc: The collapse control struct
> >>>  * @vma: The vma to check for userfaultfd
> >>> + * @order: The folio order being collapsed to
> >>>  *
> >>>  * Return: Maximum number of none-page or zero-page PTEs allowed for the
> >>>  * collapse operation.
> >>>  */
> >>> -static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
> >>> -		struct vm_area_struct *vma)
> >>> +static int collapse_max_ptes_none(struct collapse_control *cc,
> >>> +		struct vm_area_struct *vma, unsigned int order)
> >>> {
> >>> +	unsigned int max_ptes_none = khugepaged_max_ptes_none;
> >>> 	// If the vma is userfaultfd-armed, allow no none-page or zero-page PTEs.
> >>
> >> One thing I still want to call out: kernel code usually uses C-style
> >> comments :)
> >>
> >>> 	if (vma && userfaultfd_armed(vma))
> >>> 		return 0;
> >>> 	// for MADV_COLLAPSE, allow any none-page or zero-page PTEs.
> >>> 	if (!cc->is_khugepaged)
> >>> 		return HPAGE_PMD_NR;
> >>> -	// For all other cases repect the user defined maximum.
> >>> -	return khugepaged_max_ptes_none;
> >>> +	// for PMD collapse, respect the user defined maximum.
> >>> +	if (is_pmd_order(order))
> >>> +		return max_ptes_none;
> >>> +	/* Zero/non-present collapse disabled. */
> >>> +	if (!max_ptes_none)
> >>> +		return 0;
> >>> +	// for mTHP collapse with the sysctl value set to KHUGEPAGED_MAX_PTES_LIMIT,
> >>> +	// scale the maximum number of PTEs to the order of the collapse.
> >>> +	if (max_ptes_none == KHUGEPAGED_MAX_PTES_LIMIT)
> >>> +		return (1 << order) - 1;
> >>> +
> >>> +	// We currently only support max_ptes_none values of 0 or KHUGEPAGED_MAX_PTES_LIMIT.
> >>> +	// Emit a warning and return -EINVAL.
> >>> +	pr_warn_once("mTHP collapse only supports max_ptes_none values of 0 or %u\n",
> >>> +		      KHUGEPAGED_MAX_PTES_LIMIT);
> >>
> >> Maybe fallback to 0 instead, as David suggested earlier?
> >>
> >
> > It looks reasonable to fallback to 0.
> >
> > But as the updated Document says in patch 14:
> >
> >   For mTHP collapse, only 0 or (HPAGE_PMD_NR - 1) are supported. Any other
> >   value will emit a warning and no mTHP collapse will be attempted.
> >
> > This is why it does like this now.
> >
> >     mthp_collapse()
> >         max_ptes_none = collapse_max_ptes_none();
> >         if (max_ptes_none < 0)
> >             return collapsed;
> >
> >> max_ptes_none is mostly legacy PMD THP behavior. mTHP is new, and any
> >> intermediate value in (0, KHUGEPAGED_MAX_PTES_LIMIT) would implicitly
> >> disable it :(
> >>
> >
> > So it depends on what we want to do here :-)
> >
> > For me, I would vote for fallback to 0.
>
> At this point I'll prefer to not return errors from collapse_max_ptes_none().
> It's just rather awkward to return an error deep down in collapse code for a
> configuration problem.
>
> For mthp collapse, we only support max_ptes_none==0 and
> max_ptes_none=="HPAGE_PMD_NR - 1" (default).
>
> If another value is specified while collapsing mTHP, print a warning and treat
> it as 0 (save value, no creep, no memory waste).
>
> In a sense, this is similar to how we handle max_ptes_shared + max_ptes_swap:
> for mTHP: we always treat them as being 0 for mTHP collapse (and don't issue a
> warning, because we would issue a warning with the default settings).
>
> @Lorenzo, fine with you?

Yes 100%, this sounds sensible both in terms of the error and the default. Let's
keep our lives simple(-ish) please :)

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

