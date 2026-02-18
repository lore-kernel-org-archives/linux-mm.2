Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65E30E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF2A96B0088; Wed, 18 Feb 2026 04:40:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FEC6B0089; Wed, 18 Feb 2026 04:40:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F556B008A; Wed, 18 Feb 2026 04:40:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9242C6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:40:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26F53B976C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:40:11 +0000 (UTC)
X-FDA: 84457081422.02.1D1A2E0
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 77E8C100002
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:40:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=E0xfeB1t;
	spf=pass (imf14.hostedemail.com: domain of 394iVaQkKCLISdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=394iVaQkKCLISdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771407609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qgmQYzq/LwIvRAllD7t9G5Xcp/7gpl+R9gFqsKAeyw=;
	b=Ngv7+14RwzDIunB+Has+Boa5fpC4wOVyiW8LqDla/hj9FClQwg2ifPaGuIoZJJdc4c2D+h
	VnJU6DPd8Ya8/du9ZSrC1WNAQ6vy3UA9AH8XaNNisz4l31sjXsqJuo2VFpZ3ACBGunTT4z
	cd3vScKyR75OP2N7zy0J61/fafMTMhU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=E0xfeB1t;
	spf=pass (imf14.hostedemail.com: domain of 394iVaQkKCLISdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=394iVaQkKCLISdaUWjqZdYggYdW.Ugedafmp-eecnSUc.gjY@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771407609; a=rsa-sha256;
	cv=none;
	b=C9maygYdN6yo9siDOrAbe2mzfIcfaCUxuuFQZtsr7a+eCtGymYtYNHgngyFbKg8RakjKTw
	Itkb0RRtaYtZc4GTWQ03eQuLDx57rdjpFhK+quowR71HhUL/mjKfLDtsbVeKt1ajWkj4rY
	xjrHfU16Ige1g7POXpZwvqD7hRr6OhM=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4362197d1easo4345135f8f.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771407608; x=1772012408; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+qgmQYzq/LwIvRAllD7t9G5Xcp/7gpl+R9gFqsKAeyw=;
        b=E0xfeB1tv4kC6beY+I7r3wLfd9K/SixeFfULPmqdBgNTYN0mIErdyRtbfk8e0AxU/3
         XxYD9bGjMb5YhTPubAzDLzCvWQj9Qaw1RwI8qBuQS8QcWTRQ/kFR4Vsk/Sttc4rwmpRK
         MafNlHMq/w/mpfvcZBM1MePm8HXKZAX3GublkoW52HnN6rXMO6jL6h9Z01zuGEl0LxKk
         tn0yp7gc4AIXWv07dtPl8AaRPGVBAmW+DnKC3NeLAOwyLpWkPVkTQWMHQKJyU7402dxL
         8lDvMYMs/rcdqiOHIw8t4eAEtUQ7pg8bqXXMQmhgBhSvEuhtvZ+SN5AEFyp6pZfHOJrN
         qnVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771407608; x=1772012408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+qgmQYzq/LwIvRAllD7t9G5Xcp/7gpl+R9gFqsKAeyw=;
        b=f8GvZqorA3W1NbT7crMvzoRByF06/XlQJ+poiGoVUwWoLdTEGo90//2ZrCWbiIsiwe
         PDuwv+g4damBFj4Jqso853aKKInsG4SKtJIDfw6LxWEYiTnbRbf+V9EyihtJq7qIcKXc
         tH9Souona/uSXDw1CeAPopbyjnn0PMiR7zkqiG6oWmAX1IgfJBQ9piKshVp1HQHdBOAY
         yTNfWNOFuoLDkLWJU+ora911oKGOS+htDavC2BSWQZnjLkuWbmePsES2doBE3GCfAAzz
         b0DBDgx9ihmZ0SndNcfX+Xxq6li4jPeM4KkV+1V+lrMhZjghF1YwFyDn2P8Gkx5UKJCf
         c04w==
X-Forwarded-Encrypted: i=1; AJvYcCUIX2WHfFmsxBP5DXQHwa7lbnYEv/VAVmZK3S1QQD0MJCyNEYa341yNxhVex4RnPtgmoyaTdWUydw==@kvack.org
X-Gm-Message-State: AOJu0Yxf4RrgLJXbwnD1unCqojV4Npi7rIWHYaDJRMaTtFqtoMcrNwcu
	C95H2r1sezDHO8CnlL22sX7UQ54h4NnDVdXhRK77XUiQgmsBL3H6h3AvXayMNHkNuVFvy+aKzsO
	wqn6Tabj5obB7qLDuEQ==
X-Received: from wrbdr6.prod.google.com ([2002:a5d:5f86:0:b0:437:6ebe:6e58])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2dca:b0:437:6e63:9172 with SMTP id ffacd0b85a97d-43958df3516mr2229518f8f.4.1771407607843;
 Wed, 18 Feb 2026 01:40:07 -0800 (PST)
Date: Wed, 18 Feb 2026 09:40:07 +0000
In-Reply-To: <67aea464d25c8cafb3113eea62c8221b@garyguo.net>
Mime-Version: 1.0
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <aZRY9HthKwVJrAf1@google.com> <67aea464d25c8cafb3113eea62c8221b@garyguo.net>
Message-ID: <aZWI9zGIO6rtlCCg@google.com>
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
From: Alice Ryhl <aliceryhl@google.com>
To: Gary Guo <gary@garyguo.net>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Boqun Feng <boqun.feng@gmail.com>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 77E8C100002
X-Stat-Signature: x1z357jjzbbasupqrxnmnx7cbk9cp7jz
X-HE-Tag: 1771407609-421182
X-HE-Meta: U2FsdGVkX19hGyP3Cy+Odw69LhU1/KLKEnv/LjUpAvJe2B4byjYbFCYy42mt8nImKAhgPIX938QDhcTl60T4mbfYjUmesnSSy3hD+ABfO8XUISSV0dqgZUh7cJ1qlBuobzEoyVLWbxYgwWoAnoJ4RFQBhozkScfGxBBUPbq9/egipFMJwJa4DzyN83lXk5OSqMgidOBp8xq1xd3MUElUsPW/eu5ceM30uzr8KfYJI1E0yarfbIE1BeaP/rmMUFHwe4Q9O+NkDZDTjxsvWzNiL27wCr1LdlzTjMzmzLrUslPrCUzxjtjzY0QRLYUTcHAcKsiHYDQ0kM1ap9PwLiXHUsE7g6C788DQ4EMFqjgyt6HSHXM261XQznjdsq/ExwWLfUlUTivemtAWgFplkB5w317X9cO7V6jIAHucJsy5YaDIuEy1dx/iy/aDz2pbasDA1E0M/L1nJQFZCQGNMf6SmguMBKsRPNjW99WtJ4BaX79Sv8JOAo3H49ENz9iUQ4H2jnurK9U8Pwrjm9UKsa2LQkb8lnmlQLr72MmLS3AB3U9APIiDLI4ZUHXEp0I4RxcXvXidu5WohQVohKF9OZOifDLmqnJJFpEEBzrm3E8RDlm8Xo8EoZ9ikJBymUe68Ke5MdTCBatoIQPVhWDQfGxGlnAZOUqc5fMAUiosFDYvaIBVZ8aqqKXyFSWHPyjNvtVbeWmsqofDXSK7CZMGuuJ7KkOdnIDf5dZFqFmSFUVQ9JTx9SDTW1KFbsHL+bIZIxUPyehGQ8+VND8mBOMOU7C63zxYCLLpq3A5UpFNzXzfTXk45FwJuk9VpPubqmcc2bCtQyw7nZkA6+MepXLWZ1Ze90DCxSISBMWyce+j5x/M344o/IFSv+XdOq1bPvCwZj80FqgTCa/0UStWZ0bdH6D76w0O00w+iAiYl14UKtgGXtwJ1mOCvoy4GFCNCKVKG79e+rkb5NpUXsg5mQNJmSk
 TrFAEbdS
 leISoOtZmiYfHxe9EPjLtoX7k60KoS/fzaCdnwvwl+CHvjiDwoKk7qrbjX0gnjhAgxXehYV/p4GleFFguF+T9aywejJeUyd86+aK98WCoIdUQpo1ChXq0RnusCtJP69EjvUdUgVAdpaW24dnHW0bM6qhJ094Cr3itO6KvXmq2soNbRSp0BpPi+T/i1zpUtsvuJbRRSPElIC5BCsq2oQHAkXzGArzIu0ru4XxyO87qdhmvj2etHIyMW4/qYXXaLWcKLoSeF+GoOT5siioPCGGgRtIvgWGnBpBx+aEvJ0sf7hTmaaz/LX3mTId66TY1KnsGmciEZBzkgYEfb/ePtIbfRzuq9ME82DrSwqTRqNphjkJDB359TnQ1dAlFWKKdtzDEYBZX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 11:10:15PM +0000, Gary Guo wrote:
> On 2026-02-17 12:03, Alice Ryhl wrote:
> > On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
> > > When copying data from buffers that are mapped to user space, it is
> > > impossible to guarantee absence of concurrent memory operations on
> > > those
> > > buffers. Copying data to/from `Page` from/to these buffers would be
> > > undefined behavior if no special considerations are made.
> > > 
> > > Add methods on `Page` to read and write the contents using byte-wise
> > > atomic
> > > operations.
> > > 
> > > Also improve clarity by specifying additional requirements on
> > > `read_raw`/`write_raw` methods regarding concurrent operations on
> > > involved
> > > buffers.
> > > 
> > > Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> > 
> > > +/// Copy `len` bytes from `src` to `dst` using byte-wise atomic
> > > operations.
> > > +///
> > > +/// This copy operation is volatile.
> > > +///
> > > +/// # Safety
> > > +///
> > > +/// Callers must ensure that:
> > > +///
> > > +/// - `src` is valid for reads for `len` bytes for the duration of
> > > the call.
> > > +/// - `dst` is valid for writes for `len` bytes for the duration of
> > > the call.
> > > +/// - For the duration of the call, other accesses to the areas
> > > described by `src`, `dst` and `len`,
> > > +///   must not cause data races (defined by [`LKMM`]) against
> > > atomic operations executed by this
> > > +///   function. Note that if all other accesses are atomic, then
> > > this safety requirement is
> > > +///   trivially fulfilled.
> > > +///
> > > +/// [`LKMM`]: srctree/tools/memory-model
> > > +pub unsafe fn atomic_per_byte_memcpy(src: *const u8, dst: *mut u8,
> > > len: usize) {
> > > +    // SAFETY: By the safety requirements of this function, the
> > > following operation will not:
> > > +    //  - Trap.
> > > +    //  - Invalidate any reference invariants.
> > > +    //  - Race with any operation by the Rust AM, as
> > > `bindings::memcpy` is a byte-wise atomic
> > > +    //    operation and all operations by the Rust AM to the
> > > involved memory areas use byte-wise
> > > +    //    atomic semantics.
> > > +    unsafe {
> > > +        bindings::memcpy(
> > > +            dst.cast::<kernel::ffi::c_void>(),
> > > +            src.cast::<kernel::ffi::c_void>(),
> > > +            len,
> > 
> > Are we sure that LLVM will not say "memcpy is a special function name, I
> > know what it means" and optimize this like a non-atomic memcpy?
> 
> This "treating special symbol name as intrinsics" logic is done in Clang,
> and won't be performed once lower to LLVM IR, so Rust is immune to that
> (even
> when LTO'ed together with Clang generated IR). So calling to bindings is
> fine.

Ok, that's good! Then I'm less concerned.

Though I guess it means that even if it's known to be e.g. an 8-byte
aligned memcpy of length 8, then it still can't optimize it to e.g. a
movq instruction.

> > I think we should consider using the
> > 
> > 	std::intrinsics::volatile_copy_nonoverlapping_memory
> > 
> > intrinsic until Rust stabilizes a built-in atomic per-byte memcpy. Yes I
> > know the intrinsic is unstable, but we should at least ask the Rust
> > folks about it. They are plausibly ok with this particular usage.
> 
> If we have this in stable, I think it's sufficient for LKMM. However for
> Rust/C11 MM
> says that volatile ops are not atomic and use them for concurrency is UB.

I'm well aware of that! Yet, Rust currently provides no alternative
whatsoever, even on nightly, and has already told us in other situations
they're ok with Linux using volatile for this purpose in limited
situations. That is why I suggest doing this temporarily, and after
asking the rustc compiler folks about it.

> I recall in last Rust all hands the vibe at discussion is that it's
> desirable to define
> volatile as being byte-wise atomic, so if that actually happens, this would
> indeed be
> what we want (but I think semantics w.r.t. mixed-size atomics need to be
> figured out first).

Yes, that's right.

Alice

