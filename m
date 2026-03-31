Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F58B109B471
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6B346B009B; Tue, 31 Mar 2026 10:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C216B009D; Tue, 31 Mar 2026 10:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0AD56B009E; Tue, 31 Mar 2026 10:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABA476B009B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:16:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11E3F5728B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:16:10 +0000 (UTC)
X-FDA: 84606557700.14.5A5AA93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 48CA74000B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:16:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SNboa4Y6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774966568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cspgg8gJ1YN7XmBWMIm4W8AdRfzO/zMnHSiWsvcBAcM=;
	b=Gu7MF78+GYlkOTLLEvXlcfRp++l8m4lQ+yXsn9OkLrXMhcZHNIKdL9jMgd/Kjvsw3Cp0kt
	egV3FVINV7UkWv6I9RRwmyPWBcXff3TWRIRZI9lH9HnmJZLgTUh3pFPz+YJz40MvESMXo8
	+qPhKKf+uNOEsLORJyZ1GT7NU1goScU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774966568; a=rsa-sha256;
	cv=none;
	b=edaC0t5H72Rei2g+wJvIooRBfw8y68BNaofygkGCE8+BOCfGuGH6omWiyTzvdzQC5RIWsK
	T+ZtVqbopid4TjvQh/KhI2/NB2IVWdTJjhdramHMVwjdr7q4rtMHvGddCl/NTamxgPDtM5
	jj/FBzum6jualVvf8JYdSeqppASamZ4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SNboa4Y6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A652260126;
	Tue, 31 Mar 2026 14:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54175C19423;
	Tue, 31 Mar 2026 14:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774966567;
	bh=P+JOMuhq4U1b2iThGkPhI7G7/g5oR6RU6sBz2YvQW1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SNboa4Y6IqQh1zqNeRcApl01cTc/UNKo3mGYLne8KJIgI4EckiJMCfe/Igf7lVlmF
	 01/yN8Vd/oc7QZ4dTEEuR1WlMwmkcqxhJc30YrV79BR6hPZYJCcYf42xHLoYcrhAxk
	 QUetGq35k6EnEZVu0VwdC6JAiExy7n4q5zf17laIIToknXPDOnyDFLchaVRsQPaVjD
	 lC9pkeEMIid+OmmRRBBksTmG8pwNgBqE0qg0ToVcdR3hSKbeIw2jM/ZCQ3588Uw4+5
	 vDLoXtcpwJcsI+9cFgnigzUN0ueIgApPvzjXCIRuRLS7ROcpSeBs3ztHwVWnAcMpnO
	 3riO/udH1Ra3g==
Date: Tue, 31 Mar 2026 15:15:56 +0100
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
Message-ID: <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
 <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
X-Rspamd-Queue-Id: 48CA74000B
X-Stat-Signature: ygz877c4os8f9atdeqyzagnjh5bdmpjr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774966568-231840
X-HE-Meta: U2FsdGVkX19GkhR2vO7gx/ZYQOzz8nkDtIP9szA8DqQSE1GNQZrNvIoUMkdgaNKX6aYHF7RvNxp/ri9IHNuQOFRFF6qjhISTqttfo3xLsA8OBreu/HPNZwvys1Lf9SuurRypfTSymPU5f/5a+rDuBw+RnvZiF+qcpY+AsAdT9logMbTQZ4PaM6txBk4UP1NC/RofSnvg94dZmoEv2jc/Hwq4sxXfz7Ash09TlFfD7MxlTwkvzbQ5OiqLQf01+IJkPjWfK/swwZxcuUwL2tA28cfks+HI7F2Z4v0TRfwN65N+dVODTl478P8MkSgH2tFzr0h+VFGi8zGozkHlyGss+QjfPjhJUWikYfBv+O3O5xC6SOkq+fBcY97i4mYXtEtJhwbM5/5i51mwiBLUIvpzS6MJKwlJbsFJTsN7ygQjR8/FgpGMQI+9DtMb/FdLqallSUksFlscpnafO5zadFpgmNF+/pSq4WFLWXCbbyrP8qs8kgdqvZx99C0zDsM5e4a8Vzq3PGAZ3Qz/X8sYKyMcdxr8AeKdDjX70vRFF6T+qiSeLzdYt8+7oWNHMlOSczmuBQI5mD3lIP2rjOeSttgiFK3bZuJe0oL+zRLsD8u97rhhCMLu+W7ntjwEk6riKkKDHFGrRSCOMEFlBxMk/FkaBnkNZsWUpGRUpAB6mcF+KWq5durLXg656IgzH9hjJ8iOxJymngxN3uondoIPH5w/C8BrUqki3zINpfwoFDJF7nB2Pxy1y0RQd7j19ZoNZUDHOlUGQemMglqeX89eITDq6iKvl3EcA0VAEqtN8DtXa1CJYmFrmwlZw3yP6+RMpiNaPMa99UZjeeeUAZdDziApvkccYLJb+aPvLk3nYGkmo+/3t/k5vBmps44OZWKtWBl61CwG18omUxdAhMFumdKIiGnvk3FZb7R+2aGtIHztiU8M/U6ZhdGw0UX8aeq7D2hg1a6LAA2AAzVBIc8h/KD
 6zjFt7UP
 ttEA7zZ1EVyNyMdnYHCD7KzKWKrUpUqPzub0r+g6yUNfCy4o/sRrLLuB8fWcZrP27qUkja33xf22pREcs7WneVqrAO9jLFp+iYjqpp0PEz3xUkf0D6jMJzLt4KD/LtPHzHdp70hEYCgJjqcV7KE346p7SejF5hWeY+v29GN1+gKP8i5ocjsoTAlWZ+lJcWSfMUZwDW6w9fh+Aft331A9hmm3vX6xMuQdu1zZyCLYPD+lpquui2hKH7jPS/IdFBY+JKyLfXE4TaoHYgr4gl3skOaQOaVhiSbrFLB7leZGFi8fpR/N4vHPP7Fj07SDz6yPRhvlY4mda3GPhk/e00CkCF10PMVDhy5qVA07f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 04:13:29PM +0200, David Hildenbrand (Arm) wrote:
> >> +		if (*lock_dropped) {
> >>  			cond_resched();
> >>  			mmap_read_lock(mm);
> >> -			mmap_locked = true;
> >> +			*lock_dropped = false;
> >
> > So this is the bug. 'lock_dropped' needs to record if the lock was _ever_
> > dropped, not if it is _currently_ dropped.
>
> Ah, well spotted. I thought we discussed that at some point during
> review ...
>
> Thanks for tackling this!
>
> [...]
>
> >
> > ----8<----
> > From a4dfc7718a15035449f344a0bc7f58e449366405 Mon Sep 17 00:00:00 2001
> > From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> > Date: Tue, 31 Mar 2026 13:11:18 +0100
> > Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
> >
> > We are incorrectly treating lock_dropped to track both whether the lock is
> > currently held and whether or not the lock was ever dropped.
> >
> > Update this change to account for this.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  mm/khugepaged.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index d21348b85a59..b8452dbdb043 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >  	unsigned long hstart, hend, addr;
> >  	enum scan_result last_fail = SCAN_FAIL;
> >  	int thps = 0;
> > +	bool mmap_unlocked = false;
> >
> >  	BUG_ON(vma->vm_start > start);
> >  	BUG_ON(vma->vm_end < end);
> > @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >  	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
> >  		enum scan_result result = SCAN_FAIL;
> >
> > -		if (*lock_dropped) {
> > +		if (mmap_unlocked) {
> >  			cond_resched();
> >  			mmap_read_lock(mm);
> > -			*lock_dropped = false;
> > +			mmap_unlocked = false;
> > +			*lock_dropped = true;
> >  			result = hugepage_vma_revalidate(mm, addr, false, &vma,
> >  							cc);
> >  			if (result  != SCAN_SUCCEED) {
> > @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>
> (in hurry so I might be wrong)
>
> Do we have to handle when collapse_single_pmd() dropped the lock as well?

That updates mmap_unlocked which will be handled in the loop or on exit:

		if (mmap_unlocked) {
			...
			mmap_read_lock(mm);
			mmap_unlocked = false;
			*lock_dropped = true;
			...
		}

		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);

...

out_maybelock:
	/* Caller expects us to hold mmap_lock on return */
	if (mmap_unlocked) {
		*lock_dropped = true;
		mmap_read_lock(mm);
	}

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

