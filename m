Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5068CC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE546B008A; Mon, 31 Aug 2026 12:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 280056B008C; Mon, 31 Aug 2026 12:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195606B0096; Mon, 31 Aug 2026 12:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE2DD6B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:29:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 829271C0A90
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:29:50 +0000 (UTC)
X-FDA: 85162100940.16.0743F0B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40E51120008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:29:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="A7Jmg/aF";
	spf=pass (imf29.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788193788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CevEshRFCKtTBEABxBe8cgJ4pajQ0UGCKo9BrqWXex8=;
	b=XDCAK2UNHXE1/Ds6eKYx/YAk/dpmzspvvba8VSRc7ZOIN2l857dgSb2KDlWY/8dG6tw4ex
	vDMPP/+PLqdIZt9GrPUoIRQU+b0SjOHFOKRQ+tWajQX1d5+ZEJr4Z4xRE71DmvLT70ivkn
	hd8HeLW8eRBY9VCBM2CUwH59OGoz8oI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788193788;
	b=ewvTVqxHEUL8HtRM1lj2yjQSM5h4q7yDdVBKS573WwXcaYyxcM1a8uGexaBSNZRm5XXCUq
	/sQkuLGbeVup+fffvuTDTU4Cz0c+G8jJmy6i1wk/DQCQVBM/WIK39lbiCX1J0x+AIOp7eh
	ijillWXOdjwbkYulsLs+odZdfBoiM9Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="A7Jmg/aF";
	spf=pass (imf29.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CevEshRFCKtTBEABxBe8cgJ4pajQ0UGCKo9BrqWXex8=; b=A7Jmg/aFORJ4YSGm+Pn4W4PRp5
	RsiRxqaErsr+1192mTFuToB8mK6pq2SzbjKaYJA1VFvdimdXZrGCMvGlupf8IRRENBOZJFRgdzPRp
	VXP1I2TkmoRvZeYB7ajpsPQU3KibvLLZM3qDzmJtbqbEvenxUbplrmj9xdUnzCfg/G1hx6Fgvu+P4
	GIFWt2MLb4RmtpMv7VtGAgrJ1GS2siZdVOKAxXvvYYSTHLFCcFFzM3e0R9xbrWBREYhZ7Ma1sCltT
	vjcT194yk40+TZRrJLabxPJvGqe9r2RF41pvA8B3kAsxIt2S+bzOq9SnKaU85AoW61n4lAGuur+0P
	cSPlkZ1g==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x14tG-0000000A2xn-0G0G;
	Mon, 31 Aug 2026 16:29:46 +0000
Date: Mon, 31 Aug 2026 12:29:39 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Andi Kleen <ak@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, jannh@google.com, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RCU safety for vma maple tree walks
Message-ID: <nq4g527ozizmp2iqmozau7xwgdq4cny43onciw2mw7vu4bwabg@uzkdpjchygkn>
References: <20260831143511.1133029-1-ak@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831143511.1133029-1-ak@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40E51120008
X-Stat-Signature: 61ndpztkd6yu49gguqp3z45ia4esfba3
X-HE-Tag: 1788193788-803044
X-HE-Meta: U2FsdGVkX1/AgVy4rStok8m76nXhDx2X0H7LcLJ896UF7AuLHNSGTKE7P0AJVlj2XtRnpC18bCJAeCZ5qncNQYbehYMOMVQuppxgeUnAD+NQGLYYA3WfXBVrGcqk4lowlBP47T39ISSJQ+c1njf9M/GFEhNGp4e9tC5o3IXDSe59yugwJgvAQGCu5lFZcBaE1fEPKFBSx+aG7+1KfOBKrN0Al+Ftsvzw9c12LDXz5eNyLZTR1ycBRTHxIEg4fHgLbD+QZlwsCgwYwiA71BApEa4ZXs2eazrSOJX8ZLD9K2qctbI56kLd5CGuZkw/8PXkyzbbJMhLbufBs5jEUxeD98N8vuPfkH+md46O/lF60woeV590ngzfekEeFl2tKzjBAR0dUNHhvgHxh5i1ljwPMd6rezMyj7Vb2ExTNEdqu1JIwc5kDqHl85mFg55E2iGNQA0OvMaiC/z8PFK36Iz0fqIB+ZiUzERyMrMXPBQSeqQzRYY1bN2zhHIpPH6mbR/nMsaGXaurvo/vPdwvmS7ItUra8X9cK4wDxHbObhdbD/ldlb79MHsn5gCasLYESifYPRMg5FS6lg/uwfZN6wLJhxWuIAXej1VDiud7a/0qv2uejOlXpnuS5EdlJAGW5SaI4iKZcu1ICRDd9EBJ9ufZRb9Ejg76Bvqdq+0PC4IIYea2ozxuX2UACBvoWh4g0g/NQljbE+RwdWeNkbYxn2+RnOokRxPmffTAzkikVp1lsMEuCt5nEopwEdy9Q1YaUpcOfF1YWRB9UxhqIHAi52d2kNRFbjdusMuJ7qyl12V/ZkFsEgt/ZI9X89SqXK5+cllwgmZ0e3GEtzJUZZRvyQm3biguvfjMUihKcqf1Oo1cSllkIEYy3WrIfaIQ5SFoIjvBe7K7KCLFdpo52iRySR8Jawi2kGbvD5D3aTqLlAP2NPOq7DHMgXgkECe3AVh9Ov/LtOnzw93TcC0u7LlciQt
 rqD8btXb
 TXNdzRyxRTZZeZoZFS/3IwfP8G8ZTA3vDFfrMyDXlqBACn7giOdEk4RUeMF1qsi5lJNVjv2TgMZ7YexNJ/YBb/qXMR4lBD2OnS/jY1xodsHbBoqpc6Ur+GUPVaikJBFjsv1nSED5s1Dhojck4KQhxSSCUPo/UONOo+MgfKXejp2A9Mti5dgqA8o9FrqIam0IWJEJpe22aN2aozevw9NHVkplflDN2YB34s4ASBsQ79fm6BvPnZtbyMpx70kTXDjKsNtJVjnOX8Wnn/4EkFUUNytlf2MfcW5RE74zOGs6AeCzvsU6eqopyK0cRkezjDo0/IP0DXxCM1ztuZVc3JioJ4xNO1vPS2I51JOhcJOkNVbDGTCk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/31 07:35AM, Andi Kleen wrote:
> I ran into the following scenario in a slightly modified kernel:

...

> 
> That said I wasn't actually able to trigger it in a unmodified kernel
> so far with stress testing.
> 
> The following old unsolved syzkaller report has a similar signature,
> so maybe it was already seen:
> https://syzkaller.appspot.com/bug?id=4c5268fbb1d6d508a4c34dc425e2693d1ff9911a

Did you look at that syzbot?  He has 1 reply on-list pointing to the
discussion and remedy of the issue - which was debug validation code
running outside the rcu lock.

> 
> I guess in many cases where it happens for real you don't notice it
> if you don't have KASAN active.
> 
> The patch fixes up all callers to maintain the RCU reader lock
> regions correctly during the VMA walk. If they cannot be maintained the
> iterator is refreshed by a new VMA address lookup in a new region, unless
> it is proven safe not to.
> 
> In the cases where there is no sleeping it is strictly not needed
> because this scenario could not happen due the existing VMA locking.
> 
> But I fixed them too to not violate the maple tree iterator
> "rcu read lock or write lock" contract.
> 

Did you check this with lockdep?

Any access to the maple tree without holding the write lock or the rcu
read lock will cause lockdep to complain.

Likewise, any sleeping while holding the rcu read lock would produce
warnings.

Note that you do not need to hold the rcu read lock on the vma maple
tree if you have the write lock.  This looks to be the case for most (or
all?) of the cases you have below.

I suspect you have a locking issue in your modifications.


> The ones that do not strictly need it are: count_mm_mlocked_page_nr,
> remap_file_pages, range_contains_unmapped.
> 
> The ones that may sleep and clearly need it are: apply_vma_lock_flags,
> do_mprotect_pkey, remap_move, mseal_apply, mbind_range, userfaultfd
> register/unregister,
> mwriteprotect_range (doesn't sleep in the walk itself, but uses iterator
> after sleep)
> 
> In principle it could be optimized more, e.g. for example only do the
> re-lookups when actual sleeping happened. Some of it could be done
> with a new cond resched variant. But I tried to keep it minimal
> for now.
> 
> The patch survived most of LTP, the kernel mm selftests and
> my own stress tests. I didn't do any benchmarks.
> 
> For when it was introduced it's a complex area, but I believe the patch
> that originally added the problem was
> commit b2b3b886738f ("mm: don't use __vma_adjust() in __split_vma()")
> Then
> commit 17f1ae9b40c6 ("mm/vma: change munmap to use vma_munmap_struct() for
> accounting and surrounding vmas")
> extended the pattern to more places, and then later it was copied
> elsewhere too. I'm mentioning only the first below.
> 
> No cc stable so far, needs some discussion first.

Please send patches as RFC if they need discussion.

> 
> Fixes: b2b3b886738f ("mm: don't use __vma_adjust() in __split_vma()")
> Assisted-by: omp:gpt-5.6-luna
> Signed-off-by: Andi Kleen <ak@kernel.org>

It looks like you have asked gtp to fix the locking issue you have
discovered by editing the exit_mmap() function.  I suspect this
functions complex locking dance has fooled things up on you.

If any of these issues were a problem, lockdep would be reporting about
missing locks and people would have hit these in the last 3 years (the
last syzbot report which is resolved).  Your scenario isn't that unusual
- most cloud vendors run machines flat out with as much ram used as
possible.

Thanks,
Liam

