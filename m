Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7EB0C61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 00:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4713D6B0088; Tue, 25 Aug 2026 20:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449346B008A; Tue, 25 Aug 2026 20:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F576B008C; Tue, 25 Aug 2026 20:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12D7A6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 20:02:52 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D25E1C0669
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:02:51 +0000 (UTC)
X-FDA: 85141469742.11.2DCB111
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 413071C0005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:02:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="RyHg/Tab";
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787702569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NBdgN2DyXgys503Hsd3B8DyE4gvlVeQWSt6yuz5SVBE=;
	b=Qj15a907HdnXrD23/pL3a7+yHPzrpLNZIE2PkTQcEq0ypUcXX2Miu0Yjm06puOTAMetC8P
	Sl/sa1WTvLYlGTzJybPshdNv1CYjx/symn8F14ZYDuzgQOpVVXozH+8esudoLxSqSuJ1W9
	Z5zIX6klRPDHITMDZ8JXwo+pf2et6qU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="RyHg/Tab";
	spf=pass (imf18.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787702569;
	b=hA+ymyiEIq9fosq6nZ6R9KxY+qj5YxDD3Rufk/f8a2M7AcaTAVMtoZvTIUKjHhNciGv12D
	pkWCbjMReq+Y3BXo4YUU8fbOuzjxuRdT/DiS+jqPArqKzJVkAq18WEyMi/1hAQasr3tdZ6
	9uJ4Rf1gCag0KqcaBx0jnO6yacUZV5w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=NBdgN2DyXgys503Hsd3B8DyE4gvlVeQWSt6yuz5SVBE=; b=RyHg/TabT5xtxP4rCiWs83zs0l
	uFXEjv2TRABsE5z6Q41aS5XpFB+yOekqiSG3YLozinWwVU00yOdxwb32Lta44pBWrdbF9pObup8cR
	RwhUzLZ7ZyL68VGQIhcBZd3L9c28j/g2kip2rCD6EP3AtrRica4AJfwKuHfBkYq+qT5EfhpvYUMZl
	Wc1I9HqTnXkMBdIQTMCVptCTN6nu79viSUu1cbtHySUnJXWXaT/mz74cASY4sK6VNOCtxViWEQ8zS
	EcwNpxjtAd4PcE8fenqUh+6I8sc8kpxuj/873GqwjNw8pr0yYPOKX+x/jGpujRFD5zGOYJni8hhWi
	9awlrIaw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wz16D-00000009ytH-141Y;
	Wed, 26 Aug 2026 00:02:37 +0000
Date: Wed, 26 Aug 2026 01:02:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao4tHXnIySccVRIz@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <CAG48ez0vXVUu9j4rYUeCqgwyHKAiN_6fL--D90WvX9q7B41V-A@mail.gmail.com>
 <ao3y8TtEGjniZ_4f@casper.infradead.org>
 <CAG48ez1yGUcS6AgtPXnmPQDmVCnJyptu64YGsTw=9vxAN9BO6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1yGUcS6AgtPXnmPQDmVCnJyptu64YGsTw=9vxAN9BO6Q@mail.gmail.com>
X-Stat-Signature: 9e5igqc6ympk991rcpq73xepm7ir9e3t
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 413071C0005
X-Rspam-User: 
X-HE-Tag: 1787702569-241899
X-HE-Meta: U2FsdGVkX1+goRAKAqQ6Oc5ZOe4SZJfuP0rGHpSzc1HsIJjenYVf/+2PebCnvbeCCxnx32cLdti4VAArp21Mmp9u3bAqTWSek4Kqw/Lf/lSfRHEEA21Y6oXZRjkjUhSw13gr0X/MP0aRfGJgbHruMU0BSzBUgisOHh2ZDGkzmMhUkeXaQBVHFarIrdOHRaDyXUpyX6yantkR+8roeggI8yfzwGWI6KRqlUMSR+nipPiCARQAARZyJHzHGiZtUyZkbJK9ZeKb/wLnnjdfH7BMnGYZKKTmq8Fjgj+oNVhxGMvFD4JT/Hvx2LT/tCROzvFVFA7fcHyd7fmt2yTDTlhf/QrkxSBIVghS6cLXFe1NoKJLhP/i2sxZCAT8PhvvrD0p9p7glasoNEuvFKWq9Y2BG2GYeJX8aIVRYbf1CBNH9dzKgFbHB/+aWUTFvg1MZO+s5ClQUz4p/nEKdIhJjFjX1WLUt79HGyvLl0Dfeb9HFsiGfoJhNSQN0VvQlGHrhvOluOvWyXH5gKaHBhyd0nWfOSQRpGg9rV+6C6DkFvJ5DJFU/RGWx+wVRkcebxl2Jopkw3019Vav2OpnFwGCjqMsxkBkhLqWknVIXQUa/4lGEmLGGwHPhZDtr0SabiMyjN7w/nGIAfBDu8inPau8fndduvKF/hP5vTwsYftM4o4RlvNFi6LrNoKP8GMa/0E2ffwJtOX3nBerg3tBtQj3Ikj2WFLGRH9pqrRKg2v9UENzszs/oHaXQ8GfVD3S3Ff7DvSIPrW2+gxzRa3y8KutlrUL2wshJaH10nHgqHpSMbD5CLvFxakfNOXL7EIH9oRoFsBY8g3+bWVHJfSyFh1FjC1P93h/ramgersbubQj+eIo4pGr8Ydk/b/JlZ5rH8wJJnOvjK15dC6a7afCzeugh95UjrQ4OsODSYdqR1FXQ8pAafJBxzDgSlvwkGXTUaE8A0UJ3Umxu0QHJQ3cyZo/rpS
 J2kVsGYF
 xXmUXji9gdDT6BqxHphs63t/SCF8mWJCvfElf8AJnR1zaivrs+ngfB+S406RNY9VH7c9JjVqrW8bj8Beeo/mKw3/QPJfYx8FnJVS8C0iju/hWaqAMBeBl69J+PFWVjcm4/fD6AwnsTRQNSqHX2gEKb3FNvxWHJ+rasNkRRv7e3ilYMBUzduOJqDD2I4DccTE+b/TwiAUd4o7s9AVtY3bCGMAi1u/J4qGIzz7NX5H5T/Ktzm8kC1PFgLJf2Lo3vqWJE21g0PLp5lFs7/8Lmb45e9+LJSRCmdbNwDxItFpF5VnByFN7AwVBDPxFiFN21BHOBIBi3in6Zh5OaLE1/0LjXZDzvABY0ojgmZ/2UOZJfLtFm3Du7DH2WKzbTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 10:06:30PM +0200, Jann Horn wrote:
> On Tue, Aug 25, 2026 at 9:54 PM Matthew Wilcox <willy@infradead.org> wrote:
> > On Tue, Aug 25, 2026 at 09:35:57PM +0200, Jann Horn wrote:
> > > Could we strictly ban using get_user_pages*() for write access, and
> > > use the unpin_*() helpers to somehow enforce that folios are always
> > > dirtied on unpin? I guess the problem with that is that we have no
> > > state that tracks whether the pin was read-only, and finding free bits
> > > in struct page to keep track of this is hard?
> >
> > We'd need a count, not just a bit or two.  A pincount for all folios
> > is on its way (eventually) but I wans't planning on tracking writable vs
> > read-only pins.
> 
> My thinking was that once a folio has been pinned writably one time,
> it should be fine to mark it as dirty every time it is unpinned, even
> if some of those pins were read-only?

Ah, so the point of this proposal is to mark the folio dirty when it's
pinned.  Nobody clears the dirty flag at any point until it's written
back after being unpinned.

