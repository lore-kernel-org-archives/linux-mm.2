Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48230CFD624
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 12:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A90CE6B0005; Wed,  7 Jan 2026 07:35:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67B06B0088; Wed,  7 Jan 2026 07:35:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A836B0092; Wed,  7 Jan 2026 07:35:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 861AC6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:35:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 505568B3A7
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:35:39 +0000 (UTC)
X-FDA: 84305113998.20.A3575E3
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7795F1C0010
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:35:36 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=bPHmS0my;
	spf=none (imf18.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767789337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHE+uM9pFMpvKUfJm0PMn7/MMiQJxjBUC4G6rc0+7ag=;
	b=peycDprLkH0DyA2P4+++XqcXcvgjx81xMl5dmkM8LH81yQDFjulUbh9qHhlKE6qA6VviGP
	1R0aprMCIMvFhw+0o/zrsc1X0qsUJvg1+B/VRPqCviXHA5XotUsxWtFGMgf4xhgxD8MK9O
	5Nqthl2cgIGgQHk8vvvAKmyt7TwQ8d4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=bPHmS0my;
	spf=none (imf18.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767789337; a=rsa-sha256;
	cv=none;
	b=4eA5WlKF6hNv+BAKGrHVwCnaKwM0veGTmUsiDs1vNbHOMvUKd9ajh8I60PpcbuiCJhrV4X
	PmWL/NKrDSuG0IbfT6osbE2d9L7zaaITyJbvl7ITLAIO9hC2464O6w7eCheZOUwWiORBPS
	ISrW0ssrtXW22vIaYm9tJY8ZrNUmOoY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BHE+uM9pFMpvKUfJm0PMn7/MMiQJxjBUC4G6rc0+7ag=; b=bPHmS0my5zMc0KSgtrhRkA+vTW
	z8Eu7Wmq0eIbQNU2yC3YNgs0VuCTEbqJENgYB5FVcWwB5xwARLzeYZH94XMypln1xuFyKtHAZOdRz
	U4DAYDjYtqvbV6j0Sec+25E7rEGo/SUgkLRmhxcbMCyZb7AjHJlcusIr4Tk92i0yg492BC81/Tesj
	AiTOKmQi0EGinvOrsYZFIEQncVw27tFLtGb7tp0dfjEkGXjAU6UBVFcLbi0Zl0Y6qIsUU8erEvD9x
	f6nDRT3WQSJ3x2tfxW7/ueyOM5M6w23aN2hHLiS+8REmD7MykBJLvthi0BeLLp1Z7md5pKs0S/pSe
	IG6ePcKQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdSl8-0000000BKHb-0vmp;
	Wed, 07 Jan 2026 12:35:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 1B43E30057E; Wed, 07 Jan 2026 13:35:29 +0100 (CET)
Date: Wed, 7 Jan 2026 13:35:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
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
Subject: Re: [PATCH 0/4] Inline helpers into Rust without full LTO
Message-ID: <20260107123528.GF2393663@noisy.programming.kicks-ass.net>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <87y0m9har9.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y0m9har9.fsf@t14s.mail-host-address-is-not-set>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7795F1C0010
X-Stat-Signature: 9nub8w65kxn9xnp6zcsmecud5zuqcwjw
X-HE-Tag: 1767789336-15777
X-HE-Meta: U2FsdGVkX1/TDV1PTdHUHsBymcAqGdLcOwTtsmiKcS02+Lchd4tYqfthA6DPT2+zSP5LLJkdB2nH7ecHgZLeVne6rWY6QcfTp5DwH1I1ty6bVwCPECPqSAgOQ6N3AXTyRbE1mQNl3qWHeIzZ7agUug75TzA3UY6jWCmaIkC9KWKgiggucM8+aDd+2rUgucZLif7p3mQWHbnnLaJo8Dks1yGUDbH85xg66M/LdC5KGZojmLQdfbE4cmhpI1UZtGDNnci0iBi+PKk8ripN3KDRzumjjoLw3igiSJIhAOSsDWBPKpFI68AiBMIt171uPAX86RJIIE/oUi3sy4OuTwUgPcQIrsO8SOr5vz1zzBntLUpbp8WqXIhYsGgMjfc6/C5t6+VsW4q21w2EBGy4RbLi6uRG6SfO6U7HG3iQ2ZMDwYwmYPEdgsEUp4aoJh3NAsBKT2XAlCNnhzqQTIPQ4/ZwzMAbNMerKdg/sDDkcD86CIIte9EfRr2e9qELRUQmWG//v1Nu+l75YlnvePWgNc9smNlc/NShZAE31IsJbLHRqns2oX+NB6e+VhlVGQDLAdzix69CMv4s9DbCc1gc6yotasGOfajW3BzbDP4tadZPzPbr0rPbc7bnwiFr3PmvR1HOlwZzQ54OYUPwOtWZDnPpaD7ybs/YJViBGl2+Rg5HwpOJaAK5CKmRcglPomfo1g3aHZMOj/HAoiJVstAUfqvnNoJX7coT98uVgt0Wv4tuuDj0yGChqD32nEOORLviqqSqqCl6sZkcaH9BRzO+txEgF8dcw7gR3N9NJHdDYBIvrAkfI6obCt/pXnq4ZWqzBds8TTLgo7Pf3ZomltHi2J76B4WHDRLTHvu5kXb4HNvoybQJsAN+1IsJtlS+/nu0GzXWa08rBhyzOLVe69wcY3Zk04WaQIl3TIYAc3pdMdmQpnR0RECWKiZAMDHWljr6aUjPCwY7hVYHIQJCTEC8+6L
 +1AsrRe/
 rONKwM9/eh/QK/K+DWLN7a29pa2PAnbaPXOPlpiYQJbypram97Z/lsdwv2Od41vm2CsFltyxx5wGpvzlj77Z21B3mM3wHAnnwAv88nSXoUybC0tGN/cLJ1pDs80A6hr0U8CAWM9Fa3WQEJLezAJ0nwL16OeENzTUWsCFQEk7Avz21D7RPTdhqOUqBkINQDjLfFw4fAtLoRwy8esGJslqCq5v6ukrq1mpffvmjqBsgbiKsGnwMPKji129D9+O1BOrJ29N4uYNeB+QtOPAVJRJfmwavNu2ERHjyPR+YRXhxW7DjU+amOPD6u5kxDKYBUzODMbLdD/lTV/I9ueUUPsOZvpX8Gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 01:23:38PM +0100, Andreas Hindborg wrote:
> Hi Alice,
> 
> Alice Ryhl <aliceryhl@google.com> writes:
> 
> > Currently the only way for Rust code to call a static inline function is
> > to go through a helper in rust/helpers/. This introduces performance
> > costs due to additional function calls and also clutters backtraces and
> > flame graphs with helper symbols.
> >
> > To get rid of these helper symbols, provide functionality to inline
> > helpers into Rust using llvm-link. This option complements full LTO, by
> > being much cheaper and avoiding incompatibility with BTF.
> >
> > I ran a microbenchmark showing the benefit of this. All the benchmark
> > does is call refcount_inc() in a loop. This was chosen since refcounting
> > is quite hot in Binder. The results are that Rust spends 6.35 ns per
> > call vs 5.73 ns per call in C. When enabling this option, the two
> > languages become equally fast, and disassembly confirms the exact same
> > machine code is used (in particular there is no call to
> > rust_helper_refcount_inc). Benchmarking Binder also results in an
> > improvement from this change.
> >
> > This patch is complementary to:
> > https://lore.kernel.org/all/20251202-define-rust-helper-v1-0-a2e13cbc17a6@google.com/
> >
> > Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> 
> I get the following modpost errors when building with this applied on top
> of v6.19-rc4:
> 
> ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/drm/nova/nova.ko] undefined!
> ERROR: modpost: "__SCK__WARN_trap" [drivers/gpu/nova-core/nova_core.ko] undefined!
> ERROR: modpost: "__SCK__WARN_trap" [drivers/block/rnull/rnull_mod.ko] undefined!
> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_minimal.ko] undefined!
> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_misc_device.ko] undefined!
> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_print.ko] undefined!
> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_dma.ko] undefined!
> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_pci.ko] undefined!
> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_platform.ko] undefined!
> ERROR: modpost: "__SCK__WARN_trap" [samples/rust/rust_driver_faux.ko] undefined!

Looks like it used the wrong static_call_mod() version, was MODULE
defined?

