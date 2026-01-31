Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC2AD73EB5
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 19:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15DF06B0005; Sat, 31 Jan 2026 14:30:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C516B0088; Sat, 31 Jan 2026 14:30:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F8D6B008A; Sat, 31 Jan 2026 14:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DD84A6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:30:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 42FF51B1D32
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:30:40 +0000 (UTC)
X-FDA: 84393251040.26.E3BFFE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2280C14000A
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:30:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKKB+iuR;
	spf=pass (imf09.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769887838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXB6vHR8z6QHTC9YbQ2JrH9kErWY3YwcbVLiTh1UB3A=;
	b=vQkvBYneybJ7wukqkLSkqI6c1cdNgIKnH+xKizdq28vTJDdDfkBQ/4ykflvb7i6DMemr2r
	yEsiQOpVDwQsS54aHh1YY9h6hZu8zDEhgGkM+QDVxl1eDdKAO6f3YAMOhTW5ISGnBA9GLJ
	9HrKfgzXxhAWdXarNGTeksQjNOo3mz8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKKB+iuR;
	spf=pass (imf09.hostedemail.com: domain of boqun@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=boqun@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769887838; a=rsa-sha256;
	cv=none;
	b=2EArdfJju3Iv/iIn7NwiLgHztHTIrtuuUsZ+DQ4OQHdgFCA5Grq0hpxO1JU5cMTiAxHyDp
	rw0OxKc/AltwvSXrXqj4l6Fb1mKyVDPh5a1wf7OZWe+VDfmSOES9V/C81B2GMiFBE2pNjZ
	xUYfW0izmltIQQSnfp3u61FBIeR8B0U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1489B44208;
	Sat, 31 Jan 2026 19:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4202EC16AAE;
	Sat, 31 Jan 2026 19:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769887836;
	bh=CqEWdOFYuLKJESic8imDZogOszIvyv9olgNV5ixul/k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mKKB+iuRuidAZDPY3DmNKnQ5NfVz4Ne5bsLpP1auedbo7rh0km4tjNA0x4UfEGUZz
	 Gz7R9b3B9mdzeOn4dbVn6zmAWipWlkPA50c3N6SfPNCYPAABw/zSLLD25FCO9K1CiM
	 pxC/fOzW9ih3ZI8ouU+EoMJ68S9lrSeOAiXkj2hHfeXNmsbE63ASXpM2i3Kvr0cazd
	 vj2ZD0uAfLhTZSxOnTsMGsiA4oaEd9j5dXy2nY9/lpdI3aDijEZsqy3I/KF7shzpup
	 nyuktP25ypX3ZzXe8uxTOD8kbyv92F10QlvAKUqEE6SJUygZSWUz9X3eVxN2MPUx5s
	 2/XCrlc6NiUJg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 40145F4006E;
	Sat, 31 Jan 2026 14:30:35 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sat, 31 Jan 2026 14:30:35 -0500
X-ME-Sender: <xms:W1h-acgrORYgmbliPZM05YCchcC9vv7pyJoxbKY-d8rG6Dc_m7j-uw>
    <xme:W1h-afZoQifj8vUB6LUaJR9NXfMIKn9cZUrTsuT-1yYjgcyU6bninbp7W5LXHc419
    bZnxt65D_msSVOSRMCgqfv3NWUh48GmdHsPYiHOqHUaPvRTInoBJA>
X-ME-Received: <xmr:W1h-aaNUIiVQjU-rSxTHQFIeowyYFYZljcg8RLZ8YTivUNZOsrbO3mlWjoSmkJOVgpWnt3Kz-9jyXo4J0EjRAVZjQAi_acZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujedvjeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpe
    ehkeeijeeggeehkeehtddthfdtgfejueefleeutdefjeegvefhhffgueeiteekfeenucff
    ohhmrghinhepohhpvghnqdhsthgurdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenuc
    frrghrrghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhs
    ohhnrghlihhthidqudeijedtleekgeejuddqudejjeekheehhedvqdgsohhquhhnpeepkh
    gvrhhnvghlrdhorhhgsehfihigmhgvrdhnrghmvgdpnhgspghrtghpthhtohepudehpdhm
    ohguvgepshhmthhpohhuthdprhgtphhtthhopegrrdhhihhnuggsohhrgheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepghgrrhihsehgrghrhihguhhordhnvghtpdhrtghpthht
    oheprghlihgtvghrhihhlhesghhoohhglhgvrdgtohhmpdhrtghpthhtoheplhhorhgvnh
    iiohdrshhtohgrkhgvshesohhrrggtlhgvrdgtohhmpdhrtghpthhtoheplhhirghmrdhh
    ohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopehojhgvuggrsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopegsohhquhhnrdhfvghnghesghhmrghilhdrtghomhdp
    rhgtphhtthhopegsjhhorhhnfegpghhhsehprhhothhonhhmrghilhdrtghomhdprhgtph
    htthhopehlohhsshhinheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:W1h-aYafUyOdhoXbZyL63-vj3lpjbJ5pVUeR6jZlAlzwxcPA2FSa4Q>
    <xmx:W1h-aSVVoAOl4agt_-gZpveogoRwTDq25foPUwqyUpSRc-YljZyD7A>
    <xmx:W1h-afDxiV_L1yBc0jXMMSsoNu1Cgs3l-CUNACx3KEGBSv6jezfePw>
    <xmx:W1h-aWITPSfbhz-IVxwCtxckSGm34oHA87R-LcHsWa70RF1TahUY-g>
    <xmx:W1h-aVscVcUwMZBww8IycVD-ARxI8ipzKovKou0lT2peYPrOPZcHBGVs>
Feedback-ID: i8dbe485b:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 31 Jan 2026 14:30:34 -0500 (EST)
Date: Sat, 31 Jan 2026 11:30:33 -0800
From: Boqun Feng <boqun@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
Message-ID: <aX5YWdBxPmPrTLDA@tardis.local>
References: <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <-5tKAwUVrj6fo337a8NWsHQBepB07jKIVI-VafwW1zp0vsGTCkBTuI5nCBniftYJePZy8kb7bhWptJ2Gc_B-kQ==@protonmail.internalid>
 <aX0lcVngRcRwqgd5@tardis.local>
 <87pl6prkc6.fsf@t14s.mail-host-address-is-not-set>
 <DceHeOJQ2ZdVoA8jlWqMpTO6bHsSLi-JNu4iXSpnMetXsYWKkLkv7vGSdHqqNIVV4XnkW5SfReAA9dDoUENEIw==@protonmail.internalid>
 <aX4xNxsF5Qs0CTPW@tardis.local>
 <87jywxr42q.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jywxr42q.fsf@t14s.mail-host-address-is-not-set>
X-Rspamd-Server: rspam11
X-Stat-Signature: ao8irhaxn15f5bxzbxa9t9wknu9wbajq
X-Rspam-User: 
X-Rspamd-Queue-Id: 2280C14000A
X-HE-Tag: 1769887837-236745
X-HE-Meta: U2FsdGVkX19uK03o6frQAUq5oGAmQFnLKblYDHXaKSULF1H555dh/dk1UTDzDwPUws9i8mN0k7xeNiQRQMBEhTG1PryTMDZ7DRuYcQHLYQnFj0mQ+LU+GW7rBAUsgUdq3dtoPOYD3kpsxZ29EBizwTfgZkwhKPSmuj16ep2d3ltqrfZsyEF0rf2faB/nigQgl6RmZwrUFTI/UDZUSeJXy/eQifCCYNUJ40zcmeaapa5qhuzJGC5EwCma3MTo2Tcvcc4M3sy3oOJRVSEd4FlA6kRKEBm7iBtC6gwNhJnUN1yLhY+a/hmKadJxBW/khrheap35rrLCWfZMz2XNmB+b4yCzAJHETD35OSft6/CKlnhZyw4ARPQhs79Bb/BnLb/+YRJjLEIeEINnB4odc6lKZ4TysoSw9K6fKmXS+PjibsHvAkr0WlNStzpNXCVq+EG6tt61Ys5MHTaZsVa7XpKcuKcg4aqSH7lBkCmFInJvAe01drVeodyL6TjqcTSfhBXInEHk/jlPKEFLdFG0IYDDRWNg9xVbCR6wfo44tyIO0dxYAfKXwkziJK2VJPXyWuun5Xl3n/lVy0QmTrYSqvWdoFQtWml6lNA991AUUEnxGqJsrAu9CEv5R1X80XGC5owmP2MxdRZNLHfIL4/o2K+pyok2mBVS3ST+vV7ExjmVffIvEnIytdMU8R9GRXB3cbfjzgtNdUYy4RDPLZLJYbfk/4uLeOXxEtFJcMsPB+Bqpl9irfaCLG5qO87JjNE3Zslfcp73LoZaI3wRSHoaEF0MH36qJROk30uOTmHYdJNSJAwrGqWcvGo3WYI9y1sFq+oIGEPKQxzdJSPnFuC62c/uiLZM7jP0WeQBXE7teBLqVFfuar5wirBkHAtbR70tYnD2gSdY+hj91aGqmwGGR3DQJFE1/usls4JDRfvPkMKnevRfk07bNVaO7kbid5/EXjAad5uqHLhBlhNm1MUFXef
 rsESsrTv
 gyoHUKPCFbPMVxnbq6apBkU1kv0qQWkyX+ESSH9iTlSW3SMe3zOi65QYGCChjg++fqPZk4B4qRu1FPLJc8lwoxckWYho+gMJdBoUzs23X9hP524+VCYi8TrUKjcZbPY7k4aUZWadPDfdn2Mp8puw8xO8Ul3YD51dBFZMGeh0M23fYLOG58Rb6UzrBroTY7+9Im0wboa8kihGhKTtYgXabVq+261nBgshBH8VDPlMOoUwxS7liS+K1nAGGBm8RSaPS1VgI5Py7kXAnyUHnJIjM+jXxzilo7OsX9pQx7wO1wbY99Hf8ElLbbkwVGyv0+n15IQKvnEar+c5OGojAWxoSuiRykccva4Ivt+7wixiIiwOWVHtJ5qxrXpwa+ePPtnnrP6AnYH2zhOAjKCpAHep5twEzhZiNly0fZoONbXQ4DxEWxOxGmW9S43k/ygpyib017yLK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 31, 2026 at 08:10:21PM +0100, Andreas Hindborg wrote:
> "Boqun Feng" <boqun@kernel.org> writes:
> 
> > On Sat, Jan 31, 2026 at 02:19:05PM +0100, Andreas Hindborg wrote:
> > [..]
> >> >
> >> > However, byte-wise atomic memcpy will be more defined without paying any
> >> > extra penalty.
> >>
> >> Could you explain the additional penalty of `core::ptr::read_volatile`
> >> vs `kernel::sync::atomic::Atomic::load` with  relaxed ordering?
> >>
> >
> > I don't understand your question, so allow me to explain what I meant:
> > for the sake of discussion, let's assume we have both
> >
> > 	fn volatile_copy_memory(src: *mut u8, dst: *mut u8, count: usize)
> >
> > and
> >
> > 	fn volatile_byte_wise_atomic_copy_memory(<same signature>, ordering: Ordering)
> >
> > implemented. What I meant was to the best of my knowledge, when ordering
> > = Relaxed, these two would generate the exact same code because all the
> > architectures that I'm aware of have byte wise atomicity in the
> > load/store instructions. And compared to volatile_copy_memory(),
> > volatile_byte_wise_atomic_copy_memory() can bear the race with another
> > volatile_byte_wise_atomic_copy_memory() or any other atomic access
> > (meaning that's not a UB). So I'd prefer using that if we have it.
> 
> Ok, thanks for clarifying. I assumed you were referring to the other
> functions I mentioned, because they exist in `kernel` or `core`.
> `volatile_copy_memory` is unstable in `core`, and as far as I know
> `volatile_byte_wise_atomic_copy_memory` does not exist.

I was using volatile_byte_wise_atomic_copy_memory() to represent the
concept that we have a volatile byte-wise atomic memcpy. I was trying to
discuss the performance difference (which is 0) between a "volatile
memory copy" and "a volatile byte-wise atomic memory copy" based on
these concepts to answer your question about the "penalty" part of my
previous reply.

> 
> When you wrote `read_volatile`, I assumed you meant
> `core::ptr::read_volatile`, and the atomics we have are
> `kernel::sync::atomic::*`.

It was the curse of knowledge, when I referred to "byte-wise atomic
memcpy", I meant the concept of this [1], i.e. a memcpy that provides
atomicity of each byte.

[1]: https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2022/p1478r7.html

> 
> So now I am a bit confused as to what method you think is usable here.
> Is it something we need to implement?
> 

First, since the length of the copy is not fixed, we will need something
like `volatile_copy_memcpy()` to handle that. So I need to take back my
previous suggestion about using `read_volatile()`, not because it would
cause UB, but because it doesn't handle variable lengths.

But if there could be a concurrent writer to the page we are copying
from, we need a `volatile_byte_wise_atomic_copy_memory()` that we need
either implement on our own or ask Rust to provide one.

Does this help?

Regards,
Boqun

> Best regards,
> Andreas Hindborg
> 
> 
> 

