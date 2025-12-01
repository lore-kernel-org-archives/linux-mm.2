Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E605D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:38:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6901A6B00A8; Mon,  1 Dec 2025 16:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6406D6B00AC; Mon,  1 Dec 2025 16:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5569A6B00AD; Mon,  1 Dec 2025 16:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 439786B00A8
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:38:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C6AF558AF7
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:38:42 +0000 (UTC)
X-FDA: 84172216884.11.7B0BC8B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id C3CCFC0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:38:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BScuargN;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764625121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IC+JbYTz4wUsAbVSDTKYVEaA4vy5MxR+ihBKqV1SwpY=;
	b=6q/uxLRHZmUT4YHSw1X2qUlf7wvwyJ18SvQ6MYmWmsnhzECmW2ua091IcnmJIq1qqrH5+6
	OGBbwpHoxqQCk23SxNMaOwfJPZ7ObKyp7BLv865nHRCzEZiCNauqVfR9VL1hJ+Xif0YANy
	QMlHJacLcdL8M4gV4mkdv9aPRz7XfM8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764625121; a=rsa-sha256;
	cv=none;
	b=IRQ2/VCEbsHE4ko4M0iUFNHG2CcTbPei8YmdeMXoXjhhi3y7W2ezlW5tgFxgr3DfdFI+i1
	joyoNhu6W5aBvUzik9/lll/6CoUH1R+NBDCYjZri5GHWG+dY9i5rcuBN5E4Wfk3/WVZp36
	bzquoaALHj13Am0WFmj6LQdB3Std2v4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BScuargN;
	spf=none (imf10.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IC+JbYTz4wUsAbVSDTKYVEaA4vy5MxR+ihBKqV1SwpY=; b=BScuargNrc58wdjz1s1pvVAF3f
	S7Z44Udh/Va6F/2fFBtK4irt8nS9jqp8otvn9ZEKOpAhQlLPwza4nL/P5OgJYQYJfhU33qBVR6Ift
	4Mf/Ic+H0/RxqD5wyCLW8INkT3UPhBjjvtd0Byn2sOEqsSsnPcZb88XM9fG2MvCU0a0fNW09KhIkA
	52YVC8klo6DfOr2cVomZf7kuvhNfS0dFfDQxairGo0Kgngptz1+GDkbcCGIispYlaA8BRAbHeIHMz
	cATdI15rflahY9IvrEcDxtFP4Vr7kD8dp/RXsJXQjEZVTxnyKrYqC4gbMsYZ1oC3mRFjN5QltrrTI
	oJSCju8w==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQBbT-00000000GWw-0WWk;
	Mon, 01 Dec 2025 21:38:39 +0000
Date: Mon, 1 Dec 2025 21:38:38 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm/readahead: add a_ops->ra_folio_order to get a
 desired folio order
Message-ID: <aS4K3jGkJErj94R_@casper.infradead.org>
References: <20251201210152.909339-1-jaegeuk@kernel.org>
 <20251201210152.909339-4-jaegeuk@kernel.org>
 <aS4GgfzfuYRHJdg_@casper.infradead.org>
 <aS4HmeRgsStngE5v@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aS4HmeRgsStngE5v@google.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: C3CCFC0010
X-Stat-Signature: w4ctirnrpzxx7tkwuukhy3jaafqksyga
X-HE-Tag: 1764625120-696209
X-HE-Meta: U2FsdGVkX1/AA5s0rHw6RQtVZjbI4q1l2bpS1qqe7ZjPVehicqp8vZEgMUVdEXwhzdPPtYhYf9R+2fNpSFP8Fg6zM7VJ+CPOtX5diZZTnX+bzfSfIpXZvaTgs7KLu7JsX7UOQGYpxqnhSbKSAY+YcUwI5FDDyfAUM7YH3vd4VwIeJQtljlk3wCh13FG93r/rrXhizBCzRiMkXe84/qw45+ungGiWefJRySI64HbSIu+DwVc3VngFqJtOA6gKjU4ZAn3DACZINOyAHrnL3IW2eUDq4dpPC5e5gGMepe1T2/yu6X2STcRRu4vWylN1Cvxn1fHfZBJcLMd9FjQEcfA74CUgpcQSIpA1LLovOYA4PSAq9uKXDoEB7AUGJ+8eljNWjHPjFhMHM0LXp9rHxgOOhaqKwvTKEkHG+wWW2OT2jGRy/5Hf3ajaCD0HDOISTnTjbBMqFR/enQ1kzLTdtXsiFBW9ZM3HbG4IrJ4BvSX04l1Q1jLeKuCyjjTaQyrCcVJIS+aPnKzIOUHkOmX2ircH0d2VfeGjp0c9+lr4UYJsJuBCv0UJheT4DyTRW/J4aPW7Q1aBC15L9mc+M4hLPVwTKeMqhl6vi7lSu4s8SCH7N8tOA8egtf1UJqpvKdZWvKpHrp9atJUVwJZopVR/2TIlA2m3C/aDCovs1XwYa9XBpXFRB2YbaQMxNqV4FqkNdp1YMa2v6mOJpaxXLua1IHokMCrKZZ3mR3Gp34dPIJ94v6Ex4Fo/vlofpYYyHAQhjkpSbuK2XpwRhfZ/8QaAY+xSKzVV0HZ0/hRJuUYb1S0ESpZQSUSVBofgKlx6xX7U8HEq+pq5pOZcW7gJYLX0MjHfjLc4F2V3yzQue9Mm8kV9MbfZ34gJGqdx0n2VOhBkyC5gyZGf8PSderu/V4FoV5nApOmnmwl2wCuMLkkZ+iMpOxQBxRhicoDhahWpfduIG5PYNZM1g6iHmLJmrkpmudg
 bymwbyZe
 cj+jOWJZogqu2K0v9RbrzPPFGtSlSthnhj49wI05MkeZuoROYm7S3xwDh/3SgI5jX9pvOhkwiAs21UjFlW8toL+4GV2G0uiJWGPCrnHg+uQ9cGTxY19SdtEq1LlAHJ9fuM2pVDjGelj+KO68NTPqeJTC9Op8Nbwv8HG2ZiTFe9qopghOwKQGTYIMqIUHMyIYp1J/S5njEoG6rVOYPGPwTETZnrsb1qp7viVz4V+ihYk/ULbHT+8HW2gdjBG92nWQRVx6vQrxNIt24JUQoei/hS5PdLNrE7YzP9AYpG6VRpbvNBLF0iE0BGxB39E6Si1AExq9r
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 09:24:41PM +0000, Jaegeuk Kim wrote:
> On 12/01, Matthew Wilcox wrote:
> > On Mon, Dec 01, 2025 at 09:01:26PM +0000, Jaegeuk Kim wrote:
> > > This patch introduces a new address operation, a_ops->ra_folio_order(), which
> > > proposes a new folio order based on the adjusted order for page_cache_sync_ra.
> > > 
> > > Hence, each filesystem can set the desired minimum order of folio allocation
> > > when requesting fadvise(POSIX_FADV_WILLNEED).
> > 
> > Again, you've said what but not why.  Does the mm code not ramp up the
> > folio order sufficiently quickly?  What are you trying to accomplish?
> 
> That's why I posted a series of the patches to provide more details. Could you
> please check the last patch in the series to show fadvise() does not increase
> the folio order?
> 
> https://lore.kernel.org/linux-f2fs-devel/20251201210152.909339-5-jaegeuk@kernel.org/T/#u

So what you're trying to say is that readahead() currently only uses
order-0 pages and you want it to use larger order pages?  I agree with
that!  But I don't think this is the way to do it.  We should just use
larger order allocations, always.  None of this "call the filesystem,
check a sysfs parameter".  Just use the largest order page that fits.

