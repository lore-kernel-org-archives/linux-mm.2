Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88CA8CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:33:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014806B0095; Tue,  9 Jun 2026 10:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07596B009B; Tue,  9 Jun 2026 10:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DFD6B00A4; Tue,  9 Jun 2026 10:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D20446B0095
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:33:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FD591C248A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:33:48 +0000 (UTC)
X-FDA: 84860618136.15.2118498
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id DEC5F20008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:33:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kHUR4rBF;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781015627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=741Q+uof+wQFQ/KVIzOQr/dYcimcckvcggwLVqMRUHA=;
	b=DEbRIis1jipRhZoh7G5fTvoJ4S/pBk9EXtj8ewgsiXpghwr1KLsoMxOWGc384TubPH5wOo
	5KoA/YL7pfw/1uGVxKFiAkLdVQva9Z+hJvAASUhfPPi6Cgp3F7+46WXEr3+PLdqRHxnwND
	KykfSXEl7kFG+fFLVCYOynzLFe6ov78=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kHUR4rBF;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781015627;
	b=eA7F3W5hJqivvLHMerPlJjqR7bBTiQbyX1fWs6muLz4tUKZS9mMeMxevI6kVDK6lSRNCnq
	QWZ1FxfTawxLXy/RKMpn4JKFiEhhwdDUCCEhCUP3dFpkQA7H/GPAW8vF2Xur/tjeXR0DnM
	mPDZjcR9sfM70BrKtEC638niuqwKDvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3FC3D4396F;
	Tue,  9 Jun 2026 14:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5170D1F00898;
	Tue,  9 Jun 2026 14:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781015626;
	bh=741Q+uof+wQFQ/KVIzOQr/dYcimcckvcggwLVqMRUHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kHUR4rBFVL/T4vICCboCXOzze8FceQXTZiNRz6s3JJecr2Gjc5VWC7rXex5kGkMoc
	 Yk48rvqV9UXv+9V60aig44D5VNszwAhafWcxBuj5+M2N0czUG0DExOOCYaSUMx7vpp
	 J3GHHxhb9QlViItZPlpnAniPaf/BT7/QPDEzlFceuCZGdt5KhZOHfaqrkhzBeRhV53
	 8QpeXxAeahVqJiuTsEaUuO8ndu1Aee/5B39ehZ9M/Il5fHz1sF7szV7FKFcrnkUxCD
	 ZnSxOBhaKDj4vAXzWw7LhiYT9ICmbpNc8I15bGENBjm88o49kDzL4RiVr868y6LsKC
	 2bgWvh2KIcuJg==
Date: Tue, 9 Jun 2026 15:33:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
Message-ID: <aigj8wehALMDySTC@lucifer>
References: <20260609120443.71864-1-lance.yang@linux.dev>
 <7d081256-5b30-4e3c-b948-85ba76ad0e1d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d081256-5b30-4e3c-b948-85ba76ad0e1d@kernel.org>
X-Rspamd-Queue-Id: DEC5F20008
X-Stat-Signature: xaudqcfo41it9zw6nipxyw9g5xea1baa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781015626-496561
X-HE-Meta: U2FsdGVkX1/hNuIGSOPx0ZrIc5ySqFFI08K1emaeU6dwjWU2PxuPzg0VxI1lgjn21+vZC9MOXfk1IYlkacNoXS4N+HI2qz7OBjArPbNIsH8LI/yFd1mwu56Of9pCI+vGQY1HkVJqC1Gp2mWWeLlkj9BWrWdUEr8w7HdvrRZyZa5L51xqyIULfWrpZ90eM9BPRc3QvzrmxQbFW+G5qj/6gm4d0jauikymHNNdRh/cHTMC3uAkhnqMFZIughuqxAU9jyZf+5OvGXil+xB3WyQ3+K/oRsy1s5lhO8KepVUS8XftlNaFDbmZCoxBk6ImNcN0eZzs810NzX/kRlSicB9ggoxcMzVQirMMJtmYPBefpx4T+ACPnrwS/qeVSEnJwv+BW6HmCHXXzfmqDbPwEPKFyB5jUdst+pDVdWOzRTdN8ONJbgU31xJkOOy3qUof7F9sdOHF8j/Ov+3IKfisvnO9SDiZVOpyMoirgXtBRYl6Fjb73pnjuEjoKPeZwIFxfXAJ/ezCDD08nbgce5uZE+8WU46SPnCEcmHf3AEB5Xr5Z8GH4P0b2NgLNaBq1ekPsknh5w6gbyLqPsf/KQjVGAU87eV8dOOq+BzYlrrEKpZxCnHXl6L/bYkLcMIsOoGTurst4TTnla50v5F9Hw443qtUfbV3/qMsj9toA7Ve9RpRVFI4duuZu6x/ixJjgs0DHTs9oklOOmrqkQGQUL92RziIKqQ/V7N7FJZiwtwAZGrbqIRCPyToa2MGGUPX/iYUzzgwJIhEBIPTzOn/XRlUHeoL+rFU/OO2tiwmJOg2Ekxgxz77wv5ZL1Z0WMhXb+RGFoAK23ZWj343S0pr9nApZJIRS3afYxJfc6kiZPmZYqzmUZiLFnsSPbyPAqwJbQKokuwpl0Y6d5MMgctW72495c4DAEXsOVAtMtrdVWOXRSVhzXtb9Et6FLi3gg8PRky0fzEm8/8lGSSi5UgQsJbGXCV
 x6p1Hqz2
 B80tMzCayr0evidw8VYlDnFd+vDkUheBTr6LlQ3sVqM8Sy3i0QUiJy361Tvp41jOzt69/24ur99ab/6qzSFtHp1y7VL5gk5700jAxSx7Av/moHZ6plmDH36JYCCNMfsPxBl3n6whtT39mrRMGJ523Yebv1RvY37tIx2cbZqcL0r3rBodZiYiW8PZn48iMGcbsEr/KjP52KrHAdGsXzCO3XzAKbdf6dlCf4M8GFKLArAxxj44h2W9YSreFyA1WMcLT0kOxHSUNLaNbVw0TVk1EPbouhqerwW0wvYs5U+99fwVh6U5xjw/e5npqS71zRF1loey0XfVCQ4aqVhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 03:16:10PM +0200, David Hildenbrand (Arm) wrote:
> On 6/9/26 14:04, Lance Yang wrote:
> > From: Lance Yang <lance.yang@linux.dev>
> >
> > mthp_collapse() uses mthp_present_ptes to decide whether a range has
> > enough occupied PTEs to try collapse. Swap PTEs accepted by
> > collapse_scan_pmd() are counted in unmapped, but are not represented in
> > mthp_present_ptes.
> >
> > When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
> > so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
> > then checks the PMD-order candidate using the bitmap.
> >
> > With max_ptes_none set to 0, a range with 511 present PTEs and one swap
> > PTE no longer reaches collapse_huge_page(), even though PMD collapse can
> > handle swap PTEs up to max_ptes_swap.
> >
> > Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
> > through max_ptes_swap, while lower-order mTHP collapse does not currently
> > support non-present PTEs. Keep non-present PTEs out of the lower-order
> > eligibility check.
> >
> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > ---
> > Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
> > case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
> >
> > [1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com/
> > [2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@redhat.com/
> >
> >  mm/khugepaged.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index b12187709f6d..617bca76db49 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
> >  		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
> >  						      offset + nr_ptes);
> >
> > +		/*
> > +		 * Swap PTEs accepted during the scan are counted in @unmapped,
> > +		 * not in the present-PTE bitmap. Account them for the PMD-order
> > +		 * candidate.
> > +		 */
> > +		if (is_pmd_order(order))
> > +			nr_occupied_ptes += unmapped;
> > +
>
> LGTM, there is a bit of opportunity for cleanup in the future :)

From my point of view, accepting the mTHP khugepaged changes was essentially a
big compromise on how much it adds to the mess of the existing code base, and
AFAIC we shouldn't accept any further major changes until we actually sort this
mess out :)

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
>
> For example, as we no longer have the VMA here, collapse_max_ptes_none is
> imprecise in uffd VMAs. We might try collapsing where there sure is nothing to
> collapse.
>
> We could likely handle the userfaultfd_armed() part easier: some indication that
> we must not have any pte_none() would be sufficient.
>
> Also, I don't see a good reason why uffd would not be allowed to collapse with
> zeropages ... it's really just about missing faults due to pte_none().

Ugh uffd.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

