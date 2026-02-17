Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02334E6815C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:02:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 627F06B0089; Tue, 17 Feb 2026 05:02:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E83A6B008A; Tue, 17 Feb 2026 05:02:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FF376B008C; Tue, 17 Feb 2026 05:02:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39FAE6B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:02:01 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA6B38D9F0
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:02:00 +0000 (UTC)
X-FDA: 84453507600.11.16AF8E3
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0AF1B160006
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:01:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="c/vdCdvl";
	spf=pass (imf08.hostedemail.com: domain of 3lTyUaQkKCLISdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3lTyUaQkKCLISdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771322519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVqzBedJl0e/SY5rTfSCMuageeXR/z0e1KuV2G9as6U=;
	b=RyZ1OZc6UmJJs+26pc0/mgWXDla6Bvatd3BMqtXdyvSMqYWX0I4r2pavGHJM1EAo53CQ80
	GgoGvX0hMQYsWSmJqeqMFTG4qwj09o/tokK82zNftj8P5v7o4iZ62v+gEUbrt4YO3QixD4
	xU3QzoKRcwEW7xBpJou7npc7fAtpR/k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="c/vdCdvl";
	spf=pass (imf08.hostedemail.com: domain of 3lTyUaQkKCLISdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3lTyUaQkKCLISdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771322519; a=rsa-sha256;
	cv=none;
	b=liTDI/YhOqKk0nwUam90zw/8wUpNrJ7JLz4NQ0TkQ5A5klGJeUphjvrIVGwIGK6f5ZWSEP
	KUqTsCgslOL4ssKT3ULs1CmliRCJHLC+FLJeoPyYv+auKN9wZvECZ6CnGEZOPlFMq9zYaF
	O2GzdkPu8ivbDXmsX2mBG4PbTTa5uhc=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-435ab9ed85dso2934422f8f.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 02:01:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771322517; x=1771927317; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aVqzBedJl0e/SY5rTfSCMuageeXR/z0e1KuV2G9as6U=;
        b=c/vdCdvlTXeqAgaN594cGW+Qt8KzFbcU8aWZcI2TQ4X/OiqDHXtF3BGqfzeXLyMiX9
         XE5AgdQokn3qZ2K4gdwfImJDkpfS54NmOO6BrAmQdln/Sk8qOmfuGtUK4SI6nRZrYNdb
         bl49pR2YU+XhbDAATtx1CiPYjqO1Ff+/lezojc3nLqSKmTQsRQ2GJLcXszOtl11YI26k
         KfiBFfyMK4jnUUqYN3pEd2LgZuzS+HLDUVxka3kls8W6N3dRdCqnRK33PNp3HKwU+qlX
         Uxwjm14dZDgPQ4v6IOx+ltvucYj00U0sIpGlEH5JZ6XDkv8F5U0OmMFH1n3i0HjBYV+n
         F6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771322517; x=1771927317;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aVqzBedJl0e/SY5rTfSCMuageeXR/z0e1KuV2G9as6U=;
        b=BbaMIJIBAEs8AHD4I0RHK0HZLBwGcN5CpRSW/zEg/lQgA+J+k/C7Kadm3w4R8elUah
         ilfAHxyIJzIdHxC4SmXo3PXDyKC1h7GW/ylsxh1i2d8oBp6jtoJMJGtzF+Gmai3fvDJv
         dckQlnMfeU1OoPX46J5Kf1gHe44+y7OZWwPxwrCn8zucMaxlojkv80/jinc3c1MzXBRL
         NMacQVnsqbyq0iUfol+9aEOYLJZxKrdnSbjs6yA7lgPEkLRkMJ/4QGiW51IPSM2CfPkl
         gKsc594dAmG5nNCMJOqCtOBAGzTZu3Zpg54b1uwvuTUoCtq7SBZBqSLEw74odCT8BRxv
         jbtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWTXbfypES+B8hx9FdZYyw2Rot3A7/1juAdsbAcysNtyZRH0P/trPvNWCU/cfEYWaavyFQCvRJErg==@kvack.org
X-Gm-Message-State: AOJu0Yw+FevWAISijD7etsid075CtbxAOE/FcpdMqeI2S7f+nCP7AzEs
	zDpaaH/cQbLoAY3QiIPbiRZuHd04Z4Zas7KfGt+7Hf+5CWaT2qiPaCSDArPgqIvmGMfgu0H4XQ0
	Ij8414QaiHNZNLXeJqQ==
X-Received: from wrbfa8.prod.google.com ([2002:a05:6000:2588:b0:435:bb92:9d28])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:64e7:0:b0:437:8f98:8c91 with SMTP id ffacd0b85a97d-4379db34172mr17645373f8f.3.1771322517142;
 Tue, 17 Feb 2026 02:01:57 -0800 (PST)
Date: Tue, 17 Feb 2026 10:01:56 +0000
In-Reply-To: <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <2026021313-embody-deprive-9da5@gregkh> <873434u3yq.fsf@kernel.org>
 <20260213142608.GV2995752@noisy.programming.kicks-ass.net>
 <2026021311-shorten-veal-532c@gregkh> <aY9HD7nH5A-DtgmR@tardis.local>
 <2026021326-stark-coastline-c5bc@gregkh> <aY9PBfx3RRV7rXZ5@tardis.local>
 <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com> <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
Message-ID: <aZQ8lJJ-U_8j03Z4@google.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0AF1B160006
X-Stat-Signature: rb7jg14m8er15j7rfoy1f87kuwccrxfh
X-Rspam-User: 
X-HE-Tag: 1771322518-211872
X-HE-Meta: U2FsdGVkX19AhOruu5YvbBNwEPgTKkcjO/Cl+CcqHLTmeB0dnBizX3ErwYG1vBAtRAiNy3Ox0q2bdl7564WSWkV7zjZ7arMF/y9caHqJILCoIGEwAVPOvLLpQSVjfxZhxHvna0o8qr6xC/4xD5q7eNahowPM/3SKTMzPpoexzdhb06zWz7+gFNdW6pr/qdwHs+X1KKFf4BwDaVnNhh/N2Et76JIiimfjFz245L3qgrZT7AH/N1g4XL46hfF4BYNbb1kP6ndomR4ciq2ZLxv7wRMuakRtD8wRiL/11oTxgpa5gc2WWBHX7TnfNQzGweejMfXqAxM7/zzYzLfBo4UTwCy9MrB6W47c7g91sKDNlNUxlzu5ys5j7kAZtv1C2VonyRxtbvAHKpBbaUOkqQEf3z4Vk+tovtrLOfsFVKS6ShLwpDgoJXiU+UZAm0jqSKQ/CB1v7vw9sTnRmWuwIhZO3tvKWSSE/EWNZbcyW6Xh8xX4js3GoetcbKjyTqoemXO33p/9SwKo4IIRAX9SkaZwXp50ocLxVoD2907ueXiJUwxMRGuoHQCus1lbeuPRn+Tau/aK+229DzUSPQW3WdS/yhogngzM90Wa75s3+LJXE6bKh0zynXfvE+Z84BLKtPEOUAj1+fr8RsZTXUDPC/3UpC2M6nwFh8Tc2YSF2fhycQONoIqdaXBMJRFgBhkX7WMP2q4dJnZ+tpagLYgEfY73Yx5RA4T+Qca6Uq2JTknta9DKYzBcjMBQM61eip8VyNOx0UxNPFIX1vW5pOln2gcfLLc8QL2ygoIrZ5c5KMmfMbFytq0Mta4sSRXFeaL2YOlFEW4yBlAqjchiT0maFScQlkFoeTLodnJZuoKqdUyklXfnBO9zQx8h20/hwFDVajgzyCsUPGiCWiEGJjpf72OrecRV0nq34NNAuVx4YD+LcdH4v76zryxVFDCGMXy9agO+fFr2oF11Lqx5LaOe4Iy
 alJeB7at
 NjxVBdyauNuHbyHu6f9SSVOnYto73IUVYP3vnE3j64946JdgmyDT0A7DanBd6PM9frbWnpyO6N5MksnWYzmjA8SC1OcmcTXTAeeAwxzwWtjIhmxY9QYWsov5GsbqR3c9cuiRXeD806X5hsuMPTgxudPi86/6NlqG4Qamt2+iUY11uoK6xCdusxo+Xm1rzxVpnFW+OErkhx0lo8ePQg8vFRKmO4e3dPqhuKsppOd5dWO2nxq5pohFp1PTGr5tsARFQQiNFkwDzsOMuAq+O19Vg6ddae9Hd8alZQmnZWOr/vD/y9OkRB6/e8hkIj7hfN0464z4IjjE/zIXVkJrzAKUPjcO18VIlbQHRXy1uTrjQ5J+WI0mFGlpM2679wwakIsmmMYO3pWQ6SF+zt+Qj28UHVDz6zrkBQU+KFZ8JUEUfHjMfmOznkg4gdRPZ7pAZKbqF79fxjnyTuvLe2nAF83GjCwDRNrWYbiCzkw6gKQIqqPMDXy0z21efAGsiaFsfD7jfdT1SrW4kkj74vfiQn6imbESPu23W4LM2pJFnXZ2ybuTMRZOpVcNnQDGmWjTzUG4O0aBREIiKXgok7oKaSt5OFjGqjKqAlQhd3wT0OlW2Q2dhEpH/+Ex817jDu8CZLFJskmwH8xbFD98AzOgEL1wzV0TuvPhtj8fqtPvTsdJAsTmDppLbXdTcs8/FJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 10:45:15AM +0100, Peter Zijlstra wrote:
> On Tue, Feb 17, 2026 at 09:33:40AM +0000, Alice Ryhl wrote:
> > On Tue, Feb 17, 2026 at 10:13:48AM +0100, Peter Zijlstra wrote:
> > > On Fri, Feb 13, 2026 at 08:19:17AM -0800, Boqun Feng wrote:
> > > > Well, in standard C, technically memcpy() has the same problem as Rust's
> > > > `core::ptr::copy()` and `core::ptr::copy_nonoverlapping()`, i.e. they
> > > > are vulnerable to data races. Our in-kernel memcpy() on the other hand
> > > > doesn't have this problem. Why? Because it's volatile byte-wise atomic
> > > > per the implementation.
> > > 
> > > Look at arch/x86/lib/memcpy_64.S, plenty of movq variants there. Not
> > > byte-wise.
> > 
> > movq is a valid implementation of 8 byte-wise copies.
> > 
> > > Also, not a single atomic operation in sight.
> > 
> > Relaxed atomics are just mov ops.
> 
> They are not atomics at all.

Atomic loads and stores are just mov ops, right? Sure, RMW operations do
more complex stuff, but I'm pretty sure that relaxed atomic loads/stores
generally are compiled as mov ops.

> Somewhere along the line 'atomic' seems to have lost any and all meaning
> :-(
> 
> It must be this C committee and their weasel speak for fear of reality
> that has infected everyone or somesuch.
> 
> Anyway, all you really want is a normal memcpy and somehow Rust cannot
> provide? WTF?!

Forget about Rust for a moment.

Consider this code:

	// Is this ok?
	unsigned long *a, b;
	b = *a;
	if is_valid(b) {
	    // do stuff
	}

I can easily imagine that LLVM might optimize this into:

	// Uh oh!
	unsigned long *a, b;
	b = *a;
	if is_valid(*a) {  // <- this was "optimized"
	    // do stuff
	}

the argument being that you used an ordinary load of `a`, so it can be
assumed that there are no concurrent writes, so both reads are
guaranteed to return the same value.

So if `a` might be concurrently modified, then we are unhappy.

Of course, if *a is replaced with an atomic load such as READ_ONCE(a) an
optimization would no longer occur.

	// OK!
	unsigned long *a, b;
	b = READ_ONCE(a);
	if is_valid(b) {
	    // do stuff
	}

Now consider the following code:

	// Is this ok?
	unsigned long *a, b;
	memcpy(a, &b, sizeof(unsigned long));
	if is_valid(b) {
	    // do stuff
	}

If LLVM understands the memcpy in the same way as how it understands

	b = *a; // same as memcpy, right?

then by above discussion, the memcpy is not enough either. And Rust
documents that it may treat copy_nonoverlapping() in exactly that way,
which is why we want a memcpy where reading the values more than once is
not a permitted optimization. In most discussions of that topic, that's
called a per-byte atomic memcpy.

Does this optimization happen in the real world? I have no clue. I'd
rather not find out.

Alice

