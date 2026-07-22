Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE1D0C44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:38:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756BB6B00BC; Wed, 22 Jul 2026 12:38:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707706B00BD; Wed, 22 Jul 2026 12:38:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620116B00BE; Wed, 22 Jul 2026 12:38:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AC9D6B00BC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:38:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B420014022A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:38:55 +0000 (UTC)
X-FDA: 85016971830.08.CDE462E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6615940009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:38:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZY6Abulw;
	spf=pass (imf04.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784738333;
	b=PUnZ65OMOq1H8kONCBLHE2nTpmm7F/Y7RW9288KkWPRTjGNVFU99Kq1FSSepMlgqxe9z2I
	MyMKtUlVPIqQaWmNZrT4diBCBNMXkwvGNEnWPiGtcoxoUtvb/thJRxU/ptKWka1PHvdwbd
	Tj21gK5PjxFhZJOk7H0zB7nI+OSgZSo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ZY6Abulw;
	spf=pass (imf04.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784738333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a2rtpjFA91mmSgGUi28QsUrzyWT3Khnx+fSWp6f1ZBE=;
	b=3lhOKGr1Z6KNk2O7yOJJXX4K1xUXbD0fRJW4vVRovDDVhuil0fYfjKgmAFTmHjx5wgW6XP
	c0z9OBL8zNRjF562O9NdE+h/1z5BPPfTI72WKGeGmpfmqJKkNKCn5saiTZGZCLzhAIkBv9
	2U4akPacLk6S7EnlxP7XcBTyjKS0pEc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=a2rtpjFA91mmSgGUi28QsUrzyWT3Khnx+fSWp6f1ZBE=; b=ZY6Abulwpmy8e792mYgY7MIK3L
	Q+2Ou0P1npTb4PtE3lqcfi4YQmaF20mzCQD0pHGhCXsWpkPp1IQq0UblSTfkTiWlwnINRFSAGsO/K
	oMInIqfx7ne/W+XX34P4oY3cFHd5gApMUONnqhEatvCY5PxsCz8dVhM9YjgYsn0PMwaeM89KMKvaS
	csD2/6tKF0U1MRo/DsP7I0Wwz0+RgdymqQIomI6K6+tTBqH7M/5pxl9qlEpbSVVuPIkrsgIeuA1zA
	Sy0f5RGRKdokAEw4nYBhxWd7o6LrZUExnaOJJERE0SG62i4NZ2eVXRd10GoRYe/7prt6cYcTwY+x5
	8F/kLR8Q==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmZy7-0000000CMsS-3bFo;
	Wed, 22 Jul 2026 16:38:52 +0000
Date: Wed, 22 Jul 2026 12:38:34 -0400
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Rik van Riel <riel@surriel.com>, Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 14/19] maple_tree: WARN_ON_ONCE when allocations fail
Message-ID: <laaqmevk454smc2uotd37rwjz7ijekfhv4hyv3wgbp7bql2bas@tqkyygz4wm6t>
References: <20260630190843.3563858-1-liam@infradead.org>
 <20260630190843.3563858-15-liam@infradead.org>
 <20260630160208.b6d1e09d60c50c8fbb80e830@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630160208.b6d1e09d60c50c8fbb80e830@linux-foundation.org>
X-Stat-Signature: qmk416hfjrg4n3awi1gb75uergofjcwg
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6615940009
X-Rspam-User: 
X-HE-Tag: 1784738333-950501
X-HE-Meta: U2FsdGVkX1/BQqn/WKbPwmZHdnyWk5n9lqDSNW26X6aHp9J2pKB9dNa4FIhUefLx7BNhwUaendDZ3HYsvM1jTqlf8rl6rOEaNb7hOyDTvBJ1d68noMYdMMWybvd0PWyp95rAWLD4y39CpKF3gs88PxL1qyIOG9sNmjFIcAfafyph9eIugvEbX4VJbAL74dDsgCZzgyrocTeYIRRXWw430fRvRp3Il7PFS2sVrnAcDyJzNpvS4yCDEapJUTWsOOTivZ/w2DvjeWdBqvlNceXjzT8tZIAKPhZ2AvzqWHQAfGJD+bEutypk1kdi7JjntSmNAp2nCA3S85Pdss0Z9oC4neVUjqXrijFjf/wIiCEHYb1Rm0Qj783rT2toG6ybApaPj2B/KXxmfc9DJMcPcjwsyrN+y85tuAQgrq6tabMxtNFxxptF/IxB5jgtM0OlzeCX7WSS6h0cEYHUVH/IfNc3EJbepXbNgK4VGesbRC+vGgLb3fpdNtqPT4WsQkmYK5MeN7MPno/g4ivw9AvwaVvtd1QuFqY4YPdLAfPOHSakkt1zR55Y5ac1kogNS3e5PyefgcSAuiP4qKTBDXubPkkmCDTQXo6z/fEsneUWwOR4Eq+z05yNPnIJ+fptNxUHDLA0htm18wSK2820rgMO/Ig5rfzMMJtDFA5rs6i53qo5xosiEwaPsJByEh9Db6RYCwheypP6/5Z4SdCaZWQUDm/BMmGwodlvhY6C7wX5VPjt/qcRmJw71tdsDpHzJYtqvNq4SqEGUxgCYR09BhWyNNaKSi5+kELRfS9eVCSAKE/iiaqvx2hveKEA38msw2/wzAm6WaD8NK7lrX5omELT2xdqKumAVOngilIDxDWjTXdA56b5O1SL4G3M3XXzrf12wXtsBF2RpWJ5XbGXv62TQ1q8jHmh59emfvGvYAMECVARC7oUbAD7JnLzcQwS5ERxiLoQqTSgnWEu7dXzZXNe8uT
 IR73Sf8Q
 /cVe4Ys2Ty9QMG1oCs4caJUirlVDzVd7zBAENANaDgyitA6sJfqPhlLGeQQWXL/XanEyX9cRRZr3jIpuuMjTNGsQ0csPCCX3xRmV3Tv6gHYEE2G8e8asXbfL3Rpo7EPVJFJRAeXc/6/izu21/9ur0a6LQNH0OHKyW3Ske/sToFyM6fJu68h+PjdHz5iqq9X2p1DSVpYXZxPvfplu5opH+dZKWJINyhwoyI1p/rLpZ+hlRJblk3EjianaMNE95DzqnUScsEnKy4KoF6GtfXlXUSB/QTdFAiVMNdeBtRMqMDwfoW2DSeaHWto8xacxu5i4FyoOuHMKldXLcN0ioN4vPzuyw0jRu8w0tF/kGKbv77pJFM/dJNiQHS4OHTpKVLEushrOo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/06/30 04:02PM, Andrew Morton wrote:
> On Tue, 30 Jun 2026 15:08:38 -0400 "Liam R. Howlett (Oracle)" <liam@infradead.org> wrote:
> 
> > Allocations should never fail in the circumstances that are expected to
> > occur.  Add checks in the code to ensure the circumstances are correctly
> > set up by the user and warn if they are not.
> > 
> > Also add a warning on failure to allocate, which should never happen.
> > 
> > ...
> >
> > --- a/lib/maple_tree.c
> > +++ b/lib/maple_tree.c
> > @@ -5720,6 +5720,10 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
> >  	if (likely(mas->node != MA_ERROR(-ENOMEM)))
> >  		return false;
> >  
> > +	/* Allocations can fail, don't do this. */
> > +	WARN_ON_ONCE(!gfpflags_allow_blocking(gfp) &&
> > +		     mt_external_lock(mas->tree));
> > +
> >  	if (gfpflags_allow_blocking(gfp) && !mt_external_lock(mas->tree)) {
> >  		mtree_unlock(mas->tree);
> >  		mas_alloc_nodes(mas, gfp);
> > @@ -5730,9 +5734,12 @@ bool mas_nomem(struct ma_state *mas, gfp_t gfp)
> >  
> >  	/*
> >  	 * Return false on zero forward progress.  Partial allocations are kept
> > -	 * so the retry path will attempt to get the rest.
> > +	 * so the retry path will attempt to get the rest.  The failure should
> > +	 * not happen as we try our best to reclaim.  The user would need an
> > +	 * external lock with a non-blocking gfp in a low memory situation -
> > +	 * which would have triggered the first warning in this function.
> >  	 */
> > -	if (!mas->sheaf && !mas->alloc)
> > +	if (WARN_ON_ONCE(!mas->sheaf && !mas->alloc))
> >  		return false;
> >  
> 
> Can either of these warnings duplicate the effect of !__GFP_NOWARN?

From what I understand, __GFP_NOWARN is about suppressing warnings on
failures because you handle them at a higher level, but in this case I
am trying to detect incorrect use of the interface.

That is, if you want to handle the failures yourself then you should use
mas_preallocate() that is designed to give status on the allocations.
The following call to mas_store_prealloc() will not need to allocate or
check for nomem.

Thanks,
Liam


