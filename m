Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB7DD35157
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A741D6B0089; Wed,  1 Apr 2026 04:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A255D6B008A; Wed,  1 Apr 2026 04:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93ADF6B0092; Wed,  1 Apr 2026 04:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 815C56B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:17:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2CE8CC6968
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:17:35 +0000 (UTC)
X-FDA: 84609282870.10.4235176
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A9236100002
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:17:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xouf/Qy7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775031453; a=rsa-sha256;
	cv=none;
	b=77RocR9TAWm02b9Tzg3oHdmo5XFy3019lkG0V9T/OaWTmnkg0x/ZpIj6JbwQq2KC1RsDo6
	fPUh+u3gCBz0skj+8YRDabYwpjY01uJJMtNnVUPogq9v7ih3GRawBQc1lnEQv+Au2elxhW
	QLYxGR49A1kasJHq3vAWjd0hrX6FDT4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xouf/Qy7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775031453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uiCKNu+0fsGWEP+vtJDcyL0C+4drAeM5niFdrnj+lMw=;
	b=VripL9wpYQvKDeuC8jMVmFAJ4u/ktULJTtnNGH6Q7Cez/Ymg/Mu4KVWQ83WEiTUbjQTwby
	WqVKqelVU3YoLcCjLAf4rjUO2AtyhWamzelMj6Xlv6fRiXcQkG7Woza4u7/rlmejkJ0mlS
	tSZn9az94U8Ch1/FrRuHsLzhkrBDu8w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 10EDA600C4;
	Wed,  1 Apr 2026 08:17:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A0AC2BC9E;
	Wed,  1 Apr 2026 08:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775031452;
	bh=ZrZ0N0xKXR6C9RhW5WxZulhizSQSbcnecFJKI8W6SqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xouf/Qy72TBTDz2ReUXOIudIpg4FJ4N8n8mFM2mqYRs3SQw/ELMh9ZlQVKLNf4s4j
	 AtAPP2k+6PIg0Q8am5+9adyIJ1+zPp8kmA9LyYhBrsVXpt9UgTYH+QugQj1Tze+e4N
	 Vw6PPxeo/FWNcHZZOvcfxkIBsPqFPgFDt3eRfzEqiLn089UHbv+0NRnbyuFGf3JX+9
	 zNP0JbF54xE/8tbrlhV4yqik/5V8czyZ0uzQ7kgjUEAxVgNF35MldUQqKTDXzhyWo7
	 qC5NOzvPaAtralcqjwL/eLq2Zxw0kOfXxeY4ggzngtCJweDzk+I86o2FoE6JHG5oxF
	 vZFBY7PHgt7mQ==
Date: Wed, 1 Apr 2026 09:17:19 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Nico Pache <npache@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
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
Message-ID: <f6c8be02-f11d-4b33-a00f-f1796bcc08a8@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
 <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
 <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
 <20260331143538.f41a5fef4201a7384388f31c@linux-foundation.org>
 <CAA1CXcB8D9o=5EC2dbL8N=o9p2WqrHnugoGYmwUvLh8n=w5p=w@mail.gmail.com>
 <1cdec848-4822-402d-91fb-50237488aec3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1cdec848-4822-402d-91fb-50237488aec3@kernel.org>
X-Rspamd-Queue-Id: A9236100002
X-Stat-Signature: unbd98xoog73odmetoahjtbr5tzgnn9n
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775031453-233633
X-HE-Meta: U2FsdGVkX1/SMya0TfOXFxIldntreLM4/Kh7aaR9eNcHMNTXWchj+nNWZrQpEbsaM5jVVm6ecwoC3us5PJAo0HHHxiYPNW6hz3c9mz37IOdpTyern5lUX2KaUPKO5F8G3q5c3fzp2oC3jwV4tBA3NspW5/FlF9OLwp57v+VtrbWorAn4yy1o4cKxMJXIoE670K771kemyQZMECvParFROymVoTVu5hRQoMJ+qT4GcN96KDswmDXeXGdoSlqBjb0Kli8thVJbxx0GQpLxtgHSiwAHwIvCMTJjNJf8an6eAfo6kuyit0SWL7tXmuqBvP7z2kPGqQg6+He7pw+2LWeqd4V+E9YFHJAVT1FFj9kJIM1jYUqCa5vVPBZJ1HdcHp3oI+qF8Hr+Qzs5UmQIoD/fRGO2AATQ9iQwJw7jpWffH45SpVB9wG6VfMvFnR6At4F3n3CsGDaWVWR7Y4eKX2Y6dErEkf9IUL3tKByGcs649bRRd3wLLKD6E6nbCrv7zEVwn2FH+Yf6B3BW2yHL324QN2wOAbMVbEoAZWNoRYdALQpTUCx7FsDhncR7EQ6ECRN1nDwG8h1Zr52bLs5IDjlX2eIKjuS/yFXHL9rwE8TxXa+rJ7QSar5tF0nVS7oqhCe7TZ0mOHqqHHrTAjKt3HYwpNttvox5R/HeaF13OGy2JtNH/Ndpa4EIzooJM996Vp99vzOUb3ig9Z6q1csjyBvfR4vw06CNHDAldwOAh/K91qEIL6nPq3zbRbidJttM9VgrcZu4CYMNbFnNvmBkYRJ4YK9deJNWec/lO8wuKaf2dgq0yMMfVavfiZbFjNofCoEjrhB2ESMcOQFe1giWYLlkB4fyVMvXFd46I3hJbxGPMOMRWF2Ol9NDOPjiQKavlZLg5yW7NyhdCLwgBupSGd4bdGTStAQYMow25nUla5Rh/RXw5m3Gsq6A34+9bfb/6xGAut0GGcb4a9lKsn5GgkU
 Nvs8avjQ
 ajOrYSTrr6UfNeEwAqgBc4xtoRDXQHKhcKae4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 01, 2026 at 09:05:39AM +0200, David Hildenbrand (Arm) wrote:
> On 3/31/26 23:49, Nico Pache wrote:
> > On Tue, Mar 31, 2026 at 3:35 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >>
> >> On Tue, 31 Mar 2026 22:00:58 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> >>
> >>>
> >>> Right.
> >>>
> >>> The original code used
> >>>
> >>>       bool mmap_locked = true;
> >>>
> >>> If the fix get squashed, maybe we should revert to that handling to
> >>> minimize the churn?
> >>>
> >>> (this is not in stable, right?)
> >>
> >> "mm/khugepaged: unify khugepaged and madv_collapse with
> >> collapse_single_pmd(): is presently in mm-stable.
> >>
> >> Doing a big rebase&rework isn't the done thing, I believe.  So queue it
> >> afterwards, add the Fixes: and tolerate the minor runtime bisection
> >> hole.  It ends up looking like a later hotfix.
> >>
> >>
> >> Below is what I added to mm-unstable.  I added a note-to-self to check
> >> in on Nico's question at
> >> https://lore.kernel.org/all/CAA1CXcCYLGQBy9nT-MSTPVK=XgWWtD6Af-QiA_6pXtM_2pybPg@mail.gmail.com/T/#u
> >>
> >>
> >> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> >> Subject: mm/khugepaged: fix issue with tracking lock
> >> Date: Tue, 31 Mar 2026 13:11:18 +0100
> >>
> >> We are incorrectly treating lock_dropped to track both whether the lock is
> >> currently held and whether or not the lock was ever dropped.
> >>
> >> Update this change to account for this.
> >>
> >> Link: https://lkml.kernel.org/r/7760c811-e100-4d40-9217-0813c28314be@lucifer.local
> >> Fixes: 330f3758a3bc ("mm/khugepaged: unify khugepaged and madv_collapse with collapse_single_pmd()")
> >> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> >> Reviewed-by: Nico Pache <npache@redhat.com>
> >> ...
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >> ---
> >>
> >>  mm/khugepaged.c |   12 ++++++++----
> >>  1 file changed, 8 insertions(+), 4 deletions(-)
> >>
> >> --- a/mm/khugepaged.c~mm-khugepaged-fix-issue-with-tracking-lock
> >> +++ a/mm/khugepaged.c
> >> @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_stru
> >>         unsigned long hstart, hend, addr;
> >>         enum scan_result last_fail = SCAN_FAIL;
> >>         int thps = 0;
> >> +       bool mmap_unlocked = false;
> >>
> >>         BUG_ON(vma->vm_start > start);
> >>         BUG_ON(vma->vm_end < end);
> >> @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_stru
> >>         for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
> >>                 enum scan_result result = SCAN_FAIL;
> >>
> >> -               if (*lock_dropped) {
> >> +               if (mmap_unlocked) {
> >>                         cond_resched();
> >>                         mmap_read_lock(mm);
> >> -                       *lock_dropped = false;
> >> +                       mmap_unlocked = false;
> >> +                       *lock_dropped = true;
> >>                         result = hugepage_vma_revalidate(mm, addr, false, &vma,
> >>                                                          cc);
> >>                         if (result  != SCAN_SUCCEED) {
> >> @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_stru
> >>                         hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
> >>                 }
> >>
> >> -               result = collapse_single_pmd(addr, vma, lock_dropped, cc);
> >> +               result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
> >>
> >>                 switch (result) {
> >>                 case SCAN_SUCCEED:
> >> @@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_stru
> >>
> >>  out_maybelock:
> >>         /* Caller expects us to hold mmap_lock on return */
> >> -       if (*lock_dropped)
> >> +       if (mmap_unlocked) {
> >> +               *lock_dropped = true;
> >
> > Hmm this was =false in David's example and = true here? Now i am also
> > confused hahaha. It seems Lorenzo's code is correct. I think i
> > responded to my own code changes, when I thought David was replying to
> > Lorenzo's.
>
> I think I messed up that in my posting when manually applying :)
>
> So this here is correct.

Yeah the fix-patch on top made it all confusing :)

FWIW :P I also had claude do its thing to check it on this, and it gave the
thumbs up.

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

