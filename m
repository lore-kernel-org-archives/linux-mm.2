Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7D2CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 11:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1223E8E0010; Mon, 20 Oct 2025 07:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9F78E0002; Mon, 20 Oct 2025 07:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010608E0010; Mon, 20 Oct 2025 07:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E32F78E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:33:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 801A9160113
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:33:15 +0000 (UTC)
X-FDA: 84018281550.29.16770AD
Received: from flow-b6-smtp.messagingengine.com (flow-b6-smtp.messagingengine.com [202.12.124.141])
	by imf06.hostedemail.com (Postfix) with ESMTP id 662C018000F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:33:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="P WWh0Sy";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=RPQW7ZAP;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760959993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRZ4BjerK9cUcInliMf0XjEF50N2fG9lRQU0mINhdDY=;
	b=6mRon1OtI34XPIsNachSLfBlYOS3P1MaJl3FfIT1L7mt1mEte2we96ISZJdtsbrWfwDblZ
	Nz7w+ybZBjqoHY5F51lANb/OYgf1poObT6nNpuyg8bOnM0hmiqmyANQ/s4kfEeWxHBOMfh
	BZFPQZj44F1eLUq7TL/zncRD9cpE+WM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="P WWh0Sy";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=RPQW7ZAP;
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.141 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760959993; a=rsa-sha256;
	cv=none;
	b=ioQ7/a2ilM5rGeyZWi4c8BQk5ydN+WeVhuI9J4b9+HMIJ9NezSnSG1Jv8dpL0bQ1u31++U
	QapMjdL/xMJqD83/JRDO9j5mBucGvzs/x1NRm3pXZsdRBhhIQm7FjKlmGgPGGtUjSPJcVE
	Y6/mBOMyXSpx6nCGJln/vJojjTVutzM=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.stl.internal (Postfix) with ESMTP id E2EA51300522;
	Mon, 20 Oct 2025 07:33:11 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Mon, 20 Oct 2025 07:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1760959991; x=
	1760967191; bh=iRZ4BjerK9cUcInliMf0XjEF50N2fG9lRQU0mINhdDY=; b=P
	WWh0SyPO1+k3uxYMaWlu88KmVT9pMCIE09qyQtYz5Bg9K9ou8JFcBkIJQotgi6Gf
	euz4rE4RBzjmi4CbhY6KPxqfbmVOS1racV6h8GqGkOVMOOifKsOaMzNytxs0p+ib
	fL1UJO+t4+WxRlB41Mh3694tHGzlQ0PnnvQ4iQocM3asucCQeDRmynwvCS3WsogK
	m3HR0+ZzQMQzapNMGTN8pObHUXcw3Im6l+nJvLECFm656CAPS5nwO8iTzbhitpWR
	/JbZSLQ6sjIfcvKGD+xvd5KYmmufLvKXl7v5huQvi+8NvNHvAwFm35KRfCTxRWII
	20UYZQFu/baCOk2ntL0Qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1760959991; x=1760967191; bh=iRZ4BjerK9cUcInliMf0XjEF50N2fG9lRQU
	0mINhdDY=; b=RPQW7ZAPhIufg/YoeBqImEs57mVEOaBQKDkzmmNyXPduXWdtv0t
	yO1BW8GudQPxi0R6sQwfqIobDuszpHhWlDIsDsJMeM/MTEVrB37gXVOnbOGrWyFm
	EJc32MQVuXr4h0DkN53XvTUgapaH9QRPNeCxpH9FyvOp9pAz4EJrw/p6LzujymPv
	9K9i0AVWFkFYsIxivyMMZ921mDwj9GVk0l9Vy1fRymWWF8g4YLMUES6lmJJSzLTl
	wKySnzkkfonVNQ1Mdkr+8waPLUY6YE+2JKQFELyIWDvDxc9fWGU2Q/zj9BFAP74F
	w7lTadfo4QcHjNCwo5nmrUWgiXfkQojbDNw==
X-ME-Sender: <xms:9h32aHumUUDzIqFRZ43Nq08qT04ByMEqywstprrDCDxox4VQYar4zA>
    <xme:9h32aNVXC-SXxdDN60c8FfWlFACri8xKTwVcOHCK0sd2M1NsYK1sk5oqYy99bE2BQ
    8MzJVLcEarKAGxgusxKDmBuO6_stJO7bB69VFkSpLiX27FOmHLT-zg>
X-ME-Received: <xmr:9h32aIXURVBKp4X2LDSBCbxpETQtHFYRfMuk0is_Cgz4NCP5lhGGIswQvjN4Tw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddufeejjeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    vddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfoh
    hunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtgho
    mhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoh
    epthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphht
    thhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsg
    hrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdr
    tgiipdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:9h32aITK6Tc-jz67aCk8xWYGicN90g7xXaW1Rslcj8dyuhwuuwsIxg>
    <xmx:9h32aHErdqCFx9lR13EjZsBlqy5L10SnpUD2eq6l-g5nugJCrFSN8A>
    <xmx:9h32aIRMrlWrW52tfN1Gong4ZbLhXGA89dv6dWMXjAqIkZUS9s4MaA>
    <xmx:9h32aBpsYl5lHv9p3uTO7Uk_I1zdqCod9lPGgWSQkvflLrkhUtImhw>
    <xmx:9x32aBJt64NgONI-Xh-qJvLn26IzfheF0AVvELEnERbHj94NLIo8DjNk>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Oct 2025 07:33:10 -0400 (EDT)
Date: Mon, 20 Oct 2025 12:33:08 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <44ubh4cybuwsb4b6na3m4h3yrjbweiso5pafzgf57a4wgzd235@pgl54elpqgxa>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
X-Rspamd-Queue-Id: 662C018000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rhatp7k5ybuhzhys1531dcfztqx31d46
X-HE-Tag: 1760959993-85071
X-HE-Meta: U2FsdGVkX1+wz6K9PFfMf+UstsuKyexeSI19d6LUoxv9VljFLAmc0EYfdO3xCKL6wvSicZQ5ozNKqdDHVCrjlSbGL2FLgcS8yurwpI2OERBM/2hrmm+t4sWdgw3K4h/9Y9fgU1Ya3yADzcGtetrYiuUgLL85Jc7pFjhYBrVhRAZeppSESJPeGWHj3he5TFfMTUKee5kSLvnGn2coofTOpib/efKc4Ug2Lq1Xq6bfRvoJbVyiRp8TMn7NKZIRIwyxLHuyGFy47MNJLMIxrCvyRFFQ+8o14SFEM6Dn8QsoUEvNx1z7zqWpSw0+SDEno2agdvNHCZZvpM4EddwYHpZFlNbfrushek3r5IB5YESPZAJmucvkuKJ+IGRN0ug1i9cEXuvaTU/qoMwD0PLCpFY5Dn1+KClXvidOwZjVyO9KLKlYdbar2NeE7LVwvP+Va3nIFrnoRwGwKyDDZxIUk4I0yjKrFq4P4d0owZUN0BwQKKy0EYqUSWUpBt8fC0qxyeFnnS3t1P4suXkh9PqvSGnR32FBC5Z8hRqW4rQkcj7u6Bc13ZNrQc49UyeQfeyRb8JLlnLsf4NdYGCGjfLqmRnlLNGzJoX9PIxDYQ+tef7Wd14OyfhARnCF2W0f43lnDuurTmomjI6J1903is8SOkBxU5Z9gerJxbgK80eGCx5IZk32x3jwBBiPNBoUrJBD8bUFziO+3YrBMx0YB3boABSrpze0ZlSQKUsWIgpTZ0ZD+dCUmV2PcQaXknMJF6HDWYCEO6UWVOi7uFL5CN/qaP/KnKBY3OOjsM7Y++yAZNBPVUjmrSFhRbx9uorjrWu0aOB2cPXjteTzijProdEoYuoUdSenD/a0Ql6zQQTqnA9qJYeQmxzm20cUJFutG6JmHBYDjRLXpZfCC8xJq7sAB0gc3x5C/OF+RU6mn/T1QPPtqRLRm/im1pKvI09G61V/QveGs6swE3tzQ88r7m1HiCR
 9SI7OhBF
 w/wT4TFT0UyaBQEEnru3iPKUrZZy/eHz2rR/8K1/2dMKWV9SzovHe50l89+L31k9uXRYoKOZo+rH1mYsNXNLHtj255w3ZMyFz5U5KM669na0dPC1j8Vcq4aT5aj4ABdwgVeJ/zsLQfmrVWJ1UZLGPILyR1z1mNR7Mlm+8wHnDxDQhYZ4rn9rFCbb6g7bboafob7JlCwTezWQKm4VhVBF0C1/fdqF+dv2H31mYPoLCs0Q8T7Z7zMaRbYGFyCReERhBG0E0BhvVBjuid3R3hPuSaeGrOxQvcKdaTWcPJDltNGiqaU3Rbmg+ebCHs7E1+RuSENf//FGs3sRNQSpYM2Agm3zUes/wZ9fFzqz+H8BbVOaouslavWu9/UrMT1QECbaPQcTktIoE9uJbLiScXLdU+UDu20dcUEzAMMVjXv3xgOlBEqOpuQHWjqv36gJthSoRTLWIWBXwXqf7QKmVtcKz9aeHfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 19, 2025 at 09:53:28PM -0700, Andrew Morton wrote:
> On Fri, 17 Oct 2025 15:15:36 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:
> 
> > From: Kiryl Shutsemau <kas@kernel.org>
> > 
> > The protocol for page cache lookup is as follows:
> > 
> >   1. Locate a folio in XArray.
> >   2. Obtain a reference on the folio using folio_try_get().
> >   3. If successful, verify that the folio still belongs to
> >      the mapping and has not been truncated or reclaimed.
> >   4. Perform operations on the folio, such as copying data
> >      to userspace.
> >   5. Release the reference.
> > 
> > For short reads, the overhead of atomic operations on reference
> > manipulation can be significant, particularly when multiple tasks access
> > the same folio, leading to cache line bouncing.
> > 
> > To address this issue, introduce i_pages_delete_seqcnt, which increments
> > each time a folio is deleted from the page cache and implement a modified
> > page cache lookup protocol for short reads:
> > 
> >   1. Locate a folio in XArray.
> >   2. Take note of the i_pages_delete_seqcnt.
> >   3. Copy the data to a local buffer on the stack.
> >   4. Verify that the i_pages_delete_seqcnt has not changed.
> >   5. Copy the data from the local buffer to the iterator.
> > 
> > If any issues arise in the fast path, fallback to the slow path that
> > relies on the refcount to stabilize the folio.
> 
> Well this is a fun patch.

Yes! :P

> > The new approach requires a local buffer in the stack. The size of the
> > buffer determines which read requests are served by the fast path. Set
> > the buffer to 1k. This seems to be a reasonable amount of stack usage
> > for the function at the bottom of the call stack.
> 
> A use case for alloca() or equiv.  That would improve the average-case
> stack depth but not the worst-case.

__kstack_alloca()/__builtin_alloca() would work and it bypassed
-Wframe-larger-than warning.

But I don't see any real users.

My understanding is that alloca() is similar in semantics with VLAs that
we eliminated from the kernel. I am not sure it is a good idea.

Other option is to have a per-CPU buffer. But it is less cache friendly.

> The 1k guess-or-giggle is crying out for histogramming - I bet 0.1k
> covers the great majority.  I suspect it wouldn't be hard to add a new
> ad-hoc API into memory allocation profiling asking it to profile
> something like this for us, given an explicit request to to do.

Let me see what I can do.

> Is there really no way to copy the dang thing straight out to
> userspace, skip the bouncing?

I don't see a way to make it in a safe manner.

In case of a race with folio deletion we risk leaking data to userspace:
the folio we are reading from can be freed and re-allocated from under
us to random other user. Bounce buffer let's us stabilize the data
before exposing it to userspace.

> > The fast read approach demonstrates significant performance
> > improvements, particularly in contended cases.
> > 
> > 16 threads, reads from 4k file(s), mean MiB/s (StdDev)
> > 
> >  -------------------------------------------------------------
> > | Block |  Baseline  |  Baseline   |  Patched   |  Patched    |
> > | size  |  same file |  diff files |  same file | diff files  |
> >  -------------------------------------------------------------
> > |     1 |    10.96   |     27.56   |    30.42   |     30.4    |
> > |       |    (0.497) |     (0.114) |    (0.130) |     (0.158) |
> > |    32 |   350.8    |    886.2    |   980.6    |    981.8    |
> > |       |   (13.64)  |     (2.863) |    (3.361) |     (1.303) |
> > |   256 |  2798      |   7009.6    |  7641.4    |   7653.6    |
> > |       |  (103.9)   |    (28.00)  |   (33.26)  |    (25.50)  |
> 
> tl;dr, 256-byte reads from the same file nearly tripled.

Yep.

> > |  1024 | 10780      |  27040      | 29280      |  29320      |
> > |       |  (389.8)   |    (89.44)  |  (130.3)   |    (83.66)  |
> > |  4096 | 43700      | 103800      | 48420      | 102000      |
> > |       | (1953)     |    (447.2)  | (2012)     |     (0)     |
> >  -------------------------------------------------------------
> > 
> > 16 threads, reads from 1M file(s), mean MiB/s (StdDev)
> > 
> >  --------------------------------------------------------------
> > | Block |  Baseline   |  Baseline   |  Patched    |  Patched   |
> > | size  |  same file  |  diff files |  same file  | diff files |
> >  ---------------------------------------------------------
> > |     1 |     26.38   |     27.34   |     30.38   |    30.36   |
> > |       |     (0.998) |     (0.114) |     (0.083) |    (0.089) |
> > |    32 |    824.4    |    877.2    |    977.8    |   975.8    |
> > |       |    (15.78)  |     (3.271) |     (2.683) |    (1.095) |
> > |   256 |   6494      |   6992.8    |   7619.8    |   7625     |
> > |       |   (116.0)   |    (32.39)  |    (10.66)  |    (28.19) |
> > |  1024 |  24960      |  26840      |  29100      |  29180     |
> > |       |   (606.6)   |   (151.6)   |   (122.4)   |    (83.66) |
> > |  4096 |  94420      | 100520      |  95260      |  99760     |
> > |       |  (3144)     |   (672.3)   |  (2874)     |   (134.1)  |
> > | 32768 | 386000      | 402400      | 368600      | 397400     |
> > |       | (36599)     | (10526)     | (47188)     |  (6107)    |
> >  --------------------------------------------------------------
> > 
> > There's also improvement on kernel build:
> > 
> > Base line: 61.3462 +- 0.0597 seconds time elapsed  ( +-  0.10% )
> > Patched:   60.6106 +- 0.0759 seconds time elapsed  ( +-  0.13% )
> > 
> > ...
> >
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> >
> > ...
> >
> > -ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
> > -		ssize_t already_read)
> > +static inline unsigned long filemap_read_fast_rcu(struct address_space *mapping,
> > +						  loff_t pos, char *buffer,
> > +						  size_t size)
> > +{
> > +	XA_STATE(xas, &mapping->i_pages, pos >> PAGE_SHIFT);
> > +	struct folio *folio;
> > +	loff_t file_size;
> > +	unsigned int seq;
> > +
> > +	lockdep_assert_in_rcu_read_lock();
> > +
> > +	/* Give up and go to slow path if raced with page_cache_delete() */
> > +	if (!raw_seqcount_try_begin(&mapping->i_pages_delete_seqcnt, seq))
> > +		return false;
> 
> 	return 0;

Ack.

> > +
> > +	folio = xas_load(&xas);
> > +	if (xas_retry(&xas, folio))
> > +		return 0;
> > +
> > +	if (!folio || xa_is_value(folio))
> > +		return 0;
> > +
> > +	if (!folio_test_uptodate(folio))
> > +		return 0;
> > +
> > +	/* No fast-case if readahead is supposed to started */
> 
> Please expand this comment.  "explain why, not what".  Why do we care
> if it's under readahead?  It's uptodate, so just grab it??

Readahead pages require kicking rickahead machinery with
filemap_readahead(). It is not appropriate for the fast path.

Will rewrite the comment.

> > +	if (folio_test_readahead(folio))
> > +		return 0;
> > +	/* .. or mark it accessed */
> 
> This comment disagrees with the code which it is commenting.

It is continuation of the comment for the readahead. Will rewrite to make
it clear.

Similar to readahead, we don't want to go for folio_mark_accessed().

> > +	if (!folio_test_referenced(folio))
> > +		return 0;
> > +
> > +	/* i_size check must be after folio_test_uptodate() */
> 
> why?

There is comment for i_size_read() in slow path that inidicates that it
is required, but, to be honest, I don't fully understand interaction
uptodate vs i_size here.

> > +	file_size = i_size_read(mapping->host);
> > +	if (unlikely(pos >= file_size))
> > +		return 0;
> > +	if (size > file_size - pos)
> > +		size = file_size - pos;
> 
> min() is feeling all sad?

Will make it happy. :)

> > +	/* Do the data copy */
> 
> We can live without this comment ;)

:P

> > +	size = memcpy_from_file_folio(buffer, folio, pos, size);
> > +	if (!size)
> > +		return 0;
> > +
> > +	/* Give up and go to slow path if raced with page_cache_delete() */
> 
> I wonder if truncation is all we need to worry about here.  For
> example, direct-io does weird stuff.

Direct I/O does page cache invalidation which is also goes via
page_cache_delete().

Reclaim also terminates in page_cache_delete() via
__filemap_remove_folio().

> > +	if (read_seqcount_retry(&mapping->i_pages_delete_seqcnt, seq))
> > +		return 0;
> > +
> > +	return size;
> > +}
> > +
> > +#define FAST_READ_BUF_SIZE 1024
> > +
> > +static noinline bool filemap_read_fast(struct kiocb *iocb, struct iov_iter *iter,
> > +				       ssize_t *already_read)
> > +{
> > +	struct address_space *mapping = iocb->ki_filp->f_mapping;
> > +	struct file_ra_state *ra = &iocb->ki_filp->f_ra;
> > +	char buffer[FAST_READ_BUF_SIZE];
> > +	size_t count;
> > +
> > +	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
> > +		return false;
> 
> why?  (comment please)

I don't understand implication of flush_dcache_folio() on serialization
here. Will read up.

> > +	if (iov_iter_count(iter) > sizeof(buffer))
> > +		return false;
> > +
> > +	count = iov_iter_count(iter);
> 
> It'd be a tinier bit tidier to swap the above to avoid evaluating
> iov_iter_count() twice.  Yes, iov_iter_count() happens to be fast, but
> we aren't supposed to know that here.

Okay.

> > +	/* Let's see if we can just do the read under RCU */
> > +	rcu_read_lock();
> > +	count = filemap_read_fast_rcu(mapping, iocb->ki_pos, buffer, count);
> > +	rcu_read_unlock();
> > +
> > +	if (!count)
> > +		return false;
> > +
> > +	count = copy_to_iter(buffer, count, iter);
> > +	if (unlikely(!count))
> > +		return false;
> > +
> > +	iocb->ki_pos += count;
> > +	ra->prev_pos = iocb->ki_pos;
> > +	file_accessed(iocb->ki_filp);
> > +	*already_read += count;
> > +
> > +	return !iov_iter_count(iter);
> > +}
> > +
> > +static noinline ssize_t filemap_read_slow(struct kiocb *iocb,
> > +					  struct iov_iter *iter,
> > +					  ssize_t already_read)
> >  {
> >  	struct file *filp = iocb->ki_filp;
> >  	struct file_ra_state *ra = &filp->f_ra;
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

