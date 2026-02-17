Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 572F4E909CF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543A86B0005; Tue, 17 Feb 2026 11:05:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5119A6B0089; Tue, 17 Feb 2026 11:05:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A836B008A; Tue, 17 Feb 2026 11:05:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB446B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:05:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2BEEC1297
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:05:01 +0000 (UTC)
X-FDA: 84454422402.14.0B0EF16
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf19.hostedemail.com (Postfix) with ESMTP id 587CA1A0012
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:04:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=R8wMBAJp;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771344300; a=rsa-sha256;
	cv=none;
	b=MS7mYT6siSG/X5OcICQP3RsIA6AYzxg0TsKGaL+2P8oh0cCLCKd4IbWWTF/rrIWg2je3CL
	iTzJhzX60OhYRNa4Wdscba4iX1JIT1lrsVlS1gHdvlEe9fc3YyS63GRlkGMzl2nCK4rnek
	ULgSsh0ZhQIFBZFHvf5X/zudi2O9/L4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=R8wMBAJp;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf19.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771344300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+IdFW9z5sPzmCexebRSE2HsXqwv2gmAkUgD70T1ufAA=;
	b=qTV1n0IYXIMgv0Yv2qIDYTPz3Dj8CxSD9p3vETbovLKCsslQkfniyUT64x3ftfX1gkbyai
	LbWqn0glYrJp52Q3LBgIvfb2A78V6fJCitG7sfXpAuVGbJAVeBcm7P8UpuoZ1zK+q6vir1
	KojGedNAOKyEX9wHXLe4U2GoJPr0ZpE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+IdFW9z5sPzmCexebRSE2HsXqwv2gmAkUgD70T1ufAA=; b=R8wMBAJpLxB+84Dkt3GVtwn69Y
	OqOrWj8eJgW66DOV8ZsribtgtEX4Z9nCXd2RuWctYDZr8VLW8ObtNy0og4dQ4/1/lKBaUyjpt6R7o
	OpXLYUcmTn/2oF8l7pwVkEoZnOg4IRrh7P8OidYRoWLvHiYAQXpZ4VPF3nwBC3CGT5lTgRzYXuZfP
	bBGLUVUS8gxFUFUGBgUUWoE9uGomFvVPuDlSvWgxBBWzeWiyiuILJQNsJqRQc3/YeEgZAlAnynA23
	eBpKjmEgWe5l+3ClIBIKjd4mG/C6AUxY472ogaxeB9PNR36sAt0bnu9WFyCqio+U6VWpmffM24QVF
	pUoy1c7w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsNZF-0000000G8nI-1cec;
	Tue, 17 Feb 2026 16:04:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id F2A4D300CDE; Tue, 17 Feb 2026 17:04:51 +0100 (CET)
Date: Tue, 17 Feb 2026 17:04:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Boqun Feng <boqun@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260217160451.GA2995752@noisy.programming.kicks-ass.net>
References: <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <kkmXYWYC07oImDD0FJFVCCWl45alQdraRLHoLr7zowZfE0tMz0MmPIpuyEYQRSLjBQqrp_Ch0iR2Rix_g49lNg==@protonmail.internalid>
 <aZRWOIPThLfIZ1Ph@google.com>
 <87ecmjcw2v.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecmjcw2v.fsf@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 587CA1A0012
X-Stat-Signature: 5nny9nixkymsneozitkaspdxpo4s4etd
X-HE-Tag: 1771344299-532974
X-HE-Meta: U2FsdGVkX18YphfB996GtapkVDVcwrnwu3Kf8DITnxtC+gTh75cV9Gbigd3pEk9A3heIvX/Z6AzDzL+s1oUy/24SPgtRYH4b9ne30fNHzWo8krKD8tMQVs+221lwnBKKBIga1UafalzozZ/NWE6ZUl2ogI6b1XAYpTUcJm0aeWUINn/u7kR/xKOdzjI6Znk5IjAuUoJmNKlq6fTtggHHdIovGTvgsU43B5tn7Bdyv4NxOfNX4mMGaVqMgmGYPq+4/0XKiCufRpWH+AqGnibkOSgDcxFh/j56axHGr84Z/OBD7LUj6fAkpQGDXN2bIrEV1mzwARFeu8ZEc4xq898R4lNDHxarNs9v00tIDRLtaX9Zc7UvaaDyDZUJo4ZHHUzJcg3o34jrEN+YXhF4UdZ015GriAiX8CcYvNFkuxKiNdcUWcETXJ8YSp3+qr0Y3BeW64vBwO4fuUh7WgdKn8STkoSwG2laxDNRDO/6oJ2TPmFuTuU/wbJoSKybe6qMoWrO6ADnZ1B/GqRZbGhuHgSVj2NWQmCbWyIjNipxDWV45q8aR6mfngib9YVrble27sKOCB/o9ZHgzdRN321koccamD3IEq01sC/sZWjk9BgoRkBuc+DNsnTgPoVPY/d8sEuVIeVVPLmSbGO3zHwDCtPkodO6HOHRomjZcZ+L8NpnRjOMwqu8tuaKvOvGHvloPQzRYcj2q9knuEiaLb9bIhB0Bk3moGY+3EJuRbdt62uRqx2z/gXvOvU+k8DKYY509nNJkFp/oqs2Pnrmiu0XLp34QtTEKcMpmGyrAKvN/cmaKPeDeUxp3uD+q+RyDUAvItClsNNQLvdGFwLM7RsLHI1Z6wCSobfiqShCtkwHEo5JfbrwfB3mlxknJ4rIJrz0v79XywbqVSrUxLO3+6tjkpCNjuOkxb6NF6idFUuKQNUV9mgdPqa9jKC4f8wyb/WWbfK1EKx9IQxut0z7BfTk5zg
 7pm9Kh3H
 2QTHkIYsJIsHgGo7zq37zCzt9QCA7hPMGuQMm4cr1F5bvr3tgCTq+6QFlY7Sjy+CJcbOi485E75kg5s2CwdLI7l48AivTixO2TKLflL0Lz37bKseWcRJHxfbl1uYOtXzlX9AK7XMJ7WNcXkJRDDKZNDyBsCUUXoNdLV08AVTFJM9mzgGgS5vTIYEoZh5VKTD1XaVFBLEShrzkggXEK8XPYuguV1GOgeKHCqqI7l94bhKkAy2GPDNIystuhJXCjSZmGt5YrwOVU1Y+IRljc9Q8p6KBI3knBqs4anQk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 02:56:40PM +0100, Andreas Hindborg wrote:

> I'm processing disk IO in the Rust null block driver. The pages backing
> the IO requests may be simultaneously mapped to user space, so there is
> no way to guarantee that there is no concurrent memory operation to/from
> the memory area. User space programs can do whatever.
> 
> I don't have any control flow depending on the data I copy. I just store
> it somewhere and return it if a read IO for the same sector arrive.

Right, so IIRC the old DIO code used to have this problem. We'd end up
writing whatever random state to disk if you did DIO of an mmap().

And if IIRC the current state of things is better in that we ensure the
mapping becomes RO and we have writes fault and wait until the writeback
is complete, ensuring things are somewhat more consistent.

But you'd better ask Jens or someone that has looked at the various IO
paths in the past 10 years or so :-)

> Let me add a bit of context as to why I sent this patch. I am not an
> expert on the finer details of this subject, so I rely on available
> expertise in our community. It is my understanding that copying the
> memory in the situation outlined above, without special consideration
> (in Rust) would be undefined behavior. Such are the rules of the
> language. Of course I don't want undefined behavior in the Rust null
> block driver. When asked how to solve this, the experts suggested
> defining this byte-wise atomic memory copy function, A function that
> would have well defined behavior in this particular situation.

Yeah, so being a C programmer, stepping in UB and tearing up the spec is
what you do on the daily. Its called reality :-)

In reality it is *really* hard to have memcpy() not be sane. And if the
Rust spec doesn't outlaw out-of-thin-air, then the Rust spec is wrong.
It really is that simple.

> That seems like a reasonable course of action to me. I don't understand
> why this is such a big deal, and I don't understand the need to use
> aggressive language and swearing.

Feh, there hardly was any o that :-) Call it cultural differences and
show how inclusive you are by being open to how other people have
different norms, whahaha :-)

I've heard it said that in Scottish 'fucking' is the mere announcement
of a noun.

> I would suggest that if we are failing to understand each other, or if
> we are miscommunicating, let's be curious instead of angry. It get's us
> to where we want to be, way faster. And it is a much more pleasant
> journey.

/me mumbles something and quickly drops the mic before the PC police get
here...

