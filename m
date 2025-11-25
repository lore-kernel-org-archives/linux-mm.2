Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99BA2D0E6C7
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 11:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25D86B002C; Tue, 25 Nov 2025 06:54:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FD106B002D; Tue, 25 Nov 2025 06:54:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912D26B0030; Tue, 25 Nov 2025 06:54:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7B8CF6B002C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:54:51 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A8995B798
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:54:51 +0000 (UTC)
X-FDA: 84148972782.29.7D2350A
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [185.226.149.38])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5141F40008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:54:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector1 header.b="EsKve/ru";
	dmarc=pass (policy=quarantine) header.from=runbox.com;
	spf=pass (imf01.hostedemail.com: domain of david.laight@runbox.com designates 185.226.149.38 as permitted sender) smtp.mailfrom=david.laight@runbox.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764071689; a=rsa-sha256;
	cv=none;
	b=lTgW9M6QjMep0r2KvI81wwHXnJL1UfzH8IAH/MyZm3z5gdHc4FtDvTFVc0ljK72dcsKFTz
	VZmtMmsUDrJib70Utvv8YNo0VMkupBflcAhpTMVeKH8QA1LDpdFIR27mHlFoiIB0Ek8Pk0
	sqh3up11VCpcylqODXt21pTX84Vn9Ns=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=runbox.com header.s=selector1 header.b="EsKve/ru";
	dmarc=pass (policy=quarantine) header.from=runbox.com;
	spf=pass (imf01.hostedemail.com: domain of david.laight@runbox.com designates 185.226.149.38 as permitted sender) smtp.mailfrom=david.laight@runbox.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764071689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nh1yNsaA292fV48gsHMIHyahU+adY0Wr/dx1SDRWz+0=;
	b=M4lZwrUZJAKTNVhTtNTXiR2XM/RAkeB/iYZQ+Qa0+fJOQdBZvwzWVXzmIVKG6+QuoJi2s5
	lHEPCJrT5Y4buLqNDwwGw2+vlsU5zRmOXjcDVHj0NZekR9tsQK4U9AsYu02JAr/HwP6YJ1
	dK7TfYY5Y2NXmeHNDMgBS+mtic3sgKk=
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
	by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.93)
	(envelope-from <david.laight@runbox.com>)
	id 1vNrd0-006412-Sv; Tue, 25 Nov 2025 12:54:38 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=runbox.com;
	 s=selector1; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
	References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date;
	bh=nh1yNsaA292fV48gsHMIHyahU+adY0Wr/dx1SDRWz+0=; b=EsKve/ruDXUky0Bwr9Xi1Sg5vp
	7NtQbfQbv8jtsD9obrDBg+F/qyUUADAC+gcoummm2LjVYk07NWvAosJ0qNxceq/6T+r9w7/IwbD1R
	0ntJ/uvks7vKhNaWoxjV/HGAiC3R+uQFHH0Uhd+KSlgYGy33sleRXhSgpUMuP4ZeWI44IA/0s0QKk
	/NuPzCOz9OoQ8/RWcaZSdoJKqlqO+bP10xlt0FX9+WTE4OwahixrhZyy7XIamoaaAbLiyklRLZBo6
	3FpwZghadJ9jkY1cdf8PTNqTLV0flKUCWz6KsHaMucyoIhuJ1A/h4Y1F4toewDR0c+nmvu+UbUBtQ
	e3mKoqAg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
	by mailtransmit02.runbox with esmtp (Exim 4.86_2)
	(envelope-from <david.laight@runbox.com>)
	id 1vNrcy-0006lj-Dg; Tue, 25 Nov 2025 12:54:36 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (1493616)]  (TLS1.2:ECDHE_SECP256R1__RSA_SHA256__AES_256_GCM:256)
	(Exim 4.93)
	id 1vNrcl-00C0XM-Jr; Tue, 25 Nov 2025 12:54:23 +0100
Date: Tue, 25 Nov 2025 11:54:19 +0000
From: david laight <david.laight@runbox.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook
 <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter
 <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes
 <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton
 <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>, "Gustavo A . R . Silva"
 <gustavoars@kernel.org>, Bill Wendling <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, Jann Horn <jannh@google.com>, Przemek Kitszel
 <przemyslaw.kitszel@intel.com>, Marco Elver <elver@google.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Sasha Levin
 <sashal@kernel.org>, linux-mm@kvack.org, Randy Dunlap
 <rdunlap@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, Vegard Nossum
 <vegard.nossum@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, Nathan
 Chancellor <nathan@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Nick
 Desaulniers <nick.desaulniers+lkml@gmail.com>, Jonathan Corbet
 <corbet@lwn.net>, Jakub Kicinski <kuba@kernel.org>, Yafang Shao
 <laoar.shao@gmail.com>, Tony Ambardar <tony.ambardar@gmail.com>, Alexander
 Lobakin <aleksander.lobakin@intel.com>, Jan Hendrik Farr <kernel@jfarr.cc>,
 Alexander Potapenko <glider@google.com>, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH v5 2/4] slab: Introduce kmalloc_obj() and family
Message-ID: <20251125115419.304dd2a9@pumpkin>
In-Reply-To: <aSUB1qrfhXp3suGn@casper.infradead.org>
References: <20251122014258.do.018-kees@kernel.org>
	<20251122014304.3417954-2-kees@kernel.org>
	<CAHk-=wiNnECns4B3qxRsCykkHwzovT+3wG738fUhq5E+3Lxxbg@mail.gmail.com>
	<202511241119.C547DEF80@keescook>
	<aSTKLsRNiEKtDqPI@casper.infradead.org>
	<202511241317.516BDE7B@keescook>
	<aSTRsIUPeT5EC5An@casper.infradead.org>
	<CAHk-=wgn-2ieKtaHAXLLge1UFckLKa88vo3XOdLz+fP+DLpHGA@mail.gmail.com>
	<aSUB1qrfhXp3suGn@casper.infradead.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5141F40008
X-Stat-Signature: aqqys37udhjs4h3ibfe3zxkwo636nnkr
X-HE-Tag: 1764071689-113137
X-HE-Meta: U2FsdGVkX18GqROKopT7RkymJ0EAMq6jWlaEysWfnyRNDx2I+S8Z9afI3mrRTQIROlkgtts77J+IOHwrpovFKa2CM+ypvebQgFyFPkA3BCDt2P91CWdaknTY2ogoGYnXjNvpYOUGuJ0N+iqOtBVjxBBcZjKSD3smVN5RkWqg9+G6AR6eCH2KRPiEf+zv0jjTvYMNlv26uTfo6EathHTKpE/HYnIpg0NnzUBN7ewMJUverVIQqwQ3Nv8m56ysnMSmg+RK2BMr2XA54fMOs+QN9Myv2mmU3YXp1knAlGw3OI1EiPy23XUyn9In9N63kEhjRF+5ZQuSNfAMWtFwU2DUgEhpEF+lxTXWa8keaMl+ajAHM74e8NbkwLr1MS2myF5A67UgriiaED1ww9kmqgZTlnWAvUuLIBG8NsTvLU0BDTDI2QhFxV7rwmjJ9c+PcSE/wqy4rzodMInZdLoq9Xrxm3dgdIfhLbg/KsRmJWo6FBOfMFu0Q/7QnElXpqRPS4bUdALRDbRpxLLMpxkxuicGfwxcW8rWG1t/KtygQXlzsBnW3yeRY38qW1b1usKkWe+MujsNm4XjYgq6rpoK/zD+ScSKGnvnfLNsp2l1GMRNAziTcYIOhIG1zcz98GFnsBaYiuGOh8f33Hfo1rZn99eTh1giMwipHLg/j2m+nw7qOr8tkxT/YXFAyzTot3CuhyQZhSqwSQHEwldjlojBZ66FNUhhYPtshJRp0OlKnbgqsqpigzqMe/uDcVVr8Y2FIPCozG6U/h5MIi/YtflsX0j3HLIYUQ48lYpKxtXLMAymEGgM8R298vQScbQEYf+6ufhh5B++f7j+jjZnZxvjM6ksJi+uFLv0DCuNYNkl2hEnlCAsr351j4bQdDRXgSa6sr4z83oRswJPwtev5ikl24S7flO5PnXeM3KtO/P952fimwSmFQheeFLHcRP120wMs0c2gUfpalmjAFMPhIEoD5i
 bZd1/Ntx
 ZCj9N9x94yh3uWGvQTLVqbXljJZD7fNZDSutwl96CFD5zLFD12YX7DimBkAxh//QcdOxWGjrMUb4I6yTMh6vHrwpjVdaa8zHWLRyQkc14pvRKSTgkcinUOHiEqQ78q02Ippf16GDtck4J0xQ4Vo/lHheBvqiiszs/CDacAJ297ofUKG+rC0+KgHPKXIvGAzneXhtRYe6nwSfHgJhmA6VDYvt8A/QW12A28Sr9bIgKJ4yh/uGj+if/gkhFITCG2RjS+AmFSBo1k8ZjgIpFmx+HX/f1DT5w3yLoVI0HjLCGsnaJTHN10NT6VaIxM1eUUMrwr2N+9PmsF0679lz2XvnZ7PLbRLMi9TM/LPecShCEH6Qq43SCvgNoTkdNNOIbQxgCy5SL6PO5TOul9R+K7aBHJ+NwVKuDEfzeRQDSunDTx98WOa5hfUuquHjRHhbfmTOs8iGbQq87UO/jk4afegOQuQapZV1lfXCkL3gNDJrhWGznNwc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Nov 2025 01:09:42 +0000
Matthew Wilcox <willy@infradead.org> wrote:

> On Mon, Nov 24, 2025 at 03:30:19PM -0800, Linus Torvalds wrote:
> > That all a very standard thing in assembly programming, which this is
> > all about. 'entry' is a signed offset from its own address.  
> 
> I used to be an assembly programmer ... 28 years ago.  I've mostly put
> that world out of my mind (and being able to write a 20,000 instruction
> ARM32 program entirely in assembly is just not that useful an
> accomplishment to put on my CV).  Anyway, this isn't the point ...
> 
> > > The warning is ... not the best phrased, but in terms of divining the
> > > programmer's intent, I genuinely don't know if this code is supposed
> > > to zero-extend or sign-extend the s32 to unsigned long.  
> > 
> > What?
> > 
> > A signed value gets sign-extended when cast to a larger type. That's
> > how all of this always works. Casting a signed value to 'unsigned
> > long' will set the high bits in the result.
> > 
> > That's pretty much the *definition* of a signed value. It gets
> > sign-extended when used, and then obviously it becomes a large
> > unsigned value, but this is how two's complement addition
> > fundamentally works.  
> 
> Yes, agreed.
> 
> > So honestly, what's the problem with this code?
> > 
> > The warning makes no sense, and is garbage. Are we not allowed to add
> > signed integers to unsigned 64-bit values now, because that addition
> > involves that cast of a signed 32-bit entry to an unsigned 64-bit one?
> > 
> > There is NO WAY that warning is valid, it's; not *ever* something we
> > should enable, and the fact that you people are discussing it as such
> > is just crazy.
> > 
> > That code would not be improved at all by adding another cast (to
> > first cast that s32 to 'long', in order to then add it to 'unsigned
> > long').
> > 
> > Imagine how many other places you add integers to 'unsigned long'.
> > EVERY SINGLE ONE of those places involves sign-extending the integer
> > and then doing arithmetic in unsigned.  
> 
> I have bad news.  Rust requires it.
> 
> fn add(base: u64, off: i32) -> u64 {
>     base + off
> }
> 
> error[E0308]: mismatched types
>  --> add.rs:2:12  
>   |
> 2 |     base + off
>   |            ^^^ expected `u64`, found `i32`
> 
> error[E0277]: cannot add `i32` to `u64`
>  --> add.rs:2:10  
>   |
> 2 |     base + off
>   |          ^ no implementation for `u64 + i32`
>   |
>   = help: the trait `Add<i32>` is not implemented for `u64`
>   = help: the following other types implement trait `Add<Rhs>`:
>             <u64 as Add>
>             <u64 as Add<&u64>>
>             <&'a u64 as Add<u64>>
>             <&u64 as Add<&u64>>
> 
> so the Rust language people have clearly decided that this is too
> complicated for your average programmer to figure out, and you need
> explicit casts to make it work.
> 

Jeepers...
As I've found looking at min_t() you can't trust kernel programmers
(never mind 'average' ones) to use the correct cast.
It wouldn't surprise be if the casts cause more bugs that the automatic
conversions that C does.

It wouldn't be as bad if there were separate 'casts' for widening and narrowing.
You also need the compiler to be doing 'value tracking' rather than just
looking at the types.
If I do:
	int len = read(.....);
	if (len < 0)
		return -1;
	if (len > sizeof (...))
		...
then -Wsign-compare complains, but a statically_true(len >= 0) is fine.

	David


