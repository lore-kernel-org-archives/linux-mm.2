Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF05CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 15:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7278E000C; Tue, 19 Aug 2025 11:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF8E8E0007; Tue, 19 Aug 2025 11:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5A18E000C; Tue, 19 Aug 2025 11:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC0898E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:18:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7791DC032F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:18:47 +0000 (UTC)
X-FDA: 83793864294.29.069746F
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf11.hostedemail.com (Postfix) with ESMTP id D246C4000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:18:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf11.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755616725; a=rsa-sha256;
	cv=none;
	b=8lx94KQWRdx7EbGw3KWbqFrMAYU0Xu+iSm7mzGMryS+ZBB/lOl2YIlguE/Y0DnnSKCxPHx
	BhmpSx33F7aZfHKr3EIbUPejRjsQmcIP4JgRiswpDspTlfAq5WWQAHzeNZKHBMc+VF9cbU
	4VDAqj9omCNX3nUk+uQja8eiVTtUey8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf11.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755616725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q4ZBoVbBJZaI0PzdtiZxnCPKlwJGPH+XPFt5E88b53c=;
	b=Zli9Via6Gt8mV09ScbRooGAUoelgbepLLVF8qhMtVKWQqauxXG2NMIUwAv/0B2BTDVnJ00
	UXxRskY1eRkFRTve+qIa8bGn5hmX5mZwRrIOv7eC+E6qK6TnmlN4++0GEwKJzdmbo4c1fK
	iPX5pVfXIttqOJmSa+3EsDiQ8q5oJjc=
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4c5tWm0mcszYlXBY;
	Tue, 19 Aug 2025 23:18:28 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 19 Aug
 2025 23:18:39 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 19 Aug
 2025 23:18:38 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <lorenzo.stoakes@oracle.com>
CC: <akpm@linux-foundation.org>, <andrealmeid@igalia.com>,
	<dave@stgolabs.net>, <dvhart@infradead.org>, <feng.han@honor.com>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <liulu.liu@honor.com>, <mhocko@suse.com>,
	<mingo@redhat.com>, <npache@redhat.com>, <peterz@infradead.org>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <tglx@linutronix.de>,
	<zhongjinji@honor.com>
Subject: Re: [PATCH v4 3/3] mm/oom_kill: Have the OOM reaper and exit_mmap() traverse the maple tree in opposite orders
Date: Tue, 19 Aug 2025 23:18:34 +0800
Message-ID: <20250819151834.20414-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <8e20a389-9733-4882-85a0-b244046b8b51@lucifer.local>
References: <8e20a389-9733-4882-85a0-b244046b8b51@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w012.hihonor.com (10.68.27.189) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D246C4000B
X-Stat-Signature: 716db9dumrh3h447xbcjid39fs5x5jo8
X-HE-Tag: 1755616724-559656
X-HE-Meta: U2FsdGVkX1+yJepRU8/GCCF8gXaxENRCCK4QsDKrbfhZGS+SZSNTY/xbwZgnMBgdjU1k29wZnagT1hNcNlb1XsuN9Id4guFncxDuerz3OrCNxW3Cn8o3p/NIPDr4VTj5SL9Uw5ctrJM7Vqf6AWv4RwvQQirWQrTLqvNgsUQ0NdfXmmQNcAN+lN6NjYsIgV0lgD4NCXsr6BeV7IQGZAz2aJD0W1UuB5v4ktRJjzDHyikoUZTJl86CV8+xMKBh/YDLnY59/TvNcQhCcEhWMRi1cuu9UyzFc0AzoSw/Y+9/HFbfsw1epHFDE/ZBLOgqr9NNyJXvif/7QfXTKjlJE4IVrXvB17fIHizwV2e35s/OI6btxAwX1UbfY7O6JSCP5aoG+25bsK1AC6uClH0o4Z6FLju7TdrVWpld9xOJ4O0jTWT57JyB6HGWor6jG4mQjDGld6+u3ISR3O7scg7G0aVn/KLq6LPF/iujwHt2Siu0lYghs7ZIrjBl6+FY+ASo0X/v5ns0MYFEk6GJWsugMht0MQVYzD2cvpSsk3sOBaULZPrx/pDuL4Ynoq634wrI+rrpLFPXM1cDpGuRsAWQW7MjnvYKx1//aC6hvT5AOuM/bRcxzoKKSdcLL8Xtq8FNFaP9mJXVp8zVQblMzeQc/CnXoOH0gfXw+hkDbFpBokZtcvLxP/uMS/Zj1cyRCznONxKn0DcmOOAdsziFWToH+FKuskS2+mJpvPwP+9gNoxOvRL+cfHMuq6EMFoxLlkapf5FNtP8bx611S5bcMssQrwY3yoGZ44t2u58uF1LySEOSTNogl24SOrA2E2JT8DTkAK2qiYeI2ZN/TBLvLsPC/+IlLtepbAdaGUlcpVB6VouEtoQx/zcIPZyXPZBbI+udLqNVq4GSEyGsS0wo2WfvXPbjsMYX34OJdg1Yib6uRl9tp4U6PCvKe6xvJJDsErAB1mYk9+9wLI+hR4olwW9FZ+i
 7ct3T95n
 Wx5UHYTUBB5hXuDDw68V2mYbwvtpxjfva5QewqicTIrieYO84mEwYYfjN1CUqrI+oPbc2vJMPv/K26WUhb5m2Im4xDzUAEbMP3dPdwLXOuOln4qyQ3IyAjFERxzCF//aptx5SlOqQkXrWATLMsu+uS51BsPPmrodzZojEdYS3sqKk/I54odIeZ8jgE8FMKlp4DCxhi8HXgC011A6KphWncIZ+JiTyOJH8bngJJH2A+oCmYKYGk6cY+08mdwVvPE1y3ISW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Thu, Aug 14, 2025 at 09:55:55PM +0800, zhongjinji@honor.com wrote:
> > From: zhongjinji <zhongjinji@honor.com>
> >
> > When a process is OOM killed, if the OOM reaper and the thread running
> > exit_mmap() execute at the same time, both will traverse the vma's maple
> > tree along the same path. They may easily unmap the same vma, causing them
> > to compete for the pte spinlock. This increases unnecessary load, causing
> > the execution time of the OOM reaper and the thread running exit_mmap() to
> > increase.
> 
> You're not giving any numbers, and this seems pretty niche, you really
> exiting that many processes with the reaper running at the exact same time
> that this is an issue? Waiting on a spinlock also?
> 
> This commit message is very unconvincing.

This is the perf data: the first one is without this patch applied, and the
second one is with this patch applied.  It is obvious that without this patch,
the lock contention on the pte spinlock will be very intense.

|--99.74%-- oom_reaper
|    |--76.67%-- unmap_page_range
|    |    |--33.70%-- __pte_offset_map_lock
|    |    |    |--98.46%-- _raw_spin_lock
|    |    |--27.61%-- free_swap_and_cache_nr
|    |    |--16.40%-- folio_remove_rmap_ptes
|    |    |--12.25%-- tlb_flush_mmu
|    |--12.61%-- tlb_finish_mmu


|--98.84%-- oom_reaper
|    |--53.45%-- unmap_page_range
|    |    |--24.29%-- [hit in function]
|    |    |--48.06%-- folio_remove_rmap_ptes
|    |    |--17.99%-- tlb_flush_mmu
|    |    |--1.72%-- __pte_offset_map_lock
|    |
|    |--30.43%-- tlb_finish_mmu

> >
> > When a process exits, exit_mmap() traverses the vma's maple tree from low to high
> > address. To reduce the chance of unmapping the same vma simultaneously,
> > the OOM reaper should traverse vma's tree from high to low address. This reduces
> > lock contention when unmapping the same vma.
> 
> Are they going to run through and do their work in exactly the same time,
> or might one 'run past' the other and you still have an issue?
> 
> Seems very vague and timing dependent and again, not convincing.
> 
> >
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> > ---
> >  include/linux/mm.h | 3 +++
> >  mm/oom_kill.c      | 9 +++++++--
> >  2 files changed, 10 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 0c44bb8ce544..b665ea3c30eb 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -923,6 +923,9 @@ static inline void vma_iter_set(struct vma_iterator *vmi, unsigned long addr)
> >  #define for_each_vma_range(__vmi, __vma, __end)				\
> >  	while (((__vma) = vma_find(&(__vmi), (__end))) != NULL)
> >
> > +#define for_each_vma_reverse(__vmi, __vma)					\
> > +	while (((__vma) = vma_prev(&(__vmi))) != NULL)
> 
> Please don't casually add an undocumented public VMA iterator hidden in a
> patch doing something else :)
> 
> Won't this skip the first VMA? Not sure this is really worth having as a
> general thing anyway, it's not many people who want to do this in reverse.

I got it. mas_find_rev() should be used instead of vma_prev().

> > +
> >  #ifdef CONFIG_SHMEM
> >  /*
> >   * The vma_is_shmem is not inline because it is used only by slow
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 7ae4001e47c1..602d6836098a 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -517,7 +517,7 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
> >  {
> >  	struct vm_area_struct *vma;
> >  	bool ret = true;
> > -	VMA_ITERATOR(vmi, mm, 0);
> > +	VMA_ITERATOR(vmi, mm, ULONG_MAX);
> >
> >  	/*
> >  	 * Tell all users of get_user/copy_from_user etc... that the content
> > @@ -527,7 +527,12 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
> >  	 */
> >  	set_bit(MMF_UNSTABLE, &mm->flags);
> >
> > -	for_each_vma(vmi, vma) {
> > +	/*
> > +	 * When two tasks unmap the same vma at the same time, they may contend for the
> > +	 * pte spinlock. To avoid traversing the same vma as exit_mmap unmap, traverse
> > +	 * the vma maple tree in reverse order.
> > +	 */
> 
> Except you won't necessarily avoid anything, as if one walker is faster
> than the other they'll run ahead, plus of course they'll have a cross-over
> where they share the same PTE anyway.
> 
> I feel like maybe you've got a fairly specific situation that indicates an
> issue elsewhere and you're maybe solving the wrong problem here?
> 
> > +	for_each_vma_reverse(vmi, vma) {
> >  		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
> >  			continue;
> >
> > --
> > 2.17.1
> >
> >

