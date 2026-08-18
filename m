Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4489FC5DF86
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A5E6B024E; Tue, 18 Aug 2026 14:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41B996B02A6; Tue, 18 Aug 2026 14:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3326B6B03A0; Tue, 18 Aug 2026 14:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07AEA6B024E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:18:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F1A980248
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:18:00 +0000 (UTC)
X-FDA: 85115199120.06.C56CB4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id BAE4F1C0012
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:17:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S2zmJSA4;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787077078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wL0CkUQJGJiUfrjRhTdtW4GRwxEsV1avXNEQy1O+5d4=;
	b=FN1bc39Oa7TFngI6OTu3PHbigoRVshJr1mzFcEBUiVXO5pPS4B15D9yCmoVCvhjcX4Sczp
	RvV0vklRhVu0VY6Bru3Z8KKDuFQorkpvuLWMeEixuWJu/vo320YfQiIUGAjsdz7gfbxdgz
	Mt5mE+6AsueFnJLCVcY+/1GYLQvwoi8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=S2zmJSA4;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787077078;
	b=zM1zrU7AkU0xaqnC4pP0llFMW4ChpAwmCRflR0tJAzPfoBaP5plFuc9wqOHpxvPYD2URm+
	h2U3ScKnWODsueXFr1RsZiVUZBKRZZL22paHeOGwy+o4y25bjU5dqEws1tPkgaMtBZOzPX
	pVc0jVMkqjltoeOw+l/X/hyxy3gLT0o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2464E6020E;
	Tue, 18 Aug 2026 18:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823401F000E9;
	Tue, 18 Aug 2026 18:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787077077;
	bh=wL0CkUQJGJiUfrjRhTdtW4GRwxEsV1avXNEQy1O+5d4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=S2zmJSA4hi3L+3w/nGghnBtGmVPaXy1n40HH+CptFgaKpNEYSzKTLJhNEz9xcvxZO
	 G56ejIVOfp4brGi/l9Vy+1hJTs5AYrncx+9CUThq9ra+t6+KmmGE3UIsaYaGC2wtbp
	 OfumQjHR52PJnEZCxP7EuUyFaHkrRc44R/+Z0fNg=
Date: Tue, 18 Aug 2026 11:17:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Leon Hwang <leon.hwang@linux.dev>, linux-mm@kvack.org, Muchun Song
 <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] hugetlb: add cond_resched() to __unmap_hugepage_range()
Message-Id: <20260818111756.6b0e347db3170bc22cc3c5af@linux-foundation.org>
In-Reply-To: <3dadebb3-7e2a-459c-a5e8-b375faf89938@kernel.org>
References: <20260818135029.93288-1-leon.hwang@linux.dev>
	<3dadebb3-7e2a-459c-a5e8-b375faf89938@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hxgxf3nbnt1r7ugn5s9kyua1m7zfan7u
X-Rspamd-Queue-Id: BAE4F1C0012
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787077078-479313
X-HE-Meta: U2FsdGVkX18NZIKzq0WY8dQCGXribco0VG7gxIaWZ2RDRwgWJjV5r10kOGGNJ4sxf8yQdupjd1VOIgasmi27s7PRWF4NtCO8sKjk33OeFy1+2E2WVDTIp0PQnQYNa1kOo6dOhQRvxevJ8p4shSRjcfi08JAwHkJj75p0hHkh66k+q6wX3Rjyx96tXmeI66G9HxFdWXf+Z8CwfOHs3o2LnohBMvwkWea3vlqWRkktJXW2LMFELlsQLqCjz+EgvB1MNrZgXtkc3h0eudrvhIcmqZm7zQyVL2hZASLUpHUBi87Y32SrO0i80RisNPRcJJCaVCKoYhrB7eakz0MGQv5+EtlwE4SQf77cSC6FIWJyMmGqmRYpqOGcIGrd0ZgvMemyRRS2uGPjgZHygmpsPzSE9LfpBETzkVjxKLIRjfP3P5qJNZszSF/BB0jJL9PJQPoKkkKj6qU2DD0uQFZ7zOEHNminYDkJA68XOYEI9WK8WiS2TplrkAC45zxVzwlM74qI2O8eBbxOMIZAD5T4CC30D1/fIizIPLyr/DaH2Ebg6j5bQisjejBzS4bLx+GhkuV0ErzitDmV6QIMq4vNquo2g4sSyDs6Yc+CZBcbDyEVj/GXyOTFoldXEgJRR3OIAaJF/rRaAwoi/c5CrHAU7YbHGbRc5XUH3hHvQFh6425E7QThyenwoNXp0GBPiv9gDgdskHXT4PjE18sFa24rroZizmynAhNG3OfjVM6l8sU3w936Cl+uAr560OTie0t6zNqzr1wuv2trA7diAC7gFQyZIkclqZwLUxMv6W6KCJsAl7zIABDM8KKtdjWiIbHsZFO/iPFqeIKShWakwqCXOuXWB6CAd5s8uQ98BLETIPk0Tp1qyV2yHwwEp9LHIkj0LpPgZ5SNf7YP7lD9TD7u6dkpjuLTsr09ujpz7Txe2wX2rcWfRg5u5K69QZHR8IaxiiGRBMZDf1rw+2vyj8f4Hwq
 ADG7soVh
 gOUdv3jFyiWXos9V/z24JiytOrmWO4YRuNBThiANBIC2AubwwVNf43JkD1e3P2+PHiC/dwLUWsL6ixybJzyoQKXWmVh9YTpZYWLvDRuEL0tjYvTKwXbT42ats6GgcnJx9iyxHNGgl5nDl58uxR9TJVtJw3wfm42uEyMd2AT/nM5rEPe/tGOvzBxn93x8Q7+Ra4W+w6hSJABBDpkvIWdZZ7CaML3zkqnX3HrbHmoJOhD/WZd4qRlrAGfTCA21N9h14mUh/bppS5fgqYtQYNaB/e4IV8tfFAhArKBm8EfeE4zOQ/rM7XgoN2vy9pZwKbk//o3AIaj870Ehk3f3xMIV68T5E8AtS1vHBhMoF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 16:23:29 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> On 8/18/26 15:50, Leon Hwang wrote:
> > Packet receive timeouts were traced to sparse HugeTLB unmapping in
> > production. A task unmapping a sparse 2.5 TiB HugeTLB mapping could
> > remain in kernel context for over 40 ms without reaching a scheduling
> > point while walking empty huge PTEs. Although hard IRQs could still be
> > handled, the per-CPU ksoftirqd thread and other runnable tasks could not
> > run during that interval, delaying NET_RX softirq work queued to
> > ksoftirqd.
> > 
> > Add cond_resched() at the beginning of the hugepage loop so ksoftirqd
> > and other runnable tasks can run between iterations. Testing with
> > PREEMPT_NONE showed that the maximum interval between scheduling points
> > fell from over 40 ms to below 2.5 ms. Total time spent in
> > __unmap_hugepage_range() remained about 36 ms.
> > 
> > Reported-by: Lance Yang <lance.yang@linux.dev>
> > Tested-by: Lance Yang <lance.yang@linux.dev>

Is there a Link: to Lance's report?

> > Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
> > ---
> >  mm/hugetlb.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index dded1768193a..0a91aac2369f 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -5233,6 +5233,8 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >  	last_addr_mask = hugetlb_mask_last_page(h);
> >  	address = start;
> >  	for (; address < end; address += sz) {
> > +		cond_resched();
> > +
> >  		ptep = hugetlb_walk(vma, address, sz);
> >  		if (!ptep) {
> >  			address |= last_addr_mask;
> 
> As Michal just put it:
> 
> "PREEMPT_NONE is effectivelly dead and most cond_resched will/should be
> removed. Is there any reason why you are not using full preemption when
> requiring low latencies?"
> 
> https://lore.kernel.org/r/aoRnUxUlgf_kRlm8@tiehlicka

That's pretty bad behavior and we might want to fix it in earlier
kernels.  Is PREEMPT_NONE effectively dead in 6.18.x and its
existing users?

If yes, we do want to fix older kernels then we should merge this.


