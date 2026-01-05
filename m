Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA636C79FB3
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 18:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EB126B008A; Mon,  5 Jan 2026 13:31:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1C76B0093; Mon,  5 Jan 2026 13:31:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D84B6B0095; Mon,  5 Jan 2026 13:31:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE696B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 13:31:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE576139276
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:31:32 +0000 (UTC)
X-FDA: 84298753224.06.228C83D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 54268C000A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 18:31:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MsZxHeGy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767637891; a=rsa-sha256;
	cv=none;
	b=EIgoIzXEVZXunGmyAwgSoLWTLNTKRUi6K5oBHFnWcpXD6M26rZmd+LAViQB62NZm7zIsjt
	B1SOIbDx6WhH77cW0XVEuC2evir+K9xpELBZL45vrjO8PfJlSRE00iZ5eIO4DoSfOh4rhw
	TPGYdpv0gPDxV9lxQ8LyCjYjz8wn4ko=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MsZxHeGy;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767637891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8MmaHundWB98Zl9LWZS5d2NV+pR8sSOwYB6rXTuV7y0=;
	b=VEGa9baA3VgpyHIXh+x2gH5/NnicGudM8ntWLM/krX+gLG7wSqfyVfccmEDVeaMZ8CFYc3
	sWtVMVfR6VJFzac0v8gi1I30WsDA8VS8ckPSQTHpPZdZCre/B7FXFzWyQ5YzRdBgxKP17a
	75YLQ6kHK/ZQ3WFMsJmUgShUzNFCxEE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8MmaHundWB98Zl9LWZS5d2NV+pR8sSOwYB6rXTuV7y0=; b=MsZxHeGyC/LA3L9MAeio2PLiBQ
	55DSL/XD8VtW1KUcoUP9ZR9K96zKoQsD7xMHTPNlLbU2zND2MHipFuqVjwvSr5C+Xq1EKfHWl0HDN
	yZFo9UISlqY2AtbOARykVtnfD4j0mVfiz1pA2E9vPszcPPtDnXI3hswxK4rTPsN1AcFZYiRBbYXjq
	n4ndBT0QehzAmxlyBsjr11aRnc/mewCEPBJGPgzlAwVDpOD7wEuZHVkpHRZgWeOimFu6WsNo2N6Bq
	iDw0OHIwapnUJrY/AIZ8hIJXrghNPFh0uYgwmSXtGyULQkIs4Mc5KoIE0I7Oup0EiF9zucvYpph/J
	GoFBy6CQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vcpMW-0000000Ajpk-25QI;
	Mon, 05 Jan 2026 18:31:28 +0000
Date: Mon, 5 Jan 2026 18:31:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Calvin Owens <calvin@wbinvd.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Shivank Garg <shivankg@amd.com>
Subject: Re: [BUG next-20260105] khugepaged: kernel BUG at
 ./include/linux/xarray.h:1441
Message-ID: <aVwDgMWsHqebuu0j@casper.infradead.org>
References: <aVvz3tYdu49TGkjI@mozart.vkv.me>
 <20260105095111.c0e726f7a85bccd8a1aa0067@linux-foundation.org>
 <aVv-nloKXjqyfrFP@mozart.vkv.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVv-nloKXjqyfrFP@mozart.vkv.me>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54268C000A
X-Stat-Signature: touromqmqbgo4qhuyh1zdpjnkki66faf
X-Rspam-User: 
X-HE-Tag: 1767637891-387252
X-HE-Meta: U2FsdGVkX196SyvGkFAGUhER5UTEb2sVf2MUltZAMbSG5VJykIJbsmR3k1WK9hTRFIsqjafSlGJsz9iXFT2F/d2f9x6P5SKwYM+AaqFi6wSsSi34s3eZB9M5CMIIQECzSGyosJUmGeNUsasyZAo19JTPaLErXICLgTg+8Cz7DPuigJu9ehnDhseBLOLvTKW2+BlKGaZQ/iEB5I1ubhx11hZrSFcx4YLo5h36RzHDcsCEQvOxFO6ehV192j24v5mjt8UJ82XqYfWE2TCoMlKGBH8jNUTVw6Ni6RRUfzm2q0x1cPBtsXpKuce/49r/5OXSA8s5UEnILgJoKTAKZMtTkBaU+LhQiXGU+09ngViiNVewqcOa9ebqwl5OPJBEg38wI25aoEAJhFVttMp2ojm/wHsNo8u1rvzDKPScnzjTRlR5x2ZsEk2gMadx9e1EDGNUJuHPekydDhv1rZ87sFRpoCE2o7An7qOcu/VQmKQOmxNOveTF2T8vPJNq4cswoWLtYDslm05/G6vQFZdwGj3njA0m/rDtJrWxhVVWBCW9oY2fEkD87wHLPYJJPy3HQOM8EEcaCFLEvqe+59+gAAfQbNa8ziFyKAkcCdS1fu2DSEYz8izpl1w0La8xzgOVdaC7i6yBV+yCaKFnMOkl5GGqcVkhBRUPtW0TLqz0OjJgf9ecUiGBJCsXxft7LhtLZt2Cm2hkWk9N3UnbMYXsKUBxflXTn0To87q/Jhy6PoxIs2abVItIejOKI9Y8aLdb1JvuCB9qtHPFiHcnJvbHhrW+5z0yTECBlCAWjinuob/4YwT77NEs3rcfkOK2rknrC22F3jHi42bsFnRG3YP/BeQx3U2Xqfwmxv/To78xaeoGB75BwhhQU7YQsEUWsGd+8kUAsIvZrrT0s+Xeq5L07TjpdOESseMx8NaMiGjmNP79lYd02HM8i9U3/scvZj12vTvh1jNghPV4f75CKsry97A
 Q4fAm8cE
 2NW7yq8UW7eFAQkiCjXJKmoSoK8wYZRDs9iyLdJzOgsHoOSbVKFcYO1U0ErlDbJAvnJLgmh7XeSn1Ss2ulu8QQAAiUQ65b+omiYSx4iHr29eFKDcc5UToHgf6lULJahCBCJdytRaB9kDnA71sTA16FXmAcuspsSHa5+qOAk337WxtqEVItCs2go/4TzUOYWpdvZlmx9YruUbmn9KAjkpArq+U9RXtxrY+P9lWigUOXeD30MXNRvIcUSxCSP+VQsw/4v39qDf6ohkesOE86vkhSNK/daxgTdE7RfR2ngc8scBjv0dC7orS5IvfQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 10:10:38AM -0800, Calvin Owens wrote:
> On Monday 01/05 at 09:51 -0800, Andrew Morton wrote:
> > That's
> > 
> > static inline struct xa_state *XAS_INVALID(struct xa_state *xas)
> > {
> > 	XA_NODE_BUG_ON(xas->xa_node, xas_valid(xas));
> > 	return xas;
> > }
> > 
> > which was added by Willy's 43b00759f21b ("XArray: Add extra debugging
> > check to xas_lock and friends").  Maybe it found a bug.
> > 
> > I'm not actually sure how 43b00759f21b found its way into linux-next. 
> > It isn't in mainline.

It's in the xarray tree.  git://git.infradead.org/users/willy/xarray.git#main

> > I'm seeing no other changes to xarray.  mm.git's khugepaged does have a
> > bunch of changes which Shivank added, so I'll cc Shivank and hopefully
> > he can spot something?
> > 
> > Can you suggest how others could reproduce this?
> 
> It triggers immediately after boot for me on any QEMU VM, one of them is
> an empty husk that runs nothing but sshd.
> 
> FWIW (not much I guess), I disabled DEBUG_XARRAY, and the first VM has
> been happily running next-20260105 that way for about an hour. The
> workload is seeding distro install ISOs with transmission.

It's checking for something which _could_ be a problem.  So it'll catch
any sloppy uses, and doesn't necessarily mean it'll be a problem.
It may be as simple as moving a call to xas_reset() or adding one
(see the other fixes in 43b00759f21b particularly the ones which affect
the test suite).

