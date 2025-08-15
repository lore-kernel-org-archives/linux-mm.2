Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2E35CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200F88E0202; Fri, 15 Aug 2025 13:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9008E0001; Fri, 15 Aug 2025 13:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115F38E0202; Fri, 15 Aug 2025 13:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F04568E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:38:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7605D13798D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:38:04 +0000 (UTC)
X-FDA: 83779700088.19.CC1430C
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf22.hostedemail.com (Postfix) with ESMTP id BD1BEC000F
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:38:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf22.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755279482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+10pdeMQpRINhPqXTKRw/7zBKzUarRO7NvIjYOfl6q8=;
	b=25l7c9B03KG9pq7LrbKx/RqpRSUWisQs6ndVOR4yRjAdTfKa6ugFAES8H9w11zSo/Wwz89
	lWB8hguftcTBr+6lClEjUgHN3Yx26XPaadwX2LyTEMDYU+WLV3RkGVx4DrGYMW6A3Bwka9
	rmRrdngUY63rthXOf2aemhk5xOyLpmU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf22.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755279482; a=rsa-sha256;
	cv=none;
	b=eF0OM+D4mCO5V4/aIkWSsxb7Rv63RRNe6L3H3X0KX3YvcZNo+p0rLiZSX+YJh1uOvt1KE/
	G1cvDyuAS83rLtqz3FfeBg69pWKWJE6iuLkUHbaNp96sDIlfMF1Cwu1AFAI5Px0oAsIlw4
	ibIEZYcNrys7Ex+7EmBzzNdqfk4nqB4=
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4c3TpP1ZcfzYpCvG;
	Sat, 16 Aug 2025 01:37:49 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 16 Aug
 2025 01:37:57 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 16 Aug
 2025 01:37:54 +0800
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
Date: Sat, 16 Aug 2025 01:37:50 +0800
Message-ID: <20250815173750.15323-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <8e20a389-9733-4882-85a0-b244046b8b51@lucifer.local>
References: <8e20a389-9733-4882-85a0-b244046b8b51@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD1BEC000F
X-Stat-Signature: ui31ccfp1qc77jsjdscuqtx8id4symt7
X-Rspam-User: 
X-HE-Tag: 1755279481-23314
X-HE-Meta: U2FsdGVkX1+7JMbqMwJ7m9Z+7lq44WV3wDznJd2EKwtHUG9EvAFqQnb73ZVy5bXC67s0KlFxB4z1UeMjd/AOhSiNY2k+Ub2XAiIHGY2UMRrAIcFM7dowOpVqY72K7SYemPecHpne7IDZZ6si39jrhRVX9UMCjSVPTw4S0pywUKaLfc/Q9LU/lvMRWFeRKB4mcxA+E9gbzdsACo64ZO78fEI4kWMnMAzLqh4I0Zvm+Skawz7glbXdbHZkItsU/ZI5R4niTLG1WPBmX2W/hIRM/MIYcprcePPRe49lm64sC6r5PyDGCnT7pG3QNIn4L+MsNT/Cn5ztOqBmaqPqY4ldR6Dxf07rc95lUVMyBqgYOh4MxH5qYF0EVIex2K5MLOLb77oP92mL4+X/ColbpZGk3o4mmf055aBrvo8Hg7+IwCgHjKJFJMmxL16jYITWwdTEJyk5TfDb/6OZNMB0iHwn6za2SOQQq8NZ53qKlCmfgozRu2d+OvYVbpgiP+xY8LgR29vI33lI//nvXpx3scG/gBbKJB7qGoISAZvynqZPtcsMxknF5GjGuDWU6krHjXdZ/dn2EToST56NApYxW6bh7rck5Ib049YThNqHlSWqzYNk8c/phkj/BbQEDeVc1v2XQRR18LlE3tZH9GssaRZK7p3JmCugMeszv+b0htaRDE4CgMh7w2TFRHUOuRw6288ploA1pt/ncLxLpIUhng+r/HQbpqFVkMJ09+2+2GNks5qa+OOFmnne4TiMLE6Dx2aNCubI8w2AkfCBFgbCOZ3qNrq2thnSPpT9jBvqUA0nC2YsP8eIj84VD8fwj9sHFYa4RMjaEDV3IagFbLq2SqNEKUjdSLEosIhUr8ebZs/4WjF4wmLn2jY2Su6jgLn7U/2ymPYRKWcjWL0yPyRaY6paeTzzi59JutjHmDabR6J4B7O7ml5zBnOgFyXkZxZfRrJPTXa7wYVdw2c/Ixf3Noi
 yH+wi1+L
 IH+/y6JvOQ3Anw4u9OF7cA7PZAfCeFSr/iZJSwo2vxhHbM3OMTRpkErQd3GoMifUgb8Av0r1SzVkqBgnT+dtT8lzulXd0I17ZbvxHYhQylnGJuYZhm3jnDMgQDNe1OVj6vsBlsiN81Bb29RxBi0N+mkvvZ98Jp4pxwyE4dvBSZWu6MISB8n9Mk1CX8MdPcAZhP9rsJtHKxv4kelldWxCvntAH5bIzI1s5rfdZ/uJKsRwckX8oNh3Uh1C+hS4T9elVe7eX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> 
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

Thank you, I will reconfirm this issue.

> 
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

well, Thank you, I should capture a perf trace for the oom reaper, not perfetto.

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

sorry, I got it.

> 
> Won't this skip the first VMA? Not sure this is really worth having as a
> general thing anyway, it's not many people who want to do this in reverse.
> 
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

Thank you, I will reconfirm this issue.

> 
> > +	for_each_vma_reverse(vmi, vma) {
> >  		if (vma->vm_flags & (VM_HUGETLB|VM_PFNMAP))
> >  			continue;
> >
> > --
> > 2.17.1
> >
> >



