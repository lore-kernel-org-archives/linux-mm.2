Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AB75C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:15:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9511E6B00BF; Tue, 14 Jul 2026 14:15:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9025C6B00C0; Tue, 14 Jul 2026 14:15:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F17F6B00C1; Tue, 14 Jul 2026 14:15:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3C26B00BF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:15:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CD40D140434
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:15:51 +0000 (UTC)
X-FDA: 84988185702.28.735AA95
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 917854000F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:15:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="BpLqAf/g";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDRfQDib/z9B1BsarbaLihpCO5f0Vdj9FB1+83Vr95w=;
	b=3qucSmdI8pQ9iwT+y9I6aroi6YOY6ZQUs7LjkG6n9CDm/gLud/b8w4NTuEhvLgMg2EixAW
	KseuM+qAx6v1CMRicwJUyN3p9ZiZLj9E/ArVohDJr9QwCKFFXlkA8h3oEDB21X5s9VuJ5F
	Pn4KHhrCqG/DukpOMH9xDY5+MAyDtfA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="BpLqAf/g";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052949;
	b=kRha5ddSHs0DyC3Q3icZtlIRV+FALmoFv6CvMvCCXzH17smKDwXBEfuEFZOWJIvFUwBEri
	7fNGeGwm4z8eNtfrzLuAKwz52WTf6+u9KYSryo83atbxKpNt6omaXi5qxseL5B18vSOzm4
	jHOoiytNZccNYo1j+wPnPiesAbj7Fxg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=BDRfQDib/z9B1BsarbaLihpCO5f0Vdj9FB1+83Vr95w=; b=BpLqAf/gO0vW/sEagFo1t6DWEf
	9dODVxX1zB/7fgFD/d0kyQU7sTxjnp+F9IYIW3fq8j7KBjyaV9AVmymf21qbT3DyzTyJpZM0kb7Yc
	bKSaqWluPkYcU/itC3TapdjKEwSFZPBKvqOVu18vxK14KHrOxG4kxfshHjRs58a9uR0I62q3ztLKM
	JDhbJiP8IE6Y3GxbQLFgqSdgce9V35JiyggQXClRMzRhHAwbu84Wi0iCiaRE5fI3EotjmwnWzdnH9
	WqtxizescJ71/RRb92HX6gdkZrTQZw+RSKBQ46GvLr3BPbftVnEj2ddINiJiR/ez6n4CxcP73xJVD
	h5N4WPmQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjhfU-0000000FfbE-2muA;
	Tue, 14 Jul 2026 18:15:44 +0000
Date: Tue, 14 Jul 2026 19:15:44 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: "Zhou, Yun" <yun.zhou@windriver.com>,
	Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH] xfs: restore nofs context unconditionally in
 xfs_trans_roll
Message-ID: <alZ80Dv4uNWWhrDk@casper.infradead.org>
References: <20260713035505.1635191-1-yun.zhou@windriver.com>
 <alSrO3aDTuZkX0K9@infradead.org>
 <7a053113-f678-486e-a78b-8f5e94e73acb@windriver.com>
 <alToBmAN_HyeXth9@infradead.org>
 <20260713230420.GN7195@frogsfrogsfrogs>
 <0792c175-6a7c-4108-966d-4afbc8c515a2@windriver.com>
 <20260714175528.GG7380@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260714175528.GG7380@frogsfrogsfrogs>
X-Rspamd-Queue-Id: 917854000F
X-Stat-Signature: iejkwjf19ec74rwsnapmtwn6yprdd74o
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784052949-874331
X-HE-Meta: U2FsdGVkX18uIn0UbA61NwQqLPMfytRo69DMez12MULExnek9i7d2yYCSsS0MgveEXpijRBItAjnyEqeB5OXkTOM0duhWL7nh+kPBjF1AyoiMiw9iiXmi09R8N03hHeJsZdfjI8nuqgB9GEeJj069EXMLIs8CmRUfSYFoIXKc6+x+76q93WWl+jJJbXqmzSr8+X5hRVcFEnbBynijtq2fqdSn2LJ2bR9BB/KqoYroSxx0LcVV5tIG/NABHHMkt+F0GiQJ8FlLCJwCJDWJ2VpJ3kZWupnAxjN6skns5Ba+xlQm/DrQJSeDARm3a5Vzf5vHTqp2DslHZroVM85N7a+8f4ud5MkGSWCJs8e1y5GbBz7hxO0Jt7PFn//qJ8e74SjfXUVOHPQdmtnsihV63PlrVZ/39b7Rh91tTawr819sEJVBIlW55wfukTGA/XlqPQ7YD7q8F5RflxiBGNyaoL+3ELAxNQ/eZAIfRFqA4zv4LWLmh6E9w/q+00uODrPPJ3Uz3EgZJsp+8RPJlOA69rlOOus5P6o4BGZU/+oWXaHu3CifpPQUxf+SvZbxDDUXN8EnalR0RLB+mXflXfHsFjhNtCaabsPwWd5A0yD6qOpRxaglp72FLCqec5hNElexuDMq/unKqJ6XbkiTaXiGcrDoIcp3+EFw5DW2DE77OZ0VTS8sqS3ITDnNDrjWo+B90GAjzluZajIriZg3irLMj0CiXCNVouud0S9ETNl1ttmqI84uW65JEIAMCPq/xQWE5kkuifGYdyjzd9nSYRFlZ8ofIl2Go0N94eGNtT5ZrZmbnu2MVLZx7LZxfpFndRXFjiTvFKVyJs7LkiZvMoMKQJXkGPKse6pxdAHz46VAi3MMELph1TR+xjpF5EXNV0ggNDo+8efbrn0k0kXZZgpB7DHHCASqfaLr6UDM9SLyGc/swQDGoIRdR4SdwiR74rUDUyhs+BC2MC48UuYeesKQGg
 Xd+uDGdz
 9CBaKgAaVZtu8ft1lR7Mymm4rlq7TWS7yrzA14KHZHOg4ZsPnPhc8UEDSjl+WBRo9c1UguMngMf24Tfs88dHvacj2ajoK91d8Zl+liRnRV2t6gEo9HZ6df3SUYYHvYf8Un3DuOYEIEixbTvyFV6S+rwB2Z4VobltlBIRX+I53vg+1msHwp2Sns4118eco5kEx8WKJyPjI3JC7C/v0meHzOaWMPaTkWbc9s2IOKR5ko1ePzOZuYf274np0XPMjKM0fhxrt+d2/s7Kbe8MQtke39oYqam0JPSbnebptHhNq7euqQ4FDWOtIjM397Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 10:55:28AM -0700, Darrick J. Wong wrote:
> [add linux-mm since we're talking about memalloc_nofs_save]

Thanks!

> On Tue, Jul 14, 2026 at 10:15:53AM +0800, Zhou, Yun wrote:
> > On 7/14/26 07:04, Darrick J. Wong wrote:
> > > On Mon, Jul 13, 2026 at 06:28:38AM -0700, Christoph Hellwig wrote:
> > > > On Mon, Jul 13, 2026 at 06:06:38PM +0800, Zhou, Yun wrote:
> > > > > On 7/13/26 17:09, Christoph Hellwig wrote:
> > > > > > On Mon, Jul 13, 2026 at 11:55:05AM +0800, Yun Zhou wrote:
> > > > > > > diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
> > > > > > > index 7bfbd9f6f0df..1b36cf12d4e3 100644
> > > > > > > --- a/fs/xfs/xfs_trans.c
> > > > > > > +++ b/fs/xfs/xfs_trans.c
> > > > > > > @@ -1029,6 +1029,15 @@ xfs_trans_roll(
> > > > > > >          * duplicate transaction that gets returned.
> > > > > > >          */
> > > > > > >         error = __xfs_trans_commit(tp, true);
> > > > > > > +
> > > > > > > +     tp = *tpp;
> > > > > > > +     /*
> > > > > > > +      * __xfs_trans_commit cleared the NOFS flag by calling into
> > > > > > > +      * xfs_trans_free.  Set it again here before doing memory
> > > > > > > +      * allocations.
> > > > > > > +      */
> > > > > > > +     xfs_trans_set_context(tp);
> > > > > > 
> > > > > > The tp assignment above now returns the incorrect transaction when
> > > > > > __xfs_trans_commit fails, so you can't do this.
> > > > > > 
> > > > > > Otherwise yes, this call should move up.  I don't really see how
> > > > > > it fixes the syzbot report, though.
> > > > > 
> > > > > Thank you very much for your reply. The tp here is a local variable only
> > > > > used for convenience within the function. The caller always gets the new
> > > > > transaction through *tpp, which was set by xfs_trans_dup() before the commit
> > > > > call. Moving tp = *tpp before the error check doesn't change what the caller
> > > > > sees - *tpp still points to the new (dup'd) transaction regardless.
> > > > 
> > > > Ah, right.  Tis should be fine:
> > > > 
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Why not move tp_pflags to the new transaction in xfs_trans_dup like we
> > > do for the deferred item list:
> > > 
> > >          /* move deferred ops over to the new tp */
> > >          xfs_defer_move(ntp, tp);
> > > 
> > >          ntp->t_pflags = tp->t_pflags;
> > >          tp->t_pflags = 0;
> > 
> > That's what the old xfs_trans_switch_context() did before a1ca658d649a
> > removed it. The problem is that setting tp->t_pflags = 0 means
> > xfs_trans_free() calls memalloc_nofs_restore(0), which relies on that being
> > a  no-op — an mm implementation detail. A fresh memalloc_nofs_save() on the
> > new tp keeps the save/restore pairing correct unconditionally.
> 
> So add a new helper.
> 
> /**
>  * memalloc_flags_take - move an implicit __GFP_MEMALLOC scope from one
>  * tracking structure to another.
>  */
> static inline unsigned int
> memalloc_flags_take(unsigned int *old_flags)
> {
> 	unsigned int ret = *old_flags;
> 
> 	*old_flags = 0;
> 	return ret;
> }
> 
> and then:
> 
> 	/* move deferred ops over to the new tp */
> 	xfs_defer_move(ntp, tp);
> 
> 	ntp->t_pflags = memalloc_flags_take(&tp->t_pflags);

I might stick with the 'move' wording?  ie memalloc_flags_move().

And I think you should bury the call to memalloc_flags_move() inside
xfs_defer_move().  I don't think there's a case where you'd want to move
from one transaction to another without preserving the nofs state, is
there?  Bit hard to tell since there's only one caller of xfs_defer_move()
in the XFS code base.

