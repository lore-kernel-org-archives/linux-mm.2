Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFFF8C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 06:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C82D6B0095; Fri, 21 Aug 2026 02:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0056B009B; Fri, 21 Aug 2026 02:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5326B009D; Fri, 21 Aug 2026 02:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B2606B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:21:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA9268039C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:21:14 +0000 (UTC)
X-FDA: 85124279268.11.76AB8C8
Received: from mta0.migadu.com (out-154.mta0.migadu.com [91.218.175.154])
	by imf27.hostedemail.com (Postfix) with ESMTP id AE05A40006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:21:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ppN72ykJ;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787293273;
	b=uObTMZi1Gaqs3+hAJc7jkKPnrQ2dZUjOwTut4bc7ssbnT4zwxNP0T27d8tmBhIyjYvpVe4
	3WBtUr4b765wdUyonQx2HeVlDgo/H0mrCuvuP7er+fk+IxOypN4Q6r9hRxWi+dUNPDBCHq
	3uYYIM8z8vtaRR5ETG+oIeQs0chbaqc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ppN72ykJ;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.154 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787293273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XoVmYBmwXV0f9WVcpC2TRp8kdZHd68RVqz9KsA5hmdI=;
	b=LECgAknwrpcbL2fE8bD6wHKJ+fFouyfFDKOusPmBTp5YG8WvM3Zg+s7WPjYVKpxhR8Gf8l
	DhuyheIwQSc7dE++7SMa9jkBeDy5PrwvKxzzgQ55uDwLOmrTVRl+CDbMydWM2djt8NfERV
	82olLOGkxoKck+2oUFo1VuRcQjVUm8w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=adPVk1lWJaVbZTKBLf1r5uG4plHwOPG0xXdAgm1qOdo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787293269; v=1; x=1787898069;
 b=ppN72ykJoA1pOapa+b7GeFcWtqd6Qvnjp3SBBd6S3IeYMbMqfR2bbhqA7LvT7IaoonXy2D8d
 IyIs/96tQ5oNjcIbuaCHTiYN6d36ZOX8RwjLW1bM38/fI765oYwqDUyAs9PH0mnJ+3ult3Y2ZuK
 O4nTNEqBhsbxYOwVXDo2YsBY=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by mta12.migadu.com with ESMTPS id 550237e5f76dc425;
	Fri, 21 Aug 2026 06:21:08 +0000
X-Mizu-Trace-ID: 550237e5f76dc425
X-Migadu-Flow: FLOW_OUT
Date: Fri, 21 Aug 2026 14:21:00 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com,
	qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Subject: Re: [RFC PATCH 4/6] mm/mglru: report hot PUDs from the rmap feedback
 path
Message-ID: <aofuTK6OOzC4lGUK@fedora>
References: <20260806103003.3924438-1-baoquan.he@linux.dev>
 <20260806103003.3924438-5-baoquan.he@linux.dev>
 <CAGsJ_4xrJhFrmG+Gr7ukPUS0NeKTgYT9VViN_niq8tHejp36cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4xrJhFrmG+Gr7ukPUS0NeKTgYT9VViN_niq8tHejp36cg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE05A40006
X-Stat-Signature: he1rts1jeamhw479mpnoc94zkwu93x9m
X-HE-Tag: 1787293272-304971
X-HE-Meta: U2FsdGVkX1/O1Rkf6kVTN+td3CHNPCz1eLvTR6QLBdvAsFpCPJRflu4rpZFvL4C24ynZQ9xyoy8l/IRmNpB4lZB510Erh2CLqam0d9deOfNpck3okM06WgPfJ8T4fnEoqsQdPD/hiSY/ASJkbD9aGhVsLP6/utJ3yxNpWt1T8gV5oGC0zJZTJ5eFpw7JZqb94xsAZnwGeRe5tzxRVlcOPMsuNiQDGuYxmqb04sjcsflUN2owJC+L9D0zPIqIdUv/ZDbX7Mou44ruAZHNZqDucuP93BbvnWQMVkz8/rDmkRIXZGAOBzVgyUbSLZvyP4Zgp8rl9d2vdhYgP2VKYnRHACupiCV3bbnnxGAko+DRQaRN2QMilYscqxdCuVrrY9Ytd9dvpgU7BulS1zqjRobsTEUClGL6iXQCbsEfT62Pf1EVn1RNwn+cUTNL6kJ2ynFCXqN3uz3VgusK+8nZDmWaDnRvPRwwigRI7zPgje2KvqMth1hlKl1DsLSOJ/x/mWPayNuLgXEFdPppwtmyJ7NlMVgoEu8nzbummndlg3I/KCpaJxLy6uJN0PAsc6DNFDItSMOUekwhzQLVj9JrfWTGBnoR1Hgi7eWN7iyW/piWa0ck8+VxNO/V9XvOeXh9M6Ey5MuDjSqiTvzr2Jg7ByBJTCByEWWUV5g6HNHXdLRu8fbzjahTZqCga1zxA8uk334QtpM9rC5CanfP6uvI3TUBpjeSmAQUvFzuwXoVoVhMIGVZARieZazfcdmkXd0tMjJRetxE0jJAL/rVLw/HOUbMReCzliBDGPCC+KIf5gDF0Q+R/hhXjWhsVlj2iBWCdrQrIUi+b2nG0kzSjuK3MNO41nH4iXtgYKVDDtH7+t6eP9Z0N11+KUlGqbCYNiJow4brBQ5BhEbs+2YsMs9NmQ8t9ryAebBOj9YCugx2lOIL5MtVsJknxrM7RVQc5g2cjNczmtTuZ8434tdNn+iMq1o
 nnaDa4Lo
 bPhVp3sL3yBhSu/nHCkAEXhPZVGLd9d7aJe2a6/Qi5Ba2jTFG6MvaWLGSF5mQ5dRa9eg4lgebKrL+wGhggplrmTDeyysUraQgEcrkYGx2Bvpl1/sB4cpr6KVs3DO9diapx0SoqVBL3w8i5Vqz4L2hIcQcOtD45yvg+vvpwqwLvuf+yxnSbIZS5Njx1ywFNUbNt74NV/zNEKRU2G+Ctq47qvnOul17jc0cXOSIsr2CUv8AuncZv4+5AyubgRHyEaK2cofH43qc0GicTmy52Yv22TywwHCjIj7B8zt8YvNPiHmVTnMgu2fRm9W72LxOmzG9fMAhmIlbIswxj3nO7/i+pm4FKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/15/26 at 07:36am, Barry Song wrote:
> On Thu, Aug 6, 2026 at 6:30 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > lru_gen_look_around() marks the PMD of a young PTE found during the
> > eviction rmap walk, feeding hot regions back to the aging walker.
> > With the PUD-level filter in place, that PMD marking alone is not
> > enough: the next aging walk would test the containing PUD first and
> > skip the whole 1GB subtree if the PUD is unmarked, never reaching the
> > PMD. Mark the covering PUD as well, so regions whose hotness is only
> > observed by eviction keep getting re-scanned by aging.
> >
> > The PUD entry is re-derived from the mm page tables via pgd_offset()/
> > p4d_offset()/pud_offset(); it is only hashed, never dereferenced, and
> > the mmap lock held by the rmap walk keeps the table chain valid.
> >
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> > ---
> >  mm/vmscan.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 74edfe2a747d..ca0f06641adc 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -4416,8 +4416,14 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
> >         lazy_mmu_mode_disable();
> >
> >         /* feedback from rmap walkers to page table walkers */
> > -       if (mm_state && suitable_to_scan(i, young))
> > +       if (mm_state && suitable_to_scan(i, young)) {
> > +               /* the PUD entry covering the young PTEs scanned above */
> > +               pud_t *pud_p = pud_offset(p4d_offset(pgd_offset(vma->vm_mm, pvmw->address),
> > +                                                    pvmw->address), pvmw->address);
> > +
> >                 update_bloom_filter(mm_state, max_seq, pvmw->pmd);
> > +               update_pud_bloom_filter(mm_state, max_seq, pud_p);
> 
> Is there a case where all PMDs return suitable_to_scan() == false,
> but the PUD is still worth updating? Or, if only one PMD returns
> suitable_to_scan() == true while the other 511 return false, is the
> PUD still worth updating?
> It seems we can keep it simple. I was just thinking through some
> extreme cases — maybe I'm overthinking it.

Good questions.

The PUD update uses the same suitable_to_scan() gate as the PMD filter: 
walk_pte_range() returns suitable_to_scan(), just as lru_gen_look_around()
does. So a PUD is marked if any of its PMDs shows dense enough young
activity. If no PMD passes, the PUD is left unmarked by both paths on
purpose: sparse young pages don't justify walking the whole 1GB subtree. 
Those young pages in unmarked PMD/PUDs are not lost: they are deferred
to eviction, which doesn't check filters but checks their actual PTE young
bits via folio_referenced(). Young ones are kept , and lru_gen_look_around() 
then re-marks the covering PUD, or cold ones are reclaimed. So I'll keep it
simple.

> 
> > +       }
> >
> >         mem_cgroup_put(memcg);
> >
> 
> Best Regards
> Barry

