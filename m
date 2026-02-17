Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 660E8E68165
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 10:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFBC26B0089; Tue, 17 Feb 2026 05:47:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6A96B008A; Tue, 17 Feb 2026 05:47:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD36F6B008C; Tue, 17 Feb 2026 05:47:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 992336B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 05:47:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64A2116115E
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:47:12 +0000 (UTC)
X-FDA: 84453621504.04.882FBBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id A659020003
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:47:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dimWAFdB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771325230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LIvsYuanJaSVU2XTXC/sl38d6ZMzJT2xIHg603sBEjg=;
	b=1h3QtzmTmJ8zSb4E6rP/+LbeD0WJw3glYGlgtgHmtiVUmRKsPy/46yE0AQaoTTfbDLppDJ
	UAOjVSV0Ox293/JoKnaIjQbGxRjPzc4R4GIwKQoJpik63Is3PjIPXZVh81TX29qnjRpKaw
	13z3lsSUobLDzqMtIp8iO7lxMwb8pmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771325230; a=rsa-sha256;
	cv=none;
	b=HiqgR4frNInTcUpImAPjMWAX5iFBN7ujFGbPpXPNdO0eT+aF5ShnzYNduO0FfmzKE5AWRH
	3zbBLi4xMzp7ucCi2w3B9s0BivqyJiJEKGPpP+c0lOc5dKEQFcNFvQTiCT/6kcd81c/sve
	uUSWx4W4dpCO1RB+/jl/7CKowFshrTc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dimWAFdB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BF61243F0B;
	Tue, 17 Feb 2026 10:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5625FC19424;
	Tue, 17 Feb 2026 10:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771325229;
	bh=jPZESxhIMXs/RxY/w6cYQfCTnb8bodLYmLkbO3et7W0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dimWAFdBKNvwkZuk4l6uQCDToprbLgD1Ycq78ddUZJl80GGBJoBzVrUjCo6ukvHRk
	 aij42gIV0NWIMSdKs1Qws2vaOLIUEaecJ9IgY9EPXU1FLP/lgbLJQ8fgTd9KGaoKnm
	 wcnKwOssT3xhkmlBen4u7mZOzMuiB+rQ8aWqp6wnsUDLMcnQyMUfiJH2LKP8+tuDTB
	 KjKd+5PqJcC7E+9kDsWCcYXAmdlU9ylwUDr0STTwKC15+OKJOZp9scfvPyZTKnJaOM
	 OH07t0mVlOa8ESEVQuJYboD8cCIZrJbKh78MiYc/8h8hgONVMk0dZsrQyJWaPQ0m1e
	 vz9MT0zILOjaw==
Date: Tue, 17 Feb 2026 10:47:03 +0000
From: Will Deacon <will@kernel.org>
To: Gary Guo <gary@garyguo.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
Message-ID: <aZRHJ22UtG1YeBMj@willie-the-truck>
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <aY9i8rbvnxdOA9DV@tardis.local>
 <20260217085541.GS1395266@noisy.programming.kicks-ass.net>
 <102c86dd6fb1a907b7138a437dee00dc@garyguo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <102c86dd6fb1a907b7138a437dee00dc@garyguo.net>
X-Rspamd-Queue-Id: A659020003
X-Stat-Signature: bj3t7panpxsrzwmsn58e4dp8aqnhg4pc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771325230-658626
X-HE-Meta: U2FsdGVkX18LG/tcXM1DWMc7pADQFR7xC7uUAyRQo0VKqUZ7MKdcZTVT1ZetuItajgqohAZK6WVmIy5BshsDTvHQHm4pea8KtWI6fll8IBRyOvlVXMxT37aoctNuL3SWgynLndQnRzSK6d8PAV3pJJ8uJd4OWGN0LPztIQA2mE3Qvaig2/ODjoCwTIqiFITfo29bxpvtrIbKQk5TMrJlZCmzsPot7SHnROQyHy6lS+f537j84ebkITwzP1QVGJRc7tUmTeMX+r20qs4cU2Dr5+FDlx5o5I90gKd6CL5HVkSpTVIiMELCMtfHJ5TF2GEm3/Amrj/kZRyz/EDMNBVzawag2hZ4ItblJFHoO8nWzvWHMTfcpylsKLlObOtaj7k6txMfqVjcOa5nlj2HHwGEjKZeHS7xDNYehu9lKReqvgHy8DQj4Wb12nJDtQsu+O5+B+L/zNsGMXfcnL2Wm/w0qaIbK2LEYiUsdZDrT603qpM2HWIjlrEsNVbrRO8/GOdyqhpptyd+6I/IQxJGs/cZjvAqsMeOGWGQwg51F+Eo9DNa14YIrMYFMEMJaga42m2OM+kB5xj6FsHZi3x1eFSndjWohT66TVoiNCzPSGn5Qi5EJh87Ll0Ba8qP8BXGACG/BELaoCO6UIUH4Rl85KHmaYzFepDpi/lQ/5wDQY6xZzDgE+IuFb7LmS6JKqQiwzXa/VivDi2R3wgR77EASfdB6l2+/YD6DtmeYO9C+78syL+A8hobfP9+SviXKty5uOM3gjlj4eLOvUT+5tNx3kxRed6Y0fdALp3PzNYbP388vDa0Z6R+5KO/DuDqpfauG8pMyTwOJvAkY1KlX/yjXckWr7g9Oss/CU2Th4QSz0Hay4wIGdKbILZmwuRNHm52M8jqe2yUQmt77qh6vbjvSHZ8uv+cYevGm3fX7HgrcP5jbbWFwvPK5YVRxWqTE4/MjRNvxWWgdiFZCA7uHfygNa4
 iOhLRj85
 fKX0YIwPGHMzeKOH7cSjiaOGecdOfxkBFc6dL4WGnlJumxxUiCxO5TPbGh1FZhOU5EfFPzrJue1WcN2lFUOBjBRX4jqfX8jKEMKxlXZ3SJf/cvl8dSJg1vV8EuaoO3si0tnzsYFTWqZUIaAQoyxcDGZg+99uqlfF6OpetYtn/AEPraY4Y2yPgyloPrPKirN4f5fXojJKxMf0k9g7tNCxQ7+nGKXjxyOxk1frMqIH/exxW/OaEg8HVZqlzDQPhpEjitkE7h9bHanvHN9GttMv0aok3m7WZj3b6OSZrlydO3jEaMIyI9MFh5YzCc6S45zm0KEL/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 09:42:37AM +0000, Gary Guo wrote:
> On 2026-02-17 08:55, Peter Zijlstra wrote:
> > On Fri, Feb 13, 2026 at 09:44:18AM -0800, Boqun Feng wrote:
> >> On Fri, Feb 13, 2026 at 07:42:53AM +0100, Andreas Hindborg wrote:
> >> [...]
> >> > diff --git a/rust/kernel/sync/atomic.rs b/rust/kernel/sync/atomic.rs
> >> > index 4aebeacb961a2..8ab20126a88cf 100644
> >> > --- a/rust/kernel/sync/atomic.rs
> >> > +++ b/rust/kernel/sync/atomic.rs
> >> > @@ -560,3 +560,35 @@ pub fn fetch_add<Rhs, Ordering: ordering::Ordering>(&self, v: Rhs, _: Ordering)
> >> >          unsafe { from_repr(ret) }
> >> >      }
> >> >  }
> >> > +
> >> > +/// Copy `len` bytes from `src` to `dst` using byte-wise atomic operations.
> >> > +///
> >> 
> >> Given Greg and Peter's feedback, I think it's better to call out why we
> >> need `atomic_per_byte_memcpy()` and why we use bindings::memcpy() to
> >> implement it. How about a paragraph as follow:
> >> 
> >> /// This is the concurrent-safe version of `core::ptr::copy()` (the
> >> /// counterpart of standard C's `memcpy()`). Because of the atomicity at
> >> /// byte level, when racing with another concurrent atomic access (or
> >> /// a normal read races with an atomic read) or an external access (from
> >> /// DMA or userspace), the behavior of this function is defined:
> >> /// copying memory at the (at least) byte granularity.
> >> ///
> >> /// Implementation note: it's currently implemented by kernel's
> >> /// `memcpy()`, because kernel's `memcpy()` is implemented in a way that
> >> /// byte-wise atomic memory load/store instructions are used.
> >> 
> >> And probably we make it a separate patch for this
> >> atomic_per_byte_memcpy().
> >> 
> >> Thoughts?
> > 
> > Its still not making sense; an no kernel memcpy() does not necessarily
> > use byte wise copy. And please stop talking about 'atomic' here. There
> > are no atomic ops used (and atomic ops will fundamentally not help).
> 
> Byte-wise atomicity means that the guaranteed atomicity is per-byte, not that
> the copying is per byte. The copying size and order can be arbitrary.

Curious, but how would you implement a memcpy that _isn't_ "atomic" by
that definition? Are you worried about accessing bytes multiple times,
or losing dependency ordering, or something else?

This all feels like playing tricks to placate the type system for
something that isn't actually a problem in practice. But I think I'm
probably at least as confused as Peter :)

Will

