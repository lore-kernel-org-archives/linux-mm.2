Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24289D1CDCA
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 10:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636F76B0023; Thu,  4 Dec 2025 05:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E996B0026; Thu,  4 Dec 2025 05:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C026B0027; Thu,  4 Dec 2025 05:23:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4303E6B0023
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 05:23:22 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E445A160851
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:23:21 +0000 (UTC)
X-FDA: 84181401402.21.B000F8C
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1697C10000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:23:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IE+tPaYC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3FmExaQkKCO0PaXRTgnWaVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3FmExaQkKCO0PaXRTgnWaVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764843800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EF1MlHpf4n5Q1St5clq56+r8fU1ZS9gsCdCeRZ6mpDg=;
	b=TWzH/yS4SC52CZaja7nyVjGX7f9LfwgR17U1sUK2EJbS5dX5nG79pGlE4SyUkFw6a57fJl
	/a3IbzTg9IMRFLq4iWjXpz6QtnqLGeTgmYbiYdoTnBO33BYeFV3AJW2ZEE5e+BCww3o6jr
	y5cjBsy4WmpeIz/4piSxpym97GNmdQU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IE+tPaYC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3FmExaQkKCO0PaXRTgnWaVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--aliceryhl.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3FmExaQkKCO0PaXRTgnWaVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764843800; a=rsa-sha256;
	cv=none;
	b=aPDCOJO5smgGXHgFLhQ+hDAlh+OaQkD49IDfpKP5hrHHmLLQGHYG6veT4F2YM/BZyVtKqi
	rmuuW219lwi7UUZzEEmPKBL+T7E449Dllr8gKxG4+tjymoV5RQpju4wKsKNzrbJRngbL1S
	Th44QJAeFCvHq9MTP3onlc9nqPD8RIo=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b352355a1so884873f8f.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 02:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764843798; x=1765448598; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EF1MlHpf4n5Q1St5clq56+r8fU1ZS9gsCdCeRZ6mpDg=;
        b=IE+tPaYCLE+kdkiZ1tMu25iUUQKtWkBbf4YYDMHjE0gFjJGt/pfKYf21aIF0JAODKP
         qI2yVHutX255usi2n4ykG7Mk+Bw5SeuIyWlGlB5DMREPPeCATk0xll2fEgHGUS6S85p6
         9Gdt2d7X1h71s2TMV3WeHShR6QfYXONh6xDt0GdNTqIblu07uebN6D6EVq0gGSd2I+fo
         2qo22yDOjPcQworp/Wuc5vzZCFwFAtZcqoe6ckvopsF29rSL9+mLga2zgfzxTnVPXA8M
         I6mP0mFWyoJ5dcwZ4K8pPo1mA61A5IPqzszCEqeouOsPsWJEZXwLMc8+pRNpDn3r5Emk
         Y0rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764843798; x=1765448598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EF1MlHpf4n5Q1St5clq56+r8fU1ZS9gsCdCeRZ6mpDg=;
        b=MAgPuuvsmkahumN4Jj10yYF/Q+eraaWivtCjAs0ZmAiLySVnCxkJUvq6upeuYHrizC
         IVLKBpdtx5/NViGu9+HDuyG0Dgj4arPYRBjxS8wu0GRHBaOzT9qLZcRXJUP6h9iXDcmv
         kJQ2iY+YwwdfHCaMqqzFNMnoOUQAqR0BTpDMzwEKalRMCBdT5G6ZE5WleK7nZPYOclan
         hdlr36gSQynn2m/VudvSSZkAnZYg8MN4tl3inzhoZH0YJCJRmbnABECi7c73j4B5KhOC
         4uh4d9JUvYmpDIRZ4eNUOeA9yR6cK+uQ71LLdz0DqQhzpFdxRvnGJA+vByOiRLd3od92
         BXMQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7wmFhJ6lWRD7MpRDFSPo8xLbfqRqBrQ2rr9mkk7cj8iRHvsiivuySiz/CWB2hm/uS58WjzgAbYw==@kvack.org
X-Gm-Message-State: AOJu0Yy8m3W281H8+wEHm8bGweTc5Ua515K0x8nCnabJSy0YEAxyzrFV
	FoSTPfbEY5UA99svm2+hiPMsS6Pcp7tMV1nW0CyfKkyzcqUrIpJcsSB3GYN/jWZ5mlayU+hawSl
	QHjtO7uSwcB5IPZ1xKg==
X-Google-Smtp-Source: AGHT+IGiPJgDCk6zUebYl8jptLh9N24hkpO6kzd49VGJaKt6mNBrX4BGA0A2hAQXhvOeEcEPmbx50VOSkvAylEw=
X-Received: from wrmg8.prod.google.com ([2002:adf:e408:0:b0:42c:c2d6:28e])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:2f97:b0:477:9a61:fd06 with SMTP id 5b1f17b1804b1-4792eb1a02emr19061445e9.8.1764843798611;
 Thu, 04 Dec 2025 02:23:18 -0800 (PST)
Date: Thu, 4 Dec 2025 10:23:17 +0000
In-Reply-To: <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
Mime-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com> <20251204100725.GF2528459@noisy.programming.kicks-ass.net>
Message-ID: <aTFhFXCqvy7nmDOp@google.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
From: Alice Ryhl <aliceryhl@google.com>
To: Peter Zijlstra <peterz@infradead.org>, Josh Triplett <josh@joshtriplett.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1697C10000A
X-Rspamd-Server: rspam11
X-Stat-Signature: 4rjdebjfjr3w8cahtngf5ncjckh1di9c
X-HE-Tag: 1764843799-251546
X-HE-Meta: U2FsdGVkX1/Rj4QYp8/qAecWYTaEjOeI/j4g3Kiku/x+cKNkStIeUKdS25Z+siGuN0C+ws0pPjmmKI8kF5SsRhyLzHeWWOLBLuY0dcdMDWxoW3pEY+E6sPXMkpemU/yFz0eL5cHzrXFgiDepy/jCAdyS2rTpapbxkBiIqp78vOPojbHulDrdqyofTnwrtmzJSRxLXICfImu0jy4rcQuQlptSAZo7CQ58vpMvawnlDph3Lk1FXvxCFjgqVRcrAwJkLyy0hHk28lbOW2z/4F6lvrUoYaDw2U8hhBKtpm41Uy/TT1Iclx/6Z44R8sgL9hJuUg8qjvSXAjbAUP+/id1H5Hdj0NR+VikgkKEwSzFV3/4wNkruNgqVhAtM82o/7NL2qQGTukkXR8mGHo5i56xKv8/2dO5b2dUc000Oq6bBqOtzDbfqfOelXRUeAOC7kA9RBATxTHAyEy/tXpgcrAZ9XW8hZK/D5yCSLH2bmdgzUMNM0ZCQA90m/H6PSuEPyabUwLWjyYkR+aCXfC5aAdnXt6y6viq2SOlCHw2HuXwThHJF5TJWgG3n9G/Biq2nmWoJpGPmTl98dZ6fkoIRMA9jLTKc341y9um0AvsgQAZ8P3DGBsbk17BsM5X07vLnlRUL/pHMMsNb6iB4pf+N6cvyQUnkrWVztuBwIYNzeglbWPEanwBbhxha675jO240dRqnBp+XLA4u9H2E1iPVYVHlg/dhV1FXaRHM4P0km+tNGtHhr8sWxIXPP9U4j0blvVp/dPbrPJSV/zN+lXbe1CJMu+CvGjj+NP+TXYMWR5YZsKp/Hr0jYMv2pJ7uSfaCMqTkIP23xOjV/NbYwGUgEKcelnQm5chDr+F6RjN7BA1Ngh3yNUtVS+Q+bqjX4gvgG58SA5QHUx5JbZYj7KVwfvx9DrY7Flwkar6CBv4CUc2zFN6GlBB4bRNdmbHgfHtSoOEfYNi+7tQA18eLmR5hxUs
 t2HDFTFe
 8scoDtqBB0qOfv04dmOg5OP9GtSckCUeOA0HSf7VW9zdN9RtPWC9kmaQ1Up8sRkPcTWKI6GmvT3R8NHPiN45FSLM9ec2TcAjLxOY7LJTBeK6OSYiqjOfmUXb5juTMYdN31CHoiOb9w7r0v7FllyohLhFf3EssiYeEpmdrB+hYeOd6A2BG8srrE5Kg+2/Wa3KlJQfkMCNQ6mRPNSIU3DbzitYMYU19qkXNLuBwDZDawS/BKRZrcGOMMBeFSkJzpFstPVg1nL5G46gmD/0fT6ClYfmL0+bqSntlaaek2mlCrMo1R6D8NNnkgP/N2mgQFjlQtPtQDQ4y5mdK4BTuH08EbAtKUMNf9YM3FDzMtppKIdOjBiG6xA7AovGvIZoEFCadocvD3JvKqcnmZ4pInXuY0u9bZHrpZMr4TsgEBj0+zGreQmUEFdVRCOzQknN6sy89N4oi+L6P2Jt2O1VAmCuRynfjdSUndTpIQ4fmbkC0b0NAY4F/5x/rwnNRPQ27SRr+pN4YwDQzPbFs/HfwXye2ltPpAPo4t9t4xiDxluFXbsDLEUNGD/Khl3TLOXVXMCl8MydWXhgepE1unGqVo5wIf2MpaRZjdEHQFfetmmfBfaKxzmNv37JsY8FQ5eCZfyVtO+KnKKtbMKi/NFXG3NkhFdn9olDZWRUzy9Aci3MQXzkmURv/7PiyMDeMR+dmoYuBHMrK3Nb+1QSn14djPd36JV9Yt/rNC89X4K3jlVu3k/fiDE2/ZPHhZGhorgqjkOzXVfuVvNkYNgiQ0qy+KrW7+jKdGN603qBJuEBiOSSnqrf1UvVfmZiSLqvjtFzCWKPBpNhXpViqswC0p/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04, 2025 at 11:07:25AM +0100, Peter Zijlstra wrote:
> On Tue, Dec 02, 2025 at 08:27:59PM +0000, Alice Ryhl wrote:
> > From: Gary Guo <gary@garyguo.net>
> > 
> > A new experimental Kconfig option, `RUST_INLINE_HELPERS` is added to
> > allow C helpers (which were created to allow Rust to call into
> > inline/macro C functions without having to re-implement the logic in
> > Rust) to be inlined into Rust crates without performing global LTO.
> > 
> > If the option is enabled, the following is performed:
> > * For helpers, instead of compiling them to an object file to be linked
> >   into vmlinux, they're compiled to LLVM IR.
> > * The LLVM IR is compiled to bitcode (This is step is not necessary, but
> >   is a performance optimisation to prevent LLVM from always have to
> >   reparse the same IR).
> > * When a Rust crate is compiled, instead of generating an object file, we
> >   ask LLVM bitcode to be generated.
> > * llvm-link is invoked with --internalize to combine the helper bitcode
> >   with the crate bitcode. This step is similar to LTO, but this is much
> >   faster since it only needs to inline the helpers.
> > * clang is invoked to turn the combined bitcode into a final object file.
> > 
> > The --internalize flag tells llvm-link to treat all symbols in
> > helpers.bc using `internal` linkage. This matches the behavior of
> > `clang` on `static inline` functions, and avoids exporting the symbol
> > from the object file.
> > 
> > To ensure that RUST_INLINE_HELPERS is not incompatible with BTF, we pass
> > the -g0 flag when building helpers. See commit 5daa0c35a1f0 ("rust:
> > Disallow BTF generation with Rust + LTO") for details.
> > 
> > We have an intended triple mismatch of `aarch64-unknown-none` vs
> > `aarch64-unknown-linux-gnu`, so we suppress the warning.
> 
> So if I understand this correctly, it will consume the helpers twice,
> once for bindgen to generate the rust ffi glue, and then a second time
> to 'compile' to IR.
> 
> Then the IR is 'linked' into the rust translation units allowing the
> actual inlining to take place once 'LTO' runs.
> 
> And while this works, this still has the downside of requiring those
> rust helper files and using bindgen.

That's right.

> The other day [*] I proposed extending Rust such that it would be able
> to consume a clang precompiled header directly, this would allow doing
> away with most of all this. No more helpers and no more bindgen.
> 
> Would that not be a much saner approach to all this?
> 
> [*] https://lkml.kernel.org/r/20251124163315.GL4068168@noisy.programming.kicks-ass.net

I have actually discussed similar ideas in the past with Josh Triplett,
so you are not the only one who thinks it is a good idea. Unfortunately,
the road to get there is long.

Another option to get rid of the helpers is that bindgen is working on a
--wrap-static-fns flag, which would generate the helpers for us.
However, that route would still require this patch for them to be
inlined.

One detail that makes the precompiled clang header really tricky is
that IMO we should not require RUSTC_CLANG_LLVM_COMPATIBLE for the
build. With bindgen, you just need bindgen and clang to match LLVMs.
That's easy since bindgen loads a dylib from your clang install. But if
you build this logic into rustc, then you need to be really careful to
get rustc and clang from the same source, and that same source must use
the same LLVM to build both.

Alice

