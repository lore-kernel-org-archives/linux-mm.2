Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACD12D1D89F
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 09:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35726B0012; Thu,  4 Dec 2025 04:46:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0CF66B0023; Thu,  4 Dec 2025 04:46:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E026D6B0024; Thu,  4 Dec 2025 04:46:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CECAB6B0012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 04:46:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0BE4140933
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:46:07 +0000 (UTC)
X-FDA: 84181307574.15.6910F00
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id D0829C0004
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:46:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fMpnDXZU;
	spf=pass (imf22.hostedemail.com: domain of 3XFgxaQkKCCM9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3XFgxaQkKCCM9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764841565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Y+LEByl2j3nWQKuuz9R99dq4dapViIO+66bH6orc1c=;
	b=EZwrqGtwoFYMgk5X9M9+voWkIdlojjScJ7pfYIyejQbhFfHuBDcvHz1rrB6MCChMY3YC7D
	c0oxhJszionv0f37k+sjV6TRkY9wgfrgh6zVglNWcICe5CJUHMea5o/VEtJ9jqwtOqXHvw
	Cs9xHRAsAvJuVREWdr0RhDfyd6xasaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764841566; a=rsa-sha256;
	cv=none;
	b=CiQnem/Rm/5zhxVijv+C63ux2/f7aLR/0s7uTAXumUbYmGkR12GXJE5UFVl4jAZnluB8Op
	Hx344kCqjzv55K7e2D/v7tBCV8T8ZfC7ZCz3oFghbGKVyW9b7vJ4zUARHVUqZkEvT8pTSK
	pebZx7FdfQzDn836OVAgGabNnrl8I6s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fMpnDXZU;
	spf=pass (imf22.hostedemail.com: domain of 3XFgxaQkKCCM9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3XFgxaQkKCCM9KHBDQXGKFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-641632b8825so636533a12.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 01:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764841564; x=1765446364; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7Y+LEByl2j3nWQKuuz9R99dq4dapViIO+66bH6orc1c=;
        b=fMpnDXZU4LergLns8sN6Uy3X5q6qhWgAxhuZcJt4kK0R++djaKnW6aej7QK55AecQa
         CImjzwL2oqOxlVdxuEJb/+I+LIEU5uyW/hcUWlAZIiMleGx3DhOqGHtlu4+mx9SKapmh
         OO2WAF0E4cOAnVDuBfHBqcY4A4LTZqrH41YS9nzkyxqXw2Oc4LtCoO5ZNa8qrVC5z/f5
         9GjypUnZVwAE5kqDdkWz9DGdtSy53/cZlsDuaLu8op3S45nI3AG5CgpRUpEFmrHX2VxK
         3OEOcQueJrQK2PElYENS8ADAlfHU4P/Y0zGzjAdXb2um9botsAXGAgCD4EKeeFy8IDo8
         W5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764841564; x=1765446364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Y+LEByl2j3nWQKuuz9R99dq4dapViIO+66bH6orc1c=;
        b=coepLnbNQEkJ8aQCwbB00bBiKmhtxhmz4zQnK8X/db+HLYzMsba1tEVnJF4nbZwxp5
         HksXE9ID6d2bRYot/PoctWsmWwYuI5O5BVS8D7QmbU4TPqpBp3ueYET5xIfJO6ypuZ6r
         ocusWMpf4UVDbqAq5Jp+7Fpp5i69KppQKUgwiI5ILFZTzdjPnqsNtsL2JgyRmP6bQBce
         9RNEAlyKsTfOHa4EtXSr2u/gQLsd8yPerSbP4c00Fk2bCIejYFA1Vsb7H58zcL0pFcp3
         smP5VNLfmlewOLoHvuNyp1vPuD6XT50Eh29mqVU3BAGOYUA1InPanVBFrLhIZ+xI4h3p
         NnhA==
X-Forwarded-Encrypted: i=1; AJvYcCWsb7sfkVL+puNQLDkOx6lCwQexR4OSgJ5VIFHfBHEpO9wKI9kbLSj1vl6ks5cw0wj/iFxDEVj0Cg==@kvack.org
X-Gm-Message-State: AOJu0Yz9T0nyPHvgS29cP87A9PSlm8d6I3lmANcwo56c1waraxMq3Pbx
	nyr7WSlZhGQOeb/kFhb9Ys6JD34nZGx5KY4OX096pDc+EsjK1Wzi4GNWhZg4h1nre4GY5Axk8p8
	oRzC+cvIsyZ2XICJb4Q==
X-Google-Smtp-Source: AGHT+IH+B9WzKRmSWzOuHrGLt1JUxDjhE9BQol+oE79eSw4Io68p4o5P8fUOkglayWG/HVrXi6i/Vno1TKnYch4=
X-Received: from edbig1.prod.google.com ([2002:a05:6402:4581:b0:62f:24aa:896a])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1e94:b0:640:c640:98c5 with SMTP id 4fb4d7f45d1cf-6479c4c441bmr5333397a12.34.1764841564163;
 Thu, 04 Dec 2025 01:46:04 -0800 (PST)
Date: Thu, 4 Dec 2025 09:46:03 +0000
In-Reply-To: <20251203212558.GB3060476@ax162>
Mime-Version: 1.0
References: <20251202-inline-helpers-v1-0-879dae33a66a@google.com>
 <20251202-inline-helpers-v1-4-879dae33a66a@google.com> <20251203212558.GB3060476@ax162>
Message-ID: <aTFYWyUE-ln5KrsX@google.com>
Subject: Re: [PATCH 4/4] build: rust: provide an option to inline C helpers
 into Rust
From: Alice Ryhl <aliceryhl@google.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Nicolas Schier <nicolas.schier@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	nouveau@lists.freedesktop.org, Matthew Maurer <mmaurer@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: D0829C0004
X-Stat-Signature: h14rbx5hj9xidzrkabmqqhfjs7rs7bza
X-HE-Tag: 1764841565-50547
X-HE-Meta: U2FsdGVkX19MK6HvjsAwC0ch6sFOA0rDNoqVvkGjhx4SFSMgsdiZJsoW3Vgsoe6sl1F8wgqa13ZJS8R6nQcVyehBLXhEObS7UV0kC8RW4i00niTF0I3R7S1+iSV1MwrjWhMVDoFpb2hZhTNWVMEFGJ8xgzb/i3PAeGPHeCPSu9IJ59wbkHF7Y7xpQdhOUYN1Ehw8l7my/PSPQ7beOwogaoW8kO/sZoHF2yjUskJ+BY/CcVwXXdSym3X+VBuJmq4Y6MRZbKW7UHU9kYrbT4TX9NHG00B0YaUfXWTReQ/HsqaG6ueWe2B3Y000KJtxhMlvvMgiZl6DRSvAJCsqoAxAj+A8HJ7sUCFyeQx3pzPN57lW7irK+SHDvWrJxPaAYVCTWB5LmTa/lm39UanDY+9y8/NnXuuR4Pc9wmsXZ+viQosXOrJc2E3pc3Pdp2JE3Et50FdwNNpXfKwrQMAcaFpo5/kdaOGvSf/9fp47UuGHygHqc0MNlez7FAhf+4Nx5tnGwUEKd58Kl2/QZWPsNVh7ZD7m6HHVRoxRcapBZAvLTxlBKSyILZSaj7I1atCF+X3ZituYg69UQJatYh1dYSl4g+k7GT72jxbKcyO3UmA0TZ0WwP7EbJBGs6TvWzzVRGSW3iAZH3TTVk/K+YYQAXuPTb4tF1lX7EZ56G7vpI7p7glPZC8hxiXohVysQDWj2KAhgVgYk28SB6SY2gQYnl98ieIyMcNn/maRSrQPK/A3/99P2swMRPMUWNl0VurcJKoZb0OhP85uYG6v5ndTYQLqbJOHPJH14ounAuP8Lej+TPo8VEWISFOi1KW8VDiwZcQosV8Mt8qFsnbsIvIPVUsk9qeH/Mt/r6avXUlISxYj881dKM8abKU1E1rLUQZ2O/bN+RKfFmo29U53ZNzLI1bboT6M2uTl9JPobOR2D/BRlcrgusoL2HaiWsLKYvNv2Vwr04GrJLCcERaGc5xUx5T
 vtPP8UxI
 XSL38EDQ/wPy0rQUeqhIQkPBpgXJ2FKchH60NI/G5jP0KmFYKAef7ACsHh3IMngYP93Lra/CKTpHo7/o2M0Yopld+tKTAgCEsShmtvUOoyvhEVaE7Cpc0xQiM8mMEAMLgAnmBXsq8yVL59NEyVrNfxt5xZYqNro1vxvT3GOVme4YZkruUQqw1RrObWL6aetuFNPgkdHsskzWK73g+OjVAcD/DjHCQlNlx2UTgbFh9sPzzHZm5n9/Kb4z2zSJ8BaYZ/JBAqxYi+YKGnd2E163RT7u2YfxhDPfpaLadQLJ8HODFv76mXgO0AG3pFx/DVmkPHzqUAGsOqr6hf8V0hn1w0ESxoqXNynXPY5kc+a2hRGO9XF6WBO3aWLTmLjhowAKLeiDiK02EwJBkJJYGMyF056vBTkgOxCq3sJHuh4FgfiX6Tct3VyqwW8m2T5YxYeRJDBVSke8cbz7zh//AbGu5kRoZik+DpZNr93Xja7PKu8/2Z7jEGQx/646CBH6KY8EhtBYxoI1bzMkDCF0+d+1ony7OuqDjp/Rn4OU+By4AHzgT+1qQg4qKDT7qIu2LVX7j0I/oS9o/fHYxq3LXiUIxChVXgH8/bKysP6wW55JLrdLk3N9Tyl14lD8CT/UQZJp9wfG+wwkXT+BgcVwvQFe7GoqR3YuQE+pWOY/WN+Mdxvi6YqeFAnM1pHAoA+t8rE4wnvF0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 02:25:58PM -0700, Nathan Chancellor wrote:
> Hi Alice,
> 
> On Tue, Dec 02, 2025 at 08:27:59PM +0000, Alice Ryhl wrote:
> ...
> > diff --git a/Makefile b/Makefile
> > index 96ddbaae7e12de71bcfabef4639de3a13a6e4815..5834bfd568548d1bee34b328dccce5d60f85526f 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -517,6 +517,8 @@ OBJCOPY		= $(LLVM_PREFIX)llvm-objcopy$(LLVM_SUFFIX)
> >  OBJDUMP		= $(LLVM_PREFIX)llvm-objdump$(LLVM_SUFFIX)
> >  READELF		= $(LLVM_PREFIX)llvm-readelf$(LLVM_SUFFIX)
> >  STRIP		= $(LLVM_PREFIX)llvm-strip$(LLVM_SUFFIX)
> > +LLVM_LINK	= $(LLVM_PREFIX)llvm-link$(LLVM_SUFFIX)
> > +LLVM_AS		= $(LLVM_PREFIX)llvm-as$(LLVM_SUFFIX)
> 
> Please keep the binutils alphabetized (i.e, put LLVM_LINK between AR and
> NM).
> 
> Other than that, this seems fine from a Kbuild perspective (but I did
> not look too hard).

Sure will reorder.

> >  else
> >  CC		= $(CROSS_COMPILE)gcc
> >  LD		= $(CROSS_COMPILE)ld
> > @@ -625,7 +627,7 @@ export RUSTC_BOOTSTRAP := 1
> >  export CLIPPY_CONF_DIR := $(srctree)
> >  
> >  export ARCH SRCARCH CONFIG_SHELL BASH HOSTCC KBUILD_HOSTCFLAGS CROSS_COMPILE LD CC HOSTPKG_CONFIG
> > -export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN
> > +export RUSTC RUSTDOC RUSTFMT RUSTC_OR_CLIPPY_QUIET RUSTC_OR_CLIPPY BINDGEN LLVM_LINK LLVM_AS
> >  export HOSTRUSTC KBUILD_HOSTRUSTFLAGS
> >  export CPP AR NM STRIP OBJCOPY OBJDUMP READELF PAHOLE RESOLVE_BTFIDS LEX YACC AWK INSTALLKERNEL
> >  export PERL PYTHON3 CHECK CHECKFLAGS MAKE UTS_MACHINE HOSTCXX
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index 3034e294d50df55c4003c5fa5df442f59e711bd8..e63c5eb57b049aff988419ccd12dfd99d59f5080 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -3427,6 +3427,21 @@ config RUST_KERNEL_DOCTESTS
> >  
> >  	  If unsure, say N.
> >  
> > +config RUST_INLINE_HELPERS
> > +    bool "Inline C helpers into Rust crates (EXPERIMENTAL)"
> > +    depends on RUST && RUSTC_CLANG_LLVM_COMPATIBLE
> > +    depends on EXPERT
> > +    help
> > +        Links C helpers into Rust crates through LLVM IR.
> > +
> > +        If this option is enabled, instead of generating object files directly,
> > +        rustc is asked to produce LLVM IR, which is then linked together with
> > +        the LLVM IR of C helpers, before object file is generated.
> > +
> > +        This requires a matching LLVM version for Clang and rustc.
> > +
> > +        If unsure, say N.
> > +
> 
> I am just curious, why would someone want (or not) to do this? This help
> text does not really indicate the point of the option, just what it
> does. Is it just the standard tradeoffs with inlining (potential
> improvements in performance due to better optimization opportunities
> versus text size increase and icache pressure) or something else?

Basically you probably want this on if you can enable it, but
RUSTC_CLANG_LLVM_COMPATIBLE is actually a pretty harsh requirement. If
you just install rustc and clang, it's likely they wont be sufficiently
compatible for LTO to take place.

I'll expand on this in the help text.

Alice

