Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B34D206A9
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7546B00A6; Thu,  4 Dec 2025 09:27:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A576A6B00A7; Thu,  4 Dec 2025 09:27:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 947126B00A8; Thu,  4 Dec 2025 09:27:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 826096B00A6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:27:52 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2719A139250
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:27:52 +0000 (UTC)
X-FDA: 84182017584.04.C9BE3A2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id EAA5918000C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:27:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YwrF7ndD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf24.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764858470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fFnv22fcQB5aFcCjIbe5QaQi5Ay10FFsnk0wQwnxL/U=;
	b=ZXIMyAOIYQoqc1kv8ZQf6xeLiN/kZ6uH3WmnPfnHnEt0QeIuDDd9Dxmu8aFf1M5JNnsocO
	xlmwLqI+3jMJ5zdWi3FTOBoR55rLQVHfD2SqmS2cfXLGyPEmryzbvG0jIUEvNVjPB11e8D
	ZAhNjtSgwR4Wmr1siERE1a9onRKkgXY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YwrF7ndD;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf24.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764858470; a=rsa-sha256;
	cv=none;
	b=6q32Q1Kbasm9LAcLcPbIYkFQmOOIt9n5QxWT0Lk0g1J5a+E/yr9im+H0kCKei8o4K6kSFc
	c67176vTHucTMvrX6m9FHIK6fU3+c4CAZrAIX3M++qZdqFbsbPzAdhh8i8GEi1++68fxEd
	z47/kR2hHmmZ/o+vMgI09Qp9uNKxB3A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=fFnv22fcQB5aFcCjIbe5QaQi5Ay10FFsnk0wQwnxL/U=; b=YwrF7ndD6dZYtSnBju5djLf3B3
	9BwkHu8OrlzXfyMe9mncsj4GToO/8tqG0JtcRmUtUn95c3+ke4l7EthXBRpW1hDCA4txDm0KfBxlr
	uac/gVsFQHXWTT+0ldDi39DQYGDL7a09ckPOmCBRint6yxH5rrJeIDc88cwxVabg2dXtL8kn2nMt+
	vgvICwVvQw2tHBO07bBT954nsePfsujxuOldWJA2g2bIZA7a2me0JT2k5VO8kTeZWtLVle+Ebt+MS
	Q7bCGN4x5drE0np+zjvUTukF6CuC4mr5TlM7VO2qJC14ZL3jBLYAn5c9sIqH8WtCmYeUUz4Lh9uCL
	XJbsVcSw==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vRAJ6-00000004IZt-18oA;
	Thu, 04 Dec 2025 14:27:44 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id EF8FC3030B1; Thu, 04 Dec 2025 15:27:42 +0100 (CET)
Date: Thu, 4 Dec 2025 15:27:42 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Emilio Cobos =?iso-8859-1?Q?=C1lvarez?= <emilio@crisal.io>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Antoni Boucher <bouanto@zoho.com>,
	Arthur Cohen <arthur.cohen@embecosm.com>,
	Gary Guo <gary@garyguo.net>, Josh Triplett <josh@joshtriplett.org>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
Message-ID: <20251204142742.GM2528459@noisy.programming.kicks-ass.net>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com>
 <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
 <aTFhFXCqvy7nmDOp@google.com>
 <20251204111124.GJ2528459@noisy.programming.kicks-ass.net>
 <CANiq72=r+Fmu0uuNF=6x36GWWQZGZk9gApnMZxakJavviwG+ug@mail.gmail.com>
 <dd5856a8-e120-4884-8828-9d0c9edc60f0@crisal.io>
 <aTGJdlwMRxGg2iZ1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aTGJdlwMRxGg2iZ1@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: EAA5918000C
X-Rspamd-Server: rspam11
X-Stat-Signature: fq7fcokyeypg1cd8rykh7ypffxgmha4n
X-HE-Tag: 1764858469-967190
X-HE-Meta: U2FsdGVkX1+59Natx4/hsnBt5dmtDJLq2LtlsmTs+MJ3YGANGFtG69PjYXs67p6Zxl9Df82xM0yzHipAe3dPSRonr+BRbNDMpoFJOje9FdLbhKtfA56NAUC3CzxPQr+dB5vQUorTS24qDwkldDbIeK6pP5tVmeoeiHK0zY7eskRnEjGN0/9q5lYACy3E/LIjl4xEc/4v11wmNRqltwUpT3rtIhLg3XuNuUbAIacPn4ScAk+OAbGjKVa3puSx6XvU0lsgZgimoY6I/Glrfcxnph8JpXwP4zg8Hx/94sRbaxVdq4JVShUiHgvUP5FG9C3L12/jUNDzIjaH5YHldTDyKhYvkyf1gwiG/294jbwl2rX2BJUDLJKKXX3LJqSFdZmMfxdYbl+rkHLZV/NFyrsGbdMspEN0hXR7NyVzE4J/4x1QyXt6epAb7I2iq2YKOL1OD4b+kdJhnR0n2uTfZAvHfd6Fzy5mVcn5osDkBcf5z783g4564fyvMIyVmNbp8R8x/mle8j7NyWg6kknFX016zkdY8P5tDqk2Rk3bo8dXi5P67wXtVVwE3Y8jncxSioxn4eHqKRAInvb8R8FyM4DUOle6RL06Xd8HRqZu4GVmUrnaY5ayCZsIVe2jCTUKfsOo9HM4NGAEENQoPaVQqT8APRZ7Cx7VtONYTQK7yKMEJNTfitqwpFk3Ad0nPAjaPIysgrwcRsVOampsb4YKkAPqe3CRn8Xwd9AGQhMJsKnFtp3mB2oRJCkCEKzBb/oWD908yX+3CxYhy5sbzAI/pjRpWU+SIWDYomXx2z18d7FeDhtIOzwHfJQYMPqDQ0k8T1i40/3KmHBNAvjtwadPdCX0c6ve4TmAr2I8KULL5rpReKkBqvrU76HCS0zv4gAOEG4Tv5RcU+EGWRePlSwVxDjEIcyvNqf39nxrASSlQFiIp2qR2HDascruOrVTURUJn9cf4lmyOduPoKmMa6hhtt1
 PbJbTFmv
 YGBSTd9+WBHKqHebqhuoetbFtLrwe2Lz31Gb2xXPMx8iCxQC1/FWLBW8LiC/BzcxES2koyUGkOqrQTbt57HW4RVJrI+WOasZ9rE8kU94oTcqk7S/LzPsr8gnN21nyJYtGox5ZgmSvjQzUVJlW3rNAQ0dHzpRMPP4QUXPtjb8mI54UFGIoav+zNbPldRnwo3w97Mv5MZEdB5dna0/YrBjq/DcyNofFFcHXVwBn3PgheWiGAQDfMI+MdseD+twPisca8cJXtkWlPfO/Y1JdrW/ToSHg7lpke1K3CBX5ye1pyjlILujfncQrfPPW5uhSvynyM2krznFC3xT5+/FLE1V2tN05Ji1qNrw0ejI1ywyZ426hrdz00oihTYpY204tnq86sTYU1qs19SCO53U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 01:15:34PM +0000, Alice Ryhl wrote:
> On Thu, Dec 04, 2025 at 01:49:28PM +0100, Emilio Cobos Álvarez wrote:
> > On 12/4/25 12:57 PM, Miguel Ojeda wrote:
> > > On Thu, Dec 4, 2025 at 12:11 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > > > 
> > > > Right. Earlier I also proposed using libclang to parse the C header and
> > > > inject that. This might be a little simpler, in that..
> > > 
> > > Yeah, that would be closer to the `bindgen` route in that `libclang`
> > > gets already involved.
> > 
> > Yeah, so... there are existing tools (c2rust [0] being the actively
> > maintained one IIUC) that in theory could do something like that (translate
> > the bodies of the functions from C to Rust so that rustc could consume them
> > directly rather than via LLVM LTO).
> > 
> > I think the intended use case is more "translate a whole C project into
> > rust", but it could be interesting to test how well / poorly it performs
> > with the kernel helpers / with a single header translated to Rust.
> > 
> > I personally haven't tried it because for work I need to deal with C++,
> > which means that automatic translation to Rust is a lot harder / probably
> > impossible in general. So for Firefox we end up relying on bindgen +
> > cross-language LTO for this kind of thing, and it works well for us.
> > 
> > If I'm understanding correctly, it seems the kernel needs this extra bit of
> > help (__always_inline) to push LLVM to inline C functions into rust, which
> > is a bit unfortunate... But this approach seems sensible to me, for now at
> > least.
> > 
> > FWIW Bindgen recently gained an option to generate inline functions [1],
> > which could help avoid at least the bindgen ifdef in the patch series?
> > 
> > Anyways, it might be interesting to give c2rust a go on the kernel helpers
> > if nobody has done so, and see how well / poorly it works in practice? Of
> > course probably introducing a new dependency would be kind of a pain, but
> > could be a good data point for pushing into adding something like it built
> > into rustc...
> 
> I already tried c2rust as an alternative to this patch. It works okay
> for many functions, but it's missing support for some features such as
> asm goto, though this is fixable. But a larger issue is that some things
> simply do not translate to Rust right now. For example:
> 
> * Atomics use the Ir operand.
> * static_branch uses the i operand.
> 
> neither of which translate directly to Rust.

Right this. AFAIK Rust simply does not have feature parity with inline
asm. Them having picked a wildly different syntax for inline asm didn't
help either of course. But Rust is Rust, must have terrible syntax :-)

