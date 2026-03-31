Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 355D710F92FB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F14D6B0092; Tue, 31 Mar 2026 15:59:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8456B0095; Tue, 31 Mar 2026 15:59:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904366B0096; Tue, 31 Mar 2026 15:59:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA106B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:59:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 368A0588E5
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:59:26 +0000 (UTC)
X-FDA: 84607422732.02.4229310
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8C8D1180011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:59:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k1aYxgRT;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774987164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lz/xF3KDwLbN6aQz3ePSnr6PbDtYU/vbc24DbciYYWE=;
	b=03+rD+fGdEYCmRKX1UTeBCfg/f49QA1guY45bLQFnFWmoH27i+Go+ymbNDRDPFByzrNzKy
	Sejt0rPEv0navKw8pn8bal9q+4sxzzuUZVP5VQKfO90qLVEk4QeK6TRW6OPvRky7ol6exb
	NxMTN9ogDt+rWaROilOFCHWM0AMLxc4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k1aYxgRT;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774987164; a=rsa-sha256;
	cv=none;
	b=Bkrr+kWnqo565z1MwmtYeRiEgw4GSqnmboqR2kfJofSBEbbyqa2ggx7J6u07Ne3m9I9gTD
	atZ23Ctu4hwBhSJPF/AIX6sdTXvsyz5TXefxLy5fV+L8eF7TxSow3bHA4StaDyQcR2L3c2
	jwkmCrYCs3UuVuDt2TXK4dJX0fIi7LU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E444960139;
	Tue, 31 Mar 2026 19:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B49C19423;
	Tue, 31 Mar 2026 19:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774987163;
	bh=LxmMKzf7AC255UJDZa3vjLah4nTY2GHIEayHmzfCNyU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k1aYxgRT++QNPITYjQqA9vhZIEjuCZ3w0zUX+YIrWF49Sp7bpST99vgbN0FXofsVO
	 rmdnAY7cE6sWxVOqqwmQfeIeuA0RxMh30mvaSNl/SWtevqKTuivs9QSMUZuf3Rty+1
	 jehYrIJUWJp1p9SaQpGHqjWhW2MJimRdJmDrjvDETPny9EhbdJaxUEVFGgmeA3fN2+
	 w0BG5lPfdtOYdLmzppxja4R8N61QcuNsQDJjdoqmIJJjcHl1szACPumNndVdJdp+NJ
	 6LN0veNm1+9GKkJxYhaTjaJsMkU8lxMygzfOmIkUjxajvMSCZnolgTeNaNkBSwiPFA
	 ufR6Q2lmV+xIA==
Date: Tue, 31 Mar 2026 20:59:10 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
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
Message-ID: <d3c348c1-a570-476f-a48b-700042e5cb24@lucifer.local>
References: <20260325114022.444081-1-npache@redhat.com>
 <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
 <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <CAA1CXcAHa9KOR92oHAPZ0z44DKS6yhgNArKoH6caVSBio0z-8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcAHa9KOR92oHAPZ0z44DKS6yhgNArKoH6caVSBio0z-8g@mail.gmail.com>
X-Rspamd-Queue-Id: 8C8D1180011
X-Stat-Signature: 15mzb9rcuod1w3kzmtjincy3neyhxta4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774987164-215670
X-HE-Meta: U2FsdGVkX19HINjFac0FZl6LR+cI0HvslB8thX8FwddsH2PQS7OWEGGwU1ANdZJd85vzNn/UIbt1R7vIv8USL6fQYiszXmyHAFkVHZcHcPg/Mb+afNd7T6ftkZIYC7G3wWX57LhMRj6o5J2zvkRC2a5zqL+0olR+ywP32tPg4Z5seX8VWjeIKXinO+3QxpJyQm+egaIeu4Adt5XDIQfj+VABLPbr/OG/7Axu6WcC+R6lI4KI0/t9TeG9PHhVPjKf8TFJSM5Zjx/8z9I0ay0lqa/3ReZqKqPQyhnMvj894YNiyBZkEhSmrUehoLiwOVF2r1v05cVa9nRWRJcctqAdBibOSe4JD3X49/qXhMDYOzAZSxG2l8bLnvN2sTnz8SsH+p5ac+0zBHykAiPE2hd5eKHXycPolMKDaqdDDPyU89q0VLOaToum7BgwHTB+VsNIYsLSHCvGzPajhsTHkpRCWT4Q99c6/SG3rl3wVlK9MV8f15UrE27GhuiKHQigU7bKX1ePr6V+Bhz6a7Cv4EALInFxhm95V17gFy102I90TDDXcucc99WUHppHHOU51YmQjMji6I7dyPKunv4bPysfuW2bGUb75QqCcW2g0Bjb3VZ+xwdL1QbllDF+qJUgLVh+1Qr5etii+hIdlNYWkciLYzewa588gftwseoGsGm+eVwa3Xn1KPm6Z+U81KBItwJ6NEdBW4V8cfWEMAeBMbe/o0VGoVGsWKdWHVz9o+DNuBhgKlsE6Ia9SplRweGSmURZgWYb5c+glU9bdri8LuxUKMJA1K0IupbalmS11MDlYpKqNsqk3AkIfh6Ip2RpuVyHWd+ViF7616scmR2acHOlutnn38pu4mIELa17VJvtpVknNuwOJMwHwnxWINdqtQzjMaEfAfIBU6COl9onSEroEQ3fOFfrr9ZtoLAIyp4RyyHbqy2yXxhbVaWylc9bSMUCtqifmP0STbvFCDSdfSR
 Guym6ROx
 FShiV3J24MypQDMXytKuY0yvVnsFCdYclMpYqCSl5Z2VBn2ya+6NXk7cewJJ5Zj2+z7UUkrFm0ADxJQWDKZ9iz71U4AByN5cf7jjKswCw1hS6QcfQu+v92/8W2FiqnoeL8BkKdbo4QBN6xbSixIxK9qMMaW4aER2DNvjzVgE9LYu3MBB63pbYgV/Mu0nYFWQLYJGsYD7Nsv2JlkWpKCfOc3wlaFUO57y8bfpn8csIFTNOK/rLN5655Iw900S1NxKsNA+mhccDmQvXhaq16iQWOMzvuXGqq6zb0tmELX0Rgqlhus0f9GMoyif31IR1A+dhsJoCuQhlCRNyZi5AMQ+81AOLUpzwQ0k76wwTeWpSgAzzSvUYr1Ccd5MiYd+e7QmHmBNhEdNUtU8yNT88BC2oSf3T2F4ZTSu9WkCK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 01:46:02PM -0600, Nico Pache wrote:
> On Tue, Mar 31, 2026 at 8:13 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > >> +            if (*lock_dropped) {
> > >>                      cond_resched();
> > >>                      mmap_read_lock(mm);
> > >> -                    mmap_locked = true;
> > >> +                    *lock_dropped = false;
> > >
> > > So this is the bug. 'lock_dropped' needs to record if the lock was _ever_
> > > dropped, not if it is _currently_ dropped.
> >
> > Ah, well spotted. I thought we discussed that at some point during
> > review ...
>
> Yes I think we've discussed this before, and IIRC the outcome was, "We
> weren't sure why this semantic was in place, or if we truly needed to
> track if it was dropped at any point, or simply if it is currently
> dropped.". The code is rather confusing, and changed mid-flight during
> my series.
>
> Lorenzo asked me to unify this semantic across the two functions to
> further simplify readability, but it looks like we indeed needed that
> extra tracking.
>
>
> Cheers,
>  -- Nico
>
> >
> > Thanks for tackling this!
> >
> > [...]
> >
> > >
> > > ----8<----
> > > From a4dfc7718a15035449f344a0bc7f58e449366405 Mon Sep 17 00:00:00 2001
> > > From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> > > Date: Tue, 31 Mar 2026 13:11:18 +0100
> > > Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
> > >
> > > We are incorrectly treating lock_dropped to track both whether the lock is
> > > currently held and whether or not the lock was ever dropped.
> > >
> > > Update this change to account for this.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > > ---
> > >  mm/khugepaged.c | 12 ++++++++----
> > >  1 file changed, 8 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > index d21348b85a59..b8452dbdb043 100644
> > > --- a/mm/khugepaged.c
> > > +++ b/mm/khugepaged.c
> > > @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> > >       unsigned long hstart, hend, addr;
> > >       enum scan_result last_fail = SCAN_FAIL;
> > >       int thps = 0;
> > > +     bool mmap_unlocked = false;
> > >
> > >       BUG_ON(vma->vm_start > start);
> > >       BUG_ON(vma->vm_end < end);
> > > @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> > >       for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
> > >               enum scan_result result = SCAN_FAIL;
> > >
> > > -             if (*lock_dropped) {
> > > +             if (mmap_unlocked) {
> > >                       cond_resched();
> > >                       mmap_read_lock(mm);
> > > -                     *lock_dropped = false;
> > > +                     mmap_unlocked = false;
> > > +                     *lock_dropped = true;
> > >                       result = hugepage_vma_revalidate(mm, addr, false, &vma,
> > >                                                       cc);
> > >                       if (result  != SCAN_SUCCEED) {
> > > @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
> >
> > (in hurry so I might be wrong)
> >
> > Do we have to handle when collapse_single_pmd() dropped the lock as well?
>
> There are some oddities about madvise that sadly I don't fully
> understand. This is one of them. However, I dont believe khugepaged
> had these lock_dropped semantics and just tracked the state of the
> lock.

(As said to David) with my fix-patch we pass a pointer to mmap_unlocked and will
set the upstream lock_dropped appropriately as a result :)

So we cover that case also.

But yeah the handling in madvise is weird, and we maybe need to rethink a bit at
some point.

>
> >
> > --
> > Cheers,
> >
> > David
> >
>

Cheers, Lorenzo

