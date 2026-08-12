Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C186C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 23:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EC746B0184; Wed, 12 Aug 2026 19:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69D866B0186; Wed, 12 Aug 2026 19:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58BD26B0187; Wed, 12 Aug 2026 19:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FC566B0184
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:46:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3D3E40546
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:46:50 +0000 (UTC)
X-FDA: 85094254980.11.3A27562
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id E8FBE1C0008
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:46:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uPrEfiSl;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786578409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kXvgWAnKqLXP7Mpf4jm46uSY4fg6EwwBH2E+vniV1M=;
	b=GJ8nqFDhnYEjTzc2WQKYk73dqqAIey2tPkrq52NFss3hneztVbhZmU52mQIUwxN3H7PFyQ
	l/+dNhiS8HDAxyoQXf9Y6+cRhEgNvTv7y1c6IF0NOKXpq2P93SHWKH6s78oESdCsoKMj2c
	drMgLnkAXwXuRiBGMAS0yWqpYwtEEak=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786578409;
	b=AtsQmHEVwhuD/xlMooSINMScgsCZYiSZOGTg/Js+E19mR2q8gFa+6Vt4C8kaBjgWoPjb25
	tDFGNWcLY2uOTP9i9db7m6vhFMZFucQjO1hId2dGfmHhR2+zsYCfms69uAQP2pjh1jnEg+
	YTdv1+IX2slzzw2wZXwvlIBVdFCJyzk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uPrEfiSl;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1kXvgWAnKqLXP7Mpf4jm46uSY4fg6EwwBH2E+vniV1M=; b=uPrEfiSl6Z3tixJX6/YYg0q4yD
	CopOGYt59uJlUwLrw9EbN8U8JbpyZXyIw0nnZf7TTHFn6/nOloQbnyuu+kjTc5boQJc9mFovKTVIQ
	o4DgezBGuu+6dxMFB8Y0iz9ILElTG3BCUFjotJzjCdakbYAEIBLHatNx/PgdlO8q1io8g2r7jBuWj
	v+IhOw+m90tjyEFOAArQo8JEzJwn+1poq0fi72FIBVAGtkwS8cebLxbZ6Zl4WXEagYVDCMMD1m+7/
	Fr6xVcAMKOTIXtuMvOyQRORgtyp2D1YvZxhCVO85vfc0VbtSxK0KrijVoLaVqv/CrxSwzFo6gnmP0
	W7qpZDPg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wuIej-00000002jNL-3qxu;
	Wed, 12 Aug 2026 23:46:45 +0000
Date: Thu, 13 Aug 2026 00:46:45 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: mm.git review status at 7.2-rc7
Message-ID: <an0F5e6I7OJWTCLa@casper.infradead.org>
References: <20260811205836.59301ca91b65781c6292a439@linux-foundation.org>
 <6023e19e-32b1-4110-b9ce-5063f7976108@kernel.org>
 <4535a2ca-d145-48b7-aacb-027e9ba258c1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4535a2ca-d145-48b7-aacb-027e9ba258c1@kernel.org>
X-Rspam-User: 
X-Stat-Signature: x7n1gwmkxa6kc4i68zrwgzmioksgdzuk
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8FBE1C0008
X-HE-Tag: 1786578407-238839
X-HE-Meta: U2FsdGVkX1+fTEu9aFJJBL1Z8bbbUASun0674qOTm3IzJxi80WjcC4wM96ugQIVEnqckJZHpbAct1i5dmqjwY3/jB92izMmo4ileiiVmB4n49cy2r3RMdgcYXlDiVhAlxQ2EFDKbdXrs+VZLGbdawd8RM0q4VfGbYkblvf09StsYGUBO7vz6nZHKQJBnA/JvN8Nj6RtwWhdSTnF1TD6j2ANSjjJvHULWQfwsam8q7FUzEj8p2HtpGHwmjQhI7MBwyg2H/HwYiEW80pIJWLKB6hbEL6uSJ7NrSVepW1B0NG7FDmAGJBtN2bj5TGqY4H8Xhp2kaKqys0ETwOlcwN5cqMtKcXAPIrfLXnRuKyt1RUtjyMIuyDNau8mRiJvUrRgWBie5F3+zoe3zC0ZW9Ylu3ZreXHWpdbcD826XROqhxZaGn4256Q0Cx5N6WVhbG5iferclrQhnS0eAYlcsr2G599Uy2WK24gv1CjcshJ6NkYCHhE7DakB+4ZDctTsD0ofy/BDcpEW7ZSgfvB6sK15RH3rYtEOKW0uziAIHeEiXrQWvPC+zjecujLptcEtrPo271THLbCXVBt671SP81YPGHbFpHhjipK7vuYljqD6I041K7mMW6NH1peDZtMX6gR20E37hB8NF/KdK3baaYDAjJOE5gTwcS0XnPbGGvgD63cHxLYRx+7ma6YdaHB8b1YR2Lw0FaccwkTHEMM0V7hhd+htP1tct6D7xfv2f0HdjZr7UqdxaGHdLdziPkulNvSlTeiOzXJPEV1DZDoFXePb8FXwEfiQ2bVj6D1DFNGZ75/WL1PMjMEcczHFIEnz+3KEV836BoFPWOQ4W/ye3gZeFiPy9DGewDX2F6jZeOb6zo9V8NhQmBvp6aLPBXwJa8cX0v1vXlUmYHH8QvWf+dMjRo2jKIGKi7cunikHDJW8ja2EXbmQRPQXS1lXyZkz7s7+dEY2TjR0M3HyZ+ojCkz0
 hGo4UBie
 txgETn/oB6iXaHQMZJHX7hs1MqSjvj6c8O5jlnVmHpD/S8oIjQ0JXNeqhRRNq6z8ZfOfQf48MF2NiqpHb7OLcZGPLdgpXFvPrb4Sw15Hysigf9tldRWgKISZK+r6K0aoxw97DJwTuUkdRNFqtOJ4GsJCYIZuRRNGhipGhhqkQly8OOUCwTsDhd/0ntZhjG5DkQ3kdoopPQzhw2QIszojN/rJFHAR3gQDXb4CnzRbOSNKKyXceY7acgOnRCC9Tzg+ViCQ1ceSQKDN0CYIDgpsy1bnJbhX8JrwzEn5MzlvEZD6f8Iyf6UX1U2n4wwa6uOCwrMgZIzgj1Y52f98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 10:37:13AM +0200, David Hildenbrand (Arm) wrote:
> > We really need more maple_tree reviewers.
> > 
> >> Lorenzo Stoakes (ARM) <ljs@kernel.org> (6 total)
> >>     "mm/huge_memory: separate out CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic"
> >>         Link: https://lore.kernel.org/20260730-fix-refcounted-huge-zero-v2-2-c5d8a41b317f@kernel.org
> > 
> > I want to review that. I am still not convinced that we really need that right
> > now. The fix was the important bit.
> 
> Oh, good, we fast-tracked an unreviewed cleanup as a stable fix upstream.
> 
> What is happening.

Meanwhile a well-reviewed series which includes bugfixes is apparently
not even being considered for this merge window because I spent a lot of
time figuring out what Sashiko was concerned about?

https://lore.kernel.org/linux-mm/20260805210557.1118966-1-willy@infradead.org/

This was originally posted 5 weeks ago (ie when rc2 was current), so I
don't understand why it's not being considered.  It's been tested by the
people most likely to uncover bugs in it.  It's not going to get any
realistic testing in -next because most people use neither hugetlb nor
hwpoison.

There's a bunch more patches to come, and getting this batch in now
would be very convenient.  Otherwise it's going to balloon to 30 patches
next kernel release.

