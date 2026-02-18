Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC7E0E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B496B008A; Wed, 18 Feb 2026 06:58:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED0B86B0092; Wed, 18 Feb 2026 06:58:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFDE6B0093; Wed, 18 Feb 2026 06:58:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C83D66B008A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:58:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BEB01BC4A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:58:22 +0000 (UTC)
X-FDA: 84457429644.04.3E6DC5C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 476D840005
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:58:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oI1iLkOa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1h7Rq7k8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oI1iLkOa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1h7Rq7k8;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771415900; a=rsa-sha256;
	cv=none;
	b=yd1EJT7mr9Iv2iJ/AaqdVONP67ZoCEqrsbkckbvUlCVw0TUmpfx2sE285I0LBvUkCvmZKj
	sizBjAAddZGiiB4zBkSq2WIkr84xpKjn+Hq8R5hFquJ9NC+UtSAOZmcleLS+bKEYSxFCvt
	ZRlc2/Y6J4iHWni+6fJ8TvNge2jamQk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oI1iLkOa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1h7Rq7k8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oI1iLkOa;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1h7Rq7k8;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771415900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FiROjUctooIccoETQdxHZwwRDcFnuLyqVaPcfeqR5Zc=;
	b=5T64TBOk0LB8ZBzt986qD8CoTW2oaYXtXmEYTgBEdRZse5yzotx6SA67hbpx0fiXJkbGZo
	zuQ8eZjLfhabOkJkOeEQT5gMKvhrsEu0lWW90uB8Mo0XkCfA/6WQWuCkVcaZJTT2JPMeyP
	33FPJbdJEjiQGMXPVgkLwyN9F7KqEsc=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 8FF005BCC2;
	Wed, 18 Feb 2026 11:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771415898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FiROjUctooIccoETQdxHZwwRDcFnuLyqVaPcfeqR5Zc=;
	b=oI1iLkOaxMtgZcE7+tx864h+xeSTkGhX0Cn+o3ztV3h+oEa07x4NXccSkU2MR6WpbL5vHR
	FvXf/Zl8C65yZ+/a9er3haykiGbuz4rls2txri6qF35LQsnQqQ0JbKkIz4e1/ThypKeQ1o
	4PFa1rzotIisulYttqGFYWPmarFois4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771415898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FiROjUctooIccoETQdxHZwwRDcFnuLyqVaPcfeqR5Zc=;
	b=1h7Rq7k8F5dgmFfKSkfXBpxT2GoJfJYSplzHG7PA6xZAX0hr+WrvwRUhQO3DsEb6Mi6pye
	ZmB3MbBNnk9kNuDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771415898; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FiROjUctooIccoETQdxHZwwRDcFnuLyqVaPcfeqR5Zc=;
	b=oI1iLkOaxMtgZcE7+tx864h+xeSTkGhX0Cn+o3ztV3h+oEa07x4NXccSkU2MR6WpbL5vHR
	FvXf/Zl8C65yZ+/a9er3haykiGbuz4rls2txri6qF35LQsnQqQ0JbKkIz4e1/ThypKeQ1o
	4PFa1rzotIisulYttqGFYWPmarFois4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771415898;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FiROjUctooIccoETQdxHZwwRDcFnuLyqVaPcfeqR5Zc=;
	b=1h7Rq7k8F5dgmFfKSkfXBpxT2GoJfJYSplzHG7PA6xZAX0hr+WrvwRUhQO3DsEb6Mi6pye
	ZmB3MbBNnk9kNuDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BFD703EA65;
	Wed, 18 Feb 2026 11:58:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WvOCK1mplWlBfAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 18 Feb 2026 11:58:17 +0000
Date: Wed, 18 Feb 2026 11:58:16 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>, 
	surenb@google.com, jhladky@redhat.com, akpm@linux-foundation.org, 
	Liam.Howlett@oracle.com, willy@infradead.org, vbabka@suse.cz, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions
 since PTE batching (cac1db8c3aad)
Message-ID: <cdrrvtzy76f7wplcrls3pbfe37kzrvzsrlaed7glg2cq6j3yob@wjbjklvovpl2>
References: <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
 <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
 <nfrvygkft42c35ymgupwggrc2hrbatxaa6cn3hjxffrvhaprqg@wjg4ye4uv5go>
 <8315cbde-389c-40c5-ac72-92074625489a@arm.com>
 <5dso4ctke4baz7hky62zyfdzyg27tcikdbg5ecnrqmnluvmxzo@sciiqgatpqqv>
 <eaa6be47-f1fc-4b88-b267-5aa38e3ba2a9@arm.com>
 <340be2bc-cf9b-4e22-b557-dfde6efa9de8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <340be2bc-cf9b-4e22-b557-dfde6efa9de8@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 476D840005
X-Stat-Signature: yy8taatzs63ditbayggpepn5oe6wn49c
X-HE-Tag: 1771415900-174530
X-HE-Meta: U2FsdGVkX19/aGxMYL7yJkbuWTDMRNBAEW90ZAURCYJK+Kf3Wam214CIJMeZl622a3oXD5i1kHwDl+NSN0QXleCwVFw8zzob+taoKlEHsGMWQl/i+Wr89NBIDVVFprPSEmYiwNLGCFvtQNYj1daYI1qJl8nxd5riziQMzYmND5rYf81uPcYScS1o5SV67F186xKAoi+hzU/wstx4XSk5dKJ2W4rw7SYxLKAxHhOcVGvkZ9lvSl9GSwSMr8d4CfhIAP3xFXOqNPcymJ0c/0uopYLFU/icF+VH6KoteT0ECS+A2sGEOUna4x2cHHrSX8HoGqFbRmrq7IQsfc3wKT6iqHLx+hJ/WgHZ+0MB5Rz73AD1PzsD3WwmPzYyB4BR83tmTxKTvM5P/s+DcinHc+cHUD40T9xQPRv+gZqBlAiOGKAdvguBN17n55d/OhDHUpZA4XDxJnGovwGxj8H+qOpEyt3BhdekpZlZ2gWMfrfiVqOxViV0WmB1BUAB5EPCPSSEIgZv+zcLFUSRObnIqEuoa64bxBf1xueTK+mU0SJoLh7vMJe9UjhsRz+pkyreixRQCISY0Nqj7cCOyKuv3Epk1V7qXkBgC5m2eqhZYcnUWhVaojImAlHolVPWdy95b22LEdI8eKsaFcKzw6FTPMkN8mITbivrk8dnI/ZqInON7Zn6DRUebbQASd9xwbMHQxDttVklZBUQmwf7PcGalzrOoSTQYo44PMAwTSPkUt1Bz5Z3ShgR2uWedOl91Xm4toRNDpO2Y6LzJFYXSjjgOnWYN7aJLmNa82rvsjjHHB2sPBF5Mk70JP22UxcMxf+hWPtcfQmopZxJBOjBfykKNZn34N0WuoWb502vZ2QgomgsiA1mVUVTi/bvQxjAwxo5x23zDHgbuGqbdHnsaPUUV8ZzGSNPp+QM4o0IUnzMHtr7SfxAhEJPBRBFtBVfpMlTDtj/FGP5qX59yQg+FG4D6GU
 7Lzdml2D
 +5darv6czhs/39TOTRBUMlM7yzTeeEzmDxp7eCcmcsn0iJc7JFXF+Vz6e4yMubNVLI/YsKIKjbotNyp74B3MdrGSRS2fFDzJyyN7IFvg+MDB8pp2izhuzqtQzDuRuKTCmGd5S4KZXYPdeiwB4DZk8QM1/6Tdi8SMJRryLXlSfzyHyjcs7EzdnIrgWkdkdAfZ/mJxQdDbsaM7urS/eaG6Xdx0q6qYqa4PXoHDX5tIYOJwo46QWQRUCm+ytRNvIlJ4px0Jhg3lAd0qIyD+pjIgKyyCWgzMTxukGpKQew4Ppb1etTDU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 11:46:29AM +0100, David Hildenbrand (Arm) wrote:
> On 2/18/26 11:38, Dev Jain wrote:
> > 
> > On 18/02/26 3:36 pm, Pedro Falcato wrote:
> > > On Wed, Feb 18, 2026 at 10:31:19AM +0530, Dev Jain wrote:
> > > > Thanks for working on this. Some comments -
> > > > 
> > > > 1. Rejecting batching with pte_batch_hint() means that we also don't batch 16K and 32K large
> > > > folios on arm64, since the cont bit is on starting only at 64K. Not sure how imp this is.
> > > I don't understand what you mean. Is ARM64 doing large folio optimization,
> > > even when there's no special MMU support for it (the aforementioned 16K and
> > > 32K cases)? If so, perhaps it's time for a ARCH_SUPPORTS_PTE_BATCHING flag.
> > > Though if you could provide numbers in that case it would be much appreciated.
> > 
> > There are two things at play here:
> > 
> > 1. All arches are expected to benefit from pte batching on large folios, because
> > of doing similar operations together in one shot. For code paths except mprotect
> > and mremap, that benefit is far more clear due to:
> > 
> > a) batching across atomic operations etc. For example, see copy_present_ptes -> folio_ref_add.
> >     Instead of bumping the reference by 1 nr times, we bump it by nr in one shot.
> > 
> > b) vm_normal_folio was already being invoked. So, all in all the only new overhead
> >     we introduce is of folio_pte_batch(_flags). In fact, since we already have the
> >     folio, I recall that we even just special case the large folio case, out from
> >     the small folio case. Thus 4K folio processing will have no overhead.
> > 
> > 2. Due to the requirements of contpte, ptep_get() on arm64 needs to fetch a/d bits
> > across a cont block. Thus, for each ptep_get, it does 16 pte accesses. To avoid this,
> > it becomes critical to batch on arm64.
> > 
> > 
> > > 
> > > > 2. Did you measure if there is an optimization due to just the first commit ("prefetch the next pte")?
> > > Yes, I could measure a sizeable improvement (perhaps some 5%). I tested on
> > > zen5 (which is a pretty beefy uarch) and the loop is so full of ~~crap~~
> > > features that the prefetcher seems to be doing a poor job, at least per my
> > > results.
> > 
> > Nice.
> > 
> > > 
> > > > I actually had prefetch in mind - is it possible to do some kind of prefetch(pfn_to_page(pte_pfn(pte)))
> > > > to optimize the call to vm_normal_folio()?
> > > Certainly possible, but I suspect it doesn't make too much sense. You want to
> > > avoid bringing in the cacheline if possible. In the pte's case, I know we're
> > > probably going to look at it and modify it, and if I'm wrong it's just one
> > > cacheline we misprefetched (though I had some parallel convos and it might
> > > be that we need a branch there to avoid prefetching out of the PTE table).
> > > We would like to avoid bringing in the folio cacheline at all, even if we
> > > don't stall through some fancy prefetching or sheer CPU magic.
> > 
> > I dunno, need other opinions.
> 
> Let's repeat my question: what, besides the micro-benchmark in some cases
> with all small-folios, are we trying to optimize here. No hand waving
> (Androids does this or that) please.

I don't understand what you're looking for. an mprotect-based workload? those
obviously don't really exist, apart from something like a JIT engine cranking
out a lot of mprotect() calls in an aggressive fashion. Or perhaps some of that
usage of mprotect that our DB friends like to use sometimes (discussed in
$OTHER_CONTEXTS), though those are generally hugepages.

I don't see how this can justify large performance regressions in a system
call, for something every-architecture-not-named-arm64 does not have.

-- 
Pedro

