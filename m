Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F2AE6816A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E80636B0005; Tue, 17 Feb 2026 05:47:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E2A6B0089; Tue, 17 Feb 2026 05:47:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39AF6B008A; Tue, 17 Feb 2026 05:47:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C02DC6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:47:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4122913AE88
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:47:08 +0000 (UTC)
X-FDA: 84453621336.19.CB39E6C
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id 67E1340008
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:47:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QB1jRoMg;
	spf=pass (imf04.hostedemail.com: domain of 3KEeUaQkKCFs3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3KEeUaQkKCFs3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771325226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r0hJHRJh2R9794qv5CCWWuTbVzrBfeQJNewapWgpa6c=;
	b=ICkJOt8Vp4vaqRn/FbOZAe9e8NnWfa48YSMBVm67Wi5+RE8kUZ6SknbR5M4rErKnQNyMNT
	A9dTuIA7T035NqAI3by7m8vbWYGqmDXNZzPrKIVBERbOq0LoznHczrJQIK1vsJQayQwzSe
	X+nr4YQWhKdYHxSMdFpLGnU+RhBvNco=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QB1jRoMg;
	spf=pass (imf04.hostedemail.com: domain of 3KEeUaQkKCFs3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3KEeUaQkKCFs3EB57KRAE9HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771325226; a=rsa-sha256;
	cv=none;
	b=plytlRMeXEnaz9Buj4b2vLpI/EsQEfcjPevjLKIOJVM3Oca5qvJ74urlBr/Y3uKyX1FuVR
	jB5POmfjq0RhtmRnliiVsiGjHrT4Ml1iK+lUJFjxVjw+0i+QNlimAq/j9LSDl3CQ3Q4YYY
	WTIxbAPfXeO5+tppNEz9a/5Oj4NtBg4=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-65c1c72ecffso1654878a12.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 02:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771325225; x=1771930025; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=r0hJHRJh2R9794qv5CCWWuTbVzrBfeQJNewapWgpa6c=;
        b=QB1jRoMgyaetL+xz2qdMA0sn98I4KOtlzeuYzdhznz+488rmhNdCQANDl9jyaRUJSU
         hURk68ZmC6q7tVxWST79jq7VPAU3kOze5EN5OkXeMuuv2PPhJI0OVH0oE45REv3BgwmC
         Y50iY2D4qvKozk8N6Kaa3P0ytQGl86PXOkmg83fFpHyJjdEWuGisiWT/A9ucsUkPQMb7
         vtZcgCyYKH6PXgAOuhJbqjixD65CKL1EzErDNU9OJZ9SnsvxOSBW9kQjcLlnOtv+9vxu
         KFjmyPFB3VmlP/fRPVYO24gddpFsUDSZA2aZZEfN9XTtcnOqKNBga7UcsfWNiG5lBoNt
         jKuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771325225; x=1771930025;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=r0hJHRJh2R9794qv5CCWWuTbVzrBfeQJNewapWgpa6c=;
        b=YnafUgLongTzjBxbI6fwDeoPi/I6TkdcY1JgfM7LSaZIoRJAzPVQPJr3XgZgJsvAtj
         LfHKRejKQQttlSaTGtPAnqVRUoTIYHJI2xzwJQ5mkx/PxTTi5i/XSYcESecbGEjbGObr
         Tf0HqBcH/QwkD+eilShDe6DpRbli5sXUBACVkqs9JSmIXeFdPy9pLEhZ6CIEvDFVEz2C
         qYJHa9FlYloL3XzMKwKolfKl382jBVSPgM8KjhgTSO9QAlMDs+XEHEp3iK+zZwaLOVNA
         x94oCTFDzAMx5dzvmtohLUr0236Na9swoEq3RGzJSDPu4Ht/ZY8jITJNf7pr5OVof638
         jd2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHFMT8lgaPRd+CqdCfZ09Pt3T2+2YGIY2pJL6ZJZjZq0NI3Ow8OkYMWQoicYW+Q5HWklLNkznzFQ==@kvack.org
X-Gm-Message-State: AOJu0YyIOrrnVuvC2mOwoohW525R6zLK1Pbzh26Mou3tcw2TuhNDNQAG
	6qnOzSlGy4Uv97ORTsY/8OQ9Tt8U7Q7UOJ9HUt0Q3drJfZfQWq8bZBFL0QPtwjb3D6KeA0zefoi
	KIGBVRZ8Y/J4OdAiy6Q==
X-Received: from edqz17.prod.google.com ([2002:aa7:d411:0:b0:65a:44ae:faa8])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2549:b0:65a:3f4b:947b with SMTP id 4fb4d7f45d1cf-65bb112f4fcmr6725247a12.15.1771325224379;
 Tue, 17 Feb 2026 02:47:04 -0800 (PST)
Date: Tue, 17 Feb 2026 10:47:03 +0000
In-Reply-To: <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh> <aY9HD7nH5A-DtgmR@tardis.local>
 <2026021326-stark-coastline-c5bc@gregkh> <aY9PBfx3RRV7rXZ5@tardis.local>
 <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com> <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com> <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
Message-ID: <aZRHJ7pSzOHruPA2@google.com>
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
From: Alice Ryhl <aliceryhl@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 84i59cj6inmfuffcaxaet7eoa7a9hqzm
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67E1340008
X-HE-Tag: 1771325226-476279
X-HE-Meta: U2FsdGVkX1+mtaNiPh9V+Auvq5yOH68i8UxIEIJdjoA/GX9wMpNRxZYvosSm+03yj3Qa8tMQBtzmI0BkHAjdngUswrj9k1Ab5GdVvphzmRVNQhH3AkqP+7Hw3zxA4GHFJKiEiGrkBSW4ge7ALm8zBG49nq7mfbPTBmtHLoaTKhA+6ymQhRXEztenNIltZJSs1LwkCIch3TFFtfyVFKNUvMMkjVVzJ4tSctyPg/fMu+1ZVkf6lWlVYhprwHBVMGFXdoFlVmWitZRL2LTGUpg9zVKEOKJDxainsS5YFmO+HIcBZ8k+4WxZKlWdOCvOnA3WWQllTq5PDeYWdivAw3Clq4tU3sDdwuTfDKAwHB1Q1Ili1e1ILOH71+97eyFSye8eRo0lVmhSUPm9qaWM2suZ2wI+7LuKt76H5EkjaBcK9UIU4ORB87a4UF0/hj54QAwt7FktTgq/CWwpPlQN+MOa+gd+3mdz5epLIH+GaeM3TI06LgoaZo1pxeCTe+tS+9qn2jXN9zyPOlXGNrDvcgLa4fXfTRs8A/ROEAuU2FPUr4okA2Oy8AAPBFxfES27ZcQ0X+r6T7eGK6sr4YdX22r6qox5kDkb7xwYXaXy7Ek5DwOG/pCBcnQ30x3RpJEDys+bkWoSeCPGYM9oSZJQZBAk5mLftDgW9NTtfxbQeo7nEn9SlQwc4LvvaRYr3xVhjz/q3PmPiYKDWDip2D8xNNJxg60wDHkBnxtTyl+6XiAuFVeg7CrCLPjMzY0I2aiot7VUd5BUkReNRPp1d15dZyB7BKJIhZm0mB0N34dY6SFhHMbirtlbmzS6420ZtXyxAU68QJ7oRd1+mUlzU70LikKMaA4YRPkZtgZfTQHenGptimdI0lnjP+FV8NwRswC8qNzOrBlxWQRoq3nTAxBOMdXG5tb7Fz4JqYAnAB7oNMf/a4QFInP8tzga786TBSUXCZfmpOLEY2Mkph2haHFvp7r
 sTC6zyCr
 Ob0q8fgjvKjtvqca2qo6nFQVyVuP1qE+F1zMNMm87VQzNJpVeCAlLDzLdJPRvqPuacMW7BYMWp2XW+UR3lz8YGK9hNizBBgYrOj+uGH2hyfRxXw+PVphoUR6fPx7i+GsQ89OXUyEw572d6EkhblGZt5HTLQNidK1LfoTjVrPBR+pCNjwIdAd2HQDwIdDfaF4+85RImaWXODr6TwfiJmXAp45USJzzCtzoeltAqpCziPi8MGdA8AVdJR6wCdzjL66n56lwRV1y2XJc6K8BHvYYTFQHboetFtXCH1v3S6pKfk0csVr5sK8oMdb3bPXaHUCiorHdWFhUh2X3rLizadNckrjTBOr45e/Oy24qZPWejeRWDJdGEZUpoBS8Bt/4OJzbd5aoEUwlXL+b8EbF4LgWyclgexptok9bJf+WpT73GT5qWk6dgOcs8oYJ7eqPOArDVJ08dybY9bQ5sExBb2Fa6fjeqC/m+txNrgKMgoxHCfaBl4P0cVSQUFn33Yh9AIDOlr28dwha2wenfz90koIz9WSn04Ijelmmw8RWkfDsruHiv9ZIfFPDQ+zB2vVpM0LTHpt114T73JsVhDCBVTrEqegXMrys1OINgTlTjuyhaA+a60AFQcdW4Iaa1Z+kLKEAX3wvybRffoxaMMtGowTOtCOw8gocEVin1SbiaKXq+RnIgxkLPaLLR3/O4MdgenjBa5G85Su30jdIg1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 11:25:57AM +0100, Peter Zijlstra wrote:
> On Tue, Feb 17, 2026 at 10:01:56AM +0000, Alice Ryhl wrote:
> > On Tue, Feb 17, 2026 at 10:45:15AM +0100, Peter Zijlstra wrote:
> > > On Tue, Feb 17, 2026 at 09:33:40AM +0000, Alice Ryhl wrote:
> > > > On Tue, Feb 17, 2026 at 10:13:48AM +0100, Peter Zijlstra wrote:
> > > > > On Fri, Feb 13, 2026 at 08:19:17AM -0800, Boqun Feng wrote:
> > > > > > Well, in standard C, technically memcpy() has the same problem as Rust's
> > > > > > `core::ptr::copy()` and `core::ptr::copy_nonoverlapping()`, i.e. they
> > > > > > are vulnerable to data races. Our in-kernel memcpy() on the other hand
> > > > > > doesn't have this problem. Why? Because it's volatile byte-wise atomic
> > > > > > per the implementation.
> > > > > 
> > > > > Look at arch/x86/lib/memcpy_64.S, plenty of movq variants there. Not
> > > > > byte-wise.
> > > > 
> > > > movq is a valid implementation of 8 byte-wise copies.
> > > > 
> > > > > Also, not a single atomic operation in sight.
> > > > 
> > > > Relaxed atomics are just mov ops.
> > > 
> > > They are not atomics at all.
> > 
> > Atomic loads and stores are just mov ops, right? Sure, RMW operations do
> > more complex stuff, but I'm pretty sure that relaxed atomic loads/stores
> > generally are compiled as mov ops.
> 
> Yeah, because they're not in fact atomic. I have, on various occasions,
> told people to not use atomic_t if all they end up doing is atomic_set()
> and atomic_read(). They're just loads and stores, nothing atomic about
> them.
> 
> They are just there to complete the interactions with the actual RmW
> operations.
> 
> > > Somewhere along the line 'atomic' seems to have lost any and all meaning
> > > :-(
> > > 
> > > It must be this C committee and their weasel speak for fear of reality
> > > that has infected everyone or somesuch.
> > > 
> > > Anyway, all you really want is a normal memcpy and somehow Rust cannot
> > > provide? WTF?!
> > 
> > Forget about Rust for a moment.
> > 
> > Consider this code:
> > 
> > 	// Is this ok?
> > 	unsigned long *a, b;
> > 	b = *a;
> > 	if is_valid(b) {
> > 	    // do stuff
> > 	}
> 
> Syntax error on is_valid(), need opening ( after if.

Oops, too much Rust for me :)

> > I can easily imagine that LLVM might optimize this into:
> > 
> > 	// Uh oh!
> > 	unsigned long *a, b;
> > 	b = *a;
> > 	if is_valid(*a) {  // <- this was "optimized"
> > 	    // do stuff
> > 	}
> 
> Well, compiler would not do anything, since it wouldn't compile :-) But
> sure, that is valid transform.
> 
> > the argument being that you used an ordinary load of `a`, so it can be
> > assumed that there are no concurrent writes, so both reads are
> > guaranteed to return the same value.
> > 
> > So if `a` might be concurrently modified, then we are unhappy.
> > 
> > Of course, if *a is replaced with an atomic load such as READ_ONCE(a) an
> > optimization would no longer occur.
> 
> Stop using atomic for this. Is not atomic.
> 
> Key here is volatile, that indicates value can change outside of scope
> and thus re-load is not valid. And I know C language people hates
> volatile, but there it is.

Well, don't complain to me about this. I sent a patch to add READ_ONCE()/
WRITE_ONCE() impls for Rust and was told to just use atomics instead,
see: https://lwn.net/Articles/1053142/

> > 	// OK!
> > 	unsigned long *a, b;
> > 	b = READ_ONCE(a);
> > 	if is_valid(b) {
> > 	    // do stuff
> > 	}
> > 
> > Now consider the following code:
> > 
> > 	// Is this ok?
> > 	unsigned long *a, b;
> > 	memcpy(a, &b, sizeof(unsigned long));
> > 	if is_valid(b) {
> > 	    // do stuff
> > 	}
> 
> Why the hell would you want to write that? But sure. I think similar but
> less weird example would be with structures, where value copies end up
> being similar to memcpy.

I mean sure, let's say that it was a structure or whatever instead of a
long. The point is that the general pattern of memcpy, then checking the
bytes you copied, then use the bytes you copied, is potentially
susceptible to this exacty optimization.

> And in that case, you can still use volatile and compiler must not do
> silly.

What you mean by "volatile" here is the same as what this patch means
when it says "per-byte atomic". If you agree that a "volatile memcpy"
would be a good idea to use in this scenario, then it sounds like you
agree with the patch except for its naming / terminology.

> > If LLVM understands the memcpy in the same way as how it understands
> > 
> > 	b = *a; // same as memcpy, right?
> > 
> > then by above discussion, the memcpy is not enough either. And Rust
> > documents that it may treat copy_nonoverlapping() in exactly that way,
> > which is why we want a memcpy where reading the values more than once is
> > not a permitted optimization. In most discussions of that topic, that's
> > called a per-byte atomic memcpy.
> > 
> > Does this optimization happen in the real world? I have no clue. I'd
> > rather not find out.
> 
> OK, but none of this has anything to do with atomic or byte-wise.
> 
> The whole byte-wise thing turns out to be about not allowing
> out-of-thin-air. Nothing should ever allow that.

It's not just about out-of-thin-air, it's also the kind of optimization
I mentioned.

> Anyway, normal userspace copies don't suffer this because accessing
> userspace has enough magical crap around it to inhibit this optimization
> in any case.
> 
> If its a shared mapping/DMA, you'd typically end up with barriers
> anyway, and those have a memory clobber on them which tell the compiler
> reloads aren't good.
> 
> So I'm still not exactly sure why this is a problem all of a sudden?

I mean, this is for `struct page` specifically. If you have the struct
page for a page that might also be mapped into a userspace vma, then the
way to perform a "copy_from_user" operation is to:

1. kmap_local_page()
2. memcpy()
3. kunmap_local()

Correct me if I'm wrong, but my understanding is that on 64-bit systems,
kmap/kunmap are usually complete no-ops since you have enough address
space to simply map all pages into the kernel's address space. Not even
a barrier - just a `static inline` with an empty body.

Alice

