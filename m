Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 633B3D1F9BD
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 11:11:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522E06B0006; Thu,  4 Dec 2025 06:11:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D4286B002B; Thu,  4 Dec 2025 06:11:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9AC6B002C; Thu,  4 Dec 2025 06:11:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8A16B0006
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:11:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AA0D13BEC6
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:11:32 +0000 (UTC)
X-FDA: 84181522824.06.CA49F3B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B29F1C000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:11:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pSckmItV;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764846690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vs7IhsUdSawXMOrWf5f71JxGpFUjZulrktZ1Qm8Q2v8=;
	b=b7IGXC2rNTru+sB0anLqyevqXXKj/irxDRgH73Gux7uBPLTz4vTJ06wxxHhdbW4MO1a0YO
	HSvFLvYCqn5LC9AdAdMR1xRwR/hoPjuRQvL3Q117yafTuZ+ruoio+faSLHE4qco68Fb7LA
	xykeag4EAMegVK6r9/qVXRp7/ZK08DM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764846690; a=rsa-sha256;
	cv=none;
	b=rhyAPG0qHQe9LkfYQ6hwumURX3v7f2ht87XuZ5SAA5fGkKNrw/5nokBcHbeoX56lpeUsh4
	HxZZeYv9BKc8R4n05wvJm6sPtnJeyxBgXFI8ZjzXxZz6s61q6/0haS0kOOfrIKr0mObn+V
	CyckFPSie0efzabuqmw1tw4Hse8nkwM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pSckmItV;
	spf=none (imf21.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Vs7IhsUdSawXMOrWf5f71JxGpFUjZulrktZ1Qm8Q2v8=; b=pSckmItVUmdbVyusV0O0TfiwUY
	WLEioelO4DKGDd2BeLrPn03kKXhorOAL18yBqgatV/WrvupIb+SeLl/jVYIf7YyVn9tdpumdAf3XO
	v1L3ZKwMUYsApXPAEl7saGJq0Uc6SoSCq8tXizZ/VE3MZ9qLaeWPqwe0q8bSeaXVgeDzjgqUBnIDF
	L+w02J8EK0BsOFt+Ja1MizLg+TbFRyqe+mliXx4e2jbDE/aAi5xpFI0lsf81zE0cBkQg7y4zrKh89
	MQCsixAsQO4lW6rgp10bnayICypIt2TtsY6rNnrhfvd0ppat9BBV1D7K62OI3cP6vRmwXWjnpf74h
	RtUugM5A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vR7F7-000000045pY-0kUI;
	Thu, 04 Dec 2025 11:11:25 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5415B3004B8; Thu, 04 Dec 2025 12:11:24 +0100 (CET)
Date: Thu, 4 Dec 2025 12:11:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
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
Message-ID: <20251204111124.GJ2528459@noisy.programming.kicks-ass.net>
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com>
 <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
 <aTFhFXCqvy7nmDOp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aTFhFXCqvy7nmDOp@google.com>
X-Rspamd-Queue-Id: 4B29F1C000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: d7577ru6g7uyp5gzdg9swha33xgn1jig
X-HE-Tag: 1764846690-988936
X-HE-Meta: U2FsdGVkX19udDxeuGWTj12NGQ6fOnv/ReDBO1YGt3RXSQGm1QRzZBv0r2ZTSMgstUZPGznpgBYo+MfB0Kc81oSA+m5/Sck0kSlQNeElx76zByl8OOy0ZceVf5HqxmgXyq08gYCMZgWI4k1izWyGF0MIFxsyhwFKIHlv7QsCWt4WwcMW4R0mCW/IWY8tCi2sFoq51Q7Ljp/VNUEsdojLTBrtHTg73lOyQlTOI0fcRYNW0Ck8Lt0SLkokpzg39YIn+do0KNh0GtS1k/T4rhlCLdZ+4XFvf4MuCU0HZH7ghUAkZJr+FVyCJ3r+jETloXccTPX7suSX1IoBXssnjcjo9zWxidigipszbCzTCT0bo68ILFpvLxWLWO39sTTZzgyL5s/gt16HMdtH+3riLOL21lhe4463J8b/rbvY7FQJRx1tMZYM9FbEjVWwsGgboZujKFuqfGW1lB7Gqs/ylHHVRwEuB4WjOdVD4/2Khg9yvbElMXaPgfWRsFTjy2le0IiXc7fX8UKSQGn7TyP48QfwpO4jDaHLNjKiEp0LTPbkrL4wTHO0/WWsOsyYxcKdu0Q7Z2Pk4robBVl9YNWTQqFiCr9mdPpNRKPVLTsiEn/WMJXLhSoWHxW9bQbMyTH2OlJixpMtNhmnNZD5okjhYPHwmZz0Wuk0JxWX54GKB9AWiwQMkdRPVtZjfHj9TxOiByK4BvKYeylLMRLRh5dmLItVAKihnck+BdOr3HCp1r+/opO0vhANPMldFmPrjpDVFnc1dGazetW0tfHkqIw6eKEbSuukJs5zRAVxXKUYoSx2zl+IB6N+6QXCHwMPkpNz6uW3lfOvaWEK5Ug8ijA8PsnCowpFQRaI7MRKS+KfDsT1a78IFraGgV/cWicqepjHIxlhXZ41TKtePFoxo87WthxxyXtM9givPDqJwcdT3Hmv847aPHLj+j29VV9GLBLTdKhzoZem69hwnO3OmMBGObo
 CIaLD2pK
 3FmfiIGVP3Ui1VByXTi4hdxyXxz4oqWdnM1b2dCNKocEQ/vIiIYgFdAyyFRdBl5k/7oGGyqdp69qF0fdb8ZsUoJ3yAHvUOsPXMMWIz1FnAs3bUxpODiGIshK64iRdcX7czJO2TvDdnRmmmGWZtUjU3mQGvkJe/FiCbLmc0ng22oXv6Gsw4PEf7Rp42/B9RdNjs58GnTZbagQ6K1eYFLqhAF0INEn+204sE9EZYyaI2PNdro4kwfojobac2zXNF1jh2+eOvzYoBH9n/0enyIcq1mz/9SGPTI7mhoT4E9/QkYmiwFUv7jcgZGsH6SiMX6/enDDMiMn7HCxzj8pXQbZpZ9It6NBmluOT+Fkt+t/8qBu2FVYi2nEBf/B2dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 10:23:17AM +0000, Alice Ryhl wrote:

> > The other day [*] I proposed extending Rust such that it would be able
> > to consume a clang precompiled header directly, this would allow doing
> > away with most of all this. No more helpers and no more bindgen.
> > 
> > Would that not be a much saner approach to all this?
> > 
> > [*] https://lkml.kernel.org/r/20251124163315.GL4068168@noisy.programming.kicks-ass.net
> 
> I have actually discussed similar ideas in the past with Josh Triplett,
> so you are not the only one who thinks it is a good idea. Unfortunately,
> the road to get there is long.

Right. Earlier I also proposed using libclang to parse the C header and
inject that. This might be a little simpler, in that..

> Another option to get rid of the helpers is that bindgen is working on a
> --wrap-static-fns flag, which would generate the helpers for us.
> However, that route would still require this patch for them to be
> inlined.
> 
> One detail that makes the precompiled clang header really tricky is
> that IMO we should not require RUSTC_CLANG_LLVM_COMPATIBLE for the
> build. With bindgen, you just need bindgen and clang to match LLVMs.
> That's easy since bindgen loads a dylib from your clang install. But if
> you build this logic into rustc, then you need to be really careful to
> get rustc and clang from the same source, and that same source must use
> the same LLVM to build both.

... if you build rustc against libclang they are necessarily from the
same LLVM build.

But that might be more tricky in that you might need ways to specify C
specific build flags.

Anyway, good to know people are in fact pondering this, because IMO the
whole interoperability thing with C is quite terrible.

