Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9875FD5F75
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 06:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099B96B0088; Wed,  8 Apr 2026 02:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B096B0089; Wed,  8 Apr 2026 02:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA3186B008A; Wed,  8 Apr 2026 02:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9D736B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:42:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C401160A2B
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:42:27 +0000 (UTC)
X-FDA: 84634444734.14.29F4FA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0622FC000A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:42:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="U/KAz5r7";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775630546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tM7k7VYCqB4z5t3PZyIgrlKJeJsyjYJwYxEKWVfQERk=;
	b=QwlTfzy9esNIselFngxqbfpBWzdcEoX9jXvOBtzr2tQyxk1PU1EZScL/i5dgGEZP0HvKGi
	hn82fpGzKQChhjlJPz2/Dx6yqHSd4bE9LM6RgxZ+n0ZAerA5KFiFYk03UB1uF1HVLVJZ2E
	FyEXbXLNNTKadjwTT/5sx0qCcNCpr5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775630546; a=rsa-sha256;
	cv=none;
	b=PbBWthnAjUecesoyFj5CrCXuinZtm++pmWZJxAvoI5vA3JbClMSNHOS4yojD6wqyX7TinY
	S0luJ2Ekm3aykw1qg9CqI5tgRmsfm7CP3SntqqikcenDLo0DZOcmRR1Oo7SPZ1xewIu9jw
	dACBgH8fTZkBjYWc4NEk6PaGpHjndeY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="U/KAz5r7";
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3CC1360128;
	Wed,  8 Apr 2026 06:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2242C19424;
	Wed,  8 Apr 2026 06:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775630544;
	bh=hew+yMuJllj/CILG+kipSamfxQNTS+u4BKAsnh0Jvxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U/KAz5r784TYMJ5nXnUBiSQNvcv7W83SI2KXHmTgp/Gs7ftNs/tzH0V4nvKfeutOb
	 R51tBfkNTTSjrqaF3xTtyIfveOPMkl9kz0hVus573UjOZ1dYd/ZYeW5EWMwA/jL0nK
	 91ebpbl6GDCBmjUNLHUtU0LA6IihOr+Xl1NZ5DGJ0jsZUTUhfINNyIFdWv8U/8cBzZ
	 kkZNE0vwrCg/sN67ymN3pAfCux7NVAoKkvnaflxIb+zDsX1Te+Nam2oxE151EBFrCt
	 dDTHQjv6JLWK/78L4wJD80J8aHaa0OXky53/ur5lIYdB+b3Lduwd8Vglq7dKSzEuAH
	 pIP4IbOFvaeEw==
Date: Wed, 8 Apr 2026 07:42:10 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nico Pache <npache@redhat.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	aarcange@redhat.com, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
Message-ID: <adX4g9dGN_TNV8_A@lucifer>
References: <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
 <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
 <440d6b8a-d299-43eb-83b5-6625f9468e5e@lucifer.local>
 <37132e09-9c03-4afc-bc73-4bca416c5343@kernel.org>
 <9d5a4703-a15e-4be6-926b-af2d98db40c0@kernel.org>
 <CAA1CXcCYLGQBy9nT-MSTPVK=XgWWtD6Af-QiA_6pXtM_2pybPg@mail.gmail.com>
 <87b83f7b-f0b1-4184-93a0-3b4b574c813b@lucifer.local>
 <20260401133145.90b094a7b87bdceb0013b5af@linux-foundation.org>
 <adTCJ8NQHGNMqR1d@lucifer>
 <20260407144259.011a26666eff9c96d74e39a2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260407144259.011a26666eff9c96d74e39a2@linux-foundation.org>
X-Rspamd-Queue-Id: 0622FC000A
X-Stat-Signature: b1x98ah78kxsnxrnmzb5tqcn69qkd5o5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775630545-98497
X-HE-Meta: U2FsdGVkX1+vkH05PX99faw0bZdwSVKqIDD1qLcf/x3YFbL9mnkAFeVDdKObJRcF9y7Y1JfjpQl4Oc0QoPyzh2ENVKwhpLwkkKy1yJndgovqPOuBuZ1icSwt0Jcq06nd4ssyi8SgJ+Q7yx4CpOkmjbHayemjAMfYXeUK7IGLrhfZL/1yt9+0JbM12ypXT47A1/xAgY76cDbiIKeIq1GT+3ifNZ8PAYhkwcAg+K7gT/c3IIgejuaTgtkJRcDEwzlywsKLHud04ZjNPVThjeYGtoZFWL4qgQNHKHuvVBzpXylSzrK8AN1vOngKlbkEbcqrVSfNeeRgJG/mjcOfQi/uYq6nKE/styaX28Ut4hE9um6mHqPCoB3F/+/7Z35JYN9NPHIiil0RiR+1mzlqNu22Eb0CFsKWMvl+GxCI38FVB/GD2F0V2g9op2m9u6PkZ+P51kPrCy8bEWZ3OLR2Nrf6MsLi7/oh/ytf1vQ2XfIw5M3hT6K8y/E10fbuGvkC2N2U2A3ugsM1seHLRzE1kcMh4jQkDZPT1u2GYaPzKwvnXWBSRoKGeNglWA2HiBh+M2CHt1PkXhIDkX+rBuq/Kyyyt00+ndEO+g3CBy8B2RGkzMrKjSttiUIkqQ9BCtTjxdoRS2ATfcoI4EAP4M+HtaSVQVDosJ9yGOYVRn80kzLyQeS1P8pHlTPp+/iOoHpfdFXQ5YnpRAGaHUNDZYiH5kl6gOB4cwtROqOfpZ65KlDH5n4hcHyJD9LoI47O+KMflhWo9hh8TpickohO9qxVXK+1h4FhBTBA0CkVLSczbxKvd+uaHrN7snwUFPiyNuyJeFu5Rp7F1KvEY/KrEw2prk+aZEDXbpqrzUkLGDJhnURI/Op5HzVeqwH+D6aO8QqyEhrkOKBBcIK+gIVyVFisgkjyQ3ufM1FaHru7qbtEGa2HAS9zdf0nKmIm5th7CuBo9C49LBCT3W6YleqaEvHvCnV
 gKf2CcGM
 MnP9NnEmKIf69pziAjqEhT0aHI1uoIWeawrhmJPvq6bX+q5xffLNHLFXV/ChutiYvJokS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 02:42:59PM -0700, Andrew Morton wrote:
> On Tue, 7 Apr 2026 09:38:19 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > On Wed, Apr 01, 2026 at 01:31:45PM -0700, Andrew Morton wrote:
> > > On Wed, 1 Apr 2026 09:14:35 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> > >
> > > > From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> > > > Date: Tue, 31 Mar 2026 13:11:18 +0100
> > > > Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
> > > >
> > > > We are incorrectly treating lock_dropped to track both whether the lock is
> > > > currently held and whether or not the lock was ever dropped.
> > > >
> > > > Update this change to account for this.
> > > >
> > > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > >
> > > Not sure if I should add this?
> > >
> > > Should it have
> > >
> > > Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse
> > > with collapse_single_pmd()")?
> >
> > (Sorry only just noticed this)
> >
> > I mean we do need this patch, if you plan to do this as a fix follow up then
> > should have a fixed tag, but I do worry about bisection hazard by leaving this
> > as-is.
> >
> > We definitely either need this patch folded in or as a fix that gets sent
> > alongside the change.
>
> I added this to mm-stable a couple of days ago as 5a62019807da
> ("mm/khugepaged: fix issue with tracking lock"), below.  It does have
> the Fixes: so I think we're good.

Ack LGTM thanks!

Sorry was going through old mail after I realised I didn't know how to use
neomutt properly and missed a bunch :)

Cheers, Lorenzo

>
>
> commit 5a62019807da4a7add0717c962ac83b23dd12b2c
> Author: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Date:   Tue Mar 31 13:11:18 2026 +0100
>
>     mm/khugepaged: fix issue with tracking lock
>
>     We are incorrectly treating lock_dropped to track both whether the lock is
>     currently held and whether or not the lock was ever dropped.
>
>     Update this change to account for this.
>
>     Link: https://lkml.kernel.org/r/7760c811-e100-4d40-9217-0813c28314be@lucifer.local
>     Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()")
>     Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>     Reviewed-by: Lance Yang <lance.yang@linux.dev>
>     Reviewed-by: Nico Pache <npache@redhat.com>
>     Cc: Alistair Popple <apopple@nvidia.com>
>     Cc: Andrea Arcangeli <aarcange@redhat.com>
>     Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>     Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>     Cc: Barry Song <baohua@kernel.org>
>     Cc: Brendan Jackman <jackmanb@google.com>
>     Cc: Byungchul Park <byungchul@sk.com>
>     Cc: Catalin Marinas <catalin.marinas@arm.com>
>     Cc: David Hildenbrand <david@kernel.org>
>     Cc: David Rientjes <rientjes@google.com>
>     Cc: Dev Jain <dev.jain@arm.com>
>     Cc: Gregory Price <gourry@gourry.net>
>     Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
>     Cc: Hugh Dickins <hughd@google.com>
>     Cc: Jan Kara <jack@suse.cz>
>     Cc: Jann Horn <jannh@google.com>
>     Cc: Johannes Weiner <hannes@cmpxchg.org>
>     Cc: Jonathan Corbet <corbet@lwn.net>
>     Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>     Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>     Cc: Liam Howlett <liam.howlett@oracle.com>
>     Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
>     Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>     Cc: Matthew Brost <matthew.brost@intel.com>
>     Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>     Cc: Michal Hocko <mhocko@suse.com>
>     Cc: Mike Rapoport <rppt@kernel.org>
>     Cc: Nanyong Sun <sunnanyong@huawei.com>
>     Cc: Pedro Falcato <pfalcato@suse.de>
>     Cc: Peter Xu <peterx@redhat.com>
>     Cc: Rafael Aquini <raquini@redhat.com>
>     Cc: Rakie Kim <rakie.kim@sk.com>
>     Cc: Randy Dunlap <rdunlap@infradead.org>
>     Cc: Ryan Roberts <ryan.roberts@arm.com>
>     Cc: Shivank Garg <shivankg@amd.com>
>     Cc: Steven Rostedt <rostedt@goodmis.org>
>     Cc: Suren Baghdasaryan <surenb@google.com>
>     Cc: Takashi Iwai (SUSE) <tiwai@suse.de>
>     Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
>     Cc: Usama Arif <usamaarif642@gmail.com>
>     Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
>     Cc: Vlastimil Babka <vbabka@suse.cz>
>     Cc: Wei Yang <richard.weiyang@gmail.com>
>     Cc: Will Deacon <will@kernel.org>
>     Cc: Yang Shi <yang@os.amperecomputing.com>
>     Cc: Zach O'Keefe <zokeefe@google.com>
>     Cc: Zi Yan <ziy@nvidia.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d21348b85a59..b8452dbdb043 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	unsigned long hstart, hend, addr;
>  	enum scan_result last_fail = SCAN_FAIL;
>  	int thps = 0;
> +	bool mmap_unlocked = false;
>
>  	BUG_ON(vma->vm_start > start);
>  	BUG_ON(vma->vm_end < end);
> @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
>  		enum scan_result result = SCAN_FAIL;
>
> -		if (*lock_dropped) {
> +		if (mmap_unlocked) {
>  			cond_resched();
>  			mmap_read_lock(mm);
> -			*lock_dropped = false;
> +			mmap_unlocked = false;
> +			*lock_dropped = true;
>  			result = hugepage_vma_revalidate(mm, addr, false, &vma,
>  							 cc);
>  			if (result  != SCAN_SUCCEED) {
> @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>  		}
>
> -		result = collapse_single_pmd(addr, vma, lock_dropped, cc);
> +		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
>
>  		switch (result) {
>  		case SCAN_SUCCEED:
> @@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>
>  out_maybelock:
>  	/* Caller expects us to hold mmap_lock on return */
> -	if (*lock_dropped)
> +	if (mmap_unlocked) {
> +		*lock_dropped = true;
>  		mmap_read_lock(mm);
> +	}
>  out_nolock:
>  	mmap_assert_locked(mm);
>  	mmdrop(mm);
>

