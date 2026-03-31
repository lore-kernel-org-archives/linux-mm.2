Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05DDC10F92F2
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B796B0096; Tue, 31 Mar 2026 16:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BE96B0098; Tue, 31 Mar 2026 16:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20ADE6B0099; Tue, 31 Mar 2026 16:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FCC56B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:06:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4DFE140331
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:06:46 +0000 (UTC)
X-FDA: 84607441212.18.ABA7D2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id E1EC44000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:06:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GkDOVQGi;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774987605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=45ucLCwZWebAyzkkUgviktgDH0AV2FNreDLugkmF5GA=;
	b=mf68Abs0vLru5u1sam4pXZ2/EVxJh9KVzrmOZRZRp0VW6M3F3r48prgG8k7ggFa9TfMtSf
	m8vt1mI1psvFQalMbYn6kbFRB4vgSrPdXYfXAnPdVlE4BALqj4nCeUQBOka5+RPMCnBr4s
	7JC2ek9IjOEfImBpGh7ycKLYaIN87cE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774987605; a=rsa-sha256;
	cv=none;
	b=k/I0sRpCAm/ltixH07KQrLzzfUm7sTeLyqPNaPL/eL7QcDw3Q5nKpYeShfIlthREJEwZJZ
	Ex6A9TX6t18ArDStYDcQ+wZ+LLzojRumaIxPACqxlrccHtvXnuKcVxLw3RnkA8qAo8U9ik
	pLdDzyDTDdydprOqFceAuRLnb/m6DBk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GkDOVQGi;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE4044376C;
	Tue, 31 Mar 2026 20:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911C6C2BCB0;
	Tue, 31 Mar 2026 20:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774987603;
	bh=KabC0Or5uXagKoB0Q8zePzNEvjLSg6+mr+qSUuEcW9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GkDOVQGijiYAfBZ5fT2rU6iC7mMAnJF3Zg3lk1KrOMYnGUQTpiLp1pq6d3jHY9B7M
	 ky/yN5Ky10qZVy68U98IDwjnlIClc8iwGBHIfrJ+b9XGUrE0bQDspTML5gdDm7Hs5T
	 LOdelE40N+ln0/eh5sq3RfiUz6UGtfEp/kLV/8pP7HwXpWmVj54KXHzf+03HcfXHSa
	 gV2YOIKV0S7/itS3irmnD32F8P4VNxgsug8YiS1R3NPov/aoLN7JCrU0AXfSgubkVZ
	 D28OqAdbTskExpirD5MRyG3NZDC8cYvq5ARxMXYKkAU+mGJS7/l90ISH/zzZk5RU36
	 gYBUWcRi3aD5g==
Date: Tue, 31 Mar 2026 21:06:30 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, aarcange@redhat.com, akpm@linux-foundation.org, 
	anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
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
Message-ID: <440d6b8a-d299-43eb-83b5-6625f9468e5e@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
 <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
 <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
X-Rspamd-Queue-Id: E1EC44000B
X-Stat-Signature: e1h9px8qycsbpnao68qi96ynrcezcngz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774987604-126257
X-HE-Meta: U2FsdGVkX18cXngIQa0JUcuYqPqNnPFlet2X8fBEsDTRr7FFcJ+FMF2/mrWKxDMd3nO3gaKOWbV+jViKNWihxhNTloYNygc8L8FI52G1xMdGRXM6LAfX4Oe2EIN9e0svu/3sWA6uXkDMc81w8Kyk3tGMjwpDr/DYF5fvTyuZJSrqIirfzKtl5DOu4lbpynjy54sUSbr/f2eGjJvdYpQzPWI7i5TSmGOiTMs6hqsq309KKwcO+efEj4vpyXfgB6ken5xBHy0Xmlmuc7h64fYjM5Z+j4cRQBRW2BbGSvqWPpUuefekvQSRtd68zKl6MJ5y2+FsplLpC8BjHX9dvcZk3pBURv+5RneipWzibmE08c+tfXssGJJCP8/H+GZMtbVfRh8HnWlgU420aiEG6Jm6oDOt4W5KW/KWXZAn2t5P2yrRNdKKtD5yO84UHQpIh08MZS3ZrKT6J5ZhcUIxpw8u+oor7gXScKWrDobk7pDeSVdr+rHcE8uSM4X6QFmdKuEGYy0G2RH6Jt9J1c1Hau1MJ5zRtvoJkzgBycB8NGuAvqyRvlR05I5ZPp4EIKkoqWsjuhdfyG+BBlC/GGV2McUWc2cXS1MMSzFbswD4FhvCoV9j/E/kALs9d39wJduQ0DmXSoCoSVclf+Z0XBrL0KDLWKIzCHEdIepV1KmfPiLhqSYzgZONpuELmPeQEY1p0LjGE/EoVmkujnLSMFqlO9VyZx0j8qwmPWg+iKMnzf9SlHdb7/xdekk97az5kvWid07865QM4dg2z04hhl0Xx04HsbO3GlX6vmvonKlGKOYcYceTXQDUDAiPXYG8+z5E9TEsXHrL89Wmd2pQg/3FWnEixdoEAXF9ntBvEfwBTxikHY5eNP3KCK0Ip9ESDSVmAeTFbOZu1qNxZ/gz4mdCgGkzHDt6zByl5jRli5tOmlE15b4lRqMoJQqO+Pz5JuGW7FbjOYsw+Fr+UoGKO045vRw
 6OPBvKiG
 vQf0g8ohAHmWSZbB1XsEjKqoCbhBbCyk/8V896aUN58aKuteNil7y5jvHBqzzr0BPDC0zKc3xt0gsGN8n5qZteqgGzDGyaAUVGQY7pFnGV++cgcXg6tSBvvA3APsS+kdaa2O8PlgFeKzqlfH2oSczp7I84r1qi43l08ueoChGLS8yKUtKVXOzT0Py+nYBbMxF+k4IWUWdIdpGTxgmn4/55PoVO0HVatUhmIV94taphnMVEUQZxAgQnvlSnvl30lKr5qdp7Htn3vvwx3Ob7r0lyqFdbMTS04PA+t5L3uHR6EYHkKdX0i3V6OAE4yCd2JhEipjMvtOtf15/Er0QtQDdzFEOMh9PsEnqS+7O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 10:00:58PM +0200, David Hildenbrand (Arm) wrote:
> On 3/31/26 16:15, Lorenzo Stoakes (Oracle) wrote:
> > On Tue, Mar 31, 2026 at 04:13:29PM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> So this is the bug. 'lock_dropped' needs to record if the lock was _ever_
> >>> dropped, not if it is _currently_ dropped.
> >>
> >> Ah, well spotted. I thought we discussed that at some point during
> >> review ...
> >>
> >> Thanks for tackling this!
> >>
> >> [...]
> >>
> >>>
> >>> ----8<----
> >>> From a4dfc7718a15035449f344a0bc7f58e449366405 Mon Sep 17 00:00:00 2001
> >>> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> >>> Date: Tue, 31 Mar 2026 13:11:18 +0100
> >>> Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
> >>>
> >>> We are incorrectly treating lock_dropped to track both whether the lock is
> >>> currently held and whether or not the lock was ever dropped.
> >>>
> >>> Update this change to account for this.
> >>>
> >>> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >>> ---
> >>>  mm/khugepaged.c | 12 ++++++++----
> >>>  1 file changed, 8 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >>> index d21348b85a59..b8452dbdb043 100644
> >>> --- a/mm/khugepaged.c
> >>> +++ b/mm/khugepaged.c
> >>> @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >>>  	unsigned long hstart, hend, addr;
> >>>  	enum scan_result last_fail = SCAN_FAIL;
> >>>  	int thps = 0;
> >>> +	bool mmap_unlocked = false;
> >>>
> >>>  	BUG_ON(vma->vm_start > start);
> >>>  	BUG_ON(vma->vm_end < end);
> >>> @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >>>  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
> >>>  		enum scan_result result = SCAN_FAIL;
> >>>
> >>> -		if (*lock_dropped) {
> >>> +		if (mmap_unlocked) {
> >>>  			cond_resched();
> >>>  			mmap_read_lock(mm);
> >>> -			*lock_dropped = false;
> >>> +			mmap_unlocked = false;
> >>> +			*lock_dropped = true;
> >>>  			result = hugepage_vma_revalidate(mm, addr, false, &vma,
> >>>  							cc);
> >>>  			if (result  != SCAN_SUCCEED) {
> >>> @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >>
> >> (in hurry so I might be wrong)
> >>
> >> Do we have to handle when collapse_single_pmd() dropped the lock as well?
> >
> > That updates mmap_unlocked which will be handled in the loop or on exit:
> >
> > 		if (mmap_unlocked) {
> > 			...
> > 			mmap_read_lock(mm);
> > 			mmap_unlocked = false;
> > 			*lock_dropped = true;
> > 			...
> > 		}
> >
> > 		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
> >
> > ...
> >
> > out_maybelock:
> > 	/* Caller expects us to hold mmap_lock on return */
> > 	if (mmap_unlocked) {
> > 		*lock_dropped = true;
> > 		mmap_read_lock(mm);
> > 	}
> >
>
> Right.
>
> The original code used
>
> 	bool mmap_locked = true;
>
> If the fix get squashed, maybe we should revert to that handling to
> minimize the churn?

Well collapse_single_pmd() and all descendents would need to be updated to
invert the boolean, not sure it's worth it.

>
> (this is not in stable, right?)
>
> --
> Cheers,
>
> David

