Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1A9E68168
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ECE96B0005; Tue, 17 Feb 2026 05:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B606B0089; Tue, 17 Feb 2026 05:26:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB1D86B008A; Tue, 17 Feb 2026 05:26:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D1DB16B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:26:06 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3339513C58F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:26:06 +0000 (UTC)
X-FDA: 84453568332.10.AC85944
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2C2FF40002
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:26:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ZKp4GUL5;
	spf=none (imf27.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771323964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdgR9J3y9XFwf9Pjemt6beHFk6KHynnpaTjue2G2oAw=;
	b=igbeldW0iobjV68Vxh8QPw8dXtGQ4B93wOozY6GzmgJ3k1a+pdjMeOtbrHU4C8uXI0lUJu
	/Xb3GMgBNbSmUvu/d2MZ4sRxoHWt6ql2a8Txbcb9MZbOF4lrE20YHlrXaJSJ0qM1kesR/B
	/mXaxQvI4G9yMudlEGuBlDstazm5aII=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ZKp4GUL5;
	spf=none (imf27.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771323964; a=rsa-sha256;
	cv=none;
	b=PJSZzEyjAuENE/d1nspVp45F6aqKPmhk/Vro2Ift95Hbmk28dKqWFr/zTN6Ziua9C5lVYh
	USVA4sAu1tb3ix89zVYqIN6lMnfn8DmW0Iv/+K6ikk+sSVbA3FygAvjctf8tjqsRCFubK0
	mnNbvz/2Du3kaQV7uzo/hXI3cu429Yw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LdgR9J3y9XFwf9Pjemt6beHFk6KHynnpaTjue2G2oAw=; b=ZKp4GUL5rcy3Oyp09BLsWUvOs1
	10q59nf7z2zf6Ryfu5yA/i0FllAQG+ZetzF3uB8W+0DPSP7KiQNYI33Vy8CKlunIhQdoEZ9wzInVh
	4L46SkgM/bszGh/9OyZbSGAO3FBp7t1spKFdFJ8jktQ1nJEO52Bedkfvvz36kwzGADWRgwVd6UJzM
	INL8g3wanBuX6sMgOgTlVJAbl9Q3Zp5a9XSB9VzTaJkpiLa15iLnBZ80podew9cDZG34qMDIhPF6u
	4BydGRNNQ+WLqPy9ki5sR91c6NYq+eZWvTUDxng9Rq+hJrP8ElieIcDPrKjzXGtiiBYcGze62fqYw
	li/6BRdA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsIHH-0000000FirW-0ljG;
	Tue, 17 Feb 2026 10:25:59 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id BF8CE300CDE; Tue, 17 Feb 2026 11:25:57 +0100 (CET)
Date: Tue, 17 Feb 2026 11:25:57 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
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
Message-ID: <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
References: <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh>
 <aY9HD7nH5A-DtgmR@tardis.local>
 <2026021326-stark-coastline-c5bc@gregkh>
 <aY9PBfx3RRV7rXZ5@tardis.local>
 <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZQ8lJJ-U_8j03Z4@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C2FF40002
X-Rspamd-Server: rspam07
X-Stat-Signature: ry8u3yt4razkf6ewgziyato19zb9jnmk
X-HE-Tag: 1771323963-9779
X-HE-Meta: U2FsdGVkX1+wv/e9m8hjH8ymaNNicsIUwx1ivJjAcagWNwp5VTNhGWxN0XIFgLrKEtxEhiQMNsRG9kcIN4RWjqUodNX0wtVKxjoMR9wzHAQA3qXlD1tyHCHOWsnuk2IuXCnPFgxccHo9DGHu7dR9ABTBA2vTOehVPmjzlL1QAT0pd9k366vklvce92ycJHUVV80X3qV4zs5WTtm++1Huj2UsOS1uikl9vt0gmlipDpLzJtbtIJ0gi1/NwjAegNYrZfDrs6fPXZjR4b89d/yC3KLSJS5nL6fRWOzQVZWCFkJzLOr9jDqvopwbndRgM6G4xc1zJyZe2gSbWOGZHMRPd3NBN41no3GaFx9yQ8j6ZpOaQ8zI41R99s87jIDqzlBS/m0DEUp8zmR06z7G7Pu5QZz4urMUQIledkjzVsEJDDRQbXJGl5Vzzq9u6K+kWQnrTJSS/iR5lqtBjQw6ny0Uwyn8cjOojugCHRvvRCpSlgGtJ7dzHTHkU8ZxYWFd5AqoUo3EnDyJnV7ULoQyoD6YTlfur8crCXnr2C5RluBNVnwLNeVYcR06j3WUlk8C90y/FO1B8dPClnleEbvp+AZe754A80ytPFDLhQc3j2qtpLgnZl/+a8jOECENcMyO30bryWYsMjvpXYFQE9bwReKY2IMn6/F3tGPpwQIEO4feRl0yYPx6a3XQ4Jvbhb/w267C0ka+fBXI+nNh1gyXCbHn8AKVwNIrmsjmMtTl4qVZbdrhRPosupBYnKbzH5h3X3Fz582LlOYTMipI5eI/Ot2LAZC8KeKAjxHJ93fA+vGSF8ghRBzX5w22VnqjHkdk3t2bm3UPmDnHhX4STMbVTYIcOeT77JPGcXrqS4itEfi5UxXFi0ZF5ROq68Sb7Xy6bP06mFlo5vkJJMznwJJIqmvGH0Ky0ZvgK8RdBwidvQIetZoQI+DSv1KnBeFbjTVXC+ENEJaXMYHTwJSvbG8KRHw
 BThz5UAp
 XkZv1yiREgDafp5gUEf9baFjRi9Wp81r4pJDDfZmlNXELJ2cf0YsVNNeY3Ek512tVafc2XKIIBswWPbKiwLii3zk6hapcXPJmcKrqWIqW1+J/SoiuzkZXKnqedoFmEoJrgKlBEHa4rUtSecfX9kTPUn/ZVy5B5/ow8RS9kLrU6I5G0K3x/HZzGRdFy5YPU9LLbcayGT+VPeJCLJIMViMlXJNbZNSYNxX9bru3i+2369LN+aYVKRDZn68XylUpTaRL3ZGrO2w69oRtqpP8jEAysXeEpP44zj0D5znFa3jp5yWmhUwwBnnFVtc1xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:01:56AM +0000, Alice Ryhl wrote:
> On Tue, Feb 17, 2026 at 10:45:15AM +0100, Peter Zijlstra wrote:
> > On Tue, Feb 17, 2026 at 09:33:40AM +0000, Alice Ryhl wrote:
> > > On Tue, Feb 17, 2026 at 10:13:48AM +0100, Peter Zijlstra wrote:
> > > > On Fri, Feb 13, 2026 at 08:19:17AM -0800, Boqun Feng wrote:
> > > > > Well, in standard C, technically memcpy() has the same problem as Rust's
> > > > > `core::ptr::copy()` and `core::ptr::copy_nonoverlapping()`, i.e. they
> > > > > are vulnerable to data races. Our in-kernel memcpy() on the other hand
> > > > > doesn't have this problem. Why? Because it's volatile byte-wise atomic
> > > > > per the implementation.
> > > > 
> > > > Look at arch/x86/lib/memcpy_64.S, plenty of movq variants there. Not
> > > > byte-wise.
> > > 
> > > movq is a valid implementation of 8 byte-wise copies.
> > > 
> > > > Also, not a single atomic operation in sight.
> > > 
> > > Relaxed atomics are just mov ops.
> > 
> > They are not atomics at all.
> 
> Atomic loads and stores are just mov ops, right? Sure, RMW operations do
> more complex stuff, but I'm pretty sure that relaxed atomic loads/stores
> generally are compiled as mov ops.

Yeah, because they're not in fact atomic. I have, on various occasions,
told people to not use atomic_t if all they end up doing is atomic_set()
and atomic_read(). They're just loads and stores, nothing atomic about
them.

They are just there to complete the interactions with the actual RmW
operations.

> > Somewhere along the line 'atomic' seems to have lost any and all meaning
> > :-(
> > 
> > It must be this C committee and their weasel speak for fear of reality
> > that has infected everyone or somesuch.
> > 
> > Anyway, all you really want is a normal memcpy and somehow Rust cannot
> > provide? WTF?!
> 
> Forget about Rust for a moment.
> 
> Consider this code:
> 
> 	// Is this ok?
> 	unsigned long *a, b;
> 	b = *a;
> 	if is_valid(b) {
> 	    // do stuff
> 	}

Syntax error on is_valid(), need opening ( after if.

> I can easily imagine that LLVM might optimize this into:
> 
> 	// Uh oh!
> 	unsigned long *a, b;
> 	b = *a;
> 	if is_valid(*a) {  // <- this was "optimized"
> 	    // do stuff
> 	}

Well, compiler would not do anything, since it wouldn't compile :-) But
sure, that is valid transform.

> the argument being that you used an ordinary load of `a`, so it can be
> assumed that there are no concurrent writes, so both reads are
> guaranteed to return the same value.
> 
> So if `a` might be concurrently modified, then we are unhappy.
> 
> Of course, if *a is replaced with an atomic load such as READ_ONCE(a) an
> optimization would no longer occur.

Stop using atomic for this. Is not atomic.

Key here is volatile, that indicates value can change outside of scope
and thus re-load is not valid. And I know C language people hates
volatile, but there it is.

> 	// OK!
> 	unsigned long *a, b;
> 	b = READ_ONCE(a);
> 	if is_valid(b) {
> 	    // do stuff
> 	}
> 
> Now consider the following code:
> 
> 	// Is this ok?
> 	unsigned long *a, b;
> 	memcpy(a, &b, sizeof(unsigned long));
> 	if is_valid(b) {
> 	    // do stuff
> 	}

Why the hell would you want to write that? But sure. I think similar but
less weird example would be with structures, where value copies end up
being similar to memcpy.

And in that case, you can still use volatile and compiler must not do
silly.

> If LLVM understands the memcpy in the same way as how it understands
> 
> 	b = *a; // same as memcpy, right?
> 
> then by above discussion, the memcpy is not enough either. And Rust
> documents that it may treat copy_nonoverlapping() in exactly that way,
> which is why we want a memcpy where reading the values more than once is
> not a permitted optimization. In most discussions of that topic, that's
> called a per-byte atomic memcpy.
> 
> Does this optimization happen in the real world? I have no clue. I'd
> rather not find out.

OK, but none of this has anything to do with atomic or byte-wise.

The whole byte-wise thing turns out to be about not allowing
out-of-thin-air. Nothing should ever allow that.

Anyway, normal userspace copies don't suffer this because accessing
userspace has enough magical crap around it to inhibit this optimization
in any case.

If its a shared mapping/DMA, you'd typically end up with barriers
anyway, and those have a memory clobber on them which tell the compiler
reloads aren't good.

So I'm still not exactly sure why this is a problem all of a sudden?

