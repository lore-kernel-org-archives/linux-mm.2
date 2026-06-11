Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6FCCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 15:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E38E06B009B; Thu, 11 Jun 2026 11:10:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE8CC6B009D; Thu, 11 Jun 2026 11:10:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFE9A6B009E; Thu, 11 Jun 2026 11:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C198B6B009B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:10:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A35BC213B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:10:24 +0000 (UTC)
X-FDA: 84867967968.02.373B545
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 22E3D40015
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 15:10:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=h0YRGmiU;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781190622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3HxeAVNS/UOxAsIyrZo4OUMh7E2TC38v0xDmizeD57U=;
	b=DIko0NAwccKoT7MEbdaNEdXIsy31YLJ5bieKYDE4EWR73Z2+xYNFDMP9Mb3D3yw6dhPT4f
	Ctj8mX64YQGdZdkXTwrxVi6YEfQ4wdI/3RJ8Hq+wvle7wnzOALwe3WRyBxN74QH1tOJO8o
	qcLo9TuC/UhiwLIb7pmS+GGaZpC2J/Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781190622;
	b=nuPqS3lBKoY0HolQarVtWmbHS4MYWXxoysA9NgtRh2Gr0+WtFgpVzPPiPSi0sSLpNAj1WW
	gOy2WUrnbreZOEkT03Wyi3+Kl/GTWH8i+mOh5ux2P8veVaCG3yL5jS4zziUy2m1W+GvsnB
	ePqv9Lc4phyZCJx7cxHO9yHdKTlAWRA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=h0YRGmiU;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3HxeAVNS/UOxAsIyrZo4OUMh7E2TC38v0xDmizeD57U=; b=h0YRGmiU0nMFVgeJF612l0xWmr
	56qRbqJVEvjmESKxg2obet4KEItoYlDQT3fzZwtx0udB+3OnAnZIDm9/9Q2aKXRMYUE3GKA45paTW
	S79a40768cpnscmGks123yWlU1EGpvgcX3W+a9alFL4l5nz5GXooCe67Agi8MdNJ9GCLSLD+VvSx1
	Jlc3D00KOZf9yQ3CGChYAHrUXU46ypU8lsl506EIPgWdW7d4oQCCYHxCnruc4ivNNqM5gYS6YX28Z
	wAtIcLBOdaHEMapWera8mTm91G0Zc+Gyk8kAVX0DIv2CBFiOVMIrF4YfAZrjW+aphjtopmZf80+D9
	QMUWZOtQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXh2w-0000000284F-1uLI;
	Thu, 11 Jun 2026 15:10:18 +0000
Date: Thu, 11 Jun 2026 16:10:18 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nikolay Amiantov <ab@fmap.me>, fuse-devel@lists.sourceforge.net,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, fuse-devel@lists.linux.dev,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
Message-ID: <airP2mGxFu8yw6Ho@casper.infradead.org>
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me>
 <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
 <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
 <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me>
 <aeFuarTL7xBbut0F@casper.infradead.org>
 <CAJfpegtAeyMRENdneJkJrMKu8Uwnyk9LYBThjvTrFjHmPr6O_g@mail.gmail.com>
 <9fe5ff50-4c1c-49ee-a8c2-4cacc3c6781d@fmap.me>
 <CAJfpegum=LJTCGqMUfLHehQE19kgdZbE2eXS_002fdpX_sd6jw@mail.gmail.com>
 <aiq_W6PD7dZhTYPL@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiq_W6PD7dZhTYPL@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 22E3D40015
X-Stat-Signature: p6j1xs9b45un64t6u8nbqsmat1z8dci9
X-HE-Tag: 1781190621-228724
X-HE-Meta: U2FsdGVkX18HQavKGCIkKoq9tRvpWKK+0WnslcRLmsKYNGrpMB8Hy3U/7yOSvxzVQXwD4ZBKbpGgSpWcXHF6+m8JD1BA5b0iL3ByKZ+PSoAy4EhjoZMa6ufFVH1ZQsi/nNbvERE4DrRwngPx7nmuAFSEUAQAq8e36MfZK7vxfTDgyY+g1lGX+cJijpRTCP26gStX08HIehWPR++T8rzLdDRIRS31fQKuL3UJSNH2ttjzMwJaIdMxNZTAdSbMs5LkeeWcA6LvDQCWl8B+QRA33tYQMLCB81XNJkb6ralwPhCR+gFGyY4TjOg1CQaTTBbfdXL7uWw2MhNcHT7B6fKBQAiQ1gnbVFmCm7BN2gbE+LfNpHSNgYHDgRwlsqm702ZyeVNFGklvEVeo6xWPJln4pgitHz4ri+VDyswSXGwdrgEKwB5fU/wAXtF+bb2muaK4dLcZHP6ynam/CtBJ4fOcHB/dlSSKAPNFgVM1CSNgmG6QCsnFniM5EckS2DGPPoobndlSml6X9/DqDkBcyBzXTj4qaFZcNBFnzJ6OB0Tx6040/TqQZ/sLkurgGeeu4iDvFqT1oG8857Y+M/jXW2NIdiMdUeqVZQ7oPb2cqZRapJxfOQfNMgmdi1338id1XOpuNvCcvtO4Y+bmloJK2UrHJOcws1bpxKqj1VCAGy/Vi+BrsJH6GT4gsUO3zWczXmh8u2ZqkoJyIrK+vr54zZCZegnzvp7O1s8UAN89CbzTbBdfoNstijEdI0yI7hYgwb7Ox1li28ZoIRTD49Gl82Es5rWGgBMOE2dqFVCdVG6iCQqwJaS9AmcKiGzTSEbz8c8wjlEtj2fhEktnF6TcN5tH9XpY2Qjxolnzn3UDJhqbbZ9UnOqZ2d19tYBTtvUB0gCCNliWwICZYrAdyRMeuszwFEzZQpD+kw8reUS2+5rOwWlS8oI9ZAdZvbne2l7Vkpi00TO6KM1AcIuDdvUJZr7
 eeKHP3np
 JWidHE9Mz4+w9ua3xUV6oO00isTEf00RE3MVMBDZLjMvbpaa4S5YR4PPLCJjXmUew36J4vN+uBCyMq4MvMRvJ0otDOQh1h92LVsrYnlo5B2HjBkXR9jzdkOzKgYu4zh8R4EeQwt4yGakfjfg95NeR2Pq3Rwp9K186Ef7S+xjT6C4THdMxsbCvP2L92PlqpTjO/hcHkwafXHUbs3i/JdJJjzibxAf3NotTcFuro9CSSJ0gqbxfHxrrHVH6yLlT90SN/jdd8BlEigDSMCo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 02:59:55PM +0100, Matthew Wilcox wrote:
> >                         copied = copy_folio_to_iter(folio, offset, bytes, iter);
> > 
> > +                       /*
> > +                        * Has the folio been truncated?  In that case we could
> > +                        * have been copying stale info (including zeroes after
> > +                        * EOF) for a distributed fs.
> > +                        */
> > +                       if (folio->mapping != mapping)
> > +                               break;
> 
> But we've already advanced the iter, so we need to rewind it too.
> 
> 			/*
> 			 * A truncated folio may contain stale data
> 			 * from a distributed filesystem
> 			 */
> 			if (!folio->mapping) {
> 				iov_iter_revert(iter, bytes);

s/bytes/copied/ of course.  sorry.


