Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545A9E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 12:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17EF6B0088; Wed, 18 Feb 2026 07:12:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC51B6B0089; Wed, 18 Feb 2026 07:12:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EE866B008A; Wed, 18 Feb 2026 07:12:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B98C6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:12:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26966AD43B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:12:44 +0000 (UTC)
X-FDA: 84457465848.16.E587D28
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2EBA4C0004
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:12:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=RS4Uplmx;
	spf=none (imf10.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771416762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RURdNKTgo/45/sjZa4WZm4lS4SVP6Z6PKdxDGv+PE4=;
	b=JELXCHu9Ho1k59JSlair5qpI/uILwJX7YYtdrRymwdlxTtfWIMmokwC3U4Y+ZLSsd0Evck
	xn0iugBk5p4KIFOylwqKWZIjhsOSV32D0k2jdUIlhy0nwmb1ebbKGON7Hedx/cr0oU3mYz
	z/jf8nf7nSUEeB2DQNV0yASDWdYnIeY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=RS4Uplmx;
	spf=none (imf10.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771416762; a=rsa-sha256;
	cv=none;
	b=pSCuRJJpmBN8GQmjh3FJZrkNiE9ZwDsp7XjOP2R/yu2R66tMAGf43/AIKgmZUOGB3gDXal
	npN/Gf0rNdNew0D/iicauLWu4kI9C5q9h94Az+PJSDiC8ihn7yh3N44qsTztmGLYVuXh7O
	hdLAtv79U9jmXePQs6z4QdoAi8amNBo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6RURdNKTgo/45/sjZa4WZm4lS4SVP6Z6PKdxDGv+PE4=; b=RS4UplmxNHGAVzg44UJZa+YOVg
	GINpcpHTRg4GtiLFt5XFju5NzaM0+BwrF1gWoUPqQ8CJJT/z0ilkeAlkaOXxgZq7rlxUJwGUywLtc
	V9ZyfP3gMCmAmJoQA2r21WsUuYdMgXHRnrvX5HUarrLqW+VDOPehYfUPNe4IeL5w8noUQd7txmkLx
	PzgNI9ZzuDqs4i2QIP3kQo57RKIWxnFptBJyxxKQ3H7h4Nb2EEL/h+uOLTpWDzCCtNxWbeq+8A9dL
	vt1QGYJlo8/sDaOIg6w2uVLP+ZfiQmHnELM/KGhPrA++35Zqz/GmlwPMVQlfGQ+nFJ/MeoL7Upwqv
	69qsTmHA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsgQ1-0000000HOYr-1t9l;
	Wed, 18 Feb 2026 12:12:37 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E2DF73004AB; Wed, 18 Feb 2026 13:12:35 +0100 (CET)
Date: Wed, 18 Feb 2026 13:12:35 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Gary Guo <gary@garyguo.net>
Cc: Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260218121235.GF1282955@noisy.programming.kicks-ass.net>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <aZRY9HthKwVJrAf1@google.com>
 <67aea464d25c8cafb3113eea62c8221b@garyguo.net>
 <20260218102045.GD1282955@noisy.programming.kicks-ass.net>
 <9029143b048c9385768d883d93da6531@garyguo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9029143b048c9385768d883d93da6531@garyguo.net>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2EBA4C0004
X-Stat-Signature: gbkeejy6gnnk4daig1zqygked38mi65j
X-HE-Tag: 1771416761-10016
X-HE-Meta: U2FsdGVkX19k93+EXO/21xoh7zh3utUZbBdAu5EJr/UzSS15kB1TGYvV5quJX5VI3Pd9jUrkFoK3yp0oSHFyufjkI0r5l3vH2pPtl5c+uoVjFEWFdAGqtzJNLxlCGdmhHfFmZ8t0vP4HSPq7oH3lvWlgrqQs/bdK6/xMC76Q7rYEkAvDvjmS3QQ0CZWligbn7JrxY+lJ3I8bxguZdkyPGVswMYUnZwMbxNrgURr4RWxhCoiR+RBnWIncsxNYvgFxOhwWjzt0l8Pw5axiv5VjU156jT5PcQpV83Mpbh9JFQGQd6yLZdJ/jty/uD++0h0AkzEXYR8uZPUYnuZH+FDsx7nwo/EVVN+hgyOm2/2TjsBzjVtU0aT4NiyI+327qq8F9deXCZYUnqSj29oWIsIP7RGi384jg5weMxRUieBvRjv2VyOIPPw29t30orCgBPpKHe2TMx4+BmIzzSGugHqdG0mOgT8WaZV7FTTQXnrbWnhcjU6gtLu8voD0iy+Ki/eTjlCz9cMJOvURGSwkXHXs+nfQCb7O04T5KPMjsKGZlol+0lz/y8gYDPUEye5DcCCvzHu4jEURqNIJ0F3U/aM+u5gRrDYyEu9GaGB5gdCBeUv3nw+464X01+DBr+l5Dt3jOefu+G6RsHpQwcWseQfVgNgbmTInqHEcGA1nZMtlnBsFefcieVZlfjc46a3TwkIFPDmA7Xc9OEsMJo2BbyfjR2bAWhosvNi6ppbvJbqKRQItlteRGDi5woyGBakSHxwVhB+M5klOiqVNAYDx7TKlLmFFF35UINJ1K5jRSiRVIcN/5ex0sSDN+03OZB8OxrU4C7AvsnfTZl4P7XscOBQYqVnztIb3j38UOD6XmBv5/e+sw09D4LCxncvdVTcfFCtp/XxbqeMWWeQ7Tiyd90umCTW8jfY5+AQT6ZKazskwFsy7irvPKK2qIep0i5IdFBD7uBsBfyjJsynRcIgzU3W
 TB9FdkWl
 py37tTmlhdhdXqXO3Dk7G+gKC6pw4t4TUj9+APtLp53llZqMJuZ35mONTXr2b8AwU/+MwEEdnsiDsNK8TmIm+D/YK6igmJ7xdU9SiMPkmLS926oGN1/7v8vGYCCuZ6bj0tPmAEg4ja2hIuyBCKPXrohkW9XAFJ2bO6PX3AEqNFxTPvxODBAAC2O2gCXNwi6bB9FdjZpLj5NhnIiGXuZMxAGufV7DbvZh/Q9rGSyf7BI/3zCpohr0Gv0KeeaPf7WZD7FgU0bWQnp2rF8QV/bmA2qeMZkOCoJrWa705l0YT94Fg4cxRUp9KfKxtqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 11:36:20AM +0000, Gary Guo wrote:
> On 2026-02-18 10:20, Peter Zijlstra wrote:
> > On Tue, Feb 17, 2026 at 11:10:15PM +0000, Gary Guo wrote:
> > 
> >> If we have this in stable, I think it's sufficient for LKMM. However
> >> for Rust/C11 MM says that volatile ops are not atomic and use them for
> >> concurrency is UB.
> >> 
> >> I recall in last Rust all hands the vibe at discussion is that it's
> >> desirable to define volatile as being byte-wise atomic, so if that
> >> actually happens, this would indeed be what we want (but I think
> >> semantics w.r.t. mixed-size atomics need to be figured out first).
> > 
> > I would strongly suggest for volatile to be single-copy 'atomic' for any
> > naturally aligned word sized access. This is what we have with
> > GCC/Clang.
> > 
> > If you pick anything else, you're explicitly creation interoperability
> > issues.
> 
> AFAIK LLVM IR only "guarantees" this for primitives, so if you have a struct
> that happens to be word-aligned and word-sized, it can still tear, which is
> why the the "byte-wise atomicity" semantics is what's being proposed.

Urgh, what does GCC do? And are we sure this doesn't actually break
anything? I'm fairly sure we rely on at least 'small' struct volatile
reads (eg struct fd) to 'work'.

> I recall it was being discussed that, for the MMIO use case, it is desirable
> to have this defined in such way that one single instruction is generated for
> an aligned access of small-enough integer primitive.
> 
> This is exactly the same situation in C too. If you have a volatile struct load
> then Clang actually generates a volatile memcpy for you, and it can tear.

It could just be LLVM is broken and needs fixing in this case.

