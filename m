Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6011CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 18:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE558E001E; Mon,  6 Oct 2025 14:04:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5C98E0002; Mon,  6 Oct 2025 14:04:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC048E001E; Mon,  6 Oct 2025 14:04:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF5E8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:04:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3731C05A5
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 18:04:32 +0000 (UTC)
X-FDA: 83968464384.17.CA0A9F2
Received: from fhigh-b6-smtp.messagingengine.com (fhigh-b6-smtp.messagingengine.com [202.12.124.157])
	by imf30.hostedemail.com (Postfix) with ESMTP id E197280010
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 18:04:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y EIRcNU";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Auk/0g+h";
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759773871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvRmitREcUsAIl3c+ISPdevfWOPSl1oIN+oRFP6Q4Mc=;
	b=nPyB5b9snjioSbJqzcWpFWf2nn1hxQ5ind2IiLnWt3Y4e9olHWzkGf9cEE4iRQ/P6PDFlb
	nteLOTM10ywk7Elw1dlRay4wOf0aDV2Q+NasFtyI++MzMtIT0nbNJl1CmUUctH+LqgOn0o
	zhizvrp3aOszFsgmk43PnB/1xN00/Ac=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y EIRcNU";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="Auk/0g+h";
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.157 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759773871; a=rsa-sha256;
	cv=none;
	b=myFLl8teLG9tJuoT+cRrbh84BesW75n7uLSRPFhn+m12Xp3SgE035fKtow2lCtIvk6wB1S
	tiHrlUWkl4/w0clYcUPI22V11BETpWnj7aW8dmhwWzSmnqKc9Tl4ajr6npxdNEKJXWW7TB
	OZVfdpbcXVUit2rPCeqiRNp9DEHUga0=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id DF4167A0127;
	Mon,  6 Oct 2025 14:04:29 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Mon, 06 Oct 2025 14:04:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1759773869; x=
	1759860269; bh=mvRmitREcUsAIl3c+ISPdevfWOPSl1oIN+oRFP6Q4Mc=; b=Y
	EIRcNUYhfrPGY19vO2hpSwLknu6Q4o6tCDjyHmm8v+9rU12jnkWTkXJi00vm0Kf/
	5JoEk2CifeTzzxv9CJKgQX1gX1GBgmyW1gHFhHKcC23Eix7raf0mEDhwcXtKa4eg
	HMMrILVv8x7qTinIxgRVnbMl8538/zxxY+K0ozoh7yZVxq3qoSxKL2C64QkuPZIQ
	nSyy07if6Pp8OFcuprt8KElOhYlciQ92qnqbgpnGY7lZkATVvOCT0ckS56upNcDD
	s8x4Bxx65xcLtJIOKoFAerSBJ61/tLmdY68p1FNZwELg/i3s04IoZBPlntKVXZDG
	Xz5QW2qj6OdRJlcxfwlhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1759773869; x=1759860269; bh=mvRmitREcUsAIl3c+ISPdevfWOPSl1oIN+o
	RFP6Q4Mc=; b=Auk/0g+hdxoQ3NNFMr1/+2KxC1flPJFtsHTJHXIrFFDmJzuJ4On
	0yAG0FoK04ncv5SVUN6Lz3D1dODTYdKIpbf6Q5VTFAefiQvIb0YdaSm21ogqmEXo
	jZ+OkCO7wE2AIyGZPkYckyYSmS7h/1rqTkp7er3hqQPw5AYclOVdCdzZ3Tut0Wff
	G/oBE+j6qqPuBvuZpzdcKSLjRhBci48Hp1zeGrMFmeh5CPfFpS+i9VnhDBvSVnQ+
	1o8Ngzeyb7Glrup2L6vHTIS5/yfXhAg3S3BpKhMFjTmP3nrzhZyE1uA5dGS96cxk
	ZADkyCJgGjRSX6kcqBra2E0x0MD6Dz+ABqA==
X-ME-Sender: <xms:rQTkaNw84cZ5zCKLnFQ_I-ArYHhp9lCooWVyw2Was1QbpvH7_xAxNQ>
    <xme:rQTkaAWT2R0eNX6ZfL_2MTvT7-5IQ7ZKOrTFqa3Z7L6slwgzQfIi3nN4bT7P5QuTb
    7HmFWtsSYhJ0SP8HkdtJn3Lug9PkLI8B-2NNx8o9NezaUrOxqFY_l0>
X-ME-Received: <xmr:rQTkaB_vc2qTV3Bb69BpuzJOmNUVzz6sPKQbZc4xXjDFdj-4QYCNQeh-cpzc1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdelkedvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvqeenucggtf
    frrghtthgvrhhnpeejheeufeduvdfgjeekiedvjedvgeejgfefieetveffhfdtvddtledu
    hfeffeffudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepuddt
    pdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehtohhrvhgrlhgusheslhhinhhugi
    dqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrggu
    vggrugdrohhrghdprhgtphhtthhopehmtghgrhhofheskhgvrhhnvghlrdhorhhgpdhrtg
    hpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheplhhinhhu
    gidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:rQTkaLshyacJTOxqkAYV_Mq3psXLsryU-csILR2ICVVXNMthP85QwA>
    <xmx:rQTkaJ3HFfs5bn3Sz3X9Up-7-8CMZxnST_jVVVDt5CT1IP7fISuyfw>
    <xmx:rQTkaIQcy2Z0EL9aAdbAsUlNMqEWIprPGhmJ0l1P9k9szOgHTiYI4w>
    <xmx:rQTkaFd-RIs73pUY1abGNwXqu7TqMFPJAGAxtP9ZaBIiF_i0ZWnnPA>
    <xmx:rQTkaOVgd5OZygrHjAovjkvWOnGwKWmsAixlN7Cm4w3ouWWnmCAP96nJ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Oct 2025 14:04:28 -0400 (EDT)
Date: Mon, 6 Oct 2025 19:04:26 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Optimizing small reads
Message-ID: <5zq4qlllkr7zlif3dohwuraa7rukykkuu6khifumnwoltcijfc@po27djfyqbka>
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
 <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com>
 <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
 <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
X-Stat-Signature: ek3im5t513jadtqqyef4j5wk6eqerm5w
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E197280010
X-HE-Tag: 1759773870-824641
X-HE-Meta: U2FsdGVkX19M7+H6o/EDG2zPZ/inLdjLp3jxQ8ywFp6fW15y7tLP4nMwgIPYv5pJzUPETfscfOhDmjtNayh0thOIZPzCj7/p+9IKGt4xmZMwqP4B1teOJtTgvIGiK99NoziZrQpDUApD1z15VlYNDT82lqpFPVk4V+cf40XRrcOWJfFr76tn1XtSwa9daKwE3JyIYr30+tir7cN+Bi0ZQgQqEugG6NCrSowaAYXihFdzdTzmfHjWkkZqcA44Y2ms1qVmfg7Ik9+tTPo6HXcjgbTF3bJTg7/lWuqc1UHw3AAFE7ARAo80Ly8cES15crKy2kqRVQc4uQmH7hrwy1yVWXwTm94kaoViDrnh7L9PKHaqXrQ4lACHzReoUCLNeU444brNWmHLvRKru1oOA6MItX+mpXwrSsRt28vfKb+PmuMquyX6Mshp+7732oYtruWgDsr+B1r6grtqGf6PghnDZhi7Z8KPb1tt4VmctUnmGnuJuPNlrlNpkNHd86TGQ/UJmFWzZ3Rd3B5vue+9KLJ5oppxJQ3j+puPhX2ku1BUh5Rfh8OD4V+lDUFMGwWDV/Prh0HgJa0qmDtX1yZDdetU2RGakbpDZkDwPRVIpF7KlXNQbLcYCzaqcrqfvKde2hAUCC76JxtyQr0Qt15URo+qUZhVjTlQ0tz05k8EgU30yp22reZX0ZpFXIxXY6aO/DGqpIj7wiZCz59elD8QJA69akoh55tq+L2RXLLHtquHI1YUhydV5Jni6k98c65fvNmh8jWuXHgLAgJRSWtpNBuPsrg2FpNHNCk1kTtFQJAP6BsFDU6OkBUXDwHQSzY3VrtyGyv6bBWHmL4O5DhylSzbEmHIi5UdsKJpFxN47mSCjvoxxMntZ40TdcvhBCUFz5m+K6KkBe0SHboClkRDBEWUfxXZy3TrbM7e5E3oyx4gB/a2ubSnWlD54x1QdN8/MhLpe8kcgW8JBD8XOnNZBfc
 L0aRVE0J
 aVJTGD2fG/28IUA5hMklsCQFEvwCT2Gj4GI2k9zZoE2RuObMrDyA89IKHSjd5oF8So9OvM/A3j2Y6dYk8wnDYjYEJSRIl6URHoSyoc4hak55BopJihwMfUtCEVuCH76oVtSV3Pvqz2tYJrhAFIgW4iqDax0TdKtNDpf+8DJhTePKB1eB4UfMv0bYsqd73GyC8+3YxHOwGzvYpbCLVs5p6sZ00i2Fq6dl9KqV6Rvf3Nbn71PE7ZLRuOqkWlNdoaXnV6nPFx5a7SYX90YUqALsMlUV82jXFgMR15eMwKo8V69430nfDJ2dRsry0nKII+JKQh7xdEJymBiC06Ch6iFHpRT64CusDubRYuiVa0x3EQtnc0heC2Ajyc7c3K2762/I7fNf/4wlDKHzlmtRDZGDgqqmHzA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 08:50:55AM -0700, Linus Torvalds wrote:
> On Mon, 6 Oct 2025 at 04:45, Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > Below is my take on this. Lightly tested.
> 
> Thanks.
> 
> That looked even simpler than what I thought it would be, although I
> worry a bit about the effect on page_cache_delete() now being much
> more expensive with that spinlock.
>
> And the spinlock actually looks unnecessary, since page_cache_delete()
> already relies on being serialized by holding the i_pages lock.
> 
> So I think you can just change the seqcount_spinlock_t to a plain
> seqcount_t with no locking at all, and document that external locking.

That is not a spinlock. It is lockdep annotation that we expect this
spinlock to be held there for seqcount write to be valid.

It is NOP with lockdep disabled.

pidfs does the same: pidmap_lock_seq tied to pidmap_lock. And for
example for code flow: free_pid() takes pidmap_lock and calls
pidfs_remove_pid() that takes pidmap_lock_seq.

It also takes care about preemption disabling if needed.

Unless I totally misunderstood how it works... :P

> >  - Do we want a bounded retry on read_seqcount_retry()?
> >    Maybe upto 3 iterations?
> 
> No., I don't think it ever triggers, and I really like how this looks.
> 
> And I'd go even further, and change that first
> 
>         seq = read_seqcount_begin(&mapping->i_pages_delete_seqcnt);
> 
> into a
> 
>         if (!raw_seqcount_try_begin(&mapping->i_pages_delete_seqcnt);
>                 return 0;
> 
> so that you don't even wait for any existing case.

Ack.

> That you could even do *outside* the RCU section, but I'm not sure
> that buys us anything.
> 
> *If* somebody ever hits it we can revisit, but I really think the
> whole point of this fast-path is to just deal with the common case
> quickly.
> 
> There are going to be other things that are much more common and much
> more realistic, like "this is the first read, so I need to set the
> accessed bit".
> 
> >  - HIGHMEM support is trivial with memcpy_from_file_folio();
> 
> Good call. I didn't even want to think about it, and obviously never did.
> 
> >  - I opted for late partial read check. It would be nice allow to read
> >    across PAGE_SIZE boundary as long as it is in the same folio
> 
> Sure,
> 
> When I wrote that patch, I actually worried more about the negative
> overhead of it not hitting at all, so I tried very hard to minimize
> the cases where we look up a folio speculatively only to then decide
> we can't use it.

Consider it warming up CPU cache for slow path :P

> But as long as that
> 
>         if (iov_iter_count(iter) <= sizeof(area)) {
> 
> is there to protect the really basic rule, I guess it's not a huge deal.
> 
> >  - Move i_size check after uptodate check. It seems to be required
> >    according to the comment in filemap_read(). But I cannot say I
> >    understand i_size implications here.
> 
> I forget too, and it might be voodoo programming.
> 
> >  - Size of area is 256 bytes. I wounder if we want to get the fast read
> >    to work on full page chunks. Can we dedicate a page per CPU for this?
> >    I expect it to cover substantially more cases.
> 
> I guess a percpu page would be good, but I really liked using the
> buffer we already ended up having for that page array.
> 
> Maybe worth playing around with.

With page size buffer we might consider serving larger reads in the same
manner with loop around filemap_fast_read().

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

