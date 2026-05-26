Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E922CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 17:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 911676B008A; Tue, 26 May 2026 13:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C23B6B008C; Tue, 26 May 2026 13:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8AE6B0092; Tue, 26 May 2026 13:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC3E6B008A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:47:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14997A0456
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:47:36 +0000 (UTC)
X-FDA: 84810303312.06.E9C111A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87638C000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 17:47:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZDbJ9u9B;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779817654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=obRsQ1GuuOVKjDYMtGxxbgivbv2h67tD79o7v9BhPZI=;
	b=zVsclqDHhOc4RTdlIu9l5ZNBb/4CrT1EyJDz2YU0t3xBIjkVqSbUdAVxLqSDr2T0yZBLbU
	8RWsjHoA4yx+eUe024oBxRu1wrjb6wKGVr95gENSHWqkVLinWTI/ONNHeviD6fxQL0kX1d
	GNjYVq5uLeL16iryZcN4KtMYxUHXXKA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZDbJ9u9B;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779817654; a=rsa-sha256;
	cv=none;
	b=fIeVlcwMj084/kwKUIRyZTiKX8w6Fi5DtSL4bwjlwEAhE/CPFh4PsTUrqN10xO2hj56Jte
	YIU1/MamL+42pOeAM/uhhkuBXDC7fSzy186WO2CCFt6ynGEmEL0o51TEGV6ra32FgWy+Yo
	vVG1bv9x9GdCBnrvkhoF3a8/mlBEdss=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=obRsQ1GuuOVKjDYMtGxxbgivbv2h67tD79o7v9BhPZI=; b=ZDbJ9u9BFvwxXxLG1LFlcEvnKw
	i1CjHb0eytwQjIOb6IV6mejfIJePHkJ1GI1eizRXJ4YdJUyzSRVO/k3bQT0xYGd6FvX2owKIQzQbG
	sKIBX3igF9DaozOI76Voyomv+o5dlknH7Gfi3kzMPSHvoCNpQx9HCganUiOOdKpveeFJdeCWnesXp
	hBF9AfTT0IBl8crJyGIzS3YQgEFkZdx1Ro86ISN3Nl+0dJLZP+gptI6T16ljh/qVlRoTszpRLzOKJ
	tdSpxrNraKn1Rn4NoRYTYh4J49Fx5XgHXihgpnee5Sf+RsicqB0ibQQ4KittPIrqtUbZL+Y/qx0ZP
	kThsRjKA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRvsI-00000001MNz-2rl4;
	Tue, 26 May 2026 17:47:30 +0000
Date: Tue, 26 May 2026 18:47:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mm@kvack.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] block: Add bvec_folio()
Message-ID: <ahXcsrxUFfzoVCOr@casper.infradead.org>
References: <20260522182122.2489391-1-willy@infradead.org>
 <ahPm4h2gKgyEEuvV@infradead.org>
 <ahROtyLcr567wM8l@casper.infradead.org>
 <ahVBCtsodsM2FHis@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahVBCtsodsM2FHis@infradead.org>
X-Stat-Signature: 34yqubkukuf47h11dg79y5nk1165drpp
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87638C000E
X-HE-Tag: 1779817653-265071
X-HE-Meta: U2FsdGVkX1+/nDZdBV+KhQwlLFLIWF683qMSOJrBPbqUwxqo15wx2Yy21UsXnRToFkSCe8Ez7t3KdFDO+vVQucf2iZ3tLBrlzqL/bvISNQ3MDrGpbpif+V7RGIHX4erR85/3DpVqx8N/rGDQ2fz/liWhOtkFD4J7qchlfcXmNKzGJepQCz6MYKnGVcUvik0MAlpxWjt5u3RpvbpEjDg1Ii1zaNIQfXuFlnGXJCfQgT8d7u+a2VyRgv5Qs1/WrQaqE9//MO6gwtcV4zfz7t/VsRAlf3ycqBBO74chcJr+OFj2QVJd9dfHQ/5Lofinzd6+AjHduxrtpAm6TNWy+SUgmLxUMDzxnQUrB9MyKJ29/8VRTycomxLX3F/dwG+z7Je8f6DTeJ9zIk7fx0HZAwTSRftXoUWSv5y86tPlaoN7fwzzMykVbqLgWnEm2SGChGBBGHhu3GKMowFxY+joHaAeHmLHlIfak40jkvJCrLrSwgNRjVJNDuUmirUaf9YYRU5p59F/6HIxZeEG8KZx4KviQMa8asjs3CoC2Sl8bnQOftlJEqPs5JYa6/PhqgMh+Uc+E/qs5x88/547IhsZ413ytFLT/dbyl2BDwojSUDHKng+Q+didFkz2futnwgtRx2LkWCzBskMQDKVhb93v/JSxOUTm3sLUvhD5YhjFVHdiB2w8v3rlrMTP/nkhr6qC1jC1HoXyUgSEwTkGezhZDV7dqHqzxg7R89xrZQ9ekC2qcbwT0fKQTqPGjYeZuZ918rRplYXTgdS2e1iUgPZUvQxbDQ08unIEZLYRmyCz27vvyGHLndFv7qHmWUGvjJyRJwttwAmKDlZLZaDCGPkrCU2sgf1cW3P2ZjanBSvTq3N2csirZQD4Ku73ZYesrWCVtoi08TCUS8lTPajWOlsPVvEvDL77qkBR/Nrz1dGvcaf94LFxPuUAZWWt5sevHpQ+qyd+mBe/Dhtce8tLEMpjwSw
 9XY/LcOA
 A19X8+FPrlOKIVzXUiLdjUO2en33Q+giJ+eP5qqPOWNbT+9klU9le+WaqVKOp/l7jx74wrdbk2FlFbxFoRt9pZV5wNwgXguC8sxPBbIHgsAzdZ0y6PZisdt5NTH8izrb2+n5bhXhTmU3iGeAPd77JrMU20VmENW6Exuf9pkm2HqmlUX8ZoBsRTf67FyHgeWxgtdLJO6cTqL292dHkItcxzNdEWz2mONIH3tneVYUNN+YrmiLvzuhtQeY31mNRCfcRMf0l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 11:43:22PM -0700, Christoph Hellwig wrote:
> On Mon, May 25, 2026 at 02:29:27PM +0100, Matthew Wilcox wrote:
> > > So I'm not against the function per se, but the documentation must
> > > explain the minefields it is stepping into a bit better.
> > 
> > Lower level drivers shouldn't be concerning themselves with folios.
> > For a start, we can put non-folios (eg slab memory) into bvecs.
> 
> Well, that is a very good thing to put into the comment.  We can also
> put them into high-level bvecs, so framing this as 'only use if you
> know the memory is folios, which you can't unless you are the entity
> who filled the bio' might be a good choice.

How about:

/**
 * bvec_folio - Return the first folio referenced by this bvec
 * @bv: bvec to access
 *
 * bvecs can contain non-folio memory, so this should only be called by
 * the creator of the bvec; drivers have no business looking at the owner
 * of the memory.  It may not even be the right interface for the caller
 * to use as bvecs can span multiple folios.  You may be better off using
 * something like bio_for_each_folio_all() which iterates over all folios.
 */


