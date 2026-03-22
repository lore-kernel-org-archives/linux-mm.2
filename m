Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B677FC72D8
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 19:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B239B6B0005; Sun, 22 Mar 2026 15:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFADE6B0088; Sun, 22 Mar 2026 15:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A116B6B0089; Sun, 22 Mar 2026 15:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 933876B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:22:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 469001B8BDC
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:22:20 +0000 (UTC)
X-FDA: 84574670040.27.92E93EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8C7E6A0002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 19:22:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFJL0HTl;
	spf=pass (imf25.hostedemail.com: domain of ojeda@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774207338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SiYymjyqLJQefau8a4gy6w/Vver9WdiGFOPB8YRefA8=;
	b=0LZJ31MUy8BJmnFvbJcw50bnj6v8BFTbJ7/ObnDXhboOkzrPVP97ZAAa7sL2bfQo81+CHZ
	iR3zSnHit+xg26FlnxsMAy4stb32ChjkbfMnqvSppofE5/6pjYNepNVG26oIh+rIgDIG6N
	IoJN+dToOJ9OeD6XGSL/VraX8A3mGJ8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFJL0HTl;
	spf=pass (imf25.hostedemail.com: domain of ojeda@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ojeda@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774207338; a=rsa-sha256;
	cv=none;
	b=4ex4qn/yyRL905/iuae0Ajik2Yq5pqp6mVdaj2sXTxZ2ccwxJL0pwGYGyYfkCj3TwrV6Rn
	y+a8asfTNqCUmRX+UQYyD1JzVus9ZoRbHEBq0bSTDaVXNk5PVP5DJryHlk5UL01A8ZPy5+
	ZwGR8+IphSQ4yY6ve5gPT4ZjsH0EKFI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AD89416B0;
	Sun, 22 Mar 2026 19:22:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192DCC19424;
	Sun, 22 Mar 2026 19:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774207336;
	bh=KE0Ehn2v53KTMI2yWR0Gn7GG8ek8iWJ5qKwd+6T9w6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFJL0HTlpz2kyveKolahrRLNphDakm+Q0lH8RMUli8M7xc1fwB7R2zBva4trgzUpd
	 lk8r9iTZ7RK9+n11jpBQXj1Y4rhWoaJvX51FBQNmMEQ4I19oTrOeT5zbF/kKWhqeho
	 6b4Aq0d6LPYr0Yw97mZL2MZRfOYyM+WWsosZrbssdYmQvnxj51nQJGuT66y6OcCvRw
	 hNpkBjyo9j85cWcwnilz/5/JIyry8guW3hTlC48UGLFpxvnc67sza+0l5xyMRo4/u6
	 2FI0aKfs+8mqtv6TmnabtUH0CdEYOwNh97gqsacWIR5/7UbfPNWxkFDoq3gmq13g2s
	 WMG4aJ4fhX7tQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	David Gow <david@davidgow.net>,
	Russell King <linux@armlinux.org.uk>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	aliceryhl@google.com
Cc: linux-um@lists.infradead.org,
	llvm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kbuild@vger.kernel.org,
	a.hindborg@kernel.org,
	acourbot@nvidia.com,
	akpm@linux-foundation.org,
	bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com,
	dakr@kernel.org,
	gary@garyguo.net,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lossin@kernel.org,
	mark.rutland@arm.com,
	mmaurer@google.com,
	nicolas.schier@linux.dev,
	ojeda@kernel.org,
	peterz@infradead.org,
	rust-for-linux@vger.kernel.org,
	tmgross@umich.edu,
	urezki@gmail.com,
	will@kernel.org
Subject: Re: [PATCH v2 0/3] Inline helpers into Rust without full LTO
Date: Sun, 22 Mar 2026 20:21:59 +0100
Message-ID: <20260322192159.88138-1-ojeda@kernel.org>
In-Reply-To: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
References: <20260203-inline-helpers-v2-0-beb8547a03c9@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8C7E6A0002
X-Stat-Signature: 7omzbeamot5syrz9fjjiy7xu3yfktcwj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774207338-507617
X-HE-Meta: U2FsdGVkX1+KJecCnr9MwDozDje9mWgjChKmSEoGeJRBSqfWkTEeHg8b3JO0DUT8fB3nMS0Payt1BsxHG633++Vr0D1gBnwr9272rzgfK3HEfwDZD7OPZqwOlwd49XSG0nuRFdMOO/syzauzLffCO4Ir7OvqEV6nHja+QNuV94bVFAzProMnOJxoxj32ZVGIz81mFg8VbWiw8CW2sHtFTFzZCD4lxj21Fcqj/whtWCIQAdFYuYz2M3Je3eEDaqr/epj4csHHEtETJBBhvDPK1OHSD/HgVbPYVRcoOaUvwZmwC4oO4n4XfZXDAfVpfTgDRC/07mV0BwC4vcXydu+PVuhI5u1z2j8h7PFqrvW7PBTSfX5B6k8JYLjt5DxtB8V0duxRgMSEnSkzifUeKR3DcUwwav+8iczSysf7WifjdvKcN9jYsuErNVjvvylp+h6PnsBXRHbCgFqD3qOpaKli4ZdC8lQu1gsMap1aOZXc+usdHRP5bjuQHxMFmpdt7p9tKuV1ImCIdRkzCsdOIZglZQ37svR+cmLmiPZkZgViMme6jhhUS8OhXQgtXGy7mXYiuMhEc4BxPzNJYP+8sC90WXBok08baJaInaWCcZfhLMOCdSS4r3iIsNeSfyTQtFP56+VZFk411YxnPl9iHSN7qXaUAPEC995oU3ISLkogbP0z8ev6ob01JDpp+JMvf/4Hf+S2F/Ub8qWKN+S3kRCIHS/P7FdzdjfZR7j17hd1B/9bNK/aI/7qt8lMzers3KEiq58oc0tXYdqkXwtEqE8qBtuKu6oHa11VywvUfI7isOd5fbv1PCLe4BNWspeIbsl3PbZ8VmIBcu/HIMrTyLfHNXglt3VFCX80SGadCmbYe6goyNLpVsZZcpG/kud9UUdBt3mVjZmQD41b94kTF/BarBCJ1KOc6z7QjSd8kB44W9pX2RAniLlc7CdXbz+MaKQJmeGBKdvrBmVyq8qiQT/
 YmSig6lx
 HJcYogpbhLDK8eURnJrsFzP3f7o+XJMAdE/7E9WJGGvEpwSTR9DHW2iSyA6GcFkWyTgpKMV7l0NMw3+wmC6aTdcZ8/nCopVqV/nXNLONRURzKA43BE7QKI/WxheC2lShY8Z7BSkLeySSRsVCuNDU216baGetALJM0uzxrB0atZceIrzGzS5eHZ+Nnb84Gbsl/8cS+2pytIaYLbszTBMUIvH252kNcVGWudpzJL2Lm+YOz3OfUVrT06P98HzdrKBvDJwYOnedTZCIZsMand3kHu27s0Y4MbhyLgzQ9s2DbZHyCT0KF7eFzVGPIfbdLoReQBhGRbFAq4YPpl7IpjVo9ZS2BFBqO64dKd1Mb8y2pJw/5x1PO0srwCwvwZplUuF0ZfZ/p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 03 Feb 2026 11:34:07 +0000 Alice Ryhl <aliceryhl@google.com> wrote:
>
> To get rid of these helper symbols, provide functionality to inline
> helpers into Rust using llvm-link. This option complements full LTO, by
> being much cheaper and avoiding incompatibility with BTF.

I have been testing this. I think we can go ahead with it, with a few
notes.

I will reply to a couple other bindings in separate emails to avoid
spamming people too much.

  - I will mark the Kconfig option as "(EXPERIMENTAL)", since that is
    what the commit message says and it allows us to be a bit
    conservative.


  - Clang passes `-Werror=unused-command-line-argument`, which means
    under arm (i.e. 32-bit) we get:

      clang: error: argument unused during compilation: '-U arm' [-Werror,-Wunused-command-line-argument]

    And under UML I see:

      clang: error: argument unused during compilation: '-I ./arch/um/include/shared' [-Werror,-Wunused-command-line-argument]
      clang: error: argument unused during compilation: '-I ./arch/x86/um/shared' [-Werror,-Wunused-command-line-argument]
      clang: error: argument unused during compilation: '-I ./arch/um/include/shared/skas' [-Werror,-Wunused-command-line-argument]

    So we would need e.g. `-Wno-unused-command-line-argument` there
    close to the `-Wno-override-module` one, unless Kbuild or
    ClangBuiltLinux thinks it is important to keep it for this case.

    On the other hand, regardless of whether we fix this (and another
    issue in a separate email found thanks to the UML build), we could
    instead add `depends on` listing explicitly the architectures where
    this is going to be actually tested. That way maintainers can decide
    whether they want to support it when they are ready. Thoughts?

    Cc'ing Nathan, Nicolas, Nick, Bill, Justin, David, UML, ARM.


  - If we use the `.bc` extension, we need to add a `.gitignore` for
    `.bc` files, and an exception for `kernel/time/timeconst.bc`.

    I guess we will not have too many `bc` scripts in the future for
    that to be a problem. On the other hand, we have the chance to use
    another extension (either for LLVM bitcode or for `bc` scripts).

    But please let me know on e.g. the Kbuild side if someone has
    concerns...


  - Do we want to have the `cmd_ld_single` step even if the new mode is
    not enabled? i.e. we are gating the other steps, so we could gate
    that one too easily, no?

        -       $(cmd_ld_single) \
        +       $(if $(link_helper),$(cmd_ld_single)) \

        -       $(cmd_ld_single) \
        +       $(if $(CONFIG_RUST_INLINE_HELPERS),$(cmd_ld_single)) \

    I mean, it only affects `CONFIG_LTO_CLANG` configs, which are on
    their own experimental as far as I can see, so it is probably fine
    as it is, but still, while making things unconditional on the caller
    is good, it is also a behaviour change for configs outside the thing
    introduced here, so I am asking.

    (We could use something like a `is-rust-object` to do it on the
    definition side, but I would leave that for later.)

Thanks!

Cheers,
Miguel

