Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C74DE6816B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 11:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756206B0005; Tue, 17 Feb 2026 06:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703516B0089; Tue, 17 Feb 2026 06:51:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 602EF6B008A; Tue, 17 Feb 2026 06:51:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D72C6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 06:51:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6DD11B2E5B
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:51:24 +0000 (UTC)
X-FDA: 84453783288.23.3FB976B
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id E5587140004
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:51:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oahT2L8x;
	spf=pass (imf26.hostedemail.com: domain of 3OFaUaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OFaUaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771329083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJZSAw1OS3HkHNvztNaVejaKs19d/dpxzj4ZsznN3tA=;
	b=PTpOW4oErP1UCBWfneevh30Gf1lD86ni2hioGGq/cGAzwrYAdOWVcFXlgWHdywwWmp1Upd
	JHcUj/9t0SiUGf63NM5cz2gtSkp+IgKZTpCTD7vMkUCwC6EA9qS7t7cd/qhIXZMThmaIfX
	paZbwZBDZFB+LCvzqHnFwLZ0CONFHEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771329083; a=rsa-sha256;
	cv=none;
	b=NwR5FiBsgXbsZ8HIDeYz8sXnoB7hr3pXs/o0+9JZh5B/UT2aGF2yskKUmOaeYP0XH3wUSB
	bvQJ30htePhX1X9LOnW73uwO9PVaTmq7KMbKiiXKQUOR1Isp5LkkJfNYCy0sK1k72vKQ7e
	OkTLMSA7SpgPs9X2GaE7ktq0dOn4mIU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oahT2L8x;
	spf=pass (imf26.hostedemail.com: domain of 3OFaUaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3OFaUaQkKCIknyvpr4Buyt11tyr.p1zyv07A-zzx8npx.14t@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836fbfa35cso25297985e9.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 03:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771329081; x=1771933881; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BJZSAw1OS3HkHNvztNaVejaKs19d/dpxzj4ZsznN3tA=;
        b=oahT2L8xKyL+o6tAfRYXvbFoOfa70PUMXy4Ffb8xbai+KWtgWH7R3oY1+7dBeJPvtK
         VFLfZJfbRQt+R66b+ZOtYOYI7JGRjYrFbaeoFoPPzOHg99Qnlm7npUGf47/YFxA/PIX2
         Wo2+Zc0tPsmyx74+0MovtepxukwH+Ubb7TwqLhf2n6F7ocy3B3JKuziAkm0hNSAzMNY7
         2/8dvcETF/Kvn4E/c2ra3Qi4I9GVqdrgZOyJ2pXy3f/1JcpRAWVaVBD43V0K0z5EZjNo
         QP8j1g/oINkOyavDcWFSckdl2sQarkGbojkJnKEC8uTp9kcb4ijMCywKUOxxfejg7pW5
         YWzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771329081; x=1771933881;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BJZSAw1OS3HkHNvztNaVejaKs19d/dpxzj4ZsznN3tA=;
        b=e6iJwRfrR58sHL2R4LBLoo/2omnsgdpk11rTpl6aSgpxewQg8ZnBVtWHRds7DR1frI
         EauLRwjPnd3MVHThvXs2gLzEGHsn8VcZyEeVZt2CxrZIJ8E2dkOc9OoHBElkx/eMlo3H
         jbHUSrnj0qlmeEVZd4kATufO6RXBiBrhIZjiK8yPQLyV7QjaD71x7VFq6jX4EkxachDo
         aMxIyjMOQpvZwf8xatEXcBdhEf0YqetsrIFj4oqVEGmHLS1M3kafrZ+gmk6P/lGmcI3/
         pmPj81KkGwgMw30x8jlGu0iWCyBiQZz5VhUMT1FyOLQ7dlJxIw4CJzhgdTnTdu0exNLj
         +chg==
X-Forwarded-Encrypted: i=1; AJvYcCW5+bTE5ZyumHuByrdam0xz8VYX/KRXxWbfDqUJtyGc9qKH6NGkIbaIlXlhAbVe58kxVm+rDv7m9g==@kvack.org
X-Gm-Message-State: AOJu0Yx30tx4lZQ0M/OydUjhISDSsvRzIkw7jgYK1JDpBKpgTFLiQDP5
	Vs7dZRQbOZtJz64IOBlv4DXEq9dIQoDX4AKbrr4IsQqomftM9jkgSaxC2XtAO6TQ2+lcLmtiU8c
	+eyEJd+QCb/tuoey7Sw==
X-Received: from wmte24.prod.google.com ([2002:a05:600c:8b38:b0:480:6c54:bb0a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4688:b0:483:703e:4ad5 with SMTP id 5b1f17b1804b1-48373a37af9mr213342565e9.22.1771329080922;
 Tue, 17 Feb 2026 03:51:20 -0800 (PST)
Date: Tue, 17 Feb 2026 11:51:20 +0000
In-Reply-To: <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <aY9HD7nH5A-DtgmR@tardis.local> <2026021326-stark-coastline-c5bc@gregkh>
 <aY9PBfx3RRV7rXZ5@tardis.local> <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com> <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com> <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com> <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
Message-ID: <aZRWOIPThLfIZ1Ph@google.com>
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
X-Rspamd-Server: rspam09
X-Stat-Signature: ew6qtso1ndoqmrz36z4qkk47qhi8f1us
X-Rspamd-Queue-Id: E5587140004
X-Rspam-User: 
X-HE-Tag: 1771329082-151113
X-HE-Meta: U2FsdGVkX19jMEt+Jr7f3tJSgzW6Tjwb4SifbJpibXocOZAUuhVnPG82gFcZ8vLP9VNFz0jQXwPmL0Gvzl0NqQXLCYD/8j7Scjfywe3NVGB1BJeCt/O8FxP357MV/2Km43V9Z/njyz9qeSef45dNsMOZyAK2p1Jn3ERY3SUPQ/7gp65h6kVbs5sPp0XOz4Xlc6jR+T3SfTjypS6bsSMTNmr1OlDEbBvXRKI5idI7fz+vvULuAXopBKNPBo/R2JdakC3AxIT7oBE+0tXlG5Dv/b9VZ9ElMnn0Qvxm8fsMk2LmbHmCC/r7yW2n7DYHcq2bDwN5MX/oNQ8auUHEiR1f1M3eeat1UV4KYQ0s033JtCtounIVPvLbxebAbr4vpm1SOKlHKDX1u4pcy66P1t30c87qb7FMMqjzfAw+SnBMKSxogCGlBOxedGJFCet5DCZgQLnOY8ZduigHEQ53EQMYdOWCc8V4kH01HoRcVZt5ukuhyUhIA5qh6b+GeTx5LQiBS+ahd4kQw+DEzG1jPzugE9ExSjbcp0NCoTSEN5ic2f8+tqBW+qbfXqNoKw2w1lnppxUEwUCyLxORPTJaILFnnR8lwZFgkjyEE4tn464bW+NYoRby0fGTgmNCbVerwUv5Bg5hpEfh67fjFBbk8hMi1KdFSwQwtEULYiJuQClwzxHwc8nVEFEqpBaFSdnuTUrIKjoygrOaZondCQ6IZTVY4Squol1gHsOUiMexeohFUkULuZP9P5YosvoamDe5/9DrSGlkYocueD0rbB3Wy2ttgg+GSejEWCNfXuheS/fQKWhu9PwP4Gkw7xT21XFLHhB9tOY2okD+RVsHaqPXJs92/nM+gpLTYMpANFE5M9S69UD0CUttqPfNn0fXnG1f16cqZhY7XewjkkBurTtQVN/2JjVnGeVPs6QflTymrPMfHUMvlRfN0pEWLuX3h1uOz7GSCxwjCYMOujeEFgGnHmK
 +CpjdTgd
 TKtt/z4+hJ9oybCCHpJQ505GufonDGJR+R/XHOiQ3ryKszlaGGyiAT8C+4jlNuw1C8/6NhNx7ay8SJJipoof7XEDQ3zG8cuSL00p/KMPQm4QD2nVQrth+VgCthEqevDRpgDOGR4fuvnN5P+BFQ8fvSY59aX+jFd1yXlOvWE1WYc4fm3W7t6nPUcGa9+z0CaRXnERKiwf/0yc4FZ8ZJocDvGF0x8e/+g8M4Uy7nt9gzHVgivjcXz7cgZTaarOFWCv0SWvaEEKXMSeNKluPhigUbSUYuaauVId1IsqgAax2tGlTzuQIky0zTmKxaIY3XmIsY3XZ+9ihhON45pHlqj7CLTddjPPzAptOTS0J15GLSkd/GeExzyIxFivDbPbKikSyZ/9CGQaoF7zgYYq6rtr1s/sfmzDvZWQCWfM0eXNmThXfQz2BQLrZtHZymzgYQiF9Xw6Djhw5EwB/zZ0UZpjF6MemDeGQKyeHU+LnfL8Y076uksoth1vv4a9IdkEYNELPnLKkjhML+oG4bq35fRwZ8M/KqYIEMZRWZpDlCjTrv25ciOIHuZ9gQqPncpBeZdHRcqJ2UScYLS61fbh2Yu7LwgPb+UTTi+c5VqXFFbOcrllqBRUgcNfoply1PGxOhWwA1kPxEMIridD9/RInNYNgXinstSPs2D7rOuqmQCdNhmRoMwk9oF8C6MGNaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:09:11PM +0100, Peter Zijlstra wrote:
> On Tue, Feb 17, 2026 at 10:47:03AM +0000, Alice Ryhl wrote:
> > > > 	// OK!
> > > > 	unsigned long *a, b;
> > > > 	b = READ_ONCE(a);
> > > > 	if is_valid(b) {
> > > > 	    // do stuff
> > > > 	}
> > > > 
> > > > Now consider the following code:
> > > > 
> > > > 	// Is this ok?
> > > > 	unsigned long *a, b;
> > > > 	memcpy(a, &b, sizeof(unsigned long));
> > > > 	if is_valid(b) {
> > > > 	    // do stuff
> > > > 	}
> > > 
> > > Why the hell would you want to write that? But sure. I think similar but
> > > less weird example would be with structures, where value copies end up
> > > being similar to memcpy.
> > 
> > I mean sure, let's say that it was a structure or whatever instead of a
> > long. The point is that the general pattern of memcpy, then checking the
> > bytes you copied, then use the bytes you copied, is potentially
> > susceptible to this exacty optimization.
> 
> > > And in that case, you can still use volatile and compiler must not do
> > > silly.
> > 
> > What you mean by "volatile" here is the same as what this patch means
> > when it says "per-byte atomic". If you agree that a "volatile memcpy"
> > would be a good idea to use in this scenario, then it sounds like you
> > agree with the patch except for its naming / terminology.
> 
>   struct foo {
>     int a, b;
>   };
> 
>   struct foo *ptr, val;
> 
>   val = *(volatile struct foo *)ptr;
> 
> why would we need a an explicit new memcpy for this?

In my experience with dealing with `struct page` that is mapped into a
vma, you need memcpy because the struct might be split across two
different pages in the vma. The pages are adjacent in userspace's
address space, but not necessarily adjacent from the kernel's POV.

So you might end up with something that looks like this:

struct foo val;
void *ptr1 = kmap_local_page(p1);
void *ptr2 = kmap_local_page(p2);
memcpy(ptr1 + offset, val, PAGE_SIZE - offset);
memcpy(ptr2, val + offset, sizeof(struct foo) - (PAGE_SIZE - offset));
kunmap_local(ptr2);
kunmap_local(ptr1);

if (is_valid(&val)) {
    // use val
}

This exact thing happens in Binder. It has to be a memcpy.

> > > So I'm still not exactly sure why this is a problem all of a sudden?
> > 
> > I mean, this is for `struct page` specifically. If you have the struct
> > page for a page that might also be mapped into a userspace vma, then the
> > way to perform a "copy_from_user" operation is to:
> > 
> > 1. kmap_local_page()
> > 2. memcpy()
> > 3. kunmap_local()
> > 
> > Correct me if I'm wrong, but my understanding is that on 64-bit systems,
> > kmap/kunmap are usually complete no-ops since you have enough address
> > space to simply map all pages into the kernel's address space. Not even
> > a barrier - just a `static inline` with an empty body.
> 
> That is all correct -- however that cannot be all you do.
> 
> Any shared memory will involved memory barriers of a sort. You cannot
> just memcpy() and think you're done.
> 
> So yeah, on x86_64 those 1,2,3 are insufficient to inhibit the re-load,
> but nobody should ever just do 1,2,3 and think job-done. There must
> always be more.
> 
> If it is a ring-buffer like thing, you get:
> 
>          *   if (LOAD ->data_tail) {            LOAD ->data_head
>          *                      (A)             smp_rmb()       (C)
>          *      STORE $data                     LOAD $data
>          *      smp_wmb()       (B)             smp_mb()        (D)
>          *      STORE ->data_head               STORE ->data_tail
>          *   }
> 
> if it is a seqlock like thing you get that.
> 
> If it is DMA, you need dma fences.
> 
> And the moment you use any of that, the re-load goes out the window.

I don't know how Andreas is using this, but the usage pattern I'm
familiar with for `struct page` from my work on Binder is this one:

1. memcpy into the page
2. return from ioctl
3. userspace reads from vma

or

1. userspace writes to vma
2. call ioctl
3. kernel reads from page

which needs no barriers whatsoever. There is nothing to prevent this
kind of optimization in this kind of code, so an evil userspace could
trigger TOCTOU bugs in the kernel that are not present in the source
code if the code was optimized like I described.

Alice

