Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC6AD1F9A6
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3786B002B; Thu,  4 Dec 2025 05:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B659E6B002C; Thu,  4 Dec 2025 05:07:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A542B6B002D; Thu,  4 Dec 2025 05:07:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE746B002B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:07:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2ED221608CD
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:07:35 +0000 (UTC)
X-FDA: 84181361670.07.5AE1D8E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 96B574000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:07:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HaSW3im3;
	spf=none (imf04.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764842853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WpEAcvMvK6YSRYCp4amZlv9jQN7IlgsqcQBRJ8YOgr8=;
	b=OzTN/pTkyjf/rcfR4KUDWhMmTXrYxCIZWB7L8so8fapX5Q24vxjS9DKlNg6Fo6l3wuRiUN
	wRoVqGBC+6Xp8OL3td9fzC584MQfk/EtND2MBcxDoGS2qUrVa/YGCl2B4wjQ1d1aqN+CZK
	rqWPObmt+vSxRc4zwzBqm7zvP++ZT/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764842853; a=rsa-sha256;
	cv=none;
	b=iyMXgm9KkgaRfG9zP00UHCMpn1AMqSSkieDqh+Rd7qr37D+13CLEpD+ioMhS+atCb+1kRz
	4+bYZo5vazX/ouwRbSAtI7zsWtoX7WoRIKfMETTkM4CTd4VXGol6YR7aZJDXgvw9i/b/j9
	oLuG0lguPHUP+4VKWIrMUZLTIsn4KE4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HaSW3im3;
	spf=none (imf04.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WpEAcvMvK6YSRYCp4amZlv9jQN7IlgsqcQBRJ8YOgr8=; b=HaSW3im3y77oMAz/9WiXSDPHBD
	sL1kHOVefSAV3h6BULyzzgRyOpqr6hQlY2QD0gwMkT4fBaaJgWyGZLHrV1HrJjmXo3AMrU1aMVsaB
	3pCJJq2gF2W/1HUJ47/p6uPa86ILWXSNmCj4tGuhcHpPeVL7g4ZsPmZDkIP1GEb7gwXSoJbqZCQM5
	e4Ctaw9iDlvsJpz4CU+JRk6D/k52ydDl/75OOjRbcneH09e9L8m7FWOVvmwD27aN/DIG0xQp8r7CS
	XSrjM42BjKvyoG6bdhwQNpzKxzN/SHQqMdeWKG7nbBTE1nqnSUg3jbQXh2UP3yTH6hEb3+pXRvzIL
	1vUul+Ng==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR6FD-000000041rL-1oUc;
	Thu, 04 Dec 2025 10:07:27 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id DA8A03004B8; Thu, 04 Dec 2025 11:07:25 +0100 (CET)
Date: Thu, 4 Dec 2025 11:07:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
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
Message-ID: <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251202-inline-helpers-v1-4-879dae33a66a@google.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96B574000A
X-Stat-Signature: n7jzgkaiy75p9c1ogje61rcsah6tpwbp
X-Rspam-User: 
X-HE-Tag: 1764842852-134058
X-HE-Meta: U2FsdGVkX1/dg19jkmDQEOtc8NKIlTcAyTxqyh5N8iDWjzshmefz8Us3L/uignxoLWimKqbhQfOap0o73MZsyvCi+vIu8hYElt3pi6frt9C3VLOvF5vjXJMrxPtd+8+l3c+tIUIPNmhR12b7dyv8VTnsFFU9BYy/hJuH56jLtZTbATxq5Mk1NK3/i6gx884hVLHPBFhhGXIlLvs7lCTGS4UwiYLsx5wDZ9J4SePUfyuILV14hiPMtN5RRQS9wQBdl77G4Ors/Qgx50J8z+NfajJGay9xjNy6/a2plb2gaOnncl+uj2dL8sKmjiZeJfnLuNy3AjxBwiZgiBnlm5vIQS6u16VRfrqSPp01CN3NxmSF9KPoXyxwAxrfrbZtc/pA4RzlDRA7/1qpWyz/dLRYGJd6hX8g6SmjIYL5LYLzDLG7H9CrvrY5s9c5T6P85CN8DFW5X4JydidwItiuvERBk6SylOeFKoBTyR6YdpbVNmw8j50zxcM+lHzajJ1uSZW0c5jm1hH6K/xKEIGfItYe50mcx/X+mId3nzAoaSFH5JzJPT/ZVGO48Xd1vu9CFec5XFBQgPrNhI/+KsfjNz8mStClRfX4GMNufzfzQt4LebHVe1A1vnaWlgj8IDCL9eKL+ZhsxIM7YAOstkremvyKOd+SGqqdszqV+0lefNZ5p+ErNKBSlYQk343NwBFDt9LX3D0YTg+reJ8jsM4oJaKVewUVhqfdpX3ZmqOi7lo6TS76zXyR3JKdggItIS5AI33ZXs+5o5G0ytdUnEkqafmSJ7MUMIk5qZ7VIx5gxt2JPjA2PTQDgH9Lg9d9Mji+0fVaobE7GTZZqVdXxYzRpqOd8Nf6RXEX93umvEacJ1DMpb8a8WOce+8tuC7IQav0e7l5dxunSchC7073gUKaD1szMz96w9z6+0cG1koJHKWtwfQI+HiUgDhlJ8Tr2e0xXT2IYnQ2ZghN5V+mT3yCAyz
 yROlsYBN
 jYtnoR/yEgtfQuIQmtn2xthtthsTYUTPe5vz1PSSWuaYfQS/pZW0jWYPA+lWN57RGZLN3S0SEp5pntzKwDGhGqG/x20zLrnphJ4L1uPlctdHvlPPqlQkwxWM/GLKowk8bIjkr2NYVSXcQ0eYGfL00MRzqM1izaDKZxVclEyVznr2sQyogR3+pqS+qMPEY1/beL2Wl3qDqA4dyv6BedPHTFTJ7Y2hPkvZ7AzMs6rHPfZQzFtZAYZ6WjwAePz7v4bVw6Lr/o9T/gL1k05s4j3RzsLzieAy+gUeVvALHXMIa2tHsAE9Ffq3GGtq3JTeSA1eqR3JEYdOIsOuNYDYsY0JuqWOsgK0QDCzqfkoAYlZonqNaAbW2lAKLMOYD4ZctGSdOvqgwOrjcah76s9yM5JTKvqivonVbss8WF/rqjTDTN1nb5HARfz58+7ESGSNLabG22e1kPGfoPBIkjtc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 02, 2025 at 08:27:59PM +0000, Alice Ryhl wrote:
> From: Gary Guo <gary@garyguo.net>
> 
> A new experimental Kconfig option, `RUST_INLINE_HELPERS` is added to
> allow C helpers (which were created to allow Rust to call into
> inline/macro C functions without having to re-implement the logic in
> Rust) to be inlined into Rust crates without performing global LTO.
> 
> If the option is enabled, the following is performed:
> * For helpers, instead of compiling them to an object file to be linked
>   into vmlinux, they're compiled to LLVM IR.
> * The LLVM IR is compiled to bitcode (This is step is not necessary, but
>   is a performance optimisation to prevent LLVM from always have to
>   reparse the same IR).
> * When a Rust crate is compiled, instead of generating an object file, we
>   ask LLVM bitcode to be generated.
> * llvm-link is invoked with --internalize to combine the helper bitcode
>   with the crate bitcode. This step is similar to LTO, but this is much
>   faster since it only needs to inline the helpers.
> * clang is invoked to turn the combined bitcode into a final object file.
> 
> The --internalize flag tells llvm-link to treat all symbols in
> helpers.bc using `internal` linkage. This matches the behavior of
> `clang` on `static inline` functions, and avoids exporting the symbol
> from the object file.
> 
> To ensure that RUST_INLINE_HELPERS is not incompatible with BTF, we pass
> the -g0 flag when building helpers. See commit 5daa0c35a1f0 ("rust:
> Disallow BTF generation with Rust + LTO") for details.
> 
> We have an intended triple mismatch of `aarch64-unknown-none` vs
> `aarch64-unknown-linux-gnu`, so we suppress the warning.

So if I understand this correctly, it will consume the helpers twice,
once for bindgen to generate the rust ffi glue, and then a second time
to 'compile' to IR.

Then the IR is 'linked' into the rust translation units allowing the
actual inlining to take place once 'LTO' runs.

And while this works, this still has the downside of requiring those
rust helper files and using bindgen.

The other day [*] I proposed extending Rust such that it would be able
to consume a clang precompiled header directly, this would allow doing
away with most of all this. No more helpers and no more bindgen.

Would that not be a much saner approach to all this?


[*] https://lkml.kernel.org/r/20251124163315.GL4068168@noisy.programming.kicks-ass.net

